#!/usr/bin/env bash
#
# sync-rulesets.sh - sync the per-repo "main merge queue" ruleset to rulesets.yaml.
#
# Why repo-level: org rulesets need GitHub Team; this org is on Free, so
# `orgs/<org>/rulesets` returns 403. The same ruleset is created on each repo
# listed under `repos:` in rulesets.yaml instead.
#
# Modes:
#   --validate  Check yaml structure only (no GitHub calls).
#   --dry-run   Print per-repo status (OK / CREATE / UPDATE); exit 1 on drift.
#               Read-only.
#   --apply     Create / update the ruleset through the REST API. Needs admin
#               permission on each repo. NEVER deletes a ruleset.
#
# Only the ruleset named template.name is touched; other rulesets (for
# example "Require CI for release tags") are left alone. Repos under
# `pending` / `unsupported` are not touched.
#
# Requires: gh CLI authenticated, python3 (+ PyYAML).

set -euo pipefail

readonly ORG="ycpss91255-lab"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly REPO_ROOT
readonly YAML_FILE="${SYNC_RULESETS_YAML:-${REPO_ROOT}/rulesets.yaml}"

usage() {
  cat >&2 <<EOF
Usage: $(basename "$0") [--validate | --dry-run | --apply] [--repo <name>]

  --validate  Check rulesets.yaml structure only (no GitHub calls).
  --dry-run   Compare live rulesets with the yaml; exit 1 on drift or roster drift.
  --apply     Create / update rulesets (never deletes). Needs repo admin.
  --repo <n>  Restrict --dry-run / --apply to one repo (basename).
EOF
}

# py <mode> [args...]: helper around the yaml.
#   repos           -> one managed repo name per line
#   payload <repo>  -> ruleset JSON for the repo (API body)
#   normalize <json> -> comparable form of a live ruleset JSON (argument, since stdin carries the script)
#   expected <repo> -> comparable form of the yaml-built ruleset
#   name            -> ruleset name
#   roster          -> every repo name mentioned in repos/pending/unsupported
#   validate        -> structure check, exits non-zero on error
py() {
  python3 - "${YAML_FILE}" "$@" <<'PY'
import json, sys, yaml

sys.stdout.reconfigure(newline="\n")  # keep LF on Windows Python

path, mode, *rest = sys.argv[1:]
with open(path, encoding="utf-8") as f:
    doc = yaml.safe_load(f)

tpl = doc["template"]
MERGE_METHODS = {"MERGE", "SQUASH", "REBASE"}
ALLOWED = {"merge", "squash", "rebase"}

KEYS = {
    "merge_queue": {"merge_method", "max_entries_to_build", "min_entries_to_merge",
                    "max_entries_to_merge", "min_entries_to_merge_wait_minutes",
                    "grouping_strategy", "check_response_timeout_minutes"},
    "required_status_checks": {"strict_required_status_checks_policy",
                               "do_not_enforce_on_create", "required_status_checks"},
    "pull_request": {"required_approving_review_count", "dismiss_stale_reviews_on_push",
                     "require_code_owner_review", "require_last_push_approval",
                     "required_review_thread_resolution", "allowed_merge_methods"},
}


def build(repo):
    o = doc["repos"][repo]
    q = tpl["merge_queue"]
    iid = tpl["github_actions_integration_id"]
    return {
        "name": tpl["name"],
        "target": "branch",
        "enforcement": "active",
        "conditions": {"ref_name": {"include": [tpl["include_ref"]], "exclude": []}},
        "bypass_actors": [],
        "rules": [
            {"type": "deletion"},
            {"type": "non_fast_forward"},
            {"type": "merge_queue", "parameters": {
                "merge_method": o["merge_method"],
                "max_entries_to_build": q["max_entries_to_build"],
                "min_entries_to_merge": q["min_entries_to_merge"],
                "max_entries_to_merge": q["max_entries_to_merge"],
                "min_entries_to_merge_wait_minutes": q["min_entries_to_merge_wait_minutes"],
                "grouping_strategy": q["grouping_strategy"],
                "check_response_timeout_minutes": o.get("check_response_timeout_minutes",
                                                        q["check_response_timeout_minutes"]),
            }},
            {"type": "required_status_checks", "parameters": {
                "strict_required_status_checks_policy": True,
                "do_not_enforce_on_create": False,
                "required_status_checks": [
                    {"context": c, "integration_id": iid} for c in o["required_checks"]
                ],
            }},
            {"type": "pull_request", "parameters": {
                "required_approving_review_count": 0,
                "dismiss_stale_reviews_on_push": False,
                "require_code_owner_review": False,
                "require_last_push_approval": False,
                "required_review_thread_resolution": bool(o["review_thread_resolution"]),
                "allowed_merge_methods": o["allowed_merge_methods"],
            }},
        ],
    }


def normalize(rs):
    """Reduce a ruleset (payload or API response) to the fields we manage."""
    out = {"enforcement": rs.get("enforcement"), "target": rs.get("target"),
           "include": rs.get("conditions", {}).get("ref_name", {}).get("include"),
           "bypass": rs.get("bypass_actors") or [], "rules": {}}
    for r in rs.get("rules", []):
        p = r.get("parameters")
        if p:
            p = {k: v for k, v in p.items() if k in KEYS.get(r["type"], ())}
            if "required_status_checks" in p:
                p["required_status_checks"] = sorted(
                    p["required_status_checks"], key=lambda c: c["context"])
            if "allowed_merge_methods" in p:
                p["allowed_merge_methods"] = sorted(p["allowed_merge_methods"])
        out["rules"][r["type"]] = p
    return out


if mode == "repos":
    print("\n".join(doc["repos"]))
elif mode == "name":
    print(tpl["name"])
elif mode == "payload":
    print(json.dumps(build(rest[0])))
elif mode == "normalize":
    print(json.dumps(normalize(json.loads(rest[0])), sort_keys=True))
elif mode == "expected":
    print(json.dumps(normalize(build(rest[0])), sort_keys=True))
elif mode == "roster":
    names = []
    for k in ("repos", "pending", "unsupported"):
        names += list(doc.get(k) or {})
    print("\n".join(names))
elif mode == "validate":
    errs = []
    groups = [set(doc.get(k) or {}) for k in ("repos", "pending", "unsupported")]
    for i in range(3):
        for j in range(i + 1, 3):
            for n in sorted(groups[i] & groups[j]):
                errs.append(f"{n}: listed in more than one of repos/pending/unsupported")
    for n, o in (doc.get("repos") or {}).items():
        if o.get("merge_method") not in MERGE_METHODS:
            errs.append(f"{n}: merge_method must be one of {sorted(MERGE_METHODS)}")
        if not o.get("required_checks"):
            errs.append(f"{n}: required_checks must not be empty (queue needs a check)")
        am = set(o.get("allowed_merge_methods") or [])
        if not am or not am <= ALLOWED:
            errs.append(f"{n}: allowed_merge_methods must be a subset of {sorted(ALLOWED)}")
        elif str(o.get("merge_method", "")).lower() not in am:
            errs.append(f"{n}: merge_method {o.get('merge_method')} not in allowed_merge_methods")
        if "review_thread_resolution" not in o:
            errs.append(f"{n}: review_thread_resolution is required")
        if "check_response_timeout_minutes" in o:
            timeout = o["check_response_timeout_minutes"]
            if type(timeout) is not int:
                errs.append(f"{n}: check_response_timeout_minutes must be an integer")
            elif not 1 <= timeout <= 360:
                errs.append(f"{n}: check_response_timeout_minutes must be in the range 1..360")
    if errs:
        print("\n".join("ERROR: " + e for e in errs), file=sys.stderr)
        sys.exit(1)
else:
    sys.exit(f"unknown mode: {mode}")
PY
}

# Live ruleset id for <repo> by name; empty when absent.
live_id() {
  local repo="$1" name
  name="$(py name)"
  gh api "repos/${ORG}/${repo}/rulesets" \
    --jq ".[] | select(.name == \"${name}\") | .id"
}

# Roster drift: active org repos that appear nowhere in the yaml, and yaml
# names that are not in the org. Archived repos are ignored.
roster_drift() {
  local org_tmp yaml_tmp missing ghost result=0
  org_tmp="$(mktemp)"
  yaml_tmp="$(mktemp)"
  gh repo list "${ORG}" --limit 200 --no-archived --json name --jq '.[].name' \
    | sort -u >"${org_tmp}"
  py roster | sort -u >"${yaml_tmp}"
  missing="$(comm -23 "${org_tmp}" "${yaml_tmp}")"
  ghost="$(comm -13 "${org_tmp}" "${yaml_tmp}")"
  rm -f "${org_tmp}" "${yaml_tmp}"
  if [[ -n "${missing}" ]]; then
    echo "Repos in org but not in rulesets.yaml (add to repos / pending / unsupported):"
    while IFS= read -r r; do echo "  + ${r}"; done <<<"${missing}"
    result=1
  fi
  if [[ -n "${ghost}" ]]; then
    echo "Repos in rulesets.yaml but not an active org repo (typo, deleted or archived?):"
    while IFS= read -r r; do echo "  - ${r}"; done <<<"${ghost}"
    result=1
  fi
  return "${result}"
}

# Prints "<repo>\tOK|CREATE|UPDATE\t<id>" for each managed repo.
compute_status() {
  local filter="${1:-}" repo id live want
  while IFS= read -r repo; do
    if [[ -n "${filter}" && "${repo}" != "${filter}" ]]; then continue; fi
    id="$(live_id "${repo}")"
    if [[ -z "${id}" ]]; then
      printf '%s\tCREATE\t\n' "${repo}"
      continue
    fi
    live="$(py normalize "$(gh api "repos/${ORG}/${repo}/rulesets/${id}")")"
    want="$(py expected "${repo}")"
    if [[ "${live}" == "${want}" ]]; then
      printf '%s\tOK\t%s\n' "${repo}" "${id}"
    else
      printf '%s\tUPDATE\t%s\n' "${repo}" "${id}"
    fi
  done < <(py repos)
}

apply_status() {
  local lines="$1" repo action id
  while IFS=$'\t' read -r repo action id; do
    case "${action}" in
      CREATE)
        echo "  + ${repo}: create"
        py payload "${repo}" | gh api -X POST "repos/${ORG}/${repo}/rulesets" --input - >/dev/null
        ;;
      UPDATE)
        echo "  ~ ${repo}: update ruleset ${id}"
        py payload "${repo}" | gh api -X PUT "repos/${ORG}/${repo}/rulesets/${id}" --input - >/dev/null
        ;;
    esac
  done <<<"${lines}"
}

main() {
  local mode="" filter=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --validate) mode="validate"; shift ;;
      --dry-run)  mode="dry-run"; shift ;;
      --apply)    mode="apply"; shift ;;
      --repo)     filter="${2:?--repo needs a name}"; shift 2 ;;
      -h|--help)  usage; exit 0 ;;
      *)          echo "unknown arg: $1" >&2; usage; exit 2 ;;
    esac
  done
  if [[ -z "${mode}" ]]; then usage; exit 2; fi
  if [[ ! -f "${YAML_FILE}" ]]; then
    echo "rulesets.yaml not found at ${YAML_FILE}" >&2
    exit 2
  fi

  py validate
  if [[ "${mode}" == "validate" ]]; then
    echo "rulesets.yaml structure valid."
    return 0
  fi

  local roster_ok=0
  if [[ -z "${filter}" ]]; then
    roster_drift || roster_ok=1
  fi

  local status drift
  status="$(compute_status "${filter}")"
  drift="$(grep -v $'\tOK\t' <<<"${status}" || true)"
  case "${mode}" in
    dry-run)
      awk -F'\t' '{ printf "  %-24s %s\n", $1, $2 }' <<<"${status}"
      if [[ "${roster_ok}" -ne 0 || -n "${drift}" ]]; then exit 1; fi
      ;;
    apply)
      if [[ "${roster_ok}" -ne 0 ]]; then
        echo "Refusing to apply with unresolved roster drift; fix yaml first." >&2
        exit 1
      fi
      if [[ -z "${drift}" ]]; then echo "Nothing to apply."; return 0; fi
      apply_status "${drift}"
      ;;
  esac
}

main "$@"

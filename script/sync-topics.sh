#!/usr/bin/env bash
#
# sync-topics.sh - sync GitHub repository topics to topics.yaml.
#
# Reads topics.yaml at repo root, diffs each repo's actual topics
# against the target list, and either prints the diff (--dry-run) or
# applies it via `gh repo edit --add-topic / --remove-topic` (--apply).
# Also compares the org repo roster vs yaml.repos: a new repo created
# on GitHub but not added to yaml fails --dry-run on the next cron run.
#
# Intended runners:
#   - Local: `script/sync-topics.sh --apply` after merging a yaml change.
#   - CI:    `script/sync-topics.sh --dry-run` from the weekly cron;
#            non-zero exit = drift, fails the check.
#
# Requires: gh CLI authenticated, python3 (for yaml parse), jq.

set -euo pipefail

readonly ORG="ycpss91255-docker"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly REPO_ROOT
readonly YAML_FILE="${REPO_ROOT}/topics.yaml"

usage() {
  cat >&2 <<EOF
Usage: $(basename "$0") [--validate | --dry-run | --apply] [--repo <name>]

Modes:
  --validate  Check yaml structure only (no GitHub calls). Exits 0 if every
              topic in repos.* appears in allowed.*, 1 otherwise. Used by
              the lint job in CI.
  --dry-run   Print diff between yaml and live; exit 1 if drift detected.
  --apply     Apply yaml to live via gh repo edit. Implies confirmation.

Filter:
  --repo <name>   Restrict --dry-run / --apply to this single repo
                  (basename, not org/repo). Ignored by --validate.

Reads topics.yaml from the repo root. The yaml is the single source of
truth — never edit topics directly on GitHub.
EOF
}

# Parse yaml into two streams via python:
#   - allowed.tsv: one allowed topic per line
#   - target.tsv:  one "<repo>\t<topic>" per line, target topics in order
parse_yaml() {
  python3 - "${YAML_FILE}" "$@" <<'PY'
import sys, yaml

yaml_path, mode, *_ = sys.argv[1:]
with open(yaml_path) as f:
    doc = yaml.safe_load(f)

if mode == "allowed":
    for group in doc["allowed"].values():
        for name in group:
            print(name)
elif mode == "repos":
    for repo, topics in doc["repos"].items():
        for topic in topics:
            print(f"{repo}\t{topic}")
else:
    sys.exit(f"unknown mode: {mode}")
PY
}

# Validate: every topic in repos.* must appear in allowed.*
validate_yaml() {
  local allowed_tmp targets_tmp unknown result=0
  allowed_tmp="$(mktemp)"
  targets_tmp="$(mktemp)"

  parse_yaml allowed >"${allowed_tmp}"
  parse_yaml repos | awk -F'\t' '{print $2}' | sort -u >"${targets_tmp}"

  unknown="$(comm -23 "${targets_tmp}" <(sort -u "${allowed_tmp}"))"
  if [[ -n "${unknown}" ]]; then
    echo "ERROR: topics used in repos.* but not in allowed.*:" >&2
    while IFS= read -r line; do
      echo "  - ${line}" >&2
    done <<< "${unknown}"
    result=1
  fi

  rm -f "${allowed_tmp}" "${targets_tmp}"
  return "${result}"
}

# Fetch live topics for one repo. Empty list -> empty output.
live_topics() {
  local repo="$1"
  gh repo view "${ORG}/${repo}" --json repositoryTopics \
    --jq '.repositoryTopics[].name' 2>/dev/null | sort -u
}

# Compare org repo roster against yaml.repos. Catches:
#   - new repos added on GitHub but not yet listed in yaml ("missing")
#   - yaml entries for repos that no longer exist on GitHub ("ghost")
# Skipped when --repo filter is active (only relevant when iterating all).
# Prints human-readable drift; returns 1 if any drift found, 0 otherwise.
roster_drift() {
  local org_tmp yaml_tmp missing ghost result=0
  org_tmp="$(mktemp)"
  yaml_tmp="$(mktemp)"
  gh repo list "${ORG}" --limit 200 --json name --jq '.[].name' \
    | sort -u >"${org_tmp}"
  parse_yaml repos | awk -F'\t' '{print $1}' | sort -u >"${yaml_tmp}"

  missing="$(comm -23 "${org_tmp}" "${yaml_tmp}")"
  ghost="$(comm -13 "${org_tmp}" "${yaml_tmp}")"
  rm -f "${org_tmp}" "${yaml_tmp}"

  if [[ -n "${missing}" ]]; then
    echo "Repos in org but not in topics.yaml (add to repos.*):"
    while IFS= read -r r; do echo "  + ${r}"; done <<< "${missing}"
    result=1
  fi
  if [[ -n "${ghost}" ]]; then
    echo "Repos in topics.yaml but not in org (typo or deleted?):"
    while IFS= read -r r; do echo "  - ${r}"; done <<< "${ghost}"
    result=1
  fi
  return "${result}"
}

# Diff target vs live. Emits two lines per repo when drift exists:
#   <repo>\tADD\t<comma-sep>
#   <repo>\tREMOVE\t<comma-sep>
# Empty add/remove sides are skipped.
compute_diff() {
  local filter_repo="${1:-}"
  local repo target_tmp live_tmp add remove

  parse_yaml repos | awk -F'\t' '{print $1}' | sort -u | while read -r repo; do
    if [[ -n "${filter_repo}" && "${repo}" != "${filter_repo}" ]]; then
      continue
    fi
    target_tmp="$(mktemp)"
    live_tmp="$(mktemp)"
    parse_yaml repos | awk -F'\t' -v r="${repo}" '$1==r {print $2}' \
      | sort -u >"${target_tmp}"
    live_topics "${repo}" >"${live_tmp}"
    add="$(comm -23 "${target_tmp}" "${live_tmp}" | paste -sd, -)"
    remove="$(comm -13 "${target_tmp}" "${live_tmp}" | paste -sd, -)"
    [[ -n "${add}" ]] && printf '%s\tADD\t%s\n' "${repo}" "${add}"
    [[ -n "${remove}" ]] && printf '%s\tREMOVE\t%s\n' "${repo}" "${remove}"
    rm -f "${target_tmp}" "${live_tmp}"
  done
}

print_diff() {
  local diff_lines="$1"
  if [[ -z "${diff_lines}" ]]; then
    echo "All repos in sync with topics.yaml."
    return 0
  fi
  echo "Drift detected:"
  echo "${diff_lines}" | awk -F'\t' '{
    printf "  %-20s %-7s %s\n", $1, $2, $3
  }'
}

apply_diff() {
  local diff_lines="$1"
  if [[ -z "${diff_lines}" ]]; then
    echo "Nothing to apply."
    return 0
  fi
  echo "${diff_lines}" | while IFS=$'\t' read -r repo action topics; do
    case "${action}" in
      ADD)
        echo "  + ${repo}: add ${topics}"
        gh repo edit "${ORG}/${repo}" --add-topic "${topics}"
        ;;
      REMOVE)
        echo "  - ${repo}: remove ${topics}"
        gh repo edit "${ORG}/${repo}" --remove-topic "${topics}"
        ;;
    esac
  done
}

main() {
  local mode="" filter_repo=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --validate) mode="validate"; shift ;;
      --dry-run)  mode="dry-run"; shift ;;
      --apply)    mode="apply"; shift ;;
      --repo)     filter_repo="$2"; shift 2 ;;
      -h|--help)  usage; exit 0 ;;
      *)          echo "unknown arg: $1" >&2; usage; exit 2 ;;
    esac
  done
  if [[ -z "${mode}" ]]; then
    usage
    exit 2
  fi

  if [[ ! -f "${YAML_FILE}" ]]; then
    echo "topics.yaml not found at ${YAML_FILE}" >&2
    exit 2
  fi

  validate_yaml

  if [[ "${mode}" == "validate" ]]; then
    echo "topics.yaml structure valid."
    return 0
  fi

  # Roster drift only relevant when scanning everything; --repo focuses on
  # one named repo and the user already knows it exists.
  local roster_ok=0
  if [[ -z "${filter_repo}" ]]; then
    roster_drift || roster_ok=1
  fi

  local diff_lines
  diff_lines="$(compute_diff "${filter_repo}")"
  case "${mode}" in
    dry-run)
      print_diff "${diff_lines}"
      if [[ "${roster_ok}" -ne 0 || -n "${diff_lines}" ]]; then
        exit 1
      fi
      ;;
    apply)
      if [[ "${roster_ok}" -ne 0 ]]; then
        echo "Refusing to apply with unresolved roster drift; fix yaml first." >&2
        exit 1
      fi
      apply_diff "${diff_lines}"
      ;;
  esac
}

main "$@"

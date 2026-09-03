#!/usr/bin/env bash
#
# sync-labels.sh - sync GitHub repository labels to labels.yaml.
#
# Reads labels.yaml at repo root, diffs the managed labels of every org
# repo against it, and either prints the diff (--dry-run) or applies it
# via `gh label create / gh label edit` (--apply). Only the labels named
# in labels.yaml are ever touched: unmanaged labels (GitHub's stock set,
# Dependabot's `dependencies` / `github_actions`, per-repo one-offs) are
# left alone, and nothing is ever deleted.
#
# Intended runners:
#   - Local: `script/sync-labels.sh --apply` after merging a yaml change.
#   - CI:    `script/sync-labels.sh --dry-run` from the weekly cron;
#            non-zero exit = drift, fails the check.
#
# Requires: gh CLI authenticated, python3 (for yaml parse).

set -euo pipefail

readonly ORG="ycpss91255-docker"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly REPO_ROOT
readonly YAML_FILE="${REPO_ROOT}/labels.yaml"

usage() {
  cat >&2 <<EOF
Usage: $(basename "$0") [--validate | --dry-run | --apply] [--repo <name>]

Modes:
  --validate  Check yaml structure only (no GitHub calls). Exits 0 if every
              entry under labels: has a non-empty name, a 6-digit hex colour
              and a non-empty description, and names are unique; 1 otherwise.
              Used by the lint job in CI.
  --dry-run   Print diff between yaml and live; exit 1 if drift detected.
  --apply     Apply yaml to live via gh label create / gh label edit.

Filter:
  --repo <name>   Restrict --dry-run / --apply to this single repo
                  (basename, not org/repo). Ignored by --validate.

Reads labels.yaml from the repo root. The yaml is the single source of
truth — never edit the managed labels directly on GitHub. Labels absent
from the yaml are never created, edited or deleted.
EOF
}

# Parse yaml into one stream via python:
#   - labels.tsv: one "<name>\t<colour>\t<description>" per line, file order
# Mode "validate" prints nothing and exits 1 with a reason on stderr when
# the structure is malformed.
parse_yaml() {
  python3 - "${YAML_FILE}" "$@" <<'PY'
import re
import sys
import yaml

yaml_path, mode, *_ = sys.argv[1:]
with open(yaml_path) as f:
    doc = yaml.safe_load(f)

errors = []
entries = []

if not isinstance(doc, dict) or not isinstance(doc.get("labels"), list) \
        or not doc["labels"]:
    errors.append("top level must be a mapping with a non-empty `labels:` list")
else:
    seen = set()
    for index, entry in enumerate(doc["labels"]):
        where = f"labels[{index}]"
        if not isinstance(entry, dict):
            errors.append(f"{where}: must be a mapping")
            continue
        name = entry.get("name")
        color = entry.get("color")
        description = entry.get("description")
        if not isinstance(name, str) or not name.strip():
            errors.append(f"{where}: `name` must be a non-empty string")
            name = None
        elif name in seen:
            errors.append(f"{where}: duplicate label name `{name}`")
        else:
            seen.add(name)
        color = str(color) if color is not None else ""
        if not re.fullmatch(r"[0-9a-fA-F]{6}", color):
            errors.append(
                f"{where}: `color` must be 6 hex digits without `#`, got {color!r}"
            )
        if not isinstance(description, str) or not description.strip():
            errors.append(f"{where}: `description` must be a non-empty string")
            description = None
        for field, value in (("name", name), ("description", description)):
            if isinstance(value, str) and ("\t" in value or "\n" in value):
                errors.append(f"{where}: `{field}` must not contain a tab or newline")
        if name and description:
            entries.append((name, color, description))

if errors:
    print("ERROR: labels.yaml is malformed:", file=sys.stderr)
    for error in errors:
        print(f"  - {error}", file=sys.stderr)
    sys.exit(1)

if mode == "validate":
    pass
elif mode == "labels":
    for name, color, description in entries:
        print(f"{name}\t{color}\t{description}")
else:
    sys.exit(f"unknown mode: {mode}")
PY
}

# Validate: structure only, no GitHub calls. parse_yaml does the checking
# so --dry-run / --apply get it for free before touching the API.
validate_yaml() {
  parse_yaml validate
}

# Look up one field of a managed label by name. Field: 2 = colour,
# 3 = description.
label_field() {
  local name="$1" field="$2"
  parse_yaml labels \
    | awk -F'\t' -v n="${name}" -v f="${field}" '$1==n {print $f; exit}'
}

# Colours are case-insensitive hex and GitHub stores whatever case it was
# given, so compare normalised.
normalise_color() {
  tr '[:upper:]' '[:lower:]' <<< "${1#\#}"
}

# Fetch live labels for one repo as "<name>\t<colour>\t<description>".
# A repo with no description on a label yields an empty third field.
live_labels() {
  local repo="$1"
  gh label list -R "${ORG}/${repo}" --limit 200 \
    --json name,color,description \
    --jq '.[] | [.name, .color, (.description // "")] | @tsv'
}

# The org roster is the label roster: every repo gets the same managed
# set, so unlike topics.yaml there is no per-repo list to drift from.
org_repos() {
  gh repo list "${ORG}" --limit 200 --json name --jq '.[].name' | sort -u
}

# Diff managed labels vs live. Emits one line per drifted label:
#   <repo>\tCREATE\t<label>\t<reason>
#   <repo>\tUPDATE\t<label>\t<reason>
# Unmanaged labels are not inspected and never appear here.
compute_diff() {
  local filter_repo="${1:-}"
  local repo live_tmp name color description
  local live_line live_color live_description reason

  org_repos | while read -r repo; do
    if [[ -n "${filter_repo}" && "${repo}" != "${filter_repo}" ]]; then
      continue
    fi
    live_tmp="$(mktemp)"
    live_labels "${repo}" >"${live_tmp}"
    while IFS=$'\t' read -r name color description; do
      live_line="$(awk -F'\t' -v n="${name}" '$1==n {print; exit}' "${live_tmp}")"
      if [[ -z "${live_line}" ]]; then
        printf '%s\tCREATE\t%s\tmissing\n' "${repo}" "${name}"
        continue
      fi
      IFS=$'\t' read -r _ live_color live_description <<< "${live_line}"
      reason=""
      if [[ "$(normalise_color "${live_color}")" \
            != "$(normalise_color "${color}")" ]]; then
        reason="colour ${live_color} -> ${color}"
      fi
      if [[ "${live_description}" != "${description}" ]]; then
        [[ -n "${reason}" ]] && reason="${reason}; "
        reason="${reason}description \"${live_description}\" -> \"${description}\""
      fi
      [[ -n "${reason}" ]] && printf '%s\tUPDATE\t%s\t%s\n' \
        "${repo}" "${name}" "${reason}"
    done < <(parse_yaml labels)
    rm -f "${live_tmp}"
  done
}

print_diff() {
  local diff_lines="$1"
  if [[ -z "${diff_lines}" ]]; then
    echo "All repos in sync with labels.yaml."
    return 0
  fi
  echo "Drift detected:"
  echo "${diff_lines}" | awk -F'\t' '{
    printf "  %-20s %-7s %-16s %s\n", $1, $2, $3, $4
  }'
  echo "${diff_lines}" | awk -F'\t' '
    {repos[$1]; count++}
    END {printf "  (%d label(s) across %d repo(s))\n", count, length(repos)}
  '
}

apply_diff() {
  local diff_lines="$1"
  local color description
  if [[ -z "${diff_lines}" ]]; then
    echo "Nothing to apply."
    return 0
  fi
  echo "${diff_lines}" | while IFS=$'\t' read -r repo action name reason; do
    color="$(label_field "${name}" 2)"
    description="$(label_field "${name}" 3)"
    case "${action}" in
      CREATE)
        echo "  + ${repo}: create ${name} (${reason})"
        gh label create "${name}" -R "${ORG}/${repo}" \
          --color "${color}" --description "${description}"
        ;;
      UPDATE)
        echo "  ~ ${repo}: update ${name} (${reason})"
        gh label edit "${name}" -R "${ORG}/${repo}" \
          --color "${color}" --description "${description}"
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
    echo "labels.yaml not found at ${YAML_FILE}" >&2
    exit 2
  fi

  validate_yaml

  if [[ "${mode}" == "validate" ]]; then
    echo "labels.yaml structure valid."
    return 0
  fi

  local diff_lines
  diff_lines="$(compute_diff "${filter_repo}")"
  case "${mode}" in
    dry-run)
      print_diff "${diff_lines}"
      if [[ -n "${diff_lines}" ]]; then
        exit 1
      fi
      ;;
    apply)
      apply_diff "${diff_lines}"
      ;;
  esac
}

main "$@"

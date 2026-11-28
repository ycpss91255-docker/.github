#!/usr/bin/env bats

setup() {
  root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  script="$root/script/sync-rulesets.sh"
  export SYNC_RULESETS_YAML="$BATS_TEST_TMPDIR/rulesets.yaml"
  export GH_CALLS="$BATS_TEST_TMPDIR/calls"
  export GH_PAYLOAD="$BATS_TEST_TMPDIR/payload.json"
  export GH_RULESETS="$BATS_TEST_TMPDIR/live.json"
  endpoint="repos/ycpss91255-lab/isaac_lab/rulesets"
  echo '[{"id":42,"name":"release tags"}]' > "$GH_RULESETS"
  mkdir "$BATS_TEST_TMPDIR/bin"
  cat > "$BATS_TEST_TMPDIR/bin/gh" <<'SH'
#!/usr/bin/env bash
set -eu
endpoint="repos/ycpss91255-lab/isaac_lab/rulesets"
if [[ "$1 $2" == "repo list" ]]; then
  echo "GET orgs/$3/repos" >> "$GH_CALLS"
  echo isaac_lab
  exit 0
fi
[[ "$1" == api ]] || { echo "Unexpected gh call: $*" >> "$GH_CALLS"; exit 1; }
shift
method=GET
if [[ "$1" == -X ]]; then
  method="$2"
  shift 2
fi
path="$1"
shift
echo "$method $path" >> "$GH_CALLS"
case "$method $path" in
  "GET $endpoint")
    if [[ "${1:-}" == --jq ]]; then
      python3 -c 'import json, sys
for r in json.load(open(sys.argv[1])):
    if r["name"] == "main merge queue":
        print(r["id"])' "$GH_RULESETS"
    else
      cat "$GH_RULESETS"
    fi ;;
  "GET $endpoint/28220935")
    echo '{"id":28220935,"name":"main merge queue","enforcement":"disabled","rules":[]}' ;;
  "PUT $endpoint/28220935"|"POST $endpoint")
    [[ "$*" == "--input -" ]]
    cat > "$GH_PAYLOAD" ;;
  *) echo "Unexpected gh api call: $method $path" >&2; exit 1 ;;
esac
SH
  chmod +x "$BATS_TEST_TMPDIR/bin/gh"
  export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
  [[ "$(command -v gh)" == "$BATS_TEST_TMPDIR/bin/gh" ]]
}

write_fixture() {
  cat > "$SYNC_RULESETS_YAML" <<'YAML'
template:
  name: main merge queue
  include_ref: "~DEFAULT_BRANCH"
  github_actions_integration_id: 15368
  merge_queue:
    max_entries_to_build: 5
    min_entries_to_merge: 1
    max_entries_to_merge: 5
    min_entries_to_merge_wait_minutes: 5
    grouping_strategy: ALLGREEN
    check_response_timeout_minutes: 60
repos:
  isaac_lab:
    merge_method: MERGE
    required_checks: [gate]
    allowed_merge_methods: [merge]
    review_thread_resolution: true
YAML
  if [[ $# -gt 0 ]]; then
    printf '    check_response_timeout_minutes: %s\n' "$1" >> "$SYNC_RULESETS_YAML"
  fi
}

assert_timeout() {
  python3 - "$1" "$GH_PAYLOAD" <<'PY'
import json, sys
expected = int(sys.argv[1])
rules = json.load(open(sys.argv[2]))["rules"]
got = [r["parameters"]["check_response_timeout_minutes"] for r in rules if r["type"] == "merge_queue"]
sys.exit(0 if got == [expected] else 1)
PY
}

assert_invalid_timeout() {
  write_fixture "$1"
  run bash "$script" --validate
  [ "$status" -eq 1 ]
  [[ "$output" == *"ERROR: isaac_lab: check_response_timeout_minutes"* ]]
  [[ "$output" == *"$2"* ]]
}

@test "missing same-name ruleset is created with the template timeout of 60" {
  write_fixture
  bash "$script" --apply --repo isaac_lab
  diff -u - "$GH_CALLS" <<EOF
GET $endpoint
POST $endpoint
EOF
  assert_timeout 60
}

@test "existing same-name ruleset is updated by ID with the repo timeout of 240" {
  write_fixture 240
  cat > "$GH_RULESETS" <<'JSON'
[{"id":42,"name":"release tags"},{"id":28220935,"name":"main merge queue"}]
JSON
  bash "$script" --apply --repo isaac_lab
  diff -u - "$GH_CALLS" <<EOF
GET $endpoint
GET $endpoint/28220935
PUT $endpoint/28220935
EOF
  assert_timeout 240
}

@test "validate rejects a quoted timeout" {
  assert_invalid_timeout '"240"' integer
}

@test "validate rejects a boolean timeout" {
  assert_invalid_timeout true integer
}

@test "validate rejects a fractional timeout" {
  assert_invalid_timeout 1.5 integer
}

@test "validate rejects a timeout below 1" {
  assert_invalid_timeout 0 '1..360'
}

@test "validate rejects a timeout above 360" {
  assert_invalid_timeout 361 '1..360'
}

@test "validate accepts integer timeouts of 1, 240, and 360" {
  for timeout in 1 240 360; do
    write_fixture "$timeout"
    bash "$script" --validate
  done
}

@test "the repository manifest manages isaac_lab and isaac" {
  python3 - "$root/rulesets.yaml" <<'PY'
import sys
import yaml

with open(sys.argv[1], encoding="utf-8") as f:
    config = yaml.safe_load(f)
repo = config["repos"]["isaac_lab"]
assert repo["merge_method"] == "MERGE"
assert repo["required_checks"] == ["gate"]
assert repo["allowed_merge_methods"] == ["merge"]
assert repo["review_thread_resolution"] is True
assert repo["check_response_timeout_minutes"] == 240
assert "isaac_lab" not in config["pending"] and "isaac_lab" not in config["unsupported"]
isaac = config["repos"]["isaac"]
assert isaac["required_checks"] == ["gate"]
assert isaac["check_response_timeout_minutes"] == 240
assert "isaac" not in config["pending"] and "isaac" not in config["unsupported"]
PY
}

@test "base 只允許 merge commit" {
  python3 - "$root/rulesets.yaml" <<'PY'
import sys
import yaml

with open(sys.argv[1], encoding="utf-8") as f:
    config = yaml.safe_load(f)
methods = config["repos"]["base"]["allowed_merge_methods"]
assert methods == ["merge"], methods
PY
}

@test "同一個 repo 只能出現在一個分類" {
  python3 - "$root/rulesets.yaml" <<'PY'
import sys
import yaml

with open(sys.argv[1], encoding="utf-8") as f:
    config = yaml.safe_load(f)
seen = {}
for section in ("repos", "pending", "unsupported"):
    for repo in config[section]:
        name = repo.casefold()
        assert name not in seen, f"{repo} 同時出現在 {seen[name]} 和 {section}"
        seen[name] = section
PY
}

@test "新增的 repo 歸入指定分類，已封存的 repo 移出名單" {
  python3 - "$root/rulesets.yaml" <<'PY'
import sys
import yaml

with open(sys.argv[1], encoding="utf-8") as f:
    config = yaml.safe_load(f)
pending = {
    "Solidworks-MCP", "isaac-sim-webrtc-mediamtx", "nas_setup",
    "solidworks_urdf_exporter", "config_manager", "github_runner", "vendor_kit",
}
unsupported = {"arch_drawio", "ci_cluster", "test_level_demo"}
archived = {"ai_agent", "claude_code", "codex_cli", "gemini_cli"}
roster = set(config["repos"]) | set(config["pending"]) | set(config["unsupported"])
assert pending <= config["pending"].keys(), pending - config["pending"].keys()
assert unsupported <= config["unsupported"].keys(), unsupported - config["unsupported"].keys()
assert archived.isdisjoint(roster), archived & roster
PY
}

@test "seggpt 的 merge queue check timeout 為 180 分鐘" {
  python3 - "$root/rulesets.yaml" <<'PY'
import sys
import yaml

with open(sys.argv[1], encoding="utf-8") as f:
    config = yaml.safe_load(f)
assert config["repos"]["seggpt"]["check_response_timeout_minutes"] == 180
PY
}

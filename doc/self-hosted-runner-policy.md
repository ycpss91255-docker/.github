# Self-hosted runner policy

Decision record for issue #41 (owner decision, 2026-11-21). Related: #42 (runner group and approval settings), #49 (ARC kubernetes-mode compatibility).

## Decision

- **Accepted risk:** every org repo, public ones included, may use the self-hosted runners. Runner groups are not restricted to selected workflows, and self-hosted jobs are not forced through one shared workflow. Reason: no plan for it now, and one shared workflow becomes a problem as soon as repos diverge.
- **Hard gate:** the org setting "Require approval for all external contributors" for fork pull request workflows. Verify with `gh api orgs/<org>/actions/permissions/fork-pr-contributor-approval` (expected: `all_external_contributors`). Do not turn it down.
- **Template = reference only:** `workflow-templates/self-hosted-arc.yml` shows the runner class labels (`v1-cpu-s`, `v1-cpu-l`, `v1-gpu-chain`, `v1-gpu-long`), `container:` + `run:`, `services:` with `NVIDIA_VISIBLE_DEVICES: void`, CPU/GPU split with artifacts, and a fail-not-skip fork guard. Repos copy and adapt it; nothing enforces or syncs it.

## Rules for repos

- First step of every self-hosted job: the fork guard from the template. It fails the job (never `if:`-skips it, a skipped job counts as passing). It is defense in depth only: a fork PR can edit the workflow file and remove it.
- Never target self-hosted labels from `pull_request_target` or `workflow_run` (they run with secrets; `pull_request_target` ignores the approval policy).
- Jobs use `container:` + `run:`; no Docker daemon, no privileged containers, no `container.options`, non-root, no sudo.
- Pin third-party actions to full commit SHAs with a version comment. Use `${{ github.repository_owner }}`, not a hard-coded org name.
- Runner classes and sizes are owned by `ycpss91255-research/ci_cluster` (`doc/workflow-rules.md`).

`gpu-self-hosted.yml` callers move to their own job definitions based on the template once the new runners are ready (#49).

# 自架 runner 政策

issue #41 的決策紀錄（owner 決定，2026-11-21）。相關：#42（runner group 與審核設定）、#49（ARC kubernetes mode 相容性）。

## 決定

- **接受的風險**：org 內所有 repo（包含公開 repo）都可以使用自架 runner。runner group 不限制只能跑指定 workflow，自架工作也不強制透過單一共用 workflow。理由：目前沒有這個需求，而且 repo 一旦分歧，單一共用 workflow 就會變成問題。
- **硬防線**：org 設定 fork PR workflow「Require approval for all external contributors」。確認方式：`gh api orgs/<org>/actions/permissions/fork-pr-contributor-approval`，預期為 `all_external_contributors`。不可調低。
- **範本只是參考**：`workflow-templates/self-hosted-arc.yml` 示範 runner 類別標籤（`cpu-s`、`cpu-l`、`gpu-<model>`，透過 repo variable 設定）、`container:` + `run:`、帶 `NVIDIA_VISIBLE_DEVICES: void` 的 `services:`、以 artifact 分開 CPU／GPU 工作，以及失敗而非跳過的 fork 防護。各 repo 複製後自行調整，沒有任何機制強制或同步。

## Repo 須遵守

- 每個自架工作的第一步是範本中的 fork 防護。它讓工作失敗（不可用 `if:` 跳過，被跳過的工作算通過）。這只是縱深防禦：fork PR 可以修改 workflow 檔把它刪掉。
- `pull_request_target`、`workflow_run` 不可指向自架標籤（它們帶 secrets；`pull_request_target` 不受審核設定約束）。
- 工作使用 `container:` + `run:`；沒有 Docker daemon、不可特權容器、不可 `container.options`、非 root、沒有 sudo，不寫死 uid。
- 第三方 action 釘選完整 commit SHA 並註明版本。用 `${{ github.repository_owner }}`，不寫死 org 名稱。
- runner 類別名稱與規格由同一 org 的 `ci_cluster` repo 決定（`doc/workflow-rules.md`）；`arc-test-*` 是測試環境，不用於正式工作。

新 runner 就緒後，`gpu-self-hosted.yml` 的呼叫端改為依範本自行定義工作（#49）。

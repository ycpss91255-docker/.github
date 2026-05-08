**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

[![CI](https://github.com/ycpss91255-docker/.github/actions/workflows/check-topics.yaml/badge.svg)](https://github.com/ycpss91255-docker/.github/actions/workflows/check-topics.yaml) [![License](https://img.shields.io/badge/License-Apache--2.0-blue?style=flat-square)](https://github.com/ycpss91255-docker/.github/blob/main/LICENSE)

# ycpss91255-docker

ROS ロボット開発、AI Agent ツール、アプリケーションデプロイのための Docker コンテナ化環境。

---

### クイックスタート（任意の環境リポジトリ）

```bash
./build.sh && ./run.sh
```

### 選び方

2 つの環境リポジトリが ROS 1 と ROS 2 をそれぞれカバー。`BASE_IMAGE` バリアントで distro とイメージのフレーバーを選択：

- **ROS 1 vs ROS 2** → `ros_distro`（Noetic、Kinetic）vs `ros2_distro`（Humble、Jazzy、Iron）
- **`ros:` vs `osrf/ros:` バリアント** → `ros:` はマルチアーキ（x86_64 + ARM）の ros-base；`osrf/ros:` は x86_64 のみだが desktop-full（RViz、Gazebo）を含む

### トピックでフィルタ

GitHub トピックフィルタでカテゴリ別に閲覧：
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`agent`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:agent) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

---

## リポジトリ一覧

<details>
<summary><strong>環境 — 開発コンテナ</strong></summary>

各リポジトリは単一の Dockerfile で、`BASE_IMAGE` build arg により distro とイメージフレーバーを切り替えます。

| リポジトリ | ROS | ディストリビューション | バリアント |
|-----------|-----|----------------------|----------|
| [ros_distro](https://github.com/ycpss91255-docker/ros_distro) | ROS 1 | Noetic、Kinetic | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |
| [ros2_distro](https://github.com/ycpss91255-docker/ros2_distro) | ROS 2 | Humble、Jazzy、Iron | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |

> 旧来の単一 distro リポジトリ（`ros_noetic`、`ros_kinetic`、`ros2_humble`、`osrf_ros_noetic`、`osrf_ros_kinetic`、`osrf_ros2_humble`）はアーカイブ済みです。[`archived`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:archived) トピックで閲覧できます。

</details>

<details>
<summary><strong>AI Agent — 開発コンテナ</strong></summary>

| リポジトリ | AI ツール | 説明 |
|-----------|----------|------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD コンテナ、Claude Code + Gemini CLI + Codex CLI 同梱 |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD コンテナ、Anthropic Claude Code 同梱 |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD コンテナ、Google Gemini CLI 同梱 |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD コンテナ、OpenAI Codex CLI 同梱 |

</details>

<details>
<summary><strong>アプリケーション — デプロイコンテナ</strong></summary>

| リポジトリ | 説明 |
|-----------|------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1（Noetic）↔ ROS 2（Humble + Jazzy）ブリッジコンテナ；マルチアーキ（amd64 + arm64/Jetson） |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | ROS 2 Humble コンテナ化 Hokuyo URG LiDAR ドライバ |
| [urg_node_noetic](https://github.com/ycpss91255-docker/urg_node_noetic) | ROS 1 Noetic コンテナ化 Hokuyo URG LiDAR ドライバ |
| [realsense_humble](https://github.com/ycpss91255-docker/realsense_humble) | ROS 2 Humble コンテナ化 Intel RealSense ドライバ |
| [realsense_noetic](https://github.com/ycpss91255-docker/realsense_noetic) | ROS 1 Noetic コンテナ化 Intel RealSense ドライバ |
| [sick_humble](https://github.com/ycpss91255-docker/sick_humble) | ROS 2 Humble コンテナ化 SICK Safety Scanner ドライバ |
| [sick_noetic](https://github.com/ycpss91255-docker/sick_noetic) | ROS 1 Noetic コンテナ化 SICK Safety Scanner ドライバ |

</details>

<details>
<summary><strong>ツール</strong></summary>

| リポジトリ | 説明 |
|-----------|------|
| [template](https://github.com/ycpss91255-docker/template) | 共有テンプレート — スクリプト、テスト、CI workflows |
| [multi_run](https://github.com/ycpss91255-docker/multi_run) | 複数ワークスペースの Docker コンテナを同時起動 |

</details>

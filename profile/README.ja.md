**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

# ycpss91255-docker

ROS ロボット開発、AI Agent ツール、アプリケーションデプロイのための Docker コンテナ化環境。

---

## リポジトリ一覧

### 🔧 ツール

| リポジトリ | 説明 |
|-----------|------|
| [docker_setup_helper](https://github.com/ycpss91255-docker/docker_setup_helper) | モジュール化 Bash ツールキット — システムパラメータを自動検出し `.env` を生成 |

### 🖥 環境 — 開発コンテナ

#### ROS 1

| リポジトリ | ベースイメージ | アーキテクチャ | ROS ディストリビューション |
|-----------|--------------|--------------|------------------------|
| [ros_noetic](https://github.com/ycpss91255-docker/ros_noetic) | `ros:noetic-ros-base` | x86_64 + ARM | Noetic |
| [ros_kinetic](https://github.com/ycpss91255-docker/ros_kinetic) | `ros:kinetic-ros-base` | x86_64 + ARM | Kinetic |
| [osrf_ros_noetic](https://github.com/ycpss91255-docker/osrf_ros_noetic) | `osrf/ros:noetic-desktop-full` | x86_64 のみ | Noetic |
| [osrf_ros_kinetic](https://github.com/ycpss91255-docker/osrf_ros_kinetic) | `osrf/ros:kinetic-desktop-full` | x86_64 のみ | Kinetic |

#### ROS 2

| リポジトリ | ベースイメージ | アーキテクチャ | ROS ディストリビューション |
|-----------|--------------|--------------|------------------------|
| [ros2_humble](https://github.com/ycpss91255-docker/ros2_humble) | `ros:humble-ros-base` | x86_64 + ARM | Humble |
| [osrf_ros2_humble](https://github.com/ycpss91255-docker/osrf_ros2_humble) | `osrf/ros:humble-desktop-full` | x86_64 のみ | Humble |

### 🤖 AI Agent — 開発コンテナ

| リポジトリ | AI ツール | 説明 |
|-----------|----------|------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD コンテナ、Claude Code + Gemini CLI + Codex CLI 同梱 |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD コンテナ、Anthropic Claude Code 同梱 |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD コンテナ、Google Gemini CLI 同梱 |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD コンテナ、OpenAI Codex CLI 同梱 |

### 🚀 アプリケーション — デプロイコンテナ

| リポジトリ | 説明 |
|-----------|------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1/2 ブリッジコンテナ（Noetic + Foxy） |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | ROS 2 Humble コンテナ化 Hokuyo URG LiDAR ドライバ |

---

### 選び方

- **`ros` vs `osrf_ros`**：`ros` は ARM/RPi 対応、`osrf_ros` は x86 のみだが desktop-full（RViz、Gazebo）を含む
- **ROS 1 vs ROS 2**：プロジェクトの ROS バージョンに合わせて選択
- **`ros-base` vs `desktop-full`**：ヘッドレス/組み込みには `ros-base`、GUI 開発には `desktop-full`

### クイックスタート（任意の環境リポジトリ）

```bash
./build.sh && ./run.sh
```

### トピックでフィルタ

GitHub トピックフィルタでカテゴリ別に閲覧：
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

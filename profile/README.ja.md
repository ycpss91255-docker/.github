**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

# ycpss91255-docker

ROS ロボット開発、AI Agent ツール、アプリケーションデプロイのための Docker コンテナ化環境。

---

### クイックスタート（任意の環境リポジトリ）

```bash
./build.sh && ./run.sh
```

### 選び方

- **`ros` vs `osrf_ros`**：`ros` は ARM/RPi 対応、`osrf_ros` は x86 のみだが desktop-full（RViz、Gazebo）を含む
- **ROS 1 vs ROS 2**：プロジェクトの ROS バージョンに合わせて選択
- **`ros-base` vs `desktop-full`**：ヘッドレス/組み込みには `ros-base`、GUI 開発には `desktop-full`

### トピックでフィルタ

GitHub トピックフィルタでカテゴリ別に閲覧：
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

---

## リポジトリ一覧

<details>
<summary><strong>🖥 環境 — 開発コンテナ</strong></summary>

| リポジトリ | ベースイメージ | アーキテクチャ | ROS ディストリビューション |
|-----------|--------------|--------------|------------------------|
| [ros_noetic](https://github.com/ycpss91255-docker/ros_noetic) | `ros:noetic-ros-base` | x86_64 + ARM | Noetic |
| [ros_kinetic](https://github.com/ycpss91255-docker/ros_kinetic) | `ros:kinetic-ros-base` | x86_64 + ARM | Kinetic |
| [ros2_humble](https://github.com/ycpss91255-docker/ros2_humble) | `ros:humble-ros-base` | x86_64 + ARM | Humble |
| [osrf_ros_noetic](https://github.com/ycpss91255-docker/osrf_ros_noetic) | `osrf/ros:noetic-desktop-full` | x86_64 のみ | Noetic |
| [osrf_ros_kinetic](https://github.com/ycpss91255-docker/osrf_ros_kinetic) | `osrf/ros:kinetic-desktop-full` | x86_64 のみ | Kinetic |
| [osrf_ros2_humble](https://github.com/ycpss91255-docker/osrf_ros2_humble) | `osrf/ros:humble-desktop-full` | x86_64 のみ | Humble |

</details>

<details>
<summary><strong>🤖 AI Agent — 開発コンテナ</strong></summary>

| リポジトリ | AI ツール | 説明 |
|-----------|----------|------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD コンテナ、Claude Code + Gemini CLI + Codex CLI 同梱 |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD コンテナ、Anthropic Claude Code 同梱 |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD コンテナ、Google Gemini CLI 同梱 |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD コンテナ、OpenAI Codex CLI 同梱 |

</details>

<details>
<summary><strong>🚀 アプリケーション — デプロイコンテナ</strong></summary>

| リポジトリ | 説明 |
|-----------|------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1/2 ブリッジコンテナ（Noetic + Foxy） |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | ROS 2 Humble コンテナ化 Hokuyo URG LiDAR ドライバ |
| [urg_node_noetic](https://github.com/ycpss91255-docker/urg_node_noetic) | ROS 1 Noetic コンテナ化 Hokuyo URG LiDAR ドライバ |
| [realsense_humble](https://github.com/ycpss91255-docker/realsense_humble) | ROS 2 Humble コンテナ化 Intel RealSense ドライバ |
| [realsense_noetic](https://github.com/ycpss91255-docker/realsense_noetic) | ROS 1 Noetic コンテナ化 Intel RealSense ドライバ |
| [sick_humble](https://github.com/ycpss91255-docker/sick_humble) | ROS 2 Humble コンテナ化 SICK Safety Scanner ドライバ |
| [sick_noetic](https://github.com/ycpss91255-docker/sick_noetic) | ROS 1 Noetic コンテナ化 SICK Safety Scanner ドライバ |

</details>

<details>
<summary><strong>🔧 ツール</strong></summary>

| リポジトリ | 説明 |
|-----------|------|
| [template](https://github.com/ycpss91255-docker/template) | 共有テンプレート — スクリプト、テスト、CI workflows |
| [multi_run](https://github.com/ycpss91255-docker/multi_run) | 複数ワークスペースの Docker コンテナを同時起動 |

</details>

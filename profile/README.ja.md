**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

[![CI](https://github.com/ycpss91255-lab/.github/actions/workflows/check-topics.yaml/badge.svg)](https://github.com/ycpss91255-lab/.github/actions/workflows/check-topics.yaml) [![License](https://img.shields.io/badge/License-Apache--2.0-blue?style=flat-square)](https://github.com/ycpss91255-lab/.github/blob/main/LICENSE)

# ycpss91255-lab

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
[`environment`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:application) ·
[`tool`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:tool)

---

## リポジトリ一覧

<details>
<summary><strong>環境 — 開発コンテナ</strong></summary>

各リポジトリは単一の Dockerfile で、`BASE_IMAGE` build arg により distro とイメージフレーバーを切り替えます。

| リポジトリ | ROS | ディストリビューション | バリアント |
|-----------|-----|----------------------|----------|
| [ros_distro](https://github.com/ycpss91255-lab/ros_distro) | ROS 1 | Noetic、Kinetic | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |
| [ros2_distro](https://github.com/ycpss91255-lab/ros2_distro) | ROS 2 | Humble、Jazzy、Iron | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |

> 旧来の単一 distro リポジトリ（`ros_noetic`、`ros_kinetic`、`ros2_humble`、`osrf_ros_noetic`、`osrf_ros_kinetic`、`osrf_ros2_humble`）はアーカイブ済みです。[`archived`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:archived) トピックで閲覧できます。

</details>

<details>
<summary><strong>アプリケーション — デプロイコンテナ</strong></summary>

| リポジトリ | 説明 |
|-----------|------|
| [ros1_bridge](https://github.com/ycpss91255-lab/ros1_bridge) | ROS 1（Noetic）↔ ROS 2（Humble + Jazzy）ブリッジコンテナ；マルチアーキ（amd64 + arm64/Jetson） |
| [urg_node_humble](https://github.com/ycpss91255-lab/urg_node_humble) | ROS 2 Humble コンテナ化 Hokuyo URG LiDAR ドライバ |
| [urg_node_noetic](https://github.com/ycpss91255-lab/urg_node_noetic) | ROS 1 Noetic コンテナ化 Hokuyo URG LiDAR ドライバ |
| [realsense_humble](https://github.com/ycpss91255-lab/realsense_humble) | ROS 2 Humble コンテナ化 Intel RealSense ドライバ |
| [realsense_noetic](https://github.com/ycpss91255-lab/realsense_noetic) | ROS 1 Noetic コンテナ化 Intel RealSense ドライバ |
| [sick_humble](https://github.com/ycpss91255-lab/sick_humble) | ROS 2 Humble コンテナ化 SICK Safety Scanner ドライバ |
| [sick_noetic](https://github.com/ycpss91255-lab/sick_noetic) | ROS 1 Noetic コンテナ化 SICK Safety Scanner ドライバ |
| [solidworks_urdf_exporter](https://github.com/ycpss91255-lab/solidworks_urdf_exporter) | SolidWorks から URDF へのエクスポーター |
| [Solidworks-MCP](https://github.com/ycpss91255-lab/Solidworks-MCP) | Claude で SolidWorks を自動操作する MCP サーバー |
| [config_manager](https://github.com/ycpss91255-lab/config_manager) | Web UI と Git バックエンドを備えた設定の一元管理 |
| [isaac-sim-webrtc-mediamtx](https://github.com/ycpss91255-lab/isaac-sim-webrtc-mediamtx) | Isaac Sim の WebRTC クライアントを多重化し、複数の宛先へ映像を配信 |

</details>

<details>
<summary><strong>ツール</strong></summary>

| リポジトリ | 説明 |
|-----------|------|
| [base](https://github.com/ycpss91255-lab/base) | 共有テンプレート — スクリプト、テスト、CI workflows |
| [multi_run](https://github.com/ycpss91255-lab/multi_run) | 複数ワークスペースの Docker コンテナを同時起動 |
| [arch_drawio](https://github.com/ycpss91255-lab/arch_drawio) | ロボットのアーキテクチャ図（drawio）と生成スクリプト |
| [ci_cluster](https://github.com/ycpss91255-lab/ci_cluster) | GitHub Actions（ARC）と GitLab CI 向けの k3s ベース CI クラスタ |
| [vendor_kit](https://github.com/ycpss91255-lab/vendor_kit) | vendoring エンジン：配布ツリーを利用側 repo へ導入し、アップグレードとロールバックを管理 |
| [github_runner](https://github.com/ycpss91255-lab/github_runner) | セルフホスト GitHub Actions runner の構築と管理 |

</details>

> アーカイブ済みの AI Agent リポジトリ（`ai_agent`、`claude_code`、`gemini_cli`、`codex_cli`）は一覧から除外しています。[`archived`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:archived) トピックで確認できます。

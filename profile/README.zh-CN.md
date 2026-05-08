**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

[![CI](https://github.com/ycpss91255-docker/.github/actions/workflows/check-topics.yaml/badge.svg)](https://github.com/ycpss91255-docker/.github/actions/workflows/check-topics.yaml) [![License](https://img.shields.io/badge/License-Apache--2.0-blue?style=flat-square)](https://github.com/ycpss91255-docker/.github/blob/main/LICENSE)

# ycpss91255-docker

ROS 机器人开发、AI Agent 工具与应用部署的 Docker 容器化环境。

---

### 快速开始（任何环境 repo）

```bash
./build.sh && ./run.sh
```

### 如何选择？

两个环境 repo 分别覆盖 ROS 1 与 ROS 2；用 `BASE_IMAGE` 变体选择 distro 与镜像风格：

- **ROS 1 vs ROS 2** → `ros_distro`（Noetic、Kinetic）vs `ros2_distro`（Humble、Jazzy、Iron）
- **`ros:` vs `osrf/ros:` 变体** → `ros:` 支持多架构（x86_64 + ARM）的 ros-base；`osrf/ros:` 仅 x86_64 但含 desktop-full（RViz、Gazebo）

### 按主题筛选

使用 GitHub 主题筛选浏览各类 repo：
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`agent`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:agent) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

---

## 仓库索引

<details>
<summary><strong>环境 — 开发容器</strong></summary>

每个 repo 为单一 Dockerfile，通过 `BASE_IMAGE` build arg 切换 distro 与镜像风格。

| 仓库 | ROS | 发行版 | 变体 |
|------|-----|--------|------|
| [ros_distro](https://github.com/ycpss91255-docker/ros_distro) | ROS 1 | Noetic、Kinetic | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |
| [ros2_distro](https://github.com/ycpss91255-docker/ros2_distro) | ROS 2 | Humble、Jazzy、Iron | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |

> 早期单一 distro repo（`ros_noetic`、`ros_kinetic`、`ros2_humble`、`osrf_ros_noetic`、`osrf_ros_kinetic`、`osrf_ros2_humble`）已归档，可通过 [`archived`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:archived) 主题浏览。

</details>

<details>
<summary><strong>AI Agent — 开发容器</strong></summary>

| 仓库 | AI 工具 | 说明 |
|------|---------|------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD 容器，含 Claude Code + Gemini CLI + Codex CLI |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD 容器，含 Anthropic Claude Code |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD 容器，含 Google Gemini CLI |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD 容器，含 OpenAI Codex CLI |

</details>

<details>
<summary><strong>应用 — 部署容器</strong></summary>

| 仓库 | 说明 |
|------|------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1（Noetic）↔ ROS 2（Humble + Jazzy）桥接容器；多架构（amd64 + arm64/Jetson） |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | ROS 2 Humble 容器化 Hokuyo URG LiDAR 驱动 |
| [urg_node_noetic](https://github.com/ycpss91255-docker/urg_node_noetic) | ROS 1 Noetic 容器化 Hokuyo URG LiDAR 驱动 |
| [realsense_humble](https://github.com/ycpss91255-docker/realsense_humble) | ROS 2 Humble 容器化 Intel RealSense 驱动 |
| [realsense_noetic](https://github.com/ycpss91255-docker/realsense_noetic) | ROS 1 Noetic 容器化 Intel RealSense 驱动 |
| [sick_humble](https://github.com/ycpss91255-docker/sick_humble) | ROS 2 Humble 容器化 SICK Safety Scanner 驱动 |
| [sick_noetic](https://github.com/ycpss91255-docker/sick_noetic) | ROS 1 Noetic 容器化 SICK Safety Scanner 驱动 |

</details>

<details>
<summary><strong>工具</strong></summary>

| 仓库 | 说明 |
|------|------|
| [template](https://github.com/ycpss91255-docker/template) | 共用模板 — 脚本、测试、CI workflows |
| [multi_run](https://github.com/ycpss91255-docker/multi_run) | 同时启动多个不同工作区的 Docker 容器 |

</details>

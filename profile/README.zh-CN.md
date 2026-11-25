**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

[![CI](https://github.com/ycpss91255-lab/.github/actions/workflows/check-topics.yaml/badge.svg)](https://github.com/ycpss91255-lab/.github/actions/workflows/check-topics.yaml) [![License](https://img.shields.io/badge/License-Apache--2.0-blue?style=flat-square)](https://github.com/ycpss91255-lab/.github/blob/main/LICENSE)

# ycpss91255-lab

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
[`environment`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:application) ·
[`tool`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:tool)

---

## 仓库索引

<details>
<summary><strong>环境 — 开发容器</strong></summary>

每个 repo 为单一 Dockerfile，通过 `BASE_IMAGE` build arg 切换 distro 与镜像风格。

| 仓库 | ROS | 发行版 | 变体 |
|------|-----|--------|------|
| [ros_distro](https://github.com/ycpss91255-lab/ros_distro) | ROS 1 | Noetic、Kinetic | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |
| [ros2_distro](https://github.com/ycpss91255-lab/ros2_distro) | ROS 2 | Humble、Jazzy、Iron | `ros:*-ros-base`（x86_64 + ARM）、`osrf/ros:*-desktop-full`（x86_64） |

> 早期单一 distro repo（`ros_noetic`、`ros_kinetic`、`ros2_humble`、`osrf_ros_noetic`、`osrf_ros_kinetic`、`osrf_ros2_humble`）已归档，可通过 [`archived`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:archived) 主题浏览。

</details>

<details>
<summary><strong>应用 — 部署容器</strong></summary>

| 仓库 | 说明 |
|------|------|
| [ros1_bridge](https://github.com/ycpss91255-lab/ros1_bridge) | ROS 1（Noetic）↔ ROS 2（Humble + Jazzy）桥接容器；多架构（amd64 + arm64/Jetson） |
| [urg_node_humble](https://github.com/ycpss91255-lab/urg_node_humble) | ROS 2 Humble 容器化 Hokuyo URG LiDAR 驱动 |
| [urg_node_noetic](https://github.com/ycpss91255-lab/urg_node_noetic) | ROS 1 Noetic 容器化 Hokuyo URG LiDAR 驱动 |
| [realsense_humble](https://github.com/ycpss91255-lab/realsense_humble) | ROS 2 Humble 容器化 Intel RealSense 驱动 |
| [realsense_noetic](https://github.com/ycpss91255-lab/realsense_noetic) | ROS 1 Noetic 容器化 Intel RealSense 驱动 |
| [sick_humble](https://github.com/ycpss91255-lab/sick_humble) | ROS 2 Humble 容器化 SICK Safety Scanner 驱动 |
| [sick_noetic](https://github.com/ycpss91255-lab/sick_noetic) | ROS 1 Noetic 容器化 SICK Safety Scanner 驱动 |
| [solidworks_urdf_exporter](https://github.com/ycpss91255-lab/solidworks_urdf_exporter) | SolidWorks 转 URDF 导出工具 |
| [Solidworks-MCP](https://github.com/ycpss91255-lab/Solidworks-MCP) | 通过 Claude 自动操作 SolidWorks 的 MCP 服务器 |
| [config_manager](https://github.com/ycpss91255-lab/config_manager) | 带 Web UI 与 Git 后端的集中式配置管理 |
| [isaac-sim-webrtc-mediamtx](https://github.com/ycpss91255-lab/isaac-sim-webrtc-mediamtx) | Isaac Sim WebRTC 客户端多路复用，将视频流推送到多个目的地 |

</details>

<details>
<summary><strong>工具</strong></summary>

| 仓库 | 说明 |
|------|------|
| [base](https://github.com/ycpss91255-lab/base) | 共用模板 — 脚本、测试、CI workflows |
| [multi_run](https://github.com/ycpss91255-lab/multi_run) | 同时启动多个不同工作区的 Docker 容器 |
| [vendor_kit](https://github.com/ycpss91255-lab/vendor_kit) | Vendoring 引擎：将发行树安装到使用端 repo，并管理升级与回滚 |
| [github_runner](https://github.com/ycpss91255-lab/github_runner) | 部署与管理自托管 GitHub Actions runner |

</details>

> 已归档的 AI Agent repo（`ai_agent`、`claude_code`、`gemini_cli`、`codex_cli`）不再列出，可通过 [`archived`](https://github.com/orgs/ycpss91255-lab/repositories?q=topic:archived) topic 浏览。

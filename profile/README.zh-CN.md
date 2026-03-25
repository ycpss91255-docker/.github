**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

# ycpss91255-docker

ROS 机器人开发、AI Agent 工具与应用部署的 Docker 容器化环境。

---

## 仓库索引

### 🔧 工具

| 仓库 | 说明 |
|------|------|
| [docker_setup_helper](https://github.com/ycpss91255-docker/docker_setup_helper) | 模块化 Bash 工具包 — 自动检测系统参数并生成 `.env` |

### 🖥 环境 — 开发容器

#### ROS 1

| 仓库 | 基础镜像 | 架构 | ROS 发行版 |
|------|----------|------|-----------|
| [ros_noetic](https://github.com/ycpss91255-docker/ros_noetic) | `ros:noetic-ros-base` | x86_64 + ARM | Noetic |
| [ros_kinetic](https://github.com/ycpss91255-docker/ros_kinetic) | `ros:kinetic-ros-base` | x86_64 + ARM | Kinetic |
| [osrf_ros_noetic](https://github.com/ycpss91255-docker/osrf_ros_noetic) | `osrf/ros:noetic-desktop-full` | 仅 x86_64 | Noetic |
| [osrf_ros_kinetic](https://github.com/ycpss91255-docker/osrf_ros_kinetic) | `osrf/ros:kinetic-desktop-full` | 仅 x86_64 | Kinetic |

#### ROS 2

| 仓库 | 基础镜像 | 架构 | ROS 发行版 |
|------|----------|------|-----------|
| [ros2_humble](https://github.com/ycpss91255-docker/ros2_humble) | `ros:humble-ros-base` | x86_64 + ARM | Humble |
| [osrf_ros2_humble](https://github.com/ycpss91255-docker/osrf_ros2_humble) | `osrf/ros:humble-desktop-full` | 仅 x86_64 | Humble |

### 🤖 AI Agent — 开发容器

| 仓库 | AI 工具 | 说明 |
|------|---------|------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD 容器，含 Claude Code + Gemini CLI + Codex CLI |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD 容器，含 Anthropic Claude Code |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD 容器，含 Google Gemini CLI |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD 容器，含 OpenAI Codex CLI |

### 🚀 应用 — 部署容器

| 仓库 | 说明 |
|------|------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1/2 桥接容器（Noetic + Foxy） |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | ROS 2 Humble 容器化 Hokuyo URG LiDAR 驱动 |
| [urg_node_noetic](https://github.com/ycpss91255-docker/urg_node_noetic) | ROS 1 Noetic 容器化 Hokuyo URG LiDAR 驱动 |
| [realsense_humble](https://github.com/ycpss91255-docker/realsense_humble) | ROS 2 Humble 容器化 Intel RealSense 驱动 |
| [realsense_noetic](https://github.com/ycpss91255-docker/realsense_noetic) | ROS 1 Noetic 容器化 Intel RealSense 驱动 |
| [sick_humble](https://github.com/ycpss91255-docker/sick_humble) | ROS 2 Humble 容器化 SICK Safety Scanner 驱动 |
| [sick_noetic](https://github.com/ycpss91255-docker/sick_noetic) | ROS 1 Noetic 容器化 SICK Safety Scanner 驱动 |

---

### 如何选择？

- **`ros` vs `osrf_ros`**：`ros` 支持 ARM/RPi，`osrf_ros` 仅 x86 但含 desktop-full（RViz、Gazebo）
- **ROS 1 vs ROS 2**：根据项目的 ROS 版本选择
- **`ros-base` vs `desktop-full`**：无头/嵌入式用 `ros-base`，GUI 开发用 `desktop-full`

### 快速开始（任何环境 repo）

```bash
./build.sh && ./run.sh
```

### 按主题筛选

使用 GitHub 主题筛选浏览各类 repo：
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

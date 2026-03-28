**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

# ycpss91255-docker

ROS 機器人開發、AI Agent 工具與應用部署的 Docker 容器化環境。

---

## 倉庫索引

### 🔧 工具

| 倉庫 | 說明 |
|------|------|
| [docker_template](https://github.com/ycpss91255-docker/docker_template) | 模組化 Bash 工具包 — 自動偵測系統參數並產生 `.env` |

### 🖥 環境 — 開發容器

#### ROS 1

| 倉庫 | 基礎映像 | 架構 | ROS 發行版 |
|------|----------|------|-----------|
| [ros_noetic](https://github.com/ycpss91255-docker/ros_noetic) | `ros:noetic-ros-base` | x86_64 + ARM | Noetic |
| [ros_kinetic](https://github.com/ycpss91255-docker/ros_kinetic) | `ros:kinetic-ros-base` | x86_64 + ARM | Kinetic |
| [osrf_ros_noetic](https://github.com/ycpss91255-docker/osrf_ros_noetic) | `osrf/ros:noetic-desktop-full` | 僅 x86_64 | Noetic |
| [osrf_ros_kinetic](https://github.com/ycpss91255-docker/osrf_ros_kinetic) | `osrf/ros:kinetic-desktop-full` | 僅 x86_64 | Kinetic |

#### ROS 2

| 倉庫 | 基礎映像 | 架構 | ROS 發行版 |
|------|----------|------|-----------|
| [ros2_humble](https://github.com/ycpss91255-docker/ros2_humble) | `ros:humble-ros-base` | x86_64 + ARM | Humble |
| [osrf_ros2_humble](https://github.com/ycpss91255-docker/osrf_ros2_humble) | `osrf/ros:humble-desktop-full` | 僅 x86_64 | Humble |

### 🤖 AI Agent — 開發容器

| 倉庫 | AI 工具 | 說明 |
|------|---------|------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD 容器，含 Claude Code + Gemini CLI + Codex CLI |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD 容器，含 Anthropic Claude Code |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD 容器，含 Google Gemini CLI |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD 容器，含 OpenAI Codex CLI |

### 🚀 應用 — 部署容器

| 倉庫 | 說明 |
|------|------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1/2 橋接容器（Noetic + Foxy） |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | ROS 2 Humble 容器化 Hokuyo URG LiDAR 驅動 |
| [urg_node_noetic](https://github.com/ycpss91255-docker/urg_node_noetic) | ROS 1 Noetic 容器化 Hokuyo URG LiDAR 驅動 |
| [realsense_humble](https://github.com/ycpss91255-docker/realsense_humble) | ROS 2 Humble 容器化 Intel RealSense 驅動 |
| [realsense_noetic](https://github.com/ycpss91255-docker/realsense_noetic) | ROS 1 Noetic 容器化 Intel RealSense 驅動 |
| [sick_humble](https://github.com/ycpss91255-docker/sick_humble) | ROS 2 Humble 容器化 SICK Safety Scanner 驅動 |
| [sick_noetic](https://github.com/ycpss91255-docker/sick_noetic) | ROS 1 Noetic 容器化 SICK Safety Scanner 驅動 |

---

### 如何選擇？

- **`ros` vs `osrf_ros`**：`ros` 支援 ARM/RPi，`osrf_ros` 僅 x86 但含 desktop-full（RViz、Gazebo）
- **ROS 1 vs ROS 2**：依專案的 ROS 版本選擇
- **`ros-base` vs `desktop-full`**：無頭/嵌入式用 `ros-base`，GUI 開發用 `desktop-full`

### 快速開始（任何環境 repo）

```bash
./build.sh && ./run.sh
```

### 依主題篩選

使用 GitHub 主題篩選瀏覽各類 repo：
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

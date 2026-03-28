**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

# ycpss91255-docker

Docker containerized environments for ROS robotics development, AI agent tools, and deployment.

---

## Repository Index

<details>
<summary><strong>🔧 Tool</strong></summary>

| Repository | Description |
|------------|-------------|
| [docker_template](https://github.com/ycpss91255-docker/docker_template) | Shared template — scripts, tests, CI workflows for all Docker container repos |

</details>

### 🖥 Environment — Development Containers

#### ROS 1

| Repository | Base Image | Architecture | ROS Distro |
|------------|------------|-------------|------------|
| [ros_noetic](https://github.com/ycpss91255-docker/ros_noetic) | `ros:noetic-ros-base` | x86_64 + ARM | Noetic |
| [ros_kinetic](https://github.com/ycpss91255-docker/ros_kinetic) | `ros:kinetic-ros-base` | x86_64 + ARM | Kinetic |
| [osrf_ros_noetic](https://github.com/ycpss91255-docker/osrf_ros_noetic) | `osrf/ros:noetic-desktop-full` | x86_64 only | Noetic |
| [osrf_ros_kinetic](https://github.com/ycpss91255-docker/osrf_ros_kinetic) | `osrf/ros:kinetic-desktop-full` | x86_64 only | Kinetic |

#### ROS 2

| Repository | Base Image | Architecture | ROS Distro |
|------------|------------|-------------|------------|
| [ros2_humble](https://github.com/ycpss91255-docker/ros2_humble) | `ros:humble-ros-base` | x86_64 + ARM | Humble |
| [osrf_ros2_humble](https://github.com/ycpss91255-docker/osrf_ros2_humble) | `osrf/ros:humble-desktop-full` | x86_64 only | Humble |

### 🤖 AI Agent — Development Containers

| Repository | AI Tool | Description |
|------------|---------|-------------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD container with Claude Code + Gemini CLI + Codex CLI |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD container with Anthropic Claude Code |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD container with Google Gemini CLI |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD container with OpenAI Codex CLI |

### 🚀 Application — Deployment Containers

| Repository | Description |
|------------|-------------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1/2 bridge container (Noetic + Foxy) |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | Containerized Hokuyo URG LiDAR driver for ROS 2 Humble |
| [urg_node_noetic](https://github.com/ycpss91255-docker/urg_node_noetic) | Containerized Hokuyo URG LiDAR driver for ROS 1 Noetic |
| [realsense_humble](https://github.com/ycpss91255-docker/realsense_humble) | Containerized Intel RealSense driver for ROS 2 Humble |
| [realsense_noetic](https://github.com/ycpss91255-docker/realsense_noetic) | Containerized Intel RealSense driver for ROS 1 Noetic |
| [sick_humble](https://github.com/ycpss91255-docker/sick_humble) | Containerized SICK Safety Scanner driver for ROS 2 Humble |
| [sick_noetic](https://github.com/ycpss91255-docker/sick_noetic) | Containerized SICK Safety Scanner driver for ROS 1 Noetic |

---

### How to choose?

- **`ros` vs `osrf_ros`**: `ros` supports ARM/RPi, `osrf_ros` is x86-only but includes desktop-full (RViz, Gazebo)
- **ROS 1 vs ROS 2**: Choose based on your project's ROS version
- **`ros-base` vs `desktop-full`**: Use `ros-base` for headless/embedded, `desktop-full` for GUI development

### Quick Start (any environment repo)

```bash
./build.sh && ./run.sh
```

### Filter by topic

Use GitHub topic filters to browse repos by category:
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

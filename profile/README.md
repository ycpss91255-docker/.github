**[English](README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

[![CI](https://github.com/ycpss91255-docker/.github/actions/workflows/check-topics.yaml/badge.svg)](https://github.com/ycpss91255-docker/.github/actions/workflows/check-topics.yaml) [![License](https://img.shields.io/badge/License-Apache--2.0-blue?style=flat-square)](https://github.com/ycpss91255-docker/.github/blob/main/LICENSE)

# ycpss91255-docker

Docker containerized environments for ROS robotics development, AI agent tools, and deployment.

---

### Quick Start (any environment repo)

```bash
./build.sh && ./run.sh
```

### How to choose?

Two environment repos cover ROS 1 and ROS 2; pick a `BASE_IMAGE` variant to choose the distro and image flavour:

- **ROS 1 vs ROS 2** → `ros_distro` (Noetic, Kinetic) vs `ros2_distro` (Humble, Jazzy, Iron)
- **`ros:` vs `osrf/ros:` variant** → `ros:` is multi-arch (x86_64 + ARM) ros-base; `osrf/ros:` is x86_64-only desktop-full (RViz, Gazebo)

### Filter by topic

Use GitHub topic filters to browse repos by category:
[`environment`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:environment) ·
[`application`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:application) ·
[`agent`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:agent) ·
[`tool`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:tool)

---

## Repository Index

<details>
<summary><strong>Environment — Development Containers</strong></summary>

Each repo is a single Dockerfile that switches distro and base image flavour via the `BASE_IMAGE` build arg.

| Repository | ROS | Distros | Variants |
|------------|-----|---------|----------|
| [ros_distro](https://github.com/ycpss91255-docker/ros_distro) | ROS 1 | Noetic, Kinetic | `ros:*-ros-base` (x86_64 + ARM), `osrf/ros:*-desktop-full` (x86_64) |
| [ros2_distro](https://github.com/ycpss91255-docker/ros2_distro) | ROS 2 | Humble, Jazzy, Iron | `ros:*-ros-base` (x86_64 + ARM), `osrf/ros:*-desktop-full` (x86_64) |

> Earlier per-distro repos (`ros_noetic`, `ros_kinetic`, `ros2_humble`, `osrf_ros_noetic`, `osrf_ros_kinetic`, `osrf_ros2_humble`) are archived; see the [`archived`](https://github.com/orgs/ycpss91255-docker/repositories?q=topic:archived) topic.

</details>

<details>
<summary><strong>AI Agent — Development Containers</strong></summary>

| Repository | AI Tool | Description |
|------------|---------|-------------|
| [ai_agent](https://github.com/ycpss91255-docker/ai_agent) | All-in-one | DinD container with Claude Code + Gemini CLI + Codex CLI |
| [claude_code](https://github.com/ycpss91255-docker/claude_code) | Claude Code | DinD container with Anthropic Claude Code |
| [gemini_cli](https://github.com/ycpss91255-docker/gemini_cli) | Gemini CLI | DinD container with Google Gemini CLI |
| [codex_cli](https://github.com/ycpss91255-docker/codex_cli) | Codex CLI | DinD container with OpenAI Codex CLI |

</details>

<details>
<summary><strong>Application — Deployment Containers</strong></summary>

| Repository | Description |
|------------|-------------|
| [ros1_bridge](https://github.com/ycpss91255-docker/ros1_bridge) | ROS 1 (Noetic) ↔ ROS 2 (Humble + Jazzy) bridge; multi-arch (amd64 + arm64/Jetson) |
| [urg_node_humble](https://github.com/ycpss91255-docker/urg_node_humble) | Containerized Hokuyo URG LiDAR driver for ROS 2 Humble |
| [urg_node_noetic](https://github.com/ycpss91255-docker/urg_node_noetic) | Containerized Hokuyo URG LiDAR driver for ROS 1 Noetic |
| [realsense_humble](https://github.com/ycpss91255-docker/realsense_humble) | Containerized Intel RealSense driver for ROS 2 Humble |
| [realsense_noetic](https://github.com/ycpss91255-docker/realsense_noetic) | Containerized Intel RealSense driver for ROS 1 Noetic |
| [sick_humble](https://github.com/ycpss91255-docker/sick_humble) | Containerized SICK Safety Scanner driver for ROS 2 Humble |
| [sick_noetic](https://github.com/ycpss91255-docker/sick_noetic) | Containerized SICK Safety Scanner driver for ROS 1 Noetic |

</details>

<details>
<summary><strong>Tool</strong></summary>

| Repository | Description |
|------------|-------------|
| [base](https://github.com/ycpss91255-docker/base) | Shared template — scripts, tests, CI workflows for all Docker container repos |
| [multi_run](https://github.com/ycpss91255-docker/multi_run) | Launch multiple Docker containers from different workspaces simultaneously |

</details>

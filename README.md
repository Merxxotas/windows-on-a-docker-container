# 🖥️ Windows 11 Docker Setup on CachyOS / Arch Linux

[![CI/CD](https://github.com/Merxxotas/windows-on-a-docker-container/actions/workflows/ci.yml/badge.svg)](https://github.com/Merxxotas/windows-on-a-docker-container/actions)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![KVM](https://img.shields.io/badge/KVM-Accelerated-FF6600?style=for-the-badge&logo=linux&logoColor=white)](https://www.linux-kvm.org/)
[![CachyOS](https://img.shields.io/badge/CachyOS-Arch%20Linux-00DDFF?style=for-the-badge&logo=archlinux&logoColor=black)](https://cachyos.org/)
[![RDP](https://img.shields.io/badge/RDP-Supported-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://microsoft.com)

An automated and optimized environment to run **Windows 11 (Enterprise LTSC)** inside a KVM-accelerated Docker container on **CachyOS / Arch Linux**, featuring **bidirectional clipboard support**, **PipeWire/PulseAudio redirection**, **shared host directories**, **instant BTRFS backups**, **system health diagnostic tools**, and **desktop menu shortcuts**.

---

## ✨ Key Features

- ⚡ **Near-Native Performance (KVM)**: Hardware acceleration with CPU passthrough (`CPU_MODEL: "host"`).
- 📋 **Bidirectional Clipboard**: Copy/paste text and data seamlessly between CachyOS and Windows via RDP (`Ctrl+C` / `Ctrl+V`).
- 🔊 **High-Fidelity Audio**: Direct integration with the Host's PipeWire / PulseAudio sound server.
- 📁 **Host Storage Sharing**: Transparent SMB file access from Windows (`\\host.lan\home` and `\\host.lan\vicioo`).
- 💾 **Instant BTRFS Snapshots**: Backup 64 GB virtual disk images in 1 second using Copy-On-Write technology.
- 🩺 **System Doctor (`win-doctor.sh`)**: Audits KVM, TUN, Docker daemon, sound server, and network port health.
- 🎮 **Hardware GPU Acceleration (`compose.gpu.yml`)**: Pre-configured compose template for Intel/AMD Mesa/Vulkan GPU passthrough.
- 📦 **OS Version Switcher (`win-select-version.sh`)**: Interactive selector for Windows editions (`win11`, `win11-ltsc`, `tiny11`, `win10`, `server2025`).
- ⚡ **Background Systemd Daemon (`setup-service.sh`)**: Automatic background autostart configuration for Linux host boots.
- 🖥️ **Desktop Launcher**: Install standard Linux application menu shortcuts with 1 command (`install-desktop-shortcut.sh`).
- ⚙️ **Automated CI/CD Pipeline**: GitHub Actions validation for Docker Compose and shell script syntax integrity.

---

## 📁 Repository Structure

```text
.
├── compose.yml                 # Docker Compose configuration (KVM, ports, volume mounts)
├── compose.gpu.yml             # GPU-accelerated Docker Compose deployment
├── install_windows.sh          # One-click automated setup & verification script
├── .gitignore                  # Excludes large VM disks, ISOs, state files, and backups
├── README.md                   # Main repository README
├── .github/
│   └── workflows/ci.yml        # GitHub Actions CI/CD validation pipeline
├── assets/
│   └── windows-vm.desktop      # Desktop application launcher template
├── docs/
│   ├── SYSTEM_RECREATION.md    # Clean setup & reinstallation guide
│   └── USER_MANUAL.md          # User manual (Remmina, xfreerdp3, audio, clipboard & SMB)
└── scripts/
    ├── win-start.sh            # Starts VM container and launches RDP session in 1 click
    ├── win-stop.sh             # Safely stops VM container to free RAM and CPU
    ├── win-status.sh           # Displays container status, CPU/RAM stats, and active ports
    ├── win-doctor.sh           # Environment health check diagnostic tool
    ├── win-select-version.sh   # Interactive Windows OS version selector
    ├── setup-service.sh        # Installs systemd background autostart service
    ├── install-desktop-shortcut.sh # Registers Linux desktop application menu launcher
    └── backup-vm.sh            # Creates instant Copy-On-Write BTRFS snapshots
```

---

## 🚀 Prerequisites

On CachyOS or any Arch Linux-based distribution:

```bash
# 1. Install Docker, Compose, Remmina, and FreeRDP
sudo pacman -S docker docker-compose remmina freerdp --noconfirm

# 2. Enable and start Docker daemon
sudo systemctl enable --now docker

# 3. Add current user to docker group
sudo usermod -aG docker $USER
```

---

## ⚡ Quick Start

1. **Automated One-Click Install**:
   ```bash
   git clone https://github.com/Merxxotas/windows-on-a-docker-container.git
   cd windows-on-a-docker-container
   ./install_windows.sh
   ```

2. **Or Manual Launch**:
   ```bash
   ./scripts/win-start.sh
   ```

3. **Web Viewer (Initial Setup / Monitoring)**:
   Open your browser at [http://localhost:8006](http://localhost:8006).

4. **RDP Session (Clipboard + Audio)**:
   - **One-click Terminal Command**:
     ```bash
     xfreerdp3 /v:localhost:3389 /u:merxx /p:030414 +clipboard /dynamic-resolution /sound:sys:pulse
     ```
   - **Remmina GUI**: Connect to `localhost:3389` (User: `merxx` | Pass: `030414`).

---

## 🛠️ Management Commands

| Action | Command | Description |
| :--- | :--- | :--- |
| **Start VM + RDP** | `./scripts/win-start.sh` | Starts container if stopped and launches RDP. |
| **Stop VM** | `./scripts/win-stop.sh` | Safely stops container and frees RAM/CPU. |
| **Status & Stats** | `./scripts/win-status.sh` | Displays RAM/CPU usage stats and listening ports. |
| **System Doctor** | `./scripts/win-doctor.sh` | Audits KVM, TUN, Docker, RDP clients, and audio health. |
| **Switch OS Edition** | `./scripts/win-select-version.sh` | Interactively select Windows 11, LTSC, Tiny11, Win10, Server. |
| **Autostart Service** | `./scripts/setup-service.sh` | Registers systemd user service for background boot start. |
| **Install Shortcut** | `./scripts/install-desktop-shortcut.sh` | Adds 'Windows 11 (Docker VM)' to system app menu. |
| **BTRFS Backup** | `./scripts/backup-vm.sh` | Creates an instant Copy-On-Write snapshot. |

---

## 📖 Detailed Documentation

Refer to the complete technical guides in the `docs/` directory:
- [📘 System Recreation Guide](docs/SYSTEM_RECREATION.md)
- [📙 User Manual (Remmina & FreeRDP)](docs/USER_MANUAL.md)

---

## 📜 License & Acknowledgments

- Powered by [dockur/windows](https://github.com/dockur/windows).
- Licensed under the MIT License.


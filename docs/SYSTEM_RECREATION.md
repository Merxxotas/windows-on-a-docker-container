# System Recreation & Clean Setup Guide (CachyOS / Arch Linux)

This guide documents all necessary steps to deploy the Windows Docker environment (`dockur/windows`) from scratch after a clean operating system reinstallation.

---

## 1. Package Installation and Initial Configuration

On a clean CachyOS / Arch Linux installation, open your terminal and run:

```bash
# 1. Install Docker, Docker Compose, Remmina, and FreeRDP
sudo pacman -S docker docker-compose remmina freerdp --noconfirm

# 2. Enable and start the Docker daemon
sudo systemctl enable --now docker

# 3. Add your current user to the docker group
sudo usermod -aG docker $USER
```

> ⚠️ **Note**: After adding your user to the `docker` group, you must log out and log back in (or reboot) for group permissions to take effect without needing `sudo`.

---

## 2. KVM and TUN Device Verification

The Docker container requires direct hardware access to KVM virtualization and TUN networking:

```bash
ls -l /dev/kvm /dev/net/tun
```
Ensure both devices exist and have read/write permissions (`crw-rw-rw-`).

---

## 3. Project Structure & `compose.yml`

Ensure your project directory is located at:
`/home/merxx/Documents/experiments/windows_Docker-version`

The `compose.yml` file contains the following configuration:

```yaml
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      DISK_SIZE: "64G"
      RAM_SIZE: "8G"
      CPU_CORES: "8"
      CPU_MODEL: "host"
      TZ: "America/Bogota"
      AUDIO: "Y"
      USERNAME: "merxx"
      PASSWORD: "030414"
      REGION: "en-us"
      KEYBOARD: "es-CO"
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006
      - 3389:3389/tcp
      - 3389:3389/udp
    volumes:
      - /home/merxx/Documents/experiments/windows_Docker-version:/storage
      - /home/merxx:/shared/home
      - /mnt/vicioo:/shared/vicioo
      - /mnt/vicioo/ISOS/en-us_windows_11_iot_enterprise_ltsc_2024_x64_dvd_f6b14814-ENGVersion.iso:/custom.iso
    restart: always
    stop_grace_period: 2m
```

---

## 4. Launching the Container

To start the virtual machine:

```bash
cd /home/merxx/Documents/experiments/windows_Docker-version
docker compose up -d
```

### Verification:
- Access [http://localhost:8006](http://localhost:8006) in your web browser to monitor the real-time installation and boot process.

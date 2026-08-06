#!/bin/bash

# ==============================================================================
# Script: install_windows.sh
# Description: Automated setup and installation script for Windows Docker container
#              (KVM accelerated, RDP & Web UI support).
# ==============================================================================

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== STARTING WINDOWS DOCKER INSTALLATION ===${NC}"

# 1. Check Root / Sudo Privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}[NOTICE] Script is running without root privileges.${NC}"
    echo "If Docker permissions are needed, ensure your user is in the 'docker' group."
fi

# 2. Check KVM Support (Hardware Virtualization)
echo -e "${GREEN}[1/5] Checking KVM & TUN support (Hardware Virtualization)...${NC}"
if [ -r /dev/kvm ]; then
    echo -e "  ${GREEN}✓ /dev/kvm is available.${NC}"
else
    echo -e "  ${RED}[WARNING] /dev/kvm not found or not readable. The VM will perform poorly without KVM acceleration.${NC}"
    read -p "Do you want to continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 1; fi
fi

if [ -c /dev/net/tun ]; then
    echo -e "  ${GREEN}✓ /dev/net/tun is available.${NC}"
else
    echo -e "  ${YELLOW}[WARNING] /dev/net/tun not found. Network features might be limited.${NC}"
fi

# 3. Check Docker & Docker Compose
echo -e "${GREEN}[2/5] Checking Docker & Docker Compose installation...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[ERROR] Docker is not installed.${NC}"
    echo "Please install Docker using your package manager:"
    echo "  Arch/CachyOS: sudo pacman -S docker docker-compose"
    echo "  Ubuntu/Debian: sudo apt install docker.io docker-compose-v2"
    exit 1
else
    echo -e "  ${GREEN}✓ Docker is installed ($(docker --version))${NC}"
fi

# 4. Prepare Storage Directory
echo -e "${GREEN}[3/5] Preparing persistent storage...${NC}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

mkdir -p "$DIR/storage"
mkdir -p "$DIR/backups"
echo -e "  ${GREEN}✓ Storage directories ready at $DIR/storage${NC}"

# 5. Start Container
echo -e "${GREEN}[4/5] Starting Windows Docker container...${NC}"
if docker compose version &> /dev/null; then
    docker compose up -d
elif docker-compose version &> /dev/null; then
    docker-compose up -d
else
    echo -e "${RED}[ERROR] 'docker compose' command not found.${NC}"
    exit 1
fi

# 6. Final Status & Instructions
echo -e "${GREEN}[5/5] Checking container status...${NC}"
sleep 3

if docker ps | grep -q "windows"; then
    SERVER_IP=$(hostname -I | awk '{print $1}')
    echo -e "\n${GREEN}===================================================${NC}"
    echo -e "${GREEN}=== WINDOWS DOCKER INSTALLED & RUNNING ===${NC}"
    echo -e "==================================================="
    echo -e " Server IP:          ${BLUE}${SERVER_IP}${NC}"
    echo -e " Web Interface (UI): ${BLUE}http://localhost:8006${NC} or http://${SERVER_IP}:8006"
    echo -e " RDP Port:           ${BLUE}3389${NC}"
    echo -e " Default Credentials: User: ${GREEN}merxx${NC} | Pass: ${GREEN}030414${NC}"
    echo -e "---------------------------------------------------"
    echo -e " >>> ${YELLOW}One-click RDP command (Linux/xfreerdp3):${NC}"
    echo -e " ${GREEN}xfreerdp3 /v:localhost:3389 /u:merxx /p:030414 +clipboard /dynamic-resolution /sound:sys:pulse${NC}"
    echo -e " >>> ${YELLOW}Start script:${NC}  ./scripts/win-start.sh"
    echo -e " >>> ${YELLOW}Stop script:${NC}   ./scripts/win-stop.sh"
    echo -e " >>> ${YELLOW}Status script:${NC} ./scripts/win-status.sh"
    echo -e "===================================================\n"
else
    echo -e "${RED}[ERROR] Container failed to start. Check logs with: docker logs windows${NC}"
fi

#!/bin/bash

# ==============================================================================
# Script: win-doctor.sh
# Description: Health check and diagnostic tool for the Windows Docker environment.
# ==============================================================================

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}🩺 WINDOWS DOCKER ENVIRONMENT HEALTH DOCTOR${NC}"
echo -e "${BLUE}======================================================${NC}"

# 1. Check KVM Virtualization
echo -n "Checking KVM acceleration (/dev/kvm)... "
if [ -r /dev/kvm ]; then
    echo -e "${GREEN}[OK] /dev/kvm is accessible.${NC}"
else
    echo -e "${RED}[FAIL] /dev/kvm missing or permission denied.${NC}"
fi

# 2. Check TUN Networking
echo -n "Checking TUN device (/dev/net/tun)... "
if [ -c /dev/net/tun ]; then
    echo -e "${GREEN}[OK] /dev/net/tun is ready.${NC}"
else
    echo -e "${YELLOW}[WARN] /dev/net/tun missing.${NC}"
fi

# 3. Check Docker Daemon & Permissions
echo -n "Checking Docker daemon... "
if docker info &> /dev/null; then
    echo -e "${GREEN}[OK] Docker daemon is running and user has access.${NC}"
else
    echo -e "${RED}[FAIL] Cannot communicate with Docker daemon.${NC}"
fi

# 4. Check RDP Client Binaries
echo -n "Checking RDP client (FreeRDP / Remmina)... "
FOUND_CLIENT=0
if command -v xfreerdp3 &> /dev/null; then
    echo -n -e "${GREEN}xfreerdp3 ${NC}"
    FOUND_CLIENT=1
fi
if command -v xfreerdp &> /dev/null; then
    echo -n -e "${GREEN}xfreerdp ${NC}"
    FOUND_CLIENT=1
fi
if command -v remmina &> /dev/null; then
    echo -n -e "${GREEN}remmina ${NC}"
    FOUND_CLIENT=1
fi

if [ $FOUND_CLIENT -eq 1 ]; then
    echo -e "${GREEN}[OK]${NC}"
else
    echo -e "${YELLOW}[WARN] No RDP client found. Install freerdp or remmina.${NC}"
fi

# 5. Check Audio Server (PipeWire / PulseAudio)
echo -n "Checking host audio server... "
if pgrep -x "pipewire" &> /dev/null || pgrep -x "pulseaudio" &> /dev/null; then
    echo -e "${GREEN}[OK] Sound server active.${NC}"
else
    echo -e "${YELLOW}[WARN] Sound server not detected.${NC}"
fi

# 6. Check BTRFS Reflink Support for Backups
echo -n "Checking BTRFS Copy-On-Write capability... "
TEST_SRC="/tmp/btrfs_test_src"
TEST_DST="/tmp/btrfs_test_dst"
touch "$TEST_SRC"
if cp --reflink=always "$TEST_SRC" "$TEST_DST" 2>/dev/null; then
    echo -e "${GREEN}[OK] Reflink instant snapshots supported.${NC}"
    rm -f "$TEST_SRC" "$TEST_DST"
else
    echo -e "${YELLOW}[INFO] Sparse fallback copy will be used for backups.${NC}"
    rm -f "$TEST_SRC" "$TEST_DST"
fi

# 7. Check Container & Port Status
echo -e "\n${BLUE}--- Container Status ---${NC}"
if docker ps --format '{{.Names}}' | grep -q "^windows$"; then
    echo -e "Container state: ${GREEN}RUNNING${NC}"
    echo -e "Web UI (8006):   ${GREEN}http://localhost:8006${NC}"
    echo -e "RDP (3389):      ${GREEN}localhost:3389${NC}"
else
    echo -e "Container state: ${YELLOW}STOPPED${NC}"
fi
echo -e "${BLUE}======================================================${NC}"

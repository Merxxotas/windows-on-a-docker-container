#!/bin/bash

# ==============================================================================
# Script: win-select-version.sh
# Description: Interactive CLI tool to select and switch Windows versions.
# ==============================================================================

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR" || exit 1

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}📦 WINDOWS VERSION SELECTOR${NC}"
echo -e "${BLUE}======================================================${NC}"
echo "Select the Windows edition you want to deploy:"
echo ""
echo "  1) Windows 11 Enterprise LTSC (win11-ltsc) [Default]"
echo "  2) Windows 11 Pro/Home (win11)"
echo "  3) Tiny11 Lightweight Windows 11 (tiny11)"
echo "  4) Windows 10 (win10)"
echo "  5) Windows Server 2025 (server2025)"
echo "  6) Windows Server 2022 (win2022)"
echo "  7) Windows 7 (win7)"
echo ""

read -p "Enter choice [1-7]: " choice

case $choice in
    1) VERSION="win11-ltsc" ;;
    2) VERSION="win11" ;;
    3) VERSION="tiny11" ;;
    4) VERSION="win10" ;;
    5) VERSION="server2025" ;;
    6) VERSION="win2022" ;;
    7) VERSION="win7" ;;
    *) echo -e "${YELLOW}Invalid choice, defaulting to win11-ltsc.${NC}"; VERSION="win11-ltsc" ;;
esac

echo "VERSION=$VERSION" > "$DIR/.env"

echo -e "\n${GREEN}✓ Configured Windows version to: $VERSION${NC}"
echo "Saved setting to $DIR/.env"
echo ""
echo "To apply changes:"
echo " 1. Stop current container:  ./scripts/win-stop.sh"
echo " 2. Start container:         ./scripts/win-start.sh"
echo -e "${BLUE}======================================================${NC}"

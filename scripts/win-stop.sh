#!/usr/bin/env bash
# ==============================================================================
# Script: win-stop.sh
# Description: Safely stops the Windows virtual machine and releases CPU/RAM.
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR" || exit 1

echo "🛑 Stopping Windows virtual machine..."
docker compose stop

echo "✅ Windows VM stopped successfully. RAM and CPU resources freed."

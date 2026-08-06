#!/usr/bin/env bash
# ==============================================================================
# Script: win-start.sh
# Description: Starts the Windows Docker container (if not running) and
#              launches the RDP session using xfreerdp3 with audio, clipboard,
#              and dynamic resolution support.
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR" || exit 1

echo "🔍 Checking Windows VM status..."

if ! docker ps --format '{{.Names}}' | grep -q "^windows$"; then
    echo "🚀 Starting 'windows' Docker container..."
    docker compose up -d
    echo "⏳ Waiting 5 seconds for RDP services to initialize..."
    sleep 5
else
    echo "✅ 'windows' container is already running."
fi

if command -v xfreerdp3 &> /dev/null; then
    echo "🖥️ Connecting via RDP (xfreerdp3)..."
    xfreerdp3 /v:localhost:3389 /u:merxx /p:030414 +clipboard /dynamic-resolution /sound:sys:pulse
elif command -v xfreerdp &> /dev/null; then
    echo "🖥️ Connecting via RDP (xfreerdp)..."
    xfreerdp /v:localhost:3389 /u:merxx /p:030414 +clipboard /dynamic-resolution /sound:sys:pulse
else
    echo "⚠️ Neither 'xfreerdp3' nor 'xfreerdp' binary was found."
    echo "You can connect manually via RDP to localhost:3389 (User: merxx | Pass: 030414) or use Remmina / Web UI (http://localhost:8006)."
fi

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

# Load .env variables if present
if [ -f "$DIR/.env" ]; then
    set -a
    source "$DIR/.env"
    set +a
fi

WIN_USER="${USERNAME:-merxx}"
WIN_PASS="${PASSWORD:-030414}"

if command -v xfreerdp3 &> /dev/null; then
    echo "🖥️ Connecting via RDP (xfreerdp3)..."
    xfreerdp3 /v:localhost:3389 /u:"$WIN_USER" /p:"$WIN_PASS" +clipboard /dynamic-resolution /sound:sys:pulse
elif command -v xfreerdp &> /dev/null; then
    echo "🖥️ Connecting via RDP (xfreerdp)..."
    xfreerdp /v:localhost:3389 /u:"$WIN_USER" /p:"$WIN_PASS" +clipboard /dynamic-resolution /sound:sys:pulse
else
    echo "⚠️ Neither 'xfreerdp3' nor 'xfreerdp' binary was found."
    echo "You can connect manually via RDP to localhost:3389 (User: $WIN_USER | Pass: $WIN_PASS) or use Remmina / Web UI (http://localhost:8006)."
fi

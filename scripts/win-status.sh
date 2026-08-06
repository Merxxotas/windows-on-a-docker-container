#!/usr/bin/env bash
# ==============================================================================
# Script: win-status.sh
# Description: Displays container status, CPU/RAM resource usage, and listening ports.
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR" || exit 1

echo "======================================================"
echo "📊 WINDOWS VIRTUAL MACHINE STATUS"
echo "======================================================"

if docker ps --format '{{.Names}}' | grep -q "^windows$"; then
    echo "🟢 Status: RUNNING"
    echo ""
    echo "📈 Resource Usage (CPU / RAM):"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" windows
    echo ""
    echo "🔌 Active Ports:"
    echo " - Web UI (8006): http://localhost:8006"
    echo " - RDP (3389):    localhost:3389"
else
    echo "🔴 Status: STOPPED"
    echo "Run './scripts/win-start.sh' or 'docker compose up -d' to start it."
fi
echo "======================================================"

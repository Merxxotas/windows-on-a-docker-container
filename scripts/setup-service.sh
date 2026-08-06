#!/bin/bash

# ==============================================================================
# Script: setup-service.sh
# Description: Configures and registers a systemd user service (windows-docker.service)
#              so the Windows VM container automatically starts in the background on boot.
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/windows-docker.service"

echo "⚙️ Setting up systemd user service for Windows Docker VM..."

mkdir -p "$SERVICE_DIR"

cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Windows Docker VM Container Service
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$DIR
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose stop

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload

echo "✅ Systemd service file created at: $SERVICE_FILE"
echo ""
echo "Commands to manage the background service:"
echo " - Enable on login:  systemctl --user enable windows-docker.service"
echo " - Start service:    systemctl --user start windows-docker.service"
echo " - Stop service:     systemctl --user stop windows-docker.service"
echo " - Check status:     systemctl --user status windows-docker.service"
echo ""

read -p "Would you like to enable and start this service now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    systemctl --user enable --now windows-docker.service
    echo "🚀 Service enabled and started successfully!"
fi

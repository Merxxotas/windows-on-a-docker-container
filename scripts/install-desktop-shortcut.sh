#!/bin/bash

# ==============================================================================
# Script: install-desktop-shortcut.sh
# Description: Installs a desktop shortcut launcher into ~/.local/share/applications
#              so Windows Docker can be launched directly from application menus.
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$TARGET_DIR/windows-vm.desktop"

mkdir -p "$TARGET_DIR"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Windows 11 (Docker VM)
Comment=Launch Windows Docker Container and RDP Session
Exec=/bin/bash -c "cd '$DIR' && ./scripts/win-start.sh"
Icon=virtualbox-windows
Terminal=true
Categories=System;Emulator;Utility;
Keywords=Windows;Docker;VM;KVM;RDP;
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ Desktop shortcut installed successfully!"
echo "📁 Shortcut created at: $DESKTOP_FILE"
echo "🖥️ You can now launch 'Windows 11 (Docker VM)' directly from your application menu!"

#!/usr/bin/env bash
# ==============================================================================
# Script: backup-vm.sh
# Description: Creates an instant Copy-On-Write snapshot of the VM disk (data.img)
#              using BTRFS reflink.
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR" || exit 1

BACKUP_DIR="$DIR/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/data_backup_$TIMESTAMP.img"

mkdir -p "$BACKUP_DIR"

if [ ! -f "$DIR/data.img" ]; then
    echo "❌ Error: Could not find disk image file 'data.img'."
    exit 1
fi

echo "📦 Creating instant Copy-On-Write snapshot (BTRFS Reflink)..."
echo "  Source:      $DIR/data.img"
echo "  Destination: $BACKUP_FILE"

cp --reflink=always "$DIR/data.img" "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Snapshot backup created successfully at: $BACKUP_FILE"
    echo "📁 Available backups in $BACKUP_DIR:"
    ls -lh "$BACKUP_DIR"
else
    echo "⚠️ Reflink failed, falling back to traditional sparse copy..."
    cp --sparse=always "$DIR/data.img" "$BACKUP_FILE"
    echo "✅ Sparse backup created at: $BACKUP_FILE"
fi

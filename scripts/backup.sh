#!/usr/bin/env bash
#
# Backup Valheim worlds with retention
#
set -euo pipefail

VALHEIM_DIR="/opt/valheim"
WORLD_DIR="/home/valheim/.config/unity3d/IronGate/Valheim"
BACKUP_DIR="${VALHEIM_DIR}/backups"
RETENTION="${BACKUP_RETENTION_DAYS:-7}"

mkdir -p "$BACKUP_DIR"

tar -czf "${BACKUP_DIR}/valheim-$(date +%F-%H%M).tar.gz" \
    -C "$WORLD_DIR" worlds

find "$BACKUP_DIR" -name '*.tar.gz' -mtime "+$RETENTION" -delete
echo "$(date -Is) - backup completed"
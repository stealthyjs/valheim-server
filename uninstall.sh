#!/usr/bin/env bash
#
# Remove the Valheim server completely (keeps world backups optional)
#
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: run as root (sudo ./uninstall.sh)"
    exit 1
fi

read -r -p "Also delete the game files AND worlds? [y/N]: " DELETE_ALL
read -r -p "Delete the 'valheim' user account too? [y/N]: " DELETE_USER

systemctl stop valheim 2>/dev/null || true
systemctl disable valheim 2>/dev/null || true
rm -f /etc/systemd/system/valheim.service
systemctl daemon-reload

crontab -u valheim -r 2>/dev/null || true
rm -rf /etc/valheim

if [[ "$DELETE_ALL" =~ ^[Yy]$ ]]; then
    rm -rf /opt/valheim
    rm -rf /home/valheim/.config/unity3d/IronGate/Valheim
fi
if [[ "$DELETE_USER" =~ ^[Yy]$ ]]; then
    userdel -r valheim 2>/dev/null || true
fi

echo "Uninstallation complete."
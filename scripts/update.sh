#!/usr/bin/env bash
#
# Update the Valheim server via SteamCMD
#
set -euo pipefail

STEAM_USER="valheim"
STEAMCMD_DIR="/opt/steamcmd"
VALHEIM_DIR="/opt/valheim"

echo ">>> Updating Valheim server..."
sudo -u "$STEAM_USER" "$STEAMCMD_DIR/steamcmd.sh" \
    +force_install_dir "$VALHEIM_DIR" \
    +login anonymous \
    +app_update 896660 validate \
    +quit

echo ">>> Update done. Restarting service..."
systemctl restart valheim
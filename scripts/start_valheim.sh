#!/usr/bin/env bash
#
# Valheim server launcher - called by systemd
#
set -euo pipefail
cd /opt/valheim

mkdir -p logs

export SteamAppId=892970
export LD_LIBRARY_PATH="./linux64:${LD_LIBRARY_PATH:-}"

exec ./valheim_server.x86_64 \
  -name "$SERVER_NAME" \
  -world "$WORLD_NAME" \
  -password "$SERVER_PASSWORD" \
  -port "$SERVER_PORT" \
  -public "$PUBLIC_LISTING" \
  -nographics -batchmode \
  -logFile "/opt/valheim/logs/valheim-$(date +%F).log"
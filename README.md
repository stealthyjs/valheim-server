# Valheim Dedicated Server Setup (Debian 13)

One-command interactive setup for a Valheim dedicated server on a fresh
Debian 13 install, using SteamCMD and a systemd service.

## Requirements

- Debian 13 (should work on 12 too)
- Root access (sudo)
- ~4 GB RAM (8 GB recommended), ~20 GB disk
- UDP ports 2456-2458 open (adjust to your chosen port)

## Install

```bash
git clone https://github.com/stealthyjs/valheim-server.git
cd valheim-server
chmod +x install.sh
sudo ./install.sh
```

The installer will prompt for server name, world name, password, port,
public listing and backup retention, then install everything.

## Manage

| Action | Command |
|---|---|
| Start | `sudo systemctl start valheim` |
| Stop | `sudo systemctl stop valheim` |
| Status | `systemctl status valheim` |
| Logs | `journalctl -u valheim -f` |
| Update | `sudo /opt/valheim/update.sh` |

## Updates

Valheim frequently releases patches that require updating the dedicated 
server (otherwise players with updated clients won't be able to connect).

To update the server to the latest version via SteamCMD:

```bash
sudo /opt/valheim/update.sh
```
(This script will fetch the latest update and automatically restart the systemd service).

## Backups

A nightly cron job (4 AM) backs up worlds to `/opt/valheim/backups`.

## Uninstall

```bash
sudo ./uninstall.sh
```
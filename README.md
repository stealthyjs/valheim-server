# Valheim Dedicated Server Setup (Debian 13)

One-command interactive setup for a Valheim dedicated server on a fresh
Debian 13 install, using SteamCMD and a systemd service.

## Requirements

- Debian 13 (should work on 12 too)
- **x86_64 architecture only** (ARM/aarch64 is not supported — the Valheim
  dedicated server binary won't run on it)
- Root access (sudo)
- ~4 GB RAM (8 GB recommended), ~20 GB disk
- UDP ports 2456-2458 open (adjust to your chosen port)
- If deploying inside a container (LXC, Docker) behind NAT, you'll also
  need port forwarding configured at the host level — see Troubleshooting.

## Install

```bash
git clone https://github.com/stealthyjs/valheim-server.git
cd valheim-server
chmod +x install.sh
sudo ./install.sh
```

The installer will prompt for server name, world name, password, port,
public listing and backup retention, then install everything.

**Note:** the server password must be at least 5 characters and cannot
be contained in the server name.

## Manage

| Action | Command |
|---|---|
| Start | `sudo systemctl start valheim` |
| Stop | `sudo systemctl stop valheim` |
| Status | `systemctl status valheim` |
| Logs (service) | `journalctl -u valheim -f` |
| Logs (game server) | `tail -f /opt/valheim/logs/valheim-$(date +%F).log` |
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

## Troubleshooting

**Service fails with exit code 127**
The launch script's shebang may have Windows-style line endings (CRLF).
Fix with:
```bash
sudo dos2unix /opt/valheim/start_valheim.sh
```

**Service starts then exits quickly (status 0, no obvious error)**
Check the game server's own log, not journalctl — the launch script
redirects all output there:
```bash
tail -100 /opt/valheim/logs/valheim-$(date +%F).log
```
Look for `steamclient.so: cannot open shared object file`. If present,
Steamworks can't find its SDK library. Fix with:
```bash
mkdir -p /home/valheim/.steam/sdk64
ln -sf /opt/valheim/linux64/steamclient.so /home/valheim/.steam/sdk64/steamclient.so
chown -h valheim:valheim /home/valheim/.steam/sdk64/steamclient.so
sudo systemctl restart valheim
```

**`valheim_server.x86_64: No such file or directory` after install
reports success**
SteamCMD can return a success exit code even when the download didn't
fully land in `/opt/valheim` — commonly a permissions issue. Fix and
retry:
```bash
sudo chown -R valheim:valheim /opt/valheim
sudo -u valheim /opt/steamcmd/steamcmd.sh +force_install_dir /opt/valheim \
  +login anonymous +app_update 896660 validate +quit
```

**Client shows "Incompatible version" when connecting**
The dedicated server is behind the Steam client build. Force an update:
```bash
sudo systemctl stop valheim
sudo /opt/valheim/update.sh
sudo systemctl start valheim
```

**Client hangs on "Connecting..." then times out**
Usually a network/firewall issue, not a server problem:
- Confirm the server is actually listening: `sudo ss -ulnp | grep 2456`
- If running in a container behind NAT (LXC on Proxmox, Docker bridge,
  etc.), confirm the host has a DNAT/port-forward rule sending UDP
  2456-2458 to the container's private IP — this must be configured on
  the **host**, not inside the container, and is easy to lose after a
  host reboot if it wasn't made persistent.

## Uninstall

```bash
sudo ./uninstall.sh
```
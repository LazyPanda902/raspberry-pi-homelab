# Raspberry Pi Homelab & Media Server

A sanitized portfolio version of a self-hosted Raspberry Pi homelab built for Linux administration, Docker, networking, DNS filtering, monitoring, dashboards, media services, and recovery planning.

This repository documents the architecture and operating practices without publishing secrets, private domains, production `.env` files, WireGuard keys, API tokens, or personal network details.

## What this project shows

This homelab demonstrates practical infrastructure and support skills:

- Linux server administration on Raspberry Pi hardware
- NVMe-backed storage layout and service persistence
- Docker and Docker Compose service management
- DNS filtering with AdGuard Home
- Uptime monitoring with Uptime Kuma
- Container management with Portainer
- Container log review with Dozzle
- Dashboard organization with Glance
- Media stack planning with Plex, Sonarr, Radarr, Prowlarr, qBittorrent, Jellyseerr, and Tautulli
- Backup and recovery documentation
- Sanitized public documentation practices
- Troubleshooting ports, mounts, permissions, and container restarts

## Why this repo exists

The live homelab is a private system. This public repository is the safe portfolio version.

It shows the structure, service choices, recovery notes, and security practices without exposing real production configuration. The goal is to document the engineering work clearly while keeping operational secrets private.

## Core features

- Sanitized Docker Compose example
- Service inventory and role breakdown
- High-level architecture notes
- Backup and recovery checklist
- Security publishing checklist
- Example cleanup script
- NVMe storage layout documentation
- Notes for monitoring and dashboard services
- Public-safe README and docs structure

## Hardware and platform

| Component | Details |
|---|---|
| Server | Raspberry Pi |
| Storage | NVMe-backed storage |
| Boot | SD card |
| Operating system | Debian/Linux |
| Container runtime | Docker |
| Orchestration | Docker Compose |

## Service overview

| Service | Purpose |
|---|---|
| Plex | Media streaming server |
| Jellyseerr | Media request management |
| qBittorrent | Download client |
| Sonarr | TV library automation |
| Radarr | Movie library automation |
| Prowlarr | Indexer management |
| Tautulli | Plex monitoring and watch history |
| AdGuard Home | DNS filtering and DNS query visibility |
| Glance | Homelab dashboard |
| Portainer | Docker container and stack management |
| Uptime Kuma | Service uptime monitoring |
| Dozzle | Container log viewer |
| Filebrowser | Browser-based file access |

## Storage layout

Sanitized example:

```text
/mnt/nvme
├── appdata/
├── downloads/
└── media/
    ├── movies/
    ├── tv/
    ├── music/
    └── photos/
```

The main design goal is to keep persistent application data outside containers, so services can be recreated without losing configuration or state.

## Repository structure

```text
README.md
docs/
  architecture.md
  services.md
  backup-and-recovery.md
  security-notes.md
compose-examples/
  docker-compose.example.yml
scripts/
  media-cleanup-example.sh
.gitignore
```

## Example Docker Compose services

The public compose example includes safe placeholder services:

- Glance
- Uptime Kuma
- Portainer
- AdGuard Home

The example is intentionally incomplete for production use. DNS ports, private domains, secrets, and real paths should be handled only in private configuration.

Example:

```bash
cd compose-examples
docker compose -f docker-compose.example.yml config
```

This validates Compose syntax without starting services.

## Example cleanup script

The repository includes a sanitized cleanup script:

```text
scripts/media-cleanup-example.sh
```

It is a dry-run style template. Review and modify paths before using it on a real server.

Example syntax check:

```bash
bash -n scripts/media-cleanup-example.sh
```

## Backup and recovery

The recovery plan is documented in:

```text
docs/backup-and-recovery.md
```

Recovery checklist summary:

1. Install Docker.
2. Install Docker Compose.
3. Mount NVMe storage.
4. Restore compose files.
5. Restore appdata.
6. Start services.
7. Check service ports.
8. Check Uptime Kuma monitors.
9. Check AdGuard DNS.
10. Check dashboard links.

## Security and privacy

This repo is sanitized for public portfolio use.

Never publish:

- passwords
- API keys
- private keys
- real domains
- DuckDNS tokens
- WireGuard private keys
- raw client VPN configs
- personal data
- production `.env` files
- full production compose files with secrets

Before pushing changes, run a local secret scan:

```bash
grep -R "password\|passwd\|secret\|token\|api\|key\|duckdns\|private" .
```

Also review Git history if a secret was ever committed.

## Validation checklist

Because this repository is documentation and sanitized configuration, there is no application test suite or CI pipeline yet.

Recommended manual checks before publishing updates:

```bash
docker compose -f compose-examples/docker-compose.example.yml config
bash -n scripts/media-cleanup-example.sh
grep -R "password\|passwd\|secret\|token\|api\|key\|duckdns\|private" .
```

Future improvement: add GitHub Actions CI to run Compose validation, shell syntax checks, and secret-pattern scanning.

## Lessons learned

This homelab helped build practical experience with:

- organizing Docker app data
- troubleshooting port conflicts
- maintaining service dashboards
- reviewing container logs
- documenting recovery steps
- separating public examples from private production configuration
- keeping secrets out of GitHub

## Resume bullet

Built and maintained a Raspberry Pi homelab with NVMe-backed storage and Dockerized services for media management, DNS filtering, monitoring, dashboards, and container administration using Linux, Docker, Docker Compose, Portainer, Uptime Kuma, AdGuard Home, and Glance.

## License

No open-source license is currently included. Treat this repository as portfolio documentation unless a license is added later.

# Raspberry Pi Homelab & Media Server

A self-hosted Raspberry Pi homelab built to practice Linux administration, Docker, networking, service monitoring, DNS filtering, and technical troubleshooting.

This repo is a sanitized portfolio version of the setup. It does not include passwords, API keys, private domains, WireGuard keys, or real production secrets.

## Overview

The homelab runs on a Raspberry Pi with NVMe-backed storage and Dockerized services for:

- media management
- container administration
- DNS filtering
- uptime monitoring
- service dashboards
- log viewing
- browser-based file access
- cleanup automation

## What This Project Shows

This project demonstrates hands-on experience with:

- Linux server administration
- Docker and Docker Compose
- containerized service management
- DNS filtering with AdGuard Home
- uptime monitoring with Uptime Kuma
- dashboard organization with Glance
- media stack configuration
- basic backup and recovery planning
- troubleshooting service ports, mounts, permissions, and container restarts

## Hardware

| Component | Details |
|---|---|
| Server | Raspberry Pi |
| Storage | NVMe-backed storage |
| Boot | SD card |
| Operating system | Debian/Linux |
| Container runtime | Docker |
| Compose | Docker Compose |

## Storage Layout

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

## Services

| Service | Purpose |
|---|---|
| Plex | Media server |
| Jellyseerr | Media request management |
| qBittorrent | Download client |
| Sonarr | TV automation |
| Radarr | Movie automation |
| Prowlarr | Indexer management |
| Tautulli | Plex monitoring and watch history |
| AdGuard Home | DNS filtering |
| Glance | Homelab dashboard |
| Portainer | Docker container management |
| Uptime Kuma | Uptime and service monitoring |
| Dozzle | Container log viewer |
| Filebrowser | Browser-based file access |

## Network and Monitoring

The setup includes:

- service monitoring through Uptime Kuma
- dashboard links and service status through Glance
- container management through Portainer
- DNS filtering through AdGuard Home
- container log review through Dozzle

## Automation

The homelab includes cleanup and maintenance scripts for media management and routine housekeeping. Public examples in this repo are sanitized and should be treated as templates.

## Security Notes

This public repo intentionally excludes:

- passwords
- API keys
- private keys
- real domains
- WireGuard configs
- personal network details
- full production compose files with secrets
- `.env` files

Before publishing any homelab repo, always check:

```bash
grep -R "password\|passwd\|secret\|token\|api\|key\|duckdns\|private" .
```

## Repo Structure

```text
.
├── README.md
├── docs/
│   ├── architecture.md
│   ├── services.md
│   ├── backup-and-recovery.md
│   └── security-notes.md
├── compose-examples/
│   └── docker-compose.example.yml
├── scripts/
│   └── media-cleanup-example.sh
└── .gitignore
```

## Resume Bullet

Built and maintained a Raspberry Pi homelab with NVMe-backed storage and Dockerized services for media management, DNS filtering, monitoring, dashboards, and container administration using Linux, Docker, Docker Compose, Portainer, Uptime Kuma, AdGuard Home, and Glance.

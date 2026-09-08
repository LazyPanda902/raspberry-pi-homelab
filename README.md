# Raspberry Pi Homelab

This project demonstrates verified Linux, Docker, storage, DNS, monitoring, and support practices on a Raspberry Pi 5.

[![CI](https://img.shields.io/github/actions/workflow/status/LazyPanda902/raspberry-pi-homelab/ci.yml?label=CI)](https://github.com/LazyPanda902/raspberry-pi-homelab/actions)
![Bash](https://img.shields.io/badge/Bash-5.2-4EAA25?logo=gnubash&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## What problem this solves

A small server can host many useful services, but support becomes difficult when nobody can quickly answer basic questions. Is the host healthy? Are containers running? Is persistent state on the expected disk? Will a service restart after a reboot? Which interfaces expose an administrative page?

This repository provides a read-only audit, safe cleanup tooling, tests, and operating notes for answering those questions. It also records a change method for troubleshooting containers, checking logs, validating storage, monitoring failures, and rolling back an unsuccessful change.

## Demo

This shortened output was generated on the Raspberry Pi with `scripts/homelab-audit.sh --public`:

```text
# Platform
OS: Debian GNU/Linux 13 (trixie)
Architecture: aarch64
Model: Raspberry Pi 5 Model B Rev 1.1
Memory: total=7.9Gi, available=5.7Gi

# Storage
Root storage: size=117G, used=70G, available=43G, utilization=63%
NVMe device: present
NVMe storage: size=916G, used=31G, available=839G, utilization=4%

# Docker
Docker: available
Docker data root: /mnt/nvme/docker-data
Running containers: 13

# Host services
Failed systemd units: 0
WireGuard interface: present
Ollama service: active
```

The full captured report is in [docs/sample-output.md](docs/sample-output.md).

## Hardware and platform

| Component | Verified detail |
|---|---|
| Board | Raspberry Pi 5 Model B Rev 1.1 |
| Operating system | Debian GNU/Linux 13 |
| Architecture | ARM64, reported as aarch64 |
| Memory | Approximately 8 GB |
| Boot and root | SD card |
| Persistent service storage | Approximately 1 TB NVMe mounted at `/mnt/nvme` |
| Docker data root | `/mnt/nvme/docker-data` |

## Services

The following inventory was verified on 2026-09-07. Exposure describes host port binding, not application authentication or firewall policy.

| Service | Purpose | Exposure classification | Restart policy |
|---|---|---|---|
| AdGuard Home | DNS filtering | all-interfaces | unless-stopped |
| Caddy | Reverse proxy for one application | all-interfaces | unless-stopped |
| cAdvisor | Container metrics | all-interfaces | unless-stopped |
| Node Exporter | Host metrics | all-interfaces | unless-stopped |
| Prometheus | Metrics collection | all-interfaces | unless-stopped |
| Grafana | Metrics dashboards | all-interfaces | unless-stopped |
| Uptime Kuma | Availability monitoring | all-interfaces | unless-stopped |
| Portainer | Container management | all-interfaces | unless-stopped |
| Dozzle | Container log review | all-interfaces | unless-stopped |
| Filebrowser | Browser-based file management | all-interfaces | unless-stopped |
| Glance | Service dashboard | all-interfaces | unless-stopped |
| DealRadar API | Local application API | loopback | unless-stopped |
| Snowflake | Tor Snowflake proxy | no-published-port | unless-stopped |

See [docs/services.md](docs/services.md) for categories, runtime state, and health-check status.

## Architecture

The [architecture guide](docs/architecture.md) includes a Mermaid diagram of the LAN, WireGuard path, DNS, reverse proxy, containers, monitoring, Ollama, and NVMe storage.

## Operations

Changes follow a small-step method: inspect, back up, record a baseline, change one component, validate, restart only what changed, check health and logs, verify dependencies, and roll back on failure. Commands and verification points are in [docs/operations.md](docs/operations.md).

## Backup and recovery

The recovery plan separates configuration from container images, treats the NVMe mount as a startup dependency, and restores DNS, proxy, monitoring, management, then applications. No tested-restore date or off-device backup target is claimed because neither could be verified safely. See [docs/backup-and-recovery.md](docs/backup-and-recovery.md).

## Security

Verified controls include loopback-only Ollama, a present WireGuard interface, one encrypted DNS-over-HTTPS upstream, public-repo sanitization, excluded `.env` files, and persistent Docker state on NVMe. No DNS-over-TLS upstream was found.

Several administrative web services currently publish on all interfaces. This is documented as exposure, not as a security strength. Authentication and firewall behavior were not inferred from port bindings. See [docs/security.md](docs/security.md).

## Testing

```bash
bash -n scripts/*.sh
shellcheck scripts/*.sh
bats tests/
docker compose -f compose-examples/docker-compose.example.yml config
```

The suite contains 32 Bats tests. CI runs all four checks and validates Markdown links.

## Roadmap

- Restrict administrative services to loopback, a defined LAN policy, or VPN-specific bindings where appropriate.
- Expand restore verification automation and record the first completed restore exercise.
- Add automated configuration-drift reporting without collecting secrets.

## License

MIT. See [LICENSE](LICENSE).

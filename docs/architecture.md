# Architecture

## High-Level Layout

```text
User devices
   |
Home network
   |
Raspberry Pi homelab
   |
Docker services
   |
NVMe storage
```

## Main System Areas

### Storage

The homelab uses NVMe-backed storage mounted under `/mnt/nvme`.

Sanitized folder layout:

```text
/mnt/nvme
├── appdata/
├── downloads/
└── media/
```

### Docker

Services are containerized and managed with Docker and Docker Compose.

Common service categories:

- media services
- monitoring services
- networking/DNS services
- dashboard services
- admin tools

### Monitoring

Uptime Kuma monitors service availability. Dozzle provides container log visibility. Glance provides a dashboard for service links and system status.

### DNS

AdGuard Home is used for DNS filtering and query visibility.

## Design Goals

- keep services containerized
- store persistent app data outside containers
- monitor core services
- document recovery steps
- keep secrets out of public repos

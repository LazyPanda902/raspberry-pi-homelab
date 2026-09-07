# Services

This inventory was collected from the running Docker engine on 2026-09-07. Docker environment variables and full configuration were not inspected. Health `not-configured` means the image has no Docker health check. It does not by itself mean the service is unhealthy.

| Name | Role | Category | Runtime state | Health | Restart policy | Exposure classification |
|---|---|---|---|---|---|---|
| adguardhome | DNS filtering and query handling | Networking | running | not-configured | unless-stopped | all-interfaces |
| datequiz-caddy | Reverse proxy for an application | Infrastructure | running | not-configured | unless-stopped | all-interfaces |
| cadvisor | Container resource metrics | Monitoring | running | healthy | unless-stopped | all-interfaces |
| node-exporter | Host resource metrics | Monitoring | running | not-configured | unless-stopped | all-interfaces |
| prometheus | Metrics collection and queries | Monitoring | running | not-configured | unless-stopped | all-interfaces |
| grafana | Metrics dashboards | Monitoring | running | not-configured | unless-stopped | all-interfaces |
| uptime-kuma | Service availability checks | Monitoring | running | healthy | unless-stopped | all-interfaces |
| portainer | Container administration | Management | running | not-configured | unless-stopped | all-interfaces |
| dozzle | Container log review | Management | running | not-configured | unless-stopped | all-interfaces |
| filebrowser | Browser-based file management | Management | running | healthy | unless-stopped | all-interfaces |
| glance | Service dashboard | Management | running | not-configured | unless-stopped | all-interfaces |
| dealradar-api | Local application API | Applications | running | healthy | unless-stopped | loopback |
| snowflake | Tor Snowflake proxy | Networking | running | not-configured | unless-stopped | no-published-port |

## Exposure definitions

- `all-interfaces` means at least one Docker host port binding used a wildcard host address.
- `loopback` means the published host binding was restricted to loopback.
- `specific-interface` means a non-wildcard and non-loopback host binding was present. The address is intentionally not published.
- `no-published-port` means Docker reported no host port binding.

These classifications do not establish reachability through a firewall, authentication strength, TLS use, or application authorization. Those require separate checks.

# Sample Output

This output was generated on the Raspberry Pi with `scripts/homelab-audit.sh --public` on 2026-09-07. It is a point-in-time observation, not an uptime or availability guarantee.

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
NAME|STATE|HEALTH|RESTART POLICY
adguardhome|running|not-configured|unless-stopped
cadvisor|running|healthy|unless-stopped
datequiz-caddy|running|not-configured|unless-stopped
dealradar-api|running|healthy|unless-stopped
dozzle|running|not-configured|unless-stopped
filebrowser|running|healthy|unless-stopped
glance|running|not-configured|unless-stopped
grafana|running|not-configured|unless-stopped
node-exporter|running|not-configured|unless-stopped
portainer|running|not-configured|unless-stopped
prometheus|running|not-configured|unless-stopped
snowflake|running|not-configured|unless-stopped
uptime-kuma|running|healthy|unless-stopped

# Host services
Failed systemd units: 0
WireGuard interface: present
Ollama service: active
```

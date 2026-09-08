# Operations

The operating method favors small, reversible changes with recorded evidence.

1. Inspect current state.
2. Save configuration or create a backup.
3. Record a baseline.
4. Change one component.
5. Validate syntax and configuration.
6. Reload or restart only the necessary service.
7. Verify service health.
8. Inspect recent logs.
9. Verify dependent services.
10. Roll back if verification fails.

## Baseline

```bash
scripts/homelab-audit.sh --public > <BASELINE_FILE>
docker compose -f <PRIVATE_COMPOSE_FILE> config --quiet
systemctl --failed
```

Keep the unredacted baseline local and access-controlled. Use the public mode before sharing output.

## Single-service container change

```bash
docker compose -f <PRIVATE_COMPOSE_FILE> config --quiet
docker compose -f <PRIVATE_COMPOSE_FILE> up -d <SERVICE>
docker compose -f <PRIVATE_COMPOSE_FILE> ps <SERVICE>
docker compose -f <PRIVATE_COMPOSE_FILE> logs --since 10m <SERVICE>
```

Check the service health state when configured. Then test one representative dependency, such as a dashboard query, DNS lookup, or proxied request. Do not restart the whole stack when only one service changed.

## systemd service change

```bash
systemctl status <SERVICE>.service
systemd-analyze verify <UNIT_FILE>
systemctl reload-or-restart <SERVICE>.service
systemctl is-active <SERVICE>.service
journalctl -u <SERVICE>.service --since "10 minutes ago"
```

Use elevated privileges only where local policy requires them. Never paste credentials or private configuration into an issue.

## Storage check

```bash
findmnt /mnt/nvme
docker info --format '{{.DockerRootDir}}'
df -h / /mnt/nvme
```

Confirm the NVMe mount before starting Docker after storage maintenance. If validation fails, stop the change, preserve logs, restore the saved configuration, and repeat the same health and dependency checks.

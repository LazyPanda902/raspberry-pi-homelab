# Backup and Recovery Notes

## Backup Goals

The backup plan should preserve:

- Docker compose files
- app configuration folders
- dashboard configuration
- monitoring configuration
- scripts
- recovery notes

## Suggested Backup Items

```text
~/docker
~/scripts
~/backups
/mnt/nvme/appdata
```

## Safe Backup Command Example

```bash
mkdir -p ~/backups
tar -czf ~/backups/homelab-backup-YYYY-MM-DD.tar.gz ~/docker ~/scripts
sha256sum ~/backups/homelab-backup-YYYY-MM-DD.tar.gz
```

## Recovery Checklist

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

## Do Not Commit

Do not commit:

- backup archives
- `.env` files
- API keys
- private keys
- passwords
- exported WireGuard configs

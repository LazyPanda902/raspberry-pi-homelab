# Backup and Recovery

This is a recovery procedure, not a claim of a completed restore exercise. The inspected evidence confirms NVMe-backed Docker state and repository-held public examples. It does not safely establish an off-device backup destination, backup schedule, retention policy, or tested-restore date.

## Data to protect

| Data | Why it matters | Recovery note |
|---|---|---|
| Private Compose and service configuration | Recreates service definitions and bindings | Keep secrets outside this public repository |
| Application configuration and persistent volumes | Holds service state | Back up consistently while applications are stopped or using an application-aware method |
| Monitoring configuration | Recreates scrape targets and alerts | Restore before using monitoring as verification evidence |
| Dashboard configuration | Restores operational views | Treat exported dashboards and data-source settings separately |
| Local administration scripts | Restores repeatable checks | Keep reviewed copies under version control where safe |
| Docker data state | Holds engine-managed layers and volumes | Docker currently depends on `/mnt/nvme/docker-data` |
| Project documentation | Provides recovery order and checks | Clone or restore independently of the failed host |

Container images should normally be pulled again from their registries. Locally built images need a reproducible build context or a separately managed export.

## Backup preparation

1. Confirm the NVMe mount is present and has sufficient free space.
2. Record `docker ps` and the expected service inventory.
3. Validate private Compose files before stopping anything.
4. Identify bind mounts and named volumes without printing environment values.
5. Stop only services that require a consistent offline copy.
6. Copy configuration and persistent data to an approved backup target.
7. Generate checksums and store them separately from the archive.
8. Restart stopped services and verify health, logs, and dependencies.

No backup destination is named here because one was not verified for safe public disclosure.

## Restore order

1. Restore the base operating system and required packages.
2. Mount NVMe storage at the expected mount point before Docker starts.
3. Confirm Docker uses `/mnt/nvme/docker-data`.
4. Restore private Compose files, secret files, and service configuration from the approved source.
5. Restore persistent application and monitoring data with original ownership and permissions.
6. Validate Compose files with `docker compose config`.
7. Start DNS and required network services.
8. Start the reverse proxy and monitoring stack.
9. Start management services, then application services.
10. Verify containers, health checks, logs, DNS resolution, dashboards, and dependent workflows.

## Post-restore verification

```bash
scripts/homelab-audit.sh --public
docker compose -f <PRIVATE_COMPOSE_FILE> config --quiet
systemctl --failed
systemctl is-active ollama
```

Compare the new audit with a known baseline. Confirm expected container count, restart policies, health states, Docker data root, and disk utilization. A successful process exit is not enough if a dependent service cannot complete a representative request.

## Restore evidence gap

No safe evidence of a completed restore drill was found during this rebuild. The roadmap includes automating and recording restore verification. Until that happens, this document should be treated as a reviewed procedure only.

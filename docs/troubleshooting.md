# Troubleshooting

Only incidents supported by available evidence are documented.

## Evidence review result

No incident met the evidence threshold during this repository rebuild. The review covered repository Git history, existing documentation, current Docker state, filtered Docker service journal entries, failed systemd unit state, storage layout, and current service bindings.

The journal contained error messages, but the available records did not establish a complete cause, applied fix, and post-fix verification. They are therefore not presented as resolved incidents.

## Container is not running

```bash
docker compose -f <PRIVATE_COMPOSE_FILE> ps
docker inspect --format '{{.State.Status}}' <CONTAINER>
docker logs --since 15m <CONTAINER>
```

Check image availability, mount paths, permissions, port conflicts, and dependency readiness. Do not inspect or paste container environment values. After a fix, verify the container state, configured health check, logs, restart policy, and a representative request.

## Published port is unexpected

```bash
docker port <CONTAINER>
docker inspect --format '{{json .HostConfig.PortBindings}}' <CONTAINER>
```

Classify the result as all-interfaces, loopback, specific-interface, or no-published-port. Review both IPv4 and IPv6 bindings. Validate Compose before recreating only the affected service.

## DNS requests fail

```bash
docker ps --filter name=adguardhome
docker logs --since 15m adguardhome
```

Check container state, upstream reachability, configured upstream type, and client behavior without publishing query logs or upstream URLs. Current configuration inspection found one DoH upstream and zero DoT upstreams.

## Docker data root or NVMe is unavailable

```bash
findmnt /mnt/nvme
docker info --format '{{.DockerRootDir}}'
df -h /mnt/nvme
systemctl --failed
```

The verified Docker root is under `/mnt/nvme`. Treat a missing mount or unexpected Docker root as a stop condition. Avoid starting services that could create replacement paths on the SD root filesystem.

## Dashboard reports a service down

Confirm the monitor target, then compare the application health check, container state, recent logs, proxy state, and DNS resolution. A green container state does not prove the full request path works. Record each layer checked and the final representative request.

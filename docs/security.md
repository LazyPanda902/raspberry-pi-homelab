# Security

This document separates verified controls from exposure and future work. Port binding alone does not prove firewall reachability, authentication, or encryption.

## Verified controls

- Ollama is an active systemd service with a loopback-only listener.
- A WireGuard interface is present.
- AdGuard Home has one DNS-over-HTTPS upstream configured.
- Zero DNS-over-TLS upstreams were detected.
- Docker persistent state is stored on the NVMe device rather than the SD root filesystem.
- The public repository excludes production `.env` files, credentials, VPN configurations, and secret-bearing service configuration.
- Public audit output passes through `sanitize-output.sh`.

The WireGuard interface presence is evidence that a VPN path exists. It is not evidence that Docker services are bound only to that path.

## Verified exposures

The following administrative or monitoring services currently publish a Docker port on all interfaces:

- Portainer
- Uptime Kuma
- Dozzle
- Filebrowser
- Grafana
- Prometheus
- Glance

AdGuard Home, cAdvisor, Node Exporter, and the verified Caddy container also have all-interface bindings. DealRadar API is loopback-bound. Snowflake has no published Docker port.

All-interface is a current exposure classification, not a security claim. Restricting administrative services to loopback, a defined LAN interface policy, or a VPN-specific binding is a future hardening option. Any change requires dependency testing to avoid breaking dashboards, monitoring, or operator access.

## Credential handling

- Keep production secrets in private files or a secret-management mechanism outside Git.
- Set restrictive file permissions and grant access only to the service account that needs them.
- Never place tokens on command lines that may enter shell history or process listings.
- Rotate a credential if it is exposed. Removing it from the latest commit does not remove it from Git history.
- Do not commit WireGuard keys, peer configurations, authentication cookies, private hostnames, or real network addresses.

## Public-repository sanitization

Use `<HOSTNAME>`, `<VPN_INTERFACE>`, `<REDACTED>`, `server-lab`, and `example.internal` in examples. Run generated diagnostics through `scripts/sanitize-output.sh`, then review the result manually. Automated redaction reduces risk but cannot understand every custom secret format.

The sanitizer handles common IP addresses, hostnames, URLs, email addresses, credential assignments, bearer values, GitHub token formats, and private-key blocks. It writes to standard output and does not overwrite its input.

## Change review

Before pushing, review the complete diff and search tracked files for token prefixes, authorization headers, assignments that contain secrets, private-key headers, VPN material, `.env` values, private addresses, personal identifiers, and production hostnames. Treat each result as a review lead, not automatic proof of a leak.

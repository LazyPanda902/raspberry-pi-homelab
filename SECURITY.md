# Security Policy

## Reporting an issue

Use the repository's private security advisory feature for a suspected vulnerability. Use a normal issue only when the report contains no live secret, private address, personal data, or sensitive configuration.

Do not submit credentials, tokens, private keys, production `.env` files, VPN client configuration, authentication cookies, or unredacted diagnostic output. Revoke and rotate any credential that may have been exposed.

## Script scope

The audit script reads operating system, architecture, memory, disk, Docker, systemd, WireGuard interface presence, and Ollama service state. It does not dump process environments or Docker environment variables. The cleanup script lists matching files by default and requires `--execute` before deletion.

These scripts are intended for local administration. Review them and the generated output before use on a different system.

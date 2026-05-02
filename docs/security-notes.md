# Security Notes

This repo is sanitized for portfolio use.

## Do Not Publish

Never publish:

- passwords
- API keys
- private keys
- real domains
- DuckDNS tokens
- WireGuard private keys
- raw client VPN configs
- personal data
- full production `.env` files

## Recommended Public Repo Practice

Use examples like:

```text
PASSWORD=change_me
API_KEY=replace_me
DOMAIN=example.duckdns.org
LAN_IP=<PI_LAN_IP>
```

## Pre-Push Secret Check

Run:

```bash
grep -R "password\|passwd\|secret\|token\|api\|key\|duckdns\|private" .
```

Also check Git history if secrets were ever committed.

## Safer GitHub Content

Good to publish:

- sanitized README
- architecture notes
- service list
- screenshots with private info blurred
- example compose files
- recovery checklist
- lessons learned

Bad to publish:

- full production configs
- secrets
- account names
- private IP-sensitive screenshots
- active tunnel/VPN configs

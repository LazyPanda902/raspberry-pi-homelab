# Contributing

Create a focused branch, make one reviewable change, and open a pull request against `main`. Explain the operational effect, validation performed, and rollback approach where relevant.

Before opening a pull request, run:

```bash
bash -n scripts/*.sh
shellcheck scripts/*.sh
bats tests/
docker compose -f compose-examples/docker-compose.example.yml config
```

Review the complete diff for credentials, private addresses, hostnames, personal data, and production configuration. Add or update Bats tests for script behavior. Examples must stay sanitized and must not imply controls or recovery results that were not verified.

# Usage Examples

These examples were checked against the implemented command-line interfaces.

## Read-only audit

Run a local report:

```bash
scripts/homelab-audit.sh
```

Generate a public, sanitized report:

```bash
scripts/homelab-audit.sh --public
```

The audit does not change the host. Missing optional tools are reported as unavailable rather than causing destructive fallback behavior.

## Sanitize diagnostic text

Read standard input:

```bash
printf '%s\n' 'host 192.0.2.15' | scripts/sanitize-output.sh
```

Read a file and write a separate result:

```bash
scripts/sanitize-output.sh <LOCAL_REPORT> > <SANITIZED_REPORT>
```

The input file is never overwritten. Review sanitized output before sharing because custom secret formats may not match an automated rule.

## Preview temporary-file cleanup

Dry run is the default:

```bash
scripts/safe-cleanup.sh --target <APP_TEMP_DIRECTORY> --older-than 7
```

After reviewing the exact dry-run list, explicitly request execution:

```bash
scripts/safe-cleanup.sh --target <APP_TEMP_DIRECTORY> --older-than 7 --execute
```

The script considers only files named `*.tmp`, stays on one filesystem, rejects symbolic-link targets, and refuses broad system paths. Tests never delete files.

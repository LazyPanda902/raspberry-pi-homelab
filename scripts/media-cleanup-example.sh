#!/usr/bin/env bash
# Sanitized example cleanup script.
# Do not use this directly without reviewing paths and logic.

set -euo pipefail

MEDIA_DIR="/mnt/nvme/media"
LOG_FILE="$HOME/scripts/media_cleanup.log"

echo "[$(date)] Starting cleanup dry run" >> "$LOG_FILE"

# Example only. Replace with your real safe cleanup logic.
find "$MEDIA_DIR" -type f -name "*.tmp" -print >> "$LOG_FILE"

echo "[$(date)] Cleanup dry run complete" >> "$LOG_FILE"

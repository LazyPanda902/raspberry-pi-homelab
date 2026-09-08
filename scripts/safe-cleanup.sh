#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: safe-cleanup.sh --target DIRECTORY [--older-than DAYS] [--execute]

Find .tmp files beneath an explicitly supplied directory. The default is a dry run.
Use --execute to delete only the files that the dry run would list.
EOF
}

target=
older_than=7
execute=false

while (( $# > 0 )); do
  case $1 in
    --target)
      if (( $# < 2 )) || [[ -z $2 ]]; then
        printf 'Error: --target requires a directory.\n' >&2
        exit 2
      fi
      target=$2
      shift 2
      ;;
    --older-than)
      if (( $# < 2 )) || [[ ! $2 =~ ^[0-9]+$ ]]; then
        printf 'Error: --older-than requires a non-negative integer.\n' >&2
        exit 2
      fi
      older_than=$2
      shift 2
      ;;
    --execute)
      execute=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Error: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z $target ]]; then
  printf 'Error: --target is required and cannot be empty.\n' >&2
  exit 2
fi

if [[ ! -d $target || -L $target ]]; then
  printf 'Error: target must be an existing directory and not a symbolic link.\n' >&2
  exit 1
fi

canonical_target=$(readlink -f -- "$target") || {
  printf 'Error: target could not be canonicalized.\n' >&2
  exit 1
}

case $canonical_target in
  /|/home|/mnt|/mnt/nvme|/tmp)
    printf 'Error: refusing protected target: %s\n' "$canonical_target" >&2
    exit 1
    ;;
  /etc|/etc/*|/usr|/usr/*|/var|/var/*)
    printf 'Error: refusing protected system tree: %s\n' "$canonical_target" >&2
    exit 1
    ;;
  /home/*|/mnt/nvme/*|/tmp/*)
    ;;
  *)
    printf 'Error: target is outside an approved cleanup tree: %s\n' "$canonical_target" >&2
    exit 1
    ;;
esac

if [[ $canonical_target != /* ]]; then
  printf 'Error: canonical target is not absolute.\n' >&2
  exit 1
fi

if [[ $execute == true ]]; then
  printf 'Mode: execute\nTarget: %s\n' "$canonical_target"
  find "$canonical_target" -xdev -type f -name '*.tmp' -mtime "+$older_than" -print -delete
else
  printf 'Mode: dry-run\nTarget: %s\n' "$canonical_target"
  find "$canonical_target" -xdev -type f -name '*.tmp' -mtime "+$older_than" -print
fi

#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sanitize-output.sh [FILE]

Read text from FILE or standard input and write a sanitized copy to standard output.
The input file is never modified.
EOF
}

if (( $# > 1 )); then
  usage >&2
  exit 2
fi

if (( $# == 1 )); then
  case $1 in
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      printf 'Error: unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac

  if [[ ! -f $1 || ! -r $1 ]]; then
    printf 'Error: input must be a readable regular file.\n' >&2
    exit 1
  fi
  input=$1
else
  input=/dev/stdin
fi

command -v perl >/dev/null 2>&1 || {
  printf 'Error: perl is required for fail-closed sanitization.\n' >&2
  exit 1
}

perl -Mstrict -MSocket=AF_INET6,inet_pton -0777 -pe '
  s{-----BEGIN [^-\n]*PRIVATE KEY-----.*?-----END [^-\n]*PRIVATE KEY-----}{<PRIVATE_KEY_REDACTED>}gs;
  s{\b(?:github_pat_[A-Za-z0-9_]{20,}|gh[pousr]_[A-Za-z0-9]{20,})\b}{<SECRET_REDACTED>}g;
  s{\bBearer\s+[^\s,;\x27\x22]+}{Bearer <SECRET_REDACTED>}gi;
  s{\b((?:password|passwd|secret|api[_-]?key|token|username|user)\s*[:=]\s*)[^\s,;\x27\x22]+}{$1<SECRET_REDACTED>}gi;
  s{\b[A-Z0-9._%+-]+\@[A-Z0-9.-]+\.[A-Z]{2,}\b}{<EMAIL_REDACTED>}gi;
  s{\b(?:https?|ftp)://[^\s<>()]+}{<URL_REDACTED>}gi;
  s{(?<![A-Fa-f0-9:])([A-Fa-f0-9:]*:[A-Fa-f0-9:]+)(?![A-Fa-f0-9:])}{inet_pton(AF_INET6, $1) ? "<IP_REDACTED>" : $1}ge;
  s{(?<![A-Za-z0-9_.-])(?:25[0-5]|2[0-4]\d|1?\d?\d)(?:\.(?:25[0-5]|2[0-4]\d|1?\d?\d)){3}(?![A-Za-z0-9_.-])}{<IP_REDACTED>}g;
  s{\b(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+(?:com|net|org|io|dev|cloud|internal|local|lan|example|duckdns\.org)\b}{<HOST_REDACTED>}gi;
' "$input"

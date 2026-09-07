#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
public=false

usage() {
  cat <<'EOF'
Usage: homelab-audit.sh [--public]

Run a read-only local health audit. Use --public to sanitize the report.
Exit codes: 0 report completed, 1 report generation failed, 2 invalid arguments.
EOF
}

if (( $# > 1 )); then
  usage >&2
  exit 2
fi

if (( $# == 1 )); then
  case $1 in
    --public) public=true ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Error: unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
fi

tmp_report=$(mktemp)
trap 'rm -f -- "$tmp_report"' EXIT

write_report() {
  local os=unknown model=unavailable memory=unavailable
  local root_use=unavailable nvme=absent docker_state=unavailable
  local docker_root=unavailable running_count=unavailable failed_units=unavailable
  local wireguard=absent ollama=unavailable

  if [[ -r /etc/os-release ]]; then
    os=$(awk -F= '$1 == "PRETTY_NAME" {gsub(/^"|"$/, "", $2); print $2}' /etc/os-release)
  fi
  if [[ -r /proc/device-tree/model ]]; then
    model=$(tr -d '\0' </proc/device-tree/model)
  fi
  if command -v free >/dev/null 2>&1; then
    memory=$(free -h | awk '$1 == "Mem:" {print "total=" $2 ", available=" $7}')
  fi
  if command -v df >/dev/null 2>&1; then
    root_use=$(df -hP / | awk 'NR == 2 {print "size=" $2 ", used=" $3 ", available=" $4 ", utilization=" $5}')
  fi
  if command -v lsblk >/dev/null 2>&1 && lsblk -ndo NAME,TYPE | awk '$1 ~ /^nvme/ && $2 == "disk" {found=1} END {exit !found}'; then
    nvme=present
  fi
  if command -v systemctl >/dev/null 2>&1; then
    failed_units=$(systemctl --failed --no-legend --plain 2>/dev/null | wc -l | tr -d ' ')
    ollama=$(systemctl is-active ollama 2>/dev/null || true)
    [[ -n $ollama ]] || ollama=inactive
  fi
  if command -v ip >/dev/null 2>&1 && ip link show wg0 >/dev/null 2>&1; then
    wireguard=present
  fi

  printf '%s\n' '# Platform'
  printf 'OS: %s\nArchitecture: %s\nModel: %s\nMemory: %s\n\n' "$os" "$(uname -m)" "$model" "$memory"
  printf '%s\n' '# Storage'
  printf 'Root storage: %s\nNVMe device: %s\n' "$root_use" "$nvme"
  if [[ -d /mnt/nvme ]] && command -v df >/dev/null 2>&1; then
    df -hP /mnt/nvme | awk 'NR == 2 {print "NVMe storage: size=" $2 ", used=" $3 ", available=" $4 ", utilization=" $5}'
  else
    printf 'NVMe storage: unavailable\n'
  fi
  printf '\n%s\n' '# Docker'
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    docker_state=available
    docker_root=$(docker info --format '{{.DockerRootDir}}' 2>/dev/null || printf 'unavailable')
    running_count=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
  fi
  printf 'Docker: %s\nDocker data root: %s\nRunning containers: %s\n' "$docker_state" "$docker_root" "$running_count"
  printf '%s\n' 'NAME|STATE|HEALTH|RESTART POLICY'
  if [[ $docker_state == available ]]; then
    local id name state health restart container_record
    while IFS= read -r container_record; do
      id=${container_record%%|*}
      name=${container_record#*|}
      [[ -n $id ]] || continue
      state=$(docker inspect --format '{{.State.Status}}' "$id" 2>/dev/null)
      health=$(docker inspect --format '{{json .State.Health}}' "$id" 2>/dev/null || true)
      if [[ -z $health || $health == null ]]; then
        health=not-configured
      else
        health=$(docker inspect --format '{{.State.Health.Status}}' "$id" 2>/dev/null)
      fi
      restart=$(docker inspect --format '{{.HostConfig.RestartPolicy.Name}}' "$id" 2>/dev/null)
      printf '%s|%s|%s|%s\n' "$name" "$state" "$health" "${restart:-none}"
    done < <(docker ps --format '{{.ID}}|{{.Names}}' 2>/dev/null | sort -t '|' -k2,2)
  fi
  printf '\n%s\n' '# Host services'
  printf 'Failed systemd units: %s\nWireGuard interface: %s\nOllama service: %s\n' "$failed_units" "$wireguard" "$ollama"
}

if ! write_report >"$tmp_report"; then
  printf 'Error: audit report generation failed.\n' >&2
  exit 1
fi

if [[ $public == true ]]; then
  if [[ ! -x $script_dir/sanitize-output.sh ]]; then
    printf 'Error: public mode requires executable sanitize-output.sh.\n' >&2
    exit 1
  fi
  "$script_dir/sanitize-output.sh" "$tmp_report"
else
  command cat -- "$tmp_report"
fi

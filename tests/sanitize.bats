#!/usr/bin/env bats

setup() {
  SCRIPT="$BATS_TEST_DIRNAME/../scripts/sanitize-output.sh"
}

@test "redacts IPv4 addresses" {
  run bash -c "printf '%s\\n' 'server 192.168.1.25 ready' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$output" = "server <IP_REDACTED> ready" ]
}

@test "redacts IPv6 addresses" {
  run bash -c "printf '%s\\n' 'peer 2001:db8::5 ready' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == *"<IP_REDACTED>"* ]]
  [[ "$output" != *"2001:db8"* ]]
}

@test "redacts hostnames" {
  run bash -c "printf '%s\\n' 'real-host.example' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$output" = "<HOST_REDACTED>" ]
}

@test "redacts GitHub tokens" {
  run bash -c "printf '%s\\n' 'ghp_abcdefghijklmnopqrstuvwxyz123456' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$output" = "<SECRET_REDACTED>" ]
}

@test "redacts bearer values" {
  run bash -c "printf '%s\\n' 'Authorization: Bearer abc.def.ghi' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Bearer <SECRET_REDACTED>"* ]]
  [[ "$output" != *"abc.def.ghi"* ]]
}

@test "redacts password assignments" {
  run bash -c "printf '%s\\n' 'password=hunter2' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$output" = "password=<SECRET_REDACTED>" ]
}

@test "redacts private key blocks" {
  run bash -c "printf '%s\\n' '-----BEGIN PRIVATE KEY-----' 'private-material' '-----END PRIVATE KEY-----' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$output" = "<PRIVATE_KEY_REDACTED>" ]
}

@test "preserves ordinary diagnostic text and versions" {
  run bash -c "printf '%s\\n' 'Docker 29.7.2 is available' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$output" = "Docker 29.7.2 is available" ]
}

@test "preserves timestamps" {
  run bash -c "printf '%s\\n' '2026-09-07T12:34:56-05:00' | '$SCRIPT'"
  [ "$status" -eq 0 ]
  [ "$output" = "2026-09-07T12:34:56-05:00" ]
}

@test "reads a file without modifying it" {
  input="$BATS_TEST_TMPDIR/input.txt"
  printf '%s\n' 'host 192.0.2.15' >"$input"
  run "$SCRIPT" "$input"
  [ "$status" -eq 0 ]
  [[ "$output" == *"<IP_REDACTED>"* ]]
  grep -q '192.0.2.15' "$input"
}

@test "rejects an unreadable or missing file" {
  run "$SCRIPT" "$BATS_TEST_TMPDIR/missing"
  [ "$status" -eq 1 ]
}

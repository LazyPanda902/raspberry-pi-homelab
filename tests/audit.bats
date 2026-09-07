#!/usr/bin/env bats

setup() {
  SCRIPT="$BATS_TEST_DIRNAME/../scripts/homelab-audit.sh"
}

@test "shows help" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" == Usage:* ]]
}

@test "rejects unknown arguments" {
  run "$SCRIPT" --unknown
  [ "$status" -eq 2 ]
}

@test "rejects extra arguments" {
  run "$SCRIPT" --public extra
  [ "$status" -eq 2 ]
}

@test "public mode completes" {
  run "$SCRIPT" --public
  [ "$status" -eq 0 ]
}

@test "report includes expected section headings" {
  run "$SCRIPT" --public
  [ "$status" -eq 0 ]
  [[ "$output" == *"# Platform"* ]]
  [[ "$output" == *"# Storage"* ]]
  [[ "$output" == *"# Docker"* ]]
  [[ "$output" == *"# Host services"* ]]
}

@test "public report excludes obvious secret patterns" {
  run "$SCRIPT" --public
  [ "$status" -eq 0 ]
  [[ ! "$output" =~ github_pat_ ]]
  [[ ! "$output" =~ ghp_ ]]
  [[ ! "$output" =~ "BEGIN PRIVATE KEY" ]]
  [[ ! "$output" =~ Bearer[[:space:]]+[A-Za-z0-9] ]]
}

@test "report includes stable container columns" {
  run "$SCRIPT" --public
  [ "$status" -eq 0 ]
  [[ "$output" == *"NAME|STATE|HEALTH|RESTART POLICY"* ]]
}

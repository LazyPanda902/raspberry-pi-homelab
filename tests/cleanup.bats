#!/usr/bin/env bats

setup() {
  SCRIPT="$BATS_TEST_DIRNAME/../scripts/safe-cleanup.sh"
  TARGET="$BATS_TEST_TMPDIR/cleanup-target"
  mkdir -p "$TARGET"
}

@test "defaults to dry-run and preserves matching files" {
  touch -t 202001010000 "$TARGET/old.tmp"
  run "$SCRIPT" --target "$TARGET"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Mode: dry-run"* ]]
  [ -f "$TARGET/old.tmp" ]
}

@test "refuses filesystem root" {
  run "$SCRIPT" --target /
  [ "$status" -eq 1 ]
}

@test "refuses home root" {
  run "$SCRIPT" --target /home
  [ "$status" -eq 1 ]
}

@test "refuses mount root" {
  run "$SCRIPT" --target /mnt
  [ "$status" -eq 1 ]
}

@test "refuses NVMe root" {
  run "$SCRIPT" --target /mnt/nvme
  [ "$status" -eq 1 ]
}

@test "refuses descendants of etc" {
  run "$SCRIPT" --target /etc/ssl --execute
  [ "$status" -eq 1 ]
  [[ "$output" == *"protected system tree"* ]]
}

@test "refuses descendants of usr" {
  run "$SCRIPT" --target /usr/bin --execute
  [ "$status" -eq 1 ]
  [[ "$output" == *"protected system tree"* ]]
}

@test "refuses descendants of var" {
  run "$SCRIPT" --target /var/log --execute
  [ "$status" -eq 1 ]
  [[ "$output" == *"protected system tree"* ]]
}

@test "refuses empty input" {
  run "$SCRIPT" --target ""
  [ "$status" -eq 2 ]
}

@test "rejects unknown arguments" {
  run "$SCRIPT" --target "$TARGET" --delete-now
  [ "$status" -eq 2 ]
}

@test "requires explicit execute flag before deletion" {
  touch -t 202001010000 "$TARGET/old.tmp"
  run "$SCRIPT" --target "$TARGET" --older-than 0
  [ "$status" -eq 0 ]
  [ -f "$TARGET/old.tmp" ]
}

@test "execute mode accepts an empty safe target" {
  run "$SCRIPT" --target "$TARGET" --older-than 7 --execute
  [ "$status" -eq 0 ]
  [[ "$output" == *"Mode: execute"* ]]
}

@test "refuses unapproved filesystem trees by default" {
  run "$SCRIPT" --target /root --execute
  [ "$status" -eq 1 ]
  [[ "$output" == *"outside an approved cleanup tree"* ]]
}

@test "does not follow a target symlink" {
  ln -s "$TARGET" "$BATS_TEST_TMPDIR/link"
  run "$SCRIPT" --target "$BATS_TEST_TMPDIR/link"
  [ "$status" -eq 1 ]
}

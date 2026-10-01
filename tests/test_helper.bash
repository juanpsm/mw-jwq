fixtures() {
  FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixtures/$1"
}

setup() {
  export TMP="$BATS_TEST_DIRNAME/tmp"
}

filter_control_sequences() {
  "$@" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
}

teardown() {
  [ -d "$TMP" ] && rm -f "$TMP"/*
}

# Terminal tests need GNU script(1) to get a pty; BSD script differs.
require_pty() {
  command -v script >/dev/null || skip "script(1) not available"
  [[ "$(uname)" != Darwin ]] || skip "GNU script(1) needed for a pty"
}

run_pty() {
  run script -qec "$1" /dev/null
}

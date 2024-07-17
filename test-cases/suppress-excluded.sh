#!/bin/bash
set -e
. test-lib.sh

echo "TEST: excluded file is ignored"

touch a b
$making --exclude './a' c | tee -a making.log >/dev/null 2>&1 &
sleep .1 && echo foo >> a
sleep .1 && echo foo >> b
test_content making.log "b changed"
! grep "a changed" making.log >/dev/null || fail "a was reported to change"

echo "PASS"

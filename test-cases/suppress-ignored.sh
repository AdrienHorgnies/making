#!/bin/bash
set -e
. test-lib.sh

echo "TEST: ignored file is ignored"

echo a > .gitignore
touch a b
$making c | tee -a making.log >/dev/null 2>&1 &
sleep .1 && echo foo >> a
sleep .1 && echo foo >> b
test_content making.log "b changed"
! grep "a changed" making.log || fail "a was reported to change"

echo "PASS"

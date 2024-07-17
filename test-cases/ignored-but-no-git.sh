#!/bin/bash
set -e
. test-lib.sh

echo "TEST: ignored file is reported as git itself is ignored"

echo a > .gitignore
touch a b
$making --no-git -- c | tee -a making.log >/dev/null 2>&1 &
sleep .1 && echo foo >> a
sleep .1 && echo foo >> b
test_content making.log "a changed"
test_content making.log "b changed"

echo "PASS"

#!/bin/bash
set -e
. test-lib.sh

echo "TEST: tracked files are reported"

touch a b
$making c | tee -a making.log >/dev/null 2>/dev/null &
sleep .1 && echo foo >> a
sleep .1 && echo foo >> b
test_content making.log "a changed"
test_content making.log "b changed"

echo "PASS"

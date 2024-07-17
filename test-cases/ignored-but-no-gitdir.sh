#!/bin/bash
set -e
. test-lib.sh

echo "TEST: ignored file is reported as we're outside a git dir"

# sanity check to avoid deleting a non-test git dir
if grep -- "-making-test-bed$" <<< "$PWD" >/dev/null; then
    rm -rf .git
else
    fail "you're about to delete a non temporary git dir!!!"
fi
echo a > .gitignore
touch a b
$making c | tee -a making.log >/dev/null 2>&1 &
sleep .1 && echo foo >> a
sleep .1 && echo foo >> b
test_content making.log "a changed"
test_content making.log "b changed"

echo "PASS"

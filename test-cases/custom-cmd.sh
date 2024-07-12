#!/bin/bash
set -e
. test-lib.sh

echo "TEST: execute the custom command instead of guessing one"

$making --cmd "touch john" -- touchp >/dev/null 2>&1 &
echo world > person
test_created john
[ ! -f world ] || fail "world is present but was expected missing"

echo "PASS"

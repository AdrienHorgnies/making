#!/bin/bash
set -e
. test-lib.sh

echo "TEST: continuously executing the command"

$making touchp >/dev/null 2>&1 &
sleep .1 && echo world > person
test_created world
sleep .1 && rm world
test_created world
sleep .1 && echo john > person
test_created john
sleep .1 && rm world
[ ! -f world ] || fail "world is present but was expected missing"

echo "PASS"

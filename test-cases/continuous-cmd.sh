#!/bin/bash
set -e
. test-lib.sh

echo "TEST: continuously executing the command"

$making touchp >/dev/null 2>&1 &
echo world > person
test_created world
rm world
test_created world
echo john > person
test_created john
rm world
# sleeping a tiny bit to allow a potential error
sleep .1
[ ! -f world ] || fail "world is present but was expected missing"

echo "PASS"

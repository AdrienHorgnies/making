#!/bin/bash
set -e
. test-lib.sh

echo "TEST: continuously making whenever sources are modified"

$making >/dev/null 2>&1 &
sleep .05 && echo world > person
test_created hello
test_content hello "world"
sleep .05 && echo "john" > person
test_content hello "john"
sleep .05 && echo "alice" > person
test_content hello "alice"

echo "PASS"

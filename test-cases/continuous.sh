#!/bin/bash
set -e
. test-lib.sh

echo "TEST: continuously make whenever sources are modified"

$making >/dev/null 2>&1 & kid=$!
echo world > person
test_created hello
test_content hello "world"
echo "john" > person
test_content hello "john"
echo "alice" > person
test_content hello "alice"

echo "PASS"

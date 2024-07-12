#!/bin/bash
set -e
. test-lib.sh

echo "TEST: make several targets"

echo world > person
$making hello goodbye >/dev/null 2>&1 &
test_created hello
test_created goodbye

echo "PASS"

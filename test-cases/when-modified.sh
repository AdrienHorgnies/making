#!/bin/bash
set -e
. test-lib.sh

echo "TEST: make when sources are modified"

$making >/dev/null 2>&1 &
echo world > person
test_created hello

echo "PASS"

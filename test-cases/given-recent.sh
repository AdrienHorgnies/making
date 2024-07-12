#!/bin/bash
set -e
. test-lib.sh

echo "TEST: make given sources more recent than target"

echo world > person
$making >/dev/null 2>&1 &
test_created hello

echo "PASS"

#!/bin/bash
set -e
. test-lib.sh

echo "TEST: choose a custom target"

echo world > person
$making goodbye >/dev/null 2>&1 &
test_created goodbye

echo "PASS"

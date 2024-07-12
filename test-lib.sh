#!/bin/bash
root="$(git rev-parse --show-toplevel)"

function yellow() {
    echo "$(tput setaf 3)$*$(tput sgr0)"
}

# kills child processes
function cleanTrap() {
    rc=$?
    set +x
    trap - EXIT SIGINT SIGTERM
    pkill -P $(pgrep -P $$ -d, making)
    rm -rf "$workdir" 2>/dev/null || yellow "$workdir not deleted (too fast?)"

    return $rc
}

function fail() {
    echo "TEST FAILED: $*" >&2
    exit 1
}

function polling() {
    max=$(($1 * 1000000000))
    now=$(date +%s%N)
    if [ -z "$polling_start" ]; then
        polling_start="$now"
    fi

    if (( now - polling_start > max )); then
        unset polling_start
        return 1
    fi

    sleep .01
}

# checks that the file $1 is created
function test_created() {
    while polling 1; do
        if test -f "$1"; then
            return
        fi
    done
    fail "$1 was NOT created"
}

# checks that the file $1 contains the string $2
function test_content() {
    while polling 1; do
        if grep -F "$2" "$1" >/dev/null; then
            return
        fi
    done
    fail "$1 doesn't contain $2"
}

# creates a directory where I can test making
making="$(git rev-parse --show-toplevel)/making"
trap "cleanTrap" EXIT SIGINT SIGTERM
workdir="$(mktemp -d --suffix -making-test-bed)"
cd "$workdir"
cp $root/test-project/* "$workdir"
git init >/dev/null 2>&1

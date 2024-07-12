#!/bin/bash
root="$(git rev-parse --show-toplevel)"

# kills child processes
function cleanTrap() {
    rc=$?
    trap - EXIT SIGINT SIGTERM
    kids=$(pgrep -P $$ -d, making || echo)
    if [ "$kids" ]; then
        pkill -P "$kids"
    fi
    cd "$root"
    if [[ "$OLDPWD" == *-making-test-bed ]]; then
        rm -rf "$OLDPWD"
    fi
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
cd "$(mktemp -d --suffix -making-test-bed)"
cp $root/test-project/* .

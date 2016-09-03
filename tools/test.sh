#!/bin/bash

function print_log () {
echo "======== QuDi Logfile ========"
cat qudi.log

if [ -e crash.log ]; then
    echo "======== QuDi Crashfile ========"
    cat crash.log
fi
}

if [[ $(python --version 2>&1) == *"2.7"* ]]; then
    PYCMD=python3
else
    PYCMD=python
fi

$PYCMD start.py &
QUDIPID=$!

sleep 10

jupyter-nbconvert --execute notebooks/debug.ipynb
jupyter-nbconvert --execute notebooks/matplotlib.ipynb

jupyter-nbconvert --execute notebooks/shutdown.ipynb

sleep 20

if kill $PID; then
    echo "Shutdown has failed: $PID was killed" >&2
    print_log
    exit 1
fi

print_log

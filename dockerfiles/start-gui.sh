#!/bin/bash

set -e

export DISPLAY=:0

echo "Starting Xorg..."

Xorg :0 -ac > /tmp/xorg.log 2>&1 &
XORG_PID=$!

echo "Xorg PID: $XORG_PID"

for i in $(seq 1 20); do
    echo "Waiting for Xorg... $i/20"

    if [ -S /tmp/.X11-unix/X0 ]; then
        echo "X11 socket found."
        break
    fi

    if ! kill -0 "$XORG_PID" 2>/dev/null; then
        echo "Xorg exited unexpectedly."
        cat /tmp/xorg.log
        exit 1
    fi

    sleep 0.5
done

if [ ! -S /tmp/.X11-unix/X0 ]; then
    echo "Xorg failed to start."
    cat /tmp/xorg.log
    kill "$XORG_PID" 2>/dev/null || true
    exit 1
fi

echo "Xorg started."

echo "Starting i3..."

i3 > /tmp/i3.log 2>&1 &
I3_PID=$!

sleep 2

if ! kill -0 "$I3_PID" 2>/dev/null; then
    echo "i3 exited unexpectedly."
    cat /tmp/i3.log
    exit 1
fi

echo "i3 started."
echo "Starting xterm..."

xterm > /tmp/xterm.log 2>&1 &

echo "GUI started."

wait "$XORG_PID"

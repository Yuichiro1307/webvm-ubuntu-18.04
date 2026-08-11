#!/bin/bash

set -e

export DISPLAY=:0

echo "Starting Xorg..."

Xorg :0 -ac &
XORG_PID=$!

for i in $(seq 1 20); do
    if [ -S /tmp/.X11-unix/X0 ]; then
        break
    fi

    if ! kill -0 "$XORG_PID" 2>/dev/null; then
        echo "Xorg exited unexpectedly."
        exit 1
    fi

    sleep 0.5
done

if [ ! -S /tmp/.X11-unix/X0 ]; then
    echo "Xorg failed to start."
    kill "$XORG_PID" 2>/dev/null || true
    exit 1
fi

echo "Xorg started."

export DISPLAY=:0

echo "Starting i3..."

i3 &
I3_PID=$!

wait "$XORG_PID"

#!/bin/bash

export DISPLAY=:0

Xorg :0 -ac &
XORG_PID=$!

sleep 2

i3 &

wait $XORG_PID

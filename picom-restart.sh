#!/bin/bash

killall -q picom
while pgrep -u "${UID}" -x picom >/dev/null; do sleep 1; done
nohup picom --experimental-backends </dev/null >/dev/null 2>&1 &

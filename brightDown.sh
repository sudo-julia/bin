#!/usr/bin/env zsh
set -euo pipefail
# lower system brightness, use xrandr if ext monitor

EXT=$(xrandr | awk 'FNR == 2 {print $1}')
if [[ "$(xrandr | awk '/HDMI-0/{print $2}')" == 'disconnected' ]]; then
	xbacklight -dec 5
	exit 0
fi

XRAN=$(xrandr --verbose | grep -A5 "$EXT" | tail -n1 | cut -d':' -f2)
if ((XRAN >= 0.25)); then # TODO change this to a bc command
	XRAN=$(awk "BEGIN {print ($XRAN - 0.05)}")
	xrandr --output "$EXT" --brightness "$XRAN"
	xbacklight -dec 5
else
	exit 1
fi

exit 0

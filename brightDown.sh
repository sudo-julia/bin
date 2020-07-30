#!/usr/bin/env zsh
set -euo pipefail
# lower system brightness, use xrandr if ext monitor

# TODO shorten everything after xrandr to an awk command
if [[ "$(xrandr -q | grep 'HDMI-0' | cut -d' ' -f2)" == 'disconnected' ]]; then
	xbacklight -dec 5
	exit 0
fi

XRAN=$( xrandr -q --verbose | grep -A5 "$EXT" | tail -n1 | cut -d':' -f2 )
if (( XRAN >= 0.25 )); then # TODO change this to a bc command
	XRAN=$(awk "BEGIN {print ($XRAN - 0.05)}")
	xrandr --output "$EXT" --brightness "$XRAN"
	xbacklight -dec 5
else
	exit 1
fi

exit 0

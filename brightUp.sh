#!/usr/bin/env zsh
set -euo pipefail
# raise system brightness, use xrandr if ext monitor

EXT=$( xrandr -q | awk 'FNR == 2 {print $1}' )
if [[ $EXT == 'DP-0' ]]; then
	xbacklight -inc 5
	exit 0
fi
# alt: xrandr -q --verbose | awk -F':' '/Bright/ {print $2}' | head -n1
XRAN=$( xrandr -q --verbose | grep -A 5 "$EXT" | tail -n 1 | cut -d':' -f2 )
if (( XRAN >= 1.0 )); then
	exit 0
else
	XRAN=$(awk "BEGIN {print ($XRAN + 0.05)}")
	xrandr --output "$EXT" --brightness "$XRAN"
	xbacklight -inc 5
fi
exit 0

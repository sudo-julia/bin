#!/usr/bin/env zsh
set -euo pipefail
# raise system brightness, use xrandr if ext monitor

EXT=$( xrandr | awk 'FNR == 2 {print $1}' )
if [[ "$(xrandr | awk '/HDMI-0/{print $2}')" == 'disconnected' ]]; then
	xbacklight -inc 5
	exit 0
fi
# alt: xrandr -q --verbose | awk -F':' '/Bright/ {print $2}' | head -n1
XRAN=$( xrandr --verbose | grep -A5 "$EXT" | tail -n1 | cut -d':' -f2 )
if (( XRAN >= 1.0 )); then
	exit 1
else
	XRAN=$(awk "BEGIN {print ($XRAN + 0.05)}")
	xrandr --output "$EXT" --brightness "$XRAN"
	xbacklight -inc 5
fi
exit 0

#!/usr/bin/env zsh
set -euo pipefail
## TODO shorten everything after xrandr to an awk command
#EXT=$( xrandr -q | grep ' connected' | head -n 1 | cut -d' ' -f1 ) # before
EXT=$( xrandr -q | awk 'FNR == 2 {print $1}' ) # after
if [[ $EXT == 'DP-0' ]]; then
	xbacklight -dec 5
	exit 0
fi
XRAN=$( xrandr -q --verbose | grep -A5 "$EXT" | tail -n 1 | cut -d':' -f2 )
if (( XRAN >= 0.25 )); then # change this to a bc command
	XRAN=$(awk "BEGIN {print ($XRAN - 0.05)}")
	xrandr --output "$EXT" --brightness "$XRAN"
	xbacklight -dec 5
else
	exit 0
fi

exit 0

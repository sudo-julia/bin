#!/usr/bin/env zsh
set -euo pipefail

EXT=$( xrandr -q | grep ' connected' | head -n 1 | cut -d ' ' -f1 )
if [[ $1 == 'min' ]]; then
	xrandr --output "$EXT" --brightness 0.25
	xbacklight -set 25
elif [[ $1 == 'max' ]]; then
	xrandr --output "$EXT" --brightness 1.0
	xbacklight -set 100
else
	exit 127
fi
exit 0

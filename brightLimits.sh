#!/usr/bin/env zsh
set -euo pipefail
# set brightness to minimum or maximum value specified
# TODO set up to truly detect second monitor

EXT=$( xrandr -q | grep ' connected' | head -n1 | cut -d' ' -f1 )
if [[ $1 == '--min' ]]; then
	xrandr --output "$EXT" --brightness 0.25
	xbacklight -set 25
elif [[ $1 == '--max' ]]; then
	xrandr --output "$EXT" --brightness 1.0
	xbacklight -set 100
else
	exit 127
fi
exit 0

# too high to do this rn so pseudocode for working product

# if second monitor is disconnected, only use xbacklight (function) then exit
# else (it's connected) use xbacklight on laptop and xrandr on external

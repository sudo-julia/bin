#!/usr/bin/env zsh

# TODO move brightUp and brightDown to be in here as one script
set -euo pipefail
# set brightness to minimum or maximum value specified
# this shit is busted do not trust it

HDMI_STATUS=$( xrandr | awk '/HDMI-0/{print $2}' )
if [[ "$HDMI_STATUS" == 'disconnected' ]]; then
	if [[ $1 == '--min' ]]; then
		xbacklight -set 25
		exit 0
	elif [[ $1 == '--max' ]]; then
		xbacklight -set 100
		exit 0
	fi
fi


if [[ $1 == '--min' ]]; then
	xrandr --output "HDMI-0" --brightness 0.25
	xbacklight -set 25
elif [[ $1 == '--max' ]]; then
	xrandr --output "HDMI-0" --brightness 1.0
	xbacklight -set 100
else
	exit 127
fi
exit 0

# too high to do this rn so pseudocode for working product

# if second monitor is disconnected, only use xbacklight (function) then exit
# else (it's connected) use xbacklight on laptop and xrandr on external

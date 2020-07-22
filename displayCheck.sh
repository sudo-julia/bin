#!/usr/bin/env bash

launch_picom () {
    killall -q picom
    nohup picom --experimental-backends 2>/dev/null &
}
WALLPAPERS="$HOME/Pictures/Wallpapers"

CONNECTED=$( xrandr | awk '/HDMI-0/ {print $2}' )
if [ "$CONNECTED" == "connected" ]; then
    xrandr --output HDMI-0 --auto --left-of DP-0
#TODO relocate the wallpapers or use a symlink to fit on one line w/o var
	feh --bg-fill "$WALLPAPERS"/desktop01.png "$WALLPAPERS"/desktop02.png
    launch_picom
    "$HOME"/.config/polybar/scripts/launch.sh
elif [ "$CONNECTED" == "disconnected" ]; then
    xrandr --output HDMI-0 --off --auto
    feh --bg-fill "$WALLPAPERS"/desktop02.png
    launch_picom
    "$HOME"/.config/polybar/scripts/launch.sh
else
    exit 1
fi


#!/usr/bin/env bash
#set -eo pipefail

launch_picom () {
    killall -q picom
    nohup picom --experimental-backends 2>/dev/null &
}

CONNECTED=$( xrandr | awk '/HDMI-0/ {print $2}' )
if [ "$CONNECTED" == "connected" ]; then
    xrandr --output HDMI-0 --auto --left-of DP-0
    feh --bg-fill "$HOME"/Pictures/Wallpapers/desktop01.png "$HOME"/Pictures/Wallpapers/desktop02.png
    launch_picom
    "$HOME"/.config/polybar/scripts/launch.sh
elif [ "$CONNECTED" == "disconnected" ]; then
    xrandr --output HDMI-0 --off --auto
    feh --bg-fill "$HOME"/Pictures/Wallpapers/desktop02.png
    launch_picom
    "$HOME"/.config/polybar/scripts/launch.sh
else
    exit 1
fi


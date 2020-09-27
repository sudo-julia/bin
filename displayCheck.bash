#!/usr/bin/env bash
# check if external display is plugged in, launch all utilities

launch_picom () {
    killall -q picom
	nohup picom --experimental-backends </dev/null >/dev/null 2>&1 &
}
WALLPAPERS="${HOME}/documents/pictures/wallpapers"

CONNECTED=$( xrandr | awk '/HDMI-0/ {print $2}' )
if [ "${CONNECTED}" == connected ]; then
    xrandr --output HDMI-0 --auto --left-of DP-0
	feh --bg-fill "${WALLPAPERS}"/desktop01.png "${WALLPAPERS}"/desktop02.png
    launch_picom
    "${HOME}"/.config/polybar/scripts/launch.sh
elif [ "${CONNECTED}" == disconnected ]; then
    xrandr --output HDMI-0 --off --auto
    feh --bg-fill "${WALLPAPERS}"/desktop02.png
    launch_picom
    "${HOME}"/.config/polybar/scripts/launch.sh
else
    exit 1
fi

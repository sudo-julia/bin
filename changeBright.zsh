#!/usr/bin/zsh

# adjust brightness levels
# support for a laptop and one external monitor through xrandr brightness

# why zsh? bc `bc` is slight pain to use with quoting and zsh works with floats

# change this to match your external monitor's name.
# if you don't know it, run `xrandr | grep 'connected | grep -v 'dis'`
extMonitor=HDMI-0
extStatus=$( xrandr | awk "/$extMonitor/{print $2}" )
if [[ "$extStatus" = connected ]]; then
	extBright=$( xrandr --verbose \
		| grep -A5 "$extMonitor" \
		| awk -F' ' '/Brightness/{print $2}')
	extConnected=true
fi

backlight=$( xbacklight )

lower () {
	if [[ $extConnected ]]; then
		extLower
		if (( extBright > 0.2 )); then
			xrandr --output "$extMonitor" --brightness "$(( extBright - 0.5 ))"
		fi
	fi
	if (( backlight > 20 )); then
		xbacklight -dec 5
	fi
	return
}


raise () {
	if [[ $extConnected ]]; then
		if (( extBright =< 1.0 )); then
			xrandr --output "$extMonitor" --brightness "$(( extBright + 0.5 ))"
		fi
	fi
	if (( backlight <= 100 )); then
		xbacklight -inc 5
	fi
	return
}


minMax () {
	if [[ "$1" == min ]]; then
		if [[ "$extConnected" ]]; then
			xrandr --output "$extMonitor" --brightness '0.2'
		fi
		xbacklight -set 20
	elif [[ "$1" == max ]]; then
		if [[ "$extConnected" ]]; then
			xrandr --output "$extMonitor" --brightness '1.0'
		fi
		xbacklight -set 100
	fi
	return
}


main () {
	case "$1" in
		--lower)
			lower  ;;
		--raise)
			raise  ;;
		--min)
			minMax min  ;;
		--max)
		minMax max  ;;
	esac
}


main "$@"

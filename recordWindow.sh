#!/bin/sh
# record the current terminal window with giph

video_dir=/home/jam/videos/giph

if ! hash giph 2> /dev/null; then
	printf -- 'giph not installed. Exiting.\n'
fi

if [ "${1}" ]; then
	giph -w "${WINDOWID}" --format gif "${video_dir}/${1}" &
else
	giph -w "${WINDOWID}" --format gif "${video_dir}/$( date '+%Y-%m-%dT%H:%M:%S' )" &
fi

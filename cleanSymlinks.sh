#!/bin/sh
# list and offer to remove all broken symlinks recursing from your current dir
# TODO checks to exclude useful broken symlinks

removeSymlinks () {
	find . -xtype l -exec rm -v {} \;
}

logSymlinks () {
	output=$( mktemp --suffix '.txt' )
	find . -xtype l ! -exec test -e {} \; -print > "${output}" && \
	printf -- '%s\n' "Symlinks output to ${output} for review."
	printf -- '%s\n' "Exiting program without removing any symlinks."
	exit 1
}

find . -xtype l ! -exec test -e {} \; -print
printf -- '%s\n' "Remove broken symlinks? [Y/n] "; read -r remove
case "$remove" in
	y|Y)
		printf -- '%s\n' "Are you sure? [Y/n] "; read -r confirm
		case "$confirm" in
			y|Y)
				removeSymlinks  ;;
			*)
				logSymlinks
		esac  ;;
	*)
		logSymlinks
esac

exit 0

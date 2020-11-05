#!/usr/bin/env bash
# send lists of installed programs to dir specified by date

user=jam
basedir=/home/"${user}"/documents/misc/installed
currentDate=$( date "+%y%m%d" )
newDir="${basedir}"/"${currentDate}"


getInstalled() {
	if [[ $SETTING_WITH_GIT ]]; then
		if [[ ! -d "${basedir}"/.git ]]; then
			( cd "${basedir}" && git init )
		fi
	fi

	if [[ -d "${newDir}" ]]; then
		newDir="${basedir}"/"${currentDate}"-"$( date '+%H:%M:%S' )"
	fi

	mkdir "${newDir}"
	pacman -Q > "${newDir}"/all
	cut -d' ' -f1 "${newDir}"/all > "${newDir}"/no_version
	pacman -Qm | cut -d' ' -f1 > "${newDir}"/aur
	diff -y "${newDir}"/no_version "${newDir}"/aur \
	| awk '{print $2}' \
	| sed '/</d' > "${newDir}"/no_aur

	if [[ $SETTING_WITH_GIT ]]; then
		( cd "${basedir}" && git add . && git commit -m "${user} $( date '+%c' )" )
	fi

	printf -- '%s %s\n' "Installed programs backed up to" "${newDir}"
}

# TODO better help section
case "$1" in
	-g|--git)
		SETTING_WITH_GIT=ON
		getInstalled
		;;
	-h|--help)
		printf 'Usage:\ngetInstalled.bash [-g|--git]\n-g\tProvides git integration\n\n'
		exit 0
		;;
	*)
		getInstalled
esac

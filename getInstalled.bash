#!/usr/bin/env bash
# send lists of installed programs to dir specified by date

USER_HOME=$( getent passwd "$SUDO_USER" | cut -d':' -f6 )
user=$( echo "$USER_HOME" | cut -d'/' -f3 )
basedir="${USER_HOME}"/documents/misc/installed
currentDate=$( date "+%Y%m%d" )
newDir="${basedir}"/"${currentDate}"


getInstalled() {
	if [[ $SETTING_WITH_GIT ]]; then
		if [[ ! -d "${basedir}"/.git ]]; then
			git init "${basedir}"
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

# TODO option to set output dir
case "$1" in
	-g|--git)
		SETTING_WITH_GIT=ON
		getInstalled
		;;
	-h|--help)
		cat <<-EOF
			Usage:
			  getInstalled.bash [options] [dir]

			OPTIONS
			  -g, --git    Use git for storing history
		EOF
		;;
	*)
		getInstalled
esac

exit 0

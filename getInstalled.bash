#!/usr/bin/env bash
# send lists of installed programs to dir specified by date
# TODO there has to be a cleaner way to do this instead of almost identical functions

user=jam
basedir=/home/"${user}"/documents/misc/installed
currentDate=$( date "+%y%m%d" )
newDir=/home/"${user}"/documents/misc/installed/"${currentDate}"


getInstalled() {
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
	printf -- '%s %s\n' "Installed programs backed up to" "${newDir}"
}

withGit() {
	if [[ ! -d "${basedir}"/.git ]]; then
		( cd "${basedir}" && git init )
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
	( cd "${basedir}" && git add . && git commit -m "${user} $( date '+%c' )")
	printf -- '%s %s\n' "Installed programs backed up to" "${newDir}"
}

# TODO better help section
case "$1" in
	-g|--git)
		withGit
		;;
	-h|--help)
		printf '%s\n' "Usage: -g||--git for git integration"
		exit 0
		;;
	*)
		getInstalled
esac
=======
# TODO make git integration a flag

user=jam
BASEDIR=/home/"${user}"/documents/misc/installed
DATE=$( date "+%y%m%d" )
DIR=/home/"${user}"/documents/misc/installed/"${DATE}"

if [[ -d "${DIR}" ]]; then
	DIR=/home/"${user}"/documents/misc/installed/"${DATE}"-"$( date '+%H:%M' )"
fi

if [[ ! -d "${BASEDIR}"/.git ]]; then
	( cd "${BASEDIR}" && git init )
fi

mkdir "${DIR}"
pacman -Q > "${DIR}"/all
cut -d' ' -f1 "${DIR}"/all > "${DIR}"/no_version
pacman -Qm | cut -d' ' -f1 > "${DIR}"/aur
diff -y "${DIR}"/no_version "${DIR}"/aur | awk '{print $2}' | sed '/</d' > "${DIR}"/no_aur
( cd "${BASEDIR}" && git add . && git commit -m "${user} $( date '+%c' )")
printf -- '%s %s\n' "Installed programs backed up to" "${DIR}"

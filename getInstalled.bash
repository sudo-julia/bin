#!/usr/bin/env bash
# send lists of installed programs to dir specified by date

user=jam
BASEDIR=/home/"${user}"/documents/misc/installed
DATE=$( date "+%y%m%d" )
DIR=/home/"${user}"/documents/misc/installed/"${DATE}"

# TODO make something to increment this instead of a one time fix
if [[ -d "${DIR}" ]]; then
	DIR=/home/"${user}"/documents/misc/installed/"${DATE}".1
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
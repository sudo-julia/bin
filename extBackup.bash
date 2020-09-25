#!/usr/bin/env bash
set -euo pipefail
# back up shit to external drive
# shellcheck disable=SC2181

LOGLOC="/tmp/extBackup-$( date "+%s" ).log"

# TODO check exit code directly and call operation as arg of exitCheck
exitCheck () {
	if [ "$?" -ne 0 ]; then
		exitErorr
	else
		return
	fi
}

exitErorr () {
    printf -- '\n%s\n' "Error! Exiting script!"
}

unmountClose () {
    umount /mnt
    cryptsetup close external
}

if [ "$( id -u )" -ne 0 ]; then
    printf -- '\n' "Please run as root!"
    exit 1
else
    cryptsetup open /dev/sdc external
    mount /dev/mapper/external /mnt

	rsync -aucPv \
	--exclude-from=/home/jam/bin/.rExclude --include-from=/home/jam/bin/.rInclude \
	--delete --delete-excluded /home/jam /mnt/home --log-file="${LOGLOC}"
	exitCheck

	rsync -apPy /etc /mnt
	exitCheck

	rsync -apPy /var /mnt
	exitCheck
fi
exit 0

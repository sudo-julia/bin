#!/usr/bin/env bash
set -euo pipefail

LOGLOC="/tmp/extBackup-$(date "+%s").log"

exitCheck () {
	if [ "$EXIT" != 0 ]; then
		exitErorr
	else
		return
	fi
}

exitErorr () {
    printf "\nError! Exiting script!\n"
    logCheck
}

unmountClose () {
    umount /mnt
    cryptsetup close external
}

if [ "$(whoami)" != "root" ]; then
    printf "Please run as root!\n"
    exit 1
else
    cryptsetup open /dev/sdc external
    mount /dev/mapper/external /mnt
	rsync -aucPv \
	--exclude-from=/home/jam/bin/.rExclude --include-from=/home/jam/bin/.rInclude \
	--delete --delete-excluded /home/jam /mnt/home/jam --log-file="$LOGLOC"; EXIT=$?
	exitCheck

	rsync -apPy /etc/ /mnt/etc/
	exitCheck

	rsync -apPy /var/mnt/var/
	if [ "$EXIT" != 0 ]; then
	    exitErorr
	else
	    unmountClose
	fi
fi
exit 0

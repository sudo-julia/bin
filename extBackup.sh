#!/usr/bin/env bash
set -euo pipefail
# back up shit to external drive

LOGLOC="/tmp/extBackup-$(date "+%s").log"

# TODO check exit code directly and call operation as arg of exitCheck
exitCheck () {
	if [ "$?" -ne 0 ]; then
		exitErorr
	else
		return
	fi
}

exitErorr () {
    printf "\nError! Exiting script!\n"
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
	--delete --delete-excluded /home/jam /mnt/home/jam --log-file="$LOGLOC"
	exitCheck

	rsync -apPy /etc/ /mnt/etc/
	exitCheck

	rsync -apPy /var/mnt/var/
	exitCheck
fi
exit 0

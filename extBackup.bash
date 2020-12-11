#!/usr/bin/env bash
set -euo pipefail
# back up /{etc,home,var} to a LUKS encrypted external drive

# TODO allow these to be passed as arguments
# TODO make include and exclude patterns as variables
includeFile="/home/jam/bin/.rInclude"
excludeFile="/home/jam/bin/.rExclude"
externalDrive="/dev/sdc"
logLocation="/tmp/extBackup-$( date '+%s' ).log"
mountPoint="/mnt"
USER_HOME=$( getent passwd "$SUDO_USER" | cut -d':' -f6 )

checkDisk () {
	if lsblk -l | grep '/dev/mapper/external' > /dev/null; then
		cryptsetup open "${externalDrive}" external
		printf -- '%s\n' "${externalDrive} opened as 'external'"
	else
		printf -- '%s\n' "${externalDrive} already open as 'external'"
	fi

	if ! df | awk '{print $6}' | grep "${mountPoint}" > /dev/null; then
		mount '/dev/mapper/external' "${mountPoint}"
		printf -- '%s\n' "'external' mounted to ${mountPoint}"
	elif [[ "$( df '/mnt' | awk 'NR==2 {print $1}' )" == /dev/mapper/external ]]; then
		printf -- '%s\n' "'external' already mounted to ${mountPoint}"
	else
		unmountClose "${mountPoint} in use by another device"
		exit 1
	fi

	printf -- '%s\n%s\n' "Disk successfully decrypted and mounted." "Ready for backup."
	return 0
}


checkRoot () {
	if [[ "$( id -u )" -ne 0 ]]; then
		printf -- '%s\n%s\n' "Error! Run as root." "Cancelling operation."
		exit 1
	fi
}


syncDirs () {
	# run through all given directories to copy them, ignoring temp files
	while (( "$#" )); do
		rsync -apPy --exclude={'*.cache','*cache/','*.tmp','*tmp/'} \
		--log-file="${logLocation}" "${1}" "${mountPoint}"
		shift
	done
	return 0
}


syncMain() {
	# sync user's "/home" and then "/var" and "/log"
	# if you want to add another dir, just provide it as an arg to syncDirs
	if ! rsync -aucPv \
	--exclude-from="${excludeFile}" --include-from="${includeFile}" \
	--delete --delete-excluded  --log-file="${logLocation}" \
	"${USER_HOME}" "${mountPoint}"; then
		unmountClose "Syncing '${USER_HOME}' failed"
		exit 4
	fi
	if ! syncDirs "/etc" "/var"; then
		unmountClose "Syncing '/etc' and/or '/var' failed"
		exit 4
	fi
	return 0
}


unmountClose () {
	# unmount the external drive and close the LUKS container
	if [[ "$#" ]]; then
		printf -- '%s\n' "Error: ${1}!"
		read -rp "Unmount and close disk? [Y/n] " closeDisk
		case "$closeDisk" in
			y|Y)
				:  ;;
			*)
				printf -- '%s\n' "Leaving '${externalDrive}' decrypted and mounted."
				exit 2
		esac
	fi
    umount '/mnt'
    cryptsetup close external
	return 0
}


checkRoot
checkDisk
syncMain
unmountClose

exit 0

#!/usr/bin/env bash
# back up /{etc,home,var} to a LUKS encrypted external drive

# TODO add option for progress bar, no output and verbose (current)
# TODO make include and exclude patterns as variables
# TODO allow these to be passed as arguments
includeFile="/home/jam/bin/.rInclude"
excludeFile="/home/jam/bin/.rExclude"

cryptDevice="external"
externalDrive="/dev/sdc"
mountPoint="/mnt"

logLocation="/tmp/extBackup-$( date '+%s' ).log"
USER_HOME=$( getent passwd "$SUDO_USER" | cut -d':' -f6 )

checkDisk () {
	# TODO this section is finicky, make sure it responds properly
	if lsblk -l | grep "/dev/mapper/${cryptDevice}" > /dev/null; then
		cryptsetup open "${externalDrive}" "${cryptDevice}"
		printf -- '%s\n' "${externalDrive} opened as '${cryptDevice}'"
	else
		printf -- '%s\n' "${externalDrive} already open as '${cryptDevice}'"
	fi

	if ! df | awk '{print $6}' | grep "${mountPoint}" > /dev/null; then
		mount "/dev/mapper/${cryptDevice}" "${mountPoint}"
		printf -- '%s\n' "'${cryptDevice}' mounted to ${mountPoint}"
	elif [[ "$( df '/mnt' | awk 'NR==2 {print $1}' )" == /dev/mapper/"${cryptDevice}" ]]; then
		printf -- '%s\n' "'${cryptDevice}' already mounted to ${mountPoint}"
	else
		unmountClose "${mountPoint} in use by another device"
		exit 1
	fi

	printf -- '%s\n%s\n' "Disk successfully decrypted and mounted." "Ready for backup."
	return 0
}


checkRoot () {
	# exit if user is not root
	if [[ "$( id -u )" -ne 0 ]]; then
		printf -- '%s\n%s\n' "Error! Run as root." "Cancelling operation."
		exit 1
	fi
}


syncMain() {
	# sync user's "/home" and then "/var" and "/etc"
	# if you want to add another dir, just provide it as an arg to syncDirs
	# TODO make verbosity an option
	if ! rsync -maucP \
	--exclude-from="${excludeFile}" \
	--include-from="${includeFile}" \
	--delay-updates \
	--delete-delay \
	--delete-excluded  \
	--ignore-existing \
	--log-file="${logLocation}" \
	"${USER_HOME}" "${mountPoint}"; \
	then
		unmountClose "Syncing '${USER_HOME}' failed"
		exit 4
	else
		printf -- '%s\n' "'/home' successfully synced"
	fi

	if ! syncDirs "/etc" "/var"; then
		unmountClose "Syncing '/etc' and/or '/var' failed"
		exit 4
	else
		printf -- '%s\n' "'/etc' and '/var' successfully synced"
	fi
	return 0
}


syncDirs () {
	# run through all given directories to copy them, ignoring temp files
	while (( "$#" )); do
		rsync -mapPy \
		--exclude={'*.cache','*cache/','*.tmp','*tmp/'} \
		--delay-updates \
		--delete-delay \
		--delete-excluded \
		--ignore-existing \
		--log-file="${logLocation}" \
		"${1}" "${mountPoint}"
		shift
	done
	return 0
}


unmountClose () {
	# unmount the external drive and close the LUKS container
	if (( $# == 1 )); then
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
    umount "${mountPoint}"
    cryptsetup close "${cryptDevice}"
	return 0
}


checkRoot
checkDisk
syncMain
unmountClose

exit 0

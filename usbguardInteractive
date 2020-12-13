#!/usr/bin/env bash
# run usbguard interactively to avoid typing two commands lol

checkRoot () {
	if [[ "$( id -u )" -ne 0 ]] || ! hash usbguard 2> /dev/null; then
		printf -- '%s\n' "Error! Make sure 'usbguard' is installed and run as root."
		exit 1
	fi
}

main () {
	printf -- '%s\n\n' "USB Devices:"
	usbguard list-devices
	printf -- '\n'
	read -rp "Which device would you like to operate on? " device
	read -rp "[a]llow, [b]lock, or [r]eject device? " operation
	case "$operation" in
		a|A|allow|Allow)
			operation="allow-device"
			;;
		b|B|block|Block)
			operation="block-device"
			;;
		r|R|reject|Reject)
			operation="reject-device"
			;;
		*)
			printf -- '%s\n' "Please select an option between: [a]llow [b]lock [r]eject"
			exit 1
	esac
	usbguard "${operation}" "${device}"
}

checkRoot
main
exit 0

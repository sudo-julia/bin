#!/usr/bin/env bash
# make backups of files if given, if not find files to backup

# TODO expand invalid args checker to allow multiple flags
# TODO change main to search for files in current dir
# TODO move current main to a flag asking to search ~
# TODO split this var into lines and find way to avoid var alltogether
mkrt="^/bin|^/boot|^/dev|^/etc|^/home$|^/mnt|^/opt|^/proc|^/run|^/root|^/srv|^/sys|tmp|^/usr|^/var"
MKBAK_HELP="Usage:
  mkbak.sh [options...] [FILES]

  If no arguments are given, mkbak will search for files to backup in $HOME

Flags:
  -h, --help        Print this help
  -o, --output      Write to output file instead of ${1}.bak"

main () {
	if [ "$#" -eq 0 ]; then
		readlink -e "$HOME"/{,.}*/{,.,*}/{,*}/{,*} \
		| grep -Evi "chromium|^/lost\+found|$mkrt" \
		| fzf -m --height=50% --border --prompt='backup: ' --marker='*' \
		| xargs -P 4 -I % sh -c "cp -a -- % %.bak && echo 'created %.bak'"
		return 0
	fi

	while (( $# )); do
		cp -av -- "$1" "${1}.bak"
		shift
	done
	return 0
}

output_file() {
	# yes, this is the exact same as just using `cp` but whatever i wanted to add more options
	MKBAK_O_ERROR="Format is: mkbak.sh -o [FILE] [OUTPUT]"
	if [ "$#" -lt 3 ]; then
		printf -- "Not enough arguments given!\\n%s\\n" "$MKBAK_O_ERROR"
		return 1
	elif [ "$#" -gt 3 ]; then
		printf -- "Too many arguments given!\\n%s\\n" "$MKBAK_O_ERROR"
		return 1
	elif [ "$#" -eq 3 ] && [ "$1" = -o  ]; then
		cp -a -- "$2" "${3}.bak"
		printf -- "created %s from %s\\n" "${3}.bak" "$2"
		return 0
	else
		printf -- "Something went wrong! Flag in the wrong place?\\n"
		printf -- "%s\\n" "$MKBAK_O_ERROR"
		return 2
	fi
}

# TODO improve this help section to be more professional looking
case $1 in
	-h|--help)
		printf -- "%s\\n" "$MKBAK_HELP"
		;;
	-o|--output)
		output_file "$@"
		;;
	*)
		main "$@"
		;;
esac

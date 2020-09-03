#!/usr/bin/env bash
# mkbak.sh, the World's Best `cp` wrapper
# make backups of files if given, if not find files to backup
# side note, i can't belive i didn't remember `find` existed till this push

# TODO expand invalid args checker to allow multiple flags (getopts?)
# TODO flag to specify dir to search '-d'
MKBAK_HELP="Usage:
  mkbak.sh [options...] [FILES]

  If no arguments are given, mkbak will search for files to backup in $HOME
  At the time, only one argument can be provided

Flags:
  -h, --help        Print this help
  -o, --output      Write to output file instead of ${1}.bak"

main () {
	if [ "$#" -eq 0 ]; then
		find . \
		| grep -v '^\.$' \
		| fzf -m --height=30% --border --prompt='backup: ' --marker='*' \
		| xargs -P 4 -I % sh -c "cp -av -- % %.bak"
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
		cp -av -- "$2" "${3}.bak"
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

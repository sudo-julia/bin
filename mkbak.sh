#!/usr/bin/env bash
# make backups of files if given, if not find files to backup

# TODO split this var into lines and find way to avoid var alltogether
mkrt="^/bin|^/boot|^/dev|^/etc|^/home$|^/mnt|^/opt|^/proc|^/run|^/root|^/srv|^/sys|tmp|^/usr|^/var"

main () {
	if [ "$#" -eq 0 ]; then
		readlink -e "$HOME"/{,.}*/{,*}/{,*}/{,*} \
		| grep -Evi "chromium|^/lost\+found|$mkrt" \
		| fzf -m --height=50% --border --prompt='backup: ' --marker='*' \
		| xargs -P 4 -I % sh -c "cp -a -- % %.bak && echo 'created %.bak'"
		return 0
	fi

	while (( $# )); do
		cp -a -- "$1" "${1}.bak"
		printf "created %s" "${1}.bak"
		shift
	done
	return 0
}

output_file() {
	# yes, this is the exact same as just using `cp` but whatever i wanted to add more options
	MKBAK_O_ERROR="Format is: mkbak.sh -o [FILE] [OUTPUT]"
	if [ "$#" -lt 3 ]; then
		printf "Not enough arguments given!\n%s\n" "$MKBAK_O_ERROR"
		return 1
	elif [ "$#" -gt 3 ]; then
		printf "Too many arguments given!\n%s\n" "$MKBAK_O_ERROR"
		return 1
	elif [ "$#" -eq 3 ] && [ "$1" = -o  ]; then
		cp -a -- "$2" "${3}.bak"
		printf "created %s from %s\n" "${3}.bak" "$2"
		return 0
	else
		printf "Something went wrong! Flag in the wrong place?\n"
		printf "%s\n" "$MKBAK_O_ERROR"
		return 2
	fi
}

# TODO Have help display text with one formatted `cat >> EOF` instead of all these calls
# TODO improve this help section to be more professional looking
case $1 in
	-h|--help)
		printf "Usage:\n  mkbak.sh [options...] [FILES]\n"
		printf "\nIf no arguments are given, mkbak will search for files to backup in \$HOME\n"
		printf "If arguments are given with no '-o' flag, mkbak will make cop{y,ies} of any file{,s} given with the extension '.bak'\n"
		printf "Flags:\n"
		printf "  -h, --help        Print this help\n"
		printf "  -o, --output      Write to output file instead of \${1}.bak\n"
		;;
	-o|--output)
		output_file "$@"
		;;
	*)
		main "$@"
		;;
esac

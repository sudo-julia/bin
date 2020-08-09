#!/usr/bin/env bash
# make backups of files if given, if not find files to backup

#TODO split this var into lines and find way to avoid var alltogether
mkrt="^/bin|^/boot|^/dev|^/etc|^/home$|^/mnt|^/opt|^/proc|^/run|^/root|^/srv|^/sys|tmp|^/usr|^/var"

main () {
	if [ "$#" -eq 0 ]; then
		readlink -e "$HOME"/{,.}*/{,*}/{,*}/{,*} \
		| grep -Evi "chromium|^/lost\+found|$mkrt" \
		| fzf -m --height=50% --border --prompt='backup: ' --marker='*' \
		| xargs -P 4 -I % sh -c "cp -a -- % %.bak && echo 'created %.bak'"
	fi

	while (( $# )); do
		cp -a -- "$1" "${1}.bak"
		echo "created ${1}.bak"
		shift
	done
}

case $1 in
	-h|--help)
		printf "Usage: mkbak.sh [FILE]\n"
		printf "If no arguments are given, mkbak will search for files to backup in \$HOME.\n"
		printf "If arguments are given, mkbak will make copie(s) of any file(s) given with the extension '.bak'.\n"
		;;
	*)
		main "$@" && (exit 0)
		;;
esac

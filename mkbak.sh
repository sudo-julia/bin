#!/usr/bin/env bash
# make backups of files if given, if not find files to backup
#TODO split this var into lines and find way to avoid var alltogether
mkrt="^/bin|^/boot|^/dev|^/etc|^/home$|^/mnt|^/opt|^/proc|^/run|^/root|^/srv|^/sys|tmp|^/usr|^/var"

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

(exit 0)

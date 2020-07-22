#!/usr/bin/env bash
# make backups of files if given, if not find files to backup
alias fzf="fzf -m --height=50% --border --prompt='backup: ' --marker='*'"
roots='boot|dev|etc|mnt|opt|proc|/usr|/usr/'

if [ "$#" -eq 0 ]; then
	readlink -e "$HOME"/{,.}*/*/*/* | grep -Evi "chrome|chromium|$roots" | fzf \
	| xargs -P 4 -I % sh -c "cp -a -- % %.bak && echo 'created %.bak'"
fi

while (( $# )); do
	cp -a -- "$1" "${1}.bak"
	echo "created ${1}.bak"
	shift
done

unalias fzf
(exit 0)

#!/bin/env bash
# script to update pip, meant for integration in `u`
# DO NOT RUN AS SUPERUSER

if [ "$(id -u)" == 0 ]; then
	printf "Error! Do not run as root.\nCancelling...\n"
	exit 1
fi

pip list -o | grep -v '\^-e' | tee ~/.local/lib/python3.8/installed/"$(date +\"%y%m%d\")" \
| grep -Ev 'sdist|--|Latest\s' | cut -d' ' -f1 | xargs -r -n1 pip install --user -U

printf "Pip packages upgraded.\n"
exit 0

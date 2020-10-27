#!/usr/bin/env bash
# script to update pip, meant for integration in `u`
# DO NOT RUN AS SUPERUSER

if [[ "$( id -u )" == 0 ]]; then
	printf -- '%s\n%s\n' "Error! Do not run as root." "Cancelling..."
	exit 1
fi

if [ ! -d ~/.local/lib/python3.8/installed ]; then
	mkdir ~/.local/lib/python3.8/installed
fi

# shellcheck disable=SC2046
pip list -o | grep -v '\^-e' | tee ~/.local/lib/python3.8/installed/"$( date +\"%y%m%d\" )" \
| grep -Ev 'sdist|--|Latest\s' | cut -d' ' -f1 | xargs -r -n1 pip install --user -U

printf -- '\n%s\n' "Pip packages upgraded."
exit 0

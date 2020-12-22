#!/usr/bin/env bash
# script to update pip, meant for integration in `u`
# DO NOT RUN AS SUPERUSER

pythonVer=$( env pip --version | grep -o '\(python [0-3]\.[0-9]\)' )

if [[ "$( id -u )" == 0 ]]; then
	printf -- '%s\n%s\n' "Error! Do not run as root." "Cancelling..."
	exit 1
fi

if [ ! -d ~/.local/lib/"${pythonVer}"/installed ]; then
	mkdir ~/.local/lib/"${pythonVer}"/installed
fi

printf -- '%s\n' "Upgrading old pip packages..."
pip list -o \
	| grep -v '\^-e' \
	| tee ~/.local/lib/"${pythonVer}"/installed/"$( date +\"%Y%m%d\" )" \
	| grep -Ev 'sdist|--|Latest\s' \
	| cut -d' ' -f1 \
	| xargs -r -n1 pip install --user -U
printf -- '%s\n' "Pip packages upgraded."
exit 0

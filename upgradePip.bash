#!/usr/bin/env bash
# script to update pip, meant for integration in `u`
# DO NOT RUN AS SUPERUSER

# get the python version
# TODO update this to allow double digit version numbers before next release
pythonVer=$( env pip --version | grep -o '\(python [0-3]\.[0-9]\)' | tr -d ' ' )
# set the output location for installed packages at runtime
outputLoc="${HOME}/.local/lib/${pythonVer}/installed/$( date +'%Y-%m-%dT%H:%M:%S' )"

# exit if script is run as root
if [[ "$( id -u )" == 0 ]]; then
	printf -- '%s\n%s\n' "Error! Do not run as root." "Cancelling..."
	exit 1
fi

# checks if output folder exists by removing the filename with substring extraction
if [[ ! -d "${outputLoc:0:(-20)}" ]]; then
	mkdir "${outputLoc:0:(-20)}"
fi

# upgrade pip packages by listing and filtering outdated packages, then
# feeding them to pip with xargs
printf -- '%s\n' "Upgrading pip packages..."
pip list -o \
	| grep -v '\^-e' \
	| tee "${outputLoc} "\
	| grep -Ev 'sdist|--|Latest\s' \
	| cut -d' ' -f1 \
	| xargs -r -n1 pip install --user -U && \
printf -- '%s\n' "Pip packages upgraded."
exit 0

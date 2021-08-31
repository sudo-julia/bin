#!/usr/bin/bash
# compile and run a c program

if [ "${1: -2}" != ".c" ]; then
	printf -- "%s is not a valid c file.\n" "$1"
fi

if [ ! -d "./bin" ]; then
	mkdir "./bin"
fi

outfile="./bin/${1:0:-2}"
if [ -z "$outfile" ] && [ "${outfile}" -nt "$1" ]; then
	"$outfile"
else
	cc -Wall -Werror -02 -std=c99 -pedantic "$1" -o "$outfile" &&
		shift &&
		"$outfile" "$@"
fi
unset outfile

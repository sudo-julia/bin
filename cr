#!/usr/bin/bash
# Compile and Run a c program

main() {
	parse_args "$@"

	# NOTE: this can be removed/extended
	if [ "${1: -2}" != ".c" ]; then
		printf -- "%s is not a valid c file.\n" "$1"
	fi

	# set outfile if the user did not set it with an arg
	if [ -z "${outfile+x}" ]; then
		mkdir -p "./bin"
		outfile="./bin/${1:0:-2}"
	fi

  # TODO: add option for custom gcc flags
  # FIXME: make sure this uses arguments on a precompiled version
	if [ -z "$outfile" ] && [ "${outfile}" -nt "$1" ] && [ -z "${recompile+x}" ]; then
    "$outfile"
    exit_code="$?"
    exit "$exit_code"
	else
		cc -Wall -Werror -O2 -std=c99 -pedantic "$1" -o "$outfile" &&
			shift &&
			"$outfile" "$@"
      exit_code="$?"
      exit "$exit_code"
	fi
	unset outfile
}

parse_args() {
	TEMP="$(getopt -o 'ho:r' -l 'help,output:,recompile' -n 'cr' -- "$@")"
	eval set --"$TEMP"
	unset TEMP

	if [ "$#" -eq 1 ]; then
		usage
		exit 1
	fi

	while true; do
		case "$1" in
		'-h' | '--help')
			usage
			exit 0
			;;
		'-o' | '--output')
			outfile="$2"
			shift 2
			continue
			;;
    '-r' | '--recompile')
      recompile=true
      shift
      continue
      ;;
    '--')
      shift
      break
      ;;
    *)
      usage
      exit 0
      ;;
		esac
	done
}

usage() {
	cat <<EOF
Usage: cr [<cr args>] [file] [<file args>]

Arguments are:
  -h, --help           Display this help and exit
  -o, --output <file>  Output to <file>
  -r, --recompile      Recompile the input file, even if there's a compiled
                       version that's up to date
EOF
}

main "$@"
exit 0

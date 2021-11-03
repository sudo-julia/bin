#!/usr/bin/bash
# Compile and Run a c program
# shellcheck disable=SC2086
# TODO: add a "norun" option
set -e

main() {
  parse_args "$@"

  is_valid_filetype "$1"

  # set outfile if the user did not set it with an arg
  if [ -z "${outfile+x}" ]; then
    mkdir -p "./build"
    outfile="./build/${1:0:-2}"
  fi

  # FIXME: make sure this uses arguments on a precompiled version
  if [ "${outfile}" -nt "$1" ] && [ -z "${recompile+x}" ]; then
    "$outfile" $prog_flags
    exit_code="$?"
    exit "$exit_code"
  else
    #cc $flags "$1" &&
    cc -Wall -Werror -O2 -std=c99 -pedantic -o "$outfile" "$1" &&
      shift &&
      "$outfile" $prog_flags
    exit_code="$?"
    exit "$exit_code"
  fi
  unset outfile
}

is_valid_filetype() {
  ft="${1##*.}"
  declare -a valid_fts
  valid_fts=(c cpp rs)
  if ! printf '%s\n' "${valid_fts[@]}" | grep -xq "$ft"; then
    printf -- 'Invalid filetype.\n'
    exit 1
  fi
  return 0
}

parse_args() {
  TEMP="$(getopt -o 'f:hno:r' -l 'flags:,help,noflags,output:,recompile' -n 'cr' -- "$@")"
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
    '-n' | '--noflags')
      noflags=true
      shift
      continue
      ;;
    '-p' | '--program-flags')
      prog_flags="$2"
      shift 2
      continue
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
    '-v' | '--verbose')
      verbose=true
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
  -f, --compiler-flags <flags>  Flags to pass to the compiler (surround in quotes)
  -n, --noflags                 Pass no flags to the compiler
  -p, --program-flags <flags>   Flags to pass to the compiled program (surround in quotes)
  -o, --output <file>           Output to <file>
  -r, --recompile               Recompile the input file, even if there's a compiled
                                version that's up to date
  -h, --help                    Display this help and exit
EOF
}

main "$@"
exit 0

#!/usr/bin/env python3
"""Compile and run a program with cc"""

from __future__ import annotations
import argparse
import os
from pathlib import Path
from subprocess import CalledProcessError, run
from sys import stderr


def parse_args():
    """Parse arguments and return the argparse namespace"""
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="The file to compile and run.")
    parser.add_argument(
        "-t",
        "--tmp",
        action="store_true",
        help="Recompile the source file, even if one exists",
    )
    return parser.parse_args()


def print_error(msg):
    """Print a message to stderr"""
    print(msg, file=stderr)


def die(msg, exit_code=1):
    """Print a message to stderr and exit with failure"""
    print_error(msg)
    raise SystemExit(exit_code)


def compile(
    file,
    outfile,
    quiet=False,
    compiler_flags="-Wall -Werror -O2 -std=c99 -pedantic -o {} {}",
):
    """:"""
    cmd: list[str] = ["cc", compiler_flags.format(file, outfile).split()]
    if not quiet:
        print(f"Running {join(cmd)}...")
    try:
        run(cmd, check=True, capture_output=True)
    except CalledProcessError:
        ...


def main():
    """:"""
    ...


if __name__ == "__main__":
    main()

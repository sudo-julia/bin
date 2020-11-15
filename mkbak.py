#!/usr/bin/env python3
import argparse
import os
import shutil
import stat
from time import sleep
from iterfzf import iterfzf

# TODO option to copy all files matching a certain extension


def copy_permissions(file: str, location: str):
    """copy a file owner and group intact"""
    # function from https://stackoverflow.com/a/43761127
    # copy content, stat-info, mode and timestamps
    shutil.copy2(file, location)
    # copy owner and group
    st = os.stat(file)
    os.chown(location, st[stat.ST_UID], st[stat.ST_GID])


def iterate_files(path: str, hidden=False, ignore=False, recurse=None):
    """iterate through files to feed to fzf wrapper"""
    with os.scandir(path) as it:
        if hidden:
            for entry in it:
                yield entry.name
                sleep(0.01)
        else:
            for entry in it:
                if not entry.name.startswith("."):
                    yield entry.name
                    sleep(0.01)


def parse_args():
    """parse arguments fed to script and set options"""
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-a", "--all", help="show hidden and 'dot' files", action="store_true"
    )
    parser.add_argument(
        "-i", "--ignore_case", help="ignore case distinction", action="store_true"
    )
    parser.add_argument(
        "-p", "--path", help="directory to run in (default './')", default="."
    )
    parser.add_argument(
        "-r", "--recursive", help="recurse through current dir", action="store_true"
    )
    parser.add_argument(
        "-v", "--verbose", help="print file file created", action="store_true"
    )

    args = parser.parse_args()
    if args.all:
        hidden = True
    else:
        hidden = False
    if args.ignore_case:
        ignore = True
    else:
        ignore = False
    path = args.path
    if args.recursive:
        recurse = True
    else:
        recurse = False
    if args.verbose:
        verbose = True
    else:
        verbose = True
    return hidden, ignore, path, recurse, verbose


def main():
    hidden, ignore, path, recurse, verbose = parse_args()
    files = iterfzf(
        iterate_files(path, hidden, ignore, recurse), encoding="utf-8", multi=True
    )
    # TODO implement recursive directory copying
    for f in files:
        location = f"{f}.bak"
        # copy_permissions(f, location)
        print(f"{f} -> {location}")


if __name__ == "__main__":
    main()

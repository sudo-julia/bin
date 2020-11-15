#!/usr/bin/env python3
import argparse
import os
import shutil
import stat
from time import sleep
from iterfzf import iterfzf


__version__ = "v0.1.0"
# TODO monkeypatch iterfzf to change height of display


def copy_permissions(file: str, location: str):
    """copy a file owner and group intact"""
    # function from https://stackoverflow.com/a/43761127
    # copy content, stat-info, mode and timestamps
    try:
        shutil.copytree(file, location)
    except NotADirectoryError:
        shutil.copy2(file, location)
    # copy owner and group
    st = os.stat(file)
    os.chown(location, st[stat.ST_UID], st[stat.ST_GID])


def iterate_files(path: str, hidden=False, recurse=None):
    """iterate through files to feed to fzf wrapper"""
    with os.scandir(path) as it:
        if not hidden:
            for entry in it:
                if not entry.name.startswith("."):
                    yield entry.name
                    sleep(0.01)
        else:
            for entry in it:
                yield entry.name
                sleep(0.01)


def parse_args():
    """parse arguments fed to script and set options"""
    # TODO argument to copy all files of an extension
    # TODO arg for color depending on filetype
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-a", "--all", help="show hidden and 'dot' files", action="store_true"
    )
    parser.add_argument("-e", "--exact", help="exact matching", action="store_true")
    parser.add_argument(
        "-i", "--ignore_case", help="ignore case distinction", action="store_true"
    )
    parser.add_argument(
        "-p", "--path", help="directory to run in (default './')", default="."
    )
    parser.add_argument(
        "--preview", help="starts external process with current line as arg"
    )
    parser.add_argument(
        "-r", "--recursive", help="recurse through current dir", action="store_true"
    )
    parser.add_argument(
        "-v", "--verbose", help="print file file created", action="store_true"
    )
    parser.add_argument("--version", help="print version number", action="store_true")

    args = parser.parse_args()
    if args.all:
        hidden = True
    else:
        hidden = False
    if args.exact:
        exact = True
    else:
        exact = False
    if args.ignore_case:
        ignore = False
    else:
        ignore = None
    path = args.path
    if args.preview:
        preview = args.preview
    else:
        preview = None
    if args.recursive:
        recurse = True
    else:
        recurse = False
    if args.verbose:
        verbose = True
    else:
        verbose = False
    if args.version:
        print(f"mkbak.py {__version__}")
    return exact, hidden, ignore, path, preview, recurse, verbose


def main():
    exact, hidden, ignore, path, preview, recurse, verbose = parse_args()
    files = iterfzf(
        iterable=iterate_files(path, hidden, recurse),
        case_sensitive=ignore,
        exact=exact,
        encoding="utf-8",
        preview=preview,
        multi=True,
    )
    # TODO implement recursive directory copying
    try:
        for f in files:
            location = f"{f}.bak"
            copy_permissions(f, location)
            if verbose:
                print(f"{f} -> {location}")
        exit(0)
    except TypeError:
        exit(1)


if __name__ == "__main__":
    main()

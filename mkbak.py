#!/usr/bin/env python3
import argparse
import os
import shutil
import stat
from iterfzf import iterfzf


__version__ = "v0.3.4"


def copy_all(file: str, location: str):
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


def iterate_files(path: str, filetype: str, hidden=False) -> list[str]:
    """iterate through files as DirEntries to feed to fzf wrapper"""
    with os.scandir(path) as it:
        if filetype:
            for entry in it:
                if not hidden and entry.name.startswith("."):
                    pass
                else:
                    if entry.name.endswith(filetype):
                        try:
                            yield entry.path
                        except PermissionError:
                            pass
        elif not filetype:
            for entry in it:
                if not hidden and entry.name.startswith("."):
                    pass
                else:
                    try:
                        yield entry.path
                    except PermissionError:
                        pass


def main():
    filetype, exact, hidden, ignore, path, preview, recurse, verbose = parse_args()

    if not recurse:
        files = iterfzf(
            iterable=(iterate_files(path, filetype, hidden)),
            case_sensitive=ignore,
            exact=exact,
            encoding="utf-8",
            preview=preview,
            multi=True,
        )
    else:
        files = iterfzf(
            iterable=(recursive(path, hidden)),
            case_sensitive=ignore,
            exact=exact,
            encoding="utf-8",
            preview=preview,
            multi=True,
        )

    try:
        for f in files:
            location = f"{f}.bak"
            copy_all(f, location)
            if verbose:
                print(f"{f} -> {location}")
    except TypeError:
        pass

    exit(0)


def parse_args():
    """parse arguments fed to script and set options"""
    # TODO make extension copying recursive
    # TODO arg addition to recursive that allows for depth to recurse
    parser = argparse.ArgumentParser()
    main_args = parser.add_argument_group()
    matching_group = parser.add_mutually_exclusive_group()

    main_args.add_argument(
        "-a", "--all", help="show hidden and 'dot' files", action="store_true"
    )
    matching_group.add_argument(
        "-e", "--exact", help="exact matching", action="store_true"
    )
    matching_group.add_argument(
        "-f",
        "--filetype",
        help="only find files of a provided extension. recursion not supported",
        type=str,
    )
    matching_group.add_argument(
        "-i", "--ignore_case", help="ignore case distinction", action="store_true"
    )
    main_args.add_argument(
        "-p", "--path", help="directory to run in (default './')", default=".", type=str
    )
    main_args.add_argument(
        "--preview", help="starts external process with current line as arg", type=str
    )
    main_args.add_argument(
        "-r", "--recursive", help="recurse through current dir", action="store_true"
    )
    main_args.add_argument(
        "-v", "--verbose", help="print file file created", action="store_true"
    )
    parser.add_argument("--version", help="print version number", action="store_true")

    args = parser.parse_args()
    if args.version:
        print(f"mkbak.py {__version__}")
        exit(0)
    if args.all:
        hidden = True
    else:
        hidden = None
    if args.exact:
        exact = True
    else:
        exact = False
    if args.filetype:
        filetype = str(args.filetype)
    else:
        filetype = None
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

    return filetype, exact, hidden, ignore, path, preview, recurse, verbose


def recursive(path: str, hidden=None) -> list[str]:
    """recursively yield DirEntries"""
    with os.scandir(path) as it:
        for entry in it:
            if not hidden and entry.name.startswith("."):
                pass
            else:
                try:
                    if entry.is_dir(follow_symlinks=False):
                        yield from recursive(entry.path, hidden)
                    else:
                        yield entry.path
                except PermissionError:
                    pass


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
import argparse
import os
import shutil
import stat
from iterfzf import iterfzf


__version__ = "v0.3.3-1"
# TODO monkeypatch iterfzf to change height of display


def copy_all(file: str, location: str):
    """copy a file owner and group intact"""
    # TODO check if this properly copies permissions of files in dirs
    # function from https://stackoverflow.com/a/43761127
    # copy content, stat-info, mode and timestamps
    try:
        shutil.copytree(file, location)
    except NotADirectoryError:
        shutil.copy2(file, location)
    # copy owner and group
    st = os.stat(file)
    os.chown(location, st[stat.ST_UID], st[stat.ST_GID])


def iterate_files(path: str, hidden=False):
    """iterate through files as DirEntries to feed to fzf wrapper"""
    with os.scandir(path) as it:
        if hidden:
            for entry in it:
                try:
                    yield entry.path
                except PermissionError:
                    pass
        else:
            for entry in it:
                try:
                    if entry.name.startswith("."):
                        pass
                    else:
                        yield entry.path
                except PermissionError:
                    pass


def main():
    exact, hidden, ignore, path, preview, recurse, verbose = parse_args()

    if recurse:
        files = iterfzf(
            iterable=(recursive(path, hidden)),
            case_sensitive=ignore,
            exact=exact,
            encoding="utf-8",
            preview=preview,
            multi=True,
        )
    else:
        files = iterfzf(
            iterable=(iterate_files(path, hidden)),
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
    # TODO argument to copy all files of an extension
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
        "-i", "--ignore_case", help="ignore case distinction", action="store_true"
    )
    main_args.add_argument(
        "-p", "--path", help="directory to run in (default './')", default="."
    )
    main_args.add_argument(
        "--preview", help="starts external process with current line as arg"
    )
    main_args.add_argument(
        "-r", "--recursive", help="recurse through current dir", action="store_true"
    )
    main_args.add_argument(
        "-v", "--verbose", help="print file file created", action="store_true"
    )
    parser.add_argument("--version", help="print version number", action="store_true")

    args = parser.parse_args()
    if args.all:
        hidden = True
    else:
        hidden = None
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
        exit(0)

    return exact, hidden, ignore, path, preview, recurse, verbose


def recursive(path: str, hidden=None):
    """recursively yield DirEntries"""
    with os.scandir(path) as it:
        if not hidden:
            for entry in it:
                try:
                    if entry.name.startswith("."):
                        pass
                    else:
                        if entry.is_dir():
                            yield from recursive(entry.path)
                        else:
                            yield entry.path
                except PermissionError:
                    pass
        else:
            for entry in it:
                # if the entry is a dir, follow it with this function
                try:
                    if entry.is_dir(follow_symlinks=False):
                        yield from recursive(entry.path, hidden=True)
                    else:
                        yield entry.path
                except PermissionError:
                    pass


if __name__ == "__main__":
    main()

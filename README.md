# homemade utilities

This branch is for the ~/bin folder on my FreeBSD machine. All scripts are
either POSIX compliant or run with a standard install of Python 3

- [`change-bright`](./change-bright):
  adjusts monitor brightness

- [`check-display`](./check-display):
  runs at xstart to organize monitors and other display-tangential programs

- [`clean-symlinks`](./clean-symlinks):
  deletes broken symlinks

- [`cr`](./cr):
  compiles and runs a c program with any other arguments provided

- [`dmsn`](./dmsn):
  get the dimensions of an image

- [`ext-backup`](./ext-backup):
  creates backups to an external drive

- [`gen-license`](./gen-license):
  generates a license file for you based off of $USER and the current year

- [`get-installed`](./get-installed):
  grabs all installed programs and saves them in a folder

- [`gitignore`](./gitignore)
  interactively select a gitignore for the current directory

- [`note`](./note):
  opens up a text note

- [`picom-restart.sh`]:
  restart picom. meant to be called from [`check-display`](./check-display),
  hence the extension

- [`pint`](./pint):
  interfaces with `yay` for interactive package management

- [`pvw`](./pvw):
  previews files as pdfs

- [`pyformat`](./pyformat):
  formats and lints a python file

-[`python-gitignore`](./python-gitignore):
creates a `.gitignore` for a Python project in the current directory

- [`spotlight`](./spotlight):
  a searcher that will eventually mimic the spotlight search in OSX

- [`startups`](./startups):
  programs that get run every time my computer starts

- [`u`](./u):
  updates packages (intended for pacman/yay)

  - requires [informant](https://github.com/bradford-smith94/informant),
    [pacman-contrib](https://git.archlinux.org/pacman-contrib.git/about) and [yay](https://github.com/Jguer/yay)

- [`upgrade-zinit`](./upgrade-zinit):
  upgrades zinit and any zsh plugins

- [`usbguard-interactive`](./usbguard-interactive):
  interfaces with usbguard for interactive choices

- [`volume`](./volume):
  changes the volume and shows adjusted levels via dunst

- [`week_from.py`](./week_from.py):
  tells you the week from a given ISO 8601 date

- [`wttr`](./wttr):
  gets the weather _(this one's from wttr.io, but i tweaked a few things)_

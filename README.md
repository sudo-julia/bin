# homemade utilities

This repo is my ~/bin folder. [./posix](./posix) contains POSIX versions of
some of the scripts.

- [`change-bright`](./change-bright):
adjusts monitor brightness

- [`check-display`](./check-display):
runs at xstart to organize monitors and other display-tangential programs

- [`clean-symlinks`](./clean-symlinks):
deletes broken symlinks

- [`ext-backup`](./ext-backup):
creates backups to an external drive

- [`gen-license`](./gen-license):
generates a license file for you based off of $USER and the current year

- [`get-installed`](./get-installed):
grabs all installed programs and saves them in a folder

- [`note`](./note):
opens up a text note

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

- [`upgrade-pip`](./upgrade-pip):
updates outdated python packages with pip

- [`upgrade-zinit`](./upgrade-zinit):
upgrades zinit and any zsh plugins

- [`usbguard-interactive`](./usbguard-interactive):
interfaces with usbguard for interactive choices

- [`volume`](./volume):
changes the volume and shows adjusted levels via dunst

- [`week_from.py`](./week_from.py):
tells you the week from a given ISO 8601 date

- [`wttr`](./wttr):
gets the weather *(this one's from wttr.io, but i tweaked a few things)*

# My scripts
------------

- `changeBright.zsh` adjusts the brightness of your laptop and one external monitor, depending on the argument given

- `displayCheck.bash` launches picom and polybar, and will use an external monitor if one is plugged in

- `extBackup.bash` is script to backup to a LUKS encrypted external drive

- `getInstalled.bash` grabs all installed programs and backs them up to a folder
  - also separates AUR/local packages into a separate file

- `mkbak.py` finds files, pipes them through `fzf` with `iterfzf`, and allows you to select files to create backups of
  - requires [iterfzf](https://github.com/dahlia/iterfzf)
  - only runs with python3.6 or higher

- `recordWindow.sh` records the current window in the background
  - this script has been moved to my [zshrc](https://github.com/sudo-julia/.dotfiles/blob/master/zshrc) as a function
  - requires [giph](https://github.com/phisch/giph)

- `u` is an updater script for Arch Linux
  - requires [informant](https://github.com/bradford-smith94/informant), [pacman-contrib](https://git.archlinux.org/pacman-contrib.git/about) and [yay](https://github.com/Jguer/yay)

- `updatePip.bash` updates outdated python packages with pip

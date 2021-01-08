# My scripts

- [`changeBright`](https://github.com/sudo-julia/bin/blob/main/changeBright) adjusts the brightness of your laptop and one external monitor, depending on the argument given

- [`checkDisplay`](https://github.com/sudo-julia/bin/blob/main/checkDisplay) launches picom and polybar, and will use an external monitor if one is plugged in

- [`extBackup`](https://github.com/sudo-julia/bin/blob/main/checkDisplay) is script to backup to a LUKS encrypted external drive

- [`getInstalled`](https://github.com/sudo-julia/bin/blob/main/getInstalled) grabs all installed programs and backs them up to a folder
  - also separates AUR/local packages into a separate file

- `mkbak.py` finds files, pipes them through `fzf` with `iterfzf`, and allows you to select files to create backups of
  - `mkbak.py` has been moved to its [own repository](https://github.com/sudo-julia/mkbak)
  - requires [iterfzf](https://github.com/dahlia/iterfzf)
    - if you want the height option, (it's pretty nice), use my [fork](https://github.com/sudo-julia/iterfzf)
  - only runs with Python3.6 or higher

- [`u`](https://github.com/sudo-julia/bin/blob/main/u) is an updater script for Arch Linux
  - requires [informant](https://github.com/bradford-smith94/informant), [pacman-contrib](https://git.archlinux.org/pacman-contrib.git/about) and [yay](https://github.com/Jguer/yay)

- [`updatePip`](https://github.com/sudo-julia/bin/blob/main/updatePip) updates outdated python packages with pip

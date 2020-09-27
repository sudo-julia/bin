# My scripts
------------

- `brightLimits.zsh` sets the brightness to a maximum or minimum level defined by the user (dual monitor)
  - with all of these, they might not work on your system as they're written for my specific hardware

- `displayCheck.bash` launches compositor and statusbar, will use an external monitor if one is plugged in

- `extBackup.bash` is my backup script for my external drive

- `getInstalled.bash` grabs all installed programs and backs them up to a folder
  - also separates AUR/local packages into a separate file

- `mkbak.bash` create backups of files
  - requires [fzf](https://github.com/junegunn/fzf)
  - the fanciest wrapper to `cp` you'll ever see

- `u` is my updater script
  - requires [informant](https://github.com/bradford-smith94/informant), [pacman-contrib](https://git.archlinux.org/pacman-contrib.git/about) and  [yay](https://github.com/Jguer/yay)
  - this one has some probably unnecessary bits, but was the first "big" script I wrote so cut me some slack

- `updatePip.bash` updates any old pip packages

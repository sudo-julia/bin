# My scripts
------------

- `brightDown.sh` lowers brightness (dual monitor)
- `brightUp.sh` raises brightness (dual monitor)
- `brightLimits.sh` sets the brightness to a maximum or minimum level defined by the user (dual monitor)
  - with all of these, they might not work on your system as they're written for my specific hardware

- `displayCheck.sh` launches compositor and statusbar, will use an external monitor if one is plugged in

- `extBackup` is my backup script for my external drive

- `getInstalled.sh` grabs all installed programs and backs them up to a folder
  - also separates AUR/local packages into a separate file

- `mkbak.sh` create backups of files
  - requires [fzf](https://github.com/junegunn/fzf)

- `u` is my updater script
  - requires [informant](https://github.com/bradford-smith94/informant) and [yay](https://github.com/Jguer/yay)
  - this one has some probably unnecessary bits, but was the first "big" script I wrote so cut me some slack

- `updatePip.sh` updates any old pip packages

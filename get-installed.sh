#!/usr/bin/env bash
# send lists of installed programs to dir specified by date

DATE=$(date "+%y%m%d")
DIR=/home/jam/Documents/Misc/Installed/$DATE

mkdir "$DIR"
pacman -Q > "$DIR"/all
cut -d' ' -f1 "$DIR"/all > "$DIR"/no_version
pacman -Qm | cut -d' ' -f1 > "$DIR"/aur
diff -y "$DIR"/no_version "$DIR"/aur | awk '{print $2}' | sed '/</d' > "$DIR"/no_aur
printf "Installed programs backed up to %s\n" "$DIR"

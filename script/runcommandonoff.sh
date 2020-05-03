#!/bin/bash

HEIGHT=10
WIDTH=60
BACKTITLE="JammaPi Menù"
TITLE="Abilita/Disabilita Runcommand RetroPie"
MENU="Scegliere un opzione:"

OPTIONS=(1 "Abilita Runcommand RetroPie"
         2 "Disabilita Runcommand RetroPie")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1) bash /home/pi/JammaPi/script/pixelperfect.sh -runc-on ;;
        2) bash /home/pi/JammaPi/script/pixelperfect.sh -runc-off
           bash /home/pi/JammaPi/script/pixelperfect.sh -off;;
esac
bash ~/JammaPi/script/menu.sh

#!/bin/bash

HEIGHT=10
WIDTH=60
BACKTITLE="JammaPi Menù"
TITLE="Abilita/Disabilita Joystick JammaPi"
MENU="Scegliere un opzione:"

OPTIONS=(1 "Abilita Joystick JammaPi"
         2 "Disabilita Joystick JammaPi")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1) bash /home/pi/JammaPi/script/interfaccia.sh -JSON ;;
        2) bash /home/pi/JammaPi/script/interfaccia.sh -JSOFF ;;
esac
bash ~/JammaPi/script/menu.sh

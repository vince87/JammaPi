#!/bin/bash

HEIGHT=20
WIDTH=40
BACKTITLE="JammaPi Menù"
TITLE="JammaPi Menù"
MENU="Scegliere un opzione:"

OPTIONS=(1 "Aggiorna Script"
         2 "Abilita/Disabilita controlli analogici"
         3 "Abilita/Disabilita Joystick"
         4 "Abilita/Disabilita JammaPi"
         5 "Abilita/Disabilita Runcommand RetroPie"
         6 "Switch  VGA 31Khz/JAMMA 15Khz/HDMI"
         7 "Menù audio"
         8 "Abilita/Disabilita Kiosk Mode"
         9 "Lancia script richiesto")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1) bash ~/JammaPi/script/updatescript.sh ;;
        2) bash ~/JammaPi/script/analogjs.sh ;;
        3) bash ~/JammaPi/script/joystickonoff.sh ;;
        4) bash ~/JammaPi/script/jammapionoff.sh ;;
        5) bash ~/JammaPi/script/runcommandonoff.sh ;;
        6) bash ~/JammaPi/script/switchvideo.sh ;;
        7) bash ~/JammaPi/script/audio.sh ;;
        8) bash ~/JammaPi/script/kiosk.sh ;;
        9)
        if test -f "/boot/personalizzazione.sh"; then
          echo "$FILE esite!"
          bash /boot/richiesta.sh
          sleep 2
        else
          dialog --title "Hello" --msgbox 'File mancante!' 6 20
          bash ~/JammaPi/script/menu.sh
        fi
        ;;
esac

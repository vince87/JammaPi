#!/bin/bash

HEIGHT=10
WIDTH=60
BACKTITLE="JammaPi Menù"
TITLE="Abilita/Disabilita Kiosk Mode Retropie"
MENU="Scegliere un opzione:"

OPTIONS=(1 "Abilita Kiosk Mode"
         2 "Disabilita Kiosk Mode")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1) 
          echo "Attivo Kiosk Mode Retropie!"
          sudo perl -p -i -e 's/\<string name="UIMode" value="Full" \/\>/\<string name="UIMode" value="Kiosk" \/\>/g' /home/pi/.emulationstation/es_settings.cfg
          echo "Modifiche effettuate!"
          sleep 2
          echo "Riavvio in corso!"
          sudo reboot
        ;;
        2) 
          echo "Disattivo Kiosk Mode Retropie!"
          sudo perl -p -i -e 's/\<string name="UIMode" value="Kiosk" \/\>/\<string name="UIMode" value="Full" \/\>/g' /home/pi/.emulationstation/es_settings.cfg
          echo "Modifiche effettuate!"
          sleep 2
          echo "Riavvio in corso!"
          sudo reboot
        ;;
esac

bash ~/JammaPi/script/menu.sh

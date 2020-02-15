
#!/bin/bash

HEIGHT=10
WIDTH=60
BACKTITLE="JammaPi Menù"
TITLE="Abilita/Disabilita JammaPi"
MENU="Scegliere un opzione:"

OPTIONS=(1 "Abilita JammaPi"
         2 "Disabilita JammaPi")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1) bash /home/pi/JammaPi/script/interfaccia.sh -JAMMA ;;
        2) bash /home/pi/JammaPi/script/interfaccia.sh -HDMI ;;
esac
bash ~/JammaPi/script/menu.sh

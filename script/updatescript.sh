#!/bin/bash
dialog --title "JammaPi aggiorna script" \
            --backtitle "JammaPi Menù" \
            --yesno "Vuoi aggiornare lo script della JammaPi? \n Al termine sarà riavviato il sistema!" 7 60
            response=$?
case $response in
               0)
                  cd ~/JammaPi
                  git reset --hard origin/master
                  git pull
                  wget -O - https://raw.githubusercontent.com/vince87/JammaPi/master/install.sh | bash
               ;;
               1)
                  bash ~/JammaPi/script/menu.sh
               ;;
            esac


#!/bin/bash
########################################################
## Vincenzo Bini 22/08/2019
## Versione 0.1
#########################################################

  printf "\033[1;31m Attivo Driver Joystick \033[0m\n"
  
  lsmod | grep 'joypi' > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
  	sudo modprobe joypi
  else
  	cd ~/JammaPi/joypi/
	make
	sudo make install
	sudo insmod joypi.ko
	modprobe joypi
  fi
  
  CRT=/boot/JAMMA.txt
  VGA=/boot/VGA.txt
  HDMI=/boot/HDMI.txt
  
  SCRIPT=/boot/autorun.jammapi
   
  ##Check if JammaPi script is installed
  sudo grep 'dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Script JammaPi installato: procedo!"
	else
	echo "Script JammaPi non installato!"
	echo "!!!!!ERRORE!!!!!"
	sleep 5
	exit
	fi
  
  ##Check if exist CRT
  printf "\033[1;31m Controllo se esiste il file CRT \033[0m\n"
  if test -f "$CRT"; then
    echo "$FILE esite!"
    bash /home/pi/JammaPi/script/interfaccia.sh -JAMMA
    printf "\033[0;32m !!!SWITCH COMPLETATO!!! \033[0m\n"
    printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
    sudo rm /boot/JAMMA.txt
    sleep 5
    sudo reboot
  else
    printf "\033[0;32m Skip! \033[0m\n"
  fi
     
  ##Check if exist VGA
  printf "\033[1;31m Controllo se esiste il file VGA \033[0m\n"
  if test -f "$VGA"; then
    echo "$FILE esite!"
    bash /home/pi/JammaPi/script/interfaccia.sh -VGA
    printf "\033[0;32m !!!SWITCH COMPLETATO!!! \033[0m\n"
    printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
    sudo rm /boot/VGA.txt
    sleep 5
    sudo reboot
  else
  printf "\033[0;32m Skip! \033[0m\n"
  fi
   
  ##Check if exist HDMI
  printf "\033[1;31m Controllo se esiste il file HDMI \033[0m\n"
  if test -f "$HDMI"; then
    echo "$FILE esite!"
    bash /home/pi/JammaPi/script/interfaccia.sh -HDMI
    printf "\033[0;32m !!!SWITCH COMPLETATO!!! \033[0m\n"
    printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
    sudo rm /boot/HDMI.txt
    sleep 5
    sudo reboot
  else
    printf "\033[0;32m Skip! \033[0m\n"
  fi
  
    ##Check if exist autorun.jammapi
  printf "\033[1;31m Controllo se esiste il file autorun.jammapi \033[0m\n"
  if test -f "$SCRIPT"; then
    echo "$FILE esite!"
    bash /boot/autorun.jammapi
    sudo rm /boot/autorun.jammapi
    sleep 5
    sudo reboot
  else
    printf "\033[0;32m Skip! \033[0m\n"
  fi

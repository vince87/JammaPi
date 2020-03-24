#!/bin/bash
########################################################
## Vincenzo Bini 22/08/2019
## Versione 0.1
#########################################################

  printf "\033[1;31m Attivo Driver Joystick \033[0m\n"
  
  sudo modprobe joypi
  lsmod | grep 'joypi' > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
  	echo "Modulo abilitato!"
  else
  	cd ~/JammaPi/joypi/
	make
	sudo make install
	sudo insmod joypi.ko
	modprobe joypi
  fi
  
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

sudo grep '#CRT' /boot/config.txt > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
    current=0
  fi
sudo grep '#VGA' /boot/config.txt > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
    current=1
  fi
sudo grep '#HDMI' /boot/config.txt > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
    current=2
  fi

plex1=$(gpio read 14)
plex2=$(gpio read 12)

echo $plex1
echo $plex2

if [ $plex1 = 0 ] && [ $plex2 = 0 ]; then
  echo "JAMMA/SCART"
  if [ $current != 0 ]; then
    bash /home/pi/JammaPi/script/interfaccia.sh -JAMMA
    printf "\033[0;32m !!!SWITCH COMPLETATO!!! \033[0m\n"
    printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
    sleep 5
    #sudo reboot
  fi
fi

if [ $plex1 = 0 ] && [ $plex2 = 1 ]; then
  echo "VGA"
  if [ $current != 1 ]; then
    bash /home/pi/JammaPi/script/interfaccia.sh -VGA
    printf "\033[0;32m !!!SWITCH COMPLETATO!!! \033[0m\n"
    printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
    sleep 5
    #sudo reboot
  fi
fi

if [ $plex1 = 1 ] && [ $plex2 = 0 ]
then
  echo "HDMI"
  if [ $current != 2 ]; then 
    bash /home/pi/JammaPi/script/interfaccia.sh -HDMI
    printf "\033[0;32m !!!SWITCH COMPLETATO!!! \033[0m\n"
    printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
    sleep 5
    #sudo reboot
  fi
fi

if [ $plex1 = 1 ] && [ $plex2 = 1 ]
then
  echo "!ILLEGAL!"
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

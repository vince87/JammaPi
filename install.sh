#!/bin/bash
########################################################
## Vincenzo Bini 03/04/2020
## Versione 1.1
#########################################################

sudo apt-get update
sudo apt-get install -y git libjpeg-dev dialog
cd ~
git clone https://github.com/vince87/JammaPi.git
cd ~/JammaPi
git reset --hard origin/master
git pull
chmod +x install.sh
test -d "~/JammaPi" && echo Exists || echo Does not exist; break

dialog --title "Script installazione JammaPi" --msgbox "Attenzione verranno ora installati i driver per il corretto funzionamento della Jammapi.
\n \nSe stai usando un immagine custom, non scaricata da retropie.org.uk, accertati di aver disattivato tutti gli script che usano i GPIO.
\n \nTerminata l'installazione ti verrà chiesto che uscita video abilitare! " 14 60

lsmod | grep 'joypi' > /dev/null 2>&1
  if [ $? -eq 0 ] ; then
  	echo "Kernel ok!"
  else
  	sudo apt-get install --reinstall -y raspberrypi-bootloader raspberrypi-kernel raspberrypi-kernel-headers
	cd /tmp
	wget https://project-downloads.drogon.net/wiringpi-latest.deb
	sudo dpkg -i wiringpi-latest.deb
  fi

##install jammapi overlay
	cd ~/JammaPi
	printf "\033[1;31m Modifico il config.txt per la JammaPi \033[0m\n"
	sudo grep 'dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Config.txt già modificato!"
	else
	printf "\033[1;31m Installo overlay JammaPi \033[0m\n"
	sudo rm /boot/overlays/vga666.dtbo
	sudo cp vga666.dtbo /boot/overlays/vga666.dtbo
	sudo rm /boot/dt-blob.bin
	sudo cp dt-blob.bin /boot/dt-blob.bin
	sudo rm /etc/asound.conf
	sudo ln -s /home/pi/JammaPi/script/asound.conf /etc/asound.conf
	sleep 2

  ##Modify Config.txt to Default
	sudo perl -p -i -e 's/#hdmi_force_hotplug/hdmi_force_hotplug/g' /boot/config.txt
	sudo sh -c "echo 'dtparam=i2c_vc=on' >> /boot/config.txt"
	sudo sh -c "echo 'audio_pwm_mode=3' >> /boot/config.txt"
	sudo grep 'Pi 4' /proc/device-tree/model > /dev/null 2>&1 
		if [ $? -eq 0 ] ; then
        	sudo sh -c "echo 'dtoverlay=audremap,pins_18_19' >> /boot/config.txt"
		else
		sudo sh -c "echo 'dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2' >> /boot/config.txt"
		fi
	sudo sh -c "echo 'disable_audio_dither=1' >> /boot/config.txt"
	sudo sh -c "echo 'dtoverlay=vga666,mode6' >> /boot/config.txt"
	sudo sh -c "echo 'enable_dpi_lcd=1' >> /boot/config.txt"
	sudo sh -c "echo 'display_default_lcd=1' >> /boot/config.txt"
	sudo sh -c "echo 'dpi_output_format=6' >> /boot/config.txt"
	sudo sh -c "echo 'dpi_group=2' >> /boot/config.txt"
	sudo sh -c "echo 'dpi_mode=87' >> /boot/config.txt"
	sudo sh -c "echo 'hdmi_timings=480 1 14 45 56 300 1 10 5 5 0 0 0 60 0 9600000 1' >> /boot/config.txt"
	sudo sh -c "echo '#CRT' >> /boot/config.txt"
	echo "Config.txt modificato!"
	fi
	sleep 2

##install jammapi led driver
	printf "\033[1;31m Installo led \033[0m\n"
	sudo grep 'act-led,gpio=27' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Config.txt già modificato!"
	else
	sudo sh -c "echo 'dtoverlay=act-led,gpio=27,activelow=on' >> /boot/config.txt"
	sudo sh -c "echo 'gpio=26=op,dl' >> /boot/config.txt"
	echo "Modulo impostato!"
	fi
	sleep 2

##install jammapi joystick driver
	
	printf "\033[1;31m Installo driver Joystick \033[0m\n"
	lsmod | grep joypi > /dev/null 2>&1
        if [ $? -eq 0 ] ; then
        echo "Joystick già installato!"
        else
	sudo sh -c "echo 'i2c-dev' >> /etc/modules"
	cd ~/JammaPi/joypi/
	make clean
	make
	sudo make install
	sudo insmod joypi.ko
	echo "Modulo impostato!"
	ln -s /home/pi/JammaPi/joypi/JoyPi\ Joystick\ 0.cfg /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
	ln -s /home/pi/JammaPi/joypi/JoyPi\ Joystick\ 1.cfg /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
	sudo mv ~/.emulationstation/es_input.cfg ~/.emulationstation/es_input.bak
	ln -s /home/pi/JammaPi/joypi/es_input.cfg /opt/retropie/configs/all/emulationstation/es_input.cfg
        fi
	sleep 2
	
##install jammapi service and script script
	chmod u+x ~/JammaPi/script/pixelperfect.sh
	chmod u+x ~/JammaPi/script/interfaccia.sh
	chmod u+x ~/JammaPi/script/jammapi.sh
	sudo ln -s /home/pi/JammaPi/services/jammapi.service /etc/systemd/system/jammapi.service
	sudo ln -s /home/pi/JammaPi/services/jammapi_joystick.service /etc/systemd/system/jammapi_joystick.service
	sudo systemctl daemon-reload
	sudo systemctl enable jammapi.service
	sudo systemctl start jammapi.service &
	sudo systemctl enable jammapi_joystick.service
	sudo systemctl start jammapi_joystick.service &
	echo "Script impostato!"
	sleep 2

	
	
##install jammapi menu script
	printf "\033[1;31m Installo menu x RetroPie \033[0m\n"
	ln -s /home/pi/JammaPi/script/menu.sh '/home/pi/RetroPie/retropiemenu/JammaPi.sh'
	sleep 2
  
  ##Add Emulationstation basic themes...
	printf "\033[1;31m Installo temi Emulationstation \033[0m\n"
	#cd ~/JammaPi/themes
	#git clone https://github.com/PietDAmore/240p-Theme.git
	#cd 240p-Theme/
 	#sudo cp -r "240p Bubblegum"/ /etc/emulationstation/themes/
	#sudo cp -r "240p Honey"/ /etc/emulationstation/themes/
	#cd 240p-overlays-v1/
	#cd ~/JammaPi/themes
	#git clone https://github.com/anthonycaccese/es-theme-crt.git
	#sudo cp -r es-theme-crt/ /etc/emulationstation/themes/
	#cd ~/JammaPi/themes
	cd /etc/emulationstation/themes/
	sudo git clone https://github.com/ehettervik/es-theme-pixel.git
	sleep 2

  ##install retropie resolution switch
		printf "\033[1;31m installo script risoluzioni 15khz... \033[0m\n"
		ln -s /home/pi/JammaPi/script/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh
		ln -s /home/pi/JammaPi/script/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh
		ln -s /home/pi/JammaPi/script/vertical_list.txt /opt/retropie/configs/all/vertical_list.txt
		ln -s /home/pi/JammaPi/script/exceptions_list.txt /opt/retropie/configs/all/exceptions_list.txt
		sudo grep 'crt_switch_resolution' /etc/fstab > /dev/null 2>&1
		if [ $? -eq 0 ] ; then
			echo "Già modificato!"
		else
		sudo sh -c "echo 'crt_switch_resolution = \"0\"' >> /opt/retropie/configs/all/retroarch.cfg"
		sudo sh -c "echo 'crt_switch_resolution_super = \"0\"' >> /opt/retropie/configs/all/retroarch.cfg"
		echo "Modulo impostato!"
		fi
		sleep 2

		
  ##Disable swap
  		printf "\033[1;31m disabilito la swap per rendere più stabile il \033[0m\n"
		printf "\033[1;31m sistema in caso di spegnimenti improvvisi \033[0m\n"
		sudo grep '/var/log' /etc/fstab > /dev/null 2>&1
		if [ $? -eq 0 ] ; then
			echo "Già modificato!"
		else
		sudo dphys-swapfile swapoff
		sudo dphys-swapfile uninstall
		sudo update-rc.d dphys-swapfile remove
		sudo sh -c "echo 'tmpfs /var/log tmpfs size=1M,noatime 0 0' >> /etc/fstab"
		echo "Modulo impostato!"
		fi

		
  ##Choice of video output
  		bash ~/JammaPi/script/jammapi_version.sh
		chmod u+x ~/JammaPi/script/jammapi.sh
		bash ~/JammaPi/script/switchvideo.sh 1
		
    		printf "\033[0;32m !!!INSTALLAZIONE COMPLETATA!!! \033[0m\n"
		printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
  		sleep 5
		
sudo reboot				

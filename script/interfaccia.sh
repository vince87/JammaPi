#!/bin/bash

#
# Attiva l'interfaccia video
#


usage()
{
    echo "Modifica uscita audio/video"
    echo ""
	echo -e "\t-h --help"
    echo -e "\t-VGA : attiva l'uscita VGA"
	echo -e "\t-HDMI : attiva l'uscita HDMI"
	echo -e "\t-SCART -JAMMA : attiva l'uscita SCART/JAMMA"
	echo -e "\t-JSON : attiva il driver Joystick"
	echo -e "\t-JSOFF : disattiva il driver Joystick"
	echo -e "\t-HDMI-AUD : attiva l'audio su HDMI"
	echo -e "\t-JAMMA-AUD : attiva l'audio su JAMMA/JACK"
	echo -e "\t-AUD-MONO : imposta l'audio MONO"
	echo -e "\t-AUD-STEREO : imposta l'audio STEREO"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -VGA)
			printf "\033[1;31m Attivo la VGA per la JammaPi \033[0m\n"
			sudo perl -p -i -e 's/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
			sudo perl -p -i -e 's/#dtoverlay=audremap,pins_18_19/dtoverlay=audremap,pins_18_19/g' /boot/config.txt
			sudo perl -p -i -e 's/#disable_audio_dither=1/disable_audio_dither=1/g' /boot/config.txt
			sudo perl -p -i -e 's/#audio_pwm_mode/audio_pwm_mode/g' /boot/config.txt
			sudo perl -p -i -e 's/#dtoverlay=vga666-6/dtoverlay=vga666-6/g' /boot/config.txt
			sudo perl -p -i -e 's/#enable_dpi_lcd=1/enable_dpi_lcd=1/g' /boot/config.txt
			sudo perl -p -i -e 's/#display_default_lcd=1/display_default_lcd=1/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_output_format=6/dpi_output_format=6/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_group=2/dpi_group=2/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_mode=87/dpi_mode=9/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_mode=9/dpi_mode=9/g' /boot/config.txt
			sudo perl -p -i -e 's/dpi_mode=87/dpi_mode=9/g' /boot/config.txt
			sudo grep '#hdmi_timings' /boot/config.txt > /dev/null 2>&1
			if [ $? eq 0 ] ; then
			sudo perl -p -i -e 's/hdmi_timings=/#hdmi_timings=/g' /boot/config.txt
			fi
			bash /home/pi/JammaPi/script/pixelperfect.sh -runc-off
			bash /home/pi/JammaPi/script/pixelperfect.sh -off
			sudo perl -p -i -e 's/#CRT/#VGA/g' /boot/config.txt
    			sudo perl -p -i -e 's/#HDMI/#VGA/g' /boot/config.txt
			printf "\033[0;32m !!!SPOSTARE I 2 DIP SWITCH SU OFF!!! \033[0m\n"
			sleep 5
            ;;
        -HDMI)
			printf "\033[1;31m Attivo l'HDMI \033[0m\n"
            		sudo perl -p -i -e 's/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
			sudo perl -p -i -e 's/dtoverlay=audremap,pins_18_19/#dtoverlay=audremap,pins_18_19/g' /boot/config.txt
			sudo perl -p -i -e 's/disable_audio_dither=1/#disable_audio_dither=1/g' /boot/config.txt
			sudo perl -p -i -e 's/audio_pwm_mode/#audio_pwm_mode/g' /boot/config.txt
			sudo perl -p -i -e 's/dtoverlay=vga666-6/#dtoverlay=vga666-6/g' /boot/config.txt
			sudo perl -p -i -e 's/enable_dpi_lcd=1/#enable_dpi_lcd=1/g' /boot/config.txt
			sudo perl -p -i -e 's/display_default_lcd=1/#display_default_lcd=1/g' /boot/config.txt
			sudo perl -p -i -e 's/dpi_output_format=6/#dpi_output_format=6/g' /boot/config.txt
			sudo perl -p -i -e 's/dpi_group=2/#dpi_group=2/g' /boot/config.txt
			sudo perl -p -i -e 's/dpi_mode/#dpi_mode/g' /boot/config.txt
			if [ $? eq 0 ] ; then
			sudo perl -p -i -e 's/hdmi_timings=/#hdmi_timings=/g' /boot/config.txt
			fi
			bash /home/pi/JammaPi/script/pixelperfect.sh -runc-off
			bash /home/pi/JammaPi/script/pixelperfect.sh -off
			sudo perl -p -i -e 's/#VGA/#HDMI/g' /boot/config.txt
   			sudo perl -p -i -e 's/#CRT/#HDMI/g' /boot/config.txt
			sleep 5
            ;;
		-SCART | -JAMMA)
			printf "\033[1;31m Attivo la SCART/JAMMA \033[0m\n"
            		sudo perl -p -i -e 's/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
			sudo perl -p -i -e 's/#dtoverlay=audremap,pins_18_19/dtoverlay=audremap,pins_18_19/g' /boot/config.txt
			sudo perl -p -i -e 's/#disable_audio_dither=1/disable_audio_dither=1/g' /boot/config.txt
			sudo perl -p -i -e 's/#audio_pwm_mode/audio_pwm_mode/g' /boot/config.txt
			sudo perl -p -i -e 's/#dtoverlay=vga666-6/dtoverlay=vga666-6/g' /boot/config.txt
			sudo perl -p -i -e 's/#enable_dpi_lcd=1/enable_dpi_lcd=1/g' /boot/config.txt
			sudo perl -p -i -e 's/#display_default_lcd=1/display_default_lcd=1/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_output_format=6/dpi_output_format=6/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_group=2/dpi_group=2/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_mode=87/dpi_mode=87/g' /boot/config.txt
			sudo perl -p -i -e 's/#dpi_mode/dpi_mode/g' /boot/config.txt
			sudo perl -p -i -e 's/dpi_mode=9/dpi_mode=87/g' /boot/config.txt
			sudo perl -p -i -e 's/#hdmi_timings=/hdmi_timings=/g' /boot/config.txt
			bash /home/pi/JammaPi/script/pixelperfect.sh -runc-on
			bash /home/pi/JammaPi/script/pixelperfect.sh -on
			sudo perl -p -i -e 's/#VGA/#CRT/g' /boot/config.txt
    			sudo perl -p -i -e 's/#HDMI/#CRT/g' /boot/config.txt
			printf "\033[0;32m !!!SPOSTARE I 2 DIP SWITCH SU ON!!! \033[0m\n"
			sleep 5
            ;;
		-JSON)
			printf "\033[1;31m Attivo il driver Joystick \033[0m\n"
 			sudo modprobe joypi
  			lsmod | grep 'joypi' > /dev/null 2>&1
 			if [ $? -eq 0 ] ; then
  				echo "Driver Attivo!"
  			else
  			cd ~/JammaPi/joypi/
  			make clean
			make
			sudo make install
			sudo insmod joypi.ko
			modprobe joypi
  fi
            		sudo ln -s /home/pi/JammaPi/services/jammapi_joystick.service /etc/systemd/system/jammapi_joystick.service
			sudo systemctl enable jammapi_joystick.service
			sudo systemctl start jammapi_joystick.service
			sleep 5
            ;;
		-JSOFF)
			printf "\033[1;31m DIsattivo il driver Joystick \033[0m\n"
			sudo modprobe -rf joypi
			sudo systemctl disable jammapi_joystick.service
			sleep 5
            ;;
	    	-HDMI-AUD)
			printf "\033[1;31m Attivo audio su HDMI \033[0m\n"
			sudo perl -p -i -e 's/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
			sudo perl -p -i -e 's/dtoverlay=audremap,pins_18_19/#dtoverlay=audremap,pins_18_19/g' /boot/config.txt
			sudo perl -p -i -e 's/disable_audio_dither=1/#disable_audio_dither=1/g' /boot/config.txt
			sudo perl -p -i -e 's/audio_pwm_mode/#audio_pwm_mode/g' /boot/config.txt
			amixer cset numid=3 "2"
			sleep 5
            ;;
	    	-JAMMA-AUD)
			printf "\033[1;31m Attivo audio su JAMMA/JACK \033[0m\n"
			sudo perl -p -i -e 's/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
			sudo perl -p -i -e 's/#dtoverlay=audremap,pins_18_19/dtoverlay=audremap,pins_18_19/g' /boot/config.txt
			sudo perl -p -i -e 's/#disable_audio_dither=1/disable_audio_dither=1/g' /boot/config.txt
			sudo perl -p -i -e 's/#audio_pwm_mode/audio_pwm_mode/g' /boot/config.txt
			amixer cset numid=3 "1"
			sleep 5
            ;;
	    	-AUD-MONO)
			printf "\033[1;31m Imposto l'audio MONO \033[0m\n"
			sudo perl -p -i -e 's/0.0 1/0.0 1/g' /etc/asound.conf
			sudo perl -p -i -e 's/0.1 0/0.1 0/g' /etc/asound.conf
			sudo perl -p -i -e 's/1.0 0/1.0 1/g' /etc/asound.conf
			sudo perl -p -i -e 's/1.1 1/1.1 0/g' /etc/asound.conf
			sleep 5
            ;;
	        -AUD-STEREO)
			printf "\033[1;31m Imposto l'audio STEREO \033[0m\n"
			sudo perl -p -i -e 's/0.0 1/0.0 1/g' /etc/asound.conf
			sudo perl -p -i -e 's/0.1 0/0.1 0/g' /etc/asound.conf
			sudo perl -p -i -e 's/1.0 1/1.0 0/g' /etc/asound.conf
			sudo perl -p -i -e 's/1.1 0/1.1 1/g' /etc/asound.conf
			sleep 5
            ;;
		*)
            echo "ERRORE: Parametro sconosciuto: \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

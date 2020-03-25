#!/bin/bash

#
# Attiva o disattiva il pixel-perfect
#


usage()
{
    echo "Pixel-Perfect"
    echo ""
	echo -e "\t-h --help"
    	echo -e "\t-on : attiva il pixel-perfect a 15khz"
	echo -e "\t-on31 : attiva il pixel-perfect a 31khz"
	echo -e "\t-off : disattiva il pixel-perfect"
	echo -e "\t-runc-on : attiva il runcommand"
	echo -e "\t-runc-off : disattiva il runcommand"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -on)
	
	
	
			sudo grep 'Pi 4' /proc/device-tree/model > /dev/null 2>&1 
			if [ $? -eq 0 ] ; then
        			echo "ERRORE: Impossibile attivare il pixel perfect su pi4 al momento!"
			else
				printf "\033[1;31m Attivo il Pixel-Perfect per la JammaPi \033[0m\n"
				sudo perl -p -i -e 's/crt_switch_resolution = "0"/crt_switch_resolution = "1"/g' /opt/retropie/configs/all/retroarch.cfg
				sudo perl -p -i -e 's/crt_switch_resolution_super = "0"/crt_switch_resolution_super = "1920"/g' /opt/retropie/configs/all/retroarch.cfg
				sleep 2
			fi
            ;;
	 -on31)
			printf "\033[1;31m Attivo il Pixel-Perfect per la JammaPi \033[0m\n"
			sudo perl -p -i -e 's/crt_switch_resolution = "0"/crt_switch_resolution = "2"/g' /opt/retropie/configs/all/retroarch.cfg
			sudo perl -p -i -e 's/crt_switch_resolution_super = "0"/crt_switch_resolution_super = "1920"/g' /opt/retropie/configs/all/retroarch.cfg
			sleep 2
            ;;
	-runc-on)
			printf "\033[1;31m Attivo il Runcommand \033[0m\n"
			mv /opt/retropie/configs/all/runcommand-onend.sh.off /opt/retropie/configs/all/runcommand-onend.sh
			mv /opt/retropie/configs/all/runcommand-onstart.sh.off /opt/retropie/configs/all/runcommand-onstart.sh
			sleep 2
            ;;
        -off)
			printf "\033[1;31m Disattivo il Pixel-Perfect per la JammaPi \033[0m\n"
            		sudo perl -p -i -e 's/crt_switch_resolution = "1"/crt_switch_resolution = "0"/g' /opt/retropie/configs/all/retroarch.cfg
			sudo perl -p -i -e 's/crt_switch_resolution_super = "1920"/crt_switch_resolution_super = "0"/g' /opt/retropie/configs/all/retroarch.cfg
			sleep 2
            ;;
	-runc-off)
			printf "\033[1;31m Disattivo il runcommand \033[0m\n"
			mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.off
			mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.off
			sleep 2
            ;;
        *)
            echo "ERRORE: Parametro sconosciuto: \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

#!/bin/bash

sudo grep 'input_l_x_minus_axis' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg > /dev/null 2>&1
if [ $? -eq 0 ] ; then
  echo "Pronto per la modifica!"
else
  sudo sh -c "echo '#input_l_x_minus_axis = \"-0\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg"
  sudo sh -c "echo '#input_l_x_plus_axis = \"+0\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg"
  sudo sh -c "echo '#input_l_y_minus_axis = \"-1\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg"
  sudo sh -c "echo '#input_l_y_plus_axis = \"+1\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg"
fi
sudo grep 'input_l_x_minus_axis' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg > /dev/null 2>&1
if [ $? -eq 0 ] ; then
  echo "Pronto per la modifica!"
else
  sudo sh -c "echo '#input_l_x_minus_axis = \"-0\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg"
  sudo sh -c "echo '#input_l_x_plus_axis = \"+0\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg"
  sudo sh -c "echo '#input_l_y_minus_axis = \"-1\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg"
  sudo sh -c "echo '#input_l_y_plus_axis = \"+1\"' >> /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg"
fi

HEIGHT=10
WIDTH=60
BACKTITLE="JammaPi Menù"
TITLE="Abilita/Disabilita controlli analogici Joystick JammaPi"
MENU="Scegliere un opzione:"

OPTIONS=(1 "Abilita controlli analogici"
         2 "Disabilita controlli analogici")

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
          echo "Attivo controlli analogici!"
          sudo perl -p -i -e 's/#input_l_x_minus_axis/input_l_x_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/#input_l_x_plus_axis/input_l_x_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/#input_l_y_minus_axis/input_l_y_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/#input_l_y_plus_axis/input_l_y_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/#input_l_x_minus_axis/input_l_x_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          sudo perl -p -i -e 's/#input_l_x_plus_axis/input_l_x_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          sudo perl -p -i -e 's/#input_l_y_minus_axis/input_l_y_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          sudo perl -p -i -e 's/#input_l_y_plus_axis/input_l_y_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          echo "Modifiche effettuate!"
          sleep 2
        ;;
        2) 
        echo "Disattivo controlli analogici!"
        sudo grep '#input_l_x_minus_axis' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg > /dev/null 2>&1
        if [ $? -eq 0 ] ; then
          echo "Modifiche effettuate!"
          sleep 2
        else
          sudo perl -p -i -e 's/input_l_x_minus_axis/#input_l_x_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/input_l_x_plus_axis/#input_l_x_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/input_l_y_minus_axis/#input_l_y_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/input_l_y_plus_axis/#input_l_y_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 0.cfg
          sudo perl -p -i -e 's/input_l_x_minus_axis/#input_l_x_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          sudo perl -p -i -e 's/input_l_x_plus_axis/#input_l_x_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          sudo perl -p -i -e 's/input_l_y_minus_axis/#input_l_y_minus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          sudo perl -p -i -e 's/input_l_y_plus_axis/#input_l_y_plus_axis/g' /opt/retropie/configs/all/retroarch-joypads/JoyPi\ Joystick\ 1.cfg
          echo "Modifiche effettuate!"
          sleep 2
        fi
        ;;
esac
bash ~/JammaPi/script/menu.sh

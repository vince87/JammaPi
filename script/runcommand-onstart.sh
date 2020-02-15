gname="$(basename $3)"

if [ "$1" = "arcade" ] || [ "$1" = "mame" ]; then
        if  grep -w ${gname%.*} /opt/retropie/configs/all/vertical_list.txt; then
                vcgencmd hdmi_timings 320 1 10 20 54 240 1 6 8 10 0 0 0 60 0 6400000 1 > /dev/null
                tvservice -e "DMT 87" > /dev/null
                fbset -depth 8 && fbset -depth 16 -xres 320 -yres 240 > /dev/null
                bash /home/pi/JammaPi/script/pixelperfect.sh -off
                echo "GIOCO VERTICALE!"
                exit 1
        fi

        if  grep -w ${gname%.*} /opt/retropie/configs/all/exceptions_list.txt; then
                vcgencmd hdmi_timings 320 1 10 20 54 240 1 6 8 10 0 0 0 60 0 6400000 1 > /dev/null
                tvservice -e "DMT 87" > /dev/null
                fbset -depth 8 && fbset -depth 16 -xres 320 -yres 240 > /dev/null
                bash /home/pi/JammaPi/script/pixelperfect.sh -off
                echo "FREQUENZA PIXEL-PERFECT NON SUPPORTATA!"
                exit 1
        fi
fi

if [ "$1" = "daphne" ] || [ "$1" = "retropie" ] || [ "$1" = "gb" ] || [ "$1" = "gamegear" ]; then
        vcgencmd hdmi_timings 320 1 10 20 54 240 1 6 8 10 0 0 0 60 0 6400000 1 > /dev/null
        tvservice -e "DMT 87" > /dev/null
        fbset -depth 8 && fbset -depth 16 -xres 320 -yres 240 > /dev/null
        bash /home/pi/JammaPi/script/pixelperfect.sh -off
        exit 1
else
        vcgencmd hdmi_timings 1920 1 152 247 280 240 1 3 7 12 0 0 0 60 0 40860000 1 > /dev/null
        tvservice -e "DMT 87" > /dev/null
        fbset -depth 8 && fbset -depth 16 -xres 1600 -yres 240 > /dev/null
        bash /home/pi/JammaPi/script/pixelperfect.sh -on
        exit 1
fi

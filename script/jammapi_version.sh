#!/bin/bash
dialog --title "Versione JammaPi" \
--backtitle "Menu versione JammaPi" \
--yesno "Usi la nuova JammaPi Final?" 6 60

response=$?
case $response in
   0) cp ~/JammaPi/script/jammapi_new.sh ~/JammaPi/script/jammapi.sh;;
   1) cp ~/JammaPi/script/jammapi_old.sh ~/JammaPi/script/jammapi.sh;;
esac

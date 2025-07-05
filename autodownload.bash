# !/bin/bash

# CHANGE TO YOUR MUSIC DIRECOTRY PATH
cd $HOME/Music/

exists=$(/usr/bin/detify check)

if [ "$exists" == "True" ]; then
  echo 'already downloaded'
else
  spotdl $(/usr/bin/detify)
fi

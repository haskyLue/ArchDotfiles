#! /bin/bash

# volome
if [[ $# -eq 1 && $1 = vup ]];then
	amixer set Master 1%+ | tail -n1 | awk '/Mono/ {print "Volume:"$4 $6}' | xargs -0 -I {} notify-send {}
elif [[ $# -eq 1 && $1 = vdown ]];then
	amixer set Master 1%- | tail -n1 | awk '/Mono/ {print "Volume:"$4 $6}' | xargs -0 -I {} notify-send {}
fi

#! /bin/bash
secret="/home/hasky/Workspace/secret"

case "$1" in 
# volome
	"vol")
		case "$2" in
			"up")
				amixer set Master on
				amixer set Master 2%+ | tail -n1 | awk '/Mono/ {print "Volume:"$4 $6}' | xargs -0 -I {} notify-send {}
				;;
			"down")
				amixer set Master on
				amixer set Master 2%- | tail -n1 | awk '/Mono/ {print "Volume:"$4 $6}' | xargs -0 -I {} notify-send {}
				;;
			"off")
				amixer set Master off | tail -n1 | awk '/Mono/ {print "Volume:"$4 $6}' | xargs -0 -I {} notify-send {}
		esac
		;;
# psmouse
	"psmouse")
	if [ -n "$(lsmod | grep psmouse)" ] ; then
		sudo -S modprobe -r psmouse < $secret
		notify-send "触摸板已禁用"
	else
		sudo -S modprobe psmouse < $secret
		notify-send "触摸板已启用"
	fi
esac

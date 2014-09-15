#! /bin/bash
secret="/home/hasky/Workspace/secret"

if [ -n "$(lsmod | grep psmouse)" ] ; then
	sudo -S modprobe -r psmouse < $secret
	notify-send "触摸板已禁用"
else
	sudo -S modprobe psmouse < $secret
	notify-send "触摸板已启用"
fi


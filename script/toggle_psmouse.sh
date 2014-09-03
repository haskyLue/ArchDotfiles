#! /bin/bash
secret="/home/hasky/Workspace/secret"

if [ -n "$(lsmod | grep psmouse)" ] ; then
	sudo -S modprobe -r psmouse < $secret
else
	sudo -S modprobe psmouse < $secret
fi


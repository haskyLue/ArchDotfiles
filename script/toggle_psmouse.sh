#! /bin/bash

PASSWD="ldb"
if [ -n "$(lsmod | grep psmouse)" ] ; then
	echo $PASSWD | sudo -S modprobe -r psmouse 
else
	echo $PASSWD | sudo -S modprobe psmouse 
fi


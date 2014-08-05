#!/bin/bash
echo "configure wlan0 inet address and netmask ......"
sudo ifconfig wlp3s0 inet 192.168.1.4 broadcast 192.168.1.255 netmask 255.255.255.0 up
echo "wlan0 is up now ......"
sudo wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant_renlei.conf -B
echo "wpa_supplicant is running now ......"
echo "deleting default route via eth0 ......"
sudo route delete default
echo "adding default route for wlan0 ......"
sudo route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.168.1.1 dev wlan0
echo "default route has been added."
echo "now test the link ......"
ping -c4 192.168.1.1
ping -c4 www.google.com

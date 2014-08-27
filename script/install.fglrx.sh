#! /bin/bash

# install
if [ $UID -eq 0 ] && [ $1 == "install" ];then
	pacman -Rnu xf86-video-ati lib32-ati-dri ati-dri 
	echo -e "blacklist radeon" > /etc/modprobe.d/disable-radeon

	cp -fv /etc/pacman.conf.fglrx /etc/pacman.conf
	pacman -Syuu
	pacman -S catalyst-hook catalyst-utils lib32-catalyst-utils 
	pacman -S acpid

	rm -f /etc/X11/xorg.conf
	aticonfig --initial

	systemctl enable atieventsd
	systemctl enable catalyst-hook
	systemctl start atieventsd
	systemctl start catalyst-hook

	vim /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
# recover
elif [ $UID -eq 0 ] && [ $1 == "recover" ];then 
	pacman -Rnu catalyst-hook catalyst-utils lib32-catalyst-utils 
	systemctl disable atieventsd
	systemctl disable catalyst-hook
	rm -vf /etc/modprobe.d/disable-radeon
	ln -sf /home/hasky/Documents/dotfiles/xorg.conf /etc/X11/xorg.conf

	cp -fv /etc/pacman.conf.origin /etc/pacman.conf
	pacman -Syuu
	pacman -S xf86-video-ati lib32-ati-dri ati-dri mesa 

	vim /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
else
	echo "please switch to root user && supply correct arg! "
fi


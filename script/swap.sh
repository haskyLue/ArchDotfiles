dd if=/dev/zero of=/sdcard/swap bs=2M count=24567 # fallocate -l 512M /swapfile 
mkswap /sdcard/swap
swapon /sdcard/swap
echo 20 > /proc/sys/vm/swappiness

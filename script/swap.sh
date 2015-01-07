dd if=/dev/zero of=/sdcard/swap bs=1M count=24567
mkswap /sdcard/swap
swapon /sdcard/swap
echo 20 > /proc/sys/vm/swappiness

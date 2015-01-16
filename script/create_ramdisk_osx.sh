#! /bin/bash
secret="/Users/hasky/Documents/secret"
mount_point=/Volumes/Caches
create_ramdisk(){
	# copied from web 
	ramfs_size_mb=512  

	ramfs_size_sectors=$(( ${ramfs_size_mb}*1024*1024/512 ))  
	ramdisk_dev=`hdid -nomount ram://${ramfs_size_sectors}`  
	newfs_hfs ${ramdisk_dev}  
	sudo -S mkdir -p ${mount_point}  < $secret
	sudo -S mount -o noatime -t hfs ${ramdisk_dev} ${mount_point}  < $secret

	echo ""
	echo "-------remove with----------"  
	echo "hdiutil detach ${ramdisk_dev}" 
	echo ""
}

cache_to_ram(){
	if [ ! -d $mount_point/Google ] ;then
		mv -fv ~/Library/Caches/Google $mount_point/
		ln -sf $mount_point/Google ~/Library/Caches/Google 

		mv -fv  ~/Library/Caches/com.apple.Safari $mount_point/
		ln -sf $mount_point/com.apple.Safari ~/Library/Caches/com.apple.Safari

		mv -fv  ~/Library/Caches/Firefox $mount_point/
		ln -sf $mount_point/Firefox ~/Library/Caches/Firefox

		mv -fv  ~/Library/Caches/com.xiami.client $mount_point/
		ln -sf $mount_point/com.xiami.client ~/Library/Caches/com.xiami.client

		sudo -S mv -fv  ~/Library/Logs $mount_point/ < $secret
		ln -sf $mount_point/Logs ~/Library/Logs

		mv -fv ~/.newsbeuter/cache.db $mount_point/
		ln -sf $mount_point/cache.db ~/.newsbeuter/cache.db 

	fi
}
ram_restoreto_cache(){
	_ramdisk_dev=$(df | awk '/Caches/ {print $1}')
	echo $_ramdisk_dev
	if [[ -n $_ramdisk_dev ]];then
		rm -rf ~/Library/Caches/{Google,com.apple.Safari,Firefox,com.xiami.client}
		rm -rf ~/.newsbeuter/cache.db
		sudo rm -rf ~/Library/Logs # 删除软链接
		# mkdir -p ~/Library/Caches/{Google,com.apple.Safari,Firefox,com.xiami.client}
		# sudo mkdir -p ~/Library/Logs

		mv $mount_point/Google ~/Library/Caches/
		mv $mount_point/Firefox ~/Library/Caches/
		mv $mount_point/com.apple.Safari ~/Library/Caches/
		mv $mount_point/com.xiami.client ~/Library/Caches/
		mv $mount_point/cache.db ~/.newsbeuter/
		sudo mv $mount_point/Logs ~/Library/

		hdiutil detach $_ramdisk_dev
	fi
}
if [ $# -gt 0 ];then
	ram_restoreto_cache
	df -a
else
	create_ramdisk
	cache_to_ram 
	df -a
fi

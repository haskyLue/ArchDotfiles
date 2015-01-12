#! /bin/bash
mount_point=/Volumes/Caches
create_ramdisk(){
	# copied from web 
	ramfs_size_mb=1024  

	ramfs_size_sectors=$(( ${ramfs_size_mb}*1024*1024/512 ))  
	ramdisk_dev=`hdid -nomount ram://${ramfs_size_sectors}`  
	newfs_hfs ${ramdisk_dev}  
	sudo mkdir -p ${mount_point}  
	sudo mount -o noatime -t hfs ${ramdisk_dev} ${mount_point}  

	echo ""
	echo "-------remove with----------"  
	echo "hdiutil detach ${ramdisk_dev}" 
}

cache_to_ram(){
	if [ ! -d $mount_point/Google ] ;then
		mv ~/Library/Caches/Google /Volumes/Caches/
		ln -sf $mount_point/Google ~/Library/Caches/Google

		mv ~/Library/Caches/com.apple.Safari $mount_point/
		ln -sf $mount_point/com.apple.Safari ~/Library/Caches/com.apple.Safari

		mv ~/Library/Caches/Firefox $mount_point/
		ln -sf $mount_point/Firefox ~/Library/Caches/Firefox
	fi
}
ram_restoreto_cache(){
	_ramdisk_dev=$(df | awk '/Caches/ {print $1}')
	echo $_ramdisk_dev
	if [[ -n $_ramdisk_dev ]];then
		rm -f ~/Library/Caches/{Google,com.apple.Safari,Firefox}
		mv -v $mount_point/Google ~/Library/Caches/Google
		mv -v $mount_point/Firefox ~/Library/Caches/Firefox
		mv -v $mount_point/com.apple.Safari ~/Library/Caches/com.apple.Safari
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

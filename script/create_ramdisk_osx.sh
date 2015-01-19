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
		sudo -S mkdir -v $mount_point/{Google,com.apple.Safari,Firefox,com.xiami.client,Logs,sys_Logs,Homebrew,com.apple.dashboard.client} < $secret
	fi
}
ram_restoreto_cache(){
	_ramdisk_dev=$(df | awk '/Caches/ {print $1}')
	if [[ -n $_ramdisk_dev ]];then
		# 暂不处理
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

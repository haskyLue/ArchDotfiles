#! /bin/bash
# 强迫症患者
mount_point=/Volumes/Caches
create_ramdisk(){
	ramfs_size_mb=512  

	ramfs_size_sectors=$(( ${ramfs_size_mb}*1024*1024/512 ))  
	ramdisk_dev=`hdid -nomount ram://${ramfs_size_sectors}`  
	newfs_hfs ${ramdisk_dev}  
	mkdir -p ${mount_point}
	mount -o noatime,noowners -t hfs ${ramdisk_dev} ${mount_point} 
	# echo ""
	# echo "-------remove with----------"  
	# echo "hdiutil detach ${ramdisk_dev}" 
	# echo ""
}

cache_to_ram(){
	_dir=(
	Google
	com.apple.Safari
	Firefox
	com.xiami.client
	U_L_Logs
	R_L_Logs
	Homebrew
	com.apple.dashboard.client
	)
	if [ ! -d $mount_point/Google ] ;then
		cd $mount_point 
		for i in ${_dir[@]};do
			mkdir -pv $i 
		done
		[[ ! -L /var/log ]] && mv /var/log var_log && ln -sf $mount_point/var_log /var/log || rm -f /var/log # /var/log 在此脚本直接生成
	fi
}
ram_restoreto_cache(){
	_ramdisk_dev=$(df | awk '/Caches/ {print $1}')
	if [[ -n $_ramdisk_dev ]];then
		# 暂不处理
		hdiutil detach $_ramdisk_dev
	fi
}
# if [ $# -gt 0 ];then
# 	ram_restoreto_cache
# 	df -a
# else
create_ramdisk && cache_to_ram 
# 	df -a
# fi

#! /bin/bash
# 强迫症患者
mount_point=/Volumes/Caches
create_ramdisk(){
	ramfs_size_mb=512  

	ramfs_size_sectors=$(( ${ramfs_size_mb}*1024*1024/512 ))  
	ramdisk_dev=`hdiutil attach -nomount ram://${ramfs_size_sectors}`  
	newfs_hfs -v Ramdisk ${ramdisk_dev}  

	rm -rf ${mount_point} && mkdir -p ${mount_point}
	mount -w -o noatime -t hfs ${ramdisk_dev} ${mount_point} 
	chown -R root:admin ${mount_point} && chmod -R 777 ${mount_point}

	# echo "-------remove with----------"  
	# echo "hdiutil detach ${ramdisk_dev}" 
	# echo ""
}

cache_to_ram(){
	_dir_perm_root=(
	R_L_Logs
	)
	_dir_perm_user=(
	Google
	Firefox
	com.apple.Safari
	com.apple.iTunes
	com.netease.163music
	com.apple.dashboard.client
	GameKit
	U_L_Logs
	Homebrew
	nginx
	Adobe
	)
	if [ ! -d $mount_point/Google ] ;then
		cd $mount_point 

		# 创建目录并调整权限
		for i in ${_dir_perm_user[@]};do
			mkdir -p $i 
			chown -R hasky:wheel $i
		done
		for i in ${_dir_perm_root[@]};do
			mkdir -p $i 
			chown -R root:wheel $i
		done

		# [[ -L /var/log ]] && rm -f /var/log || ( /bin/cp -Rpf /var/log $mount_point/var_log && rm -fr /var/log && ln -sf $mount_point/var_log /var/log ) # /var/log 在此脚本直接生成
	fi
}
# ram_restoreto_cache(){
# 	_ramdisk_dev=$(df | awk '/Caches/ {print $1}')
# 	if [[ -n $_ramdisk_dev ]];then
# 		# 暂不处理
# 		hdiutil detach $_ramdisk_dev
# 	fi
# }
# if [ $# -gt 0 ];then
# 	ram_restoreto_cache
# 	df -a
# else
[[ ! -d /Volumes/Caches ]] && create_ramdisk && cache_to_ram 
# 	df -a
# fi

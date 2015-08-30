kernal=$(uname -s)
_tmp='/Volumes/Caches'

if [[ $kernal = 'Darwin' ]];then
	netInterface=$(netstat -nr | awk '/default/ {print $6}') # for os x
else
	netInterface=$(route -v | awk 'NR==3 {print $8}') #for linux only
fi


# MemAvailable=$(expr `cat /proc/meminfo | awk '/MemAvailable/ {print $2}'` / 1024)
# MemTotal=$(expr `cat /proc/meminfo | awk '/MemTotal/ {print $2}'` / 1024)


if [ $netInterface ]
then
	rx_old=$( [[ -e $_tmp/rx_bytes  ]] && ( cat $_tmp/rx_bytes ) || echo 0 ) # 读取上一个时间戳的流量
	tx_old=$( [[ -e $_tmp/tx_bytes  ]] && ( cat $_tmp/tx_bytes ) || echo 0 )
	time_old=$( [[ -e $_tmp/rx_tx_time  ]] && ( cat $_tmp/rx_tx_time ) || 0 )

	if [[ $kernal = 'Darwin' ]];then
		rx_new=$( netstat -I $netInterface -b | awk 'NR==3 {print $7}' )
		tx_new=$( netstat -I $netInterface -b | awk 'NR==3 {print $10}')
	elif [[ $kernal = 'Linux' ]];then
		rx_new=$( cat /sys/class/net/$netInterface/statistics/$rx_bytes )
		tx_new=$( cat /sys/class/net/$netInterface/statistics/$tx_bytes )
	else 
		rx_new=0
		tx_new=0
	fi
	time_new=$( date +%s )


	# rx_new=$( ifconfig -s $Interface | awk 'NR==2 {print $3}' )
	# tx_new=$( ifconfig -s $Interface | awk 'NR==2 {print $7}' )
	( echo $rx_new > $_tmp/rx_bytes ) && ( echo $tx_new > $_tmp/tx_bytes ) && ( echo $time_new > $_tmp/rx_tx_time )# 写入缓存供下一个时间使用

	duration=$( /bin/expr $time_new \- $time_old )
	rx_rate=$( /bin/expr \( $rx_new \- $rx_old \) / 1000 / $duration )
	tx_rate=$( /bin/expr \( $tx_new \- $tx_old \) / 1000 / $duration )
	# echo "#[bg=red] $(expr $MemTotal - $MemAvailable)/$MemTotal MB #[bg=default]#[fg=magenta] #[fg=blue]↑↓#[fg=magenta]$netInterface#[fg=blue] ↘${rx_rate}.0#[fg=magenta]KB/s#[fg=blue] ↗${tx_rate}.0#[fg=magenta]KB/s"
	echo "#[bg=default] #[fg=blue,bold]↑↓#[fg=red,none]$netInterface#[fg=blue,bold] ↘ ${rx_rate}.0#[fg=red,none]KB/s#[fg=blue,bold] ↗ ${tx_rate}.0#[fg=red,none]KB/s"
else
	# echo "#[bg=red] $(expr $MemTotal - $MemAvailable)/$MemTotal MB #[bg=default]#[fg=magenta] Invalid Interface!"
	echo "#[bg=default]#[fg=magenta] Interface NotFound!"
fi
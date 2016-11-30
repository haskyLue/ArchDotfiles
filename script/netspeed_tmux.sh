KERNEL=$(uname -s)
DIR='/tmp'
DEV='en0'

if [[ $KERNEL = 'Darwin' ]];then
	DEV=$(netstat -nr | head | awk '/default/ {print $6}') # for os x
else
	DEV=$(route -v | awk 'NR==3 {print $8}') #for linux only
fi


# MemAvailable=$(expr `cat /proc/meminfo | awk '/MemAvailable/ {print $2}'` / 1024)
# MemTotal=$(expr `cat /proc/meminfo | awk '/MemTotal/ {print $2}'` / 1024)


if [ $DEV ]
then
	rx_old=$( [[ -e $DIR/rx_bytes  ]] && ( cat $DIR/rx_bytes ) || echo 0 ) # 读取上一个时间戳的流量
	tx_old=$( [[ -e $DIR/tx_bytes  ]] && ( cat $DIR/tx_bytes ) || echo 0 )
	time_old=$( [[ -e $DIR/rx_tx_time  ]] && ( cat $DIR/rx_tx_time ) || 0 )

	if [[ $KERNEL = 'Darwin' ]];then
		rx_new=$( netstat -I $DEV -b | awk 'NR==2 {print $7}' )
		tx_new=$( netstat -I $DEV -b | awk 'NR==2 {print $10}')
	elif [[ $kernal = 'Linux' ]];then
		rx_new=$( cat /sys/class/net/$DEV/statistics/$rx_bytes )
		tx_new=$( cat /sys/class/net/$DEV/statistics/$tx_bytes )
	else 
		rx_new=0
		tx_new=0
	fi
	time_new=$( date +%s )


	# rx_new=$( ifconfig -s $Interface | awk 'NR==2 {print $3}' )
	# tx_new=$( ifconfig -s $Interface | awk 'NR==2 {print $7}' )
	( echo $rx_new > $DIR/rx_bytes ) && ( echo $tx_new > $DIR/tx_bytes ) && ( echo $time_new > $DIR/rx_tx_time )# 写入缓存供下一个时间使用

	duration=$( /bin/expr $time_new \- $time_old )
	rx_rate=$( /bin/expr \( $rx_new \- $rx_old \) / 1000 / $duration )
	tx_rate=$( /bin/expr \( $tx_new \- $tx_old \) / 1000 / $duration )
	# echo "#[bg=red] $(expr $MemTotal - $MemAvailable)/$MemTotal MB #[bg=default]#[fg=magenta] #[fg=blue]↑↓#[fg=magenta]$DEV#[fg=blue] ↘${rx_rate}.0#[fg=magenta]KB/s#[fg=blue] ↗${tx_rate}.0#[fg=magenta]KB/s"
	echo "#[bg=default] \
	#[fg=blue,none]$DEV \
	#[fg=blue,italic]⇓ ${rx_rate}K ⇑ ${tx_rate}K"
else
	# echo "#[bg=red] $(expr $MemTotal - $MemAvailable)/$MemTotal MB #[bg=default]#[fg=magenta] Invalid Interface!"
	echo "#[bg=default]#[fg=magenta] ∅"
fi

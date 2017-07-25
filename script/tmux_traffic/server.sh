__set_kernel(){
	export KERNEL=$(uname -s)
}
__cleanup(){
	rm -f /tmp/TMUX_TRAFFIC_PID
	echo "#[bg=default]#[fg=magenta] Oops,Server is Shutdown..." > $TMUX_TRAFFIC_FILE
	exit
}
__init_process(){
	export TMUX_RX_NEW=0
	export TMUX_TX_NEW=0
	export TMUX_TIMESTAMP_NEW=0
	export TMUX_RX_OLD=$TMUX_RX_NEW 
	export TMUX_TX_OLD=$TMUX_TX_NEW
	export TMUX_TIMESTAMP_OLD=$TMUX_TIMESTAMP_NEW

	export TMUX_TRAFFIC_FILE="/tmp/tmux_traffic"
	__set_kernel
	trap "__cleanup"  1 2 3 6 15 # 注册一些singal handler
	echo "$$"> /tmp/TMUX_TRAFFIC_PID
}
__set_network_interface(){
	if [[ $KERNEL = 'Darwin' ]];then
		DEV=$(netstat -nr | head | awk '/default/ {print $6}') # for macos
	else
		DEV=$(route -v | awk 'NR==3 {print $8}') #for linux only
	fi
	export DEV
}
__get_current_traffic(){
	if [[ $KERNEL = 'Darwin' ]];then
		TMUX_RX_NEW=$( netstat -I $DEV -b | awk 'NR==2 {print $7}' )
		TMUX_TX_NEW=$( netstat -I $DEV -b | awk 'NR==2 {print $10}')
	elif [[ $KERNEL = 'Linux' ]];then
		TMUX_RX_NEW=$( cat /sys/class/net/$DEV/statistics/$rx_bytes )
		TMUX_TX_NEW=$( cat /sys/class/net/$DEV/statistics/$tx_bytes )
		# TMUX_RX_NEW=$( ifconfig -s $Interface | awk 'NR==2 {print $3}' )
		# TMUX_TX_NEW=$( ifconfig -s $Interface | awk 'NR==2 {print $7}' )
	fi
	TMUX_TIMESTAMP_NEW=$( date +%s )
}



# main function
__init_process
while [[ $KERNEL ]];do
	__set_network_interface
	if [[ ! -z $DEV ]]; then
		# 1.获取当前流量和时间戳
		__get_current_traffic

		# 2.计算traffic/second
		duration=$( /bin/expr $TMUX_TIMESTAMP_NEW \- $TMUX_TIMESTAMP_OLD )
		rx_rate=$( /bin/expr \( $TMUX_RX_NEW \- $TMUX_RX_OLD \) / 1000 / $duration )
		tx_rate=$( /bin/expr \( $TMUX_TX_NEW \- $TMUX_TX_OLD \) / 1000 / $duration )

		# 3.写入缓存
		TMUX_RX_OLD=$TMUX_RX_NEW 
		TMUX_TX_OLD=$TMUX_TX_NEW
		TMUX_TIMESTAMP_OLD=$TMUX_TIMESTAMP_NEW

		echo "#[bg=default]#[fg=green,none]「$DEV ⇓ ${rx_rate}K ⇑ ${tx_rate}K」" > $TMUX_TRAFFIC_FILE

	else
		echo "#[bg=default]#[fg=magenta] ∅" > $TMUX_TRAFFIC_FILE
	fi

	sleep 1
done

# MemAvailable=$(expr `cat /proc/meminfo | awk '/MemAvailable/ {print $2}'` / 1024)
# MemTotal=$(expr `cat /proc/meminfo | awk '/MemTotal/ {print $2}'` / 1024)

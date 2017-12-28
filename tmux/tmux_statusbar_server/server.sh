#!/bin/bash

export TMUX_WORKING_DIR="/Users/hasky/Documents/.dotFile/tmux/tmux_statusbar_server"
source $TMUX_WORKING_DIR/doInit.sh

__set_kernel(){
	KERNEL=$(uname -s)
}
__set_network_interface(){
	if [[ $KERNEL = 'Darwin' ]];then
		NET_INTERFACE=$(netstat -nr | head | awk '/default/ {print $6}') # for macos
	else
		NET_INTERFACE=$(route -v | awk 'NR==3 {print $8}') # for linux 
	fi
}
__cleanup(){
	echo ${TMUX_BLUE/$TMUX_CONTENT/"Oops, server was shutdown..."} > $TMUX_OUTPUT
	exit
}
__init_process(){
	echo $0
	local serverCounts=$(/bin/ps -axf | grep -i "[s]erver.sh" | grep -vc "vim") # 子进程 + 父进程 = 2 ;[]防止grep自身,排除vim
	if [[  $serverCounts -gt 2 ]];then 
		echo "server was loaded..."
		exit 0
	fi
	rm -f $TMUX_OUTPUT 
	__set_kernel
	__set_network_interface
	trap "__cleanup"  1 2 3 6 15 # 注册一些singal handler

	echo "Server start successfully..."
}

# ------------------ FUNCTIONS ------------------ {{{
__get_wifi_ssid(){
	if [[ ! -z $NET_INTERFACE ]]; then
		networksetup -getairportnetwork $NET_INTERFACE | awk '{print "♒︎"$4}'
	fi
}
__get_ip(){
	if [[ ! -z $NET_INTERFACE ]]; then
		ifconfig $NET_INTERFACE | awk '$1=="inet" {print $2}'
	else
		echo "✖︎ "
	fi
}
__get_disk_usage(){
	df -lh | awk 'NR!=1&&NR!=3 {print $5}' | xargs echo ☯︎ 
}
__get_process_mem(){
	/usr/bin/top -l 1 -o mem -U hasky | awk '/COMMAND/ {getline; print "⚲ "$2"⎡ "$8,$13" ⎤"}'
}
__get_uptime(){
	# uptime | sed 's/.*averages: //'
	uptime| cut -d, -f4 | awk '{print "⎡ "$3"⎤"}'
}
__get_current_traffic(){
	if [[ $KERNEL = 'Darwin' ]];then
		TMUX_RX_NEW=$( netstat -I $NET_INTERFACE -bn | awk 'NR==2 {print $7}' )
		TMUX_TX_NEW=$( netstat -I $NET_INTERFACE -bn | awk 'NR==2 {print $10}')
	elif [[ $KERNEL = 'Linux' ]];then
		TMUX_RX_NEW=$( cat /sys/class/net/$NET_INTERFACE/statistics/$rx_bytes )
		TMUX_TX_NEW=$( cat /sys/class/net/$NET_INTERFACE/statistics/$tx_bytes )
	fi
	TMUX_TIMESTAMP_NEW=$( date +%s )
}
__get_traffic_rate(){
	__set_network_interface # 每次获取以处理断网等
	if [[ ! -z $NET_INTERFACE ]]; then
		# 1.获取当前流量和时间戳
		__get_current_traffic

		# 2.计算traffic/second
		duration=$((  $TMUX_TIMESTAMP_NEW - $TMUX_TIMESTAMP_OLD  ))
		rx_rate=$(( ( $TMUX_RX_NEW - $TMUX_RX_OLD ) / 1000 / $duration  ))
		tx_rate=$(( ( $TMUX_TX_NEW - $TMUX_TX_OLD ) / 1000 / $duration  ))

		# 3.写入缓存
		TMUX_RX_OLD=$TMUX_RX_NEW 
		TMUX_TX_OLD=$TMUX_TX_NEW
		TMUX_TIMESTAMP_OLD=$TMUX_TIMESTAMP_NEW

		TMUX_RATE="⥂ ${NET_INTERFACE} ⇲ ${rx_rate}K ⇱ ${tx_rate}K"
	else
		TMUX_RATE="✗ Network's off..."
	fi
}
__get_rest_mem(){
	memory_pressure | awk '/percent/ {print "✚ "$5}'
}

__get_batt(){
	pmset -g batt | awk '/InternalBattery/ {print "❍ "$3$4}' | sed 's/;/ /g'
}

# }}}

# ---------------------- ENTRY BELOW ------------------------
__init_process
while [[ $KERNEL ]];do
	__get_traffic_rate #这个函数不能放到子shell里执行,否则每次缓存的数据都无效。但是bash只支持状态返回,无法返回字符串,所以就这样吧

	echo ${TMUX_CYAN/$TMUX_CONTENT/"❖ $(uname -r)$(__get_uptime)"}\
		${TMUX_MAGENTA/$TMUX_CONTENT/" $(__get_batt)"}\
		${TMUX_GREEN/$TMUX_CONTENT/"$TMUX_RATE"}\
		${TMUX_BLUE/$TMUX_CONTENT/"$(__get_wifi_ssid) $(__get_ip)"}\
		${TMUX_RED/$TMUX_CONTENT/"$(__get_process_mem)"}\
		${TMUX_YELLOW/$TMUX_CONTENT/"$(__get_rest_mem) $(__get_disk_usage)"} > $TMUX_OUTPUT

	sleep 1
done

#([[ $(mpc | wc -l | xargs) -eq 1 ]] && mpd -V | head -n1 || mpc | awk 'NR==2 {printf $3} NR==1 {printf $0FS}')\
#[fg=cyan]「#(sw_vers | awk -F: '/Product/ {print $2}' | xargs)」\

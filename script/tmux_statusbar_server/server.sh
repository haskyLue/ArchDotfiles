#!/bin/bash
# 提前运行哦~ by debing.lu

# color
TMUX_CONTENT="TMUX"
TMUX_COLOR_TMPL="#[bg=default]#[fg=COLOR,none]⎡ ${TMUX_CONTENT}⎦ "
TMUX_GREEN=${TMUX_COLOR_TMPL/COLOR/GREEN}
TMUX_BLUE=${TMUX_COLOR_TMPL/COLOR/BLUE}
TMUX_RED=${TMUX_COLOR_TMPL/COLOR/RED}
TMUX_MAGENTA=${TMUX_COLOR_TMPL/COLOR/MAGENTA}
TMUX_CYAN=${TMUX_COLOR_TMPL/COLOR/CYAN}
TMUX_YELLOW=${TMUX_COLOR_TMPL/COLOR/YELLOW}

# network 
TMUX_RX_NEW=0
TMUX_TX_NEW=0
TMUX_TIMESTAMP_NEW=0
TMUX_RX_OLD=0
TMUX_TX_OLD=0
TMUX_TIMESTAMP_OLD=0

__set_kernel(){
	export KERNEL=$(uname -s)
}
__cleanup(){
	echo ${TMUX_BLUE/$TMUX_CONTENT/"Oops, Server was shutdown..."} > $TMUX_OUTPUT
	rm -f $TMUX_SERVER_PID
	exit
}
__init_process(){
	TMUX_CACHE_DIR=$([[ -e /Volumes/Toshiba/TMP/ ]] && echo "/Volumes/Toshiba/TMP" ||  echo "/tmp")
	export TMUX_OUTPUT=$TMUX_CACHE_DIR"/tmux_output"
	export TMUX_SERVER_PID=$TMUX_CACHE_DIR"/tmux_server.pid"

	if [[ -e $TMUX_SERVER_PID ]];then
		echo "Server was started..."
		exit 0
	fi
	__set_kernel
	trap "__cleanup"  1 2 3 6 15 # 注册一些singal handler
	echo "$$"> $TMUX_SERVER_PID
}

# ------------------ FUNCTIONS ------------------ 
__get_wifi_ssid(){
	if [[ ! -z $NET_INTERFACE ]]; then
		networksetup -getairportnetwork $NET_INTERFACE | awk '{print $4}'
	fi
}
__get_ip(){
	if [[ ! -z $NET_INTERFACE ]]; then
		ifconfig $NET_INTERFACE | awk '$1=="inet" {print $2}'
	fi
}
__get_disk_usage(){
	df -H | awk '/disk/ { print $4"/"$2 }' | xargs 
}
__get_process_mem(){
	/usr/bin/top -l 1 -o mem -U hasky |  awk '/COMMAND/ {getline; print $2,"<"$8,$13">"}'
}
__set_network_interface(){
	if [[ $KERNEL = 'Darwin' ]];then
		NET_INTERFACE=$(netstat -nr | head | awk '/default/ {print $6}') # for macos
	else
		NET_INTERFACE=$(route -v | awk 'NR==3 {print $8}') # for linux 
	fi
	export NET_INTERFACE
}
__get_current_traffic(){
	if [[ $KERNEL = 'Darwin' ]];then
		TMUX_RX_NEW=$( netstat -I $NET_INTERFACE -b | awk 'NR==2 {print $7}' )
		TMUX_TX_NEW=$( netstat -I $NET_INTERFACE -b | awk 'NR==2 {print $10}')
	elif [[ $KERNEL = 'Linux' ]];then
		TMUX_RX_NEW=$( cat /sys/class/net/$NET_INTERFACE/statistics/$rx_bytes )
		TMUX_TX_NEW=$( cat /sys/class/net/$NET_INTERFACE/statistics/$tx_bytes )
	fi
	TMUX_TIMESTAMP_NEW=$( date +%s )
}
__get_traffic_rate(){
	__set_network_interface
	if [[ ! -z $NET_INTERFACE ]]; then
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

		export TMUX_RATE="${NET_INTERFACE} ⇲ ${rx_rate}K ⇱ ${tx_rate}K"
	else
		export TMUX_RATE="Network's off..."
	fi
}


# ---------------------- ENTRY BELOW ------------------------
__init_process
while [[ $KERNEL ]];do
	__get_traffic_rate #这个函数不能放到子shell里执行,否则每次缓存的数据都无效。但是bash只支持状态返回,所以就这样吧

	echo ${TMUX_GREEN/$TMUX_CONTENT/"$TMUX_RATE"}\
		${TMUX_BLUE/$TMUX_CONTENT/"$(__get_wifi_ssid) $(__get_ip)"}\
		${TMUX_RED/$TMUX_CONTENT/"$(__get_process_mem)"}\
		${TMUX_YELLOW/$TMUX_CONTENT/"$(__get_disk_usage)"} > $TMUX_OUTPUT

	sleep 1
done

#([[ $(mpc | wc -l | xargs) -eq 1 ]] && mpd -V | head -n1 || mpc | awk 'NR==2 {printf $3} NR==1 {printf $0FS}')\
#[fg=cyan]「#(sw_vers | awk -F: '/Product/ {print $2}' | xargs)」\
#[fg=red]#(uptime | cut -d , -f 4 | cut -b 17-) \
#[fg=green]#(top -l 1 | awk 'NR==7 {print $2FS$6}')\]

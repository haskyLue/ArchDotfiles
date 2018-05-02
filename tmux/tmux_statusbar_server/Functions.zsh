#!/bin/zsh

TMUX_CACHE_DIR="/tmp"
TMUX_OUTPUT=$TMUX_CACHE_DIR"/tmux_output"
TMUX_PID_FILE="$TMUX_CACHE_DIR/tmux_server.pid"

# TMUX_COLOR_TMPL="#[fg=black]#[bg=colour237]#[bg=colour237]#[fg=COLOR,none] LABEL CONTENT #[fg=colour237]#[bg=default]"
TMUX_COLOR_TMPL="#[bg=black]#[fg=COLOR,none]LABEL CONTENT #[fg=COLOR]#[bg=black]"

OLD_FLOW_DATA=(0 0 0)
export TMUX_RATE

# tmux 状态栏字符串生成器
# $1 - color
# $2 - label
# $3 - content
__tmpl_parse(){
	local __str="${TMUX_COLOR_TMPL//COLOR/$1}"
	__str=${__str//LABEL/$2}
	echo ${__str//CONTENT/$3}
}

get_kernel_version(){
	uname -r
}

# wifi ssid名称
# $1 network_interface
get_wifi_ssid(){
	if [[ ! -z $1 ]]; then
		networksetup -getairportnetwork $1 | awk '{print $4}'
	else
		echo ""
	fi
}

# wifi网络ip
# $1 network_interface
get_ip(){
	if [[ ! -z $1 ]]; then
		ifconfig $1 | awk '$1=="inet" {print $2}'
	else
		echo "::"
	fi
}

# 磁盘使用情况
get_disk_usage(){
	# df -lh | awk 'NR!=1 {print $5}' | xargs echo
	df -lh | awk '/disk.*s1/ {print $5}' | xargs echo
}

# 内存使用情况
get_process_mem(){
	# 这个正则不错，利用贪心匹配得到最后一个空格
	/usr/bin/top -l 1 -o mem -U hasky -n1 -stats COMMAND,MEM | tail -n1 | sed 's/\(.*\)\ \(.*\)/\1 <\2>/'  
}

# 负载
get_uptime(){
	uptime | sed 's/.*averages: //g' | awk '{print "<"$1">"}'
}

# 当前流量
# $1 network_interface
# return (下行 上行 时间戳)
__get_current_traffic(){
	# for linux
	# $( cat /sys/class/net/$NET_INTERFACE/statistics/$rx_bytes )
	# $( cat /sys/class/net/$NET_INTERFACE/statistics/$tx_bytes )

	local flow_new=$( netstat -I $1 -bn | awk 'NR==2 {print $7,$10}' )
	local timestamp_new=$( date +%s )
	echo $flow_new $timestamp_new
}

# 计算网速 
# 该函数必须在当前进程执行，否则中间数据会失效;因此不能处理成返回值的形式
# $1 network_interface
get_traffic_rate(){
	if [[ ! -z $1 ]]; then
		# 1.获取当前流量和时间戳
		local new_flow_data=($(__get_current_traffic $1))

		# 2.计算traffic/second
		local duration=$((  $new_flow_data[3] - $OLD_FLOW_DATA[3]  ))
		local rx_rate=$(( ( $new_flow_data[1] - $OLD_FLOW_DATA[1] ) / 1000 / $duration  ))
		local tx_rate=$(( ( $new_flow_data[2] - $OLD_FLOW_DATA[2] ) / 1000 / $duration  ))

		# 3.写入缓存
		OLD_FLOW_DATA[1]=$new_flow_data[1]
		OLD_FLOW_DATA[2]=$new_flow_data[2]
		OLD_FLOW_DATA[3]=$new_flow_data[3]

		TMUX_RATE="$1 ⇲ ${rx_rate}K ⇱ ${tx_rate}K"
	else
		TMUX_RATE="0K"
	fi
}

#获取当前网络设备
__get_network_interface(){
	# route -v | awk 'NR==3 {print $8}' # for linux 
	netstat -nr | head | awk '/default/ {print $6}' # for macos
}

# 剩余内存
get_rest_mem(){
	memory_pressure | awk '/percent/ {print $5}'
}

# 电池
get_batt(){
	pmset -g batt | awk '/InternalBattery/ {print $3$4}' | sed 's/;/ /g'
}

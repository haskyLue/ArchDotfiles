#!/bin/zsh

__quit_handler(){
	__tmpl_parse "red" "✗" "$(date)" > $TMUX_OUTPUT 
	rm -f $TMUX_PID_FILE 
	exit 1
}

__main(){
	# local serverCounts=$(/bin/ps -axf | grep -i "[s]erver.sh" | grep -vc "vim") # 子进程 + 父进程 = 2 ;[]防止grep自身,排除vim
	# if [[  $serverCounts -gt 2 ]];then 
	# 	echo "server was loaded..."
	# 	exit 0
	# fi
	
	if [[ -e $TMUX_PID_FILE ]];then
		echo "服务已启动 " $$
		exit 1
	fi

	echo $$ > $TMUX_PID_FILE 
	trap "__quit_handler" INT TERM EXIT # 注册一些singal handler
	echo "服务启动成功..."

	# main logic
	while [[ 1 ]];do
		local netif=$(__get_network_interface)

		get_traffic_rate $netif
		echo $(__tmpl_parse "cyan" "⌘ " "$(get_kernel_version) $(get_uptime)")\
			$(__tmpl_parse "red" "⟲" "$(get_batt)")\
			$(__tmpl_parse "green" "⥂" "$TMUX_RATE")\
			$(__tmpl_parse "blue" "☫" "$(get_wifi_ssid $netif) $(get_ip $netif)")\
			$(__tmpl_parse "yellow" "❍" "$(get_rest_mem) $(get_process_mem)")\
			$(__tmpl_parse "magenta" "☯" "$(get_disk_usage)") > $TMUX_OUTPUT

		sleep 1
	done
}

source "$(dirname $0)/Functions.zsh"
__main

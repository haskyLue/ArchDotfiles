netinterface=$(route -v | awk 'NR==3 {print $8}')
if [ $netinterface ]
then
	rx_old=$( [[ -e /tmp/rx_bytes  ]] && ( cat /tmp/rx_bytes ) || echo 0 ) # 读取上一个时间戳的流量
	tx_old=$( [[ -e /tmp/tx_bytes  ]] && ( cat /tmp/tx_bytes ) || echo 0 )
	time_old=$( [[ -e /tmp/rx_tx_time  ]] && ( cat /tmp/rx_tx_time ) || 0 )

	rx_new=$(cat /sys/class/net/$netinterface/statistics/rx_bytes)
	tx_new=$(cat /sys/class/net/$netinterface/statistics/tx_bytes)
	time_new=$( date +%s )

	# rx_new=$( ifconfig -s $Interface | awk 'NR==2 {print $3}' )
	# tx_new=$( ifconfig -s $Interface | awk 'NR==2 {print $7}' )
	( echo $rx_new > /tmp/rx_bytes ) && ( echo $tx_new > /tmp/tx_bytes ) && ( echo $time_new > /tmp/rx_tx_time )# 写入缓存供下一个时间使用

	duration=$( expr $time_new \- $time_old )
	rx_rate=$(expr \( $rx_new \- $rx_old \) / 1000 / $duration )
	tx_rate=$(expr \( $tx_new \- $tx_old \) / 1000 / $duration )
	echo "#[bg=default]#[fg=white] #[fg=blue]↑↓#[fg=white]$netinterface#[fg=blue] ↘${rx_rate}.0#[fg=white]KB/s#[fg=blue] ↗${tx_rate}.0#[fg=white]KB/s"
else
	echo "#[bg=default]#[fg=default] Invalid Interface!"
fi

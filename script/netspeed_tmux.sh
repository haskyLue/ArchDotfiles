netinterface=$(route -v | awk '/default/ {print $8}')
# wifi=$(wicd-cli -yd | awk '/Essid/ {print $2}')
watchinteval=1
if [ $netinterface ]
then
	rx_old=$( [[ -e /tmp/rx_bytes  ]] && cat /tmp/rx_bytes || echo 0 ) # 读取上一个时间戳的流量
	tx_old=$( [[ -e /tmp/tx_bytes  ]] && cat /tmp/tx_bytes || echo 0 )

	rx_new=$(cat /sys/class/net/$netinterface/statistics/rx_bytes)
	tx_new=$(cat /sys/class/net/$netinterface/statistics/tx_bytes)
	echo $rx_new > /tmp/rx_bytes && echo $tx_new > /tmp/tx_bytes # 写入缓存供下一个时间使用

	rx_rate=$(expr \( $rx_new \- $rx_old \) / 1000 / $watchinteval )
	tx_rate=$(expr \( $tx_new \- $tx_old \) / 1000 / $watchinteval )
	echo "#[bg=default]#[fg=white] #[fg=blue]↑↓#[fg=white]$netinterface#[fg=blue]↘${rx_rate}.0#[fg=white]KB/s#[fg=blue]↗${tx_rate}.0#[fg=white]KB/s"
else
	echo "#[bg=default]#[fg=default] Invalid Interface!"
fi

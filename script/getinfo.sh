#! /bin/bash 
# create by ldb

secret="/home/hasky/Workspace/secret"
# color define
black='\E[30;47m'
red='\E[31;47m'
green='\E[32;47m'
yellow='\E[33;47m'
blue='\E[34;47m'
magenta='\E[35;47m'
cyan='\E[36;47m'
white='\E[37;47m'

who=$(who -q | xargs )
cputemp=$(sensors -A | awk '/Core/ {print $2,$3}' | paste -sd ",")
# hddtemp=$(sudo -S hddtemp /dev/sda /dev/sdb < $secret | awk '{$3="-"; print $1,$4}'| paste -sd ",")
iostat=$(iostat -md)
# mpdinfo=$(mpc -f '%artist% - %title% - %time%' | head -n1)
volume=$(amixer get Master | tail -n1 | awk '{print $4,$6}')
# date=$(date)
# uptime=$( uptime | cut -d\  -f6-)
# uname=$(uname -rv)
# vmstat=$(vmstat -wS m)
# battery=$(acpi -b)
wifi=$(wicd-cli -yd | awk '/Essid/ {print $2}')
externalip=$( [[ -s /tmp/externalip ]] && cat /tmp/externalip || curl -s -o /tmp/externalip http://myexternalip.com/raw )

# function {{{
function update_weather(){
	echo "更新天气中..."
	curl -s http://flash.weather.com.cn/wmaps/xml/nanjing.xml  | awk -F \" '/浦口/ {print "Weather："$18,"温度:"$20"~"$22"°C",$24"°C","风向风速:"$26,$30}' > /tmp/weather
	echo $(date +%s)>/tmp/weather_flag
}
function get_weather(){
	local howlong=3600 # 1hours更新一次
	! [ -f /tmp/weather_flag ] && update_weather #检测flag文件,不存在则更新

	local last_update=$(cat /tmp/weather_flag)
	local now_date=$(date +%s)
	let duration="$now_date-$last_update"
	if [[ $duration -gt $howlong ]];then
		update_weather
	fi #检测flag文件，过期则更新

	if [[ -s /tmp/weather ]]; then
		cat /tmp/weather
	else 
		echo "网络连接失败"
		rm -f /tmp/weather_flag #删除flag文件便于下次执行重新更新
	fi #显示文件内容
}
# function netspeed(){
# 	local netinterface=$(route -v | awk '/default/ {print $8}')
# 	local wifi=$(wicd-cli -yd | awk '/Essid/ {print $2}')
# 	local watchinteval=1
# 	if [ $netinterface ]
# 	then
# 		rx_old=$( [[ -e /tmp/rx_bytes  ]] && cat /tmp/rx_bytes || echo 0 ) # 读取上一个时间戳的流量
# 		tx_old=$( [[ -e /tmp/tx_bytes  ]] && cat /tmp/tx_bytes || echo 0 )
#
# 		rx_new=$(cat /sys/class/net/$netinterface/statistics/rx_bytes)
# 		tx_new=$(cat /sys/class/net/$netinterface/statistics/tx_bytes)
# 		echo $rx_new > /tmp/rx_bytes && echo $tx_new > /tmp/tx_bytes # 写入缓存供下一个时间使用
#
# 		rx_rate=$(expr \( $rx_new \- $rx_old \) / 1000 / $watchinteval )
# 		tx_rate=$(expr \( $tx_new \- $tx_old \) / 1000 / $watchinteval )
# 		echo "Net    ：$netinterface - $wifi   |   rx_rate - ${rx_rate}.0 KByte  |  tx_rate - ${tx_rate}.0 KByte\e[0m"
# 	else
# 		echo "Net    ：Invalid Interface!"
# 	fi
# }
# function end }}}

# main content {{{

# figlet -c About PC
# echo -e $blue" 时间：$date\e[0m"
# echo -e $magenta" 发行版：$uname\e[0m"
# echo -e $cyan" UPTIME：$uptime\e[0m"
# echo -e $red"Battery：$battery\e[0m"
# echo
# echo -e $blue"MPD：$mpdinfo\e[0m"
# echo -e $magenta" wifi：$wifi\e[0m"
echo -e $white"$iostat\e[0m"
# echo -e $red"$vmstat\e[0m"
echo 
# echo -e $red"$(netspeed)\e[0m"
echo -e $magenta"User   ：$who\e[0m" 
echo -e $green"CPU    ：$cputemp\e[0m" 
echo -e $cyan"Vol    ：$volume\e[0m" 
# echo -e $green"CPU    ：$cputemp\e[0m" "|" $yellow" HDD：$hddtemp\e[0m"
echo -e $yellow"$(get_weather)\e[0m"
echo -e $red"ifinfo : $wifi / $externalip\e[0m"

# main end }}}

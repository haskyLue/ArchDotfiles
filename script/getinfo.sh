#! /bin/bash 
# create by ldb

secret="/home/hasky/Workspace/secret"
black='\E[30;47m'
red='\E[31;47m'
green='\E[32;47m'
yellow='\E[33;47m'
blue='\E[34;47m'
magenta='\E[35;47m'
cyan='\E[36;47m'
white='\E[37;47m'

declare who cpu iostat charge wifi externalip weather


# {{{ weather
function weather.pull(){
	curl -so /tmp/weather.raw \
		"http://flash.weather.com.cn/wmaps/xml/nanjing.xml" && cat /tmp/weather.raw \
		| awk -F \" '/浦口/ {print $18,$20"~"$22"°C",$24"°C",$26,$30}' > /tmp/weath
	date +%s > /tmp/weather.flag
}
function weather.cal(){
	local howlong=3600 
	local last_update=$( [[ -f /tmp/weather.flag ]] && cat /tmp/weather.flag || echo 0 ) # flag文件不存在作0处理
	local now_date=$(date +%s)
	local duration=$(expr $now_date \- $last_update)
	[[ $duration -gt $howlong ]] && echo 1 || echo 0
}
function weather.show(){
	local suffix="$green -OK\e[0m"
	[[ $( route | wc -l ) -le 2 ]] && suffix="$red -Failed\e[0m" #网络接口连接
	[[ ! -s /tmp/weather || $(weather.cal) -eq 1 ]] && ( weather.pull )&  #数据文件不正常 || 过期
	local content=$( [[ -s /tmp/weather ]] && ( cat /tmp/weather ) || ( echo 'Data Pulling...' ) )
	echo -e "$content$suffix"
}
# }}}

# function netspeed(){
# 	local netinterface=$(route -v | awk '/default/ {print $8}')
#   local wifi=$(iwgetid | awk '{print $2}')
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

# 初始化
function main_command()
{
	who=$(who -q | xargs )
	cputemp=$(sensors -A | awk '/Core/ {print $2,$3}' | paste -sd ",")
	# hddtemp=$(sudo -S hddtemp /dev/sda /dev/sdb < $secret | awk '{$3="-"; print $1,$4}'| paste -sd ",")
	iostat=$(iostat -kd)
	# mpdinfo=$(mpc -f '%artist% - %title% - %time%' | head -n1)
	volume=$(amixer get Master | tail -n1 | awk '{print $4,$6}')
	# date=$(date)
	# uptime=$( uptime | cut -d\  -f6-)
	# uname=$(uname -rv)
	# vmstat=$(vmstat -wS m)
	charge=$(acpi -a | awk '{print $3}')
	wifi=$(iwgetid | awk '{print $2}')
	externalip=$( [[ -s /tmp/externalip ]] && ( cat /tmp/externalip ) || ( curl -so /tmp/externalip 'http://myexternalip.com/raw' )& )
	weather=$(weather.show)
}

# 前端显示
function init()
{
	# figlet -c About PC
	# echo -e $blue" 时间：$date\e[0m"
	# echo -e $magenta" 发行版：$uname\e[0m"
	# echo -e $cyan" UPTIME：$uptime\e[0m"
	# echo
	# echo -e $blue"MPD：$mpdinfo\e[0m"
	# echo -e $magenta" wifi：$wifi\e[0m"
	# echo -e $red"$vmstat\e[0m"
	# echo -e $red"$(netspeed)\e[0m"
	# echo -e $green"CPU    ：$cputemp\e[0m" "|" $yellow" HDD：$hddtemp\e[0m"
	echo -e "$iostat\e[0m"
	echo 
	echo -e $magenta"Users  ：$who\e[0m" 
	echo -e   $green"CPU    ：$cputemp\e[0m" 
	echo -e    $cyan"Volume ：$volume\e[0m" '\t' $blue"Charge ：$charge\e[0m"
	echo -e     $red"Iwinfo : $wifi / $externalip\e[0m"
	echo -e  $yellow"Weather: $weather\e[0m"
}
# while true; do
# 	main_command
# 	init
#     sleep 2
# done

# use `watch`
main_command
init

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

cputemp=$(sensors -A | awk '/Core/ {print $1$2,$3}' | paste -sd "\t")
hddtemp=$(sudo -S hddtemp /dev/sda /dev/sdb < $secret | awk '{$3="-"; print $0}'| paste -sd "\t")
iostat=$(iostat | tail -n4 | head -n6)
# mpdinfo=$(mpc status |head -n2|sed 'N;s/\n/ /')
# wifi=$(wicd-cli -yd|head -n2|paste -sd '\t')
# volume=$(amixer get Master | tail -n1 | awk '{print $4,$6}')
# date=$(date)
# uptime=$( uptime | cut -d\  -f6-)
# uname=$(uname -rv)
free=$(free -m | head -n2 )
# battery=$(acpi -b)

# function {{{
function update_weather(){
	echo "更新天气中..."
	curl -s http://flash.weather.com.cn/wmaps/xml/nanjing.xml  | awk -F \" '/浦口/ {print "WEATHER："$18,"温度:"$20"~"$22"°C",$24"°C","风向风速:"$26,$30}' > /tmp/weather
	echo $(date +%s)>/tmp/weather_flag
}
function get_weather(){
	local howlong=3600 # 1hours更新一次
	! [ -f /tmp/weather_flag ] && update_weather #检测flag文件

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
function netspeed(){
	local netinterface=$(route -v | awk '/default/ {print $8}')
	local watchinteval=1
	if [ $netinterface ]
	then
		rx_old=$( [[ -e /tmp/rx_bytes  ]] && cat /tmp/rx_bytes || echo 0 )
		tx_old=$( [[ -e /tmp/tx_bytes  ]] && cat /tmp/tx_bytes || echo 0 )

		rx_new=$(cat /sys/class/net/$netinterface/statistics/rx_bytes)
		tx_new=$(cat /sys/class/net/$netinterface/statistics/tx_bytes)
		echo $rx_new > /tmp/rx_bytes && echo $tx_new > /tmp/tx_bytes

		rx_rate=$(expr \( $rx_new \- $rx_old \) / 1024 / $watchinteval )
		tx_rate=$(expr \( $tx_new \- $tx_old \) / 1024 / $watchinteval )
		echo "Net：		$netinterface   |   rx_rate- ${rx_rate}.0 KByte   |   tx_rate- ${tx_rate}.0 KByte\e[0m"
	else
		echo "网速：未知接口!"
	fi
}
# function end }}}

# main content {{{
# figlet -c About PC
# echo -e $blue" 时间：$date\e[0m"
# echo -e $magenta" 发行版：$uname\e[0m"
echo -e $blue"$free\e[0m"
echo 
echo -e $red"$iostat\e[0m"
echo -e $magenta"$(netspeed)\e[0m"
echo 
# echo -e $cyan" UPTIME：$uptime\e[0m"
echo -e $green"CPU_TEMP：$cputemp\e[0m"
echo -e $yellow"HDD_TEMP：$hddtemp\e[0m"
# echo
# echo -e $blue"MPD：$mpdinfo\e[0m"
# echo -e $cyan"VOLUME：$volume\e[0m"
# echo -e $white"BATTERY：$battery\e[0m"
echo
echo -e $cyan"$(get_weather)\e[0m"
# echo -e $magenta" wifi：$wifi\e[0m"
# main end }}}

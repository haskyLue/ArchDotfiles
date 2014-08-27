#! /bin/bash 
# create by ldb

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
hddtemp=$(sudo hddtemp /dev/sda /dev/sdb|awk '{$3="-"; print $0}'|paste -sd "\t")
mpdinfo=$(mpc status |head -n2|xargs -L2 echo)
wifi=$(wicd-cli -yd|head -n2|paste -sd '\t')
netinterface=$(route -v | awk '/default/ {print $8}')
volume=$(amixer get Master | tail -n1 | awk '{print $4,$6}')
uptime=$( uptime | cut -d\  -f6-)

# function {{{
function update_weather(){
	echo "更新天气中..."
	curl -s http://flash.weather.com.cn/wmaps/xml/nanjing.xml  | awk -F \" '/浦口/ {print "浦口天气："$18,"温度:"$20"~"$22"°C",$24"°C","风向风速:"$26,$30}' > /tmp/weather
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
	if [ $netinterface ]
	then
		rx_old=$(cat /sys/class/net/$netinterface/statistics/rx_bytes)
		tx_old=$(cat /sys/class/net/$netinterface/statistics/tx_bytes)
		sleep 1
		rx_now=$(cat /sys/class/net/$netinterface/statistics/rx_bytes)
		tx_now=$(cat /sys/class/net/$netinterface/statistics/tx_bytes)
		let rx_rate="($rx_now - $rx_old) /1/1024"
		let tx_rate="($tx_now - $tx_old) /1/1024"
		echo "网速：$netinterface - down.${rx_rate}K/up.${tx_rate}K\e[0m"
	else
		echo "网速：未知接口!"
	fi
}
function kaoyan(){ 
	local target_time=1420331400 #2015,1,4
	local now_time=$(date +%s)
	let spare_time="($target_time-$now_time)/3600/24"
	echo "距离考研还有$spare_time天"
}
# function end }}}

# main content {{{
figlet -c About PC
echo
echo -e '*  '$magenta"$(get_weather)\e[0m"
echo '*  '
echo -e '*  '$cyan"UPTIME：$uptime\e[0m"
echo -e '*  '$green"CPU温度：$cputemp\e[0m"
echo -e '*  '$yellow"硬盘温度：$hddtemp\e[0m"
echo '*  '
echo -e '*  '$blue"MPD：$mpdinfo\e[0m"
echo -e '*  '$white"音量：$volume\e[0m"
echo '*  '
echo -e '*  '$magenta"wifi：$wifi\e[0m"
# echo -e '*  '$cyan"$(netspeed)\e[0m"
# main end }}}


echo -e "\t\t\t\t\t\t\t\t\t-----------------"
echo -e $red"\t\t\t\t\t\t\t\t\t$(kaoyan)\e[0m"

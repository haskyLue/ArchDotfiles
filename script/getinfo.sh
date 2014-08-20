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

systeminfo=$(uname -r)
cputemp=$(sensors -A | awk '/Core/ {print $1$2,$3}' | paste -sd "\t")
hddtemp=$(sudo hddtemp /dev/sda /dev/sdb|paste -sd "\t")
mpdinfo=$(mpc status |head -n2|xargs -L2 echo)
ninterface=$(wicd-cli -yd|head -n2|paste -sd '\t')
volume=$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')
uptime=$(uptime)
function update_weather(){
	echo "更新天气中..."
	curl -s http://flash.weather.com.cn/wmaps/xml/nanjing.xml  | awk -F \" '/浦口/ {print "浦口天气："$18,"温度:"$20"~"$22,$24"摄氏度","风向风速:"$26,$30}' > /tmp/weather
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
function kaoyan(){ 
	local target_time=1420331400 #2015,1,4
	local now_time=$(date +%s)
	let spare_time="($target_time-$now_time)/3600/24"
	echo $red"距离考研还有$spare_time天\e[0m"
}

# main content
figlet -c About PC
echo
echo -e '*  '$magenta"$(get_weather)\e[0m"
echo '*  '
echo -e '*  '$red"发行版：$systeminfo\e[0m"
echo '*  '
echo -e '*  '$cyan"Uptime：$uptime\e[0m"
echo -e '*  '$green"cpu温度：$cputemp\e[0m"
echo -e '*  '$yellow"硬盘温度：$hddtemp\e[0m"
echo '*  '
echo -e '*  '$blue"音乐播放器：$mpdinfo\e[0m"
echo -e '*  '$white"音量：$volume\e[0m"
echo '*  '

rx_old=$(cat /sys/class/net/wlp3s0/statistics/rx_bytes)
tx_old=$(cat /sys/class/net/wlp3s0/statistics/tx_bytes)
sleep 1
rx_now=$(cat /sys/class/net/wlp3s0/statistics/rx_bytes)
tx_now=$(cat /sys/class/net/wlp3s0/statistics/tx_bytes)
let rx_rate="($rx_now - $rx_old) /1/1024"
let tx_rate="($tx_now - $tx_old) /1/1024"

echo -e '*  '$cyan"网速：${rx_rate}K/${tx_rate}K\e[0m"
echo -e '*  '$magenta"wifi：$ninterface\e[0m"


echo -e "\t\t\t\t\t\t\t\t\t-----------------"
echo -e "\t\t\t\t\t\t\t\t\t$(kaoyan)"

#! /bin/bash
tm(){
	launhctl load /Users/hasky/Documents/.dotFile/tmux/tmux_statusbar_server/lynx.tmux.server.plist 
	tmux -2
}
tmas(){
	tmux -u attach-session
}

get_weather_info(){
	WEATHER_INFO=$( curl -sL "http://www.weather.com.cn/weather/101010100.shtml" | sed -n "/skyid.*on/,/li>/p" )
	WEA=$(echo "$WEATHER_INFO" | awk -F\" '/wea/ {print $4}') #加引号保持换行格式
	TEM=$(echo "$WEATHER_INFO" | grep -Eo "\d+℃" | paste -s -d '~' -)
	echo $WEA $TEM | say -v Ting-Ting &
}

# shadowsocks(){
# 	DIR="/usr/local/etc/ssconf"
#
# 	# 清理
# 	# [[ `jobs -l` ]] && pkill python 
# 	killall client_darwin_amd64
#
# 	# 配置shadowsocks
# 	local shadow_conf="$DIR/shadowsocks-libev.$1.json"
# 	if [[ -e $shadow_conf ]] ; then
# 		# kcp
# 		[[ $1 = "vps" ]] && /Users/hasky/Documents/bin/kcp/client_darwin_amd64 -c /Users/hasky/Documents/bin/kcp/kcpclient.json &
# 		# 设置代理
# 		local DEVICE="Wi-Fi";
# 		if [[ $2 = "gb" ]]; then 
# 			echo "设置全局"
# 			sudo networksetup -setautoproxystate $DEVICE off
# 			sudo networksetup -setsocksfirewallproxystate $DEVICE on 
# 			sudo networksetup -setsocksfirewallproxy $DEVICE localhost 1080
# 		else 
# 			echo "设置AUTO PAC"
# 			sudo networksetup -setsocksfirewallproxystate $DEVICE off 
# 			sudo networksetup -setautoproxystate $DEVICE on
# 			sudo networksetup -setautoproxyurl $DEVICE "http://45.32.29.202:8080/proxy.pac"
# 			#cd $DIR && python -m SimpleHTTPServer > /dev/null & #启动server
# 		fi
#
# 		# trap "networksetup -setautoproxystate $DEVICE off;exit" SIGINT
#
# 		echo "将使用$shadow_conf"
# 		ss-local -c $shadow_conf -v --fast-open -u; # 启动 shadowsocks
# 	else
# 		echo "$shadow_conf 不存在"
# 	fi
# }

fuckgfw(){
	# 下载gfwlist
	cd /tmp
	aria2c -q https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt

	# 生成user-rule
	echo "
||bintray.com
||gstatic.com
||apple.com
||android.com
||google.com
||gmail.com
||ytimg.com
||github.com
||reddit.com
||android.com
||googleusercontent.com
||clips4sale.com
||datatracker.ietf.org
||leetcode.com
||sciencedirect.com
||xda-developers.com
||vultr.com" > user-rule.txt

	# 转pac
	gfwlist2pac -i gfwlist.txt  -p "SOCKS5 127.0.0.1:1080; SOCKS 127.0.0.1:1080; DIRECT;" --user-rule=user-rule.txt --precise -f /usr/local/etc/ssconf/proxy.pac
}


parse_string()
{
	echo $1 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g' 
} # 处理字符串变量部分字符的转义 for sed

# cmd proxy {{{
# 用proxychains!!!
# proxyon()
#{
# 	# export http_proxy="127.0.0.1:8087"
# 	export http_proxy="localhost:8087"
# 	export https_proxy=$http_proxy
# 	export ftp_proxy=$http_proxy
# 	export rsync_proxy=$http_proxy
# 	export all_proxy=$http_proxy
# 	export no_proxy="localhost,localaddress,.localdomain.com"
#
# 	export HTTP_PROXY=$http_proxy
# 	export HTTPS_PROXY=$http_proxy
# 	export FTP_PROXY=$http_proxy
# 	export RSYNC_PROXY=$http_proxy
# 	export ALL_PROXY=$http_proxy
# 	export NO_PROXY="localhost,localaddress,.localdomain.com"
# 	echo -e "设置代理环境变量\n"
# }
# proxyoff(){
# 	unset HTTP_PROXY
# 	unset http_proxy
# 	unset HTTPS_PROXY
# 	unset https_proxy
# 	unset FTP_PROXY
# 	unset ftp_proxy
# 	unset RSYNC_PROXY
# 	unset rsync_proxy
# 	unset ALL_PROXY
# 	unset all_proxy
# 	echo -e "清除代理环境变量\n"
# }
# }}}

# for awesome WM {{{
# cwall(){
# 	/usr/bin/cp -f $1 /home/hasky/Downloads/Image/background.jpg
# 	echo "awesome.restart()"|awesome-client 2>> /dev/null
# }
# tawsome(){
# 	local RCPWD="/home/hasky/Documents/dotfiles"
# 	local CUR_RC="/home/hasky/.config/awesome/rc.lua"
# 	if file $CUR_RC | grep -o light >> /dev/null;then
# 		ln -sf $RCPWD/rc.lua $CUR_RC
# 	else 
# 		ln -sf $RCPWD/rc.light.lua $CUR_RC
# 	fi
# 	echo "awesome.restart()"|awesome-client 2>>/dev/null
# }
# }}}




#{{{ fuck gwf 
# Upac()
# {
# 	gfwlist="https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt"
# 	userlist="https://raw.githubusercontent.com/JinnLynn/genpac/master/genpac/res/user-rules-sample.txt"
# 	cd /Volumes/Caches/ && rm -f user_rule.* gfwlist.*
# 	proxychains4 aria2c $gfwlist 
# 	proxychains4 aria2c $userlist 
#
# 	gfwlist2pac -i gfwlist.txt -f /usr/local/var/www/proxy.pac -p 'SOCKS5 127.0.0.1:1080; PROXY 127.0.0.1:8087; DIRECT;' --user-rule user_rule.txt  
# }
# Ugoagent(){
# 	figlet -c GoAgent-Init
# 	cd /Users/hasky/Documents/devel/git/goagent
# 	git archive HEAD --format=zip > /Volumes/Caches/goagent-3.0.zip
#
# 	echo -e "\nextract goagent dir from git archive\n"
# 	cd /Volumes/Caches && sudo rm -rf ./goagent-3.0 && unzip ./goagent-3.0.zip -d goagent-3.0 && rm -f ./goagent-3.0.zip
# 	cd ./goagent-3.0/local && ln -sf ~/.proxy.user.ini proxy.user.ini
#
# 	echo -e "\ngenerate new fake cert for goagent\n"
# 	rm -f ./CA.crt 
# 	(sleep 5 && ps -jA | awk '/.*proxy.py$/ {print $2}' | head | xargs -I {} sudo kill -9 {})& # kill goagent to get CA.crt
# 	sudo ./proxy.py
#
# 	echo -e "\ninstall cert to system && firefox\n"
# 	sudo security delete-certificate -c GoAgent 
# 	sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "CA.crt"
# 	# for nss (mainly for firefox)
# 	certutil -D -n 'GoAgent - GoAgent' -d "/Users/hasky/Library/Application Support/Firefox/Profiles/1yijdi2a.default" 
# 	certutil -A -n 'GoAgent - GoAgent' -i "CA.crt" -t "CT,C,C" -d "/Users/hasky/Library/Application Support/Firefox/Profiles/1yijdi2a.default" 
# 	# reboot firefox
#
# 	echo -e "\nremove info log for performance\n"
# 	sed 's/self.log.*INFO.*/pass/' proxy.py > proxy.py- && mv -f proxy.py- proxy.py && chmod +x proxy.py # 去掉正常的显示
# 	# ln -fs /Users/hasky/Documents/devel/git/gfwlist2pac/test/proxy.pac
#
# 	echo -e "\nstart!!!\n"
# 	sudo ./proxy.py
# }
# get_goagent_ip()
# {
# 	local location="/Users/hasky/Documents/devel/git/checkgoogleip"
# 	echo "running per an hour..."
# 	# local ip=`awk 'NR<15 {print $1}' ip_tmpok.txt | xargs | tr ' ' '|'` 
# 	# echo $ip | pbcopy ""  && echo -e "copied to clip\n$ip"
# 	while 1;do
# 		$location/checkip.py 
# 		echo -e "$location \n"
# 		cat $location/ip.txt && cp -f $location/ip.txt /tmp
# 		sleep 18000
# 	done
# 	# vim +13 ~/.proxy.user.ini
# }

netsh_hosts()
{
	rm -f /Volumes/Caches/hosts.txt
	curl 'http://serve.netsh.org/pub/hosts.php?passcode=19735&gs=on&wk=on&twttr=on&fb=on&flkr=on&dpbx=on&odrv=on' -H 'Host: serve.netsh.org' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:34.0) Gecko/20100101 Firefox/34.0' -H 'Accept: */*' -H 'Accept-Language: zh-cn,en-us;q=0.7,en;q=0.3' --compressed -H 'X-Requested-With: XMLHttpRequest' -H 'Referer: http://serve.netsh.org/pub/gethosts.php' -H 'Cookie: hostspasscode=19735; Hm_lvt_e26a7cd6079c926259ded8f19369bf0b=1418651792; Hm_lpvt_e26a7cd6079c926259ded8f19369bf0b=1418651792' -H 'Connection: keep-alive' \
		> /tmp/hosts.txt
}

Uhosts()
{
	local secret="/Users/hasky/Documents/bin/secret"
	local hosts_append='
	# avoid adobe PS activate
	127.0.0.1 activate.adobe.com
	127.0.0.1 practivate.adobe.com
	127.0.0.1 ereg.adobe.com
	127.0.0.1 activate.wip3.adobe.com
	127.0.0.1 3dns-3.adobe.com
	127.0.0.1 3dns-2.adobe.com
	127.0.0.1 adobe-dns.adobe.com
	127.0.0.1 adobe-dns-2.adobe.com
	127.0.0.1 adobe-dns-3.adobe.com
	127.0.0.1 ereg.wip3.adobe.com
	127.0.0.1 activate-sea.adobe.com
	127.0.0.1 wwis-dubc1-vip60.adobe.com
	127.0.0.1 activate-sjc0.adobe.com
	127.0.0.1 hl2rcv.adobe.com
	127.0.0.1 lmlicenses.wip4.adobe.com
	127.0.0.1 lm.licenses.adobe.com
	127.0.0.1 na2m-pr.licenses.adobe.com
	127.0.0.1 ims-na1-prprod.adobelogin.com
	127.0.0.1 na4r.services.adobe.com
	127.0.0.1 na1r.services.adobe.com
	127.0.0.1 hlrcv.stage.adobe.com

	# baidupcs
	# 2400:da00::dbf:0:6666 p.baidupcs.com
	# 2400:da00::dbf:0:6666 nj.baidupcs.com
	# 2400:da00::dbf:0:6666 qd.baidupcs.com
	# 2400:da00::dbf:0:6666 cdn.baidupcs.com
	# 2400:da00::dbf:0:6666 hot.baidupcs.com
	# 2400:da00::dbf:0:6666 www.baidupcs.com
	# 2400:da00::dbf:0:6666 hot.cdn.baidupcs.com
	# 2400:da00::dbf:0:6666 d.pcs.baidu.com
	# 2400:da00::dbf:0:6666 pcs.n.shifen.com

	10.0.4.251 godinsec.gitlab.com
	10.0.4.251 godinsec.phabricator.com
	10.0.4.251 godinsec.jenkins.com
	'

	# local HOSTS_URL="https://raw.githubusercontent.com/lennylxx/ipv6-hosts/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/txthinking/google-hosts/master/hosts"
	# local HOSTS_URL="http://godinsec.gitlab.com/genglei.cuan/hosts/raw/master/hosts"
	local HOSTS_URL="https://raw.githubusercontent.com/racaljk/hosts/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/DingSoung/hosts/master/hosts"
	# 广告-------------
	# local HOSTS_URL="http://hosts.eladkarako.com/hosts.txt"

	figlet -c Uhost
	echo "\e[34m DOWNLOADING HOSTS\e[0m"
	cd /tmp && rm -f hosts.txt && aria2c --dir=/tmp --out=hosts.txt $HOSTS_URL
	dos2unix hosts.txt
	# netsh_hosts # 注释HOSTS_URL rm -f 
	touch /tmp/hosts
	if [[ -e /tmp/hosts.txt ]] ;then
		echo $hosts_append >> /tmp/hosts.txt

		echo -e "\nFINISHING..."
		sudo -S cp -fv /tmp/hosts.txt /etc/hosts < $secret
	fi

	# echo ""
	# grep -i "UPDATE" /etc/hosts
}

# _dnsmasq()
# {
# 	arg=$1
# 	dir="/Library/LaunchDaemons"
# 	case $arg in
# 		start)
# 			echo "Starting dnsmasq..."
# 			sudo launchctl load $dir/homebrew.mxcl.dnsmasq.plist
# 			;;
# 		stop)
# 			echo "Stopping dnsmasq..."
# 			sudo launchctl unload $dir/homebrew.mxcl.dnsmasq.plist
# 			;;
# 		restart)
# 			sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
# 			sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
#
# 			echo "Stopping dnsmasq..."
# 			sudo launchctl unload $dir/homebrew.mxcl.dnsmasq.plist
# 			sleep 1
# 			echo "Starting dnsmasq..."
# 			sudo launchctl load $dir/homebrew.mxcl.dnsmasq.plist
# 			;;
# 		edit)
# 			vim /usr/local/etc/dnsmasq.conf
# 			;;
# 	esac
# } 

# _shadowsocks()
# {
# 	arg=$1
# 	dir="/Library/LaunchDaemons"
# 	case $arg in
# 		start)
# 			echo "Starting shadowsocks..."
# 			# sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.plist
# 			sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
# 			;;
# 		stop)
# 			echo "Stopping shadowsocks..."
# 			# sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.plist
# 			sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
# 			;;
# 		restart)
# 			echo -e "Stopping shadowsocks...\n"
# 			# sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.plist
# 			sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
# 			echo "Starting shadowsocks..."
# 			# sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.plist
# 			sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
# 			;;
# 		edit)
# 			# sudo vim -o $dir/{homebrew.mxcl.shadowsocks-libev.plist,homebrew.mxcl.shadowsocks-libev.tunnel.plist}
# 			sudo vim -o $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
# 			;;
# 	esac
# } 

# _chinadns()
# {
# 	arg=$1
# 	dir="/Library/LaunchDaemons"
# 	case $arg in
# 		start)
# 			echo "Starting chinadns..."
# 			sudo launchctl load $dir/homebrew.mxcl.chinadns.plist
# 			;;
# 		stop)
# 			echo "Stopping chinadns..."
# 			sudo launchctl unload $dir/homebrew.mxcl.chinadns.plist
# 			;;
# 		restart)
# 			echo -e "Stopping chinadns...\n"
# 			sudo launchctl unload $dir/homebrew.mxcl.chinadns.plist
# 			echo "Starting chinadns..."
# 			sudo launchctl load $dir/homebrew.mxcl.chinadns.plist
# 			;;
# 		edit)
# 			sudo vim $dir/homebrew.mxcl.chinadns.plist
# 			;;
# 	esac
# } 
#}}}

# Udns()
# {
# 	local secret="/Users/hasky/Documents/bin/secret"
# 	echo -e "nameserver 223.5.5.5 \nnameserver 223.6.6.6" > /tmp/resolv
# 	# echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /tmp/resolv
# 	/bin/cp -fv /etc/dnsmasq-resolv.conf /tmp/
# 	sudo -S cp -fv /tmp/resolv /etc/dnsmasq-resolv.conf < $secret
# 	cat /etc/dnsmasq-resolv.conf
# }

rename_mp3()
{
	eyeD3 --rename '$artist - $title' $1 >> /Volumes/Caches/Music_rename_log
}

# move_log()
# {
# 	sudo -s
# 	mount_point=/Volumes/Caches
# 	[[ -L /var/log ]] && ( cd /var/log && pwd -P ) || ( sudo mv /var/log $mount_point/var_log && sudo ln -sf $mount_point/var_log /var/log ) 
# }

Ugitdir()
{
	local DIR="/Users/hasky/Documents/GIT_PROJECT"
	for dir in $DIR/*
	do
		if [ -d $dir/.git ]; then
			echo "\e[34m remote pulling $dir...\e[0m "
			cd $dir
			proxychains4 -q git pull -v origin
		fi
	done
}
# reload_ath9k(){
# 	sudo modprobe -rv ath9k
# 	sleep 5
# 	sudo modprobe -fv ath9k
# }

calc() 
{
	echo "scale=3;$@" | bc -l
}

brew_upgrade()
{
	figlet -c brew_upgrade
	export http_proxy=http://127.0.0.1:1087
	export https_proxy=http://127.0.0.1:1087
	brew update 
	brew upgrade 
	brew cleanup --force
	brew prune

	# figlet -c software_update
	# sudo softwareupdate -ia
	unset http_proxy 
	unset https_proxy 
}

pip_upgrade()
{
	figlet -c pip-upgrade
	python2 -m pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 proxychains4 -q python2 -m pip install -U --no-cache-dir
	python3 -m pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 proxychains4 -q python3 -m pip install -U --no-cache-dir
}

decode-apk()
{
	local fullPath=$@  
	local filePath=${fullPath%'.apk'}  
	baksmali="/Users/hasky/Documents/bin/baksmali-2.1.3.jar"

	echo 1.开始反编译 $fullPath  
	apktool -f d $fullPath
	# java -Xmx512M -Djava.awt.headless=true -jar apktool -f d -o "${filePath}" $@

	echo "\n"

	echo 2.解压出dex文件...  
	unzip  -o -d "${filePath}" "${fullPath}" '*.dex'

	echo "\n"

	echo 3.反编译dex为jar...  
	cd ${filePath}
	for i in ./*.dex
	do
		d2j-dex2jar $i -f -o ${i}.jar  
		java -jar $baksmali $i -o $i
	done

	open .
}

smbd-up()
{
	smbd-down 
	sudo /usr/local/bin/homebrew/Cellar/samba/3.6.25/sbin/smbd -D
	[[ $(echo $(pg smb | wc -l)) > 1 ]] && echo success || echo failed # echo去首位重复
}

c_jni_header()
{
	default_class_path="/usr/local/bin/homebrew/Cellar/android-sdk/24.4/extras/android/support/v7/appcompat/libs/android-support-v7-appcompat.jar:/usr/local/bin/homebrew/Cellar/android-sdk/24.4/extras/android/support/v4/android-support-v4.jar:/usr/local/bin/homebrew/Cellar/android-sdk/24.4/platforms/android-22/android.jar"
	javah -v -d jni -classpath $default_class_path:$1 $2
}

# listAllCommands()
# {
#     COMMANDS=`echo -n $PATH | xargs -d : -I {} find {} -maxdepth 1 \
	#         -executable -type f -printf '%P\n' 2>/dev/null`
#     ALIASES=`alias | cut -d '=' -f 1`
#     echo "$COMMANDS"$'\n'"$ALIASES" | sort -u
# }

# pacman autocomplete {{{
# peacefun()
# {
# 	cur=`_get_cword`
# 	COMPREPLY=( $( pacman -Sl | cut -d " " -f 2 | grep ^$cur 2> /dev/null ) )
# 	return 0
# }
# [[ $SHELL = "/usr/bin/bash" ]] && ( complete -F peacefun $filenames pi; complete -F peacefun $filenames i; complete -F peacefun $filenames s; complete -F peacefun $filenames p; complete -F peacefun $filenames r; )
# }}}

# remove dependencies for homebrew
# brew-rm() {
# 	brew rm $1
# 	brew rm $(join <(brew leaves) <(brew deps $1))
# 	brew clean 
# }

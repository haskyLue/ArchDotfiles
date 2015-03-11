# created by lu
# s for .bashrc

parse_string(){
	echo $1 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g' 
} # 处理字符串变量部分字符的转义 for sed

# cmd proxy {{{
proxyon(){
	export http_proxy="127.0.0.1:8087"
	export https_proxy=$http_proxy
	export ftp_proxy=$http_proxy
	export rsync_proxy=$http_proxy
	export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

	export HTTP_PROXY=$http_proxy
	export HTTPS_PROXY=$http_proxy
	export FTP_PROXY=$http_proxy
	export RSYNC_PROXY=$http_proxy
	export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
	export ALL_PROXY=$http_proxy
	echo -e "\nProxy environment variable set."
}
proxyoff(){
	unset HTTP_PROXY
	unset ALL_PROXY
	unset http_proxy
	unset HTTPS_PROXY
	unset https_proxy
	unset FTP_PROXY
	unset ftp_proxy
	unset RSYNC_PROXY
	unset rsync_proxy
	echo -e "\nProxy environment variable removed."
}
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

# {{{ bilibili 
# you-get 只用来下载弹幕,谁叫你老抽风呢

bili.download(){
	# niconvert(bili.ass1)/you-get(bili.ass2)下载处理弹幕,youtube-dl下载视频,mpv播放

	figlet -c bilibili-dw
	# _file=$(you-get -i $1 | awk -F':' '/Title/ {print $2}' | sed -e 's/^ *//' -e 's/ *$//')
	# _type=$(you-get -i $1 | awk -F'/' '/Type/ {print $2}' | tr -d ')')

	echo "\e[0;35m get video name from remote \e[0m" 
	_name_ext="$(youtube-dl --get-filename $1)"
	_name="$( basename $_name_ext .flv | xargs -I {} basename {} .mp4 )" # 视频文件名称

	# echo "\e[0;35m download file of danmu \e[0m" && bili.ass1 -o $_name $1
	echo "\e[0;35m download video \e[0m"			 && youtube-dl $1
	echo "\e[0;35m download file of danmu \e[0m" && bili.ass2 $1 $_name $_name_ext
	echo "\e[0;35m playing video \e[0m"				 && bili.play $_name_ext 
}
bili.ass1(){
	# 自动处理为ass文件 @niconvert // 只是弹幕行为比较单一
	niconvert="/Users/hasky/Documents/devel/git/niconvert/niconvert.pyw"
	echo " for cid mesg or some other parameters : open url -> jsconsole -> \$('#bofqi').attr('src') \n"
	$niconvert -B -G -V +l 0 +a async $1
}
bili.ass2(){
	# 转换xml弹幕 @danmaku2ass/you-get
	# you-get下载cmt.xml / danmuku2ass处理为ass,所需的参数由媒体文件提供

	if [[ $# -eq 3 && -f $3 ]] ;then 
		danmaku2assDir="/Users/hasky/Documents/devel/git/danmaku2ass"

		echo "\e[0;35m getting the name of xxx.cmt.xml ...\e[0m"
		_name=$( you-get -i $1 | awk -F':' '/Title/ {print $2}' | sed -e 's/^ *//' -e 's/ *$//' )
		url=$1
		name=$2 #真实的文件名(由youtube-dl下载的为准)
		name_ext=$3
		echo $name $name_ext 
		
		echo "\e[0;35m downloading xxx.cmt.xml...\e[0m" && you-get -u $url

		if [[ -e "$_name".cmt.xml ]];then # 判断xml弹幕文件是否下载完成
				local height=$(ffprobe  -v quiet -show_streams "$name_ext" | awk -F'=' '/height/ {print $2}')
				local width=$(ffprobe  -v quiet -show_streams "$name_ext" | awk -F'=' '/width/  {print $2}')
				$danmaku2assDir/danmaku2ass.py -o "$name".ass -fs 30 -dm 10 -s "$height"x"$width" "$_name".cmt.xml
		else
			echo "\e[0;34m no "$_name".cmt.xml file found"
		fi
	else
		echo -e "\e[0;33m provide the title and name of the media file \n or check the existence of the media file" 
	fi
}
bili.play(){
	name=$(echo $1 | grep -q .flv$ && basename -s .flv $1 || basename -s .mp4 $1) # 非flv即mp4
	mpv --geometry=50%:50% --autofit-larger=80% --sub-scale-with-window=yes --sub-file=$name.ass --vf='lavfi="fps=fps=60:round=down"' $1
}

bili.online(){
	cd /Users/hasky/Documents/devel/git/biligrab-danmaku2ass/ 

	local c="$( cat ./cookie )"
	./bilidan.py -c $c --hd $1
}
# }}}

#{{{ fuck gwf 
Upac(){
	gfwlist="https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt"
	userlist="https://raw.githubusercontent.com/clowwindy/gfwlist2pac/master/test/user_rule.txt"
	cd /Volumes/Caches/ && rm -f user_rule.* gfwlist.*
	proxyon;
	aria2c $gfwlist 
	aria2c $userlist && echo "" >> user_rule.txt

	gfwlist2pac -i gfwlist.txt -f /usr/local/var/www/proxy.pac -p 'SOCKS5 127.0.0.1:1080; PROXY 127.0.0.1:8087; DIRECT;' --user-rule user_rule.txt  
}
Ugoagent(){
	figlet -c GoAgent-Init
	cd /Users/hasky/Documents/devel/git/goagent
	git archive HEAD --format=zip > /Volumes/Caches/goagent-3.0.zip

	echo -e "\nextract goagent dir from git archive\n"
	cd /Volumes/Caches && sudo rm -rf ./goagent-3.0 && unzip ./goagent-3.0.zip -d goagent-3.0 && rm -f ./goagent-3.0.zip
	cd ./goagent-3.0/local && ln -sf ~/.proxy.user.ini proxy.user.ini

	echo -e "\ngenerate new fake cert for goagent\n"
	rm -f ./CA.crt 
	(sleep 5 && ps -jA | awk '/.*proxy.py$/ {print $2}' | head | xargs -I {} sudo kill -9 {})& # kill goagent to get CA.crt
	sudo ./proxy.py

	echo -e "\ninstall cert to root && firefox\n"
	sudo security delete-certificate -c GoAgent 
	sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "CA.crt"
	# for nss (mainly for firefox)
	certutil -D -n 'GoAgent - GoAgent' -d "/Users/hasky/Library/Application Support/Firefox/Profiles/1yijdi2a.default" 
	certutil -A -n 'GoAgent - GoAgent' -i "CA.crt" -t "CT,C,C" -d "/Users/hasky/Library/Application Support/Firefox/Profiles/1yijdi2a.default" 
	# reboot firefox

	echo -e "\nremove info log for performance\n"
	# sed 's/self.log.*INFO.*/pass/' proxy.py > proxy.py- && mv -f proxy.py- proxy.py && chmod +x proxy.py # 去掉正常的显示
	# ln -fs /Users/hasky/Documents/devel/git/gfwlist2pac/test/proxy.pac

	echo -e "\nstart!!!\n"
	sudo ./proxy.py
}
get_goagent_ip(){
	local location="/Users/hasky/Documents/devel/git/checkgoogleip"
	echo "running per an hour..."
	# local ip=`awk 'NR<15 {print $1}' ip_tmpok.txt | xargs | tr ' ' '|'` 
	# echo $ip | pbcopy ""  && echo -e "copied to clip\n$ip"
	while 1;do
		$location/checkip.py 
		echo -e "$location \n"
		cat $location/ip.txt && cp -fv $location/ip.txt /Volumes/Caches/
		sleep 18000
	done
	# vim +13 ~/.proxy.user.ini
}

netsh_hosts(){
	rm -f /Volumes/Caches/hosts.txt
	curl 'http://serve.netsh.org/pub/hosts.php?passcode=19735&gs=on&wk=on&twttr=on&fb=on&flkr=on&dpbx=on&odrv=on' -H 'Host: serve.netsh.org' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:34.0) Gecko/20100101 Firefox/34.0' -H 'Accept: */*' -H 'Accept-Language: zh-cn,en-us;q=0.7,en;q=0.3' --compressed -H 'X-Requested-With: XMLHttpRequest' -H 'Referer: http://serve.netsh.org/pub/gethosts.php' -H 'Cookie: hostspasscode=19735; Hm_lvt_e26a7cd6079c926259ded8f19369bf0b=1418651792; Hm_lpvt_e26a7cd6079c926259ded8f19369bf0b=1418651792' -H 'Connection: keep-alive' \
		> /Volumes/Caches/hosts.txt
}
Uhosts(){
	local secret="/Users/hasky/Documents/secret"
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
'

	local HOSTS_URL="https://raw.githubusercontent.com/txthinking/google-hosts/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/vokins/simpleu/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/Elegantid/Hosts/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/DingSoung/hosts/master/hosts"
	# 广告-------------
	# local HOSTS_URL="http://hosts.eladkarako.com/hosts.txt"

	figlet -c Uhost
	echo "\e[34m DOWNLOADING HOSTS\e[0m"
	proxyon;
	cd /Volumes/Caches/ && rm -f hosts.txt && aria2c --dir=/Volumes/Caches --out=hosts.txt $HOSTS_URL
	dos2unix hosts.txt
	# netsh_hosts # 注释HOSTS_URL rm -f 
	if [[ -e hosts.txt ]] ;then
		echo $hosts_append >> /Volumes/Caches/hosts.txt

		echo -e "\nFINISHING..."
		sudo -S cp -fv /Volumes/Caches/hosts.txt /etc/hosts < $secret
	fi

	# echo ""
	# grep -i "UPDATE" /etc/hosts
}
dnsmasq()
{
	arg=$1
	case $arg in
		start)
			echo "Starting dnsmasq..."
			sudo launchctl start homebrew.mxcl.dnsmasq
			;;
		stop)
			echo "Stopping dnsmasq..."
			sudo launchctl stop homebrew.mxcl.dnsmasq
			;;
		restart)
			dnsmasq stop
			dnsmasq start
			;;
		edit)
			vim /usr/local/etc/dnsmasq.conf
			;;
	esac
} 
shadowsocks()
{
	arg=$1
	dir="/Library/LaunchDaemons"
	case $arg in
		start)
			echo "Starting shadowsocks..."
			sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.plist
			sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
			;;
		stop)
			echo "Stopping shadowsocks..."
			sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.plist
			sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
			;;
		restart)
			echo -e "Starting shadowsocks...\n"
			sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.plist
			sudo launchctl unload $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
			echo "Stopping shadowsocks..."
			sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.plist
			sudo launchctl load $dir/homebrew.mxcl.shadowsocks-libev.tunnel.plist
			;;
		edit)
			sudo vim -o $dir/{homebrew.mxcl.shadowsocks-libev.plist,homebrew.mxcl.shadowsocks-libev.tunnel.plist}
			;;
	esac
} 
#}}}

# Udns()
# {
# 	local secret="/Users/hasky/Documents/secret"
# 	echo -e "nameserver 223.5.5.5 \nnameserver 223.6.6.6" > /tmp/resolv
# 	# echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /tmp/resolv
# 	/bin/cp -fv /etc/dnsmasq-resolv.conf /tmp/
# 	sudo -S cp -fv /tmp/resolv /etc/dnsmasq-resolv.conf < $secret
# 	cat /etc/dnsmasq-resolv.conf
# }

rename_mp3(){
	eyeD3 --rename '$artist - $title' $1 >> /Volumes/Caches/Music_rename_log
}

move_log()
{
	mount_point=/Volumes/Caches
	sudo -s
	[[ -L /var/log ]] && ( cd /var/log && pwd -P ) || ( sudo mv /var/log $mount_point/var_log && sudo ln -sf $mount_point/var_log /var/log ) 
}

Ugitdir(){
	local DIR="/Users/hasky/Documents/devel/git"
	for dir in $DIR/*
	do
		if [ -d $dir/.git ]; then
			echo "\e[34m remote pulling $dir...\e[0m "
			cd $dir
			git pull -v origin
		fi
	done
}
# reload_ath9k(){
# 	sudo modprobe -rv ath9k
# 	sleep 5
# 	sudo modprobe -fv ath9k
# }

calc() {
    echo "scale=3;$@" | bc -l
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

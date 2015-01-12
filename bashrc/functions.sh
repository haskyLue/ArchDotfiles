# created by lu
# s for .bashrc

parse_string(){
	echo $1 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g' 
} # 处理字符串变量部分字符的转义 for sed

# cmd proxy {{{
proxyon(){
	# export http_proxy="127.0.0.1:8087"
	# export ALL_PROXY="127.0.0.1:8087"
	export ALL_PROXY="socks://127.0.0.1:1080"
	# export https_proxy=$http_proxy
	# export ftp_proxy=$http_proxy
	# export rsync_proxy=$http_proxy
	# export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
	# export HTTP_PROXY="127.0.0.1:8087"
	# export HTTPS_PROXY=$http_proxy
	# export FTP_PROXY=$http_proxy
	# export RSYNC_PROXY=$http_proxy
	# export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
	echo -e "\nProxy environment variable set."
}
proxyoff(){
	# unset HTTP_PROXY
	unset ALL_PROXY
	# unset http_proxy
	# unset HTTPS_PROXY
	# unset https_proxy
	# unset FTP_PROXY
	# unset ftp_proxy
	# unset RSYNC_PROXY
	# unset rsync_proxy
	echo -e "\nProxy environment variable removed."
}
# }}}

# for awesome WM {{{
cwall(){
	/usr/bin/cp -f $1 /home/hasky/Downloads/Image/background.jpg
	echo "awesome.restart()"|awesome-client 2>> /dev/null
}
tawsome(){
	local RCPWD="/home/hasky/Documents/dotfiles"
	local CUR_RC="/home/hasky/.config/awesome/rc.lua"
	if file $CUR_RC | grep -o light >> /dev/null;then
		ln -sf $RCPWD/rc.lua $CUR_RC
	else 
		ln -sf $RCPWD/rc.light.lua $CUR_RC
	fi
	echo "awesome.restart()"|awesome-client 2>>/dev/null
}
# }}}


bili.download(){
	_file=$(you-get -i $1 | awk -F':' '/Title/ {print $2}' | sed -e 's/^ *//' -e 's/ *$//')
	_type=$(you-get -i $1 | awk -F'/' '/Type/ {print $2}' | tr -d ')')

	echo "download xml file of danmu" && you-get -u $1
	# echo "download videos" && you-get $1
	echo "download videos" && youtube-dl $1
	[[  $_type = 'x-flv' &&  -f $_file.mp4 ]] && mv $_file.mp4 $_file.flv #小处理

	[[  $_type = 'x-flv'  ]] && (bili.ass $_file.flv && bili.play $_file.flv) || (bili.ass $_file.mp4 && bili.play $_file.mp4) # 非flv即mp4
	

	# height=$(ffprobe  -v quiet -show_streams $_file.$_type | awk -F'=' '/height/ {print $2}')
	# width=$(ffprobe  -v quiet -show_streams $_file.$_type | awk -F'=' '/width/  {print $2}')
	# # echo -e "$danmaku2assDir/danmaku2ass.py -o $_file.ass -s "$height"x"$width" "$_file".cmt.xml"
	# $danmaku2assDir/danmaku2ass.py -o $_file.ass -s "$height"x"$width" "$_file".cmt.xml
    #
	# echo -e "mpv --geometry=70%x70%+50%+50% --sub-scale-with-window=yes --sub-file=$_file.ass $_file.$_type"
	# mpv --geometry=70%x70%+50%+50% --sub-scale-with-window=yes --sub-file=$_file.ass $_file.$_type --vf='lavfi="fps=fps=60:round=down"'
}
bili.ass(){
	danmaku2assDir="/Users/hasky/Documents/devel/git/danmaku2ass"
	name=$(echo $1 | grep -q .flv$ && basename -s .flv $1 || basename -s .mp4 $1) # 非flv即mp4
	local height=$(ffprobe  -v quiet -show_streams $1 | awk -F'=' '/height/ {print $2}')
	local width=$(ffprobe  -v quiet -show_streams $1 | awk -F'=' '/width/  {print $2}')
	$danmaku2assDir/danmaku2ass.py -o "$name".ass -fs 30 -dm 10 -s "$height"x"$width" "$name".cmt.xml
}
bili.play(){
	name=$(echo $1 | grep -q .flv$ && basename -s .flv $1 || basename -s .mp4 $1) # 非flv即mp4
	mpv --geometry=70%x70%+50%+50% --sub-scale-with-window=yes --sub-file=$name.ass --vf='lavfi="fps=fps=60:round=down"' $1
}

netsh_hosts(){
	rm -f /Volumes/Caches/hosts.txt
	curl 'http://serve.netsh.org/pub/hosts.php?passcode=19735&gs=on&wk=on&twttr=on&fb=on&flkr=on&dpbx=on&odrv=on' -H 'Host: serve.netsh.org' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:34.0) Gecko/20100101 Firefox/34.0' -H 'Accept: */*' -H 'Accept-Language: zh-cn,en-us;q=0.7,en;q=0.3' --compressed -H 'X-Requested-With: XMLHttpRequest' -H 'Referer: http://serve.netsh.org/pub/gethosts.php' -H 'Cookie: hostspasscode=19735; Hm_lvt_e26a7cd6079c926259ded8f19369bf0b=1418651792; Hm_lpvt_e26a7cd6079c926259ded8f19369bf0b=1418651792' -H 'Connection: keep-alive' \
		> /Volumes/Caches/hosts.txt
}

bilibili(){
	cd /Users/hasky/Documents/devel/git/biligrab-danmaku2ass/ 

	local c="$( cat ./cookie )"
	./bilidan.py -c $c --hd $1
}

Ugoagent(){
	cd /Users/hasky/Documents/devel/git/goagent
	# git reset --hard && git pull -fv
	git archive HEAD --format=zip > /Volumes/Caches/goagent-3.0.zip

	cd /Volumes/Caches && unzip ./goagent-3.0.zip -d goagent-3.0 
	cd - && sudo rm -rf ../goagent-3.0 && mv /Volumes/Caches/goagent-3.0 ../
	cd ../goagent-3.0/local && ln -sf ~/.proxy.user.ini proxy.user.ini
	# rm -f ./local/CA.crt
	# sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "CA.crt"

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

	# local HOSTS_URL="https://raw.githubusercontent.com/txthinking/google-hosts/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/vokins/simpleu/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/Elegantid/Hosts/master/hosts"
	# local HOSTS_URL="https://raw.githubusercontent.com/DingSoung/hosts/master/hosts"

	echo "\e[34m DOWNLOADING HOSTS\e[0m"
	# rm -f /tmp/hosts.txt && aria2c --dir=/tmp --out=hosts.txt $HOSTS_URL
	netsh_hosts
	echo $hosts_append >> /Volumes/Caches/hosts.txt

	echo -e "\nFINISHING..."
	sudo -S cp -fv /Volumes/Caches/hosts.txt /etc/hosts < $secret
	# echo ""
	# grep -i "UPDATE" /etc/hosts
}
# Udns()
# {
# 	local secret="/Users/hasky/Documents/secret"
# 	echo -e "nameserver 223.5.5.5 \nnameserver 223.6.6.6" > /tmp/resolv
# 	# echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /tmp/resolv
# 	/bin/cp -fv /etc/dnsmasq-resolv.conf /tmp/
# 	sudo -S cp -fv /tmp/resolv /etc/dnsmasq-resolv.conf < $secret
# 	cat /etc/dnsmasq-resolv.conf
# }
Ugitdir(){
	local DIR="/Users/hasky/Documents/devel/git"
	for dir in $DIR/*
	do
		if [ -d $dir ] || [ -L $dir ]; then
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

extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                   c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(gbkunzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}
calc() {
    echo "scale=3;$@" | bc -l
}

listAllCommands()
{
    COMMANDS=`echo -n $PATH | xargs -d : -I {} find {} -maxdepth 1 \
        -executable -type f -printf '%P\n' 2>/dev/null`
    ALIASES=`alias | cut -d '=' -f 1`
    echo "$COMMANDS"$'\n'"$ALIASES" | sort -u
}

# pacman autocomplete {{{
peacefun()
{
	cur=`_get_cword`
	COMPREPLY=( $( pacman -Sl | cut -d " " -f 2 | grep ^$cur 2> /dev/null ) )
	return 0
}
[[ $SHELL = "/usr/bin/bash" ]] && ( complete -F peacefun $filenames pi; complete -F peacefun $filenames i; complete -F peacefun $filenames s; complete -F peacefun $filenames p; complete -F peacefun $filenames r; )
# }}}

# remove dependencies for homebrew
# brew-rm() {
# 	brew rm $1
# 	brew rm $(join <(brew leaves) <(brew deps $1))
# 	brew clean 
# }

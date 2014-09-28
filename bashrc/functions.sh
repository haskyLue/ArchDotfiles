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
	export HTTP_PROXY="127.0.0.1:8087"
	export HTTPS_PROXY=$http_proxy
	export FTP_PROXY=$http_proxy
	export RSYNC_PROXY=$http_proxy
	export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
	echo -e "\nProxy environment variable set."
}
proxyoff(){
	unset HTTP_PROXY
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

Uhosts(){
	local secret="/home/hasky/Workspace/secret"
	# local HOSTS_URL="https://www.dropbox.com/sh/lw0ljk3sllmimpz/AAC-n6LmtWbdlKQRbdEa0QUoa/imouto.host.7z?dl=1"
	local HOSTS_URL="https://www.dropbox.com/sh/lw0ljk3sllmimpz/AADvmg0wxOXHAtLQ9WhPlvAva/imouto.host.txt?dl=1"

	echo "Downloading hosts package"
	# curl -#L -o /tmp/imouto.host.txt  $HOSTS_URL
	wget -vc -O /tmp/imouto.host.txt  $HOSTS_URL
	# 7z e -y /tmp/hosts.7z -o/tmp/

	echo "Finishing..."
	sudo -S cp -fv /tmp/imouto.host.txt /etc/hosts < $secret
	head -n2 /etc/hosts | tail -n1
}
Ugitdir(){
	local DIR="/home/hasky/Workspace/git"
	for dir in $DIR/*
	do
		if [ -d $dir ] || [ -L $dir ]; then
			echo "\e[34m UPDATING \e[0m $dir..."
			cd $dir
			git pull -v origin
		fi
	done
}
reload_ath9k(){
	sudo modprobe -rv ath9k
	sleep 5
	sudo modprobe -fv ath9k
}
kaoyan(){
	local target_time=1419609600
	local now_time=$(date +%s)
	let spare_time="($target_time-$now_time)/3600/24"
	echo -e "\e[5m距离考研还有 $spare_time (12.27)天\e[0m"
}

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
            *.Z)   c=(uncompress);;
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

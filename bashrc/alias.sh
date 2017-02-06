#! /bin/bash

# modified commands
alias diff='colordiff'              # requires colordiff package
alias df='df -h'
alias du='du -c -h -d 1'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'
alias ..='cd ..'
alias da='date "+%A, %B %d, %Y [%T]"'
alias pg='ps -axf | grep -i $1'         # requires an argument (note: /usr/bin/pg is installed by the util-linux package; maybe a different alias name should be used)
# alias top="top -i 2"
alias top="top -d -s 2 -u -F"
alias aria2c="aria2c --file-allocation none -x 5 -s 10 -c"
alias htop="sudo htop -d 20"
# alias pstree="pstree -ha"
alias grep="grep --color"
alias find="find ."
alias mdfind="mdfind -onlyin ."
# alias mpv="mpv --geometry=50%:50% --autofit-larger=80% --vf='lavfi=\"fps=fps=60:round=down\"' "
alias updatedb="sudo /usr/libexec/locate.updatedb"
alias reload_shell=". ~/.zshrc"
alias lsnetport="sudo lsof -i -n"
alias smbd-down="sudo pkill smbd"

# privileged access
if [ $UID -ne 0 ]; then
	alias scat='sudo cat'
	alias smount='sudo mount'
	alias sumount='sudo umount'
	alias svim='sudo vim'
	alias root='sudo -s'
	# alias reboot='sudo systemctl reboot'
	# alias poweroff='sudo systemctl poweroff'
	# alias netcfg='sudo netcfg2'
fi

# ls
alias ls='ls -hFG'
# alias l='ls -a'
alias lr='ls -R'                    # recursive ls
# alias ll='ls -l'
# alias la='ll -A'
# alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date


# pacman aliases
# alias pac="sudo powerpill -S"      # default action     - install one or more packages
# alias pacs="sudo pacman -Ss"    # '[s]earch'         - search for a package using one or more keywords
# alias paci="sudo pacman -Si"    # '[i]nfo'           - show information about a package
# alias pacr="sudo pacman -Rns"     # '[r]emove'         - uninstall one or more packages
# alias pacro="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rns \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"  # '[r]emove [o]rphans' - recursively remove ALL orphaned packages
# alias pacl="sudo pacman -Sl"    # '[l]ist'           - list all packages of a repository
# alias pacll="sudo pacman -Qq"  # '[l]ist [l]ocal'   - list all packages which were locally installed (e.g. AUR packages)
# alias paclo="pacman -Qdt"      # list orphaned package
# alias paco="sudo pacman -Qo"    # '[o]wner'          - determine which package owns a given file
# alias pacf="sudo pacman -Ql"    # '[f]iles'          - list all files installed by a given package
# alias pacc="sudo pacman -Scc"    # '[c]lean cache'    - delete all not currently installed package files
# alias update="figlet -c Package Update && yaourt --insecure -Syyua "
# alias pacm="makepkg -fci --syncdeps --rmdeps"  # '[m]ake'           - make package from PKGBUILD file in current directory
# alias yt="yaourt --insecure"

# somemore
# alias offwifi="curl 'http://admin:admin@192.168.1.1/userRpm/StatusRpm.htm?Disconnect=%B6%CF%20%CF%DF&wan=1' >> /dev/null; wicd-cli -xy"
# alias offwifi="wicd-cli -xy;rm -f /tmp/externalip"
# alias onwifi="if wicd-cli -y -d | grep Invalid > /dev/null;then wicd-cli -cy -n 0;curl 'http://admin:admin@192.168.1.1/userRpm/StatusRpm.htm?Connect=%C1%AC%20%BD%D3&wan=1' >> /dev/null; fi"
# alias onwifi="sudo ip link set wlp3s0 up ; wicd-cli -ycn `wicd-cli -yl | awk '/MERCURY/ {print $1}'`"
# alias offwifi="sudo netctl stop-all ; rm -f /tmp/externalip"
# alias onwifi="sudo netctl start wlp3s0-MERCURY_C1D49C"
# alias pon="sudo route del default && sudo pon"
# alias pon="sudo ip link set enp7s0f5 up && sudo pon" 
# alias poff="sudo poff -a"
# alias Tps="figlet -c On/Off TouchPad && sh /home/hasky/Documents/script/dotfiles/toggle_psmouse.sh" # 切换触控板
# alias Mwin7="sudo mkdir -p /mnt/win7 ;sudo mount /dev/sdb1 /mnt/win7" #
# alias Umwin7="sudo mkdir -p /mnt/win7 ;sudo umount /dev/sdb1" #
# alias elang="export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8"
# alias subl="LD_PRELOAD=/usr/lib/libsublime-imfix.so subl3" #加到local/bin了


# adjust volume
# alias Su="amixer set Master 5+"
# alias Sd="amixer set Master 5-"
# alias Smute="amixer set Master mute"
# alias Sunmute="amixer set Master unmute"

# start app 
# alias rename_mp3_dir="find . -iname '*mp3' -exec eyeD3 --rename '$artist - $title' {} >> /Volumes/Caches/Music_rename_log \;"
# alias fssh="ssh -TnN -D 7070 fastssh.com-ldb1992@jp-public.serverip.co"
# alias dns="/Users/hasky/Documents/devel/git/ArchDotfiles/chinadns/exec" 
# alias goagent="figlet -c goagent && sudo python /Volumes/Caches/goagent-3.0/local/proxy.py"
# alias trash="sudo gvfs-trash"
alias youdao="figlet -c YouDaoDict && /Users/hasky/Documents/devel/git/ydcv/ydcv.py -f"
# alias wifi="wicd-curses"
# alias gmail="checkgmail -numbers -private -no_cookies &"
# alias vmxp="vboxmanage startvm xp "
alias youtube-dl-proxy="youtube-dl --proxy socks5://127.0.0.1:1080 --no-check-certificate --write-auto-sub --audio-quality 0 --no-playlist -o '%(title)s.%(ext)s'"
alias iftop="sudo iftop -PnB"
alias glances="sudo glances --full-quicklook --disable-load"
# alias tshark="sudo tshark"
# alias winfo="watch -n 2 --no-title --color ~/Documents/devel/git/ArchDotfiles/script/getinfo.sh"
# alias bilibili="~/Documents/devel/git/ArchDotfiles/script/bilibili.sh"
# alias cmatrix="cmatrix -C green"
# tmux will always set TERM=screen inside, -2 and TERM=xterm-256color outside only tell tmux that it can output 256 colours if needed.You need to set -g default-terminal screen-256color
alias tm="tmux -2 "
alias tmas="tmux -2 -u attach-session"
# alias Udate="sudo ntpdate 3.cn.pool.ntp.org ; date |xargs -I {} sudo hwclock --set --date={}"
# alias subl="reattach-to-user-namespace /usr/local/bin/subl"
alias add_space_to_docker="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}"
alias ctags="ctags -R --c++-kinds=+px --fields=+aiKSz --extra=+q"
alias clean="sudo rm -rf /var/log/* ; sudo rm -rf /Library/Logs ; rm -rf ~/Library/Logs ; rm -rf /Library/Caches/Homebrew "
alias goagent="sudo /Users/hasky/Documents/devel/git/goagent/local/proxy.py"
alias andbug="cd /Users/hasky/Documents/devel/git/AndBug/ && PYTHONPATH=lib ./andbug"
# alias ncmpcpp="proxychains4 /usr/local/bin/ncmpcpp"
alias ndk-build="/usr/local/bin/homebrew/Cellar/android-sdk/24.4/ndk-bundle/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=Android.mk"


# enter directory & edit
alias Cd="cd /Users/hasky/Documents/devel/git/ArchDotfiles"
# alias Cg="cd /Users/hasky/Documents/devel/git"
alias Cw="cd /Volumes/WD320"
# alias Ca="cd /Users/hasky/Documents/devel/alfred.workflows.dev"
# alias Ci="cd /home/hasky/Downloads/Image && pcmanfm"
# alias Vgo="vim ~/.proxy.user.ini"
# alias Vt="vim ~/.tmux.conf"
# alias Vtask="vim ~/Documents/task.md"
# alias Vrss="vim ~/.newsbeuter/urls"
alias Valias="vim ~/Documents/devel/git/ArchDotfiles/bashrc/alias.sh"
alias Vfunctions="vim ~/Documents/devel/git/ArchDotfiles/bashrc/functions.sh"

alias jeb="/opt/JEB/jeb_macos.sh"
alias jadx="/opt/jadx-0.6.0/bin/jadx-gui"

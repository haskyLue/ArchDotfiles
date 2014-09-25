#------------------------
#	alias for .bashrc
#------------------------
# modified commands
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'
alias ..='cd ..'
alias da='date "+%A, %B %d, %Y [%T]"'
alias pg='ps -Af | grep $1'         # requires an argument (note: /usr/bin/pg is installed by the util-linux package; maybe a different alias name should be used)

# privileged access
if [ $UID -ne 0 ]; then
	alias scat='sudo cat'
	alias smount='sudo mount'
	alias sumount='sudo umount'
	alias svim='sudo vim'
	alias root='sudo su'
	alias reboot='sudo systemctl reboot'
	alias poweroff='sudo systemctl poweroff'
	alias netcfg='sudo netcfg2'
	alias htop='sudo htop'
	alias atop='sudo atop 3'
fi

# ls
alias ls='ls -hF --color=auto'
alias l='ls -a'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I --preserve-root'                    # 'rm -i' prompts for every file
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'

# pacman aliases
alias pac="sudo pacman -S"      # default action     - install one or more packages
alias pacs="sudo pacman -Ss"    # '[s]earch'         - search for a package using one or more keywords
alias paci="sudo pacman -Si"    # '[i]nfo'           - show information about a package
alias pacr="sudo pacman -Rns"     # '[r]emove'         - uninstall one or more packages
alias pacro="/usr/bin/pacman -Qtdq > /dev/null && sudo /usr/bin/pacman -Rns \$(/usr/bin/pacman -Qtdq | sed -e ':a;N;\$!ba;s/\n/ /g')"  # '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pacl="sudo pacman -Sl"    # '[l]ist'           - list all packages of a repository
alias pacll="sudo pacman -Qq"  # '[l]ist [l]ocal'   - list all packages which were locally installed (e.g. AUR packages)
alias paclo="pacman -Qdt"      # list orphaned package
alias paco="sudo pacman -Qo"    # '[o]wner'          - determine which package owns a given file
alias pacf="sudo pacman -Ql"    # '[f]iles'          - list all files installed by a given package
alias pacc="sudo pacman -Sc"    # '[c]lean cache'    - delete all not currently installed package files
alias update="figlet -c Package Update && yaourt --insecure -Syyua "
alias pacm="makepkg -fci"  # '[m]ake'           - make package from PKGBUILD file in current directory
alias yt="yaourt --insecure"

# somemore
# alias offwifi="curl 'http://admin:admin@192.168.1.1/userRpm/StatusRpm.htm?Disconnect=%B6%CF%20%CF%DF&wan=1' >> /dev/null; wicd-cli -xy"
alias offwifi="wicd-cli -xy"
# alias onwifi="if wicd-cli -y -d | grep Invalid > /dev/null;then wicd-cli -cy -n 0;curl 'http://admin:admin@192.168.1.1/userRpm/StatusRpm.htm?Connect=%C1%AC%20%BD%D3&wan=1' >> /dev/null; fi"
alias onwifi="sudo ip link set wlp3s0 up ; wicd-cli -ycn `wicd-cli -yl | awk '/MERCURY/ {print $1}'`"
alias Tps="figlet -c On/Off TouchPad && sh /home/hasky/Documents/script/dotfiles/toggle_psmouse.sh" # 切换触控板
alias Mwin7="sudo mkdir -p /mnt/win7 ;sudo mount /dev/sdb1 /mnt/win7" #
alias Umwin7="sudo mkdir -p /mnt/win7 ;sudo umount /dev/sdb1" #
alias elang="export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8"
# alias subl="LD_PRELOAD=/usr/lib/libsublime-imfix.so subl3" #加到local/bin了

# adjust volume
alias Su="amixer set Master 5+"
alias Sd="amixer set Master 5-"
alias Smute="amixer set Master mute"
alias Sunmute="amixer set Master unmute"

# start app 
alias goagent="figlet -c goagent && sudo python2 /home/hasky/Workspace/git/goagent/local/proxy.py"
# alias goagent="figlet -c goagent && sudo /usr/share/goagent/local/goagent"
alias goagent-update="/home/hasky/Documents/dotfiles/script/goagent_update.sh"
alias trash="sudo gvfs-trash"
alias youdao="ydcv -f"
# alias wifi="wicd-curses"
alias lampp="figlet -c Lampp Server && sudo /opt/lampp/xampp"
alias gmail="checkgmail -numbers -private -no_cookies &"
alias news="newsbeuter -X;newsbeuter -r  2>> /dev/null"
alias vmxp="vboxmanage startvm xp "
alias yt-dl="youtube-dl --no-check-certificate --write-auto-sub --audio-quality 0"
alias iftop="sudo iftop -PnB"
alias pon="sudo ip link set enp7s0f5 up;sudo pon" 
alias poff="sudo poff -a"
alias tshark="sudo tshark"
alias winfo="echo ldb | sudo -S watch --no-title --color /home/hasky/Documents/dotfiles/script/getinfo.sh"
alias bilibili="/home/hasky/Documents/dotfiles/script/bilibili.sh"
# tmux will always set TERM=screen inside, -2 and TERM=xterm-256color outside only tell tmux that it can output 256 colours if needed.You need to set -g default-terminal screen-256color
alias tm="TERM=xterm-256color tmux -2"
alias tmas="TERM=xterm-256color tmux -2 attach-session"
# alias Udate="sudo ntpdate 3.cn.pool.ntp.org ; date |xargs -I {} sudo hwclock --set --date={}"

# enter directory & edit
alias Cd="cd /home/hasky/Documents/dotfiles&&l"
alias Ci="cd /home/hasky/Downloads/Image && pcmanfm"
alias Cn="cd /home/hasky/Documents/note&&ll"
alias Ca="cd /home/hasky/.config/awesome/&&ll"
alias Cz="cd /home/hasky/.oh-my-zsh"
alias Vgo="vim /home/hasky/Workspace/git/goagent/local/proxy.user.ini"
alias Vtpl="vim /home/hasky/Workspace/git/tmux-powerline/themes/default.sh"
alias Vt="vim /home/hasky/.tmux.conf"
alias Vtask="vim /home/hasky/Documents/task.md"
alias Vrss="vim /home/hasky/.newsbeuter/urls"
alias Valias="vim /run/media/storage/Documents/dotfiles/bashrc/alias.sh"
alias Vfunctions="vim /run/media/storage/Documents/dotfiles/bashrc/functions.sh"

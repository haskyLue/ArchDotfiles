#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f 
fi

# 以gstreamer后端的播放器mp3 tag编码
export GST_ID3_TAG_ENCODING=GBK:UTF-8:GB18030
export GST_ID3V2_TAG_ENCODING=GBK:UTF-8:GB18030

# X单独设置语言
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_CTYPE=en_US.UTF-8

# fcitx 变量
export XIM="fcitx"
export XIM_PROGRAM="fcitx"
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"

export BROWSER="chromium"
# export CHROMIUM_USER_FLAGS="--disk-cache-dir=/tmp --disk-cache-size=50000000"
export EDITOR="vim"

# for bcloud
( eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh) && export GPG_AGENT_INFO SSH_AUTH_SOCK )&

# export GDK_BACKEND=wayland
# export vblank_mode=0
export GDK_USE_XFT=1
export QT_XFT=true

# 启动应用程序
compton&
mpd& 
mpdscribble&
fcitx&
libreoffice --quickstart&
# shutter --min_at_startup&
xflux -l 32.054829 -g 118.795193&
# stardict -h&
pcmanfm -d&
parcellite&
xfce4-power-manager&
# profile-sync-daemon&
# urxvtd -q -f -o&
# wicd-gtk -t&

xmodmap ~/.Xmodmap 
# xrdb -merge .Xdefaults

rm ~/.xsession-errors* && ln -s /dev/null ~/.xsession-errors

# 启动WM/DE 
# echo "" > ~/.cache/awesome/stderr > ~/.cache/awesome/stdout; exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
exec awesome 
# exec unity 

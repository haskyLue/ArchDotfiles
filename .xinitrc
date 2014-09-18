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
export EDITOR="vim"

# export GDK_BACKEND=wayland


# export vblank_mode=0

# 启动应用程序
compton&
# urxvtd -q -f -o&
mpd&
mpdscribble&
fcitx&
wicd-gtk -t&
libreoffice --quickstart&
shutter --min_at_startup&
xflux -l 32.054829 -g 118.795193&
stardict -h&
pcmanfm -d&
volti&

(xmodmap ~/.Xmodmap ) && (xrdb -merge .Xdefaults )

# 启动WM/DE 
# echo "" > ~/.cache/awesome/stderr > ~/.cache/awesome/stdout; exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
exec awesome 

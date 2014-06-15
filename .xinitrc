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
(fcitx &)

export BROWSER="google-chrome-beta"
export EDITOR="vim"

# 启动应用程序(已写入rc.lua) system tray icon
(wicd-gtk -t &) 
# (stardict -h &)
# (xflux -l 32.054829 -g 118.795193 &)
# (compton -bC &)
(urxvtd -q -f -o  &) 
# 重新生效keymap,urxvt配置
(xmodmap ~/.Xmodmap &) && (xrdb -merge .Xdefaults &)

# 启动WM/DE 
# exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
# exec startxfce4 
exec /usr/bin/awesome 


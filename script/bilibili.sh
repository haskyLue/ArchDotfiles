#! /bin/bash

DIR=/home/hasky/Workspace/git/biligrab-danmaku2ass
URL=$( xsel -o )
COOKIE="-c '$( cat $DIR/cookie )'"
D2AFLAGS="--danmaku2assflags 'font_size=28'"

EXECUTE="python $DIR/bilidan.py --hd $URL $COOKIE $D2AFLAGS"
notify-send "正在播放 $URL"
terminator  --geometry=1000x400+150+150 -e "$EXECUTE"

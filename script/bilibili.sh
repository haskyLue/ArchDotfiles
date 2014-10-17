#! /bin/bash

DIR=/home/hasky/Workspace/git/biligrab-danmaku2ass
URL=$( xsel -o )
COOKIE="-c '$( cat $DIR/cookie )'"
D2AFLAGS="--danmaku2assflags 'font_size=29,comment_duration=6.0,is_reduce_comments=True'"

EXECUTE="python $DIR/bilidan.py --hd $URL $COOKIE $D2AFLAGS"
notify-send "正在播放 $URL"
echo $EXECUTE
terminator  --geometry=1000x400+150+150 -e "$EXECUTE"

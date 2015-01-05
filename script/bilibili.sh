#! /bin/bash

DIR="~/Documents/devel/git/biligrab-danmaku2ass"
URL=$( xsel -o )
COOKIE="--cookie '$( cat $DIR/cookie )'"
# D2AFLAGS="--d2aflags 'font_size=28,comment_duration=6.0'"
D2AFLAGS="--d2aflags 'text_opacity=1'"

EXECUTE="python $DIR/bilidan.py --hd $URL $COOKIE $D2AFLAGS"
notify-send "正在播放 $URL"
echo $EXECUTE
terminator  --geometry=1000x400+150+150 -e "$EXECUTE"

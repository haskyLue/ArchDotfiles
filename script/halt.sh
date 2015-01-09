#! /bin/bash

#restore caches
rm -f ~/Library/Caches/{Google,com.apple.Safari,Firefox}
mv /tmp/Caches/Google ~/Library/Caches/Google
mv /tmp/Caches/Firefox ~/Library/Caches/Firefox
mv /tmp/Caches/com.apple.Safari ~/Library/Caches/com.apple.Safari


sudo shutdown -h now

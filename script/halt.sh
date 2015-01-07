#! /bin/bash

#restore caches
rm -f ~/Library/Caches/Google ~/Library/Caches/com.apple.Safari  
mv /tmp/Caches/Google ~/Library/Caches/Google
mv /tmp/Caches/com.apple.Safari ~/Library/Caches/com.apple.Safari


sudo halt

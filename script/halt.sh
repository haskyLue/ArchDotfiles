#! /bin/bash

#restore caches
rm -f ~/Library/Caches/Google ~/Library/Caches/com.apple.Safari  
mv /tmp/Caches/* ~/Library/Caches/

sudo halt

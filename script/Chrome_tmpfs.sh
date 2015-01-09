#! /bin/bash
if [ ! -d /tmp/Caches/Google ] ;then
	mkdir -p /tmp/Caches

	mv ~/Library/Caches/Google /tmp/Caches/
	ln -sf /tmp/Caches/Google ~/Library/Caches/Google

	mv ~/Library/Caches/com.apple.Safari /tmp/Caches/
	ln -sf /tmp/Caches/com.apple.Safari ~/Library/Caches/com.apple.Safari

	mv ~/Library/Caches/Firefox /tmp/Caches/
	ln -sf /tmp/Caches/Firefox ~/Library/Caches/Firefox
fi

if [[ $# -ne 0 ]] ; then
	cd $1
	[[ ! -s /tmp/music_uniq ]] && find . -type f -print0 | xargs -0 md5sum | sort -k 34 > /tmp/music_uniq
	cat /tmp/music_uniq | uniq -w 33 -d  | grep -io '\..*$' | sort | xargs  -I{} mv {} /tmp/
else 
	echo sh ./uniq.mp3.sh {MusicDir}
fi

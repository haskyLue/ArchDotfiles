TMUX_CACHE_DIR=$([[ -e /Volumes/Toshiba/TMP/ ]] && echo "/Volumes/Toshiba/TMP" ||  echo "/tmp")
cat $TMUX_CACHE_DIR/tmux_output

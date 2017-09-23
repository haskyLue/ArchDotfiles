#!/bin/bash

export TMUX_WORKING_DIR="/Users/hasky/Documents/.dotFile/script/tmux_statusbar_server"
source $TMUX_WORKING_DIR/doInit.sh

ps -axf | grep -qi "[s]erver.sh" || sh $TMUX_WORKING_DIR/server.sh& #[trick] 避免ps匹配到自身
cat $TMUX_OUTPUT

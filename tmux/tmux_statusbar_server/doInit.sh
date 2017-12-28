#!/bin/bash

# global
export TMUX_CACHE_DIR="/tmp"
export TMUX_OUTPUT=$TMUX_CACHE_DIR"/tmux_output"

# color
export TMUX_CONTENT="TMUX"
export TMUX_COLOR_TMPL="#[fg=black]#[bg=colour237]#[bg=colour237]#[fg=COLOR,none] ${TMUX_CONTENT} #[fg=colour237]#[bg=default]"
export TMUX_GREEN=${TMUX_COLOR_TMPL/COLOR/GREEN}
export TMUX_BLUE=${TMUX_COLOR_TMPL/COLOR/BLUE}
export TMUX_RED=${TMUX_COLOR_TMPL/COLOR/RED}
export TMUX_MAGENTA=${TMUX_COLOR_TMPL/COLOR/MAGENTA}
export TMUX_CYAN=${TMUX_COLOR_TMPL/COLOR/CYAN}
export TMUX_YELLOW=${TMUX_COLOR_TMPL/COLOR/YELLOW}

# network 
export TMUX_RX_NEW=0
export TMUX_TX_NEW=0
export TMUX_TIMESTAMP_NEW=1000
export TMUX_RX_OLD=0
export TMUX_TX_OLD=0
export TMUX_TIMESTAMP_OLD=0
export TMUX_RATE=0

# devices
export KERNEL
export NET_INTERFACE

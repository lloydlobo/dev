#!/usr/bin/env bash

# For each directory:
# 1 is neovim
# 2 is to run commands

if [[ "$(pwd)" == $HOME/Personal ]]; then
	clear;
	return;
fi

tmux new-window -dn scratch;
nvim .;
clear;

# Sources:
#	- https://github.com/ThePrimeagen/dev/blob/master/env/.tmux-sessionizer

#!/usr/bin/env bash

# Source https://github.com/ThePrimeagen/tmux-sessionizer/tree/6ebd16e2e30a8c0ebd77f0c2ce18cb46db8397fa

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

has_session() {
    tmux list-sessions | grep -q "^$1:"
}

# Run .tmux-sessionizer.sh like direnv
hydrate() {
    if [ -f $2/.tmux-sessionizer.sh ]; then
        tmux send-keys -t $1 "source $2/.tmux-sessionizer.sh" c-M
    elif [ -f $HOME/.tmux-sessionizer.sh ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessionizer.sh" c-M
        # else
        #     echo "WHY YOU NO RUN.....";
        #     exit 1;
    fi
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ ~/.local/apps/ ~/Projects ~/Personal ~/Personal/dev/env/.config -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    hydrate $selected_name $selected
    exit 0
fi

if ! has_session $selected_name; then
    tmux new-session -ds $selected_name -c $selected
    hydrate $selected_name $selected
fi

switch_to $selected_name

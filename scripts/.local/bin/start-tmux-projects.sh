#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Script to start tmux session for projects
# adapted from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

PROJECT_PATH=$HOME/documents/projects/

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(find "$PROJECT_PATH" -mindepth 1 -maxdepth 2 -type d | fzf)
fi

# Exit if nothing found
if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

function create_windows {
  if [[ $selected_name == "pcb" ]]; then
    conda_env="pcb"
    window=0
    tmux rename-window -t $selected_name:$window "vim"
    tmux send-keys -t $selected_name:$window "conda activate $conda_env" C-m
    tmux send-keys -t $selected_name:$window "vim" C-m
    window=1
    tmux new-window -t $selected_name:$window -n "cmd" -c $selected
    tmux send-keys -t $selected_name:$window "conda activate $conda_env" C-m
  else
    window=0
    tmux send-keys -t $selected_name:$window "vim" C-m
    window=1
    tmux new-window -t $selected_name:$window -c $selected
  fi
}

# If not in tmux and no session running, start
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -ds $selected_name -c $selected
  create_windows
  tmux attach-session -t $selected_name:0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
  tmux new-session -ds $selected_name -c $selected
  create_windows
  tmux switch-client -t $selected_name:0
fi

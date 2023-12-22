#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Script to start tmux session for paths
# adapted from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

# Personal project directory
PROJECT_PATH="$HOME"/projects

# Select project name
if [[ $# -eq 1 ]]; then
  name=$1
  path="$PROJECT_PATH/$name"
else
  path=$(find "$PROJECT_PATH" -mindepth 1 -maxdepth 2 -type d | fzf)
  # Trim full path to path name
  name=$(basename "$path" | tr . _)
fi

# Exit if nothing found
if [[ -z "$name" ]]; then
  exit 0
fi

# Use simpler project names
if [[ "$name" == "ptx-ds-Auto-fwd-curve" ]]; then
  name="pcb"
elif [[ "$name" == "pcb" ]]; then
  path="$PROJECT_PATH"/fwd-curve-modeling/ptx-ds-Auto-fwd-curve
fi

# Function to create tmux windows for given project name
create_windows () {
  if [[ "$name" == "pcb" ]]; then
    conda_env="pcb"

    window=1
    # window 0 is always created with the session
    tmux rename-window -t $window "cmd1" 
    tmux send-keys -t $window "cd $path" C-m  
    tmux send-keys -t $window "conda activate $conda_env" C-m C-l

    window=2
    tmux new-window -d -t $window -n "cmd2" 
    tmux send-keys -t $window "cd $path" C-m  
    tmux send-keys -t $window "conda activate $conda_env" C-m C-l

    window=3
    tmux new-window -d -t $window -n "vim" 
    tmux send-keys -t $window "cd $path" C-m
    tmux send-keys -t $window "conda activate $conda_env" C-m C-l
    tmux send-keys -t $window "vim" C-m

    window=4
    tmux new-window -d -t $window -n "jupyter" 
    tmux send-keys -t $window "cd $path" C-m
    tmux send-keys -t $window "conda activate $conda_env" C-m C-l
    tmux send-keys -t $window "jupyter lab --no-browser" C-m

  else
    window=1
    # the first window is always created with the session
    tmux rename-window -t $window "cmd1" 
    tmux send-keys -t $window "cd $path" C-m C-l

    window=2
    tmux new-window -d -t $window -n "vim" 
    tmux send-keys -t $window "cd $path" C-m C-l  
    tmux send-keys -t $window "vim" C-m 
  fi
}

# If not in tmux and no session running, start
if ! tmux has-session -t "$name" 2>/dev/null; then
  tmux new-session -d -s "$name"
  create_windows
fi
tmux attach-session -t "$name"


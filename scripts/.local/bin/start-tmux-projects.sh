#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Script to start tmux session for paths
# adapted from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

# Personal project directory
PROJECT_PATH="$HOME"/documents/projects

# Check if tmux is running
tmux_running=$(pgrep tmux)

# Select project name
if [[ $# -eq 1 ]]; then
  name=$1
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
if [[ $name == "ptx-ds-Auto-fwd-curve" ]]; then
  name="pcb"
fi
if [[ $name == "pcb" ]]; then
  path="$PROJECT_PATH"/fwd-curve-modeling/ptx-ds-Auto-fwd-curve
fi

# Function to create tmux windows for given project name
function create_windows {
  if [[ $name == "pcb" ]]; then
    conda_env="pcb"

    window=0
    # window 0 is always created with the session
    tmux rename-window -t $window "cmd" 
    tmux send-keys -t $window "cd $path" C-m  
    tmux send-keys -t $window "conda activate $conda_env" C-m C-l

    window=1
    tmux new-window -d -t $window -n "vim" 
    tmux send-keys -t $window "cd $path" C-m
    tmux send-keys -t $window "conda activate $conda_env" C-m C-l
    tmux send-keys -t $window "vim" C-m

    window=2
    tmux new-window -d -t $window -n "jupyter" 
    tmux send-keys -t $window "cd $path" C-m
    tmux send-keys -t $window "conda activate $conda_env" C-m C-l
    tmux send-keys -t $window "jupyter lab --no-browser" C-m

  else
    window=0
    # window 0 is always created with the session
    tmux rename-window -t $window "cmd" 

    window=1
    tmux new-window -d -t $window -n "vim" 
    tmux send-keys -t $window "vim" C-m C-l
  fi
}

# If not in tmux and no session running, start
tmux new-session -d -s $name 
create_windows
tmux attach-session -t $name


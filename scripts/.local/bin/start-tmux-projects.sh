#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Script to start tmux session for paths
# adapted from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

# Personal project directory
PROJECT_PATH="$HOME"/Dev/projects

# Select project name
if [[ $# -eq 1 ]]; then
  name=$1
  path="$PROJECT_PATH/$name"
else
  path=$(find "$PROJECT_PATH" -mindepth 1 -maxdepth 1 -type d | fzf)
  # Trim full path to path name
  name=$(basename "$path" | tr . _)
fi

# Exit if nothing found
if [[ -z "$name" ]]; then
  exit 0
fi

# Function to create tmux windows for given project name
create_windows () {
  window=1
  # the first window is always created with the session
  tmux rename-window -t $window "nvim" 
  tmux send-keys -t $window "cd $path" C-m C-l  
  tmux send-keys -t $window "nvim" C-m 

  window=2
  tmux new-window -d -t $window -n "cmd" 
  tmux send-keys -t $window "cd $path" C-m C-l
}

# If not in tmux and no session running, start
if ! tmux has-session -t "$name" 2>/dev/null; then
  tmux new-session -d -s "$name"
  create_windows
fi
tmux attach-session -t "$name"


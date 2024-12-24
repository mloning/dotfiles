#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Script to start tmux sessions for projects using fzf to filter directories 
# adapted from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

# Personal project directory
DEFAULT_ROOT_PATH="$HOME"/Dev/projects
ROOT_PATH="${TMUX_SESSIONIZER_ROOT_PATH:-$DEFAULT_ROOT_PATH}"

# Select project path and name, from input name or from project paths using fzf
if [[ $# -eq 1 ]]; then
  name="$1"
  path="$ROOT_PATH/$name"
else
  path=$(find "$ROOT_PATH" -mindepth 1 -maxdepth 1 -type d | fzf)
  # Trim full path to name
  name=$(basename "$path" | tr . _)
fi

# If no path is selected, exit
if [[ -z "$path" ]]; then
  exit 0
fi

is_conda_env_available () {
  conda env list | grep "^$1\s"
}

# Function to create tmux windows for given project name
create_windows () {
  # launch vim in first window
  # the first window is created when the session is created, so we rename it 
  local window=1
  local target="$name:$window"
  tmux rename-window -t "$target" "vim" 
  if is_conda_env_available "$name"; then
    tmux send-keys -t "$target" "conda activate $name" C-m C-l
  fi
  tmux send-keys -t "$target" "cd $path" C-m C-l  
  tmux send-keys -t "$target" "vim" C-m 

  
  # launch shell in second window
  local window=2
  local target="$name:$window"
  tmux new-window -d -t "$target" -n "cmd" 
  if is_conda_env_available "$name"; then
    tmux send-keys -t "$target" "conda activate $name" C-m C-l
  fi
  tmux send-keys -t "$target" "cd $path" C-m C-l

  # select second window as initial window
  tmux select-window -t "$target"
}


# check if tmux is running, gives non-zero exit code if not, otherwise process ID
is_tmux_running=$(pgrep tmux || true)
is_tmux_session="${TMUX:-}"

# if not in tmux and tmux is not running, create and attach to new session; 
# otherwise, assume tmux is running
if [[ -z "$is_tmux_running" ]] && [[ -z "$is_tmux_session" ]]; then
  tmux new-session -s "$name" -c "$path" -d
  create_windows
  tmux attach-session -t "$name"
fi

# if in tmux and current session is already selected name, exit
current_session=$(tmux display-message -p '#S')
if [[ -n "$is_tmux_session" ]] && [[ "$current_session" == "$name" ]]; then
  exit 0
fi

# if the session does not exists, create a new detached session 
if ! tmux has-session -t "$name" 2> /dev/null; then
  tmux new-session -s "$name" -c "$path" -d
  create_windows
fi

# when outside tmux, attach session; otherwise switch client
if [[ -z "$is_tmux_session" ]]; then
  tmux attach-session -t "$name"
else
  tmux switch-client -t "$name"
fi

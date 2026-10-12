#!/bin/bash
set -Eeuo pipefail
IFS=$'\n\t'

# Script to start tmux sessions for projects using fzf to filter directories
# adapted from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

# Name the failing command, since tmux errors like "open terminal failed: not a
# terminal" don't say where they come from
trap 'echo "tmux-sessionizer: command failed (exit $?): $BASH_COMMAND" >&2' ERR

# Personal project directory
DEFAULT_ROOT_PATH="$HOME"/Dev/projects
ROOT_PATH="${TMUX_SESSIONIZER_ROOT_PATH:-$DEFAULT_ROOT_PATH}"

# Coding agent launched in the second window of every session
DEFAULT_AGENT="claude"
AGENT="${TMUX_SESSIONIZER_AGENT:-$DEFAULT_AGENT}"

# Fail early rather than creating a session without the agent
if ! command -v "$AGENT" > /dev/null; then
  echo "tmux-sessionizer: agent '$AGENT' not found on PATH" >&2
  echo "set TMUX_SESSIONIZER_AGENT to an available command" >&2
  exit 1
fi

# Select project path and name, from input name or from project paths using fzf
if [[ $# -eq 1 ]]; then
  name="$1"
  path="$ROOT_PATH/$name"
else
  # fzf exits non-zero when cancelled, handled by the empty path check below
  path=$(find "$ROOT_PATH" -mindepth 1 -maxdepth 1 -type d | fzf || true)
  # Trim full path to name
  name=$(basename "$path" | tr . _)
fi

# If no path is selected, exit
if [[ -z "$path" ]]; then
  exit 0
fi

if [[ ! -d "$path" ]]; then
  echo "tmux-sessionizer: no such directory: $path" >&2
  exit 1
fi

# Check once, as `conda env list` is slow
has_conda_env=false
if command -v conda > /dev/null && conda env list | grep "^$name\s" > /dev/null; then
  has_conda_env=true
fi

# Function to create tmux windows for given project name
create_windows () {
  # launch nvim in first window
  # the first window is created when the session is created, so we only need to rename it
  local window=1
  local target="$name:$window"
  tmux rename-window -t "$target" "nvim"
  if $has_conda_env; then
    tmux send-keys -t "$target" "conda activate $name" C-m C-l
  fi
  tmux send-keys -t "$target" "cd $path" C-m C-l
  tmux send-keys -t "$target" "nvim" C-m

  # launch AI agent in second window
  local window=2
  local target="$name:$window"
  tmux new-window -d -t "$target" -n "$AGENT"
  if $has_conda_env; then
    tmux send-keys -t "$target" "conda activate $name" C-m C-l
  fi
  tmux send-keys -t "$target" "cd $path" C-m C-l
  tmux send-keys -t "$target" "$AGENT" C-m

  # launch shell in third window
  local window=3
  local target="$name:$window"
  tmux new-window -d -t "$target"
  if $has_conda_env; then
    tmux send-keys -t "$target" "conda activate $name" C-m C-l
  fi
  tmux send-keys -t "$target" "cd $path" C-m C-l

  # select shell window as initial window
  tmux select-window -t "$target"
}

is_tmux_session="${TMUX:-}"

# if in tmux and current session is already selected name, exit
if [[ -n "$is_tmux_session" ]] && [[ "$(tmux display-message -p '#S')" == "$name" ]]; then
  exit 0
fi

# if the session does not exist, create a new detached session; this also
# starts the tmux server if it is not running
# use "=" prefix to force an exact match (otherwise tmux prefix-matches,
# e.g. "nm-bci-cpp" would match an existing "nm-bci-cpp-wt1" session)
if ! tmux has-session -t "=$name" 2> /dev/null; then
  tmux new-session -s "$name" -c "$path" -d
  create_windows
fi

# when outside tmux, attach session; otherwise switch client
if [[ -z "$is_tmux_session" ]]; then
  tmux attach-session -t "=$name"
else
  tmux switch-client -t "=$name"
fi

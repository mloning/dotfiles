#!/usr/bin/env bash
# Pick a local branch with fzf and switch to it.
#
# Branches are listed newest first by last commit, and the worktree a branch is
# checked out in is shown next to it. Picking such a branch prints its worktree
# path, because git refuses to check out a branch that is in use elsewhere.

set -euo pipefail

if ! command -v fzf >/dev/null 2>&1; then
  echo "${0##*/}: fzf is required but not installed" >&2
  exit 1
fi

# Pad the branch column to the longest branch name. %(align:) ignores the colour
# escapes when measuring, so this is a visible width.
width=$(git for-each-ref refs/heads --format='%(refname:short)' |
  awk '{ if (length($0) > max) max = length($0) } END { print max + 2 }')

format="%(align:width=$width,position=left)%(color:yellow)%(refname:short)%(color:reset)%(end)"
format+="%(align:width=17,position=left)%(color:green)%(committerdate:relative)%(color:reset)%(end)"
format+="%(if)%(HEAD)%(then)%(color:bold blue)* %(color:reset)%(else)  %(end)"
format+="%(color:cyan)%(worktreepath)%(color:reset)"

# --sort is passed explicitly because for-each-ref ignores the branch.sort config.
# `git l` in the preview keeps the commit list formatted like the log alias.
branch=$(
  git for-each-ref refs/heads --sort=-committerdate --format="$format" |
    sed "s|$HOME|~|" |
    fzf --ansi \
      --no-multi \
      --height=60% \
      --layout=reverse \
      --border \
      --preview='git l --max-count=20 {1}' \
      --preview-window='down,40%,border-top' |
    awk '{ print $1 }'
) || exit 0 # fzf exits non-zero when the picker is aborted

[[ -n $branch ]] || exit 0

worktree=$(git for-each-ref --format='%(worktreepath)' "refs/heads/$branch")
if [[ -n $worktree && $worktree != "$(git rev-parse --show-toplevel)" ]]; then
  printf 'branch: %s is checked out in worktree: %s\n' "$branch" "$worktree" >&2
  exit 1
fi

git switch "$branch"

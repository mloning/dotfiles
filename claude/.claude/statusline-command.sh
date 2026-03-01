#!/bin/bash
set -euo pipefail

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // ""')

# Default to 0 when used_percentage is null (before first message)
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
used_int=$(echo "$used_pct" | cut -d'.' -f1)
used_int=${used_int:-0}

# Build a 10-block progress bar using dim (gray) styling
filled=$(( used_int / 10 ))
empty=$(( 10 - filled ))

bar=""
for (( i = 0; i < filled; i++ )); do bar="${bar}█"; done
for (( i = 0; i < empty;  i++ )); do bar="${bar}░"; done

# Use $'...' syntax so ANSI escape sequences are interpreted by bash
dim=$'\033[2m'
reset=$'\033[0m'

# Compose output
printf "%s %s %s%s%s\n" \
  "${dim}${bar} ${used_int}%${reset}" \
  "${dim}|${reset}" \
  "$dim" "$model" "$reset"

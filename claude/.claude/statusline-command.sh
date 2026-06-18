#!/bin/bash
set -euo pipefail

input=$(cat)

# Guard against malformed stdin: `// 0` rescues null but not a parse error, and
# under `set -euo pipefail` a failing jq aborts the script and blanks the bar.
# Swap to an empty object so every downstream `// fallback` kicks in instead.
if ! printf '%s' "$input" | jq -e 'type == "object"' >/dev/null 2>&1; then
  input='{}'
fi

model=$(printf '%s' "$input" | jq -r '.model.display_name // ""')

# Default to 0 when used_percentage is null (before first message)
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0')
used_int=$(printf '%s' "$used_pct" | cut -d'.' -f1)
used_int=${used_int:-0}

# Build a 10-block progress bar using dim (gray) styling. Clamp to [0,10]:
# used_percentage can briefly exceed 100, which would overrun the bar.
filled=$(( used_int / 10 ))
(( filled > 10 )) && filled=10
(( filled < 0 ))  && filled=0
empty=$(( 10 - filled ))

bar=""
for (( i = 0; i < filled; i++ )); do bar="${bar}█"; done
for (( i = 0; i < empty;  i++ )); do bar="${bar}░"; done

# Use $'...' syntax so ANSI escape sequences are interpreted by bash
dim=$'\033[2m'
reset=$'\033[0m'

# Compose output
printf "%s%s%s %s %s\n" \
  "$dim" "$model" "$reset" \
  "${dim}|${reset}" \
  "${dim}${bar} ${used_int}%${reset}"

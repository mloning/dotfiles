# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Include hidden files in tab completion
setopt globdots

# oh-my-zsh config
# If you come from bash you might have to change your $PATH.
export PATH="$HOME/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/Cellar/neovim/0.10.4/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh/"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
  autoupdate
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Configure command history; some of these are already set by oh-my-zsh 
# but I keep them here for completeness
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY # Record timestamp in history
setopt INC_APPEND_HISTORY # Immediately append to history file
setopt INC_APPEND_HISTORY_TIME # Add information how long command ran for
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS # Don't display a line previously found
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file
setopt SHARE_HISTORY # Share history between all sessions

# Set neovim as default editor
export EDITOR=nvim
export VISUAL=nvim
alias vim='nvim'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias la='eza --long --all --total-size'
alias lt='eza --tree'
alias lf='eza --long --total-size --only-files'
alias ld='eza --long --total-size --only-dirs'  # overrides linkage editor/binder `ld` cmd
alias rm='rm -r'
alias cp='cp -r'
alias vscode='code'
alias tmux-sessionizer="$HOME"/.local/bin/tmux-sessionizer.sh
alias py='python'
alias g='git'

# Define custom key bindings, new line '\n' at the end to run command
bindkey -s ^f "tmux-sessionizer\n"  # control + f

# Define custom functions
# define clip function for macOS and Linux
if [[ "$(uname)" == "Darwin" ]]; then 
  # macOS
  clip() {
    [ -t 0 ] && pbpaste || pbcopy
  }
else  
  # assume Linux
  clip () {
    [ -t 0 ] && xclip -o -selection clipboard || xclip -selection clipboard
  }
fi

# Avoid zsh automatic pattern matching for pip
# https://github.com/ray-project/ray/issues/6696
alias pip='noglob pip'

# dotnet 
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# Enable GPG commit signing
# See https://unix.stackexchange.com/a/608921/298933
export GPG_TTY=$TTY
gpgconf --launch gpg-agent

# Add ssh keys to agent
ssh-add --apple-use-keychain ~/.ssh/id_ed25519 >/dev/null 2>&1

# Enable fuzzy-search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# autocompletion
fpath+=~/.zfunc
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# add homebrew to path
export PATH="/opt/homebrew/bin:$PATH"

# psql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH" 

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mloning/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mloning/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mloning/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mloning/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/mloning/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


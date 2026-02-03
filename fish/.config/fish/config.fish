# ============================================================================
# Fish Shell Configuration
# ============================================================================

if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # Set neovim as default editor
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    
    # tmux-sessionizer configuration
    set -gx TMUX_SESSIONIZER_ROOT_PATH "$HOME/Documents/Software"
    
    # PATH configuration
    fish_add_path $HOME/usr/local/bin
    fish_add_path $HOME/bin
    fish_add_path $HOME/.local/bin
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/opt/libpq/bin
    fish_add_path /usr/local/opt/libpq/bin
    fish_add_path /opt/homebrew/opt/openjdk@11/bin
    
    # GPG
    set -gx GPG_TTY (tty)
    gpgconf --launch gpg-agent
    
    # pnpm
    set -gx PNPM_HOME "$HOME/Library/pnpm"
    fish_add_path $PNPM_HOME
    
    # Aliases
    alias la='eza --long --all --total-size'
    alias lt='eza --tree'
    alias rm='rm -r'
    alias cp='cp -r'
    alias vscode='code'
    alias tmux-sessionizer="$HOME/.local/bin/tmux-sessionizer.sh"
    alias py='python'
    alias g='git'
    
    # Clipboard function for macOS and Linux
    function clip
        if test (uname) = "Darwin"
            # macOS
            if isatty stdin
                pbpaste
            else
                pbcopy
            end
        else
            # Linux
            if isatty stdin
                xclip -o -selection clipboard
            else
                xclip -selection clipboard
            end
        end
    end
    
    function fish_user_key_bindings
        bind -M insert \cf 'tmux-sessionizer; commandline -f repaint'
        bind -M default \cf 'tmux-sessionizer; commandline -f repaint'
    end
    
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source

    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 &>/dev/null
    
    if test -f "$HOME/.cargo/env.fish"
        source "$HOME/.cargo/env.fish"
    end
    
    # Google Cloud SDK
    if test -f "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
        source "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
    end
end


# Disable conda's prompt modification (Starship handles it)
set -gx CONDA_CHANGEPS1 false

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /usr/local/Caskroom/miniforge/base/bin/conda
    eval /usr/local/Caskroom/miniforge/base/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/usr/local/Caskroom/miniforge/base/etc/fish/conf.d/conda.fish"
        . "/usr/local/Caskroom/miniforge/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/usr/local/Caskroom/miniforge/base/bin" $PATH
    end
end
# <<< conda initialize <<<


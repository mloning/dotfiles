if status is-interactive
    # Remove fish greeting
    set -g fish_greeting

    # Commands to run in interactive sessions can go here
    
    # Set neovim as default editor
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    
    # Load machine-specific configuration
    if test -f ~/.config/fish/config.local.fish
        source ~/.config/fish/config.local.fish
    end
    
    # PATH configuration
    set --local paths \
        $HOME/.cargo/bin \
        $HOME/.local/bin \
        $HOME/bin \
        $HOME/usr/local/bin \
        /opt/homebrew/bin \
        /opt/homebrew/opt/libpq/bin \
        /opt/homebrew/opt/openjdk@11/bin \
        /opt/homebrew/sbin \
        /usr/local/opt/libpq/bin
    for path in $paths
        if test -d $path
            fish_add_path $path
        end
    end
    
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

# Initialize conda
set --local brew_conda_path (brew --prefix)/Caskroom/miniforge/base/bin/conda
if test -f $brew_conda_path
    eval $brew_conda_path "shell.fish" "hook" $argv | source
end


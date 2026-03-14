# Dotfiles

This is my collection of configuration files.

## Usage

1. Clone the repository
1. Create symbolic links in your home directory using GNU [make](https://www.gnu.org/software/make/manual/make.html) and [stow](https://www.gnu.org/software/stow/)

```bash
git clone https://github.com/mloning/dotfiles.git
cd dotfiles
make create
```

## Core dependencies

- [Fish](https://fishshell.com/) with [Starship](https://starship.rs/)
- [Ghostty](https://ghostty.org/)
- [tmux](https://github.com/tmux/tmux)
- [Neovim](https://neovim.io) with [AstroNvim](https://astronvim.com/)

## Fish/Zsh

My personal configurations is different from my work one.

- For Fish, I use a shared `config.fish` file which imports a `config.local.fish` file if present.
- For Zsh, I use `~/.zshenv` which is imported automatically by Zsh.

The local configuration is not tracked in this repo and needs to be created manually.

## Git

My personal and work configurations are slightly different.
I define a common `.gitconfig_base` which I can then import in `.gitconfig` files.
The `.gitconfig` is not tracked in this repo and needs to be created manually.
My personal git configuration is in `git/.gitconfig_personal`.

```
[include]
  path = ~/.gitconfig_base
```

## Neovim (AstroNvim)

- `:AstroUpdate` to update Neovim and Mason plugins
- `:Lazy` and then `Sync` to upgrade Mason plugins and remove unused plugins
- `:Lazy` and then `Restore` to install Mason plugin from versions in lock file
- `:checkhealth` to check health of all packages
- `:TSUpdate` to update tree-sitter
- `:Mason` to update LSP servers and related tools

## tmux

- Press `prefix` + `I` to install plugins using [tmp]

[tmp]: https://github.com/tmux-plugins/tpm

## Find out more

### Dotfiles

- http://dotfiles.github.io
- https://alexpearce.me/2016/02/managing-dotfiles-with-stow/

### Neovim

- https://github.com/SimonCW/dotfiles
- https://github.com/LunarVim/nvim-basic-ide
- https://github.com/ThePrimeagen/.dotfiles

### tmux

- https://tmuxcheatsheet.com/

### git

- [How and why to sign git commits](https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html)
- [Popular git config options](https://jvns.ca/blog/2024/02/16/popular-git-config-options/)
- [Better Git Conflicts with zdiff3](https://ductile.systems/zdiff3/)

### How to use the Windows clipboard in Neovim from WSL?

- https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl

### Zsh

- https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
- https://www.freecodecamp.org/news/how-do-zsh-configuration-files-work/

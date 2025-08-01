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

- [alacritty](https://alacritty.org) or [Windows Terminal](https://github.com/microsoft/terminal)
- [oh-my-zsh](https://ohmyz.sh) with [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [tmux](https://github.com/tmux/tmux)
- [neovim](https://neovim.io) with [AstroNvim](https://astronvim.com/)

## Git configuration

My personal git configuration is different from my work one.
I define a shared `.gitconfig_base`, which I can then import in each of my `.gitconfig` files.

```
[include]
  path = ~/.gitconfig_base
```

My personal git configuration is in `git/.gitconfig_personal`.

## Update plugins

### AstroNvim (Neovim)

- `:AstroUpdate` to update Neovim and Mason plugins
- `:Lazy` and then `Sync` to upgrade Mason plugins and remove unused plugins
- `:Lazy` and then `Restore` to install Mason plugin from versions in lock file
- `:checkhealth` to check health of all packages
- `:TSUpdate` to update tree-sitter
- `:Mason` to update LSP servers and related tools

### tmux

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

### zsh

- https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
- https://www.freecodecamp.org/news/how-do-zsh-configuration-files-work/

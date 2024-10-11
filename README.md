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

## Update plugins

### Neovim

- `:Lazy` using `Restore` install versions from lock file and `Sync` to upgrade plugins
- `:checkhealth` to check health of all packages
- `:TSUpdate` to update tree-sitter
- `:Mason` to update LSP servers and related tools

### Tmux

- Press `prefix` + `I` to install plugins using [tmp]

[tmp]: https://github.com/tmux-plugins/tpm

## Find out more

#### Maintaining dotfiles

- http://dotfiles.github.io
- https://alexpearce.me/2016/02/managing-dotfiles-with-stow/

#### Neovim

- https://github.com/SimonCW/dotfiles
- https://github.com/LunarVim/nvim-basic-ide
- https://github.com/ThePrimeagen/.dotfiles

#### Tmux

https://tmuxcheatsheet.com/

#### Git

- [How and why to sign git commits](https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html)
- [Popular git config options](https://jvns.ca/blog/2024/02/16/popular-git-config-options/)
- [Better Git Conflicts with zdiff3](https://ductile.systems/zdiff3/)

#### How to use the Windows clipboard in Neovim from WSL?

https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl

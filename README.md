# Dotfiles

This is my collection of configuration files.

## Usage

1. Clone the repository into your home directory
1. Create symbolic links using GNU [make](https://www.gnu.org/software/make/manual/make.html) and [stow](https://www.gnu.org/software/stow/)

```bash
git clone https://github.com/mloning/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make all
```

## Dependencies

* [alacritty](https://alacritty.org) (terminal emulator)
* [oh-my-zsh](https://ohmyz.sh)
* [powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [tmux](https://github.com/tmux/tmux/wiki)
* [neovim](https://neovim.io)

## Find out more

* http://dotfiles.github.io
* https://alexpearce.me/2016/02/managing-dotfiles-with-stow/

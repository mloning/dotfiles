# MacOS setup

https://simoncw.com/posts/dev-setup-mac-python-rust/

## Manual configuration

* Bluetooth in control center bar
* Sound in control center bar
* Trackpad click on tap
* `defaults write -g ApplePressAndHoldEnabled -bool false` 

For automation, see https://apple.stackexchange.com/a/457024.

## Install homebrew

Install homebrew:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Add `brew` command to path:

```bash
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/mloning/.zprofile 
eval "$(/opt/homebrew/bin/brew shellenv)"
``` 

## Install system packages

```bash
brew install \
  neovim \
  tmux \
  alacritty \
  stow \
  bat \
  fzf \
  fd \
  gh \
  gpg \
  node \
  htop \
  tree \
  ripgrep
```

## Install my dotfiles

```bash
mv ~/.zshrc ~/.zshrc.bak
mkdir ~/Dev/projects && cd ~/Dev/projects && git clone https://github.com/mloning/dotfiles.git && cd dotfiles && make create
omz reload
```

## Install oh-my-zsh with powerlevel10k

Install ph-my-zsh with plugins specified in `.zshrc` file:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM//plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
omz reload
```

* Install fonts https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#manual-font-installation
* Install powerlevel10k https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh

## Install tmux plugins

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Open tmux session and press: tmux prefix + `I` to install plugins 

## Install Python

```bash
brew install --cask mambaforge
conda init "$(basename "${SHELL}")"
omz reload
conda info
```

## Create GPG keys

https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html


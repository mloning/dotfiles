#!/bin/bash
cp ~/.zshrc zsh/
cp /mnt/c/Users/Markus.Loning/AppData/Roaming/Code/User/settings.json vscode/
cp -r ~/.jupyter/lab/user-settings/@jupyterlab/* jupyter/
cp /mnt/c/Users/Markus.Loning/AppData/Local/packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json terminal/
code --list-extensions > vscode/extensions.list
cp ~/.config/gh/config.yml gh/

#!/bin/bash

set -eu

print_in_green() {
    echo -e "\e[32m$1\e[0m"
}

# zsh plugins
print_in_green "installing zsh plugins"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

print_in_green "Log out and log in to use zsh"

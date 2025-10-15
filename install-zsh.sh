#!/bin/bash

set -eu

print_in_green() {
    echo -e "\e[32m$1\e[0m"
}

print_in_green "DONT RUN AS SUDO"

# zsh
print_in_green "installing zsh and ohmyzsh"
sudo dnf install zsh -y

# ohmyzsh
RUNZSH=no \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
&& chsh -s "$(command -v zsh)" "$USER"

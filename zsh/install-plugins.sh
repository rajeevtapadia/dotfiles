#!/bin/bash

set -eu

print_in_green() {
    echo -e "\e[32m$1\e[0m"
}

install_or_update() {
    local repo_url="$1"
    local dest_dir="$2"

    if [ -d "$dest_dir/.git" ]; then
        print_in_green "Updating $(basename "$dest_dir")"
        git -C "$dest_dir" pull --ff-only
    else
        print_in_green "Installing $(basename "$dest_dir")"
        git clone "$repo_url" "$dest_dir"
    fi
}

# zsh plugins
print_in_green "installing zsh plugins"

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS_DIR="$ZSH_CUSTOM_DIR/plugins"

mkdir -p "$PLUGINS_DIR"

install_or_update https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
install_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"

print_in_green "Log out and log in to use zsh"

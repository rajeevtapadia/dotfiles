#!/bin/sh

# This script copies the following configs into their
# respective files in the repo
#
# zsh configs: .zshrc, .zsh_history
# zed configs: settings, keymap, tasks
# tmux config
# ghostty config
# gnome extension list
# nvim config
# gnome keybindings

set -e

# zsh
./zsh/backup-zsh.sh backup

# zed
./zed/backup-zed.sh backup

# tmux
./tmux/tmux-config-backup.sh backup

# ghostty
./ghostty/ghostty-backup.sh backup

# gnome extension list
./gnome-extensions/backup-extensions.sh backup

# nvim
./neovim/nvim_backup.sh backup

# custom keybindings
gnome-keybindings/keybindings.sh backup
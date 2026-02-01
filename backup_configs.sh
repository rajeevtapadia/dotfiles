#!/bin/sh

# This script copies the following configs into their
# respective files in the repo
#
# zsh configs: .zshrc, .zsh_history
# zed configs: settings, keymap, tasks
# tmux config
# nvim config
# wezterm config
# kde config

set -e

# zsh
./zsh/backup-zsh.sh backup

# zed
./zed/backup-zed.sh backup

# tmux
./tmux/tmux-config-backup.sh backup

# nvim
./neovim/nvim_backup.sh backup

# wezterm
./wezterm/wezterm-backup.sh backup

# kde
cd kde
./kde-backup.sh backup
cd -
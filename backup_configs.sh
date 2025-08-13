#!/bin/sh

# This script copies the following configs into their 
# respective files in the repo
#
# zsh configs: .zshrc, .zsh_history
# zed configs: settings, keymap, tasks
# tmux config
# gnome extension list

set -e

# zsh
cat ~/.zshrc > ./zsh/.zshrc
cat ~/.zsh_history > ./zsh/.zsh_history

# zed
cat ~/.config/zed/settings.json > ./zed/settings.json
cat ~/.config/zed/keymap.json > ./zed/keymap.json
cat ~/.config/zed/tasks.json > ./zed/tasks.json

# tmux
./tmux/tmux-config.sh backup

# gnome extension list
cd gnome-extensions
./backup-extensions.sh backup
cd ..

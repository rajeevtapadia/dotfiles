#!/bin/sh

# This script copies the following configs into their 
# respective files in the repo
#
# zsh configs: .zshrc, .zsh_history
# zed configs: settings, keymap, tasks
#

set -e
set -x

# zsh
cat ~/.zshrc > ./zsh/.zshrc-$(date +"%Y-%m-%dT%H:%M")
cat ~/.zsh_history > ./zsh/.zsh_history-$(date +"%Y-%m-%dT%H:%M")

# zed
cat ~/.config/zed/settings.json > ./zed/settings-$(date +"%Y-%m-%dT%H:%M").json
cat ~/.config/zed/keymap.json > ./zed/keymap-$(date +"%Y-%m-%dT%H:%M").json
cat ~/.config/zed/tasks.json > ./zed/tasks-$(date +"%Y-%m-%dT%H:%M").json

# gnome extension list
gnome-extensions list --enabled > ./gnome-extensions/gnome-extensions.txt
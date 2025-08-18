#!/usr/bin/env bash

# Backs up and restores gnome terminal profiles

set -e

if [[ $1 == 'backup' ]]; then
  dconf dump '/org/gnome/Ptyxis/' > gnome-terminal/gnome-terminal.dconf
  echo "backup done"
  exit 0
fi
if [[ $1 == 'restore' ]]; then
  dconf reset -f '/org/gnome/Ptyxis/'
  dconf load '/org/gnome/Ptyxis/' < gnome-terminal/gnome-terminal.dconf
  echo "restore done"
  exit 0
fi

echo "parameter 0: [backup|restore]"

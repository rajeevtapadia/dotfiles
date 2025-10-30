#!/bin/bash

CONFIG_DIR="$HOME/.config/wezterm"
BACKUP_DIR="./wezterm"

backup_wezterm() {
    echo "Backing up Wezterm configuration..."
    mkdir -p "$BACKUP_DIR"
    cp -rv "$CONFIG_DIR" "$BACKUP_DIR/config"
    echo "Wezterm backup complete."
}

restore_wezterm() {
    echo "Restoring Wezterm configuration..."
    mkdir -p $CONFIG_DIR
    cp -rv "$BACKUP_DIR/config" "$CONFIG_DIR"
    echo "Wezterm restore complete."
}

if [[ $# -eq 0 || ( "$1" != "backup" && "$1" != "restore" ) ]]; then
    echo "Usage: $0 {backup|restore}"
    exit 1
fi

if [ "$1" == "backup" ]; then
    backup_wezterm
elif [ "$1" == "restore" ]; then
    restore_wezterm
fi

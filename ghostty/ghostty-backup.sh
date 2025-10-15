#!/bin/bash

CONFIG_DIR="$HOME/.config/ghostty"
BACKUP_DIR="./ghostty"

backup_ghostty() {
    echo "Backing up Ghostty configuration..."
    mkdir -p "$BACKUP_DIR"
    cp -v "$CONFIG_DIR/config" "$BACKUP_DIR/config"
    echo "Ghostty backup complete."
}

restore_ghostty() {
    echo "Restoring Ghostty configuration..."
    mkdir -p $CONFIG_DIR
    cp -v "$BACKUP_DIR/config" "$CONFIG_DIR/config"
    echo "Ghostty restore complete."
}

if [[ $# -eq 0 || ( "$1" != "backup" && "$1" != "restore" ) ]]; then
    echo "Usage: $0 {backup|restore}"
    exit 1
fi

if [ "$1" == "backup" ]; then
    backup_ghostty
elif [ "$1" == "restore" ]; then
    restore_ghostty
fi

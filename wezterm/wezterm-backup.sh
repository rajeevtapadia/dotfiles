#!/bin/bash

set -eu

CONFIG_DIR="$HOME/.config/wezterm"
# Always back up next to this script, regardless of where it is called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR"
BACKUP_CONFIG_DIR="$BACKUP_DIR/config"

backup_wezterm() {
    echo "Backing up Wezterm configuration..."

    if [ ! -d "$CONFIG_DIR" ]; then
        echo "No wezterm config directory at '$CONFIG_DIR'; nothing to back up."
        return 0
    fi

    mkdir -p "$BACKUP_CONFIG_DIR"
    rsync -a --delete "$CONFIG_DIR/." "$BACKUP_CONFIG_DIR/"
    echo "Wezterm backup complete -> $BACKUP_CONFIG_DIR"
}

restore_wezterm() {
    echo "Restoring Wezterm configuration..."

    if [ ! -d "$BACKUP_CONFIG_DIR" ]; then
        echo "No backup found at '$BACKUP_CONFIG_DIR'; aborting restore."
        exit 1
    fi

    mkdir -p "$CONFIG_DIR"
    rsync -a "$BACKUP_CONFIG_DIR/." "$CONFIG_DIR/"
    echo "Wezterm restore complete -> $CONFIG_DIR"
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

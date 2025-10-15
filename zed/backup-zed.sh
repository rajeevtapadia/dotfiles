#!/bin/bash

ZED_BACKUP_DIR="./zed"

# Function for backup
backup_zed() {
    echo "Backing up zed configuration..."

    # Create backup directory if it doesn't exist
    mkdir -p "$ZED_BACKUP_DIR"

    # Backup zed files
    cp -v ~/.config/zed/settings.json "$ZED_BACKUP_DIR/settings.json"
    cp -v ~/.config/zed/keymap.json "$ZED_BACKUP_DIR/keymap.json"
    cp -v ~/.config/zed/tasks.json "$ZED_BACKUP_DIR/tasks.json"

    echo "Zed backup complete."
}

# Function for restore
restore_zed() {
    echo "Restoring zed configuration..."

    mkdir -p ~/.config/zed

    # Restore zed files
    cp -v "$ZED_BACKUP_DIR/settings.json" ~/.config/zed/settings.json
    cp -v "$ZED_BACKUP_DIR/keymap.json" ~/.config/zed/keymap.json
    cp -v "$ZED_BACKUP_DIR/tasks.json" ~/.config/zed/tasks.json

    echo "Zed restore complete."
}

# Check if a valid argument is provided
if [[ $# -eq 0 || ( "$1" != "backup" && "$1" != "restore" ) ]]; then
    echo "Usage: $0 {backup|restore}"
    exit 1
fi

# Run the appropriate action
if [ "$1" == "backup" ]; then
    backup_zed
elif [ "$1" == "restore" ]; then
    restore_zed
fi

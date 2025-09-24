#!/bin/bash

ZSH_BACKUP_DIR="./zsh"

# Function for backup
backup_zsh() {
    echo "Backing up zsh configuration..."

    # Create backup directory if it doesn't exist
    mkdir -p "$ZSH_BACKUP_DIR"

    # Backup zsh files
    cp -v ~/.zshrc "$ZSH_BACKUP_DIR/.zshrc"
    cp -v ~/.zsh_history "$ZSH_BACKUP_DIR/.zsh_history"

    echo "Zsh backup complete."
}

# Function for restore
restore_zsh() {
    echo "Restoring zsh configuration..."

    # Check if the backup files exist
    if [ ! -f "$ZSH_BACKUP_DIR/.zshrc" ] || [ ! -f "$ZSH_BACKUP_DIR/.zsh_history" ]; then
        echo "Error: Backup files not found. Please ensure backup exists."
        exit 1
    fi

    # Restore zsh files
    cp -v "$ZSH_BACKUP_DIR/.zshrc" ~/.zshrc
    cp -v "$ZSH_BACKUP_DIR/.zsh_history" ~/.zsh_history

    echo "Zsh restore complete."
}

# Check if a valid argument is provided
if [[ $# -eq 0 || ( "$1" != "backup" && "$1" != "restore" ) ]]; then
    echo "Usage: $0 {backup|restore}"
    exit 1
fi

# Run the appropriate action
if [ "$1" == "backup" ]; then
    backup_zsh
elif [ "$1" == "restore" ]; then
    restore_zsh
fi

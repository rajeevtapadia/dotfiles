#!/bin/bash

BACKUP_FILE="./gnome-extensions/extension-list.json"

usage() {
    echo "Usage: $0 backup|restore"
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

mode="$1"

if [[ "$mode" == "backup" ]]; then
    echo "Backing up enabled GNOME extensions to JSON..."
    extensions=()
    for uuid in $(gnome-extensions list --enabled); do
        name=$(gnome-extensions info "$uuid" \
               | grep -E '^Name:' \
               | cut -d: -f2- \
               | xargs)
        extensions+=("$(jq -n \
            --arg name "$name" \
            --arg uuid "$uuid" \
            '{name:$name, uuid:$uuid}')")
    done
    jq -s '.' <<< "${extensions[*]}" > "$BACKUP_FILE"
    echo "Backup complete: $BACKUP_FILE"

elif [[ "$mode" == "restore" ]]; then
    if [[ ! -f "$BACKUP_FILE" ]]; then
        echo "Backup file not found: $BACKUP_FILE"
        exit 1
    fi

    sudo dnf install pipx
    pipx install gnome-extensions-cli --system-site-packages

    echo "Restoring GNOME extensions using Python..."
    ./gnome-extensions/install-extensions.py "$BACKUP_FILE"
    echo "Restore complete."

else
    usage
fi

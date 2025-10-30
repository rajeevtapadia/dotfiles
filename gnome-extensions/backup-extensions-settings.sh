#!/bin/bash

# Location to store the backup
BACKUP_FILE="./gnome-extensions/gnome-extensions-backup.conf"

case "$1" in
    backup)
        echo "Backing up GNOME Shell extensions settings..."
        dconf dump /org/gnome/shell/extensions/ > "$BACKUP_FILE"
        echo "Backup saved to $BACKUP_FILE"
        ;;
    restore)
        if [ -f "$BACKUP_FILE" ]; then
            echo "Restoring GNOME Shell extensions settings..."
            dconf load /org/gnome/shell/extensions/ < "$BACKUP_FILE"
            echo "Restore completed."
        else
            echo "Backup file $BACKUP_FILE not found!"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac

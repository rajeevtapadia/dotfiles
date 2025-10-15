#!/bin/bash

case "$1" in
    backup)
        echo "Backing up tmux config..."
        cat ~/.tmux.conf > tmux/.tmux.conf
        echo "Backup saved"
        ;;
    restore)
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        cat tmux/.tmux.conf > ~/.tmux.conf
        echo "tmux config restored"
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac

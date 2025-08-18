#!/bin/bash

case "$1" in
    backup)
        echo "Backing up nvim config..."
        rm neovim/nvim -fr
        cp -r ~/.config/nvim neovim/
        echo "Backup saved"
        ;;
    restore)
        rm ~/.config/nvim/ -frv
        cp -r neovim/nvim ~/.config/
        echo "nvim config restored"
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac


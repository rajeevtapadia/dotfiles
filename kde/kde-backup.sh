#!/usr/bin/env bash

set -euo pipefail
# Allow globs with no matches to expand to nothing instead of the literal pattern
shopt -s nullglob

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kde-backup"

usage() {
  cat <<EOF
Usage: $(basename "$0") backup|restore

This script backs up and restores key KDE/Plasma configuration files.

Backup:
  - Reads from your home directory (~/.config, ~/.local/share) and
    stores copies under: \$BACKUP_DIR

Restore:
  - Copies the saved configs back into your home directory.
  - You should log out of KDE / stop Plasma before restoring,
    then log back in.

NOTE: This is a best-effort snapshot/restore for KDE settings.
      It may not capture absolutely everything, but it covers
      most Plasma layout, theme, shortcut and app settings.
EOF
}

ensure_backup_dir() {
  mkdir -p "$BACKUP_DIR/config"
  mkdir -p "$BACKUP_DIR/localshare"
}

# List of important config files/directories to back up.
CONFIG_ITEMS=(
  "plasma-org.kde.plasma.desktop-appletsrc"
  "plasmashellrc"
  "kwinrc"
  "kglobalshortcutsrc"
  "kdeglobals"
  "kscreenlockerrc"
  "kcminputrc"
  "kded5rc"
  "dolphinrc"
  "dolphin_viewmodesrc"
  "dolphinui.rc"
  "okularrc"
)

LOCALSHARE_ITEMS=(
  "plasma*"
  "dolphin"
  "okular"
  "color-schemes"
  "wallpapers"
  "aurorae"
)

backup() {
  ensure_backup_dir

  echo "Backing up KDE/Plasma settings to: $BACKUP_DIR"

  # Backup ~/.config items
  for item in "${CONFIG_ITEMS[@]}"; do
    src="$HOME/.config/$item"
    dest_dir="$BACKUP_DIR/config"
    if [ -e "$src" ]; then
      echo "  - Saving ~/.config/$item"
      if [ -d "$src" ]; then
        rsync -a --delete "$src"/ "$dest_dir/$item"/
      else
        cp -a "$src" "$dest_dir/"
      fi
    fi
  done

  # Backup ~/.local/share items
  for pattern in "${LOCALSHARE_ITEMS[@]}"; do
    for src in "$HOME/.local/share"/$pattern; do
      [ -e "$src" ] || continue
      name="$(basename "$src")"
      dest="$BACKUP_DIR/localshare/$name"
      echo "  - Saving ~/.local/share/$name"
      rsync -a --delete "$src"/ "$dest"/ 2>/dev/null || cp -a "$src" "$dest"
    done
  done

  echo "Done."
}

restore() {
  ensure_backup_dir

  echo "Restoring KDE/Plasma settings from: $BACKUP_DIR"
  echo "IMPORTANT: Make sure Plasma/KDE is not running (log out of the session) before restoring."

  # Restore ~/.config items
  for item in "${CONFIG_ITEMS[@]}"; do
    src_file="$BACKUP_DIR/config/$item"
    src_dir="$BACKUP_DIR/config/$item"
    dest="$HOME/.config/$item"

    if [ -d "$src_dir" ]; then
      echo "  - Restoring directory ~/.config/$item"
      mkdir -p "$dest"
      rsync -a --delete "$src_dir"/ "$dest"/
    elif [ -f "$src_file" ]; then
      echo "  - Restoring file ~/.config/$item"
      cp -a "$src_file" "$dest"
    fi
  done

  # Restore ~/.local/share items
  if [ -d "$BACKUP_DIR/localshare" ]; then
    for src in "$BACKUP_DIR/localshare"/*; do
      [ -e "$src" ] || continue
      name="$(basename "$src")"
      dest="$HOME/.local/share/$name"
      echo "  - Restoring ~/.local/share/$name"
      mkdir -p "$dest"
      rsync -a --delete "$src"/ "$dest"/ 2>/dev/null || cp -a "$src" "$dest"
    done
  fi

  echo "Restore complete."
  echo "You may need to log back into KDE/Plasma or reboot to see all changes."
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

case "$1" in
  backup)
    backup
    ;;
  restore)
    restore
    ;;
  *)
    usage
    exit 1
    ;;
esac



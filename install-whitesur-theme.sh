#!/bin/sh

set -x

echo "installing WhiteSur-gtk-theme"
echo "https://github.com/vinceliuice/WhiteSur-gtk-theme"

cd ~/Downloads
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme --depth=1

./install.sh

echo "for more customization visit\nhttps://github.com/vinceliuice/WhiteSur-gtk-theme"


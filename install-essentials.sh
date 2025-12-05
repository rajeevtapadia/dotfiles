#!/bin/bash

set -eu

print_in_green() {
    echo -e "\e[32m$1\e[0m"
}

print_in_green "PLEASE RUN AS SUDO"

print_in_green "Updating dnf config for faster downloads"
sudo tee /etc/dnf/dnf.conf >/dev/null <<'EOF'
# see `man dnf.conf` for defaults and possible options

[main]
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
keepcache=True
EOF

sudo dnf update -y

# dnf repos
print_in_green "Setting up repos"

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo --overwrite
curl -fsSL https://copr.fedorainfracloud.org/coprs/rafatosta/zapzap/repo/fedora-42/rafatosta-zapzap-fedora-42.repo | sudo tee /etc/yum.repos.d/zapzap.repo >/dev/null
sudo dnf copr enable -y wezfurlong/wezterm-nightly

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# dnf packages
print_in_green "Installing dnf packages"
sudo dnf install  \
gnome-tweaks \
neovim \
vlc \
mpv \
qbittorrent \
btop \
htop \
kde-connect \
nvtop \
brave-browser \
zapzap \
fzf \
pipx \
fd \
clangd \
wezterm \
nautilus-python \
chromium \
okular -y

sudo npm i -g neovim

./install-docker-fedora.sh

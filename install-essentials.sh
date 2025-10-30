#!/bin/bash

set -eu

print_in_green() {
    echo -e "\e[32m$1\e[0m"
}

print_in_green "PLEASE RUN AS SUDO"

print_in_green "Updating dnf config for faster downloads"
sudo echo -e "# see \`man dnf.conf\` for defaults and possible options\n\n[main]\nfastestmirror=True\nmax_parallel_downloads=10\ndefaultyes=True\nkeepcache=True" | sudo tee /etc/dnf/dnf.conf > /dev/null

sudo dnf update -y

# dnf repos
print_in_green "Setting up repos"

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo curl https://copr.fedorainfracloud.org/coprs/rafatosta/zapzap/repo/fedora-42/rafatosta-zapzap-fedora-42.repo > /etc/yum.repos.d/zapzap.repo
sudo dnf copr enable wezfurlong/wezterm-nightly

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# dnf packages
print_in_green "Installing dnf packages"
sudo dnf install  \
gnome-tweaks \
neovim \
vlc \
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
nautilus-python \   # for wezterm integration
akmod-nvidia -y

sudo npm i neovim typescript-language-server

./install-docker-fedora.sh

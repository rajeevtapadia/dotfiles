#!/bin/bash

set -euxo pipefail

echo "PLEASE RUN AS SUDO"

sudo dnf update -y

# dnf repos
echo "setting up repos"
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo curl https://copr.fedorainfracloud.org/coprs/rafatosta/zapzap/repo/fedora-42/rafatosta-zapzap-fedora-42.repo > /etc/yum.repos.d/zapzap.repo

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# dnf packages
echo "installing dnf packages"
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
akmod-nvidia -y

# zsh
echo "installing zsh and ohmyzsh"
sudo dnf install zsh -y

# ohmyzsh
RUNZSH=no \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
&& chsh -s "$(command -v zsh)" "$USER"

# zsh plugins  
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zed
echo "installing zed"
curl -f https://zed.dev/install.sh | sh 


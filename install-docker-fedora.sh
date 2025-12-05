#!/bin/bash

set -eu

print_in_green() {
    echo -e "\e[32m$1\e[0m"
}

print_in_green "Removing any old docker installation"
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine \
                  -y

print_in_green "Adding docker repo"
sudo dnf -y install dnf-plugins-core
curl -fsSL https://download.docker.com/linux/fedora/docker-ce.repo | sudo tee /etc/yum.repos.d/docker-ce.repo >/dev/null

print_in_green "Installing docker"
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

print_in_green "Starting docker"
sudo systemctl start docker

print_in_green "to start automatically use"
print_in_green "sudo systemctl enable --now docker"

sudo docker run hello-world

print_in_green "To create docker group run: "
print_in_green "newgrp docker"
print_in_green "sudo usermod -aG docker $USER"
print_in_green "See more: https://stackoverflow.com/questions/48957195/how-to-fix-docker-permission-denied"

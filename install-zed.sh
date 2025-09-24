#!/bin/bash

set -eu

print_in_green() {
    echo -e "\e[32m$1\e[0m"
}

# zed
print_in_green "installing zed"
curl -f https://zed.dev/install.sh | sh

#!/usr/bin/env bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        ubuntu|debian)
            sudo apt update && sudo apt install -y python3
            ;;
        rocky|centos|rhel)
            sudo dnf install -y python3
            ;;
        arch)
            sudo pacman -Sy --noconfirm python
            ;;
        alpine)
            sudo apk add --no-cache python3
            ;;
        *)
            echo "Unsupported distribution: $ID"
            exit 1
            ;;
    esac
else
    echo "Cannot detect operating system. Unsupported distribution."
    exit 1
fi

echo "Python3 installation completed successfully."

#!/bin/bash

echo; echo "==== packages-dev.sh ===="

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y      \
    emacs-nox		\
    jq                  \
    less                \
    ripgrep             \

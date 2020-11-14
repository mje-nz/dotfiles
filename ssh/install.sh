#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"

mkdir -p ~/.ssh
link_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"

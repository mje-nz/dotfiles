#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"

mkdir -p ~/.config/autokey/data
link_file "$DOTFILES/linux-only/autokey/osxkeys/" "$HOME/.config/autokey/data/OSXKeys"

#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"


link_scripts() {
	# TODO is this right?
	# shellcheck disable=SC2034
	local overwrite_all=false backup_all=false skip_all=false
	mkdir -p ~/.config/autokey/data
	link_file "$DOTFILES/linux-only/autokey/osxkeys/" "$HOME/.config/autokey/data/OSXKeys"
}

link_scripts

#!/usr/bin/env bash

source $DOTFILES/setup_common.sh

link_scripts() {
	local overwrite_all=false backup_all=false skip_all=false
	mkdir -p ~/.config/autokey/data
	link_file "$DOTFILES/linux-only/autokey/osxkeys/" "$HOME/.config/autokey/data/OSXKeys"
}

link_scripts


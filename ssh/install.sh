#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"

link_config() {
	# TODO is this right?
	# shellcheck disable=SC2034
	local overwrite_all=false backup_all=false skip_all=false
	mkdir -p ~/.ssh
	link_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"
}

link_config

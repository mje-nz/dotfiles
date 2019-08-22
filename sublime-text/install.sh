#!/usr/bin/env bash

source $DOTFILES/setup_common.sh
set -e

ST3_PATH="$HOME/Library/Application Support/Sublime Text 3"
if [[ -d "$ST3_PATH" ]]; then
	if [[ -e "$ST3_PATH/Packages/User" ]]; then
		st3_user_target=$(readlink "$ST3_PATH/Packages/User" || true)
		if [[ "$st3_user_target" == "$DOTFILES/sublime-text" ]]; then
			# Already set up
			exit
		fi
	fi
	if find "$ST3_PATH/Packages/User" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
		info "Sublime Text 3 already has config, link it yourself"
	else
		if [[ -d "$ST3_PATH/Packages/User" ]]; then 
			rmdir "$ST3_PATH/Packages/User";
		fi
		ln -s "$DOTFILES/sublime-text" "$ST3_PATH/Packages/User"
		success "Linked Sublime Text settings"
	fi
fi
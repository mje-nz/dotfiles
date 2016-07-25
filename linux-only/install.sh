#!/usr/bin/env bash

source $DOTFILES/setup_common.sh

yesno() {
	local message=$1
	local doit=0 action=
	user "$message [Y]/n"
	
	read -n 1 action
	case "$action" in
	  Y )
		doit=0;;
	  n )
		doit=1;;
	  * )
		;;
	esac
	
	return $doit
}

if yesno "Install zsh, git, tree, ack and cheat (will use sudo)?"; then
	echo "Installing packages"

	# Install my usual packages
	sudo apt-get install zsh zsh-common git tree ack-grep python-pip
	sudo pip install cheat
	
	success "Installed packages"
fi

if [ "$SHELL" != $(which zsh) ]; then
	if yesno "Change shell to zsh (will prompt for password)?"; then
		chsh -s $(which zsh)
	fi
fi


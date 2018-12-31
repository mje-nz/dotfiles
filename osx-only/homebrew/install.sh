#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

if test "$(uname)" = "Darwin"
then
	
	source $DOTFILES/setup_common.sh

	# Install Homebrew if necessary
	if test ! $(which brew); then
		echo "Installing Homebrew..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

		# Update Homebrew
		echo "> brew update"
		brew update

		# Run the Brewfile through Homebrew
		echo "> brew bundle"
		pushd "$(dirname $0)"
		brew bundle
		popd

		# Replace outdated bash
		brew install bash
		brew install bash-completion2
		BREW_PREFIX=$(brew --prefix)
		if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
		  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
		fi

		# Replace outdated core utils, GNU utilities etc
		brew install coreutils
		brew install file-formula
		brew install findutils --with-default-names 
		brew install gawk
		brew install gnu-sed --with-default-names 
		brew install gnu-tar --with-default-names
		brew install gnu-which --with-default-names
		brew install grep --with-default-names
		brew install less
		brew install make --with-default-names
		brew install screen
		brew install vim
		# Note coreutils and file-formula need PATH changes

		success "Installed Homebrew"
	fi
fi

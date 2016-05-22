#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

if test "$(uname)" = "Darwin"
then

	# Install Homebrew if necessary
	if test ! $(which brew); then
		echo "> Installing Homebrew"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# Update Homebrew
	echo "› brew update"
	brew update

	# Run the Brewfile through Homebrew
	echo "› brew bundle"
	pushd "$(dirname $0)"
	brew bundle
	popd
fi

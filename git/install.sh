#!/bin/sh
#
# Set up a file to include into .gitconfig which sets the author name and email
# 

source $DOTFILES/setup_common.sh

set -e

if ! [ -f git/gitconfig.local.symlink ]; then
	echo 'Setting up gitconfig'

	# See https://help.github.com/articles/caching-your-github-password-in-git/ 
	git_credential='cache'
	if [ "$(uname -s)" == "Darwin" ]; then
		git_credential='osxkeychain'
	fi

	user ' - What is your Git author name?'
	read -e git_authorname
	user ' - What is your Git author email?'
	read -e git_authoremail

	sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.template > git/gitconfig.local.symlink

	success 'Set up gitconfig'
fi

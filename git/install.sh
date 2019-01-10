#!/usr/bin/env bash
#
# Set up a file to include into .gitconfig which sets the author name and email
# 

source $DOTFILES/setup_common.sh

set -e

if ! [ -f git/gitconfig.local.symlink ]; then
	echo "Setting up gitconfig"

	# See https://help.github.com/articles/caching-your-github-password-in-git/ 
	git_credential="cache"
	if [ "$(uname -s)" == "Darwin" ]; then
		git_credential="osxkeychain"
	fi

	default_authorname="Matthew Edwards"
	user " - What is your Git author name? [$default_authorname]"
	read -e git_authorname

	default_authoremail="mje-nz@users.noreply.github.com"
	user " - What is your Git author email? [$default_authoremail]"
	read -e git_authoremail

	sed -e "s/AUTHORNAME/${git_authorname:-$default_authorname}/g" -e "s/AUTHOREMAIL/${git_authoremail:-$default_authoremail}/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.template > git/gitconfig.local.symlink

	success "Set up gitconfig"
fi

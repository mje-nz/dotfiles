#!/usr/bin/env bash
#
# Set up a file to include into .gitconfig which sets the author name and email

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"


if ! [ -f "$HOME/.gitconfig.local.symlink" ]; then
	echo "Setting up gitconfig"

	# See https://help.github.com/articles/caching-your-github-password-in-git/
	git_credential="cache"
	if [ "$(uname -s)" == "Darwin" ]; then
		git_credential="osxkeychain"
	fi

	prompt "What is your Git author name?" "Matthew Edwards" git_authorname
	prompt "What is your Git author email?" "mje-nz@users.noreply.github.com" git_authoremail
	# shellcheck disable=2154
	sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.template > git/gitconfig.local.symlink

	success "Set up gitconfig"
fi

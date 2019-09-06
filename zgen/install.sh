#!/usr/bin/env bash
#
# Based on https://github.com/unixorn/zsh-quickstart-kit/blob/master/zsh/.zgen-setup

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"

if [ ! -f ~/.zgen/zgen.zsh ]; then
	pushd ~
	echo "Installing zgen"
	git clone https://github.com/tarjoilija/zgen.git .zgen
	popd

	success "Installed zgen"
fi

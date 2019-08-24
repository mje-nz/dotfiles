#!/bin/sh

# Clone zsh-autosuggestions -- it uses submodules so I can't add it as a subrepo
if [ ! -d thirdparty/zsh-autosuggestions.noexec ]; then
	info "Checking out zsh-autosuggestions"
	git clone --recursive git://github.com/zsh-users/zsh-autosuggestions thirdparty/zsh-autosuggestions.noexec
fi

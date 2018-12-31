#!/bin/sh
# Clone zsh-autosuggestions -- it uses submodules so I can't add it as a subrepo
if [ ! -d thirdparty/zsh-autosuggestions.noexec ]; then
	git clone --recursive git://github.com/zsh-users/zsh-autosuggestions thirdparty/zsh-autosuggestions.noexec
fi

# Run fzf installer and move generated rc file
if [ ! -f thirdparty/fzf.zsh ]; then
	thirdparty/fzf.noexec/install --key-bindings --completion --no-update-rc
	mv ~/.fzf.zsh thirdparty/fzf.zsh
	mv ~/.fzf.bash thirdparty/fzf.bash
fi

#!/usr/bin/bash
# (shebang is only for shellcheck)

if type pyenv &> /dev/null; then
	eval "$(pyenv init -)"
fi

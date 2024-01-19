#!/usr/bin/bash
# (shebang is only for shellcheck)

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"
if type pyenv &> /dev/null; then
	eval "$(pyenv init -)"
fi

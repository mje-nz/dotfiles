#!/usr/bin/zsh

# Load Angular CLI autocompletion.

if command -v ng >/dev/null; then
    source <(ng completion script)
fi

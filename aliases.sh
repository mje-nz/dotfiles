# sh/bash/zsh aliases
#
# This is a separate file so that under zsh it can be sourced after loading
# oh-my-zsh to override omz aliases.

if command -v eza >/dev/null; then
    alias exa="eza"
fi
if command -v exa >/dev/null; then
    # Aliases for ls
    alias l="exa --classify"
    alias lsa="l"
    alias la="l --all"
    alias ll="l --long --header --git"
    alias lal="ll --all"
    # TODO: why don't the aliases work in here?
    tree () { exa --classify --tree --colour=always "$@" | less; }
    treel () { exa --classify --long --header --git --tree --colour=always "$@" | less; }
fi

# In case I want to use actual ls
if ls --color > /dev/null 2>&1; then
    # GNU `ls`
    alias ls="command ls --color -Gh"
else
    # macOS `ls`
    alias ls="command ls -Gh"
fi

# holman's git aliases
alias gp='git push origin HEAD'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'

# My git aliases
alias glog="git log --graph --format='%C(auto)%h %s%d %C(dim yellow)(%C(blue)%an%C(yellow), %C(green)%cr%C(yellow))%Creset'"
alias gref="git better-reflog"
alias gd='git dsf'
alias gdt='git difftool'
alias gpf='git push --force-with-lease'
alias gacpf='gaa && gc --amend --no-edit && gpf'
alias gdc='git diff --cached'

# Fast file copies
# Based on https://gist.github.com/KartikTalwar/4393116
# Cipher list from https://hihn.org/post/openssh-ciphers-performance-benchmark/
alias rcp='rsync -aHAXxv --numeric-ids --no-i-r --info=progress2 -e "ssh -T -c chacha20-poly1305@openssh.com,aes192-cbc -o Compression=no -x"'

# From oh-my-zsh/common-aliases
alias dud="du -d 1 -h"

# Terraform
alias tfos='tf output'
alias tfo='tfos -raw'

# Other aliases
alias ag='ag --pager="less"'
alias bh='bat --line-range :10'
alias i="ipython3"
alias shellcheck="shellcheck --color=always"
alias dd="dd status=progress"
alias po="popd"
alias pu="pushd"
alias dco="docker compose"
alias dig="dig +ttlunits"

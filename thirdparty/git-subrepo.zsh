# Enable git-subrepo

# Currently (2020-11-14), the bundled rc file breaks zsh with something related
# to https://github.com/ingydotnet/git-subrepo/issues/183
export GIT_SUBREPO_ROOT=$DOTFILES/thirdparty/git-subrepo
export PATH=$GIT_SUBREPO_ROOT/lib:$PATH
export MANPATH=$GIT_SUBREPO_ROOT/man:$MANPATH
fpath=($GIT_SUBREPO_ROOT/share/zsh-completion $fpath)

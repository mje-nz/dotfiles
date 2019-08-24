# zgen setup
# 
# Note that this must run before theme.zsh, or it will steamroll its changes
# 
# Based on https://github.com/unixorn/zsh-quickstart-kit/blob/master/zsh/.zgen-setup


load-plugin-list() {
  echo "Initialising zgen"

  zgen oh-my-zsh

  # If zsh-syntax-highlighting is bundled after zsh-history-substring-search,
  # they break, so get the order right.
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  # Warn you when you run a command that you've got an alias for
  zgen load djui/alias-tips

  # Add "git open" command
  zgen load paulirish/git-open

  # Load some oh-my-zsh plugins
  zgen oh-my-zsh plugins/colored-man-pages
  zgen oh-my-zsh plugins/docker
  zgen oh-my-zsh plugins/fancy-ctrl-z
  zgen oh-my-zsh plugins/fd
  zgen oh-my-zsh plugins/fzf
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/osx
  zgen oh-my-zsh plugins/pip
  zgen oh-my-zsh plugins/python

  # Load more completion files for zsh from the zsh-lovers github repo
  zgen load zsh-users/zsh-completions src

  # Save it all to init script
  zgen save
}


# This comes from https://stackoverflow.com/questions/17878684/best-way-to-get-file-modified-time-in-seconds
# This works on both Linux with GNU fileutils and OS X with BSD stat.
get_file_modification_time() {
  modified_time=$(stat -c %Y "$1" 2> /dev/null)
  if [ "$?" -ne 0 ]; then
    modified_time=$(stat -f %m "$1" 2> /dev/null)
    if [ "$?" -ne 0 ]; then
      modified_time=$(date -r "$1" +%s 2> /dev/null)
      [ "$?" -ne 0 ] && modified_time=0
    fi
  fi
  echo "$modified_time"
}


# Disable oh-my-zsh's updater
export DISABLE_AUTO_UPDATE=true

# Only check for updates every 4 weeks
export ZGEN_PLUGIN_UPDATE_DAYS=28
export ZGEN_SYSTEM_UPDATE_DAYS=28

source ~/.zgen/zgen.zsh

# Check if there's an init.zsh file for zgen and generate one if not.
if ! zgen saved; then
  load-plugin-list
fi

# If this file is newer than init.zsh, regenerate init.zsh
if [ $(get_file_modification_time $0) -gt $(get_file_modification_time ~/.zgen/init.zsh) ]; then
  echo "Zgen config updated"
  load-plugin-list
fi

# Alias for man-preview in osx plugin
alias manp=man-preview

# Remove some aliases from oh-my-zsh
unalias _
unalias ls
unalias lsa
# This one's possibly gone now
unalias please >/dev/null 2>&1

# Remove some aliases from from oh-my-zsh git plugin
unalias g
unalias gca
unalias gca!

# Tweak to prevent slow pasting of long strings 
# See https://github.com/zsh-users/zsh-syntax-highlighting/issues/295
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# Autoload some built-in functions
autoload -Uz zcalc zmv

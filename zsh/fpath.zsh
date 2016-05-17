# Add functions/ to fpath and autoload all files in it
fpath=($DOTFILES/functions $fpath)
autoload -U $DOTFILES/functions/*(:t)
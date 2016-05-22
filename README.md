# MJE dotfiles

My dotfiles.

## topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell. Anything with an extension of `.symlink` will get symlinked without extension and with a dot prepended to their name into `$HOME` when you run `setup`.

## cross-platform

Mac OSX-only dotfiles and scripts go in the osx-only/ subfolder, and the same for the linux-only subfolder.  **TODO** Figure out how to handle linking things into .config/ on Linux.

## components

There's a few special files in the hierarchy.

- **Brewfile**: This is a list of applications for [Homebrew](http://brew.sh) to   install. Might want to edit this file before running any initial setup.
- **<topic>/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **<topic>/install.sh**: Any file name `install.sh` in executed when `setup` runs.
- **<topic>/\*.symlink**: Any files ending in `*.symlink` get symlinked into your `$HOME`. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `setup`.

## pre-install

For Ubuntu:
sudo apt-get install zsh zsh-common

## install

Run this:

```sh
git clone https://github.com/MatthewJEdwards/dotfiles.git ~/.dotfiles
~/.dotfiles/setup
```

This will symlink the appropriate files from `.dotfiles` into your home directory. Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`, which sets up a few paths that'll be different on your particular machine.

## thanks

Based on [holman/dotfiles](https://github.com/holman/dotfiles).

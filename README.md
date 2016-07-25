# MJE dotfiles

My dotfiles.

## topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell. Anything with an extension of `.symlink` will get symlinked without extension and with a dot prepended to their name into `$HOME` when you run `setup`.

## cross-platform

Mac OSX-only dotfiles and scripts go in the osx-only/ subfolder, and the same for the linux-only subfolder.  **TODO** Figure out how to handle linking things into .config/ on Linux.

## components

There's a few special files in the hierarchy.

- **<topic>/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **<topic>/\*.1.zsh**: Any files ending in `.1.zsh` get loaded first, followed by `.2.zsh` and so on, then the rest.
- **<topic>/install.sh**: Any file name `install.sh` in executed when `setup` runs.
- **<topic>/\*.symlink**: Any files ending in `*.symlink` get symlinked into your `$HOME`.  This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `setup`.

## install

Run this:

```sh
git clone https://github.com/MatthewJEdwards/dotfiles.git ~/.dotfiles
~/.dotfiles/setup
```

This will symlink the appropriate files from `.dotfiles` into your home directory. Everything is configured within `~/.dotfiles`.

Before you run setup, you should probably check everything out and tweak stuff.  On OSX, you may not want to install Homebrew and my list of packages.  The install script is `osx-only/homebrew/install.sh` and the list of packages is `osx-only/homebrew/Brewfile`.  On Linux, you may not want to install my list of packages and change your login shell to zsh.  This is done in `linux-only/install.sh`.

## thanks

Based on [holman/dotfiles](https://github.com/holman/dotfiles).

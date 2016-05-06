# MJE dotfiles

My dotfiles.

**TODO:** Set up code folder

## topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell. Anything with an extension of `.symlink` will get symlinked without extension and with a dot prepended to their name into `$HOME` when you run `script/bootstrap`.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew](http://brew.sh) to   install. Might want to edit this file before running any initial setup.
- **<topic>/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **<topic>/install.sh**: Any file name `install.sh` in executed when `dot` runs.
- **<topic>/path.zsh**: Any file named `path.zsh` is loaded first and is expected to setup `$PATH` or similar.
- **<topic>/completion.zsh**: Any file named `completion.zsh` is loaded last and is expected to setup autocomplete.
- **<topic>/\*.symlink**: Any files ending in `*.symlink` get symlinked into your `$HOME`. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `script/bootstrap`.

## pre-install

For Ubuntu:
sudo apt-get install zsh zsh-common

## install

Run this:

```sh
git clone https://github.com/MatthewJEdwards/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory. Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`, which sets up a few paths that'll be different on your particular machine.

`bin/dot` is a simple script that installs/updates Homebrew and runs any `install.sh` file. Tweak this script, and occasionally run `dot` from time to time to keep your environment fresh and up-to-date.

## thanks

Based on [holman/dotfiles](https://github.com/holman/dotfiles).

# MJE dotfiles

My dotfiles.

## install

The installer will symlink the appropriate files from `.dotfiles` into your home directory, and optionally install a bunch of stuff.
Everything is configured within `~/.dotfiles`.
Before you run `setup` you should check everything out, or you'll end up with exactly my setup.

You should probably restart afterwards to be safe.

### macOS

From a fresh install of macOS:

```sh
xcode-select --install
git clone https://github.com/mje-nz/dotfiles.git ~/.dotfiles
~/.dotfiles/setup
```

### linux install

From a fresh install of Ubuntu or Mint:

```sh
sudo apt install git
git clone https://github.com/mje-nz/dotfiles.git ~/.dotfiles
~/.dotfiles/setup
```

## topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell. Anything with an extension of `.symlink` will get symlinked without extension and with a dot prepended to their name into `$HOME` when you run `setup`.

## cross-platform

MacOS-only dotfiles and scripts go in the osx-only/ subfolder, and the same for the linux-only subfolder.  **TODO** Figure out how to handle linking things into .config/ on Linux.

For macOS-specific info like GUI applications and settings I change manually, see [osx-only/Readme.md](osx-only/Readme.md).

## components

There's a few special files in the hierarchy.

- **&lt;topic&gt;/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **&lt;topic&gt;/\*.?.zsh**: Any files ending in `.1.zsh` get loaded first, followed by `.2.zsh` and so on, then the rest.
- **&lt;topic&gt;/install.sh**: Any file name `install.sh` in executed when `setup` runs.
- **&lt;topic&gt;/\*.symlink**: Any files ending in `*.symlink` get symlinked into your `$HOME`.  This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `setup`.



## thanks

Based on [holman/dotfiles](https://github.com/holman/dotfiles).
I also took inspiration from [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) and [nikitavoloboev/my-mac-os](https://github.com/nikitavoloboev/my-mac-os).

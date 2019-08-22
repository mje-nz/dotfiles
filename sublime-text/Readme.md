# Sublime Text 3 settings
The `setup` script will install Sublime Text, and if it wasn't already installed then it will also replace the ST config directory with a symlink to this directory.
Otherwise, you'll have to manually merge your settings into here and then run:

```
rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
ln -s $(pwd) ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
```

Once you [install Package Control](https://packagecontrol.io/installation), it will automatically install the packages specified here.

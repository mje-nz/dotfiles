Git LaTeXdiff
=============

`git-latexdiff` is a tool to graphically visualize differences between
different versions of a LaTeX file. Technically, it is a wrapper
around [git](http://git-scm.com) and
[latexdiff](https://www.ctan.org/pkg/latexdiff).

If your LaTeX source is split accross several `*.tex` files,
`git-latexdiff` can call
[latexpand](https://www.ctan.org/pkg/latexpand) to expand it before
running `latexdiff` (this usually works better than using `latexdiff
--flatten`).

To get the manpage (needed to get `git-latexdiff --help` to work), you
need the `a2x` tool from the asciidoc package.

Installation
------------

### Using the Makefile ###

To install `git-latexdiff` in Git's exec-path and generate and install
a manpage, run this command from the root directory of
`git-latexdiff`'s distribution:

    make install

If Git was installed as root, you will need to run this command as
root, for example using:

    sudo make install

If it fails, you may try installing only the script (you can still
read the documentation using `git latexdiff -h`):

    make install-bin

Once the script `git-latexdiff` and the manpage `git-latexdiff.1` are
installed, you're ready to go (no configuration file to edit).

### Manual installation ###

A simple way to install `git-latexdiff` is to copy the file
`git-latexdiff` anywhere in your `$PATH` (e.g. in `/usr/local/bin`,
run `echo $PATH` get the list) or in Git's exec-path (run `git
--exec-path` to get it).

To get the documentation, you need to generate it:

    make git-latexdiff.1

and then copy `git-latexdiff.1` in your man-path (run `git --man-path`
to get the location).

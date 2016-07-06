gitexecdir = ${shell git --exec-path}
gitmanpath = ${shell git --man-path}

-include ./config.mak

ifndef BASH_PATH
	BASH_PATH = /bin/bash
endif

BASH_PATH_SQ = $(subst ','\'',$(BASH_PATH))
GIT_LATEXDIFF_VERSION=${shell git describe --tags HEAD 2>/dev/null || \
			 echo unknown-version}
gitexecdir_SQ = $(subst ','\'',$(gitexecdir))
gitmanpath_SQ = $(subst ','\'',$(gitmanpath))

SCRIPT=git-latexdiff

.PHONY: help install-bin install-doc install
help:
	@echo 'This is the help target of the Makefile. Current configuration:'
	@echo '  gitexecdir = $(gitexecdir_SQ)'
	@echo '  gitmanpath = $(gitmanpath_SQ)'
	@echo '  BASH_PATH = $(BASH_PATH_SQ)'
	@echo '  git-latexdiff version: $(GIT_LATEXDIFF_VERSION)'
	@echo 'Run "$(MAKE) install" to install $(SCRIPT) in gitexecdir.'
	@echo 'Other available targets'
	@echo '  - make git-latexdiff.1: generate the manpage without installing'
	@echo '  - make install-bin: install only the script'
	@echo '  - make install-doc: install only the man page'

install: install-bin install-doc

install-bin:
	sed -e '1s|#!.*/bash|#!$(BASH_PATH_SQ)|' \
	    -e 's|@GIT_LATEXDIFF_VERSION@|$(GIT_LATEXDIFF_VERSION)|' \
	        $(SCRIPT) > '$(gitexecdir_SQ)/$(SCRIPT)'
	chmod 755 '$(gitexecdir_SQ)/$(SCRIPT)'

git-latexdiff.txt: git-latexdiff git-latexdiff.txt.header
	( cat git-latexdiff.txt.header ; \
	  printf '%s\n' ------------ ; \
	  ./git-latexdiff --help ; \
	  ./git-latexdiff --help-examples ; \
	  printf '%s\n' ------------ ) > $@

git-latexdiff.1: git-latexdiff.txt
	a2x --doctype manpage --format manpage $<

install-doc: git-latexdiff.1
	cp $< $(gitmanpath_SQ)/man1/

#!/bin/bash
# 
# Based on https://github.com/unixorn/zsh-quickstart-kit/blob/master/zsh/.zgen-setup

if [ ! -f ~/.zgen/zgen.zsh ]; then
  pushd ~
  echo "Installing zgen"
  git clone https://github.com/tarjoilija/zgen.git .zgen
  popd
fi

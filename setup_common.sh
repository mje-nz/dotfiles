#!/usr/bin/env bash
# (sheband is only for shellcheck)
# Common functions for setup script and install.sh scripts

info () {
  printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ''
  exit 1
}

prompt_prefix=$'\r  [ \033[0;33m??\033[0m ]'

# Prompt user for input
# shellcheck disable=2034
prompt_result=
prompt () {
  local message=$1 default=$2 output=${3:-prompt_result} result=
  if [[ "$default" ]]; then
    message="$message [$default]"
  fi

  echo "$prompt_prefix $message: "
  read -r result || true
  if [[ "$result" ]]; then
    eval "$output=\"$result\""
  else
    eval "$output=\"$default\""
  fi
}

# Prompt user for yes/no (default yes)
# https://stackoverflow.com/a/1885534
yesno() {
  local message=$1 result=
  echo -n "$prompt_prefix $1 [Y/n]: "
  read -n 1 -r action || true
  echo
  [[ ! $action || $action =~ ^[Yy]$ ]]
  return $?
}

# Prompt user for yes/no (default no)
noyes() {
  local message=$1 result=
  echo -n "$prompt_prefix $1 [y/N]: "
  read -n 1 -r action || true
  echo
  [[ $action =~ ^[Yy]$ ]]
  return $?
}

# Soft-link a file into home directory
link_file () {
  local src=$1 dst=$2

  local overwrite=
  local backup=
  local skip=
  local action=

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then
    # Dest exists

    if [ -z "$overwrite_all" ] && [ -z "$backup_all" ] && [ -z "$skip_all" ]; then
      # No default behaviour

      if [ "$(readlink "$dst")" == "$src" ]; then
        # Already linked
        skip=true;
      else
        echo "$prompt_prefix File already exists: $dst ($(basename "$src")), what do you want to do?"
        printf "         [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -r -n 1 action || true
        echo

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            skip=true;;
        esac
      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == true ]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == true ]; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == true ]; then
      info "skipped $src"
    fi
  fi

  if [ "$skip" != true ]; then
    ln -s "$1" "$2" || fail "Could not link $1 to $2"
    success "linked $1 to $2"
  fi
}

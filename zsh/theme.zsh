# Based on tjkirch plus the username hiding from agnoster
# Git status based on https://gist.github.com/joshdick/4415470
# -- Shows number of commits to push/pull, merge status, traffic lights for untracked/modified/staged
# 
# TODO: Tweak colours
# TODO: Asynchronous git update as in pure
# TODO: Execution time of last command if long


autoload -U colors && colors # Enable colors in prompt

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_PREFIX="%{$fg[green]%}(%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%})%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}NUM↑%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}NUM↓%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  # Add a space after ahead/behind if present
  if [[ -n $GIT_STATE ]]; then
    GIT_STATE="$GIT_STATE "
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_STATE"
  fi

}

# If inside a Git repository, print its branch and state
prompt_git_block() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)} $(parse_git_state)$GIT_PROMPT_SUFFIX"
}

# Show username if not the default user
prompt_user_block() {
	local user=`whoami`

	if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
		echo "%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}: " 
	fi
}

# Red # for root, $ otherwise
prompt_char() {
	echo '%(!.%{$fg[red]%}#%{$reset_color%}.$)'
}

prompt_jobs_block() {
	echo '%(1j.%{$fg[gray]%}[%j+] %{$reset_color%}.)'
}

PROMPT='$(prompt_user_block)%{$fg_bold[blue]%}%~%{$reset_color%} $(prompt_git_block)
%_%(?..%{$fg[red]%}→%? %{$reset_color%})%(1j.%{$fg[yellow]%}[%j+] %{$reset_color%}.)$(prompt_char) '

RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'












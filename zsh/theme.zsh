# Based on tjkirch  (https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/tjkirch.zsh-theme)
# Username hiding from agnoster  (https://gist.github.com/agnoster/3712874)
# Git status based on https://gist.github.com/joshdick/4415470
# -- Shows number of commits to push/pull, merge status, traffic lights for untracked/modified/staged
# Execution time from pure  (https://github.com/sindresorhus/pure)
# 
# TODO: Tweak colours
# TODO: Asynchronous git update as in pure
# TODO: Break $PROMPT into functions more effectively


autoload -U colors && colors # Enable colors in prompt

# Display user unless it is this user
DEFAULT_USER=${DEFAULT_USER:-Matthew}

# Display execution time if greater than this value (in seconds)
PROMPT_CMD_MAX_EXEC_TIME=${PROMPT_CMD_MAX_EXEC_TIME:-5}





###############################################################################
#                                      Git                                    #
###############################################################################

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
# TODO: Handle detached HEAD as in https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407#.heha3mnip
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

  # Merge indicator and traffic light
  local GIT_STATE_2
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE_2=$GIT_STATE_2$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE_2=$GIT_STATE_2$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE_2=$GIT_STATE_2$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE_2=$GIT_STATE_2$GIT_PROMPT_STAGED
  fi
  
  # Add space to first part if second part is not empty
  if [[ -n $GIT_STATE && -n $GIT_STATE_2 ]]; then
  	GIT_STATE="$GIT_STATE "
  fi

  # Concatenate first and second part, then print prepended with a space if not empty
  GIT_STATE="$GIT_STATE$GIT_STATE_2"
  if [[ -n $GIT_STATE ]]; then
    echo " $GIT_STATE"
  fi

}

# If inside a Git repository, print its branch and state
prompt_git_block() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$(parse_git_state)$GIT_PROMPT_SUFFIX"
}




###############################################################################
#                                Execution time                               #
###############################################################################

# turns seconds into human readable time
# 165392.5 => 1d21h56m32.5s
# Based on https://github.com/sindresorhus/pretty-time-zsh
prompt_human_time_to_var() {
	local human=" " total_seconds=$1 var=$2
	integer days=$(( total_seconds / 60 / 60 / 24 ))
	integer hours=$(( total_seconds / 60 / 60 % 24 ))
	integer minutes=$(( total_seconds / 60 % 60 ))
	typeset -F seconds=$(( total_seconds % 60 ))
	(( days > 0 )) && human+="${days}d"
	(( hours > 0 )) && human+="${hours}h"
	(( minutes > 0 )) && human+="${minutes}m"
	human+="$(printf '%.1fs' $seconds)"

	# store human readable time in variable as specified by caller
	typeset -g "${var}"="${human}"
}

# stores (into prompt_cmd_exec_time) the exec time of the last command if set threshold was exceeded
prompt_check_cmd_exec_time() {
	# Float variable
	typeset -F elapsed
	(( elapsed = EPOCHREALTIME - ${prompt_cmd_timestamp:-$EPOCHREALTIME} ))
	prompt_cmd_exec_time=
	(( elapsed > $PROMPT_CMD_MAX_EXEC_TIME )) && {
		prompt_human_time_to_var $elapsed "prompt_cmd_exec_time"
	}
}

prompt_exec_time_block() {
	if [[ -n "$prompt_cmd_exec_time" ]]; then
		echo "⟳$prompt_cmd_exec_time "
	fi
}

prompt_preexec() {
	prompt_cmd_timestamp=$EPOCHREALTIME
}

prompt_precmd() {
	prompt_check_cmd_exec_time
}

zmodload zsh/datetime
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_precmd
add-zsh-hook preexec prompt_preexec



###############################################################################
#                               Everything else                               #
###############################################################################

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
%_%(?..%{$fg[red]%}→%? %{$reset_color%})%(1j.%{$fg[yellow]%}[%j+] %{$reset_color%}.)$(prompt_exec_time_block)$(prompt_char) '





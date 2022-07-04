# Auto-update SSH_AUTH_SOCK etc when in a tmux session
# See https://www.babushk.in/posts/renew-environment-tmux.html
if [ -n "$TMUX" ]; then
  function tmux_update_env {
	  eval "$(tmux show-environment -s)"
  }
else
  function tmux_update_env { true; }
fi

autoload -Uz  add-zsh-hook
add-zsh-hook preexec tmux_update_env

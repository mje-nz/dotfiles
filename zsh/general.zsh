# General zsh settings

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Default user for theme
DEFAULT_USER=Matthew

# Override builtin fg and bg to add bash compatibility (i.e. fg 1 instead of fg %1)
fg() {
	if [[ "$*" =~ ^[0-9]+$ ]]; then 
		builtin fg %"$*"
	else 
		builtin fg "$@"
	fi 
}
bg() {
	if [[ "$*" =~ ^[0-9]+$ ]]; then 
		builtin bg %"$*"
	else 
		builtin bg "$@"
	fi 
}

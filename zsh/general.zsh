# General zsh settings

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Override builtin fg, bg and kill to add bash compatibility (i.e. fg 1 instead of fg %1)
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
kill() {
	if [[ "$*" =~ ^[0-9]+$ ]]; then 
		builtin kill %"$*"
	else 
		builtin kill "$@"
	fi 
}

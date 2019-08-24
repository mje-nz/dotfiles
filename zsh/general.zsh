# General zsh settings

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE

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

# Global aliases from oh-my-zsh/common-aliases
# e.g. "env G PATH" expands to "env | grep PATH"
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| more"
alias -g LL="2>&1 | less"
alias -g N="2> /dev/null"
alias -g NN="> /dev/null 2>&1"

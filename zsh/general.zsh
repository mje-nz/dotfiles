# General zsh settings

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE

# Autoload some built-in functions
autoload -Uz zcalc zmv


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


# Tweak to prevent slow pasting of long strings
# See https://github.com/zsh-users/zsh-syntax-highlighting/issues/295
zstyle ':bracketed-paste-magic' active-widgets '.self-*'


# fzf setup
# https://github.com/sharkdp/bat/issues/357#issuecomment-429649196
# https://github.com/sharkdp/fd#using-fd-with-fzf

# fzf default options: enable colours
export FZF_DEFAULT_OPTS="--ansi"
# fzf ctrl+T options: use bat for preview, with frame and colour but without
# git decorations, showing only first 300 lines
FZF_PREVIEW_OPTS="--preview-window 'right:60%'"
FZF_BAT_OPTS="--color=always --style=header,grid --line-range :300"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW_OPTS --preview 'bat $FZF_BAT_OPTS {}'"

# Use fd for file list instead of file, showing only files, following symlinks,
# showing hidden files except .git and anything in .gitignore
FZF_FD_OPTS="--color=always --follow --hidden --exclude .git"
export FZF_DEFAULT_COMMAND="fd --type file $FZF_FD_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Basically ctrl+T but including folders
alias f="fd $FZF_FD_OPTS | fzf $FZF_PREVIEW_OPTS --preview 'bat $FZF_BAT_OPTS {} 2>/dev/null'"


# Exclude file types from completions for specific commands (which don't have custom completions)
# (^ is from EXTENDED_GLOB, which is always on inside completion functions)
LATEX_GENERATED="aux|bbl|blg|fdb_latexmk|fls|glg-abr|glo-abr|gls-abr|ist|slg|slo|sls|pytxcode|tdo|toc"
compdef '_files -g "^*.('"$LATEX_GENERATED"'|pdf)"' subl
compdef '_files -g "^*.('"$LATEX_GENERATED"'|log|tex)"' o
compdef '_files -g "*.py"' black
compdef '_files -g "*.py"' isort

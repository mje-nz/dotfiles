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

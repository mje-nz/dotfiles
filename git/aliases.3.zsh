# Must run after zgen unaliases gdt

# holman's git aliases
alias gp='git push origin HEAD'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'

# Override oh-my-zshw gpf! to work with my safer-git
alias gpf!='git push --force --force'

# Mine
alias glog="git log --graph --format='%C(auto)%h %s%d %C(dim yellow)(%C(blue)%an%C(yellow), %C(green)%cr%C(yellow))%Creset'"
alias gref="git better-reflog"
alias gd='git dsf'
alias gdt='git difftool'
alias gpf='git push --force-with-lease'
alias gacpf='gaa && gc --amend --no-edit && gpf'
alias gdc='git diff --cached'

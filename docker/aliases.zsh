alias db='docker build'
alias dr='docker run'
alias dri='docker run --rm --interactive --tty --init'
alias drx='dri -v "/tmp/.X11-unix:/tmp/.X11-unix" -e DISPLAY=$DISPLAY'

alias db='docker build'
alias dr='docker run'

# Run a container in interactive mode, with a terminal attached, appropriate signal
# handling, and the timezone set, and then clean it up afterwards
alias dri='docker run --rm --interactive --tty --init --env TZ=Pacific/Auckland'

# Also mount the current working directory into the container as /working
alias driw='dri -v $(pwd):/working'

# Also pass in GPUs
alias drig='dri --gpus=all'

# Both (mnemonic "docker run interactive seeo")
alias dris='dri -v $(pwd):/working --gpus=all'

#Run a cuntainer with X forwarding enabled
alias drx='dri --volume "/tmp/.X11-unix:/tmp/.X11-unix" --env DISPLAY=$DISPLAY'

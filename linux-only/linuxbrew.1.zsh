# Set up linuxbrew paths
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Un-trample pkg-config path
export PKG_CONFIG_PATH="$(/home/linuxbrew/.linuxbrew/bin/pkg-config --variable pc_path pkg-config)":"$(/usr/bin/pkg-config --variable pc_path pkg-config)"

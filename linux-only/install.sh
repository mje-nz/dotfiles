#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"


if [ "$(whoami)" == "root" ]; then
	# Handle being root
	function sudo() { "$@"; }
fi

if yesno "Install zsh, git, tree, and ag (will use sudo)?"; then
	info "Installing packages"

	# Install my usual packages
	sudo apt-get install -y zsh zsh-common git tree silversearcher-ag

	success "Installed packages"
fi

if [ "$SHELL" != "$(command -v zsh)" ]; then
	if yesno "Change shell to zsh (will prompt for password)?"; then
		if chsh -s "$(command -v zsh)"; then
			success "You will need to log out and in again"
		else
			echo "Failed to change shell, continuing"
		fi
	fi
fi

if noyes "Install caps2esc (will use sudo)?"; then
	info "Installing dependencies"
	sudo apt-get install -y build-essential cmake libevdev-dev libudev-dev libyaml-cpp-dev libboost-dev
	info "Building and installing interception tools"
	pushd "$(mktemp -d)" > /dev/null
	info "(in temp directory $(pwd))"
	git clone https://gitlab.com/interception/linux/tools.git
	cd tools
	cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
	cmake --build build
	sudo cmake --build build --target install
	popd > /dev/null

    info "Building and installing caps2esc"
	pushd "$(mktemp -d)" > /dev/null
	info "(in temp directory $(pwd))"
	git clone https://gitlab.com/interception/linux/plugins/caps2esc.git
	cd caps2esc
	cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
	cmake --build build
	sudo cmake --build build --target install
	popd > /dev/null
	info "Creating and starting udevmon service"
	sudo cp "$HOME/.dotfiles/linux-only/udevmon.service" /etc/systemd/system/
	sudo cp "$HOME/.dotfiles/linux-only/udevmon.yaml" /etc/
	sudo systemctl enable udevmon
	sudo systemctl start udevmon
	success "Installed caps2esc"
fi

if yesno "Install Homebrew and tools?"; then
	if ! command -v brew >/dev/null 2>&1; then
		# The install script doesn't work as root, so do a manual install
		info "Installing Homebrew..."
		sudo apt-get install build-essential curl file git
		git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew
		mkdir /home/linuxbrew/.linuxbrew/bin
		ln -s ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		# Path setup is in linuxbrew.zsh (haven't bothered for bash)
	fi

	info "Installing exa, fzf, tmux, nano, cheat, and git-filter-repo..."
	brew install exa fzf tmux nano cheat git-filter-repo
fi

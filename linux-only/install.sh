#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"


if [ "$(whoami)" == "root" ]; then
	# Handle being root
	function sudo() { "$@"; }
fi

if yesno "Install system packages (will use sudo)?"; then
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
		info "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		# Path setup is in linuxbrew.zsh (haven't bothered for bash)
	fi

	info "Installing Homebrew packages..."
	brew install bat cheat eza fzf git git-filter-repo nano tfenv tmux
fi

if  yesno "Install pyenv and Pythons (will use sudo)?"; then
	if ! command -v pyenv >/dev/null 2>&1; then
		info "Installing pyenv..."
		# Don't install with Homebrew, there's all sorts of weird bugs
		curl https://pyenv.run | bash
	fi

	info "Installing Python build deps..."
	sudo apt-get install libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

	info "Installing Pythons..."
	pyenv install 3.8 3.9 3.10 3.11 3.12
fi

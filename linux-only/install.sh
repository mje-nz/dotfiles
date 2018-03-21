#!/usr/bin/env bash

source $DOTFILES/setup_common.sh
set -e

yesno() {
	local message=$1
	local doit=0 action=
	user "$message [Y]/n"
	
	read -n 1 action
	case "$action" in
	  Y )
		doit=0;;
	  n )
		doit=1;;
	  * )
		;;
	esac
	
	return $doit
}

if yesno "Install zsh, git, tree, ag and cheat (will use sudo)?"; then
	echo "Installing packages"

	# Install my usual packages
	sudo apt-get install zsh zsh-common git tree silversearcher-ag python-pip
	sudo pip install cheat
	
	success "Installed packages"
fi

if [ "$SHELL" != $(which zsh) ]; then
	if yesno "Change shell to zsh (will prompt for password)?"; then
		chsh -s $(which zsh)
	fi
fi

if yesno "Install caps2esc (will use sudo)?"; then
	echo "Installing dependencies"
	sudo apt-get install build-essential cmake libevdev-dev libyaml-cpp-dev
	echo "Building and installing interception tools"
	pushd $(mktemp -d) > /dev/null
	echo "(in temp directory $(pwd)"
	git clone https://gitlab.com/interception/linux/tools.git
	cd tools
	mkdir build
	cd build
	cmake ..
	make
	sudo make install
	popd > /dev/null
	echo "Building and installing caps2esc"
	pushd $(mktemp -d) > /dev/null
	echo "(in temp directory $(pwd)"
	git clone https://gitlab.com/interception/linux/plugins/caps2esc.git
	cd caps2esc
	git apply $DOTFILES/linux-only/caps2esc.patch
	mkdir build
	cd build
	cmake ..
	make
	sudo make install
	popd > /dev/null
	echo "Creating and starting udevmon service"
	sudo tee "/etc/udevmon.yaml" > /dev/null <<EOF
- JOB: "intercept -g \$DEVNODE | caps2esc | uinput -d \$DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK]
EOF
	sudo tee "/etc/systemd/system/udevmon.service" > /dev/null <<EOF
[Unit]
Description=udevmon
After=systemd-user-sessions.service

[Service]
ExecStart=/usr/bin/nice -n -20 /usr/local/bin/udevmon -c /etc/udevmon.yaml

[Install]
WantedBy=multi-user.target
EOF
	sudo systemctl enable udevmon
	success "Installed caps2esc"
fi

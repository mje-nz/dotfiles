#!/usr/bin/env bash
# macOS settings
# Mostly from https://github.com/mathiasbynens/dotfiles/blob/master/.macos, which goes way too far

set -e

# shellcheck disable=SC1090
source "$DOTFILES/setup_common.sh"


if test "$(uname)" != "Darwin"; then
	fail "This install script is for macOS only."
fi

if noyes "Install macOS settings (will use sudo, and restart various applications)?"; then

	# Close any open System Preferences panes, to prevent them from overriding
	# settings we're about to change
	osascript -e 'tell application "System Preferences" to quit'

	# Ask for the administrator password upfront
	sudo -n true

	# Keep-alive: update existing sudo time stamp until the current process has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


	###############################################################################
	echo "General UI/UX"
	###############################################################################

	# Expand save panel by default
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

	# Expand print panel by default
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

	# Save to disk (not to iCloud) by default
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	# Allow apps from anywhere in Gatekeeper
	sudo spctl --master-disable

	# Reveal IP address, hostname, OS version, etc. when clicking the clock
	# in the login window
	sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

	# Disable Notification Center and remove the menu bar icon
	launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

	# Disable automatic capitalization
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

	# Disable automatic period substitution
	defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

	# Disable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	# Disable Mojave update notifications
	/usr/sbin/softwareupdate --reset-ignored > /dev/null
	/usr/sbin/softwareupdate --ignore "macOSInstallerNotification_GM" > /dev/null

	# Show Battery Percentage on the menu bar
	defaults write com.apple.menuextra.battery ShowPercent -string "YES"

	# Disable Spotlight suggestions in Look up (for speed)
	defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool true

	# TODO Show volume etc in the menu bar


	###############################################################################
	echo "App Store"
	###############################################################################

	# Disable downloading updates in the background
	sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -boolean FALSE


	###############################################################################
	echo "Trackpad, keyboard, sound, and input"
	###############################################################################

	# Enable tap to click for this user and for the login screen
	defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	# Enable key repeat
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 35

	# Play feedback when volume is changed
	defaults write -g com.apple.sound.beep.feedback -int 1

	# Enable App Exposé gesture
	defaults write com.apple.dock showAppExposeGestureEnabled -bool true

	# Disable acceleration for external mouse (use Mos to fix scrolling)
	defaults write -g com.apple.mouse.scaling -1


	###############################################################################
	echo "Finder"
	###############################################################################

	# Display full POSIX path as Finder window title
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	# Keep folders on top when sorting by name
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	# Show item info near icons on the desktop
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

	# Enable snap-to-grid for icons on the desktop and in other icon views
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	# TODO Doesn't work on HS
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

	# Increase grid spacing for icons on the desktop
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist

	# Show the ~/Library folder
	chflags nohidden ~/Library

	# Show the /Volumes folder
	sudo chflags nohidden /Volumes

	# Show icons for hard drives on the desktop
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true


	###############################################################################
	echo "Dock, Dashboard, and hot corners"
	###############################################################################

	# Set Dock position to left
	defaults write com.apple.dock orientation -string left

	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true

	# Set the icon size of Dock items to 45 pixels
	defaults write com.apple.dock tilesize -int 45

	# Make Dock icons of hidden applications translucent
	defaults write com.apple.dock showhidden -bool true

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Minimize windows into their application's icon
	defaults write com.apple.dock minimize-to-application -bool true

	# Don't automatically rearrange Spaces based on most recent use
	defaults write com.apple.dock mru-spaces -bool false


	###############################################################################
	echo "Safari & WebKit"
	###############################################################################

	# Enable the Develop menu and the Web Inspector in Safari
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

	# Add a context menu item for showing the Web Inspector in web views
	defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

	# Enable "Do Not Track"
	defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

	# Show the full URL in the address bar (note: this still hides the scheme)
	defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

	# Show status bar
	defaults write com.apple.Safari ShowOverlayStatusBar -boolean true

	# Safari opens with all windows from last session
	defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -boolean true


	###############################################################################
	echo "Terminal.app"
	###############################################################################
	# Install Molokai colour scheme and set as default
	pushd "$(dirname "$0")" > /dev/null
	profile="$(<terminal-profile.xml)"
	popd > /dev/null
	plutil -replace Window\ Settings.Molokai -xml "$profile" ~/Library/Preferences/com.apple.Terminal.plist
	defaults write com.apple.Terminal "Default Window Settings" -string "Molokai"
	defaults write com.apple.Terminal "Startup Window Settings" -string "Molokai"

	# Fix terminfo so dim works
	# https://unix.stackexchange.com/a/295765
	terminfo_file=$(mktemp)
	infocmp -1x xterm-256color > "$terminfo_file"
	echo "	dim=\E[2m," >> "$terminfo_file"
	echo "	sgr=%?%p9%t\E(0%e\E(B%;\E[0%?%p6%t;1%;%?%p5%t;2%;%?%p2%t;4%;%?%p1%p3%|%t;7%;%?%p4%t;5%;%?%p7%t;8%;m," >> "$terminfo_file"
	tic -x "$terminfo_file"
	rm "$terminfo_file"


	###############################################################################
	echo "Mail.app"
	###############################################################################
	# Show most recent message at the top
	defaults write com.apple.mail ConversationViewSortDescending -boolean true
	# Check for new mail automatically
	defaults write com.apple.mail AutoFetch -boolean true
	defaults write com.apple.mail PollTime -int -1
	# Automatically try sending later if outgoing server is unavailable
	defaults write com.apple.mail SuppressDeliveryFailure -boolean true


	###############################################################################
	echo "Sourcetree.app"
	###############################################################################
	defaults write com.torusknot.SourceTreeNotMAS agreedToUpdateConfig -bool false
	defaults write com.torusknot.SourceTreeNotMAS allowForcePush -bool true
	defaults write com.torusknot.SourceTreeNotMAS alwaysDisplayFullOutput -bool true
	defaults write com.torusknot.SourceTreeNotMAS analyticsHasAgreed -bool false
	defaults write com.torusknot.SourceTreeNotMAS bookmarksClosedOnStartup -bool true
	defaults write com.torusknot.SourceTreeNotMAS disableDesktopNotifications -bool true
	defaults write com.torusknot.SourceTreeNotMAS checkRemoteStatus -bool false

	###############################################################################
	echo "Transmission.app"
	###############################################################################

	# Hide the donate message
	defaults write org.m0k.transmission WarningDonate -bool false
	# Hide the legal disclaimer
	defaults write org.m0k.transmission WarningLegal -bool false

	# IP block list.
	# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
	defaults write org.m0k.transmission BlocklistNew -bool true
	defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
	defaults write org.m0k.transmission BlocklistAutoUpdate -bool true


	###############################################################################
	echo "Kill affected applications"
	###############################################################################

	for app in "cfprefsd" \
		"Dock" \
		"Finder" \
		"Safari" \
		"Transmission"; do
		killall "${app}" &> /dev/null || true
	done
	echo "Done. Note that some of these changes require a logout/restart to take effect."
fi

if yesno "Install Homebrew and tools?"; then
	# Ask for the administrator password upfront
	sudo -n true

	# Keep-alive: update existing sudo time stamp until the current process has finished
	# Probably doesn't matter if we have two of these
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Exit on first error
	set -e

	# Install Homebrew if necessary
	if test ! "$(command -v brew)"; then
		echo "Installing Homebrew..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		success "Installed Homebrew"
	fi

	# Update Homebrew
	echo "> brew update"
	brew update

	# Run the Brewfile through Homebrew
	echo "> brew bundle"
	pushd "$(dirname "$0")" > /dev/null
	brew bundle -v || true
	popd > /dev/null

	# Add homebrew bash and zsh to /etc/shells
	BREW_PREFIX=$(brew --prefix)
	if ! grep -F -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
	  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
	fi
	if ! grep -F -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
	  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells
	fi

	# TODO: factor out
	if [ "$SHELL" != "$(command -v zsh)" ]; then
		if yesno "Change shell to zsh (will prompt for password)?"; then
			if chsh -s "$(command -v zsh)"; then
				success "You will need to log out and in again"
			else
				echo "Failed to change shell, continuing"
			fi
		fi
	fi

	if noyes "Install GUI apps with Homebrew Cask?"; then
		# Check if Hammerspoon is installed
		open_hammerspoon=true
		if [ -e "$HOME/Applications/Hammerspoon.app" ] || [ -e "/Applications/Hammerspoon.app" ]; then
			# Only open Hammerspoon if it wasn't already installed, so it prompts to
			# enable accessibility
			open_hammerspoon=false
		fi

		echo "> brew bundle --file=Brewfile.casks"
		pushd "$(dirname "$0")" > /dev/null
		brew bundle -v --file=Brewfile.casks
		popd > /dev/null

		if $open_hammerspoon; then
			echo "Launching Hammerspoon so you can enable accessibility"
			open -a Hammerspoon
		fi

		pin () {
			if [ -e "$HOME/Applications/$1.app" ]; then
				dockutil --no-restart --add "$HOME/Applications/$1.app"
			elif [ -e "/Applications/$1.app" ]; then
				dockutil --no-restart --add "/Applications/$1.app"
			else
				echo "Could not pin $1"
			fi
		}

		if yesno "Pin apps to dock?"; then
			dockutil --no-restart --remove all
			pin "Safari"
			pin "Fantastical 2"
			pin "iTerm"
			pin "Messages"
			pin "Mail"
			dockutil --add "$HOME/Downloads" --view grid --display stack --sort dateadded
			killall "Dock" &> /dev/null
		fi
	fi
fi

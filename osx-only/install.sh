# macOS settings
# Mostly from https://github.com/mathiasbynens/dotfiles/blob/master/.macos, which goes way too far

source $DOTFILES/setup_common.sh

if yesno "Install macOS settings (will use sudo, and restart various applications)?"; then

	# Close any open System Preferences panes, to prevent them from overriding
	# settings we're about to change
	osascript -e 'tell application "System Preferences" to quit'

	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing sudo time stamp until the current process has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


	###############################################################################
	# General UI/UX                                                               #
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


	###############################################################################
	# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
	###############################################################################

	# Enable tap to click
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

	# Enable key repeat
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 35


	###############################################################################
	# Finder                                                                      #
	###############################################################################

	# Display full POSIX path as Finder window title
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	# Keep folders on top when sorting by name
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	# Show item info near icons on the desktop
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

	# Enable snap-to-grid for icons on the desktop and in other icon views
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

	# Increase grid spacing for icons on the desktop
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist

	# Show the ~/Library folder
	chflags nohidden ~/Library

	# Show the /Volumes folder
	sudo chflags nohidden /Volumes


	###############################################################################
	# Dock, Dashboard, and hot corners                                            #
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
	# Safari & WebKit                                                             #
	###############################################################################

	# Enable the Develop menu and the Web Inspector in Safari
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

	# Add a context menu item for showing the Web Inspector in web views
	defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

	# Enable "Do Not Track"
	defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true


	###############################################################################
	# Transmission.app                                                            #
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
	# Kill affected applications                                                  #
	###############################################################################

	for app in "cfprefsd" \
		"Dock" \
		"Finder" \
		"Safari" \
		"Transmission"; do
		killall "${app}" &> /dev/null
	done
	echo "Done. Note that some of these changes require a logout/restart to take effect."
fi

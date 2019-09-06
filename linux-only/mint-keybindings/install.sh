#!/usr/bin/env bash
# Set OSX-like keybindings for Mint (and probably Gnome in general)

set -e

gsettings_array_add() {
	local path="$1" key="$2" new_value="$3"
	value="$(gsettings get "$path" "$key")"
	local value

	# Test if new_value is already in value
	if [[ "$value" == *"$new_value"* ]]; then
		return
	fi

	echo "Adding keyboard shortcut for $key"
	# Create array or append new_value
	if [[ "$value" == "@as []" ]]; then
		gsettings set "$path" "$key" "['$new_value']"
	else

		gsettings set "$path" "$key" "${value/%]/, \'$new_value\']}"
	fi
}


if gsettings get org.cinnamon.desktop.keybindings.wm close >/dev/null 2>&1; then
	# Add bindings
	gsettings_array_add org.cinnamon.desktop.keybindings.wm close "<Super>Q"
	gsettings_array_add org.cinnamon.desktop.keybindings.wm switch-windows "<Super>Tab"
	gsettings_array_add org.cinnamon.desktop.keybindings.wm switch-windows-backward "<Shift><Super>Tab"
	gsettings_array_add org.cinnamon.desktop.keybindings.wm switch-group "<Super>grave"
	gsettings_array_add org.cinnamon.desktop.keybindings.wm switch-group-backward "<Shift><Super>asciitilde"
	gsettings_array_add org.cinnamon.desktop.keybindings.wm panel-run-dialog "<Super>space"
	gsettings set org.cinnamon.desktop.keybindings looking-glass-keybinding "[]"
	gsettings_array_add org.cinnamon.desktop.keybindings.media-keys screensaver "<Super>l"
fi

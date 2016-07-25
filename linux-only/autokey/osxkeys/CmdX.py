# Cut
#
# Could do this one as a phrase, but this is easier than doing
# exclusion with a window filter.

if window.get_active_class() == "gnome-terminal-server.Gnome-terminal":
    keyboard.send_keys("<super>+x")
else:
    keyboard.send_keys("<ctrl>+x")
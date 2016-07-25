# Paste
if window.get_active_class() == "gnome-terminal-server.Gnome-terminal":
    keyboard.send_keys("<ctrl>+<shift>+v")
else:
    keyboard.send_keys("<ctrl>+v")


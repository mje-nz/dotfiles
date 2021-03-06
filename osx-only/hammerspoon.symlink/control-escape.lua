-- Map a short press of the caps lock key to escape.
-- To use this, map caps lock to control in System Preferences.
-- From https://github.com/jasonrudolph/keyboard/blob/master/hammerspoon/control-escape.lua

sendEscape = false
lastFlags = {}


ctrlKeyTimer = hs.timer.delayed.new(0.15, function()
  sendEscape = false
end)


flagsTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(evt)
  if evt:getKeyCode() ~= 62 then
    -- Only modify caps lock events
    return false
  end
  local newFlags = evt:getFlags()
  if lastFlags.ctrl == newFlags.ctrl then
    return false
  end
  if not lastFlags.ctrl then
    -- Control has just been pressed
    lastFlags = newFlags
    sendEscape = true
    ctrlKeyTimer:start()
  else
    -- Control has just been released
    if sendEscape then
      print('Sending escape')
      keyUpDown({}, 'escape')
    end
    lastFlags = newFlags
    ctrlKeyTimer:stop()
  end
  return false
end)
flagsTap:start()


keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(evt)
  sendEscape = false
  return false
end)
keyDownTap:start()

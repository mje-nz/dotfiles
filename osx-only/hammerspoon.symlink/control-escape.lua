-- From https://github.com/jasonrudolph/keyboard/blob/master/hammerspoon/control-escape.lua

sendEscape = false
lastMods = {}

ctrlKeyHandler = function()
  sendEscape = false
end

ctrlKeyTimer = hs.timer.delayed.new(0.15, ctrlKeyHandler)

ctrlHandler = function(evt)
  local newMods = evt:getFlags()
  if lastMods["ctrl"] == newMods["ctrl"] then
    return false
  end
  if not lastMods["ctrl"] then
    lastMods = newMods
    sendEscape = true
    ctrlKeyTimer:start()
  else
    if sendEscape then
      keyUpDown({}, 'escape')
    end
    lastMods = newMods
    ctrlKeyTimer:stop()
  end
  return false
end

ctrlTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, ctrlHandler)
ctrlTap:start()

otherHandler = function(evt)
  sendEscape = false
  return false
end

otherTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, otherHandler)
otherTap:start()


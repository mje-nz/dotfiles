-- Based on https://github.com/jasonrudolph/keyboard/blob/master/hammerspoon/init.lua
--
local log = hs.logger.new('init.lua', 'debug')


keyUpDown = function(modifiers, key)
  -- Un-comment & reload config to log each keystroke that we're triggering
  -- log.d('Sending keystroke:', hs.inspect(modifiers), key)
  hs.eventtap.keyStroke(modifiers, key, 0)
end


require('control-escape')

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()


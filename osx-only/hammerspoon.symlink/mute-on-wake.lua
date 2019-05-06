-- Mute speakers on waking from sleeps
-- From https://spinscale.de/posts/2016-11-08-creating-a-productive-osx-environment-hammerspoon.html

function muteOnWake(eventType)
  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    hs.audiodevice.defaultOutputDevice():setMuted(true)
  end
end
caffeinateWatcher = hs.caffeinate.watcher.new(muteOnWake)
caffeinateWatcher:start()

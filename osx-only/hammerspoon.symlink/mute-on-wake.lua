-- Mute speakers on waking from sleep
-- Based on https://spinscale.de/posts/2016-11-08-creating-a-productive-osx-environment-hammerspoon.html

function muteOnWake(eventType)
	if eventType == hs.caffeinate.watcher.systemDidWake then
		print("Waking from sleep")
		local output = hs.audiodevice.defaultOutputDevice()
		if output:name() == "Built-in Output" and not output:jackConnected() then
			print("Muting speakers")
			output:setMuted(true)
		end
	end
end
caffeinateWatcher = hs.caffeinate.watcher.new(muteOnWake)
caffeinateWatcher:start()


-- Unmute on play/pause

tap = hs.eventtap.new({hs.eventtap.event.types.NSSystemDefined}, function(event)
	-- print("event tap debug got event:")
	-- print(hs.inspect.inspect(event:getRawEventData()))
	-- print(hs.inspect.inspect(event:getFlags()))
	-- print(hs.inspect.inspect(event:systemKey()))
	if not event:systemKey() or event:systemKey().key ~= "PLAY" or event:systemKey().down then
		return false
	end
	-- Play/pause key was just released
	local output = hs.audiodevice.defaultOutputDevice()
	if output:name() ~= "Built-in Output" or output:jackConnected() then
		return false
	end
	-- Audio output device is built-in speakers
	if output:outputMuted() then
		print("Unmuting speakers on play/pause")
		output:setMuted(false)
	end
	return false
end)
tap:start()

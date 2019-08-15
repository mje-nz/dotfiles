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

-- Switch to USB audio interface when inserted
-- From https://gist.github.com/dropmeaword/ddf7b5b3a0e81ef1142f446f3f91075a
-- and https://github.com/Hammerspoon/hammerspoon/issues/1698

function usbDeviceCallback(data)
	if (data['eventType'] == 'added') then
		if (data['productName'] == 'USB audio CODEC') then
			local timer = hs.timer.waitUntil(
				function()
					-- Wait until the USB audio output is ready
					local output = hs.audiodevice.findOutputByName('USB audio CODEC')
					return output ~= nil
				end,
				function ()
					-- Switch to the USB audio output
					local success = hs.audiodevice.findOutputByName('USB audio CODEC'):setDefaultOutputDevice()
					if success then
						print('Switching to USB audio output')
						hs.notify.new({title='Hammerspoon', informativeText='Switching to USB audio output'}):send()
					else
						print('Could not switch audio output device')
					end
				end,
				-- Run check every 200ms
				0.2
			)
		end
	end
end
local usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

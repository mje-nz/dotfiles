-- When Thunderbolt Ethernet adaptor is connected, disable WiFi.  When it is
-- disconnected, re-enable WiFi.

local lan_interface = 'en6'
local lan_interface_key = 'State:/Network/Interface/' .. lan_interface
local lan_link_key = lan_interface_key .. '/Link'

function monitor_callback(conf, changed_keys)
	local state = conf:contents(lan_link_key)[lan_link_key]
	if state ~= nil and state.Active then
		-- Probably just connected
		print(lan_interface .. ' active, disabling WiFi')
		hs.wifi.setPower(false)
	else
		-- Probably just disconnected
		print(lan_interface .. ' inactive, enabling WiFi')
		hs.wifi.setPower(true)
	end
end

local conf = hs.network.configuration.open()
conf:monitorKeys(lan_link_key)
conf:setCallback(monitor_callback)
conf:start()

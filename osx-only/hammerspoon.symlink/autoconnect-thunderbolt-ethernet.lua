-- When Thunderbolt Ethernet adaptor is connected, run UC Internet Enabler and
-- disable WiFi.  When it is disconnected, re-enable WiFi.


-- From https://github.com/teunvink/hammerspoon/blob/6537a7f47acf058cdb9de2af807ba732720ae554/token.lua
function password_from_keychain(account)
    -- 'account' should be saved in the login keychain
    local command = '/usr/bin/security 2>&1 >/dev/null find-generic-password -ga ' .. account
    command = command .. " | sed -En '/^password: / s,^password: \"(.*)\"$,\\1,p'"
    local handle = io.popen(command)
    local result = handle:read('*a')
    handle:close()
    return (result:gsub('^%s*(.-)%s*$', '%1'))
end


-- Run Internet Enabler for the given account, using password from keychain
--
-- Returns:
--   output: The output of ienabler, without trailing newline
--   status: true if sucessful, nil otherwise
function run_ienabler(account)
	local password = password_from_keychain(account)
	local command = 'ienabler -u ' .. account .. ' -p ' .. password
	local output, status, type, rc = hs.execute(command, true)
	-- Remove trailing space
	output = string.gsub(output, '\n$', '')
    return output, status
end


local lan_interface = 'en6'
local lan_interface_key = 'State:/Network/Interface/' .. lan_interface
local lan_link_key = lan_interface_key .. '/Link'

function monitor_callback(conf, changed_keys)
	local state = conf:contents(lan_link_key)[lan_link_key]
	if state ~= nil and state.Active then
		-- Probably just connected
		print(lan_interface .. ' active, running Internet Enabler...')
		hs.notify.new({title='Hammerspoon', informativeText='Running Internet Enabler...'}):send()
		output, success = run_ienabler('mje109')
		if success then 
			print('Success, disabling WiFi')
			hs.wifi.setPower(false)
		else
			print('Internet enabler failed:' .. output)
		end
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

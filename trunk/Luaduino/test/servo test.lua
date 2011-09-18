--[[
Code to test comunication speed between Arduino and program.
By Matheus Braga - Matheus.mtb7@gmail.com
]]

--To test upload Arduino_test in your arduino board.
require('luaduino')
--Load lib


print('Conecting to the arduino board.')

local con,err = assert(luaduino.conectArduino("\\\\.\\COM12")) -- Connect to arduino in COM12 port.
--Initiate some vars
local awnsers = 0
local finish_test = os.time()+10
local delay = 0
local start_test = 0
if con then -- If is connected.
	while true do
		print('Insert the angle. (0-200)')
		local angle = tonumber(io.read()) or math.random(0,185)
		if angle <= 270 and angle >= 0 then
			luaduino.writeData(string.char(angle+1),1)
			local wait = os.clock()+4
		end
	end
end
--[[Will print something like:
>lua -e "io.stdout:setvbuf 'no'" "delay test.lua"
Conecting to the arduino board.
Average delay:	0.015929712460064	ms
>Exit code: 0
]]

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
	if luaduino.writeData(string.char(51),1) then -- Send byte 51 to arduino
		start_test = os.clock()
		while true do
			if os.time() >= finish_test or not luaduino.isConected() then
				break
			end
			local s,len = luaduino.readData(1) -- Read one byte
			if s then
				if s == string.char(51) then -- If byte is 51
					luaduino.writeData(string.char(50),1)
					awnsers = awnsers+1
					start_test = os.clock()-start_test
					delay = delay+start_test
				else
					luaduino.writeData(string.char(51),1)
					start_test = os.clock()
				end
			end

		end
		print('Average delay:',delay/awnsers,'ms')
	end
end
--[[Will print something like:
>lua -e "io.stdout:setvbuf 'no'" "delay test.lua"
Conecting to the arduino board.
Average delay:	0.015929712460064	ms
>Exit code: 0
]]

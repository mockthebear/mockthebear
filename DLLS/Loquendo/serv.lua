require('socket')
local S = socket.bind('*',7512)
local n = 0
local U = {}
local t = os.clock()
while true do
	S:settimeout(0.01)
	local d = S:accept()
	if d then
		n = n+1
		local ip = d:getpeername()
		U[n] = {d,ip=ip,last=os.clock(),info=os.clock()}
	end
	if t <= os.clock() then
		local cc = 0
		for i,b in pairs(U) do
			cc = cc+1
		end
		if cc ~= 0 then
			print(os.time(),'tem:',cc)
		end
		t = os.clock()+5
	end
	for i,b in pairs(U) do
		b[1]:settimeout(0)
		local f ,err = b[1]:receive()
		if not f and err == 'closed' then
			U[i] = nil
		else
			if f then
				b[1]:send('P\n')
				if b.info <= os.clock() then
					b.info = os.clock()+10
					print(os.time(),b.ip,'-',os.clock()-b.last)
				end
				if not b.ip then
					b.ip = b[1]:getpeername()
				end
				b.last = os.clock()
			end
		end
	end
end

require('socket')
require('ex')
require('bit')
require('lib')
require('luasql.mysql')
local online = {}
local name = {}
require('database')
local rooms = {}
romid = 0
--conf
SITE = 'http://localhost:8090/'
function protocol_parser(id,msg)

end
function removeUser(i)
	local ch = 0
	for code,b in pairs(rooms) do
		for id,p in pairs(b.online) do
			if p == i then
				print(id,'ded',i)
				ch =  code
				sendMessageToAll('+[Server] '..online[i].nam..' has logged out.',code)
				b.online[id] = nil
				b.master[id] = nil
				break
			end
		end
	end
	online[i]=nil
	collectgarbage()
	sendOnlineList(ch)
end
function sendOnlineList(ch)
	local ss = ''
	for i,b in pairs(online)  do
		if b.nam ~= '' and b.inroom == (ch and ch or 0) then
			ss=ss..b.nam..'¬'
		end
	end
	for a,b in pairs(online) do
		if b.nam ~= '' and b.inroom == (ch and ch or 0) then
			b.client:send('¨'..ss..'¬\n')
		end
	end
end
function sendMessageToAll(m,ch)
	for a,b in pairs(online) do
		if b.nam ~= '' and b.inroom == (ch and ch or 0) then
			b.client:send(m..'\n')
		end
	end
end
function getByName(n)
	for i,b in pairs(online) do
		if b.nam:lower() == n then
			return i
		end
	end
	sendOnlineList()
end
function isMaster(rm,i)
	local rm = rooms[rm]
	for ia,b in pairs(rm.master) do
		if b == i then
			return ia
		end
	end
end
function checkTheName(n)
	return n:lower():match('([a-z%d*%-]+)') == n:lower()
end
function user_get_pack(u,i)
	local limit = nil
	if u.downlaod then
		limit = 500
		if u.downlaod-u.don:len() < 500 then
			limit = u.downlaod-u.don:len()
		end
	end
	local dat,err = u.client:receive(limit)
	if not dat and err == 'closed' then
		print(i,'closed')
		removeUser(i)
	end
	if dat then
		print(dat)
		u.byte = u.byte+1
		if u.downlaod then
			u.don = u.don..dat
			u.client:send('F:'..u.don:len()..'\n')
			if u.don:len() == u.downlaod then
				u.client:send('K\n')
				local ida = isMaster(u.inroom,i)
				if ida then
					if u.save == '1' then
						local con,env = database:get()
						local b = assert(con:execute(string.format([[UPDATE `fichas` SET `content` = '%s' WHERE `code` = '%s' AND `pass` = '%s' AND `pass_leader` = '%s';]],u.don:gsub("'","\\'"),u.inroom,u.pass,u.mpass)))
						u.don = ''
						u.downlaod = nil
						u.save = nil
						u.client:send((b and 1 or 0)..'\n')
						con:close()
						env:close()
						sendMessageToAll('S',u.inroom)
					else
						local olda,newa = u.save:match('(.-)*(.+)')
						if olda and newa and database:hasF(u.inroom,olda) then
							local con,env = database:get()
							local b = assert(con:execute(string.format([[UPDATE `player_data` SET `data` = '%s' , `name` = '%s' WHERE `owner` = '%s' AND `name` = '%s']],u.don:gsub("'","\\'"),newa,u.inroom,olda)))
							u.don = ''
							u.downlaod = nil
							u.save = nil
							u.client:send((b and 1 or 0)..'\n')
							con:close()
							env:close()

							sendMessageToAll('Y',u.inroom)
						else
							if u.inroom and newa then
								local con,env = database:get()
								print(u.inroom,os.time(),u.don:gsub("'","\\'"),u.save)
								local b = assert(con:execute(string.format([[INSERT INTO `player_data` (`id` ,`owner` ,`creation` ,`data` ,`name`) VALUES (NULL , '%s', '%d', '%s', '%s')]],u.inroom,os.time(),u.don:gsub("'","\\'"),newa)))
								u.don = ''
								u.downlaod = nil
								u.save = nil
								u.client:send((b and 1 or 0)..'\n')
								con:close()
								env:close()
								sendMessageToAll('Y',u.inroom)
							else
								u.client:close()
							end
						end
					end
				end
			else
				u.client:send('O\n')
			end
		elseif u.byte == 1 then
			if dat:match('!@(.+)') then
				local nam = dat:match('!@(.+)')
				if not getByName(nam:lower()) then
					if checkTheName(nam) then
						u.client:send('!!'..byte(2, 3)..'€'..SITE..'\n')
						u.client:send('%'..#rooms..'\n')
						local ss = ''
						for i,b in pairs(online)  do
							if b.nam ~= '' and b.inroom == 0 then
								ss=ss..b.nam..'¬'
							end
						end
						for a,b in pairs(online) do
							if b.nam ~= '' and b.inroom == 0 then
								b.client:send('+[Server] '..nam..' has logged in.\n')
								b.client:send('¨'..ss..nam..'¬\n')
							end
						end
						u.client:send('¨'..ss..nam..'¬\n')
						online[i].nam = nam
					else
						u.client:send('wInvalid name.\n')
						u.client:close()
						removeUser(i)
					end
				else
					u.client:send('wName in use.\n')
					u.client:close()
					removeUser(i)
					return true
				end
			else
				u.client:close()
				removeUser(i)
			end
		else
			if dat:match('%+(.+)') then
				for i,b in pairs(online) do
					if b.inroom == u.inroom and b.nam ~= '' then
						b.client:send('+'..u.nam..': '..dat:match('%+(.+)')..'\n')
					end
				end
			elseif dat:match('R(%d+)|(%d+)') then
				local rl,ma = dat:match('R(%d+)|(%d+)')
				if tonumber(ma) > 10 then
					ma = 10
				end
				if tonumber(rl) > 150 then
					ma = 150
				end
				local roled = ''
				for i=1,tonumber(ma) do
					local virg = ' '
					if i ~= tonumber(ma) then
						virg = ', '
						if i == 4 or i == 8 then
							virg = virg..'#'
						end
					end
					roled = roled..math.random(1,tonumber(rl))..virg
				end
				for i,b in pairs(online) do
					if b.inroom == u.inroom and b.nam ~= '' then
						b.client:send('+[Dice] '..u.nam..' rolled '..roled..' at the dice of '..rl..' side'..(tonumber(rl) == 1 and '' or 's')..'.\n')
					end
				end
			elseif dat == 'M?' and u.inroom ~= 0 then
				u.client:send((isMaster(u.inroom,i) and 1 or 0)..'\n')
			elseif dat:match('dd(%d+)|(.+)') and u.inroom ~= 0 then
				local s,j = dat:match('dd(%d+)|(.+)')
				if tonumber(s) > 1024*100 then
					u.client:send('0Max size\n')
				elseif j == '' then
					u.client:send('0?????????????????\n')
				elseif not checkTheName(j) then
					u.client:send('0Invalid name\n')
				else
					--zomg
					if isMaster(u.inroom,i) then
						u.client:send('1\n')
						if isMaster(u.inroom,i) then
							u.downlaod = tonumber(s)
							u.save = j
							u.executar = j
						end
					else
						u.client:send('0You are not the master\n')
					end
				end
			elseif dat:match('PLX%((.-)%)(.-),(.+)') then
				local code,pass,mpass = dat:match('PLX%((.-)%)(.-),(.+)')
				local cont = database:get_f(code,pass)
				if cont then
					ff__  = cont.content
					u.client:send('1\n')
					u.client:send('S'..ff__:len()..'\n')
					u.client:send(ff__)
					u.mpass = (mpass == cont.pass_leader and mpass or '')
					u.pass = pass
					if not rooms[code] then
						rooms[code] = {n=1,online={i},master={(mpass == cont.pass_leader and i or nil)}}
					else
						local rm = rooms[code]
						rm.n = rm.n+1
						rm.online[rm.n] = i
						rm.master[rm.n] = (mpass == cont.pass_leader and i or nil)
					end
					if mpass ~= 'a' and mpass ~= cont.pass_leader then
						u.client:send('wZomg!\n')
					end
					u.inroom = code
					sendMessageToAll('+[Server] '..(mpass == cont.pass_leader and '[M]' or '')..u.nam..' has joined.',code)
					sendOnlineList(code)
				else
					u.client:send('Unknow code or wrong password.\n')
				end
			end
		end
	end
end
function con_acc()
	local f = center:accept()
	if f then
		id = id+1
		local ip = f:getpeername()
		online[id] = {client=f,ip=ip,byte=0,inroom=0,nam='',don='',downlaod=nil}
		f:settimeout(0)
		print('Con: ',ip)
	end
end
function log_(f,m)
	local fa = io.open(f,'a+')
	fa:write(m)
	fa:close()
	collectgarbage()
end
center = socket.bind('*',7175)
center:settimeout(0)
id = 0
local error_message = [[
Error [%s]
Ip    [%s]
Byte  [%d]
Room  [%s]
Name  [%s]
Downl [%s]
Time  [%s]
]]
while true do
	math.random(0,999)
	local clock_ = os.clock()
	con_acc()
	for i,b in pairs(online) do
		local r,err = pcall(user_get_pack,b,i)
		if not r and err then
			b.client:send('wDisconected! Internal server error\n')
			b.client:close()
			log_('error.txt',string.format(error_message,
			err,
			b.ip,
			b.byte,
			b.inroom,
			b.nam,
			tostring(b.downlaod),
			os.time()))
			removeUser(i)
		end
	end
	if clock_-os.clock() <= 0.01 then
		os.sleep(0.01-(clock_-os.clock()))
	end
end

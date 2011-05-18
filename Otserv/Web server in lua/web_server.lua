web_conf = {
location='data/npc/scripts/web server/'
}
location = ''
head = ''
_get = {}
--- Config
dofile(web_conf.location..'config.lua')
--- Modules
dofile(web_conf.location..'lua string.lua')
dofile(web_conf.location..'global.lua')
require('socket')
require('ex')
---Start
local q = socket.bind(web_conf.host,web_conf.port)
if not q then
	error('Cannot bind socket in: '..tostring(web_conf.host)..':'..tostring(web_conf.port)..'.')
else
	print('Binding socket in: '..tostring(web_conf.host)..':'..tostring(web_conf.port)..'.')
end

function onCreatureAppear(cid)
end

function onCreatureDisappear(cid)
end

function onCreatureSay(cid, typee, msg)
end

function onThink()
	q:settimeout(0)
local sock = q:accept()
	if sock then
		--- Some need vars
		local ipadd = sock:getpeername()
		_G.user = {sock,ip=ipadd,
		limit=os.clock()+20,ipadd = deIP(ipadd),
		cookies={},}
		location = ''
		head = ''
		_get = {}
		ipadd = deIP(ipadd)
		if web_conf.debug then	print('Connected:',ipadd) end
		--- the loop
		while true do
			if  os.clock()  > user.limit then user[1]:send('Timeout 30 seconds.') user[1]:close() print('Timeout') break end
			user[1]:settimeout(0.001)
			local stuff,status,f,k = user[1]:receive()
			if status ~= 'timeout' and web_conf.debug then print(stuff,status,f,k)	end
			if f and request == 'post' and status == 'timeout' and f:len() > 3 and not tonumber(f) then
				if not posted[ipadd] and getDataFromPost(f) then
					posted[ipadd] = getDataFromPost(f)
				end
			end
			if stuff == nil and status == 'closed' and type(f) ~= 'number' and f ~= nil then
				if web_conf.debug then print(ipadd..' closed.') end
				break
			end
			if stuff then
				if stuff:match('GET /(.-) HTTP/(%d).(%d)') then
					location = stuff:match('GET /(.-) HTTP/(%d).(%d)')
					request = 'get'
				elseif stuff:match('POST /(.-) HTTP/(%d).(%d)') then
					location = stuff:match('POST /(.-) HTTP/(%d).(%d)')
					request = 'post'
				elseif stuff:match('Cookie: (.+)') then
					local part = stuff:match('Cookie: (.+)')
					local part = part:explode(';')
					for _,var in pairs(part) do
						if var:match('(.-)=(.+)') then
							local cookiename,cookievar = var:match('(.-)=(.+)')
							user.cookies[cookiename] = cookievar
						else
							print('Bad cookie format: '..var)
						end
					end
				end
				--- Aqui verifica se o browser parou de enviar dados e começa a executar
				if stuff == '' then --
					if request == 'get' then
						if type(location) == 'string' then
							if location == '' then location = 'index.lb' end
							local site,ext = getFile(location)
							if site then
								if location:find('(.-)%.lb') then
									site,toHead  = runCode(site,user)
								end
								if send_data(user[1],200,ext,site:len(),toHead) then

								end
								user[1]:send(site)
								user[1]:close()
							else
								if location == 'index.lb' then
									site = urls['no_index']
								else
									site = urls['error']
								end
								if location:find('(.-)%.lb') then
									site,toHead = runCode(site,user)
								end
								if send_data(user[1],404,'lb',site:len(),toHead) then
									user[1]:send(site)
								end
								user[1]:close()
							end
							site = ''
						end
					end
				end
			else
				if request == 'post' then
					if posted[ipadd] and location then
						if location == '' then location = 'index.lb' end
						local site,ext = getFile(location)
						if location:find('(.-)%.lb') then
							site,toHead = runCode(site,user)
						end
						send_data(user[1],200,ext,site:len(),toHead)
						user[1]:send(site)
						user[1]:close()
						request = false
						site = ''
						posted[ipadd] = nil
					end
				end
			end
		end
	end
end

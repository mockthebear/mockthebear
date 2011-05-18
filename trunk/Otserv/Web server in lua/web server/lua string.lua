
-- Name=9159&Email=&submit=Sign+Me+Up%21
function string.trim(str)-- by Colandus
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end
function string.explode(str, sep, limit)-- by Colandus
	if limit and type(limit) ~= 'number' then
		error("string.explode: limit must be a number", 2)
	end
	if #sep == 0 or #str == 0 then return end
	local pos, i, t = 1, 1, {}
	for s, e in function() return str:find(sep, pos) end do
		table.insert(t, str:sub(pos, s-1):trim())
		pos = e + 1
		i = i + 1
		if limit and i == limit then break end
    end
    table.insert(t, str:sub(pos):trim())
    return t
end

function getDataFromPost(str)
	local post = {}
	if str == '' then return nil end
	local tabele = string.explode(str, '&')
	if not tabele or #tabele == 0 then
		return nil
	end
	for i,b in pairs(tabele) do
		local r,var = (b or 0):match('(.-)=(.+)')
		if r then
			post[r] = var
		end
	end
	return post
end
function doCode(f,s1,s2,user)
	local showit = {}
	local n__ = 1
	local to_header = {}
	local n_ = 1
	function echo(v)
		table.insert(showit,n__,tostring(v))
		n__ = n__+1
	end
	local ipadd = user[1]:getpeername()
	ipadd = deIP(ipadd)
	print(ipadd)
	function post(v)
		assert(ipadd,';(')
		if posted[ipadd] then
			if not v then
				return nil
			elseif v then
				return posted[ipadd][v]
			end
		end
	end
	function get(n)
		local edit = _get[n]
		if not edit then return nil end
		edit = edit:gsub('%%20',' ')
		return edit
	end
	function cookie(name)
		return user.cookies[name]
	end
	function set_cookie(name,value,time)
		table.insert(to_header,n_,'Set-Cookie: '..name..'='..value..'; expires='..os.date("!%a, %d %b %Y %H:%M:%S GMT",time))
		n_ = n_+1
	end
	function header(l)
		table.insert(to_header,n_,l)
		n_ = n_+1
	end
	local toprint = ""
	local ret,err = pcall(f)
	if not ret and err then
		toprint = toprint..'<b>'..err..'</b>'
	end
	for i,b in pairs(showit) do
		toprint = toprint..b
	end
	showit = {}
	return s1..toprint..s2,to_header
end
function runCode(doc,user,to_header)
	doc = ' '..doc..' '
	if doc:find('<%%lua(.+)%%>') then
		local strat_,code,end_ = string.match(doc,'(.-)<%%lua(.-)%%>(.+)')
		if not strat_ or not code or not end_ then
			error("Unexpected error!")
		end
		local f,err = loadstring(code)
		if not f and err then
			return strat_..'<b>'..err..'</b>'..end_
		end
		local doca,to_header2 = doCode(f,strat_:sub(2,-1),end_:sub(1,end_:len()-1),user)
		if type(to_header) == 'table' and #to_header > 0 then
			for i,b in pairs(to_header2) do
				table.insert(to_header,1,b)
			end
		else
			to_header = to_header2
		end
		if doca:find('<%%lua(.+)%%>') then
			doca,to_header = runCode(doca,user,to_header)
			return doca,to_header
		else
			return doca,to_header
		end
	end
	return doc,to_header
end
function deIP(ip)
	local i1,i2,i3,i4 = ip:match('(%d+).(%d+).(%d+).(%d+)')
	return tonumber(i1..i2..i3..i4)
end
status ={
[200] = 'OK',
[404] = 'PAGE NOT FOUND',
} --
function send_data(b,kind,ftip,len,more)
		local print_
		if not ftip then ftip = 'html' end
		if not file_type[ftip] then ftip = 'html' end
		ftip = ftip:lower()
		if not kind then kind = 404 end
		b:send("HTTP/1.1 "..kind.." "..status[kind].."\r\n")
		b:send(string.format ("Date: %s\r\n", os.date ("!%a, %d %b %Y %H:%M:%S GMT")))
		b:send('Server: Bear server 1.0\r\n')
		for i,b_ in pairs(more or {}) do
			b:send(b_..'\r\n')
		end
		if isInArr(toHead,'Location:') == false then
			b:send('Connection: close\r\n')
			print_ = true
		else
			b:send('Connection: Keep-Alive\r\n')
			b:send('Keep-Alive: timeout=5, max=100\r\n')
			print_ = false
		end
		if len then
			b:send('Content-Length: '..len..'\r\n')
		end
		b:send('Content-Type: '..file_type[ftip] ..'\r\n\r\n')
		return print_
end
function getFile(name)
	if name:match('(.-)?(.+)') then
		name,head = name:match('(.-)?(.+)')
		get_ = string.explode(head,'&')
		for i,b in pairs(get_) do
			local bd,cd = b:match('(.-)=(.+)')
			if bd then
			_get[bd] = cd
			end
		end
	end
	local file = io.open('web/'..name,'rb')
	if not file then return nil end
	local ff = file:read(-1)
	file:close()
	local _,tipo = name:match('(.-)%.(.+)')
	return ff,tipo
end
function isInArr(arr,va)
	for i,b in pairs(arr or {}) do
		if b:find(va) then
			return true
		end
	end
	return false
end



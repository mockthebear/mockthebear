function byte(int, bytes)
	ret = {}
	while bytes > 0 do
		table.insert(ret, 1, string.char(int-bit.lshift(bit.rshift(int, 8), 8)))
		int = bit.rshift(int, 8)
		bytes = bytes - 1
	end
	return str_mix(unpack(ret))
end


function int(...)
	params, ret = {...}, 0
	for i = 0, #params-1 do
		ret = ret + bit.lshift(params[#params-i], 8*i)
	end
	return ret
end
function str_mix(...)
	local s = ""
	local rg = {...}
	for i,b in pairs(rg) do
		s = s..b
	end
	return s
end
function string:getBytes(s,n)
	local t = {}
	s = s or 1
	self = self:sub(s,-1)
	print(self)
	for i=1,n do
		t[i] = self:sub(i,i):byte()
	end
	return t
end
function createF(t)
	local lua = 'iup.hbox{'
	local result = {}
	local n = 0
	for i,b in (''..t..''):gmatch("(%[f=\".-\"%].+%[/f%])") do
		t = t:gsub("(%[f=\".-\"%].-%[/f%])", function(s)
		local f,tt = s:match('%[f=\"(.-)\"%](.-)%[/f%]')
		n = n+1 result[n] = 'iup.label{FONT = "'..f..'",title=[['..tt..']]},'
		return '€€'..n..'€€' end)
	end
	for i,b in (''..t..''):gmatch("(%[c=\"%d+ %d+ %d+\" f=\".-\"%].-%[/c%])") do
		t = t:gsub("(%[c=\"%d+ %d+ %d+\" f=\".-\"%].-%[/c%])", function(s)
		local r,g,b,f,tt = s:match("%[c=\"(%d+) (%d+) (%d+)\" f=\"(.-)\"%](.+)%[/c%]")
		n = n+1 result[n] = 'iup.label{FONT = "'..f..'",FGCOLOR=\''..r..' '..g..' '..b..'\',title=[['..tt..']]},'
		return '€€'..n..'€€' end)
	end
	for i,b,f in pairs(string.explode(t,'€€')) do
		if tonumber(b) then
			lua = lua..result[tonumber(b)]
		else
			lua = lua..'iup.label{title=[['..b..']]},\n'
		end
		--print(i,b)
	end
	local f = assert(loadstring('return '..lua..'}'))
	return f()
end
function string.explode(self, sep)--By socket  (só usei pq tava pequena)
    local result = {}
    self:gsub("[^".. sep .."]+", function(s) table.insert(result, s) end)
    return result
end

function loadPhoto(name,t)
	local phto = {}
	local ce = {'BGCOLOR'}
	local n = 1
	local gde
	if not t then
		gde= gd.createFromGif(name)
	else
		gde= gd.createFromPng(name)
	end
	for x=1,gde:sizeX()+1 do
		for y=1,gde:sizeY()+1 do
			if not phto[(y-1)] then phto[(y-1)] = {} end
			if not phto[(y-1)][(x-1)] then phto[(y-1)][(x-1)] = {} end
			local p = gde:getPixel(x-2, y-2)
			if  (gde:red(p) == 255 and gde:blue(p) ==255 and gde:green(p) == 255) then
				phto[(y-1)][(x-1)] = 1
			else
				local r, b, g = gde:red(p), gde:blue(p), gde:green(p)
				local clr  = r..' '..b..' '..g
				local go = true
				for i,b in pairs(ce) do
					if b == clr then
						go = false
						phto[(y-1)][(x-1)] = i
						break
					end
				end
				if go then
					n = n+1
					ce[n] = clr
					phto[(y-1)][(x-1)] = n
				end
			end
		end
	end
	cs = nil
	return iup.image{colors = ce,hotspot = "1:1",unpack(phto)}
end

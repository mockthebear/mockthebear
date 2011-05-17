function loadSkin(name)
	local s
	local sk = {}
	n = 0
	local f = io.open(name..'.skin','r')
	if f then
		s = f:read(-1)
		f:close()
	else
		return {}
	end
	if s:match('„(.-)ÿ') then
		local dat = s:match('„.-ÿ(.+)ÿ')
		for i in dat:gmatch('È(.-)È'..string.char(10)) do
			n = n +1
			if i ~= '' then
				sk[n] =i
			end
		end
	end
	return sk
end

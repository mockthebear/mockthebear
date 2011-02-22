database = {
sql_db='rpg',
sql_user='root',
sql_pass='slsx450',
sql_host='localhost',
sql_port=3306
}

function database:hasF(code,pass)
	local con,env = self:get()
	local b = con:execute(string.format("SELECT * FROM `player_data` WHERE `owner`= '%s' AND `name` = '%s' ",code,pass))
	local c = b:fetch({}, "a")
	b:close()
	con:close()
	env:close()
	if c then
		return c
	else
		return false
	end
end
function database:connect_db()
	local env,con,err1,err2
	env,err1 = luasql.mysql()
	con,err2 = env:connect(self.sql_db,
	self.sql_user,
	self.sql_pass,
	self.sql_host,
	self.sql_port)
	return	con,env,err1,err2
end
function database:init()
	local env,con,err1,err2 = self:connect_db()
	if err1 then
		print(err1,'\nPress any key to close')
		--io.read()
		--os.exit()
	elseif err2 then
		print(err2,'\nPress any key to close')
		--io.read()
		--os.exit()
	end
	env:close()
	con:close()
end
function database:get()
	local env,con,err1,err2 = self:connect_db()
	if err1 then
		print(err1,'\nPress any key to close')
		io.read()
		os.exit()
	elseif err2 then
		print(err2,'\nPress any key to close')
		io.read()
		os.exit()
	end
	return env,con
end
function database:create(code,pass,cont,lpass)
	if database:get_f(code,pass) then
		return false,'Account name already exists'
	end
	local con,env = self:get()
	local b = con:execute(string.format([[INSERT INTO `rpg`.`fichas` (
`code` ,
`pass` ,
`creation` ,
`last_access` ,
`content` ,
`pass_leader`
)
VALUES (
'%s', '%s', '%d', '%d', '%s', '%s'
);]],code,pass,os.time(),os.time(),cont,lpass))
	con:close()
	env:close()
	return b,'Account has been created'
end
function database:get_f(code,pass)
	local con,env = self:get()
	local b = con:execute(string.format("SELECT * FROM `fichas` WHERE `code` = '%s' "..(pass and ("AND `pass` = '%s'") or ''),code,pass))
	local c = b:fetch({}, "a")
	b:close()
	con:close()
	env:close()
	if c then
		return c
	else
		return false
	end
end

local f = 'ab'
local s = 2
for i=0,f:len()/s do
	print(f:sub((i*s)+1,(i+1)*s))
end

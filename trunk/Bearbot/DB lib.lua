----- By colandus
db = {}
db.__index = db

function getConnection()
    local env, con
    if sqlType == "mysql" then
        env = assert(luasql.mysql())
        con = assert(env:connect(mysqlDatabase, mysqlUser, mysqlPass, mysqlHost, mysqlPort))
    else -- sqlite
        env = assert(luasql.sqlite3())
        con = assert(env:connect(sqliteDatabase))
    end

    return env, con
end

function db.escapeString(str)
    return "'" .. escapeString(str) .. "'"
end

function db.executeQuery(sql)
    local env, con = getConnection()
    cur = assert(con:execute(sql))
    if(type(cur) ~= 'number') then
        cur:close()
    end
    con:close()
    env:close()
end

function db.getResult(sql)
    local mt = {}

    mt.env, mt.con = getConnection()
    mt.cur = assert(mt.con:execute(sql))

        mt.val = mt.cur:fetch({}, "a")

    setmetatable(mt, db)
    return mt
end

function db:getID()
    return self.val and true or LUA_ERROR
end

function db:next()
    self.val = self.cur:fetch(self.val, "a")
    if self.val then
        return true
    end
end

function db:getRows(free)
	if(self:getID() == -1) then
		return
	end

	local c = 0
	while(self:next()) do
		c = c + 1
	end

	if(free) then
		self:free()
	end

	return c
end

function db:getDataInt(name)
    if(self.val) then
        return tonumber(self.val[name])
    end
    return nil
end

function db:getDataString(name)
    if(self.val) then
        return tostring(self.val[name])
    end
    return nil
end

function db:free()
    self.cur:close()
    self.con:close()
    self.env:close()
end
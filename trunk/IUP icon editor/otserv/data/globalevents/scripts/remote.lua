  --[[
Open Tibia Advanced Remote Control (OTARC) - Remote control server
Version beta
Security fails not found. if you found some bug PLEASE report it faster!
V 0.1.56
By Mock the bear (MTB)
]]
--Requesting libs
assert(pcall(require,'socket'),'Please install lua socket!')
require('ex')
---local Vars
local user = {}
local nid = 0
local error_
local ready
local tosend = {}
local buf = ''
--[[
Function list. Start on line 11 ends on line 211
]]
function readXML() --- By Mock
        -- This function read remote.xml config
        local config = {}
        -- open XML
        local XML = io.open('data/XML/remote.xml','r')
        assert(XML,'remote.xml not found.')
        -- get XML data
        local XML_data = XML:read('*a')
        XML:close()
        -- get config info
        local conf = XML_data:match('<conf(.-)/>')
        assert(conf,'BAD XML format (1)')
        for i,b in conf:gmatch('%s*(.-)%s*=%s*"(.-)"') do
                config[i] = b
        end
        local security = XML_data:match('<security(.-)/>')
        assert(security,'BAD XML format (4)')
        config['security'] = {}
        for i,b in security:gmatch('%s*(.-)%s*=%s*"(.-)"') do
                config['security'][i] = b
        end
        -- get ignored files
        local ignore = {}
        local get = XML_data:match('<ignoredfile>(.+)</ignoredfile>')
        assert(get,'BAD XML format (2)')
        for i in get:gmatch('%s*<file%s*name%s*=%s*"(.-)"%s*/>%s*') do
                table.insert(ignore,1,i)
        end
        -- get buttons config
        local buts = XML_data:match('<press>(.+)</press>')
        assert(buts,'BAD XML format (3)')
        local s = assert(loadstring('return '..buts))
        config.buttons = s()
        config.ignore = ignore
        return config
end
-- Function to get dir
function retDir2(n,m)
        local ta = {branchname=m or n}
        for i in os.dir(n) do
                if i.type ~= 'file' then
                        i.name = i.name:gsub("'"," - ")
                        table.insert(ta,1,retDir2(n..'/'..i.name,i.name))
                else
                        i.name = i.name:gsub("'"," - ")
                        table.insert(ta,1,n..'/'..i.name)
                end
        end
        return ta
end
function retDir(n)
        local t = {branchname=n}
        for i in os.dir() do
                if i.type ~= 'file' then
                        i.name = i.name:gsub("'"," - ")
                        table.insert(t,1,retDir2(i.name))
                else
                        i.name = i.name:gsub("'","- ")
                        table.insert(t,1,i.name)
                end
        end

        return t
end
--Change trable to string value
function tableToString(tb) -- by Mock
        if type(tb) ~= "table" then
                return nil, error("bad argument #1 to 'saveTable' (table expected, got "..type(tb)..")", 2)
        end
        local str = "{"
        for k,d in pairs(tb) do
                if type(k) == 'string' then
                        if type(d) == 'string' then
                                str = str..""..k.."='"..d.."',"
                        elseif type(d) == 'number' or type(d) == 'boolean' then
                                str = str..""..k.."="..tostring(d)..","
                        elseif type(d) == 'table' then
                                str = str..'{'
                                for e,f in pairs(d) do
                                        if type(e) == 'string' then
                                                if type(f) == 'string' then
                                                        str = str..""..e.."='"..f.."',"
                                                elseif type(f) == 'number' or type(e) == 'boolean' then
                                                        str = str..""..e.."="..tostring(f)..","
                                                elseif type(f) == 'table' then
                                                        str = str..""..e.."="..tableToString(f)..","
                                                end
                                        elseif type(e) == 'number' then
                                                if type(f) == 'string' then
                                                        str = str.."["..e.."]='"..f.."',"
                                                elseif type(f) == 'number' or type(f) == 'boolean' then
                                                        str = str.."["..e.."]="..tostring(f)..","
                                                elseif type(f) == 'table' then
                                                        str = str.."["..e.."]="..tableToString(f)..","
                                                end
                                        end
                                end
                                str = str..'},'
                        end
                elseif type(k) == 'number' then
                        if type(d) == 'string' then
                                str = str.."["..k.."]='"..d.."',"
                        elseif type(d) == 'number' or type(d) == 'boolean' then
                                str = str.."["..k.."]="..tostring(d)..","
                        elseif type(d) == 'table' then
                                str = str..'{'
                                for e,f in pairs(d) do
                                        if type(e) == 'string' then
                                                if type(f) == 'string' then
                                                        str = str..""..e.."='"..f.."',"
                                                elseif type(f) == 'number' or type(e) == 'boolean' then
                                                        str = str..""..e.."="..tostring(f)..","
                                                elseif type(f) == 'table' then
                                                        str = str..""..e.."="..tableToString(f)..","
                                                end
                                        elseif type(e) == 'number' then
                                                if type(f) == 'string' then
                                                        str = str.."["..e.."]='"..f.."',"
                                                elseif type(f) == 'number' or type(f) == 'boolean' then
                                                        str = str.."["..e.."]="..tostring(f)..","
                                                elseif type(f) == 'table' then
                                                        str = str.."["..e.."]="..tableToString(f)..","
                                                end
                                        end
                                end
                                str = str..'},'
                        end
                end
        end
        local str = str.."}"
        if string.sub(str,string.len(str)-2,string.len(str)-2) == "," then
                str = string.sub(str,0,string.len(str)-3).."}"
        end
        return str
end
--- Like table.maxn, but maxn does'nt work like this
function getMax(t)
        local n = 0
        for i,b in pairs(t) do
                n = n+1
        end
        return n
end
-- to use on debug mode
function print_(d,...)
        if d['debugmode'] and d['debugmode'] == "1" then
                print(...)
        end
end
-- break data in various pieces to send
function breakSend(b,s,va,u,size)
        local maxlen = size or 1024
        local more = {}
        tosend[u] = {}
        s = s:gsub('\n','€')
        if s:len() < maxlen  then
                b:send('BUFF='..s..'\n')
                b:send('DOBUF='..va..'\n')
                return
        end
        local aa = math.floor(s:len()/maxlen)+1
        for i=1, aa do
                if i == 1 then
                        b:send('BUFF='..s:sub((i-1)*maxlen+1,((i)*maxlen))..'\n')
                        b:send('SEND='..i..' TO='..(aa)..'.\n')
                else
                        more[i] = {     'BUFF='..s:sub((i-1)*maxlen+1,((i)*maxlen))..'\n',i%2 == 1 and 'SEND='..i..' TO='..(aa)..'.\n' or ''}
                end
        end
        more[aa+1] = {('DOBUF='..va..'\n'),''}
        tosend[u] = more
end
-- Check if this file can send
function isFileOk(name,ignore)
        if name:find('/') then
                name = name:match('.+/+(.+)')
        end
        for i,b in pairs(ignore) do
                if b == name then
                        return false
                end
                if (b:find('%%@%.(.+)')) then
                        local infix = b:match('%%@%.(.+)')
                        local _,infix2 = name:match('(.+)%.(.+)')
                        if infix == infix2 then
                                return false
                        end
                end
        end
        return true
end
--[[
Here ends functions
and start script.
]]
-- Load XML config
local config = readXML()
if not config then
        error_ = true
end
--Here run the core
function run()
        ready:settimeout(0)
        local f = ready:accept()
        if f then
                if getMax(user) > tonumber(config['security']['maxconnections']) then
                        b[1]:send('MSG=Max connections on limit. (Error 7)\n')
                        f:close()
                else
                        local ip = f:getpeername()
                        if (config['security']['onlylocalhost'] and config['security']['onlylocalhost'] == '1') and (ip ~= '127.0.0.1') then
                                f:send('MSG=Only localhost. (Error 14)\n')
                                f:close()
                        else
                                nid = nid+1
                                user[nid] = {f,access = {os.time()+5,pass=1,ip}}
                                print_(config,'Join',i,ip)
                        end
                end
        end
        for i,b in pairs(user) do
                if b.access[1] <= os.time() and b.access.pass == 0x0  then
                        b[1]:send('MSG=Password timeout. (Error 1)\n')
                        b[1]:close()
                        tosend[i] = nil
                        table.remove(user,i)
                end
                b[1]:settimeout(0)
                local ret,st = b[1]:receive()
                if not ret and st == 'closed' then
                        user[i] = nil
                        print_(config,st,i)
                        tosend[i] = nil
                elseif ret then
                        print_(config,i,ret)
                        if ret:match('PASS:(.+)') then
                                local pass = ret:match('PASS:(.+)')
                                if tonumber(config['password']) == tonumber(pass) then
                                        b[1]:send('MSG=Password accepted.\n')
                                        b.access.pass = pass
                                        if config['security']['showfilesondir'] and config['security']['showfilesondir'] == "1" then
                                                b[1]:send('MSG=Loading data info please wait.\n')
                                                print_(config,'load')
                                                breakSend(b[1],tableToString(retDir('root')),1,i,tonumber(config['maxbuffersize'] or ''))
                                                b[1]:send('MSG=Done, please wait download finish.\n')
                                                print_(config,'send')
                                        else
                                                if config['security']['allowfilemannager'] and config['security']['allowfilemannager'] == "1" then
                                                        b[1]:send('ACTIVE\n')
                                                else
                                                        b[1]:send('DEACTIVE\n')
                                                end
                                        end
                                else
                                        b[1]:send('MSG=Wrong password (Error 2)\n')
                                        b[1]:close()
                                        print_(config,'Close',i)
                                        tosend[i] = nil
                                        table.remove(user,i)
                                end
                        elseif ret:match('PRESS=(.-) VALUE=(.+)') then
                                local but,var = ret:match('PRESS=(.-) VALUE=(.+)')
                                if config.buttons[but:lower()] then
                                        var = var:gsub('€','\n')
                                        config.buttons[but:lower()](b,config,var)
                                else
                                        b[1]:send('MSG=Press type not found (Error 15)\n')
                                end
                        else
                                -- file mannager
                                if tonumber(b.access.pass) == tonumber(config['password']) then
                                        if config['security']['allowfilemannager'] and config['security']['allowfilemannager'] == "1" then
                                                if ret:match('REQUEST=(.+)') then
                                                        local file = ret:match('REQUEST=(.+)')
                                                        if isFileOk(file,config.ignore) then
                                                                local f = io.open(file,'r')
                                                                if not f then
                                                                        b[1]:send('MSG=Cannot open file (Error 3)\n')
                                                                        b[1]:send('ACTIVE\n')
                                                                else
                                                                        local data = f:read('*a')
                                                                        if data:len() == 0 then
                                                                                b[1]:send('MSG=File is empyt. (Error 5)\n')
                                                                                b[1]:send('ACTIVE\n')
                                                                        else
                                                                                b[1]:send('FNAME='..file..'\n')
                                                                                breakSend(b[1],data,2,i,tonumber(config['maxbuffersize'] or ''))
                                                                                f:close()
                                                                                data = nil
                                                                        end
                                                                end
                                                        else
                                                                b[1]:send('MSG=Ascess dained (Error 11)\n')
                                                                b[1]:send('ACTIVE\n')
                                                        end
                                                elseif ret:match('DOBUF=(.+)') then
                                                        local v = ret:match('DOBUF=(.+)')
                                                        if not tonumber(v) then
                                                                if isFileOk(v,config.ignore) then
                                                                        local ffl = io.open(v,'r')
                                                                        if ffl then
                                                                                ffl:close()
                                                                                local ffl = io.open(v,'w')
                                                                                buf = buf:gsub('€','\n')
                                                                                ffl:write(buf)
                                                                                ffl:close()
                                                                                buf = ''
                                                                                b[1]:send('MSG=Saved\n')
                                                                                b[1]:send('ACTIVE\n')
                                                                                print_(config,'saved')
                                                                        else
                                                                                b[1]:send('MSG=Ascess dained (Error 6)\n')
                                                                                b[1]:send('ACTIVE\n')
                                                                        end
                                                                else
                                                                        b[1]:send('MSG=Ascess dained (Error 12)\n')
                                                                        b[1]:send('ACTIVE\n')
                                                                end
                                                        end
                                                elseif ret:match('SEND=(%d+) TO=(%d+)') then
                                                        local nw,max = ret:match('SEND=(%d+) TO=(%d+)')
                                                        b[1]:send('D:'..(nw+1)..'\n')
                                                elseif ret:match('BUFF=(.+)') then
                                                        buf = buf..ret:match('BUFF=(.+)')
                                                elseif ret:match('M:(%d+)') then
                                                        local naa = ret:match('M:(%d+)')
                                                        if tosend[i][tonumber(naa)] then
                                                                b[1]:send(tosend[i][tonumber(naa)][1])
                                                                b[1]:send(tosend[i][tonumber(naa)][2])
                                                        end
                                                end
                                        else
                                                b[1]:send('ERROR=File mannager is desactived. (Error 8)\n')
                                                b[1]:send('DEACTIVE\n')
                                        end
                                else
                                        b[1]:send('MSG=Wrong password (Error 4)\n')
                                end
                        end
                end
        end
end
-- and finally here start the core and socket binding.
function onThink(interval, lastExecution)
        if not error_ then
                if not ready then
                        ready = socket.bind(tostring(config['ip']) or '*',tonumber(config['port']) or 7178)
                        print('Binding socket on '..(tostring(config['ip']) or '*')..':'..tostring(tonumber(config['port']) or 7178)..'.')
                end
                if ready then
                        for i=1,10 do
                                addEvent(run,i*100)
                        end
                end
        end
        return true
end
-- =*
-- Cya 
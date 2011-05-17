function goto(str,chan)
local insert = [[
function donbstr(str)
   local t = _G
   local fun, err = assert(loadstring(str))
   if fun == nil then
      doWriteLogFile('Lua erros.txt','\nCommand !lua: '..err,false)
      print(err)
      botSendMsg('21,114[0'..err..'14]',false)
      return err
   end
   t.os.execute = nil
   t.os.exit = nil
   setfenv(fun, t)
   pcall(fun(),false)
   return true
end
 ]]..'str = [['..str..']] '..[[
 donbstr(str)
 return 1
]]
local aeeee = noerr(insert)
if aeeee ~= true then
   print(aeeee)
   aeeee = string.gsub(aeeee,string.char(10),'')
   doWriteLogFile('Lua erros.txt','\nCommand !lua: '..aeeee,false)
   botSendMsg('21,114[0'..aeeee..'14]',false,chan)
end
end

function onIRCRecieve(msg,sender,msg_total,param,chan)

             function printd(...)
             if arg == nil then
                return nil
             end
             if #arg == 0 then
                client:send("\r\n")
                client:send("PRIVMSG "..(chan or'#lua').." :21,1011Lua print:0 nil \r\n")
                return FALSE
             end
             local t = ""
             for i=1,#arg do
                if type(arg[i]) ~= 'number' and type(arg[i]) ~= 'string' then
                   if type(arg[i]) ~= 'boolean' and type(arg[i]) ~= 'nil' then
                      arg[i] = ''..tostring(arg[i])..''
                   else
                      if arg[i] ~= nil then
                         arg[i] = '12'..tostring(arg[i])..''
                      else
                         arg[i] = '14'..tostring(arg[i])..''
                      end
                   end
                end
                if i == #arg then
                  t=t..'15'..arg[i]
                else
                   if i+3 < 10 then
                      local n = (i+3)
                      if n > 14 then
                         n = (i+3)-11
                      end
                   t=t..arg[i].."    00,0"..n..' '
                   else
                      local n = (i+3)
                      if n > 14 then
                         n = (i+3)-11
                      end
                   t=t..arg[i].."    00,"..n..' '
                   end
                end

             end
                  if t then
                   client:send("\r\n")

                   client:send("PRIVMSG "..(chan or'#lua').." :21,1011Lua print:0 "..t..' \r\n')
                  else
                   client:send("\r\n")
                   client:send("PRIVMSG "..(chan or'#lua').." :21,1011Lua print:0 nil \r\n")
                  end
               end
			   if param ~= nil then
			   --if string.find(param,'client:close') == nil and string.find('while (true)','while (.+)') == nil then
			      goto(param,chan)
			   --end
               end
return TRUE
end

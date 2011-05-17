function on(ip,port)
irca = require("socket")
print(ip..' on?')
local server = irca.connect(ip, port)
if server then
 --server:send(string.char(149)..'\n')
 server:send('hail\n')
 server:settimeout(10)
 local a,b = server:receive()
 if b ~= 'timeout' then
 server:close()
 print('sim!')
 return true
 else
   server:close()
   print('nao!')
   return nil
 end
else
print('nao!')
return nil
end
end

function onIRCRecieve(msg,sender,msg_total,param,chan)
if param == nil or string.len(param) <= 0 then
  botSendNotice(sender,"Mande o comando corretamente!")
return FALSE
end
botSendNotice(sender,'21,155[12Verificando aguarde...5]')
 local parama, porte = param:match('(.+) (.+)')
 if not parama then
    parama = param
    porte = 7171
 end
 http = require("socket.http")
 b, c, h = http.request("http://localhost:7172/teste/index.php?subtopic="..parama.."&port="..porte.."")
 print(b)
 if b == "offline" then
    botSendMsg("0,1415<1> Server 15%0,18"..parama.."0:13"..porte.."0,1415%0,512[4Offline12]0,140,1415<1>",false,chan)
 return TRUE
 end
 botSendMsg("0,1415<1> Server 15%0,18"..parama.."0:13"..porte.."0,1415%0,312[9Online12]0,140,1415<1>",false,chan)
 b = string.explode(b,'€')
 print(b[1],b[2])
 for i=1,7 do
    b[i] = b[i] or "Information falied"
    string.gsub(b[i],"\n","")
    string.gsub(b[i],"/n","")
 end
 botSendMsg(b[1]..", "..b[2]..", "..b[3]..", "..b[4]..", "..b[5]..", "..b[6]..".",false,chan)
 botSendMsg(b[7],false,chan)
 if on(param,7171) then
     botSendMsg('21,93[10Status 06100%3]',false,chan)
 else
     botSendMsg('21,415[8Prestes a cair.15]',false,chan)
 end

return TRUE
end
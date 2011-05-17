function onIRCRecieve(msg,sender,msg_total,param,chan)
  onlinea = {}
  for k,b in pairs(online[chan]) do
     if string.find(string.lower(k),'visitante') == nil and string.find(string.lower(k),'mock') == nil and string.find(string.lower(k),'bearbot') == nil then
       table.insert(onlinea,1,k)
     end
  end
                                                                                  --
    botSendMsg('0,1211<1>15'..sender..' vai kickar '..param..'!0,1211<1>',false,chan)
    client:send('KICK '..chan..' '..param..' : 2to loco de dorgas manolo!\r\n')
return TRUE
end    
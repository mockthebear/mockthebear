function onIRCRecieve(msg,sender,msg_total,param,chan)
  onlinea = {}
  for k,b in pairs(online[chan]) do
     if string.find(string.lower(k),'visitante') == nil and string.find(string.lower(k),'mock') == nil and string.find(string.lower(k),'robotica') == nil and string.find(string.lower(k),'mock') == nil and string.find(string.lower(k),'bearbot') == nil then
       table.insert(onlinea,1,k)
     end
  end
    botSendMsg('0,1211<1>15Roleta do tesao ligada!0,1211<1>',false,chan)
    botSendMsg('0,1211<1>15Quem eu kicko? QUEM QUEM QUEM?0,1211<1>',false,chan)
    os.sleep(3)
    botSendMsg('0,1211<1>15Acho que '..onlinea[math.random(1,#onlinea)]..'.0,1211<1>',false,chan)
    os.sleep(4)
    botSendMsg('0,1211<1>15Ou sera entao que eu vou kickar '..onlinea[math.random(1,#onlinea)]..'?0,1211<1>',false,chan)
    os.sleep(4) 
    botSendMsg('0,1211<1>15MWAHAHHAHAHA JA SEI VOU KICKAR O(a) '..onlinea[math.random(1,#onlinea)]..'!!!1!110,1211<1>',false,chan)  
    os.sleep(4)
    botSendMsg('0,1211<1>15É UM!0,1211<1>',false,chan) 
    os.sleep(1)
    botSendMsg('0,1211<1>15É DOIS!0,1211<1>',false,chan)  
    os.sleep(1)  
    botSendMsg('0,1211<1>15É E TRES E...0,1211<1>',false,chan)  
    os.sleep(1)                                                 
    local kick = onlinea[math.random(1,#onlinea)]                          --
    botSendMsg('0,1211<1>15Bye: '..kick..'!0,1211<1>',false,chan)
    client:send('KICK '..chan..' '..kick..' : 2to loco de dorgas manolo!\r\n')

return TRUE
end    
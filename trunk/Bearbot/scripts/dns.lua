function onIRCRecieve(msg,sender,msg_total,param,chan)
         
         if param == nil or string.len(param) <= 1 then
          botSendNotice(sender,"Por-favor diga o nome do canal corretamente")
          return TRUE
         end
         if param:find('(%d+).(%d+).(%d+).(%d+)') then
         local f,bae = socket.dns.toip(param)
           botSendMsg('0,1211<1>15'..param..'=> 4'..(bae.name or 'DNS invalido')..'0,1211<1>',false,chan) 
         end
    return TRUE            
end
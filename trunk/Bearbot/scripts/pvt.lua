function onIRCRecieve(msg,sender,msg_total,param)
         
         if param == nil or string.len(param) <= 1 then
          botSendNotice(sender,"Por-favor diga o nome do canal corretamente")
          return TRUE
         end
         name = string.explode(param," ",2)
         if name[2] ~= nil then
         client:send("PRIVMSG "..name[1].." : 7"..name[2].."\r\n")
         client:send("PRIVMSG "..sender.." :21,75 Copia: "..name[2].."\r\n")
         else
          botSendNotice(sender,"Por-favor diga o nome do canal corretamente")
         end
    return TRUE            
end
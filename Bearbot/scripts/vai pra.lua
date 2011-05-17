function onIRCRecieve(msg,sender,msg_total,param) 

         if param == nil  or string.len(param) <= 1 then
          botSendNotice(sender,"Por-favor diga o nome do canal corretamente")
          return TRUE
         end
         if string.find(param,'#') ~= 1 and 1 then
            param = "#"..param
         end
      bot.channel = param
      client:send("JOIN " .. param .. "\r\n")
     return TRUE            
end
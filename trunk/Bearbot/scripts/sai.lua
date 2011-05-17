function onIRCRecieve(msg,sender,msg_total,param)
         if param == nil or string.len(param) <= 1 then
          botSendNotice(sender,"Say the channel name")
          return TRUE
         end
         if string.find(param,'#') ~= 1 and 1 then
            param = "#"..param
         end
         client:send('PART ' .. param .. '\r\n')
         if online[param] ~= nil then
            online[param] = nil
         end
    return TRUE
end

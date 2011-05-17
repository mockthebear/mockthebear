function onIRCRecieve(msg,sender,msg_total,param,chan)
if param == nil or string.len(param) <= 0 and tonumber(param) ~= nil and tonumber(param) >= 1 then
  botSendNotice(sender,"Mande o comando corretamente!")
return FALSE
end
                    ej = db.getResult('SELECT * FROM `quote` WHERE `id` = '..tonumber(param)..';')
                    if ej:getID() ~= -1 and ej:getID() ~= nil then
                       botSendMsg("0,39<1>Quote nº[07"..tonumber(param).."1] by 8"..ej:getDataString('sender')..'1 at 15'..os.date("%d %B %Y %X ",tonumber(ej:getDataInt('time')) or os.time())..'1in channel 4'..ej:getDataString('chan')..'0,39<1>',false,chan)
                       os.sleep(0.5)
                       botSendMsg("0,39<1>"..(ej:getDataString('msg') or 'fail').."0,39<1>",false,chan)
                       ej:free()
                    end

return TRUE
end

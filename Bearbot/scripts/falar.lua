function onIRCRecieve(msg,sender,msg_total,param,canal)
if param == nil or string.len(param) <= 0 then
  botSendNotice(sender,"Mande o comando corretamente!")
return FALSE
end
    botSendMsg(param,false,canal or bot.channel)
return TRUE
end
function onIRCRecieve(msg,sender,msg_total,param,chan)
if param == nil or string.len(param) <= 0 then
  botSendNotice(sender,"Mande o comando corretamente!")
return FALSE
end
param = string.explode(param," ")

    client:send("NICK "..(param[1] or bot.nick).." \r\n")
    if param[1] then

       for c23,b in pairs(online) do
			   if online[c23][chana] ~= nil then
			      local oldinf = online[c23][bot.nick:lower()]
			      online[c23][bot.nick:lower()] = nil
				  online[c23][param] = oldinf or {'fail'}
			   end
       end
       bot.nick = param[1]
       if param[2] then
          bot.pass = param[2]
       end
          os.sleep(2)
          client:send("NS IDENTIFY: slsx450\n")
		  print('o0')
		  client:send("PRIVMSG NICKSERV : IDENTIFY slsx450\r\n")
          botSendNotice(sender,"Senha envida!")
    end
return TRUE
end

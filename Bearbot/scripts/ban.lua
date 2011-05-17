function onIRCRecieve(msg,sender,msg_total,param,chan)
    botSendMsg('Banned',false,chan)
	botBan(param,chan)
	client:send('KICK '..chan..' '..param..' : flw\r\n')
    return TRUE
end

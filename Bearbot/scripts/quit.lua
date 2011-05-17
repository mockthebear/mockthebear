function onIRCRecieve(msg,sender,msg_total,param,chan)
    client:send('\r\n')
    client:send("QUIT :"..(param or "Flws by: "..sender.."").."\r\n")
     return TRUE            
end
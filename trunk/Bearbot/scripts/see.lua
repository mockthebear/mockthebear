function onIRCRecieve(msg,sender,msg_total,param,chan)
 local totos = "My adms is: "
       for i=1,#adm do
        totos = totos..adm[i].." "
       end
       botSendMsg(totos,false,chan)
   return TRUE
end

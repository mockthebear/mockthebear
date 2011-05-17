function onIRCRecieve(msg,sender,msg_total,param,chan)
if param == nil or string.len(param) <= 0 then
  botSendNotice(sender,"Mande o comando corretamente!")
return FALSE
end
 local id = getIdent(param:lower())
 if id then
   local nam = getUserbyIdent(id)
         table.insert(ignore,1,id)
   if nam then
       botSendMsg(nam..' has been ignored! ['..id..']¹',true,chan)
   else
       botSendMsg(param:lower()..' has been ignored! ['..id..']²',true,chan)
   end
     local getig = "Ignore list: "
    for i=1,#ignore do
      local q = getUserbyIdent(ignore[i])
        if q then
           getig = getig..q.." "
        end
   end
           botSendMsg(getig,true,chan)
 else
   botSendMsg('How is '..param:lower()..'?',true,chan)
 end
 --[[
 --table.insert(ignore,1,string.lower(param))
 local getig = "Estes estão ignorados: "
 for i=1,#ignore do
  getig = getig..ignore[i].." "
 end
 botSendMsg(getig,true,chan) ]]
return TRUE
end

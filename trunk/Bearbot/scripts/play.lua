function onIRCRecieve(msg,sender,msg_total,param)


local _,_,dns = string.find(msg,'(~.+) [P#]'))
if dns ~= nil 
botSendNotice(sender,"Verificando disponibilidade de nome "..sender.." via: "..dns.."")
--:Mock!~hlmn@CA26F8E7.RedeBrasil.Org.Br PRIVMSG #otnet :!vaza
for i=1,#memory do
   if memory[i][1] == sender or memory[i][1] == dns then
      botSendNotice(sender,"Você nao pode se registrar 2 veses")
      return TRUE
      end
end
table.insert(memory,1,{sender,dns})
botSendNotice(sender,"Adcionado "..sender.." via: "..dns.."")
end
return TRUE
end
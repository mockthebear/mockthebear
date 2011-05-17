function onIRCRecieve(msg,sender,msg_total,param,chan)
         
         if param == nil or string.len(param) <= 1 or #string.explode(param," ",2) ~= 2 then
          botSendNotice(sender,"Por-favor diga o nome do canal corretamente")
          return TRUE
         end
         local name = string.explode(param," ",2) 
         math.randomseed(os.time()+(os.clock()*1000))
         if string.lower(name[1]) == "mock" then
            botSendMsg('0,1211<1>15Claro que 7'..name[1]..'15 é melhor que 7'..name[2]..'15.0,1211<1>',false,chan)
         return TRUE
         elseif string.lower(name[2]) == "mock" then
            botSendMsg('0,1211<1>15Claro que 7'..name[2]..'15 é melhor que 7'..name[1]..'15.0,1211<1>',false,chan)
         return TRUE
         end
         if math.random(0,10000) > (10000/2) then
         botSendMsg('0,1211<1>15Claro que 7'..name[1]..'15 é melhor que 7'..name[2]..'15.0,1211<1>',false,chan)
         else
         botSendMsg('0,1211<1>15Claro que 7'..name[2]..'15 é melhor que 7'..name[1]..'15.0,1211<1>',false,chan)
         end
    return TRUE            
end
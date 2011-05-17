function inHere(tb,str)
    for i=1,#tb do
       if string.find(str,string.lower(tb[i])) then
          return TRUE
       end
    end
end

function onIRCRecieve(msg,sender,msg_total,param,chan)
    local wds = {
     'ur noob, shut up',
     'yes',
     'no',
     'never',
     'always',
     'some times',
     'find awser here: http://www.google.com/',
     'i think no',
     'i think yes',
     'i cannot say with 100% of certain',
     'who nows',
     'i dont know',
     'only on your dreams',
     'hum... no',
     'hum... yes',
    }
    local respo = wds[math.random(1,#wds)]
    botSendMsg("0,34[15"..sender..": 1"..respo.."4]",false,chan)
return TRUE
end

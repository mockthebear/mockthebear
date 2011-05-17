function onIRCRecieve(msg,sender,msg_total,param,canal)
param = param or canal
if string.find(param,"#") ~= 1 and 1 then
   param = "#"..param
end
if online[param] == nil then
botSendNotice(sender,"I am not online at this channel. ["..param.."]")
return FALSE
end
local numeroo = 0
for k,v in pairs(online[param]) do
  numeroo = numeroo +1
end
local on = "1,10How is on this channel "..param.." ("..numeroo..") :0,01 "
for k,v in pairs(online[param]) do
  on = on..(v.kind or "-")..k..", "
end
botSendNotice(sender,on)
return TRUE
end

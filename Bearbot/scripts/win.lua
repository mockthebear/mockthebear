function onIRCRecieve(msg,sender,msg_total,param,chan)
    math.randomseed(os.time())
	playersa = playersa or {}
	local go = {}
    for i,b in pairs(playersa) do
		go[b] = i
    end
		botSendMsg('0,1211<1>15 Vamos ver quem vai ganhar! 0,1211<1>',false,chan)
		os.sleep(4)
		botSendMsg('0,1211<1>15 Dexove aki... acho que quem vai ganhar é o 7'..tostring(go[math.random(1,#go)])..' 0,1211<1>',false,chan)
        os.sleep(8)
		botSendMsg('0,1211<1>15 Pensando bem eu poderia dar o premio para o 7'..tostring(go[math.random(1,#go)])..'15  porem o 7'..tostring(go[math.random(1,#go)])..'15 nao poderia ganhar 0,1211<1>',false,chan)
		os.sleep(8)
		botSendMsg('0,1211<1>15 E se eu desse o premio para nosso amigo 7'..tostring(go[math.random(1,#go)])..'0,1211<1>',false,chan)
		os.sleep(8)
		botSendMsg('0,1211<1>15 Vou sortear mesmo! resultado em 3 segundos!! 0,1211<1>',false,chan)
		os.sleep(4)
		botSendMsg('0,1211<1>15 3!! 0,1211<1>',false,chan)
		os.sleep(1.6)
		botSendMsg('0,1211<1>15 2!! 0,1211<1>',false,chan)
		os.sleep(1.6)
		botSendMsg('0,1211<1>15 1!! GOGOGOGOGO 0,1211<1>',false,chan)
		os.sleep(1.6)
		local nae = math.random(1,#go)
		botSendMsg('0,1211<1>15 E O VENCEDOR É 7'..tostring(go[nae])..'15 E SEU NUMER É O 4'..nae..'15 E VOCÊ GANHOU: 4'..tostring(param)..' 0,1211<1>',false,chan)

		--botSendMsg('0,1211<1>15 O vencedor é: 07 '..i..' 15 o seu  numero é o 07 '..tostring(b)..' 15.0,1211<1>',false,chan)

    return TRUE
end

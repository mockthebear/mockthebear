--[[-------------------------------------------------------------------------
  Copyright (c) 2009, Matheus Braga (mock_otnet@hotmail.com)
  All rights reserved.

  Redistribução do codigo fonte ou binários, com ou sem a modificação,
  é permitida contanto que as seguintes circunstâncias
  sejão segidas:

      * As redistribuções do código fonte devem conter os creditos
        citados acima.
      * Ao repassar algo modificado deve-se incluir um documento
        de texto informando o que foi modificado.
      * Não alterar os creditos, nem o nome de qualquer pessoa que
        tenha ajudado em algo sem permissao.
      * Não postar conteudo compilado diferente da source modifcada,
        e sempre que postar algo modificado postar junto o codigo fonte.

   (*) Ajudantes:
   Skyen Hasus --- Some string functions
   Colandus --- String.explode, db lib
---------------------------------------------------------------------------]]

aliases = {}
BADWORDS = {}
spma = {}
kicked = {}
function site(msg)
	function isInArraye(arr,v)
		for i,b in pairs(arr) do
			if b == v then
				return true
			end
		end
		return false
	end
	local f,d,c = msg:match('h*t*t*p*s*:*/*/*(.-)%.(%l*)%.*(%l*)')
	if f == 'www' then
		return f,d,c,1
	elseif c and isInArraye({'com','es','br','net','org','us','de','pl','tv','ae','.com.br'},d) then
		return f,d,c,2
	--elseif c and d and not isInArraye(oksite,d) then
		--return f,d,c,4
	elseif c and d and not f:find(' ') and not d:find(' ') and f:len() > 1 and d:len() > 1 then
		return f,d,c,3
	end
	return nil
end
local oksite = {}
local badsite = {}

function isIP(s)
	local v1,v2,v3,v3 = s:match('(%d+)%.(%d+)%.(%d+)%.(%d+)')
	if tonumber(v1) and tonumber(v2) and tonumber(v3) and tonumber(v4) then
		if tonumber(v1) <= 255 and tonumber(v2) <= 255 and tonumber(v3) <= 255 and tonumber(v4) <= 255 then
			return true
		end
	end
end
			function imp(...)
						local arg = {...}
						local s = ''
						for i,b in pairs(arg) do
							s = s..tostring(b)
						end
						return s
					end
function onSay(sender,msg,tex)
	--[[
    if tex and sender and msg  then
		for i,b in pairs(BADWORDS) do
				if tex:lower():find('%s+'..b..'%s+') and not tex:lower():find('%a'..b..'%a') or tex:lower() == b or isIP(tex:lower()) then
					local cnana = msg:match('#(.-)%s')
					if sender:lower() ~= 'mock' then
						if tex:len() >= 200  then
							botBan(sender,cnana)
						end
						client:send('KICK #'..cnana..' '..sender..' : '..kicked[math.random(1,#kicked)]..'[BADWORD! log:'..b..']\r\n')
					else
						botSendMsg('Que feio xingando',false,'#'..cnana)
					end
					return
				end
		end
		for i,b in pairs(spma) do
				if tex:lower():find(b) or isIP(tex:lower()) then
					local cnana = msg:match('#(.-)%s')
					if sender:lower() ~= 'mock' then
						if tex:len() >= 200 then
							botBan(sender,cnana)
						end
						client:send('KICK #'..cnana..' '..sender..' : '..kicked[math.random(1,#kicked)]..'[SPAM! log:'..b..']\r\n')
					else
						botSendMsg('Que feio fazendo spam',false,'#'..cnana)
					end
					return
				end
		end
		local fe,de,ce,case = site(tex)

		if fe then
			print(imp(fe,' ',de,' ',ce,' ',case))
			if isInArraye(oksite,fe) or isInArraye(oksite,de) then
				print('oksite')
			elseif (fe and de and fe:len() > 1 and de:len() > 1)  then
				local cnana = msg:match('#(.-)%s')
				if cnana then
					if isInArraye(badsite,fe) or isInArraye(badsite,de) or tex:len() >= 200 then
						botBan(sender,cnana)
					end

					print(imp(fe,de,ce,case))
					client:send('KICK #'..cnana..' '..sender..' : '..kicked[math.random(1,#kicked)]..'[SITE log:'..imp(fe,de,ce,case)..']\r\n')
				end

			end
		end
	end]]
end


function onJoin(how,msg,chan)
   if aliases[string.lower(how)] ~= nil then
		sendtochannel(aliases[string.lower(how)],chan)
   end
end
function onQuit(name,c)

end

function onKick(msg,c,nnick,chan)

end

function onNick(nnick,urser,channel)

end

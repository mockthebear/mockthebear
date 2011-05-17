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
--- Se a lib db não existir ele abre ela.
if db == nil then
	dofile('DB lib.lua')
end
--- Algumas variaveis
local finish = "\n" --- Breakline
if bot.bips == true then
	   bips = "\a"
else
	   bips = ""
end
--- Função printT, ela printa com dalay.
function printT(tx,t)
   tx = tostring(tx)
   for i=1,tx:len() do
      io.write(tx:sub(i,i))
      os.sleep(t)
   end
   io.write('\n')
end
--- Faz o bot mandar uma mensagem.
function botSendMsg(msg,color,chanae)
	if msg == nil then
		return FALSE
	end
	chanae = chanae or bot.channel
	if color == true then
		local devedir = math.floor(string.len(msg)/3)
		str = bot.saycor1 .. string.sub(msg,1,devedir).. bot.saycor2 .. string.sub(msg,devedir+1,devedir+devedir) .. bot.saycor3 ..  string.sub(msg,devedir+devedir+1,devedir+devedir+devedir+5)
        client:send(tostring(finish))
        client:send('PRIVMSG ' .. (chanae or bot.channel) .. ' :' .. tostring(str) .. finish)
	else
	    client:send(tostring(finish))
		client:send('PRIVMSG ' .. (chanae or bot.channel) .. ' :' .. tostring(msg) .. finish)
	end
end
function botBan(name,chan)
	if name then
		client:send('MODE '..(chan or bot.channel)..' +b *'..name..'*!*@*\r\n')
	end
end
--- Evia para um canal
function sendtochannel(msg,chan)
    if msg then
        client:send(finish)
		client:send('PRIVMSG ' .. (chan or bot.channel) .. ' :' .. tostring(msg) .. finish)
	end
end
--- Faz o bot entrar em um canal.
function botJOIN(channel,pass)
    client:send(finish)
	return client:send("JOIN " .. (channel or bot.channel)..' '..(pass or '')..' '.. finish)
end
--- Faz o bot sair do irc.
function botQUIT()
    client:send(finish)
	client:close()
end
---- Faz o bot mandar um comando
function botSendComand(cmd)
	client:send(cmd..finish)
end
--- Manda uma action
function botSendAction(msg,chan)
	if chan == nil then
		local chan = bot.channel
	end
	if msg ~= nil then
	    client:send(finish)
		client:send("PRIVMSG " .. chan .. " :ACTION " .. msg .. finish)
	end
end
--- Tira a formatação do texto do IRC
function delFormat(stringa)
stringa = stringa:gsub('%d+,%d+', '')
stringa = stringa:gsub('%d+', '')
stringa = stringa:gsub('[]', '')
 return stringa
end
--- Envia uma notice
function botSendNotice(pessoa,msg)
	if pessoa == nil or msg == nil then
		print_("Valor invalido")
		return nil
	end
	client:send(finish)
	client:send("NOTICE "..(pessoa or '-').." : "..msg..finish)
end
--- Salva um texto em um log.
function doWriteLogFile(file, text,line)
	local file = io.open(file, "a+")
	if text == nil then
		return FALSE
	end
	if line == nil then
    	file:write(text .. "\n")
	else
        file:write(text)
	end
	file:close()
end
function string.trim(str)
    -- Function by Colandus
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end
function string.explode(str, sep, limit)
	if str == nil then
		return {'NADA','NADA','NADA'}
	end
    -- Function by Colandus
    if limit and type(limit) ~= 'number' then
        error("string.explode: limit must be a number", 2)
    end

    if #sep == 0 or #str == 0 then return end
    local pos, i, t = 1, 1, {}
    for s, e in function() return str:find(sep, pos) end do
        table.insert(t, str:sub(pos, s-1):trim())
        pos = e + 1
        i = i + 1
        if limit and i == limit then break end
    end
    table.insert(t, str:sub(pos):trim())
    return t
end
--- Verifica se ha um valor na tabela
function isInArray(letras, l)
if type(letras) ~= 'table' then
  return FALSE
end
  for i=1,#letras do
     if letras[i] == l then
     return TRUE
     end
  end
   return FALSE
end
--- Separa a mensagem em, mensagem, quem enviou, canal
function doPrepareString(msgr)
	if msgr == nil then
		return FALSE
	end
    local a,chan,num = doLegau(msgr)
    if a == "no" then
        return FALSE
    end
    if a == nil then
        return FALSE
    end
chan = chan or getChan(msg)
local sendera = getSender(msgr)
if num ~= nil then
   sendera = ""
end
	return delFormat(a),sendera, chan
end
--- Pega na mensagem quem enviou
function getSender(msg)
    local sender = string.match(msg,':(.-)!(.+)')
    if sender then
       return sender
    end
    return "[Server]"
end
function doLegau(msg)
    local _,_,i,b = string.find(msg,'(#.+) :(.+)')
    if b ~= nil then
	return b,i,nil
    else
       local _,_,num,sen = string.find(msg,' (%d+) '..bot.nick..' :(.+)')
       return sen,'[Server]',num
    end
end
-- Procura um comando
function findComand(msg)
	dofile('botComands.lua')
	for _,sep in pairs(bot.separator) do
	   sep = sep == '.' and '%.' or sep
		for i=1, #comands do
			if msg and msg:find(sep) then
				local ae = string.explode(msg,sep,2)
				local nb = string.explode(ae[2]," ",2)
				if not nb then return nil end
				if nb[1] ~= nil and nb[1] == comands[i].msg then
					return comands[i]
				end
			end
		end
	end
    return nil
end
--- Pega o canal
function getChan(s)
	local _,_, c = s:find('(#.+) :')
	if c ~= nil then
		if string.find(c,' ') then
			local amn = string.explode(c," ",2)
			return amn[1]
		else
			return c
		end
	end
end
--- Verifica se a pessoa esta bloqueada.
function isBlock(ignore,ident)
   return isInArray(ignore,ident)
end
--- Pega o ident da pessoa
function getIdent(user)
   for i,b in pairs(online) do
      for a,e in pairs(b) do
         if a == user then
            return e[3] or 'null'
         end
      end
   end
end
--- Pega o nome da pessoa com o ident indicado
function getUserbyIdent(id)
   for i,b in pairs(online) do
      for a,e in pairs(b) do
         if e[3] == id then
            return a
         end
      end
   end
end
--- Alguams funções gerais
function gerais(msg)
    ---- register
	if msg:find('nickname is registered and protected') or msg:find('este nick está registrado e protegido') then
		client:send("NS IDENTIFY :"..bot.pass.."\r\n")
	end
	-- names
    local canal = getChan(msg)
	if _ and canal then
	if string.find(msg,"353 "..bot.nick.." = #") then
		str = string.explode(msg,':',3)
		if str[3] ~= nil then
		    local stra = string.explode(str[3]," ")
		    local nota = {'@','+','&','~','%%'}
		    local old = ""
		    for i=1, #stra do
		       for a=1,#nota do
		          if string.find(stra[i],nota[a]) == 1 and 1 then
		             old = string.sub(stra[i],1,1)
		          end
		          stra[i] = string.gsub(stra[i],nota[a],'')
		       end
		        if online[canal] == nil then
		           online[canal] = {}
		        end
		        online[canal][string.lower(stra[i])] = {i,stra[i],kind=old}
		    end
		end
	end
	if string.find(msg,"353 "..bot.nick.." @ #") then
		str = string.explode(msg,':',3)
		if str[2] ~= nil then
		    local stra = string.explode(str[3]," ")
		    local nota = {'@','+','&','~','%%'}
		    local old = ""
		    for i=1, #stra do
		       for a=1,#nota do
		       	  if string.find(stra[i],nota[a]) == 1 and 1 then
		             old = string.sub(stra[i],1,1)
		             print_(stra[i],old)
		          end
		          stra[i] = string.gsub(stra[i],nota[a],'')
		       end
		        if online[canal] == nil then
		           online[canal] = {}
		        end
		        online[canal][string.lower(stra[i])] = {i,stra[i],kind=old}
		    end
		end
	end
	end
	local c = getChan(msg)
	if c then
	dofile('Bearbot_onFuncs.lua')
	--- quando kickar
	if string.find(msg,'KICK #') then
	    if c then
	   	local _,_,chana = string.find(msg,':(.+)!~')
		local _,_,nnick = string.find(msg,'KICK '..c..' (.+) :')
		if nnick == bot.nick then
		   if online[c] then
		      online[c] = nil
		   end
		end
	          if nnick then
	             nnick = nnick:lower()
	             if online[c] ~= nil then
	                if online[c][nnick] ~= nil then
	                   online[c][nnick] = nil
	                   onKick(msg,c,nnick,chana)
	                end
	             end

              end
		end
end
	--- quando sair
	end

end
function gerais3(msg)
   local _,_,tk = msg:find(' :(.+)')
	local _,_,recvsd = msg:find('NOTICE '..bot.nick..' :(.+)')
	if retger ~= TRUE then
	   if recvsd then
	      --- Verifica se print2 existe caso no use o print normal, nisso printando a notice unto com o bip
	      --- caso esteje habilitado.
	     (print2 or print)('[Notice]'..bips..' -'..(getSender(msg) or "Nil")..'- '..recvsd..'')
       else
         --- Caso nao seje notice apenas printa.
	     printT('>-->     '..(tk or msg),0.008)
      end
      --- Verifica se existe uma mensagem para o user.
      if tk then
	   --- Caso haja verifica se a mensagem é do tipo "nick esta em uso"
	   if tk:lower():find('register first.') then
	      --- Caso esteje ira finalizar a conexão e o bot.
	      client:send("QUIT : Bye\r\n")
	      client:close()
	   end
      end
    end
end
--- Outras gerais (pog)
function gerais2(msg)
    local _,_, sender = msg:find(':(.-)!')
    local _,_, daemon = string.find(msg, '^PING :(.+)')
	local _,_, chanell,kind_,name_ = msg:find('MODE (#.+) (.+) (.+)')
    local _,_, c2 = msg:find(':(#.+)')
    local _,_, c22 = msg:find('PART (#.+) ')
    local _,_,sendera,text = msg:find('PRIVMSG (.-) :(.+)')
	local _,_,nnick = string.find(msg,'NICK :(.+)')
    if daemon ~= nil then
       print_('PONG :' .. daemon)
       client:send('PONG :' .. daemon)
       client:send('\n\n')
       return TRUE, 'ping'
    end

	if c2 and string.find(msg,'JOIN :'..c2) then
		stra = string.explode(msg,'!',1)
		stra = string.sub(stra[1],2,string.len(stra[1]))
		if online[c2] == nil then
			online[c2] = {}
			print_(c2)
		end
		print_('Join '..stra)
		dofile('Bearbot_onFuncs.lua')
		stra = stra:lower()
		onJoin(stra,msg,c2)
		if online[c2][stra] == nil then
			online[c2][stra] = {kind=""}
		end
		return TRUE
	end
	if chanell and kind_ and name_ then
	   if online[chanell] and online[chanell][name_:lower()] then
	    if kind_ == "+v" then
	       online[chanell][name_:lower()].kind = '+'
	       print_(sender or 'unknow'..' defined '..name_:lower()..' to '..kind_..' '..chanell)
         elseif kind_ == "-v" then
	       online[chanell][name_:lower()].kind = ''
	       print_(sender..' defined '..name_:lower()..' to '..kind_..' '..chanell)
         elseif kind_ == "+o" then
	       online[chanell][name_:lower()].kind = '@'
	       print_(sender..' defined '..name_:lower()..' to '..kind_..' '..chanell)
         elseif kind_ == "-o" then
	       online[chanell][name_:lower()].kind = ''
	       print_(sender..' defined '..name_:lower()..' to '..kind_..' '..chanell)
         elseif kind_ == "+h" then
	       online[chanell][name_:lower()].kind = '%'
	       print_(sender..' defined '..name_:lower()..' to '..kind_..' '..chanell)
         elseif kind_ == "-h" then
	       online[chanell][name_:lower()].kind = ''
	       print_(sender..' defined '..name_:lower()..' to '..kind_..' '..chanell)
         elseif kind_ == "+qo" then
	       online[chanell][name_:lower()].kind = '~'
	       print_(sender..' defined '..name_:lower()..' to '..kind_..' '..chanell)
         elseif kind_ == "-qo" then
	       online[chanell][name_:lower()].kind = ''
	       print_(sender..' defined '..name_:lower()..' to '..kind_..' '..chanell)
	     end
	   end
	   return TRUE
	end
	if string.find(msg,'PART #') then
	    if c22 and online[c22] then
	        print_('PART ',sender)
	        if sender then
	               if online[c22][sender:lower()] ~= nil then
					  online[c22][sender:lower()] = nil
					  onQuit(sender:lower(),c22)
					  print_('CLOSE '..sender:lower()..': '..c22)
			       end
			end
	    end
	    return TRUE
	end
    if string.find(msg:lower(), 'quit') or string.find(msg:lower(),'close') or string.find(msg:lower(),'quit :') then
        if sender then
           local stra = sender:lower()
		   for i,b in pairs(online) do
				if online[i][stra] ~= nil then
					online[i][stra] = nil
					onQuit(stra,i)
					print_('QUIT '..stra..'.')
				end
            end
        end
        return TRUE
    end
    --- Privates
    if sendera and text and sender then
            if msg ~= bot.nick and sendera:sub(1,1) ~= "#" then
               client:send("PRIVMSG "..bot.owner.." :21,500"..sender..":7".. text.."\r\n")
               commands(sender,text,msg,sender)
			   print_('[Private] '..sender..': '..text)
        end
        return TRUE
    end
    -- nicks [01/10/09 - 13:49:43] > :Bearbot!~UrsoBot@70ED2156.UnIRC.Org NICK :Urso
	if string.find(msg, 'NICK :') then
		if sender and nnick then
		   local chana = sender:lower()
		   nnick = nnick:lower()
		   print_('NICK '..chana..' to '..nnick..'.')
		   for c23,b in pairs(online) do
			   if online[c23][chana] ~= nil then
			      local oldinf = online[c23][chana]
			      online[c23][chana] = nil
				  online[c23][nnick] = oldinf or {'fail'}
				  dofile('Bearbot_onFuncs.lua')
				  onNick(nnick,chana,c23)
			   end
		    end
        else
           print_('Failed',chana,nnick)
        end
        return TRUE
      end
      return FALSE
end
--- Verifica se a pesoa é operador
function isOP(quem,can)
 for cana in pairs(online) do
  if online[cana][quem] and cana:find(can) then
     if isInArray(adm,online[cana][quem].kind) == TRUE then
        return 1, online[cana][quem].kind
     end
  end
 end
   return nil
end
--- Roda os comandos
function commands(sender,a,msg,can)
				sender = string.lower(sender)
				local podek = 3
				if isOP(sender,can) ~= nil or (isInArray(adm,sender) == TRUE or isInArray(adm,"*") == TRUE)  then
					podek = 1
				end
				if online[can] then
				   if online[can][sender] then
				      if not online[can][sender][3] then
				         local q,dns,c = string.match(msg or "",':(.+)!(.-) PRIVMSG (#.-) ')
				         if q and dns and c then
				            online[can][sender][3] = dns
				            dns = online[can][sender][3]
				         else
				            dns = 'null'
				         end
				      else
				         dns = online[can][sender][3]
				      end
				   end
				end
				if  last+podek  <= os.clock() and findComand(a) ~= nil and isBlock(ignore, dns) == FALSE then
					dofile('botComands.lua')
					last = os.clock()
					for i=1, #comands do
					    for _,sep in pairs(bot.separator) do
							if sep == '.' then
								sep = '%.'
							end
							if string.find(a, sep) == 1 and string.len(a) > 1 then
								ae = string.explode(a,sep,2)
								nb = string.explode(ae[2]," ",2)
								if nb[1] ~= nil and nb[1] == comands[i].msg then
									if (comands[i][1] == false) or (isOP(sender,can) ~= nil or isInArray(adm,sender) == TRUE or isInArray(adm,"*") == TRUE)  then
										if check(comands[i].luafile,comands[i].msg) then
										   dofile('scripts/'..comands[i].luafile)
										   param = string.explode(a," ",bot.paramseparatorn)
										   param[2] = param[2] or type(nil)
										   if param[2] ~= "nil" then
											  param[2] = "[["..param[2].."]]"
										   end
										   local ret = noerr(" local retee = "..param[2]..' onIRCRecieve([['..a..']],[['..sender..']],[['..msg..']],retee,getChan([['..msg..']]))')
										   if ret == true then
											  print_("[Lua command:]> Executed code ["..comands[i].luafile.."].")
										   else
											  print_(ret)
											  botSendMsg('21,114[0'..ret..'14]',false)
											  print_("[Lua command:]>\n \n Fail on execute  code ["..comands[i].luafile.."].")
										   end
										   break
										else
											 if bot.shownotice == true then
												print_("[Lua command:]>\n \n Fail on execute  code ["..comands[i].luafile.."].")
												client:send("NOTICE "..sender.." : Comando com erro!.\r\n")
											 end
											 break
										end
									else
										if bot.shownotice == true then
										   client:send("NOTICE "..sender.." : Unknow command.\r\n")
										end
										break
									end
								last = os.clock()
								break
								--break
								end
							end
						end
					end
				else
				if findComand(a) ~= nil then
					if isBlock(ignore, dns,online) == TRUE then
						if bot.shownotice == true then
                           client:send("NOTICE "..sender.." : You were blocked\r\n")
                        end
					else
                        if bot.shownotice == true then
						   client:send("NOTICE "..sender.." : You have to wait "..podek.." seconds.("..math.floor(last+podek-os.clock())..")\r\n")
						end
                        last = last+0.500
					end
				end
			end
end
--- Roda os comandos de intervalo
function interval(msg)
		for i=1,#interv do
			if interv[i].last <= os.time() then
				if interv[i].msg ~= "" then
				    if interv[i].chan == nil then
						for ca,b in pairs(online) do
							botSendMsg(interv[i].msg,false,c)
						end
					else
						if string.find(interv[i].chan,'*') then
							if string.find(interv[i].chan,';') then
								local get = string.explode(interv[i].chan,";")
								for ca,b in pairs(online) do
								    if isInArray(get,ca) == FALSE then
										botSendMsg(interv[i].msg,false,ca)
									end
								end
							else
								for ca,b in pairs(online) do
									botSendMsg(interv[i].msg,false,ca)
								end
							end
						else
							local get = string.explode(interv[i].chan,";")
							if get == nil or type(get) ~= 'table' or #get == 0 then
								get = {interv[i].chan}
							end
							for getfor=1,#get do
								botSendMsg(interv[i].msg,false,get[getfor])
							end
						end
					end
				else
					if type(interv[i][1]) == 'function' then
						if interv[i][2] == false then
						   interv[i][2] = true
						   interv[i][1]()
						elseif interv[i][2] ~= true then
						  interv[i][1]()
						end
					end
				end
				interv[i].last = interv[i].interval+os.time()
			end
		end
end
--- Umas funções ai
function string.expand(s)
    s = string.gsub(s, "$(%w+)", function (n)
        return tostring(_G[n])
        end)
    return s
end
function var_dump(...)  --- By magus

    table.getn = function (table)
        local n = 0
        for _ in pairs(table) do
            n = n + 1
        end
        return n
    end

    local dumped = #arg == 0 and 'NULL' or ''

    for _, var in ipairs(arg) do

        local ret_str,x,ret = function (var)
            local VAR_TYPE,str = type(var)

            if (VAR_TYPE == "string") then
                str = VAR_TYPE.."("..var:len()..") \""..var.."\""
            elseif (VAR_TYPE == "number") then
                var = tostring(var)

                if var:find("%D+") then
                    VAR_TYPE = "float"
                else
                    VAR_TYPE = "int"
                end

                str = VAR_TYPE.."("..var..")"
            elseif (VAR_TYPE == "boolean") then
                str = "bool("..tostring(var)..")"
            else
                str = tostring(var)
            end

            return str
        end

        if (type(var) == "table") then
            local function ret_array(var,tab)
                ret = ""
                for i, v in pairs(var) do
                    if (type(v) == "table") then x = tab + 1 end
                    ret = ret.."\n\t"..string.rep("\t",tab).."["..(type(i) == "number" and i or '"'..i..'"').."] => "..(type(v) ~= "table" and ret_str(v) or ((v == _G or v == _G.package.loaded) and tostring(v).." (global environment)" or ret_array(v,x)))
                end

                return "array("..table.getn(var)..") {"..ret.."\n"..string.rep("\t",tab).."}"
            end

            ret = ret_array(var,0)
        end

        dumped = dumped..(ret or ret_str(var))..(#arg<=_ and '' or ' ')
    end

    print_(dumped)
    return dumped:gsub('\n',''):gsub('\t','')
end

function array(...)
         return {...}
end


 function tableToString(tb) -- by mock
str = "{"
for k,d in pairs(tb) do

   if type(k) == 'string' then
      if type(d) == 'string' then
      str = str..""..k.."='"..d.."',"
      elseif type(d) == 'number' or type(d) == 'boolean' then
      str = str..""..k.."="..tostring(d)..","
      elseif type(d) == 'table' then
      str = str..""..k.."="..tableToString(d)..","
      end
   elseif type(k) == 'number' then
      if type(d) == 'string' then
      str = str.."["..k.."]='"..d.."',"
      elseif type(d) == 'number' or type(d) == 'boolean' then
      str = str.."["..k.."]="..tostring(d)..","
      elseif type(d) == 'table' then
      str = str.."["..k.."]="..tableToString(d)..","
      end
   end
end
str = str.."}"
if string.sub(str,string.len(str)-2,string.len(str)-2) == "," then
  str = string.sub(str,0,string.len(str)-3)
  str = str.."}"
end
return str
end
function string.impode(arr,sep) --- by Mock
   local str = ""
   sep = sep or ""
   for i=1,#arr do
      str = str..tostring(arr[i])..sep
   end
   return str:sub(1,str:len()-1)
end
function check(file,c)
   local a,b = pcall(function() dofile('scripts/'..file) end)
   if a ~= true and b then
      print_('Error on loading !'..(c or 'unknow')..' '..file..': '..b)
      return nil
   end
   return true
end

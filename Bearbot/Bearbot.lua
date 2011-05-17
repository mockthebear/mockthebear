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
--- Vars fixas nao mudar/ do not change!
bot = {}
last = 0
TRUE = 1
FALSE = 0
teime = 0
memory = {}
ignore = {}
online = {}
bot.paramseparatorn = 2
bot.msg = 0
greet = true
bot.identd = 'Bearb'
dofile('config.lua')
bot.canalprincipal = bot.channel
--- Carrega os modulos / load the modules
function load2()
    io.write('>>Loading....\n')
    --- Define o algoritimo do math.random / set random seed.
    math.randomseed(os.time())
    --- Carrega as libs / load libs.
    --- Lua ex.
	require "ex"
	--- Lua mysql e lua.
	require "luasql.mysql"
	require "luasql.sqlite3"
	--- Lua socket.
	irc = require("socket")
	--- Libs do bot / bot libs.
	dofile('DB lib.lua')
	dofile('botlib.lua')
	dofile('botinterval.lua')
	dofile('Bearbot_onFuncs.lua')
	dofile('config.lua')
	dofile('botComands.lua')
	--- Verifica se algum script tem erro / check if some script has error.
         for i=1, #comands do
           check(comands[i].luafile,comands[i].msg)
         end
	--- Verifica intervalos e define o valor inicial como os.time / check intervals and set os.time how as start.
	io.write('>>Done\n')
	for i=1,#interv do
	   interv[i].last = os.time()+interv[i].interval
	end
	print_ = print
	if bot.showtimeinconsole == true then
       function print_(...)
            local arg = {...}
            local cont = {}
            local texa = ""
            for i=1,#arg do
              if i == 1 then
                 texa = arg[i]
              else
                  table.insert(cont,i-1,arg[i])
              end
            end
            print(os.date('[%H:%M:%S]').." > "..tostring(texa),unpack(cont))
      end
    end
end

function run()
    --- Inicia o bot / start bot.
    printT('>> Bearbot  lua irc bot (Lib).',0.02)
    printT('>> Name: '..bot.nick..'.',0.02)
    local _,ps,retur = bot.nick:find("([%a%d_%[%]]+)")
    if retur ~= bot.nick or bot.nick:len() > 18 or bot.nick:len() < 2 then
       printT('>> Invalid nick!',0.05)
       if ps then
          printT('>> Use these caracters: a-z 0-1!',0.05)
          printT('>> Invalid caraters: ['..tostring(bot.nick:sub(ps+1,ps+1))..'].',0.05)
       else
          printT('>> Name too long use max 18 and min 3',0.05)
       end
       return
    end
    printT('>> Connecting in '..bot.ip[1]..'.',0.03)
    --- Connect to irc.
    for i=1, #bot.ip do
        client = irc.connect(bot.ip[i], bot.port)
        if not client then
           print_('>> Connecting in: '..bot.ip[i]..'!')
           if bot.ip[(i+1)] then
              print_('>> Tentando novamente em '..bot.ip[(i+1)]..'. ['..(i+1)..']')
           else
              break
           end
        else
           break
        end
    end
    --- Informa da falha e finaliza / send error and finish.
    if not client then
       print_('>> Cannot conect in any server!')
       print_('>> Closing.')
       return nil
    end
    --- Conectado define o tipo da conexão / set connection opition
    client:setoption('keepalive', true)
    print_('---------------------------------------')
    --- Envia o nick e o ident / send nick and ident
    client:send("USER " .. bot.identd .. " 2 3 :" .. bot.nick .. "\r\n")
    --- Envia o nick e o ident dinovo / send nick and ident aigan
    client:send("NICK " .. bot.nick .. " " ..  bot.identd .. "\r\n")
    --- Identifica a password / identify pass
	client:send("PRIVMSG NICKSERV : IDENTIFY slsx450\r\n")
	--- Cria a tabela online / create online table
    online = {}
    repeat
	    --- No bloco asegir ele pega informações do server e define um tempo... / on this block it takes some server info
	    --- de espera pelos dados no periodo de 0.1 segundo. / set receive timeout to 0.1 seconds
		client:settimeout(0.1)
		msg, kinda = client:receive()
		-- aqui roda as funções automaticas / run some authomatic funcions.
		interval(msg)
		if msg ~= nil then
            --- Roda funçoes para ping e outras verificações / run ping and another things.
			local retger = gerais2(msg)
			--- pega quem mandou a mensagem e o canal / get how send message and channel.
			tex,sender, can = doPrepareString(msg)
			if sender ~= bot.nick then
			    ---- Salva um log de tudo que recebe / save a log.
				doWriteLogFile('BearBotReceiveLOG.txt',msg)
			end
			--- Caso canal seje nulo entao o define como '' if channel = nil set to ''.
			can = can or ""
			sender = sender or ''
			--- Verifica algumas coisas que nao sao printadas agora e se a pessoa esta ignorada/ check if sender is ignored.
			local q,ident,c = string.match(msg or "",':(.+)!(.-) PRIVMSG (#.-) ')
			if tex == nil or sender == bot.nick or tex == FALSE then
			   if isBlock(ignore, ident) == FALSE and retger ~= TRUE then
                  gerais3(msg)
               end
			else
				if isBlock(ignore, ident) == FALSE then
					--- Executa algumas outras funções gerais / run some funcions
					gerais(msg)
					--- Função que executa toda ves que o bot recebe dados de um usuario* / run if bot recceive an message form an user*
					onSay(sender,msg,tex)
					--- Procura por comandos na mensagem / find commands in message.
					commands(sender,tex,msg,can)
					--- Mostra no console o que foi recebido / print in console the stuff.
					if can ~= '[Server]' then
					   print_((can)..' -> '..sender..': '..tostring(tex))
					   ---- LOG com mensagem e enviador da mensagem e canal
					   doWriteLogFile('BearBotMsgLOG.txt',os.date('[%d/%m/%y - %H:%M:%S]').." > "..can.." "..sender..": "..tostring(tex))
					end
				end
			end
		end
	--- coroutine yield :D
	coroutine.yield()
	--- Caso a conexão seje fexada o loop para / if connection is closed finish the loop.
    until msg == nil and kinda ~= 'timeout' and kinda == 'closed'
    --- Mostra no console alguns status / show some status.
    --- Finaliza o bot / quit.
	return 'quit'
end
function string:load()
        for lua in self:gmatch('<%%lua(.-)%%>') do
                local printed = ""
                local f,err = loadstring(lua)
                if not f and err then
                        printed = tostring(err)
                elseif f then
                        local r,err = pcall(f)
                        err = err or ''
                        printed = tostring(err)
                end
                self = self:gsub('<%%lua.-%%>',printed,1)
        end
        return self
end
--- Carregar libs / load some libs
load2()
--- Abre um multi threading / open multi-threading
threads = {}
--- insere na tabela uma thread / insert in the table ah threath
table.insert(threads,1,coroutine.create(run))
--- função que coordena as threads / this funcion manage theadts
function dispatcher(threads)
  while true do
     if #threads == 0 then break end
     for location,thread in pairs(threads) do
         ---- se estiver suspended iniciar / if suspended run.
         if coroutine.status(thread) == 'suspended' then
            --- Execute até o 1º yield / run and stop in first yield.
            local bool_ret, returned = coroutine.resume(thread)
            ---- Verifica se é para fechar o bot / check if is to close bot.
            if bool_ret == true and returned then
               if returned == 'quit' then
                  return
               --- Verifica se é para executar um code / check if is to run a code.
               elseif returned:find('LUA:(.+)') then
                   local match_ = returned:match('LUA:(.+)')
                   local err = noerr(match_)
                   if err ~= true then
                      doWriteLogFile('Lua erros.txt','\nCommand !lua: '..err,false)
                      error(err)
                   end
               end
               --- Se deu algum erro para printar / if some error print.
            elseif bool_ret == false and returned then
               doWriteLogFile('Lua erros.txt','\nCommand !lua: '..returned,false)
               print(returned)
            end
         else
            --- Caso tenha terminado simplesmente para de executar / if finished remove.
            table.remove(threads,location)
         end
     end
  end
end
--- inicia / start.
dispatcher(threads)

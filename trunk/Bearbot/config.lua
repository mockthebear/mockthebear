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

--- Nome do bot / bot name.
bot.nick = 'Bearbot'
--- Ident do bot / bot nick.
bot.identd = 'bear'
--- Canal do bot / bot primary channel.
bot.channel = '#otbr'
--- O canal tem pass? Insira a pass aqui CASO tenha. / cahnnel pass (if need)
bot.channelpass = "123"
--- Nick do dono do bot / bot owner
bot.owner = 'mock'   -- not case sensitive.
--- Canais que o bot devera entrar.
bot.channels = {
--{'#apocastaff','slsx450'},
--{'#apocalipse'},
{'#otbr'},
{'#bearden'},
{'#geekfurs'},
{'#linux_fur'},
{'#babyfurs'},
{'#otserv'}
}
--- IP do irc / IRC ip
bot.ip = {'irc.irchighway.net'}--'irc.furnet.org'
--- Porta do irc / IRC port
bot.port = 6667
--- Se o nick estiver registrado ponha a senha aqui. / nick pass (if need)
bot.pass = "slsx450"
--- Caso o bor fale em multiplas cores insitras aqui (0-14) / bot with colors?
bot.saycor1 = "14"
bot.saycor2 = "10"
bot.saycor3 = "3"
--- Isto é para os comando, caso sejem chamados por ! serão !fala se for mudado
--- pelo caractere + entao so comandos serão do tipo +fala / if you change "!" to "." the commands will be .command
bot.separator = {".",'!'}
--- Administradores do bot / botd adm.
adm = {bot.owner,
'~',  --- Channel bots? ;D change to @ for OPs, % to hafhop + to voice and * to all
}
--- Mostrar a hora no console. / show time in console
bot.showtimeinconsole = true
--- Caso queira receber 'bips' quando receber uma notice / send bip when you receive a notice?
bot.bips = true
---  mostrar notice caso esteje a espera de um comando / show notice if has command delay
bot.shownotice = true
--- Bip on say bot nick.
bot.showbiep_onnick = true
--- Para database do bot  / to DB
sqlType = 'sqlite'  --- sqlite our mysql
mysqlDatabase = 'bearbot'
mysqlUser = 'root'
mysqlPass = '123'
mysqlHost = 'localhost'
mysqlPort = 3306
sqliteDatabase = "bearbot.s3db"

--[[-------------------------------------------------------------------------
  Copyright (c) 2009, Matheus Braga (mock_otnet@hotmail.com)
  All rights reserved.

  Redistribu��o do codigo fonte ou bin�rios, com ou sem a modifica��o,
  � permitida contanto que as seguintes circunst�ncias
  sej�o segidas:

      * As redistribu��es do c�digo fonte devem conter os creditos
        citados acima.
      * Ao repassar algo modificado deve-se incluir um documento
        de texto informando o que foi modificado.
      * N�o alterar os creditos, nem o nome de qualquer pessoa que
        tenha ajudado em algo sem permissao.
      * N�o postar conteudo compilado diferente da source modifcada,
        e sempre que postar algo modificado postar junto o codigo fonte.

   (*) Ajudantes:
   Skyen Hasus --- Some string functions
   Colandus --- String.explode, db lib
---------------------------------------------------------------------------]]
comands = {
{msg = "commands", luafile="comandos.lua",false},
{msg = "pergunta", luafile="pgt.lua",false},
{msg = "vontade", luafile="vontade.lua",false},
{msg = "mix", luafile="cruzar.lua",false},
{msg = "seequote", luafile="seequote.lua",false},
{msg = "action", luafile="action.lua",false},
{msg = "pvt", luafile="pvt.lua"},
{msg = "chance", luafile="chance.lua",false},
{msg = "online", luafile="online.lua",false},
{msg = "say", luafile="falar.lua",false},
{msg = "better", luafile="melhor.lua",false},
{msg = "dns", luafile="dns.lua"},
{msg = "quit", luafile="quit.lua"},
{msg = "ban", luafile="ban.lua"},
{msg = "add", luafile="add.lua"},
{msg = "see", luafile="see.lua"},
{msg = "del", luafile="del.lua"},
{msg = "lua", luafile="lua.lua"},
{msg = "join", luafile="vai pra.lua"},
{msg = "nick", luafile="nick.lua"},
{msg = "leave", luafile="sai.lua"},
{msg = "kick", luafile="kick.lua"},
{msg = "randkick", luafile="randkick.lua"},
{msg = "addquote", luafile="addquote.lua"},
{msg = "ignore", luafile="ignore.lua"},
{msg = "unignore", luafile="designore.lua"},
}

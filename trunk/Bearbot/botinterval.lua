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

--- Tabela dos intervalos
interv = {
--- Primeiro Last DEVE ser 0, interval � o tempo de intervalo em segundos.
{last=0,interval=20,msg="",
	function()
		if randa == nil then
			for i,b in pairs(bot.channels) do
			    botJOIN(b[1],b[2])
			end
			randa = 1
		end
	end
,false},
--[[egundo
{last=0, --- Last sempre 0.
interval=60, --- Intervalo de 1200 segundos ou 20 minutos.
msg="", -- Mensagens de texto.
function()
	local c
	repeat
		c = math.random(1,accs)
	until tonumber(ACC[c].chn) ~= 0
	botSendMsg("0,14Account: 05"..ACC[c].acc.."4 - Password: 05"..ACC[c].pass.."4 - IP: underwar.org",false,"#lua")
	for i=1,tonumber(ACC[c].chn) do
		botSendMsg("0,14Name: 05"..ACC[c][i][1].."4 - Level: 05"..ACC[c][i][2].."4 - Vocation: 05"..ACC[c][i][3].."4 ",false,"#lua")
	end
end},]]
--[[
{last=0, --- Last sempre 0.
interval=600,  --- Intervalo de 600 segundos ou 10 minutos.
msg="21,155[4Auto MSG - Meus comandos: fale !commands5]", -- Mensagens de texto.
chan="*;#apocastaff;#apocalipse;#lua;#publico;#brasil;#brasilia"}, -- Note que usei * primeiro, significa que:
-- * TODOS os canais que o bot se encontra, e os outros na lista s�o os canais que NAO ser� enviada a mensagem
-- segida de * ]]
}

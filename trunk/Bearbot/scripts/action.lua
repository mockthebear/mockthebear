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
function onIRCRecieve(msg,sender,msg_total,param,chan)
	if param == nil or string.len(param) <= 0 then
		botSendNotice(sender,"Mande o comando corretamente: ["..bot.separator.."action mensagem].")
		return FALSE
	end
    botSendAction(param,chan or bot.canalprincipal)
	return TRUE
end

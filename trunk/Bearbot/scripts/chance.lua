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
  botSendNotice(sender,"Say like this: ["..bot.separator.."chance MSG].")
return FALSE
end
     botSendMsg('21,108 4 |'..math.random(0,100)..'%|8 chance to '..param,false,chan)
return TRUE
end

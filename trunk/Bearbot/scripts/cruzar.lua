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
function onIRCRecieve(msg,sender,msg_total,param,chan)
if param == nil or string.len(param) <= 0 then
  botSendNotice(sender,"missing params")
return FALSE
end
                 name = string.explode(param, " ")
                 if name[1] ~= nil and name[2] ~= nil then
                    a1 = string.sub(name[1],1,math.random(1,string.len(name[1])))
               last = os.clock()
                  a2 = string.sub(name[2],string.len(name[2])/1.5,math.random(string.len(name[2])/1.5,string.len(name[2])))
                  botSendMsg('21,1015'..name[1]..' 4Mixed with 15'..name[2]..' 4 and born 9'..a1..a2..'.',false,chan)
                 else
                   botSendNotice(sender,"Missing params")
                 end



return TRUE
end

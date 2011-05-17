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
if param == nil then
   botSendNotice(sender,"Mande o comando corretamente: ["..bot.separator.."del user].")
return FALSE
end
       param = param:lower()
       for i=1,#adm do
        if adm[i] == param then
           table.remove(adm,i)
           botSendMsg("Deletado "..param..".",false,chan)
           return TRUE 
        end
       end
     botSendMsg(param.." nunca mandou em mim entao nao posso deleta-lo.",false,chan)  
return TRUE    
end
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
local str = param
if str == nil or string.len(param) <= 0 then
   botSendMsg("Say like this: ["..bot.separator.."add name].",false,chan)
return FALSE
end
	str = str:lower()
	if isInArray(adm, str) == TRUE then
		botSendMsg(str.." already on list!",false,chan)
	else
		table.insert(adm,#adm,str)
		local totos = "My adms: "
		for i=1,#adm do
			totos = totos..adm[i].." "
		end
		botSendMsg("Add "..str..". "..totos,false,chan)
	end
	return TRUE
end

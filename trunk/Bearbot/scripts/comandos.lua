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
	com = "Meus comandos s�o: "
	com2 = ""
	for i=1,#comands do
		if comands[i][1] == false then
			com = com..""..math.random(1,15)..",70- !"..comands[i].msg.."-"..i
		elseif comands[i][1] ~= false and (isInArray(adm,sender:lower()) == TRUE or isInArray(adm,"*") == TRUE) then
			com2 = com2.."1,10- !"..comands[i].msg.."-"..i
		end
	end
	botSendNotice(sender,com)
	if com2 ~= "" then
	botSendNotice(sender,com2)
	end
return TRUE
end
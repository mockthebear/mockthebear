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
  botSendNotice(sender,"Mande o comando corretamente: ["..bot.separator.."addquote MSG].")
return FALSE
end
	ej = db.getResult('SELECT * FROM `quote`;')
    local c = 1
	while(ej:next()) do
	    c = c + 1
	end
	ej:free()
    query = [[
        INSERT INTO `quote` (
        `id` ,
        `msg` ,
        `time`,
        `sender`,
        `chan`
        )
        VALUES (
        ']]..(c+1)..[[', ']]..param..[[', ']]..os.time()..[[', ']]..sender..[[', ']]..bot.channel..[['
        );
    ]]
    db.executeQuery(query)
    botSendMsg("0,1415<1>Add quote nº02"..(c+1).."0,1415<1>",false,chan)
return TRUE
end

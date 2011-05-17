function inHere(tb,str)
    for i=1,#tb do
       if string.find(str,string.lower(tb[i])) then
          return TRUE
       end    
    end
end

function onIRCRecieve(msg,sender,msg_total,param,chan)
    local wds = {
     'talvez',
     'sim',
     'nao',
     'NUNCA',
     'jamais',
     'nao',
     'com certeza',
     'provavelmente',
     'sim',
     'não posso afirmar com certeza',
     'quem sabe',
     'nao',
     'só nos seus sonhos',
     'nem fodendo',
     'sim',
     'possivelmente',
     'nao',
     'sim',
     'nem sei',
     'pergunta a tua mae',
     'A resposta é 3 vai arranja oq faze seu inutil',
     'ache a resposta aqui: http://www.google.com.br/',
     'só deus sabe',
     'nem sei',
     '3vc é otario d+ passa seu tempo lendo isso',
     'claro',
     'com certeza',
     'claro... que nao',
     'é obvio que sim',
     's',
     'n',
     'ta achando q eu sou sem empregado? se vira',
     'pra q eu iria querer saberia isso?',
     'se vira e procura a resposta',
    }
    local sims = {'sim','claro','é obvio','com certeza','s'}
    local naos = {'nao','NAO CARALHO _|_','claro... que nao','NUNCA','N'}
    local bad = {'viado','gay','noob','boiola','idiota','macumb','punhet','sexo','feio','burro',
    'tia','bixa','ripe','rippe','haxy','nao sabe','mau','mal','pequeno','transa','dá','anus','cu','pepino',
    'bunda','toba','cu','vagina','puta','ajuda','nerd','buterfly','desocupado','pau','pal','toba','vontade de da','rola'}
    local good = {'sexy','bonito','lindo','esperto','inteligente','urso','pro','gato','sabe','bom','grande',
    'scripter','script','gostoso','bv','tesao','macho','bear'}
    local respo = wds[math.random(1,#wds)]
    if string.find(string.lower(param),'mock') then
       if inHere(bad,string.lower(param)) == TRUE then
          
          respo = naos[math.random(1,#naos)]
       elseif inHere(good,string.lower(param)) == TRUE then
          respo = sims[math.random(1,#sims)]
       end    
    end
    if string.find(string.lower(param),'eu') or string.find(string.lower(param),'sou') then
       if inHere(bad,param) == TRUE then
          respo = sims[math.random(1,#sims)]
       elseif inHere(good,param) == TRUE then
          respo = naos[math.random(1,#naos)]
       end    
    end
    botSendMsg("0,34[15"..sender..": 1"..respo.."4]",false,chan)
return TRUE
end
--By mock the bear
require( "iuplua" )
require( "iupluacontrols" )
local sizex,sizey
taba = {
    colors={
        "BGCOLOR",
    },
}
--testando 1 coisa.
do
    local my = collectgarbage('count')
    print(collectgarbage('count'))
    local ab
    print(collectgarbage('count')-my)
    local dll = '1111111111111111111111111'
    print(collectgarbage('count')-my)
    local _if
    print(collectgarbage('count')-my)
    local _e
    print(collectgarbage('count')-my)
    print(collectgarbage('count')-my)
    print(collectgarbage('count')-my)
    print(collectgarbage('count'))
end
print(collectgarbage('count'))
--testeq/q/q/q/q/
AUTO_ACTIVE = true
LOADED = nil
do
    local b = iup.Alarm("Atenção", "Quer abrir um icone ja existente?" ,"Sim" ,"Não")
    if b == 1 then
        local f, err = iup.GetFile("*.luaex")
        if err == 1 then
          iup.Message("File not found",'File not found.')
          os.exit()
        elseif err == 0 then
            LOADED = f
         local f = io.open(f,'rb')

          local c = f:read(-1)
          f:close()
          f = loadstring(c)
          taba = f()
          collectgarbage()
          sizey = #taba
          sizex = #taba[1]
        elseif err < 0 then
            iup.Message("File not found",'File not found.')
            os.exit()
        end
    else
        ret, sizex,sizey =iup.GetParam("Tamanho do novo icone",'Coloque as dimensões',"X: %i[1,32]\nY: %i[1,32]\n",1,1)
        for y=1,sizey do
            taba[y] = {}
            for x=1,sizex do
                taba[y][x] = 1
            end
        end
    end
end

function daj(t)
    local uu = 'iup.vbox{'
    for i,y in pairs(t) do
        if type(i) == 'number' then
            uu = uu..'iup.hbox{'
            for a,x in pairs(y) do
                local col = t.colors[x]
                uu = uu..'iup.button{IMAGE=iup.image(genIMG(\''..col..'\')),action=gatt},'
            end
            uu = uu..'},'
        end
    end
    local f = assert(loadstring('return '..uu..'}'))
    return f()
end
function daj2(t)
    local uu = 'iup.vbox{'
    for i,y in pairs(t) do
        if type(i) == 'number' then
            uu = uu..'iup.hbox{'
            for a,x in pairs(y) do
                local col = t.colors[x]
                if col ~= 'BGCOLOR' then
                    uu = uu..'iup.label{title=\'     \',BGCOLOR="'..col..'"},'
                else
                    uu = uu..'iup.label{title=\'     \'},'
                end
            end
            uu = uu..'},'
        end
    end
    local f = assert(loadstring('return '..uu..'}'))
    return f()
end
function genIMG(c)
    local t = {colors={c}}
    for y=1,12 do
        t[y] = {}
        for x=1,12 do
            t[y][x] = 1
        end
    end
    return t
end
local olda = {255,255,255}
function gatt(self)
        local r, g, b
        if not AUTO_ACTIVE then
            r, g, b = iup.GetColor(100, 107, olda[1], olda[2], olda[3])
        else
            r = G_R
            g = G_G
            b = G_B
        end
        for i,y in pairs(taba) do
            if type(i) == 'number' then
                for a,x in pairs(y) do
                    --if taba.colors[x] ~= 'BGCOLOR' then
                        if self == dlg[1][1][1][1][i][a] then
                            if not b and not r and not g  then
                                for qq,bb in pairs(taba.colors) do
                                    if bb == 'BGCOLOR' then
                                        dlg[1][1][1][i][a].IMAGE = iup.image(genIMG('BGCOLOR'))
                                        taba[i][a] = qq
                                    end
                                end
                            else
                                local colo = r..' '..g..' '..b
                                olda[1] = r
                                olda[2] = g
                                olda[3] = b
                                local id = #taba.colors+1
                                for qq,bb in pairs(taba.colors) do
                                    if bb == colo then
                                        id = qq
                                        break
                                    end
                                end
                                dlg[1][1][1][1][i][a].IMAGE = iup.image(genIMG(colo))
                                taba[i][a] = id
                                taba.colors[id] = colo
                            end
                        end
                    --end
                end
            end
        end
        iup.Refresh(dlg[1][1][1][1])
    end
function save(t)
    local s = 'return {'
    for i,y in pairs(t) do
        if type(i) == 'number' then
            s = s..'\n{'
            for a,x in pairs(y) do
                s = s..x..','
            end
            s = s..'},'
        end
    end
    s = s..'\ncolors = {\n'
    for i,b in pairs(t.colors) do
        s = s..'"'..b..'",\n'
    end
    s = s..'}\n}'
    local nama = LOADED
    if not nama then
        nama = os.time()..'ico.luaex'
    end
    LOADED = nama
    local f = io.open(nama,'wb')
    f:write(s)
    f:close()
    s = nil
    collectgarbage()
    iup.Message('Salvo','Icone salvo como: \n'..nama)
end
function string.explode(self, sep)--By socket  (só usei pq tava pequena)
    local result = {}
    self:gsub("[^".. sep .."]+", function(s) table.insert(result, s) end)
    return result
end

function createF(t)
    local lua = 'iup.hbox{'
    local result = {}
    local n = 0
    for i,b in (''..t..''):gmatch("(%[f=\".-\"%].+%[/f%])") do
        t = t:gsub("(%[f=\".-\"%].-%[/f%])", function(s)
        local f,tt = s:match('%[f=\"(.-)\"%](.-)%[/f%]')
        n = n+1 result[n] = 'iup.label{FONT = "'..f..'",title=[['..tt..']]},'
        return '€€'..n..'€€' end)
    end
    for i,b in (''..t..''):gmatch("(%[c=\"%d+ %d+ %d+\" f=\".-\"%].-%[/c%])") do
        t = t:gsub("(%[c=\"%d+ %d+ %d+\" f=\".-\"%].-%[/c%])", function(s)
        local r,g,b,f,tt = s:match("%[c=\"(%d+) (%d+) (%d+)\" f=\"(.-)\"%](.+)%[/c%]")
        n = n+1 result[n] = 'iup.label{FONT = "'..f..'",FGCOLOR=\''..r..' '..g..' '..b..'\',title=[['..tt..']]},'
        return '€€'..n..'€€' end)
    end
    for i,b,f in pairs(string.explode(t,'€€')) do
        if tonumber(b) then
            lua = lua..result[tonumber(b)]
        else
            lua = lua..'iup.label{title=[['..b..']]},\n'
        end
        --print(i,b)
    end
    local f = assert(loadstring('return '..lua..'}'))
    return f()
end

--
function fixn(n)
    local s = tostring(n)
    return string.rep('0',3-s:len())..s
end
valr = iup.val{"VERTICAL", min=0, max=255,    value="0",bgcolor="255 0 0",
button_release_cb=function() end,
button_press_cb=function() end,
mousemove_cb=function(self,a)
    self.BGCOLOR = math.floor(a)..' 0 0'
    G_R = math.floor(a)

    G_R = math.floor(valr.value)
    G_G = math.floor(valg.value)
    G_B = math.floor(valb.value)


    labr.title = 'R '..fixn(math.floor(a))
    local r, g, b = cololab.BGCOLOR:match('(%d+) (%d+) (%d+)')
    cololab.BGCOLOR = G_R..' '..g..' '..b
    iup.Refresh(labr)
end,
}
valg = iup.val{"VERTICAL", min=0, max=255,    value="0",bgcolor="0 255 0",
button_release_cb=function() end,
button_press_cb=function() end,
mousemove_cb=function(self,a)
    self.BGCOLOR = '0 '..math.floor(a)..' 0'
    G_G = math.floor(a)

    G_R = math.floor(valr.value)
    G_G = math.floor(valg.value)
    G_B = math.floor(valb.value)


    labg.title = 'G '..fixn(math.floor(a))
    local r, g, b = cololab.BGCOLOR:match('(%d+) (%d+) (%d+)')
    cololab.BGCOLOR = r..' '..G_G..' '..b
    iup.Refresh(labg)
end
}
valb = iup.val{"VERTICAL", min=0, max=255,    value="0",bgcolor="0 0 255",
button_release_cb=function() end,
button_press_cb=function() end,
mousemove_cb=function(self,a)
    self.BGCOLOR = '0 0 '..math.floor(a)
    G_B = math.floor(a)

    G_R = math.floor(valr.value)
    G_G = math.floor(valg.value)
    G_B = math.floor(valb.value)


    labb.title = 'B '..fixn(math.floor(a))
    local r, g, b = cololab.BGCOLOR:match('(%d+) (%d+) (%d+)')
    cololab.BGCOLOR = r..' '..g..' '..G_B
    iup.Refresh(labb)
end,
}
labr = iup.label{title='R 000',BGCOLOR='255 0 0'}
labg = iup.label{title='G 000',BGCOLOR='0 255 0'}
labb = iup.label{title='B 000',BGCOLOR='0 0 255'}
cololab = iup.frame{iup.label{title='                \n                '}}
dlg = iup.dialog {

    tray = 'YES', traytip =  'Tibiando',
    trayimage = iup.image(taba),
    iup.vbox{
        iup.hbox{
        iup.frame{
                title="Edite aqui",
                size='200x100', --100x200 ou n

                daj(taba),

            },
            iup.frame{
            title="Painel",
            iup.vbox{

            iup.button{size='100x20',title="Salvar",action=function() save(taba) end},
            iup.button{size='100x20',title="Atualizar        ",action=function(self, t, i ,v)
            update()
            end },
            iup.button{size='100x20',title="Em uso   ",action=function() dlg.trayimage = iup.image(taba) end},
            iup.button{size='100x20',title="Auto-cor (On)", FGCOLOR='0 255 0',FONT="HELVETICA_BOLD_8", action=function(self)
            if self.FGCOLOR == '255 0 0' then
                AUTO_ACTIVE = true
                self.FGCOLOR = '0 255 0'
                if not G_R or not G_G or not G_B then
                    cololab.BGCOLOR = nil
                else
                    cololab.BGCOLOR = G_R..' '..G_G..' '..G_B
                end
            else
                self.FGCOLOR = '255 0 0'
                self.title = "Auto-cor (Off)"
                AUTO_ACTIVE = false
            end
            end
            },
            iup.frame{
                title='COR ESCOLHIDA',

                iup.vbox{
                iup.hbox{
                iup.fill{},
                cololab,
                iup.fill{},
                },
                iup.hbox{valr,iup.fill{},valg,iup.fill{},valb},
                iup.hbox{labr,iup.fill{},labg,iup.fill{},labb},
                iup.vbox{
                iup.fill{},
                iup.button{size='100x20',title="Mudar cor",action=function()
                local r, g, b = iup.GetColor(100, 107, olda[1], olda[2], olda[3])
                AUTO_ACTIVE = true
                G_R= r
                G_G= g
                G_B= b
                if not r then
                    cololab.BGCOLOR = nil
                    local r,g,b = GLOBALDG:match('(%d+) (%d+) (%d+)')
                    valr.value = r
                    valg.value = g
                    valb.value = b
                else
                    cololab.BGCOLOR = r..' '..g..' '..b
                    valr.value = r
                    valg.value = g
                    valb.value = b
                end
                end},
                iup.button{size='100x20',title="Transparente",action=function()
                    cololab.BGCOLOR = nil
                    local r,g,b = GLOBALDG:match('(%d+) (%d+) (%d+)')
                    valr.value = r
                    valg.value = g
                    valb.value = b
                    G_R= nil
                    G_G= nil
                    G_B= nil
                end},

                },
                }
            },

            },

            },
            iup.frame{
                size=(sizex*14)..'x'..(sizey*13),
                BGCOLOR='0 0 0',
                iup.vbox{
                    iup.fill{},
                    iup.hbox{
                        iup.fill{},
                        iup.frame{
                            BGCOLOR='255 255 255',
                            daj2(taba)
                        },
                        iup.fill{}
                },
                iup.fill{}}
            },
        },
        iup.hbox{
        iup.frame{createF('Editor de icones para IUP by [c="160 71 9" f="HELVETICA_BOLD_8"]Mock the bear[/c]')},
        }
    },

    title = "Tray icone editor.",
  }
function update()
    local t = dlg[1][1][3][1][2][2][1]
    for y=1,sizey do
        for x=1,sizex do
            local bege = taba.colors[taba[y][x]]
            if bege == 'BGCOLOR' then
            bege = nil
            end
            t[y][x].BGCOLOR = bege
        end
    end

end
GLOBALDG = dlg.BGCOLOR
do
    local r,g,b = GLOBALDG:match('(%d+) (%d+) (%d+)') --pog
    valb.value = b
    labb.title = 'B '..b
    valb.BGCOLOR = '0 0 '..b
    valr.BGCOLOR = r..' 0 0'
    valr.value = r
    labr.title = 'R '..r
    valg.BGCOLOR = '0 '..g..' 0'
    valg.value = g
    labg.title = 'G '..g
    G_R = r
    G_G = g
    G_B = b
end
dlg:showxy ( iup.CENTER, iup.CENTER )

if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

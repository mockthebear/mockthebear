function connect_db()
	local env = assert(luasql.sqlite3())
	local con = assert(env:connect('KoK.s3db'))
	return	con,env
end
local rows_ = {
	[1] = {'cla','%s'},
	[2] = {'obs','%s'},
	[3] = {'nickname','%s'},
	[4] = {'deleted','%d'},
	[5] = {'exp','%s'},
	[6] = {'id','%d',true},
	[7] = {'classe','%s'},
	[8] = {'hierarquia','%s'},
	[9] = {'desc','%s'},
	[10] = {'nome_rl','%s'},
	[11] = {'tel','%s'},
	[12] = {'email','%s'},
	[13] = {'sexo','%s'},
	[14] = {'idade','%s'},
	[15] = {'treinamento','%s'},
	[16] = {'lvl','%s'},
	[17] = {'punicao','%s'},
}
function add(t)
	local con,env = connect_db()
	local osid = os.time()
	local _1,err = assert(con:execute(CONST_INSERT:format(osid)))
	--local t = {}
	for i=1,17 do
		if rows_[i] and not rows_[i][3] then
			print(t[i],i)
			local _1,err = assert(con:execute(('UPDATE fichas SET %s=\'%s\' WHERE id=%d;'):format(rows_[i][1],t[i] or '',osid)))
		end
	end
	con:close()
	env:close()
	return true
end

CONST_SELECTED = -1
CONST_INSERT = [[INSERT INTO fichas VALUES(NULL, NULL, NULL, NULL, NULL, %d, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);]]
require("iuplua")
require("iupluacontrols")
require('luasql.sqlite3')
require('iupluaole')
require('luacom')
dofile('img.lua')


timer1 = iup.timer{time=100}
math.randomseed(os.time())
if not string then
  string = {}
  string.format = format
end
function copyTable(t)
	local t2 = {}
	for i,b in pairs(t) do
		t2[i] = b
	end
	return t2
end
function setUserSee(selected)
	if not lista[selected] then
		return false
	end
	for i,b in pairs({
	[3] = 'nickname',
	[5] = 'classe',
					[7] = 'lvl',
					[9] = 'exp',
					[11] = 'hierarquia',
					[13] = 'cla',
					[15] = 'desc',
					[17] = 'treinamento',
					[19] = 'punicao',
					}) do
						local v,s = dlg[1][3][1][1][i].title:match('(.-):(%s*).+')
						--print(v,s,i,b)
						dlg[1][3][1][1][i].title = tostring(v)..':'..(s or '        ')..tostring((data[selected] or {})[b] or '-')
					end
					for i,b in pairs({
					[3] = 'nome_rl',
					[5] = 'sexo',
					[7] = 'idade',
					[9] = 'email',
					[11] = 'tel',
					[13] = 'obs',
					}) do
						local v,s = dlg[1][3][2][1][i].title:match('(.-):(%s*).+')
						dlg[1][3][2][1][i].title = (v or '??')..':'..(s or '        ')..tostring((data[selected] or {})[b] or '-')
					end
					CONST_SELECTED = selected
					iup.Refresh(dlg)
end
function createRow()
	lista = {}
	data = {}
	local n = 0
	local con,env = connect_db()
	local _1,err = assert(con:execute('SELECT rowid,*  FROM fichas'))
	local c = _1:fetch({}, "a")
	if c then
			repeat
				if tonumber(c.deleted) ~= 1 then
					n = n+1
					lista[n] = c.nickname
					data[n] = copyTable(c)
				end
				c = _1:fetch({}, "a")
			until not c
			_1:close()
			con:close()
			env:close()
	end
	return lista,data
end
function getData(id)
	local data_ = {}
	local n = 0
	local con,env = connect_db()
	local _1,err = assert(con:execute('SELECT rowid,*  FROM fichas WHERE id = \''..id..'\''))
	local c = _1:fetch({}, "a")
	if c then
		if c.deleted ~= 1 then
				data_ = copyTable(c)
		end
		_1:close()
		con:close()
		env:close()
	end
	return data_
end
function edit(id)
	if CONST_SELECTED == -1 then
		iup.Message("Erro!", "Selecione alguem.")
		return false
	end
	print('sel',CONST_SELECTED)
	local cc = getData(data[CONST_SELECTED]['id'])
	local rws2 = {
	{'Adcional',1,'%s'},
	{'Observação',2,'%m'},
	{'Nick do personagem',3,'%s'},
	{'Telefone',5,'%s'},
	{'Classe',7,'%s'},
	{'Hierarquia',8,'%s'},
	{'Descrição',9,'%m'},
	{'Nome real',10,'%s'},
	{'Telefone',11,'%s'},
	{'E-mail',12,'%s'},
	{'Sexo',13,'%s'},
	{'Idade',14,'%s'},
	{'Contribuições',15,'%m'},
	{'Level',16,'%i[0,]'},
	{'Punição',17,'%s'},
	}
	local mk = {}
	local mar = {}
	local sa = {}
	local uses = {}
	local see = {}
	local ida = 1
	for i,b in pairs(rws2) do
		mk[i] = b[1]
		mar[i] = 0
	end
	error = iup.ListDialog(2,"Editar "..cc.nome_rl,#mar,mk,0,16,9,mar)
	if error == -1 then
		iup.Message("Editar "..cc.nome_rl, "Cancelado.")
	else
	  local selection = ""
	  local i = 1

		while i ~= #mar+1 do
		if mar[i] ~= 0 then
			ida = ida+1
			selection = selection ..  rws2[i][1] ..": "..rws2[i][3].."\n"
			uses[ida] = rws2[i][2]
			see[ida] = mk[i]
			sa[#sa+1] = rws2[i][3] == '%i[0,]' and data[CONST_SELECTED][rows_[rws2[i][2]][1]] or tostring(data[CONST_SELECTED][rows_[rws2[i][2]][1]] or '')
		end
		i = i + 1
	  end
	  if selection == "" then
		iup.Message("Editar "..cc.nome_rl, "Cancelado.")
	  else
		--iup.Message("Selected options",selection)
		local nt = os.clock()
		local err = ''
		local t = {iup.GetParam("Editando "..cc.nome_rl,'',selection,unpack(sa))}
		if t[1] == 1 or t[1] == true then
			local con,env = connect_db()
			for i,b in pairs(t) do
				if i ~= 1 then
					if (rows_[uses[i]][2] == '%d' and not tonumber(b)) then
						err = err..'Campo: '..see[i]..' - Este camp requer apenas numeros.\n'
					else
						local que = ('UPDATE fichas SET %s=\'%s\' WHERE id=%d;'):format(rows_[uses[i]][1],b or '',data[CONST_SELECTED]['id'])
						local _1,erra = assert(con:execute(que))
						if not _1 and erra then
							err = err..'SQL ERR: '..erra..'\n'
						end
					end
				end
			end
			con:close()
			env:close()
			iup.Message("Info", "Finalizado em "..(os.clock()-nt).." segundos.")
			createRow()
			for i=1,#lista do
				--print(i)
				dlg[1][2][1][1][i] = lista[i]
			end
			setUserSee(CONST_SELECTED)
			if err ~= '' then
				iup.Message("Editar "..cc.nome_rl, "Os seguintes campos nao foram adcionados:\n"..err)
			end
		else
			iup.Message("Editar "..cc.nome_rl, "Favor preencher corretamente todos os campos.")
		end
	  end
	end
end
--do return edit(1) end
tabelas_cd = {}
function timer1:action_cb()
	for i,be in pairs(tabelas_cd) do
		local r,g,b = be[1].BGCOLOR:match('(%d+) (%d+) (%d+)')
		if be[3] then
			r = tonumber(r)+be[2]
		end
		if be[4] then
			g = tonumber(g)+be[2]
		end
		if be[5] then
			b = tonumber(b)+be[2]
		end
		be[1].BGCOLOR = r..' '..g..' '..b
		if (tonumber(b) >= 255 and be[5]) or (tonumber(r) >= 255 and be[3]) or (tonumber(g) >= 255 and be[4]) then
			be[1].BGCOLOR = '255 255 255'
			tabelas_cd[i] = nil
		end

	end
  return iup.DEFAULT
end
function string.explode(self, sep)
    local result = {}
    self:gsub("[^".. sep .."]+", function(s) table.insert(result, s) end)
    return result
end
function createF(t)
	--iup.label{FONT = "HELVETICA_BOLD_8",title=""},
	--iup.label{,title=""},
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
	for i,b in pairs(result) do
		--print(b)
	end
	for i,b,f in pairs(string.explode(t,'€€')) do
		if tonumber(b) then
			lua = lua..result[tonumber(b)]
		else
			lua = lua..'iup.label{title=[['..b..']]},\n'
		end
		--print(i,b)
	end
	--print('return '..lua..'}')
	local f = assert(loadstring('return '..lua..'}'))
	return f()
end
function addEar()
	--[[
	[1] = {'cla','%s'},
	[2] = {'obs','%s'},
	[3] = {'nickname','%s'},
	[4] = {'deleted','%d'},
	[5] = {'exp','%d'},
	[6] = {'id','%d',true},
	[7] = {'classe','%s'},
	[8] = {'hierarquia','%s'},
	[9] = {'desc','%s'},
	[10] = {'nome_rl','%s'},
	[11] = {'tel','%s'},
	[12] = {'email','%s'},
	[13] = {'sexo','%s'},
	[14] = {'idade','%d'},
	[15] = {'treinamento','%s'},
	[16] = {'lvl','%d'},
	[17] = {'punicao','%s'},]] --9688 3232
	local vv = {
	['nickname'] = 			dlg[1][1][1][3][1],
	['classe'] =			dlg[1][1][1][4][1],
	['lvl'] = 				dlg[1][1][1][5][1],
	['exp'] = 				dlg[1][1][1][6][1],
	['hierarquia'] = 		dlg[1][1][1][7][1],
	['cla'] =  			    dlg[1][1][1][8][1],
	['desc'] =				dlg[1][1][1][9][1],
	['treinamento'] =		dlg[1][1][1][10][1],
	['punicao'] =  			dlg[1][1][1][11][1],
	---
	['nome_rl'] =  			dlg[1][1][1][13][1],
	['sexo'] =     			dlg[1][1][1][14][1],
	['idade'] =    			dlg[1][1][1][15][1],
	['email'] =    			dlg[1][1][1][16][1],
	['tel'] = 				dlg[1][1][1][17][1],
	['obs'] = 				dlg[1][1][1][18][1],
	['id'] = os.time(),
	['deleted'] = 0,
	}
	local tta = {}
	local err = false
	for i,b in pairs(vv) do
		local id = 0
		for a,q in pairs(rows_) do
			if q[1] == i then
				if type(b) == 'number' then
					tta[a] = b
				else
					b.BGCOLOR='255 255 255'
					local vva = b.value
					if (q[2] == '%d' and not tonumber(vva)) or (q[2] == '%s' and vva:len() == 0) then
						b.BGCOLOR='255 0 0'
						table.insert(tabelas_cd,1,{b,5,false,true,true})
						err = true
					else
						tta[a] = vva
					end
				end
			end
		end
	end
	if err then
		iup.Message("Adcionar", "Campo(s) preenchido(s) incorretamente.")
		return false
	else
		if add(tta) then
			for i,b in pairs(vv) do
				if type(b) ~= 'number' then
					b.value = ''
					b.BGCOLOR='0 255 0'
					table.insert(tabelas_cd,1,{b,5,true,false,true})
				end
			end
			for i=1,#lista do
				dlg[1][2][1][1][i] = ''
			end
			createRow()
			for i=1,#lista do
				dlg[1][2][1][1][i] = lista[i]
			end
			setUserSee(-1)
		end
	end
end
timer1.run = "YES"
function printa(id)
	if CONST_SELECTED == -1 then
		iup.Message("Erro!", "Selecione alguem.")
		return false
	end
	print('sel',CONST_SELECTED)
	local cc = getData(data[CONST_SELECTED]['id'])
	local rws2 = {
	{'Clã',1,'%s'},
	{'Observação',2,'%m'},
	{'Nick do personagem',3,'%s'},
	{'EXP',5,'%i[0,]'},
	{'Classe',7,'%s'},
	{'Hierarquia',8,'%s'},
	{'Descrição',9,'%m'},
	{'Nome real',10,'%s'},
	{'Telefone',11,'%s'},
	{'E-mail',12,'%s'},
	{'Sexo',13,'%s'},
	{'Idade',14,'%i[0,]'},
	{'Treinamento',15,'%m'},
	{'Level',16,'%i[0,]'},
	{'Punição',17,'%s'},
	}
	local mk = {}
	local mar = {}
	local ida = 1
	local s = ''

	local f = io.open('print.txt','r')
	s = f:read(-1)
	f:close()
---lvl = arma
	local kontrol = iup.olecontrol{"Shell.Explorer.2"}
	kontrol:CreateLuaCOM()
	kontrol.com:Navigate("about:blank")

	s = s:format(cc['nome_rl'],cc['tel'],cc['lvl'],cc['email'],cc['sexo'],cc['treinamento'],cc['cla']:gsub('\\n','<br>')
,cc['hierarquia'],cc['obs']:gsub('\\n','<br>'))


kontrol.com.Document:WriteLn(s)
	local dlga = iup.dialog
	{
	iup.frame{title='print',kontrol},
	}
	dlga:showxy(iup.CENTER, iup.CENTER)
end
lista,data = createRow()
dlg = iup.dialog
{
	iup.hbox{
		iup.frame{
			title="Painel",
			iup.vbox{
				createF('[c="0 104 255" f="HELVETICA_BOLD_8"]Adcione aqui um usuario.[/c]'),--1
				iup.hbox{createF('[c="105 105 105" f="HELVETICA_NORMAL_8"]----------[/c][c="0 104 255" f="HELVETICA_BOLD_8"]Dados do personagem[/c][c="105 105 105" f="HELVETICA_NORMAL_8"]-----------[/c]')},--2
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Nome [c="105 105 105" f="HELVETICA_ITALIC_8"](nick)[/c][c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--3
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Classe[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--4
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Data de nas.[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--5
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Telefone[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--6
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Hierarquia[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--7
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Posição[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--11
				iup.hbox{iup.multiline{value = "",size='90x56'},createF('   Descrição[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--8
				iup.hbox{iup.multiline{value = "",size='90x56'},createF('   Contribuições[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--9
				iup.hbox{iup.multiline{value = "",size='90x56'},createF('   Punição[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--10
				iup.hbox{createF('[c="105 105 105" f="HELVETICA_NORMAL_8"]---------------[/c][c="0 104 255" f="HELVETICA_BOLD_8"]Dados pessoais[/c][c="105 105 105" f="HELVETICA_NORMAL_8"]---------------[/c]')},--11
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Nome[c="105 105 105" f="HELVETICA_ITALIC_8"](Real)[/c][c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--12
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Sexo[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--13
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Idade[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--14
				iup.hbox{iup.text {value = "",size='90x11'},createF('   E-mail[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--15
				iup.hbox{iup.text {value = "",size='90x11'},createF('   Telefone[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--16
				iup.hbox{iup.multiline{value = "",size='90x56'},createF('   Observação[c="255 0 0" f="HELVETICA_NORMAL_8"]  *[/c]')},--16
				iup.button{title="Adcionar.",size='80x',action=function()
					addEar()
				end},
			}
		},
		iup.frame{
			title="Lista",
			iup.vbox{
				iup.list {size='150x300',action=function(t, o, selected)
					setUserSee(selected)
					return iup.DEFAULT
				end,unpack(lista)},
				iup.button{title="Refresh",action=function()
					createRow()
					for i=1,#lista do
							--print(i)
							dlg[1][2][1][1][i] = lista[i]
							end
					end},
			}
		},
		iup.vbox{
			iup.frame{
				size='200x100',
				title="Dados do personagem",
				iup.vbox{
					iup.hbox{
					iup.fill{},iup.label{FONT = "HELVETICA_BOLD_8",FGCOLOR='70 139 174',title="Dados do personagem"},iup.fill{},
					},
					--2
					iup.hbox{
						iup.fill{},
						iup.label{FONT = "HELVETICA_BOLD_8",title="-------------------------------------------"},iup.fill{},
					},
					--3
					iup.label{FONT = "HELVETICA_BOLD_8",title="Nome:             "},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Classe:           "},--5
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Data de nasc:              "},--7
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Telefone:               "},--9
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Hierarquia:     "},--11
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Posição:     "},--13
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",BGCOLOR='255 255 255',title="Descrição: \n\n\n"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",BGCOLOR='255 255 255',title="Contribuições: \n\n\n"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},--16
					iup.label{FONT = "HELVETICA_BOLD_8",BGCOLOR='230 230 255',title="Punição: \n\n\n"},
				},
			},
			iup.frame{
				size='200x100',
				title="Dados do pessoais",
				iup.vbox{
					iup.hbox{--20
					iup.fill{},iup.label{FONT = "HELVETICA_BOLD_8",FGCOLOR='70 139 174',title="Dados do pessoais"},iup.fill{},
					},
					--2
					iup.hbox{--21
						iup.fill{},
						iup.label{FONT = "HELVETICA_BOLD_8",title="-------------------------------------------"},iup.fill{},
					},
					--22
					iup.label{FONT = "HELVETICA_BOLD_8",title="Nome:                   "},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Sexo:                   "},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Idade:                  "},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="E-mail:                 "},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",title="Telefone:               "},
					iup.label{FONT = "HELVETICA_BOLD_8",title="__________________________________"},
					iup.label{FONT = "HELVETICA_BOLD_8",BGCOLOR='255 255 255',title="Observação: \n\n\n"},
				},

			},
		},
		iup.vbox{
			iup.frame{
					size='200x100',
					title="Ações",
					iup.vbox{
						iup.hbox{
							iup.button{title="Modificar campo",size='80x',action=function()
								edit(CONST_SELECTED)
							end},
							iup.button{title="Impressão",size='80x',action=function()
								printa(CONST_SELECTED)
							end},

							iup.button{title="Deletar",size='80x',action=function()
								if CONST_SELECTED ~= -1 then
									local b = iup.Alarm("Confirmação", "Tem certeza de que quer deletar "..data[CONST_SELECTED]['nickname'] ,"Sim" ,"Não")
									if b == 1 then
										local con,env = connect_db()
										local que = ('UPDATE fichas SET %s=\'%s\' WHERE id=%d;'):format('deleted',1,data[CONST_SELECTED]['id'])
										local _1,erra = assert(con:execute(que))
										con:close()
										env:close()
										for i=1,#lista do
											dlg[1][2][1][1][i] = ''
										end
										createRow()
										for i=1,#lista do
											dlg[1][2][1][1][i] = lista[i]
										end
										setUserSee(-1)
										iup.Message("Delete", "Usuario deletado.")
									end
								end
							end},
						},
						iup.fill{},
						iup.fill{},
						iup.fill{},
						iup.fill{},
						iup.fill{},
						iup.fill{},
						iup.hbox{ --
							iup.fill{},createF('[c="0 0 0" f="HELVETICA_ITALIC_14"]Abullynator [/c]'),iup.fill{},
						},
						iup.hbox{ --
							iup.fill{},createF('[c="0 0 0" f="HELVETICA_BOLD_8"]Version[/c] [c="255 90 90" f="HELVETICA_ITALIC_8"]1.0[/c]'),iup.fill{},
						},
						iup.hbox{ --
							iup.fill{},createF('Por [c="90 90 90" f="HELVETICA_ITALIC_8"]Mock[/c]'),iup.fill{},
						},
						iup.fill{},
					},
				},
				iup.fill{},
			}

	},
  title="Abullynator",

}
dlg:show()

if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

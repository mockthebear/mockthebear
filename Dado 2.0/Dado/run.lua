-- IupVal Example in IupLua
-- Creates two Valuator controls, exemplifying the two possible types.
-- When manipulating the Valuator, the label's value changes.
require( "iuplua" )
require( "iupluacontrols" )
require('socket')
dofile('img.lua')
dofile('skins.lua')
print(string.char(15))
timer1 = iup.timer{time=100}
math.randomseed(os.time())
if not string then
  string = {}
  string.format = format
end
skin = loadSkin('defaut')
maxuser = 10
rand = 0
mx = 1
name = ''
ip = ''
ps = 0
fail = false
ne = 0

status = 'Desconectado'
ml = iup.multiline{
expand="YES",
value="",
INSERT="",
border="YES",
size='x40',
bgcolor="255 255 255",
READONLY="YES",
CANFOCUS='NO',
FORMATTING='YES',

}
function timer1:action_cb()
  if fail == false then
	ml.INSERT = "Bem vindo ao gerador de numeros! By mock."
	fail = true
	end

  if conaa then
		conaa:settimeout(0)
		local q,s = conaa:receive()
		if s == 'closed' then
			conaa = nil
			stat.title = "Status: Desconectado."
			local vv = ml.value
			ml.value = ''
			ml.INSERT = vv..'\nConexão finalizada.'
			limpar()
			for i=1,maxuser do
				clean(i)
			end
		elseif q then
			if q:match('SEN=(.+)') then
				local v_ = q:match('SEN=(.+)')
				local vv = ml.value
				ml.value = ''
				ml.INSERT = vv..'\n'..v_
				ps = ps+1
			elseif q:match('BY=(.-) CLIPED=(.+)') then
				local us,clip = q:match('BY=(.-) CLIPED=(.+)')
				local vv = ml.value
				ml.value = ''
				if us ~= 'nil' then
					ml.INSERT = vv..'\n'..us..''

				else
					ml.INSERT = vv
				end
				ml2.value = ''
				ml2.INSERT = clip:gsub('#','\n')
			elseif q:match('USER=(%d+) NAME=(.-) HP=(%d+) MANA=(%d+) EXP=(%d+) PERCENT=(%d+) LVL=(%d+)') then
				local id,nam,hp,mana,exp,perc,lvlv = q:match('USER=(%d+) NAME=(.-) HP=(%d+) MANA=(%d+) EXP=(%d+) PERCENT=(%d+) LVL=(%d+)')
				boxes[tonumber(id)].tabtitle = nam
				boxes[tonumber(id)][1][1].value=tonumber(perc)/100
				boxes[tonumber(id)][5][2].value=lvlv
				boxes[tonumber(id)][6][2].value=hp
				boxes[tonumber(id)][7][2].value=mana
			elseif q:match('USER=(%d+) CIP=(.+)') then
				local id, da = q:match('USER=(%d+) CIP=(.+)')
				boxes[tonumber(id)][2].value = ""
				boxes[tonumber(id)][2].INSERT=da:gsub('#','\n')
			elseif q == 'ALERT' then
				print('\a\a\a\a')
			elseif q:match('US=(%d+) LVL=(%d+)') then
				local id,lvll = q:match('US=(%d+) LVL=(%d+)')
				boxes[tonumber(id)][5][2].value= lvll
			elseif q:match('US=(%d+) HP=(%d+)') then
				local id,lvll = q:match('US=(%d+) HP=(%d+)')
				boxes[tonumber(id)][6][2].value= lvll
			elseif q:match('US=(%d+) MANA=(%d+)') then
				local id,lvll = q:match('US=(%d+) MANA=(%d+)')
				boxes[tonumber(id)][7][2].value= lvll
			elseif q:match('US=(%d+) XP=(%d+)') then
				local id,lvll = q:match('US=(%d+) XP=(%d+)')
				boxes[tonumber(id)][1][1].value= tonumber(lvll)/100
			elseif q:match('MASTER=(%d+)') then
				if q:match('MASTER=(%d+)') == '1' then
					for ia=1,maxuser do
						boxes[ia][2].READONLY= 'NO'
					end
				else
					for ia=1,maxuser do
						boxes[ia][2].READONLY= 'YES'
					end
				end
			elseif q:match('MS=(.+)') then
				local v_ = q:match('MS=(.+)')
				local vv = ml.value
				ml.value = ''
				ml.INSERT = vv..'\n'..v_
				ps = ps+1
			elseif q:match('ON=(.+)') then
				local s =  q:match('ON=(.+)')
				for i=1,ne do
					lst[i] = nil
				end
				ne = 0
				for i in s:gmatch('(.-),') do
					ne = ne+1
					lst[ne] = i
				end
			end
		end
  end
  return iup.DEFAULT
end
function fbuttonpress(self)
  if(self.type == "VERTICAL") then
    lbl_v.fgcolor = "255 0 0"
  else
    lbl_h.fgcolor = "255 0 0"
  end
  return iup.DEFAULT
end

function fbuttonrelease(self)
  if(self.type == "VERTICAL") then
    lbl_v.fgcolor = "0 0 0"
  else
    lbl_h.fgcolor = "0 0 0"
  end
  return iup.DEFAULT
end

function fmousemove(self, val)
	mx = val
  local buffer = "Maximo: "..val
  if (self.type == "VERTICAL") then
    lbl_v.title=buffer
  else
    lbl_h.title=buffer
  end
  return iup.DEFAULT
end
lbl_v = iup.label{title="Maximo: 0",fgcolor=(skin or {})[5] or "0 0 0",bgcolor = (skin or {})[6] or "236 233 216", size=70, type="1"}
val_v = iup.val{"VERTICAL"; min=0, max=100,	value="1",
        mousemove_cb=fmousemove,
        mousemove_cb=fmousemove,
		button_press_cb=fbuttonpress,
		button_release_cb=fbuttonrelease,
		bgcolor = (skin or {})[4] or "236 233 216",

}


lb2 = iup.label{title="Numero: 0  ",fgcolor=(skin or {})[7] or "0 0 0",bgcolor = (skin or {})[8] or "236 233 216",}
stat = iup.label{title="Status: "..status.."      ",fgcolor="107 82 20"}
nam = iup.label {title="Nome:                            ",fgcolor="107 82 20"}
lb = iup.button{title="Jogar dado",bgcolor = (skin or {})[3] or "236 233 216",}
texte = iup.text {value = "",size="150",bgcolor="255 255 255"}
sended = iup.button{title="Enviar"}
sended.action = function()
	if conaa and texte.value:len() > 0 then
		conaa:send('MSG='..texte.value..'\n')
		texte.value = ''
	end
end
cleana = iup.button{title="Limpar"}
cleana.action = function()
	ml.value = ""
	ml.INSERT = "Bem vindo ao gerador de numeros! By mock."
end
atu = iup.button{title="Atualizar"}
atu.action = function()
	if conaa then
		conaa:send('SEE\n')
	end
end
atua = iup.button{title="  salvar  "}
atua.action = function()
	if conaa then
		conaa:send('CIP='..ml2.value:gsub('\n','#')..'\n')
	end
end
kik = iup.button{title="  KICK   "}
kik.action = function()
	local ret,name = iup.GetParam("Kick",'Kick',"Nome: %s\n",'')
	if conaa and ret then
		conaa:send('KILL='..name..'\n')
	end

end
SALL = iup.button{title="Chamar atenção"}
SALL.action = function()
	if conaa then
		conaa:send('CALL\n')
	end
end
bye = iup.button{title="Desconectar",bgcolor="255 166 155",}
bye.action = function()
	if conaa then
		conaa:close()
	end
end
con = iup.button{title="Conectar",bgcolor="255 166 155",}
con.action = function()
	local ret, ip,name,pass = iup.GetParam("Conectar",'',"IP: %s\nNome(11 max): %s\nSenha do mestre: %s\n",'localhost','Bob','')
	if ret == 1 and name:len() <= 11 and not conaa then
		conaa = socket.connect(ip,7173)
		nam.title = 'Nome: '..name
		if conaa then
			status = 'Conectado.'
			limpar()
			for i=1,maxuser do
				clean(i)
			end
			if pass and pass ~= '' then
				conaa:send('NAME='..name..' PASS='..pass..'\n')
			else
				conaa:send('NAME='..name..'\n')
			end
			ml.INSERT = "\nConectado ao servidor! ("..ip..":80)"
		else
			status = 'Server off.'
			ml.INSERT = "\nServidor offline!"
		end
		stat.title = "Status: "..status..""
	end
end
function aaa(a1)
	ml2.INSERT = 'amagad'
end
ml2 = iup.multiline{expand="YES", value="",INSERT="",border="YES",size='150x40',bgcolor="255 255 255",CANFOCUS='NO',FORMATTING='YES',
valuechanged_cb=aaa,}

lb.action = function()
	rand = math.random(0,mx)
	lb2.title = 'Numero: '..rand
	if conaa then
		conaa:send('N='..rand..' M='..mx..'\n')
	end
 end
lst = iup.list{bgcolor="239 231 204", value = 10, size = "EIGHTHx200"}
header = iup.label{title="",fgcolor="0 255 255",bgcolor="0 0 255",size='180'}

boxes = {}
for i=1,maxuser do
	boxes[i] =  iup.vbox{
	bgcolor = (skin or {})[12] or "236 233 216",
	iup.hbox{iup.gauge{bgcolor = (skin or {})[13] or "236 233 216",fgcolor = (skin or {})[14]},iup.button{title="Add exp",bgcolor = (skin or {})[15] or "236 233 216",fgcolor = (skin or {})[16] or "0 0 0",action = function()
	local ae,qto,va = iup.GetParam("Title",'Add exp',"EXP: %s\nAdcionar: %b\n",'',1)
		if tonumber(qto or 'a') then
			conaa:send('EXPTO='..i..' M='..qto..' T='..tostring(va)..'\n')
		end
	end}},
	iup.multiline{expand="YES", value="",INSERT="",border="YES",size='x40',bgcolor = (skin or {})[17] or "255 255 255",fgcolor = (skin or {})[18] or "0 0 0",font=(skin or {})[19] or "HELVETICA_NORMAL_8",READONLY="YES",CANFOCUS='NO',FORMATTING='YES'},
	iup.fill{},
	iup.label{title="-", expand="HORIZONTAL"},
	iup.hbox{iup.label{title="LVL  ",bgcolor = (skin or {})[20] or "236 233 216",fgcolor = (skin or {})[21] or "0 0 0"},iup.text{READONLY="YES",value = "0",CANFOCUS='NO',size="20",bgcolor = (skin or {})[26] or "200 200 200",fgcolor = (skin or {})[27] or "0 0 0",font=(skin or {})[28] or "HELVETICA_NORMAL_8"},iup.button{image=buytut21,action = function() if conaa then conaa:send('USER='..i..' LVL=+\n') end end},iup.button{image=buytut22,action = function() if conaa then conaa:send('USER='..i..' LVL=-\n') end end},iup.fill{}},
	iup.hbox{iup.label{title="HP   ",bgcolor = (skin or {})[22] or "236 233 216",fgcolor = (skin or {})[23] or "0 0 0"},iup.text{READONLY="YES",value = "0",CANFOCUS='NO',size="20",bgcolor = (skin or {})[29] or "123 27 27",fgcolor = (skin or {})[30] or "255 255 255",font=(skin or {})[31] or "TIMES_BOLD_8"},iup.button{image=buytut1,action = function() if conaa then conaa:send('USER='..i..' HP=+\n') end end},iup.button{image=buytut2,action = function() if conaa then conaa:send('USER='..i..' HP=-\n') end end},iup.fill{}},
	iup.hbox{iup.label{title="MP   ",bgcolor = (skin or {})[24] or "236 233 216",fgcolor = (skin or {})[25] or "0 0 0"},iup.text{READONLY="YES",value = "0",CANFOCUS='NO',size="20",bgcolor = (skin or {})[32] or "30 181 101",fgcolor = (skin or {})[33] or "255 255 255",font=(skin or {})[34] or "TIMES_BOLD_8"},iup.button{image=buytut31,action = function() if conaa then conaa:send('USER='..i..' MP=+\n') end end},iup.button{image=buytut32,action = function() if conaa then conaa:send('USER='..i..' MP=-\n') end end},iup.fill{}},
	iup.hbox{iup.button{title="Carregar usuario",bgcolor = (skin or {})[35] or "236 233 216",fgcolor = (skin or {})[36] or "0 0 0",action = function()
	local ae,qto = iup.GetParam("Carregar",'Nome',"Nome: %s\n",'mock')
	if conaa then
		clean(i)
		conaa:send('USER='..i..' LOAD='..tostring(qto)..'\n')
	end
	end}},
	iup.hbox{iup.button{title="Salvar somente este",bgcolor = (skin or {})[37] or "236 233 216",fgcolor = (skin or {})[38] or "0 0 0",action = function()
	if conaa then
		conaa:send('USER='..i..' CLIPANDO='..tostring(boxes[i][2].value):gsub('\n','#')..'\n')
	end
	end},
	iup.hbox{bgcolor = (skin or {})[39] or "236 233 216",iup.fill{},iup.label{image=diced3},iup.fill{},}}
}
	boxes[i].tabtitle = i.."º    - - - - -     "

end
function limpar()
	for i=1,ne do
					lst[i] = nil
				end
	ml2.value = ''
end
function clean(id)
	boxes[tonumber(id)].tabtitle = id.."º    - - - - -     "
	boxes[tonumber(id)][1][1].value=0
	boxes[tonumber(id)][5][2].value=0
	boxes[tonumber(id)][6][2].value=0
	boxes[tonumber(id)][7][2].value=0
	boxes[tonumber(id)][2].value = ""
end
-- Sets titles of the vboxes
-- Creates tabs
tabs = iup.tabs{bgcolor = (skin or {})[11] or "236 233 216",unpack(boxes)}
function constructor()
dlg_val = iup.dialog
{
	bgcolor = (skin or {})[1] or "236 233 216",
	size="800x400",
	sizemax=500,
	iup.hbox
	{

		iup.frame
		{
		bgcolor = (skin or {})[2] or "236 233 216",
		title="Dado",
			cursor = img_cursor,
			iup.vbox
			{
				lb,
				iup.hbox{val_v,lbl},
				lbl_v,
				lb2,
				iup.fill{},
			iup.fill{};
			iup.label{image=diced},
			iup.fill{};
			iup.fill{};
			},

		},

		iup.frame
		{
		bgcolor = (skin or {})[9] or "236 233 216",
		title="Fichas",
			iup.vbox
			{
			bgcolor = (skin or {})[10] or "236 233 216",
				tabs,

			},

		},

		iup.frame{title='Principal',
		bgcolor = (skin or {})[40] or "236 233 216",
		iup.vbox
			{
				bgcolor = (skin or {})[41] or "236 233 216",
				iup.hbox{iup.frame{title="Painel",
				iup.vbox{iup.hbox{atu,atua},
				iup.hbox{kik,SALL},
				}},iup.fill{},iup.frame{title = "Status",iup.vbox{iup.hbox{con,bye},stat,nam}}},ml2,
				ml,
				iup.frame{iup.hbox{texte,
				sended,iup.fill{};cleana,}},

			},

		},
		iup.frame
		{
			 title = "Players online",
			iup.vbox
			{
			lst,
			iup.fill{};
			iup.label{image=diced2},
			iup.fill{};
			},

		},
	};
	title="Gerador de numeros",

}
return dlg_val
end

dlg_val = constructor()

timer1.run = "YES"
function dlg_val:k_any(c)
	if c == 13 then
		if conaa and texte.value:len() > 0 then
			conaa:send('MSG='..texte.value..'\n')

		end
		texte.value = ''
	end
end
dlg_val:show()

if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

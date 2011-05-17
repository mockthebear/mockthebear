--[[
----------------------------------------------------------------------
-- Tibiando - an opensource audio API to open tibia servers
----------------------------------------------------------------------
--
----------------------------------------------------------------------
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software Foundation,
-- Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
----------------------------------------------------------------------


Copyright (C) 2010  Matheus Braga Almeida
]]
--[[
Open Tibia Advanced Remote Control (OTARC) - Remote control client

By Mock the bear.
]]
require('ex')
require("iuplua")
require('socket')
require( "iupluacontrols" )
require('gd')
---Functions
function loadPhoto(name,t)
	local phto = {}
	local ce = {}
	local n = 0
	local gde
	if not t then
		gde= gd.createFromGif('images/'..name)
	else
		gde= gd.createFromPng('images/'..name)
	end
	assert(gde)
	for x=1,gde:sizeX()+1 do
		for y=1,gde:sizeY()+1 do
			if not phto[(y-1)] then phto[(y-1)] = {} end
			if not phto[(y-1)][(x-1)] then phto[(y-1)][(x-1)] = {} end
			local p = gde:getPixel(x-2, y-2)
			if  (gde:red(p) == 255 and gde:blue(p) ==255 and gde:green(p) == 255) then
				phto[(y-1)][(x-1)] = 0
			else
				local r, b, g = gde:red(p), gde:blue(p), gde:green(p)
				local clr  = r..' '..b..' '..g
				local go = true
				for i,b in pairs(ce) do
					if b == clr then
						go = false
						phto[(y-1)][(x-1)] = i
						break
					end
				end
				if go then
					n = n+1
					ce[n] = clr
					phto[(y-1)][(x-1)] = n
				end
			end
		end
	end
	cs = nil
	return iup.image{colors = ce,hotspot = "1:1",unpack(phto)}
end
function fixStr(s)
	local maxlen = 26
	local s2 = ''
	if math.floor(s:len()/maxlen) == 0 then
		s = s:gsub('€','\n')
		return s..'\n'
	end
	for i=1, math.floor(s:len()/maxlen)+1 do
		s2 = s2..s:sub((i-1)*maxlen+1,((i)*maxlen))..'\n'
	end
	s2 = s2:gsub('€','\n')
	return s2
end
function breakSend(b,s,va,size)
	local maxlen = size or 1024
	local more = {}
	s = s:gsub('\n','€')
	if s:len() < 1024  then
		b:send('BUFF='..s..'\n')
		b:send('DOBUF='..va..'\n')
		return
	end
	for i=1, math.floor(s:len()/maxlen)+1 do
		if i == 1 then
			b:send('BUFF='..s:sub((i-1)*maxlen+1,((i)*maxlen))..'\n')
			b:send('SEND='..i..' TO='..(math.floor(s:len()/maxlen)+1)..'.\n')
		else
		more[i] = {	'BUFF='..s:sub((i-1)*maxlen+1,((i)*maxlen))..'\n','SEND='..i..' TO='..(math.floor(s:len()/maxlen)+1)..'.\n',false,function()
			gaug.value = (i*100/(math.floor(s:len()/maxlen)+1))/100
			recs.title = "Uploading -  "..i.."/"..(math.floor(s:len()/maxlen)+1).."" end}
		end
	end
	more[math.floor(s:len()/maxlen)+2] = {('DOBUF='..va..'\n'),'',true}
	tosend[1] = more
end
---
local wait_colorchange = 0
local stept = 0
local skt = {
buff = '',
}
tosend = {}
conect = nil

fr1 = iup.frame
{
	iup.hbox
	{
		title="Painel",
		iup.button{title="Connect",ACTIVE='YES',action = function()
			if pass.value ~= '0x' then
				tree.MARK = '1'
				skt.buff = ''
				tree.DELNODE = "CHILDREN"
				tree.redraw = "YES"
				wai.image= IMG_wait
				wait_colorchange = stept+5
				log_.insert = ('Conecting on:\n'..tostring(ip[1].value)..':'..tostring(port[1].value)..'.\n')
				conect = socket.connect(tostring(ip[1].value),tonumber(port[1].value) or 5394)
				if conect then
					log_.insert = ('Conected.\n\n')
					conc.image = loadPhoto('conected.png',1)
					desc.image = loadPhoto('desconectedno.png',1)
					conect:send('PASS:'..pass.value..'\n')
				else
					log_.insert = ('Cannot Conect\n')
					desc.image =  loadPhoto('desconected.png',1)
					conc.image = loadPhoto('conectedno.png',1)
				end
			else
				iup.Message("Info", "Please type the password!")
			end
		end},
		iup.button{title="Desconect",ACTIVE='NO',action = function()
			if conect then
				conect:close()
				conect = nil
				log_.insert = 'Connection closed.\n'
				wai.image= IMG_wait
				wait_colorchange = stept+5
				desc.image = loadPhoto('desconected.png',1)
				conc.image = loadPhoto('conectedno.png',1)
			end
		end},
		iup.fill{},
		};
}
IMG_waitno = loadPhoto('waitno.png',1)
IMG_wait = loadPhoto('wait.png',1)
desc = iup.label{title = "Status",image =loadPhoto('desconected.png',1)}
wai = iup.label{title = "Status",image =IMG_waitno}
conc = iup.label{title = "Status",image =loadPhoto('conectedno.png',1)}
ip = iup.frame{
	title = 'IP',
	iup.text{value = "localhost", expand = "NO",size='160x'},
	}
port = iup.frame{
	title = 'PORT',
	iup.text{value = "5394", expand = "NO",size='160x'},
	}
btsize = '19x16'
fr2 = iup.frame
{
	iup.hbox
	{
		iup.button{title="0",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="1",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="2",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="3",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="4",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="5",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="6",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="7",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		size='160x'
	};
}
fr3 = iup.frame
{
	iup.hbox
	{
		iup.button{title="8",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="9",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="a",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="b",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="c",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="d",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="e",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		iup.button{title="f",size=btsize,  action=function(self) pass.value = pass.value..tostring(self.title) end},
		size='160x'
	};

}
log_ = iup.multiline{insert="", size='160x220',ACTIVE='NO',bgcolor='233 233 233',fgcolor='198 156 37'}
ZKRIPT = iup.multiline{insert="",size='400x320',expand = "YES", ACTIVE='YES',MULTILINE='YES',fgcolor='0 0 0'}
pass = iup.text {value = "0x", expand = "NO",ACTIVE='NO',size='160x'}
dir = iup.text {value = "", expand = "NO",ACTIVE='YES',size='180x'}
lbl  = iup.label {title = "0",size='130x',alignment = "ACENTER"}
recs  = iup.label {title = "Donwloading -  ?/?",size='100x',alignment = "ACENTER"}
fname  = iup.label {title = 'File name: -',size='130x',alignment = "ACENTER"}
timer_pass = iup.timer{time=100,run = "YES"}
con = iup.timer{time=10,run = "YES"}
clear = iup.button{title="Clear",  action=function() pass.value = '0x' end,size='160x'}
tree = iup.tree{}
gaug = iup.gauge{size='100x'}
iup.TreeSetValue(tree,{branchname='root'})
arira = iup.label{title = "",image =loadPhoto('im1.png',1)}
function tree:renamenode_cb(id)
	if tree.name:find('(.+)%.(.-)') then
		dir.value = tree.name
	end
	return iup.DEFAULT
end
function tree:rightclick_cb(id)
	tree.value = id
	tree:renamenode_cb(tree.value)
  return iup.DEFAULT
end
DATA = iup.vbox{
					iup.hbox{
						iup.button{title="Save", ACTIVE='NO', action=function() log_.insert = fixStr('Saving...') conect:send('PRESS=SAVE VALUE=1\n') end,size='160x'},
						iup.button{title="Broadcast", ACTIVE='NO', action=function()
						local ret, var = iup.GetParam("Send Broadcast",'',"Message: %s\n",'')
						if ret == 1 then
							log_.insert = fixStr('Sending: '..tostring(var)..'...')
							conect:send('PRESS=BROADCAST VALUE='..tostring(var)..'\n')
						end
						end,size='160x'},
						iup.button{title="Reload", ACTIVE='NO', action=function() -- *8486
						local ret, var = iup.GetParam("Reload info",'','List: %l|RELOAD_ACTIONS|RELOAD_CHAT|RELOAD_CONFIG|RELOAD_CREATUREEVENTS|'..
						'RELOAD_GAMESERVERS|RELOAD_GLOBALEVENTS|RELOAD_GROUPS|RELOAD_HIGHSCORES|RELOAD_HOUSEPRICES|'..
						'RELOAD_ITEMS|RELOAD_MONSTERS|RELOAD_MOVEEVENTS|RELOAD_NPCS|RELOAD_OUTFITS|RELOAD_QUESTS|RELOAD_RAIDS|'..
						'RELOAD_SPELLS|RELOAD_STAGES|RELOAD_TALKACTIONS|RELOAD_VOCATIONS|RELOAD_WEAPONS|RELOAD_MODS|RELOAD_ALL|\n',0)
						if ret == 1 then
							log_.insert = fixStr('Reloading: '..tostring(var+1)..'...')
							conect:send('PRESS=RELOAD VALUE='..tostring(var+1)..'\n')
						end
						end,size='160x'},
						iup.button{title="Kick", ACTIVE='NO', action=function()
						local ret, var = iup.GetParam("Send Broadcast",'',"Message: %s\n",'')
						if ret == 1 then
							log_.insert = fixStr('Sending: '..tostring(var)..'...')
							conect:send('PRESS=KICK VALUE='..tostring(var)..'\n')
						end
						end,size='100x'},

						iup.fill{},
					},
					iup.hbox{iup.button{title="Execute a piece of script", ACTIVE='NO', action=function()
						local ret, var = iup.GetParam("Execute a piece of script",'',"Script: %m\n",'')
						if ret == 1 then
							local ret,err = loadstring(tostring(var))
							if not ret then
								log_.insert = fixStr('Error on sending lua code: '..err..'')
								iup.Message("ERROR", err)
							else
								log_.insert = fixStr('Executing lua code...')
								var = var:gsub('\n','€')
								conect:send('PRESS=LUA VALUE='..var..'\n')
							end
						end
						end,size='160x'},
						iup.button{title="Set state server", ACTIVE='NO', action=function()
						local ret, var = iup.GetParam("Server state",'','List: %l|GAMESTATE_STARTUP|GAMESTATE_INIT|'..
						'GAMESTATE_NORMAL|GAMESTATE_MAINTAIN|GAMESTATE_CLOSED|GAMESTATE_CLOSING|GAMESTATE_SHUTDOWN|\n',0)
						if ret == 1 then
							log_.insert = fixStr('Seting state server to : '..tostring(var+1)..'...')
							conect:send('PRESS=STATESERVER VALUE='..tostring(var+1)..'\n')
						end
						end,size='160x'},
						iup.button{title="Set world type", ACTIVE='NO', action=function()
						local ret, var = iup.GetParam("world type",'','List: %l|WORLDTYPE_NO_PVP|WORLDTYPE_PVP|WORLDTYPE_PVP_ENFORCED|\n',0)
						if ret == 1 then
							log_.insert = fixStr('Seting world type to: '..tostring(var+1)..'...')
							conect:send('PRESS=MODE VALUE='..tostring(var+1)..'\n')
						end
						end,size='160x'},
						iup.button{title="Ban", ACTIVE='NO', action=function()
						local ret, var = iup.GetParam("Send Broadcast",'',"Message: %s\n",'')
						if ret == 1 then
							log_.insert = fixStr('Sending: '..tostring(var)..'...')
							conect:send('PRESS=BAN VALUE='..tostring(var)..'\n')
						end
						end,size='100x'}
						,
						},
					iup.hbox{
						ZKRIPT,
						iup.vbox{
								fname,
								dir,
								iup.button{title="Request",size='180x', ACTIVE='NO',action = function()
									if conect then
										log_.insert = fixStr('Requesting '..dir.value..'.')
										conect:send('REQUEST='..dir.value..'\n')
										DATA[3][2][3].ACTIVE='NO'
										DATA[3][2][4].ACTIVE='NO'
									end
								end},
								iup.button{title="Save file",size='180x', ACTIVE='NO',action = function()
									if conect then
										breakSend(conect,ZKRIPT.value:gsub('\n','€'),dir.value,size)
										DATA[3][2][3].ACTIVE='NO'
										DATA[3][2][4].ACTIVE='NO'
									end
								end},
							tree,
							iup.hbox{
								iup.button{title="Information",image=loadPhoto('credit.png',1),action=function() show_info() end},
								iup.fill{},
									iup.frame{
										title='Status',
										iup.hbox{
											desc,
											wai ,
											conc,
										},
									},
									iup.fill{},
								},
						},
					},
					iup.fill{},
				}
function timer_pass:action_cb()
	if not first then
		log_.insert= 'Welcome to the Bear\nopen tibia remote control\n------------------------------------------\n'
		first = true
	end
	if pass.value ~= '0x' then
		if  tostring(tonumber(pass.value)) ~= lbl.title  then
			lbl.title = tostring(tonumber(pass.value))
		end
	else
		if  tostring(tonumber(pass.value)) ~= lbl.title  then
			lbl.title = 0
		end
	end
	if pass.value:len() > 10 then
		pass.value = pass.value:sub(1,10)
		iup.Message("Info", "Only 8 characters or less!")
	end
	if conect then
		fr1[1][1].ACTIVE = 'NO'
		fr1[1][2].ACTIVE = 'YES'

		for i=1,8 do
			fr2[1][i].ACTIVE= 'NO'
			fr3[1][i].ACTIVE= 'NO'
		end
		ip[1].ACTIVE= 'NO'
		port[1].ACTIVE= 'NO'
		clear.ACTIVE= 'NO'

		for de=1,2 do
			for i=1,4 do
				if DATA[de][i] then
					DATA[de][i].ACTIVE='YES'
				end
			end
		end
	elseif fr1[1][1].ACTIVE == 'NO' and not conect then
		fr1[1][1].ACTIVE = 'YES'
		fr1[1][2].ACTIVE = 'NO'

		for i=1,8 do
			fr2[1][i].ACTIVE= 'YES'
			fr3[1][i].ACTIVE= 'YES'
		end
		ip[1].ACTIVE= 'YES'
		port[1].ACTIVE= 'YES'
		clear.ACTIVE= 'YES'

		DATA[3][2][3].ACTIVE='NO'
		DATA[3][2][4].ACTIVE='NO'
		for de=1,2 do
			for i=1,4 do
				if DATA[de][i] then
					DATA[de][i].ACTIVE='NO'
				end
			end
		end
		tree.DELNODE = "CHILDREN"
		tree.redraw = "YES"
		iup.TreeSetValue(tree,{branchname='root'})
		tree.redraw = "YES"
		ZKRIPT.value = ''
		fname.title = 'File name: -'
		iup.Message("Info", "Connection closed.")
	end
end
function con:action_cb()
	stept = stept+1
	if stept == wait_colorchange then
		wai.image= IMG_waitno
	end
	--[[
	socket
	]]
	if conect then
		conect:settimeout(0)
		local ret,v = conect:receive()
		if ret then

			if ret:match('MSG=(.+)') and not ret:match('.+MSG=(.+)') then
				log_.insert = fixStr(ret:match('MSG=(.+)'))
			elseif ret:match('SEND=(%d+) TO=(%d+)') then
				wai.image= wai.image == IMG_waitno and IMG_wait or IMG_waitno
				local nw,max = ret:match('SEND=(%d+) TO=(%d+)')
				gaug.value = (nw*100/max)/100
				recs.title = "Donwloading -  "..nw.."/"..max..""
				conect:send('M:'..(nw+1)..'\n')
				conect:send('M:'..(nw+2)..'\n')

			elseif ret:match('D:(%d+)') then
				local naa = ret:match('D:(%d+)')
				if tosend[1][tonumber(naa)] then
					wai.image= wai.image == IMG_waitno and IMG_wait or IMG_waitno
					conect:send(tosend[1][tonumber(naa)][1])
					conect:send(tosend[1][tonumber(naa)][2])
					if tosend[1][tonumber(naa)][3] then
						tosend[1] = {}
						DATA[3][2][4].ACTIVE='YES'
					end
					if tosend[1] and tosend[1][tonumber(naa)] and tosend[1][tonumber(naa)][4] then
						tosend[1][tonumber(naa)][4]()
					else
						gaug.value = 0
						recs.title = "Donwloading -  ?/?"
						wai.image = IMG_waitno
						wait_colorchange = stept+5
					end
				end
			elseif ret =='ACTIVE' then
				DATA[3][2][3].ACTIVE='YES'
				DATA[3][2][4].ACTIVE='YES'
				ZKRIPT.ACTIVE = 'YES'
				DATA[3][2][4].ACTIVE='YES'
			elseif ret == 'DEACTIVE' then
				DATA[3][2][3].ACTIVE='NO'
				DATA[3][2][4].ACTIVE='NO'
				ZKRIPT.ACTIVE = 'NO'
				DATA[3][2][4].ACTIVE='NO'
			elseif ret:match('BUFF=(.+)') then
				skt.buff = skt.buff..ret:match('BUFF=(.+)')
				wai.image= wai.image == IMG_waitno and IMG_wait or IMG_waitno
				DATA[3][2][3].ACTIVE='NO'
			elseif ret:match('FNAME=(.+)') then
				fname.title = 'File name: '..tostring(ret:match('FNAME=(.+)'))
			elseif ret:match('DOBUF=(%d+)') then
				if skt.buff ~= '' then
					gaug.value = 0
					wai.image= IMG_wait
					wait_colorchange = stept+5
					recs.title = "Donwloading -  ?/?"
					local runing = ret:match('DOBUF=(%d+)')
					skt.buff = skt.buff:gsub('€','\n')
					if runing == '1' then
						DATA[3][2][3].ACTIVE='YES'
						local table_,err = loadstring('return '..skt.buff)
						if not table_ and err then
							log_.insert = fixStr('Error on setting dir table! '..err..' >: '..runing)
							local f = io.open('error.lua','w')
							f:write(skt.buff)
							f:close()
						else
							tree.DELNODE = "CHILDREN"
							tree.redraw = "YES"
							os.sleep(0.01)
							iup.TreeSetValue(tree,table_())
							tree.redraw = "YES"
						end
					elseif runing == '2' then
						DATA[3][2][3].ACTIVE='YES'
						DATA[3][2][4].ACTIVE='YES'
						ZKRIPT.ACTIVE = 'YES'
						ZKRIPT.value = skt.buff
						DATA[3][2][4].ACTIVE='YES'
						log_.insert = fixStr('Loaded file.')
					end
					skt.buff = ''
				end
			end
		elseif not ret and v == 'closed' then
			conect:close()
			conect = nil
		end
	end
	return iup.DEFAULT
end
function show_info()
	local lbl = iup.label { title = "Open Tibia Advanced Remote Control",
                  bgcolor = "219 195 195",
                  fgcolor = "0 0 0",
                  font = "COURIER_BOLD_14",
                  alignment = "ACENTER" }
	local lbla = iup.label { title ="By mock                           \nVersion 1.0.85                    \n",
                  bgcolor = "255 171 94",
                  fgcolor = "255 255 255",
                  font = "COURIER_NORMAL_14",
                  alignment = "ACENTER" }
	local lblR = iup.label { title = "Contact: mock_otnet@hotmail.com   ",
                  bgcolor = "219 195 195",
                  fgcolor = "255 255 255",
                  font = "COURIER_BOLD_14",
                  alignment = "ACENTER" }
	local dlg = iup.dialog { iup.vbox { lbl,lbla,lblR},}
	dlg:showxy ( iup.CENTER, iup.CENTER )

	if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
		iup.MainLoop()
	end
end

dlg = iup.dialog
{
	icon=loadPhoto('ico.png',1),
	iup.frame
	{
	title="Advanced remote control",
		iup.hbox{
			iup.frame{
				title="General",
				iup.vbox
				{
					fr1,
					ip,
					port,
					iup.frame{
						title="Password",
						iup.vbox{
						fr2,
						fr3,
						pass,
						iup.hbox{iup.label{title = "Pass:"},lbl},
						clear,
						},
					};
					iup.frame{
						size='160x',
						title="Status",
						iup.vbox{
						log_,
						iup.hbox{
							size='160x',
							iup.vbox{arira,
							iup.label{title = "   By Mock"},
							},
							iup.vbox{
							gaug,
							recs,
							}
						},
						iup.fill{},
						},
						}
				},
			},
			iup.frame{
				title="Console",
				DATA,
			},
		}
	};
	size='500x400',
  title="The bear remote",

}

dlg:show()

if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
  iup.MainLoop()
end
-- q

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

	--Conf
	run_on_debug = false
	client_name = "Tibia.exe"
	local ip = 'localhost'
	local port = 7173
	--
	if run_on_debug then
		showWindow()
	end
	function play_simple(name,t)
			local q = io.open('lang.dat','r')
			lang = q:read()
			q:close()
			local ret = playMusic('def audio/'..name..'-'..(lang or 'en')..'.ogg')
			if t then
				os.sleep(t)
			end
			return ret
	end
	function set_Lang(l)
		local dat = io.open('lang.dat','w')
		if dat then
			lang = dat:write(l)
			dat:close()
		else
			iup.Message('Error!', 'Cannot open lang.dat')
		end
		return l
	end
	function set_pref(l)
		local dat = io.open('preference.dat','w')
		if dat then
			lang = dat:write(l)
			dat:close()
		else
			iup.Message('Error!', 'Cannot open preference.dat')
		end
		return l
	end
	function isFile(name)
		local f = io.open(name,'r')
		if f then
			f:close()
			return true
		end
		return false
	end
	require( 'iuplua' )
	require('socket')
	require('ex')

	if isRunning() == 0 then
		if not run_on_debug then
			os.execute('start '..client_name)
		end
	end
	iup.SetLanguage('ENGLISH')
	if run_on_debug then
		ip,port = iup.Scanf('IP from server.\nIP:%500.70%s\nPort:%500.70%d\n', 'localhost',7173)
		ip = ip or 'localhost'
		port = port or 7173
	end
	local file = 0
	local loquendo = 3
	local mute = false
	local dat = io.open('preference.dat','r')
	if dat then
		loquendo = tonumber(dat:read(-1) or '')
		dat:close()
	else
		iup.Message('Error!', 'Cannot open preference.dat')
	end
	local dat = io.open('lang.dat','r')
	if dat then
		lang = dat:read(-1)
		dat:close()
	else
		iup.Message('Error!', 'Cannot open lang.dat')
	end
    if not lang then lang = 'pt' end
	if not ip then ip = 'localhost' end
	local nams = 0
	if loquendo == 1 then
		play_simple('ag',1.5)
	end
	local otherports = {port}
	local conec = {}
	for i=1,#otherports do
		conec[i] = socket.connect(ip,otherports[i])
	end
	if not conec[1] then
		if loquendo == 1 then
			play_simple('err',2.1)
			play_simple('bye',1.5)
		end
		os.exit()
	end
	if loquendo == 1 then
		play_simple('con',1.1)
	end
	infor = {
		[1] = {},
		[2] = {},
	} -- Ico
	local trayico = iup.image{
		{3,3,3,3,3,3,3},
		{3,2,2,2,2,2,3},
		{3,3,3,2,3,3,3},
		{4,1,3,2,3,1,4},
		{1,4,3,2,3,4,1},
		{4,1,3,2,3,1,4},
		{1,4,3,2,3,4,1},
		{4,1,3,3,3,1,4},
		colors={
			"BGCOLOR",
			'255 0 0 ',
			'255 255 0 ',
			'0 0 0'
		},
	}
	dg = iup.dialog{iup.label{title='Tibiando'}; title='Tibiando',tray = 'YES', traytip =  'Tibiando', trayimage = trayico}
	dg:show()
	dg.hidetaskbar = 'YES'
			item_q3 = iup.item({title = 'BR', key = 'K_a', value = (lang == 'pt' and 'ON' or 'OFF'),action = function(ae)
				if item_q3.value == 'ON' then
					item_q3.value = 'OFF'
					item_q4.value = 'ON'
					lang = set_Lang('en')
				else
					item_q3.value = 'ON'
					lang = set_Lang('pt')
					item_q4.value = 'OFF'
				end
				return true
			end})
			item_q4 = iup.item({title = 'US', key = 'K_a', value =  (lang == 'en' and 'ON' or 'OFF'),action = function(ae)
				if item_q4.value == 'ON' then
					item_q4.value = 'OFF'
					item_q3.value = 'ON'
				else
					item_q4.value = 'ON'
					lang = set_Lang('pt')
					lang = set_Lang('en')
					item_q3.value = 'OFF'
				end
				return true
			end})
			item_q5 = iup.item({title = 'Loquendo', key = 'K_a', value = ((loquendo == 3 or loquendo == 2) and 'ON' or 'OFF'),action = function(ae)
				if item_q5.value == 'ON' then
					loquendo = 0
					item_q5.value = 'OFF'
					loquendo = set_pref(loquendo)
				else
					loquendo = 1
					item_q5.value = 'ON'
					loquendo = set_pref(loquendo)
				end
				return true
			end})

		menu_create2 = iup.menu {item_q3,item_q4,iup.separator{},item_q5,item_q6,iup.separator{},item_q7}
		submenu_create2 = iup.submenu {menu_create2; title = 'Opitions'}
					item_show = iup.item({title = 'Mute',
			action = function()
				mute = mute == false and true or false
				if mute == false then
					conec[1]:send('KD\n')
				end
				item_show.value = item_show.value == 'ON' and 'OFF' or 'ON'
				pauseAll()
			end})

			item_q2 = iup.item({title = 'Info',action = function()
				local IP = conec[1]:getpeername()
				iup.Message('Information', 'Tibiandio v.2.1\nBy Mock\nServer:'..IP..'')
			end})
			item_exit = iup.item({title = 'Exit',
			action = function()
				if loquendo == 1 then
					play_simple('bye')
				end
				os.exit()
			end})
			------exit
			menu = iup.menu{submenu_create2,iup.separator{},item_q2,item_q,item_show, item_exit}
	function dg.trayclick_cb(self, b, press, dclick)
		if b == 3 and press then
			menu:popup(iup.MOUSEPOS, iup.MOUSEPOS)
		end
		return iup.DEFAULT
	end
	timer1 = iup.timer{time=100}

	function timer1:action_cb()
		for i,client in pairs(conec) do
			client:settimeout(0)
			local ret,info = client:receive(receivelen)
			if not ret and info == 'closed' then
				if loquendo == 1 then
					play_simple('ext',1.5)
					play_simple('bye',1.2)
				end
				os.exit()
			end
			if ret then
				print(ret)
				if ret:match('MUSIC=(.+)') then
					local go = ret:match('MUSIC=(.+)')
					if go == 'stop' then
						pauseAll()
					elseif isFile('audio/'..go) then
						pauseAll()
						if not mute then
							playMusicLoop('audio/'..go)
						end
					else
						client:send('FAIL='..go..'\\n')
					end
				elseif ret:match('EF=(.+)') then
					local go = ret:match('EF=(.+)')
					if isFile('audio/'..go) then
						if not mute then
							playMusic('audio/'..go)
						end
					end
				elseif ret:match('KEY=(.+)') then
					local key = ret:match('KEY=(.+)')
					if key ~= '114324557257395783985' then
						play_simple('update')
					end
				elseif ret:match('IP=(.-) PORT=(%d+)') then
						client:close()
						play_simple('ext',1.5)
						local ipe,porte = ret:match('IP=(.-) PORT=(%d+)')
						print(ipe,porte)
						client = socket.connect(ipe,tonumber(porte))
						if not client then
							if loquendo == 1 then
								play_simple('bye',1.2)
							end
						else
							play_simple('con',1.5)
						end
				elseif ret:match('TIP=(%d+) MESS1=(.-) MESS2=(.+)') then
					local tipe, m1,m2 = ret:match('TIP=(%d+) MESS1=(.-) MESS2=(.+)')
					if loquendo == 1 then
						play_simple('msg')
					end
					iup.Message(m1,m2)
				end
			end
		end
		return iup.DEFAULT
	end
	timer1.run = 'YES'
	if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
	  iup.MainLoop()
	end

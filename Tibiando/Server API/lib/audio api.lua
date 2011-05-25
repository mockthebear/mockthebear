--[[
----------------------------------------------------------------------
-- Tibiando Server API - an opensource audio API to open tibia servers
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

function startAPI(port)
	if not socket then
		print('Please install lua socket!')
		return nil
	end
	dj={}
	--Config
	dj.ip = port or 7173
	-- Ip to listen
	dj.bind = "*"
	-- delay to check players location.
	dj.delay = 1000
	-- print all received messages on console
	dj.print = true
	-- Dj mode 1- play by player posittion 2- play like radio
	dj.mode = 1 -- mode 2 dont work
	-- Dj channel ID
	dj.mainMusic = 'main.ogg' --- music to play if playere is on no music position
	--
	dj.randomic = {}
	dj.area = {
	--Where and how will play musicas

	{{x=1019,y=1007,z=7},{x=1053,y=1046,z=7},{'music.mp3'},type=1},
	}
	dj.online = {}
	dj.n = 0
	server = socket.bind(dj.bind,dj.ip)
	function isRandMusic(r,v)
		for i,b in pairs(r) do
			if v == b then
				return true, i
			end
		end
		return false
	end
	if server then
		print('Ready')
	else
		print('Error!\acanot bind on '..dj.bind..':'..dj.ip)
	end
	function getPlayer(ipe)
		dofile('config.lua')
		for ind,sid in pairs(getPlayersOnline()) do
			if ipe == doConvertIntegerToIp(getPlayerIp(sid)) or (doConvertIntegerToIp(getPlayerIp(sid)) == ip and ipe == '127.0.0.1') then
				return  sid
			end
		end
	end
	function sock_accepter()
		while true do
			server:settimeout(0)
			local nvm = server:accept()
			if nvm then
				local ip_ = nvm:getpeername()
				for i,b in pairs(dj.online) do
					if ip_ == b.ip then
						nvm:close()
						nvm = nil
						break
					end
				end
			end
			coroutine.yield(nvm)
		end
	end
	function sock_mannager(user,i)
			 if user.music == nil  then
				local urs =  getPlayer(dj.online[i].ip)
				if urs then
					dj.online[i].player = getCreatureName(urs)
					dj.online[i].cid = urs
				 	play(user,i)
					if dj.print then  print(dj.online[i].ip..' is: '..dj.online[i].player) end
					user[1]:send('EF=login.wav\n')
					user[1]:send('KEY=114324557257395783985\n')
					dj.online[i].fu = false
					dj.online[i].t = os.time()+4
				end
			 end
			 if dj.online[i].player then
				if isPlayer(getCreatureByName(dj.online[i].player )) == false then
				   addEvent(
				   function(id)
						if isPlayer(getCreatureByName(id,i,mus)) == false then

						else
							dj.online[i].player = id
							dj.online[i].cid = getCreatureByName(id,i,mus)
							dj.online[i].music = mus
						end
					end,1000,dj.online[i].player,i,dj.online[i].music)
				   if dj.print then  print(dj.online[i].ip..' logged off: '..dj.online[i].player) end
				   dj.online[i].fu = nil
				   dj.online[i][1]:send('MUSIC=stop\n')
				   dj.online[i].player = nil
				   dj.online[i].music = nil

				end
			 end
			 user[1]:settimeout(0.0001)
			 local ret,stat = user[1]:receive()

			 if ret then
				if ret:match('MESS=(.+)') then
					local mess = ret:match('MESS=(.+)')
					if dj.online[i].player and mess:len() < 150 then
						doPlayerSendToChannel(getPlayerByName(dj.online[i].player), getPlayerByName(dj.online[i].player),8, dj.online[i].player..': '..mess, dj.channel, 0)
						doPlayerSendTextMessage(getPlayerByName(dj.online[i].player) or 0,20,'You sent: '..tostring(mess))
					end
				elseif ret:match('KD') then
					play2(user,i)
				end

			 end
			 if not ret and stat == 'closed' then
				if dj.print then  print(dj.online[i].ip..' closed sound') end
				dj.online[i] = nil
			 end
	end
	dj.co1 = coroutine.create(sock_accepter)
	function play(b,i,t)
		if not isPlayer(b.cid) then
			return
		end
		local ps = getCreaturePosition(b.cid)
		if not ps then
			return
		end
		local inde = 0
		for ind,va in pairs(dj.area) do
			if va.type == 5 and va.f(b.cid) then
				inde = ind
				break
			elseif va.type == 4 and getGlobalStorageValue(va.storage) ~= -1 then
				inde = ind
				break
			elseif va.type == 3 and getPlayerStorageValue(b.cid,va.storage) ~= -1 then
				inde = ind
				break
			elseif va.type == 2 and ps and getTilePzInfo(ps) then
				inde = ind
				break
			elseif va.type == 1 and insideArea(va[1],va[2],ps) then
				inde = ind
				break
			end
		end
		if inde ~= 0 then
			if not isRandMusic(dj.area[inde][3],b.music) then
				local randome = math.random(1,#dj.area[inde][3])
					b[1]:send('MUSIC='..dj.area[inde][3][randome]..'\n')
					b[1]:send('OK play\n')
					if dj.print then  print(dj.area[inde][3][randome],' to ', getCreatureName(b.cid)) end
					b.music = dj.area[inde][3][randome]
			end
		else
			if dj.online[i] and dj.online[i].music ~= dj.mainMusic then
				b[1]:send('MUSIC='..dj.mainMusic..'\n')
				b[1]:send('OK play\n')
				b.music = dj.mainMusic
			end
		end
	end
	function play2(b,i,t)
		local ps = getCreaturePosition(b.cid)
		local inde = 0
		for ind,va in pairs(dj.area) do
			if va.type == 5 and va.f(b.cid) then
				inde = ind
				break
			elseif va.type == 4 and getGlobalStorageValue(va.storage) ~= -1 then
				inde = ind
				break
			elseif va.type == 3 and getPlayerStorageValue(b.cid,va.storage) ~= -1 then
				inde = ind
				break
			elseif va.type == 2 and ps and getTilePzInfo(ps) then
				inde = ind
				break
			elseif va.type == 1 and insideArea(va[1],va[2],ps) then
				inde = ind
				break
			end
		end
		if inde ~= 0 then
			local randome = math.random(1,# dj.area[inde][3])
			if not b.fu then
				addEvent(function(b)
					b[1]:send('MUSIC='..dj.area[inde][3][randome]..'\n')
					b[1]:send('OK play\n')
					dj.online[i].music = dj.area[inde][3][randome]
					b.fu = true
				end,1400,b)
			else
				b[1]:send('MUSIC='..dj.area[inde][3][randome]..'\n')
				b[1]:send('OK play\n')
				dj.online[i].music = dj.area[inde][3][randome]
			end
		else
			b[1]:send('MUSIC='..dj.mainMusic..'\n')
			b[1]:send('OK play\n')
			dj.online[i].music = dj.mainMusic
		end
	end
	function onThink()
		if server then
			local ret,var = coroutine.resume(dj.co1)
			assert(ret,var)
			if ret == true and var then
				dj.n = dj.n+1
				local ipa = var:getpeername()
				dj.online[dj.n] = {var,ip=ipa,ended=os.clock()-1}
				local urs = getPlayer(ipa)
				if urs then
					if dj.print then  print(ipa..' Logged in: '.. getCreatureName(urs) ) end
				   dj.online[dj.n].player = getCreatureName(urs)
				   dj.online[dj.n].fu = false
				   dj.online[dj.n].t = os.time()+4
				   dj.online[dj.n].cid = urs
				else
					if dj.print then print(ipa..' Logged in: no char.' ) end
				end
			end
			for index,varm in pairs(dj.online) do
				sock_mannager(varm,index)
				if varm.t and varm.t <= os.time() then
				play(varm,index)
				end
			end
		end
		addEvent(onThink,dj.delay)
	end
	function insideArea(p1,p2,me)
		if not me then return false end
		if p1.x <= me.x and p2.x >= me.x then
			if p1.y <= me.y and p2.y >= me.y then
				if p1.z >= me.z and p2.z <= me.z then
					return true
				end
			end
		end
		return false
	end
	addEvent(print,100,'OK')
	addEvent(onThink,100)
	return dj
end


--config
mestre_pass = '123'
---
showWindow()
require 'socket'
require('ex')
print('escreva um numero mto loko aki')
local q = socket.bind('*',tonumber(io.read()))
if not q then
	os.exit()
end
print('vlw, agora avisa pro mock.')
local n = 0
local us = {}
local lastaa = 'nil'
local clipedd = io.open('clip.txt','r')
if clipedd then
	clip = clipedd:read(-1)
	clipedd:close()
end
function write_(s)
	local clipedd = io.open('clip.txt','w')
	if clipedd then
		clipedd:write(s)
		clipedd:close()
	end
end

data = {
users = {}
}

clip = clip or 'Data lost'
	function char(u)
	end
	while true do
		q:settimeout(0.01)
		local x = q:accept()
		if x then
			x:settimeout(2)
			local t = x:receive()
			if t then
				if t:match('NAME=(.-) PASS=(.+)') or t:match('NAME=(.+)') then
					n = n+1
					if t:match('NAME=(.-) PASS=(.+)') then
						name,pass = t:match('NAME=(.+) PASS=(.+)')
						if name:find('%[M%]') then
							name = math.random(0,1000)
						end
					else
						name,pass = t:match('NAME=(.+)'),''
						if name:find('%[M%]') then
							name = math.random(0,1000)
						end
					end
					us[n] = {x,name,ignore=false,mestre=(mestre_pass == pass and true or false)}
					if us[n].mestre then
						us[n][2] = '[M]'..us[n][2]
						x:send('SEN='..os.date('[%H:%M:%S]')..' <Server> você é mestre!\n')
						x:send('MASTER=1\n')
					else
						x:send('MASTER=0\n')
					end
					local qee = ''
					x:send('BY='..lastaa..' CLIPED='..clip..'\n')
					for i,b in pairs(data.users) do
						x:send(string.format('USER=%d NAME=%s HP=%d MANA=%d EXP=%d PERCENT=%d LVL=%d\n',i,data.users[i].NAME,data.users[i].HP,data.users[i].MANA,data.users[i].EXP,data.users[i].PERCENT,data.users[i].LVL))
						local file = io.open('users/'..data.users[i].NAME..'_clip.txt','r')
						local cip = 'ERROR'
						if file then
							cip = file:read(-1)
							file:close()
						end
						x:send(string.format('USER=%d CIP=%s\n',i,cip or 'ERROR'))
					end
					for i,v2 in pairs(us) do
						v2[1]:send('SEN=['..name..'] Entrou.\n')
						qee = qee..v2[2]..','
					end
					for i,v2 in pairs(us) do
						v2[1]:send('ON='..qee..'\n')
					end
					qee = qee:sub(0,qee:len()-1)..'.'
					x:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Online: '..qee..'\n')
					os.sleep(0.5)
					print(name..' entrou.')
				end
			else
				q:close()
			end
		end
		for i,v in pairs(us) do
			v[1]:settimeout(0.01)
			local t,s = v[1]:receive()
			if t then print(t) end
			if s == 'closed' then
				print(v[2]..' closed.')
				us[i] = nil
				local qee = ''
				for i,v2 in pairs(us) do
					v2[1]:send('SEN=['..v[2]..'] Saiu.\n')
					qee = qee..v2[2]..','
				end
				for i,v2 in pairs(us) do
					v2[1]:send('ON='..qee..'\n')
				end
			elseif t then
				if t:match('CIP=(.+)') then
					local cli = t:match('CIP=(.+)')
					if v.mestre then
						clip = cli
						lastaa = os.date('[%H:%M:%S]')..' Salvo por '..v[2]..'.'
						write_(clip)
						for i,v2 in pairs(us) do
							v2[1]:send('BY='..lastaa..' CLIPED='..clip..'\n')
						end
					else
						v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você nao é mestre([M])!\n')
					end
				elseif t == 'SEE' then
					local f = io.open('clip.txt','r')
					if f then
						clip = f:read(-1)
						f:close()
						v[1]:send('BY=Atualizadoq. CLIPED='..clip..'\n')
					end
				elseif t:match('USER=(%d+) LVL=(.+)') then
					local u,cee = t:match('USER=(%d+) LVL=(.+)')
					if tonumber(u) and data.users[tonumber(u)] then
						if v.mestre then
							if cee == '+' then
								data.users[tonumber(u)].LVL = data.users[tonumber(u)].LVL+1
							else
								data.users[tonumber(u)].LVL = data.users[tonumber(u)].LVL-1
							end
							for i,v2 in pairs(us) do
								v2[1]:send('US='..u..' LVL='..data.users[tonumber(u)].LVL..'\n')
							end
						else
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você nao é mestre([M])!\n')
						end
					end
				elseif t == 'CALL' then
					if v.mestre then
						for i,v2 in pairs(us) do
							v2[1]:send('ALERT\n')
							v2[1]:send('SEN=RESPONDE AI PHA!\n')
						end
					end
				elseif t:match('USER=(%d+) CLIPANDO=(.+)') then
					local u,cee = t:match('USER=(%d+) CLIPANDO=(.+)')
					if tonumber(u) and data.users[tonumber(u)] then
						if v.mestre then
						local nm = data.users[tonumber(u)].NAME
						data.users[tonumber(u)].MSG = cee
						local f = io.open('users/'..nm..'_clip.txt','w')
						if f then
							f:write(cee)
							f:close()
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Salvo.\n')
						else
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Nao foi possivel salvar.\n')
						end
						local f = io.open('users/'..nm..'.lua','w')
						if f then
							f:write(string.format('user_ = {NAME=\'%s\',HP=%d,MANA=%d,EXP=0,PERCENT=%d,LVL=%d,MSG=[[]]}',data.users[tonumber(u)].NAME,
							data.users[tonumber(u)].HP,data.users[tonumber(u)].MANA,data.users[tonumber(u)].PERCENT,data.users[tonumber(u)].LVL))
							f:close()
						end
						else
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você nao é mestre([M])!\n')
						end
					end
				elseif t:match('USER=(%d+) HP=(.+)') then
					local u,cee = t:match('USER=(%d+) HP=(.+)')
					if tonumber(u) and data.users[tonumber(u)] then
						if v.mestre then
							if cee == '+' then
								data.users[tonumber(u)].HP = data.users[tonumber(u)].HP+1
							else
								data.users[tonumber(u)].HP = data.users[tonumber(u)].HP-1
							end
							for i,v2 in pairs(us) do
								v2[1]:send('US='..u..' HP='..data.users[tonumber(u)].HP..'\n')
							end
						else
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você nao é mestre([M])!\n')
						end
					end
				elseif t:match('USER=(%d+) LOAD=(.+)') then
					local u,nm = t:match('USER=(%d+) LOAD=(.+)')
					print('o0')
					if tonumber(u) then
						if v.mestre then
							local file = io.open('users/'..nm..'.lua','r')
							if file then
								file:close()
								dofile('users/'..nm..'.lua')
								data.users[tonumber(u)] = user_
								local file = io.open('users/'..nm..'_clip.txt','r')
								local cip = 'n/a'
								if file then
									cip = file:read(-1) or ''
									file:close()
								end
								v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Carregado '..nm..'.\n')
								data.users[tonumber(u)].MSG = cip or ''
								for a,v2 in pairs(us) do
									for i,b in pairs(data.users) do
										v2[1]:send(string.format('USER=%d NAME=%s HP=%d MANA=%d EXP=%d PERCENT=%d LVL=%d\n',i,data.users[i].NAME,data.users[i].HP,data.users[i].MANA,data.users[i].EXP,data.users[i].PERCENT,data.users[i].LVL))
										v2[1]:send(string.format('USER=%d CIP=%s\n',i,data.users[i].MSG))
									end
								end
							else
								local file = io.open('users/'..nm..'.lua','w')
								if file then
									file:write('user_ = {NAME=\''..nm..'\',HP=10,MANA=10,EXP=1,PERCENT=0,LVL=1,MSG=[[n/a]]}')
									file:close()
									io.open('users/'..nm..'_clip.txt','w'):close()
									dofile('users/'..nm..'.lua')
									data.users[tonumber(u)] = user_
									data.users[tonumber(u)].MSG = ''
									v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Criado '..nm..'.\n')
									for a,v2 in pairs(us) do
										for i,b in pairs(data.users) do
											v2[1]:send(string.format('USER=%d NAME=%s HP=%d MANA=%d EXP=%d PERCENT=%d LVL=%d\n',i,data.users[i].NAME,data.users[i].HP,data.users[i].MANA,data.users[i].EXP,data.users[i].PERCENT,data.users[i].LVL))
											v2[1]:send(string.format('USER=%d CIP=%s\n',i,data.users[i].MSG))
										end
									end
								else
									v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Nao foi possivel criar '..nm..'.\n')
								end
							end
						else
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você nao é mestre([M])!\n')
						end
					end
				elseif t:match('USER=(%d+) MP=(.+)') then
					local u,cee = t:match('USER=(%d+) MP=(.+)')
					if tonumber(u) and data.users[tonumber(u)] then
						if v.mestre then
							if cee == '+' then
								data.users[tonumber(u)].MANA = data.users[tonumber(u)].MANA+1
							else
								data.users[tonumber(u)].MANA = data.users[tonumber(u)].MANA-1
							end
							for i,v2 in pairs(us) do
								v2[1]:send('US='..u..' MANA='..data.users[tonumber(u)].MANA..'\n')
							end
						else
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você nao é mestre([M])!\n')
						end
					end
				elseif t:match('EXPTO=(%d+) M=(%d+) T=(.+)') then
					local u,cee,ti = t:match('EXPTO=(%d+) M=(%d+) T=(.+)')
					if tonumber(u) and data.users[tonumber(u)] and tonumber(cee) then
						if v.mestre then
							if ti == '1' then
								data.users[tonumber(u)].PERCENT = data.users[tonumber(u)].PERCENT+tonumber(cee)
							else
								data.users[tonumber(u)].PERCENT = data.users[tonumber(u)].PERCENT-tonumber(cee)
							end
							for i,v2 in pairs(us) do
								v2[1]:send('US='..u..' XP='..data.users[tonumber(u)].PERCENT..'\n')
							end
						else
							v[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você nao é mestre([M])!\n')
						end
					end
				elseif t:match('KILL=(.+)') then
					local name = t:match('KILL=(.+)')
					if v.mestre then
						for a,v2 in pairs(us) do
							if name:lower() == v2.name:lower() then
								v2[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> Você foi kickado!\n')
								for i,v3 in pairs(us) do
									if i ~= a then
										v3[1]:send('SEN='..os.date('[%H:%M:%S]')..' <Server> '..name..' foi kickado!\n')
									end
								end
								v2[1]:close()
							end
						end
					end
				elseif t:match('N=(%d+) M=(%d+)') then
					local num,mx = t:match('N=(%d+) M=(%d+)')
					print(v[2]..' roled '..num..'')
					for i,v2 in pairs(us) do
						v2[1]:send('SEN='..os.date('[%H:%M:%S]')..' [DADO] '..v[2]..' Tirou '..num..' no dado de '..mx..'\n')
					end
				elseif t:match('MSG=(.+)') then
					local ms = t:match('MSG=(.+)')
					for i,v2 in pairs(us) do
						v2[1]:send('MS='..os.date('[%H:%M:%S]')..' <'..v[2]..'> '..ms..'\n')
					end
				end
			end
		end
	end

if showWindow then
	showWindow()
end

--Requires
local req_ = {'imlua','socket','iuplua','iupluacontrols','socket.http','gd','cdlua','iupluacd','bit','lib','iupluaole','luacom','cdluaim'}
for _,a in pairs(req_) do
	require(a)
end

--os.exit()
connect = false
rmcnt = nil
frm = nil
frm3 = nil
frm2 = nil
site = nil
ne = 0
--dice = loadPhoto('lock.png',true)
SERV = ''
PORT = 0
NAM = ''
G_PASS = nil
G_MPASS = nil
G_CODE =nil
--get Server:
function createADownload()
	local gauge = iup.gauge{value=0.3}
	gauge.show_text = "YES"
	local dlg = iup.dialog{gauge; title = "Loading"}
	dlg:showxy(iup.CENTER, iup.CENTER)
	return gauge,dlg
end
function callConect(skipa)
	frm = nil
	frm2 = nil
	frm3 = nil
	rmcnt = nil
	ne = 0
	site = nil
	G_PASS = nil
	G_MPASS = nil
	G_CODE =nil
	repeat
		local pross = false
		if not skipa then
			connect = nil
			SERV = ''
			PORT = 0
			NAM = ''
			local ff = getFileCon()
			local ret, serv,port,name = iup.GetParam("Title",nil,"Server: %s\nPort: %i\nNick: %s\n",'69.162.100.200',7175,ff:match('(.+)'))
			if ret == 0 or not serv then os.exit() end
			if name ~= ff:match('(.+)') and name ~= '' then
				ff = ff:gsub(ff:match('(.+)'),name,1)
				setFileEd('dat.c9k',ff)
			end
			if serv:len() <= 3 or not tonumber(port) or port > 0xff*0xff or name:len() < 3 or name:len()>20 then
				pross = false
				iup.Message ("Warning", "Invalid IP aderess or port or name")
			else
				SERV = serv
				PORT = port
				local c_,err = socket.connect(SERV,PORT)
				if not c_ then
					pross = false
					iup.Message ("Cloud not connect", "Error: "..err)
				else
					connect = c_
					pross = true
					NAM = name
					c_:send('!@'..name..'\n')
				end
			end

		else
			connect:close()
			connect = nil
			local c_,err = socket.connect(SERV,PORT)
			if not c_ then
				pross = false
				iup.Message ("Cloud not connect", "Error: "..err)
				return false
			else
				connect = c_
				pross = true
				c_:send('!@'..NAM..'\n')
			end
		end
	until pross
	local err = getFirstByte()
	if err == true then
		return true
	else
		if err == false then
			iup.Message ("Error", "Connection refused.")
		end
		return false
	end
end
function getFileCon(n)
	local f = io.open(n or 'dat.c9k','rb')
	local c = f:read(-1)
	f:close()
	return c
end
function setFileEd(n,v)
	local f = io.open(n or 'dat.c9k','wb')
	local c = f:write(v)
	f:close()
end
function fileEdit(n,s,e,con)
	local c = getFileCon(n)
	print(c:len())
	c = c:sub(1,s-1)..con..c:sub(e+1,-1)
	local fa = io.open(n,'wb')
	fa:write(c)
	fa:close()
	collectgarbage()
end

function getFirstByte()
	connect:settimeout(10)
	local dat,err = connect:receive()
	if not dat then
		connect:close()
		connect = false
		return false
	end
	if dat:match('w(.+)') and dat then
		iup.Message('Warning!',dat:match('w(.+)'):gsub('#','\n'))
		connect:close()
		connect = false
		return
	end
	if dat:match('!!(.-)€(.+)') then
		local fa_k
		fa_k,site = dat:match('!!(.+)€(.+)')
		local k = fa_k:getBytes(nil,3)
		local in_ = int(k[1],k[2],k[3])
		local fa = getFileCon()
		local k = fa:getBytes(2,3)
		local in_2 = int(k[1],k[2],k[3])
		print('new',in_,'old',in_2)
		if in_ ~= in_2 then
			print('loading')
			local ima = socket.http.request(site..'index.png')
			if not ima then
				connect:close()
				connect = false
				iup.Message ("Error", "Cannot load main image!")
				return
			end
			local f = io.open('index.png','wb')
			f:write(ima)
			f:close(); ima = nil
			fileEdit('dat.c9k',2,4,fa_k)
			collectgarbage()
		end
		local dat,err = connect:receive()
		if dat:match('%%(%d+)') then
			local k = dat:match('%%(%d+)')
			rmcnt = tonumber(k)
			connect:settimeout(0)
			collectgarbage()
			return true
		end
	end
	connect:close()
	connect = false
	return false
end
local function callNew()
	local gauge = iup.gauge{value=0}
	gauge.show_text = "YES"
	local dlg = iup.dialog{gauge; title = "Loading"}
	dlg:showxy(iup.CENTER, iup.CENTER)
	gauge.value = 0.05
	ne = 0
	tabz = {size="200x200"}
	local s
	local tabs
	function createTab(m,m2,idare,c)
		local v
		local kontrol = iup.olecontrol{"Shell.Explorer.2"}
		kontrol:CreateLuaCOM()

		v = iup.vbox{
			iup.hbox{
				iup.label{title='('..idare..') Data from: '},iup.label{title=m,FONT='HELVETICA_BOLD_8'},
			},
			iup.frame{
				title='Info',
				iup.vbox{
					kontrol,
					iup.button{title='Edit',action=function()
						connect:send('M?\n')
						connect:settimeout(10)
						local a = connect:receive()
						connect:settimeout(0.01)
						if a == '1' then
							local emile = iup.multiline{value=tabs[idare].vaca,size='300x200'}
							local labl = iup.label{title='Size: '..emile.value:len()..'/2000',FGCOLOR='0 0 0'};
							local dia
							emile.action=function()
								labl.title = 'Size: '..emile.value:len()..'/2000'
								if emile.value:len() >= 2000 then
									FGCOLOR='255 0 0'
								else
									FGCOLOR='0 0 0'
								end
							end
							local tet = iup.text{value=m,size='100x'}
							dia = iup.dialog{
							title='Editing '..m,
								iup.frame{
									iup.vbox{
										iup.hbox{iup.label{title='Name:'},tet},
										emile,
										iup.button{title='Save',action=function()
											local f = emile.value
											if f:len() >= 2000 then
												iup.Message('Error','Maxium size is 2000. You are using '..f:len()..'.')
												return
											end
											if f:len() == 0 then
												connect:send('CLEAR'..tabs[idare].vaco..'\n')
											else
												connect:send('dd'..f:len()..'|'..tabs[idare].vaco..'*'..tet.value..'\n')
											end
											connect:settimeout(10)
											local c = connect:receive()
											connect:settimeout(0.01)
											if c == '1' then
												local gag,dga = createADownload()
												if gag then
													local now_size = 0
													while true do
														connect:send(f:sub(now_size,-1))
														connect:settimeout(10)
														local a,er = connect:receive()
														if a == 'K' then
															local c = connect:receive()
															print('UU',c)
															connect:settimeout(0.01)
															break
														elseif a and a:match('F:(%d+)') then
															now_size = tonumber(a:match('F:(%d+)'))
															gag.value = (now_size/f:len())
														end
													end
													dga:destroy()
												end
												connect:settimeout(0.01)
												tabs[idare].vaca = dat
											else
												iup.Message('Error',c:sub(2,c:len()))
											end
											dia:destroy()
										end},
										labl,
									}
								}
							}
							dia:showxy(iup.CENTER, iup.CENTER)
							if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
								iup.MainLoop()
							end
						end
					end},
				}
			}
		}

		v.tabtitle=idare..'º           '
		kontrol.com:Navigate("about:"..m2)
		v.vaca = m2
		v.vaco = m
		return v
	end
	local returned = 0
	local control = iup.olecontrol{"Shell.Explorer.2"}
	control:CreateLuaCOM()
	control.designmode= "NO"
	connect:settimeout(10)
	local nmbr = iup.text{value='1',font="HELVETICA_BOLD_8",size='35x'}
	local nmbr_dice = iup.text{value='1',font="HELVETICA_BOLD_8",size='35x'}
	local labela = iup.hbox{iup.label{title='Max value: '},iup.label{title='  1',font="HELVETICA_BOLD_8"}}
	local val_v = iup.val{"VERTICAL"; min=1, max=150,	value="1",mousemove_cb=function(s,va)
		labela[2].title = math.floor(va)
		iup.Refresh(labela[2])
		nmbr.value = math.floor(va)
	end}

	nmbr.MASK = "/d+"
	nmbr_dice.MASK = "/d+"
	nmbr.MASKINT='1:150'
	nmbr_dice.MASKINT='1:10'
	nmbr_dice.action=function(s,v,k)
		if not tonumber(k) then
			s.value = 0
		--	iup.Refresh(s)
			return true
		end
		local n = math.floor(tonumber(k))
		print(k)
		if n > 10 then s.value = 10  end
		--iup.Refresh(s)
	end
	nmbr.action=function(s,v,k)
		local n = math.floor(tonumber(k))
		if n > 150 then s.value = 150 n = 150 end
		labela[2].title = n
		val_v.value = n
		--s.value = n
		iup.Refresh(labela[2])
		iup.Refresh(val_v)
		--iup.Refresh(s)
	end
	local dat,err = connect:receive()
	if err == 'timeout' then
			return 2,'Download timeout!'
	end
	if err == 'closed' then
		return 2,'Conection closed'
	end
	gauge.value = 0.70
	local s_ = socket.http.request(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&select=1&tab=1&t="..os.time())
	gauge.value = 0.90
	local tab
	s,tab = s_:match('(.-)¬(.+)')
	if not s or not tab then
		s = s_
		tab = ''
		s_ = nil
	end
	collectgarbage()
	local l = 0
	for dat,nam in tab:gmatch('(.-)§(.-)€') do
		l = l+1
		tabz[l] = createTab(nam,dat,l)
	end
	for l=l+1,10 do
		tabz[l] = createTab('-','',l)
	end
	tabs = iup.tabs({unpack(tabz)})
	gauge.value = 0.40
	local function updateTabs()
		local tab = socket.http.request(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&tab=1")
		local l = 0
		local tabz = {}
		for dat,nam in tab:gmatch('(.-)§(.-)€') do
			l = l+1
			--tabs[l] = createTab(nam,dat,l,tabs)
			tabs[l].vaca = dat
			tabs[l][1][1].title= '('..l..') Data from: '
			tabs[l][1][2].title=nam
			--tabs[l].tabtitle=nam
			tabs[l][2][1][1].com:Navigate("about:"..tabs[l].vaca)
			tabs[l].vaco = nam
			tabs[l].tabtitle = nam
			tabs[l][2][1][2].action=function()
				connect:send('M?\n')
				connect:settimeout(10)
				local a = connect:receive()
				connect:settimeout(0.01)
				if a == '1' then
					local emile = iup.multiline{value=dat,size='300x200'}
					local dia
					local tet = iup.text{value=nam,size='100x'}
					dia = iup.dialog{
						title='Editing '..nam,
						iup.frame{
							iup.vbox{
								iup.hbox{iup.label{title='Name:'},tet},
								emile,
								iup.button{title='Save',action=function()
									local f = emile.value
									if f:len() == 0 then
										connect:send('CLEAR'..nam..'\n')
									else
										connect:send('dd'..f:len()..'|'..nam..'*'..tet.value..'\n')
									end
									connect:settimeout(10)
									local c = connect:receive()
									connect:settimeout(0.01)
									if c == '1' then
										local gag,dga = createADownload()
										local now_size = 0
										while true do
											connect:send(f:sub(now_size,-1))
											connect:settimeout(10)
											local a,er = connect:receive()
											if a == 'K' then
												local c = connect:receive()
												print('UU',c)
												connect:settimeout(0.01)
												break
											elseif a and a:match('F:(%d+)') then
												now_size = tonumber(a:match('F:(%d+)'))
												gag.value = (now_size/f:len())
											end
										end
										dga:destroy()
										connect:settimeout(0.01)
										--tabs[l].vaca = dat
									else
										iup.Message('Error',c:sub(2,c:len()))
									end
									dia:destroy()
								end}
							}
						}
					}
					dia:showxy(iup.CENTER, iup.CENTER)
				end
			end
			--tabs[l][2][1][2].action = function() os.exit() end

		end
		for l=l+1,10 do
			tabs[l] = createTab('-','',l,tabs)
		end
		--tabs =
		--dialog[1][2][3][1][1] = iup.tabs(tabz)
		iup.Refresh(tabs)
	end

	connect:settimeout(0)
	timer1 = iup.timer{time=100}
	---Timer
	local URRRL = iup.label{title='URL: '}
	local ml = iup.multiline{APPENDNEWLINE='YES',size='200x150',value='',READONLY="YES",CANFOCUS='NO',border="YES",bgcolor="255 255 255",FGCOLOR='0 0 0'}
	local lst2 = iup.list{bgcolor="239 231 204", value = 40, size = "80x150"}
	local txt = iup.text{size="200x"}
	function timer1:action_cb()
		local dat,err = connect:receive()
		if err == 'closed' then  timer1.run = "NO" returned=1 connect = nil dialog:destroy() end
		if dat then
			print(9,os.clock(),dat)
			if dat:sub(1,1) == '¨' then
				dat = dat:sub(2,-1)
				for i=1,ne do
					lst2[i] =  nil
				end
				ne = 0
				for i in dat:gmatch('(.-)¬') do
					ne = ne+1
					lst2[ne] = i
				end
			elseif dat:match('%+(.+)') then
				local c = ml.value
				ml.value = ''
				ml.insert=c..dat:match('%+(.+)'):gsub('#','\n')..'\n'
			elseif dat:sub(1,1) == 'w' then
				iup.Message('Warning!',dat:sub(2,dat:len()):gsub('#','\n'))
			elseif dat:match('%#@(.-)*(.+)') then --Update name
			elseif dat:match('Y') then
				updateTabs()
			elseif dat == 'S' then
				print(7,os.clock())
				--if not WAITE then
					WAITE = nil
					s = socket.http.request(site.."index.php","code="..G_CODE.."&pass="..G_PASS.."&select=1")
					URRRL.title = 'URL: -'
					if s:sub(1,1) == '§' then
						local page = s:sub(2,-1)
						local ba = iup.Alarm("Alert", "This room want open the page:\n"..page.."\ndo you want proceed?" ,"Yes" ,"No")
						if ba == 1 then
							control.com:Navigate(page)
							dialog[1][1][1].title = 'URL: '..page
							iup.Refresh(dialog)
						else
							timer1.run = "NO"
							dialog:destroy()
							returned = 2
							return
						end
					else
						control.com:Navigate(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&select=1&t="..os.time())
					end
				--end
			end
		end
	end
	dialog = iup.dialog
	{
	  title='Playing in room '..G_CODE,
	   iup.hbox{

		iup.vbox{
			iup.frame{
					title= '',
					size="350x380",
					EXPAND='NO',
					control,

				},
				iup.frame{
					title='Menu',
					iup.hbox{
						iup.button{title='Edit',size='125x',action=function()
							connect:send('M?\n')
							connect:settimeout(10)
							local a = connect:receive()
							connect:settimeout(0.01)
							if a == '1' then
								local dialoga
								local control_ = iup.olecontrol{"Shell.Explorer.2"}
								control_:CreateLuaCOM()

								local s = socket.http.request(site.."index.php","code="..G_CODE.."&pass="..G_PASS.."&select=1")
								if s:sub(1,1) == '§' then
									s = ' '
								end
								s = s:gsub('€','\n')
								control_.com:Navigate(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&select=1&t="..os.time())
								local ml2 = iup.multiline{size='280x280',value=s}
								local suba = iup.label{title='Size: '..ml2.value:len()..'/5120',font='HELVETICA_BOLD_8'}
								function ml2:action()
									suba.title = 'Size: '..ml2.value:len()..'/5120'
									if ml2.value:len() < 5120 then
										suba.FGCOLOR = '0 0 0'

									else
										suba.FGCOLOR = '255 0 0'
									end
									iup.Refresh(suba)
								end
								dialoga = iup.dialog
								{
									title='Edit '..G_CODE..' main.',
									iup.frame{
										title='Chat',
										iup.vbox{
											iup.hbox{control_,iup.vbox{ml2,suba},iup.button{title='Quit',action=function() dialoga:destroy() end},},
												iup.frame{
													title='Control',
													iup.hbox{
														iup.button{title='Show',size='30x50',action=function()

														end},
														iup.button{title='Save',size='30x50',action=function()
															local f = ml2.value
															connect:send('dd'..f:len()..'|1\n')
															connect:settimeout(10)
															local c = connect:receive()
															connect:settimeout(0.01)
															if c == '1' then
																local gag,dga = createADownload()
																local now_size = 0
																while true do
																	connect:send(f:sub(now_size,-1))
																	connect:settimeout(10)
																	local a,er = connect:receive()
																	if a == 'K' then
																		local c = connect:receive()
																		print('UU',c)
																		connect:settimeout(0.01)
																		break
																	elseif a and a:match('F:(%d+)') then
																		now_size = tonumber(a:match('F:(%d+)'))
																		gag.value = (now_size/f:len())
																	end
																end
																dga:destroy()
																connect:settimeout(0.01)
																control_.com:Navigate(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&select=1&t="..os.time())
															else
																if c then
																	iup.Message('Error',c:match('0(.+)') or '?')
																end
															end

														end},
														iup.button{title='Refresh',size='30x50',action=function()
															s = socket.http.request(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&select=1&t="..os.time())
															ml2.value = s
															control_.com:Navigate(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&select=1&t="..os.time())
														end},
													}
												},


										}
									},

								}
								dialoga:showxy(iup.CENTER, iup.CENTER)
								if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
								  iup.MainLoop()
								end
							elseif a == '0' then
								iup.Message('Error','You are not the Master of the room.')
							else
								iup.Message('Error','Cannot login in to DB.')
							end
						end},
						iup.button{title='Set as URL',size='125x',action=function()
							connect:send('M?\n')
							connect:settimeout(10)
							local a = connect:receive()
							connect:settimeout(0.01)
							if a == '1' then
								local ret, url = iup.GetParam("Enter URL",nil,"URL: %s\n",'')
								if ret == true then
									local f = ('§'..url):gsub('\n','')
									connect:send('dd'..f:len()..'|1\n')
									connect:settimeout(10)
									local c = connect:receive()
									connect:settimeout(0.01)
									if c == '1' then
										local now_size = 0
										while true do
											connect:send(f:sub(now_size,-1))
											connect:settimeout(10)
											local a,er = connect:receive()
											if a == 'K' then
												local c = connect:receive()
												print('UU',c)
												connect:settimeout(0.01)
												break
											elseif a and a:match('F:(%d+)') then
												now_size = tonumber(a:match('F:(%d+)'))
											end
										end
										connect:settimeout(0.01)
									else
										iup.Message('Error',c:sub(2,c:len()) or 'timeout')
									end
								end
							else
								iup.Message('Error','You are not the master')
							end
						end},
					},
				},
			},

			iup.vbox{
				iup.hbox{
					iup.frame{
						title='Chat',
						iup.hbox{ml,lst2}
					},
				},
				iup.hbox{
					iup.frame{
						iup.hbox{
							txt,
							iup.button{
								title='Send',
								size='80x',
								action=function()
									if txt.value:len() > 0 then
										connect:send('+'..txt.value..'\n')
										txt.value = ''
									end
								end}
							}
						}
					},

					iup.frame{
						title='Players info',
						iup.vbox{tabs},

						},
				},
				iup.frame{title='Dice',
					iup.vbox{
						iup.hbox{
							val_v,
							iup.vbox{
								iup.hbox{iup.label{title='Dice max val:'},nmbr},
								iup.hbox{iup.label{title='Dices to spin:'},nmbr_dice},
								iup.button{title="Spin dice",image=loadPhoto("rpg.GIF"),action=function()
									connect:send('R'..math.floor(tonumber(val_v.value))..'|'..math.floor(tonumber(nmbr_dice.value))..'\n')
								end}
								}
							}
						,labela}
					}
			},
		iup.frame{
				title='Load',
				iup.button{
					title='New',
					action=function()
						returned = 2
						timer1.run = "NO"
						dialog:destroy()
					end}
				}
	  }
	function dialog:k_any(c)
		if c == 13 then
			if txt.value:len() > 0 then
				connect:send('+'..txt.value..'\n')
				txt.value = ''
			end
		end
	end
	gauge.value = 0.95
	timer1.run = "YES"
	dialog[1][1][1].title = 'URL: '
	if s:sub(1,1) == '§' then
		local page = s:sub(2,-1)
		local ba = iup.Alarm("Alert", "This room want open the page:\n"..page.."\ndo you want proceed?" ,"Yes" ,"No")
		if ba == 1 then
			control.com:Navigate(page)
			dialog[1][1][1].title = 'URL: '..page
			iup.Refresh(dialog)
		else
			timer1.run = "NO"
			dialog:destroy()
			return 2
		end
	else
		--[[local f = s
		local sa = 500
			for i=0,math.floor(f:len()/sa)+1 do
				local c = f:sub((i*sa)+1,(i+1)*sa)
				if c:len() >= 1 then
					if i == 0 then
						control.com:Navigate("about:"..c)
					else
						if not control.com.Document then
							control.com:Navigate("about:"..f)
							break
						else
							control.com.Document:WriteLn(c)
						end
					end
				end
			end]]
		iup.Refresh(dialog)
		WAITE = true
		print(1,os.clock())
		control.com:Navigate(site.."index.php?code="..G_CODE.."&pass="..G_PASS.."&daj=1")
		print(2,os.clock())
		dialog[1][1][1].title = 'URL: -'


	end
	gauge.value = 1
	dlg:destroy()
	dialog:showxy(iup.CENTER, iup.CENTER)
	if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
	  iup.MainLoop()
	end
	return returned
end
local function show_room()
	G_PASS = nil
	G_MPASS = nil
	G_CODE =nil
	SHOW = false
	ne = 0
	local dialog
	local control = iup.olecontrol{"Shell.Explorer.2"}
	control:CreateLuaCOM()
	control.designmode= "NO"
	local returned = false
	local timer1 = iup.timer{time=100}
	local image = im.FileImageLoad("index.png")
	local campanha = iup.text{value="UC38NSAYLAK",size='120x'}
	local cv  = iup.canvas {size="194x45"}
	cv.image = image
	local ml = iup.multiline{size='280x200',expand="YES",value="",INSERT="",border="YES",size='x40',bgcolor="255 255 255",READONLY="YES",CANFOCUS='NO',FORMATTING='YES',}
	local lst = iup.list{bgcolor="239 231 204", value = 40, size = "80x200"}
	local txt = iup.text{size="280x"}
	function cv:map_cb()
		self.canvas = cd.CreateCanvas(cd.IUP, self)
	end
	local function join(uu,p,m)
		local ret, pass,mpass
		if not p then
			if not uu then
				ret,uu, pass,mpass= iup.GetParam("Join in room",nil,"Room: %s\nPassword: %s\nMaster Password (optional): %s\n",'','','')
			else
				ret, pass,mpass= iup.GetParam("Join in "..uu,nil,"Password: %s\nMaster Password (optional): %s\n",'','')
			end
		else
			pass,mpass =p,m
		end
			if (ret ~= 0 and pass) or p and pass:len() > 0 then
				connect:send('PLX('..uu..')'..pass..','..(mpass == '' and '-' or mpass)..'\n')
				connect:settimeout(10)
				local dat,err = connect:receive()
				if dat == '1' then
					G_PASS = pass
					G_MPASS = (mpass == '' and 'a' or mpass)
					G_CODE =uu
					connect:settimeout(0.01)
					returned=true
					timer1.run = "NO"
					dialog:destroy()
				else
					connect:settimeout(0.01)
					iup.Message('Error',dat or err)
				end
			end
	end
	local menu = iup.menu{
			iup.submenu{
				title = "File",
				iup.menu{
						iup.item{title = "Join",action=function() join() end},
						iup.item{title = "Exit",action=function() os.exit() end},
					},

				},
			iup.submenu{
				title = "Browser",
					iup.menu{
						iup.item{title = "Refresh", key = "K_F",action=function() control.com:Navigate(site..'?s='..os.time()) end}
					},
				}
		}
	function cv:action()
	   self.canvas:Activate()
	   self.canvas:Clear()
	   self.image:cdCanvasPutImageRect(self.canvas, 0, 0, 0, 0, 0, 0, 0, 0)
	end
	local rms = iup.frame{
		size='400x100',
		  iup.vbox
		  {
			createF('[c="0 0 0" f="HELVETICA_BOLD_8"]Rooms[/c] list Total: [c="255 0 0" f="HELVETICA_BOLD_8"]'..rmcnt..'[/c]'),
			iup.vbox{
				iup.frame{title='Load',iup.hbox{campanha,iup.button{title='Join',action=function()
					join(campanha.value)
				end},iup.button{title='New'}}}
				},
		  },
		  iup.fill{},
		}
	dialog = iup.dialog
	{
		menu=menu,
	  --,
	  iup.hbox{
		iup.vbox{
			rms,
			iup.hbox{
				iup.frame{
					title='Chat',
					ml
				},
				iup.frame{
					title='Players online',
					lst
				},
			},
			iup.hbox{iup.frame{txt},iup.frame{iup.button{title='Send',size='80x',action=function()
				if txt.value:len() > 0 then
					connect:send('+'..txt.value..'\n')
					txt.value = ''
				end
			end}}},
		},
		iup.fill{},
		iup.vbox{
			iup.frame{
				size="400x350",
				EXPAND='NO',
				control
				},
			iup.hbox{
			iup.fill{},
			iup.frame{
				size="100x66",
				EXPAND='NO',
				cv}
				}
			}
			};
			title = "Rooms list",
	}

	function timer1:action_cb()
		if not SHOW then
			control.com:Navigate(site)
			SHOW = true
		end
		local dat,err
		if connect then
			dat,err = connect:receive()
		end
		if err == 'closed' then  timer1.run = "NO"  returned=0 connect = nil dialog:destroy() return end
		if dat then
			if dat:sub(1,1) == '¨' then
				dat = dat:sub(2,-1)
				for i=1,ne do
					lst[i] =  nil
				end
				ne = 0
				for i in dat:gmatch('(.-)¬') do
					ne = ne+1
					lst[ne] = i
				end
			elseif dat:sub(1,1) == 'w' then
				iup.Message('Warning!',dat:sub(2,dat:len()):gsub('#','\n'))
			elseif dat:match('%+(.+)') then
				local c = ml.value
				ml.value = ''
				ml.insert=c..dat:match('%+(.+)')..'\n'
			end
		end
	end
	function dialog:k_any(c)
	if c == 13 then
		if txt.value:len() > 0 then
			connect:send('+'..txt.value..'\n')
			txt.value = ''
		end

	end
end
	timer1.run = "YES"

	dialog:showxy(iup.CENTER, iup.CENTER)
	--iup.Refresh(dialog)
	if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
	  iup.MainLoop()
	end
	return returned
end
function imtos()
	local im = assert(gd.createFromPng("index.png"))
	local s = ""
	for x=1,im:sizeX() do
		for y=1,im:sizeY() do
			local col = im:getPixel(x-1, y-1)
			canvas:Pixel(x-1, 100-y,cd.EncodeColor(im:red(col),im:green(col),im:blue(col)))
		end
	end

end
local skipa = false
while true do
	if skipa or not connect then
		if connect == nil then
			iup.Message ("Error!", "Connection lost")
		end
		if callConect(skipa) then
			skipa = false
			local s__ = show_room()
			print(s__)
			if s__ == true then
				local case,err = callNew()
				print(case,err)
				if case == 0 then
					skipa = true
					break
				elseif case == 1 then
					connect = false
				elseif case == 2 then
					if err then
						iup.Message ("Error!", err)
					end
					skipa = true
				end
			elseif s__ == 0 then
			elseif not s__ then
				break
			end
		end
	end
end


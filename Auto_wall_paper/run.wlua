require('iuplua')
require('ex')
require('gd')
math.randomseed(os.time())
local imgs = {}
local nams = {}
local ind  = 0
local mydir = os.currentdir()
local photodir = {}
local dat_c
local F_use = '0'
local DELAY
local TRAY = false
function updatedat()
	local f = assert(io.open('data.dat','wb'))
	f:write(dat_c)
	f:close()
	loadData()
end
function loadData()
	imgs = {}
	nams = {}
	photodir = {}
	ind = 0
	ml.value = ''
	local dat = io.open('data.dat','rb')
	dat_c = dat:read(-1)
	dat:close()
	if dat_c:match('&(.+)¬') then
		for dir in dat_c:match('&(.+)¬'):gmatch('#(.-)~') do
			photodir[#photodir+1] = dir
		end
	end
	F_use = tonumber(dat_c:match('*(%d)§'))
	DELAY = tonumber(dat_c:match('<(%d+)>'))
	STARTED = dat_c:sub(1,1):byte()
	for i,b in pairs(photodir) do
		local b2 = b
		if b2:len() > 40 then
			b2 = b2:sub(1,20)..'[...]'..b2:sub(b2:len()/1.5,b2:len())
		end
		ml.value = ml.value..b2..'\n'
		loadDir(b)
	end
	total.title=ind
	if ind == 0 then
		b_start.ACTIVE = 'YES'
		b_stop.ACTIVE = 'NO'
		STARTED = 2
	end
	iup.Refresh(lineq)
end
function loadDir(dir)
	for i in os.dir(dir) do
		if i.type == 'file' and (i.name:match('.+%.(...)') == 'jpg' or i.name:match('.+%.(...)') == 'bmp') then
			ind = ind+1
		    imgs[ind] = dir..'\\'..tostring(i.name)
			nams[ind] =  tostring(i.name)
		end
	end
end

function check_to_change(f)
	if f:match('.+%.(...)') then
		local format = f:match('.+%.(...)')
		if format == 'bmp' then
			return true,f
		elseif format == 'jpg' then
			jpgtobmp(f)
			return true,mydir..'//temp.bmp'
		end
	else
		return false
	end
end

---Functions
function loadPhoto(name,t)
	local phto = {}
	local ce = {}
	local n = 1
	local gde
	if not t then
		gde= gd.createFromGif(name)
	else
		gde= gd.createFromPng(name)
	end
	assert(gde)
	for x=1,gde:sizeX()+1 do
		for y=1,gde:sizeY()+1 do
			if not phto[(y-1)] then phto[(y-1)] = {} end
			if not phto[(y-1)][(x-1)] then phto[(y-1)][(x-1)] = {} end
			local p = gde:getPixel(x-2, y-2)
			if  (gde:red(p) == 255 and gde:blue(p) ==255 and gde:green(p) == 255) then
				phto[(y-1)][(x-1)] = 1
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
	ce[1] = 'BGCOLOR'
	print(tostring(ce[1]),phto[1][1])
	return iup.image{colors = ce,unpack(phto)}
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

local icon = iup.image{
{24,24,9,9,9,9,9,9,9,9,9,9,26,25,25,25,},
{9,9,11,9,12,9,13,10,13,10,11,12,9,26,25,25,},
{9,11,10,12,11,13,9,12,13,9,12,11,9,27,26,25,},
{9,9,10,9,9,10,10,11,11,9,10,9,9,30,27,26,},
{22,22,9,22,8,8,8,8,8,22,9,22,22,29,30,27,},
{21,21,21,21,8,8,8,8,8,21,21,21,21,21,29,30,},
{20,20,20,20,20,8,8,8,20,20,20,20,20,20,20,29,},
{19,19,19,19,19,8,8,8,19,19,19,19,19,19,19,19,},
{19,19,19,19,19,8,8,8,19,19,19,19,19,19,19,19,},
{18,18,18,18,18,8,8,8,18,18,18,18,18,18,18,18,},
{17,17,17,17,8,8,8,8,8,17,17,17,17,17,17,17,},
{16,16,16,16,8,8,8,8,8,16,16,16,16,16,16,16,},
{15,15,8,8,8,8,8,8,8,8,8,15,15,15,15,15,},
{7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,},
{3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,},
{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,},
colors = {
"BGCOLOR",
"183 233 129",
"183 209 129",
"160 199 79",
"236 122 216",
"236 196 216",
"85 245 70",
"162 109 49",
"57 127 37",
"57 201 37",
"57 193 37",
"57 96 37",
"57 196 37",
"57 196 255",
"57 211 255",
"57 186 255",
"57 178 255",
"57 163 255",
"57 135 255",
"57 130 255",
"57 119 255",
"57 109 255",
"57 94 255",
"57 0 255",
"255 255 255",
"160 255 255",
"0 181 255",
"0 127 255",
"0 94 255",
"0 150 255",
}
}
---Start

ml = iup.multiline{value='',size='250x150',active='NO'}
total = iup.label{title=0}
caenge = iup.label{title='Changing wall paper in 0 seconds.'}
local item_start,item_stop
b_start = iup.button{title='Start',size='100x15',ACTIVE=STARTED==1 and 'NO' or 'YES',action=function()
	if ind == 0 then
		iup.Message('Ops!','No pictures :(')
		return
	end
	STARTED = 1
	dat_c = string.char(1)..dat_c:sub(2,dat_c:len())
	updatedat()
	b_start.ACTIVE = 'NO'
	item_start = 'NO'
	b_stop.ACTIVE = 'YES'
	item_stop = 'YES'
end}
b_stop = iup.button{title='Stop',size='100x15',ACTIVE=STARTED==1 and 'YES' or 'NO',action=function()
	STARTED = 2
	dat_c = string.char(2)..dat_c:sub(2,dat_c:len())
	updatedat()
	b_start.ACTIVE = 'YES'
	item_start = 'YES'
	b_stop.ACTIVE = 'NO'
	item_stop = 'NO'
end}
lineq = iup.hbox{iup.label{title="Loaded "},total,iup.label{title=" photos."}};
curent = iup.label{title='Current file: '}

dg = iup.dialog{
	iup.hbox{
		iup.frame{
			size='x230',
			title="Main",
			iup.vbox{
				iup.label{title="Working directories"},
				ml,
				iup.hbox{iup.button{title='Add dir',size='100x15',action=function()
					local filedlg = iup.filedlg{DIALOGTYPE='DIR'}
					filedlg:popup (iup.ANYWHERE, iup.ANYWHERE)
					if filedlg.status ~= -1 then
						dat_c = dat_c:sub(1,2)..'#'..filedlg.VALUE..'~'..dat_c:sub(3,dat_c:len())
						updatedat()
						iup.Message('Sucess','The dir has been added.')
					end
				end},iup.button{title='Remove dir',size='100x15',action=function()
					local L = '|'
					for i,b in pairs(photodir) do
						local b2 = b
						if b2:len() > 20 then
							b2 = b2:sub(1,10)..'[...]'..b2:sub(b2:len()-5,b2:len())
						end
						L = L..b2..'|'
					end
					local ret,dir = iup.GetParam("Select a dir to remove", param_action,"List: %l"..L.."\n",1)
					if ret ~= 0 then
						dir = dir+1
						if photodir[dir] then
							dat_c = dat_c:gsub('#'..photodir[dir]..'~','')
							updatedat()
							iup.Message('Sucess','The dir has been deleted.')
						else
							iup.Message('OPS','Fail! :(')
						end
					end
				end}
				},
				iup.hbox{iup.button{title='Change delay',size='100x15',action=function()
					local ret,int = iup.GetParam("Enter a new delay", param_action,"Delay (in seconds): %i\n",DELAY)
					if ret ~= 0 then
						dat_c = dat_c:gsub('<(%d+)>','<'..int..'>')
						updatedat()
					end
				end}},
				lineq,
			}
		},
		iup.frame{
			title="Control",
			size='210x230',
			iup.vbox{
				iup.hbox{iup.button{title='HIDE',size='200x15',action=function()
					dg.hidetaskbar = 'yes'
					TRAY = true
					dg.tray = "yes" end}},
				iup.hbox{
					b_start,b_stop
				},
				caenge,
				iup.fill{},
				createF('[c="0 0 0" f="HELVETICA_BOLD_14"]Auto Wallpaper changer[/c][c="200 200 200" f="HELVETICA_BOLD_8"]V 1.0[/c]'),
				iup.hbox{createF('[c="0 0 0" f="HELVETICA_BOLD_8"]By[/c] [c="236 167 94" f="HELVETICA_BOLD_8"]Mock the bear[/c]'),iup.fill{},iup.label{title = "",image =loadPhoto('im1.png',1)}},
				createF('[c="100 100 100" f="HELVETICA_BOLD_8"]Contact:[/c] [c="0 0 255" f="HELVETICA_BOLD_8"]matheus.mtb7@gmail.com[/c]'),
				iup.fill{},
				iup.hbox{
					curent,
				},

			},
		}
	},
	title="Auto wall paper",
	tray = "YES",
	traytip = "Auto wall paper",
	trayimage = icon,
}

dg.close_cb = function() dg.tray = "NO" end
dg.trayclick_cb = function(self, b, press, dclick)
	if b == 1 and press then
		item_start = iup.item {title = "Start",ACTIVE=STARTED==1 and 'NO' or 'YES', action = function()
			if ind == 0 then
				iup.Message('Ops!','No pictures :(')
				return
			end
			STARTED = 1
			dat_c = string.char(1)..dat_c:sub(2,dat_c:len())
			updatedat()
			b_start.ACTIVE = 'NO'
			item_start = 'NO'
			b_stop.ACTIVE = 'YES'
			item_stop = 'YES'
		end}
		item_stop = iup.item {title = "Stop", ACTIVE=STARTED==1 and 'YES' or 'NO', action = function()
			STARTED = 2
			dat_c = string.char(2)..dat_c:sub(2,dat_c:len())
			updatedat()
			b_start.ACTIVE = 'YES'
			item_start = 'YES'
			b_stop.ACTIVE = 'NO'
			item_stop = 'NO'
		end}
		local item_show = iup.item {title = "Show window",ACTIVE=TRAY and 'YES' or 'NO', action = function() TRAY = false dg:show() end}
		local item_hide = iup.item {title = "Hide window",ACTIVE=TRAY and 'NO' or 'YES',action = function() TRAY = true dg.hidetaskbar = 'YES'  dg.tray = "YES" end}
		local item_exit = iup.item {title = "Exit", action = function() dg.tray = "NO" dg:hide() end}
		local menu = iup.menu{item_start,item_stop,{},item_show,item_hide,{}, item_exit}
		menu:popup(iup.MOUSEPOS, iup.MOUSEPOS)
	end
	return iup.DEFAULT
end
loadData()
local timer1 = iup.timer{time=100}
local start
local old
function timer1:action_cb()
	if STARTED == 1 then
		if ind == 0 then
			STARTED = 2
			iup.Message('Ops :(','No pictures')
			b_start.ACTIVE = 'YES'
			b_stop.ACTIVE = 'NO'
			return
		end
		if not start then
			start = os.time()
		end
		if start-os.time() ~= old then
			old = start-os.time()
			caenge.title = 'Changing wall paper in '..old..' seconds.'
			iup.Refresh(caenge)
		end
		if start <= os.time() then
			start = os.time()+DELAY
			local selected = math.random(1,ind)
			local r,f = check_to_change(imgs[selected])
			if r then
				curent.title= 'Current file: '..nams[selected]
				iup.Refresh(curent)
				setWallPaper(f)
			end
		end
	else
		if caenge.title ~= 'Changing wall paper in - seconds.' then
			caenge.title = 'Changing wall paper in - seconds.'
			iup.Refresh(caenge)
			curent.title= 'Current file: '
			iup.Refresh(curent)
		end
	end
	return iup.DEFAULT
end

timer1.run = "YES"



dg:show()

dg.hidetaskbar = F_use == 1 and (ind ~= 0 and "YES" or nil) or nil
if F_use then TRAY = true end
if F_use == 0 then
	dat_c = dat_c:gsub('*0§','*1§')
	updatedat()
end

if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
  iup.MainLoop()
end




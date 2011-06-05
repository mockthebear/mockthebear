require('irrklua')
require('ex') -- lua Ex to os.sleep()
local data = {
	name='getout.ogg',
	loop=true,
	start_paused=false,
}
do
	local music = irrklua.playMusic(data.name,data.loop,data.start_paused)
	print(('Playing %s -> %s'):format(data.name,tostring(music)))
	print('Sound size: '..irrklua.getSoundPlayLen(music))
	print('Sound position: '..irrklua.getSoundPlayPosition(music))
	print('Press enter')
	io.read()
	print('Testing volume.')
	for s=0,30 do
		irrklua.setVolume(music,s/100)
		print('Volume: '..irrklua.getVolume(music))
		os.sleep(0.05)
	end
	print('Sound position: '..irrklua.getSoundPlayPosition(music))
	print('Press enter')
	print('Testing effects\nr - setReverbEnabled\ne - setEchoEnabled\nd - setDistortionEnabled\nx - skip')
	local t = {r={1,irrklua.setReverbEnabled},e={1,irrklua.setEchoEnabled},d={1,irrklua.setDistortionEnabled}}
	while true do

		local d = io.read()
		if t[d] then
			t[d][2](music,t[d][1]==1 and true or false)
			t[d][1] =t[d][1] == 1 and 2 or 1
		elseif d == 'x' then
			break
		end
	end
	irrklua.setReverbEnabled(music,false)
	irrklua.setEchoEnabled(music,false)
	irrklua.setDistortionEnabled(music,false)
	print('Sound position: '..irrklua.getSoundPlayPosition(music))
	print('3D sound test')
	for x=-5,5 do
		print(string.rep('.',x < 0 and x+5 or 5)..(x < 0 and '*' or '')..string.rep('.',5-(x+5))..'[Y'..(x == 0 and '*' or '')..'OU]'..string.rep('.',x)..(x > 0 and '*' or '')..string.rep('.',x > 0 and 5-x or 5))
		irrklua.setSound3DPosition(music,0,0,x)
		os.sleep(0.5)
	end
	--- music,z , y, x
	irrklua.setSound3DPosition(music,0,0,0)
	print('Sound position: '..irrklua.getSoundPlayPosition(music))
	print('Press enter')
	io.read()
	irrklua.setPaused(music,true)
	print('Set sound paused.',irrklua.isPaused(music))
	print('Sound position: '..irrklua.getSoundPlayPosition(music))
	print('Press enter')
	io.read()
	irrklua.setPaused(music,false)
	print('Set sound resume.',irrklua.isPaused(music))
	print('Sound position: '..irrklua.getSoundPlayPosition(music))
	print('Press enter')
	io.read()
	print('Set to start position.')
	irrklua.setSndPlayPos(music,0)
	print('Press enter to close.')
	io.read()




end

--[[
		~ * ~ Player Class v 1.0 ~ * ~
					By Mock the Bear
MTB

	*Global info:
		-With this lib you create a player object
		-with this object you can change almost all
		-player status like health mana pos etc...
	*Use:
		-First you have to create the class
		- 	local user = Player:new(cid)
		-And then you can use like:
		- 	print(user.health)
		-I the player got 1k of health it will
		-print 1000, and if the player lose like
		-150 health in combat and you print aigan
		-it shows 850.
		-Also you can change the health like:
		-	user.health = 100
		-Or:
		- 	user.addhealth(100)
		-	-- The same
		-   user:addhealth(100)
		-Like:
		- 	user:domove(0)
		-The syntax is:
		-	[OBJ]:[METHOD][VALUE](PARAMS)
		-	user:addhealth(10)
		-	user:domove(0)
		-	user:gethealth()
		-The method get do not need use like as function
		-you can use only user.health because method get is defaut.
		-The avaliable methods is DO ADD and GET
		-The set method is only to events like
		-	user.health = 100
		-If you need change the pos (using teleport in set method)
		-and need one more param use like:
		-	user:setPack(false)
		-	user.position = {x=300,y=200,z=5}
		-To understand better lets think in another function
		-Like setPlayerStorageValue
		-   user:setPack(100)
		- 	user.storage = 4911
		-This code will set the storage value 4911 to value 100
		-And then if you need you can just use like:
		-	user:doMoveCreature(0)
		- 	user:setPlayerStorageValue(4911,100)
		-You can use in ALL functions (works in your self made funcs),
		-the code set the ard #1 to cid and call the function.

	Contact: matheus.mtb7@gmail.com


]]
Player = {debug=false,n=0,cid={},defaut='get'}
---Compat some funcions~
function doCreatureSetHealth(cid,h,...)
	local now = getCreatureHealth(cid)
	doCreatureAddHealth(cid,h-now)
end
function doCreatureSetMana(cid,h)
	local now = doCreatureSetMana(cid)
	doPlayerAddMana(cid,h-now)
end
---Get,do,add can be used as print(player.health), player.domove(1) or player.addhealth(100))
Player.get = { --
	--Health
	['health'] 			= getCreatureHealth,
	['maxhealth']		= getCreatureMaxHealth,
	--Mana
	['mana'] 			= getCreatureMana,
	['maxmana'] 		= getCreatureMaxMana,
	['requiredmana']	= getPlayerRequiredMana,
	['spentmana'] 		= getPlayerSpentMana,
	--ETC
	['position']		= getCreaturePosition,
	['rates'] 			= getPlayerRates,
	['stamina'] 		= getPlayerStamina,
	['storage'] 		= getPlayerStorageValue,
	['town'] 			= getPlayerTown,
	['vocation'] 		= getPlayerVocation,
	['voc'] 			= getPlayerVocation,
	['weapon'] 			= getPlayerWeapon,
	['target'] 			= getCreatureTarget,
	['summons'] 		= getCreatureSummons,
	['speed'] 			= getCreatureSpeed,
	['skull'] 			= getCreatureSkull,
	['outfit'] 			= getCreatureOutfit,
	['nomove'] 			= getCreatureNoMove,
	['name'] 			= getCreatureName,
	['lookdir'] 		= getCreatureLookDirection,
	['lastpos'] 		= getCreatureLastPosition,
	['condition'] 		= getCreatureCondition,
	['basespeed'] 		= getCreatureBaseSpeed,
	['access'] 			= getPlayerAccess,
	['account'] 		= getPlayerAccount,
	['accountid'] 		= getPlayerAccountId,
	['blessing'] 		= getPlayerBlessing,
	['depotitems'] 		= getPlayerDepotItems,
	['exp'] 			= getPlayerExperience,
	['flag'] 			= getPlayerFlagValue,
	['food'] 			= getPlayerFood,
	['freecap'] 		= getPlayerFreeCap,
	['guid'] 			= getPlayerGUID,
	['groupid'] 		= getPlayerGroupId,
	['guildid'] 		= getPlayerGuildId,
	['guildlvl'] 		= getPlayerGuildLevel,
	['guildname'] 		= getPlayerGuildName,
	['guildnick'] 		= getPlayerGuildNick,
	['guildrank'] 		= getPlayerGuildRank,
	['guildrankid'] 	= getPlayerGuildRankId,
	['idle'] 			= getPlayerIdleTime,
	['ip'] 				= getPlayerIp,
	['instantcount'] 	= getPlayerInstantSpellCount,
	['itembyid'] 		= getPlayerItemById,
	['itemcount'] 		= getPlayerItemCount,
	['lastload'] 		= getPlayerLastLoad,
	['lastlogin'] 		= getPlayerLastLogin,
	['lastsave'] 		= getPlayerLastLoginSaved,
	['masterpos'] 		= getPlayerMasterPos,
	['skill'] 			= getPlayerSkill,
	['skilllevel'] 		= getPlayerSkillLevel,
	['skilltries']		= getPlayerSkillTries,
	['skullend'] 		= getPlayerSkullEnd,
	['skulltype'] 		= getPlayerSkullType,
	['slotitem'] 		= getPlayerSlotItem,
	['soul'] 			= getPlayerSoul,
}
Player.add = {
	['health'] 			= doCreatureAddHealth,
	['mana']			= doPlayerAddMana,
	['spentmana']		= doPlayerAddSpentMana,
	['addons'] 			= doPlayerAddAddons,
	['bless'] 			= doPlayerAddBlessing,
	['blessing'] 		= doPlayerAddBlessing,
	['exp'] 			= doPlayerAddExperience,
	['item'] 			= doPlayerAddItem,
	['itemex'] 			= doPlayerAddItemEx,
	['level']			= doPlayerAddLevel,
	['maglevel']		= doPlayerAddMagLevel,
	['mapmark'] 		= doPlayerAddMapMark,
	['outfit'] 			= doPlayerAddOutfit,
	['skill'] 			= doPlayerAddSkill,
	['skilltry'] 		= doPlayerAddSkillTry,
	['soul'] 			= doPlayerAddSoul,
	['spell'] 			= doPlayerAddSpell,
	['stamina'] 		= doPlayerAddStamina,
	['feed'] 			= doPlayerFeed,
	['joinparty'] 		= doPlayerJoinParty,
	['learnspell'] 		= doPlayerLearnInstantSpell,
	['fyi'] 			= doPlayerPopupFYI,
	['removeoutfit'] 	= doPlayerRemOutfit,
	['removeitem'] 		= doPlayerRemoveItem,
	['resetidle'] 		= doPlayerResetIdleTime,



	['money'] 			= function(cid,amn,...) if amn > 0 then return doPlayerAddMoney(cid,amn,...) else return doPlayerRemoveMoney(cid,amn,...) end end,
	['premdays'] 		= function(cid,amn,...) if amn > 0 then return doPlayerAddPremiumDays(cid,amn,...) else return doPlayerRemovePremiumDays(cid,amn,...) end end,


}
Player['do'] = {
	['move'] 			= doMoveCreature,
	['summom'] 			= doSummonCreature,
	['remove'] 			= doRemoveCreature,
	['say'] 			= doCreatureSay,
	['mute'] 			= doMutePlayer,
	['broadcast'] 		= doPlayerBroadcastMessage,
	['buyitem'] 		= doPlayerBuyItem,
	['buyitemcontainer']= doPlayerBuyItemContainer,
	['save'] 			= doPlayerSave,
	['sendcancel'] 		= doPlayerSendCancel,
	['cancel'] 			= doPlayerSendCancel,
	['channelmessage'] 	= doPlayerSendChannelMessage,
	['defautcancel'] 	= doPlayerSendDefaultCancel,
	['outfitwindow'] 	= doPlayerSendOutfitWindow,
	['textmessage'] 	= doPlayerSendTextMessage,
	['message'] 		= doPlayerSendTextMessage,
	['tutorial'] 		= doPlayerSendTutorial,
	['removeaccban'] 	= doRemoveAccountBanishment,
	['removecondition']	= doRemoveCondition,
	['removeconditions']= doRemoveConditions,

}

---Set can be used like: player.health = 1000
Player.set = {
	--Health
	['health'] 			= doCreatureSetHealth,
	['maxhealth']		= setCreatureMaxHealth,
	--Mana
	['mana'] 			= doCreatureSetHealth,
	['maxmana']			= setCreatureMaxMana,
	--Etc
	['position']		= doTeleportThing,
	['outfit'] 			= doSetCreatureOutfit,
	['light'] 			= doSetCreatureLight,
	['skull'] 			= doCreatureSetSkullType,
	['nomove'] 			= doCreatureSetNoMove,
	['lookdir'] 		= doCreatureSetLookDirection,
	['dir'] 			= doCreatureSetLookDirection,
	['changeoutfit'] 	= doCreatureChangeOutfit,
	['idle'] 			= doPlayerSetIdleTime,
	['level'] 			= doPlayerSetLevel,
	['exprate'] 		= doPlayerSetExperienceRate,
	['groupid'] 		= doPlayerSetGroupId,
	['guildid'] 		= doPlayerSetGuildId,
	['guildlevel'] 		= doPlayerSetGuildLevel,
	['guildnick'] 		= doPlayerSetGuildNick,
	['losspercentlevel']= doPlayerSetLossPercent,
	['losspercentskill']= doPlayerSetLossSkill,
	['magicrate'] 		= doPlayerSetMagicRate,
	['maxcap'] 			= doPlayerSetMaxCapacity,
	['rate'] 			= doPlayerSetRate,
	['sex'] 			= doPlayerSetSex,
	['skillrate'] 		= doPlayerSetSkillRate,
	['skullend']		= doPlayerSetSkullEnd,
	['stamina'] 		= doPlayerSetStamina,
	['storage'] 		= doPlayerSetStorageValue,
	['town'] 			= doPlayerSetTown,
	['vocation'] 		= doPlayerSetVocation,



}
function table.skipOne(t)
	local tr = {}
	for i,b in pairs(t) do
		if not i ~= 1 then
			tr[i-1] = b
		end
	end
	return #tr ~= 0 and tr or {nil}
end
function Player:check(cid)
	if not isPlayer(cid) then
		self.cid[cid] = nil
		return false
	end
	return true
end
function Player:new(cid)
	assert(cid ,'Player not found')
	if self.cid[cid] then
		return self.cid[cid]
	end
	self.n = self.n+1
	local player={}
	local t_ = newproxy(true)
	local _t = player
	player = {}
	getmetatable(t_).cid = cid
	getmetatable(t_).pack = {}
	getmetatable(t_).mid = self.n
	getmetatable(t_).setPack = function(...)
		getmetatable(t_).packet = {}
		collectgarbage()
		getmetatable(t_).packet = table.skipOne({...})
	end
	getmetatable(t_).getPack  = function()
		local pack = getmetatable(t_).packet
		getmetatable(t_).packet = {}
		return pack
	end

	getmetatable(t_).pack = function(...)
		return {pack=true,unpack(table.skipOne({...}))}
	end
	getmetatable(t_).unpack = function(cid,pack_)
		if pack_ and #pack_ ~= 0 then
			pack_.pack = nil
			return cid,unpack(pack_)
		else
			return cid
		end
	end
	getmetatable(t_).__index = function (t,k,q)
        if self.debug then
			print("[PLAYER DEBUG] Ascess value: "..tostring(t).."[" .. tostring(k)..'] on player '..getCreatureName(getmetatable(t_).cid)..' - '..getmetatable(t_).cid,q)
		end
		if self:check(getmetatable(t_).cid) then
			if k == 'unpack' then
				return getmetatable(t_).unpack
			elseif k == 'pack' then
				return function(...)
					return getmetatable(t_).pack(...)
				end
			elseif k == 'getPack' then
				return getmetatable(t_).getPack()
			elseif k == 'setPack' then
				return function(...)
					return getmetatable(t_).setPack(...)
				end
			end

			local k_ = tostring(k):lower()
			if k_:sub(1,3) == 'get' then
				if Player.get[k_:sub(4,-1)] then
					return function(...)
						local v1 = table.skipOne({...})
						local v2 = getmetatable(t_).getPack()
						local ret = #v1 ~= 0 and v1 or v2
						return Player.get[k_:sub(4,-1)](getmetatable(t_).cid,unpack(ret))
					end
				end
			elseif k_:sub(1,3) == 'add' then
				if Player.add[k_:sub(4,-1)] then
					return function(...)
						local v1 = table.skipOne({...})
						local v2 = getmetatable(t_).getPack()
						local ret = #v1 ~= 0 and v1 or v2
						return Player.add[k_:sub(4,-1)](getmetatable(t_).cid,unpack(ret))
					end
				end
			elseif _G[k] then
				return function(...)
					local cid = getmetatable(t_).cid
					local npack = {...}
					local last = 0
					for i,b in pairs(npack) do
						last = i
						if i ~= 1 then
							npack[i-1] = b
						end
					end
					npack[last] = nil
					collectgarbage()
					return _G[k](cid,unpack(npack))
				end
			elseif k_:sub(1,2) == 'do' then
				if Player['do'][k_:sub(3,-1)] then
					return function(...)
						local v1 = table.skipOne({...})
						local v2 = getmetatable(t_).getPack()
						local ret = #v1 ~= 0 and v1 or v2
						return Player['do'][k_:sub(3,-1)](getmetatable(t_).cid,unpack(ret))
					end
				end
			else
				if Player[self.defaut][k_] then
					return Player[self.defaut][k_](getmetatable(t_).cid,unpack(getmetatable(t_).getPack()))
				else
					return _t[k]
				end
			end
			return _t[k]
		else
			return false
		end
	end
	getmetatable(t_).__newindex = function (t,k,v,...)
		if self:check(getmetatable(t_).cid) then
			if self.debug then
				print("[PLAYER DEBUG] Change k: "..tostring(t).."[" .. tostring(k)..'] = '..tostring(v)..' on player '..getCreatureName(getmetatable(t_).cid)..' - '..getmetatable(t_).cid)
			end
			if _t[k] then
				_t[k] = v
			else
				if Player.set[k:lower()] then
					Player.set[k:lower()](getmetatable(t_).unpack(getmetatable(t_).cid,v))
				else
					_t[k] = v
				end
			end
		end
    end
    setmetatable(player, getmetatable(t_))
	self.cid[cid] = player
	return player,self.n
end


function GM:AddStartingTrait(id, name, desc, worth, funcOrProp, propVal, mdl, ...)

	self:AddStartingItem(id, name, desc, ITEMCAT_TRAITS, worth, nil, function(pl)
		if (isfunction(funcOrProp)) then
			funcOrProp(pl)
		else
			GAMEMODE:RegisterProperty(pl, funcOrProp, propVal)
		end
	end, mdl)
	
	local hookTbl = {...}
	
	for i = 1, #hookTbl, 2 do
		local gmHookName = hookTbl[i]
		local gmHookFunc = hookTbl[i + 1]
		
		if (gmHookName) then
			hook.Add(gmHookName, "PERK_" .. id, gmHookFunc)
		end
	end
end

function GM:RegisterProperty(pl, prop, val)
	pl[prop] = val
	
	if (isstring(val)) then
		val = "\"" .. val .. "\""
	end
	
	pl:SendLua("LocalPlayer()[\"" .. prop .. "\"] = " .. tostring(val))
	
	self:AddPropertyResetCallback(prop, val)
end

function GM:AddPropertyResetCallback(prop, val)
	hook.Add("PlayerInitialSpawnRound", "PERK_RESET_" .. prop, function(pl)
		if (IsValid(pl) and pl:IsPlayer()) then
			pl[prop] = nil
			pl:SendLua("LocalPlayer()[\"" .. prop .. "\"] = nil")
		end
	end)
end

local isobjective
local mapname = game.GetMap()
if string.find(mapname, "_obj") or string.find(mapname, "_objective") then
	isobjective = true
else
	isobjective = false
end

GM:AddStartingTrait("bfzerg", "저그출신", "3초마다 1의 체력이 항시 회복된다.", 35, "BuffZerg", true, "models/items/healthkit.mdl", "HumanThink", function(pl)
	local time = CurTime()
	if pl.BuffZerg and time >= (pl.NextZerg or 0) and gamemode.Call("PlayerCanBeHealed", pl) then
		pl.NextZerg = time + 3
		pl:SetHealth(math.min(pl:Health() + 1, pl:GetMaxHealth()))
	end
end)
GM:AddStartingTrait("bfmedic", "의무병", "의료 키트, 자동 치료기의 재사용 대기시간이 25% 감소한다.", 15, "HumanHealDelayMultiplier", 0.75, "models/props_combine/health_charger001.mdl")

if !isobjective then
	GM:AddStartingTrait("bfrevolution", "진화론", "최대 속도의 90% 이상으로 달릴 경우 3초마다 이동속도 8이 증가한다.", 25, "BuffRevolution", true, "models/buggy.mdl", "HumanThink", function(pl) 
		local time = CurTime()
		if pl.BuffRevolution then
			pl.revolutionSpd = (pl.revolutionSpd or 0)
			if (pl.revolutionTime and pl.revolutionTime or 0) + 0.5 <= time then
				if pl:GetVelocity():Length() >= (pl:Crouching() and pl:GetCrouchedWalkSpeed() * 0.9 or pl:GetWalkSpeed() * 0.9) then
					pl.revolutionSpd = math.min(320, pl.revolutionSpd + 1.3)
					pl.revolutionTime = time
					local speed = pl:ResetSpeed(true)
					pl:SetHumanSpeed(speed+pl.revolutionSpd)
				else
					pl.revolutionSpd = 0
					pl.revolutionTime = time
					local speed = pl:ResetSpeed(true)
					pl:SetHumanSpeed(speed)
				end
			end
		end
	end)
end
GM:AddStartingTrait("bfblueprint", "설계도", "설치형 구조물의 회수 시간이 70% 단축된다.", 25, "PackupTimeMult", 0.3, "models/props_lab/binderblue.mdl")
GM:AddStartingTrait("bfsparta", "스파르타식 훈련", "근접 공격에 의한 화면 흔들림이 90% 감소하고 넉다운 지속 시간이 80% 감소한다.", 35, "BuffSparta", true, "models/Items/hevsuit.mdl")
GM:AddStartingTrait("bfwarehouse", "신속보급", "보급상자의 재사용 시간이 30% 감소한다. (본인에게만 적용)", 30, "BuffWarehouse", true, "models/Items/ammocrate_smg1.mdl")
GM:AddStartingTrait("bfthornarmor", "가시갑옷", "자신이 근접 공격에 피격당할 시 공격한 좀비가 입힌 피해의 50%를 같이 입도록 한다.", 
	30, "BuffThornArmor", true, "models/Items/hevsuit.mdl", "PlayerHurt", function(victim, attacker, healthremaining, damage)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_ZOMBIE and attacker:GetZombieClassTable().Name ~= "Shade" then
			if victim:Team() == TEAM_HUMAN and victim.BuffThornArmor then	
				attacker:TakeDamage(dmginfo:GetDamage() * 0.5, attacker, nil)
				self:DamageFloater(attacker, ent, dmginfo)
			end
		end
	end)
GM:AddStartingTrait("bfpitcher", "국민투수", "돌맹이를 포함한 물체를 던지는 힘이 40% 상승한다.", 10, "BuffPitcher", true, "models/props_junk/rock001a.mdl")
GM:AddStartingTrait("bfghost", "유체화", "바리케이드 통과 속도가 100% 증가한다.", 15, "BarriSpeedMult", 2, "models/props_junk/shoe001a.mdl")
GM:AddStartingTrait("bfsbalance", "균형감각", "뒤나 옆으로 이동할 때 감속 비율이 50% 감소한다. (뒤: 50% -> 25%, 옆: 15% -> 7.5%)", 25, "BackwardsWalkMult", 0.5, "models/props_junk/shoe001a.mdl")
GM:AddStartingTrait("bfpunch", "골목대장", "주먹의 데미지가 4배로 증가하며 10% 확률로 좀비를 느려지게 한다.", 30, "BuffPunch", true, "models/props_combine/breenbust.mdl")

GM:AddStartingTrait("bflaststand", "최후의 발악", "단 한번 죽기 직전 주변 좀비를 밀쳐내고 체력을 회복한다.", 30, function(pl)
		GAMEMODE:RegisterProperty(pl, "BuffLastStand", true)
		GAMEMODE:RegisterProperty(pl, "BuffLastStandDone", false)
		GAMEMODE:RegisterProperty(pl, "BuffLastStandHealing", false)
		GAMEMODE:RegisterProperty(pl, "BuffLastStandStart", 0)
	end, nil, "models/props_lab/huladoll.mdl", "EntityTakeDamage", function(ent, dmginfo)
		local attacker = dmginfo:GetAttacker()
		if not (IsValid(ent) and ent:IsPlayer() and ent:Team() == TEAM_HUMAN and IsValid(attacker) and attacker:IsPlayer() and attacker:Team() ~= TEAM_ZOMBIES) then return end
		if ent.BuffLastStand and !ent.BuffLastStandDone and dmginfo:GetDamage() >= ent:Health() then
			ent.BuffLastStandStart = CurTime()
			ent.BuffLastStandDone = true
			ent.BuffLastStandHealing = true
			dmginfo:ScaleDamage(0)

			local origin = ent:LocalToWorld(ent:OBBCenter())
			ent:EmitSound("ambient/machines/teleport4.wav", 130, 125)

			for _, v in pairs(ents.FindInSphere(origin, 512)) do
				if v:IsPlayer() and v:Team() == TEAM_ZOMBIE then
					v:SetGroundEntity(NULL)
					v:ThrowFromPositionSetZ(origin, 800, 0.65)
				end
			end
		end
	end, "HumanThink", function(pl)
		local time = CurTime()
		if (pl.BuffLastStandHealing) then
			pl:SetHealth((pl:GetMaxHealth() / 2) * (time - pl.BuffLastStandStart) / 1.5)
			if pl:Health() >= pl:GetMaxHealth() / 2 then
				pl:SetHealth(pl:GetMaxHealth() / 2)
				pl.BuffLastStandHealing = false
			end
		end
	end)

GM:AddStartingTrait("bfcannibal","식인종","떨어진 인간이나 좀비의 살점을 먹어 체력을 회복할 수 있다.\n의료기기에 의한 체력 회복 -75%.\n방탄복 착용 불가.", 20, function(pl) 
	GAMEMODE:RegisterProperty(pl, "ReceivedHealMultiplier", 0.25)
	GAMEMODE:RegisterProperty(pl, "BuffCannibal", true)
	GAMEMODE:RegisterProperty(pl, "BodyArmorProhibited", true)
end, nil, "models/gibs/HGIBS.mdl")

GM:AddStartingTrait("bfvampire", "뱀파이어","좀비에게 가한 누적 데미지 75당 1의 체력을 회복한다.\n의료기기에 의한 체력 회복 -75%.\n방탄복 착용 불가.", 20, function(pl) 
	GAMEMODE:RegisterProperty(pl, "ReceivedHealMultiplier", 0.25)
	GAMEMODE:RegisterProperty(pl, "BuffVampire", true)
	GAMEMODE:RegisterProperty(pl, "BuffVampireDamage", 0)
	GAMEMODE:RegisterProperty(pl, "BodyArmorProhibited", true)
end, nil, "models/gibs/HGIBS.mdl", "PlayerHurt", function(victim, attacker, healthremaining, damage)
	if victim:Team() == TEAM_UNDEAD and IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker.BuffVampire then
		attacker.BuffVampireDamage = attacker.BuffVampireDamage + damage
		if attacker.BuffVampireDamage >= 75 then
			while attacker.BuffVampireDamage >= 75 do	
				attacker.BuffVampireDamage = attacker.BuffVampireDamage - 75
				attacker:SetHealth(math.min(attacker:Health() + 1, attacker:GetMaxHealth()))
			end
		end
	end
end)

GM:AddStartingTrait("bfantihc", "헤드크랩 연구원", "포이즌 헤드크랩의 공격에 눈이 멀지 않으며 지속대미지에 면역이 된다.", 25, "BuffAntiHC", true, "models/healthvial.mdl")
GM:AddStartingTrait("bfberserk", "광전사", "체력이 50% 이하일 때 근접 무기의 공격력이 100% 증가한다.", 20, 
	"BuffBerserk", true, "models/props/cs_militia/axe.mdl", "EntityTakeDamage", function(ent, dmginfo)
		local attacker, inflictor = dmginfo:GetAttacker(), dmginfo:GetInflictor()
		if (IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN)
		and (attacker.BuffBerserk and attacker:Health() <= attacker:GetMaxHealth() / 2 and (inflictor.IsMelee)) then
			dmginfo:SetDamage(dmginfo:GetDamage() * 2)
		end
	end)

GM:AddStartingTrait("bfbeliefjump", "신뢰의 도약", "낙하 데미지를 2/3만 받는다.", 15, "BuffBeliefJump", true, "models/props_junk/shoe001a.mdl")
GM:AddStartingTrait("bfstrongshoes", "무릎보호대", "20 이상의 낙하 대미지를 받아야만 느려지게 다리를 강화한다. (기존: 5)", 15, "BuffStrongShoes", true, "models/props_junk/shoe001a.mdl")
GM:AddStartingTrait("bfchicken", "꼬꼬댉! 꼬꼮꼮!", "체력이 10% 이하로 떨어지면 이동 속도가 10초간 100% 증가한다. (재사용 대기시간 1분)", 
	20, "BuffChicken", true, "models/pigeon.mdl", "HumanThink", function(pl)
		if (pl.BuffChicken and pl:Health() <= pl:GetMaxHealth() * 0.1) then
			pl:RunChicken()
		end
	end)
GM:AddStartingTrait("bfzacinamsterville", "암스테르빌의 폭파병", "폭발로 입히는 대미지가 25% 증가한다.\n자신이 입는 폭발 대미지는 25% 감소한다.", 
	25, function(pl) 	
		GAMEMODE:RegisterProperty(pl, "ExplosiveResistance", 0.75)
		GAMEMODE:RegisterProperty(pl, "ExplosiveDamageScale", 1.25)
	end, nil, "models/weapons/w_c4.mdl")

GM:AddStartingItem("bfholylight", "빛으로 강타해요!", "자신의 손전등이 셰이드에게 50% 추가 데미지를 가한다.",
	10, "BuffHolyLight", true, "models/maxofs2d/lamp_flashlight.mdl")

GM:AddStartingTrait("bfshockabsorber", "충격 완화", "좀비 공격 넉백에 50% 저항을 가지게 된다.", 10, "KnockBackResistScale", 0.5, "models/xqm/pistontype1.mdl")
GM:AddStartingTrait("bfimgroot", "I AM GROOT", "최대 속도의 80% 이상으로 움직이지 않으면 5초 후부터 받는 피해 -80%, 가하는 피해 -90%.\n이후 다시 움직이면 이 효과는 사라진다.", 
30, function(pl)
	GAMEMODE:RegisterProperty(pl, "BuffIAmGroot", true)
	GAMEMODE:RegisterProperty(pl, "LastMoved", CurTime())
end, nil, "models/props_foliage/oak_tree01.mdl", "Move", function(pl, mv)
	if (mv:GetVelocity():Length() >= pl:GetMaxSpeed() * 0.8 and pl.BuffIAmGroot) then
		pl.LastMoved = CurTime()
	end
end, "EntityTakeDamage", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local ctime = CurTime()
	if (ent:IsValid() and ent:IsPlayer() and attacker:IsValid() and attacker:IsPlayer() and attacker:Team() != ent:Team()) then 
		if attacker.BuffIAmGroot and ent:Team() == TEAM_HUMAN and ent.LastMoved and isnumber(ent.LastMoved) and ent.LastMoved + 5 < ctime then
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.2)
		elseif attacker.BuffIAmGroot and attacker:Team() == TEAM_HUMAN and attacker.LastMoved and isnumber(attacker.LastMoved) and attacker.LastMoved + 5 < ctime then
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.1)	
		end
	end
end)

GM:AddStartingTrait("bfreturnoftheking", "왕의 귀환", "구입 시 최대 체력 -50. 2웨이브부터 매 웨이브 시작마다 최대 체력 30 증가, 체력을 최대치까지 회복한다.", 30, function(pl)
	GAMEMODE:RegisterProperty(pl, "BuffReturnOfTheKing", true)
	pl.HumanHealthAdder = (pl.HumanHealthAdder or 0) -50
	pl:CalcHumanMaxHealth()
end, nil, "models/balloons/balloon_star.mdl", "WaveStateChanged", function(newstate)
	if (newstate and GAMEMODE:GetWave() >= 1) then
		local humans = team.GetPlayers(TEAM_HUMAN)
		for _, v in pairs(humans) do
			if (v.BuffReturnOfTheKing) then
				v.HumanHealthAdder = (v.HumanHealthAdder or 0) + 30
				v:CalcHumanMaxHealth()
			end
		end
	end
end)

local alpha = 128
local alpha_ratio = alpha / 255

local col_green = Color(0, 255, 0, alpha)
local col_red = Color(255, 0, 0, alpha)
local col_green_max = 200
local col_red_max = 255
local one = 1
local zero = 0
local renderDist = 100

local crosshair = GetConVar("crosshair")
GM:AddStartingTrait("bfpointer", "레이저 포인터", "정확히 총구가 향하는 방향으로 작동되는 레이저 포인터를 장착한다.", 5, "BuffPointer", true, nil, "PostDrawTranslucentRenderables", function()
	if (MySelf.BuffPointer) then
		local pl = MySelf
		
		local ang = pl:EyeAngles() + pl:GetUp():Angle()
		
		local sp = pl:GetShootPos()
		
		local av = pl:GetAimVector()
		
		local pos = sp + av * renderDist
		
		surface.SetAlphaMultiplier(alpha_ratio)
		
		cam.IgnoreZ(true)
		cam.Start3D2D(pos, ang, 0.03)
				for i = 4, 8 do 
					surface.DrawCircle(-1, -1, i, 255, 0, 0, 255)
				end
		cam.End3D2D()
		cam.IgnoreZ(false)
		
		surface.SetAlphaMultiplier(one)
	end
end)

GM:AddStartingTrait("bfbeviolence", "팝콘이나 가져와라", "1분동안 좀비에게 데미지를 입히지 않고,\n10초동안 자신 또는 타인에 대한 치료,\n5초동안 바리케이드 수리를 하지 않은 경우\n7초당 1 포인트를 받는다.", 20, function(pl)
	GAMEMODE:RegisterProperty(pl, "BuffBeViolence", true)
	GAMEMODE:RegisterProperty(pl, "NextBuffBeViolence", CurTime())
end, nil, "models/chairs/armchair.mdl", "Think", function()
	for i, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
		if (pl.BuffBeViolence and GAMEMODE:GetWave() > 0) then
			if (pl.NextBuffBeViolence < CurTime()) then
				if (SERVER) then
					pl:AddPoints(1)
				end
				pl.NextBuffBeViolence = CurTime() + 7
			end
		end
	end
end, "PlayerHealedTeamMember", function(pl, other, health, wep)
	if (pl.BuffBeViolence) then
		pl.NextBuffBeViolence = math.max(pl.NextBuffBeViolence, pl.NextBuffBeViolence + 10)
	end
end, "PlayerRepairedObject", function(pl, other, health, wep)
	if (pl.BuffBeViolence) then
		pl.NextBuffBeViolence = math.max(pl.NextBuffBeViolence, pl.NextBuffBeViolence + 5)
	end		
end, "EntityTakeDamage", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker.BuffBeViolence) then
		if (ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_ZOMBIE) then
			attacker.NextBuffBeViolence = CurTime() + 60
		end
	end
end)
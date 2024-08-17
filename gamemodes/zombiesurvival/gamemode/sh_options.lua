local baseclass = baseclass
local bit = bit
local cam = cam
local chat = chat
local concommand = concommand
local constraint = constraint
local cvars = cvars
local derma = derma
local draw = draw
local effects = effects
local ents = ents
local file = file
local game = game
local gamemode = gamemode
local gmod = gmod
local gui = gui
local hook = hook
local input = input
local killicon = killicon
local language = language
local list = list
local math = math
local mesh = mesh
local net = net
local os = os
local physenv = physenv
local player = player
local player_manager = player_manager
local render = render
local scripted_ents = scripted_ents
local sound = sound
local string = string
local surface = surface
local table = table
local team = team
local timer = timer
local util = util
local vgui = vgui
local weapons = weapons
local AccessorFunc = AccessorFunc
local Angle = Angle
local AngleRand = AngleRand
local assert = assert
local ClientsideModel = ClientsideModel
local CloseDermaMenus = CloseDermaMenus
local Color = Color
local CreateClientConVar = CreateClientConVar
local CreateConVar = CreateConVar
local CurTime = CurTime
local DamageInfo = DamageInfo
local Derma_Anim = Derma_Anim
local Derma_DrawBackgroundBlur = Derma_DrawBackgroundBlur
local Derma_Hook = Derma_Hook
local Derma_Install_Convar_Functions = Derma_Install_Convar_Functions
local Derma_Message = Derma_Message
local Derma_Query = Derma_Query
local Derma_StringRequest = Derma_StringRequest
local DermaMenu = DermaMenu
local DisableClipping = DisableClipping
local DynamicLight = DynamicLight
local EffectData = EffectData
local EmitSentence = EmitSentence
local EmitSound = EmitSound
local EyeAngles = EyeAngles
local EyePos = EyePos
local EyeVector = EyeVector
local Format = Format
local FrameTime = FrameTime
local GetConVar = GetConVar
local GetConVarNumber = GetConVarNumber
local GetConVarString = GetConVarString
local getfenv = getfenv
local GetGlobalAngle = GetGlobalAngle
local GetGlobalBool = GetGlobalBool
local GetGlobalEntity = GetGlobalEntity
local GetGlobalFloat = GetGlobalFloat
local GetGlobalInt = GetGlobalInt
local GetGlobalString = GetGlobalString
local GetGlobalVector = GetGlobalVector
local GetHostName = GetHostName
local GetHUDPanel = GetHUDPanel
local GetRenderTarget = GetRenderTarget
local GetRenderTargetEx = GetRenderTargetEx
local GetViewEntity = GetViewEntity
local ipairs = ipairs
local IsFirstTimePredicted = IsFirstTimePredicted
local isnumber = isnumber
local IsValid = IsValid
local Label = Label
local LocalPlayer = LocalPlayer
local LocalToWorld = LocalToWorld
local Material = Material
local Matrix = Matrix
local Msg = Msg
local MsgAll = MsgAll
local MsgC = MsgC
local MsgN = MsgN
local pairs = pairs
local Particle = Particle
local ParticleEffect = ParticleEffect
local ParticleEffectAttach = ParticleEffectAttach
local ParticleEmitter = ParticleEmitter
local print = print
local PrintMessage = PrintMessage
local PrintTable = PrintTable
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local ScrH = ScrH
local ScrW = ScrW
local SetGlobalAngle = SetGlobalAngle
local SetGlobalBool = SetGlobalBool
local SetGlobalEntity = SetGlobalEntity
local SetGlobalFloat = SetGlobalFloat
local SetGlobalInt = SetGlobalInt
local SetGlobalString = SetGlobalString
local SetGlobalVector = SetGlobalVector
local Sound = Sound
local SoundDuration = SoundDuration
local tobool = tobool
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack
local ValidPanel = ValidPanel
local Vector = Vector
local VectorRand = VectorRand
local VGUIFrameTime = VGUIFrameTime
local VGUIRect = VGUIRect
local WorldToLocal = WorldToLocal

GM.ZombieEscapeWeapons = {
	"weapon_zs_zedeagle",
	"weapon_zs_zeakbar",
	"weapon_zs_zesweeper",
	"weapon_zs_zesmg",
	"weapon_zs_zestubber",
	"weapon_zs_zebulletstorm"
}

-- Change this if you plan to alter the cost of items or you severely change how Worth works.
-- Having separate cart files allows people to have separate loadouts for different servers.
GM.CartFile = "zsclassiccarts.txt"

ITEMCAT_GUNS = 1
ITEMCAT_AMMO = 2
ITEMCAT_MELEE = 3
ITEMCAT_TOOLS = 4
ITEMCAT_OTHER = 5
ITEMCAT_UPGRADE = 6
ITEMCAT_TRAITS = 7
ITEMCAT_RETURNS = 8

GM.ItemCategories = {
	[ITEMCAT_GUNS] = "총기류",
	[ITEMCAT_AMMO] = "탄약",
	[ITEMCAT_MELEE] = "근접 무기",
	[ITEMCAT_TOOLS] = "도구",
	[ITEMCAT_OTHER] = "기타",
	[ITEMCAT_UPGRADE] = "개조",
	[ITEMCAT_TRAITS] = "특성",
	[ITEMCAT_RETURNS] = "리턴"
}

--[[
Humans select what weapons (or other things) they want to start with and can even save favorites. Each object has a number of 'Worth' points.
Signature is a unique signature to give in case the item is renamed or reordered. Don't use a number or a string number!
A human can only use 100 points (default) when they join. Redeeming or joining late starts you out with a random loadout from above.
SWEP is a swep given when the player spawns with that perk chosen.
Callback is a function called. Model is a display model. If model isn't defined then the SWEP model will try to be used.
swep, callback, and model can all be nil or empty
]]
GM.Items = {}
function GM:AddItem(signature, name, desc, category, price, swep, callback, model, worthshop, pointshop)
	local tab = {Signature = signature, Name = name, Description = desc, Category = category, Price = price or 0, SWEP = swep, Callback = callback, Model = model}
	tab.Worth = tab.Price -- compat

	self.Items[#self.Items + 1] = tab
	self.Items[signature] = tab

	return tab
end

function GM:AddStartingItem(signature, name, desc, category, price, swep, callback, model)
	local item = self:AddItem(signature, name, desc, category, price, swep, callback, model, true, false)
	item.WorthShop = true

	return item
end

function GM:AddPointShopItem(signature, name, desc, category, price, swep, callback, model)
	local item = self:AddItem("ps_"..signature, name, desc, category, price, swep, callback, model, false, true)
	item.PointShop = true

	return item
end

-- Weapons are registered after the gamemode.
timer.Simple(0, function()
	for _, tab in pairs(GAMEMODE.Items) do
		if not tab.Description and tab.SWEP then
			local sweptab = weapons.GetStored(tab.SWEP)
			if sweptab then
				tab.Description = sweptab.Description
			end
		end
	end
end)

-- How much ammo is considered one 'clip' of ammo? For use with setting up weapon defaults. Works directly with zs_survivalclips
GM.AmmoCache = {}
GM.AmmoCache["ar2"] = 30 -- Assault rifles.
GM.AmmoCache["alyxgun"] = 24 -- Not used.
GM.AmmoCache["pistol"] = 12 -- Pistols.
GM.AmmoCache["smg1"] = 30 -- SMG's and some rifles.
GM.AmmoCache["357"] = 10 -- Rifles, especially of the sniper variety.
GM.AmmoCache["xbowbolt"] = 4 -- Crossbows
GM.AmmoCache["buckshot"] = 8 -- Shotguns
GM.AmmoCache["ar2altfire"] = 1 -- Not used.
GM.AmmoCache["slam"] = 1 -- Force Field Emitters.
GM.AmmoCache["rpg_round"] = 1 -- Not used. Rockets?
GM.AmmoCache["smg1_grenade"] = 1
GM.AmmoCache["sniperround"] = 1 -- Barricade Kit
GM.AmmoCache["sniperpenetratedround"] = 1 -- Remote Det pack.
GM.AmmoCache["grenade"] = 1 -- Grenades.
GM.AmmoCache["thumper"] = 1 -- Gun turret.
GM.AmmoCache["gravity"] = 200 -- m249.
GM.AmmoCache["battery"] = 30 -- Used with the Medical Kit.
GM.AmmoCache["gaussenergy"] = 1 -- Nails used with the Carpenter's Hammer.
GM.AmmoCache["combinecannon"] = 1 -- Railgun.
GM.AmmoCache["airboatgun"] = 1 -- Arsenal crates.
GM.AmmoCache["striderminigun"] = 1 -- Message beacons.
GM.AmmoCache["helicoptergun"] = 1 --Resupply boxes.
GM.AmmoCache["spotlamp"] = 1
GM.AmmoCache["manhack"] = 1
GM.AmmoCache["charger"] = 1
GM.AmmoCache["pulse"] = 30
GM.AmmoCache["rpg"] = 1
-- These ammo types are available at ammunition boxes.
-- The amount is the ammo to give them.
-- If the player isn't holding a weapon that uses one of these then they will get smg1 ammo.
GM.AmmoResupply = {}
GM.AmmoResupply["ar2"] = GM.AmmoCache["ar2"] 
GM.AmmoResupply["alyxgun"] = GM.AmmoCache["alyxgun"]
GM.AmmoResupply["pistol"] = GM.AmmoCache["pistol"]
GM.AmmoResupply["smg1"] = GM.AmmoCache["smg1"] 
GM.AmmoResupply["357"] = GM.AmmoCache["357"]
GM.AmmoResupply["xbowbolt"] = GM.AmmoCache["xbowbolt"]
GM.AmmoResupply["buckshot"] = GM.AmmoCache["buckshot"]
GM.AmmoResupply["battery"] = 30
GM.AmmoResupply["pulse"] = GM.AmmoCache["pulse"]
GM.AmmoResupply["gravity"] = GM.AmmoCache["gravity"]
GM.AmmoResupply["combinecannon"] = GM.AmmoCache["combinecannon"]
-----------
-- Worth --
-----------

GM:AddStartingItem("pshtr", "'Peashooter' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_peashooter")
GM:AddStartingItem("btlax", "'Battleaxe' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_battleaxe")
GM:AddStartingItem("owens", "'Owens' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_owens")
GM:AddStartingItem("blstr", "'Blaster' 샷건", nil, ITEMCAT_GUNS, 55, "weapon_zs_blaster")
GM:AddStartingItem("tossr", "'Tosser' SMG", nil, ITEMCAT_GUNS, 50, "weapon_zs_tosser")
GM:AddStartingItem("stbbr", "'Stubber' 소총", nil, ITEMCAT_GUNS, 55, "weapon_zs_stubber")
GM:AddStartingItem("crklr", "'Crackler' 돌격 소총", nil, ITEMCAT_GUNS, 50, "weapon_zs_crackler")
GM:AddStartingItem("z9000", "'Z9000' 펄스 권총", nil, ITEMCAT_GUNS, 50, "weapon_zs_z9000")

GM:AddStartingItem("2pcp", "3 권총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 3, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("2sgcp", "3 샷건 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("2smgcp", "3 SMG 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 3, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("2arcp", "3 돌격소총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 3, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("2rcp", "3 소총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 3, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("2pls", "3 펄스 충전팩", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 3, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddStartingItem("3pcp", "5 권총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 5, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("3sgcp", "5 샷건 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 5, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("3smgcp", "5 SMG 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 5, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("3arcp", "5 돌격소총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 5, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("3rcp", "5 소총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 5, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("3pls", "5 펄스 충전팩", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 5, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")

GM:AddStartingItem("zpaxe", "도끼", nil, ITEMCAT_MELEE, 30, "weapon_zs_axe")
GM:AddStartingItem("crwbar", "빠루", nil, ITEMCAT_MELEE, 30, "weapon_zs_crowbar")
GM:AddStartingItem("stnbtn", "전기 충격기", nil, ITEMCAT_MELEE, 45, "weapon_zs_stunbaton")
GM:AddStartingItem("csknf", "스위스 육군 칼", nil, ITEMCAT_MELEE, 10, "weapon_zs_swissarmyknife")
GM:AddStartingItem("zpplnk", "판자때기", nil, ITEMCAT_MELEE, 10, "weapon_zs_plank")
GM:AddStartingItem("zpfryp", "프라이팬", nil, ITEMCAT_MELEE, 20, "weapon_zs_fryingpan")
GM:AddStartingItem("zpcpot", "냄비", nil, ITEMCAT_MELEE, 20, "weapon_zs_pot")
GM:AddStartingItem("pipe", "납 파이프", nil, ITEMCAT_MELEE, 45, "weapon_zs_pipe")
GM:AddStartingItem("hook", "갈고리", nil, ITEMCAT_MELEE, 30, "weapon_zs_hook")

GM:AddStartingItem("medkit", "의료 키트", nil, ITEMCAT_TOOLS, 50, "weapon_zs_medicalkit")
GM:AddStartingItem("medgun", "메딕 건", nil, ITEMCAT_TOOLS, 45, "weapon_zs_medicgun")
GM:AddStartingItem("150mkit", "150 의약품", nil, ITEMCAT_TOOLS, 30, nil, function(pl) pl:GiveAmmo(150, "Battery", true) end, "models/healthvial.mdl")
GM:AddStartingItem("arscrate", "상점 상자", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate").Countables = "prop_arsenalcrate"
GM:AddStartingItem("resupplybox", "보급 상자", nil, ITEMCAT_TOOLS, 70, "weapon_zs_resupplybox").Countables = "prop_resupplybox"
local item = GM:AddStartingItem("infturret", "적외선 레이저 터렛", nil, ITEMCAT_TOOLS, 75, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end)
item.Countables = {"weapon_zs_gunturret", "prop_gunturret"}
item.NoClassicMode = true
local item = GM:AddStartingItem("manhack", "맨핵", nil, ITEMCAT_TOOLS, 55, "weapon_zs_manhack")
item.Countables = "prop_manhack"
GM:AddStartingItem("wrench", "정비공의 렌치", nil, ITEMCAT_TOOLS, 20, "weapon_zs_wrench").NoClassicMode = true
GM:AddStartingItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 45, "weapon_zs_hammer").NoClassicMode = true
GM:AddStartingItem("6nails", "못 한 박스(16개입)", nil, ITEMCAT_TOOLS, 20, nil, function(pl) pl:GiveAmmo(16, "GaussEnergy", true) end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("junkpack", "판자 더미", nil, ITEMCAT_TOOLS, 40, "weapon_zs_boardpack")
GM:AddStartingItem("spotlamp", "스팟 램프", nil, ITEMCAT_TOOLS, 15, "weapon_zs_spotlamp").Countables = "prop_spotlamp"
GM:AddStartingItem("msgbeacon", "메세지 비콘", nil, ITEMCAT_TOOLS, 5, "weapon_zs_messagebeacon").Countables = "prop_messagebeacon"
--GM:AddStartingItem("ffemitter", "Force Field Emitter", nil, ITEMCAT_TOOLS, 60, "weapon_zs_ffemitter").Countables = "prop_ffemitter"

GM:AddStartingItem("stone", "돌멩이", nil, ITEMCAT_OTHER, 5, "weapon_zs_stone")
GM:AddStartingItem("grenade", "수류탄", nil, ITEMCAT_OTHER, 15, "weapon_zs_grenade")
GM:AddStartingItem("molotov", "화염병", nil, ITEMCAT_OTHER, 15, "weapon_zs_molotov")
GM:AddStartingItem("detpck", "원격 폭발물 패키지", nil, ITEMCAT_OTHER, 35, "weapon_zs_detpack").Countables = "prop_detpack"
GM:AddStartingItem("oxtank", "산소 탱크", "숨을 더 오래 참을 수 있다.", ITEMCAT_OTHER, 10, "weapon_zs_oxygentank")

GM:AddStartingItem("10hp", "체력 10 상승", "최대 체력이 10 증가한다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanHealthAdder = (pl.HumanHealthAdder or 0) + 10 pl:CalcHumanMaxHealth() end, "models/healthvial.mdl")
GM:AddStartingItem("25hp", "체력 25 상승", "최대 체력이 25 증가한다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl.HumanHealthAdder = (pl.HumanHealthAdder or 0) + 25 pl:CalcHumanMaxHealth() end, "models/items/healthkit.mdl")
local item = GM:AddStartingItem("5spd", "이동 속도 증가", "이동 속도가 소폭 증가한다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 7 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
local item = GM:AddStartingItem("10spd", "이동 속도 증가 2", "이동 속도가 매우 증가한다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 14 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
GM:AddStartingItem("bfhandy", "수리 전문가", "모든 수리 효율이 25% 올라간다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl.HumanRepairMultiplier = (pl.HumanRepairMultiplier or 1) + 0.25 end, "models/props_c17/tools_wrench01a.mdl")
GM:AddStartingItem("bfsurgeon", "간호사", "자신과 타인에 대한 치료 효율이 30% 올라간다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 0.3 end, "models/healthvial.mdl")
GM:AddStartingItem("bfresist", "포이즌 저항", "독 데미지에 50% 저항이 생긴다.", ITEMCAT_TRAITS, 30, nil, function(pl) pl.BuffResistant = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfregen", "축복", "현재 체력이 최대 체력의 절반 이하일 때 1초에 1의 체력이 회복된다.", ITEMCAT_TRAITS, 30, nil, function(pl) pl.BuffRegenerative = true pl.BuffRegenerativeAdder = 3 / 7 pl.BuffRegenerativeHealth = 0 end, "models/healthvial.mdl")
GM:AddStartingItem("bfmusc", "근육질", "근접 무기로 20% 추가 피해를 가한다.\n또한, 무거운 물체를 끌지 않고 들어서 옮길 수 있다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffMuscular = true pl:DoMuscularBones() end, "models/props_wasteland/kitchen_shelf001a.mdl")

GM:AddStartingItem("dbfweak", "멸치", "최대 체력이 30 감소한다.", ITEMCAT_RETURNS, -20, nil, function(pl) pl.HumanHealthAdder = (pl.HumanHealthAdder or 0) - 30 pl:CalcHumanMaxHealth() end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfslow", "관절염", "이동속도가 대폭 감소한다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 1) - 20 pl:ResetSpeed() pl.IsSlow = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfpalsy", "수전증", "다쳤을 경우 조준하기가 매우 어려워진다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl:SetPalsy(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfhemo", "혈우병", "좀비에게 피격시 출혈 피해를 추가로 받는다.", ITEMCAT_RETURNS, -20, nil, function(pl) pl:SetHemophilia(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfunluc", "그러게 정치질 그만 하라니까", "라운드 중 상점 이용이 불가능해진다.", ITEMCAT_RETURNS, -100, nil, function(pl) pl:SetUnlucky(true) end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfclumsy", "골다공증", "매우 쉽게 넉다운된다.", ITEMCAT_RETURNS, -20, nil, function(pl) pl.Clumsy = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfnoghosting", "뚱땡이", "바리케이드를 통과할 수 없게 된다.", ITEMCAT_RETURNS, -25, nil, function(pl) pl.NoGhosting = true end, "models/gibs/HGIBS.mdl").NoClassicMode = true
GM:AddStartingItem("dbfnopickup", "근위축증", "프롭을 들 수 없게 된다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.NoObjectPickup = true pl:DoNoodleArmBones() end, "models/gibs/HGIBS.mdl")

------------
-- Points --
------------

GM:AddPointShopItem("deagle", "'Zombie Drill' 데저트 이글", nil, ITEMCAT_GUNS, 25, "weapon_zs_deagle")
GM:AddPointShopItem("glock3", "'Crossfire' 글록 3", nil, ITEMCAT_GUNS, 30, "weapon_zs_glock3")
GM:AddPointShopItem("magnum", "'Ricochet' 매그넘", nil, ITEMCAT_GUNS, 35, "weapon_zs_magnum")
GM:AddPointShopItem("eraser", "'Eraser' 전략 권총", nil, ITEMCAT_GUNS, 35, "weapon_zs_eraser")

GM:AddPointShopItem("uzi", "'Sprayer' Uzi 9mm", nil, ITEMCAT_GUNS, 55, "weapon_zs_uzi")
GM:AddPointShopItem("shredder", "'Shredder' SMG", nil, ITEMCAT_GUNS, 65, "weapon_zs_smg")
GM:AddPointShopItem("bulletstorm", "'Bullet Storm' SMG", nil, ITEMCAT_GUNS, 65, "weapon_zs_bulletstorm")
GM:AddPointShopItem("hunter", "'Hunter' 저격 소총", nil, ITEMCAT_GUNS, 70, "weapon_zs_hunter")

GM:AddPointShopItem("ender", "'Ender' 자동 샷건", nil, ITEMCAT_GUNS, 75, "weapon_zs_ender")
GM:AddPointShopItem("reaper", "'Reaper' UMP", nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")
GM:AddPointShopItem("akbar", "'Akbar' 돌격소총", nil, ITEMCAT_GUNS, 85, "weapon_zs_akbar")
GM:AddPointShopItem("silencer", "'Silencer' SMG", nil, ITEMCAT_GUNS, 85, "weapon_zs_silencer")
GM:AddPointShopItem("annabelle", "'애나벨' 소총", nil, ITEMCAT_GUNS, 105, "weapon_zs_annabelle")
GM:AddPointShopItem("immortal", "'Immortal' 권총", nil, ITEMCAT_GUNS, 110, "weapon_zs_immortal")
GM:AddPointShopItem("ppsh", "'Shpagina' SMG", nil, ITEMCAT_GUNS, 115, "weapon_zs_ppsh41")

GM:AddPointShopItem("stalker", "'Stalker' 돌격소총", nil, ITEMCAT_GUNS, 125, "weapon_zs_m4")
GM:AddPointShopItem("inferno", "'Inferno' 돌격소총", nil, ITEMCAT_GUNS, 135, "weapon_zs_inferno")
GM:AddPointShopItem("krieg", "'Krieg' 돌격 소총", nil, ITEMCAT_GUNS, 145, "weapon_zs_krieg")
GM:AddPointShopItem("terminator", "'Terminator' 권총", nil, ITEMCAT_GUNS, 125, "weapon_zs_terminator")
GM:AddPointShopItem("inquisition", "'Inquisition' 소형 석궁", nil, ITEMCAT_GUNS, 135, "weapon_zs_inquisition")
GM:AddPointShopItem("tommy", "'Tommy' SMG", nil, ITEMCAT_GUNS, 140, "weapon_zs_tommy")
GM:AddPointShopItem("ioncannon", "이온 캐논", nil, ITEMCAT_GUNS, 165, "weapon_zs_ioncannon")
GM:AddPointShopItem("neutrino", "'Neutrino' 펄스 LMG", nil, ITEMCAT_GUNS, 175, "weapon_zs_neutrino")
GM:AddPointShopItem("crossbow", "'Impaler' 크로스보우", nil, ITEMCAT_GUNS, 180, "weapon_zs_crossbow")
GM:AddPointShopItem("g3sg1", "'Zeus' DMR", nil, ITEMCAT_GUNS, 175, "weapon_zs_zeus")

GM:AddPointShopItem("sweeper", "'Sweeper' 샷건", nil, ITEMCAT_GUNS, 200, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("boomstick", "붐스틱", nil, ITEMCAT_GUNS, 215, "weapon_zs_boomstick")
GM:AddPointShopItem("slugrifle", "'Tiny' 슬러그 라이플", nil, ITEMCAT_GUNS, 215, "weapon_zs_slugrifle")
GM:AddPointShopItem("sg550", "'Helvetica' DMR", nil, ITEMCAT_GUNS, 210, "weapon_zs_sg550")
GM:AddPointShopItem("pulserifle", "'Adonis' 펄스 라이플", nil, ITEMCAT_GUNS, 225, "weapon_zs_pulserifle")
GM:AddPointShopItem("m249", "'Chainsaw' M249", nil, ITEMCAT_GUNS, 255, "weapon_zs_m249")
GM:AddPointShopItem("rpg", "'알라봉' RPG-7", nil, ITEMCAT_GUNS, 240, "weapon_zs_rpg")
GM:AddPointShopItem("railgun", "시제품 가우스 레일건", nil, ITEMCAT_GUNS, 260, "weapon_zs_railgun")
GM:AddPointShopItem("positron", "'Positron' 양전자포", nil, ITEMCAT_GUNS, 280, "weapon_zs_positron")

GM:AddPointShopItem("pistolammo", "권총 탄약 박스", nil, ITEMCAT_AMMO, 4, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("shotgunammo", "샷건 탄약 박스", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("smgammo", "SMG 탄약 박스", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("assaultrifleammo", "돌격소총 탄약 박스", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", "소총 탄약 박스", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 6, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("crossbowammo", "크로스보우 볼트", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(1, "XBowBolt", true) end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("pulseammo", "펄스 충전팩", nil, ITEMCAT_AMMO, 8, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 30, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddPointShopItem("m249ammo", "M249 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["gravity"] or 200, "gravity", true) end, nil)
GM:AddPointShopItem("rpgammo", "RPG-7 로켓", nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["rpg"] or 1, "rpg", true) end, nil)
GM:AddPointShopItem("railgunammo", "열화 우라늄 탄환", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["combinecannon"] or 1, "combinecannon", true) end, "models/props_combine/breenlight.mdl")
GM:AddPointShopItem("boards", "판자 3개",  nil, ITEMCAT_AMMO, 10, nil, function(pl) pl:GiveAmmo(3, "SniperRound", true) end, "models/props_debris/wood_board06a.mdl").NoClassicMode = true
GM:AddPointShopItem("nail", "못 3개",  nil, ITEMCAT_AMMO, 7, nil, function(pl) pl:GiveAmmo(3, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("mkit50", "의약품 팩", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo(50, "Battery", true) end, "models/healthvial.mdl")

GM:AddPointShopItem("axe", "도끼", nil, ITEMCAT_MELEE, 20, "weapon_zs_axe")
GM:AddPointShopItem("crowbar", "빠루", nil, ITEMCAT_MELEE, 20, "weapon_zs_crowbar")
GM:AddPointShopItem("stunbaton", "스턴 바톤", nil, ITEMCAT_MELEE, 25, "weapon_zs_stunbaton")
GM:AddPointShopItem("knife", "스위스 육군 칼", nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddPointShopItem("shovel", "삽", nil, ITEMCAT_MELEE, 30, "weapon_zs_shovel")
GM:AddPointShopItem("sledgehammer", "오함마", nil, ITEMCAT_MELEE, 30, "weapon_zs_sledgehammer")
--GM:AddPointShopItem("energysword", "에너지 소드", nil, ITEMCAT_MELEE, 60, "weapon_zs_energysword")

GM:AddPointShopItem("rivet", "리벳건", nil, ITEMCAT_TOOLS, 65, "weapon_zs_nailgun")
GM:AddPointShopItem("junkpack", "판자 더미", nil, ITEMCAT_TOOLS, 35, "weapon_zs_boardpack")
GM:AddPointShopItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 50, "weapon_zs_hammer").NoClassicMode = true
GM:AddPointShopItem("wrench", "정비공의 렌치", nil, ITEMCAT_TOOLS, 25, "weapon_zs_wrench").NoClassicMode = true
GM:AddPointShopItem("arsenalcrate", "상점 상자", nil, ITEMCAT_TOOLS, 35, "weapon_zs_arsenalcrate")
GM:AddPointShopItem("resupplybox", "보급 상자", nil, ITEMCAT_TOOLS, 55, "weapon_zs_resupplybox")
GM:AddPointShopItem("medkit", "의료 키트", nil, ITEMCAT_TOOLS, 160, "weapon_zs_medicalkit")
GM:AddPointShopItem("medgun", "'Savior' 메딕 건", nil, ITEMCAT_TOOLS, 50, "weapon_zs_medicgun")
GM:AddPointShopItem("practition", "'Practition' 의료소총", nil, ITEMCAT_TOOLS, 110, "weapon_zs_practition")
GM:AddPointShopItem("medcharger", "자동 치료기", nil, ITEMCAT_TOOLS, 60, "weapon_zs_mediccharger")
GM:AddPointShopItem("defenceprojectile", "'Twister' 국지방어기", nil, ITEMCAT_TOOLS, 35, "weapon_zs_defenceprojectile")
local item = GM:AddPointShopItem("infturret", "적외선 레이저 터렛", nil, ITEMCAT_TOOLS, 65, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
end)
item.NoClassicMode = true
GM:AddPointShopItem("manhack", "맨핵", nil, ITEMCAT_TOOLS, 45, "weapon_zs_manhack")
GM:AddPointShopItem("barricadekit", "'Aegis' 바리케이드 킷", nil, ITEMCAT_TOOLS, 125, "weapon_zs_barricadekit")

GM:AddPointShopItem("bodyarmor", "방탄복", "좀비 공격 피해량의 30%를 경감해주는 방탄복. 100의 내구도를 가지고 있으며 흡수한 피해만큼 소모된다.\n중첩되지 않고, 구매시 내구도가 100으로 전량 회복된다.", ITEMCAT_OTHER, 50, nil, 
function(pl)
	if (pl:CanBuyBodyArmor()) then
		pl:WearBodyArmor()
	else
		sender:CenterNotify(COLOR_RED, "방탄복을 입을 수 없다.")
		sender:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end
end, "models/Items/hevsuit.mdl")


GM:AddPointShopItem("grenade", "수류탄", nil, ITEMCAT_OTHER, 55, "weapon_zs_grenade")
GM:AddPointShopItem("detpck", "원격 폭발물 팩", nil, ITEMCAT_OTHER, 75, "weapon_zs_detpack")
-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "좀비 학살자", String = "%s, %d마리의 좀비를 처치했습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "생존자 하드캐리", String = "%s, 좀비들에게 %d 데미지를 입혔습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = "평화주의자", String = "%s, 이번 라운드에 단 한 마리의 좀비도 죽이지 않았습니다!", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "최고의 서포터", String = "%s, %d마리의 좀비 처치를 도왔습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "최후의 생존자", String = "%s님이 최후의 생존자입니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "도 망가 야해", String = "%s, 좀비 스폰 지역에서 %d만큼이나 도망간 후 살해당했습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "의사양반", String = "%s, 아군의 체력을 %d만큼 회복시켰습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "슈퍼 공돌이", String = "%s, 바리케이드를 수리하여 %d포인트를 벌었습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = "까마귀 학살자", String = "%s, %d마리의 죄 없는 까마귀를 학살했습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "인간 학살자", String = "%s, %d개의 뇌를 먹어치웠습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "좀비 하드캐리", String = "%s, 생존자들에게 총 %d데미지를 입혔습니다!", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = "종결자", String = "%s, 최후의 인간을 먹어치워 이번 라운드를 끝냈습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "포인트 공급원", String = "%s, 무려 %d킬을 내줬습니다!", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = "멍청이", String = "%s, 좀비 스폰 지점에서 겨우 거리 %d 떨어진 곳에서 사망했습니다.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = "세일즈맨", String = "%s, 자신의 상점 상자로 %d포인트를 벌어들였습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "살아있는 보급창고", String = "%s님의 보급 상자가 %d번 사용되었습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = "살아있는 스폰지점", String = "%s, %d마리의 좀비를 스폰시켰습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = "까마귀 군주", String = "%s, 동족을 %d마리나 학살했습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = "쥐꼬리만한 골칫거리", String = "%s, 까마귀로 바리케이드에 %d 데미지를 입혔습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "바리케이드 파괴자", String = "%s, 바리케이드에 %d 데미지를 입혔습니다!", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "둥지 파괴자", String = "%s, %d개의 둥지를 파괴했습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "제비집", String = "%s, %d마리의 좀비를 자신의 둥지에서 스폰시켰습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}

-- Don't let humans use these models because they look like undead models. Must be lower case.
GM.RestrictedModels = {
	"models/player/zombie_classic.mdl",
	"models/player/zombine.mdl",
	"models/player/zombie_soldier.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/corpse1.mdl",
	"models/player/charple.mdl",
	"models/player/skeleton.mdl"
}

-- If a person has no player model then use one of these (auto-generated).
GM.RandomPlayerModels = {}
for name, mdl in pairs(player_manager.AllValidModels()) do
	if not table.HasValue(GM.RestrictedModels, string.lower(mdl)) then
		table.insert(GM.RandomPlayerModels, name)
	end
end

-- Utility function to setup a weapon's DefaultClip.
function GM:SetupDefaultClip(tab)
	tab.DefaultClip = math.ceil(tab.ClipSize * self.SurvivalClips * (tab.ClipMultiplier or 1))
end

GM.MaxSigils = CreateConVar("zs_maxsigils", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many sigils to spawn. 0 for none."):GetInt()
cvars.AddChangeCallback("zs_maxsigils", function(cvar, oldvalue, newvalue)
	GAMEMODE.MaxSigils = math.Clamp(tonumber(newvalue) or 0, 0, 10)
end)

GM.DefaultRedeem = CreateConVar("zs_redeem", "4", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The amount of kills a zombie needs to do in order to redeem. Set to 0 to disable."):GetInt()
cvars.AddChangeCallback("zs_redeem", function(cvar, oldvalue, newvalue)
	GAMEMODE.DefaultRedeem = math.max(0, tonumber(newvalue) or 0)
end)

GM.WaveOneZombies = math.ceil(100 * CreateConVar("zs_waveonezombies", "0.1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The percentage of players that will start as zombies when the game begins."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_waveonezombies", function(cvar, oldvalue, newvalue)
	GAMEMODE.WaveOneZombies = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.NumberOfWaves = CreateConVar("zs_numberofwaves", "6", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Number of waves in a game."):GetInt()
cvars.AddChangeCallback("zs_numberofwaves", function(cvar, oldvalue, newvalue)
	GAMEMODE.NumberOfWaves = tonumber(newvalue) or 1
end)

-- Game feeling too easy? Just change these values!
GM.ZombieSpeedMultiplier = math.ceil(100 * CreateConVar("zs_zombiespeedmultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Zombie running speed will be scaled by this value."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiespeedmultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieSpeedMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

-- This is a resistance, not for claw damage. 0.5 will make zombies take half damage, 0.25 makes them take 1/4, etc.
GM.ZombieDamageMultiplier = math.ceil(100 * CreateConVar("zs_zombiedamagemultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Scales the amount of damage that zombies take. Use higher values for easy zombies, lower for harder."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiedamagemultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieDamageMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.TimeLimit = CreateConVar("zs_timelimit", "30", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Time in minutes before the game will change maps. It will not change maps if a round is currently in progress but after the current round ends. -1 means never switch maps. 0 means always switch maps."):GetInt() * 60
cvars.AddChangeCallback("zs_timelimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.TimeLimit = tonumber(newvalue) or 15
	if GAMEMODE.TimeLimit ~= -1 then
		GAMEMODE.TimeLimit = GAMEMODE.TimeLimit * 60
	end
end)

GM.RoundLimit = CreateConVar("zs_roundlimit", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many times the game can be played on the same map. -1 means infinite or only use time limit. 0 means once."):GetInt()
cvars.AddChangeCallback("zs_roundlimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.RoundLimit = tonumber(newvalue) or 3
end)

-- Static values that don't need convars...

-- Initial length for wave 1.
GM.WaveOneLength = 220

-- For Classic Mode
GM.WaveOneLengthClassic = 120

-- Add this many seconds for each additional wave.
GM.TimeAddedPerWave = 15

-- For Classic Mode
GM.TimeAddedPerWaveClassic = 10

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
GM.NoNewHumansWave = 2

-- Humans can not commit suicide if the current wave is this or lower.
GM.NoSuicideWave = 1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
GM.WaveZeroLength = 180

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator (crow) view and any living ones will still be living.
GM.WaveIntermissionLength = 90

-- For Classic Mode
GM.WaveIntermissionLengthClassic = 20

-- Time in seconds between end round and next map.
GM.EndGameTime = 30

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 2

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("zombiesurvival/lasthuman.ogg")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("zombiesurvival/music_lose.ogg")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("zombiesurvival/music_win.ogg")

-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("music/stingers/HL1_stinger_song28.mp3")

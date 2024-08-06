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

AddCSLuaFile("cl_zombieescape.lua")
AddCSLuaFile("sh_zombieescape.lua")

include("sh_zombieescape.lua")

if not GM.ZombieEscape then return end

table.insert(GM.CleanupFilter, "func_brush")
table.insert(GM.CleanupFilter, "env_global")
table.insert(GM.CleanupFilter, "info_player_terrorist")
table.insert(GM.CleanupFilter, "info_player_counterterrorist")

-- We need to fix these important entities.
hook.Add("EntityKeyValue", "zombieescape", function(ent, key, value)
	-- The teamid for Terrorist and Counter Terrorist is different than Zombie and Human in ZS.
	if ent:GetClass() == "filter_activator_team" and not ent.ZEFix then
		if string.lower(key) == "filterteam" then
			if value == "2" then
				ent.ZEFix = tostring(TEAM_UNDEAD)
			elseif value == "3" then
				ent.ZEFix = tostring(TEAM_HUMAN)
			end
		end

		return true
	end

	-- Some maps have brushes that regenerate or set health to dumb values. We don't want them. Although this can break maps I can't think of a way to remove the output instead.
	if (ent:GetClass() == "trigger_multiple" or ent:GetClass() == "trigger_once") and string.find(string.lower(value), "%!.*%,.+%,health") then
		ent.ZEDelete = true
	end
end)

hook.Add("InitPostEntityMap", "zombieescape", function(fromze)
	for _, ent in pairs(ents.FindByClass("filter_activator_team")) do
		if ent.ZEFix then
			ent:SetKeyValue("filterteam", ent.ZEFix)
		end
	end

	for _, ent in pairs(ents.GetAll()) do
		if ent and ent.ZEDelete and ent:IsValid() then
			ent:Remove()
		end
	end

	-- Forced dynamic spawning.
	-- It'd be pretty damn boring for the zombies with it off since there's only one spawn usually.
	GAMEMODE.DynamicSpawning = true

	if not fromze then
		GAMEMODE:SetRedeemBrains(0)
		if GAMEMODE.CurrentRound <= 1 then
			GAMEMODE:SetWaveStart(CurTime() + GAMEMODE.WaveZeroLength + 30) -- 30 extra seconds for late joiners
		else
			GAMEMODE:SetWaveStart(CurTime() + GAMEMODE.ZE_FreezeTime + 5)
		end
	end
end)

hook.Add("PlayerSpawn", "zombieescape", function(pl)
	timer.Simple(0, function()
		if not pl:IsValid() then return end

		if GAMEMODE:GetWave() == 0 and not GAMEMODE:GetWaveActive() and (pl:Team() == TEAM_UNDEAD or pl:Team() == TEAM_HUMAN and CurTime() < GAMEMODE:GetWaveStart() - GAMEMODE.ZE_FreezeTime) then
			pl.ZEFreeze = true
			pl:Freeze(true)
			pl:GodEnable()
		end
	end)
end)

-- In ze_ the winning condition is when all players on the zombie team are dead at the exact same time.
-- Usually set on by a trigger_hurt that takes over the entire map.
-- So if all living zombies get killed at the same time from a trigger_hurt that did massive damage, we end the round in favor of the humans.
-- But in order to do that we have to force zombies to spawn. Which is shitty.

hook.Add("OnWaveStateChanged", "zombieescape", function()
	if GAMEMODE:GetWave() == 1 and GAMEMODE:GetWaveActive() then
		for _, pl in pairs(player.GetAll()) do
			pl:Freeze(false)
			pl:GodDisable()
		end
	end
end)

local CheckTime
local FreezeTime = true
local NextDamage = 0
hook.Add("Think", "zombieescape", function()
	if GAMEMODE:GetWave() == 0 then
		if FreezeTime and CurTime() >= GAMEMODE:GetWaveStart() - GAMEMODE.ZE_FreezeTime then
			FreezeTime = false

			game.CleanUpMap(false, GAMEMODE.CleanupFilter)
			gamemode.Call("InitPostEntityMap", true)

			for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
				pl.ZEFreeze = nil
				pl:Freeze(false)
				pl:GodDisable()
				local ent = GAMEMODE:PlayerSelectSpawn(pl)
				if IsValid(ent) then
					pl:SetPos(ent:GetPos())
				end
			end
		end

		return
	end

	FreezeTime = true

	if CurTime() >= GAMEMODE:GetWaveStart() + GAMEMODE.ZE_TimeLimit and CurTime() >= NextDamage then
		NextDamage = CurTime() + 1

		for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
			pl:TakeDamage(5)
		end
	end

	local undead = team.GetPlayers(TEAM_UNDEAD)
	if #undead == 0 then return end

	for _, pl in pairs(undead) do
		if not pl.KilledByTriggerHurt or CurTime() > pl.KilledByTriggerHurt + 12 then
			CheckTime = nil
			return
		end
	end

	CheckTime = CheckTime or (CurTime() + 2.5)

	if CheckTime and CurTime() >= CheckTime then
		gamemode.Call("EndRound", TEAM_HUMAN)
	end
end)

hook.Add("DoPlayerDeath", "zombieescape", function(pl, attacker, dmginfo)
	pl.KilledPos = pl:GetPos()

	if pl:Team() == TEAM_UNDEAD then
		if attacker:IsValid() and attacker:GetClass() == "trigger_hurt" --[[and dmginfo:GetDamage() >= 1000]] then
			pl.KilledByTriggerHurt = CurTime()
			pl.NextSpawnTime = CurTime() + 10
		elseif GAMEMODE.RoundEnded then
			pl.NextSpawnTime = CurTime() + 9999
		else
			pl.NextSpawnTime = CurTime() + 5
		end
	end
end)

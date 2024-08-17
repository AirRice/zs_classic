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

if string.sub(string.lower(game.GetMap()), 1, 3) ~= "ze_" then return end

GM.ZombieEscape = true
GM.WaveZeroLength = 90
GM.EndGameTime = 35
GM.ZE_FreezeTime = 20
GM.ZE_TimeLimit = 60 * 16

GM.DefaultZombieClass = GM.ZombieClasses["Super Zombie"].Index

local CSSWEAPONS = {"weapon_knife","weapon_glock","weapon_usp","weapon_p228","weapon_deagle",
	"weapon_elite","weapon_fiveseven","weapon_m3","weapon_xm1014","weapon_galil",
	"weapon_ak47","weapon_scout","weapon_sg552","weapon_awp","weapon_g3sg1",
	"weapon_famas","weapon_m4a1","weapon_aug","weapon_sg550","weapon_mac10",
	"weapon_tmp","weapon_mp5navy","weapon_ump45","weapon_p90","weapon_m249"}

function GM:Move(pl, move)
	if pl:Team() == TEAM_HUMAN then
		-- if pl:GetBarricadeGhosting() then
			-- move:SetMaxSpeed(36)
			-- move:SetMaxClientSpeed(36)
		-- elseif move:GetForwardSpeed() < 0 then
		if move:GetForwardSpeed() < 0 then
			move:SetMaxSpeed(move:GetMaxSpeed() * 0.9)
			move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.9)
		elseif move:GetForwardSpeed() == 0 then
			move:SetMaxSpeed(move:GetMaxSpeed() * 0.95)
			move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.95)
		end
	elseif pl:CallZombieFunction("Move", move) then
		return
	end

	local legdamage = pl:GetLegDamage()
	if legdamage > 0 then
		local scale = 1 - math.min(1, legdamage * 0.25)
		move:SetMaxSpeed(move:GetMaxSpeed() * scale)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * scale)
	end
end

function GM:GetZombieDamageScale(pos, ignore)
	return self.ZombieDamageMultiplier
end

function GM:ScalePlayerDamage(pl, hitgroup, dmginfo)
	if dmginfo:IsBulletDamage() then
		if hitgroup == HITGROUP_HEAD then
			pl.m_LastHeadShot = CurTime()
		end
	end

	if not pl:CallZombieFunction("ScalePlayerDamage", hitgroup, dmginfo) then
		if hitgroup == HITGROUP_HEAD then
			dmginfo:SetDamage(dmginfo:GetDamage() * 2)
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_GEAR then
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.25)
		elseif hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			dmginfo:SetDamage(dmginfo:GetDamage() * 0.75)
		end
	end

	if pl:Team() == TEAM_UNDEAD and self:PlayerShouldTakeDamage(pl, dmginfo:GetAttacker()) then
		pl:AddLegDamage(((hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) and 1 or 0.125) * dmginfo:GetDamage())
	end
end

-- Creates some dummy entities so we don't get spammed in the console.

local ENT = {}

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:SetNoDraw(true)
end

if SERVER then
function ENT:Think()
	self:Remove()
end
end

hook.Add("Initialize", "RegisterDummyEntities", function()
	scripted_ents.Register(ENT, "ammo_50ae")
	scripted_ents.Register(ENT, "ammo_556mm_box")
	scripted_ents.Register(ENT, "player_weaponstrip")
	
	--CSS Weapons for ZE map parenting
	for i, weapon in pairs(CSSWEAPONS) do
		weapons.Register({Base = "weapon_map_base"},weapon) 
	end
end)

hook.Add( "PlayerCanPickupWeapon", "RestrictMapWeapons", function( ply, wep )

	local weps = ply:GetWeapons()
		
	--Only allow one special weapon per player
	for k, v in pairs(weps) do
		if table.HasValue( CSSWEAPONS, v:GetClass() ) or v:GetClass()=="weapon_map_base" then return false end
	end
		
	return true
end)

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

AddCSLuaFile()

-- thanks for fixing this bug that's been there for months, garry!

-- Change this to an entity to check for to determine if our entities didn't get loaded.
local ENTITYCLASS = "prop_nail"

hook.Add("Initialize", "workshop", function()

if scripted_ents.GetStored(ENTITYCLASS) ~= nil then return end

print("Workshop version...")

local foldername = GAMEMODE.FolderName

local entitiespath = foldername.."/entities/entities/"
local effectspath = foldername.."/entities/effects/"
local weaponspath = foldername.."/entities/weapons/"

-- ENTITIES
local files, folders = file.Find(entitiespath.."*", "LUA")

for _, filename in pairs(files) do
	ENT = {}
	ENT.Folder = entitiespath
	ENT.FolderName = filename

	include(entitiespath..filename)

	scripted_ents.Register(ENT, string.StripExtension(filename))
end

for _, foldername in pairs(folders) do
	ENT = {}
	ENT.Folder = entitiespath..foldername
	ENT.FolderName = foldername

	if SERVER then
		if file.Exists(entitiespath..foldername.."/init.lua", "LUA") then
			include(entitiespath..foldername.."/init.lua")
		elseif file.Exists(entitiespath..foldername.."/shared.lua", "LUA") then
			include(entitiespath..foldername.."/shared.lua")
		end
	end

	if CLIENT then
		if file.Exists(entitiespath..foldername.."/cl_init.lua", "LUA") then
			include(entitiespath..foldername.."/cl_init.lua")
		elseif file.Exists(entitiespath..foldername.."/shared.lua", "LUA") then
			include(entitiespath..foldername.."/shared.lua")
		end
	end

	scripted_ents.Register(ENT, foldername)
end

-- EFFECTS
local files, folders = file.Find(effectspath.."*", "LUA")

for _, filename in pairs(files) do
	if SERVER then
		AddCSLuaFile(effectspath..filename)
	end
	if CLIENT then
		EFFECT = {}
		EFFECT.Folder = effectspath
		EFFECT.FolderName = filename

		include(effectspath..filename)

		effects.Register(EFFECT, string.StripExtension(filename))
	end
end

for _, foldername in pairs(folders) do
	if SERVER and file.Exists(effectspath..foldername.."/init.lua", "LUA") then
		AddCSLuaFile(effectspath..foldername.."/init.lua")
	end

	if CLIENT and file.Exists(effectspath..foldername.."/init.lua", "LUA") then
		EFFECT = {}
		EFFECT.Folder = effectspath..foldername
		EFFECT.FolderName = foldername

		include(effectspath..foldername.."/init.lua")

		effects.Register(EFFECT, foldername)
	end
end

-- WEAPONS
local files, folders = file.Find(weaponspath.."*", "LUA")

for _, filename in pairs(files) do
	SWEP = {}
	SWEP.Folder = weaponspath
	SWEP.FolderName = filename
	SWEP.Base = "weapon_base"

	SWEP.Primary = {}
	SWEP.Secondary = {}
	--[[SWEP.Primary.ClipSize		= 8
	SWEP.Primary.DefaultClip	= 32
	SWEP.Primary.Automatic		= false
	SWEP.Primary.Ammo			= "Pistol"
	SWEP.Secondary.ClipSize		= 8
	SWEP.Secondary.DefaultClip	= 32
	SWEP.Secondary.Automatic	= false
	SWEP.Secondary.Ammo			= "Pistol"]]

	include(weaponspath..filename)

	weapons.Register(SWEP, string.StripExtension(filename))
end

for _, foldername in pairs(folders) do
	SWEP = {}
	SWEP.Folder = weaponspath..foldername
	SWEP.FolderName = foldername
	SWEP.Base = "weapon_base"

	SWEP.Primary = {}
	SWEP.Secondary = {}

	if SERVER then
		if file.Exists(weaponspath..foldername.."/init.lua", "LUA") then
			include(weaponspath..foldername.."/init.lua")
		elseif file.Exists(weaponspath..foldername.."/shared.lua", "LUA") then
			include(weaponspath..foldername.."/shared.lua")
		end
	end

	if CLIENT then
		if file.Exists(weaponspath..foldername.."/cl_init.lua", "LUA") then
			include(weaponspath..foldername.."/cl_init.lua")
		elseif file.Exists(weaponspath..foldername.."/shared.lua", "LUA") then
			include(weaponspath..foldername.."/shared.lua")
		end
	end

	weapons.Register(SWEP, foldername)
end

ENT = nil
EFFECT = nil
SWEP = nil

end)
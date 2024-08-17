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
-- Translation library by William Moodhe
-- Feel free to use this in your own addons.
-- See the languages folder to add your own languages.

translate = {}

local Languages = {}
local Translations = {}
local AddingLanguage
local DefaultLanguage = "en"
local CurrentLanguage = DefaultLanguage

if CLIENT then
	-- Need to make a new convar since gmod_language isn't sent to server.
	CreateClientConVar("gmod_language_rep", "en", false, true)

	timer.Create("checklanguagechange", 1, 0, function()
		CurrentLanguage = GetConVarString("gmod_language")
		if CurrentLanguage ~= GetConVarString("gmod_language_rep") then
			-- Let server know our language changed.
			RunConsoleCommand("gmod_language_rep", CurrentLanguage)
		end
	end)
end

function translate.GetLanguages()
	return Languages
end

function translate.GetLanguageName(short)
	return Languages[short]
end

function translate.GetTranslations(short)
	return Translations[short] or Translations[DefaultLanguage]
end

function translate.AddLanguage(short, long)
	Languages[short] = long
	Translations[short] = Translations[short] or {}
	AddingLanguage = short
end

function translate.AddTranslation(id, text)
	if not AddingLanguage or not Translations[AddingLanguage] then return end

	Translations[AddingLanguage][id] = text
end

function translate.Get(id)
	return translate.GetTranslations(CurrentLanguage)[id] or translate.GetTranslations(DefaultLanguage)[id] or ("@"..id.."@")
end

function translate.Format(id, ...)
	return string.format(translate.Get(id), ...)
end

if SERVER then
	function translate.ClientGet(pl, ...)
		CurrentLanguage = pl:GetInfo("gmod_language_rep")
		return translate.Get(...)
	end

	function translate.ClientFormat(pl, ...)
		CurrentLanguage = pl:GetInfo("gmod_language_rep")
		return translate.Format(...)
	end

	function PrintTranslatedMessage(printtype, str, ...)
		for _, pl in pairs(player.GetAll()) do
			pl:PrintMessage(printtype, translate.ClientFormat(pl, str, ...))
		end
	end
end

if CLIENT then
	function translate.ClientGet(_, ...)
		return translate.Get(...)
	end
	function translate.ClientFormat(_, ...)
		return translate.Format(...)
	end
end

for i, filename in pairs(file.Find(GM.FolderName.."/gamemode/languages/*.lua", "LUA")) do
	LANGUAGE = {}
	AddCSLuaFile("languages/"..filename)
	include("languages/"..filename)
	for k, v in pairs(LANGUAGE) do
		translate.AddTranslation(k, v)
	end
	LANGUAGE = nil
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:PrintTranslatedMessage(hudprinttype, translateid, ...)
	if ... ~= nil then
		self:PrintMessage(hudprinttype, translate.ClientFormat(self, translateid, ...))
	else
		self:PrintMessage(hudprinttype, translate.ClientGet(self, translateid))
	end
end

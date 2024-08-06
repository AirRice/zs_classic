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

GM.RevertableZombieClasses = {}

function GM:IsClassUnlocked(classname)
	local classtab = self.ZombieClasses[classname]
	if not classtab then return false end

	if classtab.IsClassUnlocked then
		local ret = classtab:IsClassUnlocked()
		if ret ~= nil then return ret end
	end

	return not classtab.Locked and (classtab.Unlocked or classtab.Wave and self:GetWave() >= classtab.Wave or not self:GetWaveActive() and self:GetWave() + 1 >= classtab.Wave)
end

local function ReorderZombieClassesSort(a, b)
	if (a.Order or b.Order) and a.Order ~= b.Order then
		return (a.Order or 255) < (b.Order or 255)
	end

	if (a.Wave or b.Wave) and a.Wave ~= b.Wave then
		return (a.Wave or 255) < (b.Wave or 255)
	end

	return a.Name < b.Name
end
function GM:ReorderZombieClasses()
	table.sort(self.ZombieClasses, ReorderZombieClassesSort)
	for k, v in pairs(self.ZombieClasses) do
		if type(k) == "number" then
			self.ZombieClasses[v.Name] = v
			v.Index = k

			if v.IsDefault then
				self.DefaultZombieClass = k
			end
		end
	end
end

function GM:RegisterZombieClass(name, tab)
	local gm = GAMEMODE or GM

	if tab.Wave then tab.Wave = math.floor(tab.Wave * self:GetNumberOfWaves()) end
	table.insert(gm.ZombieClasses, tab)
	tab.Index = #gm.ZombieClasses
	if CLIENT then
		tab.Icon = tab.Icon or "zombiesurvival/killicons/genericundead"
	end

	if tab.IsDefault then
		gm.DefaultZombieClass = tab.Index
	end

	tab.TranslationName = tab.TranslationName or tab.Name

	gm.ZombieClasses[name] = tab
end

function GM:RevertZombieClasses()
	self.ZombieClasses = table.Copy(self.RevertableZombieClasses)
end

function GM:RegisterZombieClasses()
	self.ZombieClasses = {}
	self.DefaultZombieClass = self.DefaultZombieClass or 1

	local included = {}

	local classes = file.Find(self.FolderName.."/gamemode/zombieclasses/*.lua", "LUA")
	table.sort(classes)
	for i, filename in ipairs(classes) do
		AddCSLuaFile("zombieclasses/"..filename)
		CLASS = {}
		include("zombieclasses/"..filename)
		if CLASS.Name then
			self:RegisterZombieClass(CLASS.Name, CLASS)
		else
			ErrorNoHalt("CLASS "..filename.." has no 'Name' member!")
		end
		included[filename] = CLASS
		CLASS = nil
	end

	for k, v in pairs(self.ZombieClasses) do
		local base = v.Base
		if base then
			base = base..".lua"
			if included[base] then
				table.Inherit(v, included[base])
			else
				ErrorNoHalt("CLASS "..tostring(v.Name).." uses base class "..base.." but it doesn't exist!")
			end
		end

		if v.Unlocked or v.Wave == 0 then
			v.UnlockedNotify = true
		end
	end

	self:ReorderZombieClasses()

	self.RevertableZombieClasses = table.Copy(self.ZombieClasses)
end

GM:RegisterZombieClasses()

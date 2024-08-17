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
local ClientsideModel = ClientsideModel
local Color = Color
local CreateClientConVar = CreateClientConVar
local CreateConVar = CreateConVar
local CurTime = CurTime
local DamageInfo = DamageInfo
local DisableClipping = DisableClipping
local DynamicLight = DynamicLight
local EffectData = EffectData
local EmitSound = EmitSound
local EyeAngles = EyeAngles
local EyePos = EyePos
local FrameTime = FrameTime
local GetConVar = GetConVar
local GetConVarNumber = GetConVarNumber
local GetConVarString = GetConVarString
local GetGlobalAngle = GetGlobalAngle
local GetGlobalBool = GetGlobalBool
local GetGlobalEntity = GetGlobalEntity
local GetGlobalFloat = GetGlobalFloat
local GetGlobalInt = GetGlobalInt
local GetGlobalString = GetGlobalString
local GetGlobalVector = GetGlobalVector
local ipairs = ipairs
local isnumber = isnumber
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local LocalToWorld = LocalToWorld
local Material = Material
local Matrix = Matrix
local pairs = pairs
local ParticleEmitter = ParticleEmitter
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
local tostring = tostring
local type = type
local unpack = unpack
local Vector = Vector
local VectorRand = VectorRand




AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	self:RecalculateValidity()

	local owner = self:GetOwner()
	if not (owner:IsValid() and owner:GetActiveWeapon():IsValid() and owner:GetActiveWeapon():GetClass() == self.GhostWeapon) then
		self:Remove()
	end
end

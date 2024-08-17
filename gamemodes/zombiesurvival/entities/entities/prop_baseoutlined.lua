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




AddCSLuaFile()

ENT.Type = "anim"

if not CLIENT then return end

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.ColorModulation = Color(1, 0.5, 1)
ENT.Seed = 0

function ENT:Initialize()
	self.Seed = math.Rand(0, 10)
end

local matWireframe = Material("models/wireframe")
local matWhite = Material("models/debug/debugwhite")
function ENT:DrawTranslucent()
	if not MySelf:IsValid() or MySelf:Team() ~= TEAM_HUMAN then
		self:DrawModel()
		return
	end

	local time = (CurTime() * 1.5 + self.Seed) % 2

	self:DrawModel()

	if time <= 1 and EyePos():Distance(self:GetPos()) <= 1024 then
		self.NoDrawSubModels = true

		local oldscale = self:GetModelScale()
		local normal = self:GetUp()
		local rnormal = normal * -1
		local mins = self:OBBMins()
		local dist = self:OBBMaxs().z - mins.z
		mins.x = 0
		mins.y = 0
		local pos = self:LocalToWorld(mins)

		self:SetModelScale(oldscale * 1.01, 0)

		if render.SupportsVertexShaders_2_0() then
			render.EnableClipping(true)
			render.PushCustomClipPlane(normal, normal:Dot(pos + dist * time * normal))
			render.PushCustomClipPlane(rnormal, rnormal:Dot(pos + dist * time * 1.25 * normal))
		end

		render.SetColorModulation(self.ColorModulation.r, self.ColorModulation.g, self.ColorModulation.b)
		render.SuppressEngineLighting(true)

		render.SetBlend(0.15)
		render.ModelMaterialOverride(matWhite)
		self:DrawModel()

		render.SetBlend(0.4)
		render.ModelMaterialOverride(matWireframe)
		self:DrawModel()

		render.ModelMaterialOverride(0)
		render.SuppressEngineLighting(false)
		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)

		if render.SupportsVertexShaders_2_0() then
			render.PopCustomClipPlane()
			render.PopCustomClipPlane()
			render.EnableClipping(false)
		end
		self:SetModelScale(oldscale, 0)

		self.NoDrawSubModels = false
	end
end

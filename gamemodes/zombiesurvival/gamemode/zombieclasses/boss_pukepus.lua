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


CLASS.Name = "Puke Pus"
CLASS.TranslationName = "class_pukepus"
CLASS.Description = "description_pukepus"
CLASS.Help = "controls_pukepus"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true

CLASS.FearPerInstance = 1

CLASS.Health = 2750
CLASS.SWEP = "weapon_zs_pukepus"

CLASS.Model = Model("models/Zombie/Poison.mdl")

CLASS.Speed = 120
CLASS.Points = 30

CLASS.PainSounds = {"NPC_PoisonZombie.Pain"}
CLASS.DeathSounds = {Sound("npc/zombie_poison/pz_call1.wav")}

CLASS.VoicePitch = 0.5

CLASS.ModelScale = 1.5
-- CLASS.ClientsideModelScale = 1.5
CLASS.Mass = 200
CLASS.ViewOffset = Vector(0, 0, 75)
CLASS.ViewOffsetDucked = Vector(0, 0, 48)
CLASS.StepSize = 25
CLASS.Hull = {Vector(-22, -22, 0), Vector(22, 22, 96)}
CLASS.HullDuck = {Vector(-22, -22, 0), Vector(22, 22, 58)}

CLASS.JumpPower = 225

local ACT_IDLE = ACT_IDLE
local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2D() <= 0.5 then
		pl.CalcIdeal = ACT_IDLE
	else
		pl.CalcSeqOverride = 2
	end

	return true
end

local mathrandom = math.random
local StepSounds = {
	"npc/zombie_poison/pz_left_foot1.wav"
}
local ScuffSounds = {
	"npc/zombie_poison/pz_right_foot1.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and mathrandom() < 0.333 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 80, 90)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 80, 90)
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return (365 - pl:GetVelocity():Length()) * 1.5
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 450
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 600
	end

	return 200
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.5, 3))
	else
		pl:SetPlaybackRate(0.5)
	end

	return true
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("pukepusambience")
	end
end

local BonesToZero = {
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32"
}
function CLASS:BuildBonePositions(pl)
	for _, bone in pairs(BonesToZero) do
		local boneid = pl:LookupBone(bone)
		if boneid and boneid > 0 then
			pl:ManipulateBoneScale(boneid, vector_tiny)
		end
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/pukepus"

local matSkin = Material("Models/Barnacle/barnacle_sheet")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
end

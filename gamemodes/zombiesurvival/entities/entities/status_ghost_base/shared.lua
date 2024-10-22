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




ENT.Type = "anim"
ENT.Base = "status__base"

ENT.GhostModel = Model("models/Combine_turrets/Floor_turret.mdl")
ENT.GhostRotation = Angle(270, 0, 0)
ENT.GhostEntity = "prop_gunturret"
ENT.GhostWeapon = "weapon_zs_gunturret"
ENT.GhostDistance = 64
ENT.GhostFlatGround = true
ENT.GhostRotateFunction = "Up"

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetMaterial("models/wireframe") --self:SetMaterial("models/debug/debugwhite")
	self:SetModel(self.GhostModel)

	self:RecalculateValidity()
end

function ENT:IsInsideProp()
	for _, ent in pairs(ents.FindInBox(self:WorldSpaceAABB())) do
		if ent and ent ~= self and ent:IsValid() and ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:GetSolid() > 0 then return true end
	end

	return false
end

-- TODO: Rewrite this so it sets pos before the validation...
function ENT:RecalculateValidity()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	if SERVER or MySelf == owner then
		self:SetRotation(math.NormalizeAngle(owner:GetInfoNum("_zs_ghostrotation", 0)))
	end

	local rotation = self.GhostNoRotation and 0 or self:GetRotation()
	local eyeangles = owner:EyeAngles()
	local shootpos = owner:GetShootPos()
	local entity
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + owner:GetAimVector() * 48, mask = MASK_SOLID, filter = owner})

	if tr.HitWorld and not tr.HitSky or tr.HitNonWorld and self.GhostPlaceOnEntities then
		if self.GhostHitNormalOffset then
			tr.HitPos = tr.HitPos + tr.HitNormal * self.GhostHitNormalOffset
		end

		local rot = self.GhostRotation
		eyeangles = tr.HitNormal:Angle()
		eyeangles:RotateAroundAxis(eyeangles:Right(), rot.pitch)
		eyeangles:RotateAroundAxis(eyeangles:Up(), rot.yaw)
		eyeangles:RotateAroundAxis(eyeangles:Forward(), rot.roll)

		local valid = true
		if self.GhostLimitedNormal and tr.HitNormal.z < self.GhostLimitedNormal or self:IsInsideProp() then
			valid = false
		elseif self.GhostDistance then
			for _, ent in pairs(ents.FindInSphere(tr.HitPos, self.GhostDistance)) do
				if ent and ent:IsValid() and ent:GetClass() == self.GhostEntity then
					valid = false
					break
				end
			end
		end

		if valid and self.GhostFlatGround and math.abs(tr.HitNormal.z) < 0.75 then
			local start = tr.HitPos + tr.HitNormal
			if not util.TraceLine({start = start, endpos = start + Vector(0, 0, -128), mask = MASK_SOLID_BRUSHONLY}).Hit then
				valid = false
			end
		end

		if valid and SERVER and GAMEMODE:EntityWouldBlockSpawn(self) then -- This isn't predicted but why would they be in the zombie spawn...
			valid = false
		end

		if valid then
			valid = self:CustomValidate(tr)
		end

		entity = tr.Entity

		self:SetValidPlacement(valid)
	else
		self:SetValidPlacement(false)
	end

	if tr.HitNormal.z >= 0.75 then
		eyeangles:RotateAroundAxis(eyeangles[self.GhostRotateFunction](eyeangles), owner:GetAngles().yaw + rotation)
	else
		eyeangles:RotateAroundAxis(eyeangles[self.GhostRotateFunction](eyeangles), rotation)
	end

	local pos, ang = tr.HitPos, eyeangles
	self:SetPos(pos)
	self:SetAngles(ang)

	return pos, ang, entity
end

function ENT:CustomValidate(tr)
	return true
end

function ENT:GetValidPlacement()
	return self:GetDTBool(0)
end

function ENT:SetValidPlacement(onoff)
	self:SetDTBool(0, onoff)
end

function ENT:GetRotation()
	return self:GetDTFloat(0)
end

function ENT:SetRotation(rotation)
	self:SetDTFloat(0, rotation)
end

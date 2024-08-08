AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status_ghost_base"

ENT.GhostModel = Model("models/mine/floodlight.mdl")
ENT.GhostRotation = Angle(90, 0, 0)
ENT.GhostHitNormalOffset = 0
ENT.GhostEntity = "prop_mine"
ENT.GhostWeapon = "weapon_zs_miner"
ENT.GhostDistance = 75
ENT.GhostLimitedNormal = -1

if SERVER then
	function ENT:Initialize()
		self:DrawShadow(false)
		self:SetMaterial("models/wireframe") --self:SetMaterial("models/debug/debugwhite")
		self:SetModel(self.GhostModel)
		self:SetModelScale(0.75)
		self:RecalculateValidity()
	end
end
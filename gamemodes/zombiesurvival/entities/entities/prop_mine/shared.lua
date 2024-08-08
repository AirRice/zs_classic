ENT.Type = "anim"

ENT.SearchRadius = 150
ENT.ExplodeRadius = 225
ENT.ExplodeTimeout = 0.8
ENT.MinDamage = 9
ENT.MaxDamage = 800
ENT.InitTimeout = 1.5

ENT.IsBarricadeObject = true
function ENT:SetupDataTables()
	-- self:NetworkVar("Bool", 0, "Died")
	self:NetworkVar("Float", 0, "ObjectHealth")
	self:NetworkVar("Float", 1, "MaxObjectHealth")
	self:NetworkVar("Float", 2, "StartExplosion")
	self:NetworkVar("Bool", 0, "Active")
	
	self:SetStartExplosion(-1)
end
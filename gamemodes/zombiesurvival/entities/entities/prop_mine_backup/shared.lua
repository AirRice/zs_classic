ENT.Type = "anim"

ENT.IsBarricadeObject = true
function ENT:SetupDataTables()
	-- self:NetworkVar("Bool", 0, "Died")
	self:NetworkVar("Float", 0, "ObjectHealth")
	self:NetworkVar("Float", 1, "MaxObjectHealth")
end
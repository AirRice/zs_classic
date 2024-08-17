ENT.Type = "anim"
ENT.m_IsProjectile = true

function ENT:ShouldNotCollide(ent)
	return ent:IsPlayer() and ent:Team() == TEAM_UNDEAD
end

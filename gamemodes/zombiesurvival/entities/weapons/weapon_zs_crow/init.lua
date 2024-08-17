AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Deploy()
	self.Owner.SkipCrow = true
	return true
end

function SWEP:Holster()
	local owner = self.Owner
	if owner:IsValid() then
		owner:StopSound("NPC_Crow.Flap")
		owner:SetAllowFullRotation(false)
	end
end
SWEP.OnRemove = SWEP.Holster

function SWEP:PhoenixExplode()
	local owner = self.Owner

	owner.PhoenixInfo.Wave = GAMEMODE:GetWave()
	owner.PhoenixInfo.Round = GAMEMODE.CurrentRound
	
	local epicenter = self:LocalToWorld(self:OBBCenter())
	local radius = self.ExplodeRadius or 180
	
	local filter = { self, owner }
	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		if ent and ent:IsValid() then
			if (ent:IsPlayer() and ent:Team() == TEAM_ZOMBIE) then
				continue
			end
			
			local nearest = ent:NearestPoint(epicenter)
			if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
				ent:TakeSpecialDamage(((radius - nearest:Distance(epicenter)) / radius) * 4, DMG_BULLET, self.Owner, self, nearest)
			end
		end
	end
	
	local ed = EffectData()
	ed:SetOrigin(self:GetPos())
	util.Effect("explosion", ed)
	
	owner:SendLua(
		"local ed = EffectData()\n" ..
		"ed:SetOrigin(MySelf:GetPos())\n" ..
		"util.Effect(\"explosion\", ed)"
	)
	owner:Kill()
end

function SWEP:Think()
	local owner = self.Owner

	if owner:KeyDown(IN_WALK) then
		owner:TrySpawnAsGoreChild()
		return
	end

	local fullrot = not owner:OnGround()
	if owner:GetAllowFullRotation() ~= fullrot then
		owner:SetAllowFullRotation(fullrot)
	end

	if owner:IsOnGround() or not owner:KeyDown(IN_JUMP) or not owner:KeyDown(IN_FORWARD) then
		if self.PlayFlap then
			owner:StopSound("NPC_Crow.Flap")
			self.PlayFlap = nil
		end
	else
		if not self.PlayFlap then
			owner:EmitSound("NPC_Crow.Flap")
			self.PlayFlap = true
		end
	end
	
	if (owner:KeyDown(IN_USE)) then
		if (!owner.PhoenixInfo) then
			owner.PhoenixInfo = 
			{
				Wave = 0,
				Round = GAMEMODE.CurrentRound
			}
		end
		
		if (owner.PhoenixInfo.Round < GAMEMODE.CurrentRound) then
			owner.PhoenixInfo.Wave = GAMEMODE:GetWave() - 1
		end
		
		if (owner.PhoenixInfo.Wave < GAMEMODE:GetWave() and owner.PhoenixInfo.Round <= GAMEMODE.CurrentRound) then
			self:PhoenixExplode()
		end
	end

	local peckend = self:GetPeckEndTime()
	if peckend == 0 or CurTime() < peckend then return end
	self:SetPeckEndTime(0)

	local trace = owner:TraceLine(14, MASK_SOLID)
	local ent = NULL
	if trace.Entity then
		ent = trace.Entity
	end

	owner:ResetSpeed()

	if ent:IsValid() then
		if ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and ent:Alive() and ent:GetZombieClassTable().Name == "Crow" then
			ent:TakeSpecialDamage(2, DMG_SLASH, owner, self)
		elseif ent:IsNailed() or ent.IsBarricadeObject then
			ent:TakeSpecialDamage(math.random(2, 6), DMG_SLASH, owner, self, trace.HitPos + Vector(0, 0, 10))
		end
	end
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or not self.Owner:IsOnGround() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:EmitSound("NPC_Crow.Squawk")
	self.Owner.EatAnim = CurTime() + 2

	self:SetPeckEndTime(CurTime() + 1)

	self.Owner:SetSpeed(1)
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 1.6)

	self.Owner:EmitSound("NPC_Crow.Alert")
end

function SWEP:Reload()
	self:SecondaryAttack()
	return false
end

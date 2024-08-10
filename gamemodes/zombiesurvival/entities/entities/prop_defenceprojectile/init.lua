AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function RefreshTwisterOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_twister")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "Twister.PlayerDisconnected", RefreshTwisterOwners)
hook.Add("OnPlayerChangedTeam", "Twister.OnPlayerChangedTeam", RefreshTwisterOwners)

function ENT:Initialize()
	self:SetModel("models/roller.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:SetMaxObjectHealth(self.MaxHealth)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true
		
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("explosion", ed)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:SetObjectHealth(self:GetObjectHealth() - math.max(1, dmginfo:GetDamage() / 8))
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:PhysicsCollide(data, collider)
	if (IsValid(data.HitEntity)) then
		local ent = data.HitEntity
		if (ent:IsProjectile() and !ent.IgnoreProjDefense and ent.__Twister = self) then
			ent:Remove()
			self:SetObjectHealth(math.max(self:GetObjectHealth() - self:GetMaxObjectHealth() * (ent.TwisterDamagePercentage or self.DamagePercentage), 0))
		end
	end
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_twister")
	pl:GiveAmmo(1, "twister")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:DefenceProjectiles()
	local center = self:LocalToWorld(self:OBBCenter())
	local curTime = CurTime()
	if self.LastAttack + self.AttackCooldown >= curTime then return end
	local projs = {}
	local attacked = 0

	local allent = ents.FindInSphere(center, self.SearchRadius)
		
	-- local sz = 7
	-- td.mins = Vector(-sz, -sz, -sz)
	-- td.maxs = Vector(sz, sz, sz)
	table.Add(td.filter, player.GetAll())
	table.Add(td.filter, game.GetWorld())
	td.mask = MASK_SHOT
	
	for _, ent in pairs(allent) do
		if (attacked >= self.AttackLimit) then
			break
		end

		if (ent != self and ent:IsProjectile() and !ent.IgnoreProjDefense) and
		(TrueVisibleFilters(center, ent:GetPos(), self, ent, self.Owner)) and
		(!ent.__Twister or ent.__Twister == nil or !IsValid(ent.__Twister) or ent.__Twister == self) then
			ent.__Twister = self
			
			self:Attack(ent)
			
			attacked = attacked + 1
		end
	end
	
	if (attacked > 0) then
		self.LastAttack = curTime
	end

	end
end

function ENT:Attack(proj)
	if !IsValid(proj) then return end
	local phys = proj:GetPhysicsObject()
	local projcenter = proj:GetPos()
	local center = self:LocalToWorld(self:OBBCenter())
	local angvec = (center - proj:GetPos()):GetNormal()
	local mul = 1 - (center:Distance(projcenter) / self.SearchRadius)
	if (IsValid(phys)) then
		phys:EnableMotion(true)
		proj.OriginalGravity = phys:IsGravityEnabled()
		phys:EnableGravity(false)
		phys:SetVelocityInstantaneous(Vector(0, 0, 0))
		phys:AddVelocity((center - projcenter):GetNormal() * (math.max(self.Gravity * mul, self.MinGravity)))
		phys:AddAngleVelocity(angvec * math.max(self.Gravity * mul, self.MinGravity))
	else
		proj:Remove()
	end

	local percentage = self.DragPercentage
	
	if (proj.TwisterDamagePercentage and proj.TwisterDamagePercentage > 0) then
		percentage = proj.TwisterDamagePercentage * 0.05
	end
	
	self:SetObjectHealth(math.max(self:GetObjectHealth() - self:GetMaxObjectHealth() * percentage, 1))
	
	local e = EffectData()
		e:SetOrigin(proj:GetPos())
		e:SetEntity(self)
	util.Effect("twister_attack", ed)
	local e = EffectData()
		e:SetOrigin(self:GetPos())
		e:SetScale(v:GetPos():Distance(self:GetPos()))
	util.Effect("defenceprojectile", e)
end


function ENT:Think()
	local curTime = CurTime()
	self:DefenceProjectiles()

	if self.Destroyed then
		self:Remove()
	elseif self.Close and curTime >= self.Close then
		self.Close = nil
		self:ResetSequence("open")
		self:EmitSound("items/ammocrate_close.wav")
	end
	
end
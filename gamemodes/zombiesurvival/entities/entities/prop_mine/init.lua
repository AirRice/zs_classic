resource.AddFile("sound/weapons/c4/c4_click.wav")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

resource.AddFile("models/mine/floodlight.mdl")

include("shared.lua")

ENT.InitTime = 0

function ENT:Initialize()
	self:SetModel("models/mine/floodlight.mdl")
	self:SetModelScale(0.75)
	self.DieTime = CurTime() + 300
	self:ManipulateBoneScale(0, Vector(0.75, 0.75, 0.75))
	self.InitTime = CurTime()
	
	self:PhysicsInit(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
	
	self:SetMaxObjectHealth(35)
	self:SetObjectHealth(35)
end

function ENT:Think()
	local expltime = self:GetStartExplosion() 
	local owner = self:GetOwner()
	if (expltime < 0) then
		if (!IsValid(owner)) then
			self:Explode()
		end

		if (!self.DieTime or self.DieTime <= CurTime()) then
			self:Explode()
		end
		
		if (self:GetObjectHealth() <= 0) then
			self:Explode(true)
		end
		
		if (owner:Team() == TEAM_ZOMBIE) then
			self:Explode()
		end
		
		if (self.InitTime + self.InitTimeout > CurTime()) then
			return
		elseif (!self:GetActive()) then
			self:SetActive(true)
		end
		
		local forward = self:GetAngles():Forward()
		local right = self:GetAngles():Right()
		local up = self:GetAngles():Up()
		local startpos = self:GetPos()
		
		-- local lines = {}
		-- for i = 1, 40 do
			-- table.insert(lines, startpos + forward * 150 + right * math.Rand(-1, 1) * 150 + up * math.Rand(-1, 1) * 150)
		-- end
		
		-- local owner = self:GetOwner()
		
		-- local td = {}
		
		-- td.start = startpos
		-- td.mask = MASK_SHOT
		-- td.filter = {}
		
		-- table.Add(td.filter, {owner})
		-- table.Add(td.filter, {owner:GetActiveWeapon()})
		-- table.Add(td.filter, team.GetPlayers(owner:Team()))
		
		-- for i, v in pairs(lines) do
			-- td.endpos = v
			
			-- table.Add(td.filter, {self})
			
			-- local tr = util.TraceLine(td)
			
			-- if (tr.Hit) then
				-- local target = tr.Entity
				-- table.Add(td.filter, {target})
				
				-- if (IsValid(target) and target:IsPlayer() and target:Team() == TEAM_ZOMBIE and target:Alive()) then
					-- if (target:GetZombieClassTable().Name == "Wraith") then
						-- if (target:GetVelocity():Length() < 80) then
							-- return
						-- end
					-- end
					-- timer.Simple(0, function()
						-- self:Explode()
					-- end)
				-- end
			-- end
		-- end
		
		local zombies = self:GetRangedZombies(startpos)
		
		if (zombies and table.Count(zombies) > 0) then
			self:Explode(false, zombies)
		end
	else
		if (expltime + self.ExplodeTimeout <= CurTime()) then
			self:_Explode()
		end
	end
end

function ENT:_Explode() 
	local ed = EffectData()
	
	ed:SetOrigin(self:GetPos())
	
	ed:SetMagnitude(1)
	
	util.Effect("explosion", ed)
	
	local owner = self:GetOwner()
	if (!IsValid(owner)) then
		return
	end
	
	local forward = self:GetAngles():Forward()
	local right = self:GetAngles():Right()
	local up = self:GetAngles():Up()
	local startpos = self:GetPos()
	
	local zombies = self.zombies
	local byAttack = self.byAttack
	
	zombies = self:GetRangedZombies(nil, self.ExplodeRadius)
	
	-- if (table.Count(zombies) <= 0) then
		-- self:Remove()
		-- return
	-- end
	
	local owner = self:GetOwner()
	if (!IsValid(owner)) then
		self:Remove()
		return
	end
	
	for _, v in pairs(zombies) do	
		local targetpos = v:GetPos()
		local startpos = self:GetPos()
		local dist = targetpos:Distance(startpos)
		local ratio = 1 - dist / self.ExplodeRadius
		
		local hit = false
		
		local td = {}
		td.start = startpos
		td.endpos = v:GetPos()
		td.filter = {}
		td.mask = MASK_SHOT
		
		table.Add(td.filter, {owner})
		table.Add(td.filter, {self})
		table.Add(td.filter, team.GetPlayers(owner:Team()))
		table.Add(td.filter, ents.FindByClass("prop_mine"))
		
		local tr = util.TraceLine(td)
		
		local hit = tr.Hit
	
		if (!hit) then
			local b = false
			for i = 0, v:GetHitBoxGroupCount() - 1 do
				for j = 0, v:GetHitBoxCount(i) - 1 do
					local bone = v:GetHitBoxBone(j, i)
					td.endpos = v:GetBonePosition(bone)
					tr = util.TraceLine(td)
					if (tr.Hit and tr.Entity == v) then
						b = true
						hit = true
						break
					end
				end
				if (b) then
					break
				end
			end
		end
		
		if (!hit) then
			continue
		end
		
		local damage = math.Clamp(self.MaxDamage * ratio, self.MinDamage, self.MaxDamage)
		
		damage = damage * ratio
	
		local byZombie = false
		if (self.byZombie and CurTime() - self.byZombie <= self.ExplodeTimeout * 1.2) then
			byZombie = true
		else
			byZombie = false
		end
	
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(owner)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamage(damage * ((byAttack and byZombie or false) and 0.3 or 1))
		dmginfo:SetDamagePosition(targetpos)
		dmginfo:SetDamageType(DMG_SLASH)
		v:TakeDamageInfo(dmginfo)
	end
	
	self:Remove()
end

function ENT:GetRangedZombies(startpos, dist)
	local owner = self:GetOwner()
	
	if (!IsValid(owner)) then
		return {}
	end

	if (!dist) then
		dist = self.SearchRadius
	end

	if (!startpos) then
		startpos = self:GetPos()
	end

	local _ents = ents.FindInSphere(startpos, dist)

	local zombies = {}
	
	for i, v in pairs(_ents) do
		if (!IsValid(v) or !v:IsPlayer() or v:Team() != TEAM_ZOMBIE or !v:Alive()) then
		-- if (v != hs()) then
			continue
		end
		
		local entpos = v:GetPos()
		local diff = entpos - startpos
		local diffang = diff:Angle()
		local selfang = self:GetAngles():Forward():Angle()
		local targetang = diffang - selfang
		local targetangnormal = Angle(targetang.pitch, targetang.yaw, targetang.roll)
		targetangnormal:Normalize()
		
		if (targetangnormal.yaw >= -90 and targetangnormal.yaw <= 90) then			
			local td = {}
			td.start = startpos
			td.endpos = v:GetPos()
			td.filter = {}
			td.mask = MASK_SHOT
			
			table.Add(td.filter, {owner})
			table.Add(td.filter, {self})
			table.Add(td.filter, team.GetPlayers(owner:Team()))
			table.Add(td.filter, ents.FindByClass("prop_mine"))
			
			local tr = util.TraceLine(td)
			
			local hit = tr.Hit
		
			if (!hit) then
				local b = false
				for i = 0, v:GetHitBoxGroupCount() - 1 do
					for j = 0, v:GetHitBoxCount(i) - 1 do
						local bone = v:GetHitBoxBone(j, i)
						td.endpos = v:GetBonePosition(bone)
						tr = util.TraceLine(td)
						if (tr.Hit and tr.Entity == v) then
							b = true
							hit = true
							break
						end
					end
					if (b) then
						break
					end
				end
			end
			
			if (!hit) then
				continue
			end
			
			table.Add(zombies, {v})
		end
	end
	
	return zombies
end

function ENT:Explode(byAttack, zombies)
	if (self:GetStartExplosion() > 0) then
		return
	else
		if (!zombies) then
			zombies = self:GetRangedZombies()
		end
		
		for _, v in pairs(zombies) do
			local zc = v:GetZombieClassTable()
			local zcname = zc.Name
			
			if (zcname == "Wraith" and v:GetVelocity():Length() < 80) then
				continue
			end
			
			self:SetStartExplosion(CurTime())
		end
	
		if (byAttack) then
			self:SetStartExplosion(CurTime())
		end
		
		self.byAttack = byAttack
		self.zombies = zombies
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if ((IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_ZOMBIE) or (attacker == self:GetOwner())) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
		if (attacker:Team() == TEAM_ZOMBIE) then
			self.byZombie = CurTime()
			self.byAttack = true
			self:Explode()
		else
			self.byAttack = true
			self.byZombie = 0
			self:Explode()
		end
	end
end
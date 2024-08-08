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
	if (self.InitTime + 1.5 > CurTime()) then
		return
	end

	if (!IsValid(self:GetOwner())) then
		self:Explode()
	end

	if (!self.DieTime or self.DieTime <= CurTime()) then
		self:Explode()
	end
	
	if (self:GetObjectHealth() <= 0) then
		self:Explode()
	end
	
	if (self:GetOwner():Team() == TEAM_ZOMBIE) then
		self:Explode()
	end
	
	local forward = self:GetAngles():Forward()
	local right = self:GetAngles():Right()
	local up = self:GetAngles():Up()
	local startpos = self:GetPos()
	
	local lines = {}
	for i = 1, 40 do
		table.insert(lines, startpos + forward * 150 + right * math.Rand(-1, 1) * 150 + up * math.Rand(-1, 1) * 150)
	end
	
	local owner = self:GetOwner()
	
	local td = {}
	
	td.start = startpos
	td.mask = MASK_SHOT
	td.filter = {}
	
	table.Add(td.filter, {owner})
	table.Add(td.filter, {owner:GetActiveWeapon()})
	table.Add(td.filter, team.GetPlayers(owner:Team()))
	
	for i, v in pairs(lines) do
		td.endpos = v
		-- td.ignoreworld = true
		
		table.Add(td.filter, {self})
		
		-- if (IsValid(owner)) then
		-- end
		
		local tr = util.TraceLine(td)
		
		if (tr.Hit) then
			local target = tr.Entity
			table.Add(td.filter, {target})
			
			-- PrintMessage(3, tostring(target))
			
			if (IsValid(target) and target:IsPlayer() and target:Team() == TEAM_ZOMBIE and target:Alive()) then
				if (target:GetZombieClassTable().Name == "Wraith") then
					if (target:GetVelocity():Length() < 80) then
						return
					end
				end
				timer.Simple(0, function()
					self:Explode()
				end)
			end
		end
	end
end

function ENT:Explode()
	local ed = EffectData()
	
	ed:SetOrigin(self:GetPos())
	
	ed:SetMagnitude(1)
	
	util.Effect("explosion", ed)
	
	local forward = self:GetAngles():Forward()
	local right = self:GetAngles():Right()
	local up = self:GetAngles():Up()
	local startpos = self:GetPos()
	
	local lines = {}
	for i = 1, 800 do
		table.insert(lines, startpos + forward * 450 + right * math.Rand(-1, 1) * 450 + up * math.Rand(-1, 1) * 450)
	end
	
	local owner = self:GetOwner()
	
	local td = {}
	
	td.start = startpos
	td.mask = MASK_SHOT
	td.filter = {}
	
	table.Add(td.filter, {self})
	table.Add(td.filter, {owner})
	table.Add(td.filter, {owner:GetActiveWeapon()})
	table.Add(td.filter, team.GetPlayers(owner:Team()))
	
	-- local hitCount = 0
	
	for i, v in pairs(lines) do
		td.endpos = v
		-- td.ignoreworld = true
		
		
		-- if (IsValid(owner)) then
		-- table.insert(td.filter, owner)
		-- table.insert(td.filter, owner:GetActiveWeapon())
		-- table.insert(td.filter, team.GetPlayers(owner:Team()))
		-- end
		
		local tr = util.TraceLine(td)
		
		if (tr.Hit) then
			local target = tr.Entity
			-- table.Add(td.filter, {target})
			if (IsValid(target) and target:IsPlayer() and target:Team() == TEAM_ZOMBIE and target:Alive() and target != owner) then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(9)
				dmginfo:SetDamageType(DMG_BLAST)
				target:TakeDamageInfo(dmginfo)
				-- target:SetVelocity((target:GetPos() - v):GetNormal() * 300)
				-- hitCount = hitCount + 1
				-- PrintMessage(3, tostring(hitCount))
			elseif (IsValid(target) and target:GetClass() == "prop_physics") then
				target:TakeDamage(1, owner, self)
			elseif (IsValid(target) and target:IsPlayer() and target:Team() == TEAM_HUMAN) then
				if (math.random(1, 10) <= 1) then
					target:TakeDamage(1, owner, self)
				end
			end
		end
	end

	-- self:SetDied(true)
	
	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if ((IsValid(attacker) and attacker:IsPlayer() and attacker:Team() == TEAM_ZOMBIE) or (attacker == self:GetOwner())) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end
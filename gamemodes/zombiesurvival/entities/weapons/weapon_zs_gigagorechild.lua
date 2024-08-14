AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeReach = 100
SWEP.MeleeDamage = 30
SWEP.MeleeForceScale = 2
SWEP.MeleeSize = 3
SWEP.MeleeDamageType = DMG_SLASH
SWEP.Primary.Delay = 1.7
SWEP.Secondary.Delay = 3
SWEP.RoarDelay = 14
SWEP.SmashRadius = 256
SWEP.ThrowDelay = 1
SWEP.RoarStartDelay = 1.5
SWEP.NextRoar = 0
SWEP.RoarStartHealth = 0;
function SWEP:SetupDataTables()
	self:NetworkVar("Float", 3, "ThrowTime")
	self:NetworkVar("Float", 4, "RoarTime")
end

function SWEP:Think()
	self:CheckMeleeAttack()
	self:CheckThrow()
	self:CheckRoar()
end

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsValid() and ent:IsPlayer() then
		local vel = ent:GetPos() - self.Owner:GetPos()
		vel.z = 0
		vel:Normalize()
		vel = vel * 400
		vel.z = 200

		ent:KnockDown(1.1)
		ent:SetGroundEntity(NULL)
		ent:SetVelocity(vel)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end

function SWEP:PrimaryAttack()
	if self:IsThrowing() then return end
	if self:IsRoaring() then return end
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	if self:IsSwinging() or CurTime() <= self:GetNextSecondaryAttack() or IsValid(self.Owner.FeignDeath) then return end
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self:SetThrowTime(CurTime() + self.ThrowDelay)
	local owner = self:GetOwner()
	owner:DoReloadEvent() -- Handled in the class file. Fires the throwing anim.
	self:SetNextSecondaryAttack(CurTime() + self.Secondary.Delay)
end

function SWEP:DoRoar()
	local owner = self.Owner
	owner:SetLegDamage(20)
	owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
	self.RoarStartHealth = owner:Health()
	owner:EmitSound("npc/stalker/go_alert2a.wav", 500, 65)
	self:SetRoarTime(CurTime() + self.RoarStartDelay)
end

function SWEP:CheckRoar()
	local owner = self.Owner
	if self:IsRoaring() and CurTime() >= self:GetRoarTime() then
		self:SetRoarTime(0)
		if not (owner:IsValid() and owner:IsPlayer() and owner:Alive()) then return end
		if (self.RoarStartHealth - owner:Health() >= 50) then
			owner:EmitSound("ambient/creatures/town_child_scream1.wav", 100, math.random(85, 95))
			return
		else
			owner:EmitSound("npc/env_headcrabcanister/explosion.wav", 100,math.random(85,95))
			owner:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 400, math.random(65,95))
			local effectdata = EffectData()
				effectdata:SetOrigin(owner:GetPos())
			util.Effect("gigagoresmashdust", effectdata, true)
			util.ScreenShake( owner:GetPos(), 50, 20, 0.75, 800 )
			local center = owner:GetPos()
			for _,pl in pairs(ents.FindInSphere(center, self.SmashRadius)) do
				if IsValid(pl) then
					local plpos = pl:GetPos()
					if WorldVisible(plpos, center) then
						if pl != owner and pl:IsPlayer() and pl:Team() == TEAM_SURVIVORS then
							local perc = 1-((plpos:Distance(center))/self.SmashRadius)*0.75
							pl:KnockDown(1+2*perc)
							pl:SetGroundEntity(NULL)	
							pl:ThrowFromPositionSetZ(center, perc * 256, 0.75, false)
							pl:ViewPunch(Angle(-40, 0, math.Rand(-20, 20)))
						elseif pl:IsNailed() then
							pl:TakeSpecialDamage(math.random(25,45), DMG_CLUB, owner, self)
						end
					end
				end
			end
		end
	end
end

function SWEP:CheckThrow()
	if self:IsThrowing() and CurTime() >= self:GetThrowTime() then
		self:SetThrowTime(0)

		local owner = self.Owner

		owner:EmitSound("weapons/slam/throw.wav", 70, math.random(78, 82))

		if SERVER then
			local ent = ents.Create("prop_thrownbaby")
			if ent:IsValid() then
				ent:SetPos(owner:GetShootPos())
				ent:SetAngles(AngleRand())
				ent:SetOwner(owner)
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetVelocityInstantaneous(owner:GetAimVector() * 500)
					phys:AddAngleVelocity(VectorRand() * math.Rand(200, 300))

					ent:SetPhysicsAttacker(owner)
				end
			end

		end
	end
end
function SWEP:IsRoaring()
	return self:GetRoarTime() > 0
end
function SWEP:IsThrowing()
	return self:GetThrowTime() > 0
end
SWEP.GetThrowing = SWEP.IsThrowing

function SWEP:Reload()
	--if CLIENT then return end
	if CurTime() < self.NextRoar then return end
	self.NextRoar = CurTime() + self.RoarDelay
	self:DoRoar()
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("ambient/creatures/teddy.wav", 77, 45)
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("ambient/creatures/teddy.wav", 77, 60)
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("ambient/creatures/teddy.wav", 77, 60)
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 77, math.random(60, 70))
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 77, math.random(60, 70))
end

if not CLIENT then return end

function SWEP:DrawHUD()
	if GAMEMODE:GetWaveActive() then
		local scrW = ScrW()
		local scrH = ScrH()
		local width = 200
		local height = 20
		local x = scrW / 2 - width / 2
		local y = scrH / 2 - height + 120
		local ratio = math.Clamp((self.NextRoar - CurTime()) / self.RoarDelay,0,1)
		surface.SetDrawColor(Color(0, 0, 255, 80))
		if ratio >= 0.01 then
			surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
			draw.RoundedBox(0, x, y, width*ratio, height, Color(255, 0, 0, 80))
		end
	end

	if self.BaseClass.DrawHUD then
		self.BaseClass.DrawHUD(self)
	end
end
AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = Model("models/Weapons/v_fza.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
if CLIENT then
SWEP.ViewModelFOV = 47
end
SWEP.NextMessage = 0
SWEP.MeleeReach = 45
SWEP.MeleeDelay = 0.55
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 5
SWEP.MeleeDamageType = DMG_SLASH

SWEP.Primary.Delay = 1.5
function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsPlayer() then
		ent:TakeSpecialDamage(damage, self.MeleeDamageType, self.Owner, self, trace.HitPos)
		if SERVER then	
			local bleed = ent:GiveStatus("bleed")
				if bleed and bleed:IsValid() then
				bleed:AddDamage(5)
				if self.Owner:IsValid() and self.Owner:IsPlayer() then
					bleed.Damager = self.Owner
				end
			end
			local status = ent:GetStatus("branded")
			if !status or !IsValid(status) then
				ent:GiveStatus("branded")	
			end
		end
	else
		local dmgtype, owner, hitpos = self.MeleeDamageType, self.Owner, trace.HitPos
		timer.Simple(0, function() -- Avoid prediction errors.
			if ent:IsValid() then
				ent:TakeSpecialDamage(damage, dmgtype, owner, self, hitpos)
			end
		end)
	end
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("npc/manhack/grind_flesh"..math.random(3)..".wav")
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav", 75, 80)
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/antlion/attack_double"..math.random(3)..".wav", 75, 110)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/combine_gunship/gunship_moan.wav", 75, math.random(160,200))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound
function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

local function DoPlaceTrap(pl)
	if pl:IsValid() and pl:Alive() and pl:GetActiveWeapon():IsValid() and SERVER then
		pl:ResetSpeed()
		local trace = pl:TraceLine(100, MASK_SOLID)
		if trace.Entity and trace.Entity:IsWorld()then
			pl:EmitSound("npc/roller/mine/rmine_predetonate.wav",75,60)
			local ent = ents.Create("prop_trap")
			if ent:IsValid() then
				ent:SetPos(trace.HitPos)
				ent:SetAngles(trace.HitNormal:Angle())
				ent:Spawn()
				ent:SetOwner(pl)
				ent.Team = pl:Team()
			end
			pl:RawCapLegDamage(CurTime() + 2)
			pl:TakeDamage(50)
		end	
	end
end
local function DoSwing(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
	
		if wep.SwapAnims then wep:SendWeaponAnim(ACT_VM_HITCENTER) else wep:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		wep.IdleAnimation = CurTime() + wep:SequenceDuration()
		wep.SwapAnims = not wep.SwapAnims
	end
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() then return end
	
	local owner = self.Owner
	local trace = owner:TraceLine(200, MASK_SOLID)
	if trace.Entity and trace.Entity:IsWorld()then
		self.Owner:DoAnimationEvent(ACT_RANGE_ATTACK2)
		self.Owner:EmitSound("npc/roller/mine/rmine_blades_out"..math.random(3)..".wav",75,60)
		self.Owner:SetSpeed(1)
		self:SetNextSecondaryFire(CurTime() + 14)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		timer.Simple(0.6, function() DoSwing(owner, self) end)
		timer.Simple(0.75, function() DoPlaceTrap(owner) end)
	else 		
		self:SetNextSecondaryFire(CurTime() + 1)
		if CurTime() >= self.NextMessage then
			self.NextMessage = CurTime() + 2
			if SERVER then
			self.Owner:CenterNotify(COLOR_RED, "범위 안에 덫을 놓을 곳이 없다!")
			end
		end 
	end
end

if CLIENT then

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/flesh")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
end
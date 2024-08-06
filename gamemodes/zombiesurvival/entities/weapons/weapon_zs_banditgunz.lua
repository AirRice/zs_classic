AddCSLuaFile()

SWEP.Base = "weapon_zs_banditgun"
SWEP.ZombieOnly = true
SWEP.Primary.Damage = 10
SWEP.AlertDelay = 1
SWEP.Primary.Delay = 1
SWEP.HoldType = "ar2"
SWEP.ViewModel = "models/weapons/v_snip_g3sg1.mdl"
SWEP.MaxCharged = 25
SWEP.PlayCharging = nil
SWEP.CannotCharged = false
SWEP.NextCharge = 0
SWEP.ChargeDelay = 35
SWEP.NextSpecialShot = 0
SWEP.SpecialShotLeft = 0
if CLIENT then
	SWEP.ViewModelFlip = true
end
SWEP.LastGave = 0

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Charged")
	self:NetworkVar("Vector", 31, "ConeAdder")
	self:NetworkVar("Float", 31, "LastFire")
end
function SWEP:CanPrimaryAttack()
	if self.Charging then
		return false
	end
	return self.BaseClass.BaseClass.CanPrimaryAttack(self)
end


function SWEP:Initialize()
	if SERVER then
		self.Weapon:SetMaterial('models/Flesh')
	end
	self.BaseClass.BaseClass.Initialize(self)
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + self.AlertDelay)

	self:DoAlert()
	if self:GetDTBool(0) then
			self:SetDTBool(0, false) 
		else
			self:SetDTBool(0, true) 
	end
end

function SWEP:DoAlert()
	self.Owner:LagCompensation(true)

	local ent = self.Owner:MeleeTrace(4096, 24, self.Owner:GetMeleeFilter()).Entity
	if ent:IsValid() and ent:IsPlayer() then
		self:PlayAlertSound()
	else
		self:PlayIdleSound()
	end

	self.Owner:LagCompensation(false)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/zombine/zombine_alert"..math.random(1,7)..".wav",75,100)
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/zombine/zombine_idle"..math.random(4)..".wav")
end

function SWEP:Reload()
	if self.Owner:IsHolding() then return end

	if self:GetIronsights() then
		self:SetIronsights(false)
	end
	if self:GetNextReload() <= CurTime() and self:Clip1() != 25 then
		self.Owner:GetViewModel():SetPlaybackRate(0.5)
		self.IdleAnimation = CurTime() + self:SequenceDuration()*2+0.3
		self:SetNextPrimaryFire(self.IdleAnimation)
		self:SetNextReload(self.IdleAnimation)
		self.Owner:EmitSound("npc/zombine/zombine_readygrenade2.wav",75,100)
		self:DefaultReload(ACT_VM_RELOAD)
		self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_CROSSBOW)
		self:ResetConeAdder()
	end
end

function SWEP:Think()
	local owner = self.Owner
	local curTime = CurTime()
	if SERVER then
	if (self.LastGave or 0) + 10 <= curTime then
		if (IsValid(owner)) then
			owner:GiveAmmo(10, "ar2")
			self.LastGave = curTime
		end
	end
	end	
	if self:GetNextReload() + 0.3 > CurTime() then
		self:SetCharged(0)
		return
	end
	if owner:KeyPressed(IN_SPEED) and self.NextCharge <= CurTime() and self:Clip1() >= 5 then	
		self:EmitSound("npc/combine_gunship/see_enemy.wav")
	end
	
	local charged = self:GetCharged()
	self.CannotCharged = false
	if owner:KeyDown(IN_SPEED) then
		if self:Clip1() < 5 then
			self.CannotCharged = true	
		elseif self.NextCharge <= CurTime() then
			self.CannotCharged = false
			self:SetCharged(math.Clamp(charged + FrameTime() * 8, 0, self.MaxCharged))
			self.Charging = true	
		else
			self.CannotCharged = true
			self.Charging = false
		end
	else
		if charged == self.MaxCharged then
			self:SetCharged(0)
			self.Charging = false
			self.NextCharge = CurTime() + self.ChargeDelay
			self:SetClip1(0)
			self.SpecialShotLeft = 20
			if SERVER then
			self.Owner:TakeDamage(100)
			end
		end
		if charged > 0 then
			self:SetCharged(math.Clamp(charged - FrameTime() * 16, 0, self.MaxCharged))
		else
			self.Charging = false
		end
	end
	if self:GetDTBool(0) and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetDTBool(0, false)
	end
	
	if self.SpecialShotLeft > 0 and CurTime() >= self.NextSpecialShot then
		self.SpecialShotLeft = self.SpecialShotLeft - 1
		self.NextSpecialShot = CurTime() + 0.04
		self:ShootChargedBullet()
	elseif self.SpecialShotLeft <=0 then
		self:ResetConeAdder()
	end
end


function SWEP:ShootChargedBullet()	
	if SERVER then
		self:SetConeAndFire()
	end
	self.OriginalRecoil = self.Recoil
	self.Recoil = self.OriginalRecoil * 0.4
	self:DoRecoil()
	self.Recoil = self.OriginalRecoil
	self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav",90, 90)
	local owner = self.Owner
	--owner:MuzzleFlash()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()

	local cone = self:GetCone() * 1.2
	local dmg = self.Primary.Damage * 0.5
	
	self:StartBulletKnockback()
	owner:FireBullets({Num = numbul, Src = owner:GetShootPos(), Dir = owner:GetAimVector(), Spread = Vector(cone, cone, 0), Tracer = 1, TracerName = self.TracerName, Force = dmg * 0.1, Damage = dmg, Callback = self.BulletCallback})
	self:DoBulletKnockback(self.Primary.KnockbackScale * 0.05)
	self:EndBulletKnockback()
	
	self:EmitSound("Weapon_AWP.Single")
end

if CLIENT then

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/flesh")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end

function SWEP:DrawHUD()
		if self.CannotCharged then
			surface.SetDrawColor(255, 0, 0, 120)
			surface.DrawOutlinedRect(ScrW() / 2 - 100, ScrH() / 2 + 32, 200, 32)
			surface.SetFont("ZSHUDFontSmaller")
			surface.SetTextColor(255, 0, 0, 120)
			surface.SetTextPos(ScrW() / 2 - 98, ScrH() / 2 + 34)
			surface.DrawText("CANNOT CHARGE")
			if self.NextCharge > CurTime() then
			surface.SetTextPos(ScrW() / 2 - -100, ScrH() / 2 + 34)
			surface.DrawText(math.floor(self.NextCharge - CurTime()))
			end
		elseif self.Charging then
			local charged = self:GetCharged()
			local ratio = charged / self.MaxCharged
			surface.SetDrawColor(255 - 255 * ratio, 255 * ratio, 0, 120)
			surface.DrawRect(ScrW() / 2 - 100, ScrH() / 2 + 32, 200 * ratio, 32)
			if charged == self.MaxCharged then
				surface.SetDrawColor(13, 255, 150, 120)
				surface.DrawOutlinedRect(ScrW() / 2 - 104, ScrH() / 2 + 28, 208, 40)
				surface.DrawOutlinedRect(ScrW() / 2 - 103, ScrH() / 2 + 29, 206, 38)
			end
		end
		self.BaseClass.DrawHUD(self)
	end
	
end
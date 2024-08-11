AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Sweeper' 샷건"
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.M3_PARENT"
	SWEP.HUD3DPos = Vector(-1, -4, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.UseHands = true

SWEP.ReloadDelay = 0.4

SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Damage = 28
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 1

SWEP.Primary.KnockbackScale = 0.3

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.14
SWEP.ConeMin = 0.105

SWEP.Recoil = 7.65

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.IgniteDuration = 5

function SWEP:Reload()
	if self.reloading then return end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		if SERVER then
			self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
		end
		self:ResetConeAdder()
	end

	self:SetIronsights(false)
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		self.nextreloadfinish = 0
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
	
	self:DevineConeAdder()
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self.reloading then
		if 0 < self:Clip1() then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return true
end

function SWEP:SecondaryAttack()
end

SWEP.BulletCallback = function(attacker, tr, dmginfo) 	
	if (!IsFirstTimePredicted()) then
		return
	end
			
	GenericBulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if IsValid(ent) and ent:IsPlayer() and ent:Team() == TEAM_ZOMBIE and attacker.sweeperInc and SERVER then
		local wep = attacker:GetWeapon("weapon_zs_sweepershotgun")
		if IsValid(wep) then
			local burn = ent:GiveStatus("burn")
			if burn and burn:IsValid() then
				burn:AddDamage(wep.IgniteDuration)
				if attacker:IsValid() and attacker:IsPlayer() and ent:GetZombieClassTable().Name ~= "Shade" and ent:GetZombieClassTable().Name ~= "Cremated" then
					burn.Damager = attacker
				end
			end
		end
	end
end
	
end
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Blaster' 샷건"
	SWEP.Slot = 3
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false

	SWEP.HUD3DPos = Vector(4, -3.5, -1.2)
	SWEP.HUD3DAng = Angle(90, 0, -30)
	SWEP.HUD3DScale = 0.02
	SWEP.HUD3DBone = "SS.Grip.Dummy"
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/v_supershorty/v_supershorty.mdl"
SWEP.WorldModel = "models/weapons/w_supershorty.mdl"

SWEP.ReloadDelay = 0.3

SWEP.Primary.Sound = Sound("Weapon_Shotgun.Single")
SWEP.Primary.Damage = 21
SWEP.Primary.NumShots = 4
SWEP.Primary.Delay = 0.3

SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.126
SWEP.ConeMin = 0.085

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.Recoil = 8

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	if self.reloading then return end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
		end

	self:SetIronsights(false)
	
	self:ResetConeAdder()
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 4)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:EmitSound("Weapon_M3.Pump")
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
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
		-- if self:Clip1() >= self.Primary.ClipSize then
			-- self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			-- self.reloading = false
		-- else
			-- self:SendWeaponAnim(ACT_VM_IDLE)
		-- end
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return true
end

function SWEP:SecondaryAttack()
end

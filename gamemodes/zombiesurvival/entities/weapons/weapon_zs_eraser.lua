AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Eraser' 전략 권총"
	SWEP.Description = "한 총기연구시설에서 불의의 사고로 만들어진 권총.\n탄창에 남은 탄이 줄어들수록 데미지가 증가하며, 마지막 한 발은 3배의 대미지를 가한다."

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "v_weapon.FIVESEVEN_PARENT"
	SWEP.HUD3DPos = Vector(-1, -2.5, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/ar2/npc_ar2_altfire.wav")
SWEP.Primary.Damage = 21
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.0025
SWEP.ConeMin = 0.0012
SWEP.Recoil = 1.124
SWEP.SideRecoil = 1.0

SWEP.IronSightsPos = Vector(-5.95, 0, 2.5)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, 70 + (1 - (self:Clip1() / self.Primary.ClipSize)) * 90)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	if self:Clip1() == 0 then
		dmg = dmg * 3
	else
		dmg = dmg + dmg * (1 - self:Clip1() / self.Primary.ClipSize)
	end

	self.BaseClass.ShootBullets(self, dmg, numbul, cone)
end

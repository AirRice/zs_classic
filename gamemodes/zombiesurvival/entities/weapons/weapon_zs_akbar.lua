AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Akbar' 돌격소총"
	SWEP.Description = "이 총의 특수 탄환은 피해를 이미 입은 대상에게 그만큼 높은 피해를 입힌다.\n단 특히 강한 보스 좀비에게는 특수탄 효과가 없다."
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.AK47_Parent"
	SWEP.HUD3DPos = Vector(-1, -4.5, -4)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AK47.Clipout")
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Damage = 18
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.055
SWEP.ConeMin = 0.0195

SWEP.Recoil = 0.42

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-6.6, 20, 3.1)

function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsPlayer() and ent:Team() == TEAM_UNDEAD and not ent:GetZombieClassTable().Boss then
		local mul = 1-ent:Health()/ent:GetMaxHealthEx()
		dmginfo:AddDamage(dmginfo:GetDamage()*mul)
	end
	GenericBulletCallback(attacker, tr, dmginfo)
end
SWEP.BulletCallback = BulletCallback
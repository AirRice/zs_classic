AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "맨핵 : 톱날"
	SWEP.Description = "기존 맨핵에 톱날을 부착한 개조 버전.\n더 강력한 데미지와 튼튼한 내구성을 얻었으나 컨트롤하기가 비교적 어려워졌다."
end

SWEP.Base = "weapon_zs_manhack"

SWEP.DeployClass = "prop_manhack_saw"
SWEP.ControlWeapon = "weapon_zs_manhackcontrol_saw"

SWEP.Primary.Ammo = "manhack_saw"

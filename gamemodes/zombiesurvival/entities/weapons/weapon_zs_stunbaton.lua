AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "스턴 바톤"

	SWEP.ViewModelFOV = 50

	SWEP.Description = "다른 무기에 비해 직접적인 피해는 적지만,\n좀비에게 전기 충격을 가해 일시적으로 현저히 느려지게 만든다."
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.MeleeDamage = 27
SWEP.StunDamage = 20
SWEP.MeleeRange = 49
SWEP.MeleeSize = 1.5
SWEP.Primary.Delay = 0.9

SWEP.SwingTime = 0.25
SWEP.SwingRotation = Angle(60, 0, 0)
SWEP.SwingOffset = Vector(0, -50, 0)
SWEP.SwingHoldType = "grenade"

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_StunStick.Swing")
end

function SWEP:PlayHitSound()
	self:EmitSound("Weapon_StunStick.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("Weapon_StunStick.Melee_Hit")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() then
		hitent:AddLegDamage(self.StunDamage)
	end
end

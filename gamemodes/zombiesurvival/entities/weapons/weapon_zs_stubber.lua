AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Stubber' 소총"
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.scout_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.75, -6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_Scout.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Scout.Single")
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.025
SWEP.ConeMin = 0

SWEP.Recoil = 5

SWEP.SideRecoil = 3

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 100)
end

local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() then
		if ent:IsPlayer() then
			if ent:Team() == TEAM_UNDEAD and tempknockback then
				tempknockback[ent] = ent:GetVelocity()
			end
			
			if tr.HitGroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage(3)
			end
		else
			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end
	end
end

SWEP.BulletCallback = BulletCallback

if CLIENT then
	local surface = surface
	local RealTime = RealTime
	local RunConsoleCommand = RunConsoleCommand
	local math = math
	local GetConVarNumber = GetConVarNumber
	local GetGlobalBool = GetGlobalBool
	local ScrW = ScrW
	local ScrH = ScrH
	local Material = Material
	local draw = draw

	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local matScope = Material("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:IsScoped() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)
			surface.SetMaterial(matScope)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5, size, size)
			surface.SetDrawColor(0, 0, 0, 255)
			if scrw > size then
				local extra = (scrw - size) * 0.5
				surface.DrawRect(0, 0, extra, scrh)
				surface.DrawRect(scrw - extra, 0, extra, scrh)
			end
			if scrh > size then
				local extra = (scrh - size) * 0.5
				surface.DrawRect(0, 0, scrw, extra)
				surface.DrawRect(0, scrh - extra, scrw, extra)
			end
		end
	end
end

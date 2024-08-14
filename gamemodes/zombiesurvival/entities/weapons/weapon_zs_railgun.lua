AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "시제품 가우스 레일건"
	SWEP.Description = "고전압을 이용해 열화 우라늄 탄환을 초고속으로 발사한다. \n이 탄환은 좀비, 바리케이드 등 그 어떤 물체도 관통하지만 관통하는 물체마다 입히는 대미지가 20% 경감된다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.sg550_Parent"
	SWEP.HUD3DPos = Vector(-1.5, -4.7, 0.6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.03
	
	SWEP.VElements = {
		["Barrel3"] = { type = "Model", model = "models/props_c17/utilityconnecter006c.mdl", bone = "v_weapon.sg550_Parent", rel = "Barrel1", pos = Vector(0, 1.465, 15), angle = Angle(0, 0, 0), size = Vector(0.263, 0.263, 0.263), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel2"] = { type = "Model", model = "models/props_trainstation/pole_448connection002a.mdl", bone = "v_weapon.sg550_Parent", rel = "Barrel1", pos = Vector(0, 2.799, 0), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.079), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel1"] = { type = "Model", model = "models/props_trainstation/pole_448connection002a.mdl", bone = "v_weapon.sg550_Parent", rel = "", pos = Vector(0, -5.6, -19), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.079), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel4"] = { type = "Model", model = "models/props_c17/utilityconnecter006c.mdl", bone = "v_weapon.sg550_Parent", rel = "Barrel1", pos = Vector(0, 1.465, 7), angle = Angle(0, 0, 0), size = Vector(0.263, 0.263, 0.263), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["Barrel4"] = { type = "Model", model = "models/props_c17/utilityconnecter006c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Barrel1", pos = Vector(0, 1.465, 13.873), angle = Angle(0, 0, 0), size = Vector(0.263, 0.263, 0.263), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel2"] = { type = "Model", model = "models/props_trainstation/pole_448connection002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Barrel1", pos = Vector(0, 2.799, 0), angle = Angle(0, 0, 0), size = Vector(0.1, 0.05, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel1"] = { type = "Model", model = "models/props_trainstation/pole_448connection002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.461, 1.067, -6.928), angle = Angle(0, 89.526, -79.413), size = Vector(0.1, 0.05, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Barrel3"] = { type = "Model", model = "models/props_c17/utilityconnecter006c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Barrel1", pos = Vector(0, 1.465, 4.112), angle = Angle(0, 0, 0), size = Vector(0.263, 0.263, 0.263), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

sound.Add(
{
	name = "Weapon_Railgun.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitch = 85,
	level = 85,
	sound = "npc/strider/fire.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AWP.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Railgun.Single")
SWEP.Primary.Damage = 175
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 5
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "combinecannon"
SWEP.Primary.DefaultClip = 1

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.02
SWEP.ConeMin = 0
SWEP.Recoil = 1.51

SWEP.IronSightsPos = Vector(-4.2, -5, 1.74)
SWEP.IronSightsAng = Vector(0, 0, 0)


SWEP.WalkSpeed = 130

SWEP.TracerName = "AirboatGunHeavyTracer"

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:EmitFireSound()
	self:EmitSound("npc/sniper/sniper1.wav", 75, 75,1,CHAN_AUTO + 20)
	self:EmitSound("npc/sniper/echo1.wav", 75, 120,1, CHAN_AUTO + 21)
	self:EmitSound("Weapon_Railgun.Single")
end
local temp_vel_ents = {}

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:EmitFireSound()
	self:TakeAmmo()
	if SERVER then
		self:SetConeAndFire()
	end
	self:DoRecoil()
	
	local owner = self.Owner
	--owner:MuzzleFlash()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	local railgun_filter = team.GetPlayers(TEAM_HUMAN)
	table.insert(railgun_filter, self)
	local pretrace = util.GetPlayerTrace( owner )
	pretrace.mask = MASK_SHOT
	local tr = util.TraceLine(pretrace)
	if !tr.HitWorld and !tr.HitSky then
		local tracer = { 
			start = tr.HitPos + tr.Normal * 1000,
			endpos = tr.HitPos,
			mask = MASK_SHOT,
			ignoreworld = true 
		}
		backtr = util.TraceLine(tracer)
		firsthit = backtr.HitPos
		local backtrent = nil;
		local Hitlist = {}
		while backtrent ~= tr.Entity do
			backtrent = backtr.Entity
			table.insert(Hitlist, backtrent)
			tracer.filter = Hitlist
			backtr = util.TraceLine(tracer)
		end
		local pierceOrder = table.Reverse(Hitlist)
		local validtargets = 0
		for i, ent in ipairs(pierceOrder) do
			local bullet_trace = util.GetPlayerTrace( owner )
			local hittrace_filter = table.Copy(pierceOrder)
			table.remove(hittrace_filter , i)
			table.Add(hittrace_filter, railgun_filter)
			bullet_trace.filter = hittrace_filter
			bullet_tr = util.TraceLine(bullet_trace)

			// Dispatch trace attack to pierced zombies
			// Make dmginfo first
			


			if IsValid(ent) then
				if ent:IsPlayer() and IsValid(owner) and owner:IsPlayer() and ent:Team() == owner:Team() then continue end
				local dmg = math.Clamp(self.Primary.Damage * (0.8 ^ (validtargets)), 1, self.Primary.Damage)
				local damageinfo = DamageInfo()
					damageinfo:SetDamageType(DMG_BULLET)
					damageinfo:SetDamage(dmg)
					damageinfo:SetDamagePosition(bullet_tr.HitPos)
					damageinfo:SetAttacker(owner)
					damageinfo:SetInflictor(self)
					damageinfo:SetDamageForce(dmg * 70 * bullet_tr.Normal)
				validtargets = validtargets + 1
				if ent:IsPlayer() then
					temp_vel_ents[ent] = temp_vel_ents[ent] or ent:GetVelocity()
					if SERVER then
						ent:SetLastHitGroup(bullet_tr.HitGroup)
					end
				elseif IsValid(owner) and owner:IsPlayer() then
					local phys = ent:GetPhysicsObject()
					if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
						ent:SetPhysicsAttacker(owner)
					end
				end
				ent:DispatchTraceAttack(damageinfo, bullet_tr, bullet_tr.Normal)
			end
		end
		for ent, vel in pairs(temp_vel_ents) do
			ent:SetLocalVelocity(vel)
		end
		table.Empty(temp_vel_ents)
	end

	local worldtrace = util.GetPlayerTrace( owner )
	worldtrace.mask = bit.band(MASK_SHOT, MASK_NPCWORLDSTATIC)
	local worldtr = util.TraceLine(worldtrace)
	if worldtr.HitWorld or worldtr.HitSky then
		if IsFirstTimePredicted() then
			local worldloc = worldtr.HitPos
			local worldnorm = worldtr.HitNormal
			local hitw = EffectData()
				hitw:SetRadius(8)
				hitw:SetMagnitude(3)
				hitw:SetScale(1.25)
				hitw:SetOrigin(worldloc)
				hitw:SetNormal(worldnorm)
			util.Effect("cball_bounce", hitw)
			local effectdata = EffectData()
				effectdata:SetOrigin(worldtr.HitPos)
				effectdata:SetStart(worldtr.StartPos)
				effectdata:SetNormal(worldtr.HitNormal)
				util.Effect("RagdollImpact", effectdata)
			if not worldtr.HitSky then
				effectdata:SetSurfaceProp(worldtr.SurfaceProps)
				effectdata:SetDamageType(DMG_BULLET)
				effectdata:SetHitBox(worldtr.HitBox)
				effectdata:SetEntity(worldtr.Entity)
				util.Effect("Impact", effectdata)
			end
			if owner:IsPlayer() and IsValid(self) then
				effectdata:SetFlags( 0x0003 ) --TRACER_FLAG_USEATTACHMENT + TRACER_FLAG_WHIZ
				effectdata:SetEntity(self)
				effectdata:SetAttachment(1)
				effectdata:SetScale(5000) -- Tracer travel speed
				util.Effect("tracer_railgun", effectdata)
			end
			util.Decal("FadingScorch", worldloc -  worldnorm, worldloc + worldnorm)
		end
	end

	--self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
	
function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.4

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
		local hw,hh = scrw * 0.5, scrh * 0.5
		local screenscale = BetterScreenScale()
		local gradsize = math.ceil(size * 0.14)
		local line = 38 * screenscale
		
		surface.SetDrawColor(0,145,255,16)
		surface.DrawRect(0,0,scrw,scrh)
		for i=0,6 do
			local rectsize = math.floor(screenscale * 44) + i * math.floor(130 * screenscale)
			local hrectsize = rectsize * 0.5
			surface.SetDrawColor(0,145,255,math.max(35,25 + i * 30))
			surface.DrawOutlinedRect(hw-hrectsize,hh-hrectsize,rectsize,rectsize)
		end
		if scrw > size then
			local extra = (scrw - size) * 0.5
			for i=0,12 do
				surface.SetDrawColor(0,145,255, math.max(10,255 - i * 21.25))
				surface.DrawLine(hw,i*line,hw,i*line+line)
				surface.DrawLine(hw,scrh-i*line,hw,scrh-i*line-line)
				surface.DrawLine(i*line+extra,hh,i*line+line+extra,hh)
				surface.DrawLine(scrw-i*line-extra,hh,scrw-i*line-line-extra,hh)
			end
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, extra, scrh)
			surface.DrawRect(scrw - extra, 0, extra, scrh)
		end
		if scrh > size then
			local extra = (scrh - size) * 0.5
			for i=0,12 do
				surface.SetDrawColor(0,145,255, math.max(10,255 - i * 21.25))
				surface.DrawLine(hw,i*line+extra,hw,i*line+line+extra)
				surface.DrawLine(hw,scrh-i*line-extra,hw,scrh-i*line-line-extra)
				surface.DrawLine(i*line,hh,i*line+line,hh)
				surface.DrawLine(scrw-i*line,hh,scrw-i*line-line,hh)
			end
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, scrw, extra)
			surface.DrawRect(0, scrh - extra, scrw, extra)
		end
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

if SERVER then

end
CLASS.Name = "Zombine"
CLASS.TranslationName = "class_zombine"
CLASS.Description = "description_zombine"
CLASS.Help = "controls_zombine"

CLASS.Wave = 1

CLASS.Health = 375
CLASS.Speed = 125
CLASS.DefaultSpeed = 125
CLASS.ChaseModeSpeed = 230
CLASS.JumpPower = 175
CLASS.Mass = DEFAULT_MASS * 2

CLASS.CanTaunt = false

CLASS.Points = 9

CLASS.SWEP = "weapon_zs_zombine"

CLASS.Model = Model("models/zombie/zombie_soldier.mdl")

CLASS.DeathSounds = {"zombiesurvival/zombine/zombine_die1.wav","zombiesurvival/zombine/zombine_die2.wav"}

CLASS.VoicePitch = 1

CLASS.CanFeignDeath = false

local DIR_BACK = DIR_BACK
local ACT_HL2MP_ZOMBIE_SLUMP_RISE = ACT_HL2MP_ZOMBIE_SLUMP_RISE
local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

function CLASS:PlayPainSound(pl)
	pl:EmitSound("zombiesurvival/zombine/zombine_pain"..math.random(2, 3)..".wav", 72, math.Rand(100, 110))
	return true
end

local mathrandom = math.random
local StepSounds = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav",
}
local ScuffSounds = {
	"npc/zombie/foot_slide1.wav",
	"npc/zombie/foot_slide2.wav",
	"npc/zombie/foot_slide3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if mathrandom() < 0.15 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 70, 75)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 70, 75)
	end

	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and pl:GetWeapon( "weapon_zs_zombine" ) == wep and wep.IsInAttackAnim then
		if wep.IsInAttackAnim and wep:IsInAttackAnim() then
			pl.CalcSeqOverride = wep.AttackMotion
			return true
		end
	end
	if wep:IsValid() and wep.DuringShieldUp then
		pl.CalcSeqOverride = 3 
		return true
	end
	if wep:IsValid() and wep.IsInShield and wep:IsInShield() then
		if velocity:Length2D() > 0.5 then
			pl.CalcSeqOverride = 33 
		else 
			pl.CalcSeqOverride = 4
		end
		return true
	end
	if velocity:Length2D() > 0.5 then
		if wep:GetNWInt("MovementMode", 0) == 0 then
			pl.CalcSeqOverride = 32
		elseif wep:GetNWInt("MovementMode", 0) == 1 then
			pl.CalcSeqOverride = 35
		end
	else
		pl.CalcSeqOverride = 2
	end
	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local feign = pl.FeignDeath
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.IsInAttackAnim then
		if wep:IsInAttackAnim() then
			pl:SetPlaybackRate(0)
			pl:SetCycle((1 - (wep:GetAttackAnimTime() - CurTime()) / wep.Primary.Delay))

			return true
		end
	end
	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 2))
	else
		pl:SetPlaybackRate(1)
	end
	
	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		return ACT_INVALID
	end
end


function CLASS:ProcessDamage(pl, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local wep = pl:GetActiveWeapon()
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and wep:IsValid() then
		if wep:IsInShield() then
			dmginfo:ScaleDamage(0.3)
			if SERVER then
			local center = pl:LocalToWorld(pl:OBBCenter())
			local hitpos = pl:NearestPoint(dmginfo:GetDamagePosition())
			local effectdata = EffectData()
				effectdata:SetOrigin(center)
				effectdata:SetStart(pl:WorldToLocal(hitpos))
				effectdata:SetAngles((center - hitpos):Angle())
				effectdata:SetEntity(pl)
			util.Effect("shadedeflect", effectdata, true, true)
			end
		end
		wep:ForceChangeMode()
	end
end
function CLASS:Move(pl,mv)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and pl:GetWeapon( "weapon_zs_zombine" ) == wep then
		if wep.DuringModeChange or wep.IsInAttackAnim and wep:IsInAttackAnim() or wep.DuringShieldUp then
			mv:SetMaxSpeed(30)
			mv:SetMaxClientSpeed(30)
		elseif wep:GetNWInt("MovementMode", 0) == 0 then
			if wep.IsInShield and wep:IsInShield() then
				mv:SetMaxSpeed(self.DefaultSpeed*0.35)
				mv:SetMaxClientSpeed(self.DefaultSpeed*0.35)
			else
				mv:SetMaxSpeed(self.DefaultSpeed)
				mv:SetMaxClientSpeed(self.DefaultSpeed)
			end
		elseif wep:GetNWInt("MovementMode", 0) == 1 then
			mv:SetMaxSpeed(self.ChaseModeSpeed)
			mv:SetMaxClientSpeed(self.ChaseModeSpeed)
		end
	end
end
if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("zombineambience")
	end
end

if CLIENT then
	CLASS.Icon = "zombiesurvival/killicons/zombie"
end


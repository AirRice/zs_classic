CLASS.Name = "Infected Bandit"
CLASS.TranslationName = "class_bandit"
CLASS.Description = "description_bandit"
CLASS.Help = "controls_bandit"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true
CLASS.ModelScale = 1.05
CLASS.Health = 750
CLASS.Speed = 130
CLASS.CanTaunt = true

CLASS.FearPerInstance = 1

CLASS.Points = 25

CLASS.SWEP = "weapon_zs_banditgunz"

CLASS.Model = Model("models/player/arctic.mdl")

CLASS.VoicePitch = 0.6

CLASS.DeathSounds = {"zombiesurvival/zombine/zombine_die1.wav","zombiesurvival/zombine/zombine_die2.wav"}

--[[
local ACT_HL2MP_SWIM_MELEE = ACT_HL2MP_SWIM_MELEE
local ACT_HL2MP_IDLE_CROUCH_MELEE = ACT_HL2MP_IDLE_CROUCH_MELEE
local ACT_HL2MP_WALK_CROUCH_MELEE = ACT_HL2MP_WALK_CROUCH_MELEE
local ACT_HL2MP_IDLE_MELEE = ACT_HL2MP_IDLE_MELEE
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE
local ACT_HL2MP_RUN_MELEE = ACT_HL2MP_RUN_MELEE
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE
]]

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
	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_AR2
		return true
	end

	local shooting = false
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and CurTime() < wep:GetNextPrimaryFire() then
		shooting = true
	end

	if pl:Crouching() then
		if velocity:Length2D() <= 0.5 then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_AR2
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_AR2
		end
	elseif velocity:Length2D() <= 0.5 then
		if shooting then
			pl.CalcIdeal = ACT_HL2MP_IDLE_AR2
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_ZOMBIE_02
		end
	elseif shooting then
		pl.CalcIdeal = ACT_HL2MP_WALK_AR2
	else
		pl.CalcIdeal = ACT_HL2MP_WALK_ZOMBIE_04
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.666, 3))
	else
		pl:SetPlaybackRate(1)
	end
	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2, true)
		return ACT_INVALID
	end
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("banditambience")
	end
	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
		local effectdata = EffectData()
			effectdata:SetOrigin(pl:GetPos())
			effectdata:SetNormal(pl:GetForward())
			effectdata:SetEntity(pl)
		util.Effect("chemzombieexplode", effectdata, nil, true)
	end
end

if not CLIENT then return end

--CLASS.Icon = "zombiesurvival/killicons/butcher"
local matFlesh = Material("Models/Flesh")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matFlesh)
	render.SetColorModulation(1, 0.6, 0.4)
end
function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
	render.SetColorModulation(1, 1, 1)
end
local vecSpineScaleOffset = Vector(0.84, 1.2, 1.1)
local SpineBones = { 
	"ValveBiped.Bip01_Spine4", 
	"ValveBiped.Bip01_Spine3",
	"ValveBiped.Bip01_Spine5",
	"ValveBiped.Bip01_Spine6", 
	"ValveBiped.Bip01_Spine7", 
	"ValveBiped.Bip01_L_Clavicle", 
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_L_Calf", 
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_L_Thigh", 
	"ValveBiped.Bip01_R_Thigh"
	}
local ArmBones = { 
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm"
}
	
function CLASS:BuildBonePositions(pl)
	for _, bone in pairs(SpineBones) do
		local spineid = pl:LookupBone(bone)
		if spineid and spineid > 0 then
			pl:ManipulateBoneScale(spineid, vecSpineScaleOffset)
		end
	end
	for _, bone in pairs(ArmBones) do
		local spineid = pl:LookupBone(bone)
		if spineid and spineid > 0 then
			pl:ManipulateBoneScale(spineid, Vector(1.5, 0.3, 0.5))
		end
	end
end

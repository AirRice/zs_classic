CLASS.Name = "Slasher"
CLASS.TranslationName = "class_slash"
CLASS.Description = "description_slash"
CLASS.Help = "controls_slash"

CLASS.Wave = 0
CLASS.Threshold = 0

CLASS.Health = 150
CLASS.Speed = 210

CLASS.Points = 4

CLASS.SWEP = "weapon_zs_slasher"

CLASS.Model = Model("models/player/zombie_fast.mdl")

CLASS.VoicePitch = 1.5

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 58)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
CLASS.ViewOffset = Vector(0, 0, 50)
CLASS.ViewOffsetDucked = Vector(0, 0, 24)

CLASS.PainSounds = {"npc/zombie/zombie_pain1.wav", "npc/zombie/zombie_pain2.wav", "npc/zombie/zombie_pain3.wav", "npc/zombie/zombie_pain4.wav", "npc/zombie/zombie_pain5.wav", "npc/zombie/zombie_pain6.wav"}
CLASS.DeathSounds = {"npc/combine_gunship/gunship_moan.wav"}

local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE
local ACT_ZOMBIE_LEAPING = ACT_ZOMBIE_LEAPING
local ACT_HL2MP_RUN_ZOMBIE_FAST = ACT_HL2MP_RUN_ZOMBIE_FAST

CLASS.Hidden = false
CLASS.Disabled = false
CLASS.Unlocked = false

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound("npc/strider/strider_step1.wav", 40, math.random(180, 255))
	else
		pl:EmitSound("npc/strider/strider_step3.wav", 40, math.random(180, 255))
	end
	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 450 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 400
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 550
	end

	return 250
end

function CLASS:CalcMainActivity(pl, velocity)
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_ZOMBIE_LEAPING
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE_FAST
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl:SetPlaybackRate(1)

		if pl:GetCycle() >= 1 then
			pl:SetCycle(pl:GetCycle() - 1)
		end

		return true
	end
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:Move(pl, mv)
	if mv:GetForwardSpeed() <= 0 then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.33)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.33)
	end
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
	if SERVER then
		local effectdata = EffectData()
			effectdata:SetOrigin(pl:GetPos())
			effectdata:SetNormal(pl:GetForward())
			effectdata:SetEntity(pl)
		util.Effect("fatexplosion", effectdata, nil, true)
	end
end
if SERVER then
	function CLASS:OnSpawned(pl)
		local status = pl:GiveStatus("overridemodel")
		if status and status:IsValid() then
			status:SetModel("models/wraith_zsv1.mdl")
			status:SetMaterial("Models/flesh")
			status:SetColor(Color(130, 95, 20,255))
		end
	end
end
if not CLIENT then return end

--CLASS.Icon = "zombiesurvival/killicons/blighted"

local vecSpineScaleOffset = Vector(1.14, 2.3, 2.5)
local SpineBones = {
	"ValveBiped.Bip01_L_Thigh", 
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_L_Calf", 
	"ValveBiped.Bip01_R_Calf", 
	"ValveBiped.Bip01_L_Foot", 
	"ValveBiped.Bip01_R_Foot"
	}
function CLASS:BuildBonePositions(pl)
	for _, bone in pairs(SpineBones) do
		local spineid = pl:LookupBone(bone)
		if spineid and spineid > 0 then
			pl:ManipulateBoneScale(spineid, vecSpineScaleOffset)
		end
	end
end

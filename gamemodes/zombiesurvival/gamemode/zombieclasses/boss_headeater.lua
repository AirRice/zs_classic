local bit = bit
local cam = cam
local chat = chat
local concommand = concommand
local constraint = constraint
local cvars = cvars
local derma = derma
local draw = draw
local effects = effects
local ents = ents
local file = file
local game = game
local gamemode = gamemode
local gmod = gmod
local gui = gui
local hook = hook
local input = input
local killicon = killicon
local language = language
local list = list
local math = math
local mesh = mesh
local net = net
local os = os
local physenv = physenv
local player = player
local player_manager = player_manager
local render = render
local scripted_ents = scripted_ents
local sound = sound
local string = string
local surface = surface
local table = table
local team = team
local timer = timer
local util = util
local vgui = vgui
local weapons = weapons
local AccessorFunc = AccessorFunc
local Angle = Angle
local AngleRand = AngleRand
local ClientsideModel = ClientsideModel
local Color = Color
local CreateClientConVar = CreateClientConVar
local CreateConVar = CreateConVar
local CurTime = CurTime
local DamageInfo = DamageInfo
local DisableClipping = DisableClipping
local DynamicLight = DynamicLight
local EffectData = EffectData
local EmitSound = EmitSound
local EyeAngles = EyeAngles
local EyePos = EyePos
local FrameTime = FrameTime
local GetConVar = GetConVar
local GetConVarNumber = GetConVarNumber
local GetConVarString = GetConVarString
local GetGlobalAngle = GetGlobalAngle
local GetGlobalBool = GetGlobalBool
local GetGlobalEntity = GetGlobalEntity
local GetGlobalFloat = GetGlobalFloat
local GetGlobalInt = GetGlobalInt
local GetGlobalString = GetGlobalString
local GetGlobalVector = GetGlobalVector
local ipairs = ipairs
local isnumber = isnumber
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local LocalToWorld = LocalToWorld
local Material = Material
local Matrix = Matrix
local pairs = pairs
local ParticleEmitter = ParticleEmitter
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local ScrH = ScrH
local ScrW = ScrW
local SetGlobalAngle = SetGlobalAngle
local SetGlobalBool = SetGlobalBool
local SetGlobalEntity = SetGlobalEntity
local SetGlobalFloat = SetGlobalFloat
local SetGlobalInt = SetGlobalInt
local SetGlobalString = SetGlobalString
local SetGlobalVector = SetGlobalVector
local tostring = tostring
local type = type
local unpack = unpack
local Vector = Vector
local VectorRand = VectorRand


CLASS.Name = "Head Eater"
CLASS.TranslationName = "class_headeater"
CLASS.Description = "description_headeater"
CLASS.Help = "controls_headeater"

CLASS.Model = Model("models/headcrabclassic.mdl")

CLASS.Boss = true

CLASS.Wave = 0
CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.SWEP = "weapon_zs_headeater"

CLASS.Health = 400
CLASS.Speed = 375
CLASS.JumpPower = 250

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

CLASS.Points = 20

CLASS.Hull = {Vector(-12, -12, 0), Vector(12, 12, 18.1)}
CLASS.HullDuck = {Vector(-12, -12, 0), Vector(12, 12, 18.1)}
CLASS.ViewOffset = Vector(0, 0, 10)
CLASS.ViewOffsetDucked = Vector(0, 0, 10)
CLASS.StepSize = 8
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = 25

CLASS.CantDuck = true

CLASS.IsHeadcrab = false

CLASS.PainSounds = {"NPC_HeadCrab.Pain"}
CLASS.DeathSounds = {"NPC_HeadCrab.Die"}

function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end


function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return true
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		local time = wep:GetBurrowTime()
		if time > 0 then
			pl.CalcSeqOverride = 11
			return true
		elseif time < 0 then
			pl.CalcSeqOverride = 10
			return true
		end
	end

	if pl:OnGround() then
		if velocity:Length2D() > 0.5 then
			pl.CalcIdeal = ACT_RUN
		else
			pl.CalcSeqOverride = 1
		end
	elseif pl:WaterLevel() >= 3 then
		pl.CalcSeqOverride = 6
	else
		pl.CalcSeqOverride = 5
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)

	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		local time = wep:GetBurrowTime()
		if time ~= 0 then
			pl:SetCycle(math.Clamp((math.abs(time) - CurTime()) / wep.BurrowTime, 0, 1))
			pl:SetPlaybackRate(0)
			return true
		end
	end

	local seq = pl:GetSequence()
	if seq == 5 then
		if not pl.m_PrevFrameCycle then
			pl.m_PrevFrameCycle = true
			pl:SetCycle(0)
		end

		pl:SetPlaybackRate(1)

		return true
	elseif pl.m_PrevFrameCycle then
		pl.m_PrevFrameCycle = nil
	end

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.5, 2))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoesntGiveFear(pl)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime then
		return wep:GetBurrowTime() > 0 and CurTime() > math.abs(wep:GetBurrowTime())
	end
end
CLASS.NoDraw = CLASS.DoesntGiveFear

function CLASS:ShouldDrawLocalPlayer(pl)
	local wep = pl:GetActiveWeapon()
	return wep:IsValid() and wep.GetBurrowTime and wep:GetBurrowTime() ~= 0
end

if SERVER then
	function CLASS:AltUse(pl)
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() then wep:Reload() end
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/headcrab"

function CLASS:PrePlayerDraw(pl)
	render.SetColorModulation(0, 0, 0)
	render.SetBlend(0.5)

	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.GetBurrowTime and wep:GetBurrowTime() ~= 0 and CurTime() >= math.abs(wep:GetBurrowTime()) then
		return true
	end
end

function CLASS:PostPlayerDraw(pl)
	render.SetColorModulation(1, 1, 1)
	render.SetBlend(1)
end

function CLASS:CreateMove(pl, cmd)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep.m_ViewAngles and wep.IsPouncing and wep:IsPouncing() then
		local maxdiff = FrameTime() * 15
		local mindiff = -maxdiff
		local originalangles = wep.m_ViewAngles
		local viewangles = cmd:GetViewAngles()

		local diff = math.AngleDifference(viewangles.yaw, originalangles.yaw)
		if diff > maxdiff or diff < mindiff then
			viewangles.yaw = math.NormalizeAngle(originalangles.yaw + math.Clamp(diff, mindiff, maxdiff))
		end

		wep.m_ViewAngles = viewangles

		cmd:SetViewAngles(viewangles)
	end
end

local vecSpineOffset = Vector(100, 0, 0)
local SpineBones = {
	"HeadcrabClassic.UpperArmL_Bone",
	"HeadcrabClassic.UpperArmR_Bone",
	"HeadcrabClassic.ThighL_Bone",
	"HeadcrabClassic.ThighR_Bone",
}

function CLASS:BuildBonePositions(pl)
	-- for _, bone in pairs(SpineBones) do
		-- local spineid = pl:LookupBone(bone)
		-- if spineid and spineid > 0 then
			-- pl:ManipulateBonePosition(spineid, vecSpineOffset)
		-- end
	-- end

	local desiredscale = 2
	
	pl.m_HEArmLength = math.Approach(pl.m_HEArmLength or desiredscale, desiredscale, FrameTime() * desiredscale)

	local body = pl:LookupBone("HeadcrabClassic.SpineControl")
	if (body and body > 0) then
		pl:ManipulateBoneScale(body, Vector(pl.m_HEArmLength, desiredscale, desiredscale))
	end
	
	local larmid1 = pl:LookupBone("HeadcrabClassic.UpperArmL_Bone")
	if larmid1 and larmid1 > 0 then
		pl:ManipulateBoneScale(larmid1, Vector(pl.m_HEArmLength, desiredscale, desiredscale))
	end
	
	local larmid2 = pl:LookupBone("HeadcrabClassic.UpperArmR_Bone")
	if larmid2 and larmid2 > 0 then
		pl:ManipulateBoneScale(larmid2, Vector(pl.m_HEArmLength, desiredscale, desiredscale))
	end
	
	local rarmid1 = pl:LookupBone("HeadcrabClassic.ThighL_Bone")
	if rarmid1 and rarmid1 > 0 then
		pl:ManipulateBoneScale(rarmid1, Vector(pl.m_HEArmLength, desiredscale, desiredscale))
	end
	
	local rarmid2 = pl:LookupBone("HeadcrabClassic.ThighR_Bone")
	if rarmid2 and rarmid2 > 0 then
		pl:ManipulateBoneScale(rarmid2, Vector(pl.m_HEArmLength, desiredscale, desiredscale))
	end
end
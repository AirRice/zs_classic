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


CLASS.Name = "Crow"
CLASS.TranslationName = "class_crow"
CLASS.Description = "description_crow"

CLASS.Health = 5
CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.SWEP = "weapon_zs_crow"
CLASS.Model = Model("models/crow.mdl")
CLASS.Speed = 90
CLASS.JumpPower = 230

CLASS.PainSounds = {"NPC_Crow.Pain"}
CLASS.DeathSounds = {"NPC_Crow.Die"}

CLASS.Unlocked = true
CLASS.Hidden = true

CLASS.Hull = {Vector(-4, -4, 0), Vector(4, 4, 9)}
CLASS.HullDuck = {Vector(-4, -4, 0), Vector(4, 4, 9)}
CLASS.ViewOffset = Vector(0,0,8)
CLASS.ViewOffsetDucked = Vector(0,0,8)
CLASS.CrouchedWalkSpeed = 1
CLASS.StepSize = 8
CLASS.Mass = 2

CLASS.NoUse = true
CLASS.NoGibs = true
CLASS.NoCollideAll = true
CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true
CLASS.NeverAlive = true
CLASS.AllowTeamDamage = true
CLASS.NoDeaths = true
CLASS.Points = 0

function CLASS:NoDeathMessage(pl, attacker, dmginfo)
	return true
end

function CLASS:DoesntGiveFear()
	return true
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	return true
end

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return true
end

function CLASS:CalcMainActivity(pl, velocity)
	if pl:OnGround() then
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.IsPecking and wep:IsPecking() then
			pl.CalcSeqOverride = 5
		elseif velocity:Length2D() > 0.5 then
			pl.CalcIdeal = ACT_RUN
		else
			pl.CalcIdeal = ACT_IDLE
		end
	elseif velocity:Length() > 350 then
		pl.CalcIdeal = ACT_FLY
	else
		pl.CalcSeqOverride = 7
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)
	pl:SetPlaybackRate(1)
	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end

function CLASS:Move(pl, mv)
	if not pl:GetActiveWeapon().IsCrow then return end

	if not pl:IsOnGround() and pl:KeyDown(IN_JUMP) then
		local dir = pl:EyeAngles()
		if pl:KeyDown(IN_MOVELEFT) then
			dir:RotateAroundAxis(dir:Up(), 20)
		elseif pl:KeyDown(IN_MOVERIGHT) then
			dir:RotateAroundAxis(dir:Up(), -20)
		end

		if pl:KeyDown(IN_FORWARD) then
			mv:SetVelocity(dir:Forward() * 450)
		else
			mv:SetVelocity(dir:Forward() * 300)
		end

		return true
	end
end

if SERVER then

function CLASS:SwitchedAway(pl)
	pl:SetAllowFullRotation(false)
end

function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo)
	pl:SetAllowFullRotation(false)

	if attacker:IsPlayer() and attacker ~= pl then
		if attacker:Team() == TEAM_HUMAN then
			attacker.CrowKills = attacker.CrowKills + 1
		elseif attacker:Team() == TEAM_UNDEAD and attacker:GetZombieClassTable().Name == "Crow" then
			attacker.CrowVsCrowKills = attacker.CrowVsCrowKills + 1

			net.Start("zs_crow_kill_crow")
				net.WriteString(pl:Name())
				net.WriteString(attacker:Name())
			net.Broadcast()
		end
	end

	if pl:Health() < -45 then
		local amount = pl:OBBMaxs():Length()
		local vel = pl:GetVelocity()
		util.Blood(pl:LocalToWorld(pl:OBBCenter()), math.Rand(amount * 0.25, amount * 0.5), vel:GetNormalized(), vel:Length() * 0.75)

		return true
	elseif not pl.KnockedDown then
		pl:CreateRagdoll()
	end

	pl:SetHealth(pl:GetMaxHealth())
	pl:StripWeapons()
	pl:Spectate(OBS_MODE_ROAMING)
end
end

if not CLIENT then return end

function CLASS:ShouldDrawLocalPlayer(pl)
	return true
end

CLASS.Icon = "zombiesurvival/killicons/crow"

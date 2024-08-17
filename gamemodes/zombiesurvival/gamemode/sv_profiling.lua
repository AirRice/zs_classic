local baseclass = baseclass
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
local assert = assert
local ClientsideModel = ClientsideModel
local CloseDermaMenus = CloseDermaMenus
local Color = Color
local CreateClientConVar = CreateClientConVar
local CreateConVar = CreateConVar
local CurTime = CurTime
local DamageInfo = DamageInfo
local Derma_Anim = Derma_Anim
local Derma_DrawBackgroundBlur = Derma_DrawBackgroundBlur
local Derma_Hook = Derma_Hook
local Derma_Install_Convar_Functions = Derma_Install_Convar_Functions
local Derma_Message = Derma_Message
local Derma_Query = Derma_Query
local Derma_StringRequest = Derma_StringRequest
local DermaMenu = DermaMenu
local DisableClipping = DisableClipping
local DynamicLight = DynamicLight
local EffectData = EffectData
local EmitSentence = EmitSentence
local EmitSound = EmitSound
local EyeAngles = EyeAngles
local EyePos = EyePos
local EyeVector = EyeVector
local Format = Format
local FrameTime = FrameTime
local GetConVar = GetConVar
local GetConVarNumber = GetConVarNumber
local GetConVarString = GetConVarString
local getfenv = getfenv
local GetGlobalAngle = GetGlobalAngle
local GetGlobalBool = GetGlobalBool
local GetGlobalEntity = GetGlobalEntity
local GetGlobalFloat = GetGlobalFloat
local GetGlobalInt = GetGlobalInt
local GetGlobalString = GetGlobalString
local GetGlobalVector = GetGlobalVector
local GetHostName = GetHostName
local GetHUDPanel = GetHUDPanel
local GetRenderTarget = GetRenderTarget
local GetRenderTargetEx = GetRenderTargetEx
local GetViewEntity = GetViewEntity
local ipairs = ipairs
local IsFirstTimePredicted = IsFirstTimePredicted
local isnumber = isnumber
local IsValid = IsValid
local Label = Label
local LocalPlayer = LocalPlayer
local LocalToWorld = LocalToWorld
local Material = Material
local Matrix = Matrix
local Msg = Msg
local MsgAll = MsgAll
local MsgC = MsgC
local MsgN = MsgN
local pairs = pairs
local Particle = Particle
local ParticleEffect = ParticleEffect
local ParticleEffectAttach = ParticleEffectAttach
local ParticleEmitter = ParticleEmitter
local print = print
local PrintMessage = PrintMessage
local PrintTable = PrintTable
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
local Sound = Sound
local SoundDuration = SoundDuration
local tobool = tobool
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack
local ValidPanel = ValidPanel
local Vector = Vector
local VectorRand = VectorRand
local VGUIFrameTime = VGUIFrameTime
local VGUIRect = VGUIRect
local WorldToLocal = WorldToLocal

-- This system creates nodes which can be used to spawn dynamic objectives.

GM.ProfilerNodes = {}
GM.ProfilerFolder = "zsprofiler"
GM.ProfilerFolderPreMade = "profiler_premade"
GM.ProfilerVersion = 0
GM.MaxProfilerNodes = 128

hook.Add("Initialize", "ZSProfiler", function()
	file.CreateDir(GAMEMODE.ProfilerFolder)
	file.CreateDir(GAMEMODE.ProfilerFolderPreMade)
end)

local mapname = string.lower(game.GetMap())
if file.Exists(GM.ProfilerFolderPreMade.."/"..mapname..".txt", "DATA") then
	GM.ProfilerIsPreMade = true
	GM.ProfilerNodes = Deserialize(file.Read(GM.ProfilerFolderPreMade.."/"..mapname..".txt", "DATA"))
	SRL = nil
elseif file.Exists(GM.FolderName.."/gamemode/"..GM.ProfilerFolderPreMade.."/"..mapname..".lua", "LUA") then
	include(GM.ProfilerFolderPreMade.."/"..mapname..".lua")
	GM.ProfilerIsPreMade = true
	GM.ProfilerNodes = SRL or GM.ProfilerNodes
	SRL = nil
end

function GM:ClearProfiler()
	if not self:ProfilerEnabled() then return end

	self:SaveProfiler()
end

function GM:SaveProfilerPreMade(tab)
	file.Write(self:GetProfilerFilePreMade(), Serialize(tab))
end

function GM:DeleteProfilerPreMade()
	file.Delete(self:GetProfilerFilePreMade())
end

function GM:SaveProfiler()
	if not self:ProfilerEnabled() or self.ProfilerIsPreMade then return end

	file.Write(self:GetProfilerFile(), Serialize({Nodes = self.ProfilerNodes, Version = self.ProfilerVersion}))
end

function GM:LoadProfiler()
	if not self:ProfilerEnabled() or self.ProfilerIsPreMade then return end

	local filename = self:GetProfilerFile()
	if file.Exists(filename, "DATA") then
		local data = Deserialize(file.Read(filename, "DATA"))
		if not data.Version and self.ProfilerVersion == 0 then -- old, versionless format
			self.ProfilerNodes = data
		elseif data.Nodes and data.Version >= self.ProfilerVersion then
			self.ProfilerNodes = data.Nodes
		end
	end
end

function GM:GetProfilerFile()
	return self.ProfilerFolder.."/"..string.lower(game.GetMap())..".txt"
end

function GM:GetProfilerFilePreMade()
	return self.ProfilerFolderPreMade.."/"..string.lower(game.GetMap())..".txt"
end

function GM:ProfilerEnabled()
	return not self.ZombieEscape and not self.ObjectiveMap
end

function GM:NeedsProfiling()
	return #self.ProfilerNodes <= self.MaxProfilerNodes and not self.ProfilerIsPreMade
end

function GM:DebugProfiler()
	for _, node in pairs(self.ProfilerNodes) do
		local spawned = false
		for __, e in pairs(ents.FindByClass("prop_dynamic*")) do
			if e.IsNode and e:GetPos() == node then spawned = true end
		end
		if not spawned then
			local ent = ents.Create("prop_dynamic_override")
			if ent:IsValid() then
				ent:SetModel("models/player/breen.mdl")
				ent:SetKeyValue("solid", "0")
				ent:SetColor(Color(255, 0, 0))
				ent:SetPos(node)
				ent:Spawn()
				ent.IsNode = true
			end
		end
	end
end

local playerheight = Vector(0, 0, 92)
local playermins = Vector(-24, -24, 0)
local playermaxs = Vector(24, 24, 4)
local vecsky = Vector(0, 0, 32000)
local function SkewedDistance(a, b, skew)
	if a.z > b.z then
		return math.sqrt((b.x - a.x) ^ 2 + (b.y - a.y) ^ 2 + ((a.z - b.z) * skew) ^ 2)
	end

	return a:Distance(b)
end

function GM:ProfilerPlayerValid(pl)
	if (!IsValid(pl) or !pl.GetPos) then
		return false
	end

	-- Preliminary checks. We need to mark players as incompatible when they do certain things.
	if pl.NoProfiling then return false end

	-- Basic checks (movement, etc.)
	if not (pl:Team() == TEAM_HUMAN and pl:Alive()
	and pl:GetMoveType() == MOVETYPE_WALK and not pl:Crouching()
	and pl:OnGround() and pl:IsOnGround() and pl:GetGroundEntity() == game.GetWorld()) then return false end

	local plcenter = pl:LocalToWorld(pl:OBBCenter())
	local plpos = pl:GetPos()

	-- Are they near another node?
	for _, node in pairs(self.ProfilerNodes) do
		if SkewedDistance(node, plpos, 3) <= 128 then
			--print('near')
			return false
		end
	end

	-- Are they inside something?
	local pos = plpos + Vector(0, 0, 1)
	if util.TraceHull({start = pos, endpos = pos + playerheight, mins = playermins, maxs = playermaxs, mask = MASK_SOLID, filter = team.GetPlayers(TEAM_HUMAN)}).Hit then
		--print('inside')
		return false
	end

	-- Are they near a trigger hurt?
	for _, ent in pairs(ents.FindInSphere(plcenter, 256)) do
		if ent and ent:IsValid() then
			local entclass = ent:GetClass()
			if entclass == "trigger_hurt" then
				--print('trigger hurt')
				return false
			end
		end
	end

	-- What about zombie spawns?
	for _, ent in pairs(team.GetValidSpawnPoint(TEAM_UNDEAD)) do
		if ent:GetPos():Distance(plcenter) < 420 then
			--print('near spawn')
			return false
		end
	end

	-- Time for the more complicated stuff.
	local trace = {start = plcenter, endpos = plcenter + vecsky, mins = playermins, maxs = playermaxs, mask = MASK_SOLID_BRUSHONLY}
	local trsky = util.TraceHull(trace)
	if trsky.HitSky or trsky.HitNoDraw then
		--print('outside')
		return false
	end

	-- Check to see if they're near a window or the entrance of somewhere. This also doubles as a check for long hallways.
	local ang = Angle(0, 0, 0)
	for t = 0, 359, 15 do
		ang.yaw = t

		for d = 32, 92, 24 do
			trace.start = plcenter + ang:Forward() * d
			trace.endpos = trace.start + Vector(0, 0, 640)
			local tr = util.TraceHull(trace)
			if not tr.Hit or tr.HitNormal.z > -0.65 then
				--print('not hit ceiling')
				return false
			end
			trace.endpos = trace.start + Vector(0, 0, -64)
			local tr = util.TraceHull(trace)
			if not tr.Hit or tr.HitNormal.z < 0.65 then
				--print('not hit floor')
				return false
			end
		end
	end

	-- Are they outside?
	--[[local trace = {start = plcenter, endpos = plcenter + vecsky, mins = playermins, maxs = playermaxs, mask = MASK_SOLID_BRUSHONLY}
	local trsky = util.TraceHull(trace)
	if trsky.HitSky or trsky.HitNoDraw then
		--print('outside')
		return false
	end

	-- Check to see if they're near a window or the entrance of somewhere. This also doubles as a check for long hallways.
	local ang = Angle(-30, 0, 0)
	for t = 0, 359, 15 do
		ang.yaw = t

		trace.endpos = trace.start + ang:Forward() * 350
		local tr = util.TraceLine(trace)
		if not tr.Hit then
			--print('not hit ceiling')
			return false
		end
	end

	local ang = Angle(-50, 0, 0)
	for t = 0, 359, 15 do
		ang.yaw = t

		trace.endpos = trace.start + ang:Forward() * 300
		local tr = util.TraceLine(trace)
		if tr.Fraction == 0 or tr.HitSky or tr.HitNoDraw or tr.HitNormal.z > -0.65 then
			print('fractions differ')
			return false
		end
	end

	-- Check to make sure the floor is even all around.
	local ang = Angle(55, 0, 0)
	local floordist = playerheight.z
	for t = 0, 359, 15 do
		ang.yaw = t

		trace.endpos = trace.start + ang:Forward() * floordist
		local tr = util.TraceLine(trace)
		if not tr.Hit then
			--print('floor uneven')
			return false
		end
	end]]

	--print('valid')
	return true
end

function GM:ProfilerTick()
	if not self:ProfilerEnabled() or not self:NeedsProfiling() then return end

	local changed = false
	for _, pl in pairs(player.GetAll()) do
		if not self:ProfilerPlayerValid(pl) then continue end

		table.insert(self.ProfilerNodes, pl:GetPos())

		changed = true
	end

	if changed then
		self:SaveProfiler() --self:DebugProfiler()
	end
end
timer.Create("ZSProfiler", 3, 0, function() GAMEMODE:ProfilerTick() end)
hook.Add("OnWaveStateChanged", "ZSProfiler", function() -- Only profile during start
	if GAMEMODE:GetWave() > 0 then
		timer.Destroy("ZSProfiler")
	end
end)

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

local Hints = {}

function GM:DrawPointWorldHints()
	for _, ent in pairs(ents.FindByClass("point_worldhint")) do ent:DrawHint() end
end

function GM:WorldHint(hint, pos, ent, lifetime)
	lifetime = lifetime or 8

	if ent and ent:IsValid() then
		if pos then
			pos = ent:WorldToLocal(pos)
		else
			pos = ent:OBBCenter()
		end
	end

	local hint = {Hint = hint, Pos = pos, Entity = ent, StartTime = CurTime(), EndTime = CurTime() + lifetime}
	table.insert(Hints, hint)

	return hint
end

net.Receive("zs_worldhint", function(length)
	GAMEMODE:WorldHint(net.ReadString(), net.ReadVector(), net.ReadEntity(), net.ReadFloat())
end)

local matRing = Material("effects/select_ring")
local colFG = Color(220, 220, 220, 255)
function DrawWorldHint(hint, pos, delta, scale)
	local eyepos = EyePos()

	delta = delta or 1

	colFG.a = math.min(220, delta * 220)

	local ang = (eyepos - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 270)
	ang:RotateAroundAxis(ang:Up(), 90)

	cam.IgnoreZ(true)
	cam.Start3D2D(pos, ang, (scale or 1) * math.max(250, eyepos:Distance(pos)) * delta * 0.0005)

	draw.SimpleText("!", "zshintfont", 0, 0, colFG, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(hint, "ZS3D2DFont2Small", 0, 64, colFG, TEXT_ALIGN_CENTER)

	surface.SetMaterial(matRing)
	for i=1, 4 do
		colFG.a = colFG.a * (1 / i)
		surface.SetDrawColor(colFG)
		local pulse = math.max(0.25, math.abs(math.sin(RealTime() * 6))) * 30 * i
		surface.DrawTexturedRectRotated(0, 0, 128 + pulse, 128 + pulse, 0)
	end

	cam.End3D2D()
	cam.IgnoreZ(false)
end
local DrawWorldHint = DrawWorldHint

function GM:DrawWorldHints()
	if #Hints > 0 then
		local curtime = CurTime()

		local done = true

		for _, hint in pairs(Hints) do
			local ent = hint.Entity
			if curtime < hint.EndTime and not (ent and not ent:IsValid()) then
				done = false

				DrawWorldHint(hint.Hint, ent and ent:LocalToWorld(hint.Pos) or hint.Pos, math.Clamp(hint.EndTime - curtime, 0, 1))
			end
		end

		if done then
			Hints = {}
		end
	end
end

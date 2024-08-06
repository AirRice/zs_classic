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

function GM:OnSigilDestroyed(ent, dmginfo)
	local numsigils = self:NumSigils()
	if numsigils > 0 then
		for _, pl in pairs(player.GetAll()) do
			pl:CenterNotify({killicon = "default"}, " ", COLOR_RED, translate.ClientGet(pl, "sigil_destroyed"), {killicon = "default"})
			if numsigils == 1 then
				pl:CenterNotify(COLOR_RED, translate.ClientGet(pl, pl:Team() == TEAM_HUMAN and "sigil_destroyed_only_one_remain_h" or "sigil_destroyed_only_one_remain_z"))
			else
				pl:CenterNotify(COLOR_RED, translate.ClientFormat(pl, "sigil_destroyed_x_remain", numsigils))
			end
		end
	else
		for _, pl in pairs(player.GetAll()) do
			pl:CenterNotify({killicon = "default"}, " ", COLOR_RED, translate.ClientGet(pl, "last_sigil_destroyed_all_is_lost"), {killicon = "default"})
			pl:CenterNotify(COLOR_RED, translate.ClientGet(pl, "last_sigil_destroyed_all_is_lost2"))
		end

		self.LastHumanPosition = ent:LocalToWorld(ent:OBBCenter())
		timer.Simple(4, function() gamemode.Call("EndRound", TEAM_UNDEAD) end)
	end
end

local function SortDistFromLast(a, b)
	return a.d < b.d
end
function GM:CreateSigils()
	if #self.ProfilerNodes < self.MaxSigils
	or self.ZombieEscape or self.ObjectiveMap
	or self:IsClassicMode() or self.PantsMode or self:IsBabyMode() then
		self:SetUseSigils(false)
		return
	end

	-- Copy
	local nodes = {}
	for _, node in pairs(self.ProfilerNodes) do
		local vec = Vector()
		vec:Set(node)
		nodes[#nodes + 1] = {v = vec}
	end

	local spawns = team.GetSpawnPoint(TEAM_UNDEAD)
	for i=1, self.MaxSigils do
		local id
		local sigs = ents.FindByClass("prop_obj_sigil")

		for _, n in pairs(nodes) do
			n.d = 999999

			for __, spawn in pairs(spawns) do
				n.d = math.min(n.d, n.v:Distance(spawn:GetPos()))
			end
			for __, sig in pairs(sigs) do
				n.d = math.min(n.d, n.v:Distance(sig.NodePos))
			end

			local tr = util.TraceLine({start = n.v + Vector(0, 0, 8), endpos = n.v + Vector(0, 0, 512), mask = MASK_SOLID_BRUSHONLY})
			n.d = n.d * (2 - tr.Fraction)
		end

		-- Sort the nodes by their distances.
		table.sort(nodes, SortDistFromLast)

		-- Now select a node using an exponential weight.
		-- We use a random float between 0 and 1 then sqrt it.
		-- This way we're much more likely to get a lower index but a higher index is still possible.
		id = math.Rand(0, 0.7) ^ 0.3
		id = math.Clamp(math.ceil(id * #nodes), 1, #nodes)

		-- Remove the chosen point from the temp table and make the sigil.
		local point = nodes[id].v
		table.remove(nodes, id)

		local ent = ents.Create("prop_obj_sigil")
		if ent:IsValid() then
			ent:SetPos(point)
			ent:Spawn()
			ent.NodePos = point
		end
	end

	self:SetUseSigils(#ents.FindByClass("prop_obj_sigil") > 0)
end

function GM:SetUseSigils(use)
	if self:GetUseSigils() ~= use then
		self.UseSigils = use
		SetGlobalBool("sigils", true)
	end
end

function GM:GetUseSigils(use)
	return self.UseSigils
end

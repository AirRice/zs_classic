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

function GM:RenderScreenspaceEffects()
end

GM.PostProcessingEnabled = CreateClientConVar("zs_postprocessing", 1, true, false):GetBool()
cvars.AddChangeCallback("zs_postprocessing", function(cvar, oldvalue, newvalue)
	GAMEMODE.PostProcessingEnabled = tonumber(newvalue) == 1
end)

GM.FilmGrainEnabled = CreateClientConVar("zs_filmgrain", 1, true, false):GetBool()
cvars.AddChangeCallback("zs_filmgrain", function(cvar, oldvalue, newvalue)
	GAMEMODE.FilmGrainEnabled = tonumber(newvalue) == 1
end)

GM.FilmGrainOpacity = CreateClientConVar("zs_filmgrainopacity", 50, true, false):GetInt()
cvars.AddChangeCallback("zs_filmgrainopacity", function(cvar, oldvalue, newvalue)
	GAMEMODE.FilmGrainOpacity = math.Clamp(tonumber(newvalue) or 0, 0, 255)
end)

GM.ColorModEnabled = CreateClientConVar("zs_colormod", "1", true, false):GetBool()
cvars.AddChangeCallback("zs_colormod", function(cvar, oldvalue, newvalue)
	GAMEMODE.ColorModEnabled = tonumber(newvalue) == 1
end)

GM.Auras = CreateClientConVar("zs_auras", 1, true, false):GetBool()
cvars.AddChangeCallback("zs_auras", function(cvar, oldvalue, newvalue)
	GAMEMODE.Auras = tonumber(newvalue) == 1
end)

GM.AuraColorEmpty = Color(CreateClientConVar("zs_auracolor_empty_r", 255, true, false):GetInt(), CreateClientConVar("zs_auracolor_empty_g", 0, true, false):GetInt(), CreateClientConVar("zs_auracolor_empty_b", 0, true, false):GetInt(), 255)
GM.AuraColorFull = Color(CreateClientConVar("zs_auracolor_full_r", 20, true, false):GetInt(), CreateClientConVar("zs_auracolor_full_g", 255, true, false):GetInt(), CreateClientConVar("zs_auracolor_full_b", 20, true, false):GetInt(), 255)

cvars.AddChangeCallback("zs_auracolor_empty_r", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorEmpty.r = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_empty_g", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorEmpty.g = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_empty_b", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorEmpty.b = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_full_r", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorFull.r = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_full_g", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorFull.g = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

cvars.AddChangeCallback("zs_auracolor_full_b", function(cvar, oldvalue, newvalue)
	GAMEMODE.AuraColorFull.b = math.Clamp(math.ceil(tonumber(newvalue) or 0), 0, 255)
end)

local render = render
local math = math
local team = team
local Material = Material
local Color = Color
local pairs = pairs
local ipairs= ipairs
local DrawColorModify = DrawColorModify
local DrawSharpen = DrawSharpen
local EyePos = EyePos
local TEAM_HUMAN = TEAM_HUMAN
local TEAM_UNDEAD = TEAM_UNDEAD
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local render_SetMaterial = render.SetMaterial
local render_DrawScreenQuad = render.DrawScreenQuad
local render_DrawSprite = render.DrawSprite
local render_DrawBeam = render.DrawBeam
local render_GetLightRGB = render.GetLightRGB
local math_Approach = math.Approach
local FrameTime = FrameTime
local CurTime = CurTime
local math_sin = math.sin
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local team_GetPlayers = team.GetPlayers

local tColorModDead = {
	["$pp_colour_contrast"] = 1.25,
	["$pp_colour_colour"] = 0,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.02,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local tColorModHuman = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local tColorModZombie = {
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1.25,
	["$pp_colour_colour"] = 0.5,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local tColorModZombieVision = {
	["$pp_colour_colour"] = 0.75,
	["$pp_colour_brightness"] = -0.15,
	["$pp_colour_contrast"] = 1.5,
	["$pp_colour_mulr"]	= 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0
}

local redview = 0
local fear = 0
local matTankGlass = Material("models/props_lab/Tank_Glass001")
function GM:_RenderScreenspaceEffects()
	local frameTime = FrameTime()
	local curTime = CurTime()
	
	if MySelf.Confusion and MySelf.Confusion:IsValid() then
		MySelf.Confusion:RenderScreenSpaceEffects()
	end

	fear = math_Approach(fear, self:CachedFearPower(), frameTime)

	if not self.PostProcessingEnabled then return end

	if self.DrawPainFlash and self.HurtEffect > 0 then
		DrawSharpen(1, math_min(6, self.HurtEffect * 3))
	end

	--[[if MySelf:Team() == TEAM_UNDEAD and self.m_ZombieVision and not matTankGlass:IsError() then
		render_UpdateScreenEffectTexture()
		matTankGlass:SetFloat("$envmap", 0)
		matTankGlass:SetFloat("$envmaptint", 0)
		matTankGlass:SetFloat("$refractamount", 0.035)
		matTankGlass:SetInt("$ignorez", 1)
		render_SetMaterial(matTankGlass)
		render_DrawScreenQuad()
	end]]

	if self.ColorModEnabled then
		if not MySelf:Alive() and MySelf:GetObserverMode() ~= OBS_MODE_CHASE then
			if not MySelf:HasWon() then
				tColorModDead["$pp_colour_colour"] = (1 - math_min(1, curTime - self.LastTimeAlive)) * 0.5
				DrawColorModify(tColorModDead)
			end
		elseif MySelf:Team() == TEAM_UNDEAD then
			if self.m_ZombieVision then
				DrawColorModify(tColorModZombieVision)
			else
				tColorModZombie["$pp_colour_colour"] = math_min(1, 0.25 + math_min(1, (curTime - self.LastTimeDead) * 0.5) * 1.75 * fear)

				DrawColorModify(tColorModZombie)
			end
		else
			local curr = tColorModHuman["$pp_colour_addr"]
			local health = MySelf:Health()
			if health <= 50 then
				--tColorModHuman["$pp_colour_addr"] = math_min(0.3 - health * 0.006, curr + FrameTime() * 0.055)
				redview = math_Approach(redview, 1 - health / 50, frameTime * 0.2)
			elseif 0 < curr then
				--tColorModHuman["$pp_colour_addr"] = math_max(0, curr - FrameTime() * 0.1)
				redview = math_Approach(redview, 0, frameTime * 0.2)
			end

			tColorModHuman["$pp_colour_addr"] = redview * (0.035 + math_abs(math.sin(curTime * 2)) * 0.14)
			tColorModHuman["$pp_colour_brightness"] = fear * -0.045
			tColorModHuman["$pp_colour_contrast"] = 1 + fear * 0.15
			tColorModHuman["$pp_colour_colour"] = 1 - fear * 0.725 --0.85

			DrawColorModify(tColorModHuman)
		end
	end
end

local matGlow = Material("Sprites/light_glow02_add_noz")
local colHealthEmpty = GM.AuraColorEmpty
local colHealthFull = GM.AuraColorFull
local colHealth = Color(255, 255, 255, 255)
local matPullBeam = Material("cable/rope")
local colPullBeam = Color(255, 255, 255, 255)
function GM:_PostDrawOpaqueRenderables()
	if MySelf:Team() == TEAM_UNDEAD then
		if self.Auras then
			local eyepos = EyePos()
			for _, pl in pairs(team_GetPlayers(TEAM_HUMAN)) do
				if pl:Alive() and pl:GetPos():Distance(eyepos) <= pl:GetAuraRange() then
					local healthfrac = math_max(pl:Health(), 0) / pl:GetMaxHealth()
					colHealth.r = math_Approach(colHealthEmpty.r, colHealthFull.r, math_abs(colHealthEmpty.r - colHealthFull.r) * healthfrac)
					colHealth.g = math_Approach(colHealthEmpty.g, colHealthFull.g, math_abs(colHealthEmpty.g - colHealthFull.g) * healthfrac)
					colHealth.b = math_Approach(colHealthEmpty.b, colHealthFull.b, math_abs(colHealthEmpty.b - colHealthFull.b) * healthfrac)

					--local attach = pl:GetAttachment(pl:LookupAttachment("chest")) -- This probably lagged so much.
					--local pos = attach and attach.Pos or pl:WorldSpaceCenter()
					local pos = pl:WorldSpaceCenter()

					render_SetMaterial(matGlow)
					render_DrawSprite(pos, 13, 13, colHealth)
					local size = math_sin(self.HeartBeatTime + pl:EntIndex()) * 50 - 21
					if size > 0 then
						render_DrawSprite(pos, size * 1.5, size, colHealth)
						render_DrawSprite(pos, size, size * 1.5, colHealth)
					end
				end
			end
		end
	elseif MySelf:Team() == TEAM_HUMAN then
		self:DrawCraftingEntity()

		local holding = MySelf.status_human_holding
		if holding and holding:IsValid() and holding:GetIsHeavy() then
			local object = holding:GetObject()
			if object:IsValid() then
				local pullpos = holding:GetPullPos()
				local hingepos = holding:GetHingePos()
				local r, g, b = render_GetLightRGB(hingepos)
				colPullBeam.r = r * 255
				colPullBeam.g = g * 255
				colPullBeam.b = b * 255
				render_SetMaterial(matPullBeam)
				render_DrawBeam(hingepos, pullpos, 0.5, 0, pullpos:Distance(hingepos) / 128, colPullBeam)
			end
		end
	end
end

function GM:ToggleZombieVision(onoff)
	if onoff == nil then
		onoff = not self.m_ZombieVision
	end

	if onoff then
		if not self.m_ZombieVision then
			self.m_ZombieVision = true
			MySelf:EmitSound("npc/stalker/breathing3.wav", 0, 230)
			MySelf:SetDSP(30)
		end
	elseif self.m_ZombieVision then
		self.m_ZombieVision = nil
		MySelf:EmitSound("npc/zombie/zombie_pain6.wav", 0, 110)
		MySelf:SetDSP(0)
	end
end

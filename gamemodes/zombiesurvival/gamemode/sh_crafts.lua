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

GM.CraftingRange = 72

GM.Crafts = {
	{
		Name = "a big wooden crate",
		a = {"*physics*", {"models/props_junk/wood_crate001a.mdl", "models/props_junk/wood_crate001a_damaged.mdl", "models/props_junk/wood_crate001a_damagedmax.mdl"}},
		b = {"*physics*", {"models/props_junk/wood_crate001a.mdl", "models/props_junk/wood_crate001a_damaged.mdl", "models/props_junk/wood_crate001a_damagedmax.mdl"}},
		Result = {"prop_physics", Model("models/props_junk/wood_crate002a.mdl")}
	},
	{
		Name = "a bust-on-a-stick",
		callback = function(enta, entb)
			return enta:IsPhysicsModel("models/props_combine/breenbust.mdl") and entb:IsWeaponType("weapon_zs_plank")
		end,
		Result = {"weapon_zs_bust"}
	},
	{
		Name = "an oil-filled barrel",
		a = {"*physics*", "models/props_junk/gascan001a.mdl"},
		b = {"*physics*", "models/props_c17/oildrum001.mdl"},
		Result = {"prop_physics", Model("models/props_c17/oildrum001_explosive.mdl")}
	},
	{
		Name = "a sawhack",
		callback = function(enta, entb)
			return enta:IsPhysicsModel("models/props_junk/sawblade001a.mdl") and entb:IsWeaponType("weapon_zs_axe")
		end,
		Result = {"weapon_zs_sawhack"}
	},
	{
		Name = "a mega masher",
		callback = function(enta, entb)
			return enta:IsPhysicsModel("models/props_c17/oildrum001_explosive.mdl") and entb:IsWeaponType("weapon_zs_sledgehammer")
		end,
		Result = {"weapon_zs_megamasher"}
	},
	{
		Name = "an electrohammer",
		callback = function(enta, entb)
			return enta:IsPhysicsModel("models/items/car_battery01.mdl") and entb:IsWeaponType("weapon_zs_hammer")
		end,
		Result = {"weapon_zs_electrohammer"}
	},
	{
		Name = "a 'Waraxe' handgun",
		callback = function(enta, entb)
			return enta:IsWeaponType("weapon_zs_battleaxe") and entb:IsWeaponType("weapon_zs_battleaxe")
		end,
		Result = {"weapon_zs_waraxe"}
	},
	{
		Name = "a modified manhack",
		callback = function(enta, entb)
			return enta:IsPhysicsModel("models/props_junk/sawblade001a.mdl") and entb:IsWeaponType("weapon_zs_manhack")
		end,
		Result = {"weapon_zs_manhack_saw"}
	},
	{
		Name = "kongol axe",
		callback = function(enta, entb)
			return enta:IsWeaponType("weapon_zs_axe") and entb:IsWeaponType("weapon_zs_butcherknife")
		end,
		Result = {"weapon_zs_kongol"}
	}
}

function GM:GetCraftingRecipe(enta, entb)
	if not enta:IsValid() or not entb:IsValid() or enta == entb then return end

	for _, recipe in pairs(self.Crafts) do
		if self:CraftingRecipeMatches(enta, entb, recipe) then return recipe end
	end
end

function GM:GetCraftTarget(enta, entb)
	return enta:OBBMaxs():Distance(enta:OBBMins()) > entb:OBBMaxs():Distance(entb:OBBMins()) and enta or entb
end

function GM:CraftingRecipeMatches(enta, entb, recipe, checkedswap)
	local entaclass = enta:GetClass()
	local entbclass = entb:GetClass()
	local entaisphysics = string.sub(entaclass, 1, 12) == "prop_physics"
	local entbisphysics = string.sub(entbclass, 1, 12) == "prop_physics"

	if recipe.callback and recipe.callback(enta, entb) then
		return true
	end

	if recipe.a and recipe.b and (recipe.a[1] == entaclass or entaisphysics and recipe.a[1] == "*physics*") and (recipe.b[1] == entbclass or entaisphysics and recipe.a[1] == "*physics*") then
		local mdla = string.lower(enta:GetModel())
		local mdlb = string.lower(entb:GetModel())
		if (recipe.a[2] == nil or type(recipe.a[2]) == "table" and table.HasValue(recipe.a[2], mdla) or mdla == recipe.a[2]) and (recipe.b[2] == nil or type(recipe.b[2]) == "table" and table.HasValue(recipe.b[2], mdlb) or mdlb == recipe.b[2]) then
			return true
		end
	end

	if not checkedswap then
		return self:CraftingRecipeMatches(entb, enta, recipe, true)
	end
end

function GM:CanCraft(pl, enta, entb)
	if self:GetCraftingRecipe(enta, entb) == nil or not pl:IsValid() or not pl:Alive() or pl:Team() ~= TEAM_HUMAN then return false end

	if enta:IsBarricadeProp() or entb:IsBarricadeProp() or enta:GetName() ~= "" or entb:GetName() ~= "" then return false end

	local nearestb = entb:NearestPoint(enta:LocalToWorld(enta:OBBCenter()))
	local nearesta = enta:NearestPoint(entb:LocalToWorld(entb:OBBCenter()))
	if nearesta:Distance(nearestb) > self.CraftingRange or not TrueVisibleFilters(nearesta, nearestb, pl, enta, entb) then return false end

	local eyepos = pl:EyePos()
	if enta:NearestPoint(eyepos):Distance(eyepos) > self.CraftingRange or entb:NearestPoint(eyepos):Distance(eyepos) > self.CraftingRange then return false end

	if not TrueVisibleFilters(nearesta, eyepos, pl, enta, entb) or not TrueVisibleFilters(nearestb, eyepos, pl, enta, entb) then return false end

	return true
end

local meta = FindMetaTable("Entity")
if not meta then return end

function meta:IsPhysicsModel(mdl)
	return string.sub(self:GetClass(), 1, 12) == "prop_physics" and (not mdl or string.lower(self:GetModel()) == string.lower(mdl))
end

function meta:IsWeaponType(class)
	return self:GetClass() == "prop_weapon" and self:GetWeaponType() == class
end

if true then return end

function GM:GetCraftingRecipe(enta, entb)
	if not enta:IsValid() or not entb:IsValid() or enta == entb then return end

	for _, recipe in pairs(self.Crafts) do
		if self:CraftingRecipeMatches(enta, entb, recipe) then return recipe end
	end
end

function GM:GetCraftTarget(enta, entb)
	return enta:OBBMaxs():Distance(enta:OBBMins()) > entb:OBBMaxs():Distance(entb:OBBMins()) and enta or entb
end

function GM:CraftingRecipeMatches(enta, entb, recipe, checkedswap)
	local entaclass = enta:GetClass()
	local entbclass = entb:GetClass()
	local entaisphysics = string.sub(entaclass, 1, 12) == "prop_physics"
	local entbisphysics = string.sub(entbclass, 1, 12) == "prop_physics"

	if recipe.callback and recipe.callback(enta, entb) then
		return true
	end

	if recipe.a and recipe.b and (recipe.a[1] == entaclass or entaisphysics and recipe.a[1] == "*physics*") and (recipe.b[1] == entbclass or entaisphysics and recipe.a[1] == "*physics*") then
		local mdla = string.lower(enta:GetModel())
		local mdlb = string.lower(entb:GetModel())
		if (recipe.a[2] == nil or type(recipe.a[2]) == "table" and table.HasValue(recipe.a[2], mdla) or mdla == recipe.a[2]) and (recipe.b[2] == nil or type(recipe.b[2]) == "table" and table.HasValue(recipe.b[2], mdlb) or mdlb == recipe.b[2]) then
			return true
		end
	end

	if not checkedswap then
		return self:CraftingRecipeMatches(entb, enta, recipe, true)
	end
end

function GM:GetAllValidCraftingRecipes(pl)
	local craftable = {}

	for _, craft in pairs(self.Crafts) do
		if self:CanCraft(pl, craft) then
			table.insert(craftable, craft)
		end
	end

	return craftable
end

-- Preliminary tests for all entity types.
-- Classes are enforced by the recipes so if someone makes a recipe inolving players or worldspawn then oh well.
function GM:IsValidCraftingEntity(ent, pl)
	return not ent:IsWeapon()
	and not (ent:IsPhysicsModel() and ent:GetName() ~= "")
	and not (ent:IsWeapon() and ent:GetOwner() ~= pl)
end

-- This checks everything and is what determines if a recipe displays to the player in their menu.
function GM:CanCraft(pl, craft)
	if not pl:IsValid() or not pl:Alive() or pl:Team() ~= TEAM_HUMAN then return false end

	local plpos = pl:EyePos()
	local entities = ents.FindValidInSphere(plpos, self.CraftingRange)

	if craft.CanCraft and not craft:CanCraft(pl, entities, plpos) then return false end

	local ingredients = {}

	for _, ent in pairs(entities) do
		if craft.CanUseEntity and not craft:CanUseEntity(ent, pl) then continue end
	end

	-- All ingredients accounted for?
	--for _, ingredient

	local nearestb = entb:NearestPoint(enta:LocalToWorld(enta:OBBCenter()))
	local nearesta = enta:NearestPoint(entb:LocalToWorld(entb:OBBCenter()))
	if nearesta:Distance(nearestb) > self.CraftingRange or not TrueVisibleFilters(nearesta, nearestb, pl, enta, entb) then return false end

	local eyepos = pl:EyePos()
	if enta:NearestPoint(eyepos):Distance(eyepos) > self.CraftingRange or entb:NearestPoint(eyepos):Distance(eyepos) > self.CraftingRange then return false end

	if not TrueVisibleFilters(nearesta, eyepos, pl, enta, entb) or not TrueVisibleFilters(nearestb, eyepos, pl, enta, entb) then return false end

	return true
end

local meta = FindMetaTable("Entity")
if not meta then return end

function meta:IsPhysicsModel(mdl)
	return string.sub(self:GetClass(), 1, 12) == "prop_physics" and (not mdl or string.lower(self:GetModel()) == string.lower(mdl))
end

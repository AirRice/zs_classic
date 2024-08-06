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

function GM:CraftItem(pl, recipe, enta, entb)
	if enta._USEDINCRAFTING or entb._USEDINCRAFTING then return end

	if not recipe.OnCraft or not recipe.OnCraft(pl, enta, entb) then
		enta._USEDINCRAFTING = true
		entb._USEDINCRAFTING = true

		local result = recipe.Result
		if result then
			local resultclass = result[1]
			if string.sub(resultclass, 1, 7) == "weapon_" then
				if pl:HasWeapon(resultclass) then
					local target = self:GetCraftTarget(enta, entb)
					local ent = ents.Create("prop_weapon")
					if ent:IsValid() then
						ent:SetPos(target:GetPos())
						ent:SetAngles(target:GetAngles())
						ent:SetWeaponType(resultclass)
						ent:Spawn()

						local phys = ent:GetPhysicsObject()
						if phys:IsValid() then
							phys:Wake()
							phys:SetVelocity(target:GetVelocity())
						end
					end
				else
					local weptab = weapons.GetStored(resultclass)
					if weptab and weptab.AmmoIfHas then
						pl:GiveAmmo(weptab.Primary.DefaultClip, weptab.Primary.Ammo)
					else
						pl:Give(resultclass)
					end
				end
			else
				local target = self:GetCraftTarget(enta, entb)
				local ent = ents.Create(resultclass)
				if ent:IsValid() then
					ent:SetPos(target:GetPos())
					ent:SetAngles(target:GetAngles())
					if result[2] then
						ent:SetModel(result[2])
					end
					ent:Spawn()

					if recipe.OnCrafted then
						recipe.OnCrafted(pl, recipe, enta, entb, ent)
					end

					ent:TemporaryBarricadeObject()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:Wake()
						phys:SetVelocity(target:GetVelocity())
					end
				end
			end
		end

		enta:Remove()
		entb:Remove()
	end

	pl:CenterNotify(COLOR_LIMEGREEN, translate.ClientGet(pl, "crafting_successful"), color_white, "   ("..recipe.Name..")")
	pl:SendLua("surface.PlaySound(\"buttons/lever"..math.random(5)..".wav\")")
	PrintMessage(HUD_PRINTCONSOLE, translate.Format("x_crafted_y", pl:Name(), recipe.Name))
end

concommand.Add("_zs_craftcombine", function(sender, command, arguments)
	local enta = Entity(tonumbersafe(arguments[1] or 0) or 0)
	local entb = Entity(tonumbersafe(arguments[2] or 0) or 0)

	local recipe = GAMEMODE:GetCraftingRecipe(enta, entb)
	if recipe and gamemode.Call("CanCraft", sender, enta, entb) then
		gamemode.Call("CraftItem", sender, recipe, enta, entb)
	end
end)

concommand.Add("_zs_useobject", function(sender, command, arguments)
	if not pl:IsValid() or not pl:Alive() or pl:Team() ~= TEAM_HUMAN then return end

	local ent = Entity(tonumbersafe(arguments[1] or 0) or 0)
	local action = arguments[2] or ""

	if ent:IsValid() then
		local func = ent["Action_"..string.upper(action)]
		if func then
			local eyepos = sender:EyePos()
			local nearest = ent:NearestPoint(eyepos)
			if eyepos:Distance(nearest) <= 64 and TrueVisibleFilters(eyepos, nearest, sender, ent) then
				func(ent, sender, unpack(arguments[3]))
			end
		end
	end
end)

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	return true
end
local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(0, 0, 255, 125)
function ENT:Draw()
	local owner = self:GetOwner()
	if owner:IsValid() and not (owner == LocalPlayer() and not owner:ShouldDrawLocalPlayer()) then  
	-- 실드 켤 시 파란색 글로우
	local boneid = owner:LookupBone("ValveBiped.Bip01_Spine4")--("ValveBiped.HC_Head_Bone")
	if not boneid or boneid <= 0 then return end
	local offsetvec = Vector( 8.8, 0.2, 0.4 )--Vector( -5, 3, 2 )
	local offsetang = Angle( 0, 90, 90 ) --Angle( -18, 0, -74 ) 
	local matrix = owner:GetBoneMatrix( boneid )
	if not matrix then return end
	local newpos, newang = LocalToWorld( offsetvec, offsetang, matrix:GetTranslation(), matrix:GetAngles() )
	self:SetPos(newpos)
	self:SetAngles(newang)
	self:SetupBones()
	self:DrawModel()
	end
	if not owner:IsValid() then return end 
	-- 해골 모델 렌더	
	local wep = owner:GetWeapon( "weapon_zs_zombine" )
	if wep:IsValid() and wep:IsInShield() then
	render.SetMaterial(matGlow)
	local pos = owner:GetBonePosition( owner:LookupBone("ValveBiped.Bip01_Spine4") )
	render.DrawSprite(pos, 190, 190, colGlow)
	end
end

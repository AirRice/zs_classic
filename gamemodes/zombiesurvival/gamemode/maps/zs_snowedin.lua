hook.Add("InitPostEntityMap", "Adding", function()
	for _, v in pairs(ents.FindByClass("info_player_zombie")) do local pos = v:GetPos() v:SetPos(Vector(pos.x, pos.y, pos.z - 50)) end
end)

local lastThink = 0
hook.Add("Think", "zs_backstreet_v2b_RemoveGrenades", function()
	if (lastThink + 0.2 <= CurTime()) then
		for _, frag in pairs(ents.FindByClass("weapon_frag")) do
			frag:Remove()
		end
		
		lastThink = CurTime()
	end
end)
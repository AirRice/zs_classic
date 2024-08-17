hook.Remove("Tick", "zs_tower_v1")
hook.Add("Tick", "zs_tower_v1", function()
	for _, v in pairs(ents.FindInSphere(Vector(0, -600, 380), 50)) do
		if (IsValid(v) and !v:IsWorld() and v:IsPlayer()) then
			v:SetPos(Vector(0, -600, 219))
		end
	end
	for _, v in pairs(ents.FindInSphere(Vector(9, 1588, 380), 50)) do
		if (IsValid(v) and !v:IsWorld() and v:IsPlayer()) then
			v:SetPos(Vector(9, 1588, 219))
		end
	end
	for _, v in pairs(ents.FindInSphere(Vector(30, 2493, 164), 50)) do
		if (IsValid(v) and !v:IsWorld() and v:IsPlayer()) then
			v:SetPos(Vector(30, 2493, 0))
		end
	end
end)
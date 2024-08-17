hook.Add("Tick", "zs_tower_v1", function()
	for _, v in pairs(ents.FindInSphere(Vector(115, -4962, -3173), 50)) do
		if (IsValid(v) and !v:IsWorld() and v:IsPlayer()) then
			v:SetVelocity(Vector(0, 0, 100000))
		end
	end
end)

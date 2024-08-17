hook.Add("InitPostEntityMap", "Adding", function()
	for _, v in pairs(ents.FindByClass("info_player_zombie")) do
		v:Remove()
	end

	local zombiespawns = {
		Vector(-2018.2860107422, 210.22457885742, 0.03125),
		Vector(-2018.4185791016, 3.8517010211945, 0.03125),
		Vector(-2015.0078125, -181.52368164063, 0.03125),
		Vector(-2112.0458984375, 41.499389648438, 0.03125),
		Vector(1239.5751953125, -1968.1170654297, 0.03125),
		Vector(1328.2276611328, -1804.3453369141, 0.03125),
		Vector(1159.0600585938, -1939.9880371094, 0.03125),
		Vector(-918.51147460938, 3175.2116699219, 52.607620239258),
		Vector(-1407.8045654297, 3428.8686523438, 0.50942659378052),
		Vector(-1477.3747558594, 3803.0715332031, 27.269332885742),
		Vector(-1538.5494384766, 3027.0270996094, 65.056007385254),
		Vector(-1343.4926757813, 3357.388671875, 0.057509899139404),
	}

	for _, v in pairs(zombiespawns) do
		local ent = ents.Create("info_player_zombie")
		
		ent:SetPos(v)
		
		ent:Spawn()
	endend
end)

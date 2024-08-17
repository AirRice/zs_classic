hook.Add("InitPostEntityMap", "Adding", function()
	local zSpawns = {
		Vector(-171.67636108398, 2608.46875, 114.37588500977),
		Vector(-691.54333496094, -21.041284561157, -189.96875),
		Vector(3724.3779296875, 2110.7709960938, 768.03125),
		Vector(798.81524658203, -1330.5911865234, 576.03125),
		Vector(421.94195556641, 2331.5109863281, 258.03125),
		Vector(2943.10546875, 1329.4086914063, 1280.03125),
		Vector(3138.5224609375, 101.63194274902, 371.62811279297),
	}
	
	local hSpawns = {
		Vector(788.62536621094, -1191.4022216797, 576.03125),
		Vector(2592.9255371094, 1716.4385986328, 380.03125),
		Vector(1894.1086425781, -100.7052154541, 385.03125),
		Vector(75.362915039063, -53.854335784912, 64.03125),
		Vector(794.83734130859, -1180.6689453125, 1048.03125),
		Vector(-366.92172241211, 1014.5429077148, 256.03125),
		Vector(2686.3244628906, 1326.4514160156, 768.03125),
		Vector(2956.5241699219, -1276.9927978516, 1088.03125),
	}
	
	for i, spawnPos in pairs(zSpawns) do
		local spawn = ents.Create("info_player_zombie")
		spawn:SetPos(spawnPos)
		spawn:Spawn()
	end
	
	for i, spawnPos in pairs(hSpawns) do
		local spawn = ents.Create("info_player_human")
		spawn:SetPos(spawnPos)
		spawn:Spawn()
	end
end)

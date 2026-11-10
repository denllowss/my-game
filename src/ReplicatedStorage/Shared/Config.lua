--[[
	Config
	Konfigurasi bersama server & client.
	Diakses lewat: require(game.ReplicatedStorage.Shared.Config)
]]

local Config = {
	GameName = "Game Saya",

	Leaderstats = {
		Coins = "Coins",
		Wins = "Wins",
	},

	Coin = {
		Amount = 1,       -- coins didapat per pickup
		RespawnTime = 5,  -- detik sampai coin muncul lagi
		CollectDistance = 3, -- stud, jarak maksimal antar pemain dan coin
		MaxActive = 30,   -- batas jumlah coin yang dibuat saat start
	},

	-- Pengaturan tampilan coin
	CoinVisual = {
		SpinSpeed = 3,        -- radian per detik
		BobHeight = 0.35,     -- naik-turun (stud)
		BobSpeed = 2,         -- kecepatan naik-turun
		Color = Color3.fromRGB(255, 205, 60),
		EmitLight = true,
		LightColor = Color3.fromRGB(255, 220, 120),
		LightRange = 9,
		LightBrightness = 1.2,
	},
}

return Config

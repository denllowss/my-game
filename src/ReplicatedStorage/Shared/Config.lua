--[[
	Config
	Modul konfigurasi yang dipakai bersama server & client.
	Diakses lewat: require(game.ReplicatedStorage.Shared.Config)
]]

local Config = {
	GameName = "Game Saya",
	MaxPlayers = 12,

	Coin = {
		Amount = 1,
		RespawnTime = 5, -- detik
	},

	Leaderstats = {
		Coins = "Coins",
		Wins  = "Wins",
	},
}

return Config

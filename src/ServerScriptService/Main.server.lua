--[[
	Main (Script / server)
	Entry point sisi server. Jalankan logika game di sini.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

print(("[Server] %s dimulai"):format(Config.GameName))

-- Leaderstats
local function onPlayerAdded(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local coins = Instance.new("IntValue")
	coins.Name = Config.Leaderstats.Coins
	coins.Value = 0
	coins.Parent = leaderstats

	local wins = Instance.new("IntValue")
	wins.Name = Config.Leaderstats.Wins
	wins.Value = 0
	wins.Parent = leaderstats

	leaderstats.Parent = player
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

-- Penanda uji sync: kalau baris ini terlihat di Studio, pipeline sudah benar.
print("[SYNC-TEST] file ini ter-update dari GitHub pada 2026-11-10")

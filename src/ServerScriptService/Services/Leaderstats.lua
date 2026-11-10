--[[
	Leaderstats
	Membuat folder "leaderstats" pada setiap pemain dan menyediakan API
	untuk menambah coins / wins dari server.

	require(script.Parent.Services.Leaderstats)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local Leaderstats = {}

local coinName = Config.Leaderstats.Coins
local winName = Config.Leaderstats.Wins

-- Menyimpan nilai di luar leaderstats juga, supaya mudah dibaca ulang.
local values: { [Player]: { Coins: IntValue, Wins: IntValue } } = {}

local function setup(player: Player)
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"

	local coins = Instance.new("IntValue")
	coins.Name = coinName
	coins.Value = 0
	coins.Parent = folder

	local wins = Instance.new("IntValue")
	wins.Name = winName
	wins.Value = 0
	wins.Parent = folder

	folder.Parent = player

	values[player] = { Coins = coins, Wins = wins }
end

--- Mengambil IntValue coins milik pemain (bisa nil kalau belum siap).
function Leaderstats.getCoins(player: Player): IntValue?
	local entry = values[player]
	return entry and entry.Coins or nil
end

--- Menambah coins. Mengembalikan total baru.
function Leaderstats.addCoins(player: Player, amount: number): number
	local entry = values[player]
	if not entry then
		return 0
	end

	entry.Coins.Value += amount
	return entry.Coins.Value
end

--- Menambah wins.
function Leaderstats.addWins(player: Player, amount: number)
	local entry = values[player]
	if not entry then
		return
	end

	entry.Wins.Value += amount
end

function Leaderstats.start()
	Players.PlayerAdded:Connect(setup)
	Players.PlayerRemoving:Connect(function(player)
		values[player] = nil
	end)

	for _, player in Players:GetPlayers() do
		setup(player)
	end
end

return Leaderstats

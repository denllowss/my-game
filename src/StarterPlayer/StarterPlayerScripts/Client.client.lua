--[[
	Client (LocalScript)
	Jalan di sisi client setiap kali pemain join.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer

print(("[Client] Halo %s, selamat datang di %s"):format(player.Name, Config.GameName))

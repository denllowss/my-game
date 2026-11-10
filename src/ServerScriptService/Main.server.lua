--[[
	Main (Script / server)
	Entry point sisi server.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Leaderstats = require(script.Services.Leaderstats)
local CoinService = require(script.Services.CoinService)

print(("[Server] %s dimulai"):format(Config.GameName))

Leaderstats.start()
CoinService.start()

print("[SYNC-TEST v2] pipeline OK — pesan ini dikirim agent lewat GitHub + Rojo")

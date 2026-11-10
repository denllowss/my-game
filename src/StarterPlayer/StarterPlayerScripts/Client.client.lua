--[[
	Client (LocalScript)
	Jalan di sisi client setiap kali pemain join.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer

print("[Client] script mulai")

-- Ambil modul welcome dengan aman, supaya kalau gagal kita tahu penyebabnya.
local welcomeOk, WelcomeGui = pcall(function()
	return require(script.Parent:WaitForChild("Gui", 5):WaitForChild("WelcomeGui", 5))
end)

if not welcomeOk then
	warn("[Client] GAGAL require WelcomeGui: " .. tostring(WelcomeGui))
	WelcomeGui = nil
else
	print("[Client] WelcomeGui ditemukan")
end

print(("[Client] Halo %s, selamat datang di %s"):format(player.Name, Config.GameName))

--[[
	HUD coin sederhana.
	Membaca IntValue di player.leaderstats, jadi otomatis ikut berubah
	saat server menambah coins.
]]
local function createHud()
	local playerGui = player:WaitForChild("PlayerGui")

	local gui = Instance.new("ScreenGui")
	gui.Name = "CoinHud"
	gui.ResetOnSpawn = false
	-- false = otomatis diberi jarak dari topbar Roblox (menu, chat, leaderboard).
	-- Kalau true, GUI akan menimpa topbar bawaan.
	gui.IgnoreGuiInset = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "Container"
	frame.AnchorPoint = Vector2.new(0, 0)
	-- Ditempel di kiri-atas, TEPAT DI BAWAH topbar Roblox.
	-- y = 0 berarti sudah di bawah inset, jadi cukup beri sedikit margin.
	frame.Position = UDim2.new(0, 12, 0, 10)
	frame.Size = UDim2.new(0, 170, 0, 46)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 200, 60)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.35
	stroke.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = frame

	-- Ikon coin (lingkaran kuning)
	local icon = Instance.new("Frame")
	icon.Name = "Icon"
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.Position = UDim2.new(0, 0, 0.5, 0)
	icon.Size = UDim2.new(0, 22, 0, 22)
	icon.BackgroundColor3 = Color3.fromRGB(255, 205, 60)
	icon.BorderSizePixel = 0
	icon.Parent = frame

	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(1, 0)
	iconCorner.Parent = icon

	local iconShine = Instance.new("Frame")
	iconShine.Size = UDim2.new(0.45, 0, 0.45, 0)
	iconShine.Position = UDim2.new(0.12, 0, 0.12, 0)
	iconShine.BackgroundColor3 = Color3.fromRGB(255, 240, 190)
	iconShine.BackgroundTransparency = 0.35
	iconShine.BorderSizePixel = 0
	iconShine.Parent = icon

	local iconShineCorner = Instance.new("UICorner")
	iconShineCorner.CornerRadius = UDim.new(1, 0)
	iconShineCorner.Parent = iconShine

	local label = Instance.new("TextLabel")
	label.Name = "Amount"
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 32, 0, 0)
	label.Size = UDim2.new(1, -32, 1, 0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 22
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = "0"
	label.Parent = frame

	return label
end

local coinLabel = createHud()

local leaderstats = player:WaitForChild("leaderstats")
local coinsValue = leaderstats:WaitForChild(Config.Leaderstats.Coins) :: IntValue

local function updateCoins(value: number)
	coinLabel.Text = tostring(value)

	-- Animasi "punch" kecil setiap kali bertambah
	coinLabel.TextSize = 27
	TweenService:Create(coinLabel, TweenInfo.new(0.15, Enum.EasingStyle.Back), { TextSize = 22 }):Play()
end

coinsValue:GetPropertyChangedSignal("Value"):Connect(function()
	updateCoins(coinsValue.Value)
end)

updateCoins(coinsValue.Value)

--[[
	Panel sambutan: muncul sekali saat pemain masuk.
	Ditunggu sebentar supaya tidak bertabrakan dengan loading screen Roblox.
]]
local SHOW_WELCOME = true
local WELCOME_DELAY = 1.2 -- detik

if SHOW_WELCOME and WelcomeGui then
	task.delay(WELCOME_DELAY, function()
		print("[Client] menampilkan WelcomeGui...")
		local ok, err = pcall(function()
			WelcomeGui.show()
		end)
		if not ok then
			warn("[Client] GAGAL menampilkan WelcomeGui: " .. tostring(err))
		else
			print("[Client] WelcomeGui ditampilkan")
		end
	end)
end

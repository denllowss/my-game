--[[
	WelcomeGui
	Panel sambutan yang muncul sekali saat pemain masuk game.
	Bisa ditutup dengan tombol, klik backdrop, atau tombol Escape.

	Cara pakai:
		local WelcomeGui = require(script.Parent.Gui.WelcomeGui)
		WelcomeGui.show()
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer

local WelcomeGui = {}

local COLORS = {
	card = Color3.fromRGB(20, 20, 30),
	accent = Color3.fromRGB(255, 205, 60),
	accentDark = Color3.fromRGB(0, 140, 255),
	text = Color3.fromRGB(255, 255, 255),
	textDim = Color3.fromRGB(170, 172, 190),
	button = Color3.fromRGB(0, 150, 255),
}

local function corner(parent: Instance, radius: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(parent: Instance, color: Color3, transparency: number?)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = 1.5
	s.Transparency = transparency or 0.3
	s.Parent = parent
	return s
end

--[[
	Membuat satu baris "tips" dengan ikon bulat kecil.
]]
local function makeTipRow(parent: Instance, order: number, iconColor: Color3, text: string)
	local row = Instance.new("Frame")
	row.Name = "Tip" .. order
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, 0, 0, 28)
	row.LayoutOrder = order
	row.Parent = parent

	local dot = Instance.new("Frame")
	dot.AnchorPoint = Vector2.new(0, 0.5)
	dot.Position = UDim2.new(0, 4, 0.5, 0)
	dot.Size = UDim2.new(0, 10, 0, 10)
	dot.BackgroundColor3 = iconColor
	dot.BorderSizePixel = 0
	dot.Parent = row
	corner(dot, 999)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 24, 0, 0)
	label.Size = UDim2.new(1, -24, 1, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = COLORS.textDim
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	label.Parent = row
end

--[[
	Menampilkan panel sambutan.
]]
function WelcomeGui.show()
	local playerGui = player:WaitForChild("PlayerGui")

	-- Jangan dobel kalau sudah ada
	local existing = playerGui:FindFirstChild("WelcomeGui")
	if existing then
		existing:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "WelcomeGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true -- backdrop harus menutupi seluruh layar
	gui.DisplayOrder = 50
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = playerGui

	-- Backdrop gelap + blur
	local backdrop = Instance.new("Frame")
	backdrop.Name = "Backdrop"
	backdrop.Size = UDim2.fromScale(1, 1)
	backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	backdrop.BackgroundTransparency = 1
	backdrop.BorderSizePixel = 0
	backdrop.ZIndex = 1
	backdrop.Parent = gui

	local blur = Instance.new("BlurEffect")
	blur.Size = 0
	blur.Parent = game:GetService("Lighting")

	-- Kartu utama
	local card = Instance.new("Frame")
	card.Name = "Card"
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.fromScale(0.5, 0.5)
	card.Size = UDim2.new(0, 420, 0, 0)
	card.BackgroundColor3 = COLORS.card
	card.BackgroundTransparency = 0.05
	card.BorderSizePixel = 0
	card.ZIndex = 2
	card.Parent = gui

	corner(card, 18)
	stroke(card, COLORS.accent, 0.45)

	local cardPadding = Instance.new("UIPadding")
	cardPadding.PaddingTop = UDim.new(0, 26)
	cardPadding.PaddingBottom = UDim.new(0, 22)
	cardPadding.PaddingLeft = UDim.new(0, 26)
	cardPadding.PaddingRight = UDim.new(0, 26)
	cardPadding.Parent = card

	local cardLayout = Instance.new("UIListLayout")
	cardLayout.FillDirection = Enum.FillDirection.Vertical
	cardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
	cardLayout.Padding = UDim.new(0, 8)
	cardLayout.Parent = card

	-- Ikon coin besar di atas judul
	local badge = Instance.new("Frame")
	badge.Name = "Badge"
	badge.LayoutOrder = 1
	badge.Size = UDim2.new(0, 66, 0, 66)
	badge.BackgroundColor3 = COLORS.accent
	badge.BorderSizePixel = 0
	badge.Parent = card
	corner(badge, 999)

	local badgeGlow = Instance.new("UIStroke")
	badgeGlow.Color = COLORS.accent
	badgeGlow.Thickness = 3
	badgeGlow.Transparency = 0.55
	badgeGlow.Parent = badge

	local badgeInner = Instance.new("Frame")
	badgeInner.AnchorPoint = Vector2.new(0.5, 0.5)
	badgeInner.Position = UDim2.fromScale(0.5, 0.5)
	badgeInner.Size = UDim2.new(0, 34, 0, 34)
	badgeInner.BackgroundColor3 = Color3.fromRGB(255, 240, 190)
	badgeInner.BackgroundTransparency = 0.25
	badgeInner.BorderSizePixel = 0
	badgeInner.Parent = badge
	corner(badgeInner, 999)

	-- Judul
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.LayoutOrder = 2
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 0, 38)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 28
	title.TextColor3 = COLORS.text
	title.Text = ("Selamat datang di %s"):format(Config.GameName)
	title.Parent = card

	-- Sapaan personal
	local greeting = Instance.new("TextLabel")
	greeting.Name = "Greeting"
	greeting.LayoutOrder = 3
	greeting.BackgroundTransparency = 1
	greeting.Size = UDim2.new(1, 0, 0, 24)
	greeting.Font = Enum.Font.GothamMedium
	greeting.TextSize = 16
	greeting.TextColor3 = COLORS.accent
	greeting.Text = ("Hai, %s!"):format(player.DisplayName)
	greeting.Parent = card

	-- Sub-judul
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.LayoutOrder = 4
	subtitle.BackgroundTransparency = 1
	subtitle.Size = UDim2.new(1, 0, 0, 20)
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 14
	subtitle.TextColor3 = COLORS.textDim
	subtitle.Text = "Kumpulkan coin sebanyak mungkin."
	subtitle.Parent = card

	-- Garis pemisah
	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.LayoutOrder = 5
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.BackgroundColor3 = Color3.fromRGB(60, 62, 80)
	divider.BorderSizePixel = 0
	divider.Parent = card

	-- Daftar tips
	local tips = Instance.new("Frame")
	tips.Name = "Tips"
	tips.LayoutOrder = 6
	tips.BackgroundTransparency = 1
	tips.Size = UDim2.new(1, 0, 0, 96)
	tips.Parent = card

	local tipsLayout = Instance.new("UIListLayout")
	tipsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tipsLayout.Padding = UDim.new(0, 6)
	tipsLayout.Parent = tips

	makeTipRow(tips, 1, COLORS.accent, "Sentuh coin kuning untuk mendapat 1 coin")
	makeTipRow(tips, 2, COLORS.accent, "Coin muncul lagi setelah 5 detik")
	makeTipRow(tips, 3, COLORS.accentDark, "Lihat total coin di kiri atas layar")

	-- Tombol mulai
	local button = Instance.new("TextButton")
	button.Name = "StartButton"
	button.LayoutOrder = 7
	button.Size = UDim2.new(1, 0, 0, 46)
	button.BackgroundColor3 = COLORS.button
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Font = Enum.Font.GothamBold
	button.TextSize = 17
	button.TextColor3 = COLORS.text
	button.Text = "Mulai Bermain"
	button.Parent = card
	corner(button, 12)

	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = Color3.fromRGB(120, 200, 255)
	buttonStroke.Thickness = 1.5
	buttonStroke.Transparency = 0.5
	buttonStroke.Parent = button

	-- Hint kecil di bawah tombol
	local hint = Instance.new("TextLabel")
	hint.Name = "Hint"
	hint.LayoutOrder = 8
	hint.BackgroundTransparency = 1
	hint.Size = UDim2.new(1, 0, 0, 18)
	hint.Font = Enum.Font.Gotham
	hint.TextSize = 12
	hint.TextColor3 = Color3.fromRGB(120, 122, 140)
	hint.Text = "Tekan Escape atau klik di luar kotak untuk menutup"
	hint.Parent = card

	-- ============================ ANIMASI ============================
	local cardTargetSize = UDim2.new(0, 420, 0, 470)
	local closing = false

	local function close()
		if closing then
			return
		end
		closing = true

		local shrink = TweenService:Create(
			card,
			TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ Size = UDim2.new(0, 420, 0, 0), BackgroundTransparency = 1 }
		)
		TweenService:Create(
			backdrop,
			TweenInfo.new(0.22),
			{ BackgroundTransparency = 1 }
		):Play()
		TweenService:Create(
			blur,
			TweenInfo.new(0.22),
			{ Size = 0 }
		):Play()

		shrink:Play()
		shrink.Completed:Wait()
		blur:Destroy()
		gui:Destroy()
	end

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(0, 175, 255) }):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), { BackgroundColor3 = COLORS.button }):Play()
	end)
	button.Activated:Connect(close)

	-- Klik backdrop juga menutup
	local backdropButton = Instance.new("TextButton")
	backdropButton.Name = "BackdropButton"
	backdropButton.Size = UDim2.fromScale(1, 1)
	backdropButton.BackgroundTransparency = 1
	backdropButton.Text = ""
	backdropButton.ZIndex = 1
	backdropButton.Parent = gui
	backdropButton.Activated:Connect(close)

	-- Escape untuk menutup
	local userInput = game:GetService("UserInputService")
	local connection
	connection = userInput.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.KeyCode == Enum.KeyCode.Escape then
			close()
		end
	end)

	-- Bersihkan koneksi & blur kalau GUI dihancurkan dengan cara lain
	gui.Destroying:Connect(function()
		if connection then
			connection:Disconnect()
		end
		if blur and blur.Parent then
			blur:Destroy()
		end
	end)

	-- Animasi masuk
	backdrop.BackgroundTransparency = 1
	TweenService:Create(backdrop, TweenInfo.new(0.35), { BackgroundTransparency = 0.45 }):Play()
	TweenService:Create(blur, TweenInfo.new(0.35), { Size = 14 }):Play()

	card.BackgroundTransparency = 1
	TweenService:Create(
		card,
		TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = cardTargetSize, BackgroundTransparency = 0.05 }
	):Play()

	-- Denyut halus pada badge ikon
	task.spawn(function()
		local t = 0
		while badge.Parent do
			t += RunService.RenderStepped:Wait()
			local pulse = 1 + math.sin(t * 2.2) * 0.04
			badgeInner.Size = UDim2.new(0, 34 * pulse, 0, 34 * pulse)
		end
	end)

	return gui
end

return WelcomeGui

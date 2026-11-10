--[[
	CoinService
	Membuat coin di dunia dan menangani pengambilannya.

	Cara pakai dari script lain:
		local CoinService = require(script.Parent.Services.CoinService)
		CoinService.start()                                  -- mulai otomatis (coin dibuat acak)
		CoinService.createCoinAt(Vector3.new(0, 5, 0))       -- coin manual
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Shared.Config)
local Leaderstats = require(script.Parent.Leaderstats)

local CoinService = {}

local coinConfig = Config.Coin
local visual = Config.CoinVisual

local coinFolder: Folder? = nil
local activeCoins = 0

local function getCoinFolder(): Folder
	if coinFolder and coinFolder.Parent then
		return coinFolder
	end

	local existing = Workspace:FindFirstChild("Coins")
	if existing and existing:IsA("Folder") then
		coinFolder = existing
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = "Coins"
	folder.Parent = Workspace
	coinFolder = folder
	return folder
end

--- Membuat model coin lengkap (part + light + efek visual).
local function buildCoin(position: Vector3): BasePart
	local part = Instance.new("Part")
	part.Name = "Coin"
	part.Shape = Enum.PartType.Cylinder
	part.Size = Vector3.new(0.4, 2, 2)
	part.Color = visual.Color
	part.Material = Enum.Material.Neon
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = true
	part.CastShadow = false
	part.Position = position
	part.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))

	local light = Instance.new("PointLight")
	light.Color = visual.LightColor
	light.Range = visual.LightRange
	light.Brightness = visual.LightBrightness
	light.Enabled = visual.EmitLight
	light.Parent = part

	-- Efek naik-turun halus
	local basePosition = position
	task.spawn(function()
		local t = 0
		while part.Parent do
			t += task.wait()
			local offset = math.sin(t * visual.BobSpeed) * visual.BobHeight
			part.CFrame = CFrame.new(basePosition + Vector3.new(0, offset, 0))
				* CFrame.Angles(0, t * visual.SpinSpeed, math.rad(90))
		end
	end)

	return part
end

--[[
	Menangani satu coin yang tersentuh pemain.
	Debounce memakai atribut supaya aman kalau tersentuh berkali-kali.
]]
local function hookCoin(part: BasePart)
	part.Touched:Connect(function(hit)
		if part:GetAttribute("Collected") then
			return
		end

		local character = hit:FindFirstAncestorOfClass("Model")
		if not character then
			return
		end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end

		part:SetAttribute("Collected", true)
		activeCoins -= 1

		Leaderstats.addCoins(player, coinConfig.Amount)

		-- Efek ambil: mengecil lalu hilang
		local shrink = TweenService:Create(
			part,
			TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{ Size = Vector3.new(0.4, 0.2, 0.2), Transparency = 1 }
		)
		shrink:Play()
		shrink.Completed:Wait()

		task.delay(coinConfig.RespawnTime, function()
			if not part.Parent then
				return
			end
			part.Size = Vector3.new(0.4, 2, 2)
			part.Transparency = 0
			part:SetAttribute("Collected", false)
			activeCoins += 1
		end)
	end)
end

--- Membuat coin di posisi tertentu. Mengembalikan part-nya.
function CoinService.createCoinAt(position: Vector3): BasePart
	local folder = getCoinFolder()
	local part = buildCoin(position)
	part.Parent = folder
	hookCoin(part)
	activeCoins += 1
	return part
end

--[[
	Membuat coin acak di atas baseplate.
	Ketinggian diambil dari raycast supaya coin menempel di permukaan,
	bukan melayang di udara atau tenggelam.
]]
function CoinService.scatterCoins(count: number, radius: number?)
	local areaRadius = radius or 60
	local folder = getCoinFolder()

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { folder }

	local made = 0
	local attempts = 0

	while made < count and attempts < count * 5 do
		attempts += 1

		local x = (math.random() * 2 - 1) * areaRadius
		local z = (math.random() * 2 - 1) * areaRadius
		local origin = Vector3.new(x, 200, z)

		local result = Workspace:Raycast(origin, Vector3.new(0, -400, 0), raycastParams)
		if not result then
			continue
		end

		-- Jangan menaruh coin di dinding/atap
		if result.Normal.Y < 0.7 then
			continue
		end

		-- Hindari menumpuk coin di titik yang sama
		local tooClose = false
		for _, other in folder:GetChildren() do
			if other:IsA("BasePart") and (other.Position - result.Position).Magnitude < 6 then
				tooClose = true
				break
			end
		end
		if tooClose then
			continue
		end

		CoinService.createCoinAt(result.Position + Vector3.new(0, 3, 0))
		made += 1
	end

	print(("[CoinService] %d coin dibuat"):format(made))
	return made
end

--- Mulai layanan: buat coin otomatis kalau belum ada.
function CoinService.start()
	local folder = getCoinFolder()
	if #folder:GetChildren() > 0 then
		-- Jangan duplikat kalau script jalan ulang
		for _, part in folder:GetChildren() do
			if part:IsA("BasePart") and not part:GetAttribute("Collected") then
				hookCoin(part)
			end
		end
		return
	end

	CoinService.scatterCoins(coinConfig.MaxActive)
end

return CoinService

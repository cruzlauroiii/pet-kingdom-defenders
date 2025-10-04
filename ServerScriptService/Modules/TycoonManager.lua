--[[
	TycoonManager - Manages player-owned base building and automation
	Players purchase buildings that generate passive income
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManager = require(ServerScriptService.Modules.DataManager)
local ProceduralBuildingGenerator = require(ServerScriptService.Modules.ProceduralBuildingGenerator)
local Config = require(ReplicatedStorage.Shared.Config)

local TycoonManager = {}
TycoonManager.PlayerBases = {} -- player.UserId -> base data

function TycoonManager:Initialize()
	print("[TycoonManager] Initializing...")

	-- Setup remotes
	local purchaseBuildingRemote = ReplicatedStorage.Remotes.PurchaseBuilding
	purchaseBuildingRemote.OnServerEvent:Connect(function(player, buildingId)
		self:PurchaseBuilding(player, buildingId)
	end)

	local collectIncomeRemote = ReplicatedStorage.Remotes.CollectIncome
	collectIncomeRemote.OnServerEvent:Connect(function(player)
		self:CollectIncome(player)
	end)

	-- Start income generation loop
	task.spawn(function()
		self:IncomeGenerationLoop()
	end)

	print("[TycoonManager] Initialized successfully!")
end

function TycoonManager:SetupPlayerBase(player, playerData)
	-- Initialize base
	self.PlayerBases[player.UserId] = {
		Buildings = playerData.UnlockedBuildings,
		PendingIncome = 0,
		LastIncomeTime = tick()
	}

	-- Spawn base in world (simplified)
	self:SpawnBase(player)
end

function TycoonManager:CleanupPlayerBase(player)
	-- Clean up base
	self:DespawnBase(player)
	self.PlayerBases[player.UserId] = nil
end

-- Spawn player's base in workspace
function TycoonManager:SpawnBase(player)
	local character = player.Character
	if not character then return end

	-- Create base plot (simplified)
	local basePlot = Instance.new("Part")
	basePlot.Name = player.Name .. "_Base"
	basePlot.Size = Vector3.new(50, 1, 50)
	basePlot.Anchored = true
	basePlot.BrickColor = BrickColor.new("Bright green")
	basePlot.Position = Vector3.new(player.UserId % 10 * 60, 0.5, math.floor(player.UserId / 10) * 60)
	basePlot.Parent = workspace.Bases or workspace

	-- Spawn buildings
	local baseData = self.PlayerBases[player.UserId]
	for _, buildingId in ipairs(baseData.Buildings) do
		self:SpawnBuilding(player, buildingId)
	end
end

-- Despawn player's base
function TycoonManager:DespawnBase(player)
	local basePlot = workspace:FindFirstChild(player.Name .. "_Base")
	if basePlot then
		basePlot:Destroy()
	end
end

-- Spawn individual building
function TycoonManager:SpawnBuilding(player, buildingId)
	local buildingConfig = Config.BUILDINGS[buildingId]
	if not buildingConfig then return end

	local basePlot = workspace:FindFirstChild(player.Name .. "_Base")
	if not basePlot then return end

	-- Create building model using ProceduralBuildingGenerator (NO mesh IDs!)
	local buildingPosition = basePlot.Position + buildingConfig.Offset + Vector3.new(0, 5, 0)
	local building = ProceduralBuildingGenerator:GenerateBuilding(
		buildingConfig.Type or "Building",
		buildingConfig.Name,
		buildingPosition
	)

	if not building then
		warn("[TycoonManager] Failed to generate building:", buildingId)
		return
	end

	building.Name = "Building_" .. buildingId
	building.Parent = basePlot

	-- Generate purchase button if not owned yet
	local playerData = DataManager:GetData(player)
	if playerData and not table.find(playerData.UnlockedBuildings, buildingId) then
		local button = ProceduralBuildingGenerator:GeneratePurchaseButton(
			building,
			buildingConfig.Cost,
			buildingConfig.CostType or "Coins"
		)
		button.Parent = building
	end
end

-- Purchase a building
function TycoonManager:PurchaseBuilding(player, buildingId)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local buildingConfig = Config.BUILDINGS[buildingId]
	if not buildingConfig then
		warn("[TycoonManager] Invalid building ID:", buildingId)
		return
	end

	-- Check if already owned
	if table.find(playerData.UnlockedBuildings, buildingId) then
		return
	end

	-- Check prerequisites
	for _, prereq in ipairs(buildingConfig.Prerequisites) do
		if not table.find(playerData.UnlockedBuildings, prereq) then
			ReplicatedStorage.Remotes.PurchaseResult:FireClient(player, false, "Prerequisites not met")
			return
		end
	end

	-- Check cost
	if playerData.Coins < buildingConfig.Cost then
		ReplicatedStorage.Remotes.PurchaseResult:FireClient(player, false, "Not enough Coins")
		return
	end

	-- Purchase building
	DataManager:RemoveCurrency(player, "Coins", buildingConfig.Cost)
	table.insert(playerData.UnlockedBuildings, buildingId)
	table.insert(self.PlayerBases[player.UserId].Buildings, buildingId)

	-- Spawn building
	self:SpawnBuilding(player, buildingId)

	-- Increase tycoon level
	playerData.TycoonLevel += 1

	ReplicatedStorage.Remotes.PurchaseResult:FireClient(player, true, buildingId)

	print(string.format("[TycoonManager] %s purchased %s", player.Name, buildingId))
end

-- Income generation loop (runs every 5 seconds)
function TycoonManager:IncomeGenerationLoop()
	while true do
		task.wait(5)

		for userId, baseData in pairs(self.PlayerBases) do
			local player = game.Players:GetPlayerByUserId(userId)
			if player then
				local income = self:CalculateIncome(player)
				baseData.PendingIncome += income

				-- Notify player
				ReplicatedStorage.Remotes.IncomeGenerated:FireClient(player, baseData.PendingIncome)
			end
		end
	end
end

-- Calculate passive income from buildings
function TycoonManager:CalculateIncome(player)
	local baseData = self.PlayerBases[player.UserId]
	if not baseData then return 0 end

	local totalIncome = 0

	for _, buildingId in ipairs(baseData.Buildings) do
		local buildingConfig = Config.BUILDINGS[buildingId]
		if buildingConfig then
			totalIncome += buildingConfig.IncomePerSecond * 5 -- 5 second interval
		end
	end

	return totalIncome
end

-- Collect pending income
function TycoonManager:CollectIncome(player)
	local baseData = self.PlayerBases[player.UserId]
	if not baseData then return end

	if baseData.PendingIncome > 0 then
		DataManager:AddCurrency(player, "Coins", math.floor(baseData.PendingIncome))

		ReplicatedStorage.Remotes.IncomeCollected:FireClient(player, baseData.PendingIncome)

		baseData.PendingIncome = 0
	end
end

return TycoonManager

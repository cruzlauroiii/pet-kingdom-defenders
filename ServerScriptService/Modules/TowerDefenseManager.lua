--[[
	TowerDefenseManager - Handles wave-based enemy spawning and tower defense gameplay
	Players use their pets to defend against waves of enemies
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManager = require(ServerScriptService.Modules.DataManager)
local ProceduralEnemyGenerator = require(ServerScriptService.Modules.ProceduralEnemyGenerator)
local Config = require(ReplicatedStorage.Shared.Config)

local TowerDefenseManager = {}
TowerDefenseManager.ActiveGames = {} -- player.UserId -> game state

function TowerDefenseManager:Initialize()
	print("[TowerDefenseManager] Initializing...")

	-- Setup remotes
	local startWaveRemote = ReplicatedStorage.Remotes.StartWave
	startWaveRemote.OnServerEvent:Connect(function(player)
		self:StartWave(player)
	end)

	local placeTowerRemote = ReplicatedStorage.Remotes.PlaceTower
	placeTowerRemote.OnServerEvent:Connect(function(player, petId, position)
		self:PlaceTower(player, petId, position)
	end)

	print("[TowerDefenseManager] Initialized successfully!")
end

-- Start a new wave
function TowerDefenseManager:StartWave(player)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	-- Initialize game state if not exists
	if not self.ActiveGames[player.UserId] then
		self.ActiveGames[player.UserId] = {
			CurrentWave = 0,
			Health = Config.TD_BASE_HEALTH,
			PlacedTowers = {},
			ActiveEnemies = {},
			IsWaveActive = false
		}
	end

	local gameState = self.ActiveGames[player.UserId]

	if gameState.IsWaveActive then
		return -- Already in a wave
	end

	-- Start next wave
	gameState.CurrentWave += 1
	gameState.IsWaveActive = true

	ReplicatedStorage.Remotes.WaveStarted:FireClient(player, gameState.CurrentWave)

	-- Spawn enemies
	task.spawn(function()
		self:SpawnWaveEnemies(player, gameState.CurrentWave)
	end)
end

-- Spawn enemies for current wave
function TowerDefenseManager:SpawnWaveEnemies(player, waveNumber)
	local gameState = self.ActiveGames[player.UserId]
	if not gameState then return end

	-- Use ProceduralEnemyGenerator to create wave enemies
	local enemies = ProceduralEnemyGenerator:GenerateWave(waveNumber)

	-- Ensure Enemies folder exists
	local enemiesFolder = workspace:FindFirstChild("Enemies")
	if not enemiesFolder then
		enemiesFolder = Instance.new("Folder")
		enemiesFolder.Name = "Enemies"
		enemiesFolder.Parent = workspace
	end

	for i, enemyModel in ipairs(enemies) do
		if not gameState.IsWaveActive then break end

		-- Get enemy data from model attributes
		local enemyId = game:GetService("HttpService"):GenerateGUID(false)
		local primaryPart = enemyModel.PrimaryPart

		if primaryPart then
			-- Position enemy at spawn point
			local spawnPosition = Vector3.new(-50, 5, 0) -- TD spawn point
			enemyModel:SetPrimaryPartCFrame(CFrame.new(spawnPosition))
			enemyModel.Name = "Enemy_" .. enemyId
			enemyModel.Parent = enemiesFolder

			-- Create enemy data structure
			local enemy = {
				Id = enemyId,
				Model = enemyModel,
				Health = primaryPart:GetAttribute("Health"),
				MaxHealth = primaryPart:GetAttribute("MaxHealth"),
				Speed = primaryPart:GetAttribute("Speed"),
				Reward = primaryPart:GetAttribute("Reward"),
				Position = 0 -- Path position
			}

			table.insert(gameState.ActiveEnemies, enemy)

			-- Notify client
			ReplicatedStorage.Remotes.EnemySpawned:FireClient(player, enemy)

			-- Enemy movement
			task.spawn(function()
				self:MoveEnemy(player, enemy)
			end)
		end

		task.wait(1) -- Spawn delay
	end
end

-- Move enemy along path
function TowerDefenseManager:MoveEnemy(player, enemy)
	local gameState = self.ActiveGames[player.UserId]
	if not gameState then return end

	while enemy.Health > 0 and gameState.IsWaveActive do
		task.wait(0.1)

		-- Move enemy forward
		enemy.Position += enemy.Speed * 0.1

		-- Check if reached end
		if enemy.Position >= Config.TD_PATH_LENGTH then
			-- Damage base
			gameState.Health -= 1

			if gameState.Health <= 0 then
				self:GameOver(player, false)
			end

			-- Remove enemy
			self:RemoveEnemy(player, enemy.Id)
			break
		end

		-- Check tower attacks
		for _, tower in ipairs(gameState.PlacedTowers) do
			if tower.LastAttack + tower.AttackCooldown <= tick() then
				-- Simple range check (would use actual positions in production)
				if math.abs(tower.Position - enemy.Position) <= tower.Range then
					enemy.Health -= tower.Damage

					-- Update visual health bar
					if enemy.Model then
						ProceduralEnemyGenerator:UpdateHealthBar(enemy.Model, enemy.Health, enemy.MaxHealth)
					end

					tower.LastAttack = tick()

					if enemy.Health <= 0 then
						self:EnemyDefeated(player, enemy)
						break
					end
				end
			end
		end
	end
end

-- Enemy defeated
function TowerDefenseManager:EnemyDefeated(player, enemy)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	-- Award rewards
	DataManager:AddCurrency(player, "Coins", enemy.Reward)
	DataManager:AddExperience(player, math.floor(enemy.Reward / 2))

	playerData.TotalEnemiesDefeated += 1

	-- Remove enemy
	self:RemoveEnemy(player, enemy.Id)

	-- Check if wave complete
	self:CheckWaveComplete(player)
end

-- Remove enemy from game
function TowerDefenseManager:RemoveEnemy(player, enemyId)
	local gameState = self.ActiveGames[player.UserId]
	if not gameState then return end

	for i, enemy in ipairs(gameState.ActiveEnemies) do
		if enemy.Id == enemyId then
			-- Destroy visual model
			if enemy.Model and enemy.Model.Parent then
				enemy.Model:Destroy()
			end

			table.remove(gameState.ActiveEnemies, i)
			ReplicatedStorage.Remotes.EnemyRemoved:FireClient(player, enemyId)
			break
		end
	end
end

-- Check if wave is complete
function TowerDefenseManager:CheckWaveComplete(player)
	local gameState = self.ActiveGames[player.UserId]
	if not gameState then return end

	if #gameState.ActiveEnemies == 0 and gameState.IsWaveActive then
		gameState.IsWaveActive = false

		local playerData = DataManager:GetData(player)
		if playerData and gameState.CurrentWave > playerData.HighestWave then
			playerData.HighestWave = gameState.CurrentWave
		end

		-- Award wave completion bonus
		local bonus = gameState.CurrentWave * 100
		DataManager:AddCurrency(player, "Coins", bonus)

		ReplicatedStorage.Remotes.WaveComplete:FireClient(player, gameState.CurrentWave, bonus)
	end
end

-- Place pet as tower
function TowerDefenseManager:PlaceTower(player, petId, position)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local gameState = self.ActiveGames[player.UserId]
	if not gameState then return end

	-- Find pet
	local petData = nil
	for _, pet in ipairs(playerData.Pets) do
		if pet.Id == petId then
			petData = pet
			break
		end
	end

	if not petData then return end

	-- Create tower from pet
	local tower = {
		PetId = petId,
		Position = position,
		Damage = 10 * petData.PowerMultiplier * petData.Level,
		Range = 20,
		AttackCooldown = 1,
		LastAttack = 0
	}

	table.insert(gameState.PlacedTowers, tower)

	ReplicatedStorage.Remotes.TowerPlaced:FireClient(player, tower)
end

-- Game over
function TowerDefenseManager:GameOver(player, victory)
	local gameState = self.ActiveGames[player.UserId]
	if not gameState then return end

	gameState.IsWaveActive = false
	gameState.ActiveEnemies = {}

	ReplicatedStorage.Remotes.GameOver:FireClient(player, victory, gameState.CurrentWave)
end

return TowerDefenseManager

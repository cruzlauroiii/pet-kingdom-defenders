--[[
	DataManager - Handles all player data storage and retrieval using DataStore2
	Manages player progression, pets, currency, and statistics
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local DataManager = {}
DataManager.PlayerData = {} -- In-memory cache of player data

-- Default player data structure
local DEFAULT_DATA = {
	-- Currency
	Coins = 1000,
	Gems = 50,

	-- Pets
	Pets = {},
	EquippedPets = {},

	-- Progression
	Level = 1,
	Experience = 0,
	TotalPlayTime = 0,

	-- Tycoon
	TycoonLevel = 1,
	UnlockedBuildings = {},

	-- Tower Defense
	HighestWave = 0,
	TotalEnemiesDefeated = 0,

	-- Obby
	CompletedObbies = {},
	BestObbyTimes = {},

	-- Statistics
	TotalPetsHatched = 0,
	TotalTradesCompleted = 0,
	LoginStreak = 0,
	LastLogin = 0,

	-- Settings
	Settings = {
		MusicEnabled = true,
		SFXEnabled = true,
		ParticlesEnabled = true,
		MobileMode = false
	}
}

-- DataStore instances
local PlayerDataStore
local BackupDataStore

function DataManager:Initialize()
	print("[DataManager] Initializing...")

	-- DataStore Version Management (2025 Best Practices)
	-- IMPORTANT: Use different versions for Testing vs Production!
	--
	-- FOR TESTING (in Studio):
	-- PlayerDataStore = DataStoreService:GetDataStore("PlayerData_TEST_V1")
	-- BackupDataStore = DataStoreService:GetDataStore("PlayerDataBackup_TEST_V1")
	--
	-- FOR PRODUCTION (published game):
	-- PlayerDataStore = DataStoreService:GetDataStore("PlayerData_PROD_V1")
	-- BackupDataStore = DataStoreService:GetDataStore("PlayerDataBackup_PROD_V1")
	--
	-- Version Increment Rules:
	-- - Change data structure? Increment version (V1 → V2)
	-- - Add new fields? Keep same version (backward compatible)
	-- - Major update? New version to avoid conflicts
	-- - Never mix test and production data!
	--
	-- 2025 DataStore Updates:
	-- - Creator Hub now has DataStore Manager (view/compare versions)
	-- - Session locking prevents concurrent edits
	-- - Use UpdateAsync for atomic operations

	-- Initialize DataStores
	local success, err = pcall(function()
		-- PRODUCTION VERSION - Change before publishing!
		PlayerDataStore = DataStoreService:GetDataStore("PlayerData_PROD_V1")
		BackupDataStore = DataStoreService:GetDataStore("PlayerDataBackup_PROD_V1")

		-- For testing, use: PlayerData_TEST_V1
		-- NEVER use the same name for both test and production!
	end)

	if not success then
		warn("[DataManager] Failed to initialize DataStores:", err)
		warn("[DataManager] Running in offline mode - data will not persist!")
		warn("[DataManager] Enable 'Studio Access to API Services' in Game Settings")
	end

	print("[DataManager] DataStore Version: PROD_V1")
	print("[DataManager] Initialized successfully!")
end

-- Deep copy table
local function deepCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = deepCopy(value)
		else
			copy[key] = value
		end
	end
	return copy
end

-- Load player data from DataStore
function DataManager:LoadPlayerData(player)
	local userId = player.UserId
	local dataKey = "Player_" .. userId

	print("[DataManager] Loading data for:", player.Name)

	-- Start with default data
	local playerData = deepCopy(DEFAULT_DATA)

	-- Try to load from DataStore
	if PlayerDataStore then
		local success, savedData = pcall(function()
			return PlayerDataStore:GetAsync(dataKey)
		end)

		if success and savedData then
			-- Merge saved data with defaults (in case new fields were added)
			for key, value in pairs(savedData) do
				playerData[key] = value
			end
			print("[DataManager] Loaded existing data for:", player.Name)
		else
			print("[DataManager] No existing data found, using defaults for:", player.Name)
		end
	end

	-- Update login stats
	local currentTime = os.time()
	local daysSinceLastLogin = math.floor((currentTime - playerData.LastLogin) / 86400)

	if daysSinceLastLogin == 1 then
		playerData.LoginStreak += 1
	elseif daysSinceLastLogin > 1 then
		playerData.LoginStreak = 1
	end

	playerData.LastLogin = currentTime

	-- Cache in memory
	self.PlayerData[userId] = playerData

	return true, playerData
end

-- Save player data to DataStore
function DataManager:SavePlayerData(player)
	local userId = player.UserId
	local dataKey = "Player_" .. userId

	local playerData = self.PlayerData[userId]
	if not playerData then
		warn("[DataManager] No data to save for:", player.Name)
		return false
	end

	print("[DataManager] Saving data for:", player.Name)

	if PlayerDataStore then
		local success, err = pcall(function()
			PlayerDataStore:SetAsync(dataKey, playerData)
		end)

		if success then
			print("[DataManager] Successfully saved data for:", player.Name)

			-- Also save to backup
			pcall(function()
				BackupDataStore:SetAsync(dataKey, playerData)
			end)

			return true
		else
			warn("[DataManager] Failed to save data for:", player.Name, err)
			return false
		end
	end

	return false
end

-- Get player data
function DataManager:GetData(player)
	return self.PlayerData[player.UserId]
end

-- Update player data
function DataManager:UpdateData(player, key, value)
	local data = self.PlayerData[player.UserId]
	if data then
		data[key] = value
		return true
	end
	return false
end

-- Add currency
function DataManager:AddCurrency(player, currencyType, amount)
	local data = self.PlayerData[player.UserId]
	if data and data[currencyType] then
		data[currencyType] += amount

		-- Fire client update event
		local remoteEvent = ReplicatedStorage.Remotes.UpdateCurrency
		if remoteEvent then
			remoteEvent:FireClient(player, currencyType, data[currencyType])
		end

		return true
	end
	return false
end

-- Remove currency
function DataManager:RemoveCurrency(player, currencyType, amount)
	local data = self.PlayerData[player.UserId]
	if data and data[currencyType] and data[currencyType] >= amount then
		data[currencyType] -= amount

		-- Fire client update event
		local remoteEvent = ReplicatedStorage.Remotes.UpdateCurrency
		if remoteEvent then
			remoteEvent:FireClient(player, currencyType, data[currencyType])
		end

		return true
	end
	return false
end

-- Add experience
function DataManager:AddExperience(player, amount)
	local data = self.PlayerData[player.UserId]
	if not data then return false end

	data.Experience += amount

	-- Check for level up
	local expNeeded = Config.LEVEL_EXPERIENCE_FORMULA(data.Level)
	while data.Experience >= expNeeded do
		data.Experience -= expNeeded
		data.Level += 1

		-- Award level up rewards
		self:AddCurrency(player, "Coins", data.Level * 100)
		self:AddCurrency(player, "Gems", math.floor(data.Level / 5))

		-- Fire level up event
		local remoteEvent = ReplicatedStorage.Remotes.LevelUp
		if remoteEvent then
			remoteEvent:FireClient(player, data.Level)
		end

		expNeeded = Config.LEVEL_EXPERIENCE_FORMULA(data.Level)
	end

	return true
end

return DataManager

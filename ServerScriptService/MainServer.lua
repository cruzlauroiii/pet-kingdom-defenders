--[[
	Pet Kingdom Defenders - Main Server Script
	Initializes all server-side systems and manages game state
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

-- Server Modules
local DataManager = require(ServerScriptService.Modules.DataManager)
local PetSystem = require(ServerScriptService.Modules.PetSystem)
local TowerDefenseManager = require(ServerScriptService.Modules.TowerDefenseManager)
local TycoonManager = require(ServerScriptService.Modules.TycoonManager)
local EconomyManager = require(ServerScriptService.Modules.EconomyManager)
local TradingSystem = require(ServerScriptService.Modules.TradingSystem)
local ObbyManager = require(ServerScriptService.Modules.ObbyManager)
local EventManager = require(ServerScriptService.Modules.EventManager)

-- Shared Modules
local Config = require(ReplicatedStorage.Shared.Config)
local Utils = require(ReplicatedStorage.Shared.Utils)

print("[Server] Pet Kingdom Defenders - Initializing...")

-- Initialize all systems
local function initializeSystems()
	DataManager:Initialize()
	PetSystem:Initialize()
	TowerDefenseManager:Initialize()
	TycoonManager:Initialize()
	EconomyManager:Initialize()
	TradingSystem:Initialize()
	ObbyManager:Initialize()
	EventManager:Initialize()

	print("[Server] All systems initialized successfully!")
end

-- Player joined handler
local function onPlayerAdded(player)
	print("[Server] Player joined:", player.Name)

	-- Load player data
	local success, playerData = DataManager:LoadPlayerData(player)

	if success then
		-- Initialize player systems
		PetSystem:SetupPlayer(player, playerData)
		TycoonManager:SetupPlayerBase(player, playerData)
		EconomyManager:SetupPlayerEconomy(player, playerData)

		-- Award daily bonus
		EconomyManager:CheckDailyBonus(player)

		print("[Server] Player setup complete:", player.Name)
	else
		player:Kick("Failed to load player data. Please rejoin.")
	end
end

-- Player leaving handler
local function onPlayerRemoving(player)
	print("[Server] Player leaving:", player.Name)
	DataManager:SavePlayerData(player)
	TycoonManager:CleanupPlayerBase(player)
	TradingSystem:CancelActiveTrades(player)
end

-- Server shutdown handler
local function onServerShutdown()
	print("[Server] Server shutting down - Saving all player data...")
	for _, player in ipairs(Players:GetPlayers()) do
		DataManager:SavePlayerData(player)
	end
	print("[Server] All data saved!")
end

-- Initialize systems
initializeSystems()

-- Connect player events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Handle players already in game (for testing)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, player)
end

-- Bind shutdown handler
game:BindToClose(onServerShutdown)

-- Auto-save loop (every 5 minutes)
task.spawn(function()
	while true do
		task.wait(300) -- 5 minutes
		print("[Server] Auto-saving all player data...")
		for _, player in ipairs(Players:GetPlayers()) do
			DataManager:SavePlayerData(player)
		end
	end
end)

print("[Server] Pet Kingdom Defenders is running!")

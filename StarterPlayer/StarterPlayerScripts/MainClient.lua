--[[
	MainClient - Main client-side controller
	Initializes all client systems and UI managers
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Shared modules
local Config = require(ReplicatedStorage.Shared.Config)
local Utils = require(ReplicatedStorage.Shared.Utils)
local PetData = require(ReplicatedStorage.Shared.PetData)

-- Client modules
local UIManager = require(script.Parent.Modules.UIManager)
local InputManager = require(script.Parent.Modules.InputManager)
local CameraController = require(script.Parent.Modules.CameraController)
local SoundManager = require(script.Parent.Modules.SoundManager)
local NotificationManager = require(script.Parent.Modules.NotificationManager)

print("[Client] Pet Kingdom Defenders - Initializing...")

-- Initialize client systems
local function initializeClient()
	-- Initialize managers
	UIManager:Initialize()
	InputManager:Initialize()
	CameraController:Initialize()
	SoundManager:Initialize()
	NotificationManager:Initialize()

	print("[Client] All systems initialized successfully!")

	-- Show welcome notification
	NotificationManager:Show("Welcome to Pet Kingdom Defenders!", "success")
end

-- Setup remote event listeners
local function setupRemoteListeners()
	-- Currency updates
	ReplicatedStorage.Remotes.UpdateCurrency.OnClientEvent:Connect(function(currencyType, newAmount)
		UIManager:UpdateCurrency(currencyType, newAmount)
	end)

	-- Level up
	ReplicatedStorage.Remotes.LevelUp.OnClientEvent:Connect(function(newLevel)
		NotificationManager:Show("Level Up! Now Level " .. newLevel, "success")
		SoundManager:PlaySound("LevelUp")
	end)

	-- Pet hatching
	ReplicatedStorage.Remotes.HatchResult.OnClientEvent:Connect(function(success, data)
		if success then
			UIManager:ShowHatchAnimation(data)
			NotificationManager:Show("Hatched: " .. data.Name, "success")
		else
			NotificationManager:Show(data, "error")
		end
	end)

	-- Trading
	ReplicatedStorage.Remotes.TradeRequest.OnClientEvent:Connect(function(requester, tradeId)
		UIManager:ShowTradeRequest(requester, tradeId)
	end)

	ReplicatedStorage.Remotes.TradeAccepted.OnClientEvent:Connect(function(tradeData)
		UIManager:OpenTradeWindow(tradeData)
	end)

	ReplicatedStorage.Remotes.TradeCompleted.OnClientEvent:Connect(function()
		NotificationManager:Show("Trade completed successfully!", "success")
		UIManager:CloseTradeWindow()
	end)

	-- Events
	ReplicatedStorage.Remotes.EventStarted.OnClientEvent:Connect(function(eventData)
		NotificationManager:Show("Event Started: " .. eventData.Name, "special")
		UIManager:ShowEventBanner(eventData)
	end)

	-- Achievements
	ReplicatedStorage.Remotes.AchievementUnlocked.OnClientEvent:Connect(function(achievement)
		UIManager:ShowAchievementPopup(achievement)
		SoundManager:PlaySound("Achievement")
	end)
end

-- Character added handler
local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")

	-- Setup character-specific systems
	CameraController:SetupCharacter(character)
	InputManager:SetupCharacter(character)
end

-- Initialize
initializeClient()
setupRemoteListeners()

-- Handle character
if player.Character then
	onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

print("[Client] Pet Kingdom Defenders is running!")

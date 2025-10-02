--[[
	RemotesSetup - Creates all RemoteEvents and RemoteFunctions for client-server communication
	Run this in ServerScriptService to initialize all remotes
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Remotes folder
local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = ReplicatedStorage
end

-- List of all RemoteEvents needed
local remoteEvents = {
	-- Pet System
	"HatchEgg",
	"HatchResult",
	"EquipPet",
	"EquipResult",
	"UnequipPet",
	"UnequipResult",
	"EvolvePet",
	"EvolveResult",

	-- Currency
	"UpdateCurrency",

	-- Player Progression
	"LevelUp",

	-- Tower Defense
	"StartWave",
	"WaveStarted",
	"PlaceTower",
	"TowerPlaced",
	"EnemySpawned",
	"EnemyRemoved",
	"WaveComplete",
	"GameOver",

	-- Tycoon
	"PurchaseBuilding",
	"PurchaseResult",
	"CollectIncome",
	"IncomeGenerated",
	"IncomeCollected",

	-- Trading
	"SendTradeRequest",
	"TradeRequest",
	"AcceptTradeRequest",
	"TradeAccepted",
	"DeclineTradeRequest",
	"TradeDeclined",
	"AddTradeItem",
	"RemoveTradeItem",
	"TradeUpdated",
	"ConfirmTrade",
	"CancelTrade",
	"TradeCancelled",
	"TradeCompleted",
	"TradeError",

	-- Obby
	"StartObby",
	"ObbyStarted",
	"CheckpointReached",
	"CompleteObby",
	"ObbyCompleted",
	"ObbyError",

	-- Events
	"ClaimEventReward",
	"EventStarted",
	"EventEnded",
	"EventRewardClaimed",
	"EventError",
	"SeasonChanged",

	-- Economy
	"ClaimDailyBonus",
	"DailyBonusAvailable",
	"DailyBonusClaimed",
	"AchievementUnlocked"
}

-- Create all RemoteEvents
for _, remoteName in ipairs(remoteEvents) do
	if not remotesFolder:FindFirstChild(remoteName) then
		local remoteEvent = Instance.new("RemoteEvent")
		remoteEvent.Name = remoteName
		remoteEvent.Parent = remotesFolder
		print("[RemotesSetup] Created RemoteEvent:", remoteName)
	end
end

print("[RemotesSetup] All remotes created successfully!")

return remotesFolder

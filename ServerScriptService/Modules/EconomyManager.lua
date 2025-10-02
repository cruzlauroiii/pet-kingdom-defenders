--[[
	EconomyManager - Manages in-game economy, currency, and rewards
	Handles daily bonuses, achievements, and monetization
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

local DataManager = require(ServerScriptService.Modules.DataManager)
local Config = require(ReplicatedStorage.Shared.Config)

local EconomyManager = {}

function EconomyManager:Initialize()
	print("[EconomyManager] Initializing...")

	-- Setup remotes
	local claimDailyRemote = ReplicatedStorage.Remotes.ClaimDailyBonus
	claimDailyRemote.OnServerEvent:Connect(function(player)
		self:ClaimDailyBonus(player)
	end)

	-- Setup marketplace
	MarketplaceService.ProcessReceipt = function(receiptInfo)
		return self:ProcessReceipt(receiptInfo)
	end

	print("[EconomyManager] Initialized successfully!")
end

function EconomyManager:SetupPlayerEconomy(player, playerData)
	-- Send initial currency state to client
	ReplicatedStorage.Remotes.UpdateCurrency:FireClient(player, "Coins", playerData.Coins)
	ReplicatedStorage.Remotes.UpdateCurrency:FireClient(player, "Gems", playerData.Gems)
end

-- Check and award daily bonus
function EconomyManager:CheckDailyBonus(player)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local currentTime = os.time()
	local lastLogin = playerData.LastLogin
	local timeSinceLogin = currentTime - lastLogin

	-- Check if eligible for daily bonus (24 hours)
	if timeSinceLogin >= 86400 then
		-- Award daily bonus
		local streakBonus = math.min(playerData.LoginStreak, 7) -- Cap at 7 days
		local coinsReward = 500 * streakBonus
		local gemsReward = math.floor(streakBonus / 2)

		DataManager:AddCurrency(player, "Coins", coinsReward)
		DataManager:AddCurrency(player, "Gems", gemsReward)

		ReplicatedStorage.Remotes.DailyBonusAvailable:FireClient(player, {
			Streak = playerData.LoginStreak,
			Coins = coinsReward,
			Gems = gemsReward
		})
	end
end

-- Claim daily bonus
function EconomyManager:ClaimDailyBonus(player)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local currentTime = os.time()
	local lastClaim = playerData.LastDailyClaim or 0
	local timeSinceClaim = currentTime - lastClaim

	if timeSinceClaim >= 86400 then
		local streakBonus = math.min(playerData.LoginStreak, 7)
		local coinsReward = 500 * streakBonus
		local gemsReward = math.floor(streakBonus / 2)

		DataManager:AddCurrency(player, "Coins", coinsReward)
		DataManager:AddCurrency(player, "Gems", gemsReward)

		playerData.LastDailyClaim = currentTime

		ReplicatedStorage.Remotes.DailyBonusClaimed:FireClient(player, {
			Streak = playerData.LoginStreak,
			Coins = coinsReward,
			Gems = gemsReward
		})
	end
end

-- Process Robux purchases
function EconomyManager:ProcessReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = game.Players:GetPlayerByUserId(userId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local playerData = DataManager:GetData(player)
	if not playerData then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Process different products
	local productConfig = Config.SHOP_PRODUCTS[productId]
	if not productConfig then
		warn("[EconomyManager] Unknown product ID:", productId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Award product
	if productConfig.Type == "Gems" then
		DataManager:AddCurrency(player, "Gems", productConfig.Amount)
	elseif productConfig.Type == "Coins" then
		DataManager:AddCurrency(player, "Coins", productConfig.Amount)
	elseif productConfig.Type == "Bundle" then
		DataManager:AddCurrency(player, "Gems", productConfig.Gems)
		DataManager:AddCurrency(player, "Coins", productConfig.Coins)
	end

	print(string.format("[EconomyManager] %s purchased %s", player.Name, productConfig.Name))

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- Award achievement rewards
function EconomyManager:AwardAchievement(player, achievementId)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local achievement = Config.ACHIEVEMENTS[achievementId]
	if not achievement then return end

	-- Check if already claimed
	if not playerData.CompletedAchievements then
		playerData.CompletedAchievements = {}
	end

	if table.find(playerData.CompletedAchievements, achievementId) then
		return -- Already claimed
	end

	-- Award rewards
	DataManager:AddCurrency(player, "Coins", achievement.CoinsReward or 0)
	DataManager:AddCurrency(player, "Gems", achievement.GemsReward or 0)

	table.insert(playerData.CompletedAchievements, achievementId)

	ReplicatedStorage.Remotes.AchievementUnlocked:FireClient(player, achievement)
end

return EconomyManager

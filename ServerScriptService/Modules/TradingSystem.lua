--[[
	TradingSystem - Manages peer-to-peer pet trading between players
	Includes trade requests, verification, and completion
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManager = require(ServerScriptService.Modules.DataManager)
local Config = require(ReplicatedStorage.Shared.Config)

local TradingSystem = {}
TradingSystem.ActiveTrades = {} -- tradeId -> trade data
TradingSystem.PlayerTrades = {} -- playerId -> tradeId

function TradingSystem:Initialize()
	print("[TradingSystem] Initializing...")

	-- Setup remotes
	local sendTradeRequest = ReplicatedStorage.Remotes.SendTradeRequest
	sendTradeRequest.OnServerEvent:Connect(function(player, targetPlayer)
		self:SendTradeRequest(player, targetPlayer)
	end)

	local acceptTradeRequest = ReplicatedStorage.Remotes.AcceptTradeRequest
	acceptTradeRequest.OnServerEvent:Connect(function(player, tradeId)
		self:AcceptTradeRequest(player, tradeId)
	end)

	local declineTradeRequest = ReplicatedStorage.Remotes.DeclineTradeRequest
	declineTradeRequest.OnServerEvent:Connect(function(player, tradeId)
		self:DeclineTradeRequest(player, tradeId)
	end)

	local addTradeItem = ReplicatedStorage.Remotes.AddTradeItem
	addTradeItem.OnServerEvent:Connect(function(player, tradeId, petId)
		self:AddTradeItem(player, tradeId, petId)
	end)

	local removeTradeItem = ReplicatedStorage.Remotes.RemoveTradeItem
	removeTradeItem.OnServerEvent:Connect(function(player, tradeId, petId)
		self:RemoveTradeItem(player, tradeId, petId)
	end)

	local confirmTrade = ReplicatedStorage.Remotes.ConfirmTrade
	confirmTrade.OnServerEvent:Connect(function(player, tradeId)
		self:ConfirmTrade(player, tradeId)
	end)

	local cancelTrade = ReplicatedStorage.Remotes.CancelTrade
	cancelTrade.OnServerEvent:Connect(function(player, tradeId)
		self:CancelTrade(player, tradeId)
	end)

	print("[TradingSystem] Initialized successfully!")
end

-- Generate trade ID
local function generateTradeId()
	return game:GetService("HttpService"):GenerateGUID(false)
end

-- Send trade request to another player
function TradingSystem:SendTradeRequest(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Parent then
		ReplicatedStorage.Remotes.TradeError:FireClient(player, "Player not found")
		return
	end

	if player == targetPlayer then
		ReplicatedStorage.Remotes.TradeError:FireClient(player, "Cannot trade with yourself")
		return
	end

	-- Check if already in trade
	if self.PlayerTrades[player.UserId] then
		ReplicatedStorage.Remotes.TradeError:FireClient(player, "You are already in a trade")
		return
	end

	if self.PlayerTrades[targetPlayer.UserId] then
		ReplicatedStorage.Remotes.TradeError:FireClient(player, "Target player is already in a trade")
		return
	end

	-- Create trade
	local tradeId = generateTradeId()
	self.ActiveTrades[tradeId] = {
		Id = tradeId,
		Player1 = player,
		Player2 = targetPlayer,
		Player1Items = {},
		Player2Items = {},
		Player1Confirmed = false,
		Player2Confirmed = false,
		Status = "pending"
	}

	-- Send request to target
	ReplicatedStorage.Remotes.TradeRequest:FireClient(targetPlayer, player, tradeId)

	print(string.format("[TradingSystem] %s sent trade request to %s", player.Name, targetPlayer.Name))
end

-- Accept trade request
function TradingSystem:AcceptTradeRequest(player, tradeId)
	local trade = self.ActiveTrades[tradeId]
	if not trade then return end

	if trade.Player2 ~= player then return end

	trade.Status = "active"
	self.PlayerTrades[trade.Player1.UserId] = tradeId
	self.PlayerTrades[trade.Player2.UserId] = tradeId

	-- Notify both players
	ReplicatedStorage.Remotes.TradeAccepted:FireClient(trade.Player1, trade)
	ReplicatedStorage.Remotes.TradeAccepted:FireClient(trade.Player2, trade)

	print(string.format("[TradingSystem] %s accepted trade from %s", player.Name, trade.Player1.Name))
end

-- Decline trade request
function TradingSystem:DeclineTradeRequest(player, tradeId)
	local trade = self.ActiveTrades[tradeId]
	if not trade then return end

	if trade.Player2 ~= player then return end

	-- Notify requester
	ReplicatedStorage.Remotes.TradeDeclined:FireClient(trade.Player1)

	-- Clean up
	self.ActiveTrades[tradeId] = nil

	print(string.format("[TradingSystem] %s declined trade from %s", player.Name, trade.Player1.Name))
end

-- Add item to trade
function TradingSystem:AddTradeItem(player, tradeId, petId)
	local trade = self.ActiveTrades[tradeId]
	if not trade or trade.Status ~= "active" then return end

	local playerData = DataManager:GetData(player)
	if not playerData then return end

	-- Verify player owns pet
	local ownsPet = false
	for _, pet in ipairs(playerData.Pets) do
		if pet.Id == petId then
			ownsPet = true
			break
		end
	end

	if not ownsPet then
		ReplicatedStorage.Remotes.TradeError:FireClient(player, "You don't own this pet")
		return
	end

	-- Add to appropriate side
	if trade.Player1 == player then
		if #trade.Player1Items >= Config.MAX_TRADE_ITEMS then
			ReplicatedStorage.Remotes.TradeError:FireClient(player, "Maximum items reached")
			return
		end
		table.insert(trade.Player1Items, petId)
		trade.Player1Confirmed = false
	elseif trade.Player2 == player then
		if #trade.Player2Items >= Config.MAX_TRADE_ITEMS then
			ReplicatedStorage.Remotes.TradeError:FireClient(player, "Maximum items reached")
			return
		end
		table.insert(trade.Player2Items, petId)
		trade.Player2Confirmed = false
	end

	-- Update both players
	ReplicatedStorage.Remotes.TradeUpdated:FireClient(trade.Player1, trade)
	ReplicatedStorage.Remotes.TradeUpdated:FireClient(trade.Player2, trade)
end

-- Remove item from trade
function TradingSystem:RemoveTradeItem(player, tradeId, petId)
	local trade = self.ActiveTrades[tradeId]
	if not trade or trade.Status ~= "active" then return end

	-- Remove from appropriate side
	if trade.Player1 == player then
		local index = table.find(trade.Player1Items, petId)
		if index then
			table.remove(trade.Player1Items, index)
			trade.Player1Confirmed = false
		end
	elseif trade.Player2 == player then
		local index = table.find(trade.Player2Items, petId)
		if index then
			table.remove(trade.Player2Items, index)
			trade.Player2Confirmed = false
		end
	end

	-- Update both players
	ReplicatedStorage.Remotes.TradeUpdated:FireClient(trade.Player1, trade)
	ReplicatedStorage.Remotes.TradeUpdated:FireClient(trade.Player2, trade)
end

-- Confirm trade
function TradingSystem:ConfirmTrade(player, tradeId)
	local trade = self.ActiveTrades[tradeId]
	if not trade or trade.Status ~= "active" then return end

	if trade.Player1 == player then
		trade.Player1Confirmed = true
	elseif trade.Player2 == player then
		trade.Player2Confirmed = true
	end

	-- Update both players
	ReplicatedStorage.Remotes.TradeUpdated:FireClient(trade.Player1, trade)
	ReplicatedStorage.Remotes.TradeUpdated:FireClient(trade.Player2, trade)

	-- Execute if both confirmed
	if trade.Player1Confirmed and trade.Player2Confirmed then
		self:ExecuteTrade(tradeId)
	end
end

-- Execute the trade
function TradingSystem:ExecuteTrade(tradeId)
	local trade = self.ActiveTrades[tradeId]
	if not trade then return end

	local player1Data = DataManager:GetData(trade.Player1)
	local player2Data = DataManager:GetData(trade.Player2)

	if not player1Data or not player2Data then
		self:CancelTrade(trade.Player1, tradeId)
		return
	end

	-- Transfer pets from player1 to player2
	for _, petId in ipairs(trade.Player1Items) do
		for i, pet in ipairs(player1Data.Pets) do
			if pet.Id == petId then
				table.insert(player2Data.Pets, pet)
				table.remove(player1Data.Pets, i)
				break
			end
		end
	end

	-- Transfer pets from player2 to player1
	for _, petId in ipairs(trade.Player2Items) do
		for i, pet in ipairs(player2Data.Pets) do
			if pet.Id == petId then
				table.insert(player1Data.Pets, pet)
				table.remove(player2Data.Pets, i)
				break
			end
		end
	end

	-- Update statistics
	player1Data.TotalTradesCompleted += 1
	player2Data.TotalTradesCompleted += 1

	-- Notify both players
	ReplicatedStorage.Remotes.TradeCompleted:FireClient(trade.Player1)
	ReplicatedStorage.Remotes.TradeCompleted:FireClient(trade.Player2)

	-- Clean up
	self.PlayerTrades[trade.Player1.UserId] = nil
	self.PlayerTrades[trade.Player2.UserId] = nil
	self.ActiveTrades[tradeId] = nil

	print(string.format("[TradingSystem] Trade completed between %s and %s",
		trade.Player1.Name, trade.Player2.Name))
end

-- Cancel trade
function TradingSystem:CancelTrade(player, tradeId)
	local trade = self.ActiveTrades[tradeId]
	if not trade then return end

	-- Notify both players
	ReplicatedStorage.Remotes.TradeCancelled:FireClient(trade.Player1)
	ReplicatedStorage.Remotes.TradeCancelled:FireClient(trade.Player2)

	-- Clean up
	self.PlayerTrades[trade.Player1.UserId] = nil
	self.PlayerTrades[trade.Player2.UserId] = nil
	self.ActiveTrades[tradeId] = nil
end

-- Cancel all active trades for player (when leaving)
function TradingSystem:CancelActiveTrades(player)
	local tradeId = self.PlayerTrades[player.UserId]
	if tradeId then
		self:CancelTrade(player, tradeId)
	end
end

return TradingSystem

--[[
	EventManager - Manages seasonal events, limited-time content, and special rewards
	Keeps the game fresh with rotating content
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManager = require(ServerScriptService.Modules.DataManager)
local Config = require(ReplicatedStorage.Shared.Config)

local EventManager = {}
EventManager.ActiveEvents = {}
EventManager.CurrentSeason = "Default"

function EventManager:Initialize()
	print("[EventManager] Initializing...")

	-- Check for active events
	self:CheckEvents()

	-- Setup event check loop (every hour)
	task.spawn(function()
		while true do
			task.wait(3600) -- 1 hour
			self:CheckEvents()
		end
	end)

	-- Setup remotes
	local claimEventReward = ReplicatedStorage.Remotes.ClaimEventReward
	claimEventReward.OnServerEvent:Connect(function(player, eventId, rewardId)
		self:ClaimEventReward(player, eventId, rewardId)
	end)

	print("[EventManager] Initialized successfully!")
end

-- Check and activate events based on date
function EventManager:CheckEvents()
	local currentTime = os.time()
	local dateTable = os.date("*t", currentTime)

	-- Clear expired events
	for eventId, eventData in pairs(self.ActiveEvents) do
		if currentTime > eventData.EndTime then
			self:EndEvent(eventId)
		end
	end

	-- Check for new events
	for eventId, eventConfig in pairs(Config.EVENTS) do
		if not self.ActiveEvents[eventId] then
			-- Check if event should be active
			local shouldActivate = false

			if eventConfig.Type == "Seasonal" then
				-- Check month/day
				if dateTable.month == eventConfig.Month then
					shouldActivate = true
				end
			elseif eventConfig.Type == "Weekend" then
				-- Check if weekend (Saturday or Sunday)
				if dateTable.wday == 1 or dateTable.wday == 7 then
					shouldActivate = true
				end
			elseif eventConfig.Type == "Special" then
				-- Check specific date range
				if currentTime >= eventConfig.StartTime and currentTime <= eventConfig.EndTime then
					shouldActivate = true
				end
			end

			if shouldActivate then
				self:StartEvent(eventId, eventConfig)
			end
		end
	end

	-- Determine current season
	self:UpdateSeason(dateTable.month)
end

-- Start an event
function EventManager:StartEvent(eventId, eventConfig)
	print("[EventManager] Starting event:", eventId)

	self.ActiveEvents[eventId] = {
		Id = eventId,
		Name = eventConfig.Name,
		StartTime = os.time(),
		EndTime = eventConfig.EndTime or (os.time() + eventConfig.Duration),
		Rewards = eventConfig.Rewards,
		Multipliers = eventConfig.Multipliers or {}
	}

	-- Notify all players
	for _, player in ipairs(game.Players:GetPlayers()) do
		ReplicatedStorage.Remotes.EventStarted:FireClient(player, self.ActiveEvents[eventId])
	end
end

-- End an event
function EventManager:EndEvent(eventId)
	print("[EventManager] Ending event:", eventId)

	local eventData = self.ActiveEvents[eventId]
	if not eventData then return end

	-- Notify all players
	for _, player in ipairs(game.Players:GetPlayers()) do
		ReplicatedStorage.Remotes.EventEnded:FireClient(player, eventId)
	end

	self.ActiveEvents[eventId] = nil
end

-- Update current season
function EventManager:UpdateSeason(month)
	local newSeason = "Default"

	if month >= 3 and month <= 5 then
		newSeason = "Spring"
	elseif month >= 6 and month <= 8 then
		newSeason = "Summer"
	elseif month >= 9 and month <= 11 then
		newSeason = "Autumn"
	elseif month == 12 or month <= 2 then
		newSeason = "Winter"
	end

	if newSeason ~= self.CurrentSeason then
		self.CurrentSeason = newSeason
		print("[EventManager] Season changed to:", newSeason)

		-- Apply seasonal changes
		self:ApplySeasonalChanges(newSeason)
	end
end

-- Apply seasonal visual and gameplay changes
function EventManager:ApplySeasonalChanges(season)
	-- Update lighting, decorations, etc.
	local lighting = game:GetService("Lighting")

	if season == "Winter" then
		lighting.Ambient = Color3.fromRGB(200, 220, 255)
	elseif season == "Spring" then
		lighting.Ambient = Color3.fromRGB(255, 240, 220)
	elseif season == "Summer" then
		lighting.Ambient = Color3.fromRGB(255, 250, 200)
	elseif season == "Autumn" then
		lighting.Ambient = Color3.fromRGB(255, 200, 150)
	end

	-- Notify all players
	for _, player in ipairs(game.Players:GetPlayers()) do
		ReplicatedStorage.Remotes.SeasonChanged:FireClient(player, season)
	end
end

-- Claim event reward
function EventManager:ClaimEventReward(player, eventId, rewardId)
	local eventData = self.ActiveEvents[eventId]
	if not eventData then
		ReplicatedStorage.Remotes.EventError:FireClient(player, "Event not active")
		return
	end

	local playerData = DataManager:GetData(player)
	if not playerData then return end

	-- Initialize event data
	if not playerData.EventData then
		playerData.EventData = {}
	end
	if not playerData.EventData[eventId] then
		playerData.EventData[eventId] = {
			ClaimedRewards = {}
		}
	end

	-- Check if already claimed
	if table.find(playerData.EventData[eventId].ClaimedRewards, rewardId) then
		ReplicatedStorage.Remotes.EventError:FireClient(player, "Reward already claimed")
		return
	end

	-- Find reward
	local reward = nil
	for _, r in ipairs(eventData.Rewards) do
		if r.Id == rewardId then
			reward = r
			break
		end
	end

	if not reward then return end

	-- Check requirements
	if reward.RequiredProgress and playerData.EventData[eventId].Progress < reward.RequiredProgress then
		ReplicatedStorage.Remotes.EventError:FireClient(player, "Requirements not met")
		return
	end

	-- Award reward
	if reward.Type == "Coins" then
		DataManager:AddCurrency(player, "Coins", reward.Amount)
	elseif reward.Type == "Gems" then
		DataManager:AddCurrency(player, "Gems", reward.Amount)
	elseif reward.Type == "Pet" then
		-- Award special event pet
		-- Implementation would go here
	end

	-- Mark as claimed
	table.insert(playerData.EventData[eventId].ClaimedRewards, rewardId)

	ReplicatedStorage.Remotes.EventRewardClaimed:FireClient(player, rewardId, reward)

	print(string.format("[EventManager] %s claimed reward %s from event %s",
		player.Name, rewardId, eventId))
end

-- Get active event multipliers
function EventManager:GetMultipliers()
	local multipliers = {
		Coins = 1,
		Experience = 1,
		PetHatchRate = 1
	}

	for _, eventData in pairs(self.ActiveEvents) do
		if eventData.Multipliers then
			for key, value in pairs(eventData.Multipliers) do
				multipliers[key] = multipliers[key] * value
			end
		end
	end

	return multipliers
end

return EventManager

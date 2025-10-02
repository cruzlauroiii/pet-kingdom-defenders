--[[
	ObbyManager - Manages parkour courses for pet training and rewards
	Players complete obstacle courses to train pets and earn bonuses
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManager = require(ServerScriptService.Modules.DataManager)
local Config = require(ReplicatedStorage.Shared.Config)

local ObbyManager = {}
ObbyManager.ActiveRuns = {} -- player.UserId -> run data

function ObbyManager:Initialize()
	print("[ObbyManager] Initializing...")

	-- Setup remotes
	local startObby = ReplicatedStorage.Remotes.StartObby
	startObby.OnServerEvent:Connect(function(player, obbyId)
		self:StartObby(player, obbyId)
	end)

	local completeObby = ReplicatedStorage.Remotes.CompleteObby
	completeObby.OnServerEvent:Connect(function(player, obbyId)
		self:CompleteObby(player, obbyId)
	end)

	local checkpointReached = ReplicatedStorage.Remotes.CheckpointReached
	checkpointReached.OnServerEvent:Connect(function(player, checkpointNumber)
		self:CheckpointReached(player, checkpointNumber)
	end)

	print("[ObbyManager] Initialized successfully!")
end

-- Start obby run
function ObbyManager:StartObby(player, obbyId)
	local obbyConfig = Config.OBBIES[obbyId]
	if not obbyConfig then
		warn("[ObbyManager] Invalid obby ID:", obbyId)
		return
	end

	-- Check if player meets requirements
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	if playerData.Level < obbyConfig.RequiredLevel then
		ReplicatedStorage.Remotes.ObbyError:FireClient(player, "Level too low")
		return
	end

	-- Initialize run
	self.ActiveRuns[player.UserId] = {
		ObbyId = obbyId,
		StartTime = tick(),
		Checkpoints = {},
		CurrentCheckpoint = 0
	}

	ReplicatedStorage.Remotes.ObbyStarted:FireClient(player, obbyId)

	print(string.format("[ObbyManager] %s started obby: %s", player.Name, obbyId))
end

-- Checkpoint reached
function ObbyManager:CheckpointReached(player, checkpointNumber)
	local run = self.ActiveRuns[player.UserId]
	if not run then return end

	-- Validate checkpoint order
	if checkpointNumber == run.CurrentCheckpoint + 1 then
		run.CurrentCheckpoint = checkpointNumber
		table.insert(run.Checkpoints, {
			Number = checkpointNumber,
			Time = tick() - run.StartTime
		})

		ReplicatedStorage.Remotes.CheckpointReached:FireClient(player, checkpointNumber)
	end
end

-- Complete obby
function ObbyManager:CompleteObby(player, obbyId)
	local run = self.ActiveRuns[player.UserId]
	if not run or run.ObbyId ~= obbyId then return end

	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local obbyConfig = Config.OBBIES[obbyId]
	if not obbyConfig then return end

	-- Calculate completion time
	local completionTime = tick() - run.StartTime

	-- Check for new best time
	local isNewBest = false
	local previousBest = playerData.BestObbyTimes[obbyId]

	if not previousBest or completionTime < previousBest then
		playerData.BestObbyTimes[obbyId] = completionTime
		isNewBest = true
	end

	-- Mark as completed
	if not table.find(playerData.CompletedObbies, obbyId) then
		table.insert(playerData.CompletedObbies, obbyId)
	end

	-- Calculate rewards
	local baseReward = obbyConfig.RewardCoins
	local timeBonus = 0

	if completionTime < obbyConfig.ParTime then
		timeBonus = math.floor(baseReward * 0.5) -- 50% bonus for beating par time
	end

	local totalReward = baseReward + timeBonus

	-- Award rewards
	DataManager:AddCurrency(player, "Coins", totalReward)
	DataManager:AddExperience(player, obbyConfig.ExperienceReward)

	-- Train equipped pets (increase power slightly)
	for _, petId in ipairs(playerData.EquippedPets) do
		for _, pet in ipairs(playerData.Pets) do
			if pet.Id == petId then
				pet.PowerMultiplier += 0.01 -- Small boost
				break
			end
		end
	end

	-- Send completion data to client
	ReplicatedStorage.Remotes.ObbyCompleted:FireClient(player, {
		ObbyId = obbyId,
		Time = completionTime,
		IsNewBest = isNewBest,
		Reward = totalReward,
		TimeBonus = timeBonus
	})

	-- Clean up
	self.ActiveRuns[player.UserId] = nil

	print(string.format("[ObbyManager] %s completed %s in %.2f seconds (Best: %s)",
		player.Name, obbyId, completionTime, isNewBest and "YES" or "NO"))
end

-- Get leaderboard for obby
function ObbyManager:GetLeaderboard(obbyId)
	-- In production, this would query all player data
	-- For now, return empty
	return {}
end

return ObbyManager

--[[
	SecurityManager - 2025 Anti-Exploit & Rate Limiting System
	Implements "Never Trust the Client" principle and prevents common exploits
]]

local Players = game:GetService("Players")

local SecurityManager = {}
SecurityManager.RateLimits = {} -- Track rate limits per player
SecurityManager.SuspiciousActivity = {} -- Track suspicious behavior

-- Rate limit configuration (requests per second)
local RATE_LIMITS = {
	HatchEgg = 2, -- Max 2 egg hatches per second
	EquipPet = 5, -- Max 5 equip changes per second
	PurchaseBuilding = 3,
	StartWave = 1,
	Trade = 1,
	CompleteObby = 1
}

-- Initialize security system
function SecurityManager:Initialize()
	print("[SecurityManager] Initializing 2025 security measures...")

	-- Clean up disconnected players
	Players.PlayerRemoving:Connect(function(player)
		self:CleanupPlayer(player)
	end)

	print("[SecurityManager] Security initialized!")
end

-- Check if action is rate limited
function SecurityManager:CheckRateLimit(player, actionType)
	local userId = player.UserId
	local currentTime = tick()

	-- Initialize tracking for player if needed
	if not self.RateLimits[userId] then
		self.RateLimits[userId] = {}
	end

	if not self.RateLimits[userId][actionType] then
		self.RateLimits[userId][actionType] = {
			Count = 0,
			ResetTime = currentTime + 1
		}
	end

	local limit = self.RateLimits[userId][actionType]

	-- Reset counter if time window passed
	if currentTime >= limit.ResetTime then
		limit.Count = 0
		limit.ResetTime = currentTime + 1
	end

	-- Check if limit exceeded
	local maxAllowed = RATE_LIMITS[actionType] or 10
	if limit.Count >= maxAllowed then
		self:LogSuspiciousActivity(player, actionType, "Rate limit exceeded")
		return false, "Too many requests. Please wait a moment."
	end

	-- Increment counter
	limit.Count += 1
	return true, nil
end

-- Validate currency amount (prevent negative/NaN exploits)
function SecurityManager:ValidateCurrency(amount, currencyType)
	-- Check if number
	if type(amount) ~= "number" then
		return false, "Invalid currency type"
	end

	-- Check for NaN
	if amount ~= amount then
		return false, "Invalid currency value (NaN)"
	end

	-- Check for negative
	if amount < 0 then
		return false, "Currency cannot be negative"
	end

	-- Check for infinity
	if amount == math.huge or amount == -math.huge then
		return false, "Invalid currency value (infinity)"
	end

	-- Check for unreasonably large amounts (likely exploit)
	local MAX_CURRENCY = currencyType == "Gems" and 1000000 or 100000000
	if amount > MAX_CURRENCY then
		return false, "Currency amount exceeds maximum"
	end

	return true, nil
end

-- Validate pet data structure
function SecurityManager:ValidatePetData(petData)
	-- Check required fields
	local requiredFields = {"Id", "Name", "Rarity", "Level", "PowerMultiplier"}
	for _, field in ipairs(requiredFields) do
		if petData[field] == nil then
			return false, "Missing required field: " .. field
		end
	end

	-- Validate level (1-100 reasonable range)
	if type(petData.Level) ~= "number" or petData.Level < 1 or petData.Level > 100 then
		return false, "Invalid pet level"
	end

	-- Validate PowerMultiplier (1.0-10.0 reasonable range)
	if type(petData.PowerMultiplier) ~= "number" or petData.PowerMultiplier < 1 or petData.PowerMultiplier > 10 then
		return false, "Invalid pet power multiplier"
	end

	-- Validate rarity
	local validRarities = {Common = true, Uncommon = true, Rare = true, Epic = true, Legendary = true}
	if not validRarities[petData.Rarity] then
		return false, "Invalid pet rarity"
	end

	return true, nil
end

-- Validate player data integrity
function SecurityManager:ValidatePlayerData(playerData)
	if type(playerData) ~= "table" then
		return false, "Player data must be a table"
	end

	-- Validate currency
	local valid, err = self:ValidateCurrency(playerData.Coins or 0, "Coins")
	if not valid then return false, "Coins: " .. err end

	valid, err = self:ValidateCurrency(playerData.Gems or 0, "Gems")
	if not valid then return false, "Gems: " .. err end

	-- Validate level
	if type(playerData.Level) ~= "number" or playerData.Level < 1 or playerData.Level > 1000 then
		return false, "Invalid player level"
	end

	-- Validate pets array
	if playerData.Pets and type(playerData.Pets) ~= "table" then
		return false, "Pets must be an array"
	end

	return true, nil
end

-- Log suspicious activity
function SecurityManager:LogSuspiciousActivity(player, action, reason)
	local userId = player.UserId

	if not self.SuspiciousActivity[userId] then
		self.SuspiciousActivity[userId] = {}
	end

	table.insert(self.SuspiciousActivity[userId], {
		Action = action,
		Reason = reason,
		Time = os.time(),
		PlayerName = player.Name
	})

	warn(string.format("[SecurityManager] Suspicious activity: %s | Player: %s (%d) | Action: %s | Reason: %s",
		os.date("%Y-%m-%d %H:%M:%S"),
		player.Name,
		userId,
		action,
		reason
	))

	-- Auto-kick if too many violations (10+ in 5 minutes)
	local recentViolations = 0
	local fiveMinutesAgo = os.time() - 300

	for _, violation in ipairs(self.SuspiciousActivity[userId]) do
		if violation.Time >= fiveMinutesAgo then
			recentViolations += 1
		end
	end

	if recentViolations >= 10 then
		player:Kick("Suspicious activity detected. Please contact support if this was an error.")
		warn(string.format("[SecurityManager] Player kicked for excessive violations: %s (%d)", player.Name, userId))
	end
end

-- Sanitize string input (prevent injection attacks)
function SecurityManager:SanitizeString(input, maxLength)
	if type(input) ~= "string" then
		return ""
	end

	maxLength = maxLength or 100

	-- Truncate
	if #input > maxLength then
		input = string.sub(input, 1, maxLength)
	end

	-- Remove potentially dangerous characters
	input = string.gsub(input, "[<>\"']", "")

	return input
end

-- Validate position (prevent teleport exploits)
function SecurityManager:ValidatePosition(player, position)
	if typeof(position) ~= "Vector3" then
		return false, "Invalid position type"
	end

	-- Check for NaN/Inf
	if position.X ~= position.X or position.Y ~= position.Y or position.Z ~= position.Z then
		return false, "Position contains NaN"
	end

	if math.abs(position.X) == math.huge or math.abs(position.Y) == math.huge or math.abs(position.Z) == math.huge then
		return false, "Position contains infinity"
	end

	-- Check if position is unreasonably far (likely teleport exploit)
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local distance = (character.HumanoidRootPart.Position - position).Magnitude
		if distance > 1000 then -- More than 1000 studs is suspicious
			self:LogSuspiciousActivity(player, "ValidatePosition", "Position too far from player")
			return false, "Position too far from current location"
		end
	end

	return true, nil
end

-- Cleanup player data
function SecurityManager:CleanupPlayer(player)
	local userId = player.UserId
	self.RateLimits[userId] = nil
	self.SuspiciousActivity[userId] = nil
end

-- Get player's violation count
function SecurityManager:GetViolationCount(player)
	local userId = player.UserId
	if not self.SuspiciousActivity[userId] then
		return 0
	end
	return #self.SuspiciousActivity[userId]
end

return SecurityManager

--[[
	Utils - Utility functions used across client and server
	Common helper functions for formatting, calculations, and more
]]

local Utils = {}

-- Format large numbers with abbreviations (1000 -> 1K, 1000000 -> 1M)
function Utils.FormatNumber(num)
	if num < 1000 then
		return tostring(math.floor(num))
	elseif num < 1000000 then
		return string.format("%.1fK", num / 1000)
	elseif num < 1000000000 then
		return string.format("%.1fM", num / 1000000)
	else
		return string.format("%.1fB", num / 1000000000)
	end
end

-- Format time in seconds to MM:SS
function Utils.FormatTime(seconds)
	local mins = math.floor(seconds / 60)
	local secs = math.floor(seconds % 60)
	return string.format("%02d:%02d", mins, secs)
end

-- Format time with hours HH:MM:SS
function Utils.FormatTimeHours(seconds)
	local hours = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	local secs = math.floor(seconds % 60)
	return string.format("%02d:%02d:%02d", hours, mins, secs)
end

-- Lerp between two numbers
function Utils.Lerp(a, b, t)
	return a + (b - a) * t
end

-- Clamp value between min and max
function Utils.Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

-- Get rarity color
function Utils.GetRarityColor(rarity)
	local colors = {
		Common = Color3.fromRGB(155, 155, 155),
		Uncommon = Color3.fromRGB(100, 255, 100),
		Rare = Color3.fromRGB(100, 150, 255),
		Epic = Color3.fromRGB(200, 100, 255),
		Legendary = Color3.fromRGB(255, 200, 50)
	}

	return colors[rarity] or Color3.fromRGB(255, 255, 255)
end

-- Deep copy table
function Utils.DeepCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = Utils.DeepCopy(value)
		else
			copy[key] = value
		end
	end
	return copy
end

-- Shuffle array
function Utils.Shuffle(array)
	local shuffled = Utils.DeepCopy(array)
	for i = #shuffled, 2, -1 do
		local j = math.random(i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end
	return shuffled
end

-- Round to decimal places
function Utils.Round(num, decimalPlaces)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Calculate distance between two Vector3 positions
function Utils.Distance(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

-- Check if point is within radius of center
function Utils.IsInRadius(point, center, radius)
	return Utils.Distance(point, center) <= radius
end

-- Generate random position within bounds
function Utils.RandomPositionInBox(min, max)
	return Vector3.new(
		math.random(min.X, max.X),
		math.random(min.Y, max.Y),
		math.random(min.Z, max.Z)
	)
end

-- Weighted random selection
function Utils.WeightedRandom(weights)
	local totalWeight = 0
	for _, weight in pairs(weights) do
		totalWeight += weight
	end

	local random = math.random() * totalWeight
	local currentWeight = 0

	for item, weight in pairs(weights) do
		currentWeight += weight
		if random <= currentWeight then
			return item
		end
	end

	-- Fallback
	for item, _ in pairs(weights) do
		return item
	end
end

-- Tween number with easing
function Utils.EaseInOut(t)
	return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
end

-- Create billboard GUI for floating text
function Utils.CreateFloatingText(text, position, duration, color)
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(4, 0, 1, 0)
	billboardGui.StudsOffset = Vector3.new(0, 2, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Adornee = nil

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboardGui

	billboardGui.Parent = workspace

	-- Animate up and fade
	local start = tick()
	game:GetService("RunService").Heartbeat:Connect(function()
		local elapsed = tick() - start
		if elapsed >= duration then
			billboardGui:Destroy()
		else
			local alpha = 1 - (elapsed / duration)
			textLabel.TextTransparency = 1 - alpha
			billboardGui.StudsOffset = Vector3.new(0, 2 + elapsed * 2, 0)
		end
	end)

	return billboardGui
end

-- Play sound effect
function Utils.PlaySound(soundId, volume, parent)
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = volume or 0.5
	sound.Parent = parent or game.Workspace

	sound:Play()

	sound.Ended:Connect(function()
		sound:Destroy()
	end)

	return sound
end

-- Vibrate mobile device (if on mobile)
function Utils.VibrateDevice()
	local UserInputService = game:GetService("UserInputService")
	local HapticService = game:GetService("HapticService")

	if UserInputService.TouchEnabled then
		pcall(function()
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0.5)
			task.wait(0.1)
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
		end)
	end
end

return Utils

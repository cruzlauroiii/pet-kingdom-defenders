--[[
	ProceduralItemGenerator - Generates loot items and collectibles
	NO external models required - Uses procedural generation

	Creates items with random stats and visual representations
]]

local ProceduralItemGenerator = {}

-- Item type templates
local ITEM_TEMPLATES = {
	Coin = {
		Shape = "Cylinder",
		BaseSize = Vector3.new(1, 0.2, 1),
		BaseColor = Color3.fromRGB(255, 215, 0), -- Gold
		Value = 10,
		Particle = "Sparkles"
	},
	Gem = {
		Shape = "Wedge",
		BaseSize = Vector3.new(0.8, 1.2, 0.8),
		BaseColor = Color3.fromRGB(0, 191, 255), -- Blue
		Value = 1,
		Particle = "Sparkles"
	},
	PowerUp = {
		Shape = "Ball",
		BaseSize = Vector3.new(1.5, 1.5, 1.5),
		BaseColor = Color3.fromRGB(255, 0, 255), -- Magenta
		Duration = 30,
		Particle = "Fire"
	},
	HealthPack = {
		Shape = "Block",
		BaseSize = Vector3.new(1, 1, 1),
		BaseColor = Color3.fromRGB(0, 255, 0), -- Green
		HealAmount = 50,
		Particle = nil
	},
	Chest = {
		Shape = "Block",
		BaseSize = Vector3.new(2, 1.5, 1.5),
		BaseColor = Color3.fromRGB(139, 69, 19), -- Brown
		LootTable = {"Coins", "Gems", "PowerUp"},
		Particle = "Sparkles"
	}
}

-- Loot rarity weights
local LOOT_RARITY = {
	Common = 60,
	Uncommon = 25,
	Rare = 10,
	Epic = 4,
	Legendary = 1
}

-- Generate a collectible item
function ProceduralItemGenerator:GenerateItem(itemType, position, properties)
	itemType = itemType or "Coin"
	position = position or Vector3.new(0, 5, 0)
	properties = properties or {}

	local template = ITEM_TEMPLATES[itemType]
	if not template then
		warn("[ItemGenerator] Unknown item type:", itemType)
		return nil
	end

	-- Create item model
	local item = Instance.new("Model")
	item.Name = itemType

	local part
	if template.Shape == "Cylinder" then
		part = Instance.new("Part")
		part.Shape = Enum.PartType.Cylinder
	elseif template.Shape == "Ball" then
		part = Instance.new("Part")
		part.Shape = Enum.PartType.Ball
	elseif template.Shape == "Wedge" then
		part = Instance.new("WedgePart")
	else
		part = Instance.new("Part")
	end

	part.Name = "Primary"
	part.Size = properties.Size or template.BaseSize
	part.Color = properties.Color or template.BaseColor
	part.Material = Enum.Material.Neon
	part.Anchored = true
	part.CanCollide = false
	part.Position = position
	part.Parent = item

	item.PrimaryPart = part

	-- Add visual effects
	if template.Particle == "Sparkles" then
		local sparkles = Instance.new("Sparkles")
		sparkles.Parent = part
	elseif template.Particle == "Fire" then
		local fire = Instance.new("Fire")
		fire.Size = 3
		fire.Heat = 5
		fire.Parent = part
	end

	-- Add glow
	local pointLight = Instance.new("PointLight")
	pointLight.Brightness = 2
	pointLight.Range = 10
	pointLight.Color = part.Color
	pointLight.Parent = part

	-- Store item data as attributes
	part:SetAttribute("ItemType", itemType)
	part:SetAttribute("Value", template.Value)
	if template.Duration then
		part:SetAttribute("Duration", template.Duration)
	end
	if template.HealAmount then
		part:SetAttribute("HealAmount", template.HealAmount)
	end

	-- Add floating animation
	task.spawn(function()
		local startHeight = position.Y
		while item.Parent do
			local newY = startHeight + math.sin(tick() * 2) * 0.5
			if part.Parent then
				part.Position = Vector3.new(position.X, newY, position.Z)
				part.Orientation = Vector3.new(0, part.Orientation.Y + 2, 0)
			end
			task.wait(0.03)
		end
	end)

	return item
end

-- Generate random loot drop
function ProceduralItemGenerator:GenerateLootDrop(position, sourceLevel)
	sourceLevel = sourceLevel or 1

	-- Determine item type based on weighted random
	local itemTypes = {"Coin", "Coin", "Coin", "Gem", "PowerUp", "HealthPack"}
	local itemType = itemTypes[math.random(1, #itemTypes)]

	-- Scale value based on source level
	local properties = {}
	if itemType == "Coin" then
		properties.Value = 10 * sourceLevel
	elseif itemType == "Gem" then
		properties.Value = math.ceil(sourceLevel / 5)
	end

	return self:GenerateItem(itemType, position, properties)
end

-- Generate loot chest
function ProceduralItemGenerator:GenerateChest(position, rarity)
	rarity = rarity or "Common"

	local chest = self:GenerateItem("Chest", position)

	if not chest then return nil end

	-- Add rarity-based visual modifications
	local rarityColors = {
		Common = Color3.fromRGB(139, 69, 19), -- Brown
		Uncommon = Color3.fromRGB(0, 200, 0), -- Green
		Rare = Color3.fromRGB(0, 100, 255), -- Blue
		Epic = Color3.fromRGB(150, 0, 255), -- Purple
		Legendary = Color3.fromRGB(255, 215, 0) -- Gold
	}

	local part = chest.PrimaryPart
	if part then
		-- Add accent color
		local accent = Instance.new("Part")
		accent.Size = Vector3.new(2.2, 0.2, 1.7)
		accent.Position = part.Position + Vector3.new(0, 0.5, 0)
		accent.Color = rarityColors[rarity] or rarityColors.Common
		accent.Material = Enum.Material.Neon
		accent.Anchored = true
		accent.CanCollide = false
		accent.Parent = chest

		-- Store rarity
		part:SetAttribute("Rarity", rarity)
	end

	return chest
end

-- Generate collectible coins in a pattern
function ProceduralItemGenerator:GenerateCoinPattern(centerPosition, pattern, count)
	pattern = pattern or "Circle"
	count = count or 10

	local coins = {}

	for i = 1, count do
		local offset
		if pattern == "Circle" then
			local angle = (i / count) * math.pi * 2
			local radius = 5
			offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
		elseif pattern == "Line" then
			offset = Vector3.new(i * 2, 0, 0)
		elseif pattern == "Grid" then
			local gridSize = math.ceil(math.sqrt(count))
			local x = (i % gridSize) * 2
			local z = math.floor(i / gridSize) * 2
			offset = Vector3.new(x, 0, z)
		else
			offset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
		end

		local coin = self:GenerateItem("Coin", centerPosition + offset)
		if coin then
			table.insert(coins, coin)
		end
	end

	return coins
end

-- Generate power-up with random effect
function ProceduralItemGenerator:GeneratePowerUp(position, powerType)
	local powerTypes = {
		Speed = {Color = Color3.fromRGB(0, 255, 255), Icon = "⚡"},
		Damage = {Color = Color3.fromRGB(255, 0, 0), Icon = "💥"},
		Shield = {Color = Color3.fromRGB(0, 100, 255), Icon = "🛡️"},
		Magnet = {Color = Color3.fromRGB(255, 215, 0), Icon = "🧲"},
		Double = {Color = Color3.fromRGB(255, 0, 255), Icon = "✨"}
	}

	powerType = powerType or ({"Speed", "Damage", "Shield", "Magnet", "Double"})[math.random(1, 5)]
	local powerConfig = powerTypes[powerType]

	local powerUp = self:GenerateItem("PowerUp", position, {
		Color = powerConfig.Color
	})

	if powerUp and powerUp.PrimaryPart then
		powerUp.PrimaryPart:SetAttribute("PowerType", powerType)
		powerUp.PrimaryPart:SetAttribute("Duration", 30)

		-- Add billboard with icon
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 50, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.Parent = powerUp.PrimaryPart

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = powerConfig.Icon
		label.TextScaled = true
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Parent = billboard
	end

	return powerUp
end

-- Clean up collected item with animation
function ProceduralItemGenerator:CollectItem(item, player)
	if not item or not item.PrimaryPart then return end

	local part = item.PrimaryPart

	-- Animate collection
	local startPos = part.Position
	local character = player.Character
	local targetPos = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or startPos

	task.spawn(function()
		for i = 1, 10 do
			if part.Parent then
				part.Position = part.Position:Lerp(targetPos + Vector3.new(0, 3, 0), i / 10)
				part.Size = part.Size * 0.9
				task.wait(0.03)
			end
		end
		item:Destroy()
	end)
end

return ProceduralItemGenerator

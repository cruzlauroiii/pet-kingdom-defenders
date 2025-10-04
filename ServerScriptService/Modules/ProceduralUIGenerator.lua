--[[
	ProceduralUIGenerator - Generates UI sprites, icons, and visual elements
	NO external images required - Uses Frame gradients and shapes

	Creates all UI elements procedurally for zero asset dependencies
]]

local ProceduralUIGenerator = {}

-- Color schemes for different UI elements
local COLOR_SCHEMES = {
	Currency = {
		Coins = Color3.fromRGB(255, 215, 0), -- Gold
		Gems = Color3.fromRGB(0, 191, 255), -- Deep Sky Blue
	},
	Rarity = {
		Common = Color3.fromRGB(190, 190, 190), -- Gray
		Uncommon = Color3.fromRGB(30, 255, 0), -- Green
		Rare = Color3.fromRGB(0, 112, 255), -- Blue
		Epic = Color3.fromRGB(163, 53, 238), -- Purple
		Legendary = Color3.fromRGB(255, 128, 0), -- Orange
	},
	Status = {
		Success = Color3.fromRGB(0, 255, 0), -- Green
		Error = Color3.fromRGB(255, 0, 0), -- Red
		Warning = Color3.fromRGB(255, 255, 0), -- Yellow
		Info = Color3.fromRGB(0, 191, 255), -- Light Blue
	}
}

-- Generate circular icon
function ProceduralUIGenerator:GenerateCircleIcon(color, size)
	size = size or UDim2.new(0, 50, 0, 50)

	local icon = Instance.new("Frame")
	icon.Size = size
	icon.BackgroundColor3 = color
	icon.BorderSizePixel = 0

	-- Make circular using UICorner
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0) -- Full circle
	corner.Parent = icon

	-- Add gradient for depth
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, color)
	}
	gradient.Rotation = 45
	gradient.Parent = icon

	return icon
end

-- Generate currency icon
function ProceduralUIGenerator:GenerateCurrencyIcon(currencyType)
	local color = COLOR_SCHEMES.Currency[currencyType] or Color3.fromRGB(255, 255, 255)
	local icon = self:GenerateCircleIcon(color, UDim2.new(0, 32, 0, 32))

	-- Add shine effect
	local shine = Instance.new("Frame")
	shine.Size = UDim2.new(0.4, 0, 0.4, 0)
	shine.Position = UDim2.new(0.2, 0, 0.2, 0)
	shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shine.BackgroundTransparency = 0.5
	shine.BorderSizePixel = 0
	shine.Parent = icon

	local shineCorner = Instance.new("UICorner")
	shineCorner.CornerRadius = UDim.new(1, 0)
	shineCorner.Parent = shine

	return icon
end

-- Generate rarity border
function ProceduralUIGenerator:GenerateRarityBorder(rarity)
	local color = COLOR_SCHEMES.Rarity[rarity] or COLOR_SCHEMES.Rarity.Common

	local border = Instance.new("UIStroke")
	border.Color = color
	border.Thickness = 3
	border.Transparency = 0

	-- Add glow effect for higher rarities
	if rarity == "Epic" or rarity == "Legendary" then
		border.Thickness = 4

		-- Create glow (shadow simulation)
		local glow = Instance.new("ImageLabel")
		glow.Size = UDim2.new(1, 20, 1, 20)
		glow.Position = UDim2.new(0, -10, 0, -10)
		glow.BackgroundTransparency = 1
		glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		glow.ImageColor3 = color
		glow.ImageTransparency = 0.7
		glow.ScaleType = Enum.ScaleType.Slice
		glow.SliceCenter = Rect.new(10, 10, 118, 118)

		return border, glow
	end

	return border
end

-- Generate pet icon (simplified representation)
function ProceduralUIGenerator:GeneratePetIcon(petName, rarity)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 64, 0, 64)
	container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	container.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.1, 0)
	corner.Parent = container

	-- Add rarity border
	local border = self:GenerateRarityBorder(rarity)
	border.Parent = container

	-- Create simple shape representation
	local shape = Instance.new("Frame")
	shape.Size = UDim2.new(0.6, 0, 0.6, 0)
	shape.Position = UDim2.new(0.2, 0, 0.2, 0)
	shape.BackgroundColor3 = COLOR_SCHEMES.Rarity[rarity] or Color3.fromRGB(200, 200, 200)
	shape.BorderSizePixel = 0
	shape.Parent = container

	-- Different shapes for different pet types
	if petName:find("Dragon") or petName:find("Phoenix") then
		-- Triangle (wedge approximation using rotation)
		shape.Rotation = 0
		local shapeCorner = Instance.new("UICorner")
		shapeCorner.CornerRadius = UDim.new(0.2, 0)
		shapeCorner.Parent = shape
	elseif petName:find("Cat") or petName:find("Dog") then
		-- Circle
		local shapeCorner = Instance.new("UICorner")
		shapeCorner.CornerRadius = UDim.new(1, 0)
		shapeCorner.Parent = shape
	else
		-- Square
		local shapeCorner = Instance.new("UICorner")
		shapeCorner.CornerRadius = UDim.new(0.1, 0)
		shapeCorner.Parent = shape
	end

	-- Add name label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, 1, -20)
	label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	label.BackgroundTransparency = 0.5
	label.Text = petName
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.BorderSizePixel = 0
	label.Parent = container

	return container
end

-- Generate loading spinner
function ProceduralUIGenerator:GenerateLoadingSpinner(size)
	size = size or UDim2.new(0, 50, 0, 50)

	local spinner = Instance.new("Frame")
	spinner.Size = size
	spinner.BackgroundTransparency = 1
	spinner.BorderSizePixel = 0

	-- Create rotating arc segments
	for i = 1, 8 do
		local segment = Instance.new("Frame")
		segment.Size = UDim2.new(0, 6, 0.3, 0)
		segment.Position = UDim2.new(0.5, -3, 0.1, 0)
		segment.AnchorPoint = Vector2.new(0.5, 0)
		segment.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		segment.BackgroundTransparency = 0.2 + (i * 0.1)
		segment.BorderSizePixel = 0
		segment.Rotation = (i - 1) * 45
		segment.Parent = spinner

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = segment
	end

	-- Animate rotation
	task.spawn(function()
		while spinner.Parent do
			spinner.Rotation = spinner.Rotation + 10
			task.wait(0.05)
		end
	end)

	return spinner
end

-- Generate progress bar
function ProceduralUIGenerator:GenerateProgressBar(current, max, color)
	current = current or 0
	max = max or 100
	color = color or Color3.fromRGB(0, 255, 0)

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 20)
	container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	container.BorderSizePixel = 1
	container.BorderColor3 = Color3.fromRGB(0, 0, 0)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(current / max, 0, 1, 0)
	bar.BackgroundColor3 = color
	bar.BorderSizePixel = 0
	bar.Parent = container

	-- Add gradient
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, color)
	}
	gradient.Rotation = 90
	gradient.Parent = bar

	-- Add text
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = string.format("%d / %d", current, max)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextStrokeTransparency = 0.5
	label.Parent = container

	return container
end

-- Generate button with effects
function ProceduralUIGenerator:GenerateButton(text, color, size)
	text = text or "Button"
	color = color or Color3.fromRGB(0, 170, 255)
	size = size or UDim2.new(0, 150, 0, 50)

	local button = Instance.new("TextButton")
	button.Size = size
	button.BackgroundColor3 = color
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextScaled = true
	button.Font = Enum.Font.GothamBold
	button.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = button

	-- Add gradient
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, color)
	}
	gradient.Rotation = 90
	gradient.Parent = button

	-- Add stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 2
	stroke.Transparency = 0.7
	stroke.Parent = button

	-- Hover effect
	button.MouseEnter:Connect(function()
		gradient.Rotation = 270
		stroke.Transparency = 0.3
	end)

	button.MouseLeave:Connect(function()
		gradient.Rotation = 90
		stroke.Transparency = 0.7
	end)

	return button
end

-- Generate notification badge
function ProceduralUIGenerator:GenerateNotificationBadge(count)
	count = count or 1

	local badge = Instance.new("Frame")
	badge.Size = UDim2.new(0, 24, 0, 24)
	badge.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	badge.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = badge

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = tostring(count)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = badge

	return badge
end

return ProceduralUIGenerator

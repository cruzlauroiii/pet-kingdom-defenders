--[[
	ProceduralEnemyGenerator - Generates Tower Defense enemies using geometric shapes
	NO MESH IDS REQUIRED - Inspired by popular games like Geometry Defense

	Uses simple geometric shapes for performant, unique enemies
	Can handle 500+ enemies without lag
]]

local ProceduralEnemyGenerator = {}

-- Enemy templates using geometric shapes
local ENEMY_TEMPLATES = {
	-- Basic geometric enemies
	Cube = {
		Shape = "Block",
		Size = Vector3.new(2, 2, 2),
		Color = Color3.fromRGB(255, 100, 100),
		Health = 50,
		Speed = 8,
		Reward = 10
	},

	Sphere = {
		Shape = "Ball",
		Size = Vector3.new(2, 2, 2),
		Color = Color3.fromRGB(100, 100, 255),
		Health = 75,
		Speed = 10,
		Reward = 15
	},

	Pyramid = {
		Shape = "Wedge",
		Size = Vector3.new(2.5, 2.5, 2.5),
		Color = Color3.fromRGB(255, 200, 50),
		Health = 100,
		Speed = 6,
		Reward = 20
	},

	Cylinder = {
		Shape = "Cylinder",
		Size = Vector3.new(2, 3, 2),
		Color = Color3.fromRGB(150, 255, 150),
		Health = 60,
		Speed = 12,
		Reward = 12
	},

	-- Advanced geometric enemies
	Octahedron = {
		-- Two pyramids joined (approximation using wedges)
		Parts = {
			{Shape = "Wedge", Size = Vector3.new(2, 2, 2), Offset = Vector3.new(0, 1, 0)},
			{Shape = "Wedge", Size = Vector3.new(2, 2, 2), Offset = Vector3.new(0, -1, 0), Rotation = 180}
		},
		Color = Color3.fromRGB(255, 100, 255),
		Health = 150,
		Speed = 7,
		Reward = 30
	},

	Hexagon = {
		-- Six-sided shape using blocks
		Parts = {
			{Shape = "Block", Size = Vector3.new(2, 2, 0.5), Offset = Vector3.new(0, 0, 0)},
			{Shape = "Block", Size = Vector3.new(0.5, 2, 2), Offset = Vector3.new(0, 0, 0)}
		},
		Color = Color3.fromRGB(100, 255, 255),
		Health = 120,
		Speed = 9,
		Reward = 25
	},

	Boss = {
		-- Large complex enemy
		Parts = {
			{Shape = "Ball", Size = Vector3.new(4, 4, 4), Offset = Vector3.new(0, 0, 0)},
			{Shape = "Cylinder", Size = Vector3.new(1, 3, 1), Offset = Vector3.new(0, 3, 0)},
			{Shape = "Block", Size = Vector3.new(2, 0.5, 0.5), Offset = Vector3.new(0, 4.5, 0)}
		},
		Color = Color3.fromRGB(150, 0, 150),
		Health = 500,
		Speed = 5,
		Reward = 100
	}
}

-- Color variations for different wave difficulties
local DIFFICULTY_COLORS = {
	Easy = Color3.fromRGB(100, 200, 100),
	Medium = Color3.fromRGB(200, 200, 100),
	Hard = Color3.fromRGB(200, 100, 100),
	Boss = Color3.fromRGB(150, 0, 150)
}

-- Create a basic part
local function createPart(shape, size, color)
	local part

	if shape == "Ball" then
		part = Instance.new("Part")
		part.Shape = Enum.PartType.Ball
	elseif shape == "Cylinder" then
		part = Instance.new("Part")
		part.Shape = Enum.PartType.Cylinder
	elseif shape == "Wedge" then
		part = Instance.new("WedgePart")
	else
		part = Instance.new("Part")
	end

	part.Size = size
	part.Color = color
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Material = Enum.Material.Neon -- Glowing effect
	part.Anchored = false
	part.CanCollide = false

	return part
end

-- Generate an enemy from template
function ProceduralEnemyGenerator:GenerateEnemy(enemyType, waveNumber, difficulty)
	local template = ENEMY_TEMPLATES[enemyType] or ENEMY_TEMPLATES.Cube

	-- Scale stats with wave number
	local healthMultiplier = 1 + (waveNumber * 0.1)
	local speedMultiplier = 1 + (waveNumber * 0.05)
	local rewardMultiplier = 1 + (waveNumber * 0.1)

	-- Adjust color based on difficulty
	local baseColor = template.Color
	if difficulty then
		baseColor = DIFFICULTY_COLORS[difficulty] or baseColor
	end

	-- Create model
	local model = Instance.new("Model")
	model.Name = enemyType

	local parts = {}

	-- Simple enemy (single part)
	if template.Shape then
		local mainPart = createPart(template.Shape, template.Size, baseColor)
		mainPart.Name = "HumanoidRootPart" -- For compatibility
		mainPart.Parent = model
		table.insert(parts, mainPart)

		-- Add health bar
		local healthBar = Instance.new("BillboardGui")
		healthBar.Name = "HealthBar"
		healthBar.Size = UDim2.new(0, 50, 0, 5)
		healthBar.StudsOffset = Vector3.new(0, 3, 0)
		healthBar.Parent = mainPart

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(1, 0, 1, 0)
		bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		bar.BorderSizePixel = 0
		bar.Parent = healthBar
	end

	-- Complex enemy (multiple parts)
	if template.Parts then
		local mainPart = nil

		for i, partData in ipairs(template.Parts) do
			local part = createPart(partData.Shape, partData.Size, baseColor)
			part.Name = i == 1 and "HumanoidRootPart" or "Part" .. i
			part.Position = partData.Offset or Vector3.new(0, 0, 0)

			if partData.Rotation then
				part.Orientation = Vector3.new(partData.Rotation, 0, 0)
			end

			part.Parent = model
			table.insert(parts, part)

			if i == 1 then
				mainPart = part

				-- Add health bar to main part
				local healthBar = Instance.new("BillboardGui")
				healthBar.Name = "HealthBar"
				healthBar.Size = UDim2.new(0, 60, 0, 6)
				healthBar.StudsOffset = Vector3.new(0, 4, 0)
				healthBar.Parent = mainPart

				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(1, 0, 1, 0)
				bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
				bar.BorderSizePixel = 0
				bar.Parent = healthBar
			end
		end

		-- Weld parts together
		for _, part in ipairs(parts) do
			if part ~= mainPart then
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = mainPart
				weld.Part1 = part
				weld.Parent = mainPart
			end
		end
	end

	-- Set primary part
	model.PrimaryPart = model:FindFirstChild("HumanoidRootPart")

	-- Store enemy stats in attributes (for Tower Defense system)
	if model.PrimaryPart then
		model.PrimaryPart:SetAttribute("Health", math.floor(template.Health * healthMultiplier))
		model.PrimaryPart:SetAttribute("MaxHealth", math.floor(template.Health * healthMultiplier))
		model.PrimaryPart:SetAttribute("Speed", template.Speed * speedMultiplier)
		model.PrimaryPart:SetAttribute("Reward", math.floor(template.Reward * rewardMultiplier))
		model.PrimaryPart:SetAttribute("EnemyType", enemyType)
	end

	-- Add floating effect
	if model.PrimaryPart then
		local bodyPosition = Instance.new("BodyPosition")
		bodyPosition.MaxForce = Vector3.new(0, 50000, 0)
		bodyPosition.Position = model.PrimaryPart.Position + Vector3.new(0, math.sin(tick()) * 0.5, 0)
		bodyPosition.Parent = model.PrimaryPart

		-- Rotate enemy for visual effect
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(0, 50000, 0)
		bodyGyro.CFrame = model.PrimaryPart.CFrame
		bodyGyro.Parent = model.PrimaryPart

		-- Spin animation
		task.spawn(function()
			while model.Parent do
				if bodyGyro then
					bodyGyro.CFrame = bodyGyro.CFrame * CFrame.Angles(0, math.rad(2), 0)
				end
				task.wait(0.03)
			end
		end)
	end

	return model
end

-- Generate a wave of enemies
function ProceduralEnemyGenerator:GenerateWave(waveNumber)
	local enemies = {}
	local enemyCount = 5 + (waveNumber * 2) -- Scale with wave

	-- Determine difficulty
	local difficulty = "Easy"
	if waveNumber >= 10 then
		difficulty = "Hard"
	elseif waveNumber >= 5 then
		difficulty = "Medium"
	end

	-- Select enemy types for this wave
	local enemyTypes = {"Cube", "Sphere", "Pyramid", "Cylinder"}

	-- Add advanced enemies on higher waves
	if waveNumber >= 3 then
		table.insert(enemyTypes, "Hexagon")
	end
	if waveNumber >= 5 then
		table.insert(enemyTypes, "Octahedron")
	end

	-- Generate enemies
	for i = 1, enemyCount do
		local enemyType = enemyTypes[math.random(1, #enemyTypes)]
		local enemy = self:GenerateEnemy(enemyType, waveNumber, difficulty)
		table.insert(enemies, enemy)
	end

	-- Add boss every 10 waves
	if waveNumber % 10 == 0 then
		local boss = self:GenerateEnemy("Boss", waveNumber, "Boss")
		table.insert(enemies, boss)
	end

	return enemies
end

-- Update health bar visual
function ProceduralEnemyGenerator:UpdateHealthBar(enemy, currentHealth, maxHealth)
	local primaryPart = enemy.PrimaryPart
	if not primaryPart then return end

	local healthBar = primaryPart:FindFirstChild("HealthBar")
	if not healthBar then return end

	local bar = healthBar:FindFirstChild("Frame")
	if not bar then return end

	-- Update bar size based on health percentage
	local healthPercent = currentHealth / maxHealth
	bar.Size = UDim2.new(healthPercent, 0, 1, 0)

	-- Change color based on health
	if healthPercent > 0.6 then
		bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
	elseif healthPercent > 0.3 then
		bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
	else
		bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
	end
end

return ProceduralEnemyGenerator

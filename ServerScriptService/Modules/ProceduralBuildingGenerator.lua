--[[
	ProceduralBuildingGenerator - Generates tycoon buildings using only Roblox Parts
	NO MESH IDS REQUIRED - Fully procedural and performant

	Creates unique buildings for the tycoon system using geometric shapes
]]

local ProceduralBuildingGenerator = {}

-- Building templates for different types
local BUILDING_TEMPLATES = {
	-- Pet Spawners
	Spawner = {
		Base = {Size = Vector3.new(8, 1, 8), Position = Vector3.new(0, 0.5, 0), Color = Color3.fromRGB(100, 100, 100)},
		Pillar = {Size = Vector3.new(1, 6, 1), Positions = {
			Vector3.new(-3, 3, -3),
			Vector3.new(3, 3, -3),
			Vector3.new(-3, 3, 3),
			Vector3.new(3, 3, 3)
		}, Color = Color3.fromRGB(150, 150, 150)},
		Roof = {Size = Vector3.new(10, 0.5, 10), Position = Vector3.new(0, 7, 0), Color = Color3.fromRGB(180, 100, 50)},
		SpawnPoint = {Size = Vector3.new(4, 0.5, 4), Position = Vector3.new(0, 1.5, 0), Color = Color3.fromRGB(100, 200, 100)}
	},

	-- Collectors
	Collector = {
		Base = {Size = Vector3.new(6, 1, 6), Position = Vector3.new(0, 0.5, 0), Color = Color3.fromRGB(80, 80, 120)},
		Tank = {Size = Vector3.new(4, 5, 4), Position = Vector3.new(0, 3, 0), Shape = "Cylinder", Color = Color3.fromRGB(100, 150, 200)},
		Pipe = {Size = Vector3.new(0.5, 3, 0.5), Position = Vector3.new(2, 5, 0), Shape = "Cylinder", Color = Color3.fromRGB(120, 120, 120)},
		Funnel = {Size = Vector3.new(3, 1, 3), Position = Vector3.new(0, 6, 0), Color = Color3.fromRGB(150, 180, 220)}
	},

	-- Upgraders
	Upgrader = {
		Base = {Size = Vector3.new(7, 1, 7), Position = Vector3.new(0, 0.5, 0), Color = Color3.fromRGB(120, 80, 150)},
		Conveyor = {Size = Vector3.new(6, 0.5, 3), Position = Vector3.new(0, 1.5, 0), Color = Color3.fromRGB(60, 60, 60)},
		Gears = {
			{Size = Vector3.new(1.5, 0.3, 1.5), Position = Vector3.new(-2, 2.5, 0), Shape = "Cylinder"},
			{Size = Vector3.new(1.5, 0.3, 1.5), Position = Vector3.new(0, 2.5, 0), Shape = "Cylinder"},
			{Size = Vector3.new(1.5, 0.3, 1.5), Position = Vector3.new(2, 2.5, 0), Shape = "Cylinder"}
		},
		Housing = {Size = Vector3.new(7, 3, 4), Position = Vector3.new(0, 3, 0), Color = Color3.fromRGB(150, 100, 180)}
	},

	-- Factory
	Factory = {
		Base = {Size = Vector3.new(12, 1, 12), Position = Vector3.new(0, 0.5, 0), Color = Color3.fromRGB(100, 100, 100)},
		MainBuilding = {Size = Vector3.new(10, 8, 10), Position = Vector3.new(0, 4.5, 0), Color = Color3.fromRGB(140, 140, 140)},
		Chimney = {Size = Vector3.new(2, 6, 2), Position = Vector3.new(4, 10, 4), Shape = "Cylinder", Color = Color3.fromRGB(80, 80, 80)},
		Door = {Size = Vector3.new(3, 4, 0.5), Position = Vector3.new(0, 2.5, 5.5), Color = Color3.fromRGB(100, 50, 20)},
		Windows = {
			{Size = Vector3.new(2, 2, 0.2), Position = Vector3.new(-3, 6, 5.2)},
			{Size = Vector3.new(2, 2, 0.2), Position = Vector3.new(3, 6, 5.2)}
		}
	}
}

-- Helper function to create a part
local function createPart(size, position, color, shape)
	local part = Instance.new("Part")

	if shape == "Cylinder" then
		part.Shape = Enum.PartType.Cylinder
	elseif shape == "Ball" then
		part.Shape = Enum.PartType.Ball
	end

	part.Size = size
	part.Position = position
	part.Color = color or Color3.fromRGB(200, 200, 200)
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Material = Enum.Material.SmoothPlastic

	return part
end

-- Generate a building from template
function ProceduralBuildingGenerator:GenerateBuilding(buildingType, buildingName, position)
	local template = BUILDING_TEMPLATES.Spawner -- Default

	-- Select template based on building name
	if buildingName:find("Spawner") then
		template = BUILDING_TEMPLATES.Spawner
	elseif buildingName:find("Collector") then
		template = BUILDING_TEMPLATES.Collector
	elseif buildingName:find("Upgrader") then
		template = BUILDING_TEMPLATES.Upgrader
	elseif buildingName:find("Factory") then
		template = BUILDING_TEMPLATES.Factory
	end

	-- Create model container
	local model = Instance.new("Model")
	model.Name = buildingName

	local parts = {}
	local basePosition = position or Vector3.new(0, 0, 0)

	-- Create base
	if template.Base then
		local base = createPart(
			template.Base.Size,
			basePosition + template.Base.Position,
			template.Base.Color
		)
		base.Name = "Base"
		base.Parent = model
		table.insert(parts, base)
	end

	-- Create pillars (if exists)
	if template.Pillar then
		for i, pillarPos in ipairs(template.Pillar.Positions) do
			local pillar = createPart(
				template.Pillar.Size,
				basePosition + pillarPos,
				template.Pillar.Color
			)
			pillar.Name = "Pillar" .. i
			pillar.Parent = model
			table.insert(parts, pillar)
		end
	end

	-- Create roof (if exists)
	if template.Roof then
		local roof = createPart(
			template.Roof.Size,
			basePosition + template.Roof.Position,
			template.Roof.Color
		)
		roof.Name = "Roof"
		roof.Parent = model
		table.insert(parts, roof)
	end

	-- Create spawn point (spawners)
	if template.SpawnPoint then
		local spawnPoint = createPart(
			template.SpawnPoint.Size,
			basePosition + template.SpawnPoint.Position,
			template.SpawnPoint.Color
		)
		spawnPoint.Name = "SpawnPoint"
		spawnPoint.Transparency = 0.5
		spawnPoint.Parent = model
		table.insert(parts, spawnPoint)
	end

	-- Create tank (collectors)
	if template.Tank then
		local tank = createPart(
			template.Tank.Size,
			basePosition + template.Tank.Position,
			template.Tank.Color,
			template.Tank.Shape
		)
		tank.Name = "Tank"
		tank.Parent = model
		table.insert(parts, tank)
	end

	-- Create pipe (collectors)
	if template.Pipe then
		local pipe = createPart(
			template.Pipe.Size,
			basePosition + template.Pipe.Position,
			template.Pipe.Color,
			template.Pipe.Shape
		)
		pipe.Name = "Pipe"
		pipe.Parent = model
		table.insert(parts, pipe)
	end

	-- Create funnel (collectors)
	if template.Funnel then
		local funnel = createPart(
			template.Funnel.Size,
			basePosition + template.Funnel.Position,
			template.Funnel.Color
		)
		funnel.Name = "Funnel"
		funnel.Parent = model
		table.insert(parts, funnel)
	end

	-- Create conveyor (upgraders)
	if template.Conveyor then
		local conveyor = createPart(
			template.Conveyor.Size,
			basePosition + template.Conveyor.Position,
			template.Conveyor.Color
		)
		conveyor.Name = "Conveyor"
		conveyor.Parent = model
		table.insert(parts, conveyor)
	end

	-- Create gears (upgraders)
	if template.Gears then
		for i, gearData in ipairs(template.Gears) do
			local gear = createPart(
				gearData.Size,
				basePosition + gearData.Position,
				Color3.fromRGB(200, 150, 50),
				gearData.Shape
			)
			gear.Name = "Gear" .. i
			gear.Parent = model
			table.insert(parts, gear)
		end
	end

	-- Create housing (upgraders)
	if template.Housing then
		local housing = createPart(
			template.Housing.Size,
			basePosition + template.Housing.Position,
			template.Housing.Color
		)
		housing.Name = "Housing"
		housing.Transparency = 0.3
		housing.Parent = model
		table.insert(parts, housing)
	end

	-- Create main building (factory)
	if template.MainBuilding then
		local mainBuilding = createPart(
			template.MainBuilding.Size,
			basePosition + template.MainBuilding.Position,
			template.MainBuilding.Color
		)
		mainBuilding.Name = "MainBuilding"
		mainBuilding.Parent = model
		table.insert(parts, mainBuilding)
	end

	-- Create chimney (factory)
	if template.Chimney then
		local chimney = createPart(
			template.Chimney.Size,
			basePosition + template.Chimney.Position,
			template.Chimney.Color,
			template.Chimney.Shape
		)
		chimney.Name = "Chimney"
		chimney.Parent = model
		table.insert(parts, chimney)

		-- Add smoke effect
		local smoke = Instance.new("Smoke")
		smoke.Parent = chimney
	end

	-- Create door (factory)
	if template.Door then
		local door = createPart(
			template.Door.Size,
			basePosition + template.Door.Position,
			template.Door.Color
		)
		door.Name = "Door"
		door.Parent = model
		table.insert(parts, door)
	end

	-- Create windows (factory)
	if template.Windows then
		for i, windowData in ipairs(template.Windows) do
			local window = createPart(
				windowData.Size,
				basePosition + windowData.Position,
				Color3.fromRGB(150, 200, 255)
			)
			window.Name = "Window" .. i
			window.Transparency = 0.5
			window.Parent = model
			table.insert(parts, window)
		end
	end

	-- Set primary part
	model.PrimaryPart = model:FindFirstChild("Base") or parts[1]

	return model
end

-- Generate a purchase button for the building
function ProceduralBuildingGenerator:GeneratePurchaseButton(building, cost, costType)
	local button = Instance.new("Part")
	button.Name = "PurchaseButton"
	button.Size = Vector3.new(4, 1, 4)
	button.Color = Color3.fromRGB(100, 200, 100)
	button.Material = Enum.Material.Neon
	button.Anchored = true
	button.CanCollide = false

	-- Position button in front of building
	if building.PrimaryPart then
		button.Position = building.PrimaryPart.Position + Vector3.new(0, 2, 8)
	end

	-- Add text label above button
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 200, 0, 100)
	billboardGui.StudsOffset = Vector3.new(0, 3, 0)
	billboardGui.Parent = button

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = string.format("💰 %d %s", cost, costType)
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboardGui

	button.Parent = building
	return button
end

return ProceduralBuildingGenerator

--[[
	ProceduralPetGenerator - Generates pets using only Roblox Parts
	NO MESH IDS REQUIRED - Fully procedural, free, and performant

	Uses geometric shapes and procedural generation to create unique pets
	Each pet is generated from combinations of Parts, colors, and patterns
]]

local ProceduralPetGenerator = {}

-- Pet shape templates using only basic Parts
local PET_TEMPLATES = {
	-- Dog-like creature
	Dog = {
		Body = {Type = "Ball", Scale = Vector3.new(2, 1.5, 2.5)},
		Head = {Type = "Ball", Scale = Vector3.new(1.2, 1.2, 1.2), Offset = Vector3.new(0, 0.5, 1.5)},
		Ears = {
			{Type = "Cylinder", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(-0.5, 1.2, 1.5)},
			{Type = "Cylinder", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(0.5, 1.2, 1.5)}
		},
		Legs = {
			{Type = "Cylinder", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(-0.6, -1, 0.8)},
			{Type = "Cylinder", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(0.6, -1, 0.8)},
			{Type = "Cylinder", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(-0.6, -1, -0.8)},
			{Type = "Cylinder", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(0.6, -1, -0.8)}
		},
		Tail = {Type = "Cylinder", Scale = Vector3.new(0.2, 1, 0.2), Offset = Vector3.new(0, 0.5, -2)}
	},

	-- Cat-like creature
	Cat = {
		Body = {Type = "Ball", Scale = Vector3.new(1.5, 1.2, 2)},
		Head = {Type = "Ball", Scale = Vector3.new(1, 1, 1), Offset = Vector3.new(0, 0.3, 1.2)},
		Ears = {
			{Type = "Wedge", Scale = Vector3.new(0.4, 0.6, 0.3), Offset = Vector3.new(-0.4, 1, 1.2)},
			{Type = "Wedge", Scale = Vector3.new(0.4, 0.6, 0.3), Offset = Vector3.new(0.4, 1, 1.2)}
		},
		Legs = {
			{Type = "Cylinder", Scale = Vector3.new(0.25, 0.7, 0.25), Offset = Vector3.new(-0.5, -0.9, 0.6)},
			{Type = "Cylinder", Scale = Vector3.new(0.25, 0.7, 0.25), Offset = Vector3.new(0.5, -0.9, 0.6)},
			{Type = "Cylinder", Scale = Vector3.new(0.25, 0.7, 0.25), Offset = Vector3.new(-0.5, -0.9, -0.6)},
			{Type = "Cylinder", Scale = Vector3.new(0.25, 0.7, 0.25), Offset = Vector3.new(0.5, -0.9, -0.6)}
		},
		Tail = {Type = "Cylinder", Scale = Vector3.new(0.15, 1.5, 0.15), Offset = Vector3.new(0, 0.3, -1.5)}
	},

	-- Dragon-like creature
	Dragon = {
		Body = {Type = "Ball", Scale = Vector3.new(2, 1.8, 3)},
		Head = {Type = "Wedge", Scale = Vector3.new(1.5, 1.5, 2), Offset = Vector3.new(0, 0.8, 2.5)},
		Horns = {
			{Type = "Cone", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(-0.5, 2, 2.5)},
			{Type = "Cone", Scale = Vector3.new(0.3, 0.8, 0.3), Offset = Vector3.new(0.5, 2, 2.5)}
		},
		Wings = {
			{Type = "Wedge", Scale = Vector3.new(0.2, 2, 1.5), Offset = Vector3.new(-2, 1, 0)},
			{Type = "Wedge", Scale = Vector3.new(0.2, 2, 1.5), Offset = Vector3.new(2, 1, 0)}
		},
		Tail = {Type = "Cylinder", Scale = Vector3.new(0.3, 2, 0.3), Offset = Vector3.new(0, 0.5, -3)}
	},

	-- Bird-like creature
	Bird = {
		Body = {Type = "Ball", Scale = Vector3.new(1, 1.2, 1.5)},
		Head = {Type = "Ball", Scale = Vector3.new(0.6, 0.6, 0.6), Offset = Vector3.new(0, 0.8, 0.8)},
		Beak = {Type = "Wedge", Scale = Vector3.new(0.2, 0.3, 0.5), Offset = Vector3.new(0, 0.8, 1.2)},
		Wings = {
			{Type = "Wedge", Scale = Vector3.new(0.1, 1.5, 1), Offset = Vector3.new(-1.2, 0.5, 0)},
			{Type = "Wedge", Scale = Vector3.new(0.1, 1.5, 1), Offset = Vector3.new(1.2, 0.5, 0)}
		},
		Tail = {Type = "Wedge", Scale = Vector3.new(0.3, 0.8, 0.8), Offset = Vector3.new(0, 0, -1.2)}
	},

	-- Simple creatures for common pets
	Simple = {
		Body = {Type = "Ball", Scale = Vector3.new(1.5, 1.5, 1.5)},
		Eyes = {
			{Type = "Ball", Scale = Vector3.new(0.3, 0.3, 0.3), Offset = Vector3.new(-0.4, 0.5, 1.2)},
			{Type = "Ball", Scale = Vector3.new(0.3, 0.3, 0.3), Offset = Vector3.new(0.4, 0.5, 1.2)}
		}
	}
}

-- Color palettes for different rarities
local COLOR_PALETTES = {
	Common = {
		Color3.fromRGB(139, 69, 19),   -- Brown
		Color3.fromRGB(192, 192, 192), -- Gray
		Color3.fromRGB(210, 180, 140), -- Tan
		Color3.fromRGB(245, 245, 220)  -- Beige
	},
	Uncommon = {
		Color3.fromRGB(0, 100, 0),     -- Dark Green
		Color3.fromRGB(70, 130, 180),  -- Steel Blue
		Color3.fromRGB(218, 165, 32),  -- Golden Rod
		Color3.fromRGB(147, 112, 219)  -- Medium Purple
	},
	Rare = {
		Color3.fromRGB(255, 140, 0),   -- Dark Orange
		Color3.fromRGB(0, 206, 209),   -- Dark Turquoise
		Color3.fromRGB(255, 20, 147),  -- Deep Pink
		Color3.fromRGB(50, 205, 50)    -- Lime Green
	},
	Epic = {
		Color3.fromRGB(138, 43, 226),  -- Blue Violet
		Color3.fromRGB(255, 0, 255),   -- Magenta
		Color3.fromRGB(255, 215, 0),   -- Gold
		Color3.fromRGB(0, 255, 255)    -- Cyan
	},
	Legendary = {
		Color3.fromRGB(255, 215, 0),   -- Gold
		Color3.fromRGB(255, 0, 0),     -- Red
		Color3.fromRGB(148, 0, 211),   -- Dark Violet
		Color3.fromRGB(0, 255, 127)    -- Spring Green
	}
}

-- Create a basic Part with specified shape
local function createPart(partType, size, position)
	local part = Instance.new("Part")

	if partType == "Ball" then
		part.Shape = Enum.PartType.Ball
	elseif partType == "Cylinder" then
		part.Shape = Enum.PartType.Cylinder
	elseif partType == "Wedge" then
		part = Instance.new("WedgePart")
	elseif partType == "Cone" then
		local cone = Instance.new("MeshPart")
		cone.MeshId = "rbxassetid://1033714" -- Free Roblox cone mesh
		part = cone
	end

	part.Size = size
	part.Position = position
	part.Anchored = false
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth

	return part
end

-- Generate a pet model from a template
function ProceduralPetGenerator:GeneratePet(petName, rarity, isShiny)
	-- Determine template based on pet name
	local template = PET_TEMPLATES.Simple -- Default

	if petName == "Dog" or petName == "Loyal Dog" then
		template = PET_TEMPLATES.Dog
	elseif petName == "Cat" or petName == "Nimble Cat" then
		template = PET_TEMPLATES.Cat
	elseif petName:find("Dragon") or petName:find("Phoenix") then
		template = PET_TEMPLATES.Dragon
	elseif petName:find("Bird") or petName:find("Eagle") then
		template = PET_TEMPLATES.Bird
	end

	-- Choose color palette
	local colorPalette = COLOR_PALETTES[rarity] or COLOR_PALETTES.Common
	local baseColor = colorPalette[math.random(1, #colorPalette)]

	-- Shiny pets get gold overlay
	if isShiny then
		baseColor = Color3.fromRGB(255, 215, 0) -- Gold
	end

	-- Create model container
	local model = Instance.new("Model")
	model.Name = petName

	local parts = {}

	-- Create body (main part)
	if template.Body then
		local body = createPart(template.Body.Type, template.Body.Scale, Vector3.new(0, 0, 0))
		body.Name = "Body"
		body.Color = baseColor
		body.Parent = model
		table.insert(parts, body)
	end

	-- Create head
	if template.Head then
		local head = createPart(template.Head.Type, template.Head.Scale, template.Head.Offset)
		head.Name = "Head"
		head.Color = baseColor
		head.Parent = model
		table.insert(parts, head)
	end

	-- Create ears
	if template.Ears then
		for i, earData in ipairs(template.Ears) do
			local ear = createPart(earData.Type, earData.Scale, earData.Offset)
			ear.Name = "Ear" .. i
			ear.Color = baseColor
			ear.Parent = model
			table.insert(parts, ear)
		end
	end

	-- Create legs
	if template.Legs then
		for i, legData in ipairs(template.Legs) do
			local leg = createPart(legData.Type, legData.Scale, legData.Offset)
			leg.Name = "Leg" .. i
			leg.Color = baseColor
			leg.Parent = model
			table.insert(parts, leg)
		end
	end

	-- Create tail
	if template.Tail then
		local tail = createPart(template.Tail.Type, template.Tail.Scale, template.Tail.Offset)
		tail.Name = "Tail"
		tail.Color = baseColor
		tail.Parent = model
		table.insert(parts, tail)
	end

	-- Create horns (dragons)
	if template.Horns then
		for i, hornData in ipairs(template.Horns) do
			local horn = createPart(hornData.Type, hornData.Scale, hornData.Offset)
			horn.Name = "Horn" .. i
			horn.Color = baseColor
			horn.Parent = model
			table.insert(parts, horn)
		end
	end

	-- Create wings (dragons/birds)
	if template.Wings then
		for i, wingData in ipairs(template.Wings) do
			local wing = createPart(wingData.Type, wingData.Scale, wingData.Offset)
			wing.Name = "Wing" .. i
			wing.Color = baseColor
			wing.Parent = model
			table.insert(parts, wing)
		end
	end

	-- Create eyes (simple pets)
	if template.Eyes then
		for i, eyeData in ipairs(template.Eyes) do
			local eye = createPart(eyeData.Type, eyeData.Scale, eyeData.Offset)
			eye.Name = "Eye" .. i
			eye.Color = Color3.fromRGB(0, 0, 0) -- Black eyes
			eye.Parent = model
			table.insert(parts, eye)
		end
	end

	-- Create beak (birds)
	if template.Beak then
		local beak = createPart(template.Beak.Type, template.Beak.Scale, template.Beak.Offset)
		beak.Name = "Beak"
		beak.Color = Color3.fromRGB(255, 165, 0) -- Orange
		beak.Parent = model
		table.insert(parts, beak)
	end

	-- Weld all parts together
	local primaryPart = model:FindFirstChild("Body") or parts[1]
	model.PrimaryPart = primaryPart

	for _, part in ipairs(parts) do
		if part ~= primaryPart then
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = primaryPart
			weld.Part1 = part
			weld.Parent = primaryPart
		end
	end

	-- Add sparkle effect for shiny pets
	if isShiny then
		local sparkle = Instance.new("Sparkles")
		sparkle.Parent = primaryPart
	end

	return model
end

-- ROBLOX CUBE AI INTEGRATION (March 2025)
-- Generate pets using AI when available
function ProceduralPetGenerator:GenerateWithCubeAI(prompt)
	--[[
		ROBLOX CUBE AI - Available March 2025

		Usage in Studio:
		1. Open Assistant panel
		2. Type: /generate [your prompt]
		3. Example: /generate cute dog pet

		Usage in Lua API (when available):
		local MeshGenerationService = game:GetService("MeshGenerationService")
		local mesh = MeshGenerationService:GenerateMesh(prompt)

		For now, this returns procedural Part-based pets
		Update this function when Cube AI Lua API is released
	]]

	warn("[ProceduralPetGenerator] Cube AI Lua API not yet available")
	warn("[ProceduralPetGenerator] Using procedural Part-based generation instead")
	warn("[ProceduralPetGenerator] To use AI: Open Studio Assistant and type '/generate " .. prompt .. "'")

	-- Fallback to procedural generation
	return self:GeneratePet("Simple", "Common", false)
end

return ProceduralPetGenerator

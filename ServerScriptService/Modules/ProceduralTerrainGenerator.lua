--[[
	ProceduralTerrainGenerator - Generates game maps using Perlin noise
	NO external assets required - Uses Roblox Terrain API

	Based on 2025 best practices from Roblox DevForum
	Generates realistic terrain procedurally for the game world
]]

local ProceduralTerrainGenerator = {}

-- Terrain parameters
local TERRAIN_SIZE = Vector3.new(512, 100, 512) -- World size
local CHUNK_SIZE = 16 -- Process terrain in chunks for performance
local SEED = math.random(1, 1000000) -- Random seed for unique maps

-- Perlin noise implementation (simplified for Roblox)
local function noise2D(x, z, seed)
	-- Simple hash-based noise
	local n = x + z * 57 + seed * 131
	n = bit32.bxor(n, bit32.rshift(n, 13))
	n = (n * (n * n * 15731 + 789221) + 1376312589)
	return (bit32.band(n, 0x7fffffff) / 0x7fffffff) * 2 - 1
end

-- Octave noise for more natural terrain
local function perlinNoise(x, z, seed, octaves, persistence)
	local total = 0
	local frequency = 1
	local amplitude = 1
	local maxValue = 0

	for i = 1, octaves do
		total = total + noise2D(x * frequency, z * frequency, seed) * amplitude
		maxValue = maxValue + amplitude
		amplitude = amplitude * persistence
		frequency = frequency * 2
	end

	return total / maxValue
end

-- Generate terrain heightmap
function ProceduralTerrainGenerator:GenerateHeightmap(sizeX, sizeZ, seed)
	local heightmap = {}

	for x = 1, sizeX do
		heightmap[x] = {}
		for z = 1, sizeZ do
			-- Multi-octave Perlin noise for realistic terrain
			local height = perlinNoise(x / 50, z / 50, seed or SEED, 4, 0.5)

			-- Normalize to 0-1 range
			height = (height + 1) / 2

			-- Scale to terrain height
			heightmap[x][z] = height * 50 -- 0-50 studs height
		end
	end

	return heightmap
end

-- Generate full terrain using Roblox Terrain API
function ProceduralTerrainGenerator:GenerateTerrain(options)
	options = options or {}
	local seed = options.Seed or SEED
	local sizeX = options.SizeX or 256
	local sizeZ = options.SizeZ or 256
	local biome = options.Biome or "Grass" -- Grass, Desert, Snow, etc.

	print("[TerrainGenerator] Generating terrain with seed:", seed)

	-- Clear existing terrain
	if options.ClearExisting then
		workspace.Terrain:Clear()
	end

	-- Generate heightmap
	local heightmap = self:GenerateHeightmap(sizeX, sizeZ, seed)

	-- Material based on biome
	local materials = {
		Grass = {Ground = Enum.Material.Grass, Mountain = Enum.Material.Rock},
		Desert = {Ground = Enum.Material.Sand, Mountain = Enum.Material.Sandstone},
		Snow = {Ground = Enum.Material.Snow, Mountain = Enum.Material.Glacier},
		Volcanic = {Ground = Enum.Material.Basalt, Mountain = Enum.Material.CrackedLava}
	}

	local biomeMaterials = materials[biome] or materials.Grass

	-- Fill terrain in chunks for performance
	for chunkX = 0, math.floor(sizeX / CHUNK_SIZE) do
		for chunkZ = 0, math.floor(sizeZ / CHUNK_SIZE) do

			local region = Region3.new(
				Vector3.new(chunkX * CHUNK_SIZE - sizeX/2, 0, chunkZ * CHUNK_SIZE - sizeZ/2),
				Vector3.new((chunkX + 1) * CHUNK_SIZE - sizeX/2, 100, (chunkZ + 1) * CHUNK_SIZE - sizeZ/2)
			):ExpandToGrid(4)

			local size = region.Size
			local materials = table.create(size.X * size.Y * size.Z)
			local occupancies = table.create(size.X * size.Y * size.Z)

			local index = 1
			for x = 1, size.X do
				for y = 1, size.Y do
					for z = 1, size.Z do
						local worldX = chunkX * CHUNK_SIZE + x
						local worldZ = chunkZ * CHUNK_SIZE + z

						if worldX <= sizeX and worldZ <= sizeZ then
							local height = heightmap[worldX][worldZ]
							local worldY = y

							if worldY <= height then
								-- Choose material based on height
								if height > 35 then
									materials[index] = biomeMaterials.Mountain
								else
									materials[index] = biomeMaterials.Ground
								end
								occupancies[index] = 1
							else
								materials[index] = Enum.Material.Air
								occupancies[index] = 0
							end
						else
							materials[index] = Enum.Material.Air
							occupancies[index] = 0
						end

						index = index + 1
					end
				end
			end

			workspace.Terrain:WriteVoxels(region, 4, materials, occupancies)

			-- Yield to prevent timeout
			if (chunkX + chunkZ) % 4 == 0 then
				task.wait()
			end
		end
	end

	print("[TerrainGenerator] Terrain generation complete!")
	return true
end

-- Generate simple flat arena for Tower Defense
function ProceduralTerrainGenerator:GenerateArena(radius)
	radius = radius or 100

	print("[TerrainGenerator] Generating TD Arena...")

	-- Create flat circular arena
	local region = Region3.new(
		Vector3.new(-radius, -10, -radius),
		Vector3.new(radius, 5, radius)
	):ExpandToGrid(4)

	local size = region.Size
	local materials = table.create(size.X * size.Y * size.Z)
	local occupancies = table.create(size.X * size.Y * size.Z)

	local index = 1
	local center = Vector3.new(0, 0, 0)

	for x = 1, size.X do
		for y = 1, size.Y do
			for z = 1, size.Z do
				local worldPos = region.CFrame.Position + Vector3.new(x - size.X/2, y - size.Y/2, z - size.Z/2) * 4
				local distance = (Vector2.new(worldPos.X, worldPos.Z) - Vector2.new(center.X, center.Z)).Magnitude

				-- Create circular arena
				if distance <= radius and y <= 2 then
					materials[index] = Enum.Material.Concrete
					occupancies[index] = 1
				else
					materials[index] = Enum.Material.Air
					occupancies[index] = 0
				end

				index = index + 1
			end
		end
	end

	workspace.Terrain:WriteVoxels(region, 4, materials, occupancies)

	print("[TerrainGenerator] Arena generation complete!")
	return true
end

-- Generate spawn platform
function ProceduralTerrainGenerator:GenerateSpawnPlatform(position, size)
	position = position or Vector3.new(0, 0, 0)
	size = size or Vector3.new(50, 5, 50)

	local region = Region3.new(
		position - size/2,
		position + size/2
	):ExpandToGrid(4)

	workspace.Terrain:FillBlock(
		region.CFrame,
		region.Size,
		Enum.Material.Grass
	)

	return true
end

return ProceduralTerrainGenerator

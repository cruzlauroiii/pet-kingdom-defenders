--[[
	PetData - Contains all pet definitions, stats, and abilities
	Reference for all available pets in the game

	FREE PET MODELS - How to Get Them:

	Option 1: FREE Pet Packs from Roblox DevForum
	- 300+ Free Simulator Pets: devforum.roblox.com/t/300-free-simulator-pets/692024
	- 100+ Quality Pets: devforum.roblox.com/t/100-good-quality-simulator-pets/426398
	- 28 Pet Pack: devforum.roblox.com/t/free-pet-pack-28-pets/958670

	Option 2: Roblox Toolbox (in Studio)
	- Open Toolbox → Models → Search "pet simulator"
	- Filter by: Free models
	- Insert model → Get MeshId from properties

	Option 3: Use Simple Parts (Current Implementation)
	- PetSystem.lua already creates Part-based pets
	- Works without mesh IDs
	- Just colored spheres/balls

	To Add Mesh Models:
	1. Get model from DevForum or Toolbox
	2. Insert into workspace
	3. Check MeshPart → Properties → MeshId
	4. Copy the asset ID number
	5. Update Model fields below: "rbxassetid://YOUR_ID"
	6. For icons: Use Roblox image editor or keep at 0

	NOTE: Current game works with Part-based pets (balls)
	Mesh IDs are OPTIONAL for enhanced visuals
]]

local PetData = {
	-- BASIC PETS (Common/Uncommon)
	Dog = {
		Name = "Loyal Dog",
		Rarity = "Common",
		BasePower = 10,
		BaseSpeed = 15,
		Ability = "Fetch",
		AbilityDescription = "Automatically collects nearby coins",
		Model = "rbxassetid://0", -- Replace with actual model ID
		Icon = "rbxassetid://0"
	},

	Cat = {
		Name = "Nimble Cat",
		Rarity = "Common",
		BasePower = 8,
		BaseSpeed = 20,
		Ability = "Nine Lives",
		AbilityDescription = "Small chance to dodge enemy attacks",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Bunny = {
		Name = "Hopping Bunny",
		Rarity = "Common",
		BasePower = 6,
		BaseSpeed = 25,
		Ability = "Lucky Hop",
		AbilityDescription = "Increased coin drops",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Hamster = {
		Name = "Tiny Hamster",
		Rarity = "Uncommon",
		BasePower = 12,
		BaseSpeed = 18,
		Ability = "Hoard",
		AbilityDescription = "Bonus passive income",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Bird = {
		Name = "Flying Bird",
		Rarity = "Uncommon",
		BasePower = 14,
		BaseSpeed = 30,
		Ability = "Air Strike",
		AbilityDescription = "Deal damage from above",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	-- GOLDEN PETS (Rare/Epic)
	Lion = {
		Name = "Mighty Lion",
		Rarity = "Rare",
		BasePower = 35,
		BaseSpeed = 20,
		Ability = "Roar",
		AbilityDescription = "Stuns nearby enemies",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Eagle = {
		Name = "Soaring Eagle",
		Rarity = "Rare",
		BasePower = 30,
		BaseSpeed = 40,
		Ability = "Dive Bomb",
		AbilityDescription = "Powerful targeted attack",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Wolf = {
		Name = "Pack Wolf",
		Rarity = "Rare",
		BasePower = 32,
		BaseSpeed = 35,
		Ability = "Pack Hunter",
		AbilityDescription = "Stronger with other pets",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Fox = {
		Name = "Clever Fox",
		Rarity = "Epic",
		BasePower = 45,
		BaseSpeed = 38,
		Ability = "Cunning",
		AbilityDescription = "Double coin chance",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Bear = {
		Name = "Grizzly Bear",
		Rarity = "Epic",
		BasePower = 55,
		BaseSpeed = 25,
		Ability = "Maul",
		AbilityDescription = "Massive damage to single target",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	-- MYSTIC PETS (Epic/Legendary)
	Dragon = {
		Name = "Fire Dragon",
		Rarity = "Epic",
		BasePower = 70,
		BaseSpeed = 45,
		Ability = "Flame Breath",
		AbilityDescription = "Area damage over time",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Phoenix = {
		Name = "Eternal Phoenix",
		Rarity = "Epic",
		BasePower = 65,
		BaseSpeed = 50,
		Ability = "Rebirth",
		AbilityDescription = "Revives once per wave",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Unicorn = {
		Name = "Magical Unicorn",
		Rarity = "Legendary",
		BasePower = 80,
		BaseSpeed = 55,
		Ability = "Healing Light",
		AbilityDescription = "Heals base over time",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Griffin = {
		Name = "Royal Griffin",
		Rarity = "Legendary",
		BasePower = 85,
		BaseSpeed = 60,
		Ability = "Divine Shield",
		AbilityDescription = "Protects base from damage",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	Pegasus = {
		Name = "Sky Pegasus",
		Rarity = "Legendary",
		BasePower = 75,
		BaseSpeed = 70,
		Ability = "Cloud Walk",
		AbilityDescription = "Increases all pet speed",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	-- ULTIMATE PETS (Legendary)
	["Celestial Dragon"] = {
		Name = "Celestial Dragon",
		Rarity = "Legendary",
		BasePower = 150,
		BaseSpeed = 80,
		Ability = "Cosmic Fire",
		AbilityDescription = "Massive area damage",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	["Divine Phoenix"] = {
		Name = "Divine Phoenix",
		Rarity = "Legendary",
		BasePower = 140,
		BaseSpeed = 90,
		Ability = "Infinite Rebirth",
		AbilityDescription = "Multiple revivals per wave",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	["Rainbow Unicorn"] = {
		Name = "Rainbow Unicorn",
		Rarity = "Legendary",
		BasePower = 160,
		BaseSpeed = 85,
		Ability = "Rainbow Blessing",
		AbilityDescription = "All rewards multiplied",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	["Golden Griffin"] = {
		Name = "Golden Griffin",
		Rarity = "Legendary",
		BasePower = 170,
		BaseSpeed = 95,
		Ability = "Golden Aura",
		AbilityDescription = "Massive coin generation",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	},

	["Crystal Pegasus"] = {
		Name = "Crystal Pegasus",
		Rarity = "Legendary",
		BasePower = 155,
		BaseSpeed = 100,
		Ability = "Crystal Storm",
		AbilityDescription = "Freezes and damages all enemies",
		Model = "rbxassetid://0",
		Icon = "rbxassetid://0"
	}
}

return PetData

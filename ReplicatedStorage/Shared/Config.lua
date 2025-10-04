--[[
	Config - Central configuration file for game balance and settings
	All game constants, formulas, and configuration data
]]

local Config = {}

-- Player Progression
Config.LEVEL_EXPERIENCE_FORMULA = function(level)
	return 100 * level * (level + 1) / 2
end

Config.MAX_EQUIPPED_PETS = 3

-- Currency & Economy
Config.STARTING_COINS = 1000
Config.STARTING_GEMS = 50

-- Eggs (Pet Hatching)
Config.EGGS = {
	Basic = {
		Name = "Basic Egg",
		Cost = 500,
		CostType = "Coins",
		PetPool = {"Dog", "Cat", "Bunny", "Hamster", "Bird"}
	},
	Golden = {
		Name = "Golden Egg",
		Cost = 2500,
		CostType = "Coins",
		PetPool = {"Lion", "Eagle", "Wolf", "Fox", "Bear"}
	},
	Mystic = {
		Name = "Mystic Egg",
		Cost = 100,
		CostType = "Gems",
		PetPool = {"Dragon", "Phoenix", "Unicorn", "Griffin", "Pegasus"}
	},
	Legendary = {
		Name = "Legendary Egg",
		Cost = 500,
		CostType = "Gems",
		PetPool = {"Celestial Dragon", "Divine Phoenix", "Rainbow Unicorn", "Golden Griffin", "Crystal Pegasus"}
	}
}

-- Buildings (Tycoon)
Config.BUILDINGS = {
	Spawner1 = {
		Name = "Basic Pet Spawner",
		Cost = 1000,
		IncomePerSecond = 10,
		Prerequisites = {},
		Offset = Vector3.new(-10, 0, -10)
	},
	Collector1 = {
		Name = "Coin Collector",
		Cost = 2500,
		IncomePerSecond = 25,
		Prerequisites = {"Spawner1"},
		Offset = Vector3.new(-10, 0, 0)
	},
	Upgrader1 = {
		Name = "Pet Upgrader",
		Cost = 5000,
		IncomePerSecond = 50,
		Prerequisites = {"Collector1"},
		Offset = Vector3.new(-10, 0, 10)
	},
	Spawner2 = {
		Name = "Advanced Pet Spawner",
		Cost = 10000,
		IncomePerSecond = 100,
		Prerequisites = {"Upgrader1"},
		Offset = Vector3.new(0, 0, -10)
	},
	Collector2 = {
		Name = "Gem Collector",
		Cost = 25000,
		IncomePerSecond = 200,
		Prerequisites = {"Spawner2"},
		Offset = Vector3.new(0, 0, 0)
	},
	Upgrader2 = {
		Name = "Super Upgrader",
		Cost = 50000,
		IncomePerSecond = 500,
		Prerequisites = {"Collector2"},
		Offset = Vector3.new(0, 0, 10)
	},
	Factory = {
		Name = "Pet Factory",
		Cost = 100000,
		IncomePerSecond = 1000,
		Prerequisites = {"Upgrader2"},
		Offset = Vector3.new(10, 0, 0)
	}
}

-- Tower Defense
Config.TD_BASE_HEALTH = 100
Config.TD_BASE_ENEMIES = 10
Config.TD_BASE_ENEMY_HEALTH = 50
Config.TD_ENEMY_SPEED = 5
Config.TD_BASE_REWARD = 50
Config.TD_PATH_LENGTH = 100

-- Obbies (Parkour Courses)
Config.OBBIES = {
	Easy1 = {
		Name = "Beginner's Course",
		RequiredLevel = 1,
		RewardCoins = 200,
		ExperienceReward = 50,
		ParTime = 30,
		Checkpoints = 5
	},
	Easy2 = {
		Name = "Jumping Practice",
		RequiredLevel = 3,
		RewardCoins = 350,
		ExperienceReward = 75,
		ParTime = 45,
		Checkpoints = 7
	},
	Medium1 = {
		Name = "Speed Runner",
		RequiredLevel = 5,
		RewardCoins = 500,
		ExperienceReward = 100,
		ParTime = 60,
		Checkpoints = 10
	},
	Medium2 = {
		Name = "Precision Platformer",
		RequiredLevel = 8,
		RewardCoins = 750,
		ExperienceReward = 150,
		ParTime = 90,
		Checkpoints = 12
	},
	Hard1 = {
		Name = "Expert Challenge",
		RequiredLevel = 12,
		RewardCoins = 1200,
		ExperienceReward = 250,
		ParTime = 120,
		Checkpoints = 15
	},
	Hard2 = {
		Name = "Master Course",
		RequiredLevel = 15,
		RewardCoins = 2000,
		ExperienceReward = 400,
		ParTime = 180,
		Checkpoints = 20
	},
	Extreme = {
		Name = "Impossible Tower",
		RequiredLevel = 20,
		RewardCoins = 5000,
		ExperienceReward = 1000,
		ParTime = 300,
		Checkpoints = 30
	}
}

-- Trading
Config.MAX_TRADE_ITEMS = 4

-- Shop Products (DevProducts for Robux purchases)
-- HOW TO CREATE DEVELOPER PRODUCTS:
-- 1. Go to: create.roblox.com
-- 2. Select your game → Monetization → Developer Products
-- 3. Click "Create a Developer Product"
-- 4. Upload icon (512x512 max), enter name, description
-- 5. Set price in Robux (minimum 1, maximum 1,000,000,000)
-- 6. Copy the Product ID from the URL or product page
-- 7. Replace the placeholder IDs below with your real Product IDs
--
-- RECOMMENDED PRODUCTS (based on 2025 best practices):
-- - Gem Packs: Best sellers, 100/500/1000 gems
-- - Coin Packs: For players who want quick progress
-- - Bundles: Better value, increases ARPPU
-- - All items are consumable (can be purchased repeatedly)
--
-- PRICING STRATEGY (2025):
-- - Lower prices = more purchases (1-3% conversion typical)
-- - Bundles = 20-30% more value than individual
-- - Never exceed ~$50 USD (~5000 Robux) per item
-- - Fair pricing increases player lifetime value

Config.SHOP_PRODUCTS = {
	-- Replace these placeholder IDs with your actual Developer Product IDs
	[0000000001] = { -- REPLACE with real Product ID from Creator Dashboard
		Name = "100 Gems",
		Type = "Gems",
		Amount = 100,
		Price = 100 -- Robux (approx $1 USD)
	},
	[0000000002] = { -- REPLACE with real Product ID
		Name = "500 Gems",
		Type = "Gems",
		Amount = 500,
		Price = 400 -- Robux (approx $4 USD) - 20% bonus value
	},
	[0000000003] = { -- REPLACE with real Product ID
		Name = "1000 Gems",
		Type = "Gems",
		Amount = 1000,
		Price = 700 -- Robux (approx $7 USD) - 30% bonus value
	},
	[0000000004] = { -- REPLACE with real Product ID
		Name = "50,000 Coins",
		Type = "Coins",
		Amount = 50000,
		Price = 200 -- Robux (approx $2 USD)
	},
	[0000000005] = { -- REPLACE with real Product ID
		Name = "Starter Bundle",
		Type = "Bundle",
		Gems = 250,
		Coins = 25000,
		Price = 300 -- Robux (approx $3 USD) - Best value for new players
	}
}

-- NOTE: EconomyManager.lua handles the ProcessReceipt callback
-- Test purchases in Studio with "Enable Studio Access to API Services" enabled
-- After creating DevProducts, they appear in game within ~5 minutes

-- Events
Config.EVENTS = {
	DoubleCoins = {
		Name = "Double Coins Weekend",
		Type = "Weekend",
		Multipliers = {
			Coins = 2
		},
		Rewards = {}
	},
	SummerEvent = {
		Name = "Summer Festival",
		Type = "Seasonal",
		Month = 7,
		Multipliers = {
			Experience = 1.5,
			Coins = 1.25
		},
		Rewards = {
			{
				Id = "summer_pet",
				Type = "Pet",
				Name = "Beach Dragon",
				RequiredProgress = 100
			}
		}
	},
	WinterEvent = {
		Name = "Winter Wonderland",
		Type = "Seasonal",
		Month = 12,
		Multipliers = {
			PetHatchRate = 1.5,
			Coins = 1.5
		},
		Rewards = {
			{
				Id = "winter_pet",
				Type = "Pet",
				Name = "Snow Phoenix",
				RequiredProgress = 100
			}
		}
	}
}

-- Achievements
Config.ACHIEVEMENTS = {
	FirstPet = {
		Name = "First Friend",
		Description = "Hatch your first pet",
		CoinsReward = 500,
		GemsReward = 10
	},
	PetCollector10 = {
		Name = "Pet Collector",
		Description = "Hatch 10 pets",
		CoinsReward = 2000,
		GemsReward = 25
	},
	PetCollector50 = {
		Name = "Pet Master",
		Description = "Hatch 50 pets",
		CoinsReward = 10000,
		GemsReward = 100
	},
	Wave10 = {
		Name = "Defender",
		Description = "Complete wave 10",
		CoinsReward = 2500,
		GemsReward = 25
	},
	Wave50 = {
		Name = "Elite Defender",
		Description = "Complete wave 50",
		CoinsReward = 25000,
		GemsReward = 250
	},
	FirstTrade = {
		Name = "Trader",
		Description = "Complete your first trade",
		CoinsReward = 1000,
		GemsReward = 20
	},
	ObbyMaster = {
		Name = "Parkour Pro",
		Description = "Complete all obbies",
		CoinsReward = 50000,
		GemsReward = 500
	}
}

-- UI Settings
Config.UI_ANIMATION_SPEED = 0.3
Config.NOTIFICATION_DURATION = 3

return Config

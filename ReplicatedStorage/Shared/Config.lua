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
Config.SHOP_PRODUCTS = {
	[1234567] = {
		Name = "100 Gems",
		Type = "Gems",
		Amount = 100,
		Price = 100 -- Robux
	},
	[1234568] = {
		Name = "500 Gems",
		Type = "Gems",
		Amount = 500,
		Price = 400
	},
	[1234569] = {
		Name = "1000 Gems",
		Type = "Gems",
		Amount = 1000,
		Price = 700
	},
	[1234570] = {
		Name = "50,000 Coins",
		Type = "Coins",
		Amount = 50000,
		Price = 200
	},
	[1234571] = {
		Name = "Starter Bundle",
		Type = "Bundle",
		Gems = 250,
		Coins = 25000,
		Price = 300
	}
}

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

# Config.lua

## Overview
Central configuration file containing all game balance constants, formulas, and settings. Single source of truth for game tuning.

## Purpose
- Define progression formulas
- Configure economy balance
- Set building/egg costs
- Define event parameters
- Configure achievement rewards

## Key Sections

### Player Progression
```lua
LEVEL_EXPERIENCE_FORMULA(level)
  Returns: 100 * level * (level + 1) / 2

MAX_EQUIPPED_PETS = 3
STARTING_COINS = 1000
STARTING_GEMS = 50
```

### Eggs
4 egg types with different costs and pet pools:
- **Basic**: 500 coins (Dog, Cat, Bunny, Hamster, Bird)
- **Golden**: 2500 coins (Lion, Eagle, Wolf, Fox, Bear)
- **Mystic**: 100 gems (Dragon, Phoenix, Unicorn, Griffin, Pegasus)
- **Legendary**: 500 gems (Celestial variants)

### Buildings (Tycoon)
7 progressive buildings:
1. Basic Pet Spawner - 1K coins, 10/sec
2. Coin Collector - 2.5K coins, 25/sec
3. Pet Upgrader - 5K coins, 50/sec
4. Advanced Pet Spawner - 10K coins, 100/sec
5. Gem Collector - 25K coins, 200/sec
6. Super Upgrader - 50K coins, 500/sec
7. Pet Factory - 100K coins, 1000/sec

Each has:
- Cost (coins)
- IncomePerSecond
- Prerequisites (unlock order)
- Offset (position)

### Tower Defense
```lua
TD_BASE_HEALTH = 100
TD_BASE_ENEMIES = 10
TD_BASE_ENEMY_HEALTH = 50
TD_ENEMY_SPEED = 5
TD_BASE_REWARD = 50
TD_PATH_LENGTH = 100
```

### Obbies
7 difficulty tiers from Easy1 to Extreme:
- RequiredLevel
- RewardCoins
- ExperienceReward
- ParTime (target time)
- Checkpoints

### Trading
```lua
MAX_TRADE_ITEMS = 4
```

### Shop Products (DevProducts)
Maps product IDs to rewards:
- Gem packs (100, 500, 1000)
- Coin packs (50K)
- Bundles (gems + coins)

### Events
Predefined events:
- **Double Coins Weekend**: 2x coins
- **Summer Festival**: 1.5x XP, 1.25x coins, special pet
- **Winter Wonderland**: 1.5x hatch rate, 1.5x coins, special pet

### Achievements
Reward tiers for:
- Pet collection (First, 10, 50)
- Tower defense (Wave 10, 50)
- Trading (First trade)
- Obbies (Complete all)

Each awards coins and gems.

### UI Settings
```lua
UI_ANIMATION_SPEED = 0.3
NOTIFICATION_DURATION = 3
```

## Balance Philosophy
- **Early Game**: Quick rewards, low barriers
- **Mid Game**: Meaningful choices, pet variety
- **Late Game**: Prestige mechanics, competitive goals
- **Monetization**: Fair, non-pay-to-win
- **Retention**: Daily bonuses, events, progression

## Tuning Guide
To adjust difficulty:
1. **Easier**: Increase coin rewards, decrease costs
2. **Harder**: Increase enemy health, decrease income
3. **Faster**: Reduce par times, increase XP
4. **Slower**: Increase level requirements, reduce multipliers

## Usage
```lua
local Config = require(ReplicatedStorage.Shared.Config)
local expNeeded = Config.LEVEL_EXPERIENCE_FORMULA(playerLevel)
local eggData = Config.EGGS["Mystic"]
```

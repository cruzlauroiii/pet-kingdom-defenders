# EconomyManager.lua

## Overview
Manages the in-game economy including currency, daily bonuses, achievements, and Robux monetization.

## Purpose
- Handle daily login bonuses with streaks
- Process Robux purchases (DevProducts)
- Award achievement rewards
- Manage economy balance

## Currency Types
- **Coins**: Primary currency (free-to-play)
- **Gems**: Premium currency (Robux or earned)

## Daily Bonus System

### Login Streak Rewards
```lua
coinsReward = 500 * streakBonus (max 7 days)
gemsReward = floor(streakBonus / 2)
```

### Streak Logic
- Same day: No change
- Next day (24h): Streak +1
- Missed days (>24h): Reset to 1

## Key Functions

### `Initialize()`
- Sets up remote events
- Configures MarketplaceService receipt processing

### `SetupPlayerEconomy(player, playerData)`
- Sends initial currency state to client

### `CheckDailyBonus(player)`
Called on player join:
- Calculates time since last login
- Awards daily bonus if eligible (24h+)
- Notifies client of streak rewards

### `ClaimDailyBonus(player)`
Manual claim by player:
- Validates 24h cooldown
- Awards streak-based rewards
- Updates last claim time

### `ProcessReceipt(receiptInfo): PurchaseDecision`
Handles Robux purchases:
- Validates product ID
- Awards gems/coins/bundles
- Returns PurchaseGranted or NotProcessedYet
- Prevents duplicate purchases

### `AwardAchievement(player, achievementId)`
- Checks if already claimed
- Awards coin/gem rewards
- Marks achievement complete
- Notifies client with popup

## Shop Products (DevProducts)
```lua
{
    [productId] = {
        Name = string,
        Type = "Gems"|"Coins"|"Bundle",
        Amount = number,
        Price = number (Robux)
    }
}
```

## Achievement Rewards
Defined in Config.ACHIEVEMENTS:
- First Pet: 500 coins, 10 gems
- Pet Collector (10): 2K coins, 25 gems
- Pet Master (50): 10K coins, 100 gems
- Defender (Wave 10): 2.5K coins, 25 gems
- Elite Defender (Wave 50): 25K coins, 250 gems
- Trader (First): 1K coins, 20 gems
- Parkour Pro (All obbies): 50K coins, 500 gems

## Monetization Strategy
- **Gems** are primary monetization
- **Bundles** provide better value
- **Login rewards** encourage daily play
- **Achievements** reward long-term engagement
- Fair free-to-play progression maintained

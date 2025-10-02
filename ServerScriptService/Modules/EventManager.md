# EventManager.lua

## Overview
Manages seasonal events, limited-time content, and special rewards to keep the game fresh and engaging.

## Purpose
- Activate/deactivate events based on date/time
- Apply event multipliers to rewards
- Manage seasonal visual changes
- Award special event rewards

## Event Types
1. **Seasonal**: Month-based (Summer, Winter, etc.)
2. **Weekend**: Saturday/Sunday only
3. **Special**: Custom date range

## Event Structure
```lua
{
    Id = string,
    Name = string,
    StartTime = number,
    EndTime = number,
    Rewards = {Reward[]},
    Multipliers = {
        Coins = number,
        Experience = number,
        PetHatchRate = number
    }
}
```

## Seasonal System
Auto-detects season by month:
- **Spring**: March-May
- **Summer**: June-August
- **Autumn**: September-November
- **Winter**: December-February

## Key Functions

### `Initialize()`
- Checks for active events
- Starts hourly event check loop
- Sets up remote events

### `CheckEvents()`
Runs every hour:
- Removes expired events
- Checks for new events to activate
- Updates current season
- Validates event conditions

### `StartEvent(eventId, eventConfig)`
- Creates active event data
- Applies multipliers
- Notifies all players
- Shows event banner

### `EndEvent(eventId)`
- Removes event data
- Notifies all players
- Removes event effects

### `UpdateSeason(month)`
- Determines current season
- Changes lighting/atmosphere
- Applies seasonal decorations
- Notifies clients

### `ApplySeasonalChanges(season)`
Changes game atmosphere:
- **Winter**: Blue-white ambient (200, 220, 255)
- **Spring**: Warm yellow (255, 240, 220)
- **Summer**: Bright yellow (255, 250, 200)
- **Autumn**: Orange-red (255, 200, 150)

### `ClaimEventReward(player, eventId, rewardId)`
- Validates event is active
- Checks requirements met
- Prevents duplicate claims
- Awards reward
- Marks as claimed

### `GetMultipliers(): multipliers`
Combines all active event multipliers:
```lua
{
    Coins = number,
    Experience = number,
    PetHatchRate = number
}
```

## Event Examples

### Double Coins Weekend
```lua
{
    Type = "Weekend",
    Multipliers = { Coins = 2 }
}
```

### Summer Festival
```lua
{
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
}
```

### Winter Wonderland
```lua
{
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
```

## Event Progression
Players earn progress through:
- Playing during event
- Completing event objectives
- Defeating enemies
- Hatching pets

Progress unlocks event rewards.

## Update Frequency
- **Event Check**: Every 1 hour
- **Season Check**: On month change
- **Player Notification**: Real-time on activation

# ObbyManager.lua

## Overview
Manages parkour obstacle courses (obbies) that players complete to train pets and earn rewards.

## Purpose
- Track obby runs and completion times
- Validate checkpoint progression
- Award rewards based on performance
- Train equipped pets through completion

## Obby Run Structure
```lua
{
    ObbyId = string,
    StartTime = number,
    Checkpoints = {
        {
            Number = number,
            Time = number
        }
    },
    CurrentCheckpoint = number
}
```

## Obby Configuration
Each obby has:
- **Name**: Display name
- **RequiredLevel**: Minimum player level
- **RewardCoins**: Base coin reward
- **ExperienceReward**: XP awarded
- **ParTime**: Target completion time
- **Checkpoints**: Number of checkpoints

## Key Functions

### `Initialize()`
Sets up remote events for obby gameplay.

### `StartObby(player, obbyId)`
- Validates obby exists
- Checks player level requirement
- Initializes run tracking
- Records start time
- Notifies client

### `CheckpointReached(player, checkpointNumber)`
- Validates sequential checkpoint order
- Records checkpoint time
- Updates current checkpoint
- Notifies client

### `CompleteObby(player, obbyId)`
Completion handler:
- Validates active run
- Calculates completion time
- Checks for new personal best
- Awards base rewards
- Calculates time bonus (50% extra if beat par time)
- Awards total rewards
- Trains equipped pets (+0.01 power)
- Sends completion data to client
- Cleans up run

### `GetLeaderboard(obbyId): leaderboard`
Returns top times for an obby (production implementation needed).

## Reward System

### Base Rewards
- Coins: Defined per obby
- Experience: Defined per obby

### Time Bonus
If completion time < par time:
```lua
timeBonus = floor(baseReward * 0.5)
```

### Pet Training
All equipped pets receive:
- PowerMultiplier +0.01 per completion
- Encourages active pet training

## Difficulty Progression
Obbies increase in difficulty:
1. **Easy1** - Beginner's Course (Lvl 1, 200 coins, 30s par)
2. **Easy2** - Jumping Practice (Lvl 3, 350 coins, 45s par)
3. **Medium1** - Speed Runner (Lvl 5, 500 coins, 60s par)
4. **Medium2** - Precision Platformer (Lvl 8, 750 coins, 90s par)
5. **Hard1** - Expert Challenge (Lvl 12, 1200 coins, 120s par)
6. **Hard2** - Master Course (Lvl 15, 2000 coins, 180s par)
7. **Extreme** - Impossible Tower (Lvl 20, 5000 coins, 300s par)

## Checkpoint Validation
- **Sequential Only**: Must reach checkpoints in order
- **Anti-Cheat**: Prevents checkpoint skipping
- **Time Tracking**: Records time at each checkpoint

## Best Time Tracking
```lua
playerData.BestObbyTimes[obbyId] = completionTime
```
- Personal best per obby
- Can be used for leaderboards
- Achievement progress tracking

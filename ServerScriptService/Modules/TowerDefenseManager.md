# TowerDefenseManager.lua

## Overview
Manages wave-based tower defense gameplay where players use their pets to defend against enemy waves.

## Purpose
- Spawn and manage enemy waves
- Handle pet tower placement
- Process enemy-tower interactions
- Award wave completion rewards

## Game State Structure
```lua
{
    CurrentWave = number,
    Health = number,            -- Base health
    PlacedTowers = {Tower[]},
    ActiveEnemies = {Enemy[]},
    IsWaveActive = boolean
}
```

## Tower Structure
```lua
{
    PetId = string,
    Position = number,
    Damage = number,            -- Based on pet stats
    Range = number,
    AttackCooldown = number,
    LastAttack = number
}
```

## Enemy Structure
```lua
{
    Id = string,
    Health = number,
    MaxHealth = number,
    Speed = number,
    Reward = number,
    Position = number           -- Path position
}
```

## Key Functions

### `Initialize()`
Sets up remote events and initializes tower defense system.

### `StartWave(player)`
- Initializes game state if needed
- Increments wave number
- Spawns wave enemies
- Notifies client

### `SpawnWaveEnemies(player, waveNumber)`
Spawns enemies with scaling difficulty:
- Enemy count: BASE + (wave * 2)
- Enemy health: BASE * (1 + wave * 0.2)
- Enemy reward: BASE * wave

### `MoveEnemy(player, enemy)`
Continuous loop that:
- Moves enemy along path
- Checks tower attacks in range
- Damages base if enemy reaches end
- Handles enemy death

### `EnemyDefeated(player, enemy)`
- Awards coins and experience
- Updates statistics
- Removes enemy
- Checks wave completion

### `CheckWaveComplete(player)`
- Verifies all enemies defeated
- Awards wave completion bonus
- Updates highest wave record
- Notifies client

### `PlaceTower(player, petId, position)`
- Validates pet ownership
- Creates tower from pet stats
- Places in game world
- Applies pet power multipliers

### `GameOver(player, victory)`
- Stops wave
- Clears enemies
- Sends results to client

## Difficulty Scaling
Each wave increases:
- **Enemy Count**: +2 per wave
- **Enemy Health**: +20% per wave
- **Enemy Reward**: Scales with wave number

## Tower Stats Calculation
```lua
Damage = 10 * pet.PowerMultiplier * pet.Level
Range = 20 (default)
AttackCooldown = 1 second
```

## Wave Completion Rewards
- Bonus coins: wave * 100
- Experience based on enemies defeated
- Progress toward achievements

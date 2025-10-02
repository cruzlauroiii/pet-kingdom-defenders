# TycoonManager.lua

## Overview
Manages player-owned base building with automated income generation. Players purchase buildings that generate passive coins.

## Purpose
- Manage player base construction
- Generate passive income
- Handle building prerequisites
- Spawn building models in world

## Base Structure
```lua
{
    Buildings = {buildingId[]},
    PendingIncome = number,
    LastIncomeTime = number
}
```

## Building Configuration
Each building has:
- **Name**: Display name
- **Cost**: Coin cost to purchase
- **IncomePerSecond**: Passive income rate
- **Prerequisites**: Required buildings
- **Offset**: Position relative to base plot

## Key Functions

### `Initialize()`
- Sets up remote events
- Starts income generation loop (5-second intervals)

### `SetupPlayerBase(player, playerData)`
- Initializes base data
- Spawns base plot
- Places owned buildings

### `CleanupPlayerBase(player)`
- Removes base from world
- Clears data

### `SpawnBase(player)`
- Creates 50x50 base plot
- Positions based on userId (unique location per player)
- Spawns all owned buildings

### `DespawnBase(player)`
- Removes base plot and buildings

### `SpawnBuilding(player, buildingId)`
- Creates building model (simplified as colored part)
- Positions based on offset from config
- Anchors in place

### `PurchaseBuilding(player, buildingId)`
- Validates prerequisites
- Checks coin balance
- Deducts cost
- Adds building
- Spawns in world
- Increases tycoon level

### `IncomeGenerationLoop()`
Runs every 5 seconds:
- Calculates income from all buildings
- Adds to pending income
- Notifies player of accumulation

### `CalculateIncome(player): income`
Sums income from all owned buildings:
```lua
totalIncome = Σ(building.IncomePerSecond * 5)
```

### `CollectIncome(player)`
- Transfers pending income to player coins
- Resets pending income
- Notifies client

## Building Progression
Buildings unlock in sequence:
1. Basic Pet Spawner (1K coins, 10/sec)
2. Coin Collector (2.5K coins, 25/sec)
3. Pet Upgrader (5K coins, 50/sec)
4. Advanced Pet Spawner (10K coins, 100/sec)
5. Gem Collector (25K coins, 200/sec)
6. Super Upgrader (50K coins, 500/sec)
7. Pet Factory (100K coins, 1000/sec)

## Income System
- **Interval**: Every 5 seconds
- **Storage**: Accumulates in PendingIncome
- **Collection**: Manual (prevents AFK farming)
- **Scaling**: Later buildings provide exponentially more income

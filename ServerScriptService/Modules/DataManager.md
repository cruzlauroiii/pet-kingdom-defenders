# DataManager.lua

## Overview
Manages all player data storage, retrieval, and persistence using Roblox DataStore2. Handles player progression, currency, pets, and statistics.

## Purpose
- Load and save player data to/from DataStores
- Manage in-memory data cache
- Handle currency transactions
- Track player statistics and progression

## Data Structure
```lua
{
    -- Currency
    Coins = number,
    Gems = number,

    -- Pets
    Pets = {Pet[]},
    EquippedPets = {petId[]},

    -- Progression
    Level = number,
    Experience = number,
    TotalPlayTime = number,

    -- Tycoon
    TycoonLevel = number,
    UnlockedBuildings = {buildingId[]},

    -- Tower Defense
    HighestWave = number,
    TotalEnemiesDefeated = number,

    -- Obby
    CompletedObbies = {obbyId[]},
    BestObbyTimes = {[obbyId] = time},

    -- Statistics
    TotalPetsHatched = number,
    TotalTradesCompleted = number,
    LoginStreak = number,
    LastLogin = number,

    -- Settings
    Settings = {
        MusicEnabled = boolean,
        SFXEnabled = boolean,
        ParticlesEnabled = boolean,
        MobileMode = boolean
    }
}
```

## Key Functions

### `Initialize()`
Sets up DataStore connections and initializes the data system.

### `LoadPlayerData(player): (success, playerData)`
Loads player data from DataStore or creates new default data.

### `SavePlayerData(player): success`
Saves player data to DataStore with backup.

### `GetData(player): playerData`
Retrieves cached player data.

### `UpdateData(player, key, value): success`
Updates a specific field in player data.

### `AddCurrency(player, currencyType, amount): success`
Adds currency and updates client display.

### `RemoveCurrency(player, currencyType, amount): success`
Removes currency if player has enough.

### `AddExperience(player, amount): success`
Adds experience and handles level ups with rewards.

## DataStore Structure
- **Primary DataStore**: `PlayerData_V1`
- **Backup DataStore**: `PlayerDataBackup_V1`
- **Key Format**: `Player_{userId}`

## Security
- Validates all data changes
- Prevents negative currency
- Backup system for data recovery
- Graceful offline mode fallback

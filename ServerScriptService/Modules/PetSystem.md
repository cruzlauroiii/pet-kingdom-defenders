# PetSystem.lua

## Overview
Manages the pet collection system including hatching, evolution, equipping, and pet behavior. Core feature combining collection and progression mechanics.

## Purpose
- Handle egg hatching with weighted rarity system
- Manage equipped pets that follow the player
- Control pet evolution and power upgrades
- Spawn and animate pets in the game world

## Pet Rarity System
Weighted random selection:
- **Common**: 50% chance
- **Uncommon**: 30% chance
- **Rare**: 15% chance
- **Epic**: 4% chance
- **Legendary**: 1% chance

## Pet Data Structure
```lua
{
    Id = string,              -- Unique GUID
    Name = string,            -- Pet name from PetData
    Rarity = string,          -- Common/Uncommon/Rare/Epic/Legendary
    Level = number,           -- Pet level
    Experience = number,      -- Pet XP
    PowerMultiplier = number, -- Damage/power multiplier
    Shiny = boolean,          -- 0.1% shiny chance
    HatchTime = number        -- Unix timestamp
}
```

## Key Functions

### `Initialize()`
Sets up remote event listeners for pet actions.

### `SetupPlayer(player, playerData)`
Initializes player's pet system and spawns equipped pets.

### `HatchEgg(player, eggType): pet`
- Validates currency
- Determines rarity
- Selects random pet from egg pool
- Creates new pet instance
- Awards to player

### `EquipPet(player, petId)`
- Validates pet ownership
- Checks max equipped limit (3 pets)
- Adds to equipped list
- Spawns pet in world

### `UnequipPet(player, petId)`
- Removes from equipped list
- Despawns pet model

### `SpawnPet(player, petId)`
- Creates pet model (ball shape for now)
- Adds floating physics (BodyPosition, BodyGyro)
- Starts follow behavior loop
- Shiny pets appear golden

### `DespawnPet(player, petId)`
- Destroys pet model
- Cleans up references

### `PetFollowLoop(player, petId)`
Continuous loop that makes pets:
- Orbit around player
- Float with sine wave motion
- Face toward player
- Maintain spacing when multiple pets equipped

### `EvolvePet(player, petId)`
- Checks evolution cost (based on current power)
- Increases PowerMultiplier by 0.1
- Deducts coins

## Pet Abilities
Pet abilities are defined in PetData.lua and affect:
- Tower defense power
- Coin generation
- Special effects
- Team bonuses

## Visual Effects
- Shiny pets: Golden color
- Floating animation: Sine wave motion
- Orbital following: Circular pattern around player
- Smooth rotation: Always faces player

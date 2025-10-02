# PetData.lua

## Overview
Complete pet database containing all pet definitions, stats, abilities, and metadata. Reference for the collection system.

## Purpose
- Define all available pets
- Specify rarity tiers
- Set base stats and scaling
- Describe unique abilities
- Link to visual assets

## Pet Structure
```lua
{
    Name = string,              -- Display name
    Rarity = string,            -- Common|Uncommon|Rare|Epic|Legendary
    BasePower = number,         -- Base damage/power stat
    BaseSpeed = number,         -- Movement/attack speed
    Ability = string,           -- Ability name
    AbilityDescription = string,-- What the ability does
    Model = string,             -- Asset ID for 3D model
    Icon = string               -- Asset ID for UI icon
}
```

## Pet Categories

### Basic Pets (Common/Uncommon)
Found in Basic Egg:
- **Dog** (Common): Fetch ability, auto-collect coins
- **Cat** (Common): Nine Lives, dodge chance
- **Bunny** (Common): Lucky Hop, increased coin drops
- **Hamster** (Uncommon): Hoard, bonus passive income
- **Bird** (Uncommon): Air Strike, aerial damage

### Golden Pets (Rare/Epic)
Found in Golden Egg:
- **Lion** (Rare): Roar, stuns enemies
- **Eagle** (Rare): Dive Bomb, targeted attack
- **Wolf** (Rare): Pack Hunter, team synergy
- **Fox** (Epic): Cunning, double coin chance
- **Bear** (Epic): Maul, massive single-target damage

### Mystic Pets (Epic/Legendary)
Found in Mystic Egg:
- **Dragon** (Epic): Flame Breath, DoT area damage
- **Phoenix** (Epic): Rebirth, revive once per wave
- **Unicorn** (Legendary): Healing Light, heals base
- **Griffin** (Legendary): Divine Shield, damage protection
- **Pegasus** (Legendary): Cloud Walk, speed buff

### Ultimate Pets (Legendary)
Found in Legendary Egg:
- **Celestial Dragon**: Cosmic Fire, massive area damage
- **Divine Phoenix**: Infinite Rebirth, multiple revivals
- **Rainbow Unicorn**: Rainbow Blessing, reward multiplier
- **Golden Griffin**: Golden Aura, coin generation
- **Crystal Pegasus**: Crystal Storm, freeze + damage

## Power Scaling
Base power ranges:
- **Common**: 6-10
- **Uncommon**: 12-14
- **Rare**: 30-35
- **Epic**: 45-70
- **Legendary**: 75-170

## Speed Scaling
Base speed ranges:
- **Slow**: 15-25 (Tank pets)
- **Medium**: 30-45 (Balanced)
- **Fast**: 50-70 (DPS pets)
- **Ultra**: 80-100 (Ultimate pets)

## Ability Types

### Economic Abilities
- Auto-collect coins (Dog)
- Bonus income (Hamster)
- Double coin chance (Fox)
- Reward multiplier (Rainbow Unicorn)
- Coin generation (Golden Griffin)

### Combat Abilities
- Stun enemies (Lion)
- Area damage (Dragon, Celestial Dragon)
- Single-target burst (Bear)
- Aerial attacks (Bird, Eagle)
- Freeze effects (Crystal Pegasus)

### Support Abilities
- Healing (Unicorn)
- Damage reduction (Griffin)
- Revival (Phoenix, Divine Phoenix)
- Speed buffs (Pegasus)
- Team synergy (Wolf)

## Rarity Distribution
In hatching:
- Common: 50% chance
- Uncommon: 30% chance
- Rare: 15% chance
- Epic: 4% chance
- Legendary: 1% chance

Plus 0.1% shiny chance for any pet.

## Asset Integration
Replace placeholder asset IDs:
```lua
Model = "rbxassetid://123456"  -- 3D model
Icon = "rbxassetid://789012"   -- UI icon
```

## Balancing Considerations
- Higher rarity = Higher power
- Speed vs Power tradeoff
- Unique abilities for variety
- No strictly "best" pet
- Synergies encourage collecting

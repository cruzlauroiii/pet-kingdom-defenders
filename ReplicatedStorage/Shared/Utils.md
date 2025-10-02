# Utils.lua

## Overview
Shared utility functions used across both client and server code. Provides common helpers for formatting, math, and visual effects.

## Purpose
- Number/time formatting for UI
- Math utilities (lerp, clamp, distance)
- Color utilities (rarity colors)
- Table operations (deep copy, shuffle)
- Visual effects (floating text, sounds)
- Mobile support (vibration)

## Number Formatting

### `FormatNumber(num): string`
Abbreviates large numbers:
- 1,000 → "1.0K"
- 1,000,000 → "1.0M"
- 1,000,000,000 → "1.0B"

### `FormatTime(seconds): string`
Formats as MM:SS:
- 125 → "02:05"

### `FormatTimeHours(seconds): string`
Formats as HH:MM:SS:
- 3665 → "01:01:05"

## Math Utilities

### `Lerp(a, b, t): number`
Linear interpolation between a and b:
```lua
result = a + (b - a) * t
```

### `Clamp(value, min, max): number`
Restricts value to range:
```lua
return math.max(min, math.min(max, value))
```

### `Round(num, decimalPlaces): number`
Rounds to specified decimals:
```lua
Round(3.14159, 2) → 3.14
```

### `Distance(pos1, pos2): number`
Calculates distance between Vector3 positions:
```lua
return (pos1 - pos2).Magnitude
```

### `IsInRadius(point, center, radius): boolean`
Checks if point within radius of center.

### `RandomPositionInBox(min, max): Vector3`
Generates random position within bounds.

## Color Utilities

### `GetRarityColor(rarity): Color3`
Returns color for each rarity:
- **Common**: Gray (155, 155, 155)
- **Uncommon**: Green (100, 255, 100)
- **Rare**: Blue (100, 150, 255)
- **Epic**: Purple (200, 100, 255)
- **Legendary**: Gold (255, 200, 50)

## Table Operations

### `DeepCopy(original): table`
Creates independent copy of nested table:
```lua
local copy = Utils.DeepCopy(originalTable)
```

### `Shuffle(array): table`
Returns shuffled copy of array:
```lua
local shuffled = Utils.Shuffle({1,2,3,4,5})
```

### `WeightedRandom(weights): any`
Selects item based on weights:
```lua
local item = Utils.WeightedRandom({
    Sword = 10,
    Shield = 5,
    Potion = 1
})
```

## Easing

### `EaseInOut(t): number`
Smooth easing function for animations:
```lua
t < 0.5 ? 2*t² : -1 + (4-2t)*t
```

## Visual Effects

### `CreateFloatingText(text, position, duration, color): BillboardGui`
Creates floating damage/reward numbers:
- Animates upward
- Fades out over duration
- Auto-destroys

### `PlaySound(soundId, volume, parent): Sound`
Plays one-shot sound effect:
- Creates Sound instance
- Plays immediately
- Auto-destroys on completion

## Mobile Support

### `VibrateDevice()`
Triggers haptic feedback on mobile:
- Detects touch input
- Uses HapticService
- Safe fallback if unavailable

## Usage Examples

```lua
local Utils = require(ReplicatedStorage.Shared.Utils)

-- Format currency
local display = Utils.FormatNumber(1234567) -- "1.2M"

-- Calculate distance
local dist = Utils.Distance(pos1, pos2)

-- Get rarity color
local color = Utils.GetRarityColor("Legendary")

-- Weighted selection
local result = Utils.WeightedRandom({
    Common = 50,
    Rare = 10,
    Legendary = 1
})

-- Floating text
Utils.CreateFloatingText("+100", position, 2, Color3.new(1,1,0))
```

## Performance Notes
- DeepCopy: Expensive for large tables
- WeightedRandom: O(n) where n = number of items
- CreateFloatingText: Limit concurrent instances
- Shuffle: Creates new array, doesn't modify original

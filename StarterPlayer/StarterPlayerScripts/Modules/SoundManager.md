# SoundManager.lua

## Overview
Manages all game audio including music, sound effects, volume control, and audio settings.

## Purpose
- Play background music
- Trigger sound effects
- Control volume levels
- Handle mute/unmute
- Manage audio settings

## Sound Library
```lua
LevelUp = "rbxassetid://0"
Achievement = "rbxassetid://0"
PetHatch = "rbxassetid://0"
CoinCollect = "rbxassetid://0"
ButtonClick = "rbxassetid://0"
Victory = "rbxassetid://0"
Defeat = "rbxassetid://0"
BackgroundMusic = "rbxassetid://0"
```
*(Replace with actual asset IDs)*

## Audio Settings
```lua
MusicEnabled = true
SFXEnabled = true
DefaultVolume = 0.5
MusicVolume = 0.3
```

## Key Functions

### `Initialize()`
Setup process:
1. Creates Sound instances for all audio
2. Sets default volumes
3. Configures BackgroundMusic as looping
4. Starts background music if enabled
5. Parents sounds to SoundService

### `PlaySound(soundName, volume?)`
Plays a sound effect:

**Behavior:**
- Checks if SFX enabled (except music)
- Uses custom volume or default
- Plays sound immediately
- Music check for BackgroundMusic

**Usage:**
```lua
SoundManager:PlaySound("LevelUp")
SoundManager:PlaySound("CoinCollect", 0.3)
```

### `StopSound(soundName)`
Stops a playing sound:
```lua
SoundManager:StopSound("BackgroundMusic")
```

### `ToggleMusic()`
Toggles music on/off:
- Flips MusicEnabled flag
- Starts/stops BackgroundMusic
- Saves preference

### `ToggleSFX()`
Toggles sound effects on/off:
- Flips SFXEnabled flag
- Affects all non-music sounds
- Saves preference

### `SetMasterVolume(volume)`
Sets volume for all sounds:
```lua
SoundManager:SetMasterVolume(0.5) -- 50% volume
```

## Sound Triggers

### Progression Sounds
- **LevelUp**: Player levels up
- **Achievement**: Achievement unlocked

### Pet Sounds
- **PetHatch**: Pet successfully hatched

### Economy Sounds
- **CoinCollect**: Coins collected
- **ButtonClick**: UI button pressed

### Game Sounds
- **Victory**: Wave/obby completed
- **Defeat**: Game over/failed

### Ambient
- **BackgroundMusic**: Continuous loop

## Integration Examples

### Pet Hatching
```lua
-- In MainClient.lua
ReplicatedStorage.Remotes.HatchResult.OnClientEvent:Connect(function(success, data)
    if success then
        SoundManager:PlaySound("PetHatch")
        -- Show animation...
    end
end)
```

### Level Up
```lua
ReplicatedStorage.Remotes.LevelUp.OnClientEvent:Connect(function(newLevel)
    SoundManager:PlaySound("LevelUp")
    -- Show notification...
end)
```

### Button Click
```lua
button.MouseButton1Click:Connect(function()
    SoundManager:PlaySound("ButtonClick")
    -- Handle click...
end)
```

## Volume Management

### Sound Hierarchy
1. **Master Volume**: Affects all sounds
2. **Music/SFX Toggle**: Enable/disable categories
3. **Individual Volume**: Per-sound volume

### Calculation
```lua
finalVolume = masterVolume * soundVolume * categoryEnabled
```

## Audio Settings Persistence
Save to player settings:
```lua
{
    MusicEnabled = boolean,
    SFXEnabled = boolean,
    MasterVolume = number
}
```

Load on initialization:
```lua
local settings = playerData.Settings
SoundManager.MusicEnabled = settings.MusicEnabled
SoundManager.SFXEnabled = settings.SFXEnabled
```

## Performance Optimization
- Sounds parent to SoundService (global)
- Reuse Sound instances (don't recreate)
- Stop sounds when not needed
- Limit concurrent sounds

## Mobile Considerations
- Lower default volume (battery/speaker)
- Vibration as audio feedback alternative
- Respect system volume

## Audio Best Practices
- **Feedback**: Immediate sound for actions
- **Clarity**: Distinct sounds for different events
- **Balance**: Music doesn't overpower SFX
- **Variety**: Multiple sounds prevent repetition
- **Accessibility**: Option to disable

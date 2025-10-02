# CameraController.lua

## Overview
Manages camera behavior, effects, and cinematic moments for enhanced visual experience.

## Purpose
- Control camera modes
- Create camera shake effects
- Smooth zoom transitions
- Handle cinematic sequences

## Camera Modes
1. **Default**: Standard Roblox camera (follows player)
2. **Cinematic**: Scripted camera movements
3. **Fixed**: Locked position/rotation

## Key Functions

### `Initialize()`
- Sets default camera type (Custom)
- Prepares camera system
- Logs initialization

### `SetupCharacter(character)`
Stores character references:
- Character model
- Humanoid (camera subject)
- HumanoidRootPart (position reference)

### `Shake(intensity, duration)`
Creates camera shake effect:

**Parameters:**
- `intensity`: Shake magnitude (0-1)
- `duration`: Shake duration (seconds)

**Behavior:**
- Random offset each frame
- Intensity in all axes (X, Y, Z)
- Auto-stops after duration
- Returns camera to normal

**Usage:**
```lua
CameraController:Shake(0.5, 0.3) -- Medium shake for 0.3s
```

### `ZoomTo(position, duration)`
Smooth camera transition to position:

**Process:**
1. Set mode to "Cinematic"
2. Calculate target CFrame (10 units up, 10 back)
3. Tween camera to position
4. Return to "Default" mode

**Parameters:**
- `position`: Vector3 target
- `duration`: Transition time (seconds)

**Usage:**
```lua
CameraController:ZoomTo(Vector3.new(0, 50, 0), 2)
```

### `ResetCamera()`
Returns camera to normal:
- Sets mode to "Default"
- CameraType = Custom
- Subject = player Humanoid
- Removes any locks

## Camera Shake Uses
- **Impact Effects**: Enemy hits, explosions
- **Pet Hatching**: Dramatic reveal
- **Level Up**: Celebration effect
- **Wave Complete**: Victory shake

## Cinematic Uses
- **Event Start**: Zoom to event area
- **Achievement**: Dramatic angle
- **Boss Spawn**: Epic introduction
- **Tutorial**: Guide player attention

## Camera Math

### Shake Calculation
```lua
shake = Vector3.new(
    random(-100, 100) / 100 * intensity,
    random(-100, 100) / 100 * intensity,
    random(-100, 100) / 100 * intensity
)
CFrame = CFrame * CFrame.new(shake)
```

### Zoom Calculation
```lua
targetCFrame = CFrame.new(
    position + Vector3.new(0, 10, 10),  -- Offset
    position                             -- Look at
)
```

## Integration Examples

### Pet Hatch Shake
```lua
-- When rare pet hatched
if petRarity == "Legendary" then
    CameraController:Shake(0.8, 0.5)
end
```

### Event Start Zoom
```lua
-- When event begins
local eventPosition = workspace.EventArea.Position
CameraController:ZoomTo(eventPosition, 3)
```

### Battle Impact
```lua
-- When enemy hit
CameraController:Shake(0.3, 0.2)
```

## Performance Notes
- Shake uses RenderStepped (every frame)
- Auto-disconnects when complete
- Tweens are garbage collected
- No memory leaks

## Mobile Considerations
- Shake intensity may be reduced
- Cinematic modes respect touch camera
- Smooth transitions prevent motion sickness

## Future Enhancements
- FOV changes (zoom effect)
- Camera presets (angles)
- Replay system (recording)
- Depth of field effects

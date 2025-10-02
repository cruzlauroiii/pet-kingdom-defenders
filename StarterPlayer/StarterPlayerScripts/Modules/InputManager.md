# InputManager.lua

## Overview
Handles all player input including keyboard, mouse, and mobile touch controls with cross-platform support.

## Purpose
- Detect input type (desktop/mobile)
- Handle keyboard shortcuts
- Process touch input
- Manage input state (enabled/disabled)

## Input Detection
```lua
if TouchEnabled and not KeyboardEnabled then
    IsMobile = true
else
    IsMobile = false
end
```

## Key Functions

### `Initialize()`
- Detects platform (mobile vs desktop)
- Connects InputBegan listener
- Connects InputEnded listener
- Logs control mode

### `SetupCharacter(character)`
- Stores character reference
- Gets Humanoid reference
- Enables character-specific input

### `OnInputBegan(input)`
Handles keyboard shortcuts:
- **E**: Toggle Pet Menu
- **Q**: Toggle Shop
- **T**: Toggle Trading
- **ESC**: Toggle Settings

Respects `gameProcessed` flag (ignores input if UI has focus).

### `OnInputEnded(input)`
Handles release events (currently unused).

### `SetInputEnabled(enabled)`
Globally enable/disable input:
- Useful during cutscenes
- Prevents input during trades
- Disabled during respawn

## Keyboard Shortcuts

### Menu Access
- **E**: Pets
- **Q**: Shop
- **T**: Trading
- **ESC**: Settings

### Movement
Handled by Roblox default:
- **WASD**: Movement
- **Space**: Jump
- **Shift**: Sprint (if enabled)

### Camera
Handled by Roblox default:
- **Mouse**: Look around
- **I/O**: Zoom in/out

## Mobile Controls

### Touch Support
- **Virtual Thumbstick**: Movement
- **Jump Button**: Jump
- **UI Buttons**: All menu access

### Mobile Optimizations
- Larger hit boxes for buttons
- Simplified UI layout
- Auto-hide unused controls

## Input States
```lua
InputEnabled = true|false
```

When disabled:
- No keyboard input processed
- Touch input still works for UI
- Movement disabled

## Platform-Specific Behavior

### Desktop
- Full keyboard shortcuts
- Mouse look
- High precision input

### Mobile
- Touch controls only
- Simplified shortcuts
- Larger touch targets

### Console (Future)
- Gamepad support
- D-pad navigation
- Button mapping

## Integration with UIManager
```lua
InputManager detects E key
  ↓
Gets UIManager module
  ↓
Calls UIManager:ToggleWindow("PetMenu")
  ↓
Window opens/closes
```

## Best Practices
- Always check `gameProcessed` flag
- Respect `InputEnabled` state
- Provide alternative touch controls
- Clear visual feedback for input

## Anti-Spam
- Built-in debounce via UserInputService
- No need for manual cooldowns
- UI handles rapid clicking

## Future Enhancements
- Custom keybinds
- Gamepad support
- Gesture controls (mobile)
- Accessibility options

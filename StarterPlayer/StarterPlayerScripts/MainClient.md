# MainClient.lua

## Overview
Main client-side controller that initializes all client systems and manages UI/UX for Pet Kingdom Defenders.

## Purpose
- Initialize client-side managers
- Handle server → client communication
- Process remote events
- Manage player character setup

## Initialized Systems
1. **UIManager** - All UI windows and displays
2. **InputManager** - Keyboard/mouse/touch input
3. **CameraController** - Camera behavior and effects
4. **SoundManager** - Music and sound effects
5. **NotificationManager** - Toast notifications

## Key Functions

### `initializeClient()`
Initializes all client systems in order:
- Sets up managers
- Shows welcome notification
- Prepares UI for interaction

### `setupRemoteListeners()`
Connects to all server events:

#### Currency Events
- **UpdateCurrency**: Updates coin/gem display

#### Progression Events
- **LevelUp**: Shows level up notification + sound

#### Pet Events
- **HatchResult**: Shows hatch animation and notification

#### Trading Events
- **TradeRequest**: Shows trade request popup
- **TradeAccepted**: Opens trade window
- **TradeCompleted**: Closes window, shows success

#### Event Events
- **EventStarted**: Shows event banner
- **AchievementUnlocked**: Shows achievement popup + sound

### `onCharacterAdded(character)`
Called when player spawns:
- Sets up camera for character
- Configures input for character
- Initializes character-specific systems

## Remote Event Flow

### Receiving Updates
```lua
Server → UpdateCurrency → Client
  ↓
UIManager:UpdateCurrency()
  ↓
Updates UI display
```

### Pet Hatching
```lua
Player clicks hatch button
  ↓
Client → HatchEgg → Server
  ↓
Server processes hatch
  ↓
Server → HatchResult → Client
  ↓
Shows hatch animation
```

### Trading Flow
```lua
Player1 → SendTradeRequest → Server
  ↓
Server → TradeRequest → Player2
  ↓
Player2 accepts
  ↓
Server → TradeAccepted → Both players
  ↓
UIManager opens trade window
```

## Notification Types
- **success**: Green, positive actions
- **error**: Red, failures/warnings
- **info**: Blue, general information
- **special**: Gold, events/achievements

## Dependencies
- UIManager (UI/windows)
- InputManager (controls)
- CameraController (camera)
- SoundManager (audio)
- NotificationManager (toasts)
- Config (game settings)
- Utils (helper functions)
- PetData (pet information)

## Initialization Order
Critical that managers initialize in this order:
1. UIManager (needs UI elements)
2. InputManager (needs character)
3. CameraController (needs camera setup)
4. SoundManager (can start anytime)
5. NotificationManager (needs UI container)

## Mobile Optimization
Automatically detects mobile and adjusts:
- Touch controls
- Simplified UI
- Optimized effects

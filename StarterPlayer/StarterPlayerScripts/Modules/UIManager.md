# UIManager.lua

## Overview
Manages all UI elements, windows, animations, and visual displays on the client side.

## Purpose
- Control window opening/closing
- Animate UI transitions
- Update currency displays
- Show pet hatch animations
- Handle trade UI
- Display event banners
- Show achievement popups

## UI Structure
```
MainUI (ScreenGui)
├── HUD (Frame)
│   ├── Currency Displays
│   ├── Menu Buttons
│   ├── Event Banner
│   └── Achievement Popup
├── Windows (Frame)
│   ├── PetMenu
│   ├── Shop
│   ├── Tycoon
│   ├── TowerDefense
│   ├── Trading
│   └── Settings
└── NotificationContainer
```

## Key Functions

### `Initialize()`
- Waits for MainUI to load
- Gets references to HUD and Windows
- Sets up button click handlers

### `SetupButtons()`
Connects all menu buttons:
- Pet Menu (E key)
- Shop (Q key)
- Tycoon
- Tower Defense
- Trading (T key)
- Settings (ESC key)

### `ToggleWindow(windowName)`
Opens window if closed, closes if open.

### `OpenWindow(windowName)`
- Makes window visible
- Closes other windows (optional)
- Animates in from bottom
- Uses Back easing for bounce effect

### `CloseWindow(windowName)`
- Animates out to bottom
- Hides window after animation
- Uses Back easing for smooth exit

### `UpdateCurrency(currencyType, amount)`
Updates coin or gem display with formatted number.

### `ShowHatchAnimation(petData)`
Shows pet hatch reveal:
- Displays pet name
- Shows rarity with color
- Auto-closes after 3 seconds

### `ShowTradeRequest(requester, tradeId)`
Shows trade request popup:
- Displays requester name
- Accept button → fires AcceptTradeRequest
- Decline button → fires DeclineTradeRequest

### `OpenTradeWindow(tradeData)`
Opens trading window with:
- Trade partner info
- Item slots for both sides
- Confirm/cancel buttons

### `CloseTradeWindow()`
Closes trading window.

### `ShowEventBanner(eventData)`
Displays event notification banner:
- Shows event name
- Auto-hides after 5 seconds

### `ShowAchievementPopup(achievement)`
Shows achievement unlock:
- Title and description
- Auto-hides after 4 seconds

## Animation System

### Window Animations
```lua
-- Open animation
Position: UDim2(0.5, 0, 1.5, 0) -- Below screen
  ↓
Position: UDim2(0.5, 0, 0.5, 0) -- Center
Duration: 0.3s
Easing: Back Out (bounce effect)
```

```lua
-- Close animation
Position: UDim2(0.5, 0, 0.5, 0) -- Center
  ↓
Position: UDim2(0.5, 0, 1.5, 0) -- Below screen
Duration: 0.3s
Easing: Back In
```

## Window Management
- **Single Window Mode**: Only one window open at a time
- **Multi Window Mode**: Comment out close logic for multiple windows
- **Escape to Close**: All windows close on ESC

## Rarity Colors
Uses Utils.GetRarityColor() for:
- Pet rarity display
- Item quality indicators
- Reward tiers

## UI Best Practices
- **Responsive**: Works on all screen sizes
- **Mobile-Friendly**: Touch-optimized buttons
- **Smooth Animations**: 0.3s tweens with easing
- **Clear Hierarchy**: Logical window structure
- **Accessibility**: High contrast, readable fonts

## Button Shortcuts
- **E**: Open Pet Menu
- **Q**: Open Shop
- **T**: Open Trading
- **ESC**: Open Settings / Close Windows

## Dependencies
- Config (animation speeds)
- Utils (number formatting, colors)
- TweenService (animations)

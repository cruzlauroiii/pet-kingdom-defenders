# MainUI.lua

## Overview
Programmatically creates the complete UI structure for Pet Kingdom Defenders. Builds all HUD elements, windows, and interactive components.

## Purpose
- Create main ScreenGui
- Build HUD elements (currency, buttons)
- Generate window templates
- Setup notification container
- Create event banners and popups

## UI Architecture
```
MainUI (ScreenGui)
├── HUD (Frame)
│   ├── Currency Displays (Coins, Gems)
│   ├── Bottom Menu Buttons (5 buttons)
│   ├── Settings Button (top-right)
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

## HUD Components

### Currency Display
Function: `createCurrencyDisplay(name, position, icon)`

Creates:
- 150x40 frame
- Rounded corners
- Icon label (emoji/symbol)
- Value label (formatted number)

**Displays:**
- 💰 Coins (top-left)
- 💎 Gems (next to coins)

### Menu Buttons
Function: `createMenuButton(name, position, text)`

Creates:
- 100x50 button
- Rounded corners
- Centered text
- Bottom-anchored

**Buttons:**
1. Pets (20% from left)
2. Shop (35%)
3. Tycoon (50%)
4. Tower Defense (65%)
5. Trade (80%)
6. Settings (top-right corner)

## Window System

### Window Template
Function: `createWindow(name, title)`

Each window has:
1. **Main Frame** (600x400)
   - Centered on screen
   - Rounded corners (12px)
   - Dark gray background

2. **Title Bar** (full width, 40px height)
   - Title text (left-aligned)
   - Close button (X, red, top-right)

3. **Content Area** (ScrollingFrame)
   - Fills remaining space
   - 10px padding
   - 6px scroll bar

### Created Windows
- **PetMenu**: "My Pets"
- **Shop**: "Shop"
- **Tycoon**: "My Tycoon"
- **TowerDefense**: "Tower Defense"
- **Trading**: "Trading"
- **Settings**: "Settings"

## Special UI Elements

### Event Banner
- 400x60 frame
- Top-center position
- Gold background
- Auto-hides (controlled by EventManager)
- Shows event name

### Achievement Popup
- 350x100 frame
- Below event banner
- Green background
- Shows title and description
- Auto-hides after display

### Notification Container
- Full-screen transparent frame
- Contains toast notifications
- Top-right positioning
- Managed by NotificationManager

## Styling

### Colors
- **Background**: RGB(40, 40, 40) - Dark gray
- **Title Bar**: RGB(30, 30, 30) - Darker gray
- **Close Button**: RGB(200, 50, 50) - Red
- **Event**: RGB(255, 200, 50) - Gold
- **Achievement**: RGB(100, 200, 100) - Green

### Corners
- **Windows**: 12px radius
- **Buttons**: 8px radius
- **Currency/HUD**: 8px radius

### Fonts
- **Titles**: GothamBold
- **Content**: Gotham
- **Buttons**: GothamBold

## Responsive Design

### Anchoring
All elements use proper anchoring:
- **Currency**: Top-left (0, 0)
- **Menu Buttons**: Bottom-center (0.5, 1)
- **Settings**: Top-right (1, 0)
- **Windows**: Center (0.5, 0.5)

### Scaling
- Uses UDim2 with offset
- Scales on different resolutions
- Mobile-friendly sizes

## Initialization Flow
```lua
Create ScreenGui
  ↓
Create HUD frame
  ↓
Create currency displays
  ↓
Create menu buttons
  ↓
Create Windows container
  ↓
Create all window templates
  ↓
Create special elements (banners, popups)
  ↓
Parent to PlayerGui
```

## Integration

### With UIManager
UIManager references:
```lua
self.MainUI = mainUI
self.HUD = mainUI.HUD
self.Windows = mainUI.Windows
```

### With NotificationManager
NotificationManager uses:
```lua
self.NotificationContainer = mainUI.NotificationContainer
```

## Button Setup
Close buttons auto-connect:
```lua
closeButton.MouseButton1Click:Connect(function()
    -- Close window logic
end)
```

Menu buttons connect in UIManager:
```lua
petButton.MouseButton1Click:Connect(function()
    UIManager:ToggleWindow("PetMenu")
end)
```

## Properties
```lua
ResetOnSpawn = false  -- Persists through respawn
ZIndexBehavior = Sibling  -- Proper layering
```

## Mobile Optimization
- Touch-friendly button sizes (100x50)
- Clear visual hierarchy
- Scrollable content areas
- Large touch targets

## Performance
- Created once on join
- Reused throughout session
- No frame recreation
- Efficient structure

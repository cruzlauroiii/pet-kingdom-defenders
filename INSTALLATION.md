# Installation & Setup Guide

Complete guide for setting up Pet Kingdom Defenders in Roblox Studio.

## 📋 Prerequisites

### Software Requirements
- **Roblox Studio** (Latest version)
  - Download from [roblox.com/create](https://www.roblox.com/create)
  - Minimum version: 2024.10 or newer

### Account Requirements
- Roblox account with:
  - Studio access enabled
  - API Services enabled (for DataStores)
  - Group or personal place to publish

## 🚀 Quick Start

### Option 1: Import to Roblox Studio

1. **Open Roblox Studio**
   ```
   File → Open from File → Select project folder
   ```

2. **Enable Required Services**
   ```
   Home → Game Settings → Security
   ☑ Enable Studio Access to API Services
   ☑ Enable HTTP Requests (if using external APIs)
   ```

3. **Configure DataStore**
   ```
   Home → Game Settings → Options
   ☑ Enable Studio Access to Game Settings
   ```

4. **Run the Game**
   - Press **F5** or click **Play** button
   - Test in single-player first
   - Then test with **Local Server** (F7) for multiplayer

### Option 2: Manual Setup

1. **Create New Place**
   ```
   File → New
   Select: Baseplate or Flat Terrain
   ```

2. **Import Scripts**
   - Copy all files from repository
   - Maintain folder structure:
     ```
     ServerScriptService/
     ReplicatedStorage/
     StarterPlayer/
     StarterGui/
     ```

3. **Create Required Folders**
   ```lua
   -- In Workspace
   Folder: Pets
   Folder: Bases
   Folder: Enemies
   Folder: Obbies
   ```

## 📂 File Structure Setup

### 1. ServerScriptService
```
ServerScriptService/
├── InitializeRemotes.lua      (RunContext: Server)
├── MainServer.lua              (RunContext: Server)
└── Modules/
    ├── DataManager.lua
    ├── PetSystem.lua
    ├── TowerDefenseManager.lua
    ├── TycoonManager.lua
    ├── EconomyManager.lua
    ├── TradingSystem.lua
    ├── ObbyManager.lua
    └── EventManager.lua
```

**Properties to set:**
- All scripts: `RunContext = Server`
- Load order: InitializeRemotes → MainServer

### 2. ReplicatedStorage
```
ReplicatedStorage/
├── Shared/
│   ├── Config.lua
│   ├── PetData.lua
│   └── Utils.lua
└── Remotes/
    └── RemotesSetup.lua
```

**Note:** All modules are `ModuleScript` type

### 3. StarterPlayer
```
StarterPlayer/
└── StarterPlayerScripts/
    ├── MainClient.lua          (RunContext: Client)
    └── Modules/
        ├── UIManager.lua
        ├── InputManager.lua
        ├── CameraController.lua
        ├── SoundManager.lua
        └── NotificationManager.lua
```

**Properties to set:**
- MainClient.lua: `RunContext = Client`
- All modules: `ModuleScript` type

### 4. StarterGui
```
StarterGui/
└── MainUI.lua                  (RunContext: Client)
```

**Properties:**
- RunContext: Client
- Runs on player spawn

## ⚙️ Configuration

### 1. Game Settings

**Basic Settings:**
```
Game Settings → Basic Info
- Name: Pet Kingdom Defenders
- Description: [Your description]
- Genre: All Genres or Adventure
- Max Players: 50 (recommended)
```

**Permissions:**
```
Game Settings → Permissions
- ☑ Friends Allowed
- ☑ Following Allowed
- ☑ Public (for launch)
```

**Monetization:**
```
Game Settings → Monetization
- ☑ Enable Paid Access (if desired)
- ☑ Enable Game Passes
- ☑ Enable Developer Products
```

### 2. DataStore Configuration

**Enable DataStore:**
```lua
-- Game Settings → Security
☑ Enable Studio Access to API Services

-- For Testing in Studio
☑ Enable Studio Access to Data Stores
```

**DataStore Names:**
- Primary: `PlayerData_V1`
- Backup: `PlayerDataBackup_V1`

**Important:** Change `_V1` to `_V2` for new versions to avoid data conflicts

### 3. Asset IDs Setup

**Replace placeholder asset IDs in:**

**SoundManager.lua:**
```lua
local SOUND_IDS = {
    LevelUp = "rbxassetid://YOUR_ID",
    Achievement = "rbxassetid://YOUR_ID",
    PetHatch = "rbxassetid://YOUR_ID",
    CoinCollect = "rbxassetid://YOUR_ID",
    ButtonClick = "rbxassetid://YOUR_ID",
    Victory = "rbxassetid://YOUR_ID",
    Defeat = "rbxassetid://YOUR_ID",
    BackgroundMusic = "rbxassetid://YOUR_ID"
}
```

**PetData.lua:**
```lua
-- For each pet
Model = "rbxassetid://YOUR_PET_MODEL_ID",
Icon = "rbxassetid://YOUR_PET_ICON_ID"
```

### 4. Developer Products Setup

**Create Dev Products:**
1. Go to [Roblox Creator Dashboard](https://create.roblox.com)
2. Select your game
3. Monetization → Developer Products → Create New
4. Create these products:
   - 100 Gems (100 Robux)
   - 500 Gems (400 Robux)
   - 1000 Gems (700 Robux)
   - 50K Coins (200 Robux)
   - Starter Bundle (300 Robux)

**Update Config.lua:**
```lua
Config.SHOP_PRODUCTS = {
    [YOUR_PRODUCT_ID_1] = {
        Name = "100 Gems",
        Type = "Gems",
        Amount = 100,
        Price = 100
    },
    -- etc...
}
```

## 🧪 Testing

### 1. Single Player Test
```
Press F5 in Studio
- Test pet hatching
- Test building purchase
- Test obby completion
- Check UI functionality
```

### 2. Multiplayer Test
```
Press F7 (Local Server)
Players: 2-4
- Test trading system
- Test multiple bases
- Test server performance
```

### 3. Mobile Test
```
View → Device → Phone or Tablet
- Test touch controls
- Test UI scaling
- Check performance
```

## 🐛 Common Issues & Solutions

### Issue 1: "Remote not found"
**Solution:**
```lua
-- Ensure InitializeRemotes runs first
-- Check output for remote creation logs
-- Verify Remotes folder exists in ReplicatedStorage
```

### Issue 2: "DataStore failed"
**Solution:**
```lua
-- Enable API Services in Game Settings
-- Check internet connection
-- Verify DataStore names are correct
-- Check for typos in DataStore keys
```

### Issue 3: "UI not showing"
**Solution:**
```lua
-- Ensure MainUI.lua runs on client
-- Check if ScreenGui is parented to PlayerGui
-- Verify ResetOnSpawn = false
-- Check for script errors in output
```

### Issue 4: "Pets not spawning"
**Solution:**
```lua
-- Verify PetSystem:Initialize() is called
-- Check if player has equipped pets
-- Look for errors in PetSystem.lua
-- Ensure Pets folder exists in Workspace
```

### Issue 5: "Trading not working"
**Solution:**
```lua
-- Verify remotes are created
-- Check both players are in-game
-- Ensure players have pets to trade
-- Check for firewall/network issues
```

## 📊 Performance Optimization

### Server Performance
```lua
-- Recommended Settings
Max Players: 50
Network Ownership: Automatic
Streaming Enabled: ☑ (for large maps)
```

### Client Performance
```lua
-- Graphics Settings
Quality Level: Automatic
Shadow Quality: Medium or Low
Particle Effects: Enabled (can disable for low-end)
```

### Memory Management
- Pet models: Keep poly count under 5K
- Textures: Use 512x512 or lower
- Sound files: Use compressed audio
- Scripts: Avoid memory leaks (proper cleanup)

## 🚢 Publishing

### 1. Pre-publish Checklist
- [ ] All asset IDs replaced
- [ ] DataStores tested and working
- [ ] Developer Products created and configured
- [ ] Game tested with multiple players
- [ ] No critical errors in output
- [ ] Mobile version tested
- [ ] Performance is acceptable

### 2. Publish Steps
```
File → Publish to Roblox
- Choose existing place or create new
- Set privacy (public/private)
- Click "Publish"
```

### 3. Post-publish Setup
1. **Configure Game Page**
   - Upload thumbnails
   - Write description
   - Add game passes
   - Set up social links

2. **Enable Analytics**
   - Creator Dashboard → Analytics
   - Monitor key metrics
   - Track player behavior

3. **Setup Notifications**
   - Update announcements
   - Social media posts
   - Friend invites

## 🔄 Updates & Maintenance

### Updating the Game
```lua
-- Safe update process
1. Test in separate place
2. Backup current version
3. Increment DataStore version (V1 → V2)
4. Publish update
5. Monitor for errors
```

### Data Migration
```lua
-- If changing data structure
function DataManager:MigrateData(oldData)
    local newData = deepCopy(DEFAULT_DATA)
    -- Copy old values
    newData.Coins = oldData.Coins or 1000
    -- Add new fields with defaults
    newData.NewField = 0
    return newData
end
```

## 📝 Checklist

### Initial Setup
- [ ] Roblox Studio installed
- [ ] API Services enabled
- [ ] All scripts imported
- [ ] Folder structure created
- [ ] Asset IDs configured
- [ ] Dev Products created

### Testing
- [ ] Single player tested
- [ ] Multiplayer tested
- [ ] Mobile tested
- [ ] All features working
- [ ] No critical errors
- [ ] Performance acceptable

### Publishing
- [ ] Game published
- [ ] Thumbnails uploaded
- [ ] Description written
- [ ] Products configured
- [ ] Analytics enabled
- [ ] Announced to players

## 🆘 Support

If you encounter issues:
1. Check Output window for errors
2. Review this installation guide
3. Check individual `.md` files for system-specific docs
4. Visit [Roblox DevForum](https://devforum.roblox.com)
5. Create issue on GitHub repository

---

**🎉 Congratulations!** Your Pet Kingdom Defenders game is now set up and ready to play!

For detailed information on each system, refer to the individual `.md` documentation files.

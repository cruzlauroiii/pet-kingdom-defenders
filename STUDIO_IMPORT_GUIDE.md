# 🎮 Roblox Studio Import & Testing Guide

## Quick Start: Get Your Game Running in 15 Minutes!

This guide will help you import Pet Kingdom Defenders into Roblox Studio and start testing immediately.

---

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ **Roblox Studio** installed (latest version from [roblox.com/create](https://www.roblox.com/create))
- ✅ **Roblox Account** (13+ for DataStore testing)
- ✅ **This project folder** (`C:\Users\lauro.cruz\src\map`)

---

## 🚀 Method 1: Open the Place File (Recommended)

### Step 1: Open in Roblox Studio

1. **Launch Roblox Studio**
2. Click **File → Open from File**
3. Navigate to: `C:\Users\lauro.cruz\src\map`
4. Select: **`PetKingdomDefenders.rbxlx`**
5. Click **Open**

Studio will load the basic place structure with:
- Workspace with spawn, baseplate, and folders
- All necessary service folders (ReplicatedStorage, ServerScriptService, etc.)

### Step 2: Add the Lua Scripts

The place file has the folder structure, but scripts must be added manually.

**IMPORTANT:** Roblox Studio cannot directly import .lua files from your file system into the game. You need to copy the code.

#### Option A: Manual Copy-Paste (Simple but Tedious)

1. **ServerScriptService:**
   - Create a **Script** named `InitializeRemotes`
   - Copy code from: `ServerScriptService/InitializeRemotes.lua`
   - Paste into Studio script

   - Create a **Script** named `MainServer`
   - Copy code from: `ServerScriptService/MainServer.lua`
   - Paste into Studio script

2. **ServerScriptService/Modules:**
   - Right-click Modules folder → Insert Object → ModuleScript
   - Name it: `SecurityManager`
   - Copy code from: `ServerScriptService/Modules/SecurityManager.lua`
   - Paste into Studio

   - Repeat for all 8 modules:
     - SecurityManager.lua
     - DataManager.lua
     - PetSystem.lua
     - TowerDefenseManager.lua
     - TycoonManager.lua
     - EconomyManager.lua
     - TradingSystem.lua
     - ObbyManager.lua
     - EventManager.lua

3. **ReplicatedStorage/Remotes:**
   - Insert ModuleScript → Name: `RemotesSetup`
   - Copy from: `ReplicatedStorage/Remotes/RemotesSetup.lua`

4. **ReplicatedStorage/Shared:**
   - Insert 3 ModuleScripts:
     - `Config` ← Config.lua
     - `PetData` ← PetData.lua
     - `Utils` ← Utils.lua

5. **StarterPlayer/StarterPlayerScripts:**
   - Insert LocalScript → Name: `MainClient`
   - Copy from: `StarterPlayer/StarterPlayerScripts/MainClient.lua`

6. **StarterPlayer/StarterPlayerScripts/Modules:**
   - Insert 5 ModuleScripts:
     - `UIManager` ← UIManager.lua
     - `InputManager` ← InputManager.lua
     - `CameraController` ← CameraController.lua
     - `SoundManager` ← SoundManager.lua
     - `NotificationManager` ← NotificationManager.lua

7. **StarterGui:**
   - Insert LocalScript → Name: `MainUI`
   - Copy from: `StarterGui/MainUI.lua`

#### Option B: Use Rojo (Advanced - Automatic Sync)

If you're familiar with Rojo, you can use it to automatically sync files:

```bash
# Install Rojo
aftman add rojo-rbx/rojo

# Create default.project.json
rojo init

# Serve project
rojo serve
```

Then connect from Studio plugin. See [Rojo documentation](https://rojo.space).

---

## ⚙️ Method 2: Build from Scratch (Learning Path)

If you want to understand every piece:

1. **Create New Place**
   - File → New
   - Choose Baseplate template

2. **Create Folder Structure**
   - Add Folder to Workspace: "Pets", "Bases", "Enemies", "Obbies"
   - Add Folder to ReplicatedStorage: "Remotes", "Shared"
   - Add Folder to ServerScriptService: "Modules"
   - Add Folder to StarterPlayerScripts: "Modules"

3. **Add Scripts** (same as Method 1, Step 2)

---

## 🔧 Configuration Before Testing

### 1. Enable API Services

**Critical for DataStore testing!**

1. Go to: **Home → Game Settings** (or press Alt+S)
2. Navigate to: **Security**
3. Enable: ✅ **Allow Studio Access to API Services**
4. Click **Save**

Without this, DataStore will fail and you'll see warnings in Output.

### 2. Verify Script Locations

Use this checklist to verify everything is in the right place:

```
Workspace
├── Pets (Folder)
├── Bases (Folder)
├── Enemies (Folder)
└── Obbies (Folder)

ServerScriptService
├── InitializeRemotes (Script)
├── MainServer (Script)
└── Modules (Folder)
    ├── SecurityManager (ModuleScript)
    ├── DataManager (ModuleScript)
    ├── PetSystem (ModuleScript)
    ├── TowerDefenseManager (ModuleScript)
    ├── TycoonManager (ModuleScript)
    ├── EconomyManager (ModuleScript)
    ├── TradingSystem (ModuleScript)
    ├── ObbyManager (ModuleScript)
    └── EventManager (ModuleScript)

ReplicatedStorage
├── Remotes (Folder)
│   └── RemotesSetup (ModuleScript)
└── Shared (Folder)
    ├── Config (ModuleScript)
    ├── PetData (ModuleScript)
    └── Utils (ModuleScript)

StarterPlayer
└── StarterPlayerScripts
    ├── MainClient (LocalScript)
    └── Modules (Folder)
        ├── UIManager (ModuleScript)
        ├── InputManager (ModuleScript)
        ├── CameraController (ModuleScript)
        ├── SoundManager (ModuleScript)
        └── NotificationManager (ModuleScript)

StarterGui
└── MainUI (LocalScript)
```

---

## ▶️ Testing the Game

### First Test: Check for Errors

1. **Open Output Window**
   - View → Output (or press Ctrl+Alt+O)

2. **Click Play (F5)**

3. **Look for Initialization Messages**

You should see:
```
[Server] Pet Kingdom Defenders - Initializing...
[SecurityManager] Initializing 2025 security measures...
[SecurityManager] Security initialized!
[DataManager] Initializing...
[DataManager] DataStore Version: PROD_V1
[DataManager] Initialized successfully!
[PetSystem] Initializing...
[PetSystem] Initialized successfully!
... (all 8 systems initialize)
[Server] All systems initialized successfully!
[Server] Pet Kingdom Defenders is running!
[Server] Player joined: YourUsername
[RemotesSetup] All remotes created successfully!
[UIManager] Initializing...
[UIManager] Initialized successfully!
[SoundManager] Initializing...
[SoundManager] Initialized successfully!
```

4. **If You See Errors:**
   - Red text = script error
   - Yellow text = warning (usually okay)
   - Check script names and locations match exactly

### Second Test: Basic Functionality

**Test Pet Hatching:**

1. Press **E** to open Pet Menu (or click Pets button)
2. Pet Menu window should slide in from bottom
3. Click on an egg option
4. Check Output for: `[PetSystem] YourName hatched Dog (Common) - ID: xxx`
5. A colored ball should appear following you

**Test Currency:**

1. Check top-left HUD shows Coins and Gems
2. Open Output window
3. Type in Command Bar:
```lua
game:GetService("ReplicatedStorage").Remotes.UpdateCurrency:FireClient(game.Players:GetPlayers()[1], "Coins", 999999)
```
4. Should see coin count update

**Test Tower Defense:**

1. Click "Tower Defense" button
2. Window should open
3. Click "Start Wave" (if button exists in UI)
4. Check Output for wave started messages

**Test Keyboard Controls:**

- **E** = Pet Menu
- **Q** = Shop
- **T** = Trading
- **ESC** = Settings

### Third Test: Security System

**Test Rate Limiting:**

1. Open Command Bar (View → Command Bar)
2. Run this rapidly (press Enter multiple times):
```lua
game:GetService("ReplicatedStorage").Remotes.HatchEgg:FireServer("BasicEgg")
```

3. Check Output - you should see:
```
[SecurityManager] Suspicious activity: ... | Action: HatchEgg | Reason: Rate limit exceeded
```

4. After 10 violations in 5 minutes, player should be auto-kicked

**This confirms security is working!**

---

## 🐛 Common Issues & Solutions

### Issue 1: "RemotesSetup module not found"

**Solution:**
- Verify `RemotesSetup.lua` is in `ReplicatedStorage/Remotes/`
- It must be a **ModuleScript**, not a Script

### Issue 2: "DataStore request was rejected"

**Solution:**
- Game Settings → Security → Enable "Studio Access to API Services"
- Save and restart Studio
- Or ignore if testing without persistence

### Issue 3: No UI appears

**Solution:**
- Check `MainUI.lua` is in `StarterGui` as a **LocalScript**
- Check Output for UI errors
- Verify UIManager is in StarterPlayerScripts/Modules

### Issue 4: Pets don't follow player

**Solution:**
- PetSystem creates simple Part-based pets (colored balls)
- They should orbit around player
- Check Output for PetSystem errors

### Issue 5: Sounds don't play

**Solution:**
- Sounds use free Roblox asset IDs
- If they don't work, they may be deleted
- Replace IDs in `SoundManager.lua` (see comments)

### Issue 6: "Attempt to index nil with 'Remotes'"

**Solution:**
- `InitializeRemotes.lua` must run BEFORE `MainServer.lua`
- Rename scripts so InitializeRemotes loads first alphabetically
- Or make InitializeRemotes a ModuleScript required by MainServer

---

## 📊 Testing Checklist

Use this to verify all features work:

### Core Systems
- [ ] Game loads without errors
- [ ] All 8 server modules initialize
- [ ] All client modules initialize
- [ ] UI appears and functions

### Pet System
- [ ] Can open Pet Menu (E key)
- [ ] Can hatch eggs (costs currency)
- [ ] Pets appear and follow player
- [ ] Can equip up to 3 pets
- [ ] Shiny pets possible (1/1000 chance)

### Currency
- [ ] Coins display updates
- [ ] Gems display updates
- [ ] Currency persists (with DataStore enabled)

### Tower Defense
- [ ] Can open Tower Defense window
- [ ] Can start waves
- [ ] Enemies spawn (check Output)
- [ ] Waves complete with rewards

### Tycoon
- [ ] Can open Tycoon window
- [ ] Can purchase buildings
- [ ] Income generates every 5 seconds
- [ ] Can collect income

### Trading
- [ ] Can send trade request to another player
- [ ] Trade window opens
- [ ] Can add/remove pets
- [ ] Trade confirmation works

### Obby
- [ ] Obby courses exist in Workspace/Obbies
- [ ] Can start obby
- [ ] Checkpoints work
- [ ] Completion gives rewards

### Security (2025)
- [ ] Rate limiting triggers on spam
- [ ] Invalid data rejected
- [ ] Suspicious activity logged
- [ ] Auto-kick works (10+ violations)

### UI/UX
- [ ] All windows open/close smoothly
- [ ] Keyboard shortcuts work (E, Q, T, ESC)
- [ ] Mobile controls work (if testing on tablet)
- [ ] Notifications appear

---

## 🎯 Next Steps After Testing

Once everything works in Studio:

1. **Customize Assets**
   - Replace sound IDs in `SoundManager.lua`
   - Add 3D pet models to `PetData.lua`
   - Build obby courses in Workspace/Obbies
   - Create tower defense paths

2. **Create Developer Products**
   - Go to create.roblox.com
   - Your game → Monetization → Developer Products
   - Create gem packs
   - Update Product IDs in `Config.lua`

3. **DataStore Version**
   - For testing: Use "PlayerData_TEST_V1"
   - For production: Use "PlayerData_PROD_V1"
   - Update in `DataManager.lua`

4. **Publish Place**
   - File → Publish to Roblox
   - Choose "Create new game" or existing place
   - Set to Private for initial testing

5. **Follow Deployment Guide**
   - See `DEPLOYMENT_GUIDE_2025.md`
   - Complete pre-launch checklist
   - Test with friends
   - Launch publicly

---

## 🔥 Quick Troubleshooting Commands

**Useful Command Bar commands for testing:**

```lua
-- Give yourself currency
local player = game.Players.LocalPlayer
game:GetService("ReplicatedStorage").Remotes.UpdateCurrency:FireClient(player, "Coins", 100000)
game:GetService("ReplicatedStorage").Remotes.UpdateCurrency:FireClient(player, "Gems", 1000)

-- Force hatch rare pet
game:GetService("ReplicatedStorage").Remotes.HatchEgg:FireServer("MysticEgg")

-- Teleport to spawn
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 3, 0)

-- Clear DataStore (testing only)
local DataStoreService = game:GetService("DataStoreService")
local store = DataStoreService:GetDataStore("PlayerData_PROD_V1")
store:RemoveAsync("Player_" .. game.Players.LocalPlayer.UserId)

-- Check security violations
local SecurityManager = require(game.ServerScriptService.Modules.SecurityManager)
print(SecurityManager:GetViolationCount(game.Players.LocalPlayer))
```

---

## 📚 Additional Resources

- **Official Docs**: [create.roblox.com/docs](https://create.roblox.com/docs)
- **DevForum**: [devforum.roblox.com](https://devforum.roblox.com)
- **This Project Docs**: See all `.md` files in project folder
- **Deployment Guide**: `DEPLOYMENT_GUIDE_2025.md`
- **Security Guide**: `ServerScriptService/Modules/SecurityManager.md`

---

## ✅ Success Criteria

Your import is successful when:

✅ Game loads in Studio without errors
✅ All initialization messages appear in Output
✅ UI appears and is interactive
✅ Can hatch pets and see them follow player
✅ Can open all windows (E, Q, T, ESC)
✅ Security system logs violations
✅ No red errors in Output window

**Congratulations! Your game is ready for testing!** 🎉

---

## 💡 Pro Tips

1. **Save Often**: Ctrl+S or File → Save
2. **Use Output**: Most debugging info is here
3. **Test in Play Solo**: F5 to start, Shift+F5 to stop
4. **Test Multiplayer**: Use "Test" tab → Start Server + Players
5. **Commit Often**: Use Git to save progress
6. **Read Error Messages**: They usually tell you exactly what's wrong

---

*Happy Game Development! 🚀*

*For issues, check DEPLOYMENT_GUIDE_2025.md or game documentation*

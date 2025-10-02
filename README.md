# Pet Kingdom Defenders

🎮 **A hybrid Roblox game combining the most popular mechanics of 2025**

[![Roblox](https://img.shields.io/badge/Roblox-Game-00b2ff?style=for-the-badge&logo=roblox)](https://www.roblox.com)
[![Lua](https://img.shields.io/badge/Lua-5.1-blue?style=for-the-badge&logo=lua)](https://www.lua.org)

## 🌟 Overview

Pet Kingdom Defenders is a comprehensive Roblox game that combines the most successful and trending game mechanics from 2025:

- 🐾 **Pet Collection & Evolution System** - Hatch, collect, and evolve pets with unique abilities
- 🏰 **Tower Defense** - Use pets to defend against waves of enemies
- 🏗️ **Tycoon/Base Building** - Build your kingdom with automated income generation
- 🏃 **Parkour/Obby Courses** - Train your pets through obstacle courses
- 💎 **Trading System** - Trade pets with other players safely
- 🎉 **Seasonal Events** - Regular updates with limited-time content and rewards
- 💰 **Economy System** - Balanced progression with dual currency (Coins & Gems)

## 🎯 Game Concept

Based on extensive market research of the most popular Roblox games in 2025, Pet Kingdom Defenders combines:

- **Pet Simulator mechanics** (fastest game to reach 1B visits in 2025)
- **Tower Defense gameplay** (trending with anime-themed units)
- **Tycoon progression** (automated income + unlockables)
- **Obby/Parkour** (timeless classic mechanic)
- **Social trading** (proven engagement driver)

## 📁 Project Structure

```
Pet Kingdom Defenders/
├── ServerScriptService/          # Server-side game logic
│   ├── MainServer.lua            # Main server controller
│   ├── InitializeRemotes.lua     # Remote events setup
│   └── Modules/                  # Server modules
│       ├── DataManager.lua       # Player data & DataStore
│       ├── PetSystem.lua         # Pet hatching & management
│       ├── TowerDefenseManager.lua
│       ├── TycoonManager.lua     # Base building
│       ├── EconomyManager.lua    # Currency & monetization
│       ├── TradingSystem.lua     # P2P trading
│       ├── ObbyManager.lua       # Parkour courses
│       └── EventManager.lua      # Seasonal events
│
├── ReplicatedStorage/            # Shared resources
│   ├── Shared/                   # Shared modules
│   │   ├── Config.lua           # Game configuration
│   │   ├── PetData.lua          # Pet definitions
│   │   └── Utils.lua            # Utility functions
│   └── Remotes/
│       └── RemotesSetup.lua     # Creates all RemoteEvents
│
├── StarterPlayer/
│   └── StarterPlayerScripts/    # Client-side logic
│       ├── MainClient.lua       # Main client controller
│       └── Modules/
│           ├── UIManager.lua    # UI control
│           ├── InputManager.lua # Input handling
│           ├── CameraController.lua
│           ├── SoundManager.lua
│           └── NotificationManager.lua
│
├── StarterGui/
│   └── MainUI.lua              # UI structure creation
│
└── README.md                   # This file
```

## 🎮 Core Features

### 🐾 Pet System
- **25+ Unique Pets** across 5 rarity tiers (Common → Legendary)
- **Weighted Rarity System**: Common (50%), Uncommon (30%), Rare (15%), Epic (4%), Legendary (1%)
- **0.1% Shiny Chance** for golden variants
- **Pet Evolution**: Increase power multipliers with coins
- **Pet Abilities**: Unique skills for combat, economy, and support
- **4 Egg Types**: Basic (500 coins), Golden (2.5K coins), Mystic (100 gems), Legendary (500 gems)

### 🏰 Tower Defense
- **Wave-Based Combat**: Progressively harder waves with scaling rewards
- **Pet-Powered Towers**: Place pets as towers with unique abilities
- **Dynamic Difficulty**: Enemy count, health, and speed scale with wave number
- **Strategic Placement**: Range and damage based on pet stats
- **Rewards**: Coins, XP, and progression toward achievements

### 🏗️ Tycoon System
- **7 Progressive Buildings**: From Basic Spawner to Pet Factory
- **Passive Income**: Earn coins over time (10/sec → 1000/sec)
- **Building Prerequisites**: Unlock in sequence
- **Personal Base**: Unique location per player
- **Automated Generation**: 5-second income intervals

### 🏃 Parkour/Obby System
- **7 Difficulty Tiers**: Easy → Extreme
- **Level Requirements**: Unlock harder courses as you level up
- **Time Challenges**: Beat par time for 50% bonus rewards
- **Pet Training**: Equipped pets gain +0.01 power per completion
- **Personal Records**: Track best times per obby

### 💎 Trading System
- **Safe P2P Trading**: Dual confirmation required
- **4 Items Per Side**: Trade up to 4 pets
- **Real-Time Updates**: Both players see changes instantly
- **Anti-Scam Protection**: Ownership verification and confirmation system
- **Trade Statistics**: Track total trades completed

### 🎉 Events System
- **Seasonal Events**: Summer Festival, Winter Wonderland
- **Weekend Events**: Double Coins, Special Multipliers
- **Event Rewards**: Exclusive pets and items
- **Seasonal Atmosphere**: Dynamic lighting and decorations
- **Auto-Detection**: Events activate based on real-world calendar

## 💰 Economy & Monetization

### Currency Types
- **Coins** (Primary): Earned through gameplay
- **Gems** (Premium): Purchased with Robux or earned through achievements

### Monetization Strategy
- **Gem Packs**: 100 gems (100 Robux) → 1000 gems (700 Robux)
- **Value Bundles**: Gems + Coins packages
- **Fair Free-to-Play**: All content accessible without paying
- **Daily Login Rewards**: Streak-based bonuses
- **Achievement Rewards**: Long-term engagement incentives

### Progression Balance
```lua
-- Level Experience Formula
ExpRequired = 100 * level * (level + 1) / 2

-- Building Costs
Basic Spawner: 1,000 coins (10/sec)
Pet Factory: 100,000 coins (1000/sec)

-- Egg Costs
Basic: 500 coins
Legendary: 500 gems
```

## 📊 Data Management

### Player Data Structure
```lua
{
    -- Currency
    Coins, Gems,

    -- Pets
    Pets = {Pet[]},
    EquippedPets = {petId[]},

    -- Progression
    Level, Experience, TotalPlayTime,

    -- Tycoon
    TycoonLevel, UnlockedBuildings,

    -- Tower Defense
    HighestWave, TotalEnemiesDefeated,

    -- Obby
    CompletedObbies, BestObbyTimes,

    -- Statistics
    TotalPetsHatched, TotalTradesCompleted,
    LoginStreak, LastLogin,

    -- Settings
    Settings = {MusicEnabled, SFXEnabled, ...}
}
```

### Data Persistence
- **Primary DataStore**: `PlayerData_V1`
- **Backup DataStore**: `PlayerDataBackup_V1`
- **Auto-Save**: Every 5 minutes
- **Save on Leave**: Guaranteed save when player disconnects
- **Offline Mode**: Graceful fallback if DataStore unavailable

## 🎨 UI/UX Design

### Mobile-Optimized
- **80% Mobile Players**: Designed for touch-first experience
- **Responsive Layout**: Adapts to all screen sizes
- **Large Touch Targets**: Buttons sized for easy tapping
- **Simplified Controls**: Streamlined for mobile gameplay

### UI Features
- **Smooth Animations**: 0.3s tweens with easing
- **Toast Notifications**: Color-coded feedback (success/error/info/special)
- **Window System**: Organized menu structure
- **Event Banners**: Prominent event notifications
- **Achievement Popups**: Celebratory reward displays

### Keyboard Shortcuts
- **E**: Pets Menu
- **Q**: Shop
- **T**: Trading
- **ESC**: Settings

## 🔊 Audio System

### Sound Effects
- Pet Hatch, Level Up, Achievement Unlocked
- Coin Collect, Button Click
- Victory, Defeat

### Background Music
- Looping ambient music
- Volume controls (Music/SFX toggle)
- Persistent settings

## 🚀 Getting Started

### For Developers

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   ```

2. **Open in Roblox Studio**
   - Open Roblox Studio
   - File → Open from File
   - Select the project folder

3. **Configure DataStores**
   - Enable Studio API Access
   - Configure DataStore settings

4. **Run the Game**
   - Press F5 or click Play
   - Test all systems

### For Players

1. Visit the game on Roblox
2. Start hatching pets and building your kingdom
3. Complete obbies to train your pets
4. Defend against waves of enemies
5. Trade with other players
6. Participate in seasonal events

## 📋 System Requirements

### Server-Side
- Roblox Server (automatic)
- DataStore API access
- MarketplaceService (for purchases)

### Client-Side
- **Desktop**: Windows, Mac, or Linux with Roblox
- **Mobile**: iOS 11+ or Android 5.0+
- **Memory**: Optimized for low-end devices
- **Internet**: Stable connection required

## 🔧 Configuration

### Game Balance (Config.lua)
```lua
-- Adjust these values to tune difficulty
MAX_EQUIPPED_PETS = 3
TD_BASE_HEALTH = 100
TD_ENEMY_SPEED = 5
UI_ANIMATION_SPEED = 0.3
```

### Pet Data (PetData.lua)
Add new pets by defining:
```lua
PetName = {
    Name = "Display Name",
    Rarity = "Common|Uncommon|Rare|Epic|Legendary",
    BasePower = number,
    BaseSpeed = number,
    Ability = "Ability Name",
    AbilityDescription = "What it does"
}
```

## 📈 Success Metrics

Based on 2025 Roblox trends:
- **Mobile Optimization**: 80% of players use mobile
- **Rapid Updates**: Weekly content updates maintain engagement
- **Pet Collection**: Proven mechanic with highest retention
- **Social Features**: Trading increases session time
- **Events**: Seasonal content drives return visits
- **Fair Monetization**: Non-pay-to-win increases player lifetime value

## 🏆 Achievements System

```lua
First Friend: Hatch your first pet (500 coins, 10 gems)
Pet Collector: Hatch 10 pets (2K coins, 25 gems)
Pet Master: Hatch 50 pets (10K coins, 100 gems)
Defender: Complete wave 10 (2.5K coins, 25 gems)
Elite Defender: Complete wave 50 (25K coins, 250 gems)
Trader: Complete first trade (1K coins, 20 gems)
Parkour Pro: Complete all obbies (50K coins, 500 gems)
```

## 🛠️ Development Roadmap

### Phase 1 (Current) ✅
- Core pet system
- Tower defense gameplay
- Tycoon mechanics
- Trading system
- Obby courses
- Events system

### Phase 2 (Planned)
- Boss battles
- Pet breeding system
- Guild/Clan system
- PvP arena
- Leaderboards
- More pets and eggs

### Phase 3 (Future)
- Raid dungeons
- World events
- Cross-server trading
- Pet cosmetics
- Story mode

## 📝 Documentation

Each file has a corresponding `.md` documentation file:
- `MainServer.lua` → `MainServer.md`
- `DataManager.lua` → `DataManager.md`
- etc.

Refer to individual documentation files for detailed system information.

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is for educational purposes. Roblox and associated trademarks are property of Roblox Corporation.

## 🎯 Target Audience

- **Primary**: Ages 8-16
- **Secondary**: Ages 17-25 (nostalgia players)
- **Play Style**: Casual to hardcore collectors
- **Session Length**: 15-60 minutes average

## 📊 Analytics Integration

Track key metrics:
- Daily Active Users (DAU)
- Average Session Time
- Pets Hatched per Player
- Trade Volume
- Wave Completion Rate
- Obby Success Rate
- Revenue per Paying User (ARPPU)

## 🔐 Security Considerations

- **Server Authority**: All game logic on server
- **Anti-Exploit**: Validation on all remote calls
- **Trade Security**: Dual confirmation prevents scams
- **Data Validation**: Sanity checks on all player data
- **Rate Limiting**: Prevent spam/abuse

## 🌐 Localization (Future)

Planned language support:
- English (default)
- Spanish
- Portuguese
- French
- German
- Japanese
- Korean

## 📞 Support

For issues or questions:
- Check documentation files
- Review Config.lua for settings
- Check Roblox DevForum
- Create an issue on GitHub

---

## 🎮 Start Playing Today!

Visit [Roblox.com](https://www.roblox.com) to play Pet Kingdom Defenders and join thousands of players building their pet kingdoms!

**Built with ❤️ using Roblox Studio and Lua**

*Last Updated: 2025*

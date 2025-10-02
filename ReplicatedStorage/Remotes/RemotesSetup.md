# RemotesSetup.lua

## Overview
Creates all RemoteEvent instances for client-server communication. Centralizes remote creation for organization and maintainability.

## Purpose
- Create Remotes folder in ReplicatedStorage
- Generate all needed RemoteEvents
- Organize communication channels
- Prevent missing remotes errors

## Remote Events Created

### Pet System (8 remotes)
- **HatchEgg**: Client → Server (request egg hatch)
- **HatchResult**: Server → Client (hatch result + pet data)
- **EquipPet**: Client → Server (equip pet request)
- **EquipResult**: Server → Client (equip confirmation)
- **UnequipPet**: Client → Server (unequip request)
- **UnequipResult**: Server → Client (unequip confirmation)
- **EvolvePet**: Client → Server (evolution request)
- **EvolveResult**: Server → Client (evolution result)

### Currency (1 remote)
- **UpdateCurrency**: Server → Client (currency changed)

### Player Progression (1 remote)
- **LevelUp**: Server → Client (level up notification)

### Tower Defense (8 remotes)
- **StartWave**: Client → Server (start wave request)
- **WaveStarted**: Server → Client (wave begun)
- **PlaceTower**: Client → Server (place pet as tower)
- **TowerPlaced**: Server → Client (tower placed confirmation)
- **EnemySpawned**: Server → Client (new enemy data)
- **EnemyRemoved**: Server → Client (enemy defeated/reached end)
- **WaveComplete**: Server → Client (wave finished + rewards)
- **GameOver**: Server → Client (game ended)

### Tycoon (5 remotes)
- **PurchaseBuilding**: Client → Server (buy building)
- **PurchaseResult**: Server → Client (purchase outcome)
- **CollectIncome**: Client → Server (collect pending income)
- **IncomeGenerated**: Server → Client (income accumulated)
- **IncomeCollected**: Server → Client (income collected)

### Trading (12 remotes)
- **SendTradeRequest**: Client → Server (initiate trade)
- **TradeRequest**: Server → Client (trade invitation)
- **AcceptTradeRequest**: Client → Server (accept trade)
- **TradeAccepted**: Server → Client (trade active)
- **DeclineTradeRequest**: Client → Server (decline trade)
- **TradeDeclined**: Server → Client (trade rejected)
- **AddTradeItem**: Client → Server (add pet to offer)
- **RemoveTradeItem**: Client → Server (remove pet from offer)
- **TradeUpdated**: Server → Client (trade state changed)
- **ConfirmTrade**: Client → Server (confirm trade)
- **CancelTrade**: Client → Server (cancel trade)
- **TradeCancelled**: Server → Client (trade cancelled)
- **TradeCompleted**: Server → Client (trade executed)
- **TradeError**: Server → Client (trade error message)

### Obby (5 remotes)
- **StartObby**: Client → Server (begin obby run)
- **ObbyStarted**: Server → Client (run started)
- **CheckpointReached**: Client → Server (hit checkpoint)
- **CompleteObby**: Client → Server (finished obby)
- **ObbyCompleted**: Server → Client (completion + rewards)
- **ObbyError**: Server → Client (error message)

### Events (6 remotes)
- **ClaimEventReward**: Client → Server (claim reward)
- **EventStarted**: Server → Client (event began)
- **EventEnded**: Server → Client (event finished)
- **EventRewardClaimed**: Server → Client (reward claimed)
- **EventError**: Server → Client (error message)
- **SeasonChanged**: Server → Client (season update)

### Economy (4 remotes)
- **ClaimDailyBonus**: Client → Server (claim daily)
- **DailyBonusAvailable**: Server → Client (bonus ready)
- **DailyBonusClaimed**: Server → Client (bonus claimed)
- **AchievementUnlocked**: Server → Client (achievement earned)

**Total: 58 RemoteEvents**

## File Structure
```
ReplicatedStorage
└── Remotes (Folder)
    ├── HatchEgg (RemoteEvent)
    ├── HatchResult (RemoteEvent)
    ├── EquipPet (RemoteEvent)
    └── ... (55 more)
```

## Usage Pattern

### Server-side
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Listen for client request
ReplicatedStorage.Remotes.HatchEgg.OnServerEvent:Connect(function(player, eggType)
    -- Handle hatch
end)

-- Send to client
ReplicatedStorage.Remotes.HatchResult:FireClient(player, success, petData)
```

### Client-side
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Send to server
ReplicatedStorage.Remotes.HatchEgg:FireServer("BasicEgg")

-- Listen for server response
ReplicatedStorage.Remotes.HatchResult.OnClientEvent:Connect(function(success, petData)
    -- Handle result
end)
```

## Initialization

### InitializeRemotes.lua
Separate script in ServerScriptService:
```lua
local RemotesSetup = require(ReplicatedStorage.Remotes.RemotesSetup)
```

Runs before MainServer.lua to ensure remotes exist.

## Security Considerations
- Server validates all client requests
- Client cannot fire server-to-client events
- Rate limiting on server side (not shown)
- Sanity checks on all parameters

## Benefits of Centralized Creation
1. **Single Source**: All remotes in one file
2. **Easy Management**: Add/remove remotes easily
3. **No Duplicates**: Checks if remote exists
4. **Organization**: Grouped by system
5. **Documentation**: Clear list of all communications

## Error Prevention
```lua
if not remotesFolder:FindFirstChild(remoteName) then
    -- Create only if missing
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = remoteName
    remoteEvent.Parent = remotesFolder
end
```

Prevents duplicate creation errors.

## Logging
Each remote creation is logged:
```
[RemotesSetup] Created RemoteEvent: HatchEgg
[RemotesSetup] Created RemoteEvent: HatchResult
...
[RemotesSetup] All remotes created successfully!
```

## RemoteFunction vs RemoteEvent
Currently uses **only RemoteEvents**:
- Fire-and-forget communication
- No blocking calls
- Better for game flow
- Simpler error handling

RemoteFunctions can be added for:
- Get requests (data retrieval)
- Synchronous operations
- Return values needed

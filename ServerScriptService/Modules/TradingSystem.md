# TradingSystem.lua

## Overview
Peer-to-peer trading system allowing players to exchange pets safely with verification and confirmation steps.

## Purpose
- Facilitate safe pet trading between players
- Prevent scams with dual confirmation
- Track trade statistics
- Manage trade lifecycle

## Trade State Structure
```lua
{
    Id = string,                -- Trade GUID
    Player1 = Player,
    Player2 = Player,
    Player1Items = {petId[]},
    Player2Items = {petId[]},
    Player1Confirmed = boolean,
    Player2Confirmed = boolean,
    Status = "pending"|"active"|"completed"
}
```

## Trade Flow
1. **Request**: Player1 sends trade request to Player2
2. **Accept/Decline**: Player2 accepts or declines
3. **Active**: Both players add/remove pets
4. **Confirm**: Both players confirm trade
5. **Execute**: Pets transferred when both confirmed
6. **Complete**: Trade cleaned up

## Key Functions

### `Initialize()`
Sets up all trade-related remote events.

### `SendTradeRequest(player, targetPlayer)`
- Validates both players available
- Prevents self-trading
- Creates pending trade
- Sends request to target player

### `AcceptTradeRequest(player, tradeId)`
- Validates trade exists
- Sets status to "active"
- Links both players to trade
- Opens trade window for both

### `DeclineTradeRequest(player, tradeId)`
- Notifies requester
- Cleans up trade data

### `AddTradeItem(player, tradeId, petId)`
- Verifies pet ownership
- Checks max items limit (4 per side)
- Adds to appropriate player's items
- Resets confirmations
- Updates both players

### `RemoveTradeItem(player, tradeId, petId)`
- Removes from trade offer
- Resets confirmations
- Updates both players

### `ConfirmTrade(player, tradeId)`
- Sets player's confirmation flag
- Updates UI for both players
- Executes trade if both confirmed

### `ExecuteTrade(tradeId)`
Critical function that:
- Validates both player data
- Transfers pets from Player1 to Player2
- Transfers pets from Player2 to Player1
- Updates trade statistics
- Notifies both players
- Cleans up trade data

### `CancelTrade(player, tradeId)`
- Notifies both players
- Cleans up trade data

### `CancelActiveTrades(player)`
Called when player leaves:
- Cancels any active trades
- Prevents trade data loss

## Security Features
- **Ownership Verification**: Validates pet ownership before adding
- **Dual Confirmation**: Both players must confirm
- **Max Items Limit**: 4 items per side prevents spam
- **Trade Locking**: One trade at a time per player
- **Cancel on Leave**: Automatic cleanup

## Trade Statistics
Tracks:
- `TotalTradesCompleted` per player
- Can be used for achievements
- Leaderboard data

## Error Handling
Specific error messages for:
- Player not found
- Self-trading attempt
- Already in trade
- Pet not owned
- Maximum items reached

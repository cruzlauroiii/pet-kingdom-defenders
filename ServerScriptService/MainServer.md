# MainServer.lua

## Overview
Main server-side script that initializes all game systems and manages the core game loop for Pet Kingdom Defenders.

## Purpose
- Initializes all server-side managers and systems
- Handles player join/leave events
- Manages data persistence and auto-save functionality
- Coordinates between different game systems

## Key Systems Initialized
1. **DataManager** - Player data storage and retrieval
2. **PetSystem** - Pet hatching, evolution, and management
3. **TowerDefenseManager** - Wave-based enemy combat
4. **TycoonManager** - Base building and passive income
5. **EconomyManager** - Currency and monetization
6. **TradingSystem** - Peer-to-peer pet trading
7. **ObbyManager** - Parkour course challenges
8. **EventManager** - Seasonal events and limited-time content

## Functions

### `initializeSystems()`
Initializes all game systems in the correct order.

### `onPlayerAdded(player)`
Called when a player joins the game:
- Loads player data from DataStore
- Initializes player-specific systems
- Awards daily login bonuses

### `onPlayerRemoving(player)`
Called when a player leaves:
- Saves player data
- Cleans up player resources
- Cancels active trades

### `onServerShutdown()`
Saves all player data when server shuts down.

## Auto-Save System
Automatically saves all player data every 5 minutes to prevent data loss.

## Dependencies
- DataManager
- PetSystem
- TowerDefenseManager
- TycoonManager
- EconomyManager
- TradingSystem
- ObbyManager
- EventManager
- Config
- Utils

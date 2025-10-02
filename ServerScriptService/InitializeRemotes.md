# InitializeRemotes.lua

## Overview
Simple initialization script that creates all RemoteEvents before the main server starts. Ensures communication channels are ready.

## Purpose
- Run RemotesSetup module
- Create all remote events early
- Prevent "remote not found" errors
- Log initialization status

## Execution Order
```
1. InitializeRemotes.lua (this script)
   ↓
2. RemotesSetup.lua (creates remotes)
   ↓
3. MainServer.lua (uses remotes)
```

## Code
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Run the remotes setup
local RemotesSetup = require(ReplicatedStorage.Remotes.RemotesSetup)

print("[InitializeRemotes] All remotes initialized!")
```

## Why Separate Script?
1. **Clear Separation**: Initialization vs logic
2. **Load Order**: Guarantees remotes exist first
3. **Modularity**: Can disable/modify easily
4. **Debugging**: Clear initialization point

## Script Properties
In Roblox Studio:
- **RunContext**: Server
- **Parent**: ServerScriptService
- **Run Before**: MainServer.lua

## Error Handling
If RemotesSetup fails:
```
[RemotesSetup] Could not create remote: [reason]
[InitializeRemotes] All remotes initialized!  -- May be incomplete
```

Check output for any creation errors.

## Dependencies
- **ReplicatedStorage**: Must exist
- **RemotesSetup module**: Must be in ReplicatedStorage/Remotes/

## Testing
To verify remotes created:
```lua
-- In Studio command bar
local remotes = game.ReplicatedStorage.Remotes:GetChildren()
for _, remote in ipairs(remotes) do
    print(remote.Name, remote.ClassName)
end
```

Should print 58 RemoteEvents.

## Common Issues

### Issue: "Remotes not found"
**Solution**: Ensure InitializeRemotes runs before MainServer

### Issue: "RemotesSetup module not found"
**Solution**: Check RemotesSetup.lua is in correct location

### Issue: "Some remotes missing"
**Solution**: Check RemotesSetup completion logs

## Load Order Management
In ServerScriptService:
```
ServerScriptService
├── InitializeRemotes.lua  (RunContext: Server, runs first)
├── MainServer.lua         (RunContext: Server, runs after)
└── Modules/
```

Roblox runs scripts alphabetically, but InitializeRemotes should run via require before MainServer uses them.

## Alternative: Using Script.Parent
Could also use:
```lua
script.Parent:WaitForChild("MainServer")
```
But current approach is cleaner.

## Production Considerations
- Could add retry logic
- Validate all remotes created
- Error if setup fails (prevent broken game)
- Telemetry/analytics

## Future Enhancements
```lua
-- Validate all remotes exist
local requiredRemotes = {
    "HatchEgg", "HatchResult", -- etc
}

for _, remoteName in ipairs(requiredRemotes) do
    local remote = ReplicatedStorage.Remotes:FindFirstChild(remoteName)
    if not remote then
        error("[InitializeRemotes] Critical remote missing: " .. remoteName)
    end
end
```

This ensures game doesn't run with incomplete setup.

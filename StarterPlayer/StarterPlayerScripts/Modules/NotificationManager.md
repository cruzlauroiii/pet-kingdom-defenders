# NotificationManager.lua

## Overview
Displays toast-style notifications to inform players of events, rewards, errors, and updates.

## Purpose
- Show temporary messages
- Queue multiple notifications
- Animate in/out smoothly
- Color-code by type
- Auto-dismiss after duration

## Notification Types
1. **success** - Green (achievements, rewards, completions)
2. **error** - Red (failures, insufficient funds, errors)
3. **info** - Blue (general information, tips)
4. **special** - Gold (events, rare occurrences)

## Notification Structure
```lua
{
    Message = string,
    Type = "success"|"error"|"info"|"special"
}
```

## Key Functions

### `Initialize()`
- Gets NotificationContainer reference
- Prepares notification system
- Logs initialization

### `Show(message, notificationType)`
Public interface:
- Adds notification to queue
- Defaults to "info" if no type
- Triggers queue processing if idle

**Usage:**
```lua
NotificationManager:Show("Pet hatched!", "success")
NotificationManager:Show("Not enough coins", "error")
NotificationManager:Show("Event started!", "special")
```

### `ProcessQueue()`
Queue processor:
1. Gets next notification
2. Creates notification frame
3. Animates in
4. Waits 3 seconds
5. Animates out
6. Processes next (recursive)

### `CreateNotificationFrame(notification): Frame`
Creates notification UI:
- 300x60 frame
- Rounded corners (8px)
- Colored background
- Bold text label
- Positioned top-right (off-screen initially)

### `GetNotificationColor(notificationType): Color3`
Returns color for type:
- **success**: RGB(50, 200, 50) - Green
- **error**: RGB(200, 50, 50) - Red
- **info**: RGB(50, 150, 250) - Blue
- **special**: RGB(255, 200, 50) - Gold

### `AnimateIn(frame)`
Slide in animation:
```lua
Start: X = 1 (off right side)
  ↓
End: X = 1, -320 (visible right side)
Duration: 0.3s
Easing: Back Out (bounce)
```

### `AnimateOut(frame)`
Slide out animation:
```lua
Start: X = 1, -320 (visible)
  ↓
End: X = 1 (off right side)
Duration: 0.3s
Easing: Back In
Then: Destroy frame
```

## Queue System

### How It Works
```lua
Notification 1 added → ProcessQueue starts
  ↓
Show Notification 1 (3s)
  ↓
Notification 2 added → Queued
  ↓
Notification 1 finishes
  ↓
Show Notification 2 (3s)
  ↓
Queue empty → Idle
```

### Queue Properties
- **FIFO**: First in, first out
- **Sequential**: One at a time
- **Non-blocking**: Adding is instant
- **Recursive**: Auto-processes

## Display Duration
- **Show**: 3 seconds
- **Transition**: 0.3 seconds in/out
- **Total**: ~3.6 seconds per notification

## Integration Examples

### Success Notification
```lua
-- Pet hatched
NotificationManager:Show("Hatched: " .. petName, "success")

-- Level up
NotificationManager:Show("Level Up! Now Level " .. level, "success")

-- Trade complete
NotificationManager:Show("Trade completed successfully!", "success")
```

### Error Notification
```lua
-- Insufficient funds
NotificationManager:Show("Not enough coins!", "error")

-- Invalid action
NotificationManager:Show("Cannot do that right now", "error")

-- Trade failed
NotificationManager:Show("Trade cancelled", "error")
```

### Info Notification
```lua
-- Game tips
NotificationManager:Show("Press E to open Pet Menu", "info")

-- Status updates
NotificationManager:Show("Auto-save complete", "info")
```

### Special Notification
```lua
-- Events
NotificationManager:Show("Event Started: " .. eventName, "special")

-- Rare occurrences
NotificationManager:Show("Shiny Pet Hatched!", "special")
```

## UI Positioning
```lua
Position: UDim2.new(1, -320, 0, 20)
```
- Right side of screen
- 320px from right edge
- 20px from top
- Stacks if multiple (future enhancement)

## Performance Considerations
- **Max Queue Size**: Unlimited (but sequential display)
- **Frame Cleanup**: Auto-destroyed after animation
- **Memory**: No leaks (proper cleanup)
- **Timing**: Uses task.wait (non-blocking)

## Accessibility
- **High Contrast**: Clear colors
- **Bold Text**: GothamBold font
- **Large Size**: 300x60 readable
- **Animation**: Attention-grabbing but not jarring

## Future Enhancements
- Stack multiple notifications
- Priority system (critical vs normal)
- Persistent notifications (requires dismiss)
- Custom icons
- Sound integration
- Rich text formatting

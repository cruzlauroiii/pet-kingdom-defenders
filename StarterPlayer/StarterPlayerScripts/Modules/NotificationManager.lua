--[[
	NotificationManager - Displays toast notifications to players
	Supports different notification types (success, error, info, special)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local NotificationManager = {}
NotificationManager.NotificationQueue = {}
NotificationManager.ActiveNotification = nil

function NotificationManager:Initialize()
	print("[NotificationManager] Initializing...")

	-- Create notification container if it doesn't exist
	local mainUI = playerGui:WaitForChild("MainUI", 10)
	if mainUI then
		self.NotificationContainer = mainUI:FindFirstChild("NotificationContainer")
	end

	print("[NotificationManager] Initialized successfully!")
end

-- Show notification
function NotificationManager:Show(message, notificationType)
	notificationType = notificationType or "info"

	-- Add to queue
	table.insert(self.NotificationQueue, {
		Message = message,
		Type = notificationType
	})

	-- Process queue if not already showing a notification
	if not self.ActiveNotification then
		self:ProcessQueue()
	end
end

-- Process notification queue
function NotificationManager:ProcessQueue()
	if #self.NotificationQueue == 0 then
		self.ActiveNotification = nil
		return
	end

	local notification = table.remove(self.NotificationQueue, 1)
	self.ActiveNotification = notification

	-- Create notification UI
	local notificationFrame = self:CreateNotificationFrame(notification)

	-- Show animation
	self:AnimateIn(notificationFrame)

	-- Wait and hide
	task.wait(3)

	self:AnimateOut(notificationFrame)

	-- Process next in queue
	task.wait(0.5)
	self:ProcessQueue()
end

-- Create notification frame
function NotificationManager:CreateNotificationFrame(notification)
	if not self.NotificationContainer then
		return nil
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 60)
	frame.Position = UDim2.new(1, -320, 0, 20)
	frame.BackgroundColor3 = self:GetNotificationColor(notification.Type)
	frame.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -20, 1, -20)
	textLabel.Position = UDim2.new(0, 10, 0, 10)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = notification.Message
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = frame

	frame.Parent = self.NotificationContainer

	return frame
end

-- Get color based on notification type
function NotificationManager:GetNotificationColor(notificationType)
	local colors = {
		success = Color3.fromRGB(50, 200, 50),
		error = Color3.fromRGB(200, 50, 50),
		info = Color3.fromRGB(50, 150, 250),
		special = Color3.fromRGB(255, 200, 50)
	}

	return colors[notificationType] or colors.info
end

-- Animate notification in
function NotificationManager:AnimateIn(frame)
	if not frame then return end

	frame.Position = UDim2.new(1, 0, 0, 20)

	local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -320, 0, 20)
	})

	tween:Play()
end

-- Animate notification out
function NotificationManager:AnimateOut(frame)
	if not frame then return end

	local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Position = UDim2.new(1, 0, 0, 20)
	})

	tween:Play()

	tween.Completed:Connect(function()
		frame:Destroy()
	end)
end

return NotificationManager

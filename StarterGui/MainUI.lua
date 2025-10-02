--[[
	MainUI - Main UI structure setup script
	Creates all UI elements programmatically for the game
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
local mainUI = Instance.new("ScreenGui")
mainUI.Name = "MainUI"
mainUI.ResetOnSpawn = false
mainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create HUD frame
local hud = Instance.new("Frame")
hud.Name = "HUD"
hud.Size = UDim2.new(1, 0, 1, 0)
hud.BackgroundTransparency = 1
hud.Parent = mainUI

-- Currency display
local function createCurrencyDisplay(name, position, icon)
	local frame = Instance.new("Frame")
	frame.Name = name .. "Display"
	frame.Size = UDim2.new(0, 150, 0, 40)
	frame.Position = position
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	frame.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(0, 30, 0, 30)
	iconLabel.Position = UDim2.new(0, 5, 0, 5)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = icon
	iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextScaled = true
	iconLabel.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = name .. "Label"
	valueLabel.Size = UDim2.new(1, -40, 1, 0)
	valueLabel.Position = UDim2.new(0, 40, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = "0"
	valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextScaled = true
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.Parent = frame

	frame.Parent = hud
	return frame
end

createCurrencyDisplay("Coins", UDim2.new(0, 10, 0, 10), "💰")
createCurrencyDisplay("Gems", UDim2.new(0, 170, 0, 10), "💎")

-- Bottom menu buttons
local function createMenuButton(name, position, text)
	local button = Instance.new("TextButton")
	button.Name = name .. "Button"
	button.Size = UDim2.new(0, 100, 0, 50)
	button.Position = position
	button.AnchorPoint = Vector2.new(0.5, 1)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextScaled = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	button.Parent = hud
	return button
end

createMenuButton("Pet", UDim2.new(0.2, 0, 1, -10), "Pets")
createMenuButton("Shop", UDim2.new(0.35, 0, 1, -10), "Shop")
createMenuButton("Tycoon", UDim2.new(0.5, 0, 1, -10), "Tycoon")
createMenuButton("TowerDefense", UDim2.new(0.65, 0, 1, -10), "Tower Defense")
createMenuButton("Trade", UDim2.new(0.8, 0, 1, -10), "Trade")

-- Settings button (top right)
createMenuButton("Settings", UDim2.new(1, -60, 0, 60), "⚙️")

-- Create Windows container
local windows = Instance.new("Frame")
windows.Name = "Windows"
windows.Size = UDim2.new(1, 0, 1, 0)
windows.BackgroundTransparency = 1
windows.Parent = mainUI

-- Create window templates
local function createWindow(name, title)
	local window = Instance.new("Frame")
	window.Name = name
	window.Size = UDim2.new(0, 600, 0, 400)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	window.BorderSizePixel = 0
	window.Visible = false

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = window

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	titleBar.BorderSizePixel = 0

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 12)
	titleCorner.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -40, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextScaled = true
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar

	titleBar.Parent = window

	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -35, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextScaled = true
	closeButton.Parent = titleBar

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton

	-- Content frame
	local content = Instance.new("ScrollingFrame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -20, 1, -60)
	content.Position = UDim2.new(0, 10, 0, 50)
	content.BackgroundTransparency = 1
	content.ScrollBarThickness = 6
	content.Parent = window

	window.Parent = windows
	return window
end

-- Create all windows
createWindow("PetMenu", "My Pets")
createWindow("Shop", "Shop")
createWindow("Tycoon", "My Tycoon")
createWindow("TowerDefense", "Tower Defense")
createWindow("Trading", "Trading")
createWindow("Settings", "Settings")

-- Notification container
local notificationContainer = Instance.new("Frame")
notificationContainer.Name = "NotificationContainer"
notificationContainer.Size = UDim2.new(1, 0, 1, 0)
notificationContainer.BackgroundTransparency = 1
notificationContainer.Parent = mainUI

-- Event banner
local eventBanner = Instance.new("Frame")
eventBanner.Name = "EventBanner"
eventBanner.Size = UDim2.new(0, 400, 0, 60)
eventBanner.Position = UDim2.new(0.5, 0, 0, 70)
eventBanner.AnchorPoint = Vector2.new(0.5, 0)
eventBanner.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
eventBanner.BorderSizePixel = 0
eventBanner.Visible = false

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 8)
bannerCorner.Parent = eventBanner

local eventNameLabel = Instance.new("TextLabel")
eventNameLabel.Name = "EventName"
eventNameLabel.Size = UDim2.new(1, -20, 1, -20)
eventNameLabel.Position = UDim2.new(0, 10, 0, 10)
eventNameLabel.BackgroundTransparency = 1
eventNameLabel.Text = "Event Active!"
eventNameLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
eventNameLabel.Font = Enum.Font.GothamBold
eventNameLabel.TextScaled = true
eventNameLabel.Parent = eventBanner

eventBanner.Parent = hud

-- Achievement popup
local achievementPopup = Instance.new("Frame")
achievementPopup.Name = "AchievementPopup"
achievementPopup.Size = UDim2.new(0, 350, 0, 100)
achievementPopup.Position = UDim2.new(0.5, 0, 0, 150)
achievementPopup.AnchorPoint = Vector2.new(0.5, 0)
achievementPopup.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
achievementPopup.BorderSizePixel = 0
achievementPopup.Visible = false

local achievementCorner = Instance.new("UICorner")
achievementCorner.CornerRadius = UDim.new(0, 8)
achievementCorner.Parent = achievementPopup

local achievementTitle = Instance.new("TextLabel")
achievementTitle.Name = "Title"
achievementTitle.Size = UDim2.new(1, -20, 0, 40)
achievementTitle.Position = UDim2.new(0, 10, 0, 5)
achievementTitle.BackgroundTransparency = 1
achievementTitle.Text = "Achievement Unlocked!"
achievementTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
achievementTitle.Font = Enum.Font.GothamBold
achievementTitle.TextScaled = true
achievementTitle.Parent = achievementPopup

local achievementDesc = Instance.new("TextLabel")
achievementDesc.Name = "Description"
achievementDesc.Size = UDim2.new(1, -20, 0, 40)
achievementDesc.Position = UDim2.new(0, 10, 0, 50)
achievementDesc.BackgroundTransparency = 1
achievementDesc.Text = "Description here"
achievementDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
achievementDesc.Font = Enum.Font.Gotham
achievementDesc.TextScaled = true
achievementDesc.Parent = achievementPopup

achievementPopup.Parent = hud

-- Parent to PlayerGui
mainUI.Parent = playerGui

print("[MainUI] UI structure created successfully!")

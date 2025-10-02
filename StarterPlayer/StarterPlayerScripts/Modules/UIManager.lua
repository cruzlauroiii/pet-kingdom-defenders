--[[
	UIManager - Manages all UI elements and windows
	Handles opening/closing menus, updating displays, and animations
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Config = require(ReplicatedStorage.Shared.Config)
local Utils = require(ReplicatedStorage.Shared.Utils)

local UIManager = {}
UIManager.OpenWindows = {}

function UIManager:Initialize()
	print("[UIManager] Initializing...")

	-- Wait for UI to load
	local mainUI = playerGui:WaitForChild("MainUI", 10)
	if not mainUI then
		warn("[UIManager] MainUI not found!")
		return
	end

	self.MainUI = mainUI
	self.HUD = mainUI:WaitForChild("HUD")
	self.Windows = mainUI:WaitForChild("Windows")

	-- Setup button handlers
	self:SetupButtons()

	print("[UIManager] Initialized successfully!")
end

-- Setup all button click handlers
function UIManager:SetupButtons()
	-- HUD buttons
	local hud = self.HUD

	-- Pet menu button
	local petButton = hud:FindFirstChild("PetButton")
	if petButton then
		petButton.MouseButton1Click:Connect(function()
			self:ToggleWindow("PetMenu")
		end)
	end

	-- Shop button
	local shopButton = hud:FindFirstChild("ShopButton")
	if shopButton then
		shopButton.MouseButton1Click:Connect(function()
			self:ToggleWindow("Shop")
		end)
	end

	-- Tycoon button
	local tycoonButton = hud:FindFirstChild("TycoonButton")
	if tycoonButton then
		tycoonButton.MouseButton1Click:Connect(function()
			self:ToggleWindow("Tycoon")
		end)
	end

	-- Tower Defense button
	local tdButton = hud:FindFirstChild("TowerDefenseButton")
	if tdButton then
		tdButton.MouseButton1Click:Connect(function()
			self:ToggleWindow("TowerDefense")
		end)
	end

	-- Trading button
	local tradeButton = hud:FindFirstChild("TradeButton")
	if tradeButton then
		tradeButton.MouseButton1Click:Connect(function()
			self:ToggleWindow("Trading")
		end)
	end

	-- Settings button
	local settingsButton = hud:FindFirstChild("SettingsButton")
	if settingsButton then
		settingsButton.MouseButton1Click:Connect(function()
			self:ToggleWindow("Settings")
		end)
	end
end

-- Toggle window open/close
function UIManager:ToggleWindow(windowName)
	local window = self.Windows:FindFirstChild(windowName)
	if not window then
		warn("[UIManager] Window not found:", windowName)
		return
	end

	if self.OpenWindows[windowName] then
		self:CloseWindow(windowName)
	else
		self:OpenWindow(windowName)
	end
end

-- Open window with animation
function UIManager:OpenWindow(windowName)
	local window = self.Windows:FindFirstChild(windowName)
	if not window then return end

	-- Close other windows (optional - comment out for multiple windows)
	for name, _ in pairs(self.OpenWindows) do
		if name ~= windowName then
			self:CloseWindow(name)
		end
	end

	window.Visible = true
	self.OpenWindows[windowName] = true

	-- Animate in
	window.Position = UDim2.new(0.5, 0, 1.5, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	local tween = TweenService:Create(window, TweenInfo.new(Config.UI_ANIMATION_SPEED, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	tween:Play()
end

-- Close window with animation
function UIManager:CloseWindow(windowName)
	local window = self.Windows:FindFirstChild(windowName)
	if not window then return end

	self.OpenWindows[windowName] = false

	-- Animate out
	local tween = TweenService:Create(window, TweenInfo.new(Config.UI_ANIMATION_SPEED, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 1.5, 0)
	})
	tween:Play()

	tween.Completed:Connect(function()
		window.Visible = false
	end)
end

-- Update currency display
function UIManager:UpdateCurrency(currencyType, amount)
	local currencyLabel = self.HUD:FindFirstChild(currencyType .. "Label")
	if currencyLabel then
		currencyLabel.Text = Utils.FormatNumber(amount)
	end
end

-- Show pet hatch animation
function UIManager:ShowHatchAnimation(petData)
	local hatchWindow = self.Windows:FindFirstChild("HatchAnimation")
	if not hatchWindow then return end

	hatchWindow.Visible = true

	local petNameLabel = hatchWindow:FindFirstChild("PetName")
	local rarityLabel = hatchWindow:FindFirstChild("Rarity")

	if petNameLabel then
		petNameLabel.Text = petData.Name
	end

	if rarityLabel then
		rarityLabel.Text = petData.Rarity
		rarityLabel.TextColor3 = Utils.GetRarityColor(petData.Rarity)
	end

	-- Auto close after 3 seconds
	task.wait(3)
	hatchWindow.Visible = false
end

-- Show trade request popup
function UIManager:ShowTradeRequest(requester, tradeId)
	local tradeRequestPopup = self.Windows:FindFirstChild("TradeRequest")
	if not tradeRequestPopup then return end

	tradeRequestPopup.Visible = true

	local messageLabel = tradeRequestPopup:FindFirstChild("Message")
	if messageLabel then
		messageLabel.Text = requester.Name .. " wants to trade with you!"
	end

	-- Accept button
	local acceptButton = tradeRequestPopup:FindFirstChild("AcceptButton")
	if acceptButton then
		acceptButton.MouseButton1Click:Connect(function()
			ReplicatedStorage.Remotes.AcceptTradeRequest:FireServer(tradeId)
			tradeRequestPopup.Visible = false
		end)
	end

	-- Decline button
	local declineButton = tradeRequestPopup:FindFirstChild("DeclineButton")
	if declineButton then
		declineButton.MouseButton1Click:Connect(function()
			ReplicatedStorage.Remotes.DeclineTradeRequest:FireServer(tradeId)
			tradeRequestPopup.Visible = false
		end)
	end
end

-- Open trade window
function UIManager:OpenTradeWindow(tradeData)
	self:OpenWindow("Trading")
	-- Setup trade window with data
	-- Implementation would populate trade slots, etc.
end

-- Close trade window
function UIManager:CloseTradeWindow()
	self:CloseWindow("Trading")
end

-- Show event banner
function UIManager:ShowEventBanner(eventData)
	local eventBanner = self.HUD:FindFirstChild("EventBanner")
	if not eventBanner then return end

	eventBanner.Visible = true
	local eventNameLabel = eventBanner:FindFirstChild("EventName")
	if eventNameLabel then
		eventNameLabel.Text = eventData.Name
	end

	-- Auto hide after 5 seconds
	task.wait(5)
	eventBanner.Visible = false
end

-- Show achievement popup
function UIManager:ShowAchievementPopup(achievement)
	local achievementPopup = self.HUD:FindFirstChild("AchievementPopup")
	if not achievementPopup then return end

	achievementPopup.Visible = true

	local titleLabel = achievementPopup:FindFirstChild("Title")
	local descLabel = achievementPopup:FindFirstChild("Description")

	if titleLabel then
		titleLabel.Text = achievement.Name
	end

	if descLabel then
		descLabel.Text = achievement.Description
	end

	-- Auto hide after 4 seconds
	task.wait(4)
	achievementPopup.Visible = false
end

return UIManager

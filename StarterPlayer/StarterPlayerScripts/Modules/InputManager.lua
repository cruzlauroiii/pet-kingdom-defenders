--[[
	InputManager - Handles all player input (keyboard, mouse, touch)
	Mobile-optimized controls
]]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local InputManager = {}
InputManager.InputEnabled = true

function InputManager:Initialize()
	print("[InputManager] Initializing...")

	-- Detect input type
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		self.IsMobile = true
		print("[InputManager] Mobile controls enabled")
	else
		self.IsMobile = false
		print("[InputManager] Desktop controls enabled")
	end

	-- Setup input listeners
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		self:OnInputBegan(input)
	end)

	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		self:OnInputEnded(input)
	end)

	print("[InputManager] Initialized successfully!")
end

function InputManager:SetupCharacter(character)
	self.Character = character
	self.Humanoid = character:WaitForChild("Humanoid")
end

-- Handle input began
function InputManager:OnInputBegan(input)
	if not self.InputEnabled then return end

	-- Keyboard shortcuts
	if input.KeyCode == Enum.KeyCode.E then
		-- Open pet menu
		local UIManager = require(script.Parent.UIManager)
		UIManager:ToggleWindow("PetMenu")
	elseif input.KeyCode == Enum.KeyCode.Q then
		-- Open shop
		local UIManager = require(script.Parent.UIManager)
		UIManager:ToggleWindow("Shop")
	elseif input.KeyCode == Enum.KeyCode.T then
		-- Open trading
		local UIManager = require(script.Parent.UIManager)
		UIManager:ToggleWindow("Trading")
	elseif input.KeyCode == Enum.KeyCode.Escape then
		-- Open settings
		local UIManager = require(script.Parent.UIManager)
		UIManager:ToggleWindow("Settings")
	end
end

-- Handle input ended
function InputManager:OnInputEnded(input)
	-- Handle any release events
end

-- Enable/disable input
function InputManager:SetInputEnabled(enabled)
	self.InputEnabled = enabled
end

return InputManager

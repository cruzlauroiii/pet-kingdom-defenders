--[[
	CameraController - Manages camera behavior and effects
	Smooth camera transitions and cinematic moments
]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local CameraController = {}
CameraController.CameraMode = "Default" -- Default, Cinematic, Fixed

function CameraController:Initialize()
	print("[CameraController] Initializing...")

	-- Set default camera settings
	camera.CameraType = Enum.CameraType.Custom

	print("[CameraController] Initialized successfully!")
end

function CameraController:SetupCharacter(character)
	self.Character = character
	self.Humanoid = character:WaitForChild("Humanoid")
	self.HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

-- Shake camera (for impacts, explosions, etc.)
function CameraController:Shake(intensity, duration)
	local startTime = tick()

	local connection
	connection = RunService.RenderStepped:Connect(function()
		local elapsed = tick() - startTime

		if elapsed >= duration then
			connection:Disconnect()
			camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0) -- Reset
			return
		end

		local shake = Vector3.new(
			math.random(-100, 100) / 100 * intensity,
			math.random(-100, 100) / 100 * intensity,
			math.random(-100, 100) / 100 * intensity
		)

		camera.CFrame = camera.CFrame * CFrame.new(shake)
	end)
end

-- Zoom to position smoothly
function CameraController:ZoomTo(position, duration)
	self.CameraMode = "Cinematic"

	local targetCFrame = CFrame.new(position + Vector3.new(0, 10, 10), position)

	local tween = TweenService:Create(camera, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		CFrame = targetCFrame
	})

	tween:Play()

	tween.Completed:Connect(function()
		self.CameraMode = "Default"
	end)
end

-- Set camera to follow character (reset)
function CameraController:ResetCamera()
	self.CameraMode = "Default"
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = self.Humanoid
end

return CameraController

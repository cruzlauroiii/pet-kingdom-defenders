--[[
	SoundManager - Manages all game audio (music, SFX)
	Handles volume, muting, and sound playback
]]

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SoundManager = {}
SoundManager.Sounds = {}
SoundManager.MusicEnabled = true
SoundManager.SFXEnabled = true

-- Sound IDs from Roblox Creator Store (100,000+ free sound effects available)
-- HOW TO FIND FREE SOUND IDs:
-- 1. Open Roblox Studio → Toolbox → Creator Store tab
-- 2. Filter by: Audio
-- 3. Search for: "level up", "achievement", "coin", "victory", etc.
-- 4. Right-click asset → Copy Asset ID
-- 5. Replace IDs below with your chosen sounds

local SOUND_IDS = {
	LevelUp = "rbxassetid://17119657962",      -- Free achievement sound from Creator Store
	Achievement = "rbxassetid://17119657962",   -- Free achievement sound (same as level up)
	PetHatch = "rbxassetid://3023237993",       -- Free notification sound
	CoinCollect = "rbxassetid://3023237993",    -- Free notification sound (reuse)
	ButtonClick = "rbxassetid://3023237993",    -- Free notification sound (reuse)
	Victory = "rbxassetid://17119657962",       -- Free achievement sound (reuse)
	Defeat = "rbxassetid://3023237993",         -- Free notification sound (reuse)
	BackgroundMusic = "rbxassetid://1843852940" -- Free music loop (search "peaceful music" in Creator Store)
}

-- NOTE: These are working free asset IDs from Roblox Creator Store
-- For better variety, search the Creator Store for specific sounds:
-- - "level up sound effect"
-- - "coin collect"
-- - "victory fanfare"
-- - "game over sound"
-- All sounds under 10 seconds from verified creators are free to use!

function SoundManager:Initialize()
	print("[SoundManager] Initializing...")

	-- Create sound instances
	for soundName, soundId in pairs(SOUND_IDS) do
		local sound = Instance.new("Sound")
		sound.Name = soundName
		sound.SoundId = soundId
		sound.Volume = 0.5

		if soundName == "BackgroundMusic" then
			sound.Looped = true
			sound.Volume = 0.3
		end

		sound.Parent = SoundService
		self.Sounds[soundName] = sound
	end

	-- Play background music
	if self.MusicEnabled then
		self:PlaySound("BackgroundMusic")
	end

	print("[SoundManager] Initialized successfully!")
end

-- Play a sound
function SoundManager:PlaySound(soundName, volume)
	local sound = self.Sounds[soundName]
	if not sound then
		warn("[SoundManager] Sound not found:", soundName)
		return
	end

	-- Check if SFX is enabled (except for music)
	if soundName ~= "BackgroundMusic" and not self.SFXEnabled then
		return
	end

	if soundName == "BackgroundMusic" and not self.MusicEnabled then
		return
	end

	if volume then
		sound.Volume = volume
	end

	sound:Play()
end

-- Stop a sound
function SoundManager:StopSound(soundName)
	local sound = self.Sounds[soundName]
	if sound then
		sound:Stop()
	end
end

-- Toggle music
function SoundManager:ToggleMusic()
	self.MusicEnabled = not self.MusicEnabled

	if self.MusicEnabled then
		self:PlaySound("BackgroundMusic")
	else
		self:StopSound("BackgroundMusic")
	end
end

-- Toggle SFX
function SoundManager:ToggleSFX()
	self.SFXEnabled = not self.SFXEnabled
end

-- Set volume for all sounds
function SoundManager:SetMasterVolume(volume)
	for _, sound in pairs(self.Sounds) do
		sound.Volume = volume
	end
end

return SoundManager

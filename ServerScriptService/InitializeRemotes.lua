--[[
	InitializeRemotes - Initializes all remote events and functions
	This should run before MainServer.lua
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Run the remotes setup
local RemotesSetup = require(ReplicatedStorage.Remotes.RemotesSetup)

print("[InitializeRemotes] All remotes initialized!")

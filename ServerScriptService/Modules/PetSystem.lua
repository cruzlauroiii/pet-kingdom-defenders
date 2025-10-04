--[[
	PetSystem - Manages pet hatching, evolution, abilities, and equipped pets
	Core feature of the game combining collection and progression
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManager = require(ServerScriptService.Modules.DataManager)
local SecurityManager = require(ServerScriptService.Modules.SecurityManager)
local Config = require(ReplicatedStorage.Shared.Config)
local PetData = require(ReplicatedStorage.Shared.PetData)

local PetSystem = {}
PetSystem.ActivePets = {} -- Tracks spawned pets in workspace

-- Pet rarity chances (legendary requires gems or special eggs)
local RARITY_WEIGHTS = {
	Common = 50,
	Uncommon = 30,
	Rare = 15,
	Epic = 4,
	Legendary = 1
}

function PetSystem:Initialize()
	print("[PetSystem] Initializing...")

	-- Setup remote functions
	local hatchEggRemote = ReplicatedStorage.Remotes.HatchEgg
	hatchEggRemote.OnServerEvent:Connect(function(player, eggType)
		self:HatchEgg(player, eggType)
	end)

	local equipPetRemote = ReplicatedStorage.Remotes.EquipPet
	equipPetRemote.OnServerEvent:Connect(function(player, petId)
		self:EquipPet(player, petId)
	end)

	local unequipPetRemote = ReplicatedStorage.Remotes.UnequipPet
	unequipPetRemote.OnServerEvent:Connect(function(player, petId)
		self:UnequipPet(player, petId)
	end)

	local evolveRemote = ReplicatedStorage.Remotes.EvolvePet
	evolveRemote.OnServerEvent:Connect(function(player, petId)
		self:EvolvePet(player, petId)
	end)

	print("[PetSystem] Initialized successfully!")
end

function PetSystem:SetupPlayer(player, playerData)
	-- Initialize pet tracking for player
	self.ActivePets[player.UserId] = {}

	-- Spawn equipped pets
	for _, petId in ipairs(playerData.EquippedPets) do
		self:SpawnPet(player, petId)
	end
end

-- Weighted random selection
local function selectByWeight(weights)
	local totalWeight = 0
	for _, weight in pairs(weights) do
		totalWeight += weight
	end

	local random = math.random() * totalWeight
	local currentWeight = 0

	for rarity, weight in pairs(weights) do
		currentWeight += weight
		if random <= currentWeight then
			return rarity
		end
	end

	return "Common"
end

-- Generate unique pet ID
local function generatePetId()
	return game:GetService("HttpService"):GenerateGUID(false)
end

-- Hatch egg and give player a pet
function PetSystem:HatchEgg(player, eggType)
	-- 2025 Security: Rate limiting to prevent exploit spam
	local canProceed, errorMsg = SecurityManager:CheckRateLimit(player, "HatchEgg")
	if not canProceed then
		ReplicatedStorage.Remotes.HatchResult:FireClient(player, false, errorMsg)
		return
	end

	-- 2025 Security: Validate input type
	if type(eggType) ~= "string" then
		SecurityManager:LogSuspiciousActivity(player, "HatchEgg", "Invalid egg type parameter")
		return
	end

	local eggConfig = Config.EGGS[eggType]
	if not eggConfig then
		warn("[PetSystem] Invalid egg type:", eggType)
		return
	end

	-- Check if player has enough currency
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local currencyType = eggConfig.CostType
	local cost = eggConfig.Cost

	if playerData[currencyType] < cost then
		-- Not enough currency
		ReplicatedStorage.Remotes.HatchResult:FireClient(player, false, "Not enough " .. currencyType)
		return
	end

	-- Deduct currency
	DataManager:RemoveCurrency(player, currencyType, cost)

	-- Determine rarity
	local rarity = selectByWeight(RARITY_WEIGHTS)

	-- Select random pet from egg pool with matching rarity
	local possiblePets = {}
	for petName, petInfo in pairs(PetData) do
		if petInfo.Rarity == rarity and table.find(eggConfig.PetPool, petName) then
			table.insert(possiblePets, petName)
		end
	end

	-- Fallback if no pets match
	if #possiblePets == 0 then
		for petName, _ in pairs(PetData) do
			if table.find(eggConfig.PetPool, petName) then
				table.insert(possiblePets, petName)
			end
		end
	end

	local petName = possiblePets[math.random(1, #possiblePets)]
	local petInfo = PetData[petName]

	-- Create pet instance
	local petId = generatePetId()
	local newPet = {
		Id = petId,
		Name = petName,
		Rarity = petInfo.Rarity,
		Level = 1,
		Experience = 0,
		PowerMultiplier = 1.0,
		Shiny = math.random(1, 1000) <= 1, -- 0.1% shiny chance
		HatchTime = os.time()
	}

	-- Add pet to player data
	table.insert(playerData.Pets, newPet)
	playerData.TotalPetsHatched += 1

	-- Fire result to client
	ReplicatedStorage.Remotes.HatchResult:FireClient(player, true, newPet)

	print(string.format("[PetSystem] %s hatched %s (%s) - ID: %s",
		player.Name, petName, petInfo.Rarity, petId))

	return newPet
end

-- Equip pet to follow player
function PetSystem:EquipPet(player, petId)
	-- 2025 Security: Rate limiting
	local canProceed, errorMsg = SecurityManager:CheckRateLimit(player, "EquipPet")
	if not canProceed then
		ReplicatedStorage.Remotes.EquipResult:FireClient(player, false, errorMsg)
		return
	end

	-- 2025 Security: Validate input
	if type(petId) ~= "string" then
		SecurityManager:LogSuspiciousActivity(player, "EquipPet", "Invalid petId parameter type")
		return
	end

	local playerData = DataManager:GetData(player)
	if not playerData then return end

	-- Check if pet exists and belongs to player
	local petData = nil
	for _, pet in ipairs(playerData.Pets) do
		if pet.Id == petId then
			petData = pet
			break
		end
	end

	if not petData then
		-- 2025 Security: Log attempt to equip pet they don't own
		SecurityManager:LogSuspiciousActivity(player, "EquipPet", "Attempted to equip pet they don't own")
		warn("[PetSystem] Pet not found:", petId)
		return
	end

	-- Check max equipped limit
	if #playerData.EquippedPets >= Config.MAX_EQUIPPED_PETS then
		ReplicatedStorage.Remotes.EquipResult:FireClient(player, false, "Maximum pets equipped")
		return
	end

	-- Check if already equipped
	if table.find(playerData.EquippedPets, petId) then
		return
	end

	-- Equip pet
	table.insert(playerData.EquippedPets, petId)

	-- Spawn pet in world
	self:SpawnPet(player, petId)

	ReplicatedStorage.Remotes.EquipResult:FireClient(player, true, petId)
end

-- Unequip pet
function PetSystem:UnequipPet(player, petId)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local index = table.find(playerData.EquippedPets, petId)
	if index then
		table.remove(playerData.EquippedPets, index)

		-- Despawn pet
		self:DespawnPet(player, petId)

		ReplicatedStorage.Remotes.UnequipResult:FireClient(player, true, petId)
	end
end

-- Spawn pet model in workspace
function PetSystem:SpawnPet(player, petId)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local petData = nil
	for _, pet in ipairs(playerData.Pets) do
		if pet.Id == petId then
			petData = pet
			break
		end
	end

	if not petData then return end

	local character = player.Character
	if not character then return end

	-- Create pet model (simplified - would use actual models in production)
	local petModel = Instance.new("Part")
	petModel.Name = "Pet_" .. petId
	petModel.Size = Vector3.new(2, 2, 2)
	petModel.Shape = Enum.PartType.Ball
	petModel.Anchored = false
	petModel.CanCollide = false
	petModel.BrickColor = petData.Shiny and BrickColor.new("Gold") or BrickColor.random()

	-- Add floating effect
	local bodyPosition = Instance.new("BodyPosition")
	bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
	bodyPosition.Parent = petModel

	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(5000, 5000, 5000)
	bodyGyro.Parent = petModel

	petModel.Parent = workspace.Pets or workspace

	-- Store reference
	if not self.ActivePets[player.UserId] then
		self.ActivePets[player.UserId] = {}
	end
	self.ActivePets[player.UserId][petId] = {
		Model = petModel,
		Data = petData,
		BodyPosition = bodyPosition,
		BodyGyro = bodyGyro
	}

	-- Start follow loop
	task.spawn(function()
		self:PetFollowLoop(player, petId)
	end)
end

-- Despawn pet model
function PetSystem:DespawnPet(player, petId)
	if self.ActivePets[player.UserId] and self.ActivePets[player.UserId][petId] then
		local petInfo = self.ActivePets[player.UserId][petId]
		if petInfo.Model then
			petInfo.Model:Destroy()
		end
		self.ActivePets[player.UserId][petId] = nil
	end
end

-- Pet follow behavior
function PetSystem:PetFollowLoop(player, petId)
	while true do
		task.wait(0.1)

		if not self.ActivePets[player.UserId] or not self.ActivePets[player.UserId][petId] then
			break
		end

		local petInfo = self.ActivePets[player.UserId][petId]
		local character = player.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

		if not humanoidRootPart or not petInfo.Model then
			break
		end

		-- Calculate follow position with offset
		local equippedPets = DataManager:GetData(player).EquippedPets
		local petIndex = table.find(equippedPets, petId) or 1
		local angle = (petIndex - 1) * (math.pi * 2 / #equippedPets)
		local radius = 4

		local offsetX = math.cos(angle + tick()) * radius
		local offsetZ = math.sin(angle + tick()) * radius
		local offsetY = math.sin(tick() * 2) * 0.5 + 3

		local targetPosition = humanoidRootPart.Position + Vector3.new(offsetX, offsetY, offsetZ)

		-- Update position
		petInfo.BodyPosition.Position = targetPosition
		petInfo.BodyGyro.CFrame = CFrame.new(petInfo.Model.Position, humanoidRootPart.Position)
	end
end

-- Evolve pet (increase power)
function PetSystem:EvolvePet(player, petId)
	local playerData = DataManager:GetData(player)
	if not playerData then return end

	local petData = nil
	for _, pet in ipairs(playerData.Pets) do
		if pet.Id == petId then
			petData = pet
			break
		end
	end

	if not petData then return end

	-- Check evolution requirements
	local evolutionCost = petData.PowerMultiplier * 1000
	if playerData.Coins < evolutionCost then
		ReplicatedStorage.Remotes.EvolveResult:FireClient(player, false, "Not enough Coins")
		return
	end

	-- Deduct cost and evolve
	DataManager:RemoveCurrency(player, "Coins", evolutionCost)
	petData.PowerMultiplier += 0.1

	ReplicatedStorage.Remotes.EvolveResult:FireClient(player, true, petData)
end

return PetSystem

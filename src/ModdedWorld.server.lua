local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local WorldConfig = require(script.Parent:WaitForChild("WorldConfig"))

local remotes = ReplicatedStorage:FindFirstChild("ModdedWorldRemotes") or Instance.new("Folder")
remotes.Name = "ModdedWorldRemotes"
remotes.Parent = ReplicatedStorage

local punchRemote = remotes:FindFirstChild("Punch") or Instance.new("RemoteEvent")
punchRemote.Name = "Punch"
punchRemote.Parent = remotes

local worldFolder = workspace:FindFirstChild(WorldConfig.WorldName)
if worldFolder then
	worldFolder:Destroy()
end
worldFolder = Instance.new("Folder")
worldFolder.Name = WorldConfig.WorldName
worldFolder.Parent = workspace

local state = {}
local wallHealth = WorldConfig.WallMaxHealth
local wall, portal, crystalOrb
local createOrb

local function createPart(name, size, position, color, material, parent)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Anchored = true
	part.CanCollide = true
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function addLabel(part, text, color)
	local gui = Instance.new("BillboardGui")
	gui.Name = "WorldLabel"
	gui.Size = UDim2.fromOffset(300, 70)
	gui.StudsOffset = Vector3.new(0, part.Size.Y / 2 + 2, 0)
	gui.AlwaysOnTop = true
	gui.Parent = part
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = gui
end

local function ensureStats(player)
	local leaderstats = player:FindFirstChild("leaderstats") or Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local strength = leaderstats:FindFirstChild("Strength") or Instance.new("NumberValue")
	strength.Name = "Strength"
	strength.Parent = leaderstats

	local orbs = leaderstats:FindFirstChild("Orbs") or Instance.new("NumberValue")
	orbs.Name = "Orbs"
	orbs.Parent = leaderstats

	local prestige = leaderstats:FindFirstChild("Prestige") or Instance.new("IntValue")
	prestige.Name = "Prestige"
	prestige.Parent = leaderstats
	return strength, orbs, prestige
end

local function getOrbValue(player)
	local _, _, prestige = ensureStats(player)
	return math.floor(WorldConfig.BaseOrbStrength * (1 + prestige.Value * 0.25))
end

local function collectOrb(player, orb, value, isCrystal)
	if not orb or not orb.Parent then
		return
	end
	local strength, orbs = ensureStats(player)
	strength.Value += value
	orbs.Value += isCrystal and 5 or 1
	local burst = Instance.new("Part")
	burst.Name = "OrbCollectBurst"
	burst.Shape = Enum.PartType.Ball
	burst.Size = Vector3.new(1, 1, 1)
	burst.Position = orb.Position
	burst.Anchored = true
	burst.CanCollide = false
	burst.Material = Enum.Material.Neon
	burst.Color = orb.Color
	burst.Parent = worldFolder
	Debris:AddItem(burst, 0.25)
	orb.Transparency = 1
	orb.CanTouch = false
	task.delay(isCrystal and WorldConfig.CrystalRespawnSeconds or WorldConfig.OrbRespawnSeconds, function()
		if orb.Parent then
			orb.Transparency = 0
			orb.CanTouch = true
		end
	end)
end

createOrb = function(position, value, isCrystal)
	local orb = Instance.new("Part")
	orb.Name = isCrystal and "RareCrystalOrb" or "StrengthOrb"
	orb.Shape = Enum.PartType.Ball
	orb.Size = isCrystal and Vector3.new(3, 3, 3) or Vector3.new(1.6, 1.6, 1.6)
	orb.Position = position
	orb.Anchored = true
	orb.CanCollide = false
	orb.Material = Enum.Material.Neon
	orb.Color = isCrystal and Color3.fromRGB(255, 80, 220) or Color3.fromRGB(70, 220, 255)
	orb.Parent = worldFolder
	if isCrystal then
		addLabel(orb, "RARE CRYSTAL\nNEXT WORLD POWER", Color3.fromRGB(255, 180, 255))
	end
	local claimed = false
	orb.Touched:Connect(function(hit)
		if claimed then
			return
		end
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			claimed = true
			collectOrb(player, orb, value, isCrystal)
			task.delay(isCrystal and WorldConfig.CrystalRespawnSeconds or WorldConfig.OrbRespawnSeconds, function()
				claimed = false
			end)
		end
	end)
end

local function makePortal()
	portal = createPart("NextWorldPortal", Vector3.new(12, 14, 2), Vector3.new(0, 7, 42), Color3.fromRGB(100, 35, 255), Enum.Material.Neon, worldFolder)
	portal.CanCollide = false
	addLabel(portal, "NEXT WORLD\n25,000 STRENGTH", Color3.fromRGB(220, 190, 255))
	portal.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if not player then
			return
		end
		local strength = ensureStats(player)
		if strength.Value >= WorldConfig.NextWorldStrength then
			player:SetAttribute("UnlockedWorld", WorldConfig.WorldIndex + 1)
			local root = hit.Parent:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = CFrame.new(0, 5, 55)
			end
		end
	end)
end

local function makeMap()
	createPart("Floor", Vector3.new(120, 2, 120), Vector3.new(0, -1, 0), Color3.fromRGB(24, 28, 45), Enum.Material.Slate, worldFolder)
	for x = -40, 40, 10 do
		for z = -30, 25, 11 do
			createOrb(Vector3.new(x, 2.5, z), WorldConfig.BaseOrbStrength, false)
		end
	end
	wall = createPart("PunchWall", Vector3.new(36, 16, 3), Vector3.new(0, 8, 20), Color3.fromRGB(55, 65, 95), Enum.Material.DiamondPlate, worldFolder)
	addLabel(wall, "PUNCH WALL\nHP: " .. wallHealth, Color3.fromRGB(255, 225, 120))
	createOrb(Vector3.new(0, 5, 17), WorldConfig.CrystalOrbStrength, true)
	makePortal()
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "WorldSpawn"
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.Position = Vector3.new(0, 1, -48)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Color = Color3.fromRGB(60, 200, 180)
	spawn.Parent = worldFolder
end

punchRemote.OnServerEvent:Connect(function(player)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root or not wall or not wall.Parent then
		return
	end
	local now = os.clock()
	if state[player] and now - state[player] < WorldConfig.PunchCooldown then
		return
	end
	state[player] = now
	if (root.Position - wall.Position).Magnitude > 13 then
		return
	end
	local strength = ensureStats(player)
	local lowerWorldBonus = math.max(1, 11 - WorldConfig.WorldIndex)
	local damage = math.max(1, strength.Value * WorldConfig.WallDamageMultiplier * lowerWorldBonus)
	wallHealth = math.max(0, wallHealth - damage)
	local label = wall:FindFirstChild("WorldLabel")
	if label and label:FindFirstChildOfClass("TextLabel") then
		label:FindFirstChildOfClass("TextLabel").Text = "PUNCH WALL\nHP: " .. math.ceil(wallHealth)
	end
	if wallHealth <= 0 then
		wall.Transparency = 0.65
		wall.CanCollide = false
		if label and label:FindFirstChildOfClass("TextLabel") then
			label:FindFirstChildOfClass("TextLabel").Text = "WALL BROKEN\nPORTAL UNLOCKED"
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	ensureStats(player)
end)
Players.PlayerRemoving:Connect(function(player)
	state[player] = nil
end)

makeMap()

-- Mannequin d'entraînement : un combattant immobile pour tester ses coups seul.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))
local Match = require(script.Parent:WaitForChild("Match"))
local Costumes = require(script.Parent:WaitForChild("Costumes"))

local Dummy = {}

local function nearestPlayerX(position)
	local best, bestDistance = nil, math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			local distance = math.abs(root.Position.X - position.X)
			if distance < bestDistance then
				best, bestDistance = root.Position.X, distance
			end
		end
	end
	return best
end

function Dummy.spawn()
	local description = Instance.new("HumanoidDescription")
	local model = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
	model.Name = "Mannequin"
	local defaultAnimate = model:FindFirstChild("Animate")
	if defaultAnimate then
		defaultAnimate:Destroy()
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	Match.setupHumanoid(humanoid)
	humanoid.AutoRotate = false
	model:PivotTo(CFrame.new(Config.SPAWN_POINTS[2]))
	model.Parent = workspace
	root:SetNetworkOwner(nil)
	Costumes.apply(model, "Dummy")
	Match.registerFighter(model, Config.DEFAULT_CHARACTER, "Mannequin")

	-- Garde le mannequin sur le plan de combat, tourné vers le joueur le plus proche
	RunService.Heartbeat:Connect(function(dt)
		if not root.Parent or root.Anchored then
			return
		end
		local position = root.Position
		local targetX = nearestPlayerX(position)
		local facing = (targetX and targetX < position.X) and -1 or 1
		local velocity = root.AssemblyLinearVelocity
		-- l'éjection freine pendant qu'il est sonné (comme pour les joueurs)
		local s = Fighters.get(model)
		if s and os.clock() < s.stunnedUntil then
			velocity = Vector3.new(velocity.X * math.exp(-Config.KB_DRAG * dt), velocity.Y, 0)
		end
		root.CFrame = CFrame.lookAt(Vector3.new(position.X, position.Y, 0), Vector3.new(position.X + facing, position.Y, Config.TURN_TO_CAMERA))
		root.AssemblyLinearVelocity = Vector3.new(velocity.X, velocity.Y, 0)
		root.AssemblyAngularVelocity = Vector3.zero
	end)
	return model
end

return Dummy

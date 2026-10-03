-- Bots : combattants pilotés par le serveur pour remplir les parties (Bagarre générale, Duel) et pour l'Aventure.
-- Ils jouent avec exactement les mêmes règles que les joueurs (mêmes coups, même Caisse Bizarre, aucun bonus) :
-- seule la difficulté (1 à 5) change leur temps de réaction, leurs esquives et leur agressivité.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local MoveSets = require(Shared:WaitForChild("MoveSets"))
local Statuses = require(Shared:WaitForChild("Statuses"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))
local Combat = require(script.Parent:WaitForChild("Combat"))
local Costumes = require(script.Parent:WaitForChild("Costumes"))

local Bot = {}

local bots = {} -- model -> cerveau
local rng = Random.new()
local registerFighter = nil -- Match.registerFighter (branché par Lobby pour éviter un require circulaire)
local setupHumanoid = nil

-- Les bots traversent les plateformes fines en montant (les joueurs le font chez eux, voir client/Main)
local SOFT_GROUP, PASS_GROUP = "Traversable", "BotPassant"
pcall(function()
	PhysicsService:RegisterCollisionGroup(SOFT_GROUP)
	PhysicsService:RegisterCollisionGroup(PASS_GROUP)
	PhysicsService:CollisionGroupSetCollidable(SOFT_GROUP, PASS_GROUP, false)
end)

function Bot.init(registerFunction, setupFunction)
	registerFighter = registerFunction
	setupHumanoid = setupFunction
end

-- Les plateformes fines de l'arène entrent dans le groupe de collision « Traversable »
function Bot.tagSoftPlatforms()
	for _, platform in ipairs(CollectionService:GetTagged("Traversable")) do
		platform.CollisionGroup = SOFT_GROUP
	end
end

local NAMES = { "Kévin", "Josiane", "Le Grand Robert", "Mimi", "Dédé", "Patou", "Ginette", "Bébert", "Nono", "Lulu" }

local function setGroup(brain, group)
	if brain.group == group then
		return
	end
	brain.group = group
	for _, p in ipairs(brain.model:GetDescendants()) do
		if p:IsA("BasePart") then
			p.CollisionGroup = group
		end
	end
end

function Bot.spawn(characterId, difficulty, cframe, displayName)
	local data = CharacterList[characterId] or CharacterList[Config.DEFAULT_CHARACTER]
	characterId = data.id
	local model = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	local name = displayName or ((data.name or characterId) .. " (bot)")
	model.Name = "Bot_" .. characterId
	local defaultAnimate = model:FindFirstChild("Animate")
	if defaultAnimate then
		defaultAnimate:Destroy()
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	if setupHumanoid then
		setupHumanoid(humanoid)
	end
	humanoid.AutoRotate = false
	model:SetAttribute("IsBot", true)
	model:PivotTo(cframe or CFrame.new(Config.SPAWN_POINTS[2]))
	model.Parent = workspace
	root:SetNetworkOwner(nil)
	Costumes.apply(model, data.costume)
	if registerFighter then
		registerFighter(model, characterId, name)
	end
	local brain = {
		model = model, humanoid = humanoid, root = root, data = data,
		difficulty = math.clamp(difficulty or 2, 1, 5),
		nextThink = 0, airJumps = Config.AIR_JUMPS, facing = 1, wantMove = 0, upUsed = false,
		group = "Default",
	}
	bots[model] = brain
	model.Destroying:Connect(function()
		bots[model] = nil
	end)
	return model
end

function Bot.clearAll()
	for model in pairs(bots) do
		model:Destroy()
	end
	table.clear(bots)
end

function Bot.randomName()
	return NAMES[rng:NextInteger(1, #NAMES)]
end

------------------------------------------------------------------------ Décisions
local function enemies(model)
	local list = {}
	for _, other in ipairs(Fighters.all()) do
		local r = Fighters.root(other)
		local team = model:GetAttribute("Team")
		local sameTeam = Config.TEAMS and team ~= nil and team ~= "" and team == other:GetAttribute("Team")
		if other ~= model and r and not other:GetAttribute("Eliminated") and not other:GetAttribute("Away") and not sameTeam then
			table.insert(list, other)
		end
	end
	return list
end

local function nearest(model, root)
	local best, bestDistance = nil, math.huge
	for _, other in ipairs(enemies(model)) do
		local r = Fighters.root(other)
		local d = (r.Position - root.Position).Magnitude
		if d < bestDistance then
			best, bestDistance = other, d
		end
	end
	return best, bestDistance
end

local function grounded(brain)
	return brain.humanoid.FloorMaterial ~= Enum.Material.Air
end

-- Lance une action comme le ferait un joueur ; renvoie vrai si le coup est parti
local function act(brain, key, extra)
	local s = Fighters.get(brain.model)
	if not s then
		return false
	end
	local before = s.lastMoveAt
	Combat.handleModelAction(brain.model, key, extra)
	if s.lastMoveAt ~= before then
		-- élan du coup (les joueurs l'appliquent chez eux)
		local move = brain.data.moves[key]
		if move and move.selfVelocity then
			local v = brain.root.AssemblyLinearVelocity
			local vy = move.selfVelocity.Y ~= 0 and move.selfVelocity.Y or v.Y
			brain.root.AssemblyLinearVelocity = Vector3.new(move.selfVelocity.X * brain.facing, vy, 0)
		end
		return true
	end
	return false
end

local function pick(brain, candidates)
	return MoveSets.pick(brain.data.moves, candidates, MoveSets.armed(brain.model))
end

local function nearestCrate(root)
	local objects = workspace:FindFirstChild("Objets")
	if not objects then
		return nil
	end
	local best, bestDistance = nil, 30
	for _, item in ipairs(objects:GetChildren()) do
		if item:IsA("Model") and item:GetAttribute("ItemId") == "crate" then
			local d = (item:GetPivot().Position - root.Position).Magnitude
			if d < bestDistance then
				best, bestDistance = item, d
			end
		end
	end
	return best, bestDistance
end

local function think(brain, now)
	local model, root = brain.model, brain.root
	local s = Fighters.get(model)
	if not s then
		return
	end
	local d = brain.difficulty
	local flags = Statuses.flags(model)
	local onGround = grounded(brain)
	if onGround then
		brain.airJumps = Config.AIR_JUMPS + (model:GetAttribute("AirJumpsBonus") or 0)
		brain.upUsed = false
	end
	local busy = os.clock() < s.busyUntil
	local pos = root.Position

	-- tient quelqu'un : projection vers le bord le plus proche
	if model:GetAttribute("Holding") then
		local toward = pos.X >= 0 and 1 or -1
		act(brain, "THROW", toward == brain.facing and "fwd" or "back")
		return
	end

	-- remontée : hors de l'arène, on revient vers le centre
	local offStage = math.abs(pos.X) > 47 or pos.Y < -1
	if offStage and not onGround then
		brain.wantMove = pos.X > 0 and -1 or 1
		brain.facing = brain.wantMove
		if root.AssemblyLinearVelocity.Y < 5 then
			if brain.airJumps > 0 then
				brain.airJumps -= 1
				local v = root.AssemblyLinearVelocity
				root.AssemblyLinearVelocity = Vector3.new(v.X, Config.AIR_JUMP_VELOCITY, 0)
			elseif not brain.upUsed and not busy then
				local key = pick(brain, { "S_up" })
				if key and act(brain, key) then
					brain.upUsed = true
				end
			end
		end
		return
	end

	local target, distance = nearest(model, root)
	-- Caisse Bizarre à portée : on va l'ouvrir (son arme et ses vrais coups)
	if not MoveSets.armed(model) then
		local crate, crateDistance = nearestCrate(root)
		if crate and (not target or crateDistance < distance * 0.8) then
			local dx = crate:GetPivot().Position.X - pos.X
			brain.wantMove = math.abs(dx) > 1.5 and math.sign(dx) or 0
			if crateDistance <= Config.PICKUP_RANGE - 0.5 and not busy then
				act(brain, "PICKUP")
			end
			return
		end
	end
	if not target then
		brain.wantMove = math.abs(pos.X) > 10 and -math.sign(pos.X) or 0
		return
	end
	local troot = Fighters.root(target)
	local dx = troot.Position.X - pos.X
	local dy = troot.Position.Y - pos.Y
	if not busy then
		brain.facing = dx >= 0 and 1 or -1
	end

	-- esquive quand un adversaire proche lance un coup
	local enemyStart = target:GetAttribute("MoveStart") or 0
	if distance < 7 and workspace:GetServerTimeNow() - enemyStart < 0.15 and not busy and not flags.noDodge
		and rng:NextNumber() < 0.08 + 0.1 * d then
		model:SetAttribute("DodgeStart", workspace:GetServerTimeNow())
		act(brain, "DODGE")
		local away = -brain.facing
		root.AssemblyLinearVelocity = Vector3.new(away * Config.DODGE_SPEED * 0.8, root.AssemblyLinearVelocity.Y, 0)
		return
	end

	-- recharge d'énergie quand on est loin et à sec
	local energy = model:GetAttribute("Energy") or 0
	if distance > 25 and energy < 40 and onGround and not busy then
		brain.wantMove = 0
		act(brain, "CHARGE")
		return
	end
	if s.charging then
		act(brain, "CHARGE_END")
	end

	local range = 5.5
	if math.abs(dx) > range or math.abs(dy) > 7 then
		-- on se rapproche ; adversaire au-dessus : on saute ; de temps en temps un spécial à distance
		brain.wantMove = math.sign(dx)
		if dy > 6 and onGround and rng:NextNumber() < 0.5 then
			brain.humanoid.Jump = true
		elseif dy > 6 and not onGround and brain.airJumps > 0 and root.AssemblyLinearVelocity.Y < 0 then
			brain.airJumps -= 1
			local v = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity = Vector3.new(v.X, Config.AIR_JUMP_VELOCITY, 0)
		end
		if not busy and math.abs(dy) < 5 and distance < 30 and energy >= 30 and rng:NextNumber() < 0.04 * d then
			local key = pick(brain, { "S_neutral", "S_side" })
			if key then
				act(brain, key)
			end
		end
		return
	end

	-- à portée : on frappe
	brain.wantMove = math.abs(dx) > 2.5 and math.sign(dx) * 0.4 or 0
	if busy then
		return
	end
	local super = (model:GetAttribute("Super") or 0) >= Config.MAX_SUPER
	local roll = rng:NextNumber()
	local key
	if super and rng:NextNumber() < 0.5 then
		key = pick(brain, { "SUPER" })
	elseif distance < 3.5 and roll < 0.1 then
		key = "GRAB"
	elseif not onGround then
		if dy < -2 then
			key = pick(brain, roll < 0.5 and { "P_air_down", "P_air" } or { "K_air_down", "K_air" })
		elseif dy > 2 then
			key = pick(brain, roll < 0.5 and { "P_air_up", "P_air" } or { "K_air_up", "K_air" })
		else
			key = pick(brain, roll < 0.5 and { "P_air_side", "P_air" } or { "K_air_side", "K_air" })
		end
	elseif dy > 3 then
		key = pick(brain, roll < 0.5 and { "P_up" } or { "K_up" })
	elseif roll < 0.45 then
		key = pick(brain, roll < 0.2 and { "P_neutral" } or { "P_side", "P_neutral" })
	elseif roll < 0.75 then
		key = pick(brain, roll < 0.6 and { "K_neutral" } or { "K_side", "K_down", "K_neutral" })
	elseif energy >= 25 then
		key = pick(brain, ({ { "S_neutral" }, { "S_side" }, { "S_down" }, { "S_hold" } })[rng:NextInteger(1, 4)])
	else
		key = pick(brain, { "P_down", "P_neutral" })
	end
	if key then
		local done = act(brain, key)
		-- enchaînement : la suite du combo part un peu plus tard (plus vite en difficulté haute)
		local move = done and brain.data.moves[key]
		if move and move.links and rng:NextNumber() < 0.25 + 0.12 * d then
			local follow = move.links.P or move.links.K or move.links.S
			if follow then
				task.delay(move.startup + move.active + 0.05, function()
					if bots[model] then
						act(brain, follow)
					end
				end)
			end
		end
	end
end

------------------------------------------------------------------------ Boucle physique
RunService.Heartbeat:Connect(function(dt)
	local now = os.clock()
	for model, brain in pairs(bots) do
		local root, humanoid = brain.root, brain.humanoid
		if not root.Parent or not humanoid.Parent then
			bots[model] = nil
		elseif not root.Anchored and not model:GetAttribute("Eliminated") then
			local s = Fighters.get(model)
			local stunned = s and os.clock() < s.stunnedUntil
			local flags = Statuses.flags(model)
			if now >= brain.nextThink and not stunned and not flags.noAct and not model:GetAttribute("Grabbed") then
				brain.nextThink = now + math.max(0.08, 0.42 - 0.07 * brain.difficulty) * rng:NextNumber(0.8, 1.2)
				local ok, err = pcall(think, brain, now)
				if not ok then
					warn("[Bot] " .. tostring(err))
				end
			end
			-- marche (sauf sonné ou pendant un coup au sol)
			local busy = s and os.clock() < s.busyUntil
			local velocity = root.AssemblyLinearVelocity
			if stunned then
				velocity = Vector3.new(velocity.X * math.exp(-Config.KB_DRAG * dt), velocity.Y, 0)
				humanoid:Move(Vector3.zero)
			elseif flags.noMove or flags.noAct or (busy and humanoid.FloorMaterial ~= Enum.Material.Air) then
				humanoid:Move(Vector3.zero)
			else
				humanoid.WalkSpeed = Config.RUN_SPEED * 0.9 * Statuses.speed(model)
				humanoid:Move(Vector3.new(brain.wantMove, 0, 0))
			end
			-- traverse les plateformes fines en montant ou en descendant volontairement
			setGroup(brain, velocity.Y > 1 and "BotPassant" or "Default")
			root.CFrame = CFrame.lookAt(Vector3.new(root.Position.X, root.Position.Y, 0), Vector3.new(root.Position.X + brain.facing, root.Position.Y, Config.TURN_TO_CAMERA))
			root.AssemblyLinearVelocity = Vector3.new(velocity.X, velocity.Y, 0)
			root.AssemblyAngularVelocity = Vector3.zero
		end
	end
end)

return Bot

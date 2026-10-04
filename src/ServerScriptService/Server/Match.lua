-- Déroulement du match, règles façon Smash Bros :
--   mode "time" (aux points) : temps limité, vies illimitées. Éjecter quelqu'un rapporte +1 à celui qui l'a
--     frappé en dernier, chaque chute coûte -1. Égalité à la fin : mort subite, tout le monde à 300 %.
--   mode "stock" (aux vies) : 3 vies, le dernier debout gagne.
--   Équipes (Config.TEAMS) : les points de l'équipe s'additionnent, pas de coups entre coéquipiers.
-- Après une chute : le perso revient sur sa plateforme (propre à chaque perso) avec son animation d'entrée,
-- invincible tant qu'il y reste et encore un court instant après. Coups fatals et victoire.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))
local Fatals = require(script.Parent:WaitForChild("Fatals"))
local Costumes = require(script.Parent:WaitForChild("Costumes"))
local Combat = require(script.Parent:WaitForChild("Combat"))
local Pickups = require(script.Parent:WaitForChild("Pickups"))
local Mechanics = require(script.Parent:WaitForChild("Mechanics"))
local Specials = require(script.Parent:WaitForChild("Specials"))

local Match = {}

-- Branchés par server/Lobby.lua :
--   Match.characterFor(player) -> id du perso si le joueur participe à la partie en cours, sinon nil (spectateur)
--   Match.onEnd(group)         -> fin de partie (groupe gagnant ou nil)
Match.characterFor = nil
Match.onEnd = nil
Match.fatalAllowed = nil -- (attaquant, n° du fatal) -> débloqué ?
local active = false -- une partie est en cours

local roundOver = false
local suddenDeath = false
local fxRemote = nil
local platforms = {} -- perso -> { model, x, top, expires }
local respawning = {} -- perso -> true pendant son retour

function Match.setFxRemote(remote)
	fxRemote = remote
end
local messageToken = 0

function Match.setMessage(text, duration)
	messageToken += 1
	local token = messageToken
	workspace:SetAttribute("Message", text)
	task.delay(duration, function()
		if messageToken == token then
			workspace:SetAttribute("Message", "")
		end
	end)
end

local function spawnCFrame(index)
	local point = Config.SPAWN_POINTS[(index - 1) % #Config.SPAWN_POINTS + 1]
	local facing = point.X > 0 and -1 or 1
	return CFrame.lookAt(point, point + Vector3.new(facing, 0, 0))
end

function Match.setupHumanoid(humanoid)
	humanoid.MaxHealth = 1e9
	humanoid.Health = 1e9
	humanoid.BreakJointsOnDeath = false
	humanoid.WalkSpeed = Config.WALK_SPEED
	humanoid.UseJumpPower = true
	humanoid.JumpPower = Config.JUMP_POWER
end

local function displayName(model)
	return model:GetAttribute("DisplayName") or model.Name
end

------------------------------------------------------------------------ Équipes et points
local function teamOf(model)
	local team = model:GetAttribute("Team")
	return (team and team ~= "") and team or nil
end

local function assignTeam(model)
	if not Config.TEAMS then
		model:SetAttribute("Team", "")
		return
	end
	-- équipe choisie par le salon (2 contre 2) : on la garde, même après un rechargement du personnage
	local player = Players:GetPlayerFromCharacter(model)
	local wanted = player and player:GetAttribute("Team")
	if wanted == "Rouge" or wanted == "Bleu" then
		model:SetAttribute("Team", wanted)
		return
	end
	local counts = { Rouge = 0, Bleu = 0 }
	for _, other in ipairs(Fighters.all()) do
		local team = other ~= model and teamOf(other)
		if team and counts[team] then
			counts[team] += 1
		end
	end
	model:SetAttribute("Team", counts.Rouge <= counts.Bleu and "Rouge" or "Bleu")
end

-- Inscrit un combattant (joueur ou mannequin) dans le match
function Match.registerFighter(model, characterId, name)
	Fighters.register(model, characterId, name)
	assignTeam(model)
end

local function addAttribute(model, name, amount)
	model:SetAttribute(name, (model:GetAttribute(name) or 0) + amount)
end

-- Groupes qui s'affrontent : une équipe, ou un joueur seul
local function groupOf(model)
	return teamOf(model) or model
end

local function groupName(group)
	if typeof(group) == "string" then
		return "L'ÉQUIPE " .. string.upper(group)
	end
	return displayName(group)
end

------------------------------------------------------------------------ Fin de manche
local startRound -- défini plus bas

local function declareWinner(group)
	roundOver = true
	Pickups.reset(false)
	workspace:SetAttribute("MatchEndsAt", 0)
	Match.setMessage(group and (groupName(group) .. " GAGNE !") or "ÉGALITÉ !", 4)
	task.delay(4, function()
		if Match.onEnd then
			Match.onEnd(group)
		else
			startRound()
		end
	end)
end

-- Groupe (joueur ou équipe) d'un combattant, et nom affiché (pour le salon)
Match.groupOf = function(model)
	return groupOf(model)
end
Match.groupName = function(group)
	return groupName(group)
end

local function eliminate(model)
	model:SetAttribute("Stocks", 0)
	model:SetAttribute("Eliminated", true)
	model:SetAttribute("Finishable", false)
	local root = Fighters.root(model)
	if root then
		root.AssemblyLinearVelocity = Vector3.zero
		root.Anchored = true
		root.CFrame = CFrame.new(Config.SPECTATOR_POINT)
	end
end

-- Mode aux vies (ou mort subite) : il ne reste qu'un groupe en vie ?
function Match.checkWinner()
	if roundOver or (Config.MATCH_MODE ~= "stock" and not suddenDeath) then
		return
	end
	local all = Fighters.all()
	if #all < 2 then
		return
	end
	local alive, count = {}, 0
	for _, model in ipairs(all) do
		if not model:GetAttribute("Eliminated") then
			local group = groupOf(model)
			if not alive[group] then
				alive[group] = true
				count += 1
			end
		end
	end
	if count <= 1 then
		declareWinner(next(alive))
	end
end

local respawn -- défini plus bas

-- Fin du temps : le groupe qui a le plus de points gagne, sinon mort subite entre les ex aequo
local function endOfTime()
	local scores = {}
	for _, model in ipairs(Fighters.all()) do
		local group = groupOf(model)
		scores[group] = (scores[group] or 0) + (model:GetAttribute("Score") or 0)
	end
	local best, leaders = -math.huge, {}
	for group, score in pairs(scores) do
		if score > best then
			best, leaders = score, { group }
		elseif score == best then
			table.insert(leaders, group)
		end
	end
	if #leaders <= 1 then
		declareWinner(leaders[1])
		return
	end
	-- Mort subite : les ex aequo repartent à 300 % avec une seule vie, les autres regardent
	suddenDeath = true
	workspace:SetAttribute("MatchEndsAt", 0)
	workspace:SetAttribute("SuddenDeath", true)
	local inSuddenDeath = {}
	for _, group in ipairs(leaders) do
		inSuddenDeath[group] = true
	end
	for index, model in ipairs(Fighters.all()) do
		if inSuddenDeath[groupOf(model)] then
			model:SetAttribute("Stocks", 1)
			model:SetAttribute("Damage", Config.SUDDEN_DEATH_DAMAGE)
			Fighters.updateFinishable(model)
			if not respawning[model] then
				local root = Fighters.root(model)
				if root then
					root.Anchored = false
					root.AssemblyLinearVelocity = Vector3.zero
				end
				model:PivotTo(spawnCFrame(index))
			end
		else
			eliminate(model)
		end
	end
	Match.setMessage("MORT SUBITE !", 2.5)
end

------------------------------------------------------------------------ Plateforme de retour
-- Une par perso (champ respawn.platform de sa fiche). Chaque pièce est placée par rapport au dessus de
-- la plateforme ; la pièce « base » est celle sur laquelle le perso se tient.
local function anchoredPart(parent, name, size, color, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function ball(parent, name, size, color)
	local p = anchoredPart(parent, name, size, color, Enum.Material.Fabric)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Parent = p
	return p
end

local PLATFORMS = {}

-- Gégé : une caisse de soda qui descend du ciel sous un parachute rouge et blanc
PLATFORMS.sodaCrate = function(model)
	local base = anchoredPart(model, "Caisse", Vector3.new(6, 1.6, 4), Color3.fromRGB(235, 120, 30), Enum.Material.Plastic)
	base.CanCollide = true
	local parts = { { base, CFrame.new(0, -0.8, 0) } }
	for i = 0, 5 do
		local x = -2 + (i % 3) * 2
		local z = i < 3 and -0.9 or 0.9
		local cap = anchoredPart(model, "Capsule", Vector3.new(0.1, 0.7, 0.7), Color3.fromRGB(30, 135, 60), Enum.Material.Glass)
		cap.Shape = Enum.PartType.Cylinder
		table.insert(parts, { cap, CFrame.new(x, 0.02, z) * CFrame.Angles(0, 0, math.rad(90)) })
	end
	table.insert(parts, { ball(model, "Parachute", Vector3.new(9, 3, 6), Color3.fromRGB(220, 40, 40)), CFrame.new(0, 9.5, 0) })
	table.insert(parts, { ball(model, "Bande", Vector3.new(3, 3.1, 6.1), Color3.new(1, 1, 1)), CFrame.new(0, 9.55, 0) })
	for _, corner in ipairs({ { -2.8, -1.8 }, { 2.8, -1.8 }, { -2.8, 1.8 }, { 2.8, 1.8 } }) do
		local from = Vector3.new(corner[1], 0, corner[2])
		local to = Vector3.new(corner[1] * 1.3, 8.5, corner[2] * 0.9)
		local rope = anchoredPart(model, "Corde", Vector3.new(0.08, 0.08, (to - from).Magnitude), Color3.fromRGB(240, 230, 210))
		table.insert(parts, { rope, CFrame.lookAt((from + to) / 2, to) })
	end
	return parts
end

-- Par défaut : un disque lumineux
PLATFORMS.default = function(model)
	local base = anchoredPart(model, "Disque", Vector3.new(0.6, 6, 6), Color3.fromRGB(120, 220, 255), Enum.Material.Neon)
	base.Shape = Enum.PartType.Cylinder
	base.Transparency = 0.2
	base.CanCollide = true
	return { { base, CFrame.new(0, -0.3, 0) * CFrame.Angles(0, 0, math.rad(90)) } }
end

-- Plateforme décrite dans la fiche : respawn.platform = { pieces = { { nom, "base" ou "", forme, taille,
-- position, rotation, couleur, matière, options }, ... } } (même format que look.parts ; position par rapport
-- au dessus de la plateforme ; les pièces "base" portent le perso)
local function platformFromSpec(model, spec)
	local parts = {}
	for _, piece in ipairs(spec.pieces or {}) do
		local part, offset = Costumes.buildPiece(piece)
		part.Anchored = true
		part.CanCollide = piece[2] == "base"
		part.Parent = model
		table.insert(parts, { part, offset })
	end
	if #parts == 0 then
		return PLATFORMS.default(model)
	end
	return parts
end

local function buildPlatform(kind)
	local model = Instance.new("Model")
	model.Name = "PlateformeDeRetour"
	local parts
	if typeof(kind) == "table" then
		parts = platformFromSpec(model, kind)
	else
		parts = (PLATFORMS[kind] or PLATFORMS.default)(model)
	end
	model.Parent = workspace
	return model, function(top)
		for _, entry in ipairs(parts) do
			entry[1].CFrame = CFrame.new(top) * entry[2]
		end
	end
end

local function leavePlatform(model)
	local entry = platforms[model]
	if not entry then
		return
	end
	platforms[model] = nil
	local s = Fighters.get(model)
	if s then
		s.invulnUntil = os.clock() + Config.RESPAWN_INVULN
	end
	model:SetAttribute("Protected", false)
	model:SetAttribute("ProtectedUntil", workspace:GetServerTimeNow() + Config.RESPAWN_INVULN)
	-- la plateforme s'efface
	local platform = entry.model
	task.spawn(function()
		for i = 1, 10 do
			for _, p in ipairs(platform:GetDescendants()) do
				if p:IsA("BasePart") then
					p.Transparency = math.max(p.Transparency, i / 10)
					p.CanCollide = false
				end
			end
			task.wait(0.03)
		end
		platform:Destroy()
	end)
end

-- Toute action (coup, esquive…) fait quitter la plateforme, comme dans Smash
function Match.onFighterAction(model)
	leavePlatform(model)
end

local function resetFighterState(model)
	-- on lâche tout : adversaire saisi (ou saisie subie), objet en main, croustillant
	Combat.releaseGrabs(model)
	Pickups.clear(model)
	Pickups.disarm(model) -- éjecté : on perd son arme, retour aux mains nues
	Specials.clear(model) -- ses pièges et murs disparaissent
	Mechanics.reset(model)
	model:SetAttribute("ObeseUntil", 0)
	model:SetAttribute("FragileUntil", 0)
	model:SetAttribute("Damage", 0)
	model:SetAttribute("Bulles", 0)
	model:SetAttribute("Finishable", false)
	model:SetAttribute("Energy", Config.ENERGY_START)
	Fighters.setCharging(model, false)
	Fighters.clearSmash(model)
	Fighters.clearStatus(model)
	local s = Fighters.get(model)
	if s then
		s.busyUntil = 0
		s.stunnedUntil = 0
		s.lastHitBy = nil
	end
end

-- Plateforme de retour la plus éloignée des adversaires (et libre)
local function respawnPoint(model)
	local best, bestScore = Config.RESPAWN_POINTS[1], -math.huge
	for _, point in ipairs(Config.RESPAWN_POINTS) do
		local nearest = math.huge
		for _, other in ipairs(Fighters.all()) do
			local root = Fighters.root(other)
			if other ~= model and root and not other:GetAttribute("Eliminated") and not other:GetAttribute("Away") then
				nearest = math.min(nearest, (root.Position - point).Magnitude)
			end
		end
		for _, entry in pairs(platforms) do
			if math.abs(entry.x - point.X) < 6 then
				nearest = -1 -- déjà occupée
			end
		end
		local score = nearest + math.random() -- à égalité, au hasard
		if score > bestScore then
			best, bestScore = point, score
		end
	end
	return best
end

-- Retour après une chute : disparition, puis descente sur la plateforme avec l'animation d'entrée du perso
respawn = function(model)
	local s = Fighters.get(model)
	local root = Fighters.root(model)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not s or not root or not humanoid then
		return
	end
	respawning[model] = true
	s.invulnUntil = math.huge
	model:SetAttribute("Protected", true)
	model:SetAttribute("Away", true)
	root.AssemblyLinearVelocity = Vector3.zero
	root.Anchored = true
	root.CFrame = CFrame.new(Config.SPECTATOR_POINT)
	task.wait(Config.RESPAWN_DELAY)
	if not model.Parent or Fighters.get(model) == nil or model:GetAttribute("Eliminated") then
		respawning[model] = nil
		model:SetAttribute("Away", false)
		return
	end
	if model:GetScale() ~= 1 then
		model:ScaleTo(1) -- après un coup fatal qui rapetisse
	end
	resetFighterState(model)
	model:SetAttribute("Away", false)

	local data = CharacterList[model:GetAttribute("Character") or Config.DEFAULT_CHARACTER]
	local spec = data and data.respawn or {}
	local platform, place = buildPlatform(spec.platform)
	local final = respawnPoint(model)
	local rootAbove = humanoid.HipHeight + root.Size.Y / 2
	local function put(top)
		place(top)
		root.CFrame = CFrame.lookAt(top + Vector3.new(0, rootAbove, 0), top + Vector3.new(1, rootAbove, Config.TURN_TO_CAMERA))
	end
	-- tous les clients jouent l'animation d'entrée du perso à partir de cet instant
	model:SetAttribute("RespawnStart", workspace:GetServerTimeNow())
	local start = os.clock()
	while os.clock() - start < Config.RESPAWN_DESCENT do
		local t = (os.clock() - start) / Config.RESPAWN_DESCENT
		put(final + Vector3.new(0, Config.RESPAWN_DROP * (1 - t) ^ 3, 0))
		RunService.Heartbeat:Wait()
	end
	put(final)
	task.wait(math.max(0, (spec.duration or 1.2) - Config.RESPAWN_DESCENT))
	respawning[model] = nil
	if not model.Parent or model:GetAttribute("Eliminated") then
		platform:Destroy()
		return
	end
	root.Anchored = false
	platforms[model] = { model = platform, x = final.X, top = final.Y + rootAbove, expires = os.clock() + Config.RESPAWN_PLATFORM_TIME }
end

------------------------------------------------------------------------ Éjections
-- Un perso sort de l'arène (ou subit un coup fatal) : points, vie perdue, puis retour
local function knockOut(model, creditTo)
	local s = Fighters.get(model)
	local root = Fighters.root(model)
	if not s or not root then
		return
	end
	local position = root.Position
	if creditTo == nil and s.lastHitBy and os.clock() - (s.lastHitAt or 0) <= Config.KO_CREDIT_TIME then
		creditTo = s.lastHitBy
	end
	if creditTo == model or (creditTo and not Fighters.get(creditTo)) then
		creditTo = nil
	end
	addAttribute(model, "Falls", 1)
	addAttribute(model, "Score", -1)
	if creditTo then
		addAttribute(creditTo, "KOs", 1)
		addAttribute(creditTo, "Score", 1)
	end
	if fxRemote then
		fxRemote:FireAllClients("KO", { target = model, attacker = creditTo, position = position })
	end
	resetFighterState(model)

	if Config.MATCH_MODE == "stock" or suddenDeath then
		local stocks = (model:GetAttribute("Stocks") or 1) - 1
		model:SetAttribute("Stocks", stocks)
		if stocks <= 0 then
			eliminate(model)
			Match.checkWinner()
			return
		end
	end
	task.spawn(respawn, model)
end

local function isOutOfBounds(position)
	local b = Config.BLAST
	return position.X < b.left or position.X > b.right or position.Y > b.top or position.Y < b.bottom
end

-- Coup fatal : l'adversaire le plus proche doit être achevable (dans le rouge ; sur sa dernière vie en mode vies)
function Match.tryFatal(attacker, fatalId)
	if roundOver then
		return
	end
	local character = CharacterList[attacker:GetAttribute("Character")]
	local fatal = nil
	for index, f in ipairs(character and character.fatals or {}) do
		-- fatals débloqués par la maîtrise du perso (voir server/Lobby.lua)
		if f.id == fatalId and (not Match.fatalAllowed or Match.fatalAllowed(attacker, index)) then
			fatal = f
		end
	end
	local attackerRoot = Fighters.root(attacker)
	if not fatal or not attackerRoot then
		return
	end

	local target, bestDistance = nil, Config.FATAL_RANGE
	for _, model in ipairs(Fighters.all()) do
		local root = Fighters.root(model)
		if model ~= attacker and root and model:GetAttribute("Finishable") and not model:GetAttribute("Eliminated") then
			local distance = (root.Position - attackerRoot.Position).Magnitude
			if distance <= bestDistance then
				target, bestDistance = model, distance
			end
		end
	end
	if not target then
		return
	end

	target:SetAttribute("Finishable", false)
	Combat.releaseGrabs(target)
	Combat.releaseGrabs(attacker)
	Fighters.stun(target, 10)
	Fighters.get(target).invulnUntil = os.clock() + 10
	Fighters.get(attacker).busyUntil = os.clock() + 3
	local targetRoot = Fighters.root(target)
	targetRoot.AssemblyLinearVelocity = Vector3.zero
	targetRoot.Anchored = true
	Match.setMessage(string.upper(fatal.label) .. " !", 3)
	if fxRemote then
		fxRemote:FireAllClients("Fatal", { attacker = attacker, target = target, id = fatal.id })
	end

	Fatals.play(fatal.id, attacker, target, fatal)
	if target.Parent and Fighters.get(target) then
		Fighters.get(target).invulnUntil = 0
		knockOut(target, attacker)
	end
end

------------------------------------------------------------------------ Manches
startRound = function()
	for model in pairs(platforms) do
		leavePlatform(model)
	end
	Pickups.reset(true)
	for index, model in ipairs(Fighters.all()) do
		Combat.releaseGrabs(model)
		Pickups.clear(model)
		Pickups.disarm(model)
		Specials.clear(model)
		Fighters.resetAttributes(model)
		local s = Fighters.get(model)
		s.busyUntil = 0
		s.stunnedUntil = 0
		s.invulnUntil = os.clock() + 1
		s.immunity = {}
		s.lastHitBy = nil
		if model:GetScale() ~= 1 then
			model:ScaleTo(1)
		end
		local root = Fighters.root(model)
		if root and not respawning[model] then
			root.Anchored = false
			root.AssemblyLinearVelocity = Vector3.zero
			model:PivotTo(spawnCFrame(index))
		end
	end
	roundOver = false
	suddenDeath = false
	workspace:SetAttribute("SuddenDeath", false)
	workspace:SetAttribute("MatchMode", Config.MATCH_MODE)
	workspace:SetAttribute("MatchEndsAt", Config.MATCH_MODE == "time" and workspace:GetServerTimeNow() + Config.MATCH_TIME or 0)
	Match.setMessage("COMBAT !", 1.5)
end

local reloaded = {}

-- Spectateur (au salon, ou pas dans la partie) : le perso attend hors de l'arène, sans être un combattant
local function park(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then
		root.Anchored = true
		root.CFrame = CFrame.new(Config.SPECTATOR_POINT + Vector3.new(math.random(-20, 20), 20, 0))
	end
	character:SetAttribute("Parked", true)
end
Match.park = park


-- Règles de la partie : mode "time" (aux points), "stock" (aux vies) ou "training" (sans fin)
function Match.configure(mode, seconds)
	Config.MATCH_MODE = mode
	Config.MATCH_TIME = seconds or Config.MATCH_TIME
end

function Match.begin()
	active = true
	startRound()
	if Config.MATCH_MODE == "training" then
		workspace:SetAttribute("MatchEndsAt", 0)
	end
end

-- Fin de partie : plus de combattants, les joueurs retournent au salon
function Match.stop()
	active = false
	roundOver = true
	suddenDeath = false
	workspace:SetAttribute("MatchEndsAt", 0)
	workspace:SetAttribute("SuddenDeath", false)
	Pickups.reset(false)
	for model in pairs(platforms) do
		leavePlatform(model)
	end
	for _, model in ipairs(Fighters.all()) do
		Combat.releaseGrabs(model)
		Pickups.clear(model)
		Specials.clear(model)
		Fighters.unregister(model)
		model:SetAttribute("Eliminated", false)
		if Players:GetPlayerFromCharacter(model) then
			park(model)
		end
	end
end

function Match.isActive()
	return active
end

local function onCharacterAdded(player, character)
	-- Perso apparu avec l'avatar Roblox du joueur (avant que le jeu ne mette son corps standard) : on le refait
	local starter = StarterPlayer:FindFirstChild("StarterCharacter")
	if starter and starter:GetAttribute("BagarreBody") and not character:GetAttribute("BagarreBody") and not reloaded[player] then
		reloaded[player] = true
		task.defer(player.LoadCharacter, player)
		return
	end
	local humanoid = character:WaitForChild("Humanoid")
	character:WaitForChild("HumanoidRootPart")
	Match.setupHumanoid(humanoid)
	local characterId = Match.characterFor and Match.characterFor(player) or (not Match.characterFor and Config.DEFAULT_CHARACTER) or nil
	local characterData = characterId and CharacterList[characterId]
	if not characterData then
		-- pas dans la partie : costume du perso choisi au salon, et on attend hors de l'arène
		local choice = CharacterList[player:GetAttribute("Choice") or ""] or CharacterList[Config.DEFAULT_CHARACTER]
		task.spawn(Costumes.apply, character, choice.costume)
		park(character)
		return
	end
	character:SetAttribute("Parked", false)
	Costumes.apply(character, characterData.costume)
	Match.registerFighter(character, characterData.id, player.DisplayName)
	task.wait()
	character:PivotTo(spawnCFrame(#Fighters.all()))
	if roundOver or suddenDeath then
		eliminate(character)
	end
end

function Match.start()
	local function onPlayer(player)
		player.CharacterAdded:Connect(function(character)
			onCharacterAdded(player, character)
		end)
		if player.Character then
			task.spawn(onCharacterAdded, player, player.Character)
		end
	end
	Players.PlayerAdded:Connect(onPlayer)
	for _, player in ipairs(Players:GetPlayers()) do
		onPlayer(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		reloaded[player] = nil
		task.defer(Match.checkWinner)
	end)

	workspace:SetAttribute("SuddenDeath", false)
	workspace:SetAttribute("MatchMode", Config.MATCH_MODE)
	workspace:SetAttribute("MatchEndsAt", 0)
	roundOver = true -- rien ne se passe avant que le salon lance une partie (Match.begin)
	-- objets à ramasser ; la bombe éjecte d'office (comme une chute, avec le point pour celui qui l'a lancée)
	Pickups.start(fxRemote, function(model, creditTo)
		if not roundOver and not respawning[model] then
			knockOut(model, creditTo)
		end
	end)

	RunService.Heartbeat:Connect(function()
		local now = os.clock()
		for _, model in ipairs(Fighters.all()) do
			local root = Fighters.root(model)
			if root and not root.Anchored and not respawning[model] and not model:GetAttribute("Eliminated") and isOutOfBounds(root.Position) then
				knockOut(model)
			end
			-- on quitte la plateforme de retour en s'en éloignant, en sautant, ou au bout du temps
			local entry = platforms[model]
			if entry and root then
				local p = root.Position
				if now > entry.expires or math.abs(p.X - entry.x) > 3.5 or p.Y > entry.top + 2.5 or p.Y < entry.top - 1.5 then
					leavePlatform(model)
				end
			end
		end
		local endsAt = workspace:GetAttribute("MatchEndsAt") or 0
		if active and not roundOver and not suddenDeath and endsAt > 0 and workspace:GetServerTimeNow() >= endsAt then
			endOfTime()
		end
	end)
end

return Match

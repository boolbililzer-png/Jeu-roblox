-- Salon et déroulé des parties (voir docs/gameplay-progression.md) :
--   1. Salon : chaque joueur choisit son perso (gratuits, rotation de la semaine, achetés), vote pour un mode,
--      le premier joueur prêt (l'hôte) choisit l'arène et les pièges ON/OFF, puis « PRÊT ».
--   2. Partie : Bagarre générale (4, chacun pour soi, 3 min), Duel (1v1, 3 vies), Aventure (5 combats contre des
--      bots, en équipe), Entraînement (le mannequin, sans fin). Les places libres sont prises par des bots.
--   3. Résultats : pièces (~30 par partie) et expérience de maîtrise du perso joué, puis retour au salon.
-- Canal « Menu » (client → serveur) : choose, buy, mode, arena, traps, ready, leave.
-- Attributs lus par le menu : workspace Phase / LobbyText / Countdown / Mode / Stage / Host ;
-- joueur Choice / Ready / VoteMode / Coins / Owned / Mastery.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local Roster = require(Shared:WaitForChild("Roster"))
local Arenas = require(Shared:WaitForChild("Arenas"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))
local Match = require(script.Parent:WaitForChild("Match"))
local Arena = require(script.Parent:WaitForChild("Arena"))
local Hazards = require(script.Parent:WaitForChild("Hazards"))
local Bot = require(script.Parent:WaitForChild("Bot"))
local Dummy = require(script.Parent:WaitForChild("Dummy"))
local Profile = require(script.Parent:WaitForChild("Profile"))

local Lobby = {}

local menuRemote = nil
local rng = Random.new()
local participants = {} -- player -> id du perso joué
local current = nil -- { mode, arena, stage, startedAt }
local countdownToken = 0
local hostId = 0
local arenaChoice = "random"
local trapsOn = true

local MODES = {}
for _, mode in ipairs(Roster.MODES) do
	MODES[mode.id] = mode
end

local function setPhase(phase, text)
	workspace:SetAttribute("Phase", phase)
	workspace:SetAttribute("LobbyText", text or "")
end

local function toast(player, text)
	if menuRemote then
		menuRemote:FireClient(player, "toast", text)
	end
end

local function playable()
	local list = {}
	for _, id in ipairs(Roster.ORDER) do
		if CharacterList[id] then
			table.insert(list, id)
		end
	end
	return list
end

local function randomCharacter(exclude)
	local list = {}
	for _, id in ipairs(playable()) do
		if not exclude[id] then
			table.insert(list, id)
		end
	end
	if #list == 0 then
		list = playable()
	end
	return list[rng:NextInteger(1, #list)]
end

local function readyPlayers()
	local list = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player:GetAttribute("Ready") then
			table.insert(list, player)
		end
	end
	table.sort(list, function(a, b)
		return (a:GetAttribute("ReadyAt") or 0) < (b:GetAttribute("ReadyAt") or 0)
	end)
	return list
end

-- Mode le plus voté parmi les joueurs prêts (à égalité : celui de l'hôte)
local function votedMode(ready)
	local counts, best, bestCount = {}, nil, 0
	for i, player in ipairs(ready) do
		local mode = MODES[player:GetAttribute("VoteMode") or ""] and player:GetAttribute("VoteMode") or "brawl"
		counts[mode] = (counts[mode] or 0) + 1 + (i == 1 and 0.5 or 0)
	end
	for mode, count in pairs(counts) do
		if count > bestCount then
			best, bestCount = mode, count
		end
	end
	return best or "brawl"
end

local function pickArena(preferOwner)
	if preferOwner then
		for _, arena in ipairs(Arenas.LIST) do
			if arena.owner == preferOwner then
				return arena.id
			end
		end
	end
	if Arenas.BY_ID[arenaChoice] then
		return arenaChoice
	end
	return Arenas.LIST[rng:NextInteger(1, #Arenas.LIST)].id
end

local function updateLobbyText()
	if workspace:GetAttribute("Phase") ~= "lobby" then
		return
	end
	local ready = #readyPlayers()
	local total = #Players:GetPlayers()
	workspace:SetAttribute("LobbyText", ready == 0 and "Choisis ton perso et ton mode, puis PRÊT !"
		or string.format("%d / %d prêt(s)", ready, total))
end

------------------------------------------------------------------------ Lancement d'une partie
local function spawnPlayers(list)
	for _, player in ipairs(list) do
		player:LoadCharacter()
	end
	-- on attend que chaque perso soit inscrit comme combattant
	local deadline = os.clock() + 6
	while os.clock() < deadline do
		local all = true
		for _, player in ipairs(list) do
			local character = player.Character
			if not character or not Fighters.get(character) then
				all = false
			end
		end
		if all then
			break
		end
		task.wait(0.1)
	end
end

local function setTeam(model, team)
	model:SetAttribute("Team", team or "")
end

local function prepareArena(arenaId)
	Hazards.stop()
	local theme = Arena.build(arenaId)
	Bot.tagSoftPlatforms()
	workspace:SetAttribute("Traps", trapsOn)
	return theme
end

-- Aventure : 5 combats de plus en plus durs, chacun dans l'arène de son adversaire principal
local STAGES = {
	{ bots = 1, difficulty = 1 },
	{ bots = 1, difficulty = 2 },
	{ bots = 2, difficulty = 2 },
	{ bots = 2, difficulty = 3 },
	{ bots = 1, difficulty = 5, boss = true },
}

local function startStage(stageIndex)
	local humans = {}
	for player in pairs(participants) do
		if player.Parent then
			table.insert(humans, player)
		end
	end
	if #humans == 0 then
		Lobby.backToLobby()
		return
	end
	local stage = STAGES[stageIndex]
	current.stage = stageIndex
	workspace:SetAttribute("Stage", stageIndex)
	local taken = {}
	for _, id in pairs(participants) do
		taken[id] = true
	end
	local opponents = {}
	for _ = 1, stage.bots do
		local id = randomCharacter(taken)
		taken[id] = true
		table.insert(opponents, id)
	end
	prepareArena(pickArena(opponents[1]))
	Config.TEAMS = true
	Match.configure("stock")
	spawnPlayers(humans)
	for _, player in ipairs(humans) do
		if player.Character then
			setTeam(player.Character, "Rouge")
		end
	end
	for i, id in ipairs(opponents) do
		local data = CharacterList[id]
		local name = (stage.boss and "BOSS " or "") .. (data and data.name or id)
		local model = Bot.spawn(id, stage.difficulty, CFrame.new(Config.SPAWN_POINTS[(i % #Config.SPAWN_POINTS) + 1]), name)
		setTeam(model, "Bleu")
	end
	Match.begin()
	Hazards.start(Arena.current())
	Match.setMessage("COMBAT " .. stageIndex .. " / " .. #STAGES .. (stage.boss and " : LE BOSS !" or ""), 2.5)
end

local function startMatch(mode, ready)
	countdownToken += 1
	table.clear(participants)
	current = { mode = mode, startedAt = os.clock(), stage = 0 }
	workspace:SetAttribute("Mode", mode)
	workspace:SetAttribute("Stage", 0)
	setPhase("match", MODES[mode].name)
	for _, player in ipairs(Players:GetPlayers()) do
		player:SetAttribute("Ready", false)
	end

	-- qui joue : les premiers prêts (places limitées), les autres regardent
	local slots = (mode == "duel" and 2) or (mode == "adventure" and 2) or 4
	local humans = {}
	for _, player in ipairs(ready) do
		if #humans < slots then
			local choice = player:GetAttribute("Choice") or Config.DEFAULT_CHARACTER
			if not CharacterList[choice] or not Profile.canPlay(player, choice) then
				choice = Config.DEFAULT_CHARACTER
			end
			participants[player] = choice
			table.insert(humans, player)
		end
	end

	if mode == "adventure" then
		startStage(1)
		return
	end

	Config.TEAMS = false
	prepareArena(pickArena(nil))
	if mode == "training" then
		Match.configure("training")
		spawnPlayers(humans)
		Dummy.spawn()
	elseif mode == "duel" then
		Match.configure("stock")
		spawnPlayers(humans)
	else
		Match.configure("time", 180)
		spawnPlayers(humans)
	end
	-- places libres : des bots (difficulté moyenne)
	local wanted = (mode == "duel" and 2) or (mode == "brawl" and 4) or 0
	local taken = {}
	for _, id in pairs(participants) do
		taken[id] = true
	end
	for i = #humans + 1, wanted do
		local id = randomCharacter(taken)
		taken[id] = true
		Bot.spawn(id, rng:NextInteger(2, 3), CFrame.new(Config.SPAWN_POINTS[i]), Bot.randomName() .. " (" .. (CharacterList[id].name or id) .. ")")
	end
	Match.begin()
	if mode ~= "training" then
		Hazards.start(Arena.current())
	end
end

------------------------------------------------------------------------ Fin de partie
local function finishMatch(winnerGroup)
	local mode = current and current.mode or "brawl"
	-- récompenses : ~30 pièces par partie, XP de maîtrise du perso joué (rien en Entraînement)
	for player, characterId in pairs(participants) do
		local character = player.Character
		if player.Parent and character then
			local kos = character:GetAttribute("KOs") or 0
			local won = winnerGroup ~= nil and Match.groupOf(character) == winnerGroup
			local coins, xp = 0, 0
			if mode == "adventure" then
				local stages = math.max(0, (current.stage or 1) - (won and 0 or 1))
				coins = 8 * stages + (won and current.stage == #STAGES and 20 or 0) + 4
				xp = 30 * stages + 15
			elseif mode ~= "training" then
				coins = math.clamp(15 + 5 * kos + (won and 15 or 0), 10, 50)
				xp = 40 + 10 * kos + (won and 20 or 0)
			end
			local result = Profile.reward(player, characterId, coins, xp) or {}
			result.won = won
			result.mode = mode
			result.character = characterId
			result.stage = current.stage
			if menuRemote then
				menuRemote:FireClient(player, "results", result)
			end
		end
	end
	Lobby.backToLobby(true)
end

function Lobby.backToLobby(showResults)
	Hazards.stop()
	Match.stop()
	Bot.clearAll()
	local dummy = workspace:FindFirstChild("Mannequin")
	if dummy then
		dummy:Destroy()
	end
	table.clear(participants)
	current = nil
	Config.TEAMS = false
	workspace:SetAttribute("Stage", 0)
	setPhase(showResults and "results" or "lobby", showResults and "Résultats" or "")
	task.delay(showResults and 7 or 0, function()
		if workspace:GetAttribute("Phase") == "results" or not showResults then
			setPhase("lobby")
			updateLobbyText()
		end
	end)
end

Match.onEnd = function(winnerGroup)
	if current and current.mode == "adventure" and winnerGroup == "Rouge" and current.stage < #STAGES then
		-- combat gagné : on passe au suivant
		Hazards.stop()
		Match.stop()
		Bot.clearAll()
		Match.setMessage("COMBAT SUIVANT…", 2)
		task.delay(2.5, function()
			if current and current.mode == "adventure" then
				startStage(current.stage + 1)
			end
		end)
		return
	end
	finishMatch(winnerGroup)
end

Match.characterFor = function(player)
	return participants[player]
end

-- Fatals débloqués : le 1er tout de suite, le 2e au niveau de maîtrise 5, le 3e au niveau 15 (les bots n'en font pas)
Match.fatalAllowed = function(attacker, index)
	local player = Players:GetPlayerFromCharacter(attacker)
	if not player then
		return false
	end
	local id = attacker:GetAttribute("Character")
	return index <= Roster.fatalsUnlocked(Profile.level(player, id))
end

------------------------------------------------------------------------ Salon
local function tryStart()
	if workspace:GetAttribute("Phase") ~= "lobby" then
		return
	end
	local ready = readyPlayers()
	updateLobbyText()
	if #ready == 0 then
		countdownToken += 1
		workspace:SetAttribute("Countdown", 0)
		return
	end
	local all = #ready == #Players:GetPlayers()
	-- tout le monde est prêt : 3 s ; sinon on laisse 15 s aux retardataires
	local delay = all and 3 or 15
	countdownToken += 1
	local token = countdownToken
	workspace:SetAttribute("Countdown", workspace:GetServerTimeNow() + delay)
	task.delay(delay, function()
		if token ~= countdownToken or workspace:GetAttribute("Phase") ~= "lobby" then
			return
		end
		local stillReady = readyPlayers()
		if #stillReady == 0 then
			return
		end
		workspace:SetAttribute("Countdown", 0)
		startMatch(votedMode(stillReady), stillReady)
	end)
end

local function onMenu(player, action, value)
	if typeof(action) ~= "string" then
		return
	end
	local phase = workspace:GetAttribute("Phase")
	if action == "choose" and typeof(value) == "string" and CharacterList[value] then
		if Profile.canPlay(player, value) then
			player:SetAttribute("Choice", value)
		else
			toast(player, "🔒 Perso verrouillé : achète-le ou attends la rotation")
		end
	elseif action == "buy" and typeof(value) == "string" then
		local ok, reason = Profile.buy(player, value)
		toast(player, ok and ("🎉 " .. ((CharacterList[value] and CharacterList[value].name) or value) .. " est à toi !") or ("❌ " .. tostring(reason)))
		if ok then
			player:SetAttribute("Choice", value)
		end
	elseif action == "mode" and typeof(value) == "string" and MODES[value] then
		player:SetAttribute("VoteMode", value)
	elseif action == "arena" and typeof(value) == "string" and (value == "random" or Arenas.BY_ID[value]) then
		if hostId == 0 or hostId == player.UserId then
			arenaChoice = value
			workspace:SetAttribute("ArenaChoice", value)
		else
			toast(player, "C'est l'hôte qui choisit l'arène")
		end
	elseif action == "traps" and typeof(value) == "boolean" then
		if hostId == 0 or hostId == player.UserId then
			trapsOn = value
			workspace:SetAttribute("TrapsChoice", value)
		end
	elseif action == "ready" and typeof(value) == "boolean" and phase == "lobby" then
		player:SetAttribute("Ready", value)
		player:SetAttribute("ReadyAt", value and os.clock() or 0)
		if value and (hostId == 0 or not Players:GetPlayerByUserId(hostId)) then
			hostId = player.UserId
			workspace:SetAttribute("Host", hostId)
		end
		tryStart()
	elseif action == "leave" and current and current.mode == "training" and participants[player] then
		Lobby.backToLobby(false)
	end
end

function Lobby.start(remote)
	menuRemote = remote
	Bot.init(Match.registerFighter, Match.setupHumanoid)
	remote.OnServerEvent:Connect(onMenu)
	prepareArena(Arenas.DEFAULT)
	workspace:SetAttribute("ArenaChoice", "random")
	workspace:SetAttribute("TrapsChoice", true)
	workspace:SetAttribute("Countdown", 0)
	setPhase("lobby")

	local function onPlayer(player)
		player:SetAttribute("Choice", Config.DEFAULT_CHARACTER)
		player:SetAttribute("VoteMode", "brawl")
		player:SetAttribute("Ready", false)
		Profile.load(player)
		player:SetAttribute("Rotation", table.concat((function()
			local list = {}
			for id in pairs(Roster.rotation()) do
				table.insert(list, id)
			end
			return list
		end)(), ","))
		updateLobbyText()
	end
	Players.PlayerAdded:Connect(onPlayer)
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(onPlayer, player)
	end
	Players.PlayerRemoving:Connect(function(player)
		participants[player] = nil
		if hostId == player.UserId then
			hostId = 0
			workspace:SetAttribute("Host", 0)
		end
		task.defer(function()
			-- plus aucun joueur dans la partie : retour au salon
			if current then
				local anyone = false
				for p in pairs(participants) do
					if p.Parent then
						anyone = true
					end
				end
				if not anyone then
					Lobby.backToLobby(false)
				end
			end
			tryStart()
		end)
	end)
end

return Lobby

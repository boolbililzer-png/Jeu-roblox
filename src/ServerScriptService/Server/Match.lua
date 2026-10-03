-- Déroulement des parties : salon (choix du perso) -> compte à rebours -> combat aux vies
-- (éjection hors des Blast Zones = vie perdue) -> écran de victoire -> retour au salon.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local GameData = require(Shared.GameData)
local Fighters = require(Shared.Fighters)

local Fighter = require(script.Parent.Fighter)
local Combat = require(script.Parent.Combat)
local Passives = require(script.Parent.Passives)
local ArenaBuilder = require(script.Parent.ArenaBuilder)
local ArenaTraps = require(script.Parent.ArenaTraps)
local Crates = require(script.Parent.Crates)
local Bot = require(script.Parent.Bot)

local Match = {}
local state: Configuration
local selections: { [Player]: { key: string?, ready: boolean } } = {}
local byPlayer: { [Player]: any } = {}
local bots: { any } = {}
local phase = "Lobby"
local endsAt = 0

local function now(): number
	return workspace:GetServerTimeNow()
end

local function setPhase(p: string)
	phase = p
	state:SetAttribute("Phase", p)
end

function Match.phase(): string
	return phase
end

function Match.fighterOf(player: Player)
	return byPlayer[player]
end

local function publishLobby()
	local parts = {}
	for plr, s in selections do
		table.insert(parts, ("%s:%s:%s"):format(plr.DisplayName, s.key or "-", if s.ready then "1" else "0"))
	end
	state:SetAttribute("Lobby", table.concat(parts, ";"))
end

function Match.onLobbyAction(player: Player, action: string, data)
	if action == "select" and type(data) == "string" and Fighters.get(data) then
		selections[player] = selections[player] or { ready = false }
		selections[player].key = data
	elseif action == "ready" then
		selections[player] = selections[player] or { ready = false }
		if selections[player].key then
			selections[player].ready = data == true
		end
	elseif action == "settings" and type(data) == "table" and phase == "Lobby" then
		if type(data.bots) == "number" then
			Config.BotsToFill = math.clamp(math.floor(data.bots), 0, 3)
			state:SetAttribute("BotsToFill", Config.BotsToFill)
		end
		if type(data.traps) == "boolean" then
			Config.TrapsEnabled = data.traps
			state:SetAttribute("Traps", Config.TrapsEnabled)
		end
	end
	publishLobby()
end

local function spawnFighter(f, index: number)
	local L = GameData.Layout
	local sp = L.spawns[((index - 1) % #L.spawns) + 1]
	local h = Fighters.get(f.key).look.scale[1]
	local cf = CFrame.new(sp[1], L.stage.top + 0.2, 0)
	f:spawn(cf)
	f.model:PivotTo(CFrame.new(sp[1], L.stage.top + 2.8 * h + 0.3, 0))
	Passives.init(f)
	f.invulnUntil = now() + 1
end

local function startMatch()
	setPhase("Countdown")
	Combat.enabled = false
	Fighter.clearAll()
	Combat.clear()
	table.clear(byPlayer)
	table.clear(bots)

	local chosen = {}
	local humans = {}
	for plr, s in selections do
		if plr.Parent and s.ready and s.key then
			table.insert(humans, plr)
			chosen[s.key] = true
		end
	end
	-- arène : celle du perso d'un joueur tiré au sort (son « chez-lui »)
	local arenaOwner = selections[humans[math.random(1, #humans)]].key
	local arenaKey = Fighters.get(arenaOwner).arena
	ArenaBuilder.build(arenaKey)
	state:SetAttribute("Arena", arenaKey)

	local index = 1
	for _, plr in humans do
		local f = Fighter.new(selections[plr].key, plr)
		byPlayer[plr] = f
		spawnFighter(f, index)
		index += 1
	end
	local nBots = math.min(Config.MaxFighters - #humans, math.max(Config.BotsToFill, if #humans < 2 then 1 else 0))
	for _ = 1, nBots do
		local pool = {}
		for _, fd in GameData.Fighters do
			if not chosen[fd.key] then
				table.insert(pool, fd.key)
			end
		end
		local key = pool[math.random(1, #pool)]
		chosen[key] = true
		local f = Fighter.new(key, nil, "Bot " .. Fighters.get(key).name)
		spawnFighter(f, index)
		index += 1
		f.mc.onDodge = function()
			Combat.onAction(f, "dodge", {})
		end
		table.insert(bots, Bot.new(f, 0.55 + math.random() * 0.3))
	end

	for i = Config.CountdownTime, 1, -1 do
		state:SetAttribute("Countdown", i)
		task.wait(1)
	end
	state:SetAttribute("Countdown", 0)
	Crates.reset()
	ArenaTraps.start(arenaKey)
	Combat.enabled = true
	endsAt = now() + Config.MatchTime
	setPhase("Fight")
end

local function finish(reason: string)
	if phase ~= "Fight" then
		return
	end
	setPhase("End")
	Combat.enabled = false
	ArenaTraps.stop()
	-- classement : vies restantes puis % le plus bas
	local ranking = table.clone(Fighter.list)
	table.sort(ranking, function(a, b)
		if a.stocks ~= b.stocks then
			return a.stocks > b.stocks
		end
		return a.damage < b.damage
	end)
	local winner = ranking[1]
	state:SetAttribute("Winner", if winner then winner.name else "")
	state:SetAttribute("WinnerKey", if winner then winner.key else "")
	state:SetAttribute("EndReason", reason)
	local lines = {}
	for i, f in ranking do
		table.insert(lines, ("%d. %s — %d KO · %d chutes · %d %% infligés"):format(i, f.name, f.stats.kos, f.stats.falls, math.floor(f.stats.dealt)))
	end
	state:SetAttribute("Results", table.concat(lines, "\n"))
	if winner and winner:alive() then
		Combat.broadcast("Victory", winner.model)
	end
	task.delay(Config.EndScreenTime, function()
		Fighter.clearAll()
		Combat.clear()
		table.clear(byPlayer)
		table.clear(bots)
		for _, s in selections do
			s.ready = false
		end
		for _, plr in Players:GetPlayers() do
			plr.Character = nil
		end
		publishLobby()
		setPhase("Lobby")
	end)
end

local function ko(f)
	local L = GameData.Layout
	f.dead = true
	f.stocks -= 1
	f.stats.falls += 1
	local killer = f.lastHitBy
	if killer and killer ~= f and now() - (f.lastHitT or 0) < 8 then
		killer.stats.kos += 1
	end
	local pos = f:position()
	Combat.broadcast("Fx", "ko", Vector3.new(math.clamp(pos.X, L.blast.left + 10, L.blast.right - 10), math.clamp(pos.Y, L.blast.bottom + 10, L.blast.top - 10), 0), f.data.look.body.torso, f.name)
	f:interrupt()
	f:clearStatuses()
	f.hrp.Anchored = true
	f.model:PivotTo(CFrame.new(0, 400, -300))
	f:sync()
	task.delay(Config.RespawnDelay, function()
		if phase ~= "Fight" or not f.model then
			return
		end
		if f.stocks <= 0 then
			f.eliminated = true
			f.model:SetAttribute("Eliminated", true)
			return
		end
		-- Retour 🪂 : descend en parachute, protégé quelques instants
		f.damage = 0
		f.armed = false
		f.dead = false
		f.recoveryUsed = false
		f.invulnUntil = now() + Config.RespawnInvuln
		f.model:SetAttribute("Parachute", now() + 2.2)
		f.model:SetAttribute("Invuln", f.invulnUntil)
		local r = L.respawn
		f.hrp.Anchored = false
		f:teleport(CFrame.new(r[1], r[2], 0))
		if f.player then
			pcall(function()
				f.hrp:SetNetworkOwner(f.player)
			end)
		end
		Passives.init(f)
		f:sync()
		Combat.broadcast("Fx", "respawn", f.model)
	end)
end

local function step(dt: number)
	if phase == "Lobby" then
		local ready, total = 0, 0
		for plr, s in selections do
			if plr.Parent then
				total += 1
				if s.ready then
					ready += 1
				end
			end
		end
		if total > 0 and ready == total then
			task.spawn(startMatch)
		end
		return
	end
	for _, b in bots do
		b:step(dt)
	end
	if phase ~= "Fight" then
		return
	end
	Combat.tick(dt)
	Crates.tick(GameData.Layout)
	ArenaTraps.tick()
	local B = GameData.Layout.blast
	local alive, humansAlive = 0, 0
	for _, f in table.clone(Fighter.list) do
		if f.model and not f.dead and not f.eliminated then
			local p = f:position()
			if p.X < B.left or p.X > B.right or p.Y < B.bottom or p.Y > B.top then
				ko(f)
			end
		end
		if not f.eliminated then
			alive += 1
			if f.player then
				humansAlive += 1
			end
		end
	end
	state:SetAttribute("TimeLeft", math.max(0, math.ceil(endsAt - now())))
	if alive <= 1 then
		finish("ko")
	elseif humansAlive == 0 and next(byPlayer) ~= nil then
		finish("ko")
	elseif now() >= endsAt then
		finish("time")
	end
end

function Match.init()
	state = Instance.new("Configuration")
	state.Name = "GameState"
	state.Parent = ReplicatedStorage
	state:SetAttribute("Phase", "Lobby")
	state:SetAttribute("BotsToFill", Config.BotsToFill)
	state:SetAttribute("Traps", Config.TrapsEnabled)
	ArenaBuilder.build("bar")
	Players.PlayerAdded:Connect(function(plr)
		selections[plr] = { ready = false }
		publishLobby()
	end)
	for _, plr in Players:GetPlayers() do
		selections[plr] = { ready = false }
	end
	Players.PlayerRemoving:Connect(function(plr)
		selections[plr] = nil
		local f = byPlayer[plr]
		if f then
			byPlayer[plr] = nil
			f.eliminated = true
			f:destroy()
		end
		publishLobby()
	end)
	RunService.Heartbeat:Connect(step)
end

return Match

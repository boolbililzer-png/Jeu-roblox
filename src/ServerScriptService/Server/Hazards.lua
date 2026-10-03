-- Pièges d'arène (champ trap de shared/Arenas.lua) : un par arène, annoncé 2 s à l'avance (icône + texte),
-- jamais mortel seul (≈ 5 % et un petit déséquilibre). Coupés par l'interrupteur « Pièges ON/OFF »
-- (attribut Traps de workspace, réglé au lancement de la partie).
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))

local Hazards = {}

local fxRemote = nil
local running = false
local token = 0
local rng = Random.new()

local FLOOR_TOP = 2 -- dessus du sol principal (server/Arena.lua)
local FLOOR_HALF = 45

local HIT = {
	dive = { damage = 5, kbBase = 45, kbGrowth = 25, kbAngle = 60, hitText = "COUCOU !" },
	shockwave = { damage = 4, kbBase = 55, kbGrowth = 20, kbAngle = 25, hitText = "TÛÛÛT !" },
	pillar = { damage = 5, kbBase = 70, kbGrowth = 25, kbAngle = 85, hitText = "FLAMBÉ !", burn = true, burnTime = 2 },
	sweeper = { damage = 5, kbBase = 50, kbGrowth = 25, kbAngle = 70, hitText = "VROUM !" },
	launcher = { damage = 5, kbBase = 85, kbGrowth = 20, kbAngle = 88, hitText = "ÉJECTÉ !" },
	geyser = { damage = 4, kbBase = 90, kbGrowth = 20, kbAngle = 90, hitText = "PSCHHHT !" },
	puddle = { damage = 3, kbBase = 0, kbGrowth = 0, kbAngle = 0, hitText = "GLISSS !", status = { name = "slippery", duration = 2 } },
	sand = { damage = 2, kbBase = 0, kbGrowth = 0, kbAngle = 0, hitText = "ENSABLÉ !", status = { name = "slowed", duration = 1.5 } },
}

function Hazards.setFxRemote(remote)
	fxRemote = remote
end

local function fire(kind, data)
	if fxRemote then
		fxRemote:FireAllClients(kind, data)
	end
end

local function alive()
	local list = {}
	for _, model in ipairs(Fighters.all()) do
		local root = Fighters.root(model)
		if root and not root.Anchored and not model:GetAttribute("Eliminated") and not model:GetAttribute("Away") then
			table.insert(list, model)
		end
	end
	return list
end

local function onFloor(model, x, halfWidth)
	local root = Fighters.root(model)
	if not root then
		return false
	end
	local feet = root.Position.Y - 3
	return math.abs(root.Position.X - x) <= halfWidth and feet > FLOOR_TOP - 1.5 and feet < FLOOR_TOP + 3
end

local function hitAll(kind, filter, direction)
	for _, model in ipairs(alive()) do
		if filter(model) then
			local root = Fighters.root(model)
			local dir = direction or ((root and root.Position.X >= 0) and 1 or -1)
			Fighters.hit(nil, model, HIT[kind], 1, dir)
		end
	end
end

-- Chaque piège : (trap, position annoncée) -> se joue
local RUN = {}

RUN.puddle = function(trap, x)
	fire("HazardFx", { kind = "puddle", position = Vector3.new(x, FLOOR_TOP, 0), color = trap.color, time = 4 })
	local touched = {}
	local start = os.clock()
	while os.clock() - start < 4 do
		for _, model in ipairs(alive()) do
			if not touched[model] and onFloor(model, x, 6) then
				touched[model] = true
				Fighters.hit(nil, model, HIT.puddle, 1, 1)
			end
		end
		task.wait(0.1)
	end
end

RUN.dive = function(trap)
	local list = alive()
	if #list == 0 then
		return
	end
	local target = list[rng:NextInteger(1, #list)]
	local root = Fighters.root(target)
	if root then
		fire("HazardFx", { kind = "dive", position = root.Position, color = trap.color })
		task.wait(0.35)
		if target.Parent and not target:GetAttribute("Eliminated") then
			Fighters.hit(nil, target, HIT.dive, 1, rng:NextNumber() < 0.5 and -1 or 1)
		end
	end
end

RUN.shockwave = function(trap)
	local from = rng:NextNumber() < 0.5 and -1 or 1
	fire("HazardFx", { kind = "shockwave", from = from, color = trap.color })
	task.wait(0.3)
	hitAll("shockwave", function(model)
		return onFloor(model, 0, FLOOR_HALF + 25)
	end, -from)
end

RUN.bounce = function(trap)
	fire("HazardFx", { kind = "bounce", color = trap.color })
	for _, model in ipairs(alive()) do
		if onFloor(model, 0, FLOOR_HALF) then
			local root = Fighters.root(model)
			Fighters.nudge(model, Vector3.new(root and root.AssemblyLinearVelocity.X or 0, 75, 0))
			model:SetAttribute("Damage", (model:GetAttribute("Damage") or 0) + 3)
			Fighters.updateFinishable(model)
		end
	end
end

local function statusAll(name, duration, filter)
	for _, model in ipairs(alive()) do
		if not filter or filter(model) then
			Fighters.applyStatus(model, name, duration)
		end
	end
end

RUN.spotlight = function(trap)
	local list = alive()
	local chosen = list[rng:NextInteger(1, math.max(1, #list))]
	fire("HazardFx", { kind = "spotlight", target = chosen, time = 1.5 })
end

RUN.flock = function(trap)
	fire("HazardFx", { kind = "flock", time = 1 })
	statusAll("blinded", 1)
end

RUN.ticket = function(trap)
	local list = alive()
	if #list > 0 then
		local target = list[rng:NextInteger(1, #list)]
		fire("HazardFx", { kind = "ticket", target = target })
		Fighters.applyStatus(target, "frozen", 1)
	end
end

RUN.pillar = function(trap, x)
	fire("HazardFx", { kind = "pillar", position = Vector3.new(x, FLOOR_TOP, 0), color = trap.color, time = 1.2 })
	local touched = {}
	local start = os.clock()
	while os.clock() - start < 1.2 do
		for _, model in ipairs(alive()) do
			local root = Fighters.root(model)
			if not touched[model] and root and math.abs(root.Position.X - x) < 5 and root.Position.Y < FLOOR_TOP + 30 then
				touched[model] = true
				Fighters.hit(nil, model, HIT.pillar, 1, root.Position.X >= x and 1 or -1)
			end
		end
		task.wait(0.05)
	end
end

RUN.sweeper = function(trap)
	local from = rng:NextNumber() < 0.5 and -1 or 1
	local duration = 2.4
	fire("HazardFx", { kind = "sweeper", from = from, color = trap.color, time = duration, y = FLOOR_TOP })
	local touched = {}
	local start = os.clock()
	while os.clock() - start < duration do
		local x = from * (FLOOR_HALF + 5) - from * (2 * FLOOR_HALF + 10) * ((os.clock() - start) / duration)
		for _, model in ipairs(alive()) do
			if not touched[model] and onFloor(model, x, 3) then
				touched[model] = true
				Fighters.hit(nil, model, HIT.sweeper, 1, -from)
			end
		end
		task.wait(0.03)
	end
end

RUN.conveyor = function(trap)
	local dir = rng:NextNumber() < 0.5 and -1 or 1
	-- les clients poussent leur perso tant que l'attribut est actif (voir client/Main.client.lua)
	workspace:SetAttribute("ConveyorSpeed", dir * 16)
	workspace:SetAttribute("ConveyorUntil", workspace:GetServerTimeNow() + 4)
	fire("HazardFx", { kind = "conveyor", dir = dir, time = 4, color = trap.color })
end

RUN.notifications = function(trap)
	fire("HazardFx", { kind = "notifications", time = 2 })
end

RUN.blackout = function(trap)
	fire("HazardFx", { kind = "blackout", time = 1 })
end

RUN.launcher = function(trap, x)
	fire("HazardFx", { kind = "launcher", position = Vector3.new(x, FLOOR_TOP, 0), color = trap.color })
	hitAll("launcher", function(model)
		return onFloor(model, x, 5)
	end)
end

RUN.whistle = function(trap)
	fire("HazardFx", { kind = "whistle" })
	statusAll("stunned", 0.5)
end

RUN.sand = function(trap, x)
	fire("HazardFx", { kind = "sand", position = Vector3.new(x, FLOOR_TOP, 0), color = trap.color, time = 5 })
	local start = os.clock()
	local touched = {}
	while os.clock() - start < 5 do
		for _, model in ipairs(alive()) do
			if onFloor(model, x, 7) and os.clock() >= (touched[model] or 0) then
				touched[model] = os.clock() + 1.6
				Fighters.hit(nil, model, HIT.sand, 1, 1)
			end
		end
		task.wait(0.1)
	end
end

RUN.swap = function(trap)
	local list = alive()
	if #list < 2 then
		return
	end
	local a = table.remove(list, rng:NextInteger(1, #list))
	local b = list[rng:NextInteger(1, #list)]
	local ra, rb = Fighters.root(a), Fighters.root(b)
	if ra and rb then
		local pa, pb = ra.CFrame, rb.CFrame
		fire("HazardFx", { kind = "swap", a = ra.Position, b = rb.Position })
		a:PivotTo(pb)
		b:PivotTo(pa)
	end
end

RUN.sunbeam = function(trap)
	fire("HazardFx", { kind = "sunbeam", time = 3, color = trap.color })
	statusAll("slippery", 3, function(model)
		return onFloor(model, 0, FLOOR_HALF)
	end)
end

RUN.geyser = function(trap)
	local spot = Vector3.new(rng:NextNumber() < 0.5 and -63 or 63, -6.5, 0)
	fire("GeyserWarn", { position = spot })
	task.wait(1.3)
	fire("Geyser", { position = spot })
	for _, model in ipairs(alive()) do
		local root = Fighters.root(model)
		if root then
			local offset = root.Position - spot
			if math.abs(offset.X) < 5 and offset.Y > -1 and offset.Y < 16 then
				Fighters.hit(nil, model, HIT.geyser, 1, offset.X >= 0 and 1 or -1)
			end
		end
	end
end

-- Lance la boucle des pièges de cette arène (s'arrête avec Hazards.stop ou au changement d'arène)
function Hazards.start(theme)
	Hazards.stop()
	if not theme or not theme.trap or workspace:GetAttribute("Traps") == false or not Config.ARENA_HAZARDS then
		return
	end
	running = true
	token += 1
	local myToken = token
	local trap = theme.trap
	task.spawn(function()
		task.wait(12)
		while running and token == myToken do
			local x = rng:NextNumber(-35, 35)
			-- annonce 2 s avant (icône + texte + son chez tous les joueurs)
			fire("HazardWarn", { icon = trap.icon, text = trap.text, kind = trap.kind, color = trap.color, position = Vector3.new(x, FLOOR_TOP, 0) })
			task.wait(2)
			if not running or token ~= myToken then
				break
			end
			local fn = RUN[trap.kind]
			if fn then
				local ok, err = pcall(fn, trap, x)
				if not ok then
					warn("[Piège] " .. trap.kind .. " : " .. tostring(err))
				end
			end
			task.wait(rng:NextNumber(12, 18))
		end
	end)
end

function Hazards.stop()
	running = false
	token += 1
	workspace:SetAttribute("ConveyorUntil", 0)
end

-- Bots et mannequin : le tapis de course les pousse aussi (les joueurs le font chez eux)
RunService.Heartbeat:Connect(function()
	local untilTime = workspace:GetAttribute("ConveyorUntil") or 0
	if untilTime <= workspace:GetServerTimeNow() then
		return
	end
	local speed = workspace:GetAttribute("ConveyorSpeed") or 0
	for _, model in ipairs(Fighters.all()) do
		if model:GetAttribute("IsBot") and onFloor(model, 0, FLOOR_HALF) then
			local root = Fighters.root(model)
			if root then
				root.AssemblyLinearVelocity += Vector3.new(speed * 0.05, 0, 0)
			end
		end
	end
end)

return Hazards

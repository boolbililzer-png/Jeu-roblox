-- Résolution des coups côté serveur : validation, zones de frappe, projectiles.
-- Le client lance l'action et son élan tout de suite ; le serveur décide seul de ce qui touche.
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local MoveSets = require(Shared:WaitForChild("MoveSets"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))
local Pickups = require(script.Parent:WaitForChild("Pickups"))

local Combat = {}

local fatalHandler = nil
local actionHook = nil
local fxRemote = nil
local nextProjectileId = 0

function Combat.setFatalHandler(handler)
	fatalHandler = handler
end

-- Appelée à chaque action d'un joueur (sert à quitter la plateforme de retour)
function Combat.setActionHook(hook)
	actionHook = hook
end

function Combat.setFxRemote(remote)
	fxRemote = remote
end

local function fighterFromPart(part)
	local model = part:FindFirstAncestorOfClass("Model")
	while model and not CollectionService:HasTag(model, Fighters.TAG) do
		model = model:FindFirstAncestorOfClass("Model")
	end
	return model
end

local function queryHits(attacker, cframe, size, alreadyHit)
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { attacker }
	local hits = {}
	for _, part in ipairs(workspace:GetPartBoundsInBox(cframe, size, params)) do
		local model = fighterFromPart(part)
		if model and not alreadyHit[model] then
			alreadyHit[model] = true
			table.insert(hits, model)
		end
	end
	return hits
end

local function showHitbox(cframe, size)
	if not Config.DEBUG_HITBOXES then
		return
	end
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Transparency = 0.6
	p.Color = Color3.fromRGB(255, 40, 40)
	p.Material = Enum.Material.Neon
	p.Size = size
	p.CFrame = cframe
	p.Parent = workspace
	task.delay(0.1, function()
		p:Destroy()
	end)
end

-- Bulle au-dessus de la tête avec le nom du coup (remplace les animations dans le prototype)
local function showMoveName(model, text)
	local head = model:FindFirstChild("Head")
	if not head or not Config.SHOW_MOVE_NAMES then
		return
	end
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(220, 40)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextScaled = true
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0
	label.Parent = gui
	gui.Parent = head
	task.delay(0.7, function()
		gui:Destroy()
	end)
end

local function damageMultiplier(model)
	return 1 + 0.1 * (model:GetAttribute("Bulles") or 0)
end

local function doMelee(attacker, move)
	local root = Fighters.root(attacker)
	if not root then
		return
	end
	local alreadyHit = {}
	local multiplier = damageMultiplier(attacker)
	local endTime = os.clock() + math.max(move.active, 0.03)
	local touched = false
	repeat
		if not root.Parent or Fighters.get(attacker) == nil then
			return
		end
		local facing = Fighters.facing(attacker)
		local offset = move.hitbox.offset
		local cframe = CFrame.new(root.Position + Vector3.new(offset.X * facing, offset.Y, 0))
		showHitbox(cframe, move.hitbox.size)
		for _, target in ipairs(queryHits(attacker, cframe, move.hitbox.size, alreadyHit)) do
			if Fighters.hit(attacker, target, move, multiplier, facing) then
				touched = true
			end
		end
		task.wait()
	until os.clock() >= endTime
	return touched
end

------------------------------------------------------------------------ Saisies et projections
-- ✋ au contact : le perso attrape l'adversaire (coup GRAB, kind = "grab") et le tient à bout de bras.
-- Il choisit ensuite la direction de la projection (flèche, ou ✋ / J / K = vers l'avant) ; au bout de
-- GRAB_HOLD secondes, il projette tout seul vers l'avant. Chaque perso a ses propres projections
-- (THROW_fwd / back / up / down, avec carry = trajet de la victime pendant l'élan).
local holds = {} -- celui qui tient -> { target, since, throwing = { move, start, facing } }

local function setHeldState(target, held)
	local root = Fighters.root(target)
	if root then
		root.Anchored = held
	end
	target:SetAttribute("Grabbed", held)
end

-- Lâche la saisie sans projeter (coup reçu, éjection…)
local function releaseHold(grabber)
	local h = holds[grabber]
	if not h then
		return
	end
	holds[grabber] = nil
	local gs, ts = Fighters.get(grabber), Fighters.get(h.target)
	if gs then
		gs.holding = nil
		gs.busyUntil = math.min(gs.busyUntil, os.clock())
	end
	grabber:SetAttribute("Holding", false)
	if ts then
		ts.heldBy = nil
		ts.stunnedUntil = os.clock() + 0.2
	end
	if h.target.Parent then
		setHeldState(h.target, false)
	end
end

-- Fin de saisie pour ce perso, qu'il tienne ou qu'il soit tenu
function Combat.releaseGrabs(model)
	if holds[model] then
		releaseHold(model)
	end
	local s = Fighters.get(model)
	if s and s.heldBy then
		releaseHold(s.heldBy)
	elseif model:GetAttribute("Grabbed") then
		setHeldState(model, false)
	end
end

-- Un coup reçu fait lâcher (celui qui tient) ou libère (celui qui est tenu)
Fighters.onHit = function(target)
	Combat.releaseGrabs(target)
end

local function canBeGrabbed(attacker, target)
	local ts = Fighters.get(target)
	return ts ~= nil
		and not ts.heldBy
		and not target:GetAttribute("Eliminated")
		and not target:GetAttribute("Away")
		and not target:GetAttribute("Protected")
		and not Fighters.isInvulnerable(target)
		and not (Config.TEAMS and not Config.TEAM_ATTACK and target:GetAttribute("Team") ~= "" and target:GetAttribute("Team") == attacker:GetAttribute("Team"))
end

local function startHold(attacker, target)
	local as, ts = Fighters.get(attacker), Fighters.get(target)
	Combat.releaseGrabs(target)
	Fighters.setCharging(target, false)
	Fighters.clearSmash(target)
	ts.heldBy = attacker
	ts.stunnedUntil = math.huge
	ts.lastHitBy, ts.lastHitAt = attacker, os.clock()
	as.holding = target
	as.busyUntil = os.clock() + Config.GRAB_HOLD + 0.2
	holds[attacker] = { target = target, since = os.clock() }
	setHeldState(target, true)
	attacker:SetAttribute("Holding", true)
	if fxRemote then
		local root = Fighters.root(target)
		fxRemote:FireAllClients("Grab", { attacker = attacker, target = target, position = root and root.Position })
	end
end

local function doGrab(attacker, move)
	local root = Fighters.root(attacker)
	if not root then
		return
	end
	local alreadyHit = {}
	local endTime = os.clock() + math.max(move.active, 0.05)
	repeat
		if not root.Parent or Fighters.get(attacker) == nil then
			return
		end
		local facing = Fighters.facing(attacker)
		local offset = move.hitbox.offset
		local cframe = CFrame.new(root.Position + Vector3.new(offset.X * facing, offset.Y, 0))
		showHitbox(cframe, move.hitbox.size)
		for _, target in ipairs(queryHits(attacker, cframe, move.hitbox.size, alreadyHit)) do
			if Fighters.isObese(target) then
				-- gavé de croustillant : trop lourd à soulever !
				if fxRemote then
					fxRemote:FireAllClients("TooHeavy", { target = target })
				end
			elseif canBeGrabbed(attacker, target) then
				startHold(attacker, target)
				return
			end
		end
		task.wait()
	until os.clock() >= endTime
end

-- Position de la victime pendant l'élan de la projection (carry = { {temps, avant, haut}, ... })
local function carryAt(carry, t)
	if not carry or #carry == 0 then
		return 2.4, 0.6
	end
	if t <= carry[1][1] then
		return carry[1][2], carry[1][3]
	end
	for i = 2, #carry do
		local a, b = carry[i - 1], carry[i]
		if t <= b[1] then
			local k = (t - a[1]) / math.max(b[1] - a[1], 1e-3)
			return a[2] + (b[2] - a[2]) * k, a[3] + (b[3] - a[3]) * k
		end
	end
	local last = carry[#carry]
	return last[2], last[3]
end

-- Lance la projection dans une direction ("fwd", "back", "up", "down")
function Combat.throwHeld(attacker, direction, forced)
	local h = holds[attacker]
	if not h or h.throwing then
		return
	end
	local character = CharacterList[attacker:GetAttribute("Character") or Config.DEFAULT_CHARACTER]
	local key = "THROW_" .. (direction or "fwd")
	local move = character and (character.moves[key] or character.moves.THROW_fwd)
	if not move then
		releaseHold(attacker)
		return
	end
	if not character.moves[key] then
		key = "THROW_fwd"
	end
	h.throwing = { move = move, start = os.clock(), facing = Fighters.facing(attacker) }
	local s = Fighters.get(attacker)
	s.busyUntil = os.clock() + move.startup + move.active + move.recovery
	s.lastMoveKey, s.lastMoveAt = key, os.clock()
	Combat.perform(attacker, key, move, forced)
end

-- Fin de l'élan : la victime est lâchée et part dans la direction choisie
local function finishThrow(attacker, h)
	local move = h.throwing.move
	local target = h.target
	holds[attacker] = nil
	local gs, ts = Fighters.get(attacker), Fighters.get(target)
	if gs then
		gs.holding = nil
	end
	attacker:SetAttribute("Holding", false)
	if ts then
		ts.heldBy = nil
		ts.stunnedUntil = os.clock()
	end
	setHeldState(target, false)
	local direction = h.throwing.facing * (move.back and -1 or 1)
	Fighters.hit(attacker, target, move, damageMultiplier(attacker), direction)
end

RunService.Heartbeat:Connect(function()
	local now = os.clock()
	for grabber, h in pairs(holds) do
		local groot, troot = Fighters.root(grabber), Fighters.root(h.target)
		if not groot or not troot or not groot.Parent or not troot.Parent or Fighters.get(grabber) == nil or Fighters.get(h.target) == nil
			or grabber:GetAttribute("Eliminated") or h.target:GetAttribute("Eliminated") then
			releaseHold(grabber)
		elseif h.throwing then
			local t = now - h.throwing.start
			if t >= h.throwing.move.startup then
				finishThrow(grabber, h)
			else
				local forward, up = carryAt(h.throwing.move.carry, t)
				local facing = h.throwing.facing
				local position = Vector3.new(groot.Position.X + forward * facing, groot.Position.Y + up, 0)
				troot.CFrame = CFrame.lookAt(position, Vector3.new(groot.Position.X, position.Y, 0))
			end
		else
			if now - h.since >= Config.GRAB_HOLD then
				Combat.throwHeld(grabber, "fwd", true)
			else
				local facing = Fighters.facing(grabber)
				local bob = math.sin(now * 9) * 0.15
				local position = Vector3.new(groot.Position.X + 2.4 * facing, groot.Position.Y + 0.6 + bob, 0)
				troot.CFrame = CFrame.lookAt(position, Vector3.new(groot.Position.X, position.Y, 0))
			end
		end
	end
end)

-- Le serveur calcule le trajet et les touches ; chaque client dessine le projectile (plus fluide)
local function launchProjectile(attacker, move, angleDegrees, multiplier)
	local root = Fighters.root(attacker)
	if not root then
		return
	end
	local spec = move.projectile
	local facing = Fighters.facing(attacker)
	local angle = math.rad(angleDegrees)
	local velocity = Vector3.new(math.cos(angle) * spec.speed * facing, math.sin(angle) * spec.speed, 0)
	local position = root.Position + Vector3.new(2.5 * facing, 1, 0)
	local size = Vector3.new(spec.size, spec.size, 6)

	nextProjectileId += 1
	local id = nextProjectileId
	if fxRemote then
		fxRemote:FireAllClients("Projectile", {
			id = id,
			origin = position,
			velocity = velocity,
			gravity = spec.gravity or 0,
			lifetime = spec.lifetime,
			visual = spec.visual or "ball",
			color = spec.color,
		})
	end

	local alreadyHit = { [attacker] = true }
	local elapsed = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		elapsed += dt
		velocity += Vector3.new(0, -(spec.gravity or 0) * dt, 0)
		position += velocity * dt
		local cframe = CFrame.new(position)
		showHitbox(cframe, size)
		local direction = velocity.X >= 0 and 1 or -1
		local touched = false
		for _, target in ipairs(queryHits(attacker, cframe, size, alreadyHit)) do
			if Fighters.hit(attacker, target, move, multiplier, direction) then
				touched = true
			end
		end
		if touched or elapsed >= spec.lifetime then
			connection:Disconnect()
			if fxRemote then
				fxRemote:FireAllClients("ProjectileEnd", { id = id, position = position, touched = touched })
			end
		end
	end)
end

local function doProjectile(attacker, move)
	local spec = move.projectile
	local multiplier = damageMultiplier(attacker)
	if spec.fan then
		local count = spec.fan.count
		for i = 0, count - 1 do
			local t = count > 1 and i / (count - 1) or 0
			launchProjectile(attacker, move, spec.fan.from + (spec.fan.to - spec.fan.from) * t, multiplier)
		end
	else
		launchProjectile(attacker, move, spec.angle or 0, multiplier)
	end
end

local function doSelf(attacker, move)
	if move.effect == "sip" then
		local bulles = math.min(3, (attacker:GetAttribute("Bulles") or 0) + 1)
		attacker:SetAttribute("Bulles", bulles)
	end
end

-- forced = coup décidé par le serveur (projection automatique) : le joueur local doit aussi le jouer
function Combat.perform(attacker, key, move, forced)
	showMoveName(attacker, move.label)
	-- tous les clients lancent l'animation du coup à partir de ces valeurs
	attacker:SetAttribute("MoveForced", forced == true)
	attacker:SetAttribute("MoveKey", key)
	attacker:SetAttribute("MoveStart", workspace:GetServerTimeNow())
	task.delay(move.startup, function()
		if Fighters.get(attacker) == nil or attacker:GetAttribute("Eliminated") then
			return
		end
		local kind = move.kind or "melee"
		if kind == "melee" then
			doMelee(attacker, move)
		elseif kind == "grab" then
			doGrab(attacker, move)
		elseif kind == "projectile" then
			doProjectile(attacker, move)
		elseif kind == "self" then
			doSelf(attacker, move)
		end
	end)
end

-- Vrai si key fait partie des suites possibles du coup previous (voir links dans les persos)
function Combat.isLink(previous, key)
	if previous.links then
		for _, linked in pairs(previous.links) do
			if linked == key then
				return true
			end
		end
	end
	return false
end

-- Remplissage de la barre d'énergie pendant la recharge
RunService.Heartbeat:Connect(function(dt)
	for _, model in ipairs(Fighters.all()) do
		local s = Fighters.get(model)
		if s.charging then
			local energy = math.min(Config.ENERGY_MAX, (model:GetAttribute("Energy") or 0) + Config.ENERGY_CHARGE_RATE * dt)
			model:SetAttribute("Energy", energy)
			if energy >= Config.ENERGY_MAX or model:GetAttribute("Eliminated") or os.clock() < s.stunnedUntil then
				Fighters.setCharging(model, false)
			end
		end
	end
end)

-- Point d'entrée des actions envoyées par les joueurs
function Combat.handleAction(player, action, extra)
	local model = player.Character
	local s = model and Fighters.get(model)
	if not s or model:GetAttribute("Eliminated") then
		return
	end
	local now = os.clock()
	if now < s.stunnedUntil or model:GetAttribute("Grabbed") then
		return
	end
	-- il tient un adversaire : il ne peut que le projeter
	if s.holding then
		if action == "THROW" then
			local direction = (extra == "back" or extra == "up" or extra == "down") and extra or "fwd"
			Combat.throwHeld(model, direction)
		end
		return
	end

	if action == "CHARGE" then
		-- recharge possible seulement hors d'un coup ; elle s'arrête au relâchement, au premier coup reçu,
		-- à la première action, ou quand la barre est pleine
		if now >= s.busyUntil - 0.05 and (model:GetAttribute("Energy") or 0) < Config.ENERGY_MAX then
			Fighters.setCharging(model, true)
		end
		return
	elseif action == "CHARGE_END" then
		Fighters.setCharging(model, false)
		return
	end
	Fighters.setCharging(model, false)
	if actionHook then
		actionHook(model)
	end

	-- Dash (double tap) : les autres clients jouent la ruée et la poussière
	if action == "DASH" then
		model:SetAttribute("DashStart", workspace:GetServerTimeNow())
		return
	end

	-- ✋ : ramasser l'objet le plus proche
	if action == "PICKUP" then
		if now >= s.busyUntil - 0.05 and not Pickups.heldId(model) then
			Pickups.tryPickup(model)
		end
		return
	end
	-- ✋ avec un objet en main : on le lance (flèche ↑ = vers le haut, ↓ = vers le bas)
	if action == "THROW_ITEM" then
		local id = Pickups.heldId(model)
		if not id or now < s.busyUntil - 0.05 then
			return
		end
		local direction = (extra == "up" or extra == "down") and extra or "fwd"
		local character = CharacterList[model:GetAttribute("Character") or Config.DEFAULT_CHARACTER]
		local key = direction == "fwd" and "ITEM_throw" or "ITEM_throw_" .. direction
		local move = character.moves[key] or character.moves.ITEM_throw
		s.busyUntil = now + move.startup + move.active + move.recovery
		Combat.perform(model, key, move)
		task.delay(move.startup, function()
			if Fighters.get(model) and Pickups.heldId(model) == id then
				Pickups.throw(model, direction)
			end
		end)
		return
	end

	-- Frappe chargée (J ou K maintenu au sol) : le perso reste en élan jusqu'au relâchement
	if action == "SMASH_START" then
		local character = CharacterList[model:GetAttribute("Character")]
		if typeof(extra) ~= "string" then
			return
		end
		local _, base = MoveSets.split(extra)
		local smashMove = character and character.moves[extra]
		if not Config.SMASH_MOVES[base] or not smashMove or not MoveSets.allowed(extra, smashMove, MoveSets.armed(model)) then
			return
		end
		if now < s.busyUntil - 0.05 then
			return
		end
		s.smash = { key = extra, start = now }
		s.busyUntil = now + Config.SMASH_MAX_TIME + 0.5
		model:SetAttribute("SmashKey", extra)
		return
	end
	-- relâchement : la puissance dépend du temps de charge mesuré ici (pas de triche possible)
	local smashPower = nil
	if s.smash then
		if s.smash.key == action and extra == "SMASH" then
			smashPower = math.clamp((now - s.smash.start) / Config.SMASH_MAX_TIME, 0, 1)
		end
		Fighters.clearSmash(model)
	end

	if action == "DODGE" then
		if now < s.dodgeReadyAt or now < s.busyUntil then
			return
		end
		s.dodgeReadyAt = now + Config.DODGE_COOLDOWN
		s.invulnUntil = math.max(s.invulnUntil, now + Config.DODGE_INVULN)
		model:SetAttribute("DodgeStart", workspace:GetServerTimeNow())
		return
	end

	if action == "FATAL" then
		if fatalHandler and typeof(extra) == "string" then
			fatalHandler(model, extra)
		end
		return
	end

	local character = CharacterList[model:GetAttribute("Character")]
	local move = character and character.moves[action]
	if not move or move.kind == "throw" or move.kind == "item" then
		return
	end
	-- moveset du perso : il faut avoir ouvert une Caisse Bizarre ; coups à mains nues : sans elle
	if not MoveSets.allowed(action, move, MoveSets.armed(model)) then
		return
	end
	-- petite tolérance pour la latence du téléphone ; un enchaînement peut couper le retour en garde
	local previous = s.lastMoveKey and character.moves[s.lastMoveKey]
	local chaining = previous ~= nil
		and Combat.isLink(previous, action)
		and now >= s.lastMoveAt + previous.startup + previous.active - 0.08
	if now < s.busyUntil - 0.05 and not chaining then
		return
	end
	local cost = Fighters.energyCost(move, action)
	local energy = model:GetAttribute("Energy") or 0
	if energy < cost then
		return
	end
	if cost > 0 then
		model:SetAttribute("Energy", energy - cost)
	end
	if smashPower then
		-- version chargée : plus de dégâts, et plus d'éjection (voir Fighters.hit)
		local charged = table.clone(move)
		charged.damage = move.damage * (1 + Config.SMASH_DAMAGE_BONUS * smashPower)
		charged.smashPower = smashPower
		move = charged
	end
	model:SetAttribute("MovePower", smashPower or 0)
	if move.superCost then
		if (model:GetAttribute("Super") or 0) < move.superCost then
			return
		end
		model:SetAttribute("Super", 0)
	end

	s.busyUntil = now + move.startup + move.active + (move.hold or 0) + move.recovery
	s.lastMoveKey, s.lastMoveAt = action, now
	if move.invuln then
		s.invulnUntil = math.max(s.invulnUntil, now + move.invuln)
	end
	Combat.perform(model, action, move)
end

return Combat

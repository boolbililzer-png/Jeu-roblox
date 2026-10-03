-- Point d'entrée client : déplacements en 2D, saut et double saut, dash, esquive, plateformes traversables,
-- choix du coup selon la direction (et l'arme tenue), enchaînements, énergie et recharge, éjections,
-- bouton ✋ (ramasser, lancer, saisir et projeter), coups fatals.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local MoveSets = require(Shared:WaitForChild("MoveSets"))
local Statuses = require(Shared:WaitForChild("Statuses"))
local Items = require(Shared:WaitForChild("Items"))
local Controls = require(script.Parent:WaitForChild("Controls"))
local CameraRig = require(script.Parent:WaitForChild("CameraRig"))
local Hud = require(script.Parent:WaitForChild("Hud"))
local Animator = require(script.Parent:WaitForChild("Animator"))
local Fx = require(script.Parent:WaitForChild("Fx"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ActionRemote = Remotes:WaitForChild("Action")
local KnockbackRemote = Remotes:WaitForChild("Knockback")

local player = Players.LocalPlayer

-- On remplace les commandes Roblox par défaut par les nôtres
local PlayerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
PlayerModule:GetControls():Disable()
task.spawn(function()
	for _ = 1, 10 do
		if pcall(StarterGui.SetCore, StarterGui, "ResetButtonCallback", false) then
			break
		end
		task.wait(1)
	end
end)

local controls = Controls.new()
local Menu = require(script.Parent:WaitForChild("Menu"))
Menu.start()
CameraRig.start()
Hud.fatalsUnlocked = Menu.fatalsUnlocked
Hud.start()
Animator.start()
Fx.start()

local character, humanoid, root
local facing = 1
local airJumpsLeft = Config.AIR_JUMPS
local upSpecialUsed = false
local busyUntil, stunnedUntil, dodgeReadyAt = 0, 0, 0
local lastDashTime, lastDodgeTime = -10, -10
local knockbackToken = 0
local lastTapSign, lastTapTime, wasNeutralX = 0, -10, true
local lastAbsoluteDirection = "neutral"
local directionHistory = {} -- { {dir = "left"/"right"/"up"/"down", time = ...}, ... }
local lastMoveKey, lastMoveAt = nil, -10 -- dernier coup lancé, pour les enchaînements
local buffered = nil -- appui arrivé un peu trop tôt dans un enchaînement : { button, vector, time }
local charging = false -- recharge d'énergie en cours (O / ⚡ maintenu)
local smash = nil -- J ou K maintenu au sol : { button, key, pressedAt, startedAt }
local dashUntil, dashDir, running = 0, 0, false -- dash (double tap) puis course
local carry = nil -- coup lancé en ruée ou en course : { dir, speed, untilTime } (le perso garde son élan)
local downSince, dropUntil = nil, 0 -- ↓ maintenu sur une plateforme fine : on passe au travers
local holdDirection = "neutral" -- direction tenue quand on a saisi quelqu'un

local function onCharacter(newCharacter)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	root = newCharacter:WaitForChild("HumanoidRootPart")
	Animator.setLocalCharacter(newCharacter)
	humanoid.AutoRotate = false
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	busyUntil, stunnedUntil = 0, 0
	charging = false
	Animator.setLocalCharging(false)
end
player.CharacterAdded:Connect(onCharacter)
if player.Character then
	task.spawn(onCharacter, player.Character)
end

local function statusActive(name)
	return character ~= nil
		and character:GetAttribute("Status") == name
		and (character:GetAttribute("StatusUntil") or 0) > workspace:GetServerTimeNow()
end

local function isObese()
	return character ~= nil and (character:GetAttribute("ObeseUntil") or 0) > workspace:GetServerTimeNow()
end

-- Statut loufoque et bonus en cours (voir shared/Statuses.lua)
local function flags()
	return character and Statuses.flags(character) or {}
end

local function canAct()
	return root ~= nil
		and not root.Anchored
		and not character:GetAttribute("Eliminated")
		and not character:GetAttribute("Grabbed")
		and not character:GetAttribute("Holding")
		and os.clock() >= stunnedUntil
		and not flags().noAct
		and not isObese()
end

-- Direction lue au joystick, inversée si on a pris le jet de soda de Gégé
local function moveInput()
	local v = controls:getMoveVector()
	if flags().invert then
		v = Vector2.new(-v.X, v.Y)
	end
	return v
end

local function maxAirJumps()
	return Config.AIR_JUMPS + (character and character:GetAttribute("AirJumpsBonus") or 0)
end

local function isGrounded()
	return humanoid ~= nil and humanoid.FloorMaterial ~= Enum.Material.Air
end

local function relativeDirection(v)
	if v.Y > 0.55 then
		return "up"
	elseif v.Y < -0.55 then
		return "down"
	elseif math.abs(v.X) > 0.35 then
		return "side"
	end
	return "neutral"
end

local function absoluteDirection(v)
	if v.Y > 0.6 then
		return "up"
	elseif v.Y < -0.6 then
		return "down"
	elseif v.X > 0.6 then
		return "right"
	elseif v.X < -0.6 then
		return "left"
	end
	return "neutral"
end

local function characterData()
	return CharacterList[character:GetAttribute("Character") or Config.DEFAULT_CHARACTER]
end

local function energyCost(move, key)
	if move.energyCost then
		return move.energyCost
	end
	return string.sub(key, 1, 2) == "S_" and Config.ENERGY_S_COST or 0
end

-- Fenêtre d'enchaînement du dernier coup : "early" (trop tôt, on garde l'appui), "open" ou nil (fermée)
local function comboWindow()
	local previous = lastMoveKey and characterData().moves[lastMoveKey]
	if not previous or not previous.links then
		return nil, nil
	end
	local elapsed = os.clock() - lastMoveAt
	local opens = previous.startup + previous.active
	local closes = opens + (previous.hold or 0) + previous.recovery + Config.COMBO_GRACE
	if elapsed < opens then
		return "early", previous
	elseif elapsed <= closes then
		return "open", previous
	end
	return nil, nil
end

-- Suite d'enchaînement pour ce bouton et cette direction (façon Tekken, voir links dans Gege.lua) :
-- d'abord la suite propre à la direction (fwd / back / down / up), sinon celle du bouton seul
local function linkedMove(previous, button, v)
	local links = previous.links
	local candidates = {}
	if v.Y > 0.55 then
		table.insert(candidates, "up_" .. button)
	elseif v.Y < -0.55 then
		table.insert(candidates, "down_" .. button)
	elseif math.abs(v.X) > 0.35 then
		table.insert(candidates, (math.sign(v.X) == facing and "fwd_" or "back_") .. button)
		table.insert(candidates, "side_" .. button)
	end
	table.insert(candidates, button)
	local air = not isGrounded()
	local moves = characterData().moves
	for _, name in ipairs(candidates) do
		local key = links[name]
		-- une suite aérienne ne sort pas une fois retombé au sol
		if key and moves[key] and MoveSets.allowed(key, moves[key], MoveSets.armed(character))
			and not (string.find(key, "_air", 1, true) and not air) then
			return key
		end
	end
	return nil
end

-- Premier coup utilisable parmi les candidats : avec la Caisse Bizarre, le moveset du perso ; sans, à mains nues
local function pickMove(candidates)
	return MoveSets.pick(characterData().moves, candidates, MoveSets.armed(character))
end

-- Le coup en cours donne-t-il son propre élan (selfVelocity) ? On ne le remplace pas alors.
local function move_has_own_velocity()
	local data = characterData()
	local move = lastMoveKey and data and data.moves[lastMoveKey]
	return move ~= nil and move.selfVelocity ~= nil and move.selfVelocity.X ~= 0
end

-- Fenêtre des coups de dash : pendant la ruée, pendant la course qui suit, et un court instant après
local function inDashWindow(now)
	return now < dashUntil or running or now - lastDashTime < Config.DASH_S_WINDOW
end

-- Traduit « bouton + direction + situation » en clé de coup (voir Characters/Gege.lua)
local function resolveMove(button)
	local v = moveInput()
	local dir = relativeDirection(v)
	-- un coup de côté part dans la direction poussée, comme dans Brawlhalla
	if dir == "side" and os.clock() >= busyUntil then
		facing = v.X > 0 and 1 or -1
	end
	local air = not isGrounded()
	local now = os.clock()
	if button == "P" or button == "K" then
		if air then
			-- en l'air, chaque flèche a son coup (sinon le coup aérien de base)
			return pickMove(dir ~= "neutral" and { button .. "_air_" .. dir, button .. "_air" } or { button .. "_air" })
		end
		if inDashWindow(now) and dir ~= "down" and dir ~= "up" then
			return pickMove({ button .. "_dash", button .. "_side" })
		end
		return pickMove({ button .. "_" .. dir, button .. "_neutral" })
	elseif button == "S" then
		if now - lastDodgeTime < Config.DODGE_S_WINDOW then
			return pickMove({ "S_dodge", "S_neutral" })
		elseif inDashWindow(now) and isGrounded() and dir ~= "up" and dir ~= "down" then
			return pickMove({ "S_dash", "S_side" })
		elseif dir == "up" then
			return pickMove({ "S_up" })
		elseif air then
			return pickMove(dir == "down" and { "S_air_down", "S_air" } or { "S_air", "S_neutral" })
		end
		return pickMove({ "S_" .. dir, "S_neutral" })
	elseif button == "S_HOLD" then
		return pickMove({ "S_hold", "S_neutral" })
	elseif button == "SUPER" then
		-- 3 Supers : ↑I, →I (ou I seul) et ↓I
		if dir == "up" then
			return pickMove({ "SUPER_up", "SUPER" })
		elseif dir == "down" then
			return pickMove({ "SUPER_down", "SUPER" })
		end
		return pickMove({ "SUPER" })
	end
	return nil
end

local function performMove(key, chaining, power)
	local move = characterData().moves[key]
	if not move or not canAct() then
		return false
	end
	local _, statusKey = MoveSets.split(key)
	if Statuses.blocks(flags(), statusKey) then
		Fx.noEnergy(character)
		return false
	end
	-- jauge du perso (pression d'eau du Canard, pigeons, réservoir de R-0B0…)
	if move.meterCost and (character:GetAttribute("Meter") or 0) < move.meterCost then
		Fx.noEnergy(character)
		return false
	end
	-- un enchaînement (ou le relâchement d'une frappe chargée) coupe l'attente du coup précédent
	if os.clock() < busyUntil and not chaining and not power then
		return false
	end
	if move.superCost and (character:GetAttribute("Super") or 0) < move.superCost then
		Fx.popText(root.Position + Vector3.new(0, 4, 1), "⭐ SUPER PAS ENCORE PRÊT", Color3.fromRGB(255, 190, 60), 0.8, 0.8)
		return false
	end
	local cost = energyCost(move, key)
	if cost > (character:GetAttribute("Energy") or 0) then
		Fx.noEnergy(character)
		return false
	end
	local _, baseKey = MoveSets.split(key)
	if baseKey == "S_up" and not isGrounded() then
		if upSpecialUsed then
			return false
		end
		upSpecialUsed = true
	end
	busyUntil = os.clock() + move.startup + move.active + (move.hold or 0) + move.recovery
	lastMoveKey, lastMoveAt = key, os.clock()
	-- frapper pendant la ruée : la ruée s'arrête, le coup garde l'élan (ou prend le sien)
	if os.clock() < dashUntil or running then
		-- le coup part sur la lancée : on continue d'avancer jusqu'à la fin de la frappe
		local speed = os.clock() < dashUntil and Config.DASH_SPEED * 0.8 or Config.RUN_SPEED
		carry = { dir = dashDir, speed = speed, untilTime = os.clock() + move.startup + move.active }
		dashUntil, running = 0, false
		lastDashTime = -10
	end
	ActionRemote:FireServer(key, power and "SMASH" or nil)
	-- l'animation part tout de suite chez soi, sans attendre la réponse du serveur
	Animator.playMove(character, key, os.clock(), power)
	if move.selfVelocity then
		local current = root.AssemblyLinearVelocity
		local vy = move.selfVelocity.Y ~= 0 and move.selfVelocity.Y or current.Y
		root.AssemblyLinearVelocity = Vector3.new(move.selfVelocity.X * facing, vy, 0)
	end
	return true
end

-- Frappe chargée : maintenu au-delà de SMASH_HOLD, le perso reste en élan ; au relâchement (ou à pleine
-- charge) le coup part, plus fort selon le temps de charge. Relâché avant : coup normal.
local function startSmash()
	smash.startedAt = os.clock()
	busyUntil = os.clock() + Config.SMASH_MAX_TIME + 0.5
	ActionRemote:FireServer("SMASH_START", smash.key)
	Animator.holdMove(character, smash.key, os.clock())
end

local function releaseSmash()
	local pending = smash
	smash = nil
	if not pending then
		return
	end
	if pending.startedAt then
		local power = math.clamp((os.clock() - pending.startedAt) / Config.SMASH_MAX_TIME, 0, 1)
		busyUntil = 0
		if not performMove(pending.key, false, power) then
			Animator.cancelHold(character)
		end
	else
		performMove(pending.key)
	end
end

local function cancelSmash()
	if smash and smash.startedAt then
		Animator.cancelHold(character)
		busyUntil = 0
	end
	smash = nil
end

-- Un bouton d'attaque : suite d'enchaînement si la fenêtre du coup précédent est ouverte,
-- sinon coup normal selon la direction. Trop tôt dans un enchaînement : l'appui est gardé en mémoire.
local function attack(button)
	-- un autre bouton pendant qu'on hésite encore entre tap et charge : le tap part d'abord
	if smash and not smash.startedAt then
		releaseSmash()
	elseif smash then
		return
	end
	if button == "P" or button == "K" or button == "S" then
		local window, previous = comboWindow()
		if window == "early" then
			buffered = { button = button, time = os.clock() }
			return
		elseif window == "open" then
			local key = linkedMove(previous, button, moveInput())
			if key and performMove(key, true) then
				return
			end
		end
	end
	local key = resolveMove(button)
	if not key then
		return
	end
	-- J ou K au sol, hors combo : on attend de savoir si c'est un tap ou une frappe chargée
	local _, baseKey = MoveSets.split(key)
	if Config.SMASH_MOVES[baseKey] and isGrounded() and os.clock() >= busyUntil and canAct() then
		smash = { button = button, key = key, pressedAt = os.clock() }
		return
	end
	performMove(key)
end

-- Recharge d'énergie : on reste sur place, l'animation propre au perso se joue
local function setCharging(on)
	if charging == on then
		return
	end
	charging = on
	Animator.setLocalCharging(on)
	ActionRemote:FireServer(on and "CHARGE" or "CHARGE_END")
end

local function nearestEnemyInFront(range)
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local otherRoot = model:FindFirstChild("HumanoidRootPart")
		if model ~= character and otherRoot and not model:GetAttribute("Eliminated") then
			local dx = otherRoot.Position.X - root.Position.X
			if math.abs(dx) <= range and math.abs(otherRoot.Position.Y - root.Position.Y) < 4 and dx * facing >= 0 then
				return model
			end
		end
	end
	return nil
end

-- Objet posé à portée (les objets sont dans workspace.Objets, avec l'attribut ItemId)
local function nearestPickup()
	local objects = workspace:FindFirstChild("Objets")
	if not objects or not root then
		return nil
	end
	local best, bestDistance = nil, Config.PICKUP_RANGE
	for _, item in ipairs(objects:GetChildren()) do
		local id = item:GetAttribute("ItemId")
		-- une Caisse Bizarre ne sert à rien si on a déjà sorti son arme
		if id and item:IsA("Model") and not (id == "crate" and MoveSets.armed(character)) then
			local distance = (item:GetPivot().Position - root.Position).Magnitude
			if distance <= bestDistance then
				best, bestDistance = item, distance
			end
		end
	end
	return best
end

local function heldItem()
	local id = character and character:GetAttribute("Held") or ""
	return Items.LIST[id], id
end

-- Direction d'une projection ou d'un lancer : flèche tenue, avant par défaut
local function aimDirection()
	local v = moveInput()
	if v.Y > 0.55 then
		return "up"
	elseif v.Y < -0.55 then
		return "down"
	elseif math.abs(v.X) > 0.35 and math.sign(v.X) ~= facing then
		return "back"
	end
	return "fwd"
end

-- Ce que fera le bouton ✋ maintenant (pour son étiquette et pour l'action) : il sert seulement à ramasser
-- (Caisse Bizarre, objets) et à lancer l'objet tenu. Il n'y a pas de saisie d'adversaire.
local function handAction()
	if heldItem() then
		return "throwItem"
	end
	if nearestPickup() then
		return "pickup"
	end
	return "none"
end

local function doHand()
	local action = handAction()
	if action == "throw" then
		ActionRemote:FireServer("THROW", aimDirection())
		return
	end
	if os.clock() < busyUntil or not canAct() then
		return
	end
	if action == "throwItem" then
		local direction = aimDirection()
		if direction == "back" then
			-- lancer derrière soi : on se retourne d'abord
			facing = -facing
			direction = "fwd"
		end
		if direction == "down" and isGrounded() then
			direction = "fwd"
		end
		local key = direction == "fwd" and "ITEM_throw" or "ITEM_throw_" .. direction
		local move = characterData().moves[key]
		if move then
			busyUntil = os.clock() + move.startup + move.active + move.recovery
			Animator.playMove(character, key, os.clock())
		end
		ActionRemote:FireServer("THROW_ITEM", direction)
	elseif action == "pickup" then
		ActionRemote:FireServer("PICKUP")
	end
end

local function doDodge()
	local v = moveInput()
	local now = os.clock()
	if now < dodgeReadyAt or now < busyUntil or flags().noDodge then
		return
	end
	dodgeReadyAt = now + Config.DODGE_COOLDOWN
	lastDodgeTime = now
	busyUntil = now + Config.DODGE_DURATION
	ActionRemote:FireServer("DODGE")
	Animator.playDodge(character, now)
	local vx = math.abs(v.X) > 0.35 and math.sign(v.X) * Config.DODGE_SPEED or 0
	local vy = (not isGrounded() and v.Y < -0.5) and -Config.DODGE_SPEED or root.AssemblyLinearVelocity.Y
	root.AssemblyLinearVelocity = Vector3.new(vx, vy, 0)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.LocalTransparencyModifier = 0.6
		end
	end
	task.delay(Config.DODGE_INVULN, function()
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.LocalTransparencyModifier = 0
			end
		end
	end)
end

local function doJump()
	if flags().noMove then
		return
	end
	if isGrounded() then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	elseif airJumpsLeft > 0 then
		airJumpsLeft -= 1
		local v = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(v.X, Config.AIR_JUMP_VELOCITY, 0)
	end
end

-- Coup fatal : 3 flèches puis ⭐, avec un adversaire achevable à portée
local function tryFatal()
	local target = Hud.findFinishable(character)
	if not target then
		return false
	end
	local towards = target.HumanoidRootPart.Position.X >= root.Position.X and "right" or "left"
	local away = towards == "right" and "left" or "right"
	local unlocked = Menu.fatalsUnlocked(character:GetAttribute("Character") or "")
	for index, fatal in ipairs(characterData().fatals) do
		if index > unlocked then
			break -- pas encore débloqué (maîtrise niveau 5 et 15)
		end
		local sequence = fatal.sequence
		local count = #sequence
		if #directionHistory >= count then
			local ok = true
			local previousTime = nil
			for i = 1, count do
				local entry = directionHistory[#directionHistory - count + i]
				local expected = sequence[i]
				if expected == "forward" then
					expected = towards
				elseif expected == "back" then
					expected = away
				end
				if entry.dir ~= expected or (previousTime and entry.time - previousTime > Config.FATAL_INPUT_GAP) then
					ok = false
					break
				end
				previousTime = entry.time
			end
			if ok and os.clock() - previousTime <= Config.FATAL_INPUT_GAP then
				ActionRemote:FireServer("FATAL", fatal.id)
				table.clear(directionHistory)
				return true
			end
		end
	end
	return false
end

controls.Pressed:Connect(function(name)
	if name == "CHARGE_END" then
		setCharging(false)
		return
	elseif name == "P_RELEASE" or name == "K_RELEASE" then
		if smash and smash.button == string.sub(name, 1, 1) then
			releaseSmash()
		end
		return
	end
	-- adversaire saisi : J, K, L ou ✋ le projettent (dans la direction tenue, vers l'avant sinon)
	if character and character:GetAttribute("Holding") then
		if name == "P" or name == "K" or name == "S" or name == "MAIN" then
			ActionRemote:FireServer("THROW", aimDirection())
		end
		return
	end
	if not canAct() then
		return
	end
	if name == "CHARGE" then
		if (character:GetAttribute("Energy") or 0) >= Config.ENERGY_MAX then
			Fx.popText(root.Position + Vector3.new(0, 4, 1), "⚡ ÉNERGIE PLEINE", Color3.fromRGB(120, 200, 255), 0.8, 0.8)
		elseif not isGrounded() then
			Fx.popText(root.Position + Vector3.new(0, 4, 1), "⚡ AU SOL SEULEMENT", Color3.fromRGB(120, 200, 255), 0.8, 0.8)
		elseif os.clock() >= busyUntil then
			setCharging(true)
		end
		return
	end
	-- n'importe quelle autre action coupe la recharge
	setCharging(false)
	if name == "SAUT" then
		doJump()
	elseif name == "MAIN" then
		doHand()
	elseif name == "ESQUIVE" then
		doDodge()
	elseif string.sub(name, 1, 6) == "EMOTE_" then
		-- emote : à part des attaques, seulement quand on ne fait rien d'autre
		if os.clock() >= busyUntil and isGrounded() then
			performMove(name)
		end
	elseif name == "SUPER" and tryFatal() then
		return
	else
		attack(name)
	end
end)

KnockbackRemote.OnClientEvent:Connect(function(velocity, hitstun)
	if not root then
		return
	end
	stunnedUntil = os.clock() + hitstun
	setCharging(false)
	cancelSmash()
	buffered = nil
	knockbackToken += 1
	local token = knockbackToken
	humanoid.PlatformStand = true
	root.AssemblyLinearVelocity = velocity
	task.delay(hitstun, function()
		if knockbackToken == token and humanoid then
			humanoid.PlatformStand = false
		end
	end)
end)

-- Plateau qui va et vient : même calcul que le serveur (server/Arena.lua), fait ici avant la physique
-- pour que le perso posé dessus soit emporté sans saccade
RunService.PreSimulation:Connect(function()
	local m = Config.MOVING_PLATFORM
	local t = workspace:GetServerTimeNow()
	for _, platform in ipairs(CollectionService:GetTagged("Traversable")) do
		if platform:GetAttribute("Moving") then
			platform.CFrame = CFrame.new(m.amplitude * math.sin(t * m.speed), m.y, 0)
			platform.AssemblyLinearVelocity = Vector3.new(m.amplitude * m.speed * math.cos(t * m.speed), 0, 0)
		end
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if not root or not root.Parent or root.Anchored or character:GetAttribute("Eliminated") then
		return
	end
	local now = os.clock()
	local v = moveInput()
	local grounded = isGrounded()
	local acting = canAct()
	local busy = now < busyUntil

	if grounded then
		airJumpsLeft = maxAirJumps()
		upSpecialUsed = false
	end

	-- Frappe chargée : la charge commence après SMASH_HOLD, le coup part tout seul à pleine charge
	if smash then
		if not acting then
			cancelSmash()
		elseif not smash.startedAt and now - smash.pressedAt >= Config.SMASH_HOLD then
			startSmash()
		elseif smash.startedAt and now - smash.startedAt >= Config.SMASH_MAX_TIME then
			releaseSmash()
		end
	end

	-- Éjection : elle freine pendant qu'on est sonné (sinon on part trop loin et les combos décrochent)
	if now < stunnedUntil then
		local velocity = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(velocity.X * math.exp(-Config.KB_DRAG * dt), velocity.Y, 0)
	end

	-- Appui gardé en mémoire : il part dès que la fenêtre d'enchaînement s'ouvre
	if buffered then
		if now - buffered.time > Config.COMBO_BUFFER then
			buffered = nil
		elseif comboWindow() == "open" then
			local button = buffered.button
			buffered = nil
			attack(button)
		end
	end

	-- La recharge s'arrête quand la barre est pleine ou si on quitte le sol
	if charging and (not acting or not grounded or (character:GetAttribute("Energy") or 0) >= Config.ENERGY_MAX) then
		setCharging(false)
	end

	-- Historique des flèches pour les coups fatals
	local rawDirection = absoluteDirection(controls:getMoveVector())
	if rawDirection ~= lastAbsoluteDirection then
		lastAbsoluteDirection = rawDirection
		if rawDirection ~= "neutral" then
			table.insert(directionHistory, { dir = rawDirection, time = now })
			if #directionHistory > 8 then
				table.remove(directionHistory, 1)
			end
		end
	end

	-- Double tap gauche/droite = dash : une ruée rapide, puis on court tant que la direction reste tenue.
	-- (Avant, la vitesse du dash était aussitôt écrasée par la marche du Humanoid : il ne se passait rien.)
	if math.abs(v.X) > 0.6 then
		if wasNeutralX then
			local tapSign = math.sign(v.X)
			if acting and not busy and grounded and tapSign == lastTapSign and now - lastTapTime < Config.DOUBLE_TAP_WINDOW then
				lastDashTime = now
				facing = tapSign
				dashDir = tapSign
				dashUntil = now + Config.DASH_TIME
				running = true
				ActionRemote:FireServer("DASH")
				Animator.playDash(character, now)
				Fx.dash(character)
			end
			lastTapSign, lastTapTime = tapSign, now
		end
		wasNeutralX = false
	elseif math.abs(v.X) < 0.3 then
		wasNeutralX = true
		running = false
	end
	if running and (math.sign(v.X) ~= dashDir or not acting) then
		running = false
	end
	local dashing = now < dashUntil and acting
	local status = flags()
	local speedMult = Statuses.speed(character)
	humanoid.WalkSpeed = ((dashing and Config.DASH_SPEED) or (running and Config.RUN_SPEED) or Config.WALK_SPEED) * speedMult
	if status.noMove then
		humanoid.WalkSpeed = 0
	end
	-- plané (Capitaine Canard) : SAUT maintenu en tombant, la chute est freinée
	if character:GetAttribute("Glide") and not grounded and controls:isHeld("SAUT") and root.AssemblyLinearVelocity.Y < -8 then
		local velocity = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(velocity.X, -8, 0)
	end

	-- Orientation et marche (pas pendant la recharge : on boit sur place)
	if acting and not busy and not charging and math.abs(v.X) > 0.3 then
		facing = v.X > 0 and 1 or -1
	end
	local moveX = 0
	if dashing and not status.noMove then
		moveX = dashDir
		root.AssemblyLinearVelocity = Vector3.new(dashDir * Config.DASH_SPEED * speedMult, root.AssemblyLinearVelocity.Y, 0)
	elseif carry and now < carry.untilTime and not move_has_own_velocity() and not status.noMove then
		-- coup lancé en ruée / en course : il garde son élan
		moveX = carry.dir
		humanoid.WalkSpeed = carry.speed * speedMult
	elseif acting and not charging and not status.noMove and math.abs(v.X) > 0.2 then
		-- on peut marcher pendant un coup (plus lentement au sol), et toujours se diriger en l'air
		moveX = v.X
		if busy and grounded then
			humanoid.WalkSpeed = Config.WALK_SPEED * Config.ATTACK_MOVE_SPEED * speedMult
		end
	end
	if carry and now >= carry.untilTime then
		carry = nil
	end
	humanoid:Move(Vector3.new(moveX, 0, 0), false)

	-- Piège de la Salle de Fitness : le tapis de course pousse ceux qui sont sur le sol principal
	if grounded and (workspace:GetAttribute("ConveyorUntil") or 0) > workspace:GetServerTimeNow() and math.abs(root.Position.X) < 45 and root.Position.Y < 8 then
		local velocity = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(velocity.X + (workspace:GetAttribute("ConveyorSpeed") or 0) * dt * 6, velocity.Y, 0)
	end

	-- Plateformes fines : on les traverse en montant, et ↓ maintenu (sans attaquer) pour redescendre
	if v.Y < -0.6 and grounded and acting and not busy then
		downSince = downSince or now
		if now - downSince >= Config.DROP_HOLD then
			dropUntil = now + 0.35
			downSince = nil
		end
	else
		downSince = nil
	end
	local feet = root.Position.Y - (humanoid.HipHeight + root.Size.Y / 2)
	for _, platform in ipairs(CollectionService:GetTagged("Traversable")) do
		local top = platform.Position.Y + platform.Size.Y / 2
		platform.CanCollide = now >= dropUntil and feet >= top - 0.75 and root.AssemblyLinearVelocity.Y < 40
	end

	-- Verrouillage sur le plan de combat (Z = 0), tourné à gauche ou à droite et un peu vers la caméra
	local position = root.Position
	local velocity = root.AssemblyLinearVelocity
	root.CFrame = CFrame.lookAt(Vector3.new(position.X, position.Y, 0), Vector3.new(position.X + facing, position.Y, Config.TURN_TO_CAMERA))
	root.AssemblyLinearVelocity = Vector3.new(velocity.X, velocity.Y, 0)
	root.AssemblyAngularVelocity = Vector3.zero

	-- Adversaire saisi : pousser une flèche le projette dans cette direction
	if character:GetAttribute("Holding") then
		local direction = relativeDirection(v)
		if direction ~= "neutral" and holdDirection == "neutral" then
			ActionRemote:FireServer("THROW", aimDirection())
		end
		holdDirection = direction
	else
		holdDirection = relativeDirection(v)
	end

	-- Bouton ✋ : il annonce ce qu'il va faire
	local hand = handAction()
	local _, heldId = heldItem()
	if hand == "throw" then
		controls:setHandLabel("LANCE", Color3.fromRGB(230, 90, 60))
	elseif hand == "throwItem" then
		controls:setHandLabel((Items.LIST[heldId] and Items.LIST[heldId].icon or "") .. "↗", Color3.fromRGB(230, 140, 40))
	elseif hand == "pickup" then
		controls:setHandLabel("PRENDS", Color3.fromRGB(80, 190, 110))
	else
		controls:setHandLabel("✋", Color3.fromRGB(110, 100, 120)) -- rien à ramasser à portée
	end

	-- ⭐ visible si la jauge Super est pleine ou si un coup fatal est possible
	controls:setSuperReady((character:GetAttribute("Super") or 0) >= Config.MAX_SUPER or Hud.findFinishable(character) ~= nil)
	-- bouton S grisé quand l'énergie ne suffit plus pour un spécial, ⚡ qui pulse pendant la recharge
	controls:setEnergy((character:GetAttribute("Energy") or 0) / Config.ENERGY_MAX, (character:GetAttribute("Energy") or 0) >= Config.ENERGY_S_COST, charging)
end)

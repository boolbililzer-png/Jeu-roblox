-- Registre des combattants (joueurs et mannequins) : dégâts, vies, jauges, statuts, éjection.
-- Les valeurs visibles par les clients sont stockées en attributs sur le modèle du personnage.
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))
local Statuses = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Statuses"))

local Fighters = {}
Fighters.TAG = "Fighter"

local state = {}
local remotes = {}

-- Appelé quand un combattant encaisse un coup (Combat s'en sert pour lâcher une saisie)
Fighters.onHit = nil
-- Mécaniques des persos (server/Mechanics.lua), branchées par Main.server (évite un require circulaire)
Fighters.mechanics = nil

function Fighters.init(remoteTable)
	remotes = remoteTable
end

function Fighters.resetAttributes(model)
	model:SetAttribute("Damage", 0)
	model:SetAttribute("Stocks", Config.STOCKS)
	model:SetAttribute("Super", 0)
	model:SetAttribute("Bulles", 0)
	model:SetAttribute("Status", "")
	model:SetAttribute("StatusUntil", 0)
	model:SetAttribute("Eliminated", false)
	model:SetAttribute("Finishable", false)
	model:SetAttribute("Energy", Config.ENERGY_START)
	model:SetAttribute("Charging", false)
	-- points façon Smash : +1 par adversaire éjecté, -1 par chute
	model:SetAttribute("Score", 0)
	model:SetAttribute("KOs", 0)
	model:SetAttribute("Falls", 0)
	model:SetAttribute("Protected", false)
	model:SetAttribute("ProtectedUntil", 0)
	model:SetAttribute("Away", false)
	model:SetAttribute("SmashKey", "")
	model:SetAttribute("MovePower", 0)
	-- objet tenu (voir shared/Items.lua), saisies, croustillant
	model:SetAttribute("Held", "")
	model:SetAttribute("Armed", false) -- Caisse Bizarre ouverte : moveset du perso (sinon mains nues)
	model:SetAttribute("HeldUses", -1)
	model:SetAttribute("HeldSince", 0)
	model:SetAttribute("Holding", false) -- tient un adversaire saisi
	model:SetAttribute("Grabbed", false) -- saisi par un adversaire
	model:SetAttribute("ObeseUntil", 0)
	model:SetAttribute("FragileUntil", 0)
	if Fighters.mechanics then
		Fighters.mechanics.reset(model)
	end
end

function Fighters.register(model, characterId, displayName)
	model:SetAttribute("Character", characterId)
	model:SetAttribute("DisplayName", displayName or model.Name)
	Fighters.resetAttributes(model)
	state[model] = {
		busyUntil = 0,
		stunnedUntil = 0,
		invulnUntil = 0,
		dodgeReadyAt = 0,
		knockbackToken = 0,
		charging = false,
		smash = nil, -- frappe chargée en cours : { key, start }
		lastHitBy = nil, -- dernier à l'avoir frappé (pour le point en cas d'éjection)
		lastHitAt = 0,
		holding = nil, -- adversaire saisi
		heldBy = nil, -- saisi par
		immunity = {},
		armorUntil = 0, -- encaisse sans être éjecté (armor d'un coup, titubade…)
		counter = nil, -- contre en cours : { untilTime, move, key }
	}
	CollectionService:AddTag(model, Fighters.TAG)
	model.Destroying:Connect(function()
		state[model] = nil
	end)
end

-- Retire un combattant du match (fin de partie : les joueurs retournent au salon)
function Fighters.unregister(model)
	state[model] = nil
	CollectionService:RemoveTag(model, Fighters.TAG)
end

function Fighters.get(model)
	return state[model]
end

function Fighters.all()
	local list = {}
	for _, model in ipairs(CollectionService:GetTagged(Fighters.TAG)) do
		if state[model] then
			table.insert(list, model)
		end
	end
	return list
end

function Fighters.root(model)
	return model:FindFirstChild("HumanoidRootPart")
end

function Fighters.facing(model)
	local root = Fighters.root(model)
	if root and root.CFrame.LookVector.X < 0 then
		return -1
	end
	return 1
end

function Fighters.isInvulnerable(model)
	local s = state[model]
	return s ~= nil and os.clock() < s.invulnUntil
end

function Fighters.addSuper(model, amount)
	local value = math.min(Config.MAX_SUPER, (model:GetAttribute("Super") or 0) + amount)
	model:SetAttribute("Super", value)
end

-- Recharge d'énergie (O / ⚡) : l'attribut Charging fait jouer l'animation de recharge chez tous les joueurs
function Fighters.setCharging(model, charging)
	local s = state[model]
	if s and s.charging ~= charging then
		s.charging = charging
		model:SetAttribute("Charging", charging)
	end
end

-- Frappe chargée annulée (coup reçu, chute…)
function Fighters.clearSmash(model)
	local s = state[model]
	if s and s.smash then
		s.smash = nil
		s.busyUntil = math.min(s.busyUntil, os.clock())
	end
	if model:GetAttribute("SmashKey") ~= "" then
		model:SetAttribute("SmashKey", "")
	end
end

function Fighters.energyCost(move, key)
	if Config.INFINITE_SPECIALS then
		return 0
	end
	if move.energyCost then
		return move.energyCost
	end
	return string.sub(key, 1, 2) == "S_" and Config.ENERGY_S_COST or 0
end

-- Achevable par un coup fatal : dans le rouge (et sur sa dernière vie en mode aux vies ou en mort subite)
function Fighters.updateFinishable(model)
	local stockRule = Config.MATCH_MODE == "stock" or workspace:GetAttribute("SuddenDeath") == true
	local finishable = (model:GetAttribute("Damage") or 0) >= Config.RED_DAMAGE and (not stockRule or model:GetAttribute("Stocks") == 1)
	model:SetAttribute("Finishable", finishable)
end

local function sameTeam(a, b)
	if not a or not b then
		return false
	end
	local ta, tb = a:GetAttribute("Team"), b:GetAttribute("Team")
	return Config.TEAMS and ta ~= nil and ta ~= "" and ta == tb
end

function Fighters.stun(model, duration)
	local s = state[model]
	if s then
		s.stunnedUntil = math.max(s.stunnedUntil, os.clock() + duration)
	end
end

-- Statuts loufoques : un seul à la fois, durée plafonnée, immunité ensuite
function Fighters.applyStatus(model, name, duration)
	local s = state[model]
	if not s then
		return
	end
	local now = workspace:GetServerTimeNow()
	if (s.immunity[name] or 0) > now then
		return
	end
	if (model:GetAttribute("StatusUntil") or 0) > now then
		return
	end
	duration = math.min(duration, Config.STATUS_MAX_DURATION)
	model:SetAttribute("Status", name)
	model:SetAttribute("StatusUntil", now + duration)
	s.immunity[name] = now + duration + Config.STATUS_IMMUNITY
	local flags = Statuses.LIST[name]
	if flags and flags.noAct then
		Fighters.stun(model, duration)
		Fighters.setCharging(model, false)
	end
end

function Fighters.clearStatus(model)
	model:SetAttribute("Status", "")
	model:SetAttribute("StatusUntil", 0)
end

-- Les joueurs possèdent la physique de leur perso : on leur demande d'appliquer l'éjection.
-- Les mannequins appartiennent au serveur : on l'applique directement.
function Fighters.applyKnockback(model, velocity, hitstun)
	local s = state[model]
	if not s then
		return
	end
	Fighters.stun(model, hitstun)
	-- pour que tous les clients jouent l'animation de projection
	model:SetAttribute("HitPower", velocity.Magnitude)
	model:SetAttribute("HitstunUntil", workspace:GetServerTimeNow() + hitstun)
	local player = Players:GetPlayerFromCharacter(model)
	if player then
		remotes.Knockback:FireClient(player, velocity, hitstun)
		return
	end
	local root = Fighters.root(model)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid then
		return
	end
	s.knockbackToken += 1
	local token = s.knockbackToken
	humanoid.PlatformStand = true
	root.AssemblyLinearVelocity = velocity
	task.delay(hitstun, function()
		if state[model] and state[model].knockbackToken == token and humanoid.Parent then
			humanoid.PlatformStand = false
		end
	end)
end

-- Petite poussée sans sonner (rebond sur Sumo, aspiration…)
function Fighters.nudge(model, velocity)
	local player = Players:GetPlayerFromCharacter(model)
	if player then
		remotes.Knockback:FireClient(player, velocity, 0.08)
		return
	end
	local root = Fighters.root(model)
	if root then
		root.AssemblyLinearVelocity = velocity
	end
end

function Fighters.isObese(model)
	return (model:GetAttribute("ObeseUntil") or 0) > workspace:GetServerTimeNow()
end

-- Tasty Croustillant avalé : énorme et immobile CROUSTY_TIME secondes (aucune éjection, les dégâts
-- s'accumulent), puis « fragile » : le premier coup reçu juste après éjecte beaucoup plus loin
function Fighters.makeObese(model)
	local s = state[model]
	if not s then
		return
	end
	local serverNow = workspace:GetServerTimeNow()
	Fighters.setCharging(model, false)
	Fighters.clearSmash(model)
	Fighters.stun(model, Config.CROUSTY_TIME)
	model:SetAttribute("ObeseUntil", serverNow + Config.CROUSTY_TIME)
	model:SetAttribute("FragileUntil", serverNow + Config.CROUSTY_TIME + Config.CROUSTY_FRAGILE_TIME)
	-- il s'arrête net (les joueurs gèrent eux-mêmes la physique de leur perso)
	local player = Players:GetPlayerFromCharacter(model)
	local root = Fighters.root(model)
	local fall = root and math.min(root.AssemblyLinearVelocity.Y, 0) or 0
	if player then
		remotes.Knockback:FireClient(player, Vector3.new(0, fall, 0), 0.05)
	elseif root then
		root.AssemblyLinearVelocity = Vector3.new(0, fall, 0)
	end
end

-- Applique un coup. direction = 1 (vers +X) ou -1. Renvoie true si le coup a porté.
function Fighters.hit(attacker, target, move, damageMultiplier, direction)
	if target == attacker or not state[target] then
		return false
	end
	if target:GetAttribute("Eliminated") or Fighters.isInvulnerable(target) then
		return false
	end
	if sameTeam(attacker, target) and not Config.TEAM_ATTACK then
		return false
	end
	-- contre en cours (spécial d'esquive de beaucoup de persos) : le coup est annulé et l'attaquant prend la riposte
	local ts = state[target]
	if ts.counter and os.clock() < ts.counter.untilTime and attacker and state[attacker] and not move.unblockable then
		local counter = ts.counter
		ts.counter = nil
		ts.invulnUntil = math.max(ts.invulnUntil, os.clock() + 0.3)
		if remotes.Fx then
			remotes.Fx:FireAllClients("Counter", { model = target, attacker = attacker, text = counter.move.counter.text })
		end
		local riposte = counter.move.counter.riposte or { damage = 8, kbBase = 35, kbGrowth = 60, kbAngle = 35, hitText = "CONTRÉ !" }
		local attackerRoot, targetRoot = Fighters.root(attacker), Fighters.root(target)
		local back = (attackerRoot and targetRoot and attackerRoot.Position.X < targetRoot.Position.X) and -1 or 1
		task.defer(Fighters.hit, target, attacker, riposte, 1, back)
		return false
	end
	if move.pull then
		direction = -direction -- attire vers l'attaquant (ventouse, aimant…)
	end

	-- un coup encaissé interrompt la recharge et la frappe chargée : recharger, c'est prendre un risque
	Fighters.setCharging(target, false)
	Fighters.clearSmash(target)
	if attacker and state[attacker] then
		state[target].lastHitBy = attacker
		state[target].lastHitAt = os.clock()
	end
	if Fighters.onHit then
		Fighters.onHit(target)
	end

	local damage = math.floor(move.damage * (damageMultiplier or 1) + 0.5)
	local newDamage = target:GetAttribute("Damage") + damage
	target:SetAttribute("Damage", newDamage)

	-- Éjection façon Smash : petite à bas %, de plus en plus violente quand la jauge monte
	local percent = newDamage
	local speed = move.kbBase * Config.KB_BASE_SCALE + move.kbGrowth * Config.KB_GROWTH_SCALE * (percent / 100) * (1 + percent / Config.KB_RAMP)
	local power = move.smashPower
	local comboPiece = move.links ~= nil and power == nil
	if comboPiece then
		-- un coup qui a une suite garde l'adversaire à portée pour que le combo continue
		speed *= Config.COMBO_KB_SCALE
	end
	if power then
		speed *= 1 + Config.SMASH_KB_BONUS * power
	end
	-- juste après le croustillant : beaucoup plus d'éjection
	local obese = Fighters.isObese(target)
	local fragile = not obese and (target:GetAttribute("FragileUntil") or 0) > workspace:GetServerTimeNow()
	if fragile then
		speed *= Config.CROUSTY_FRAGILE_KB
		target:SetAttribute("FragileUntil", 0)
	end
	speed *= Config.KB_SCALE
	local angleDeg = move.kbAngle or 30
	if comboPiece and angleDeg >= 0 and angleDeg < 75 then
		-- coup de combo : l'adversaire décolle un peu et reste à portée pour la suite (vrais combos)
		angleDeg += (75 - angleDeg) * Config.COMBO_POP
	end
	local angle = math.rad(angleDeg)
	local velocity = Vector3.new(math.cos(angle) * speed * direction, math.sin(angle) * speed, 0)
	local hitstun = math.clamp(speed * Config.HITSTUN_PER_KB, Config.HITSTUN_MIN, Config.HITSTUN_MAX)
	if comboPiece then
		hitstun = math.max(hitstun, Config.COMBO_HITSTUN)
	end
	local armored = Fighters.mechanics ~= nil and Fighters.mechanics.hasArmor(target)
	if not obese and not armored then
		Fighters.applyKnockback(target, velocity, hitstun)
	end -- gavé de croustillant ou en armure : personne ne peut l'éjecter, il encaisse juste les dégâts

	if move.status then
		Fighters.applyStatus(target, move.status.name or move.status[1], move.status.duration or move.status[2] or 2)
	end
	if Fighters.mechanics then
		Fighters.mechanics.onHit(attacker, target, move, damage, direction)
	end
	local onBeat = attacker ~= nil and Fighters.mechanics ~= nil and Fighters.mechanics.onBeat(attacker)

	local targetRoot = Fighters.root(target)
	if targetRoot and remotes.Fx then
		local position = targetRoot.Position + Vector3.new(-direction * 0.8, 0.8, 1)
		remotes.Fx:FireAllClients("Hit", {
			attacker = attacker,
			target = target,
			position = position,
			power = obese and 20 or speed,
			text = obese and "MOELLEUX !" or armored and "MÊME PAS MAL !" or fragile and "FRAGILE !" or onBeat and "SUR LE TEMPO !" or move.hitText,
		})
	end
	if attacker and state[attacker] then
		Fighters.addSuper(attacker, damage * 0.8)
		-- esquive de poursuite : juste après une touche, l'esquive revient presque tout de suite
		attacker:SetAttribute("ChaseUntil", workspace:GetServerTimeNow() + Config.CHASE_DODGE_WINDOW)
		local as = state[attacker]
		as.dodgeReadyAt = math.min(as.dodgeReadyAt, os.clock() + Config.CHASE_DODGE_COOLDOWN)
	end
	Fighters.addSuper(target, damage * 0.4)
	Fighters.updateFinishable(target)
	return true
end

return Fighters

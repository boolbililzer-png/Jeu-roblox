-- Mécaniques propres à chaque perso (champ passive de sa fiche, voir le roster) et bonus passagers.
-- Rien ne s'achète ici : ce sont les règles du perso, identiques pour tout le monde dans tous les modes.
--
-- Jauge affichée sous le perso (HUD) : attributs Meter, MeterMax, MeterName, MeterIcon, MeterColor.
-- Bonus passager : attributs Buff / BuffUntil (voir shared/Statuses.lua BUFFS).
--
-- passive.kind :
--   "bulles"    Gégé : gorgées (S_down, selfEffect.bulles) = +10 % de dégâts chacune, il titube (max 3)
--   "traps"     pièges posés au sol (kind = "trap"), au plus passive.max (Mamie : pelotes)
--   "walls"     murs posés (kind = "wall"), au plus passive.max (Marcel : murs invisibles)
--   "rating"    Dylan : note client 1 à 5 ⭐ ; chaque touche enchaînée la monte, chaque coup reçu la baisse ;
--               +passive.speedPerStar de vitesse par étoile au-dessus de 1
--   "forms"     Bernard : chaque touche colle un formulaire ; à passive.max (3), l'adversaire est « en attente »
--   "burn"      Chef : les coups marqués burn = true brûlent (dégâts dans la durée)
--   "caprice"   Bébé : les dégâts reçus remplissent la jauge ; pleine, bonus « caprice » (encaisse sans broncher)
--   "tempo"     Gloria : métronome de passive.period s ; une touche sur le temps fait +30 %
--   "likes"     Lola : +passive.gain par touche ; à passive.max, bonus « viral »
--   "rage"      Jordan : les dégâts reçus montent la rage ; à 100, bonus « tilt » (+50 %, plus d'esquive)
--   "laugh"     Dr Fraise : rien de passif, ses coups donnent le statut « laughing »
--   "bounce"    Sumo : qui le frappe au corps à corps rebondit un peu en arrière
--   "contagion" Ramsès : ses coups marqués status sneezy enrhument ; l'enrhumé éternue au hasard
--   "float"     Canard : sauts en l'air en plus (passive.airJumps), plané ; pression d'eau pour ses tirs
--   "tricks"    Gaston : chaque coup à variants a 3 résultats possibles, le prochain est affiché (NextTrick)
--   "fresh"     Bob : la fraîcheur baisse quand il bouge, remonte à l'arrêt ; haute, ses coups gèlent
--   "tank"      R-0B0 : aspire les projectiles (kind = "absorb") et les recrache (meterCost)
--   "playlist"  Papi DJ : 3 morceaux (Track) : Rap = vitesse, Slow = soin, Techno = dégâts ; selfEffect.nextTrack
--   "flock"     Roi Pigeon : nuée de pigeons (max 6) qui revient avec le temps ; ses envois coûtent meterCost
--   "grapple"   Madame Ventouse : rien de passif, ses coups kind = "grapple" s'accrochent
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local Statuses = require(Shared:WaitForChild("Statuses"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))

local Mechanics = {}

local fxRemote = nil
local rng = Random.new()
local lastLanded = {} -- model -> os.clock() de la dernière touche (note client)
local nextSneeze = {} -- model -> os.clock()
local lastPosition = {} -- model -> Vector3 (fraîcheur)

local DEFAULTS = {
	bulles = { name = "Bulles", icon = "🫧", max = 3 },
	traps = { name = "Pièges", icon = "🧶", max = 3 },
	walls = { name = "Murs", icon = "🧱", max = 2 },
	rating = { name = "Note client", icon = "⭐", max = 5, start = 1, speedPerStar = 0.06, chain = 2.5 },
	forms = { name = "Paperasse", icon = "📋", max = 3, duration = 2 },
	burn = { name = "Cuisson", icon = "🔥" },
	caprice = { name = "Caprice", icon = "😭", max = 100, gain = 1.4, duration = 5 },
	tempo = { name = "Tempo", icon = "🎵", period = 0.6, window = 0.12, bonus = 1.3 },
	likes = { name = "Likes", icon = "❤️", max = 1000, gain = 100, duration = 8 },
	rage = { name = "Rage", icon = "😡", max = 100, gain = 1.2, duration = 6 },
	laugh = { name = "Fou rire", icon = "😂" },
	bounce = { name = "Rebond", icon = "🍮", push = 32 },
	contagion = { name = "Contagion", icon = "🤧" },
	float = { name = "Pression", icon = "💧", max = 100, regen = 22, airJumps = 2, glide = true },
	tricks = { name = "Tours ratés", icon = "🎩", icons = { "✨", "💥", "🐇" } },
	fresh = { name = "Fraîcheur", icon = "❄️", max = 100, drain = 28, regen = 22, threshold = 70, freeze = 0.9 },
	tank = { name = "Réservoir", icon = "🌀", max = 3 },
	playlist = { name = "Playlist", icon = "🎧", tracks = { "rap", "slow", "techno" } },
	flock = { name = "Nuée", icon = "🐦", max = 6, regen = 0.7, start = 6 },
	grapple = { name = "Grappin", icon = "🪠" },
}

function Mechanics.setFxRemote(remote)
	fxRemote = remote
end

local function fire(kind, data)
	if fxRemote then
		fxRemote:FireAllClients(kind, data)
	end
end

function Mechanics.passive(model)
	local data = CharacterList[model:GetAttribute("Character") or ""]
	local passive = data and data.passive
	if not passive then
		return nil
	end
	local defaults = DEFAULTS[passive.kind] or {}
	-- les valeurs par défaut complètent la fiche (calculé une fois par perso)
	if not passive._merged then
		for key, value in pairs(defaults) do
			if passive[key] == nil then
				passive[key] = value
			end
		end
		passive._merged = true
	end
	return passive
end


function Mechanics.meter(model)
	return model:GetAttribute("Meter") or 0
end

function Mechanics.setMeter(model, value)
	local max = model:GetAttribute("MeterMax") or 0
	model:SetAttribute("Meter", math.clamp(value, 0, max > 0 and max or math.huge))
end

function Mechanics.setBuff(model, name, duration)
	model:SetAttribute("Buff", name)
	model:SetAttribute("BuffUntil", workspace:GetServerTimeNow() + duration)
	fire("Buff", { model = model, name = name })
end

local function buffActive(model, name)
	return model:GetAttribute("Buff") == name and (model:GetAttribute("BuffUntil") or 0) > workspace:GetServerTimeNow()
end

-- Début de match et nouvelle vie : jauges remises à leur valeur de départ
function Mechanics.reset(model)
	local p = Mechanics.passive(model)
	model:SetAttribute("Buff", "")
	model:SetAttribute("BuffUntil", 0)
	model:SetAttribute("SpeedMult", 1)
	model:SetAttribute("Forms", 0)
	model:SetAttribute("NextTrick", 0)
	model:SetAttribute("Track", "")
	model:SetAttribute("AirJumpsBonus", 0)
	model:SetAttribute("Glide", false)
	model:SetAttribute("MeterName", p and p.name or "")
	model:SetAttribute("MeterIcon", p and p.icon or "")
	model:SetAttribute("MeterColor", p and p.color or Color3.fromRGB(255, 220, 80))
	local max = 0
	local start = 0
	if p then
		if p.kind == "rating" or p.kind == "caprice" or p.kind == "likes" or p.kind == "rage" or p.kind == "float"
			or p.kind == "fresh" or p.kind == "tank" or p.kind == "flock" or p.kind == "traps" or p.kind == "walls" then
			max = p.max or 0
		end
		start = p.start or (p.kind == "float" and p.max) or (p.kind == "fresh" and p.max) or 0
		if p.kind == "float" then
			model:SetAttribute("AirJumpsBonus", (p.airJumps or 2) - Config.AIR_JUMPS)
			model:SetAttribute("Glide", p.glide == true)
		elseif p.kind == "tricks" then
			model:SetAttribute("NextTrick", rng:NextInteger(1, 3))
		elseif p.kind == "playlist" then
			-- le premier morceau donne son bonus dès le début
			model:SetAttribute("Track", p.tracks[1])
			model:SetAttribute("Buff", p.tracks[1])
			model:SetAttribute("BuffUntil", workspace:GetServerTimeNow() + 9999)
		end
	end
	model:SetAttribute("MeterMax", max)
	model:SetAttribute("Meter", math.min(start, max > 0 and max or start))
	lastLanded[model] = nil
	Mechanics.updateSpeed(model)
end

function Mechanics.updateSpeed(model)
	local p = Mechanics.passive(model)
	local mult = 1
	if p and p.kind == "rating" then
		mult += (math.max(1, Mechanics.meter(model)) - 1) * p.speedPerStar
	end
	model:SetAttribute("SpeedMult", mult)
end

------------------------------------------------------------------------ Coûts
-- Coups qui consomment la jauge du perso (pression du Canard, pigeons, réservoir…)
function Mechanics.canPay(model, move)
	return not move.meterCost or Mechanics.meter(model) >= move.meterCost
end

function Mechanics.pay(model, move)
	if move.meterCost then
		Mechanics.setMeter(model, Mechanics.meter(model) - move.meterCost)
	end
end

-- Gaston : le coup prend la variante annoncée (1 à 3), puis on tire la suivante
function Mechanics.variant(model, move)
	if not move.variants then
		return move
	end
	local index = model:GetAttribute("NextTrick") or 0
	if index < 1 or index > #move.variants then
		index = rng:NextInteger(1, #move.variants)
	end
	model:SetAttribute("NextTrick", rng:NextInteger(1, #move.variants))
	local merged = table.clone(move)
	for key, value in pairs(move.variants[index]) do
		merged[key] = value
	end
	merged.variants = nil
	return merged
end

------------------------------------------------------------------------ Dégâts
-- Multiplicateur de dégâts de l'attaquant : gorgées de Gégé, bonus en cours, tempo de Gloria
function Mechanics.damageMultiplier(attacker)
	local mult = 1 + 0.1 * (attacker:GetAttribute("Bulles") or 0)
	mult *= Statuses.flags(attacker).damage or 1
	local p = Mechanics.passive(attacker)
	if p and p.kind == "tempo" then
		local t = workspace:GetServerTimeNow() % p.period
		if t < p.window or p.period - t < p.window then
			mult *= p.bonus
			attacker:SetAttribute("OnBeat", workspace:GetServerTimeNow())
		end
	end
	return mult
end

-- Le coup a-t-il été « sur le temps » (pour le texte d'impact) ?
function Mechanics.onBeat(attacker)
	return math.abs(workspace:GetServerTimeNow() - (attacker:GetAttribute("OnBeat") or -10)) < 0.2
end

-- Armure : le coup fait ses dégâts mais n'éjecte pas (caprice de Bébé, titubade de Gégé…)
function Mechanics.hasArmor(model)
	local s = Fighters.get(model)
	return Statuses.flags(model).armor == true or (s ~= nil and os.clock() < (s.armorUntil or 0))
end

-- Après une touche : jauges de l'attaquant (note, likes, paperasse…) et de la victime (caprice, rage)
function Mechanics.onHit(attacker, target, move, damage, direction)
	if attacker and Fighters.get(attacker) then
		local p = Mechanics.passive(attacker)
		local kind = p and p.kind
		if kind == "rating" then
			local now = os.clock()
			if lastLanded[attacker] and now - lastLanded[attacker] <= p.chain then
				Mechanics.setMeter(attacker, Mechanics.meter(attacker) + 0.5)
			end
			lastLanded[attacker] = now
			Mechanics.updateSpeed(attacker)
		elseif kind == "forms" and not move.noForm then
			local forms = (target:GetAttribute("Forms") or 0) + 1
			if forms >= p.max then
				target:SetAttribute("Forms", 0)
				Fighters.applyStatus(target, "waiting", p.duration)
				fire("Popup", { model = target, text = "EN ATTENTE…", icon = "📋" })
			else
				target:SetAttribute("Forms", forms)
			end
		elseif kind == "likes" then
			local likes = Mechanics.meter(attacker) + p.gain
			if likes >= p.max then
				Mechanics.setMeter(attacker, 0)
				Mechanics.setBuff(attacker, "viral", p.duration)
			else
				Mechanics.setMeter(attacker, likes)
			end
		elseif kind == "fresh" and Mechanics.meter(attacker) >= p.threshold and (move.kind or "melee") == "melee" then
			Fighters.applyStatus(target, "frozen", p.freeze)
		end
	end
	if move.burn then
		Fighters.applyStatus(target, "burning", move.burnTime or 3)
	end

	local tp = Mechanics.passive(target)
	local tkind = tp and tp.kind
	if tkind == "rating" then
		Mechanics.setMeter(target, Mechanics.meter(target) - 1)
		Mechanics.updateSpeed(target)
	elseif (tkind == "caprice" or tkind == "rage") and not buffActive(target, tkind == "caprice" and "caprice" or "tilt") then
		local value = Mechanics.meter(target) + damage * tp.gain
		if value >= tp.max then
			Mechanics.setMeter(target, 0)
			Mechanics.setBuff(target, tkind == "caprice" and "caprice" or "tilt", tp.duration)
		else
			Mechanics.setMeter(target, value)
		end
	elseif tkind == "bounce" and attacker and (move.kind or "melee") == "melee" and Fighters.get(attacker) then
		-- l'attaquant rebondit sur la gélatine
		local push = Vector3.new(-direction * tp.push, tp.push * 0.45, 0)
		Fighters.nudge(attacker, push)
	end

	-- un coup réveille celui qui dort
	local flags = Statuses.flags(target)
	if flags.wakeOnHit then
		Fighters.clearStatus(target)
		local s = Fighters.get(target)
		if s then
			s.stunnedUntil = os.clock()
		end
	end
end

------------------------------------------------------------------------ Coups « self »
-- selfEffect = { heal = % soignés, energy = +énergie, meter = +jauge, buff = { nom, durée }, bulles = +gorgées,
--               nextTrack = true (Papi DJ), armor = durée d'armure }
function Mechanics.applySelf(model, move)
	local e = move.selfEffect
	if move.effect == "sip" then
		e = e or { bulles = 1 }
	end
	if not e then
		return
	end
	if e.heal then
		model:SetAttribute("Damage", math.max(0, (model:GetAttribute("Damage") or 0) - e.heal))
		Fighters.updateFinishable(model)
	end
	if e.energy then
		model:SetAttribute("Energy", math.min(Config.ENERGY_MAX, (model:GetAttribute("Energy") or 0) + e.energy))
	end
	if e.meter then
		Mechanics.setMeter(model, Mechanics.meter(model) + e.meter)
		Mechanics.updateSpeed(model)
		-- Lola : un Live qui atteint les 1000 likes la rend virale tout de suite
		local p = Mechanics.passive(model)
		if p and p.kind == "likes" and Mechanics.meter(model) >= p.max then
			Mechanics.setMeter(model, 0)
			Mechanics.setBuff(model, "viral", p.duration)
		end
	end
	if e.bulles then
		model:SetAttribute("Bulles", math.min(3, (model:GetAttribute("Bulles") or 0) + e.bulles))
	end
	if e.buff then
		Mechanics.setBuff(model, e.buff[1] or e.buff.name, e.buff[2] or e.buff.duration or 4)
	end
	if e.armor then
		local s = Fighters.get(model)
		if s then
			s.armorUntil = os.clock() + e.armor
		end
	end
	if e.nextTrack then
		local p = Mechanics.passive(model)
		if p and p.tracks then
			local current = model:GetAttribute("Track") or ""
			local index = table.find(p.tracks, current) or 0
			local nextTrack = p.tracks[index % #p.tracks + 1]
			model:SetAttribute("Track", nextTrack)
			Mechanics.setBuff(model, nextTrack, 9999)
		end
	end
end

------------------------------------------------------------------------ Boucle
local accumulator = 0
RunService.Heartbeat:Connect(function(dt)
	accumulator += dt
	if accumulator < 0.1 then
		return
	end
	local step = accumulator
	accumulator = 0
	local now = os.clock()
	local serverNow = workspace:GetServerTimeNow()
	for _, model in ipairs(Fighters.all()) do
		if not model:GetAttribute("Eliminated") then
			local flags = Statuses.flags(model, serverNow)
			-- brûlure : dégâts dans la durée
			if flags.dot then
				local damage = (model:GetAttribute("Damage") or 0) + flags.dot * step
				model:SetAttribute("Damage", damage)
				Fighters.updateFinishable(model)
			end
			-- Slow de Papi DJ : soin lent
			if flags.heal then
				model:SetAttribute("Damage", math.max(0, (model:GetAttribute("Damage") or 0) - flags.heal * step))
			end
			-- enrhumé : éternue au hasard, ce qui coupe l'action en cours
			if flags.sneeze then
				if not nextSneeze[model] then
					nextSneeze[model] = now + rng:NextNumber(0.5, 1.1)
				elseif now >= nextSneeze[model] then
					nextSneeze[model] = now + rng:NextNumber(0.7, 1.3)
					local s = Fighters.get(model)
					if s then
						s.busyUntil = math.max(s.busyUntil, now + 0.35)
						Fighters.stun(model, 0.3)
					end
					fire("Sneeze", { model = model })
				end
			else
				nextSneeze[model] = nil
			end
			-- bonus terminé
			if (model:GetAttribute("Buff") or "") ~= "" and (model:GetAttribute("BuffUntil") or 0) <= serverNow then
				model:SetAttribute("Buff", "")
			end

			local p = Mechanics.passive(model)
			local kind = p and p.kind
			local root = Fighters.root(model)
			if kind == "float" or kind == "flock" then
				Mechanics.setMeter(model, Mechanics.meter(model) + p.regen * step)
			elseif kind == "fresh" and root then
				local previous = lastPosition[model]
				local moving = previous ~= nil and (root.Position - previous).Magnitude > 0.25
				lastPosition[model] = root.Position
				Mechanics.setMeter(model, Mechanics.meter(model) + (moving and -p.drain or p.regen) * step)
			elseif kind == "rating" and lastLanded[model] and now - lastLanded[model] > 6 and Mechanics.meter(model) > 1 then
				-- la note retombe doucement quand il ne livre plus
				Mechanics.setMeter(model, Mechanics.meter(model) - 0.15 * step)
				Mechanics.updateSpeed(model)
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local character = player.Character
	if character then
		lastLanded[character], nextSneeze[character], lastPosition[character] = nil, nil, nil
	end
end)

return Mechanics

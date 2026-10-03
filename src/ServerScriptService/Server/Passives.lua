-- Passifs des 20 combattants. Chaque passif expose sa jauge au HUD via des attributs du modèle :
--   PassiveText (texte), PassiveValue (0..1), PassiveHot (effet actif).
local Passives = {}

local function now(): number
	return workspace:GetServerTimeNow()
end

local function show(f, text: string, value: number, hot: boolean?)
	local m = f.model
	if m then
		m:SetAttribute("PassiveText", text)
		m:SetAttribute("PassiveValue", math.floor(math.clamp(value, 0, 1) * 50 + 0.5) / 50)
		m:SetAttribute("PassiveHot", hot == true)
	end
end

local TRACKS = { "Rap", "Slow", "Techno" }
local TRICKS = { "Colombe", "Confettis", "Lapin" }

function Passives.init(f)
	local p = f.passive
	table.clear(p)
	local kind = f.data.passive
	if kind == "bulles" then
		p.gorgees = 0
	elseif kind == "note" then
		p.stars = 3
	elseif kind == "caprice" then
		p.caprice = 0
	elseif kind == "likes" then
		p.likes = 0
	elseif kind == "rage" then
		p.rage = 0
	elseif kind == "tours" then
		p.trick = math.random(1, 3)
	elseif kind == "fraicheur" then
		p.fresh = 100
	elseif kind == "playlist" then
		p.track = 1
	elseif kind == "nuee" then
		p.pigeons = 6
		p.regen = 0
	end
	Passives.refresh(f)
end

function Passives.refresh(f)
	local p, kind, t = f.passive, f.data.passive, now()
	local speed = 1
	if kind == "bulles" then
		show(f, ("Gorgées %d/3"):format(p.gorgees), p.gorgees / 3, p.gorgees >= 3)
	elseif kind == "pelotes" then
		show(f, ("Pelotes %d/3"):format(#f.traps), #f.traps / 3)
	elseif kind == "note" then
		show(f, string.rep("★", p.stars) .. string.rep("☆", 5 - p.stars), p.stars / 5, p.stars >= 5)
		speed = 1 + (p.stars - 3) * 0.05
	elseif kind == "paperasse" then
		show(f, "Paperasse : 3 formulaires = ralenti", 0)
	elseif kind == "cuisson" then
		show(f, "Cuisson : ses flammes brûlent", 0)
	elseif kind == "murs" then
		show(f, ("Murs invisibles %d/2"):format(#f.walls), #f.walls / 2)
	elseif kind == "caprice" then
		local hot = f.armorUntil > t
		show(f, if hot then "CRISE ! Super-armure" else "Caprice", if hot then 1 else p.caprice / 100, hot)
	elseif kind == "tempo" then
		show(f, "Tempo : frappe sur le temps", 0)
	elseif kind == "likes" then
		local hot = (p.viralUntil or 0) > t
		show(f, if hot then "VIRALE !" else ("%d likes"):format(p.likes), if hot then 1 else p.likes / 1000, hot)
	elseif kind == "rage" then
		local hot = (p.tiltUntil or 0) > t
		show(f, if hot then "TILT ! +50 %" else ("Rage %d %%"):format(p.rage), if hot then 1 else p.rage / 100, hot)
		if f.model then
			f.model:SetAttribute("NoDodge", hot)
		end
	elseif kind == "fourire" then
		show(f, "Gaz hilarant : bloque les S", 0)
	elseif kind == "rebond" then
		show(f, "Rebond", 0)
	elseif kind == "contagion" then
		show(f, "Contagion", 0)
	elseif kind == "flottaison" then
		show(f, "Flottaison : maintenir SAUT pour planer", 0)
	elseif kind == "tours" then
		show(f, "Prochain tour : " .. TRICKS[p.trick], p.trick / 3)
	elseif kind == "fraicheur" then
		show(f, ("Fraîcheur %d %%"):format(math.floor(p.fresh)), p.fresh / 100, p.fresh >= 70)
	elseif kind == "reservoir" then
		show(f, if f.stored then "Réservoir : PLEIN" else "Réservoir : vide", if f.stored then 1 else 0, f.stored ~= nil)
	elseif kind == "playlist" then
		show(f, "Piste : " .. TRACKS[p.track], p.track / 3, true)
		if p.track == 1 then
			speed = 1.2
		end
	elseif kind == "nuee" then
		show(f, ("Pigeons %d/6"):format(p.pigeons), p.pigeons / 6)
	elseif kind == "grappin" then
		show(f, "Grappin", 0)
	end
	if f.model then
		f.model:SetAttribute("SpeedMult", speed)
	end
end

function Passives.tick(f, dt: number)
	local p, kind = f.passive, f.data.passive
	if kind == "fraicheur" and f.hrp then
		local v = math.abs(f.hrp.AssemblyLinearVelocity.X)
		if v > 3 then
			p.fresh = math.max(0, p.fresh - v * 0.3 * dt)
		else
			p.fresh = math.min(100, p.fresh + 20 * dt)
		end
	elseif kind == "playlist" and p.track == 2 then
		f.damage = math.max(0, f.damage - 1 * dt)
		f:sync()
	elseif kind == "nuee" and p.pigeons < 6 then
		p.regen += dt
		if p.regen >= 2 then
			p.regen = 0
			p.pigeons += 1
		end
	end
	Passives.refresh(f)
end

-- Multiplicateur de dégâts de l'attaquant au lancement du coup
function Passives.damageMult(f, startTime: number): number
	local p, kind, t = f.passive, f.data.passive, now()
	local m = 1
	if kind == "bulles" then
		m *= 1 + 0.1 * p.gorgees
	elseif kind == "tempo" then
		local phase = startTime % 0.6
		if phase < 0.12 or phase > 0.48 then
			m *= 1.3
			f.onBeat = true
		else
			f.onBeat = false
		end
	elseif kind == "likes" and (p.viralUntil or 0) > t then
		m *= 1.25
	elseif kind == "rage" and (p.tiltUntil or 0) > t then
		m *= 1.5
	elseif kind == "playlist" and p.track == 3 then
		m *= 1.2
	end
	return m
end

-- Peut renvoyer une version modifiée du coup (copie) au moment où il est lancé.
function Passives.onMoveStart(f, slot: string, move)
	local p, kind = f.passive, f.data.passive
	local isSig = string.sub(slot, 1, 1) == "S"
	if kind == "bulles" then
		if move.extra == "gorgee" then
			p.gorgees = math.min(3, p.gorgees + 1)
		elseif move.extra == "gegeFlame" and p.gorgees >= 3 then
			move = table.clone(move)
			move.status, move.statusDur = "invert", 3
			p.gorgees = 0
		end
	elseif kind == "tours" and move.extra == "randomTrick" then
		move = table.clone(move)
		if p.trick == 1 then
			move.kind = "projectile"
			move.anim = "throw"
			move.dmg = 9
			move.proj = { speed = 60, grav = 0, size = 1.4, life = 1.2, shape = "Ball", color = "#ffffff", mat = "Neon" }
		elseif p.trick == 2 then
			move.kind = "aura"
			move.radius = 6
			move.dmg = 10
			move.angle = 60
			move.vfx = "#f1c40f"
		else
			move.dmg, move.bkb, move.kbs, move.angle = 15, 30, 0.62, 40
		end
		p.trick = math.random(1, 3)
	elseif kind == "playlist" and move.extra == "nextTrack" then
		p.track = p.track % 3 + 1
	elseif kind == "nuee" and isSig then
		if p.pigeons > 0 then
			p.pigeons -= 1
		else
			move = table.clone(move)
			move.dmg = move.dmg * 0.7
		end
	elseif kind == "fraicheur" and move.extra == "refillFresh" then
		p.fresh = 100
	end
	return move
end

function Passives.onHitDealt(f, victim, move, dmg: number)
	local p, kind, t = f.passive, f.data.passive, now()
	if kind == "note" then
		p.stars = math.min(5, p.stars + 1)
	elseif kind == "paperasse" then
		victim.forms = (victim.forms or 0) + 1 + (move.extraForms or 0)
		if victim.forms >= 3 then
			victim.forms = 0
			victim:addStatus("slow", 2)
		end
		if victim.model then
			victim.model:SetAttribute("Forms", victim.forms)
		end
	elseif kind == "likes" then
		if (p.viralUntil or 0) < t then
			p.likes += 100 + (move.extraLikes or 0)
			if p.likes >= 1000 then
				p.likes = 0
				p.viralUntil = t + 8
			end
		end
	elseif kind == "fraicheur" then
		if p.fresh >= 70 and math.random() < 0.3 then
			victim:addStatus("stun", 0.8)
			if victim.model then
				victim.model:SetAttribute("Frozen", t + 0.8)
			end
		end
	end
end

-- Renvoie true si l'éjection doit être ignorée (super-armure)
function Passives.onHitTaken(f, attacker, move, dmg: number): boolean
	local p, kind, t = f.passive, f.data.passive, now()
	if kind == "note" then
		p.stars = math.max(1, p.stars - 1)
	elseif kind == "caprice" then
		if f.armorUntil < t then
			p.caprice = math.min(100, p.caprice + dmg * 2.5)
			if p.caprice >= 100 then
				p.caprice = 0
				f.armorUntil = t + 5
			end
		end
	elseif kind == "rage" then
		if (p.tiltUntil or 0) < t then
			p.rage = math.min(100, p.rage + dmg * 2)
			if p.rage >= 100 then
				p.rage = 0
				p.tiltUntil = t + 6
			end
		end
	elseif kind == "rebond" and attacker and attacker.hrp and f.hrp and move and move.kind == "melee" then
		local d = attacker.hrp.Position - f.hrp.Position
		if d.Magnitude < 7 then
			local dir = if d.X >= 0 then 1 else -1
			attacker:sendHit(Vector3.new(dir * 28, 10, 0), 0.15)
		end
	end
	return false
end

return Passives

-- Statuts loufoques (subis, attribut Status / StatusUntil) et bonus passagers (Buff / BuffUntil).
-- Un seul statut à la fois, 3 s maximum, puis 5 s d'immunité (voir server/Fighters.lua applyStatus).
-- Les bonus viennent des mécaniques des persos (voir server/Mechanics.lua) : aucun ne s'achète.
-- Les drapeaux sont lus par le serveur (actions refusées) et par le client (commandes, vitesse, écran).
--   noAct     : ne peut rien faire (étourdi, endormi, gelé…)
--   noMove    : ne peut plus se déplacer (enraciné) mais peut frapper
--   noHeavy   : K, ⭐ et les coups chargés sont bloqués (fou rire)
--   noSpecial : S bloqué (muet)
--   noDodge   : ESQUIVE bloquée
--   invert    : gauche et droite inversées
--   speed     : multiplicateur de vitesse de marche
--   dot       : dégâts par seconde (en %)
--   wakeOnHit : un coup reçu met fin au statut
--   blind     : écran assombri pour le joueur touché
--   sneeze    : éternue au hasard, ce qui coupe son action en cours
--   slippery  : glisse (il garde son élan)
--   armor     : (bonus) encaisse sans être éjecté ni sonné
--   damage    : (bonus) multiplicateur de dégâts infligés
--   heal      : (bonus) % de dégâts soignés par seconde
local Statuses = {}

Statuses.LIST = {
	stunned = { noAct = true, icon = "💫", text = "SONNÉ" },
	asleep = { noAct = true, wakeOnHit = true, icon = "💤", text = "ZZZ" },
	frozen = { noAct = true, icon = "🧊", text = "GELÉ" },
	statue = { noAct = true, icon = "🗿", text = "STATUE" },
	dancing = { noAct = true, icon = "💃", text = "DANSE !" },
	inverted = { invert = true, icon = "🔄", text = "INVERSÉ" },
	slowed = { speed = 0.5, icon = "🐌", text = "RALENTI" },
	waiting = { speed = 0.45, noSpecial = true, icon = "📋", text = "EN ATTENTE" },
	rooted = { noMove = true, icon = "🧶", text = "LIGOTÉ" },
	laughing = { noHeavy = true, icon = "😂", text = "FOU RIRE" },
	muted = { noSpecial = true, icon = "🤐", text = "MUET" },
	blinded = { blind = true, icon = "🕶️", text = "AVEUGLÉ" },
	sneezy = { sneeze = true, icon = "🤧", text = "ENRHUMÉ" },
	burning = { dot = 3, icon = "🔥", text = "BRÛLÉ" },
	slippery = { slippery = true, speed = 1.2, icon = "🧼", text = "GLISSE" },
	dog = { noSpecial = true, noHeavy = true, icon = "🐶", text = "OUAF" },
	wet = { speed = 0.7, icon = "💧", text = "TREMPÉ" },
}

Statuses.BUFFS = {
	armor = { armor = true, icon = "🛡️", text = "INÉBRANLABLE" },
	caprice = { armor = true, icon = "😭", text = "CAPRICE !" },
	turbo = { speed = 1.35, icon = "⚡", text = "TURBO" },
	viral = { damage = 1.25, icon = "📈", text = "VIRALE !" },
	tilt = { damage = 1.5, noDodge = true, icon = "😡", text = "TILT !" },
	rap = { speed = 1.2, icon = "🎤", text = "RAP" },
	slow = { heal = 1, icon = "💕", text = "SLOW" },
	techno = { damage = 1.15, icon = "🎛️", text = "TECHNO" },
	stars = { icon = "⭐", text = "" },
}

local NONE = {}

-- Drapeaux actifs d'un combattant (statut subi et bonus fusionnés)
function Statuses.flags(model, now)
	now = now or workspace:GetServerTimeNow()
	local status = model:GetAttribute("Status") or ""
	local buff = model:GetAttribute("Buff") or ""
	local s = (status ~= "" and (model:GetAttribute("StatusUntil") or 0) > now) and Statuses.LIST[status] or NONE
	local b = (buff ~= "" and (model:GetAttribute("BuffUntil") or 0) > now) and Statuses.BUFFS[buff] or NONE
	if b == NONE then
		return s
	elseif s == NONE then
		return b
	end
	local merged = table.clone(s)
	for key, value in pairs(b) do
		if key == "speed" or key == "damage" then
			merged[key] = (merged[key] or 1) * value
		elseif merged[key] == nil then
			merged[key] = value
		end
	end
	return merged
end

-- Vitesse de marche : statut, bonus et mécanique du perso (note client de Dylan…)
function Statuses.speed(model, now)
	return (Statuses.flags(model, now).speed or 1) * (model:GetAttribute("SpeedMult") or 1) * (model:GetAttribute("WeaponSpeed") or 1)
end

-- Ce coup est-il interdit par le statut ? (clé de base, sans « bare. »)
function Statuses.blocks(flags, baseKey)
	if flags.noAct then
		return true
	end
	local prefix = string.sub(baseKey, 1, 2)
	if flags.noHeavy and (prefix == "K_" or string.sub(baseKey, 1, 5) == "SUPER") then
		return true
	end
	if flags.noSpecial and prefix == "S_" then
		return true
	end
	return false
end

return Statuses

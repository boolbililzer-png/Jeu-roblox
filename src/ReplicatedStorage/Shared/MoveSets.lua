-- Caisse Bizarre 📦 et armes.
-- Sans caisse, tout le monde se bat à mains nues : coups P / K communs à tous (shared/BareMoves.lua, rangés sous
-- « bare.clé »), mais chaque perso garde SES spéciaux (S_…, clés non préfixées de la fiche), ses Supers et ses fatals.
-- Celui qui ouvre une caisse en sort UNE de ses 3 armes, au hasard (data.weapons de la fiche) :
--   - l'arme n° 1 (emblématique) joue les coups P / K / S / SUPER non préfixés de data.moves ;
--   - les armes n° 2 et 3 ont leurs propres coups (weapon.moves), rangés sous « <id>.clé » ; ce qu'elles n'écrivent
--     pas (coups aériens, dash, combos…) retombe sur les coups non préfixés du perso.
-- L'attribut « Weapon » du modèle dit quelle arme est sortie ("" ou absent = aucune, mains nues).
local MoveSets = {}

MoveSets.BARE = "bare"

function MoveSets.key(weapon, key)
	return weapon .. "." .. key
end

-- "bare.P_neutral" -> "bare", "P_neutral" ; "P_neutral" -> nil, "P_neutral"
function MoveSets.split(key)
	local weapon, base = string.match(key, "^([%a_]+)%.(.+)$")
	if weapon then
		return weapon, base
	end
	return nil, key
end

-- set = { moves = { clé = coup }, links = { clé = { P = "clé", ... } } }
local function installSet(data, weapon, set)
	for key, move in pairs(set.moves) do
		local copy = table.clone(move)
		copy.weapon = weapon
		local links = set.links and set.links[key] or move.links
		if links then
			local prefixed = {}
			for button, target in pairs(links) do
				-- une suite qui n'existe pas pour l'arme renvoie vers un coup normal du perso (ex. un spécial au L)
				prefixed[button] = set.moves[target] and MoveSets.key(weapon, target) or target
			end
			copy.links = prefixed
		end
		data.moves[MoveSets.key(weapon, key)] = copy
	end
end

local function merge(base, over)
	if not base then
		return over
	end
	if not over then
		return base
	end
	local moves = table.clone(base.moves)
	for key, move in pairs(over.moves) do
		moves[key] = move
	end
	local links = table.clone(base.links or {})
	for key, link in pairs(over.links or {}) do
		links[key] = link
	end
	return { moves = moves, links = links }
end

-- Les mains nues ne gardent que les coups P_ / K_ : sans arme, les L et les Y restent ceux du perso
local function onlyPunchesAndKicks(set)
	if not set then
		return nil
	end
	local moves = {}
	for key, move in pairs(set.moves) do
		local prefix = string.sub(key, 1, 2)
		if prefix == "P_" or prefix == "K_" or string.find(key, "combo", 1, true) then
			moves[key] = move
		end
	end
	return { moves = moves, links = set.links }
end

-- generic = { bare = BareMoves } (secours) ; data.bare = { moves, links } : les coups et combos à mains nues
-- PROPRES au perso (ils remplacent ceux de BareMoves) ; data.weapons[2..] : les armes à coups propres
function MoveSets.install(data, generic)
	local own = data.bare or (data.weaponMoves and data.weaponMoves.bare)
	installSet(data, MoveSets.BARE, onlyPunchesAndKicks(merge(generic.bare, own)))
	data.weaponById = {}
	for index, weapon in ipairs(data.weapons or {}) do
		data.weaponById[weapon.id] = weapon
		weapon.index = index
		if index > 1 and weapon.moves then
			installSet(data, weapon.id, { moves = weapon.moves, links = weapon.links })
		end
	end
	return data
end

-- Arme emblématique (la n° 1) : ses coups sont ceux de data.moves
function MoveSets.iconic(data)
	return data and data.weapons and data.weapons[1] and data.weapons[1].id or nil
end

-- armé = a ouvert une Caisse Bizarre (attribut « Armed »), jusqu'à sa prochaine éjection
function MoveSets.armed(model)
	return model ~= nil and model:GetAttribute("Armed") == true
end

-- Arme sortie : son id, ou nil à mains nues
function MoveSets.weapon(model)
	if not MoveSets.armed(model) then
		return nil
	end
	local id = model:GetAttribute("Weapon")
	return (type(id) == "string" and id ~= "") and id or nil
end

-- Fiche de l'arme sortie (ou nil)
function MoveSets.weaponData(data, model)
	local id = MoveSets.weapon(model)
	return id and data and data.weaponById and data.weaponById[id] or nil
end

-- Capacité passive de l'arme sortie (voir docs/fiche-perso.md) : table vide à mains nues
function MoveSets.ability(data, model)
	local weapon = MoveSets.weaponData(data, model)
	return weapon and weapon.ability or {}
end

-- Ce coup est-il utilisable avec cette arme (weapon = id, nil à mains nues) ?
--   bare.*      : mains nues seulement
--   <arme>.*    : cette arme seulement
--   P_ / K_ nus : il faut une arme (ceux de l'arme emblématique, et de secours pour les autres armes)
--   S_ nus, Supers, saisie, objets, emotes : toujours
function MoveSets.allowed(key, move, weapon)
	local prefix = MoveSets.split(key)
	if prefix == MoveSets.BARE then
		return weapon == nil
	elseif prefix then
		return weapon == prefix
	end
	local kind = string.sub(key, 1, 2)
	if kind == "P_" or kind == "K_" then
		return weapon ~= nil
	end
	return true
end

-- Premier coup utilisable parmi les candidats : à mains nues, les coups communs puis ceux du perso (S, Supers) ;
-- avec une arme, les coups de l'arme puis ceux du perso
function MoveSets.pick(moves, candidates, weapon)
	-- l'arme emblématique n'a pas de coups préfixés : on retombe tout de suite sur ceux du perso
	local order = weapon == nil and { MoveSets.BARE .. ".", "" } or { weapon .. ".", "" }
	for _, prefix in ipairs(order) do
		for _, key in ipairs(candidates) do
			local full = prefix .. key
			if moves[full] and MoveSets.allowed(full, moves[full], weapon) then
				return full
			end
		end
	end
	return nil
end

return MoveSets

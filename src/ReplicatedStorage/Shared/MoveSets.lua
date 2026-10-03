-- Caisse Bizarre 📦 : sans elle, tout le monde se bat à mains nues avec les mêmes coups (shared/BareMoves.lua) ;
-- celui qui ramasse la caisse en sort SON arme (la bouteille de Gégé, le sac de Mamie…) et P, K, S deviennent
-- son moveset unique (les coups de data.moves). Saisie, projections, Supers et fatals restent ceux du perso.
-- Les coups à mains nues sont rangés dans data.moves sous la clé « bare.clé » (ex. "bare.P_neutral"),
-- avec leurs suites d'enchaînement préfixées de la même façon : le reste du jeu les lit comme les autres.
-- Un perso peut remplacer une partie des coups à mains nues avec data.weaponMoves.bare.
local MoveSets = {}

MoveSets.BARE = "bare"

function MoveSets.key(weapon, key)
	return weapon .. "." .. key
end

-- "gloves.P_neutral" -> "gloves", "P_neutral" ; "P_neutral" -> nil, "P_neutral"
function MoveSets.split(key)
	local weapon, base = string.match(key, "^(%a+)%.(.+)$")
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

-- Comme dans Brawlhalla : les coups de l'arme sont communs à tous, et un perso peut remplacer certains coups
-- par les siens (ses « signatures »). Le jeu du perso est fusionné coup par coup par-dessus le jeu générique
-- de l'arme ; un jeu complet (comme les gants de Gégé) remplace donc tout.
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

function MoveSets.install(data, generic)
	local own = data.weaponMoves or {}
	local weapons = {}
	for weapon in pairs(generic) do
		weapons[weapon] = true
	end
	for weapon in pairs(own) do
		weapons[weapon] = true
	end
	for weapon in pairs(weapons) do
		installSet(data, weapon, merge(generic[weapon], own[weapon]))
	end
	return data
end

-- Coup propre au perso qui demande la caisse : P_, K_ et S_ non préfixés (y compris combos et suites)
function MoveSets.needsCrate(key)
	local prefix = string.sub(key, 1, 2)
	return string.find(key, ".", 1, true) == nil and (prefix == "P_" or prefix == "K_" or prefix == "S_")
end

-- armé = a ouvert une Caisse Bizarre (attribut « Armed » du modèle), jusqu'à sa prochaine éjection
function MoveSets.armed(model)
	return model ~= nil and model:GetAttribute("Armed") == true
end

-- Sans la caisse, chaque perso utilise quand même SES coups (tous différents) mais sans son arme, avec des
-- dégâts réduits (Config.UNARMED_DAMAGE, voir server/Mechanics.lua). Les coups communs à mains nues
-- (« bare. », shared/BareMoves.lua) ne servent plus que si MoveSets.SHARED_BARE_HANDS vaut true.
MoveSets.SHARED_BARE_HANDS = false

-- Ce coup est-il utilisable, armé ou à mains nues ?
function MoveSets.allowed(key, move, armed)
	if not MoveSets.SHARED_BARE_HANDS then
		return not (move and move.weapon == MoveSets.BARE)
	end
	if move and move.weapon == MoveSets.BARE then
		return not armed
	elseif MoveSets.needsCrate(key) then
		return armed
	end
	return true
end

-- Premier coup utilisable parmi les candidats : armé, le moveset du perso (sinon à mains nues) ;
-- à mains nues, les coups communs (et ceux qui ne demandent pas la caisse : Supers, saisie…)
function MoveSets.pick(moves, candidates, armed)
	local order = (armed or not MoveSets.SHARED_BARE_HANDS) and { "" } or { MoveSets.BARE .. ".", "" }
	for _, prefix in ipairs(order) do
		for _, key in ipairs(candidates) do
			local full = prefix .. key
			if moves[full] and MoveSets.allowed(full, moves[full], armed) then
				return full
			end
		end
	end
	return nil
end

return MoveSets

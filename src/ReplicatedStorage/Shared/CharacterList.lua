-- Liste des personnages jouables (dans l'ordre de shared/Roster.lua). Ajouter un perso = ajouter son module
-- Characters/<id>.lua et son id dans Roster.ORDER.
-- Les coups à mains nues (sans la Caisse Bizarre) sont ajoutés à chaque perso par MoveSets.
local Characters = script.Parent:WaitForChild("Characters")
local MoveSets = require(script.Parent:WaitForChild("MoveSets"))
local BareMoves = require(script.Parent:WaitForChild("BareMoves"))
local CommonMoves = require(script.Parent:WaitForChild("CommonMoves"))
local Roster = require(script.Parent:WaitForChild("Roster"))
local Config = require(script.Parent:WaitForChild("Config"))

-- Spéciaux (S_…) et Supers (SUPER…) « sûrs de toucher » (voir Config.S_LANE) :
--   corps à corps : la zone devient un couloir devant le perso, à la même hauteur de plateforme, plus large que
--     toutes les attaques P / K (scale = 1 pour un L, SUPER_LANE_SCALE pour un Y) ; la zone écrite dans la fiche
--     n'est qu'un minimum ;
--   ↑L : décollage en diagonale (Config.S_UP_LAUNCH) et couloir qui monte avec le perso ;
--   projectiles : marqués aimed (ils visent l'adversaire le plus proche, voir server/Combat.lua) et plus longs.
-- Chaque coup n'est transformé qu'une fois.
local function widenSpecial(move, key, scale, flying)
	if move._widened then
		return
	end
	move._widened = true
	local kind = move.kind or "melee"
	local box = move.hitbox
	local isUp = key == "S_up"
	local isAir = string.find(key, "air", 1, true) ~= nil
	if isUp then
		-- remontée façon Brawlhalla : élan en diagonale vers l'avant, le coup frappe sur tout le passage
		local launch = move.selfVelocity or Vector2.new(0, 0)
		move.selfVelocity = Vector2.new(math.max(launch.X, Config.S_UP_LAUNCH.X), math.max(launch.Y, Config.S_UP_LAUNCH.Y))
		if box and box.size then
			move.hitbox = { size = Vector3.new(math.max(box.size.X, 10), math.max(box.size.Y, 11), box.size.Z), offset = Vector2.new(3, 4) }
		end
		if flying and (move.damage or 0) > 0 then
			move.damage = math.floor(move.damage * Config.S_UP_FLYER_DAMAGE + 0.5)
		end
	elseif box and box.size and box.offset and (kind == "melee" or kind == "absorb" or kind == "counter" or kind == "wall") then
		local size, offset = box.size, box.offset
		local lane = Config.S_LANE * scale
		local height = Config.S_LANE_HEIGHT * scale
		if isAir then
			-- en l'air : zone très large tout autour (vers le bas pour un plongeon)
			move.hitbox = {
				size = Vector3.new(math.max(size.X * Config.S_RANGE, lane * 0.6), math.max(size.Y * Config.S_RANGE, height), size.Z),
				offset = Vector2.new(offset.X * Config.S_RANGE, offset.Y),
			}
		elseif size.X >= 12 and math.abs(offset.X) <= size.X * 0.25 then
			-- zone déjà très large et centrée sur le perso (onde, cri, monologue…) : on la garde des deux côtés
			move.hitbox = { size = Vector3.new(size.X, math.max(size.Y, height), size.Z), offset = Vector2.new(offset.X, offset.Y) }
			move.lane = size.X
			move.laneCentered = true
		else
			-- au sol : couloir devant le perso, qui commence juste derrière lui (touche aussi à bout portant)
			local length = math.max(size.X * Config.S_RANGE, lane)
			move.hitbox = {
				size = Vector3.new(length, math.max(size.Y, height), size.Z),
				offset = Vector2.new(length / 2 - 1.5, math.max(offset.Y, 0.5)),
			}
			move.lane = length
		end
	end
	local function aimProjectile(holder)
		if holder.projectile and not holder.projectile._aimedDone then
			local projectile = table.clone(holder.projectile)
			if projectile.lifetime then
				projectile.lifetime *= Config.S_PROJECTILE_RANGE
			end
			if projectile.aim ~= false then
				projectile.aimed = true
			end
			projectile._aimedDone = true
			holder.projectile = projectile
		end
	end
	aimProjectile(move)
	-- variantes (Gaston) : chacune peut remplacer le projectile, elles visent aussi
	for _, variant in ipairs(move.variants or {}) do
		aimProjectile(variant)
	end
	-- plus de jauges : rien ne coûte plus rien
	if Config.INFINITE_SPECIALS then
		move.energyCost = 0
		move.superCost = nil
		move.meterCost = nil
	end
end

-- Attaques P / K : zone un peu plus large (les combos touchent plus souvent)
local function widenLight(move)
	if move._widened or (move.kind or "melee") ~= "melee" or not move.hitbox then
		return
	end
	move._widened = true
	local size, offset = move.hitbox.size, move.hitbox.offset
	move.hitbox = {
		size = Vector3.new(size.X * Config.LIGHT_RANGE, size.Y * Config.LIGHT_RANGE, size.Z),
		offset = Vector2.new(offset.X * Config.LIGHT_RANGE, offset.Y),
	}
end

-- Signatures (L) : toujours plus fortes que les attaques P / K du perso
local function strengthenSpecials(data)
	-- la plus forte attaque P / K, tous jeux d'armes confondus (les mains nues comprises)
	local strongest = 0
	for key, move in pairs(data.moves) do
		local _, base = MoveSets.split(key)
		local prefix = string.sub(base, 1, 2)
		if prefix == "P_" or prefix == "K_" then
			strongest = math.max(strongest, move.damage or 0)
		end
	end
	for key, move in pairs(data.moves) do
		local weapon, base = MoveSets.split(key)
		if string.sub(base, 1, 2) == "S_" and weapon ~= MoveSets.BARE and (move.damage or 0) > 0 and not move._strengthened then
			move._strengthened = true
			-- la règle porte sur le TOTAL du coup : une rafale ou un coup à plusieurs touches répartit le bonus
			local hits = move.hits or 1
			local p = move.projectile
			if p then
				hits *= (p.hits or 1) * ((p.fan and p.fan.count) or (p.rain and p.rain.count) or 1)
			end
			local total = math.max(move.damage * hits * Config.S_DAMAGE, strongest + Config.S_DAMAGE_OVER_LIGHT)
			move.damage = math.max(1, math.floor(total / hits + 0.5))
		end
	end
end

local list = {}
for _, id in ipairs(Roster.ORDER) do
	local module = Characters:FindFirstChild(id)
	if module then
		local ok, data = pcall(require, module)
		if ok and type(data) == "table" then
			list[id] = data
		else
			warn("Personnage « " .. id .. " » illisible : " .. tostring(data))
		end
	end
end
for _, data in pairs(list) do
	-- lancer d'objet pour tous, saisie et projections par défaut si le perso n'a pas les siennes
	for key, move in pairs(CommonMoves) do
		if not data.moves[key] then
			data.moves[key] = move
		end
	end
	-- 3 armes par perso (Caisse Bizarre) ; une fiche sans liste d'armes garde son arme emblématique seule
	if type(data.weapons) ~= "table" or #data.weapons == 0 then
		local info = Roster.INFO[data.id] or {}
		data.weapons = { { id = "arme", name = info.weapon or "Arme", icon = info.icon or "📦" } }
	end
	MoveSets.install(data, { bare = BareMoves })
	strengthenSpecials(data)
	for key, move in pairs(data.moves) do
		local _, base = MoveSets.split(key)
		local prefix = string.sub(base, 1, 2)
		if prefix == "S_" then
			widenSpecial(move, base, 1, data.flying == true)
		elseif string.sub(base, 1, 5) == "SUPER" then
			widenSpecial(move, base, Config.SUPER_LANE_SCALE, false)
		elseif prefix == "P_" or prefix == "K_" then
			widenLight(move)
		end
	end
end
return list

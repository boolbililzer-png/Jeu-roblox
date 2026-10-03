-- Liste des personnages jouables (dans l'ordre de shared/Roster.lua). Ajouter un perso = ajouter son module
-- Characters/<id>.lua et son id dans Roster.ORDER.
-- Les coups à mains nues (sans la Caisse Bizarre) sont ajoutés à chaque perso par MoveSets.
local Characters = script.Parent:WaitForChild("Characters")
local MoveSets = require(script.Parent:WaitForChild("MoveSets"))
local BareMoves = require(script.Parent:WaitForChild("BareMoves"))
local CommonMoves = require(script.Parent:WaitForChild("CommonMoves"))
local Roster = require(script.Parent:WaitForChild("Roster"))
local Config = require(script.Parent:WaitForChild("Config"))

-- Spéciaux (S_…) : portée augmentée (Config.S_RANGE). Chaque coup n'est agrandi qu'une fois.
local function widenSpecial(move)
	if move._widened then
		return
	end
	move._widened = true
	local box = move.hitbox
	if box and box.size and box.offset then
		local size, offset = box.size, box.offset
		move.hitbox = {
			size = Vector3.new(size.X * Config.S_RANGE, size.Y * (1 + (Config.S_RANGE - 1) * 0.5), size.Z),
			offset = Vector2.new(offset.X * Config.S_RANGE, offset.Y),
		}
	end
	if move.projectile and move.projectile.lifetime then
		local projectile = table.clone(move.projectile)
		projectile.lifetime *= Config.S_PROJECTILE_RANGE
		move.projectile = projectile
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
	MoveSets.install(data, { bare = BareMoves })
	for key, move in pairs(data.moves) do
		local _, base = MoveSets.split(key)
		if string.sub(base, 1, 2) == "S_" then
			widenSpecial(move)
		end
	end
end
return list

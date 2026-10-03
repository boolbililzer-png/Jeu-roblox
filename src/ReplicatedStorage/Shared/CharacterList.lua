-- Liste des personnages jouables (dans l'ordre de shared/Roster.lua). Ajouter un perso = ajouter son module
-- Characters/<id>.lua et son id dans Roster.ORDER.
-- Les coups à mains nues (sans la Caisse Bizarre) sont ajoutés à chaque perso par MoveSets.
local Characters = script.Parent:WaitForChild("Characters")
local MoveSets = require(script.Parent:WaitForChild("MoveSets"))
local BareMoves = require(script.Parent:WaitForChild("BareMoves"))
local CommonMoves = require(script.Parent:WaitForChild("CommonMoves"))
local Roster = require(script.Parent:WaitForChild("Roster"))

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
end
return list

-- Liste des personnages jouables. Ajouter un perso = ajouter son module dans Characters et une ligne ici.
-- Les coups à mains nues (sans la Caisse Bizarre) sont ajoutés à chaque perso par MoveSets.
local Characters = script.Parent:WaitForChild("Characters")
local MoveSets = require(script.Parent:WaitForChild("MoveSets"))
local BareMoves = require(script.Parent:WaitForChild("BareMoves"))
local CommonMoves = require(script.Parent:WaitForChild("CommonMoves"))

local list = {
	Gege = require(Characters:WaitForChild("Gege")),
}
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

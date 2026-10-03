-- Accès pratique aux combattants et à leurs coups.
local GameData = require(script.Parent.GameData)

local Fighters = {}

local byKey = {}
for _, f in GameData.Fighters do
	byKey[f.key] = f
end

Fighters.List = GameData.Fighters
Fighters.Unarmed = GameData.Unarmed

function Fighters.get(key: string)
	return byKey[key]
end

function Fighters.move(key: string, armed: boolean, slot: string)
	if armed then
		local f = byKey[key]
		if f and f.moves[slot] then
			return f.moves[slot]
		end
	end
	return GameData.Unarmed[slot]
end

-- Traduit bouton + direction + en l'air en case de la grille (Grille des Combos & Signatures).
-- dirX/dirY dans [-1, 1] (dirY > 0 = haut).
function Fighters.resolveSlot(button: string, dirX: number, dirY: number, airborne: boolean): string
	local side = math.abs(dirX) > 0.5
	local down = dirY < -0.55
	local up = dirY > 0.55
	if button == "P" then
		if airborne then
			if down then
				return "PairD"
			elseif side then
				return "PairS"
			end
			return "PairN"
		end
		if down then
			return "Pd"
		elseif side then
			return "Ps"
		end
		return "Pn"
	end
	-- Signatures
	if up then
		return "Sup"
	end
	if down then
		return if airborne then "SairD" else "Sd"
	end
	if side then
		return "Ss"
	end
	return "Sn"
end

function Fighters.arena(key: string)
	return GameData.Arenas[key]
end

return Fighters

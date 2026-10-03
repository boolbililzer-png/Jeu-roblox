-- Les 20 combattants dans l'ordre du roster, et ce qui est gratuit (voir docs/gameplay-progression.md).
-- Un perso de cette liste dont la fiche (Characters/<id>.lua) manque est simplement ignoré.
local Roster = {}

Roster.ORDER = {
	"Gege", "Mamie", "Dylan", "Bernard", "Chef", "Marcel", "Bebe", "Gloria", "Lola", "Jordan",
	"Fraise", "Sumo", "Ramses", "Canard", "Gaston", "Bob", "Robo", "Papi", "Pigeon", "Ventouse",
}

-- Gratuits pour toujours
Roster.FREE = { Gege = true, Mamie = true, Dylan = true, Sumo = true, Marcel = true, Pigeon = true }

-- Prix d'un perso payant, en pièces (≈ 8 à 10 h de jeu à ~30 pièces par partie + missions)
Roster.PRICE = 3000

-- Rotation gratuite : 4 persos payants changent chaque semaine (même tirage pour tous les serveurs)
Roster.ROTATION_SIZE = 4
local WEEK = 7 * 24 * 3600
function Roster.rotation(unixTime)
	local week = math.floor((unixTime or os.time()) / WEEK)
	local paid = {}
	for _, id in ipairs(Roster.ORDER) do
		if not Roster.FREE[id] then
			table.insert(paid, id)
		end
	end
	local rng = Random.new(week * 7919 + 17)
	local picked = {}
	for _ = 1, math.min(Roster.ROTATION_SIZE, #paid) do
		local index = rng:NextInteger(1, #paid)
		picked[table.remove(paid, index)] = true
	end
	return picked
end

-- Maîtrise : niveau 1 à 30 par perso, en jouant. Jamais de bonus de stats (décision de YAZ) :
-- seulement des fatals, variantes, couleurs et titres.
Roster.MASTERY_MAX = 30
Roster.XP_PER_LEVEL = 100 -- une partie rapporte ~40 à 70 XP au perso joué
Roster.FATAL_LEVELS = { 1, 5, 15 } -- 1er fatal offert, 2e au niveau 5, 3e au niveau 15
Roster.MASTERY_REWARDS = {
	[2] = "Couleur alternative n°1",
	[5] = "2ᵉ coup fatal",
	[8] = "Provocation",
	[10] = "Variante de Super",
	[15] = "3ᵉ coup fatal",
	[20] = "Titre + bordure de profil",
	[25] = "Effet de KO personnalisé",
	[30] = "Skin « Maître » doré",
}

function Roster.levelFromXp(xp)
	return math.clamp(math.floor((xp or 0) / Roster.XP_PER_LEVEL) + 1, 1, Roster.MASTERY_MAX)
end

-- Nombre de fatals débloqués à ce niveau de maîtrise
function Roster.fatalsUnlocked(level)
	local n = 0
	for _, needed in ipairs(Roster.FATAL_LEVELS) do
		if (level or 1) >= needed then
			n += 1
		end
	end
	return n
end

return Roster

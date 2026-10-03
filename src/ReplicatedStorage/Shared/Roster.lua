-- Les 20 combattants dans l'ordre du roster, et ce qui est gratuit (voir docs/gameplay-progression.md).
-- Un perso de cette liste dont la fiche (Characters/<id>.lua) manque est simplement ignoré.
local Roster = {}

Roster.ORDER = {
	"Gege", "Mamie", "Dylan", "Bernard", "Chef", "Marcel", "Bebe", "Gloria", "Lola", "Jordan",
	"Fraise", "Sumo", "Ramses", "Canard", "Gaston", "Bob", "Robo", "Papi", "Pigeon", "Ventouse",
}

-- Présentation dans le menu de choix : style de jeu, difficulté (★), arme sortie de la Caisse Bizarre, icône
Roster.INFO = {
	Gege = { title = "Piégeur imprévisible", stars = 2, weapon = "Bouteille de soda douteux", icon = "🍾", color = Color3.fromRGB(170, 220, 60) },
	Mamie = { title = "Zoneuse", stars = 3, weapon = "Sac à main & canne", icon = "🧶", color = Color3.fromRGB(230, 150, 190) },
	Dylan = { title = "Rushdown", stars = 2, weapon = "Trottinette & sac cube", icon = "🛵", color = Color3.fromRGB(70, 200, 120) },
	Bernard = { title = "Contrôle", stars = 3, weapon = "Tampon géant & dossiers", icon = "📋", color = Color3.fromRGB(150, 150, 160) },
	Chef = { title = "Polyvalent", stars = 2, weapon = "Poêle & rouleau à pâtisserie", icon = "🍳", color = Color3.fromRGB(255, 130, 50) },
	Marcel = { title = "Défense et pièges", stars = 3, weapon = "Accessoires invisibles", icon = "🤍", color = Color3.fromRGB(235, 235, 235) },
	Bebe = { title = "Choppeur", stars = 2, weapon = "Hochet géant & couche", icon = "🍼", color = Color3.fromRGB(150, 200, 255) },
	Gloria = { title = "Rythme", stars = 3, weapon = "Enceinte fluo & jambières", icon = "💃", color = Color3.fromRGB(255, 90, 200) },
	Lola = { title = "Zoneuse", stars = 2, weapon = "Perche à selfie & ring light", icon = "🤳", color = Color3.fromRGB(255, 150, 200) },
	Jordan = { title = "Rushdown", stars = 3, weapon = "Manette filaire & clavier", icon = "🎮", color = Color3.fromRGB(90, 255, 140) },
	Fraise = { title = "Contrôle", stars = 2, weapon = "Fraise géante & miroir", icon = "🦷", color = Color3.fromRGB(120, 220, 230) },
	Sumo = { title = "Tank pour débutants", stars = 1, weapon = "Gants en guimauve", icon = "🍮", color = Color3.fromRGB(255, 170, 200) },
	Ramses = { title = "Usure", stars = 2, weapon = "Bandelettes & thermomètre", icon = "🤧", color = Color3.fromRGB(230, 220, 190) },
	Canard = { title = "Aérien", stars = 2, weapon = "Bouée canard & pistolet à eau", icon = "🦆", color = Color3.fromRGB(255, 220, 60) },
	Gaston = { title = "Aléatoire", stars = 3, weapon = "Baguette magique & chapeau", icon = "🎩", color = Color3.fromRGB(150, 60, 200) },
	Bob = { title = "Choppeur", stars = 2, weapon = "Glacière & tongs", icon = "❄️", color = Color3.fromRGB(180, 230, 255) },
	Robo = { title = "Anti-projectiles", stars = 2, weapon = "Tuyau flexible & brosse rotative", icon = "🤖", color = Color3.fromRGB(120, 140, 160) },
	Papi = { title = "Zoneur sonore", stars = 2, weapon = "Vinyles tranchants & platine", icon = "🎧", color = Color3.fromRGB(255, 200, 60) },
	Pigeon = { title = "Invocateur", stars = 3, weapon = "Baguette de pain & nuée", icon = "🐦", color = Color3.fromRGB(150, 150, 170) },
	Ventouse = { title = "Mobilité", stars = 2, weapon = "Ventouse géante & clé à molette", icon = "🪠", color = Color3.fromRGB(230, 60, 60) },
}

-- Modes de jeu du menu (voir server/Lobby.lua)
Roster.MODES = {
	{ id = "brawl", name = "Bagarre générale", icon = "💥", text = "4 joueurs, chacun pour soi, 3 minutes" },
	{ id = "duel", name = "Duel", icon = "⚔️", text = "1 contre 1, 3 vies" },
	{ id = "adventure", name = "Aventure", icon = "🗺️", text = "5 combats contre des bots" },
	{ id = "training", name = "Entraînement", icon = "🎯", text = "Le mannequin, sans chrono" },
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

-- R-0B0, l'aspirateur : robot aspirateur rond devenu humanoïde, raide comme un piquet et poli jusqu'au bout des
-- roulettes. Il avale les projectiles adverses (jauge Réservoir, 3 max) et les recrache. Arme sortie de la
-- Caisse Bizarre : tuyau flexible & brosse rotative.
--
-- Format : voir docs/fiche-perso.md et Characters/Gege.lua (clés de coups, poses, links, effets).
-- Mécanique « tank » (server/Mechanics.lua) : les coups kind = "absorb" avalent les projectiles proches et
-- remplissent la jauge Réservoir (décorative : les signatures sont sans limite, plus de meterCost).
-- Style « robot » : angles nets, coudes à 90°, buste droit, la tête tourne par crans.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local METAL = Color3.fromRGB(205, 210, 220)
local STEEL = Color3.fromRGB(150, 158, 170)
local DARK = Color3.fromRGB(55, 60, 70)
local CYAN = Color3.fromRGB(80, 220, 255)
local RED = Color3.fromRGB(255, 70, 60)
local GREEN = Color3.fromRGB(90, 230, 110)
local YELLOW = Color3.fromRGB(255, 200, 50)
local DUST = Color3.fromRGB(160, 140, 115)
local DUST_DARK = Color3.fromRGB(110, 95, 80)

local data = {
	id = "Robo",
	name = "R-0B0, l'aspirateur",
	costume = "Robo",
	style = "robot",

	look = {
		body = {
			head = METAL, upper = METAL, lower = DARK, arms = STEEL, hands = DARK, legs = STEEL, feet = DARK,
			forearms = METAL, shins = METAL,
		},
		cubeHead = 1.25,
		parts = {
			-- tête : dôme, visière lumineuse, antenne à voyant, grille de haut-parleur
			{ "Dome", "Head", "ball", Vector3.new(1.35, 0.8, 1.35), Vector3.new(0, 0.6, 0), Vector3.zero, METAL, "Metal", { reflect = 0.15 } },
			{ "Visiere", "Head", "block", Vector3.new(1.05, 0.32, 0.1), Vector3.new(0, 0.12, -0.64), Vector3.zero, CYAN, "Neon", { neon = true, light = { CYAN, 6, 1 } } },
			{ "Antenne", "Head", "cyl", Vector3.new(0.7, 0.08, 0.08), Vector3.new(0.35, 1.1, 0), Vector3.zero, DARK, "Metal", { axis = "y" } },
			{ "Voyant", "Head", "ball", Vector3.new(0.24, 0.24, 0.24), Vector3.new(0.35, 1.48, 0), Vector3.zero, RED, "Neon", { neon = true } },
			{ "Grille", "Head", "block", Vector3.new(0.6, 0.16, 0.06), Vector3.new(0, -0.35, -0.64), Vector3.zero, DARK, "Metal" },
			-- buste : réservoir transparent plein de poussière, moteur dans le dos
			{ "Reservoir", "UpperTorso", "cyl", Vector3.new(0.3, 1.15, 1.15), Vector3.new(0, 0.1, -0.55), Vector3.zero, Color3.fromRGB(190, 230, 255), "Glass", { axis = "z", transparency = 0.45 } },
			{ "Poussiere", "UpperTorso", "ball", Vector3.new(0.75, 0.55, 0.3), Vector3.new(0, -0.05, -0.55), Vector3.zero, DUST, "Sand" },
			{ "Jauge", "UpperTorso", "block", Vector3.new(0.9, 0.12, 0.06), Vector3.new(0, 0.62, -0.52), Vector3.zero, GREEN, "Neon", { neon = true } },
			{ "Moteur", "UpperTorso", "block", Vector3.new(1.3, 1.2, 0.45), Vector3.new(0, 0, 0.7), Vector3.zero, DARK, "Metal" },
			{ "Ventilo", "UpperTorso", "cyl", Vector3.new(0.1, 0.8, 0.8), Vector3.new(0, 0, 0.95), Vector3.zero, STEEL, "Metal", { axis = "z" } },
			-- bassin : le disque d'aspirateur (pare-chocs) avec son liseré lumineux
			{ "PareChocs", "LowerTorso", "cyl", Vector3.new(0.5, 2.8, 2.8), Vector3.new(0, -0.05, 0), Vector3.zero, Color3.fromRGB(235, 238, 242), "SmoothPlastic", { axis = "y" } },
			{ "Liseret", "LowerTorso", "cyl", Vector3.new(0.12, 2.95, 2.95), Vector3.new(0, -0.32, 0), Vector3.zero, CYAN, "Neon", { axis = "y", neon = true } },
			{ "BoutonMarche", "LowerTorso", "cyl", Vector3.new(0.08, 0.35, 0.35), Vector3.new(0, 0.22, -1.2), Vector3.new(0, 0, 0), GREEN, "Neon", { axis = "y", neon = true } },
			-- bras gauche annelé comme un tuyau, épaulettes boulonnées
			{ "AnnelureHaut", "LeftUpperArm", "cyl", Vector3.new(0.25, 1.15, 1.15), Vector3.new(0, 0.1, 0), Vector3.zero, DARK, "Metal", { axis = "y" } },
			{ "AnnelureBas", "LeftLowerArm", "cyl", Vector3.new(0.25, 1.1, 1.1), Vector3.new(0, 0, 0), Vector3.zero, DARK, "Metal", { axis = "y" } },
			{ "EpauletteD", "RightUpperArm", "ball", Vector3.new(1.2, 0.7, 1.2), Vector3.new(0, 0.5, 0), Vector3.zero, METAL, "Metal" },
			{ "EpauletteG", "LeftUpperArm", "ball", Vector3.new(1.2, 0.7, 1.2), Vector3.new(0, 0.5, 0), Vector3.zero, METAL, "Metal" },
			-- roulettes à la place des talons
			{ "RoueD", "RightFoot", "cyl", Vector3.new(0.45, 0.8, 0.8), Vector3.new(0, -0.15, 0.2), Vector3.zero, DARK, "SmoothPlastic", { axis = "x" } },
			{ "RoueG", "LeftFoot", "cyl", Vector3.new(0.45, 0.8, 0.8), Vector3.new(0, -0.15, 0.2), Vector3.zero, DARK, "SmoothPlastic", { axis = "x" } },
			-- le cordon d'alimentation enroulé dans le dos, prise au bout
			{ "Cordon", "LowerTorso", "cyl", Vector3.new(1.4, 0.12, 0.12), Vector3.new(0.4, -0.6, 0.6), Vector3.new(0, 0, 20), Color3.fromRGB(30, 30, 30), "SmoothPlastic", { axis = "y" } },
			{ "Prise", "LowerTorso", "block", Vector3.new(0.35, 0.3, 0.25), Vector3.new(0.65, -1.3, 0.6), Vector3.zero, Color3.fromRGB(240, 240, 240), "SmoothPlastic" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : tuyau flexible et brosse rotative au bout
			{ name = "PropTuyau", hand = "Right", visible = true, pieces = {
				{ "Raccord", "", "cyl", Vector3.new(0.45, 0.5, 0.5), Vector3.new(0, -0.25, 0), Vector3.zero, STEEL, "Metal", { axis = "y" } },
				{ "Gaine", "", "cyl", Vector3.new(1.7, 0.34, 0.34), Vector3.new(0, -1.25, 0), Vector3.zero, DARK, "Fabric", { axis = "y" } },
				{ "Embout", "", "block", Vector3.new(0.45, 0.35, 0.55), Vector3.new(0, -2.2, 0), Vector3.zero, STEEL, "Metal" },
				{ "Brosse", "", "cyl", Vector3.new(1.5, 0.55, 0.55), Vector3.new(0, -2.55, 0), Vector3.zero, DARK, "SmoothPlastic", { axis = "x" } },
				{ "Poils", "", "block", Vector3.new(1.55, 0.25, 0.3), Vector3.new(0, -2.85, 0), Vector3.zero, YELLOW, "Fabric" },
			} },
			-- rallonge télescopique (tuyau-poing)
			{ name = "PropRallonge", hand = "Right", visible = false, pieces = {
				{ "Tube", "", "cyl", Vector3.new(4.6, 0.3, 0.3), Vector3.new(0, -2.6, 0), Vector3.zero, STEEL, "Metal", { axis = "y", reflect = 0.2 } },
				{ "Poing", "", "ball", Vector3.new(0.9, 0.9, 0.9), Vector3.new(0, -5, 0), Vector3.zero, DARK, "Metal" },
				{ "Poils", "", "block", Vector3.new(1.2, 0.25, 0.3), Vector3.new(0, -5.45, 0), Vector3.zero, YELLOW, "Fabric" },
			} },
			-- le sac à poussière (nuage aveuglant, vidage)
			{ name = "PropSac", hand = "Right", visible = false, pieces = {
				{ "Sac", "", "ball", Vector3.new(1.3, 1.7, 1.1), Vector3.new(0, -1.2, 0), Vector3.zero, Color3.fromRGB(215, 200, 170), "Fabric" },
				{ "Lien", "", "cyl", Vector3.new(0.3, 0.5, 0.5), Vector3.new(0, -0.35, 0), Vector3.zero, DARK, "Fabric", { axis = "y" } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Brosse rotative : petit coup sec, le tuyau part à l'horizontale, la brosse tourne et crache des étincelles
		P_neutral = {
			label = "Brosse rotative", startup = 0.08, active = 0.08, recovery = 0.14,
			damage = 6, hitbox = box(4.5, 3, 3, 0.6), kbBase = 20, kbGrowth = 25, kbAngle = 25,
			windup = { Root = { 0, -12, 0, 0, -0.2, 0.1 }, Waist = { 0, -15, 0 }, RS = { 80, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -4, 12, 0, 0, -0.22, -0.25 }, Waist = { 0, 15, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 90, 0, 0 } },
			follow = { Root = { -4, 14, 0, 0, -0.22, -0.28 }, Waist = { 0, 18, 0 }, RS = { 90, 0, -4 }, RE = { 4, 0, 0 }, RW = { -6, 0, 0 }, LS = { 18, 0, -22 }, LE = { 92, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = YELLOW, dir = "front", at = "hand", time = 0.15, speed = 10, size = 0.4, rate = 80 } },
			hitText = "BZZT !",
		},
		-- Coup de pare-chocs : le bassin pivote d'un cran et le disque d'aspirateur cogne de côté
		P_combo2 = {
			label = "Coup de pare-chocs", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 6, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { 0, -45, 0, 0, -0.25, 0.15 }, Waist = { 0, 20, 0 }, Neck = { 0, 25, 0 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { 0, 35, 0, 0, -0.3, -0.45 }, Waist = { 0, -20, 0 }, Neck = { 0, -15, 0 }, RS = { 20, 0, 40 }, RE = { 90, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 0, 40, 0, 0, -0.3, -0.5 }, Waist = { 0, -24, 0 }, Neck = { 0, -18, 0 }, RS = { 18, 0, 42 }, RE = { 90, 0, 0 }, LS = { 62, 0, -42 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hitText = "BIP BOUM !",
		},
		-- Brosse tourbillon : bras à l'horizontale, il tourne sur son axe comme une hélice
		P_combo3 = {
			label = "Brosse tourbillon", startup = 0.09, active = 0.12, recovery = 0.3,
			damage = 9, hitbox = box(6.5, 3.5, 2.5, 0.5), kbBase = 30, kbGrowth = 60, kbAngle = 45,
			windup = { Root = { 0, -30, 0, 0, -0.25, 0.1 }, Waist = { 0, -25, 0 }, RS = { 90, 0, 60 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -60 }, LE = { 0, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -0.2, -0.2 }, Waist = { 0, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 10, 0, 0, -0.2, -0.25 }, Waist = { 0, 5, 0 }, RS = { 88, 0, 92 }, RE = { 0, 0, 0 }, RW = { -5, 0, 0 }, LS = { 88, 0, -92 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", text = "MODE TURBO", hitText = "VRRRAP !",
		},
		-- Tuyau-poing : la rallonge télescopique jaillit droit devant (très grande allonge, un peu plus lent)
		P_side = {
			label = "Tuyau-poing", startup = 0.12, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(8, 2.5, 5.5, 0.8), kbBase = 22, kbGrowth = 38, kbAngle = 20,
			windup = { Root = { 0, -25, 0, 0, -0.2, 0.3 }, Waist = { 0, -20, 0 }, RS = { 70, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -6, 20, 0, 0, -0.25, -0.3 }, Waist = { 0, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -25 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -6, 22, 0, 0, -0.25, -0.32 }, Waist = { 0, 22, 0 }, Neck = { 0, -12, 0 }, RS = { 90, 0, -4 }, RE = { 0, 0, 0 }, RW = { -4, 0, 0 }, LS = { -12, 0, -26 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			hold = 0.08, prop = "rallonge", trail = "prop", text = "EXTENSION !", hitText = "PLONK !",
		},
		-- → P P : Double extension, la rallonge remonte en diagonale et cueille l'adversaire
		P_side2 = {
			label = "Double extension", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 7, hitbox = box(7, 4, 4.5, 2.2), kbBase = 26, kbGrowth = 45, kbAngle = 55,
			windup = { Root = { 0, 15, 0, 0, -0.35, 0 }, Waist = { 0, 10, 0 }, RS = { 40, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -25 }, LE = { 90, 0, 0 } },
			strike = { Root = { 6, 20, 0, 0, -0.15, -0.25 }, Waist = { 6, 20, 0 }, Neck = { 15, -10, 0 }, RS = { 135, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -30 }, LE = { 90, 0, 0 } },
			follow = { Root = { 8, 22, 0, 0, -0.15, -0.28 }, Waist = { 8, 22, 0 }, Neck = { 18, -10, 0 }, RS = { 140, 0, -4 }, RE = { 0, 0, 0 }, RW = { -5, 0, 0 }, LS = { -22, 0, -30 }, LE = { 90, 0, 0 } },
			hold = 0.06, prop = "rallonge", trail = "prop", hitText = "PLONK PLONK !",
		},
		-- Balai rotatif : accroupi, la brosse balaie le sol d'arrière en avant au ras des chevilles
		P_down = {
			label = "Balai rotatif", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(6, 2, 3, -2), kbBase = 25, kbGrowth = 20, kbAngle = 75,
			windup = { Root = { -6, -25, 0, 0, -0.7, 0.15 }, Waist = { -15, -20, 0 }, Neck = { -10, 20, 0 }, RS = { -10, 0, 45 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -25 }, LE = { 90, 0, 0 } },
			strike = { Root = { -10, 20, 0, 0, -0.8, -0.1 }, Waist = { -22, 25, 0 }, Neck = { -10, -10, 0 }, RS = { 45, 0, -5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -35 }, LE = { 90, 0, 0 } },
			follow = { Root = { -10, 30, 0, 0, -0.8, -0.12 }, Waist = { -22, 35, 0 }, Neck = { -10, -15, 0 }, RS = { 40, 0, -30 }, RE = { 10, 0, 0 }, RW = { -5, 0, 0 }, LS = { 15, 0, -38 }, LE = { 90, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "smoke", color = DUST, dir = "front", at = "feet", time = 0.2, speed = 6, size = 0.8, rate = 60 } },
			hitText = "SHHHRK !",
		},
		-- Aspiration verticale (anti-air) : tuyau pointé au plafond, il aspire ce qui tombe et cueille l'adversaire
		P_up = {
			label = "Aspiration verticale", kind = "absorb", startup = 0.1, active = 0.18, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 5, 0.8, 3.5), kbBase = 28, kbGrowth = 30, kbAngle = 88,
			absorb = { radius = 5, offset = 0.5 },
			windup = { Root = { 0, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 5, 0, 0, 0, 0.12, 0 }, Waist = { 10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 42, 0, -42 }, LE = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			trail = "prop", fx = { { "particles", tex = "smoke", color = DUST, dir = "down", at = "above", time = 0.3, speed = 6, size = 0.6, rate = 60 } },
			hitText = "SLURP !",
		},
		-- Aspi-charge (dash puis P) : lancé sur ses roulettes, buste penché, tuyau en lance
		P_dash = {
			label = "Aspi-charge", startup = 0.08, active = 0.14, recovery = 0.24,
			damage = 8, hitbox = box(5, 3, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -10, -15, 0, 0, -0.35, 0.1 }, Waist = { -5, -10, 0 }, RS = { 60, 0, 15 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -18, 10, 0, 0, -0.4, -0.3 }, Waist = { -5, 10, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -35, 0, -25 }, LE = { 90, 0, 0 } },
			follow = { Root = { -20, 12, 0, 0, -0.42, -0.35 }, Waist = { -6, 12, 0 }, RS = { 93, 0, -3 }, RE = { 0, 0, 0 }, RW = { -4, 0, 0 }, LS = { -38, 0, -25 }, LE = { 90, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "smoke", color = DUST, dir = "up", at = "feet", time = 0.25, speed = 5, size = 0.7, rate = 70 } },
			hitText = "VROUM !",
		},
		-- Brosse tournoyante (P en l'air) : jambes repliées en angle droit, bras en croix, il tourne sur son axe
		P_air = {
			label = "Brosse tournoyante", startup = 0.09, active = 0.14, recovery = 0.18,
			damage = 7, hitbox = box(6, 4, 1, 0), kbBase = 22, kbGrowth = 38, kbAngle = 40,
			windup = { Root = { 0, -30, 0 }, Waist = { 0, -20, 0 }, RS = { 90, 0, 50 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, RH = { 50, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 0, 10, 0 }, Waist = { 0, 5, 0 }, RS = { 90, 0, 92 }, RE = { 0, 0, 0 }, RW = { -5, 0, 0 }, LS = { 90, 0, -92 }, LE = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "VRRR !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Coup de roulette : jambe droite raide comme une barre, la roulette du talon en avant
		K_neutral = {
			label = "Coup de roulette", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.15 }, Waist = { 4, 0, 0 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, RH = { 70, 0, 0 }, RK = { -90, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.12, 0 }, Waist = { 10, 0, 0 }, RS = { -20, 0, 35 }, RE = { 90, 0, 0 }, LS = { 60, 0, -35 }, LE = { 90, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 16, 0, 0, 0, -0.12, 0.05 }, Waist = { 12, 0, 0 }, RS = { -25, 0, 38 }, RE = { 90, 0, 0 }, LS = { 62, 0, -38 }, LE = { 90, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", hitText = "ROULE !",
		},
		-- K K : Double roulette, même mouvement mécanique avec la jambe gauche
		K_combo2 = {
			label = "Double roulette", startup = 0.09, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 6, 15, 0, 0, -0.2, 0.1 }, Waist = { 4, 0, 0 }, RS = { 50, 0, 30 }, RE = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, LH = { 70, 0, 0 }, LK = { -90, 0, 0 }, LA = { 0, 0, 0 } },
			strike = { Root = { 14, 10, 0, 0, -0.12, -0.1 }, Waist = { 8, 0, 0 }, RS = { 60, 0, 35 }, RE = { 90, 0, 0 }, LS = { -20, 0, -35 }, LE = { 90, 0, 0 }, LH = { 95, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 16, 12, 0, 0, -0.12, -0.12 }, Waist = { 10, 0, 0 }, RS = { 62, 0, 38 }, RE = { 90, 0, 0 }, LS = { -25, 0, -38 }, LE = { 90, 0, 0 }, LH = { 98, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "leftFoot", hitText = "ROULE ROULE !",
		},
		-- K K K : Rotation 360°, le bassin tourne comme une tourelle, jambe droite tendue
		K_combo3 = {
			label = "Rotation 360°", startup = 0.1, active = 0.14, recovery = 0.32,
			damage = 12, hitbox = box(6, 3.5, 2.5, 0.5), kbBase = 32, kbGrowth = 80, kbAngle = 40,
			windup = { Root = { 4, -60, 0, 0, -0.25, 0.1 }, Waist = { 0, -30, 0 }, Neck = { 0, 40, 0 }, RS = { 60, 0, 40 }, RE = { 90, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 80 }, RE = { 0, 0, 0 }, LS = { 40, 0, -80 }, LE = { 0, 0, 0 }, RH = { 85, 0, 25 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 22, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 28, 0, 82 }, RE = { 0, 0, 0 }, LS = { 38, 0, -82 }, LE = { 0, 0, 0 }, RH = { 88, 0, 20 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", text = "ROTATION 360°", hitText = "VLANG !",
		},
		-- Pare-chocs : coudes rentrés, il fonce et percute avec tout son châssis
		K_side = {
			label = "Pare-chocs", startup = 0.22, active = 0.14, recovery = 0.34,
			damage = 13, hitbox = box(4.5, 4, 2.5, 0), kbBase = 32, kbGrowth = 85, kbAngle = 28, selfVelocity = Vector2.new(35, 0),
			windup = { Root = { 6, -30, 0, 0, -0.35, 0.3 }, Waist = { 0, -10, 0 }, Neck = { 0, 20, 0 }, RS = { -30, 0, 20 }, RE = { 90, 0, 0 }, LS = { -30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -15, -10, 0, 0, -0.45, -0.5 }, Waist = { -5, 0, 0 }, Neck = { 10, 10, 0 }, RS = { -40, 0, 25 }, RE = { 90, 0, 0 }, LS = { -40, 0, -25 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -17, -12, 0, 0, -0.47, -0.6 }, Waist = { -6, 0, 0 }, Neck = { 12, 10, 0 }, RS = { -42, 0, 26 }, RE = { 90, 0, 0 }, LS = { -42, 0, -26 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { { "particles", tex = "smoke", color = DUST, dir = "up", at = "feet", time = 0.3, speed = 5, size = 0.8, rate = 70 } },
			text = "PARE-CHOCS !", hitText = "BONG !",
		},
		-- Coup de balai : accroupi, il pivote sur la roulette gauche, la jambe droite balaie le sol
		K_down = {
			label = "Coup de balai", startup = 0.18, active = 0.16, recovery = 0.32,
			damage = 11, hitbox = box(7, 2, 0.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 70,
			windup = { Root = { -6, -20, 0, 0, -0.95, 0 }, Waist = { -15, -10, 0 }, RS = { 30, 0, 50 }, RE = { 90, 0, 0 }, LS = { 40, 0, -50 }, LE = { 90, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -1.15, 0 }, Waist = { -18, 0, 0 }, RS = { 10, 0, 60 }, RE = { 20, 0, 0 }, LS = { 20, 0, -60 }, LE = { 20, 0, 0 }, RH = { 75, 0, 15 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -1.1, 0 }, Waist = { -16, 0, 0 }, RS = { 15, 0, 62 }, RE = { 20, 0, 0 }, LS = { 25, 0, -62 }, LE = { 20, 0, 0 }, RH = { 72, 0, 18 }, RK = { -8, 0, 0 }, RA = { -20, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "BALAYÉ !",
		},
		-- Retour à la base : salto arrière en reculant, les deux roulettes passent sous le menton adverse
		K_up = {
			label = "Retour à la base", startup = 0.16, active = 0.16, recovery = 0.3,
			damage = 11, hitbox = box(4.5, 5, 1.5, 2.5), kbBase = 32, kbGrowth = 70, kbAngle = 85, selfVelocity = Vector2.new(-22, 35),
			windup = { Root = { -6, 0, 0, 0, -0.6, 0 }, Waist = { -15, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 25 }, RE = { 90, 0, 0 }, LS = { -20, 0, -25 }, LE = { 90, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, 0.2, 0.3 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -60, 0, 40 }, RE = { 0, 0, 0 }, LS = { -60, 0, -40 }, LE = { 0, 0, 0 }, RH = { 150, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 22, 0, 0, 0, 0.25, 0.35 }, Waist = { 12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -62, 0, 42 }, RE = { 0, 0, 0 }, LS = { -62, 0, -42 }, LE = { 0, 0, 0 }, RH = { 120, 0, 0 }, RK = { -30, 0, 0 }, LH = { 150, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "RETOUR À LA BASE", hitText = "BIP !",
		},
		-- Mode roomba (dash puis K) : il se replie en disque et file au ras du sol en tournant
		K_dash = {
			label = "Mode roomba", startup = 0.1, active = 0.24, recovery = 0.3,
			damage = 10, hitbox = box(5, 2, 1.5, -1.8), kbBase = 30, kbGrowth = 60, kbAngle = 65, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -1.1, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 90, 0, 70 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -70 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -1.1, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 90, 0, 72 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -72 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "prop", text = "MODE ROOMBA", hitText = "VRRROUM !",
		},
		-- Atterrissage capteur (saut K) : genoux pliés puis les deux roulettes plaquées devant, capteurs allumés
		K_air = {
			label = "Atterrissage capteur", startup = 0.18, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.2, -0.8), kbBase = 30, kbGrowth = 70, kbAngle = 30,
			windup = { Root = { -10, 0, 0 }, Waist = { -15, 0, 0 }, RS = { 40, 0, 40 }, RE = { 90, 0, 0 }, LS = { 40, 0, -40 }, LE = { 90, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 25, 0, 0 }, Waist = { 10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 90, 0, 0 }, LS = { -30, 0, -50 }, LE = { 90, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 65, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 28, 0, 0 }, Waist = { 12, 0, 0 }, RS = { -35, 0, 52 }, RE = { 90, 0, 0 }, LS = { -35, 0, -52 }, LE = { 90, 0, 0 }, RH = { 74, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 68, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", fx = { { "ring", color = CYAN, radius = 3, at = "feet" } }, hitText = "CAPTEUR ACTIVÉ !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : Mode souffleur, le tuyau souffle une rafale qui repousse fort (il recule un peu)
		P_air_side = {
			label = "Mode souffleur", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 6, hitbox = box(7, 3.5, 4.5, 0.5), kbBase = 32, kbGrowth = 35, kbAngle = 15, selfVelocity = Vector2.new(-15, 0),
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 80, 0, 0 }, RH = { 70, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 90, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 10 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -30, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { 14, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 3, 0, 0 }, LS = { 88, 0, 10 }, LE = { 28, 0, 0 }, RH = { 15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 5, 0, 0 }, LK = { -35, 0, 0 } },
			shake = true, trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(230, 230, 235), dir = "front", at = "hand", time = 0.25, speed = 18, size = 0.9, rate = 90 } },
			text = "MODE SOUFFLEUR", hitText = "FWOOOSH !",
		},
		-- ↑ P en l'air : Hélice de brosse, le tuyau tourne au-dessus de la tête comme un rotor
		P_air_up = {
			label = "Hélice de brosse", startup = 0.09, active = 0.14, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 30, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 }, RH = { 80, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 6, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 175, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -40 }, LE = { 30, 0, 0 }, RH = { 0, 0, 0 }, RK = { -10, 0, 0 }, LH = { 10, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 8, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 180, 0, 5 }, RE = { 0, 0, 0 }, RW = { -5, 0, 0 }, LS = { -12, 0, -42 }, LE = { 30, 0, 0 }, RH = { 0, 0, 0 }, RK = { -10, 0, 0 }, LH = { 10, 0, 0 }, LK = { -20, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "TCHOP TCHOP !",
		},
		-- ↓ P en l'air : Tuyau plongeant, le tuyau monte tout droit puis s'abat sur le crâne (smash vers le sol)
		P_air_down = {
			label = "Tuyau plongeant", startup = 0.15, active = 0.1, recovery = 0.28,
			damage = 9, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -75,
			windup = { Root = { 12, 0, 0 }, Waist = { 15, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -15, 0, 0 }, Waist = { -25, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 30, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 90, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 20, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { -18, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 10, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -25, 0, -42 }, LE = { 90, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 15, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "prop", hitText = "BLONK !",
		},
		-- → K en l'air : Roulette volante, jambe droite détendue sur le côté, buste rejeté
		K_air_side = {
			label = "Roulette volante", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -10, 30, 0 }, Waist = { -10, 20, 0 }, RS = { 60, 0, 40 }, RE = { 90, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 25, 35, 0 }, Waist = { 5, 10, 0 }, Neck = { -10, -20, 0 }, RS = { -30, 0, 60 }, RE = { 90, 0, 0 }, LS = { 50, 0, -60 }, LE = { 90, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 28, 38, 0 }, Waist = { 6, 10, 0 }, Neck = { -12, -20, 0 }, RS = { -34, 0, 62 }, RE = { 90, 0, 0 }, LS = { 52, 0, -62 }, LE = { 90, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 16, 0, 0 }, LK = { -100, 0, 0 } },
			trail = "rightFoot", hitText = "ROULIBAF !",
		},
		-- ↑ K en l'air : Ciseau capteur, salto arrière les deux jambes raides vers le ciel
		K_air_up = {
			label = "Ciseau capteur", startup = 0.14, active = 0.18, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, RS = { 40, 0, 50 }, RE = { 90, 0, 0 }, LS = { 40, 0, -50 }, LE = { 90, 0, 0 }, RH = { 90, 0, 0 }, RK = { -110, 0, 0 }, LH = { 90, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 0, 0, 0 }, LS = { -40, 0, -60 }, LE = { 0, 0, 0 }, RH = { 150, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 140, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 32, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -42, 0, 62 }, RE = { 0, 0, 0 }, LS = { -42, 0, -62 }, LE = { 0, 0, 0 }, RH = { 155, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 145, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "CLAC-CLAC !",
		},
		-- ↓ K en l'air : Chute capteur, genoux remontés puis jambes raides plantées vers le bas (smash vers le sol)
		K_air_down = {
			label = "Chute capteur", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -55),
			windup = { Root = { -6, 0, 0 }, Waist = { -15, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 40 }, RE = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 0, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 5, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 90, 0, 60 }, RE = { 0, 0, 0 }, LS = { 90, 0, -60 }, LE = { 0, 0, 0 }, RH = { 0, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { 0, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 95, 0, 65 }, RE = { 0, 0, 0 }, LS = { 95, 0, -65 }, LE = { 0, 0, 0 }, RH = { 0, 0, 6 }, RK = { -4, 0, 0 }, RA = { -10, 0, 0 }, LH = { 0, 0, -6 }, LK = { -4, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "ATTERRISSAGE !", hitText = "KLONK !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Aspiration (L) : trou noir frontal ; arc-bouté sur ses roulettes, il avale les projectiles et aspire tout le couloir vers lui
		S_neutral = {
			label = "Aspiration", kind = "absorb", startup = 0.2, active = 0.5, recovery = 0.5,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 24, kbGrowth = 20, kbAngle = 10, pull = true,
			absorb = { radius = 8, offset = 5 },
			windup = { Root = { 6, 0, 0, 0, -0.35, 0.2 }, Waist = { 5, 0, 0 }, RS = { 70, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 25 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			strike = { Root = { 10, 0, 0, 0, -0.45, 0.3 }, Waist = { 8, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 88, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 30 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 12, 0, 0, 0, -0.45, 0.35 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 86, 0, 0 }, RE = { 0, 0, 0 }, RW = { 2, 0, 0 }, LS = { 78, 0, 30 }, LE = { 52, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
			shake = true, wobble = true,
			windupFx = { { "ring", color = CYAN, radius = 3, at = "hand" } },
			fx = { { "ring", color = DARK, radius = 6, at = "front" }, { "beam", color = DUST, length = 14, width = 2.5, at = "hand" }, { "particles", tex = "smoke", color = DUST, dir = "all", at = "front", time = 0.5, speed = 6, size = 0.8, rate = 80 } },
			text = "ASPIRATION", hitText = "SLUUURP !",
		},
		-- Recrachat (→L) : il vise et recrache une boule de poussière compactée qui fonce droit sur l'adversaire, 50 % plus vite qu'à l'aller
		S_side = {
			label = "Recrachat", kind = "projectile", startup = 0.2, active = 0, recovery = 0.5,
			damage = 14, kbBase = 30, kbGrowth = 75, kbAngle = 25,
			projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.6, size = 2.2, color = DUST,
				visual = { shape = "ball", size = 1.8, color = DUST, material = "Sand", spin = 12,
					parts = { { "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0.6, 0.4, 0), DUST_DARK }, { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-0.5, -0.5, 0), STEEL } } } },
			windup = { Root = { -6, 0, 0, 0, -0.25, -0.1 }, Waist = { -10, 0, 0 }, RS = { 80, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 25 }, LE = { 70, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.3, 0.35 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 25 }, LE = { 40, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -0.3, 0.3 }, Waist = { 8, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 5, 0, 0 }, LS = { 88, 0, 25 }, LE = { 38, 0, 0 } },
			shake = true, fx = { { "burst", color = DUST, size = 2.5, at = "hand" }, { "particles", tex = "smoke", color = DUST, dir = "front", at = "hand", time = 0.2, speed = 16, rate = 70 } }, text = "RECRACHAT", hitText = "PTOU !",
		},
		-- Sac à poussière (↓L) : il secoue le sac au-dessus de lui ; le nuage aveuglant roule jusqu'à l'adversaire et reste sur place
		S_down = {
			label = "Sac à poussière", kind = "projectile", startup = 0.22, active = 0, recovery = 0.5,
			damage = 12, kbBase = 12, kbGrowth = 10, kbAngle = 60,
			status = { name = "blinded", duration = 2.5 },
			projectile = { speed = 34, angle = 0, gravity = 0, lifetime = 0.6, size = 7, color = DUST, linger = 2.5, from = "feet",
				visual = { shape = "ball", size = 6, color = DUST, material = "Sand", transparency = 0.45, trail = false } },
			windup = { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 5, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 150, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 120, 0, 0 }, RE = { 10, 0, 0 }, RW = { 40, 0, 0 }, LS = { 115, 0, -5 }, LE = { 20, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.32, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 5 }, RE = { 15, 0, 0 }, RW = { 60, 0, 0 }, LS = { 108, 0, -8 }, LE = { 25, 0, 0 } },
			prop = "sac", hideProp = "tuyau", wobble = true,
			fx = { { "particles", tex = "smoke", color = DUST, dir = "front", at = "feet", time = 1.2, speed = 8, size = 1.6, rate = 90 } },
			text = "VIDAGE DU SAC", hitText = "ATCHOUM !",
		},
		-- Turbo diagonal (↑L, remontée) : il se comprime comme un ressort, le propulseur à poussière s'allume et il part en diagonale, raide
		-- comme une fusée, tuyau et bras tendus devant, roulettes derrière : tout ce qu'il croise est emporté
		S_up = {
			label = "Turbo diagonal", startup = 0.15, active = 0.3, recovery = 0.45,
			damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 45, kbAngle = 80, selfVelocity = Vector2.new(42, 80),
			windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -12, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -20 }, LE = { 0, 0, 0 } },
			strike = { Root = { -45, 0, 0, 0, 0.3, 0 }, Waist = { 0, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -5 }, LE = { 0, 0, 0 }, RH = { -15, 0, 3 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -15, 0, -3 }, LK = { 0, 0, 0 }, LA = { -40, 0, 0 } },
			follow = { Root = { -50, 0, 0, 0, 0.35, 0 }, Waist = { 0, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 180, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -5 }, LE = { 0, 0, 0 }, RH = { -18, 0, 3 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -18, 0, -3 }, LK = { 0, 0, 0 }, LA = { -40, 0, 0 } },
			trail = "prop", fx = { { "burst", color = DUST, size = 3, at = "feet" }, { "particles", tex = "fire", color = YELLOW, dir = "down", at = "feet", time = 0.4, speed = 16, size = 0.9, rate = 110 }, { "ring", color = CYAN, radius = 4, at = "feet" } },
			text = "TURBO !", hitText = "WHOOSH !",
		},
		-- Puissance max (S maintenu) : arc-bouté, jambes écartées, le tuyau aspire tout le couloir d'un coup et avale les tirs (encaisse sans broncher)
		S_hold = {
			label = "Puissance max", kind = "absorb", startup = 0.3, active = 0.6, recovery = 0.6,
			damage = 14, hitbox = box(16, 6, 8, 1), kbBase = 26, kbGrowth = 25, kbAngle = 10, pull = true, armor = true,
			absorb = { radius = 9, offset = 5 },
			windup = { Root = { 0, 0, 0, 0, -0.4, 0.2 }, Waist = { 10, 0, 0 }, RS = { 60, 0, 0 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 }, FR = { 0, 0, 0, 0, 0, 0.2 } },
			strike = { Root = { 14, 0, 0, 0, -0.55, 0.4 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 85, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 28 }, LE = { 45, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 }, FR = { 0, 0, 0, 0, 0, 0.25 } },
			follow = { Root = { 16, 0, 0, 0, -0.55, 0.45 }, Waist = { 14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 84, 0, 0 }, RE = { 0, 0, 0 }, RW = { 3, 0, 0 }, LS = { 79, 0, 28 }, LE = { 46, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 }, FR = { 0, 0, 0, 0, 0, 0.25 } },
			shake = true, wobble = true,
			windupFx = { { "text", text = "PUISSANCE 100 %", color = CYAN } },
			fx = { { "ring", color = DARK, radius = 8, at = "front" }, { "beam", color = DUST, length = 17, width = 3.5, at = "hand" }, { "particles", tex = "smoke", color = DUST, dir = "all", at = "front", time = 0.8, speed = 8, size = 1, rate = 100 }, { "shake", amount = 0.3 } },
			text = "PUISSANCE MAX", hitText = "SHLUUURP !",
		},
		-- Nettoyage programmé (→→L) : buste penché, il file en zigzag et brosse tout le couloir sur son passage
		S_dash = {
			label = "Nettoyage programmé", startup = 0.15, active = 0.3, recovery = 0.5,
			damage = 13, hitbox = box(14, 6, 7, 0.5), kbBase = 28, kbGrowth = 55, kbAngle = 35, selfVelocity = Vector2.new(60, 0), invuln = 0.15,
			windup = { Root = { -15, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -25, 0, 0, 0, -0.5, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 70, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 90, 0, 0 } },
			follow = { Root = { -25, 0, 0, 0, -0.5, -0.35 }, Waist = { -10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 65, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -22, 0, -40 }, LE = { 90, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "particles", tex = "smoke", color = DUST, dir = "up", at = "feet", time = 0.3, speed = 5, size = 0.8, rate = 80 }, { "particles", tex = "spark", color = YELLOW, dir = "front", at = "hand", time = 0.3, speed = 12, size = 0.4, rate = 80 } },
			text = "NETTOYAGE PROGRAMMÉ", hitText = "SHRK SHRK !",
		},
		-- Mode bordure (ESQUIVE puis L) : de profil, au ras du sol, il longe tout le couloir en cognant du pare-chocs et ressort derrière l'adversaire
		S_dodge = {
			label = "Mode bordure", startup = 0.15, active = 0.25, recovery = 0.45,
			damage = 12, hitbox = box(14, 5, 7, 0.5), kbBase = 28, kbGrowth = 55, kbAngle = 115, selfVelocity = Vector2.new(70, 0), invuln = 0.3,
			windup = { Root = { 0, 60, 0, 0, -0.8, 0 }, Waist = { -10, 0, 0 }, Neck = { 0, -40, 0 }, RS = { 30, 0, 40 }, RE = { 90, 0, 0 }, LS = { 30, 0, -40 }, LE = { 90, 0, 0 } },
			strike = { Root = { -10, 90, 0, 0, -1.0, -0.4 }, Waist = { -15, 0, 0 }, Neck = { 0, -60, 0 }, RS = { 10, 0, 80 }, RE = { 0, 0, 0 }, LS = { 10, 0, -80 }, LE = { 0, 0, 0 } },
			follow = { Root = { -10, 95, 0, 0, -1.0, -0.45 }, Waist = { -15, 0, 0 }, Neck = { 0, -65, 0 }, RS = { 8, 0, 82 }, RE = { 0, 0, 0 }, LS = { 8, 0, -82 }, LE = { 0, 0, 0 } },
			trail = "body", fx = { { "particles", tex = "smoke", color = DUST, dir = "up", at = "feet", time = 0.3, speed = 4, size = 0.6, rate = 60 }, { "ring", color = CYAN, radius = 3, at = "root" } },
			text = "MODE BORDURE", hitText = "PAR DERRIÈRE !",
		},
		-- Disque volant (L en l'air) : jambes repliées, bras à l'horizontale, il tourne comme un disque d'aspirateur et fauche tout autour
		S_air = {
			label = "Disque volant", startup = 0.15, active = 0.3, recovery = 0.45,
			damage = 13, hitbox = box(8, 5, 2, 0), kbBase = 28, kbGrowth = 55, kbAngle = 35, selfVelocity = Vector2.new(40, 15),
			windup = { Root = { 0, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { -15, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, RH = { 110, 0, 0 }, RK = { -140, 0, 0 }, LH = { 110, 0, 0 }, LK = { -140, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { -15, 0, 0 }, RS = { 90, 0, 92 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -92 }, LE = { 0, 0, 0 }, RH = { 110, 0, 0 }, RK = { -140, 0, 0 }, LH = { 110, 0, 0 }, LK = { -140, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "prop", fx = { { "ring", color = CYAN, radius = 5, at = "root" } }, text = "DISQUE VOLANT", hitText = "ZING !",
		},
		-- Chute du disque (↓L en l'air) : bras rentrés, raide comme une plaque d'acier, il tombe comme un poids mort et aplatit tout en dessous
		S_air_down = {
			label = "Chute du disque", startup = 0.18, active = 0.4, recovery = 0.5,
			damage = 14, hitbox = box(8, 5, 0, -2.5), kbBase = 30, kbGrowth = 70, kbAngle = -80, selfVelocity = Vector2.new(0, -110), armor = true,
			windup = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 30 }, RE = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 0, 0, 2 }, RE = { 0, 0, 0 }, LS = { 0, 0, -2 }, LE = { 0, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, RA = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 }, LA = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 0, 0, 3 }, RE = { 0, 0, 0 }, LS = { 0, 0, -3 }, LE = { 0, 0, 0 }, RH = { 0, 0, 2 }, RK = { 0, 0, 0 }, RA = { 0, 0, 0 }, LH = { 0, 0, -2 }, LK = { 0, 0, 0 }, LA = { 0, 0, 0 } },
			trail = "body", fx = { { "burst", color = STEEL, size = 3.5, at = "feet" }, { "ring", color = CYAN, radius = 6, at = "feet" }, { "shake", amount = 0.4 } },
			text = "POIDS MORT", hitText = "KLANG !",
		},

		------------------------------------------------------------------ Suites d'enchaînement (voir LINKS en bas)
		-- P puis K : Roulette à piston, la jambe droite se déplie d'un cran, raide, la roulette du talon plantée dans le tibia
		PK_combo = {
			label = "Roulette à piston", startup = 0.07, active = 0.08, recovery = 0.18,
			damage = 7, hitbox = box(5, 3.5, 2.8, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { 8, 0, 0, 0, -0.25, 0.2 }, Waist = { 4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 0, 0, 20 }, RE = { 90, 0, 0 }, LS = { 0, 0, -20 }, LE = { 90, 0, 0 }, RH = { 90, 0, 0 }, RK = { -90, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { 12, 0, 0, 0, -0.2, -0.15 }, Waist = { 6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -30, 0, 25 }, RE = { 90, 0, 0 }, LS = { 30, 0, -25 }, LE = { 90, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
			follow = { Root = { 14, 0, 0, 0, -0.2, -0.18 }, Waist = { 8, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -34, 0, 26 }, RE = { 90, 0, 0 }, LS = { 34, 0, -26 }, LE = { 90, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
			trail = "rightFoot", fx = { { "particles", tex = "spark", color = YELLOW, dir = "front", at = "feet", time = 0.12, speed = 8, size = 0.4, rate = 60 } }, hitText = "TCHAK-BIP !",
		},
		-- K puis P : Moulinet de brosse, le bras fait un tour complet par le haut et la brosse s'abat de face en crachant des étincelles
		KP_combo = {
			label = "Moulinet de brosse", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 2.8, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 40,
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 200, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -25 }, LE = { 90, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.32, -0.35 }, Waist = { -12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 32, 0, -25 }, LE = { 90, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = YELLOW, dir = "front", at = "hand", time = 0.15, speed = 12, size = 0.4, rate = 80 } }, hitText = "VRRRT-PLONK !",
		},
		-- Coup de tête 404 (P P puis →P) : bug ! sa tête fait un tour complet sur elle-même puis cogne l'adversaire, voyant rouge
		P_bug = {
			label = "Coup de tête 404", startup = 0.07, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 2.6, 1), kbBase = 24, kbGrowth = 35, kbAngle = 40,
			windup = { Root = { 6, 0, 0, 0, -0.25, 0.15 }, Waist = { 6, 0, 0 }, Neck = { -10, 180, 0 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -18, 0, 0 }, Neck = { -30, 360, 0 }, RS = { -20, 0, 35 }, RE = { 90, 0, 0 }, LS = { -20, 0, -35 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -16, 0, 0, 0, -0.37, -0.4 }, Waist = { -20, 0, 0 }, Neck = { -34, 360, 0 }, RS = { -24, 0, 36 }, RE = { 90, 0, 0 }, LS = { -24, 0, -36 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
			shake = true, trail = "head", fx = { { "particles", tex = "spark", color = RED, dir = "all", at = "head", time = 0.25, speed = 8, size = 0.4, rate = 70 }, { "text", text = "ERREUR 404", color = RED, at = "head" } },
			text = "BZZT ?", hitText = "BONK.EXE !",
		},
		-- Rebond de pare-chocs (K K puis →K) : comme un robot aspirateur contre un mur, il cogne, recule d'un cran et recogne (2 touches)
		K_bumper = {
			label = "Rebond de pare-chocs", startup = 0.08, active = 0.2, recovery = 0.22,
			damage = 4, hits = 2, hitbox = box(5, 4, 2.6, 0.3), kbBase = 20, kbGrowth = 30, kbAngle = 40, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 0, 0, 0, 0, -0.3, 0.3 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { -30, 0, 20 }, RE = { 90, 0, 0 }, LS = { -30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.4, -0.5 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -40, 0, 25 }, RE = { 90, 0, 0 }, LS = { -40, 0, -25 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 6, 0, 0, 0, -0.35, 0.2 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -30, 0, 20 }, RE = { 90, 0, 0 }, LS = { -30, 0, -20 }, LE = { 90, 0, 0 } },
			wobble = true, trail = "body", fx = { { "text", text = "BIP", color = CYAN, at = "head" }, { "ring", color = CYAN, radius = 2.5, at = "front" } }, hitText = "BONG-BIP-BONG !",
		},
		-- Compactage (finition) : bras en croix, puis les deux bras se referment d'un coup sec comme une presse et éjectent l'adversaire plié en quatre
		K_press = {
			label = "Compactage", startup = 0.1, active = 0.1, recovery = 0.34,
			damage = 12, hitbox = box(5.5, 4.5, 2.8, 0.8), kbBase = 38, kbGrowth = 90, kbAngle = 38,
			windup = { Root = { 4, 0, 0, 0, -0.25, 0.2 }, Waist = { 4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.35, -0.35 }, Waist = { -10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -12, 0, 0, 0, -0.37, -0.4 }, Waist = { -12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 94, 0, -15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, 15 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			trail = "bothHands", fx = { { "burst", color = STEEL, size = 3, at = "front" }, { "text", text = "COMPACTAGE : 100 %", color = CYAN, at = "head" }, { "shake", amount = 0.3 } }, text = "COMPACTAGE.", hitText = "CRRRUNCH !",
		},
		-- Souffle turbo (finition S) : le tuyau passe en soufflerie et éjecte l'adversaire au loin
		S_finish_souffle = {
			label = "Souffle turbo", startup = 0.12, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(7, 4, 4, 0.5), kbBase = 38, kbGrowth = 88, kbAngle = 30,
			windup = { Root = { -6, 0, 0, 0, -0.3, -0.1 }, Waist = { -8, 0, 0 }, RS = { 70, 0, 15 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 25 }, LE = { 80, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.35, 0.3 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 86, 0, 25 }, LE = { 45, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.2 } },
			follow = { Root = { 12, 0, 0, 0, -0.35, 0.35 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 4, 0, 0 }, LS = { 88, 0, 25 }, LE = { 44, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.25 } },
			shake = true, trail = "prop",
			fx = { { "particles", tex = "smoke", color = Color3.fromRGB(230, 230, 235), dir = "front", at = "hand", time = 0.35, speed = 22, size = 1.1, rate = 110 } },
			text = "SOUFFLERIE !", hitText = "FWAAAH !",
		},
		-- Vidange du réservoir (finition S) : trois projectiles avalés recrachés en éventail (coûte 2 du Réservoir)
		S_finish_vidange = {
			label = "Vidange du réservoir", kind = "projectile", startup = 0.12, active = 0, recovery = 0.35,
			damage = 7, kbBase = 34, kbGrowth = 80, kbAngle = 30,
			projectile = { speed = 85, gravity = 0, lifetime = 0.5, size = 1.6, color = DUST, fan = { count = 3, from = -12, to = 22 },
				visual = { shape = "ball", size = 1.3, color = DUST, material = "Sand", spin = 14, parts = { { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0.5, 0.3, 0), DUST_DARK } } } },
			windup = { Root = { -8, 0, 0, 0, -0.3, -0.1 }, Waist = { -12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 25 }, LE = { 80, 0, 0 } },
			strike = { Root = { 12, 0, 0, 0, -0.35, 0.4 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 25 }, LE = { 40, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.35, 0.38 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 108, 0, 0 }, RE = { 0, 0, 0 }, RW = { 6, 0, 0 }, LS = { 92, 0, 25 }, LE = { 38, 0, 0 } },
			shake = true, fx = { { "burst", color = DUST, size = 3, at = "hand" } }, text = "VIDANGE !", hitText = "PTOU PTOU PTOU !",
		},

		------------------------------------------------------------------ Supers
		-- Grand ménage (Y) : bras en croix, il tourne sur lui-même et devient une tornade d'aspiration qui ratisse des deux côtés
		SUPER = {
			label = "Grand ménage !", kind = "absorb", startup = 0.35, active = 1.2, recovery = 0.7,
			damage = 8, hits = 3, hitbox = box(30, 10, 0, 2), kbBase = 20, kbGrowth = 25, kbAngle = 70, pull = true, armor = true,
			absorb = { radius = 12, offset = 0 },
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -15, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 60, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 5, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 6, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 165, 0, 42 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -92 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 1080 }, trail = "prop",
			windupFx = { { "screen", color = CYAN, alpha = 0.25 }, { "text", text = "GRAND MÉNAGE ACTIVÉ", color = CYAN } },
			fx = { { "pillar", color = DUST, height = 14, width = 10, at = "root" }, { "ring", color = DARK, radius = 15, at = "root" }, { "particles", tex = "smoke", color = DUST, dir = "up", at = "root", time = 1.2, speed = 10, size = 1.5, rate = 120 }, { "shake", amount = 0.5 } },
			text = "GRAND MÉNAGE !", hitText = "VROOOOOM !",
		},
		-- Super ↑ : compte à rebours, le propulseur s'allume et il traverse le couloir en diagonale comme une fusée, bras joints devant,
		-- en vrille : tout ce qui est sur la trajectoire part en orbite avec lui
		SUPER_up = {
			label = "Décollage fusée !", startup = 0.35, active = 0.4, recovery = 0.75,
			damage = 24, hitbox = box(14, 8, 7, 2), kbBase = 45, kbGrowth = 95, kbAngle = 80, invuln = 0.3, selfVelocity = Vector2.new(55, 70),
			windup = { Root = { 0, 0, 0, 0, -1.0, 0 }, Waist = { -10, 0, 0 }, Neck = { -35, 0, 0 }, RS = { 0, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -10 }, LE = { 0, 0, 0 } },
			strike = { Root = { -50, 0, 0, 0, 0.4, 0 }, Waist = { 0, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 180, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, 0 }, LE = { 0, 0, 0 }, RH = { -15, 0, 2 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -15, 0, -2 }, LK = { 0, 0, 0 }, LA = { -40, 0, 0 } },
			follow = { Root = { -55, 0, 0, 0, 0.5, 0 }, Waist = { 0, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 182, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 182, 0, 0 }, LE = { 0, 0, 0 }, RH = { -18, 0, 2 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -18, 0, -2 }, LK = { 0, 0, 0 }, LA = { -40, 0, 0 } },
			spin = { axis = "y", degrees = 1080 },
			windupFx = { "super", { "text", text = "DÉCOLLAGE DANS 3… 2… 1…", color = CYAN } }, trail = "prop",
			fx = { { "beam", color = DUST, length = 18, width = 3, at = "root" }, { "particles", tex = "fire", color = YELLOW, dir = "down", at = "feet", time = 0.6, speed = 18, size = 1, rate = 120 }, { "burst", color = DUST, size = 4, at = "feet" }, { "shake", amount = 0.5 } },
			text = "FUSÉE.EXE", hitText = "EN ORBITE !",
		},
		-- Mise à jour (↓Y) : tête basse, il redémarre… puis écarte les bras : une barre de chargement géante traverse l'arène des deux côtés,
		-- qui la touche attend la fin du téléchargement (« en attente »), pendant que R-0B0 ressort avec armure et turbo 3 s
		SUPER_down = {
			label = "Mise à jour !", startup = 0.4, active = 0.2, recovery = 0.7,
			damage = 22, hitbox = box(30, 8, 0, 2), kbBase = 30, kbGrowth = 55, kbAngle = 50,
			status = { name = "waiting", duration = 2 },
			selfEffect = { armor = 3, buff = { "turbo", 3 } },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { -35, 0, 0 }, RS = { 0, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -5 }, LE = { 0, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 172, 0, 32 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, -32 }, LE = { 0, 0, 0 } },
			hold = 0.3, shake = true,
			windupFx = { { "text", text = "TÉLÉCHARGEMENT… 99 %", color = CYAN } },
			fx = { { "ring", color = CYAN, radius = 15, at = "root" }, { "beam", color = CYAN, length = 15, width = 2.2, at = "root" }, { "pillar", color = CYAN, height = 10, width = 3, at = "root" }, { "screen", color = CYAN, alpha = 0.2 }, { "text", text = "VEUILLEZ PATIENTER", color = CYAN, at = "above" } },
			text = "MISE À JOUR TERMINÉE", hitText = "VEUILLEZ PATIENTER…",
		},

		------------------------------------------------------------------ Chope (bouton ✋) et projections
		-- Aspiration du visage : le tuyau part droit devant et vient se coller sur la figure de l'adversaire
		GRAB = {
			label = "Aspiration du visage", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4.5, 3, 2.5, 1),
			windup = { Root = { 0, -10, 0, 0, -0.2, 0.1 }, Waist = { 0, -10, 0 }, RS = { 70, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.25, -0.3 }, Waist = { 0, 10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 90, 0, 0 } },
			follow = { Root = { -6, 12, 0, 0, -0.25, -0.32 }, Waist = { 0, 12, 0 }, RS = { 90, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 62, 0, -10 }, LE = { 90, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = DUST, dir = "all", at = "front", time = 0.3, speed = 3, size = 0.6, rate = 50 } },
			text = "ASPIRATION DU VISAGE", hitText = "SHLOK !",
		},
		-- ✋ puis → : Sac à poussière vidé, il gonfle la victime d'air puis la recrache droit devant
		THROW_fwd = {
			label = "Sac à poussière vidé", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 15,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 1.8, 0.6 }, { 0.32, 4.2, 0.8 } },
			windup = { Root = { -8, 0, 0, 0, -0.3, -0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 80, 0, 0 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 25 }, LE = { 70, 0, 0 } },
			strike = { Root = { 12, 0, 0, 0, -0.3, 0.4 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 25 }, LE = { 40, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.3, 0.38 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 5, 0, 0 }, LS = { 90, 0, 25 }, LE = { 38, 0, 0 } },
			shake = true, fx = { { "burst", color = DUST, size = 3, at = "front" }, { "particles", tex = "smoke", color = DUST, dir = "front", at = "hand", time = 0.4, speed = 16, size = 1.2, rate = 100 } },
			text = "VIDAGE DU SAC", hitText = "PFIOUUU !",
		},
		-- ✋ puis ← : Rejet par l'arrière, le bras tourne d'un cran au-dessus de la tête et rejette la victime derrière
		THROW_back = {
			label = "Rejet par l'arrière", kind = "throw", back = true, startup = 0.38, active = 0.1, recovery = 0.38,
			damage = 11, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 1.2, 3.2 }, { 0.28, -1.0, 3.0 }, { 0.38, -2.6, 0.8 } },
			windup = { Root = { 0, -20, 0, 0, -0.3, 0 }, Waist = { 0, -10, 0 }, RS = { 90, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { 10, 30, 0, 0, -0.25, 0.2 }, Waist = { 10, 20, 0 }, Neck = { 20, 0, 0 }, RS = { 200, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } },
			follow = { Root = { 12, 34, 0, 0, -0.25, 0.25 }, Waist = { 12, 22, 0 }, Neck = { 24, 0, 0 }, RS = { 210, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 18, 0, -32 }, LE = { 90, 0, 0 } },
			trail = "prop", text = "REJET", hitText = "POUBELLE !",
		},
		-- ✋ puis ↑ : Mode souffleur, tuyau pointé au ciel, la victime part au plafond sur un jet d'air
		THROW_up = {
			label = "Mode souffleur", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 1.6, 2 }, { 0.3, 1.2, 5 } },
			windup = { Root = { 0, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, RS = { 120, 0, 0 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -0.2, 0.12 }, Waist = { 10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 28, 0, -32 }, LE = { 90, 0, 0 } },
			shake = true, fx = { { "particles", tex = "smoke", color = Color3.fromRGB(230, 230, 235), dir = "up", at = "hand", time = 0.4, speed = 20, size = 1, rate = 100 } },
			text = "MODE SOUFFLEUR", hitText = "FWOOOSH !",
		},
		-- ✋ puis ↓ : Nettoyage en profondeur, la victime plaquée au sol, il passe et repasse dessus avec la brosse
		THROW_down = {
			label = "Nettoyage en profondeur", kind = "throw", startup = 0.45, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.4, 0.6 }, { 0.12, 2.4, -1.6 }, { 0.45, 2.4, -2.3 } },
			windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.75, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, -30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 90, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.75, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 45, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 32, 0, -40 }, LE = { 90, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "particles", tex = "smoke", color = DUST, dir = "up", at = "front", time = 0.5, speed = 5, size = 0.9, rate = 80 } },
			text = "NETTOYAGE EN PROFONDEUR", hitText = "SHRK SHRK SHRK !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	-- 1er fatal offert, 2e au niveau de maîtrise 5, 3e au niveau 15
	fatals = {
		{
			id = "aspire", label = "Aspiré", sequence = { "forward", "forward", "forward" },
			-- l'adversaire rapetisse, file dans le tuyau et tourne en rond dans le réservoir transparent
			scene = {
				{ "fxAttacker", { "text", text = "Aspiration en cours, veuillez patienter.", color = CYAN } },
				{ "fxAttacker", { "particles", tex = "smoke", color = DUST, dir = "all", at = "front", time = 1.4, speed = 6, size = 1, rate = 100 } },
				{ "text", "NON NON NON !" },
				{ "move", to = "between", time = 0.5 },
				{ "shrink", 0.35, time = 0.5 },
				{ "spawn", at = "attacker", offset = Vector3.new(0, 5, 0), life = 3.4, pieces = {
					{ "Cuve", "", "cyl", Vector3.new(3.2, 2.8, 2.8), Vector3.new(0, 0, 0), Vector3.zero, Color3.fromRGB(190, 230, 255), "Glass", { axis = "y", transparency = 0.55 } },
					{ "Couvercle", "", "cyl", Vector3.new(0.4, 3, 3), Vector3.new(0, 1.8, 0), Vector3.zero, DARK, "Metal", { axis = "y" } },
					{ "Fond", "", "cyl", Vector3.new(0.4, 3, 3), Vector3.new(0, -1.8, 0), Vector3.zero, DARK, "Metal", { axis = "y" } },
					{ "Poussiere", "", "ball", Vector3.new(2.2, 0.8, 2.2), Vector3.new(0, -1.2, 0), Vector3.zero, DUST, "Sand" },
				} },
				{ "move", to = "attacker", offset = Vector3.new(0, 5, 0), time = 0.4 },
				{ "fx", { "particles", tex = "smoke", color = DUST, dir = "all", at = "root", time = 1.4, speed = 3, size = 0.8, rate = 60 } },
				{ "spin", 1440, time = 1.4, axis = "y" },
				{ "fxAttacker", { "text", text = "RÉSERVOIR : 100 %", color = GREEN } },
				{ "wait", 0.8 },
			},
		},
		{
			id = "sac_plein", label = "Sac plein", sequence = { "down", "up", "back" },
			-- transformé en sac à poussière bien rempli, il est vidé dans la poubelle
			scene = {
				{ "text", "PAS LE SAC !" },
				{ "color", Color3.fromRGB(215, 200, 170) },
				{ "material", "Fabric" },
				{ "shrink", 0.5, time = 0.4 },
				{ "spawn", at = "target", offset = Vector3.new(2.5, -1.6, 0), life = 3.5, pieces = {
					{ "Poubelle", "", "cyl", Vector3.new(2.6, 2.2, 2.2), Vector3.new(0, 0, 0), Vector3.zero, Color3.fromRGB(110, 120, 110), "Metal", { axis = "y" } },
					{ "Bord", "", "cyl", Vector3.new(0.2, 2.4, 2.4), Vector3.new(0, 1.3, 0), Vector3.zero, Color3.fromRGB(90, 100, 90), "Metal", { axis = "y" } },
					{ "Couvercle", "", "cyl", Vector3.new(0.2, 2.4, 2.4), Vector3.new(-1.4, 2.2, 0), Vector3.new(0, 0, 70), Color3.fromRGB(90, 100, 90), "Metal", { axis = "y" } },
				} },
				{ "lift", 4, time = 0.4 },
				{ "launch", Vector3.new(2.5, -4.5, 0), time = 0.4 },
				{ "hide" },
				{ "fx", { "burst", color = DUST, size = 4, at = "root" } },
				{ "fx", { "particles", tex = "smoke", color = DUST, dir = "up", at = "root", time = 0.8, speed = 5, size = 1.2, rate = 80 } },
				{ "fxAttacker", { "text", text = "Merci de votre confiance.", color = CYAN } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "erreur_404", label = "Erreur 404", sequence = { "back", "down", "forward" },
			-- il scanne l'adversaire… écran bleu, adversaire introuvable : il ne reste que ses chaussures
			scene = {
				{ "fxAttacker", { "text", text = "Analyse de la cible…", color = CYAN } },
				{ "fxAttacker", { "beam", color = CYAN, length = 8, width = 0.6, at = "head" } },
				{ "wait", 0.6 },
				{ "fx", { "screen", color = Color3.fromRGB(40, 60, 255), alpha = 0.35 } },
				{ "color", Color3.fromRGB(60, 90, 255) },
				{ "text", "ERREUR 404" },
				{ "wait", 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.75, 0), life = 4, pieces = {
					{ "ChaussureG", "", "block", Vector3.new(0.8, 0.5, 1.4), Vector3.new(-0.5, 0, -0.1), Vector3.zero, Color3.fromRGB(240, 240, 240), "SmoothPlastic" },
					{ "ChaussureD", "", "block", Vector3.new(0.8, 0.5, 1.4), Vector3.new(0.5, 0, 0.1), Vector3.zero, Color3.fromRGB(240, 240, 240), "SmoothPlastic" },
					{ "SemelleG", "", "block", Vector3.new(0.85, 0.15, 1.45), Vector3.new(-0.5, -0.3, -0.1), Vector3.zero, RED, "SmoothPlastic" },
					{ "SemelleD", "", "block", Vector3.new(0.85, 0.15, 1.45), Vector3.new(0.5, -0.3, 0.1), Vector3.zero, RED, "SmoothPlastic" },
				} },
				{ "hide" },
				{ "fx", { "symbols", symbols = { "?", "404", "…" }, count = 5, color = CYAN, radius = 3 } },
				{ "fxAttacker", { "text", text = "Adversaire introuvable.", color = CYAN } },
				{ "wait", 1.3 },
			},
		},
	},

	-- Mécanique : Réservoir (3 projectiles avalés au plus), voir server/Mechanics.lua (« tank »)
	passive = { kind = "tank", name = "Réservoir", icon = "🌀", max = 3, color = CYAN },

	-- Recharge : la prise sort du sol, il se branche et attend sans bouger, raide, la tête qui tourne par crans ;
	-- une batterie s'affiche au-dessus de lui
	charge = {
		label = "Recharge en cours",
		loop = 1.6,
		lockWrist = true,
		color = GREEN,
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.12, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 0, 0, 6 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -6 }, LE = { 90, 0, 0 } } },
			{ 0.4, { Root = { 0, 0, 0, 0, -0.12, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 25, 0 }, RS = { 0, 0, 6 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -6 }, LE = { 90, 0, 0 } } },
			{ 0.8, { Root = { 0, 0, 0, 0, -0.17, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 0, 0, 6 }, RE = { 95, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -6 }, LE = { 95, 0, 0 } } },
			{ 1.2, { Root = { 0, 0, 0, 0, -0.12, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, -25, 0 }, RS = { 0, 0, 6 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -6 }, LE = { 90, 0, 0 } } },
			{ 1.6, { Root = { 0, 0, 0, 0, -0.12, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 0, 0, 6 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -6 }, LE = { 90, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "pillar", color = Color3.fromRGB(240, 240, 240), height = 1.5, width = 0.5, at = "front" } },
			{ 0.1, { "symbols", symbols = { "🔋", "⚡" }, color = GREEN, count = 3, radius = 2 } },
			{ 0.9, { "text", text = "Recharge en cours, merci de patienter", color = CYAN, scale = 0.6 } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- Auto-dépoussiérage : il se brosse l'épaule gauche avec son propre tuyau
		{ duration = 1.8, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 0, 20, 0 }, RS = { 110, 0, -35 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 } } },
			{ 0.7, { Neck = { 0, 20, 0 }, RS = { 120, 0, -45 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 } } },
			{ 1.0, { Neck = { 0, 20, 0 }, RS = { 110, 0, -35 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 } } },
			{ 1.3, { Neck = { 0, 20, 0 }, RS = { 120, 0, -45 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 } } },
			{ 1.8, {} },
		} },
		-- Contrôle des roulettes : il lève le pied droit et inspecte sa roue
		{ duration = 1.7, keys = {
			{ 0, {} },
			{ 0.5, { Waist = { -10, 0, 0 }, Neck = { -30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 } } },
			{ 1.2, { Waist = { -10, 0, 0 }, Neck = { -30, 10, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, RA = { 20, 0, 0 } } },
			{ 1.7, {} },
		} },
		-- Mise en veille : la tête tombe, les bras pendent… puis il se rallume d'un coup
		{ duration = 2, keys = {
			{ 0, {} },
			{ 0.6, { Root = { 0, 0, 0, 0, -0.25, 0 }, Waist = { -10, 0, 0 }, Neck = { -35, 0, 0 }, RS = { 0, 0, 4 }, RE = { 0, 0, 0 }, LS = { 0, 0, -4 }, LE = { 0, 0, 0 } } },
			{ 1.4, { Root = { 0, 0, 0, 0, -0.27, 0 }, Waist = { -10, 0, 0 }, Neck = { -38, 0, 0 }, RS = { 0, 0, 4 }, RE = { 0, 0, 0 }, LS = { 0, 0, -4 }, LE = { 0, 0, 0 } } },
			{ 1.55, { Root = { 0, 0, 0, 0, -0.1, 0 }, Neck = { 15, 0, 0 } } },
			{ 2, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : bras tendu, le tuyau collé au visage de la victime, la main gauche cale le tuyau
data.grabHold = {
	Root = { 6, 0, 0, 0, -0.25, 0.15 },
	Waist = { 6, 0, 0 },
	Neck = { 0, 0, 0 },
	RS = { 88, 0, 0 },
	RE = { 5, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 70, 0, 20 },
	LE = { 70, 0, 0 },
}

-- Retour après une chute : il se pose éteint sur son socle de charge, bip de démarrage, les voyants clignotent,
-- il regarde à gauche et à droite puis fait un tour complet sur lui-même (« Nettoyage en cours »)
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Socle", "base", "block", Vector3.new(5, 1, 3.2), Vector3.new(0, -0.5, 0), Vector3.zero, DARK, "Metal" },
		{ "Plaque", "", "cyl", Vector3.new(0.12, 3.2, 3.2), Vector3.new(0, 0.02, 0), Vector3.zero, CYAN, "Neon", { axis = "y", neon = true } },
		{ "Borne", "", "block", Vector3.new(0.8, 3, 0.8), Vector3.new(-2.1, 1.5, -0.9), Vector3.zero, METAL, "Metal" },
		{ "Ecran", "", "block", Vector3.new(0.6, 0.5, 0.1), Vector3.new(-2.1, 2.3, -0.45), Vector3.zero, GREEN, "Neon", { neon = true } },
		{ "VoyantRouge", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(1.5, -0.5, 1.62), Vector3.zero, RED, "Neon", { neon = true } },
		{ "VoyantVert", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(1.95, -0.5, 1.62), Vector3.zero, GREEN, "Neon", { neon = true } },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -0.55, 0 }, Waist = { -15, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 0, 0, 5 }, RE = { 0, 0, 0 }, LS = { 0, 0, -5 }, LE = { 0, 0, 0 } } },
		{ 0.45, { Root = { 0, 0, 0, 0, -0.55, 0 }, Waist = { -15, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 0, 0, 5 }, RE = { 0, 0, 0 }, LS = { 0, 0, -5 }, LE = { 0, 0, 0 } } },
		{ 0.65, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 0, 0, 6 }, RE = { 90, 0, 0 }, LS = { 0, 0, -6 }, LE = { 90, 0, 0 } } },
		{ 0.8, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 30, 0 }, RS = { 0, 0, 6 }, RE = { 90, 0, 0 }, LS = { 0, 0, -6 }, LE = { 90, 0, 0 } } },
		{ 0.95, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, -30, 0 }, RS = { 0, 0, 6 }, RE = { 90, 0, 0 }, LS = { 0, 0, -6 }, LE = { 90, 0, 0 } } },
		{ 1.05, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 } } },
		{ 1.45, { Root = { 0, 360, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 } } },
		{ 1.451, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.5, { "text", text = "BIP !", color = GREEN } },
		{ 0.6, { "ring", color = CYAN, radius = 3, at = "feet" } },
		{ 1.05, { "text", text = "Nettoyage en cours", color = CYAN } },
		{ 1.1, { "particles", tex = "smoke", color = DUST, dir = "up", at = "feet", time = 0.35, speed = 4, size = 0.6, rate = 60 } },
	},
}

-- Arbre d'enchaînements. Lecture : après le coup de gauche, le bouton (avec la direction s'il y en a une) lance
-- le coup de droite. Les chaînes finissent sur S : Souffle turbo (éjection) ou Vidange (si le Réservoir est plein).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P… : brosse, pare-chocs, tourbillon, bug 404 (P P P K : compactage, finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side", S = "S_finish_souffle" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", fwd_P = "P_bug", S = "S_finish_souffle" }, -- P P
	P_combo3 = { K = "K_press", P = "P_bug", S = "S_finish_vidange" }, -- P P P
	P_bug = { P = "P_combo3", K = "K_bumper", S = "S_finish_souffle" }, -- P P →P (coup de tête 404)
	PK_combo = { P = "KP_combo", K = "K_bumper", S = "S_finish_souffle" }, -- P K
	KP_combo = { P = "P_combo3", K = "K_press", S = "S_finish_vidange" }, -- K P / P K P
	-- K… : roulettes, pare-chocs, presse (K K K K et K K →K K : compactage)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_souffle" },
	K_combo2 = { K = "K_combo3", P = "P_bug", fwd_K = "K_bumper", S = "S_finish_souffle" }, -- K K
	K_combo3 = { K = "K_press", S = "S_finish_vidange" }, -- K K K
	K_bumper = { K = "K_press", P = "P_combo3", S = "S_finish_vidange" }, -- K K →K (rebond)
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_vidange" }, -- → P
	P_side2 = { P = "P_bug", K = "K_bumper", S = "S_finish_souffle" }, -- → P P
	P_down = { P = "P_up", K = "K_down", S = "S_finish_souffle" }, -- ↓ P
	P_up = { K = "K_up", P = "P_bug", S = "S_finish_vidange" }, -- ↑ P
	K_side = { P = "KP_combo", K = "K_bumper", S = "S_finish_souffle" }, -- → K
	K_down = { P = "P_up", K = "K_combo3", S = "S_finish_souffle" }, -- ↓ K
	K_up = airAfterK(), -- ↑ K (il décolle en reculant)
	P_dash = { P = "P_combo2", K = "K_side", S = "S_finish_souffle" }, -- dash P
	K_dash = { P = "P_up", K = "K_bumper", S = "S_finish_vidange" }, -- dash K
	-- en l'air ; ↓ P et ↓ K (smash vers le sol) sont des finitions sans suite
	P_air = airAfterP(),
	P_air_side = airAfterP(),
	P_air_up = airAfterP(),
	K_air = airAfterK(),
	K_air_side = airAfterK(),
	K_air_up = airAfterK(),
}
for key, links in pairs(LINKS) do
	data.moves[key].links = links
end

return data

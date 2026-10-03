-- Bernard du Guichet : fonctionnaire blasé, contrôleur qui colle de la paperasse et fige ses adversaires.
-- Arme sortie de la Caisse Bizarre : tampon géant (main droite) & dossiers (main gauche, ponctuels).
--
-- Même format que Gege.lua (voir l'en-tête de Gege.lua et docs/fiche-perso.md).
-- Bernard s'ennuie : gestes amples mais sans hâte, startups un peu plus longs, coups qui tamponnent fort.
-- Le tampon géant pend à la main droite ; la gauche sort le mug, l'agrafeuse, le classeur, le trombone,
-- la chaise de bureau ou les dossiers selon le coup.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(235, 195, 170)
local BEIGE = Color3.fromRGB(196, 178, 138)
local BEIGE_DARK = Color3.fromRGB(160, 140, 100)
local SHIRT = Color3.fromRGB(240, 240, 235)
local TIE = Color3.fromRGB(120, 60, 40)
local HAIR = Color3.fromRGB(150, 150, 150)
local INK = Color3.fromRGB(200, 30, 40)
local PAPER = Color3.fromRGB(245, 240, 225)
local WOOD = Color3.fromRGB(120, 80, 45)
local BLACK = Color3.fromRGB(30, 30, 35)
local GREY = Color3.fromRGB(110, 110, 120)
local POSTIT = Color3.fromRGB(255, 235, 90)
local MUG = Color3.fromRGB(235, 235, 240)
local FOLDER = Color3.fromRGB(230, 190, 90)
local OFFICE_GREEN = Color3.fromRGB(70, 120, 90)

-- Avion en papier (projectile) : fuselage, ailes et pointe
local PLANE = { shape = "block", size = 0.5, color = PAPER, parts = {
	{ "block", Vector3.new(1.6, 0.06, 1.2), Vector3.new(-0.2, 0.15, 0), PAPER },
	{ "block", Vector3.new(0.5, 0.3, 0.06), Vector3.new(0.7, 0, 0), PAPER },
	{ "block", Vector3.new(0.3, 0.07, 0.3), Vector3.new(-0.3, 0.2, 0), INK },
} }

local data = {
	id = "Bernard",
	name = "Bernard du Guichet",
	costume = "Bernard",
	style = "bored",

	-- Costume : costume beige, chemise et cravate marron, lunettes en demi-lune, couronne de cheveux gris,
	-- moustache, manchettes de lustrine, badge et stylo derrière l'oreille
	look = {
		body = {
			head = SKIN, upper = BEIGE, lower = BEIGE, arms = BEIGE, hands = SKIN, legs = BEIGE_DARK, feet = BLACK,
		},
		cubeHead = 1.25,
		parts = {
			{ "Couronne", "Head", "block", Vector3.new(1.32, 0.45, 1.0), Vector3.new(0, 0.2, 0.2), Vector3.new(0, 0, 0), HAIR, "Fabric" },
			{ "Meche", "Head", "block", Vector3.new(0.9, 0.08, 0.15), Vector3.new(0.05, 0.65, -0.2), Vector3.new(0, 0, -5), HAIR, "Fabric" },
			{ "VerreD", "Head", "block", Vector3.new(0.42, 0.18, 0.06), Vector3.new(0.27, -0.02, -0.68), Vector3.new(0, 0, 0), Color3.fromRGB(200, 230, 255), "Glass", { transparency = 0.25 } },
			{ "VerreG", "Head", "block", Vector3.new(0.42, 0.18, 0.06), Vector3.new(-0.27, -0.02, -0.68), Vector3.new(0, 0, 0), Color3.fromRGB(200, 230, 255), "Glass", { transparency = 0.25 } },
			{ "Monture", "Head", "block", Vector3.new(1.05, 0.04, 0.05), Vector3.new(0, 0.07, -0.69), Vector3.new(0, 0, 0), Color3.fromRGB(150, 110, 40), "Metal" },
			{ "Nez", "Head", "ball", Vector3.new(0.3, 0.4, 0.35), Vector3.new(0, -0.12, -0.7), Vector3.new(0, 0, 0), Color3.fromRGB(225, 170, 150) },
			{ "Moustache", "Head", "block", Vector3.new(0.75, 0.15, 0.1), Vector3.new(0, -0.35, -0.66), Vector3.new(0, 0, 0), HAIR, "Fabric" },
			{ "Stylo", "Head", "cyl", Vector3.new(0.8, 0.08, 0.08), Vector3.new(0.66, 0.1, 0), Vector3.new(0, 0, 0), Color3.fromRGB(30, 60, 180), "SmoothPlastic", { axis = "z" } },
			{ "ColD", "UpperTorso", "wedge", Vector3.new(0.1, 0.35, 0.4), Vector3.new(0.18, 0.65, -0.52), Vector3.new(0, 0, -30), SHIRT },
			{ "ColG", "UpperTorso", "wedge", Vector3.new(0.1, 0.35, 0.4), Vector3.new(-0.18, 0.65, -0.52), Vector3.new(0, 0, 30), SHIRT },
			{ "Chemise", "UpperTorso", "block", Vector3.new(0.6, 1.2, 0.05), Vector3.new(0, 0.15, -0.51), Vector3.new(0, 0, 0), SHIRT },
			{ "Cravate", "UpperTorso", "block", Vector3.new(0.25, 1.1, 0.06), Vector3.new(0, 0.1, -0.55), Vector3.new(0, 0, 0), TIE },
			{ "Noeud", "UpperTorso", "block", Vector3.new(0.3, 0.22, 0.1), Vector3.new(0, 0.65, -0.56), Vector3.new(0, 0, 0), TIE },
			{ "Badge", "UpperTorso", "block", Vector3.new(0.45, 0.3, 0.05), Vector3.new(-0.6, 0.35, -0.53), Vector3.new(0, 0, 0), PAPER },
			{ "Pochette", "UpperTorso", "block", Vector3.new(0.12, 0.35, 0.06), Vector3.new(0.6, 0.45, -0.53), Vector3.new(0, 0, 8), INK },
			{ "ManchetteD", "RightLowerArm", "block", Vector3.new(0.65, 0.9, 0.65), Vector3.new(0, -0.1, 0), Vector3.new(0, 0, 0), BLACK, "Fabric" },
			{ "ManchetteG", "LeftLowerArm", "block", Vector3.new(0.65, 0.9, 0.65), Vector3.new(0, -0.1, 0), Vector3.new(0, 0, 0), BLACK, "Fabric" },
			{ "Ceinture", "LowerTorso", "block", Vector3.new(2.05, 0.2, 1.05), Vector3.new(0, 0.25, 0), Vector3.new(0, 0, 0), BLACK },
			{ "Bedaine", "UpperTorso", "ball", Vector3.new(1.6, 1.0, 0.5), Vector3.new(0, -0.45, -0.35), Vector3.new(0, 0, 0), BEIGE },
		},
		props = {
			-- L'arme (Caisse Bizarre) : le tampon géant, tenu par le pommeau
			{ name = "PropTampon", hand = "Right", visible = true, pieces = {
				{ "Pommeau", "", "ball", Vector3.new(0.6, 0.5, 0.6), Vector3.new(0, 0.1, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
				{ "Manche", "", "cyl", Vector3.new(1.0, 0.35, 0.35), Vector3.new(0, -0.45, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
				{ "Socle", "", "block", Vector3.new(2, 0.6, 1.3), Vector3.new(0, -1.2, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
				{ "Encreur", "", "block", Vector3.new(1.9, 0.2, 1.2), Vector3.new(0, -1.6, 0), Vector3.new(0, 0, 0), INK },
			} },
			-- Objets ponctuels (prop = "…" dans les coups), main gauche
			{ name = "PropMug", hand = "Left", visible = false, pieces = {
				{ "Tasse", "", "cyl", Vector3.new(0.8, 0.65, 0.65), Vector3.new(0, -0.35, -0.2), Vector3.new(0, 0, 0), MUG },
				{ "Anse", "", "block", Vector3.new(0.12, 0.45, 0.25), Vector3.new(0, -0.35, 0.18), Vector3.new(0, 0, 0), MUG },
				{ "Cafe", "", "cyl", Vector3.new(0.05, 0.55, 0.55), Vector3.new(0, 0.06, -0.2), Vector3.new(0, 0, 0), Color3.fromRGB(80, 50, 30) },
				{ "Slogan", "", "block", Vector3.new(0.5, 0.25, 0.05), Vector3.new(0, -0.35, -0.53), Vector3.new(0, 0, 0), INK },
			} },
			{ name = "PropAgrafeuse", hand = "Left", visible = false, pieces = {
				{ "Corps", "", "block", Vector3.new(0.4, 0.35, 1.6), Vector3.new(0, -0.3, -0.4), Vector3.new(0, 0, 0), BLACK, "Metal" },
				{ "Machoire", "", "block", Vector3.new(0.42, 0.15, 1.6), Vector3.new(0, -0.6, -0.4), Vector3.new(0, 0, 0), GREY, "Metal" },
			} },
			{ name = "PropClasseur", hand = "Left", visible = false, pieces = {
				{ "Couverture", "", "block", Vector3.new(0.5, 2.6, 2), Vector3.new(0, -1.2, -0.3), Vector3.new(0, 0, 0), OFFICE_GREEN },
				{ "Etiquette", "", "block", Vector3.new(0.52, 0.8, 0.5), Vector3.new(0, -1.2, 0.5), Vector3.new(0, 0, 0), PAPER },
				{ "Anneau", "", "cyl", Vector3.new(0.6, 0.3, 0.3), Vector3.new(0, -0.3, -0.3), Vector3.new(0, 0, 0), GREY, "Metal", { axis = "x" } },
			} },
			{ name = "PropTrombone", hand = "Left", visible = false, pieces = {
				{ "BrinA", "", "cyl", Vector3.new(3, 0.12, 0.12), Vector3.new(0, -1.5, -0.12), Vector3.new(0, 0, 0), Color3.fromRGB(200, 205, 215), "Metal" },
				{ "BrinB", "", "cyl", Vector3.new(2.4, 0.12, 0.12), Vector3.new(0, -1.3, 0.12), Vector3.new(0, 0, 0), Color3.fromRGB(200, 205, 215), "Metal" },
				{ "Boucle", "", "cyl", Vector3.new(0.12, 0.4, 0.4), Vector3.new(0, -3, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 205, 215), "Metal", { axis = "x" } },
			} },
			{ name = "PropChaise", hand = "Left", visible = false, pieces = {
				{ "Dossier", "", "block", Vector3.new(1.6, 1.4, 0.25), Vector3.new(0, -0.6, 0.3), Vector3.new(0, 0, 0), BLACK, "Fabric" },
				{ "Assise", "", "block", Vector3.new(1.6, 0.25, 1.6), Vector3.new(0, -1.4, -0.4), Vector3.new(0, 0, 0), BLACK, "Fabric" },
				{ "Pied", "", "cyl", Vector3.new(1.1, 0.2, 0.2), Vector3.new(0, -2.0, -0.4), Vector3.new(0, 0, 0), GREY, "Metal" },
				{ "Etoile", "", "block", Vector3.new(1.8, 0.15, 0.3), Vector3.new(0, -2.55, -0.4), Vector3.new(0, 0, 0), GREY, "Metal" },
				{ "Roulette", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0.85, -2.7, -0.4), Vector3.new(0, 0, 0), BLACK },
				{ "Roulette2", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(-0.85, -2.7, -0.4), Vector3.new(0, 0, 0), BLACK },
			} },
			{ name = "PropDossiers", hand = "Left", visible = false, pieces = {
				{ "Pile", "", "block", Vector3.new(1.8, 1.4, 1.3), Vector3.new(0, -0.6, -0.6), Vector3.new(0, 0, 0), FOLDER },
				{ "Feuilles", "", "block", Vector3.new(1.7, 0.2, 1.25), Vector3.new(0.1, -0.1, -0.6), Vector3.new(0, 8, 0), PAPER },
				{ "Elastique", "", "block", Vector3.new(0.12, 1.45, 1.35), Vector3.new(0.4, -0.6, -0.6), Vector3.new(0, 0, 0), INK },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de mug : crochet du gauche avec le mug « Vivement vendredi », sans renverser une goutte
		P_neutral = {
			label = "Coup de mug", startup = 0.08, active = 0.08, recovery = 0.16,
			damage = 6, hitbox = box(4, 3, 2.5, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 25,
			windup = { Root = { 2, 22, 0, 0, -0.15, 0.1 }, Waist = { 4, 26, 0 }, Neck = { -4, -15, 0 }, RS = { 20, 0, 20 }, RE = { 50, 0, 0 }, LS = { 70, 0, -70 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, -18, 0, 0, -0.2, -0.25 }, Waist = { -6, -26, 0 }, Neck = { 0, 12, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 92, 0, -5 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -7, -22, 0, 0, -0.2, -0.28 }, Waist = { -7, -32, 0 }, Neck = { 0, 16, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 88, 0, 18 }, LE = { 75, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "mug", trail = "leftHand", hitText = "SLURP-PAF !",
		},
		-- Classeur claqué : il lève le classeur à deux mains et le rabat lourdement vers l'avant
		P_side = {
			label = "Classeur claqué", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(5, 3.5, 3, 0.5), kbBase = 26, kbGrowth = 42, kbAngle = 20, selfVelocity = Vector2.new(15, 0),
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 10 }, RE = { 60, 0, 0 }, LS = { 160, 0, -10 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.3, -0.4 }, Waist = { -22, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, -10 }, RE = { 20, 0, 0 }, LS = { 85, 0, 10 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -14, 0, 0, 0, -0.32, -0.45 }, Waist = { -26, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, -10 }, RE = { 25, 0, 0 }, LS = { 70, 0, 10 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "classeur", fx = { { "particles", tex = "smoke", color = PAPER, dir = "front", at = "front", time = 0.2, speed = 6 } }, text = "CLASSÉ !", hitText = "CLAC !",
		},
		-- Trombone piquant : accroupi, il pique les pieds avec un trombone géant déplié
		P_down = {
			label = "Trombone piquant", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 6, hitbox = box(5, 1.6, 3, -2.1), kbBase = 22, kbGrowth = 22, kbAngle = 70,
			windup = { Root = { -6, -20, 0, 0, -0.7, 0.15 }, Waist = { -12, -20, 0 }, Neck = { 6, 15, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 30, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 15, 0, 0, -0.8, -0.2 }, Waist = { -18, 18, 0 }, Neck = { 10, -10, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 55, 0, 5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -13, 18, 0, 0, -0.8, -0.24 }, Waist = { -19, 20, 0 }, Neck = { 10, -12, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 50, 0, 8 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "trombone", hitText = "PIQUÉ !",
		},
		-- « Suivant ! » (anti-air) : il relève le mug d'un grand geste vers le plafond en appelant le suivant
		P_up = {
			label = "« Suivant ! »", startup = 0.1, active = 0.12, recovery = 0.22,
			damage = 7, hitbox = box(4, 5, 1, 3.5), kbBase = 26, kbGrowth = 32, kbAngle = 85,
			windup = { Root = { -6, 10, 0, 0, -0.5, 0.05 }, Waist = { -14, 10, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 }, LS = { -20, 0, -15 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, -10, 0, 0, 0.2, 0 }, Waist = { 14, -14, 0 }, Neck = { 28, 0, 0 }, RS = { 15, 0, 30 }, RE = { 50, 0, 0 }, LS = { 168, 0, 0 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, -12, 0, 0, 0.25, 0 }, Waist = { 16, -16, 0 }, Neck = { 32, 0, 0 }, RS = { 15, 0, 30 }, RE = { 50, 0, 0 }, LS = { 176, 0, -6 }, LE = { 12, 0, 0 }, LW = { -10, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "mug", trail = "leftHand", text = "SUIVANT !", hitText = "AU SUIVANT !",
		},
		-- Tampon aérien : en l'air, il lève le tampon et l'abat en avant et vers le bas
		P_air = {
			label = "Tampon aérien", startup = 0.1, active = 0.12, recovery = 0.18,
			damage = 8, hitbox = box(4, 4, 1.8, -1), kbBase = 22, kbGrowth = 38, kbAngle = -30,
			windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -40, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 40, 0, 5 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -28, 0, -48 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -35, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "prop", fx = { { "burst", color = INK, size = 2 } }, hitText = "CHTONK !",
		},
		-- Ruée de 17 h (dash puis P) : c'est l'heure de la sortie, il fonce épaule en avant vers la porte
		P_dash = {
			label = "Ruée de 17 h", startup = 0.08, active = 0.15, recovery = 0.25,
			damage = 8, hitbox = box(4, 4, 2, 0.5), kbBase = 28, kbGrowth = 52, kbAngle = 25, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -8, -20, 0, 0, -0.25, 0.1 }, Waist = { -6, -10, 0 }, Neck = { 10, 15, 0 }, RS = { -20, 0, 30 }, RE = { 40, 0, 0 }, LS = { 50, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { -22, -45, 0, 0, -0.35, -0.25 }, Waist = { -10, -15, 0 }, Neck = { 0, 40, 0 }, RS = { -30, 0, 35 }, RE = { 30, 0, 0 }, LS = { 60, 0, 20 }, LE = { 125, 0, 0 } },
			follow = { Root = { -24, -50, 0, 0, -0.38, -0.3 }, Waist = { -12, -18, 0 }, Neck = { 0, 45, 0 }, RS = { -38, 0, 38 }, RE = { 30, 0, 0 }, LS = { 62, 0, 20 }, LE = { 125, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 5 } }, text = "17 H, J'Y VAIS !", hitText = "POUSSEZ-VOUS !",
		},

		-- Suites d'enchaînement (voir LINKS) : P P, P P P…
		-- P P : Coup d'agrafeuse, il agrafe l'adversaire d'un revers du gauche
		P_combo2 = {
			label = "Coup d'agrafeuse", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(4, 3, 2.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { -4, -20, 0, 0, -0.2, -0.2 }, Waist = { -6, -30, 0 }, Neck = { 0, 15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 70, 0, 40 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, 15, 0, 0, -0.22, -0.28 }, Waist = { -8, 22, 0 }, Neck = { 0, -12, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 90, 0, -45 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -6, 20, 0, 0, -0.22, -0.3 }, Waist = { -8, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 86, 0, -65 }, LE = { 25, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "agrafeuse", trail = "leftHand", hitText = "CLAC-CLAC !",
		},
		-- P P P : Coup de tampon, il lève le tampon bien haut et l'abat sur le crâne : « TAMPONNÉ »
		P_combo3 = {
			label = "Coup de tampon", startup = 0.15, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 2.5, 1), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 6, -8, 0, 0, -0.05, 0.25 }, Waist = { 12, -10, 0 }, Neck = { 14, 0, 0 }, RS = { 190, 0, 15 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -14, 8, 0, 0, -0.45, -0.4 }, Waist = { -30, 10, 0 }, Neck = { -4, 0, 0 }, RS = { 75, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -35 }, LE = { 60, 0, 0 } },
			follow = { Root = { -18, 10, 0, 0, -0.55, -0.45 }, Waist = { -36, 12, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 5 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -28, 0, -40 }, LE = { 60, 0, 0 } },
			hold = 0.08, trail = "prop", fx = { { "burst", color = INK, size = 3 }, { "text", text = "TAMPONNÉ", color = INK } }, hitText = "CHTONK !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Pied de chaise : il donne un coup de pied comme s'il était encore assis sur sa chaise de bureau
		K_neutral = {
			label = "Pied de chaise", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 3, 3, -0.3), kbBase = 30, kbGrowth = 72, kbAngle = 30,
			windup = { Root = { 10, 0, 0, 0, -0.5, 0.2 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, RH = { 90, 0, 0 }, RK = { -95, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { 18, 0, 0, 0, -0.55, 0 }, Waist = { 12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, RH = { 92, 0, 0 }, RK = { -2, 0, 0 }, RA = { 25, 0, 0 } },
			follow = { Root = { 20, 0, 0, 0, -0.55, -0.05 }, Waist = { 14, 0, 0 }, Neck = { -2, 0, 0 }, RS = { 18, 0, 42 }, RE = { 60, 0, 0 }, LS = { 18, 0, -42 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
			trail = "rightFoot", text = "*SOUPIR*", hitText = "BONK !",
		},
		-- Coup de pied agrafeuse : genou monté, puis la jambe claque vers l'avant comme une agrafeuse
		K_side = {
			label = "Coup de pied agrafeuse", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 3, 3, 0), kbBase = 32, kbGrowth = 75, kbAngle = 28, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { 6, -10, 0, 0, -0.15, 0.2 }, Waist = { 6, -8, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 35 }, RE = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 }, RH = { 110, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { -6, 5, 0, 0, -0.2, -0.3 }, Waist = { -8, 5, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 50 }, RE = { 30, 0, 0 }, LS = { 50, 0, -50 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { -8, 6, 0, 0, -0.2, -0.35 }, Waist = { -10, 6, 0 }, Neck = { -8, 0, 0 }, RS = { 52, 0, 55 }, RE = { 30, 0, 0 }, LS = { 52, 0, -55 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", text = "CLAC !", hitText = "AGRAFÉ !",
		},
		-- Pied de bureau : coup de pied raide et bas dans le tibia, sans même se lever
		K_down = {
			label = "Pied de bureau", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 1.8, 3, -1.8), kbBase = 28, kbGrowth = 60, kbAngle = 60,
			windup = { Root = { -4, -15, 0, 0, -0.6, 0.15 }, Waist = { -10, -10, 0 }, Neck = { 10, 10, 0 }, RS = { 30, 0, 35 }, RE = { 60, 0, 0 }, LS = { 30, 0, -35 }, LE = { 60, 0, 0 }, RH = { -20, 0, 10 }, RK = { -70, 0, 0 } },
			strike = { Root = { -8, 15, 0, 0, -0.75, -0.15 }, Waist = { -16, 12, 0 }, Neck = { 12, -8, 0 }, RS = { 10, 0, 45 }, RE = { 40, 0, 0 }, LS = { 60, 0, -30 }, LE = { 50, 0, 0 }, RH = { 55, 0, 6 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -9, 18, 0, 0, -0.75, -0.18 }, Waist = { -17, 14, 0 }, Neck = { 12, -10, 0 }, RS = { 8, 0, 46 }, RE = { 40, 0, 0 }, LS = { 62, 0, -30 }, LE = { 50, 0, 0 }, RH = { 58, 0, 2 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- Recul en chaise de bureau (anti-air) : il recule assis comme sur sa chaise et lance la jambe au plafond
		K_up = {
			label = "Recul en chaise de bureau", startup = 0.18, active = 0.14, recovery = 0.3,
			damage = 11, hitbox = box(4, 5, 1, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 85, selfVelocity = Vector2.new(-18, 0),
			windup = { Root = { 8, 0, 0, 0, -0.7, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { 80, 0, 0 }, RK = { -90, 0, 0 } },
			strike = { Root = { 25, 0, 0, 0, -0.6, 0.3 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { -30, 0, 40 }, RE = { 20, 0, 0 }, LS = { -30, 0, -40 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 28, 0, 0, 0, -0.6, 0.35 }, Waist = { 12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { -35, 0, 42 }, RE = { 20, 0, 0 }, LS = { -35, 0, -42 }, LE = { 20, 0, 0 }, RH = { 160, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(210, 210, 210), dir = "up", at = "feet", time = 0.25, speed = 5 } }, text = "GRIIIN…", hitText = "POC !",
		},
		-- Double semelle réglementaire : en l'air, genoux à la poitrine puis les deux semelles devant
		K_air = {
			label = "Double semelle réglementaire", startup = 0.18, active = 0.14, recovery = 0.26,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -130, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 22, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -35, 0, 50 }, RE = { 20, 0, 0 }, LS = { -35, 0, -50 }, LE = { 20, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 80, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 26, 0, 0 }, Waist = { 22, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -42, 0, 55 }, RE = { 20, 0, 0 }, LS = { -42, 0, -55 }, LE = { 20, 0, 0 }, RH = { 94, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 86, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", hitText = "RÉGLEMENTAIRE !",
		},
		-- Glissade sur parquet ciré (dash puis K) : il glisse sur le dos, mocassins en avant
		K_dash = {
			label = "Glissade sur parquet ciré", startup = 0.1, active = 0.25, recovery = 0.32,
			damage = 11, hitbox = box(6, 2, 3, -1.8), kbBase = 30, kbGrowth = 62, kbAngle = 45, selfVelocity = Vector2.new(48, 0),
			windup = { Root = { -8, 0, 0, 0, -0.55, 0 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 40 }, RE = { 30, 0, 0 }, LS = { 50, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 48, 0, 0, 0, -1.5, 0 }, Waist = { -25, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 150, 0, 50 }, RE = { 10, 0, 0 }, LS = { 150, 0, -50 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 75, 0, 0 }, LK = { -15, 0, 0 } },
			follow = { Root = { 54, 0, 3, 0, -1.55, 0 }, Waist = { -28, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 160, 0, 60 }, RE = { 20, 0, 0 }, LS = { 140, 0, -62 }, LE = { 25, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
			trail = "bothFeet", fx = { { "particles", tex = "spark", color = Color3.fromRGB(240, 220, 160), dir = "up", at = "feet", time = 0.3, speed = 5 } }, text = "OUPS, C'EST CIRÉ…", hitText = "SCHLIIIP !",
		},

		-- Suites d'enchaînement : K K, K K K
		-- K K : Talon administratif, demi-tour réglementaire sur le pied gauche, talon droit tendu
		K_combo2 = {
			label = "Talon administratif", startup = 0.15, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(5, 3, 3, 0.5), kbBase = 28, kbGrowth = 48, kbAngle = 30,
			windup = { Root = { 4, -40, 0, 0, -0.15, 0.1 }, Waist = { 4, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 40, 0, 55 }, RE = { 40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 50, 0, 0 }, RH = { 55, 0, 40 }, RK = { -105, 0, 0 } },
			strike = { Root = { 12, 50, 0, 0, -0.1, 0 }, Waist = { 10, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 30, 0, 70 }, RE = { 30, 0, 0 }, LS = { 70, 0, -60 }, LE = { 40, 0, 0 }, RH = { 85, 0, 55 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { 14, 68, 0, 0, -0.1, 0 }, Waist = { 12, 36, 0 }, Neck = { 0, -26, 0 }, RS = { 25, 0, 75 }, RE = { 30, 0, 0 }, LS = { 72, 0, -62 }, LE = { 40, 0, 0 }, RH = { 80, 0, 40 }, RK = { -8, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", hitText = "VLAN !",
		},
		-- K K K : Coup de pied de fin de service, grand coup de pied haut qui expédie l'adversaire (fait décoller)
		K_combo3 = {
			label = "Coup de pied de fin de service", startup = 0.18, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(4.5, 4.5, 2.5, 1.5), kbBase = 34, kbGrowth = 80, kbAngle = 72,
			windup = { Root = { -8, 0, 0, 0, -0.4, 0.15 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -110, 0, 0 } },
			strike = { Root = { 22, 0, 0, 0, -0.15, -0.2 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -30, 0, 65 }, RE = { 15, 0, 0 }, LS = { -30, 0, -65 }, LE = { 15, 0, 0 }, RH = { 140, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 26, 0, 0, 0, -0.15, -0.22 }, Waist = { 14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { -38, 0, 70 }, RE = { 15, 0, 0 }, LS = { -38, 0, -70 }, LE = { 15, 0, 0 }, RH = { 150, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", text = "LE SERVICE EST FERMÉ !", hitText = "BAM !",
		},
		-- P puis K : Genou syndical, petit coup de genou en se rajustant la cravate
		PK_combo = {
			label = "Genou syndical", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4, 3, 2.3, 0.3), kbBase = 22, kbGrowth = 30, kbAngle = 40,
			windup = { Root = { 4, -6, 0, 0, -0.2, 0.1 }, Waist = { 4, -6, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 90, 0, 20 }, LE = { 140, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, 0, -0.3 }, Waist = { -8, 4, 0 }, Neck = { -10, 0, 0 }, RS = { -10, 0, 40 }, RE = { 50, 0, 0 }, LS = { 95, 0, 25 }, LE = { 145, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -11, 6, 0, 0, 0.02, -0.32 }, Waist = { -9, 4, 0 }, Neck = { -10, 0, 0 }, RS = { -12, 0, 42 }, RE = { 50, 0, 0 }, LS = { 95, 0, 25 }, LE = { 145, 0, 0 }, RH = { 104, 0, 0 }, RK = { -122, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightLeg", hitText = "GNOC !",
		},
		-- K puis P : Coup de dossier, il frappe avec une pile de dossiers tenue du bras gauche
		KP_combo = {
			label = "Coup de dossier", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 7, hitbox = box(4.5, 3, 2.5, 0.6), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, 25, 0, 0, -0.2, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 0, -15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 70, 0, -70 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.25, -0.3 }, Waist = { -8, -32, 0 }, Neck = { 0, 15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 95, 0, -5 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -9, -26, 0, 0, -0.25, -0.33 }, Waist = { -9, -40, 0 }, Neck = { 0, 20, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 90, 0, 20 }, LE = { 35, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "dossiers", trail = "leftHand", fx = { { "particles", tex = "smoke", color = PAPER, dir = "all", at = "lhand", time = 0.2, speed = 6 } }, hitText = "PAPERASSE !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : « Suivant ! », il tend le tampon à plat devant lui et repousse l'adversaire
		P_air_side = {
			label = "« Suivant ! » (aérien)", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 3, 0.3), kbBase = 34, kbGrowth = 35, kbAngle = 10,
			windup = { Root = { -6, -25, 0 }, Waist = { -6, -28, 0 }, Neck = { 0, 20, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 8, 18, 0 }, Waist = { -4, 22, 0 }, Neck = { 0, -12, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -55 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 50, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 10, 22, 0 }, Waist = { -4, 26, 0 }, Neck = { 0, -15, 0 }, RS = { 98, 0, -8 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 28, 0, -58 }, LE = { 30, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 45, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "prop", text = "SUIVANT !", hitText = "AU SUIVANT !",
		},
		-- ↑ P en l'air : Tampon au plafond, il tamponne l'air au-dessus de sa tête : « APPROUVÉ »
		P_air_up = {
			label = "Tampon au plafond", startup = 0.1, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 42, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 85, 0, 0 }, RK = { -115, 0, 0 }, LH = { 80, 0, 0 }, LK = { -115, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			follow = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 8 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -26, 0, -50 }, LE = { 20, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			trail = "prop", fx = { { "text", text = "APPROUVÉ", color = Color3.fromRGB(40, 160, 60), at = "above" } }, hitText = "CHTONK !",
		},
		-- ↓ P en l'air : Pied de chaise de bureau, il brandit sa chaise à roulettes et l'abat pieds en bas
		P_air_down = {
			label = "Pied de chaise de bureau", startup = 0.16, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78,
			windup = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, -10 }, RE = { 40, 0, 0 }, LS = { 190, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -18, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 45, 0, -10 }, RE = { 0, 0, 0 }, LS = { 30, 0, 10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 30, 0, -10 }, RE = { 5, 0, 0 }, LS = { 15, 0, 10 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			prop = "chaise", text = "ASSIS !", hitText = "KLONK !",
		},
		-- → K en l'air : Au service d'à côté, coup de pied latéral qui envoie voir ailleurs
		K_air_side = {
			label = "Au service d'à côté", startup = 0.15, active = 0.12, recovery = 0.26,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 30,
			windup = { Root = { -14, 20, 0 }, Waist = { -16, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 50, 0, 45 }, RE = { 70, 0, 0 }, LS = { 70, 0, -30 }, LE = { 80, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 28, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, -10, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 65, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 32, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, -10, 0 }, RS = { -38, 0, 65 }, RE = { 20, 0, 0 }, LS = { 45, 0, -75 }, LE = { 30, 0, 0 }, RH = { 68, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", text = "VOYEZ À CÔTÉ !", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Retourné de guichet, salto arrière poussif, les mocassins passent au-dessus de la tête
		K_air_up = {
			label = "Retourné de guichet", startup = 0.15, active = 0.2, recovery = 0.26,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "rightFoot", text = "HOP… OUF.", hitText = "POC !",
		},
		-- ↓ K en l'air : Pause écrasée, il tombe les deux pieds joints comme sur le bouton de la machine à café
		K_air_down = {
			label = "Pause écrasée", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 170, 0, 50 }, RE = { 10, 0, 0 }, LS = { 170, 0, -50 }, LE = { 10, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "PAUSE !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Avion en papier : il plie un formulaire en avion et le lance ; l'avion vole mollement vers l'adversaire
		S_neutral = {
			label = "Avion en papier", kind = "projectile", energyCost = 20, startup = 0.16, active = 0, recovery = 0.3,
			damage = 7, kbBase = 18, kbGrowth = 30, kbAngle = 20,
			projectile = { speed = 40, angle = 5, gravity = 0, lifetime = 1.4, size = 1.6, homing = 0.25, color = PAPER, visual = PLANE },
			windup = { Root = { 0, -15, 0, 0, -0.15, 0.15 }, Waist = { 0, -18, 0 }, Neck = { 6, 15, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 120, 0, 30 }, LE = { 110, 0, 0 } },
			strike = { Root = { -6, 12, 0, 0, -0.2, -0.15 }, Waist = { -6, 16, 0 }, Neck = { 0, -10, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 100, 0, -5 }, LE = { 5, 0, 0 } },
			follow = { Root = { -6, 16, 0, 0, -0.2, -0.18 }, Waist = { -6, 20, 0 }, Neck = { 0, -12, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 90, 0, -15 }, LE = { 10, 0, 0 } },
			text = "VEUILLEZ REMPLIR CECI.", hitText = "FORMULAIRE COLLÉ !",
		},
		-- Tampon « REFUSÉ » : il charge un grand coup de tampon à deux mains et renverse l'adversaire
		S_side = {
			label = "Tampon « REFUSÉ »", energyCost = 30, startup = 0.26, active = 0.12, recovery = 0.38,
			damage = 15, hitbox = box(5.5, 4, 3, 0.5), kbBase = 38, kbGrowth = 80, kbAngle = 25, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 8, -10, 0, 0, -0.15, 0.3 }, Waist = { 14, -12, 0 }, Neck = { 16, 0, 0 }, RS = { 195, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, 0 }, LE = { 60, 0, 0 } },
			strike = { Root = { -18, 8, 0, 0, -0.5, -0.5 }, Waist = { -30, 10, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 15 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -20, 10, 0, 0, -0.55, -0.55 }, Waist = { -34, 12, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, -5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 65, 0, 15 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			hold = 0.12, shake = true, trail = "prop", fx = { { "burst", color = INK, size = 4 }, { "text", text = "REFUSÉ", color = INK, scale = 1.3 }, { "shake", amount = 0.4 } },
			text = "DOSSIER…", hitText = "REFUSÉ !",
		},
		-- File d'attente : un figurant en carton se place devant lui et bloque le prochain projectile
		S_down = {
			label = "File d'attente", kind = "wall", energyCost = 25, startup = 0.2, active = 0.1, recovery = 0.3,
			damage = 0,
			wall = { size = Vector3.new(1.5, 6.5, 6), offset = 4, lifetime = 6, max = 2, absorbs = true, solid = false, color = GREY,
				visual = { shape = "block", size = 1.6, color = GREY, trail = false, parts = {
					{ "block", Vector3.new(1.8, 3, 1), Vector3.new(0, -0.6, 0), GREY },
					{ "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 1.8, 0), Color3.fromRGB(150, 150, 160) },
					{ "block", Vector3.new(0.6, 0.4, 0.1), Vector3.new(0.3, 0.2, -0.55), PAPER },
				} } },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -4, 0, 0, 0, -0.15, 0 }, Waist = { -4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 90, 0, -30 }, LE = { 5, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.15, 0 }, Waist = { -4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 92, 0, -32 }, LE = { 5, 0, 0 } },
			text = "PRENEZ UN TICKET ET PATIENTEZ.",
		},
		-- Pause café (après une esquive) : il s'arrête et sirote son mug ; il récupère un peu, mais il est sans défense
		S_dodge = {
			label = "Pause café", kind = "self", energyCost = 30, startup = 0.2, active = 0, recovery = 0.8,
			damage = 0, selfEffect = { heal = 6 },
			windup = { Root = { 2, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 90, 0, 20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, -0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 130, 0, 25 }, LE = { 140, 0, 0 }, LW = { -30, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -0.05, 0 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 138, 0, 25 }, LE = { 138, 0, 0 }, LW = { -40, 0, 0 } },
			hold = 0.3, prop = "mug", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(240, 230, 220), dir = "up", at = "lhand", time = 0.8, speed = 3 }, { "symbols", symbols = { "☕" }, count = 1, radius = 1 } },
			text = "PAUSE CAFÉ.",
		},
		-- Pile de dossiers (remontée, gratuite) : une pile de dossiers jaillit sous lui, il monte assis dessus
		S_up = {
			label = "Pile de dossiers", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 7, hitbox = box(5, 6, 0.5, 0.5), kbBase = 30, kbGrowth = 40, kbAngle = 85, selfVelocity = Vector2.new(5, 85),
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 30, 0, 30 }, RE = { 40, 0, 0 }, LS = { 30, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.3, 0 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 40 }, RE = { 70, 0, 0 }, LS = { 20, 0, -40 }, LE = { 70, 0, 0 }, RH = { 90, 0, 0 }, RK = { -90, 0, 0 }, LH = { 90, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -0.3, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 18, 0, 42 }, RE = { 75, 0, 0 }, LS = { 18, 0, -42 }, LE = { 75, 0, 0 }, RH = { 92, 0, 0 }, RK = { -92, 0, 0 }, LH = { 92, 0, 0 }, LK = { -92, 0, 0 } },
			fx = { { "pillar", color = FOLDER, height = 10, width = 2.5, neon = false } }, text = "*SOUPIR*", hitText = "CLASSÉ EN HAUT !",
		},
		-- Ticket numéroté (S maintenu) : il distribue un ticket ; à l'appel de son numéro, l'adversaire se fige
		-- (le moteur ne sait pas différer un statut : le ticket touché fige tout de suite)
		S_hold = {
			label = "Ticket numéroté", kind = "projectile", energyCost = 30, startup = 0.22, active = 0, recovery = 0.32,
			damage = 5, kbBase = 6, kbGrowth = 8, kbAngle = 20, status = { name = "stunned", duration = 1.5 },
			projectile = { speed = 35, angle = 0, gravity = 0, lifetime = 1.2, size = 1.6, color = Color3.fromRGB(255, 200, 220),
				visual = { shape = "block", size = 0.9, color = Color3.fromRGB(255, 200, 220), text = "42", textColor = BLACK } },
			windup = { Root = { 0, -10, 0, 0, -0.15, 0.1 }, Waist = { 0, -12, 0 }, Neck = { 10, 10, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 60, 0, 10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.2, -0.1 }, Waist = { -4, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 90, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { -4, 12, 0, 0, -0.2, -0.12 }, Waist = { -4, 14, 0 }, Neck = { 0, -10, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 88, 0, -12 }, LE = { 12, 0, 0 } },
			hold = 0.1, text = "LE NUMÉRO 42…", hitText = "C'EST VOUS !",
		},
		-- Glissade en chaise à roulettes (→→S) : assis sur sa chaise, il traverse l'arène à reculons… puis de face
		S_dash = {
			label = "Glissade en chaise à roulettes", energyCost = 25, startup = 0.1, active = 0.35, recovery = 0.32,
			damage = 10, hitbox = box(5, 3, 2.5, -0.3), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(60, 0),
			windup = { Root = { 6, 0, 0, 0, -0.6, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 0, 0, -10 }, LE = { 10, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.9, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 30, 0, 0 }, LS = { -5, 0, -12 }, LE = { 5, 0, 0 }, RH = { 85, 0, 0 }, RK = { -40, 0, 0 }, LH = { 85, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.9, 0 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 72, 0, 22 }, RE = { 30, 0, 0 }, LS = { -5, 0, -12 }, LE = { 5, 0, 0 }, RH = { 88, 0, 0 }, RK = { -35, 0, 0 }, LH = { 88, 0, 0 }, LK = { -35, 0, 0 } },
			prop = "chaise", trail = "body", fx = { { "particles", tex = "spark", color = Color3.fromRGB(240, 220, 160), dir = "up", at = "feet", time = 0.4, speed = 5 } },
			text = "GRIIIIIN…", hitText = "BOUM !",
		},
		-- Pluie de Post-it (S en l'air) : il secoue un bloc de Post-it, qui pleuvent devant lui
		S_air = {
			label = "Pluie de Post-it", kind = "projectile", energyCost = 20, startup = 0.14, active = 0, recovery = 0.3,
			damage = 3, kbBase = 14, kbGrowth = 20, kbAngle = 50,
			projectile = { speed = 45, gravity = 0, lifetime = 0.5, size = 1.3, color = POSTIT, visual = { shape = "block", size = 0.8, color = POSTIT, spin = 6 },
				rain = { count = 6, spread = 5, ahead = 6, height = 12, gap = 0.08 } },
			windup = { Root = { -4, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 150, 0, -10 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 165, 0, -25 }, LE = { 10, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 160, 0, 5 }, LE = { 10, 0, 0 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 25, 0, 0 }, LK = { -65, 0, 0 } },
			shake = true, text = "N'OUBLIEZ PAS…", hitText = "COLLÉ !",
		},
		-- Plongeon de dossier (↓S en l'air) : bras chargés d'archives, il se laisse tomber de tout son poids
		S_air_down = {
			label = "Plongeon de dossier", energyCost = 25, startup = 0.12, active = 0.35, recovery = 0.32,
			damage = 12, hitbox = box(5, 4, 0.8, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, -20 }, RE = { 60, 0, 0 }, LS = { 120, 0, 20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 75, 0, -20 }, RE = { 60, 0, 0 }, LS = { 75, 0, 20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 72, 0, -22 }, RE = { 62, 0, 0 }, LS = { 72, 0, 22 }, LE = { 62, 0, 0 }, LW = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -30, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
			prop = "dossiers", trail = "body", fx = { { "toss", shape = "flat", color = PAPER, size = 0.8, count = 6, speed = 16 }, { "ring", color = FOLDER, radius = 4, at = "feet" } },
			text = "ARCHIVES !", hitText = "BLAM !",
		},
		-- Agrafage en règle (finition d'enchaînement) : trois coups d'agrafeuse rapides, chacun colle un formulaire
		S_finish_agrafe = {
			label = "Agrafage en règle", energyCost = 20, startup = 0.12, active = 0.24, recovery = 0.3,
			damage = 4, hitbox = box(4.5, 3, 2.6, 0.6), hits = 3, kbBase = 26, kbGrowth = 45, kbAngle = 35,
			windup = { Root = { -4, 20, 0, 0, -0.2, 0.1 }, Waist = { -4, 24, 0 }, Neck = { 0, -15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 80, 0, -50 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -10, 0, 0, -0.25, -0.25 }, Waist = { -8, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 95, 0, 0 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -8, -12, 0, 0, -0.25, -0.28 }, Waist = { -8, -16, 0 }, Neck = { 0, 12, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 92, 0, 5 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			wobble = true, prop = "agrafeuse", trail = "leftHand", text = "EN TROIS EXEMPLAIRES !", hitText = "CLAC CLAC CLAC !",
		},

		------------------------------------------------------------------ Supers
		-- Grève générale : il croise les bras, sort sa pancarte imaginaire… et tout le monde se fige, sauf lui
		SUPER = {
			label = "Grève générale !", superCost = 100, startup = 0.45, active = 0.2, recovery = 0.5,
			damage = 6, hitbox = box(80, 50, 0, 10), kbBase = 8, kbGrowth = 8, kbAngle = 60,
			status = { name = "statue", duration = 2.5 },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -40 }, RE = { 110, 0, 0 }, LS = { 60, 0, 40 }, LE = { 110, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, LS = { 175, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 178, 0, 14 }, RE = { 10, 0, 0 }, LS = { 178, 0, -14 }, LE = { 10, 0, 0 } },
			hold = 0.5, windupFx = { { "screen", color = Color3.fromRGB(150, 150, 160), alpha = 0.35 } },
			fx = { { "symbols", symbols = { "🪧", "✊", "GRÈVE !" }, count = 8, radius = 6 }, { "shake", amount = 0.3 } },
			text = "GRÈVE GÉNÉRALE !", hitText = "TOUT EST FERMÉ !",
		},
		-- Formulaire Cerfa 12-B : il plaque un formulaire interminable sur l'adversaire ; selon qu'il est bien rempli
		-- ou non, le résultat change (le mini-jeu de saisie n'existe pas dans le moteur : variantes au hasard)
		SUPER_down = {
			label = "Formulaire Cerfa 12-B", superCost = 100, startup = 0.4, active = 0.15, recovery = 0.5,
			damage = 18, hitbox = box(7, 6, 3.5, 1), kbBase = 35, kbGrowth = 70, kbAngle = 35,
			variants = {
				{ label = "Cerfa presque rempli", damage = 12, kbBase = 30, kbGrowth = 45, hitText = "IL MANQUE UNE SIGNATURE…" },
				{ label = "Cerfa en triple exemplaire", damage = 18, status = { name = "waiting", duration = 2 }, hitText = "EN TRIPLE EXEMPLAIRE !" },
				{ label = "Cerfa refusé", damage = 26, kbBase = 45, kbGrowth = 90, hitText = "DOSSIER REFUSÉ !!" },
			},
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 15 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, 30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.4, -0.45 }, Waist = { -24, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 85, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -16, 0, 0, 0, -0.42, -0.5 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, -5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 85, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			hold = 0.2, prop = "dossiers", windupFx = { { "screen", color = PAPER, alpha = 0.3 }, { "symbols", symbols = { "📋", "✍️", "📎" }, count = 6, radius = 4 } },
			fx = { { "burst", color = INK, size = 4 }, { "toss", shape = "flat", color = PAPER, size = 1, count = 8, speed = 20 } },
			text = "FORMULAIRE CERFA 12-B !", hitText = "TAMPONNÉ !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise administrative : il attrape l'adversaire par le col en soupirant longuement
		GRAB = {
			label = "Prise administrative", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.38,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 110, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 90, 0, 10 }, LE = { 30, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.18, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 85, 0, 15 }, LE = { 45, 0, 0 } },
			text = "*SOUPIR*… PAPIERS, S'IL VOUS PLAÎT.",
		},
		-- ✋ puis → : Dossier refusé, « il manque un justificatif » : coup de tampon qui l'expédie au bout de l'arène
		THROW_fwd = {
			label = "Dossier refusé", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.32,
			damage = 9, kbBase = 44, kbGrowth = 58, kbAngle = 12,
			carry = { { 0, 2.4, 0.6 }, { 0.2, 2.0, 0.4 }, { 0.34, 4.0, 0.3 } },
			windup = { Root = { 4, -15, 0, 0, -0.15, 0.25 }, Waist = { 8, -20, 0 }, Neck = { 10, 10, 0 }, RS = { 185, 0, 15 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 15 }, LE = { 45, 0, 0 } },
			strike = { Root = { -14, 15, 0, 0, -0.35, -0.45 }, Waist = { -22, 18, 0 }, Neck = { -4, 0, 0 }, RS = { 90, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -16, 18, 0, 0, -0.38, -0.5 }, Waist = { -24, 20, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -32 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "prop", fx = { { "text", text = "REFUSÉ", color = INK, scale = 1.2 } }, text = "IL MANQUE UN JUSTIFICATIF.", hitText = "CHTONK !",
		},
		-- ✋ puis ← : Au service d'à côté, il fait pivoter l'adversaire et le pousse derrière lui
		THROW_back = {
			label = "Au service d'à côté", kind = "throw", back = true, startup = 0.38, active = 0.1, recovery = 0.38,
			damage = 10, kbBase = 36, kbGrowth = 66, kbAngle = 35,
			carry = { { 0, 2.4, 0.6 }, { 0.14, 1.2, 0.6 }, { 0.26, -0.6, 0.6 }, { 0.38, -2.6, 0.4 } },
			windup = { Root = { 0, 30, 0, 0, -0.2, 0 }, Waist = { 0, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 85, 0, 15 }, LE = { 45, 0, 0 } },
			strike = { Root = { -6, -60, 0, 0, -0.25, 0.2 }, Waist = { -6, -40, 0 }, Neck = { 0, 40, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 70, 0, -80 }, LE = { 10, 0, 0 } },
			follow = { Root = { -6, -70, 0, 0, -0.25, 0.25 }, Waist = { -6, -45, 0 }, Neck = { 0, 50, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 60, 0, -90 }, LE = { 10, 0, 0 } },
			text = "VOYEZ AVEC LE SERVICE D'À CÔTÉ.", hitText = "SUIVANT !",
		},
		-- ✋ puis ↑ : Classement vertical, il range l'adversaire tout en haut d'une étagère imaginaire
		THROW_up = {
			label = "Classement vertical", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.4, 0.6 }, { 0.14, 1.8, -0.4 }, { 0.3, 0.8, 4.2 } },
			windup = { Root = { -6, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 45, 0, -15 }, RE = { 40, 0, 0 }, LS = { 45, 0, 15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.2, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.25, -0.1 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 180, 0, 20 }, RE = { 5, 0, 0 }, LS = { 180, 0, -20 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			text = "CLASSÉ EN HAUT.", hitText = "ARCHIVÉ !",
		},
		-- ✋ puis ↓ : Mis en attente, il plaque l'adversaire au sol et pose son mug dessus
		THROW_down = {
			label = "Mis en attente", kind = "throw", startup = 0.42, active = 0.1, hold = 0.3, recovery = 0.35,
			damage = 9, kbBase = 30, kbGrowth = 25, kbAngle = 75, status = { name = "waiting", duration = 2 },
			carry = { { 0, 2.4, 0.6 }, { 0.16, 1.8, 1.6 }, { 0.3, 1.6, -2.0 }, { 0.42, 1.0, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.75, -0.4 }, Waist = { -28, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 20 }, RE = { 20, 0, 0 }, LS = { 70, 0, -5 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -14, 0, 0, 0, -0.7, -0.4 }, Waist = { -26, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 65, 0, -5 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.4 } },
			prop = "mug", fx = { { "symbols", symbols = { "☕", "📋" }, count = 3, radius = 1.5, at = "front" } }, text = "VEUILLEZ PATIENTER.", hitText = "EN ATTENTE…",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "classe_sans_suite", label = "Classé sans suite", sequence = { "back", "down", "back" },
			-- aplati dans un classeur, rangé dans une archive qui défile à l'infini
			scene = {
				{ "fxAttacker", { "text", text = "BON. CLASSÉ SANS SUITE.", color = PAPER } },
				{ "wait", 0.4 },
				{ "squash", 0.15 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 2, pieces = {
					{ "Classeur", "", "block", Vector3.new(4, 5.5, 0.6), Vector3.new(0, 0, -0.6), Vector3.new(0, 0, 0), OFFICE_GREEN },
					{ "Dos", "", "block", Vector3.new(4, 5.5, 0.6), Vector3.new(0, 0, 0.6), Vector3.new(0, 0, 0), OFFICE_GREEN },
					{ "Etiquette", "", "block", Vector3.new(2, 1, 0.1), Vector3.new(0, 1, -0.95), Vector3.new(0, 0, 0), PAPER },
				} },
				{ "text", "CLASSÉ SANS SUITE" },
				{ "wait", 0.8 },
				{ "spawn", at = "target", offset = Vector3.new(0, 1, 2), life = 2.4, name = "Archives", pieces = {
					{ "Etagere1", "", "block", Vector3.new(30, 0.4, 2), Vector3.new(10, -2, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
					{ "Etagere2", "", "block", Vector3.new(30, 0.4, 2), Vector3.new(10, 2, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
					{ "Boites", "", "block", Vector3.new(28, 3.4, 1.6), Vector3.new(10, 0, 0.1), Vector3.new(0, 0, 0), FOLDER },
				} },
				{ "launch", Vector3.new(60, 0, 0), time = 1.6 },
				{ "wait", 0.4 },
			},
		},
		{
			id = "revenez_demain", label = "Revenez demain", sequence = { "forward", "up", "forward" },
			-- jour et nuit en accéléré : l'adversaire attend toujours au guichet, une barbe blanche jusqu'aux pieds
			scene = {
				{ "fxAttacker", { "text", text = "GUICHET FERMÉ. REVENEZ DEMAIN.", color = PAPER } },
				{ "wait", 0.5 },
				{ "fx", { "screen", color = Color3.fromRGB(20, 20, 60), alpha = 0.7, time = 0.3 } },
				{ "wait", 0.3 },
				{ "fx", { "screen", color = Color3.fromRGB(255, 230, 150), alpha = 0.5, time = 0.3 } },
				{ "wait", 0.3 },
				{ "fx", { "screen", color = Color3.fromRGB(20, 20, 60), alpha = 0.7, time = 0.3 } },
				{ "wait", 0.3 },
				{ "fx", { "screen", color = Color3.fromRGB(255, 230, 150), alpha = 0.5, time = 0.3 } },
				{ "spawn", at = "target", offset = Vector3.new(0, -0.5, -0.8), life = 3, pieces = {
					{ "Barbe", "", "wedge", Vector3.new(1.4, 4.5, 0.5), Vector3.new(0, 0, 0), Vector3.new(180, 0, 0), Color3.fromRGB(245, 245, 245), "Fabric" },
				} },
				{ "color", Color3.fromRGB(200, 200, 200) },
				{ "text", "…TOUJOURS EN ATTENTE." },
				{ "fx", { "symbols", symbols = { "🕰️", "📅", "💤" }, count = 6, radius = 3 } },
				{ "wait", 1.2 },
				{ "fxAttacker", { "text", text = "NUMÉRO SUIVANT !", color = INK } },
				{ "wait", 0.6 },
			},
		},
		{
			id = "valide", label = "VALIDÉ", sequence = { "down", "down", "down" },
			-- un tampon géant tombe du ciel et l'imprime à plat sur le sol comme un autocollant
			scene = {
				{ "spawn", at = "above", offset = Vector3.new(0, 3, 0), life = 1.2, name = "TamponGeant", pieces = {
					{ "Pommeau", "", "ball", Vector3.new(2.4, 2, 2.4), Vector3.new(0, 4, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
					{ "Manche", "", "cyl", Vector3.new(3, 1.4, 1.4), Vector3.new(0, 2, 0), Vector3.new(0, 0, 0), WOOD, "Wood", { axis = "y" } },
					{ "Socle", "", "block", Vector3.new(7, 1.6, 4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
					{ "Encreur", "", "block", Vector3.new(6.8, 0.4, 3.8), Vector3.new(0, -1, 0), Vector3.new(0, 0, 0), INK },
				} },
				{ "text", "VÉRIFICATION…" },
				{ "wait", 0.9 },
				{ "squash", 0.1 },
				{ "fx", { "shake", amount = 0.7 } },
				{ "fx", { "burst", color = INK, size = 6, at = "feet" } },
				{ "color", INK },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.9, 0), life = 3, pieces = {
					{ "Cadre", "", "block", Vector3.new(6, 0.1, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), INK },
					{ "Fond", "", "block", Vector3.new(5.4, 0.12, 2.4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), PAPER },
					{ "Coche", "", "block", Vector3.new(3, 0.14, 0.5), Vector3.new(0.4, 0, 0), Vector3.new(0, 35, 0), Color3.fromRGB(40, 160, 60) },
				} },
				{ "text", "VALIDÉ ✔" },
				{ "fxAttacker", { "text", text = "DOSSIER SUIVANT.", color = PAPER } },
				{ "wait", 1.3 },
			},
		},
	},

	-- Mécanique : paperasse. Chaque touche colle un formulaire ; au 3e, l'adversaire est « en attente » 2 s
	-- icons : annonce du prochain résultat du Cerfa 12-B (variantes, affiché par le HUD comme pour Gaston)
	passive = { kind = "forms", name = "Paperasse", icon = "📋", max = 3, duration = 2, icons = { "✍️", "📑", "❌" } },

	-- Recharge ⚡ : il tamponne une pile de formulaires à la chaîne (CHTONK CHTONK) puis sirote son mug
	charge = {
		label = "Tamponnage à la chaîne",
		loop = 1.6,
		lockWrist = true,
		color = INK,
		keys = {
			{ 0.0, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 5 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 0.15, { Root = { -2, 0, 0, 0, -0.25, 0 }, Waist = { -16, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 55, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 0.35, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 5 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 0.5, { Root = { -2, 0, 0, 0, -0.25, 0 }, Waist = { -16, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 55, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 0.7, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 5 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 0.95, { Root = { 6, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 132, 0, 25 }, LE = { 140, 0, 0 } } },
			{ 1.3, { Root = { 6, 0, 0, 0, -0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 138, 0, 25 }, LE = { 138, 0, 0 } } },
			{ 1.6, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 5 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
		},
		beats = {
			{ 0.15, { "text", text = "CHTONK", color = INK } },
			{ 0.5, { "text", text = "CHTONK", color = INK } },
			{ 0.55, { "particles", tex = "smoke", color = PAPER, dir = "up", at = "front", time = 0.2, speed = 4 } },
			{ 1.0, { "symbols", symbols = { "☕", "SLURP" }, count = 2, radius = 1.5, color = Color3.fromRGB(200, 170, 130) } },
		},
	},

	-- Manies au repos : grand soupir, coup d'œil à la montre (« vivement vendredi »), lecture d'un formulaire
	fidgets = {
		{ duration = 2.2, keys = {
			{ 0, {} },
			{ 0.6, { Root = { 0, 0, 0, 0, 0.05, 0 }, Waist = { 8, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 10, 0, 30 }, LS = { 10, 0, -30 } } },
			{ 1.4, { Root = { 6, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 5, 0, 8 }, RE = { 20, 0, 0 }, LS = { 5, 0, -8 }, LE = { 20, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -25, 15, 0 }, LS = { 80, 0, 30 }, LE = { 100, 0, 0 } } },
			{ 1.1, { Neck = { -28, 15, 6 }, LS = { 82, 0, 30 }, LE = { 105, 0, 0 } } },
			{ 1.4, { Neck = { 10, 0, 0 }, LS = { 30, 0, -10 }, LE = { 50, 0, 0 } } },
			{ 1.8, {} },
		} },
		{ duration = 2.2, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -20, 0, 0 }, RS = { 55, 0, -15 }, RE = { 70, 0, 0 }, LS = { 55, 0, 15 }, LE = { 70, 0, 0 } } },
			{ 0.9, { Neck = { -20, 10, 0 }, RS = { 55, 0, -15 }, RE = { 70, 0, 0 }, LS = { 55, 0, 15 }, LE = { 70, 0, 0 } } },
			{ 1.3, { Neck = { -20, -10, 0 }, RS = { 55, 0, -15 }, RE = { 70, 0, 0 }, LS = { 55, 0, 15 }, LE = { 70, 0, 0 } } },
			{ 1.7, { Neck = { -20, 10, 0 }, RS = { 55, 0, -15 }, RE = { 70, 0, 0 }, LS = { 55, 0, 15 }, LE = { 70, 0, 0 } } },
			{ 2.2, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : la main gauche tient le col, buste en arrière, tête penchée, l'air
-- profondément las ; le tampon pend dans la main droite
data.grabHold = {
	Root = { 6, -6, 0, 0, -0.1, 0.1 },
	Waist = { 8, -6, 0 },
	Neck = { 10, 6, -10 },
	RS = { 20, 0, 22 },
	RE = { 50, 0, 0 },
	LS = { 85, 0, 15 },
	LE = { 45, 0, 0 },
	LW = { 0, 0, 0 },
}

-- Retour 🪂 : il tombe assis derrière son guichet qui se pose en grinçant, tamponne un ticket « VOTRE TOUR »
-- et rabat la vitre d'un coup sec
data.respawn = {
	duration = 1.9,
	platform = { pieces = {
		{ "Plancher", "base", "block", Vector3.new(6, 0.6, 4), Vector3.new(0, -0.3, 0), Vector3.zero, WOOD, "WoodPlanks" },
		{ "Cloison", "", "block", Vector3.new(6, 5, 0.3), Vector3.new(0, 2.5, 2), Vector3.zero, BEIGE },
		{ "Vitre", "", "block", Vector3.new(3.4, 2.2, 0.1), Vector3.new(0, 3, 1.8), Vector3.zero, Color3.fromRGB(200, 230, 255), "Glass", { transparency = 0.5 } },
		{ "Panneau", "", "block", Vector3.new(3, 0.8, 0.2), Vector3.new(0, 5.5, 2), Vector3.zero, OFFICE_GREEN },
		{ "Numero", "", "block", Vector3.new(0.8, 0.5, 0.1), Vector3.new(0, 5.5, 1.85), Vector3.zero, PAPER },
		{ "Comptoir", "", "block", Vector3.new(1.4, 2.4, 3), Vector3.new(-2.4, 1.2, 0.2), Vector3.zero, WOOD, "Wood" },
		{ "Sonnette", "", "ball", Vector3.new(0.5, 0.35, 0.5), Vector3.new(-2.4, 2.55, -0.4), Vector3.zero, Color3.fromRGB(220, 200, 90), "Metal" },
		{ "Plante", "", "ball", Vector3.new(0.9, 1.2, 0.9), Vector3.new(-2.4, 3, 0.8), Vector3.zero, Color3.fromRGB(60, 140, 60), "Grass" },
	} },
	keys = {
		{ 0.0, { Root = { 6, 0, 0, 0, -1.0, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 }, RH = { 85, 0, 4 }, RK = { -85, 0, 0 }, LH = { 85, 0, -4 }, LK = { -85, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
		{ 0.6, { Root = { 2, 0, 0, 0, -1.05, 0.15 }, Waist = { 2, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 }, RH = { 88, 0, 4 }, RK = { -82, 0, 0 }, LH = { 88, 0, -4 }, LK = { -82, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
		{ 0.85, { Root = { 2, 0, 0, 0, -0.2, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 120, 0, 5 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
		{ 1.0, { Root = { -4, 0, 0, 0, -0.3, 0 }, Waist = { -14, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 55, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } } },
		{ 1.3, { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 10 }, RE = { 30, 0, 0 }, LS = { 160, 0, -10 }, LE = { 30, 0, 0 } } },
		{ 1.5, { Root = { -4, 0, 0, 0, -0.2, 0 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 100, 0, 10 }, RE = { 10, 0, 0 }, LS = { 100, 0, -10 }, LE = { 10, 0, 0 } } },
		{ 1.9, {} },
	},
	beats = {
		{ 0.6, { "text", text = "GRIIIINCE…", color = PAPER } },
		{ 1.0, { "text", text = "VOTRE TOUR.", color = INK } },
		{ 1.0, { "burst", color = INK, size = 2 } },
		{ 1.5, { "text", text = "CLAC !", color = PAPER } },
		{ 1.5, { "shake", amount = 0.2 } },
	},
}

-- Arbre d'enchaînements : P P P (mug, agrafeuse, tampon), K K K, mélanges, et finitions S qui collent de
-- la paperasse (agrafage en triple exemplaire, avion en papier, tampon REFUSÉ)
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_agrafe" }, -- P
	P_combo2 = { P = "P_combo3", K = "K_combo3", S = "S_finish_agrafe" }, -- P P
	P_combo3 = { S = "S_side" }, -- P P P (tampon puis REFUSÉ)
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_agrafe" }, -- P K
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_agrafe" }, -- K
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_agrafe" }, -- K K
	K_combo3 = { S = "S_neutral" }, -- K K K (fait décoller : l'avion en papier suit)
	KP_combo = { P = "P_combo3", K = "K_combo2", S = "S_finish_agrafe" }, -- K P
	P_side = { P = "P_combo2", K = "K_neutral", S = "S_side" }, -- → P
	P_down = { P = "P_up", K = "K_combo3", S = "S_finish_agrafe" }, -- ↓ P
	P_up = { P = "P_combo3", S = "S_neutral" }, -- ↑ P
	K_down = { P = "P_combo2", K = "K_combo2", S = "S_finish_agrafe" }, -- ↓ K
	K_side = { P = "KP_combo", S = "S_side" }, -- → K
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_finish_agrafe" }, -- dash P
	K_dash = { P = "P_up", S = "S_neutral" }, -- dash K
	-- en l'air
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

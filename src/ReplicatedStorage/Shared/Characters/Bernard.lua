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

local COPIER = Color3.fromRGB(215, 215, 210) -- photocopieuse (arme n° 2)
local COPIER_DARK = Color3.fromRGB(90, 90, 100)
local SCANLIGHT = Color3.fromRGB(120, 255, 120)
local COFFEE = Color3.fromRGB(80, 50, 30) -- machine à café (arme n° 3)
local CUP = Color3.fromRGB(245, 245, 240)
local SILVER_B = Color3.fromRGB(200, 205, 215)
-- Feuille photocopiée (projectiles de l'arme n° 2)
local SHEET = { shape = "block", size = 1.2, color = PAPER, spin = 6, parts = {
	{ "block", Vector3.new(1.0, 0.04, 1.3), Vector3.new(0, 0, 0), PAPER },
	{ "block", Vector3.new(0.7, 0.05, 0.1), Vector3.new(0, 0.03, -0.3), BLACK },
	{ "block", Vector3.new(0.5, 0.05, 0.1), Vector3.new(-0.1, 0.03, 0.1), BLACK },
} }

local data = {
	id = "Bernard",
	name = "Bernard du Guichet",
	costume = "Bernard",
	style = "bored",

	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : le guichet fermé
	-- Ses propres J / K et ses combos sans arme (les L et les Y restent ceux de moves). Sans tampon ni dossiers,
	-- Bernard se bat avec un ennui profond : revers mous, index du refus, bâillements, mocassins qui partent.
	-- Combos : J J (revers aller-retour), J K (bâillement contagieux), K K K (mocassins), K J (craquage de doigts).
	bare = {
		moves = {
			-- J : revers de la main, mou et méprisant, sans même regarder
			P_neutral = {
				label = "Revers blasé", startup = 0.09, active = 0.08, recovery = 0.16,
				damage = 5, hitbox = box(4, 3, 2.6, 0.8), kbBase = 16, kbGrowth = 22, kbAngle = 24,
				windup = { Root = { 4, -20, 0, 0, -0.05, 0.1 }, Waist = { 4, -24, 0 }, Neck = { 6, 30, 0 }, RS = { 60, 0, -40 }, RE = { 90, 0, 0 }, RW = { 20, 0, 0 }, LS = { 0, 0, -6 }, LE = { 20, 0, 0 } },
				strike = { Root = { 0, 16, 0, 0, -0.05, -0.15 }, Waist = { 0, 20, 0 }, Neck = { 6, 40, 0 }, RS = { 85, 0, 60 }, RE = { 20, 0, 0 }, RW = { -20, 0, 0 }, LS = { 0, 0, -6 }, LE = { 20, 0, 0 } },
				follow = { Root = { 0, 20, 0, 0, -0.05, -0.18 }, Waist = { 0, 24, 0 }, Neck = { 6, 44, 0 }, RS = { 80, 0, 72 }, RE = { 24, 0, 0 }, RW = { -30, 0, 0 }, LS = { 0, 0, -6 }, LE = { 20, 0, 0 } },
				trail = "rightHand", hitText = "PFF !",
			},
			-- J J : retour de la même main, en soupirant
			P_combo2 = {
				label = "Revers de retour", startup = 0.08, active = 0.08, recovery = 0.16,
				damage = 5, hitbox = box(4, 3, 2.6, 0.8), kbBase = 16, kbGrowth = 24, kbAngle = 30,
				windup = { Root = { 0, 20, 0, 0, -0.05, 0.05 }, Waist = { 0, 24, 0 }, Neck = { 6, 40, 0 }, RS = { 85, 0, 70 }, RE = { 30, 0, 0 }, LS = { 0, 0, -6 }, LE = { 20, 0, 0 } },
				strike = { Root = { 2, -18, 0, 0, -0.08, -0.2 }, Waist = { 2, -22, 0 }, Neck = { 6, 20, 0 }, RS = { 90, 0, -30 }, RE = { 10, 0, 0 }, RW = { 20, 0, 0 }, LS = { 0, 0, -6 }, LE = { 20, 0, 0 } },
				follow = { Root = { 2, -22, 0, 0, -0.08, -0.22 }, Waist = { 2, -26, 0 }, Neck = { 6, 16, 0 }, RS = { 86, 0, -42 }, RE = { 14, 0, 0 }, RW = { 30, 0, 0 }, LS = { 0, 0, -6 }, LE = { 20, 0, 0 } },
				trail = "rightHand", text = "SOUPIR…", hitText = "PFLOC !",
			},
			-- J K : bâillement contagieux, il s'étire et l'onde d'ennui assomme l'adversaire (finition)
			PK_combo = {
				label = "Bâillement contagieux", startup = 0.14, active = 0.14, recovery = 0.3,
				damage = 9, hitbox = box(5, 4, 2.4, 1.2), kbBase = 28, kbGrowth = 56, kbAngle = 40,
				windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 120, 0, 0 }, LS = { 40, 0, -40 }, LE = { 120, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 70 }, RE = { 10, 0, 0 }, LS = { 150, 0, -70 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.1, 0 }, FL = { 0, 0, 0, 0, 0.1, 0 } },
				follow = { Root = { 12, 0, 0, 0, 0.05, 0.12 }, Waist = { 18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 156, 0, 80 }, RE = { 10, 0, 0 }, LS = { 156, 0, -80 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.1, 0 }, FL = { 0, 0, 0, 0, 0.1, 0 } },
				hold = 0.1, fx = { { "ring", color = OFFICE_GREEN, radius = 4, at = "front" }, { "symbols", symbols = { "💤", "💤" }, color = SHIRT, count = 4, radius = 3 } }, text = "OUAAAAH…", hitText = "ZZZ !",
			},
			-- K : coup de mocassin, la jambe se lève à peine mais le talon est dur
			K_neutral = {
				label = "Coup de mocassin", startup = 0.13, active = 0.1, recovery = 0.26,
				damage = 7, hitbox = box(4.5, 2.6, 2.6, -0.4), kbBase = 22, kbGrowth = 40, kbAngle = 30,
				windup = { Root = { 6, 0, 0, 0, -0.05, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { -10, 0, 10 }, RE = { 30, 0, 0 }, LS = { -10, 0, -10 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, -0.05, -0.05 }, Waist = { 10, 0, 0 }, Neck = { 4, 0, 0 }, RS = { -14, 0, 14 }, RE = { 30, 0, 0 }, LS = { -14, 0, -14 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
				follow = { Root = { 12, 0, 0, 0, -0.05, -0.06 }, Waist = { 12, 0, 0 }, Neck = { 4, 0, 0 }, RS = { -14, 0, 14 }, RE = { 30, 0, 0 }, LS = { -14, 0, -14 }, LE = { 30, 0, 0 }, RH = { 72, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
				trail = "rightFoot", hitText = "TOC.",
			},
			-- K K : deuxième mocassin, de l'autre pied, en regardant le plafond
			K_combo2 = {
				label = "Mocassin gauche", startup = 0.12, active = 0.1, recovery = 0.26,
				damage = 7, hitbox = box(4.5, 2.6, 2.8, -0.4), kbBase = 22, kbGrowth = 40, kbAngle = 34,
				windup = { Root = { 6, 0, 0, 0, -0.05, 0.05 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -10, 0, 10 }, RE = { 30, 0, 0 }, LS = { -10, 0, -10 }, LE = { 30, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, -0.05, -0.1 }, Waist = { 10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { -14, 0, 14 }, RE = { 30, 0, 0 }, LS = { -14, 0, -14 }, LE = { 30, 0, 0 }, LH = { 75, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
				follow = { Root = { 12, 0, 0, 0, -0.05, -0.12 }, Waist = { 12, 0, 0 }, Neck = { 26, 0, 0 }, RS = { -14, 0, 14 }, RE = { 30, 0, 0 }, LS = { -14, 0, -14 }, LE = { 30, 0, 0 }, LH = { 78, 0, 0 }, LK = { 0, 0, 0 }, LA = { 14, 0, 0 } },
				trail = "leftFoot", hitText = "TOC TOC.",
			},
			-- K K K : le mocassin s'envole avec le coup de pied et part dans la figure (finition)
			K_combo3 = {
				label = "Mocassin parti", startup = 0.14, active = 0.12, recovery = 0.32,
				damage = 10, hitbox = box(5.5, 3, 3.4, 0.6), kbBase = 30, kbGrowth = 62, kbAngle = 38,
				windup = { Root = { 10, 0, 0, 0, -0.1, 0.15 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 40, 0, -40 }, LE = { 40, 0, 0 }, RH = { -30, 0, 0 }, RK = { -90, 0, 0 } },
				strike = { Root = { 16, 0, 0, 0, -0.1, -0.15 }, Waist = { 14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 60, 0, 50 }, RE = { 20, 0, 0 }, LS = { 60, 0, -50 }, LE = { 20, 0, 0 }, RH = { 120, 0, 0 }, RK = { -4, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { 18, 0, 0, 0, -0.1, -0.18 }, Waist = { 16, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 62, 0, 52 }, RE = { 20, 0, 0 }, LS = { 62, 0, -52 }, LE = { 20, 0, 0 }, RH = { 126, 0, 0 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 } },
				trail = "rightFoot", fx = { { "toss", shape = "flat", color = BLACK, size = 0.8, count = 1, speed = 20 } }, text = "OH, ZUT.", hitText = "CLONK !",
			},
			-- K J : il fait craquer ses doigts, puis frappe des deux poings joints sur le crâne
			KP_combo = {
				label = "Craquage de doigts", startup = 0.13, active = 0.1, recovery = 0.3,
				damage = 9, hitbox = box(4, 3.5, 2.4, 1.2), kbBase = 28, kbGrowth = 52, kbAngle = 60,
				windup = { Root = { 6, 0, 0, 0, 0, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 170, 0, 6 }, RE = { 20, 0, 0 }, LS = { 170, 0, -6 }, LE = { 20, 0, 0 } },
				strike = { Root = { -12, 0, 0, 0, -0.3, -0.25 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 0, 0, 0 } },
				follow = { Root = { -14, 0, 0, 0, -0.32, -0.28 }, Waist = { -26, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 55, 0, -10 }, RE = { 0, 0, 0 }, LS = { 55, 0, 10 }, LE = { 0, 0, 0 } },
				windupFx = { { "text", text = "CRIC CRAC", color = SHIRT, at = "hand" } }, trail = "bothHands", fx = { { "burst", color = INK, size = 2, at = "front" } }, hitText = "BOUM.",
			},
			-- →J : l'index du refus, il pointe le doigt et le remue « non, non, non »
			P_side = {
				label = "Doigt du refus", startup = 0.1, active = 0.12, recovery = 0.2,
				damage = 7, hits = 2, hitbox = box(4.5, 2.6, 3, 1), kbBase = 20, kbGrowth = 36, kbAngle = 20, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { 4, 10, 0, 0, -0.05, 0.1 }, Waist = { 4, 14, 0 }, Neck = { 10, -10, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, LS = { 20, 0, -40 }, LE = { 100, 0, 0 } },
				strike = { Root = { -6, -4, 0, 0, -0.08, -0.3 }, Waist = { -6, -6, 0 }, Neck = { 6, 0, 0 }, RS = { 95, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, -25 }, LS = { 20, 0, -40 }, LE = { 100, 0, 0 } },
				follow = { Root = { -6, -4, 0, 0, -0.08, -0.32 }, Waist = { -6, -6, 0 }, Neck = { 6, 0, 0 }, RS = { 95, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 25 }, LS = { 20, 0, -40 }, LE = { 100, 0, 0 } },
				trail = "rightHand", text = "NON.", hitText = "NON NON !",
			},
			-- ↓J : il tape du plat de la main sur un guichet imaginaire, comme sur une sonnette
			P_down = {
				label = "Sonnette du guichet", startup = 0.08, active = 0.08, recovery = 0.2,
				damage = 6, hitbox = box(4, 2, 2.4, -1.3), kbBase = 20, kbGrowth = 26, kbAngle = 66,
				windup = { Root = { -6, 0, 0, 0, -0.5, 0.05 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, RW = { 30, 0, 0 }, LS = { -10, 0, -10 }, LE = { 30, 0, 0 } },
				strike = { Root = { -14, 0, 0, 0, -0.7, -0.1 }, Waist = { -26, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 45, 0, 0 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { -10, 0, -10 }, LE = { 30, 0, 0 } },
				follow = { Root = { -14, 0, 0, 0, -0.72, -0.12 }, Waist = { -28, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 40, 0, 0 }, RE = { 12, 0, 0 }, RW = { -44, 0, 0 }, LS = { -10, 0, -10 }, LE = { 30, 0, 0 } },
				trail = "rightHand", fx = { { "symbols", symbols = { "🔔" }, color = POSTIT, count = 1, radius = 1 } }, hitText = "DING !",
			},
			-- ↑J : l'étirement de 10 h, les deux bras au ciel en se cambrant
			P_up = {
				label = "Étirement de 10 h", startup = 0.1, active = 0.12, recovery = 0.22,
				damage = 6, hitbox = box(4.5, 5, 1.2, 3), kbBase = 22, kbGrowth = 38, kbAngle = 88,
				windup = { Root = { -4, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 30 }, RE = { 90, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } },
				strike = { Root = { 8, 0, 0, 0, 0.1, 0.05 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 20 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 175, 0, -20 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
				follow = { Root = { 10, 0, 0, 0, 0.12, 0.06 }, Waist = { 22, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 26 }, RE = { 0, 0, 0 }, RW = { -36, 0, 0 }, LS = { 178, 0, -26 }, LE = { 0, 0, 0 }, LW = { -36, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
				trail = "bothHands", text = "HMMMF…", hitText = "CRAC !",
			},
			-- J en l'air : poings joints en marteau, il retombe comme un tampon humain
			P_air = {
				label = "Poing-tampon", startup = 0.1, active = 0.12, recovery = 0.2,
				damage = 8, hitbox = box(4, 3.5, 1.4, -1.4), kbBase = 22, kbGrowth = 38, kbAngle = -55,
				windup = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 175, 0, 6 }, RE = { 30, 0, 0 }, LS = { 175, 0, -6 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
				strike = { Root = { -20, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, -8 }, RE = { 0, 0, 0 }, LS = { 30, 0, 8 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
				follow = { Root = { -22, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 20, 0, -8 }, RE = { 0, 0, 0 }, LS = { 20, 0, 8 }, LE = { 0, 0, 0 }, RH = { 8, 0, 0 }, RK = { -40, 0, 0 }, LH = { 8, 0, 0 }, LK = { -40, 0, 0 } },
				trail = "bothHands", fx = { { "burst", color = INK, size = 2, at = "front" } }, hitText = "TAMPONNÉ !",
			},
			-- dash J : coudes de la cantine, il joue des coudes pour arriver le premier au self
			P_dash = {
				label = "Coudes de la cantine", startup = 0.1, active = 0.18, recovery = 0.26,
				damage = 7, hits = 2, hitbox = box(4.5, 3, 2.4, 0.8), kbBase = 22, kbGrowth = 36, kbAngle = 28, selfVelocity = Vector2.new(30, 0),
				windup = { Root = { -4, 0, 0, 0, -0.1, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 40, 0, 60 }, RE = { 150, 0, 0 }, LS = { 40, 0, -60 }, LE = { 150, 0, 0 } },
				strike = { Root = { -10, 20, 0, 0, -0.12, -0.35 }, Waist = { -10, 24, 0 }, Neck = { 4, -20, 0 }, RS = { 60, 0, 40 }, RE = { 150, 0, 0 }, LS = { 30, 0, -80 }, LE = { 150, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
				follow = { Root = { -10, -20, 0, 0, -0.12, -0.4 }, Waist = { -10, -24, 0 }, Neck = { 4, 20, 0 }, RS = { 30, 0, 80 }, RE = { 150, 0, 0 }, LS = { 60, 0, -40 }, LE = { 150, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				trail = "body", text = "C'EST MIDI !", hitText = "POUSSEZ-VOUS !",
			},
			-- →K : talon du règlement, coup de pied latéral bien droit « article 12, alinéa 3 »
			K_side = {
				label = "Talon du règlement", startup = 0.14, active = 0.12, recovery = 0.28,
				damage = 9, hitbox = box(5.5, 2.8, 3.2, 0.2), kbBase = 26, kbGrowth = 50, kbAngle = 26, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { 4, 70, 0, 0, -0.1, 0.1 }, Waist = { 4, 20, 0 }, Neck = { 6, -70, 0 }, RS = { -10, 0, 10 }, RE = { 30, 0, 0 }, LS = { -10, 0, -10 }, LE = { 30, 0, 0 }, RH = { 40, 0, 50 }, RK = { -110, 0, 0 } },
				strike = { Root = { 10, 85, 14, 0, -0.1, -0.1 }, Waist = { 10, 20, 0 }, Neck = { 6, -85, 0 }, RS = { -14, 0, 14 }, RE = { 30, 0, 0 }, LS = { -14, 0, -14 }, LE = { 30, 0, 0 }, RH = { 10, 0, 90 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { 12, 86, 16, 0, -0.1, -0.12 }, Waist = { 12, 22, 0 }, Neck = { 6, -86, 0 }, RS = { -14, 0, 14 }, RE = { 30, 0, 0 }, LS = { -14, 0, -14 }, LE = { 30, 0, 0 }, RH = { 12, 0, 92 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
				trail = "rightLeg", text = "ARTICLE 12 !", hitText = "ALINÉA 3 !",
			},
			-- ↓K : jambes croisées, il s'affale et décroise d'un coup sec dans les chevilles
			K_down = {
				label = "Jambes décroisées", startup = 0.11, active = 0.12, recovery = 0.28,
				damage = 7, hitbox = box(5.5, 2, 2.8, -1.6), kbBase = 24, kbGrowth = 40, kbAngle = 72,
				windup = { Root = { 10, 0, 0, 0, -1.0, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -20, 0, 30 }, RE = { 40, 0, 0 }, LS = { -20, 0, -30 }, LE = { 40, 0, 0 }, RH = { 90, 0, -20 }, RK = { -80, 0, 0 }, LH = { 90, 0, 0 }, LK = { -90, 0, 0 } },
				strike = { Root = { 14, 0, 0, 0, -1.05, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -24, 0, 34 }, RE = { 40, 0, 0 }, LS = { -24, 0, -34 }, LE = { 40, 0, 0 }, RH = { 85, 0, 20 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 }, LH = { 90, 0, 0 }, LK = { -90, 0, 0 } },
				follow = { Root = { 14, 0, 0, 0, -1.05, 0.08 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -24, 0, 34 }, RE = { 40, 0, 0 }, LS = { -24, 0, -34 }, LE = { 40, 0, 0 }, RH = { 86, 0, 24 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 }, LH = { 90, 0, 0 }, LK = { -90, 0, 0 } },
				trail = "rightFoot", hitText = "CLAP.",
			},
			-- ↑K : son dos se bloque, il se cambre et le talon part en arrière par-dessus la tête
			K_up = {
				label = "Dos bloqué", startup = 0.14, active = 0.12, recovery = 0.3,
				damage = 8, hitbox = box(4, 5.5, 0.6, 3.4), kbBase = 26, kbGrowth = 50, kbAngle = 92,
				windup = { Root = { -6, 0, 0, 0, -0.2, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, -20 }, LE = { 60, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 } },
				strike = { Root = { 20, 0, 0, 0, 0, 0.2 }, Waist = { 24, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 60 }, RE = { 10, 0, 0 }, LS = { 20, 0, -60 }, LE = { 10, 0, 0 }, RH = { -60, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
				follow = { Root = { 22, 0, 0, 0, 0, 0.22 }, Waist = { 26, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 18, 0, 62 }, RE = { 10, 0, 0 }, LS = { 18, 0, -62 }, LE = { 10, 0, 0 }, RH = { -64, 0, 0 }, RK = { -124, 0, 0 }, RA = { -24, 0, 0 } },
				trail = "rightFoot", text = "AÏE, MON DOS !", hitText = "CRAAAC !",
			},
			-- K en l'air : double mocassin, les deux pieds pendants qui battent l'air sans conviction
			K_air = {
				label = "Double mocassin", startup = 0.1, active = 0.16, recovery = 0.22,
				damage = 8, hitbox = box(4.5, 3, 2, -1.2), kbBase = 22, kbGrowth = 40, kbAngle = 36,
				windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 40 }, RE = { 40, 0, 0 }, LS = { 30, 0, -40 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
				strike = { Root = { 16, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 50 }, RE = { 30, 0, 0 }, LS = { 20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 70, 0, 6 }, RK = { -4, 0, 0 }, LH = { 70, 0, -6 }, LK = { -4, 0, 0 } },
				follow = { Root = { 18, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 18, 0, 52 }, RE = { 30, 0, 0 }, LS = { 18, 0, -52 }, LE = { 30, 0, 0 }, RH = { 72, 0, 8 }, RK = { 0, 0, 0 }, LH = { 72, 0, -8 }, LK = { 0, 0, 0 } },
				trail = "rightFoot", hitText = "PLOF.",
			},
			-- dash K : croche-pied administratif, il glisse une jambe en travers « c'est fermé »
			K_dash = {
				label = "Croche-pied administratif", startup = 0.1, active = 0.22, recovery = 0.32,
				damage = 8, hitbox = box(5.5, 2, 2.8, -1.4), kbBase = 26, kbGrowth = 48, kbAngle = 74, selfVelocity = Vector2.new(34, 0),
				windup = { Root = { -4, 20, 0, 0, -0.2, 0.05 }, Waist = { -6, 10, 0 }, Neck = { 6, -20, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 20, 0, -30 }, LE = { 60, 0, 0 } },
				strike = { Root = { 0, 40, 0, 0, -0.75, -0.1 }, Waist = { -4, 10, 0 }, Neck = { 6, -40, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { -20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 40, 0, 60 }, RK = { -4, 0, 0 }, LH = { 70, 0, 0 }, LK = { -120, 0, 0 } },
				follow = { Root = { 0, 42, 0, 0, -0.76, -0.12 }, Waist = { -4, 12, 0 }, Neck = { 6, -42, 0 }, RS = { 40, 0, 52 }, RE = { 30, 0, 0 }, LS = { -22, 0, -52 }, LE = { 30, 0, 0 }, RH = { 42, 0, 62 }, RK = { 0, 0, 0 }, LH = { 70, 0, 0 }, LK = { -120, 0, 0 } },
				trail = "rightLeg", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(200, 195, 185), dir = "front", at = "feet", time = 0.25, speed = 7 } }, text = "C'EST FERMÉ.", hitText = "BADABOUM !",
			},
		},
		-- Combos à mains nues : J J puis K (revers aller-retour puis bâillement), K K K (mocassins jusqu'à la perte),
		-- K J (craquage de doigts), →J ↓K, ↓J ↑J. Un S pour finir envoie le spécial du perso.
		links = {
			P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_neutral" },
			P_combo2 = { K = "PK_combo", P = "P_side", S = "S_side" },
			PK_combo = { S = "S_neutral" },
			K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_down" },
			K_combo2 = { K = "K_combo3", P = "KP_combo", S = "S_side" },
			K_combo3 = { S = "S_side" },
			KP_combo = { K = "K_up", S = "S_down" },
			P_side = { K = "K_down", P = "P_combo2", S = "S_side" },
			P_down = { P = "P_up", K = "K_combo2", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			K_side = { P = "KP_combo", K = "K_combo3", S = "S_side" },
			K_down = { P = "P_up", S = "S_down" },
			K_up = { S = "S_up" },
			P_dash = { P = "P_combo2", K = "PK_combo", S = "S_neutral" },
			K_dash = { P = "P_up", K = "K_up", S = "S_down" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : le tampon géant (ses coups sont ceux de moves). n° 2 : la photocopieuse portative, jeu de projectiles en papier à
	-- longue portée. n° 3 : la machine à café du couloir, lourde et lente, qui requinque à chaque coup.
	weapons = {
		{ id = "tampon", name = "Tampon géant & dossiers", icon = "📋",
			ability = { status = { name = "slowed", duration = 1.5 }, text = "Ses L enlisent l'adversaire dans la paperasse" } },
		{ id = "photocopieuse", name = "Photocopieuse portative", icon = "🖨️",
			prop = { name = "PropPhotocopieuse", hand = "Right", pieces = {
				{ "Poignee", "", "cyl", Vector3.new(0.7, 0.18, 0.18), Vector3.new(0, -0.15, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic", { axis = "x" } },
				{ "Caisson", "", "block", Vector3.new(1.6, 0.9, 1.4), Vector3.new(0, -0.95, 0), Vector3.new(0, 0, 0), COPIER, "SmoothPlastic" },
				{ "Capot", "", "block", Vector3.new(1.65, 0.12, 1.45), Vector3.new(0, -0.44, 0), Vector3.new(0, 0, 0), COPIER_DARK, "SmoothPlastic" },
				{ "Vitre", "", "block", Vector3.new(1.3, 0.04, 1.1), Vector3.new(0, -0.5, 0), Vector3.new(0, 0, 0), SCANLIGHT, "Neon" },
				{ "Bac", "", "block", Vector3.new(1.2, 0.08, 0.9), Vector3.new(0, -1.1, -1.0), Vector3.new(-10, 0, 0), PAPER, "SmoothPlastic" },
				{ "Voyant", "", "ball", Vector3.new(0.18, 0.18, 0.18), Vector3.new(0.6, -0.6, -0.72), Vector3.new(0, 0, 0), INK, "Neon" },
			} },
			ability = { reach = 1.2, text = "Portée +20 % (il envoie des copies partout)" },
			moves = {
				-- J : coup de bac à papier : il tend la machine devant lui, le bac en avant cogne le nez
				P_neutral = {
					label = "Coup de bac", startup = 0.09, active = 0.08, recovery = 0.16,
					damage = 6, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 20, kbGrowth = 26, kbAngle = 25,
					windup = { Root = { 2, -16, 0, 0, -0.12, 0.12 }, Waist = { 4, -20, 0 }, Neck = { -4, 14, 0 }, RS = { 50, 0, 25 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 16, 0, 0, -0.24, -0.3 }, Waist = { -10, 22, 0 }, Neck = { 0, -12, 0 }, RS = { 94, 0, 4 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 10, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -10, 20, 0, 0, -0.26, -0.34 }, Waist = { -12, 26, 0 }, Neck = { 0, -14, 0 }, RS = { 96, 0, 6 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 8, 0, -32 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", hitText = "CLOC !",
				},
				-- →J : une copie éjectée à bout portant, qui claque sur le front comme une gifle en papier
				P_side = {
					label = "Copie éjectée", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 7, kbBase = 22, kbGrowth = 34, kbAngle = 28,
					projectile = { speed = 70, angle = 4, gravity = 25, lifetime = 0.3, size = 1.2, color = PAPER, aim = false, visual = SHEET },
					windup = { Root = { 4, -24, 0, 0, -0.15, 0.2 }, Waist = { 6, -28, 0 }, Neck = { -6, 20, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -10, 18, 0, 0, -0.28, -0.35 }, Waist = { -12, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 22, 0, 0, -0.3, -0.4 }, Waist = { -14, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 94, 0, 2 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 26, 0, -32 }, LE = { 70, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					fx = { { "particles", tex = "spark", color = SCANLIGHT, dir = "front", at = "hand", time = 0.15, speed = 8, size = 0.4 } }, hitText = "FLAP !",
				},
				-- ↓J : accroupi, il rabat le capot de la machine sur les orteils de l'adversaire
				P_down = {
					label = "Capot claqué", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 6, hitbox = box(5, 2, 3, -1.9), kbBase = 22, kbGrowth = 26, kbAngle = 72,
					windup = { Root = { 6, 0, 0, 0, -0.6, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -20 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.9, -0.2 }, Waist = { 24, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 44, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 14, 0, 0, 0, -0.9, -0.24 }, Waist = { 26, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 46, 0, -12 }, LE = { 0, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "leftHand", hitText = "CLAC !",
				},
				-- ↑J : il lève la machine au-dessus de lui, le scanner flashe vert dans les yeux de celui qui passe
				P_up = {
					label = "Flash du scanner", startup = 0.1, active = 0.12, recovery = 0.22,
					damage = 7, hitbox = box(5, 5, 1.5, 3.2), kbBase = 24, kbGrowth = 36, kbAngle = 85,
					windup = { Root = { 6, 0, 0, 0, -0.4, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 25 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -25 }, LE = { 110, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.15, -0.05 }, Waist = { -12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 178, 0, 8 }, RE = { 5, 0, 0 }, RW = { 170, 0, 0 }, LS = { 170, 0, -8 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.18, -0.06 }, Waist = { -14, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 182, 0, 10 }, RE = { 5, 0, 0 }, RW = { 175, 0, 0 }, LS = { 174, 0, -10 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.18, 0 }, FL = { 0, 0, 0, 0, 0.18, 0 } },
					trail = "prop", fx = { { "burst", color = SCANLIGHT, size = 2.5, at = "above" }, { "screen", color = SCANLIGHT, alpha = 0.15 } }, text = "SCAN…", hitText = "FLASHÉ !",
				},
				-- J en l'air : la machine plaquée à plat devant lui, jambes repliées comme assis sur son bureau
				P_air = {
					label = "Copieuse aérienne", startup = 0.1, active = 0.12, recovery = 0.18,
					damage = 8, hitbox = box(5, 4, 2.8, 0.2), kbBase = 24, kbGrowth = 40, kbAngle = 25,
					windup = { Root = { 4, -22, 0 }, Waist = { 6, -26, 0 }, Neck = { 0, 18, 0 }, RS = { 60, 0, 40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, RH = { 80, 0, 0 }, RK = { -90, 0, 0 }, LH = { 80, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -8, 16, 0 }, Waist = { -8, 20, 0 }, Neck = { 0, -12, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, RH = { 85, 0, 0 }, RK = { -85, 0, 0 }, LH = { 85, 0, 0 }, LK = { -85, 0, 0 } },
					follow = { Root = { -10, 20, 0 }, Waist = { -10, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 98, 0, -8 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 15, 0, -42 }, LE = { 60, 0, 0 }, RH = { 85, 0, 0 }, RK = { -85, 0, 0 }, LH = { 85, 0, 0 }, LK = { -85, 0, 0 } },
					trail = "prop", hitText = "CHTONK !",
				},
				-- dash J : transfert de service : il court la machine serrée contre lui et bouscule tout sur son passage
				P_dash = {
					label = "Transfert de service", startup = 0.08, active = 0.15, recovery = 0.25,
					damage = 8, hitbox = box(5.5, 4, 2.8, 0.6), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(40, 0),
					windup = { Root = { -8, 0, 0, 0, -0.25, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -22, 0, 0, 0, -0.35, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 92, 0, 6 }, RE = { 8, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 8, 0, 0 } },
					follow = { Root = { -24, 0, 0, 0, -0.38, -0.35 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 94, 0, 8 }, RE = { 8, 0, 0 }, RW = { -8, 0, 0 }, LS = { 94, 0, -8 }, LE = { 8, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 5 } }, text = "MUTATION !", hitText = "TRANSFÉRÉ !",
				},
				-- K : il pose la machine et shoote dedans : elle recrache deux copies dans la figure de l'adversaire
				K_neutral = {
					label = "Coup de pied dans la machine", startup = 0.18, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(6, 3.5, 3.5, 0.3), kbBase = 30, kbGrowth = 68, kbAngle = 30,
					windup = { Root = { 8, -8, 0, 0, -0.3, 0.15 }, Waist = { 8, -6, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { -30, 0, 0 }, RK = { -70, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.15, 0.05 }, Waist = { 12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 30, 0, 0 }, RH = { 94, 0, 0 }, RK = { -4, 0, 0 }, RA = { 14, 0, 0 } },
					follow = { Root = { 14, 0, 0, 0, -0.15, 0.1 }, Waist = { 14, 0, 0 }, Neck = { -2, 0, 0 }, RS = { 22, 0, 52 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -54 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 } },
					trail = "rightFoot", fx = { { "toss", shape = "flat", color = PAPER, size = 0.9, count = 2, speed = 18 } }, text = "SALETÉ DE MACHINE.", hitText = "BONK !",
				},
				-- →K : bourrage papier : une boule de feuilles froissées grosse comme un ballon part en grand revers de la machine
				K_side = {
					label = "Bourrage papier", startup = 0.18, active = 0.14, recovery = 0.32,
					damage = 12, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 32, kbGrowth = 74, kbAngle = 30, selfVelocity = Vector2.new(16, 0),
					windup = { Root = { 6, 40, 0, 0, -0.2, 0.2 }, Waist = { 8, 46, 0 }, Neck = { -4, -30, 0 }, RS = { 70, 0, 70 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 70, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 92, 0, -30 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -42, 0, 0, -0.32, -0.4 }, Waist = { -12, -48, 0 }, Neck = { 0, 30, 0 }, RS = { 96, 0, -40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 84, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { { "toss", shape = "ball", color = PAPER, size = 1.2, count = 3, speed = 16 }, { "symbols", symbols = { "BOURRAGE", "⚠️" }, count = 2, radius = 2, at = "front", color = INK } }, text = "BOURRAGE !", hitText = "FROISSÉ !",
				},
				-- ↓K : tiroir à toner : accroupi, il ouvre le tiroir du bas d'un coup de pied, il part dans les tibias
				K_down = {
					label = "Tiroir à toner", startup = 0.16, active = 0.12, recovery = 0.3,
					damage = 11, hitbox = box(6, 2, 3.5, -1.8), kbBase = 28, kbGrowth = 60, kbAngle = 62,
					windup = { Root = { -4, -16, 0, 0, -0.6, 0.15 }, Waist = { -10, -12, 0 }, Neck = { 10, 10, 0 }, RS = { 60, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -35 }, LE = { 60, 0, 0 }, RH = { -20, 0, 10 }, RK = { -70, 0, 0 } },
					strike = { Root = { -8, 14, 0, 0, -0.75, -0.15 }, Waist = { -16, 12, 0 }, Neck = { 12, -8, 0 }, RS = { 40, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 50, 0, 0 }, RH = { 55, 0, 6 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { -9, 18, 0, 0, -0.75, -0.18 }, Waist = { -17, 14, 0 }, Neck = { 12, -10, 0 }, RS = { 38, 0, 22 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 62, 0, -30 }, LE = { 50, 0, 0 }, RH = { 58, 0, 2 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
					trail = "rightFoot", fx = { { "particles", tex = "smoke", color = BLACK, dir = "front", at = "feet", time = 0.25, speed = 8, size = 0.5 } }, hitText = "TOC !",
				},
				-- ↑K : capot à la volée : il cabre la machine d'un coup de genou, le capot s'ouvre dans le menton
				K_up = {
					label = "Capot à la volée", startup = 0.17, active = 0.12, recovery = 0.3,
					damage = 11, hitbox = box(4.5, 5.5, 1.5, 3.5), kbBase = 32, kbGrowth = 68, kbAngle = 88,
					windup = { Root = { 8, 0, 0, 0, -0.35, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.05, -0.1 }, Waist = { -18, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.08, -0.12 }, Waist = { -20, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 116, 0, 0 }, RK = { -124, 0, 0 }, RA = { -20, 0, 0 } },
					trail = "prop", fx = { { "burst", color = SCANLIGHT, size = 2, at = "above" } }, hitText = "CLANG !",
				},
				-- K en l'air : scan aérien : il tourne la machine vitre vers le bas, le flash vert assomme ce qui est dessous
				K_air = {
					label = "Scan aérien", startup = 0.15, active = 0.14, recovery = 0.24,
					damage = 11, hitbox = box(5, 4, 2, -1.2), kbBase = 28, kbGrowth = 64, kbAngle = -50,
					windup = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 185, 0, 12 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -12 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -18, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 55, 0, 6 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 55, 0, -6 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -22, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 6 }, RE = { 6, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -6 }, LE = { 6, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", fx = { { "burst", color = SCANLIGHT, size = 2.5, at = "feet" } }, hitText = "SCANNÉ !",
				},
				-- dash K : glissade sur une rame de papier, à plat ventre, machine tendue devant
				K_dash = {
					label = "Glissade sur rame", startup = 0.1, active = 0.25, recovery = 0.32,
					damage = 11, hitbox = box(6, 3, 3.5, -0.5), kbBase = 30, kbGrowth = 62, kbAngle = 45, selfVelocity = Vector2.new(50, 8),
					windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, 25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -25 }, LE = { 60, 0, 0 } },
					strike = { Root = { -75, 0, 0, 0, -1.3, -0.3 }, Waist = { -8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -10, 0, 4 }, RK = { -15, 0, 0 }, LH = { -10, 0, -4 }, LK = { -25, 0, 0 } },
					follow = { Root = { -80, 0, 0, 0, -1.35, -0.35 }, Waist = { -10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 16 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 180, 0, -16 }, LE = { 0, 0, 0 }, RH = { -14, 0, 5 }, RK = { -30, 0, 0 }, LH = { -6, 0, -5 }, LK = { -15, 0, 0 } },
					trail = "prop", fx = { { "toss", shape = "flat", color = PAPER, size = 0.8, count = 4, speed = 14 } }, text = "80 GRAMMES !", hitText = "ÉCRASÉ !",
				},
				-- L : rafale de copies : trois feuilles éjectées en éventail qui foncent sur l'adversaire
				S_neutral = {
					label = "Rafale de copies", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 5, kbBase = 24, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.7, size = 1.3, color = PAPER, visual = SHEET, fan = { count = 3, from = -8, to = 8 } },
					windup = { Root = { 6, -20, 0, 0, -0.2, 0.2 }, Waist = { 8, -26, 0 }, Neck = { 4, 16, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 0 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 100, 0, 6 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 36, 0, -34 }, LE = { 60, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, fx = { { "burst", color = SCANLIGHT, size = 2, at = "hand" }, { "symbols", symbols = { "COPIE", "COPIE", "COPIE" }, count = 3, radius = 2.5, at = "front", color = INK } }, text = "EN TROIS EXEMPLAIRES !", hitText = "FLAP FLAP !",
				},
				-- →L : copie conforme : une seule grande feuille certifiée part en flèche, traverse le couloir et oblige à patienter
				S_side = {
					label = "Copie certifiée conforme", kind = "projectile", startup = 0.26, active = 0, recovery = 0.5,
					damage = 15, kbBase = 32, kbGrowth = 60, kbAngle = 34,
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.8, size = 2.2, color = PAPER, pierce = true,
						visual = { shape = "block", size = 2, color = PAPER, spin = 4, parts = { { "block", Vector3.new(1.8, 0.05, 2.4), Vector3.new(0, 0, 0), PAPER }, { "ball", Vector3.new(0.7, 0.08, 0.7), Vector3.new(0.4, 0.05, 0.6), INK }, { "block", Vector3.new(1.2, 0.06, 0.15), Vector3.new(0, 0.05, -0.6), BLACK } } } },
					status = { name = "waiting", duration = 1.5 },
					windup = { Root = { 8, -30, 0, 0, -0.2, 0.25 }, Waist = { 10, -34, 0 }, Neck = { 6, 20, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -14, 20, 0, 0, -0.32, -0.4 }, Waist = { -16, 26, 0 }, Neck = { -4, -14, 0 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 6 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					follow = { Root = { -16, 24, 0, 0, -0.36, -0.46 }, Waist = { -20, 30, 0 }, Neck = { -6, -16, 0 }, RS = { 98, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 94, 0, 8 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					fx = { { "beam", color = SCANLIGHT, length = 12, width = 2, at = "hand" }, { "text", text = "CONFORME", color = INK } }, text = "CERTIFIÉ CONFORME.", hitText = "TAMPONNÉ À DISTANCE !",
				},
				-- ↓L : nuage de toner : il secoue la cartouche au-dessus du couloir, la poudre noire aveugle tout le monde
				S_down = {
					label = "Nuage de toner", startup = 0.22, active = 0.22, recovery = 0.45,
					damage = 12, hitbox = box(14, 5, 7, 0.8), kbBase = 18, kbGrowth = 30, kbAngle = 40,
					status = { name = "blinded", duration = 1.5 },
					windup = { Root = { 4, -10, 0, 0, -0.3, 0.1 }, Waist = { -8, -10, 0 }, Neck = { -14, 0, 0 }, RS = { 120, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -6, 10, 0, 0, -0.35, -0.15 }, Waist = { -18, 10, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 30 }, RE = { 40, 0, 0 }, RW = { 90, 0, 0 }, LS = { 150, 0, -30 }, LE = { 40, 0, 0 } },
					follow = { Root = { -6, -10, 0, 0, -0.35, -0.15 }, Waist = { -18, -10, 0 }, Neck = { -20, 0, 0 }, RS = { 140, 0, 40 }, RE = { 50, 0, 0 }, RW = { 90, 0, 0 }, LS = { 140, 0, -40 }, LE = { 50, 0, 0 } },
					wobble = true, trail = "prop", fx = { { "beam", color = BLACK, length = 14, width = 4, at = "head" }, { "particles", tex = "smoke", color = BLACK, dir = "front", at = "hand", time = 0.4, speed = 16, size = 1, rate = 80 }, { "symbols", symbols = { "☁️", "💨" }, count = 4, radius = 3, at = "front", color = GREY } },
					text = "RECHARGE DE TONER…", hitText = "NOIRCI !",
				},
				-- ↑L : bourrage explosif : la machine bourre, explose sous lui en pluie de feuilles et le propulse en diagonale
				S_up = {
					label = "Bourrage explosif", startup = 0.12, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 74, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 4, 0, 0, 0, -0.7, 0 }, Waist = { -12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 168, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 20, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 172, 0, 12 }, RE = { 10, 0, 0 }, RW = { -8, 0, 0 }, LS = { 156, 0, -64 }, LE = { 20, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					shake = true, trail = "prop", fx = { { "burst", color = PAPER, size = 3.5, at = "feet" }, { "toss", shape = "flat", color = PAPER, size = 0.8, count = 8, speed = 18 }, { "ring", color = SCANLIGHT, radius = 5, at = "feet" } },
					text = "BOURRAGE !!", hitText = "PROPULSÉ !",
				},
				-- L en l'air : rames lâchées : il renverse le bac, les feuilles tombent en pluie sur l'adversaire
				S_air = {
					label = "Rames lâchées", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 24, kbGrowth = 45, kbAngle = -40,
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.2, color = PAPER, visual = SHEET, rain = { count = 5, spread = 6 } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { 170, 0, 0 }, LS = { 30, 0, -10 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 26, 0, 12 }, RE = { 4, 0, 0 }, RW = { 175, 0, 0 }, LS = { 26, 0, -12 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					fx = { { "burst", color = PAPER, size = 2, at = "feet" } }, text = "500 FEUILLES !", hitText = "ENSEVELI !",
				},
				-- Y : mille exemplaires : il appuie sur « 1000 » et la machine crache un éventail de copies qui filent toutes sur l'adversaire
				SUPER = {
					label = "Mille exemplaires !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.6,
					damage = 4, kbBase = 25, kbGrowth = 40, kbAngle = 40,
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 1.0, size = 1.4, color = PAPER, visual = SHEET, fan = { count = 8, from = -20, to = 40 } },
					status = { name = "waiting", duration = 2 },
					windup = { Root = { 0, 0, 0, 0, -0.2, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 110, 0, 0 }, LW = { -60, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, -0.3, -0.3 }, Waist = { -12, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -5 }, LE = { 10, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, 0, 0, 0, -0.32, -0.34 }, Waist = { -14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 98, 0, 2 }, RE = { 4, 0, 0 }, RW = { -8, 0, 0 }, LS = { 92, 0, -8 }, LE = { 14, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					shake = true, windupFx = { "super", { "symbols", symbols = { "1000", "📄", "📄" }, count = 6, radius = 3, color = INK } }, fx = { { "burst", color = SCANLIGHT, size = 3, at = "hand" }, { "screen", color = SCANLIGHT, alpha = 0.2 } },
					text = "MILLE EXEMPLAIRES !", hitText = "FLAP FLAP FLAP !",
				},
				-- →Y : la copie géante : le bac s'élargit et crache une affiche A0 qui traverse tout le couloir comme un drap de papier
				SUPER_side = {
					label = "Copie géante !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.9, size = 3.4, color = PAPER, pierce = true,
						visual = { shape = "block", size = 3, color = PAPER, spin = 3, parts = { { "block", Vector3.new(3.2, 0.06, 3.6), Vector3.new(0, 0, 0), PAPER }, { "ball", Vector3.new(1.4, 0.1, 1.4), Vector3.new(0.6, 0.06, 0.8), INK }, { "block", Vector3.new(2, 0.08, 0.3), Vector3.new(0, 0.06, -1), BLACK } } } },
					windup = { Root = { 10, -30, 0, 0, -0.5, 0.3 }, Waist = { 14, -34, 0 }, Neck = { 10, 20, 0 }, RS = { 30, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 120, 0, 0 } },
					strike = { Root = { -18, 22, 0, 0, -0.3, -0.5 }, Waist = { -20, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 4 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 26, 0, 0, -0.34, -0.56 }, Waist = { -24, 32, 0 }, Neck = { -8, -18, 0 }, RS = { 100, 0, -4 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 96, 0, 6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					shake = true, windupFx = { "super", { "symbols", symbols = { "A0", "📄" }, count = 6, radius = 3, color = INK } }, fx = { { "burst", color = PAPER, size = 3.5, at = "hand" }, { "beam", color = SCANLIGHT, length = 14, width = 4, at = "hand" }, { "shake", amount = 0.4 } },
					text = "FORMAT A0 !", hitText = "APLATI SOUS L'AFFICHE !",
				},
				-- ↑Y : la tour de copies : la machine crache sans s'arrêter, la pile monte sous ses pieds et emporte tout le couloir au plafond
				SUPER_up = {
					label = "Tour de copies !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.9, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 70, 0, 70 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { 70, 0, -70 }, LE = { 20, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, windupFx = { "super", { "particles", tex = "spark", color = SCANLIGHT, dir = "all", at = "feet", time = 0.25, speed = 8 } },
					fx = { { "pillar", color = PAPER, height = 24, width = 4, at = "front" }, { "rain", shape = "flat", color = PAPER, count = 16, radius = 6, size = 0.9 }, { "burst", color = SCANLIGHT, size = 4, at = "above" }, { "ring", color = SCANLIGHT, radius = 6, at = "feet" } },
					text = "ENCORE UNE COPIE !", hitText = "EMPILÉ AU PLAFOND !",
				},
				-- ↓Y : le tapis de papier : il vide tous les bacs sur le sol du couloir, un tapis de feuilles glissantes où tout le monde dérape
				SUPER_down = {
					label = "Tapis de papier !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 60,
					status = { name = "slippery", duration = 2.5 },
					windup = { Root = { 12, 0, 0, 0, -0.5, 0.2 }, Waist = { 20, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 150, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -1.0, -0.3 }, Waist = { 28, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 0, 0, 0 }, RW = { 170, 0, 0 }, LS = { 40, 0, -60 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 20, 0, 0, 0, -1.0, -0.34 }, Waist = { 30, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 30, 0, 70 }, RE = { 0, 0, 0 }, RW = { 175, 0, 0 }, LS = { 30, 0, -70 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.15, windupFx = { "super" }, fx = { { "puddle", color = PAPER, width = 16 }, { "toss", shape = "flat", color = PAPER, size = 1.2, count = 10, speed = 24 }, { "beam", color = PAPER, length = 16, width = 4, at = "feet" }, { "shake", amount = 0.3 } },
					text = "TOUT LE BAC !", hitText = "GLISSÉ SUR LA PAPERASSE !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				K_side = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "machine_a_cafe", name = "Machine à café du couloir", icon = "☕",
			prop = { name = "PropMachine", hand = "Right", pieces = {
				{ "Poignee", "", "cyl", Vector3.new(0.7, 0.18, 0.18), Vector3.new(0, -0.15, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic", { axis = "x" } },
				{ "Corps", "", "block", Vector3.new(1.4, 2.2, 1.2), Vector3.new(0, -1.5, 0), Vector3.new(0, 0, 0), COPIER_DARK, "Metal" },
				{ "Facade", "", "block", Vector3.new(1.2, 1.0, 0.1), Vector3.new(0, -1.0, -0.62), Vector3.new(0, 0, 0), INK, "SmoothPlastic" },
				{ "Bouton", "", "ball", Vector3.new(0.25, 0.25, 0.15), Vector3.new(0.35, -0.8, -0.7), Vector3.new(0, 0, 0), SCANLIGHT, "Neon" },
				{ "Bec", "", "cyl", Vector3.new(0.5, 0.14, 0.14), Vector3.new(0, -1.9, -0.75), Vector3.new(0, 0, 0), SILVER_B, "Metal" },
				{ "Gobelet", "", "cyl", Vector3.new(0.5, 0.4, 0.4), Vector3.new(0, -2.35, -0.75), Vector3.new(0, 0, 0), CUP, "Plastic" },
			} },
			ability = { heal = 0.3, text = "30 % des dégâts le requinquent (c'est l'heure du café)" },
			moves = {
				-- J : coup de machine : il tend la lourde machine devant lui à bout de bras, lentement mais sûrement
				P_neutral = {
					label = "Coup de machine", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 3.5, 2.8, 0.5), kbBase = 24, kbGrowth = 30, kbAngle = 28,
					windup = { Root = { 4, -16, 0, 0, -0.15, 0.15 }, Waist = { 6, -20, 0 }, Neck = { -6, 12, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 14, 0, 0, -0.28, -0.3 }, Waist = { -12, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 96, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 18, 0, 0, -0.3, -0.36 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 100, 0, 6 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -8 }, LE = { 14, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", text = "*SOUPIR*", hitText = "BOUM.",
				},
				-- →J : giclée de café : il appuie sur le bouton, le bec crache un jet brûlant dans la figure
				P_side = {
					label = "Giclée de café", startup = 0.1, active = 0.12, recovery = 0.22,
					damage = 8, hitbox = box(6, 3, 3.5, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 22,
					windup = { Root = { 4, -10, 0, 0, -0.15, 0.1 }, Waist = { 6, -12, 0 }, Neck = { 0, 8, 0 }, RS = { 70, 0, 20 }, RE = { 100, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -8, 8, 0, 0, -0.25, -0.3 }, Waist = { -10, 10, 0 }, Neck = { 0, -6, 0 }, RS = { 90, 0, 0 }, RE = { 20, 0, 0 }, RW = { 80, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, 10, 0, 0, -0.28, -0.34 }, Waist = { -12, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 92, 0, 0 }, RE = { 20, 0, 0 }, RW = { 82, 0, 0 }, LS = { 72, 0, -22 }, LE = { 90, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					fx = { { "particles", tex = "smoke", color = COFFEE, dir = "front", at = "hand", time = 0.25, speed = 16, size = 0.5, rate = 70 }, { "burst", color = COFFEE, size = 1.5, at = "front" } }, text = "PSCHHH…", hitText = "ÉBOUILLANTÉ !",
				},
				-- ↓J : accroupi, il pose la machine de tout son poids sur les orteils, puis se redresse en soufflant
				P_down = {
					label = "Machine sur les orteils", startup = 0.12, active = 0.1, recovery = 0.26,
					damage = 8, hitbox = box(5, 2, 3, -1.8), kbBase = 26, kbGrowth = 30, kbAngle = 75,
					windup = { Root = { 8, 0, 0, 0, -0.5, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 140, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { 16, 0, 0, 0, -0.95, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 18, 0, 0, 0, -0.95, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 44, 0, -32 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { "dust" }, text = "OUF.", hitText = "ÉCRASÉ !",
				},
				-- ↑J : jet de vapeur : il retourne la machine, la buse de vapeur siffle vers le plafond et soulève ce qui passe
				P_up = {
					label = "Jet de vapeur", startup = 0.1, active = 0.12, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 5.5, 1.5, 3.2), kbBase = 26, kbGrowth = 40, kbAngle = 86,
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, 0.1, -0.1 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 170, 0, 0 }, LS = { 60, 0, -30 }, LE = { 80, 0, 0 } },
					follow = { Root = { -12, 0, 0, 0, 0.12, -0.12 }, Waist = { -16, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 178, 0, 12 }, RE = { 10, 0, 0 }, RW = { 175, 0, 0 }, LS = { 64, 0, -32 }, LE = { 80, 0, 0 } },
					fx = { { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "up", at = "hand", time = 0.3, speed = 16, size = 0.7, rate = 70 } }, text = "PSSSSHT !", hitText = "VAPORISÉ !",
				},
				-- J en l'air : la machine serrée contre le ventre, il la pousse d'un coup sous lui
				P_air = {
					label = "Machine plongeante", startup = 0.1, active = 0.12, recovery = 0.18,
					damage = 9, hitbox = box(4.5, 4, 1.5, -1.4), kbBase = 22, kbGrowth = 38, kbAngle = -45,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -5 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 24, 0, 5 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 24, 0, -5 }, LE = { 6, 0, 0 }, RH = { 5, 0, 0 }, RK = { -25, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash J : le chariot de la pause : il pousse la machine devant lui comme un chariot, tête baissée vers la salle de pause
				P_dash = {
					label = "Chariot de pause", startup = 0.1, active = 0.16, recovery = 0.28,
					damage = 9, hitbox = box(5.5, 4, 3, 0.6), kbBase = 30, kbGrowth = 54, kbAngle = 24, selfVelocity = Vector2.new(38, 0),
					windup = { Root = { -8, 0, 0, 0, -0.3, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 15 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -15 }, LE = { 100, 0, 0 } },
					strike = { Root = { -24, 0, 0, 0, -0.42, -0.3 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 94, 0, 6 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -6 }, LE = { 6, 0, 0 } },
					follow = { Root = { -26, 0, 0, 0, -0.44, -0.35 }, Waist = { -16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 96, 0, 8 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 96, 0, -8 }, LE = { 6, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 5 } }, text = "C'EST LA PAUSE.", hitText = "RENVERSÉ !",
				},
				-- K : coup de pied dans la machine qui ne rend pas la monnaie, elle crache un gobelet
				K_neutral = {
					label = "Rends la monnaie !", startup = 0.2, active = 0.12, recovery = 0.34,
					damage = 13, hitbox = box(6, 3.5, 3.5, 0.2), kbBase = 32, kbGrowth = 74, kbAngle = 30,
					windup = { Root = { 8, -8, 0, 0, -0.3, 0.15 }, Waist = { 8, -6, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { -30, 0, 0 }, RK = { -70, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.15, 0.05 }, Waist = { 12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 30, 0, 0 }, RH = { 94, 0, 0 }, RK = { -4, 0, 0 }, RA = { 14, 0, 0 } },
					follow = { Root = { 14, 0, 0, 0, -0.15, 0.1 }, Waist = { 14, 0, 0 }, Neck = { -2, 0, 0 }, RS = { 22, 0, 52 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -54 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 } },
					trail = "rightFoot", fx = { { "toss", shape = "cyl", color = CUP, size = 0.5, count = 2, speed = 16 } }, text = "RENDS LA MONNAIE !", hitText = "BONK !",
				},
				-- →K : balançoire à café : grand revers de la machine tenue à deux mains, il pivote tout le corps
				K_side = {
					label = "Balançoire à café", startup = 0.2, active = 0.14, recovery = 0.36,
					damage = 14, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 34, kbGrowth = 80, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 6, 44, 0, 0, -0.25, 0.2 }, Waist = { 8, 50, 0 }, Neck = { -4, -32, 0 }, RS = { 70, 0, 70 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 50, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 92, 0, -30 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -60 }, LE = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -44, 0, 0, -0.32, -0.4 }, Waist = { -12, -50, 0 }, Neck = { 0, 30, 0 }, RS = { 96, 0, -40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { { "toss", shape = "ball", color = COFFEE, size = 0.5, count = 4, speed = 14 } }, hitText = "BAOUM !",
				},
				-- ↓K : marc de café : accroupi, il vide le bac à marc devant lui d'un coup de pied, boue noire dans les tibias
				K_down = {
					label = "Marc de café", startup = 0.17, active = 0.14, recovery = 0.32,
					damage = 12, hitbox = box(7, 2, 3.5, -1.6), kbBase = 30, kbGrowth = 62, kbAngle = 70,
					windup = { Root = { -4, -16, 0, 0, -0.6, 0.15 }, Waist = { -10, -12, 0 }, Neck = { 10, 10, 0 }, RS = { 60, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -35 }, LE = { 60, 0, 0 }, RH = { -20, 0, 10 }, RK = { -70, 0, 0 } },
					strike = { Root = { -8, 14, 0, 0, -0.75, -0.15 }, Waist = { -16, 12, 0 }, Neck = { 12, -8, 0 }, RS = { 40, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 50, 0, 0 }, RH = { 55, 0, 6 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { -9, 18, 0, 0, -0.75, -0.18 }, Waist = { -17, 14, 0 }, Neck = { 12, -10, 0 }, RS = { 38, 0, 22 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 62, 0, -30 }, LE = { 50, 0, 0 }, RH = { 58, 0, 2 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
					trail = "rightFoot", fx = { { "puddle", color = COFFEE, width = 5 }, { "particles", tex = "smoke", color = COFFEE, dir = "front", at = "feet", time = 0.25, speed = 8, size = 0.5 } }, hitText = "SPLOTCH !",
				},
				-- ↑K : percolateur : il cabre la machine d'un coup de genou, le percolateur siffle et soulève l'adversaire
				K_up = {
					label = "Percolateur", startup = 0.18, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(4.5, 5.5, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88,
					windup = { Root = { 8, 0, 0, 0, -0.35, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.05, -0.1 }, Waist = { -18, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -10 }, LE = { 10, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.08, -0.12 }, Waist = { -20, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 166, 0, -12 }, LE = { 10, 0, 0 }, RH = { 116, 0, 0 }, RK = { -124, 0, 0 }, RA = { -20, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "up", at = "hand", time = 0.3, speed = 14, size = 0.6 } }, text = "PSSSHT !", hitText = "PERCOLÉ !",
				},
				-- K en l'air : gobelet écrasé : il abat la machine sous lui comme une enclume, jambes repliées
				K_air = {
					label = "Enclume à café", startup = 0.16, active = 0.14, recovery = 0.26,
					damage = 13, hitbox = box(5, 4, 2, -1.2), kbBase = 30, kbGrowth = 70, kbAngle = -55,
					windup = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 190, 0, 12 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -12 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -20, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -6 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -24, 0, 0 }, Waist = { -36, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, 6 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 40, 0, -6 }, LE = { 6, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "BADABOUM !",
				},
				-- dash K : glissade de pause : il glisse sur une flaque de café, assis, la machine sur les genoux, pieds en avant
				K_dash = {
					label = "Glissade sur le café", startup = 0.1, active = 0.26, recovery = 0.32,
					damage = 12, hitbox = box(6, 3, 3, -0.8), kbBase = 30, kbGrowth = 64, kbAngle = 38, selfVelocity = Vector2.new(50, 8),
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 } },
					strike = { Root = { 20, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 24, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, RS = { 62, 0, 12 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 62, 0, -12 }, LE = { 100, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "bothFeet", fx = { { "puddle", color = COFFEE, width = 6 } }, text = "GRIIIN…", hitText = "DÉRAPÉ !",
				},
				-- L : jet de café brûlant : le bec crache une giclée longue comme le couloir, droit sur l'adversaire (brûle)
				S_neutral = {
					label = "Jet de café brûlant", kind = "projectile", startup = 0.24, active = 0, recovery = 0.45,
					damage = 13, kbBase = 26, kbGrowth = 45, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.7, size = 1.8, color = COFFEE, visual = "water", hits = 2 },
					status = { name = "burning", duration = 1.5 },
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.15 }, Waist = { 8, -12, 0 }, Neck = { 4, 8, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 10, 0, 0, -0.3, -0.35 }, Waist = { -14, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 94, 0, 0 }, RE = { 10, 0, 0 }, RW = { 90, 0, 0 }, LS = { 80, 0, -20 }, LE = { 80, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 12, 0, 0, -0.32, -0.4 }, Waist = { -16, 14, 0 }, Neck = { 0, -10, 0 }, RS = { 96, 0, 2 }, RE = { 10, 0, 0 }, RW = { 92, 0, 0 }, LS = { 82, 0, -22 }, LE = { 80, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, fx = { { "beam", color = COFFEE, length = 12, width = 2, at = "hand" }, { "particles", tex = "smoke", color = COFFEE, dir = "front", at = "hand", time = 0.3, speed = 20, size = 0.6, rate = 80 } }, text = "UN GRAND NOIR !", hitText = "ÉBOUILLANTÉ !",
				},
				-- →L : la machine lancée à bout de bras à travers tout le couloir, il encaisse tout pendant l'effort
				S_side = {
					label = "Machine en avant", startup = 0.28, active = 0.18, recovery = 0.55,
					damage = 16, hitbox = box(14, 5, 7, 0.8), kbBase = 38, kbGrowth = 82, kbAngle = 26, armor = true, selfVelocity = Vector2.new(20, 0),
					windup = { Root = { 10, -20, 0, 0, -0.3, 0.3 }, Waist = { 14, -24, 0 }, Neck = { 10, 16, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -18, 14, 0, 0, -0.4, -0.5 }, Waist = { -22, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 16, 0, 0, -0.44, -0.55 }, Waist = { -26, 20, 0 }, Neck = { -8, -12, 0 }, RS = { 100, 0, 2 }, RE = { 4, 0, 0 }, RW = { -8, 0, 0 }, LS = { 96, 0, -6 }, LE = { 4, 0, 0 }, LW = { -8, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hold = 0.1, shake = true, trail = "prop", fx = { { "burst", color = COPIER_DARK, size = 3.5, at = "front" }, { "beam", color = COFFEE, length = 14, width = 3, at = "feet" }, { "shake", amount = 0.4 } },
					text = "ELLE PÈSE UNE TONNE !", hitText = "ÉCRASÉ PAR LA MACHINE !",
				},
				-- ↓L : flaque de café : il penche la machine et vide le réservoir sur le sol : tout le couloir patine dans le café
				S_down = {
					label = "Flaque de café", startup = 0.22, active = 0.2, recovery = 0.5,
					damage = 12, hitbox = box(14, 4, 7, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 60,
					status = { name = "slippery", duration = 2.5 },
					windup = { Root = { 6, -10, 0, 0, -0.15, 0.1 }, Waist = { 10, -10, 0 }, Neck = { 14, 0, 0 }, RS = { 110, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -10, 8, 0, 0, -0.3, -0.25 }, Waist = { -16, 8, 0 }, Neck = { -10, 0, 0 }, RS = { 100, 0, 15 }, RE = { 10, 0, 0 }, RW = { 0, 0, 90 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 10, 0, 0, -0.32, -0.3 }, Waist = { -18, 10, 0 }, Neck = { -12, 0, 0 }, RS = { 70, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 100 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					hold = 0.1, trail = "prop", fx = { { "puddle", color = COFFEE, width = 14 }, { "beam", color = COFFEE, length = 14, width = 2.5, at = "feet" } }, text = "OUPS, LE RÉSERVOIR.", hitText = "ÇA GLISSE !",
				},
				-- ↑L : décollage à la caféine : il boit un gobelet cul sec, les yeux s'écarquillent et il décolle en diagonale, machine brandie
				S_up = {
					label = "Décollage à la caféine", startup = 0.14, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 74, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.6, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -20 }, LE = { 140, 0, 0 }, LW = { -30, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 174, 0, 12 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -35, 0, -44 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					shake = true, trail = "prop", windupFx = { { "symbols", symbols = { "☕", "!!" }, count = 2, radius = 1.5, at = "head", color = COFFEE } },
					fx = { { "burst", color = COFFEE, size = 3, at = "feet" }, { "ring", color = CUP, radius = 5, at = "feet" }, { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "down", at = "feet", time = 0.35, speed = 14 } },
					text = "CUL SEC !", hitText = "RÉVEILLÉ !",
				},
				-- L en l'air : gobelets lâchés : il renverse le distributeur, une pluie de gobelets pleins tombe sur l'adversaire
				S_air = {
					label = "Pluie de gobelets", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 24, kbGrowth = 45, kbAngle = -40,
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.2, color = CUP, rain = { count = 4, spread = 6 },
						visual = { shape = "cyl", size = 1, color = CUP, spin = 6, parts = { { "cyl", Vector3.new(0.6, 0.1, 0.6), Vector3.new(0, 0.5, 0), COFFEE } } } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { 170, 0, 0 }, LS = { 30, 0, -10 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 26, 0, 12 }, RE = { 4, 0, 0 }, RW = { 175, 0, 0 }, LS = { 26, 0, -12 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					fx = { { "burst", color = COFFEE, size = 2, at = "feet" } }, text = "TOURNÉE GÉNÉRALE !", hitText = "PLOC !",
				},
				-- Y : tournée de décaféiné : il sert un décaféiné à tout le couloir, tout le monde s'endort sur place (lui se requinque)
				SUPER = {
					label = "Tournée de décaféiné !", startup = 0.45, active = 0.25, recovery = 0.7,
					damage = 22, hitbox = box(16, 6, 8, 1), kbBase = 20, kbGrowth = 30, kbAngle = 40, selfEffect = { heal = 10 },
					status = { name = "asleep", duration = 2.5 },
					windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 130, 0, 30 }, LE = { 140, 0, 0 }, LW = { -30, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, -0.3, -0.35 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 94, 0, 0 }, RE = { 10, 0, 0 }, RW = { 90, 0, 0 }, LS = { 90, 0, 40 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 0, 0, 0, -0.32, -0.4 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 96, 0, 2 }, RE = { 10, 0, 0 }, RW = { 92, 0, 0 }, LS = { 94, 0, 44 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.3, windupFx = { "super", { "symbols", symbols = { "☕", "💤" }, count = 6, radius = 3, color = COFFEE } },
					fx = { { "beam", color = COFFEE, length = 16, width = 4, at = "hand" }, { "toss", shape = "cyl", color = CUP, size = 0.6, count = 8, speed = 22 }, { "symbols", symbols = { "💤", "zzz", "💤" }, count = 8, radius = 6, at = "front", color = GREY } },
					text = "C'EST DU DÉCA.", hitText = "ENDORMI !",
				},
				-- →Y : l'expresso balistique : la machine se met à vibrer, surchauffe et tire un gobelet géant qui traverse tout le couloir
				SUPER_side = {
					label = "Expresso balistique !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 92, angle = 0, gravity = 0, lifetime = 0.9, size = 3.2, color = CUP, pierce = true,
						visual = { shape = "cyl", size = 2.8, color = CUP, spin = 10, parts = { { "cyl", Vector3.new(2.6, 0.2, 2.6), Vector3.new(0, 1.3, 0), COFFEE }, { "block", Vector3.new(0.4, 1.2, 0.3), Vector3.new(1.5, 0, 0), CUP } } } },
					status = { name = "burning", duration = 2 },
					windup = { Root = { 10, -20, 0, 0, -0.4, 0.3 }, Waist = { 14, -24, 0 }, Neck = { 10, 14, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 } },
					strike = { Root = { -18, 14, 0, 0, -0.3, -0.5 }, Waist = { -20, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 4 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { 4, 16, 0, 0, -0.2, -0.2 }, Waist = { 6, 20, 0 }, Neck = { 4, -12, 0 }, RS = { 120, 0, 10 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { 116, 0, -10 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					shake = true, windupFx = { "super", { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "up", at = "hand", time = 0.4, speed = 8 } },
					fx = { { "burst", color = COFFEE, size = 3.5, at = "hand" }, { "beam", color = COFFEE, length = 14, width = 4, at = "hand" }, { "shake", amount = 0.4 } },
					text = "SERRÉ, TRÈS SERRÉ !", hitText = "KA-BLONG !",
				},
				-- ↑Y : le geyser de café : la chaudière explose sous lui, un geyser brun le propulse et emporte tout le couloir au plafond
				SUPER_up = {
					label = "Geyser de café !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.9, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 156, 0, -66 }, LE = { 10, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super", { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "all", at = "hand", time = 0.3, speed = 6 } },
					fx = { { "pillar", color = COFFEE, height = 22, width = 3, at = "front" }, { "beam", color = COFFEE, length = 16, width = 5, at = "feet" }, { "burst", color = CUP, size = 4, at = "above" }, { "ring", color = COFFEE, radius = 6, at = "feet" } },
					text = "LA CHAUDIÈRE !", hitText = "GEYSER !",
				},
				-- ↓Y : marc de café géant : il renverse la machine entière, une coulée de marc enlise tout le couloir
				SUPER_down = {
					label = "Coulée de marc !", startup = 0.35, active = 0.35, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 60,
					status = { name = "slowed", duration = 2.5 },
					windup = { Root = { 12, 0, 0, 0, -0.5, 0.2 }, Waist = { 20, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 160, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -1.0, -0.3 }, Waist = { 28, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 120 }, LS = { 30, 0, -20 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 20, 0, 0, 0, -1.0, -0.34 }, Waist = { 30, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 24, 0, 22 }, RE = { 0, 0, 0 }, RW = { 0, 0, 130 }, LS = { 24, 0, -22 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.15, trail = "prop", windupFx = { "super" }, fx = { { "puddle", color = COFFEE, width = 16 }, { "beam", color = COFFEE, length = 16, width = 4, at = "feet" }, { "particles", tex = "smoke", color = COFFEE, dir = "front", at = "feet", time = 0.5, speed = 14, size = 1 }, { "shake", amount = 0.4 } },
					text = "TOUT LE MARC !", hitText = "ENLISÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

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
			damage = 7, hitbox = box(5, 5, 2.5, 3), kbBase = 26, kbGrowth = 32, kbAngle = 85,
			windup = { Root = { -6, 10, 0, 0, -0.5, 0.05 }, Waist = { -14, 10, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 }, LS = { -20, 0, -15 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, -10, 0, 0, 0.2, 0 }, Waist = { 14, -14, 0 }, Neck = { 28, 0, 0 }, RS = { 15, 0, 30 }, RE = { 50, 0, 0 }, LS = { 168, 0, 0 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, -12, 0, 0, 0.25, 0 }, Waist = { 16, -16, 0 }, Neck = { 32, 0, 0 }, RS = { 15, 0, 30 }, RE = { 50, 0, 0 }, LS = { 176, 0, -6 }, LE = { 12, 0, 0 }, LW = { -10, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "mug", trail = "leftHand", text = "SUIVANT !", hitText = "AU SUIVANT !",
		},
		-- Tampon aérien : en l'air, il tamponne à l'horizontale devant lui à bout de bras, jambes fléchies comme assis sur sa chaise
		P_air = {
			label = "Tampon aérien", startup = 0.1, active = 0.12, recovery = 0.18,
			damage = 8, hitbox = box(5, 4, 3, 0.3), kbBase = 24, kbGrowth = 40, kbAngle = 22,
			windup = { Root = { 4, -25, 0 }, Waist = { 6, -28, 0 }, Neck = { 0, 20, 0 }, RS = { 60, 0, 40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, RH = { 80, 0, 0 }, RK = { -90, 0, 0 }, LH = { 80, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -8, 18, 0 }, Waist = { -8, 22, 0 }, Neck = { 0, -14, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, RH = { 85, 0, 0 }, RK = { -85, 0, 0 }, LH = { 85, 0, 0 }, LK = { -85, 0, 0 } },
			follow = { Root = { -10, 22, 0 }, Waist = { -10, 26, 0 }, Neck = { 0, -16, 0 }, RS = { 98, 0, -10 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 15, 0, -42 }, LE = { 60, 0, 0 }, RH = { 85, 0, 0 }, RK = { -85, 0, 0 }, LH = { 85, 0, 0 }, LK = { -85, 0, 0 } },
			trail = "prop", fx = { { "burst", color = INK, size = 2, at = "front" } }, hitText = "CHTONK !",
		},
		-- Ruée de 17 h (dash puis P) : c'est l'heure de la sortie, il fonce vers la porte le classeur brandi devant lui comme un bouclier
		P_dash = {
			label = "Ruée de 17 h", startup = 0.08, active = 0.15, recovery = 0.25,
			damage = 8, hitbox = box(5.5, 4, 2.8, 0.6), kbBase = 28, kbGrowth = 52, kbAngle = 25, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -8, 0, 0, 0, -0.25, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 25 }, RE = { 60, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, -0.35, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 70, 0, 10 }, RE = { 90, 0, 0 }, LS = { 95, 0, 0 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -24, 0, 0, 0, -0.38, -0.35 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 72, 0, 12 }, RE = { 90, 0, 0 }, LS = { 97, 0, -2 }, LE = { 18, 0, 0 }, LW = { -8, 0, 0 } },
			prop = "classeur", trail = "leftHand", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 5 } }, text = "17 H, J'Y VAIS !", hitText = "POUSSEZ-VOUS !",
		},

		-- Suites d'enchaînement (voir LINKS) : P P, P P P…
		-- P P : Coup d'agrafeuse, il agrafe l'adversaire d'un revers du gauche
		P_combo2 = {
			label = "Coup d'agrafeuse", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { -4, -20, 0, 0, -0.2, -0.2 }, Waist = { -6, -30, 0 }, Neck = { 0, 15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 70, 0, 40 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, 15, 0, 0, -0.22, -0.28 }, Waist = { -8, 22, 0 }, Neck = { 0, -12, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 90, 0, -45 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -6, 20, 0, 0, -0.22, -0.3 }, Waist = { -8, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 86, 0, -65 }, LE = { 25, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "agrafeuse", trail = "leftHand", hitText = "CLAC-CLAC !",
		},
		-- P P P : Coup de tampon, il lève le tampon bien haut et l'abat sur le crâne : « TAMPONNÉ »
		P_combo3 = {
			label = "Coup de tampon", startup = 0.1, active = 0.1, recovery = 0.3,
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
		-- Plongeon de dossier : en l'air, il pique du nez bras chargés d'archives et percute l'adversaire de toute la pile
		K_air = {
			label = "Plongeon de dossier", startup = 0.16, active = 0.16, recovery = 0.26,
			damage = 12, hitbox = box(5.5, 4, 3, -0.5), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, -20 }, RE = { 70, 0, 0 }, LS = { 120, 0, 20 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -45, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 100, 0, -20 }, RE = { 30, 0, 0 }, LS = { 100, 0, 20 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { -10, 0, 0 }, RK = { -20, 0, 0 }, LH = { -5, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { -52, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 95, 0, -22 }, RE = { 30, 0, 0 }, LS = { 95, 0, 22 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { -8, 0, 0 }, LK = { -35, 0, 0 } },
			prop = "dossiers", trail = "body", fx = { { "toss", shape = "flat", color = PAPER, size = 0.8, count = 5, speed = 14 } }, text = "ARCHIVES !", hitText = "ENSEVELI !",
		},
		-- Plongeon par-dessus le guichet (dash puis K) : il passe par-dessus son guichet à plat ventre, cravate au vent, et glisse sur le carrelage
		K_dash = {
			label = "Plongeon par-dessus le guichet", startup = 0.1, active = 0.25, recovery = 0.32,
			damage = 11, hitbox = box(6, 3, 3.5, -0.5), kbBase = 30, kbGrowth = 62, kbAngle = 45, selfVelocity = Vector2.new(50, 8),
			windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, 25 }, RE = { 40, 0, 0 }, LS = { 120, 0, -25 }, LE = { 40, 0, 0 } },
			strike = { Root = { -75, 0, 0, 0, -1.3, -0.3 }, Waist = { -8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -10, 0, 4 }, RK = { -15, 0, 0 }, LH = { -10, 0, -4 }, LK = { -25, 0, 0 } },
			follow = { Root = { -80, 0, 0, 0, -1.35, -0.35 }, Waist = { -10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 16 }, RE = { 0, 0, 0 }, LS = { 180, 0, -16 }, LE = { 0, 0, 0 }, RH = { -14, 0, 5 }, RK = { -30, 0, 0 }, LH = { -6, 0, -5 }, LK = { -15, 0, 0 } },
			trail = "body", fx = { { "particles", tex = "spark", color = Color3.fromRGB(240, 220, 160), dir = "up", at = "feet", time = 0.3, speed = 5 }, { "toss", shape = "flat", color = PAPER, size = 0.8, count = 4, speed = 14 } }, text = "PAR-DESSUS LE GUICHET !", hitText = "ÉCRASÉ DE PAPERASSE !",
		},

		-- K K : Coup de pied en regardant sa montre, talon droit tendu de côté pendant qu'il vérifie l'heure de la pause
		K_combo2 = {
			label = "Coup de pied en regardant sa montre", startup = 0.1, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(5.5, 3.5, 3, 0.5), kbBase = 28, kbGrowth = 48, kbAngle = 30,
			windup = { Root = { 2, 15, 0, 0, -0.15, 0.1 }, Waist = { 2, 10, 0 }, Neck = { -22, 24, 0 }, RS = { 15, 0, 25 }, RE = { 40, 0, 0 }, LS = { 80, 0, 30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RH = { 30, 0, 20 }, RK = { -100, 0, 0 } },
			strike = { Root = { -4, 30, 0, 0, -0.15, -0.2 }, Waist = { -4, 20, 0 }, Neck = { -24, 30, 0 }, RS = { 10, 0, 30 }, RE = { 40, 0, 0 }, LS = { 82, 0, 30 }, LE = { 112, 0, 0 }, LW = { 0, 0, 0 }, RH = { 88, 0, 30 }, RK = { -4, 0, 0 }, RA = { 12, 0, 0 } },
			follow = { Root = { -4, 36, 0, 0, -0.15, -0.22 }, Waist = { -4, 24, 0 }, Neck = { -24, 32, 0 }, RS = { 8, 0, 32 }, RE = { 40, 0, 0 }, LS = { 82, 0, 30 }, LE = { 112, 0, 0 }, LW = { 0, 0, 0 }, RH = { 92, 0, 32 }, RK = { 0, 0, 0 }, RA = { 12, 0, 0 } },
			trail = "rightFoot", fx = { { "symbols", symbols = { "⌚", "16 H 58…" }, count = 2, radius = 1.5, at = "head", color = PAPER } }, text = "BIENTÔT LA PAUSE…", hitText = "VLAN.",
		},
		-- K K K : Coup de pied de fin de service, grand coup de pied haut qui expédie l'adversaire (fait décoller)
		K_combo3 = {
			label = "Coup de pied de fin de service", startup = 0.1, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(4.5, 4.5, 2.5, 1.5), kbBase = 34, kbGrowth = 80, kbAngle = 72,
			windup = { Root = { -8, 0, 0, 0, -0.4, 0.15 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -110, 0, 0 } },
			strike = { Root = { 22, 0, 0, 0, -0.15, -0.2 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -30, 0, 65 }, RE = { 15, 0, 0 }, LS = { -30, 0, -65 }, LE = { 15, 0, 0 }, RH = { 140, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 26, 0, 0, 0, -0.15, -0.22 }, Waist = { 14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { -38, 0, 70 }, RE = { 15, 0, 0 }, LS = { -38, 0, -70 }, LE = { 15, 0, 0 }, RH = { 150, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", text = "LE SERVICE EST FERMÉ !", hitText = "BAM !",
		},
		-- P puis K : Genou syndical, petit coup de genou en se rajustant la cravate
		PK_combo = {
			label = "Genou syndical", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 2.5, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 40,
			windup = { Root = { 4, -6, 0, 0, -0.2, 0.1 }, Waist = { 4, -6, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 90, 0, 20 }, LE = { 140, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, 0, -0.3 }, Waist = { -8, 4, 0 }, Neck = { -10, 0, 0 }, RS = { -10, 0, 40 }, RE = { 50, 0, 0 }, LS = { 95, 0, 25 }, LE = { 145, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -11, 6, 0, 0, 0.02, -0.32 }, Waist = { -9, 4, 0 }, Neck = { -10, 0, 0 }, RS = { -12, 0, 42 }, RE = { 50, 0, 0 }, LS = { 95, 0, 25 }, LE = { 145, 0, 0 }, RH = { 104, 0, 0 }, RK = { -122, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightLeg", hitText = "GNOC !",
		},
		-- K puis P : Coup de dossier, il frappe avec une pile de dossiers tenue du bras gauche
		KP_combo = {
			label = "Coup de dossier", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 7, hitbox = box(5, 3.5, 2.5, 0.6), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, 25, 0, 0, -0.2, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 0, -15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 70, 0, -70 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.25, -0.3 }, Waist = { -8, -32, 0 }, Neck = { 0, 15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 95, 0, -5 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -9, -26, 0, 0, -0.25, -0.33 }, Waist = { -9, -40, 0 }, Neck = { 0, 20, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 90, 0, 20 }, LE = { 35, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "dossiers", trail = "leftHand", fx = { { "particles", tex = "smoke", color = PAPER, dir = "all", at = "lhand", time = 0.2, speed = 6 } }, hitText = "PAPERASSE !",
		},

		-- → P P : Re-classé, revers du classeur dans l'autre sens, sans décoller les yeux de sa montre
		P_side2 = {
			label = "Re-classé", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(5.5, 3.5, 3, 0.6), kbBase = 20, kbGrowth = 30, kbAngle = 22, selfVelocity = Vector2.new(10, 0),
			windup = { Root = { -4, 25, 0, 0, -0.25, -0.2 }, Waist = { -6, 30, 0 }, Neck = { -20, 10, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 70, 0, 40 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -18, 0, 0, -0.3, -0.4 }, Waist = { -10, -26, 0 }, Neck = { -20, 14, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 95, 0, -40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -8, -26, 0, 0, -0.3, -0.45 }, Waist = { -10, -34, 0 }, Neck = { -20, 18, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 88, 0, -65 }, LE = { 10, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "classeur", trail = "leftHand", text = "ET RE-CLASSÉ.", hitText = "CLAC !",
		},
		-- → P P P : Classeur en vrille, il tourne deux fois sur lui-même classeur tendu, les feuilles volent partout (finition)
		P_side3 = {
			label = "Classeur en vrille", startup = 0.1, active = 0.2, recovery = 0.34,
			damage = 10, hitbox = box(7, 4, 2.5, 0.8), kbBase = 34, kbGrowth = 76, kbAngle = 38,
			windup = { Root = { 0, -35, 0, 0, -0.3, 0 }, Waist = { -4, -25, 0 }, Neck = { -6, 20, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 60, 0, -70 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -4, 0, 0, 0, -0.2, 0 }, Waist = { -6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.2, 0 }, Waist = { -6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 62, 0, 75 }, RE = { 20, 0, 0 }, LS = { 92, 0, -90 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, prop = "classeur", trail = "leftHand", fx = { { "toss", shape = "flat", color = PAPER, size = 0.9, count = 8, speed = 20 }, { "burst", color = OFFICE_GREEN, size = 3, at = "front" } },
			text = "CLASSEMENT VERTICAL !", hitText = "ARCHIVÉ !",
		},
		-- ↓ P P : Trombone déplié, le trombone se déplie encore et pique deux fois les chevilles, en tremblotant d'ennui
		P_down2 = {
			label = "Trombone déplié", startup = 0.07, active = 0.16, recovery = 0.2,
			damage = 3, hits = 2, hitbox = box(6.5, 3.5, 3.4, -0.6), kbBase = 20, kbGrowth = 24, kbAngle = 65,
			windup = { Root = { -8, -15, 0, 0, -0.8, 0.1 }, Waist = { -14, -16, 0 }, Neck = { 6, 12, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, 18, 0, 0, -0.85, -0.3 }, Waist = { -20, 22, 0 }, Neck = { 10, -12, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 62, 0, 8 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -14, 22, 0, 0, -0.85, -0.35 }, Waist = { -20, 26, 0 }, Neck = { 10, -14, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 58, 0, 12 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 } },
			wobble = true, prop = "trombone", trail = "leftHand", text = "PIC. PIC.", hitText = "PIQUÉ PIQUÉ !",
		},
		-- ↓ P P P : Chaise dans les tibias, il sort sa chaise de bureau et l'envoie rouler dans les jambes (finition)
		P_down3 = {
			label = "Chaise dans les tibias", startup = 0.1, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(7, 4, 3.5, -0.4), kbBase = 34, kbGrowth = 72, kbAngle = 70, selfVelocity = Vector2.new(10, 0),
			windup = { Root = { -6, -20, 0, 0, -0.55, 0.15 }, Waist = { -12, -20, 0 }, Neck = { 6, 15, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 120, 0, -30 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, 20, 0, 0, -0.8, -0.35 }, Waist = { -24, 22, 0 }, Neck = { 12, -14, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 70, 0, 5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -12, 24, 0, 0, -0.75, -0.4 }, Waist = { -22, 26, 0 }, Neck = { 12, -16, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 40, 0, 10 }, LE = { 30, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			prop = "chaise", trail = "leftHand", fx = { { "particles", tex = "spark", color = Color3.fromRGB(240, 220, 160), dir = "front", at = "feet", time = 0.3, speed = 8 }, { "burst", color = GREY, size = 2.5, at = "front" } },
			text = "GRIIIIN…", hitText = "ROULÉ DESSUS !",
		},
		-- → K K : Agrafe du pied gauche, deuxième coup de pied, l'autre jambe, toujours aussi peu motivé
		K_side2 = {
			label = "Agrafe du pied gauche", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5.5, 3.5, 3, 0.2), kbBase = 24, kbGrowth = 40, kbAngle = 28, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 6, 10, 0, 0, -0.15, 0.15 }, Waist = { 6, 8, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 30 }, RE = { 70, 0, 0 }, LS = { 30, 0, -35 }, LE = { 60, 0, 0 }, LH = { 110, 0, 0 }, LK = { -125, 0, 0 }, LA = { -20, 0, 0 } },
			strike = { Root = { -6, -5, 0, 0, -0.2, -0.3 }, Waist = { -8, -5, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 50 }, RE = { 30, 0, 0 }, LS = { 50, 0, -50 }, LE = { 30, 0, 0 }, LH = { 72, 0, 0 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { -8, -6, 0, 0, -0.2, -0.35 }, Waist = { -10, -6, 0 }, Neck = { -8, 0, 0 }, RS = { 52, 0, 55 }, RE = { 30, 0, 0 }, LS = { 52, 0, -55 }, LE = { 30, 0, 0 }, LH = { 62, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "leftFoot", text = "CLAC.", hitText = "RE-AGRAFÉ !",
		},
		-- → K K K : Mug en pleine poire, le mug « Vivement vendredi » part en grand crochet, le café avec (finition)
		K_side3 = {
			label = "Mug en pleine poire", startup = 0.1, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(6, 4, 3, 1), kbBase = 36, kbGrowth = 82, kbAngle = 40, selfVelocity = Vector2.new(14, 0),
			windup = { Root = { 4, 35, 0, 0, -0.2, 0.15 }, Waist = { 6, 40, 0 }, Neck = { -6, -25, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 60, 0, -85 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, -30, 0, 0, -0.3, -0.4 }, Waist = { -12, -36, 0 }, Neck = { 0, 20, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 95, 0, 5 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, -40, 0, 0, -0.32, -0.45 }, Waist = { -14, -46, 0 }, Neck = { 0, 26, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 90, 0, 30 }, LE = { 55, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "mug", trail = "leftHand", fx = { { "toss", shape = "ball", color = Color3.fromRGB(80, 50, 30), size = 0.5, count = 6, speed = 16 }, { "burst", color = MUG, size = 3, at = "front" }, { "symbols", symbols = { "☕", "VENDREDI !" }, count = 3, radius = 2.5, at = "front", color = Color3.fromRGB(200, 170, 130) } },
			text = "VIVEMENT VENDREDI !", hitText = "CAFÉ RENVERSÉ !",
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
		-- ↑ P en l'air : Tampon au plafond, il s'étire de tout son long, pointes de pieds tendues, pour tamponner le plafond : « APPROUVÉ »
		P_air_up = {
			label = "Tampon au plafond", startup = 0.1, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 42, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 20, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -30, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 178, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -15 }, LE = { 10, 0, 0 }, RH = { 0, 0, 2 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, -2 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 2, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 182, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 8, 0, -14 }, LE = { 10, 0, 0 }, RH = { 0, 0, 3 }, RK = { 0, 0, 0 }, RA = { -22, 0, 0 }, LH = { 0, 0, -3 }, LK = { 0, 0, 0 }, LA = { -22, 0, 0 } },
			trail = "prop", fx = { { "text", text = "APPROUVÉ", color = Color3.fromRGB(40, 160, 60), at = "above" } }, hitText = "CHTONK !",
		},
		-- ↓ P en l'air : Pied de chaise de bureau, chaise à roulettes brandie de la main gauche et abattue pieds en bas, l'autre bras en l'air pour l'équilibre
		P_air_down = {
			label = "Pied de chaise de bureau", startup = 0.16, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78,
			windup = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 30 }, RE = { 40, 0, 0 }, LS = { 190, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -18, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 160, 0, 30 }, RE = { 10, 0, 0 }, LS = { 25, 0, 10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 165, 0, 35 }, RE = { 10, 0, 0 }, LS = { 10, 0, 10 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			prop = "chaise", text = "ASSIS !", hitText = "KLONK !",
		},
		-- → K en l'air : Au service d'à côté, coup de pied latéral, les deux bras tendus pour indiquer le guichet d'à côté
		K_air_side = {
			label = "Au service d'à côté", startup = 0.15, active = 0.12, recovery = 0.26,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 30,
			windup = { Root = { -14, 20, 0 }, Waist = { -16, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 50, 0, 45 }, RE = { 70, 0, 0 }, LS = { 70, 0, -30 }, LE = { 80, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 12, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, -10, 0 }, RS = { 95, 0, 30 }, RE = { 0, 0, 0 }, LS = { 95, 0, -30 }, LE = { 0, 0, 0 }, RH = { 65, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 14, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, -10, 0 }, RS = { 98, 0, 34 }, RE = { 0, 0, 0 }, LS = { 98, 0, -34 }, LE = { 0, 0, 0 }, RH = { 68, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", text = "VOYEZ À CÔTÉ !", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Retourné de guichet, salto arrière poussif : une seule jambe monte, l'autre pend, la main gauche serre la cravate
		K_air_up = {
			label = "Retourné de guichet", startup = 0.15, active = 0.2, recovery = 0.26,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 70, 0, 20 }, LE = { 120, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 0, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 32, 0, 22 }, RE = { 60, 0, 0 }, LS = { 72, 0, 22 }, LE = { 122, 0, 0 }, RH = { 110, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -30, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "rightFoot", text = "HOP… OUF.", hitText = "POC !",
		},
		-- ↓ K en l'air : Pause écrasée, bras croisés et l'air blasé, il tombe les deux pieds joints comme sur le bouton de la machine à café
		K_air_down = {
			label = "Pause écrasée", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 22, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 60, 0, -20 }, RE = { 110, 0, 0 }, LS = { 60, 0, 20 }, LE = { 110, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 24, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 62, 0, -22 }, RE = { 112, 0, 0 }, LS = { 62, 0, 22 }, LE = { 112, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "PAUSE !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Avion en papier : il plie un formulaire en avion et le lance ; il vire droit sur le nez de l'adversaire et s'y colle
		S_neutral = {
			label = "Avion en papier", kind = "projectile", startup = 0.18, active = 0, recovery = 0.4,
			damage = 12, kbBase = 20, kbGrowth = 35, kbAngle = 20,
			projectile = { speed = 55, angle = 5, gravity = 0, lifetime = 1.0, size = 1.8, color = PAPER, visual = PLANE },
			windup = { Root = { 0, -15, 0, 0, -0.15, 0.15 }, Waist = { 0, -18, 0 }, Neck = { 6, 15, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 120, 0, 30 }, LE = { 110, 0, 0 } },
			strike = { Root = { -6, 12, 0, 0, -0.2, -0.15 }, Waist = { -6, 16, 0 }, Neck = { 0, -10, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 100, 0, -5 }, LE = { 5, 0, 0 } },
			follow = { Root = { -6, 16, 0, 0, -0.2, -0.18 }, Waist = { -6, 20, 0 }, Neck = { 0, -12, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 90, 0, -15 }, LE = { 10, 0, 0 } },
			text = "VEUILLEZ REMPLIR CECI.", hitText = "FORMULAIRE COLLÉ !",
		},
		-- Tampon « REFUSÉ » : il lève le tampon géant à deux mains et l'abat : REFUSÉ s'imprime sur tout le couloir
		S_side = {
			label = "Tampon « REFUSÉ »", startup = 0.28, active = 0.15, recovery = 0.5,
			damage = 16, hitbox = box(14, 5, 7, 0.5), kbBase = 38, kbGrowth = 80, kbAngle = 25, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 8, -10, 0, 0, -0.15, 0.3 }, Waist = { 14, -12, 0 }, Neck = { 16, 0, 0 }, RS = { 195, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, 0 }, LE = { 60, 0, 0 } },
			strike = { Root = { -18, 8, 0, 0, -0.5, -0.5 }, Waist = { -30, 10, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 15 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -20, 10, 0, 0, -0.55, -0.55 }, Waist = { -34, 12, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, -5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 65, 0, 15 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			hold = 0.12, shake = true, trail = "prop", fx = { { "burst", color = INK, size = 4 }, { "beam", color = INK, length = 14, width = 3, at = "feet" }, { "text", text = "REFUSÉ", color = INK, scale = 1.3 }, { "shake", amount = 0.4 } },
			text = "DOSSIER…", hitText = "REFUSÉ !",
		},
		-- File d'attente : un figurant en carton surgit devant lui et bloque le prochain projectile… et Bernard pousse toute la file des deux mains : elle bouscule tout le couloir
		S_down = {
			label = "File d'attente", kind = "wall", startup = 0.22, active = 0.15, recovery = 0.45,
			hitbox = box(14, 5, 7, 0.6), kbBase = 30, kbGrowth = 50, kbAngle = 30,
			damage = 12,
			wall = { size = Vector3.new(1.5, 6.5, 6), offset = 4, lifetime = 6, max = 2, absorbs = true, solid = false, color = GREY,
				visual = { shape = "block", size = 1.6, color = GREY, trail = false, parts = {
					{ "block", Vector3.new(1.8, 3, 1), Vector3.new(0, -0.6, 0), GREY },
					{ "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 1.8, 0), Color3.fromRGB(150, 150, 160) },
					{ "block", Vector3.new(0.6, 0.4, 0.1), Vector3.new(0.3, 0.2, -0.55), PAPER },
				} } },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.3, -0.45 }, Waist = { -16, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 95, 0, -10 }, RE = { 0, 0, 0 }, LS = { 95, 0, 10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 0, 0, 0, -0.32, -0.5 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 98, 0, -12 }, RE = { 0, 0, 0 }, LS = { 98, 0, 12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "bothHands", fx = { { "burst", color = GREY, size = 2.5, at = "front" }, { "symbols", symbols = { "🎫", "42" }, count = 2, radius = 1.5, at = "front", color = PAPER } },
			text = "PRENEZ UN TICKET ET PATIENTEZ.", hitText = "POUSSÉ DANS LA FILE !",
		},
		-- Pause café (après une esquive) : il sirote son mug, récupère un peu… et recrache un jet de café bouillant sur tout le couloir (sans défense pendant la pause)
		S_dodge = {
			label = "Pause café", startup = 0.22, active = 0.15, recovery = 0.8,
			hitbox = box(14, 5, 7, 0.8), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 12, selfEffect = { heal = 6 },
			windup = { Root = { 6, 0, 0, 0, -0.05, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 130, 0, 25 }, LE = { 140, 0, 0 }, LW = { -30, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.25, -0.35 }, Waist = { -18, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -14, 0, 0, 0, -0.28, -0.4 }, Waist = { -20, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 55, 0, -32 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			hold = 0.2, prop = "mug", windupFx = { { "particles", tex = "smoke", color = Color3.fromRGB(240, 230, 220), dir = "up", at = "lhand", time = 0.6, speed = 3 }, { "symbols", symbols = { "☕" }, count = 1, radius = 1 } },
			fx = { { "beam", color = Color3.fromRGB(120, 80, 50), length = 14, width = 2, at = "head" }, { "particles", tex = "smoke", color = Color3.fromRGB(120, 80, 50), dir = "front", at = "head", time = 0.3, speed = 18, size = 0.6, rate = 80 }, { "burst", color = Color3.fromRGB(120, 80, 50), size = 2, at = "front" } },
			text = "PAUSE CAFÉ.", hitText = "CAFÉ BRÛLANT !",
		},
		-- Courrier prioritaire (↑L) : une pile de dossiers jaillit sous lui comme un ressort et l'expédie en diagonale vers l'avant,
		-- tampon tendu devant lui, timbré URGENT, jambes qui traînent derrière
		S_up = {
			label = "Courrier prioritaire", startup = 0.1, active = 0.3, recovery = 0.4,
			damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 75, selfVelocity = Vector2.new(42, 80),
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 25 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -25 }, LE = { 50, 0, 0 } },
			strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 172, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -25 }, LE = { 30, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
			follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 176, 0, 12 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -35, 0, -30 }, LE = { 30, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
			trail = "prop", fx = { { "pillar", color = FOLDER, height = 10, width = 2.5, neon = false }, { "toss", shape = "flat", color = PAPER, size = 0.8, count = 6, speed = 16 }, { "ring", color = FOLDER, radius = 5, at = "feet" }, { "symbols", symbols = { "📨", "URGENT" }, count = 3, radius = 2, color = INK } }, text = "COURRIER PRIORITAIRE !", hitText = "TAMPONNÉ EN VOL !",
		},
		-- Ticket numéroté (S maintenu) : il tend un ticket qui vole droit sur l'adversaire ; à l'appel de son numéro, il se fige
		-- (le moteur ne sait pas différer un statut : le ticket touché fige tout de suite)
		S_hold = {
			label = "Ticket numéroté", kind = "projectile", startup = 0.3, active = 0, recovery = 0.45,
			damage = 12, kbBase = 10, kbGrowth = 12, kbAngle = 20, status = { name = "stunned", duration = 1.5 },
			projectile = { speed = 50, angle = 0, gravity = 0, lifetime = 1.0, size = 1.8, color = Color3.fromRGB(255, 200, 220),
				visual = { shape = "block", size = 1.1, color = Color3.fromRGB(255, 200, 220), text = "42", textColor = BLACK } },
			windup = { Root = { 0, -10, 0, 0, -0.15, 0.1 }, Waist = { 0, -12, 0 }, Neck = { 10, 10, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 60, 0, 10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.2, -0.1 }, Waist = { -4, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 90, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { -4, 12, 0, 0, -0.2, -0.12 }, Waist = { -4, 14, 0 }, Neck = { 0, -10, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 88, 0, -12 }, LE = { 12, 0, 0 } },
			hold = 0.1, text = "LE NUMÉRO 42…", hitText = "C'EST VOUS !",
		},
		-- Glissade en chaise à roulettes (→→S) : assis sur sa chaise, il traverse tout le couloir et fauche tout au passage avec les pieds
		S_dash = {
			label = "Glissade en chaise à roulettes", startup = 0.15, active = 0.35, recovery = 0.4,
			damage = 13, hitbox = box(14, 5, 6, -0.3), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(60, 0),
			windup = { Root = { 6, 0, 0, 0, -0.6, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 0, 0, -10 }, LE = { 10, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.9, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 30, 0, 0 }, LS = { -5, 0, -12 }, LE = { 5, 0, 0 }, RH = { 85, 0, 0 }, RK = { -40, 0, 0 }, LH = { 85, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.9, 0 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 72, 0, 22 }, RE = { 30, 0, 0 }, LS = { -5, 0, -12 }, LE = { 5, 0, 0 }, RH = { 88, 0, 0 }, RK = { -35, 0, 0 }, LH = { 88, 0, 0 }, LK = { -35, 0, 0 } },
			prop = "chaise", trail = "body", fx = { { "particles", tex = "spark", color = Color3.fromRGB(240, 220, 160), dir = "up", at = "feet", time = 0.4, speed = 5 } },
			text = "GRIIIIIN…", hitText = "BOUM !",
		},
		-- Bloc de Post-it (S en l'air) : il jette son bloc de Post-it entier, qui fonce sur l'adversaire et s'y colle de partout
		S_air = {
			label = "Bloc de Post-it", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
			damage = 12, kbBase = 20, kbGrowth = 35, kbAngle = 50,
			projectile = { speed = 60, angle = -20, gravity = 0, lifetime = 0.7, size = 1.6, color = POSTIT,
				visual = { shape = "block", size = 1.2, color = POSTIT, spin = 6, parts = { { "block", Vector3.new(0.7, 0.05, 0.7), Vector3.new(0.3, 0.65, 0.2), POSTIT }, { "block", Vector3.new(0.7, 0.7, 0.05), Vector3.new(-0.2, 0.2, -0.65), Color3.fromRGB(255, 180, 200) } } } },
			windup = { Root = { -4, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 150, 0, -10 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 165, 0, -25 }, LE = { 10, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 160, 0, 5 }, LE = { 10, 0, 0 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 25, 0, 0 }, LK = { -65, 0, 0 } },
			shake = true, text = "N'OUBLIEZ PAS…", hitText = "COLLÉ !",
		},
		-- Plongeon de dossier (↓S en l'air) : bras chargés d'archives, il se laisse tomber de tout son poids sur l'adversaire
		S_air_down = {
			label = "Plongeon de dossier", startup = 0.15, active = 0.35, recovery = 0.4,
			damage = 13, hitbox = box(6, 5, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, -20 }, RE = { 60, 0, 0 }, LS = { 120, 0, 20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 75, 0, -20 }, RE = { 60, 0, 0 }, LS = { 75, 0, 20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 72, 0, -22 }, RE = { 62, 0, 0 }, LS = { 72, 0, 22 }, LE = { 62, 0, 0 }, LW = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -30, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
			prop = "dossiers", trail = "body", fx = { { "toss", shape = "flat", color = PAPER, size = 0.8, count = 6, speed = 16 }, { "ring", color = FOLDER, radius = 4, at = "feet" } },
			text = "ARCHIVES !", hitText = "BLAM !",
		},
		-- Agrafage en règle (finition d'enchaînement) : trois coups d'agrafeuse rapides d'un seul geste, qui collent un formulaire
		S_finish_agrafe = {
			label = "Agrafage en règle", startup = 0.12, active = 0.24, recovery = 0.3,
			damage = 12, hitbox = box(5, 3.5, 2.6, 0.6), kbBase = 26, kbGrowth = 45, kbAngle = 35,
			windup = { Root = { -4, 20, 0, 0, -0.2, 0.1 }, Waist = { -4, 24, 0 }, Neck = { 0, -15, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 80, 0, -50 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -10, 0, 0, -0.25, -0.25 }, Waist = { -8, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 95, 0, 0 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -8, -12, 0, 0, -0.25, -0.28 }, Waist = { -8, -16, 0 }, Neck = { 0, 12, 0 }, RS = { 20, 0, 22 }, RE = { 50, 0, 0 }, LS = { 92, 0, 5 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			wobble = true, prop = "agrafeuse", trail = "leftHand", text = "EN TROIS EXEMPLAIRES !", hitText = "CLAC CLAC CLAC !",
		},

		------------------------------------------------------------------ Supers
		-- Grève générale (Y) : il croise les bras, sort sa pancarte imaginaire… et tout l'écran se fige, sauf lui
		SUPER = {
			label = "Grève générale !", startup = 0.45, active = 0.2, recovery = 0.7,
			damage = 20, hitbox = box(80, 50, 0, 10), kbBase = 8, kbGrowth = 8, kbAngle = 60,
			status = { name = "statue", duration = 2.5 },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -40 }, RE = { 110, 0, 0 }, LS = { 60, 0, 40 }, LE = { 110, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, LS = { 175, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 178, 0, 14 }, RE = { 10, 0, 0 }, LS = { 178, 0, -14 }, LE = { 10, 0, 0 } },
			hold = 0.5, windupFx = { { "screen", color = Color3.fromRGB(150, 150, 160), alpha = 0.35 } },
			fx = { { "symbols", symbols = { "🪧", "✊", "GRÈVE !" }, count = 8, radius = 6 }, { "shake", amount = 0.3 } },
			text = "GRÈVE GÉNÉRALE !", hitText = "TOUT EST FERMÉ !",
		},
		-- Chaise de bureau balistique (→Y) : il s'assied sur sa chaise à roulettes, prend un élan de pied contre le guichet et
		-- l'envoie seule à travers tout le couloir : elle fauche tout le monde, dossier en avant, puis revient en roulant jusqu'à lui
		SUPER_side = {
			label = "Chaise balistique !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.65,
			damage = 25, kbBase = 46, kbGrowth = 96, kbAngle = 30,
			projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = GREY, from = "feet", returns = true, pierce = true,
				visual = { shape = "block", size = 2.4, color = BLACK, spin = 6, parts = {
					{ "block", Vector3.new(1.6, 1.4, 0.25), Vector3.new(0, 0.8, 0.7), BLACK },
					{ "cyl", Vector3.new(1.0, 0.2, 0.2), Vector3.new(0, -0.6, 0), GREY },
					{ "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0.8, -1.1, 0), BLACK },
					{ "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(-0.8, -1.1, 0), BLACK },
				} } },
			status = { name = "waiting", duration = 2 },
			windup = { Root = { 10, 0, 0, 0, -0.7, 0.2 }, Waist = { 6, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 120, 0, -30 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.4 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -20 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 2, 0, 0, 0, -0.35, -0.2 }, Waist = { 0, 0, 0 }, Neck = { -16, 20, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, 30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -20, 0, 0 }, RA = { 10, 0, 0 } },
			prop = "chaise", trail = "rightFoot", windupFx = { "super", { "symbols", symbols = { "🪑", "GRIIIN" }, count = 4, radius = 3, color = GREY } },
			fx = { { "burst", color = GREY, size = 3, at = "feet" }, { "particles", tex = "spark", color = Color3.fromRGB(240, 220, 160), dir = "front", at = "feet", time = 0.4, speed = 16 }, { "shake", amount = 0.3 } },
			text = "CHAISE BALISTIQUE !", hitText = "ROULÉ DESSUS !",
		},
		-- Avalanche de dossiers (↑Y) : il serre une montagne de dossiers contre lui et la jette au plafond : une tour d'archives
		-- jaillit sur tout le couloir et emporte tout le monde en haut
		SUPER_up = {
			label = "Avalanche de dossiers !", startup = 0.4, active = 0.3, recovery = 0.7,
			damage = 24, hitbox = box(16, 14, 8, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -10, 0, 0, 0, -0.6, 0.1 }, Waist = { -26, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, -25 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 25 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.4, 0 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 182, 0, 18 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 182, 0, -18 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.45, 0 }, Waist = { 20, 0, 0 }, Neck = { 46, 0, 0 }, RS = { 165, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -60 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			hold = 0.3, shake = true, prop = "dossiers",
			windupFx = { "super", { "symbols", symbols = { "📁", "📋", "📎" }, count = 5, radius = 2.5, at = "front", color = FOLDER } }, status = { name = "waiting", duration = 2 },
			fx = { { "pillar", color = FOLDER, height = 24, width = 4.5, at = "front" }, { "rain", shape = "flat", color = PAPER, count = 16, radius = 6, size = 0.9 }, { "text", text = "ARCHIVÉ", color = INK, at = "above" }, { "shake", amount = 0.4 } },
			text = "AVALANCHE DE DOSSIERS !", hitText = "CLASSÉ TOUT EN HAUT !",
		},
		-- Formulaire Cerfa 12-B (↓Y) : il déroule un formulaire interminable sur tout le couloir ; selon qu'il est bien rempli
		-- ou non, le résultat change (le mini-jeu de saisie n'existe pas dans le moteur : variantes au hasard)
		SUPER_down = {
			label = "Formulaire Cerfa 12-B", startup = 0.4, active = 0.2, recovery = 0.7,
			damage = 20, hitbox = box(16, 6, 8, 1), kbBase = 35, kbGrowth = 70, kbAngle = 35,
			variants = {
				{ label = "Cerfa presque rempli", damage = 14, kbBase = 30, kbGrowth = 45, hitText = "IL MANQUE UNE SIGNATURE…" },
				{ label = "Cerfa en triple exemplaire", damage = 20, status = { name = "waiting", duration = 2 }, hitText = "EN TRIPLE EXEMPLAIRE !" },
				{ label = "Cerfa refusé", damage = 28, kbBase = 45, kbGrowth = 90, hitText = "DOSSIER REFUSÉ !!" },
			},
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 15 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, 30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.4, -0.45 }, Waist = { -24, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 85, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -16, 0, 0, 0, -0.42, -0.5 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, -5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 85, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			hold = 0.2, prop = "dossiers", windupFx = { { "screen", color = PAPER, alpha = 0.3 }, { "symbols", symbols = { "📋", "✍️", "📎" }, count = 6, radius = 4 } },
			fx = { { "burst", color = INK, size = 4 }, { "beam", color = PAPER, length = 16, width = 4, at = "feet" }, { "toss", shape = "flat", color = PAPER, size = 1, count = 8, speed = 20 } },
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

-- Arbre d'enchaînements : P P P (mug, agrafeuse, tampon), → P P P (classeur, re-classé, vrille), ↓ P P P (trombone,
-- trombone déplié, chaise), K K K, → K K K (agrafe, agrafe gauche, mug), mélanges, et finitions S qui collent de
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
	P_side = { P = "P_side2", K = "K_side2", S = "S_side" }, -- → P
	P_side2 = { P = "P_side3", K = "K_combo3", S = "S_finish_agrafe" }, -- → P P
	P_down = { P = "P_down2", K = "K_combo3", up_P = "P_up", S = "S_finish_agrafe" }, -- ↓ P
	P_down2 = { P = "P_down3", K = "K_combo2", S = "S_finish_agrafe" }, -- ↓ P P
	P_up = { P = "P_combo3", S = "S_neutral" }, -- ↑ P
	K_down = { P = "P_combo2", K = "K_combo2", S = "S_finish_agrafe" }, -- ↓ K
	K_side = { K = "K_side2", P = "KP_combo", S = "S_side" }, -- → K
	K_side2 = { K = "K_side3", P = "P_combo2", S = "S_finish_agrafe" }, -- → K K
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

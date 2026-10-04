-- Madame Ventouse, plombière : salopette, casquette à l'envers, ceinture d'outils ; elle s'accroche partout.
-- Mobilité : ses ventouses (kind = "grapple") attirent l'adversaire ou la tirent vers le décor (murs, plafond,
-- dessous des plateformes). Arme sortie de la Caisse Bizarre : Ventouse géante (et Clé à molette).
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(225, 172, 135)
local SHIRT = Color3.fromRGB(200, 60, 50)
local DENIM = Color3.fromRGB(60, 95, 160)
local DENIM_DARK = Color3.fromRGB(45, 72, 125)
local GLOVE = Color3.fromRGB(240, 150, 45)
local BOOT = Color3.fromRGB(240, 200, 40)
local HAIR = Color3.fromRGB(115, 70, 40)
local CAP = Color3.fromRGB(205, 50, 40)
local RUBBER = Color3.fromRGB(200, 35, 40)
local RUBBER_DARK = Color3.fromRGB(150, 25, 30)
local HANDLE = Color3.fromRGB(165, 110, 60)
local STEEL = Color3.fromRGB(165, 170, 180)
local LEATHER = Color3.fromRGB(110, 70, 40)
local WATER = Color3.fromRGB(80, 170, 240)
local BRASS = Color3.fromRGB(215, 175, 70)

local GAS = Color3.fromRGB(40, 60, 120) -- bouteille du chalumeau (arme n° 2)
local FLAME = Color3.fromRGB(90, 170, 255)
local EMBER = Color3.fromRGB(255, 140, 40)
local PORCELAIN = Color3.fromRGB(240, 240, 245) -- cuvette de WC (arme n° 3)
local SEWER = Color3.fromRGB(90, 90, 95) -- plaque d'égout du →Y

-- flammèche du chalumeau
local FLAME_SHOT = { shape = "ball", size = 1.2, color = FLAME, neon = true, spin = 10, parts = { { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-0.5, 0.2, 0), EMBER } } }
-- la cuvette qui roule / vole
local TOILET_SHOT = { shape = "ball", size = 2.4, color = PORCELAIN, spin = 6, parts = {
	{ "cyl", Vector3.new(0.2, 2.4, 2.4), Vector3.new(0, 0.9, 0), PORCELAIN },
	{ "block", Vector3.new(1.8, 1.6, 0.7), Vector3.new(0, 1.2, 1.3), PORCELAIN },
	{ "ball", Vector3.new(1.2, 0.3, 1.2), Vector3.new(0, 0.95, 0), WATER },
} }
-- plaque d'égout boomerang
local MANHOLE = { shape = "ball", size = 1, color = SEWER, spin = 14, parts = {
	{ "cyl", Vector3.new(0.4, 4.2, 4.2), Vector3.new(0, 0, 0), SEWER },
	{ "cyl", Vector3.new(0.5, 1.2, 1.2), Vector3.new(0, 0, 0), Color3.fromRGB(60, 60, 65) },
	{ "block", Vector3.new(3.2, 0.5, 0.3), Vector3.new(0, 0, 0), Color3.fromRGB(60, 60, 65) },
	{ "block", Vector3.new(0.3, 0.5, 3.2), Vector3.new(0, 0, 0), Color3.fromRGB(60, 60, 65) },
} }
local data = {
	id = "Ventouse",
	name = "Madame Ventouse",
	costume = "Ventouse",
	style = "plumber",
	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : dépannage à l'ancienne
	-- Ses propres J / K et ses combos sans arme (les L et les Y restent ceux de moves). Sans ventouse, Madame Ventouse
	-- se sert de ses paumes comme de ventouses (SPLOTCH), tape sur la tuyauterie à coups de poing-marteau et répare
	-- tout d'un bon coup de pied au radiateur ; ses combos finissent en double débouchage ou en geyser réparateur.
	bare = {
		moves = {
			-- J : paume-ventouse : elle crache dans sa main et la plaque en pleine figure, SPLOTCH, ça colle
			P_neutral = {
				label = "Paume-ventouse", startup = 0.07, active = 0.08, recovery = 0.14,
				damage = 5, hitbox = box(4, 3, 2.7, 1), kbBase = 18, kbGrowth = 22, kbAngle = 22,
				windup = { Root = { 0, 20, 0, 0, -0.2, 0.1 }, Waist = { 0, 15, 0 }, Neck = { 0, -10, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 50, 0, -20 }, LE = { 80, 0, 0 } },
				strike = { Root = { -6, -10, 0, 0, -0.22, -0.25 }, Waist = { -6, -10, 0 }, Neck = { 0, 0, 0 }, RS = { 92, 0, 0 }, RE = { 10, 0, 0 }, RW = { -70, 0, 0 }, LS = { 50, 0, -20 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
				follow = { Root = { -6, -12, 0, 0, -0.22, -0.27 }, Waist = { -6, -12, 0 }, Neck = { 0, 0, 0 }, RS = { 92, 0, -2 }, RE = { 10, 0, 0 }, RW = { -75, 0, 0 }, LS = { 50, 0, -20 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.22 } },
				hold = 0.05, trail = "rightHand", hitText = "SPLOTCH !",
			},
			-- J J : l'autre paume se colle à son tour, de la main gauche, avec un petit bruit de succion
			P_combo2 = {
				label = "Paume gauche", startup = 0.06, active = 0.08, recovery = 0.14,
				damage = 5, hitbox = box(4, 3, 2.8, 1), kbBase = 18, kbGrowth = 22, kbAngle = 25,
				windup = { Root = { 0, -20, 0, 0, -0.2, 0.08 }, Waist = { 0, -15, 0 }, Neck = { 0, 10, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 }, LW = { -40, 0, 0 } },
				strike = { Root = { -6, 15, 0, 0, -0.22, -0.28 }, Waist = { -6, 15, 0 }, Neck = { 0, 0, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, LS = { 92, 0, 0 }, LE = { 10, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
				follow = { Root = { -6, 17, 0, 0, -0.22, -0.3 }, Waist = { -6, 17, 0 }, Neck = { 0, 0, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, LS = { 92, 0, 2 }, LE = { 10, 0, 0 }, LW = { -75, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				hold = 0.05, trail = "leftHand", hitText = "SPLOUTCH !",
			},
			-- J J J : double débouchage à mains nues : les deux paumes collées, elle tire de tout son poids en arrière… POP ! (finition)
			P_combo3 = {
				label = "Débouchage à mains nues", startup = 0.13, active = 0.12, recovery = 0.32,
				damage = 9, hitbox = box(4.5, 3.5, 2.6, 1), kbBase = 30, kbGrowth = 60, kbAngle = 40,
				windup = { Root = { -10, 0, 0, 0, -0.2, -0.2 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 10 }, RE = { 0, 0, 0 }, RW = { -70, 0, 0 }, LS = { 92, 0, -10 }, LE = { 0, 0, 0 }, LW = { -70, 0, 0 } },
				strike = { Root = { 18, 0, 0, 0, -0.5, 0.45 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { 20, 0, 0, 0, -0.52, 0.48 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 50, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -25 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				shake = true, trail = "bothHands",
				fx = { { "burst", color = RUBBER, size = 2.5, at = "front" }, { "text", text = "POP !", color = RUBBER, at = "front" } },
				hitText = "SCHPLOP !",
			},
			-- J K : cric de dépanneuse : elle se glisse sous l'adversaire et le soulève des épaules comme une voiture en panne
			PK_combo = {
				label = "Cric de dépanneuse", startup = 0.1, active = 0.1, recovery = 0.24,
				damage = 7, hitbox = box(4, 4.5, 1.8, 1.5), kbBase = 24, kbGrowth = 40, kbAngle = 80, selfVelocity = Vector2.new(10, 0),
				windup = { Root = { -20, 0, 0, 0, -0.8, -0.1 }, Waist = { -25, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 140, 0, 30 }, RE = { 100, 0, 0 }, LS = { 140, 0, -30 }, LE = { 100, 0, 0 } },
				strike = { Root = { -4, 0, 0, 0, 0.1, -0.25 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 175, 0, 20 }, RE = { 30, 0, 0 }, LS = { 175, 0, -20 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
				follow = { Root = { -4, 0, 0, 0, 0.12, -0.27 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 178, 0, 20 }, RE = { 26, 0, 0 }, LS = { 178, 0, -20 }, LE = { 26, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.27 } },
				shake = true, trail = "bothHands", fx = { { "text", text = "HNNG… HOP !", color = BOOT, at = "head" } }, hitText = "CRIC !",
			},
			-- K J : coup de queue de cheval : elle tourne la tête d'un coup sec, la queue de cheval fouette d'un tour complet
			KP_combo = {
				label = "Fouet de queue de cheval", startup = 0.1, active = 0.14, recovery = 0.24,
				damage = 8, hitbox = box(5, 3.5, 2, 1.4), kbBase = 24, kbGrowth = 45, kbAngle = 35,
				windup = { Root = { 0, -40, 0, 0, -0.15, 0.1 }, Waist = { 0, -20, 0 }, Neck = { 10, -40, 0 }, RS = { 30, 0, 40 }, RE = { 70, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
				strike = { Root = { 0, 0, 0, 0, -0.2, -0.15 }, Waist = { 0, 0, 0 }, Neck = { -15, 30, 0 }, RS = { 40, 0, 60 }, RE = { 40, 0, 0 }, LS = { 40, 0, -60 }, LE = { 40, 0, 0 } },
				follow = { Root = { 0, 10, 0, 0, -0.2, -0.17 }, Waist = { 0, 10, 0 }, Neck = { -15, 40, 0 }, RS = { 40, 0, 62 }, RE = { 40, 0, 0 }, LS = { 40, 0, -62 }, LE = { 40, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "head", hitText = "FOUETTÉ !",
			},
			-- K K : « ça marche toujours pas ! » : deuxième coup de pied au radiateur, plus haut et plus énervé
			K_combo2 = {
				label = "Ça marche toujours pas !", startup = 0.1, active = 0.1, recovery = 0.24,
				damage = 8, hitbox = box(4.5, 3, 2.8, 0.4), kbBase = 24, kbGrowth = 45, kbAngle = 38, selfVelocity = Vector2.new(10, 0),
				windup = { Root = { 6, 0, 0, 0, -0.15, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -20, 0, 40 }, RE = { 90, 0, 0 }, LS = { -20, 0, -40 }, LE = { 90, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
				strike = { Root = { -10, 0, 0, 0, -0.1, -0.15 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { -40, 0, -50 }, LE = { 60, 0, 0 }, LH = { 100, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
				follow = { Root = { -10, 0, 0, 0, -0.1, -0.17 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 42, 0, 52 }, RE = { 60, 0, 0 }, LS = { -42, 0, -52 }, LE = { 60, 0, 0 }, LH = { 104, 0, 0 }, LK = { -2, 0, 0 }, LA = { 20, 0, 0 } },
				trail = "leftFoot", fx = { { "text", text = "GRRR", color = CAP, at = "head" } }, hitText = "BONNNG !",
			},
			-- K K K : le coup qui répare tout : coup de pied retourné de toutes ses forces… et un geyser jaillit, réparé ! (finition)
			KKK_combo = {
				label = "Le coup qui répare tout", startup = 0.14, active = 0.12, recovery = 0.32,
				damage = 10, hitbox = box(5.5, 4, 3, 0.6), kbBase = 30, kbGrowth = 60, kbAngle = 42, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { 6, 40, 0, 0, -0.2, 0.15 }, Waist = { 10, 20, 0 }, Neck = { 0, -60, 0 }, RS = { 30, 0, 50 }, RE = { 60, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 } },
				strike = { Root = { -10, 0, 0, 0, -0.1, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { -10, -4, 0, 0, -0.1, -0.22 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 62, 0, 72 }, RE = { 20, 0, 0 }, LS = { 62, 0, -72 }, LE = { 20, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
				hold = 0.08, spin = { axis = "y", degrees = 360 }, trail = "rightFoot",
				fx = { { "pillar", color = WATER, height = 12, width = 2.5, at = "front" }, { "text", text = "RÉPARÉ !", color = WATER, at = "head" } },
				hitText = "KLONNNG !",
			},
			-- →J : poing-marteau : le poing fermé tape à l'horizontale comme sur un tuyau grippé
			P_side = {
				label = "Poing-marteau", startup = 0.1, active = 0.1, recovery = 0.18,
				damage = 7, hitbox = box(5, 3, 2.9, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 28, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { 0, 40, 0, 0, -0.2, 0.15 }, Waist = { 0, 30, 0 }, Neck = { 0, -30, 0 }, RS = { 120, 0, 90 }, RE = { 60, 0, 0 }, LS = { 50, 0, -20 }, LE = { 80, 0, 0 } },
				strike = { Root = { -8, -30, 0, 0, -0.28, -0.35 }, Waist = { -8, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 85, 0, -20 }, RE = { 10, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
				follow = { Root = { -8, -34, 0, 0, -0.28, -0.38 }, Waist = { -8, -34, 0 }, Neck = { 0, 22, 0 }, RS = { 80, 0, -30 }, RE = { 12, 0, 0 }, LS = { 28, 0, -32 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
				trail = "rightHand", hitText = "BLANG !",
			},
			-- ↓J : bras dans le siphon : à genoux, elle plonge le bras jusqu'au coude dans un siphon imaginaire et attrape une cheville
			P_down = {
				label = "Bras dans le siphon", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 5, hitbox = box(4, 2, 2.6, -1.4), kbBase = 20, kbGrowth = 25, kbAngle = 65,
				windup = { Root = { -10, 0, 0, 0, -0.9, 0.1 }, Waist = { -20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
				strike = { Root = { -20, 0, 0, 0, -1.0, -0.15 }, Waist = { -35, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
				follow = { Root = { -20, 0, 0, 0, -1.0, -0.15 }, Waist = { -35, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 45, 0, 10 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
				wobble = true, trail = "rightHand", fx = { { "puddle", color = WATER, width = 4 } }, hitText = "GLOUP !",
			},
			-- ↑J : poing au plafond : uppercut tout droit dans le tuyau qui fuit au-dessus d'elle (et dans le menton au passage)
			P_up = {
				label = "Poing au plafond", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 6, hitbox = box(4, 5, 1.5, 3), kbBase = 22, kbGrowth = 38, kbAngle = 86,
				windup = { Root = { 0, 15, 0, 0, -0.45, 0.05 }, Waist = { -10, 15, 0 }, Neck = { 10, 0, 0 }, RS = { 10, 0, 20 }, RE = { 120, 0, 0 }, LS = { 50, 0, -20 }, LE = { 80, 0, 0 } },
				strike = { Root = { 6, -10, 0, 0, 0.2, 0 }, Waist = { 6, -10, 0 }, Neck = { -20, 0, 0 }, RS = { 175, 0, 5 }, RE = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 80, 0, 0 } },
				follow = { Root = { 6, -12, 0, 0, 0.22, 0 }, Waist = { 6, -12, 0 }, Neck = { -22, 0, 0 }, RS = { 178, 0, 5 }, RE = { 0, 0, 0 }, LS = { 18, 0, -30 }, LE = { 80, 0, 0 } },
				trail = "rightHand", fx = { { "toss", shape = "ball", color = WATER, size = 0.4, count = 3, speed = 10 } }, hitText = "BING !",
			},
			-- J en l'air : casquette claquée : elle arrache sa casquette et l'abat sur le crâne d'en dessous
			P_air = {
				label = "Casquette claquée", startup = 0.09, active = 0.12, recovery = 0.18,
				damage = 7, hitbox = box(4.5, 4, 1.6, -0.8), kbBase = 20, kbGrowth = 32, kbAngle = -40,
				windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 175, 0, 10 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
				strike = { Root = { -15, 0, 0 }, Waist = { -15, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
				follow = { Root = { -17, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 28, 0, 0 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
				trail = "rightHand", hitText = "FLAC !",
			},
			-- dash J : épaule de déménageuse : lancée, épaule rentrée, elle enfonce l'adversaire comme une porte coincée
			P_dash = {
				label = "Épaule de déménageuse", startup = 0.08, active = 0.18, recovery = 0.24,
				damage = 7, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 30, selfVelocity = Vector2.new(36, 0),
				windup = { Root = { -10, 40, 0, 0, -0.3, 0.15 }, Waist = { -10, 20, 0 }, Neck = { 0, -30, 0 }, RS = { 20, 0, 10 }, RE = { 100, 0, 0 }, LS = { 40, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -20, 70, 0, 0, -0.35, -0.4 }, Waist = { -10, 20, 0 }, Neck = { 0, -60, 0 }, RS = { 10, 0, 5 }, RE = { 110, 0, 0 }, LS = { 50, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { -20, 72, 0, 0, -0.35, -0.42 }, Waist = { -10, 22, 0 }, Neck = { 0, -62, 0 }, RS = { 10, 0, 5 }, RE = { 110, 0, 0 }, LS = { 50, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
				trail = "body", fx = { "dust" }, hitText = "ÇA PASSE !",
			},
			-- K : coup de pied au radiateur : le petit coup sec qu'on donne à un vieux radiateur pour qu'il redémarre
			K_neutral = {
				label = "Coup de pied au radiateur", startup = 0.12, active = 0.1, recovery = 0.24,
				damage = 8, hitbox = box(4.5, 2.8, 2.6, -0.4), kbBase = 24, kbGrowth = 45, kbAngle = 35,
				windup = { Root = { 4, 0, 0, 0, -0.15, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 0, 0, 20 }, RE = { 100, 0, 0 }, LS = { 0, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 0 }, RK = { -70, 0, 0 } },
				strike = { Root = { -6, 0, 0, 0, -0.15, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 15, 0, 0 }, RS = { -10, 0, 25 }, RE = { 100, 0, 0 }, LS = { -10, 0, -25 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -10, 0, 0 }, RA = { 10, 0, 0 } },
				follow = { Root = { -6, 0, 0, 0, -0.15, -0.12 }, Waist = { -6, 0, 0 }, Neck = { 15, 0, 0 }, RS = { -10, 0, 25 }, RE = { 100, 0, 0 }, LS = { -10, 0, -25 }, LE = { 100, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { 10, 0, 0 } },
				trail = "rightFoot", hitText = "BONG !",
			},
			-- →K : jambe d'équerre : de profil, jambe tendue pile à l'horizontale, elle vérifie le niveau… bulle au centre !
			K_side = {
				label = "Jambe d'équerre", startup = 0.14, active = 0.12, recovery = 0.28,
				damage = 9, hitbox = box(6, 3, 3.4, 0.3), kbBase = 26, kbGrowth = 50, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
				windup = { Root = { 0, 80, 0, 0, -0.2, 0.15 }, Waist = { 0, 0, 0 }, Neck = { 0, -80, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 30 }, RK = { -90, 0, 0 } },
				strike = { Root = { 0, 90, 18, 0, -0.15, -0.1 }, Waist = { 0, 0, -6 }, Neck = { 0, -85, 0 }, RS = { 90, 0, 80 }, RE = { 0, 0, 0 }, LS = { 0, 0, -60 }, LE = { 30, 0, 0 }, RH = { 0, 0, 90 }, RK = { 0, 0, 0 }, RA = { 0, 0, 0 } },
				follow = { Root = { 0, 90, 18, 0, -0.15, -0.12 }, Waist = { 0, 0, -6 }, Neck = { 0, -85, 0 }, RS = { 90, 0, 82 }, RE = { 0, 0, 0 }, LS = { 0, 0, -62 }, LE = { 30, 0, 0 }, RH = { 0, 0, 90 }, RK = { 0, 0, 0 }, RA = { 0, 0, 0 } },
				hold = 0.06, trail = "rightLeg", fx = { { "text", text = "D'ÉQUERRE", color = BRASS, at = "head" } }, hitText = "PILE !",
			},
			-- ↓K : fesses dans la flaque : elle glisse et tombe assise dans une flaque, l'éclaboussure fauche tout autour
			K_down = {
				label = "Fesses dans la flaque", startup = 0.12, active = 0.14, recovery = 0.3,
				damage = 8, hitbox = box(6, 2, 2.4, -1.4), kbBase = 26, kbGrowth = 45, kbAngle = 72,
				windup = { Root = { 10, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 20, 0, 0 }, LS = { 120, 0, -50 }, LE = { 20, 0, 0 }, RH = { 30, 0, 0 } },
				strike = { Root = { 20, 0, 0, 0, -1.2, 0.2 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 70, 0, 70 }, RE = { 10, 0, 0 }, LS = { 70, 0, -70 }, LE = { 10, 0, 0 }, RH = { 85, 0, 15 }, RK = { -5, 0, 0 }, LH = { 85, 0, -15 }, LK = { -5, 0, 0 } },
				follow = { Root = { 22, 0, 0, 0, -1.22, 0.22 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 66, 0, 74 }, RE = { 10, 0, 0 }, LS = { 66, 0, -74 }, LE = { 10, 0, 0 }, RH = { 88, 0, 18 }, RK = { -2, 0, 0 }, LH = { 88, 0, -18 }, LK = { -2, 0, 0 } },
				trail = "bothFeet", fx = { { "puddle", color = WATER, width = 7 }, { "toss", shape = "ball", color = WATER, size = 0.4, count = 5, speed = 14 } },
				hitText = "SPLATCH !",
			},
			-- ↑K : coup de pied au tuyau du plafond : jambe tendue tout droit vers le haut, des gouttes retombent
			K_up = {
				label = "Pied au plafond", startup = 0.14, active = 0.12, recovery = 0.3,
				damage = 9, hitbox = box(4, 6, 1.2, 3.3), kbBase = 26, kbGrowth = 55, kbAngle = 88,
				windup = { Root = { 0, 0, 0, 0, -0.3, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 } },
				strike = { Root = { 20, 0, 0, 0, -0.1, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 10, 0, 60 }, RE = { 20, 0, 0 }, LS = { 10, 0, -60 }, LE = { 20, 0, 0 }, RH = { 165, 0, 0 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
				follow = { Root = { 22, 0, 0, 0, -0.1, 0.17 }, Waist = { 15, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 8, 0, 62 }, RE = { 20, 0, 0 }, LS = { 8, 0, -62 }, LE = { 20, 0, 0 }, RH = { 170, 0, 0 }, RK = { -2, 0, 0 }, RA = { 10, 0, 0 } },
				trail = "rightFoot", fx = { { "rain", shape = "ball", color = WATER, count = 5, radius = 2, size = 0.3 } }, hitText = "DING-PLOC !",
			},
			-- K en l'air : escalade de colonne : elle grimpe à une colonne imaginaire, genou puis pied, genou puis pied (2 touches)
			K_air = {
				label = "Escalade de colonne", startup = 0.1, active = 0.2, recovery = 0.2,
				damage = 8, hits = 2, hitbox = box(4.5, 4, 2, -0.2), kbBase = 22, kbGrowth = 40, kbAngle = 45,
				windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 10 }, RE = { 40, 0, 0 }, LS = { 120, 0, -10 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -110, 0, 0 }, LH = { 10, 0, 0 }, LK = { -20, 0, 0 } },
				strike = { Root = { -10, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, LS = { 160, 0, -10 }, LE = { 40, 0, 0 }, RH = { 90, 0, 0 }, RK = { -10, 0, 0 }, LH = { 100, 0, 0 }, LK = { -110, 0, 0 } },
				follow = { Root = { -10, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 10 }, RE = { 40, 0, 0 }, LS = { 120, 0, -10 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -110, 0, 0 }, LH = { 90, 0, 0 }, LK = { -10, 0, 0 } },
				trail = "bothFeet", hitText = "HOP, HOP !",
			},
			-- dash K : pied dans le seau : en courant, son pied se coince dans un seau et elle shoote avec, seau compris
			K_dash = {
				label = "Pied dans le seau", startup = 0.1, active = 0.22, recovery = 0.3,
				damage = 9, hitbox = box(5.5, 2.8, 3, -0.4), kbBase = 28, kbGrowth = 55, kbAngle = 38, selfVelocity = Vector2.new(46, 6),
				windup = { Root = { -6, 0, 0, 0, -0.2, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 70, 0, 50 }, RE = { 30, 0, 0 }, LS = { 70, 0, -50 }, LE = { 30, 0, 0 }, RH = { -20, 0, 0 }, RK = { -80, 0, 0 } },
				strike = { Root = { 14, 0, 0, 0, -0.3, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 60 }, RE = { 10, 0, 0 }, LS = { 120, 0, -60 }, LE = { 10, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
				follow = { Root = { 16, 0, 0, 0, -0.32, 0.02 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 124, 0, 62 }, RE = { 10, 0, 0 }, LS = { 124, 0, -62 }, LE = { 10, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
				trail = "rightFoot", fx = { "dust", { "symbols", symbols = { "🪣" } } }, hitText = "CLANG-CLONG !",
			},
		},
		-- Combos à mains nues : J J J (paume, paume, débouchage à mains nues), J K (cric de dépanneuse),
		-- K K K (radiateur, toujours pas, le coup qui répare tout), K J (queue de cheval). Un L pour finir envoie son spécial.
		links = {
			P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_side" },
			P_combo2 = { P = "P_combo3", up_K = "PK_combo", S = "S_neutral" },
			P_combo3 = { S = "S_side" },
			PK_combo = { P = "P_up", K = "K_up", S = "S_up" },
			K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_down" },
			K_combo2 = { K = "KKK_combo", down_P = "P_down", S = "S_side" },
			KKK_combo = { S = "S_neutral" },
			KP_combo = { P = "P_side", K = "K_combo2", S = "S_neutral" },
			P_side = { P = "P_combo2", K = "K_side", S = "S_side" },
			P_down = { K = "K_down", P = "PK_combo", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			K_side = { P = "KP_combo", S = "S_side" },
			K_down = { P = "P_up", S = "S_down" },
			K_up = { S = "S_up" },
			P_dash = { P = "P_combo2", K = "K_side", S = "S_side" },
			K_dash = { K = "K_up", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la ventouse géante (ses coups sont ceux de moves). n° 2 : le chalumeau, rapide et court, qui brûle tout
	-- ce qu'il touche. n° 3 : la cuvette de WC, lourde, à chasse d'eau, qui frappe fort et éjecte loin.
	weapons = {
		{ id = "ventouse", name = "Ventouse géante", icon = "🪠",
			ability = { jumps = 1, text = "Un saut en l'air de plus : elle s'accroche partout" } },
		{ id = "chalumeau", name = "Chalumeau de plombière", icon = "🔥",
			prop = { name = "PropChalumeau", hand = "Right", pieces = {
				{ "Bouteille", "", "cyl", Vector3.new(1.3, 0.52, 0.52), Vector3.new(0, -0.5, 0), Vector3.zero, GAS, "Metal" },
				{ "Robinet", "", "cyl", Vector3.new(0.12, 0.42, 0.42), Vector3.new(0, 0.22, 0), Vector3.zero, BRASS, "Metal" },
				{ "Bec", "", "cyl", Vector3.new(0.9, 0.16, 0.16), Vector3.new(0, -1.6, 0), Vector3.zero, BRASS, "Metal" },
				{ "Flamme", "", "ball", Vector3.new(0.32, 0.9, 0.32), Vector3.new(0, -2.4, 0), Vector3.zero, FLAME, "Neon", { neon = true } },
				{ "Etiquette", "", "block", Vector3.new(0.3, 0.5, 0.06), Vector3.new(0, -0.5, -0.27), Vector3.zero, EMBER, "SmoothPlastic" },
			} },
			ability = { speed = 1.15, status = { name = "burning", duration = 2 }, text = "15 % plus vite ; les spéciaux enflamment" },
			moves = {
				-- J : petit coup de bec du chalumeau, vif comme un fer à souder
				P_neutral = {
					label = "Coup de bec", startup = 0.06, active = 0.08, recovery = 0.12,
					damage = 5, hitbox = box(4.5, 2.5, 2.8, 0.8), kbBase = 16, kbGrowth = 20, kbAngle = 25, burn = true,
					windup = { Root = { 2, -16, 0, 0, -0.2, 0.1 }, Waist = { 2, -18, 0 }, Neck = { 0, 12, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 12, 0, 0, -0.25, -0.25 }, Waist = { -8, 14, 0 }, Neck = { 0, -8, 0 }, RS = { 94, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 } },
					follow = { Root = { -9, 14, 0, 0, -0.27, -0.28 }, Waist = { -9, 16, 0 }, Neck = { 0, -10, 0 }, RS = { 96, 0, 0 }, RE = { 4, 0, 0 }, RW = { -6, 0, 0 }, LS = { 18, 0, -42 }, LE = { 80, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "fire", color = FLAME, dir = "front", at = "hand", time = 0.12, speed = 10, size = 0.3, rate = 50 } }, hitText = "TSSS !",
				},
				-- →J : une flammèche crachée à bout portant (petit projectile court qui enflamme)
				P_side = {
					label = "Flammèche", kind = "projectile", startup = 0.08, active = 0, recovery = 0.16,
					damage = 6, kbBase = 18, kbGrowth = 26, kbAngle = 28, burn = true,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.25, size = 1.1, color = FLAME, visual = FLAME_SHOT, aim = false },
					windup = { Root = { 2, -20, 0, 0, -0.2, 0.15 }, Waist = { 2, -22, 0 }, Neck = { 0, 14, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 14, 0, 0, -0.25, -0.25 }, Waist = { -8, 16, 0 }, Neck = { 0, -8, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -9, 16, 0, 0, -0.27, -0.28 }, Waist = { -9, 18, 0 }, Neck = { 0, -10, 0 }, RS = { 94, 0, 2 }, RE = { 2, 0, 0 }, RW = { 0, 0, 0 }, LS = { 72, 0, -12 }, LE = { 20, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					fx = { { "burst", color = FLAME, size = 1.2, at = "hand" } }, hitText = "FSSHH !",
				},
				-- ↓J : accroupie, elle soude les bottes de l'adversaire au sol d'un coup de flamme
				P_down = {
					label = "Soudure aux bottes", startup = 0.08, active = 0.12, recovery = 0.16,
					damage = 5, hitbox = box(5.5, 2, 3.2, -2), kbBase = 14, kbGrowth = 16, kbAngle = 60, burn = true,
					status = { name = "rooted", duration = 0.6 },
					windup = { Root = { -8, 14, 0, 0, -0.7, 0.1 }, Waist = { -18, 12, 0 }, Neck = { -12, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -14, -4, 0, 0, -0.9, -0.15 }, Waist = { -28, -6, 0 }, Neck = { -18, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -15, -8, 0, 0, -0.9, -0.18 }, Waist = { -30, -8, 0 }, Neck = { -20, 0, 0 }, RS = { 55, 0, 14 }, RE = { 0, 0, 0 }, RW = { 70, 0, 0 }, LS = { 52, 0, -32 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "particles", tex = "spark", color = EMBER, dir = "up", at = "front", time = 0.2, speed = 12, size = 0.3, rate = 80 } }, text = "SOUDÉ !", hitText = "CHAUD LES BOTTES !",
				},
				-- ↑J : la flamme pointée au ciel grille le menton (anti-air)
				P_up = {
					label = "Flamme au menton", startup = 0.08, active = 0.12, recovery = 0.18,
					damage = 6, hitbox = box(4, 5.5, 1.2, 3.5), kbBase = 22, kbGrowth = 30, kbAngle = 86, burn = true,
					windup = { Root = { -4, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 178, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					follow = { Root = { 8, 0, 0, 0, 0.14, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 184, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 44, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.18, 0 }, FL = { 0, 0, 0, 0, 0.18, 0 } },
					trail = "prop", fx = { { "particles", tex = "fire", color = FLAME, dir = "up", at = "hand", time = 0.2, speed = 14, size = 0.4, rate = 70 } }, hitText = "GRILLÉ !",
				},
				-- J en l'air : flambée en vol, un coup de flamme balayé sous elle
				P_air = {
					label = "Flambée en vol", startup = 0.08, active = 0.14, recovery = 0.14,
					damage = 6, hitbox = box(5, 4, 1.5, -1.5), kbBase = 18, kbGrowth = 28, kbAngle = -35, burn = true,
					windup = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 160, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 50, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 30, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 10, 0, 12 }, RE = { 4, 0, 0 }, RW = { 40, 0, 0 }, LS = { -28, 0, -50 }, LE = { 20, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "fire", color = FLAME, dir = "down", at = "hand", time = 0.2, speed = 12, size = 0.4, rate = 70 } }, hitText = "FSSHH !",
				},
				-- dash J : passage au chalumeau, elle fonce flamme devant comme une torche
				P_dash = {
					label = "Passage au chalumeau", startup = 0.07, active = 0.16, recovery = 0.2,
					damage = 7, hitbox = box(6, 3, 3.5, 0.5), kbBase = 24, kbGrowth = 42, kbAngle = 26, selfVelocity = Vector2.new(46, 0), burn = true,
					windup = { Root = { -8, -16, 0, 0, -0.3, 0.1 }, Waist = { -6, -16, 0 }, Neck = { 0, 10, 0 }, RS = { 50, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -18, 16, 0, 0, -0.4, -0.45 }, Waist = { -10, 16, 0 }, Neck = { 6, -14, 0 }, RS = { 94, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { -20, 18, 0, 0, -0.42, -0.55 }, Waist = { -12, 18, 0 }, Neck = { 6, -16, 0 }, RS = { 98, 0, 4 }, RE = { 0, 0, 0 }, RW = { 4, 0, 0 }, LS = { -36, 0, -44 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					trail = "prop", fx = { "dust", { "beam", color = FLAME, length = 6, width = 1, at = "hand" } }, text = "CHAUD DEVANT !", hitText = "ROUSSI !",
				},
				-- K : botte chauffée à blanc, elle passe sa semelle au chalumeau et l'enfonce dans le ventre
				K_neutral = {
					label = "Botte chauffée à blanc", startup = 0.15, active = 0.1, recovery = 0.26,
					damage = 10, hitbox = box(5, 3, 3, 0.3), kbBase = 28, kbGrowth = 60, kbAngle = 30, burn = true,
					windup = { Root = { 8, -10, 0, 0, -0.15, 0.2 }, Waist = { 8, -8, 0 }, Neck = { 4, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, RA = { 15, 0, 0 } },
					strike = { Root = { 18, -5, 0, 0, -0.1, -0.1 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 92, 0, 0 }, RK = { -2, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { 20, -3, 0, 0, -0.1, -0.12 }, Waist = { 14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -25, 0, 52 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
					trail = "rightFoot", windupFx = { { "particles", tex = "spark", color = EMBER, dir = "all", at = "feet", time = 0.15, speed = 8, size = 0.3, rate = 60 } }, hitText = "SSSS… BOUM !",
				},
				-- →K : coup de bouteille de gaz, elle balance le chalumeau par la bouteille comme une massue
				K_side = {
					label = "Coup de bouteille", startup = 0.16, active = 0.12, recovery = 0.28,
					damage = 11, hitbox = box(6, 3.5, 3.4, 0.6), kbBase = 30, kbGrowth = 68, kbAngle = 32, selfVelocity = Vector2.new(22, 0),
					windup = { Root = { 4, 40, 0, 0, -0.25, 0.2 }, Waist = { 6, 44, 0 }, Neck = { 0, -30, 0 }, RS = { 100, 0, 70 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -10, -30, 0, 0, -0.35, -0.4 }, Waist = { -12, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 92, 0, -30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -12, -42, 0, 0, -0.37, -0.45 }, Waist = { -14, -48, 0 }, Neck = { 0, 32, 0 }, RS = { 94, 0, -40 }, RE = { 4, 0, 0 }, RW = { -10, 0, 0 }, LS = { 44, 0, -54 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					trail = "prop", hitText = "KLONG !",
				},
				-- ↓K : balayette brûlante, elle fauche les jambes en traînant la flamme au ras du sol
				K_down = {
					label = "Balayette brûlante", startup = 0.14, active = 0.14, recovery = 0.26,
					damage = 10, hitbox = box(7, 2, 3.5, -1.8), kbBase = 26, kbGrowth = 54, kbAngle = 72, burn = true,
					windup = { Root = { 10, 10, 0, 0, -0.8, 0.1 }, Waist = { 14, 14, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 14, -20, 0, 0, -0.9, -0.1 }, Waist = { 18, -26, 0 }, RS = { 50, 0, 40 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 16, -26, 0, 0, -0.9, -0.14 }, Waist = { 20, -32, 0 }, RS = { 52, 0, 42 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust", { "beam", color = FLAME, length = 6, width = 0.8, at = "feet" } }, hitText = "FAUCHÉ ET GRILLÉ !",
				},
				-- ↑K : flamme montante, genou levé, elle ouvre le robinet à fond et la flamme jaillit vers le ciel
				K_up = {
					label = "Flamme montante", startup = 0.14, active = 0.14, recovery = 0.28,
					damage = 10, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 28, kbGrowth = 60, kbAngle = 88, burn = true,
					windup = { Root = { 8, 0, 0, 0, -0.35, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.05, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 60, 0, 0 }, LW = { -30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.08, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 182, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 154, 0, -12 }, LE = { 60, 0, 0 }, LW = { -30, 0, 0 }, RH = { 104, 0, 0 }, RK = { -124, 0, 0 } },
					trail = "prop", fx = { { "pillar", color = FLAME, height = 7, width = 1.2, at = "front" }, { "particles", tex = "fire", color = FLAME, dir = "up", at = "hand", time = 0.3, speed = 18, size = 0.5, rate = 90 } }, text = "À FOND !", hitText = "ROUSSI !",
				},
				-- K en l'air : talon fumant, la botte passée à la flamme s'abat de biais
				K_air = {
					label = "Talon fumant", startup = 0.12, active = 0.14, recovery = 0.2,
					damage = 10, hitbox = box(5.5, 3.5, 3, -0.5), kbBase = 26, kbGrowth = 54, kbAngle = 38, burn = true,
					windup = { Root = { -10, -20, 0 }, Waist = { -10, -10, 0 }, Neck = { 0, 15, 0 }, RS = { 60, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 100, 0, 20 }, RK = { -130, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { 20, -40, 0 }, Waist = { 8, -10, 0 }, Neck = { -10, 36, 0 }, RS = { 80, 0, 60 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -70 }, LE = { 30, 0, 0 }, RH = { 80, 0, 36 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { 24, -44, 0 }, Waist = { 10, -10, 0 }, Neck = { -12, 40, 0 }, RS = { 84, 0, 64 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -74 }, LE = { 30, 0, 0 }, RH = { 84, 0, 40 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
					trail = "rightFoot", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(80, 80, 80), dir = "all", at = "feet", time = 0.3, speed = 6, size = 0.6 } }, hitText = "SBLAF !",
				},
				-- dash K : glissade au gaz, elle se laisse glisser sur les genoux, flamme au ras du sol
				K_dash = {
					label = "Glissade au gaz", startup = 0.1, active = 0.24, recovery = 0.28,
					damage = 10, hitbox = box(6, 3, 3, -0.8), kbBase = 28, kbGrowth = 60, kbAngle = 38, selfVelocity = Vector2.new(54, 6), burn = true,
					windup = { Root = { -8, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, -0.95, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -50 }, LE = { 20, 0, 0 }, RH = { 10, 0, 6 }, RK = { -130, 0, 0 }, LH = { 10, 0, -6 }, LK = { -130, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, -0.97, 0.14 }, Waist = { -10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -46, 0, -54 }, LE = { 20, 0, 0 }, RH = { 12, 0, 8 }, RK = { -132, 0, 0 }, LH = { 12, 0, -8 }, LK = { -132, 0, 0 } },
					trail = "prop", fx = { "dust", { "particles", tex = "fire", color = FLAME, dir = "front", at = "hand", time = 0.3, speed = 14, size = 0.5, rate = 80 } }, text = "SKRRRT !", hitText = "GRILLÉ !",
				},
				-- L : jet de flamme, robinet ouvert à fond, un dard de feu bleu file droit sur l'adversaire
				S_neutral = {
					label = "Jet de flamme", kind = "projectile", startup = 0.2, active = 0, recovery = 0.42,
					damage = 12, kbBase = 24, kbGrowth = 40, kbAngle = 30, burn = true,
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.55, size = 1.8, color = FLAME, pierce = true, visual = FLAME_SHOT },
					windup = { Root = { 0, -14, 0, 0, -0.2, 0.15 }, Waist = { 0, -18, 0 }, Neck = { 4, 10, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 0 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -8, 10, 0, 0, -0.28, -0.3 }, Waist = { -8, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 10 }, LE = { 70, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, 12, 0, 0, -0.3, -0.34 }, Waist = { -10, 14, 0 }, Neck = { 0, -8, 0 }, RS = { 96, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 82, 0, 12 }, LE = { 70, 0, 0 }, LW = { -44, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, fx = { { "beam", color = FLAME, length = 14, width = 1.6, at = "hand" }, { "particles", tex = "fire", color = FLAME, dir = "front", at = "hand", time = 0.3, speed = 22, size = 0.6, rate = 100 } }, text = "PLEIN GAZ !", hitText = "CRAMÉ !",
				},
				-- →L : soudure à l'arc, elle avance en soudant tout le couloir d'un trait, trois gerbes d'étincelles
				S_side = {
					label = "Soudure à l'arc", startup = 0.22, active = 0.3, recovery = 0.45, hits = 3,
					damage = 5, hitbox = box(14, 5, 7, 1), kbBase = 26, kbGrowth = 48, kbAngle = 34, selfVelocity = Vector2.new(30, 0), burn = true,
					windup = { Root = { -4, -20, 0, 0, -0.25, 0.15 }, Waist = { -6, -24, 0 }, Neck = { -10, 14, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -14, 10, 0, 0, -0.35, -0.3 }, Waist = { -16, 12, 0 }, Neck = { -16, -6, 0 }, RS = { 90, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 0 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, -10, 0, 0, -0.37, -0.36 }, Waist = { -18, -12, 0 }, Neck = { -18, 6, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -20 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					wobble = true, trail = "prop", fx = { { "particles", tex = "spark", color = Color3.fromRGB(255, 240, 200), dir = "all", at = "hand", time = 0.4, speed = 20, size = 0.4, rate = 150 }, { "beam", color = FLAME, length = 14, width = 1.2, at = "hand" }, { "screen", color = FLAME, alpha = 0.15 } },
					text = "SOUDURE !", hitText = "TSSS TSSS TSSS !",
				},
				-- ↓L : fuite de gaz, elle ouvre la bouteille à ras du sol et allume : une flamme rase court le long du couloir
				S_down = {
					label = "Fuite de gaz", startup = 0.24, active = 0.22, recovery = 0.48,
					damage = 13, hitbox = box(14, 4, 7, -0.5), kbBase = 28, kbGrowth = 52, kbAngle = 70, burn = true,
					status = { name = "burning", duration = 2.5 },
					windup = { Root = { -8, 10, 0, 0, -0.75, 0.1 }, Waist = { -20, 10, 0 }, Neck = { -12, 0, 0 }, RS = { 50, 0, 20 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -12, -8, 0, 0, -0.9, -0.1 }, Waist = { -26, -8, 0 }, Neck = { -18, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { 80, 0, 0 }, LS = { 60, 0, -30 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 6, 0, 0, 0, -0.4, 0.2 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					hold = 0.1, windupFx = { { "particles", tex = "smoke", color = Color3.fromRGB(200, 200, 210), dir = "front", at = "feet", time = 0.25, speed = 10, size = 0.6 } },
					fx = { { "beam", color = EMBER, length = 16, width = 2.5, at = "feet" }, { "particles", tex = "fire", color = EMBER, dir = "front", at = "feet", time = 0.4, speed = 24, size = 0.8, rate = 120 }, { "shake", amount = 0.3 } },
					text = "ÇA SENT LE GAZ…", hitText = "WOUF !",
				},
				-- ↑L : réacteur à gaz, elle pointe le chalumeau vers le sol et décolle en diagonale sur la flamme, casquette au vent
				S_up = {
					label = "Réacteur à gaz", startup = 0.14, active = 0.3, recovery = 0.44,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 46, kbAngle = 76, selfVelocity = Vector2.new(42, 82), burn = true,
					windup = { Root = { -6, 0, 0, 0, -0.65, 0 }, Waist = { -16, 0, 0 }, Neck = { -4, 0, 0 }, RS = { -30, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -44, 0, 0, 0, 0.3, 0 }, Waist = { -4, 0, 0 }, Neck = { 28, 0, 0 }, RS = { -50, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 }, RH = { -25, 0, 6 }, RK = { -35, 0, 0 }, RA = { -30, 0, 0 }, LH = { -35, 0, -6 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -48, 0, 0, 0, 0.35, 0 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { -56, 0, 34 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -32 }, LE = { 20, 0, 0 }, RH = { -30, 0, 8 }, RK = { -45, 0, 0 }, RA = { -30, 0, 0 }, LH = { -40, 0, -8 }, LK = { -60, 0, 0 }, LA = { -30, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "fire", color = FLAME, dir = "down", at = "hand", time = 0.5, speed = 22, size = 0.7, rate = 110 }, { "ring", color = FLAME, radius = 4, at = "feet" }, { "burst", color = EMBER, size = 3, at = "feet" } },
					text = "DÉCOLLAGE !", hitText = "ROUSSI !",
				},
				-- L en l'air : flamme plongeante, un dard de feu tiré en piqué vers l'adversaire
				S_air = {
					label = "Flamme plongeante", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
					damage = 12, kbBase = 24, kbGrowth = 44, kbAngle = -40, burn = true,
					projectile = { speed = 90, angle = -45, gravity = 0, lifetime = 0.6, size = 1.8, color = FLAME, visual = FLAME_SHOT },
					windup = { Root = { -6, -15, 0 }, Waist = { -8, -15, 0 }, Neck = { 0, 10, 0 }, RS = { 150, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
					strike = { Root = { -10, 15, 0 }, Waist = { -14, 18, 0 }, Neck = { 20, -10, 0 }, RS = { 50, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					follow = { Root = { -12, 17, 0 }, Waist = { -16, 20, 0 }, Neck = { 24, -12, 0 }, RS = { 46, 0, 8 }, RE = { 4, 0, 0 }, RW = { 0, 0, 0 }, LS = { -26, 0, -52 }, LE = { 30, 0, 0 }, RH = { 26, 0, 0 }, RK = { -56, 0, 0 }, LH = { 64, 0, 0 }, LK = { -92, 0, 0 } },
					fx = { { "beam", color = FLAME, length = 10, width = 1.2, at = "hand" }, { "burst", color = FLAME, size = 1.8, at = "hand" } }, text = "EN PIQUÉ !", hitText = "CRAMÉ !",
				},
				-- Y : explosion de gaz, elle ouvre la bouteille à fond, compte jusqu'à trois… et tout le couloir part en champignon
				SUPER = {
					label = "Explosion de gaz !", startup = 0.45, active = 0.3, recovery = 0.75,
					damage = 24, hitbox = box(16, 8, 8, 2), kbBase = 44, kbGrowth = 92, kbAngle = 40, burn = true, invuln = 0.2,
					status = { name = "burning", duration = 3 },
					windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 24, 0, 0, 0, -0.5, 0.5 }, Waist = { 20, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 150, 0, 70 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -70 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.5 }, FL = { 0, 0, 0, 0, 0, 0.5 } },
					follow = { Root = { 30, 0, 0, 0, -0.6, 0.6 }, Waist = { 24, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 160, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -80 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.55 }, FL = { 0, 0, 0, 0, 0, 0.55 } },
					hold = 0.2, shake = true, windupFx = { "super", { "text", text = "3… 2… 1…", color = EMBER, at = "head" }, { "particles", tex = "smoke", color = Color3.fromRGB(200, 200, 210), dir = "front", at = "hand", time = 0.4, speed = 12, size = 0.8 } },
					fx = { { "burst", color = EMBER, size = 7, at = "front" }, { "pillar", color = FLAME, height = 20, width = 6, at = "front" }, { "ring", color = EMBER, radius = 9, at = "front" }, { "screen", color = EMBER, alpha = 0.35 }, { "particles", tex = "fire", color = EMBER, dir = "all", at = "front", time = 0.6, speed = 24, size = 1.2, rate = 150 }, { "shake", amount = 0.9 } },
					text = "BOUM !", hitText = "CARBONISÉ !",
				},
				-- →Y : lance-flammes, elle bloque le robinet avec sa clé et arrose tout le couloir d'un dragon de feu qui traverse tout
				SUPER_side = {
					label = "Lance-flammes !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 8, kbBase = 30, kbGrowth = 50, kbAngle = 36, burn = true,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1.0, size = 3, color = FLAME, pierce = true, hits = 3, fan = { count = 3, from = -4, to = 4, gap = 0.12 },
						visual = { shape = "ball", size = 2.8, color = EMBER, neon = true, spin = 10, parts = { { "ball", Vector3.new(1.6, 1.6, 1.6), Vector3.new(-1.2, 0.4, 0), FLAME }, { "ball", Vector3.new(1, 1, 1), Vector3.new(-2.2, -0.3, 0), FLAME } } } },
					status = { name = "burning", duration = 3 },
					windup = { Root = { 2, -20, 0, 0, -0.3, 0.2 }, Waist = { 2, -24, 0 }, Neck = { 4, 14, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 0 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 10, 0, 0, -0.4, -0.3 }, Waist = { -8, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 6 }, LE = { 50, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -14, 12, 0, 0, -0.42, -0.4 }, Waist = { -10, 14, 0 }, Neck = { 0, -8, 0 }, RS = { 98, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, 8 }, LE = { 50, 0, 0 }, LW = { -34, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					shake = true, prop = "cle", windupFx = { "super", { "text", text = "CRIIIC", color = STEEL, at = "hand" } },
					fx = { { "beam", color = FLAME, length = 18, width = 4, at = "hand" }, { "particles", tex = "fire", color = EMBER, dir = "front", at = "hand", time = 0.7, speed = 30, size = 1.2, rate = 160 }, { "screen", color = EMBER, alpha = 0.2 }, { "shake", amount = 0.5 } },
					text = "DRAGON !", hitText = "RÔTI !",
				},
				-- ↑Y : fusée à gaz, elle se met à califourchon sur la bouteille, dévisse le robinet d'un coup de clé et décolle au plafond avec tout le couloir
				SUPER_up = {
					label = "Fusée à gaz !", startup = 0.4, active = 0.3, recovery = 0.75,
					damage = 24, hitbox = box(14, 14, 7, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 60), burn = true,
					windup = { Root = { 6, 0, 0, 0, -0.6, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 40, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 30 }, RK = { -110, 0, 0 }, LH = { 60, 0, -30 }, LK = { -110, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 14, 0, 0 }, Neck = { 46, 0, 0 }, RS = { 44, 0, 12 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 188, 0, -12 }, LE = { 0, 0, 0 }, RH = { 64, 0, 32 }, RK = { -112, 0, 0 }, LH = { 64, 0, -32 }, LK = { -112, 0, 0 } },
					hold = 0.2, shake = true, prop = "cle", trail = "prop", windupFx = { "super", { "text", text = "CRIIIC", color = STEEL, at = "hand" } },
					fx = { { "pillar", color = FLAME, height = 24, width = 4, at = "front" }, { "burst", color = EMBER, size = 5, at = "feet" }, { "ring", color = FLAME, radius = 7, at = "feet" }, { "particles", tex = "fire", color = FLAME, dir = "down", at = "feet", time = 0.6, speed = 26, size = 1, rate = 140 }, { "shake", amount = 0.7 } },
					text = "YIIIHAA !", hitText = "AU PLAFOND, GRILLÉ !",
				},
				-- ↓Y : brasier au sol, elle verse tout le gaz par terre et craque une allumette avec ses dents : le couloir brûle longtemps
				SUPER_down = {
					label = "Brasier au sol !", startup = 0.42, active = 0.35, recovery = 0.7,
					damage = 22, hitbox = box(16, 5, 8, 0), kbBase = 40, kbGrowth = 84, kbAngle = 65, burn = true,
					status = { name = "burning", duration = 3 },
					windup = { Root = { -10, 0, 0, 0, -0.7, 0.1 }, Waist = { -22, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 60, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 4, 0, 0, 0, -0.3, 0.2 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -10 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 10, 0, 0, 0, -0.2, 0.4 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 70, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.3 } },
					hold = 0.2, windupFx = { "super", { "puddle", color = Color3.fromRGB(200, 200, 210), width = 16, time = 0.6 } },
					fx = { { "beam", color = EMBER, length = 16, width = 5, at = "feet" }, { "puddle", color = EMBER, width = 16, time = 2.5 }, { "particles", tex = "fire", color = EMBER, dir = "up", at = "front", time = 0.8, speed = 16, size = 1.2, rate = 150 }, { "screen", color = EMBER, alpha = 0.25 }, { "shake", amount = 0.6 } },
					text = "ET ON CRAQUE L'ALLUMETTE !", hitText = "BRASIER !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_neutral", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				K_side = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "cuvette", name = "Cuvette de WC", icon = "🚽",
			prop = { name = "PropCuvette", hand = "Right", pieces = {
				{ "Cuvette", "", "ball", Vector3.new(1.5, 0.9, 1.6), Vector3.new(0, -1.0, 0), Vector3.zero, PORCELAIN, "SmoothPlastic" },
				{ "Lunette", "", "cyl", Vector3.new(0.12, 1.6, 1.7), Vector3.new(0, -0.52, 0), Vector3.zero, PORCELAIN, "SmoothPlastic" },
				{ "Eau", "", "cyl", Vector3.new(0.08, 0.9, 0.9), Vector3.new(0, -0.5, 0), Vector3.zero, WATER, "SmoothPlastic" },
				{ "Reservoir", "", "block", Vector3.new(1.3, 1.1, 0.5), Vector3.new(0, -0.35, 0.95), Vector3.zero, PORCELAIN, "SmoothPlastic" },
				{ "Chasse", "", "cyl", Vector3.new(0.45, 0.1, 0.1), Vector3.new(0.55, 0.3, 0.95), Vector3.zero, BRASS, "Metal" },
				{ "Pied", "", "cyl", Vector3.new(0.6, 0.9, 1.0), Vector3.new(0, -1.7, 0), Vector3.zero, PORCELAIN, "SmoothPlastic" },
			} },
			ability = { damage = 1.2, text = "Dégâts +20 % : la porcelaine, c'est lourd" },
			moves = {
				-- J : coup de lunette lourd, à deux mains, dans le ventre
				P_neutral = {
					label = "Coup de lunette", startup = 0.13, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(5, 3.5, 2.8, 0.5), kbBase = 24, kbGrowth = 30, kbAngle = 30,
					windup = { Root = { 4, -14, 0, 0, -0.15, 0.15 }, Waist = { 6, -18, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 12, 0, 0, -0.3, -0.3 }, Waist = { -12, 16, 0 }, RS = { 96, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 16, 0, 0, -0.32, -0.36 }, Waist = { -14, 20, 0 }, RS = { 100, 0, 6 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -8 }, LE = { 14, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", hitText = "KLONG !",
				},
				-- →J : balayage de cuvette à l'horizontale, l'eau de la cuvette gicle au passage
				P_side = {
					label = "Balayage de cuvette", startup = 0.16, active = 0.12, recovery = 0.26,
					damage = 10, hitbox = box(6, 3.5, 3.5, 0.8), kbBase = 26, kbGrowth = 42, kbAngle = 28, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 6, 42, 0, 0, -0.2, 0.2 }, Waist = { 8, 46, 0 }, Neck = { 0, -30, 0 }, RS = { 70, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 90, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -40, 0, 0, -0.32, -0.4 }, Waist = { -12, -46, 0 }, Neck = { 0, 32, 0 }, RS = { 94, 0, -36 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 94, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { { "toss", shape = "ball", color = WATER, size = 0.4, count = 3, speed = 12 } }, hitText = "BLAM !",
				},
				-- ↓J : elle pose la cuvette lourdement sur les orteils de l'adversaire
				P_down = {
					label = "Cuvette sur les orteils", startup = 0.14, active = 0.1, recovery = 0.26,
					damage = 9, hitbox = box(5, 2.5, 2.5, -1.5), kbBase = 26, kbGrowth = 40, kbAngle = 80,
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -10 }, LE = { 40, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -0.9, -0.2 }, Waist = { 28, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 20, 0, 0, 0, -0.95, -0.24 }, Waist = { 30, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 36, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					fx = { "thud", "dust" }, hitText = "AÏE LES ORTEILS !",
				},
				-- ↑J : elle soulève la cuvette à bout de bras, le pied de porcelaine cogne le menton
				P_up = {
					label = "Cuvette au menton", startup = 0.14, active = 0.12, recovery = 0.26,
					damage = 9, hitbox = box(4.5, 5.5, 1.5, 3), kbBase = 26, kbGrowth = 45, kbAngle = 86,
					windup = { Root = { 10, 0, 0, 0, -0.35, 0.1 }, Waist = { 14, 0, 0 }, RS = { 30, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.1, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 172, 0, 8 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, -8 }, LE = { 6, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.14, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 178, 0, 10 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 178, 0, -10 }, LE = { 6, 0, 0 } },
					trail = "prop", hitText = "KLONK !",
				},
				-- J en l'air : elle lâche la cuvette sous elle et retombe assise dessus
				P_air = {
					label = "Cuvette tombante", startup = 0.12, active = 0.14, recovery = 0.18,
					damage = 10, hitbox = box(4.5, 4, 1, -1.8), kbBase = 24, kbGrowth = 40, kbAngle = -45,
					windup = { Root = { 8, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 185, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -10 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -28, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -5 }, LE = { 0, 0, 0 }, RH = { 90, 0, 10 }, RK = { -40, 0, 0 }, LH = { 90, 0, -10 }, LK = { -40, 0, 0 } },
					follow = { Root = { -14, 0, 0 }, Waist = { -32, 0, 0 }, RS = { 20, 0, 5 }, RE = { 8, 0, 0 }, RW = { -20, 0, 0 }, LS = { 20, 0, -5 }, LE = { 8, 0, 0 }, RH = { 95, 0, 10 }, RK = { -36, 0, 0 }, LH = { 95, 0, -10 }, LK = { -36, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash J : bélier de porcelaine, la cuvette en avant comme un bouclier, rien ne l'arrête
				P_dash = {
					label = "Bélier de porcelaine", startup = 0.1, active = 0.2, recovery = 0.3,
					damage = 11, hitbox = box(6, 4, 3, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 30, selfVelocity = Vector2.new(48, 0), armor = true,
					windup = { Root = { 10, -20, 0, 0, -0.2, 0.2 }, Waist = { 12, -24, 0 }, RS = { 80, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 100, 0, 0 } },
					strike = { Root = { 18, 10, 0, 0, -0.3, -0.3 }, Waist = { 14, 14, 0 }, Neck = { -10, 0, 0 }, RS = { 96, 0, 4 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -4 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 20, 12, 0, 0, -0.32, -0.36 }, Waist = { 16, 16, 0 }, Neck = { -12, 0, 0 }, RS = { 100, 0, 6 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -6 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { "dust" }, text = "DÉGAGEZ !", hitText = "BÉLIER !",
				},
				-- K : chasse d'eau, elle tire la chaînette et un paquet d'eau part de la cuvette (projectile court, trempe)
				K_neutral = {
					label = "Chasse d'eau", kind = "projectile", startup = 0.2, active = 0, recovery = 0.32,
					damage = 11, kbBase = 30, kbGrowth = 60, kbAngle = 30,
					projectile = { speed = 75, angle = 6, gravity = 30, lifetime = 0.4, size = 2, color = WATER, visual = "water", aim = false },
					status = { name = "wet", duration = 1.5 },
					windup = { Root = { 4, -12, 0, 0, -0.2, 0.15 }, Waist = { 6, -14, 0 }, Neck = { 4, 8, 0 }, RS = { 80, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -8, 8, 0, 0, -0.3, -0.25 }, Waist = { -10, 10, 0 }, Neck = { 0, -4, 0 }, RS = { 92, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 100, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, 10, 0, 0, -0.32, -0.3 }, Waist = { -12, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 94, 0, 6 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -24 }, LE = { 100, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					fx = { { "particles", tex = "smoke", color = WATER, dir = "front", at = "hand", time = 0.3, speed = 16, size = 0.6, rate = 80 }, { "text", text = "FLOUUUSH", color = WATER, at = "hand" } }, hitText = "SPLASH !",
				},
				-- →K : coup de pied sauté, la cuvette serrée contre elle en bouclier
				K_side = {
					label = "Botte-bouclier", startup = 0.16, active = 0.14, recovery = 0.32,
					damage = 13, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 34, kbGrowth = 74, kbAngle = 36, selfVelocity = Vector2.new(26, 18),
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.1 }, Waist = { 8, -8, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, 0.1, -0.1 }, Waist = { 12, 0, 0 }, RS = { 70, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 100, 0, 0 }, RH = { 100, 0, 10 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { -20, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, 0.12, -0.14 }, Waist = { 14, 0, 0 }, RS = { 74, 0, 12 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 74, 0, -12 }, LE = { 100, 0, 0 }, RH = { 108, 0, 12 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { -24, 0, 0 }, LK = { -64, 0, 0 } },
					trail = "rightFoot", hitText = "VLAN !",
				},
				-- ↓K : assise sur la cuvette (comme aux toilettes, journal à la main), elle balaie des deux bottes
				K_down = {
					label = "Balayage sur le trône", startup = 0.16, active = 0.16, recovery = 0.34,
					damage = 11, hitbox = box(7, 2.2, 3.5, -1.6), kbBase = 28, kbGrowth = 54, kbAngle = 76,
					windup = { Root = { 6, 0, 0, 0, -0.5, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.75, -0.15 }, Waist = { 18, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 50, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 30, 0, 0 }, RH = { 90, 0, 10 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 }, LH = { 90, 0, -10 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 16, 0, 0, 0, -0.78, -0.18 }, Waist = { 20, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 54, 0, 44 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -44 }, LE = { 30, 0, 0 }, RH = { 96, 0, 12 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 }, LH = { 96, 0, -12 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "bothFeet", fx = { "dust", { "symbols", symbols = { "📰" }, color = PORCELAIN, count = 1, radius = 1.5, at = "head" } }, hitText = "FAUCHÉ !",
				},
				-- ↑K : elle balance la cuvette en l'air et la suit d'un coup de botte monté
				K_up = {
					label = "Cuvette envoyée", startup = 0.18, active = 0.14, recovery = 0.34,
					damage = 12, hitbox = box(5, 6, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.1 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 176, 0, -12 }, LE = { 10, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { { "toss", shape = "ball", color = WATER, size = 0.5, count = 4, speed = 14 } }, hitText = "ET HOP !",
				},
				-- K en l'air : assise sur la cuvette en plein vol, elle tombe d'un bloc, le trône en premier
				K_air = {
					label = "Trône tombant", startup = 0.16, active = 0.16, recovery = 0.28,
					damage = 12, hitbox = box(5.5, 4, 1.5, -1.5), kbBase = 30, kbGrowth = 70, kbAngle = -40,
					windup = { Root = { -8, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 160, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -30 }, LE = { 20, 0, 0 }, RH = { 60, 0, 10 }, RK = { -90, 0, 0 }, LH = { 60, 0, -10 }, LK = { -90, 0, 0 } },
					strike = { Root = { 14, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 60, 0, 0 }, RH = { 100, 0, 25 }, RK = { -110, 0, 0 }, LH = { 100, 0, -25 }, LK = { -110, 0, 0 } },
					follow = { Root = { 16, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 64, 0, 64 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -64 }, LE = { 60, 0, 0 }, RH = { 104, 0, 28 }, RK = { -112, 0, 0 }, LH = { 104, 0, -28 }, LK = { -112, 0, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "🚽", "💧" }, color = WATER, count = 2, radius = 2, at = "feet" } }, text = "OCCUPÉ !", hitText = "ÉCRASÉ SOUS LE TRÔNE !",
				},
				-- dash K : luge de porcelaine, assise sur la cuvette, elle glisse sur le sol mouillé bottes devant
				K_dash = {
					label = "Luge de porcelaine", startup = 0.12, active = 0.3, recovery = 0.34,
					damage = 13, hitbox = box(6, 4, 3, -0.5), kbBase = 32, kbGrowth = 68, kbAngle = 40, selfVelocity = Vector2.new(52, 14), armor = true,
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.75, 0.1 }, Waist = { 16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 60, 0, 0 }, RH = { 95, 0, 15 }, RK = { -20, 0, 0 }, RA = { 10, 0, 0 }, LH = { 95, 0, -15 }, LK = { -20, 0, 0 }, LA = { 10, 0, 0 } },
					follow = { Root = { 16, 0, 0, 0, -0.78, 0.14 }, Waist = { 18, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 44, 0, 64 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 44, 0, -64 }, LE = { 60, 0, 0 }, RH = { 100, 0, 15 }, RK = { -16, 0, 0 }, RA = { 14, 0, 0 }, LH = { 100, 0, -15 }, LK = { -16, 0, 0 }, LA = { 14, 0, 0 } },
					trail = "body", fx = { { "puddle", color = WATER, width = 8 }, "dust" }, text = "YAHOU !", hitText = "ÉCRASÉ !",
				},
				-- L : grande chasse, elle tire la chaînette à fond : un torrent d'eau part de la cuvette droit sur l'adversaire
				S_neutral = {
					label = "Grande chasse", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 13, kbBase = 28, kbGrowth = 50, kbAngle = 35,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.6, size = 2.6, color = WATER, visual = "water" },
					status = { name = "wet", duration = 2.5 },
					windup = { Root = { 4, -14, 0, 0, -0.2, 0.15 }, Waist = { 6, -16, 0 }, Neck = { 4, 8, 0 }, RS = { 80, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 10, 0, 0, -0.32, -0.3 }, Waist = { -12, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 94, 0, 4 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 12, 0, 0, -0.34, -0.36 }, Waist = { -14, 14, 0 }, Neck = { 0, -8, 0 }, RS = { 96, 0, 6 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -24 }, LE = { 110, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, fx = { { "beam", color = WATER, length = 14, width = 2.5, at = "hand" }, { "particles", tex = "smoke", color = WATER, dir = "front", at = "hand", time = 0.35, speed = 20, size = 0.8, rate = 100 }, { "text", text = "FLOUUUUSH", color = WATER, at = "hand" } },
					text = "GRANDE CHASSE !", hitText = "RINCÉ !",
				},
				-- →L : siphon aspirant, elle pointe la cuvette devant elle et tire la chasse à l'envers : tout le couloir est aspiré vers la cuvette… puis recraché
				S_side = {
					label = "Siphon aspirant", kind = "absorb", startup = 0.24, active = 0.3, recovery = 0.5,
					damage = 14, hitbox = box(14, 6, 7, 1), kbBase = 30, kbGrowth = 54, kbAngle = 30, pull = true,
					absorb = { radius = 8, offset = 5 },
					windup = { Root = { 6, -20, 0, 0, -0.25, 0.2 }, Waist = { 8, -24, 0 }, Neck = { 4, 14, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -12, 10, 0, 0, -0.4, -0.3 }, Waist = { -16, 12, 0 }, Neck = { -4, -6, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 0 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { 10, 0, 0, 0, -0.3, 0.3 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 80, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 50, 0, 0 } },
					hold = 0.2, shake = true, trail = "prop", fx = { { "particles", tex = "smoke", color = WATER, dir = "front", at = "front", time = 0.5, speed = 14, size = 0.8, rate = 100 }, { "beam", color = WATER, length = 14, width = 3, at = "hand" }, { "ring", color = WATER, radius = 6, at = "front" } },
					text = "SCHLOOORP !", hitText = "ASPIRÉ… RECRACHÉ !",
				},
				-- ↓L : elle pose la cuvette au sol et la pousse du pied : elle roule sur tout le couloir en débordant
				S_down = {
					label = "Cuvette roulante", kind = "projectile", startup = 0.22, active = 0, recovery = 0.5,
					damage = 13, kbBase = 30, kbGrowth = 56, kbAngle = 40,
					projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 0.9, size = 2.6, color = PORCELAIN, pierce = true, from = "feet", aim = false, visual = TOILET_SHOT },
					status = { name = "wet", duration = 2 },
					windup = { Root = { 12, 0, 0, 0, -0.9, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 60, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 30, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, -0.35, -0.1 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -50 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 8, 0, 0, 0, -0.35, -0.12 }, Waist = { 10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 28, 0, 42 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -52 }, LE = { 40, 0, 0 }, RH = { 86, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					hideProp = "cuvette", trail = "rightFoot", fx = { "dust", { "toss", shape = "ball", color = WATER, size = 0.5, count = 4, speed = 14 } }, text = "ROULE !", hitText = "ÉCRABOUILLÉ !",
				},
				-- ↑L : jet de chasse, elle s'assoit sur la cuvette, tire la chaînette et la colonne d'eau la propulse en diagonale, trône compris
				S_up = {
					label = "Jet de chasse", startup = 0.15, active = 0.3, recovery = 0.45,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 48, kbAngle = 78, selfVelocity = Vector2.new(42, 82),
					status = { name = "wet", duration = 2 },
					windup = { Root = { 6, 0, 0, 0, -0.75, 0 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.3, 0 }, Waist = { -2, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 110, 0, 0 }, LW = { -40, 0, 0 }, RH = { 80, 0, 20 }, RK = { -100, 0, 0 }, LH = { 80, 0, -20 }, LK = { -100, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.35, 0 }, Waist = { -4, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 64, 0, 32 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 36, 0, -32 }, LE = { 110, 0, 0 }, LW = { -44, 0, 0 }, RH = { 84, 0, 22 }, RK = { -104, 0, 0 }, LH = { 84, 0, -22 }, LK = { -104, 0, 0 } },
					trail = "prop", fx = { { "pillar", color = WATER, height = 8, width = 2.5, at = "root", time = 0.4 }, { "particles", tex = "smoke", color = WATER, dir = "down", at = "feet", time = 0.5, speed = 20, size = 0.8, rate = 100 }, { "ring", color = WATER, radius = 5, at = "feet" } },
					text = "FLOUUUSH !", hitText = "RINCÉ !",
				},
				-- L en l'air : chasse plongeante, cuvette retournée au-dessus de l'adversaire, toute l'eau lui tombe dessus
				S_air = {
					label = "Chasse plongeante", kind = "projectile", startup = 0.16, active = 0, recovery = 0.42,
					damage = 13, kbBase = 26, kbGrowth = 48, kbAngle = -50,
					projectile = { speed = 75, angle = -55, gravity = 20, lifetime = 0.6, size = 2.4, color = WATER, visual = "water" },
					status = { name = "wet", duration = 2 },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 185, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, 10 }, LE = { 20, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, 10 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 50, 0, 0 }, LK = { -85, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 34, 0, 12 }, RE = { 4, 0, 0 }, RW = { 100, 0, 0 }, LS = { 34, 0, 12 }, LE = { 4, 0, 0 }, LW = { 100, 0, 0 }, RH = { 16, 0, 0 }, RK = { -46, 0, 0 }, LH = { 54, 0, 0 }, LK = { -88, 0, 0 } },
					trail = "prop", fx = { { "burst", color = WATER, size = 2.5, at = "hand" }, { "rain", shape = "ball", color = WATER, count = 8, radius = 3, size = 0.4 } }, text = "PLOUF !", hitText = "TREMPÉ !",
				},
				-- Y : tout aux égouts, elle lève la cuvette au-dessus de sa tête et la claque au sol : la chasse géante aspire tout le couloir et l'envoie dans les tuyaux
				SUPER = {
					label = "Tout aux égouts !", startup = 0.45, active = 0.3, recovery = 0.8,
					damage = 24, hitbox = box(14, 7, 7, 1), kbBase = 46, kbGrowth = 94, kbAngle = 36,
					status = { name = "wet", duration = 3 },
					windup = { Root = { 10, 0, 0, 0, 0.1, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 190, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -5 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.9, -0.3 }, Waist = { -32, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -5 }, LE = { 0, 0, 0 } },
					follow = { Root = { -20, 0, 0, 0, -0.95, -0.34 }, Waist = { -34, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -5 }, LE = { 0, 0, 0 } },
					hold = 0.3, shake = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🚽", "🌀" }, count = 5, radius = 3, color = WATER } },
					fx = { { "burst", color = PORCELAIN, size = 5, at = "front" }, { "ring", color = WATER, radius = 9, at = "front" }, { "beam", color = WATER, length = 16, width = 4, at = "feet" }, { "particles", tex = "smoke", color = WATER, dir = "front", at = "front", time = 0.6, speed = 22, size = 1.2, rate = 150 }, { "text", text = "FLOUUUUUUSH", color = WATER, at = "front" }, { "shake", amount = 0.8 } },
					text = "TOUT AUX ÉGOUTS !", hitText = "DANS LES TUYAUX !",
				},
				-- →Y : cuvette-boulet, elle fait tournoyer la cuvette par la chaînette comme un marteau et la lâche : un boulet de porcelaine traverse le couloir
				SUPER_side = {
					label = "Cuvette-boulet !", kind = "projectile", startup = 0.42, active = 0, recovery = 0.7,
					damage = 26, kbBase = 48, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3.6, color = PORCELAIN, pierce = true, visual = TOILET_SHOT },
					status = { name = "wet", duration = 2 },
					windup = { Root = { 0, -50, 0, 0, -0.4, 0.2 }, Waist = { -4, -46, 0 }, Neck = { 0, 34, 0 }, RS = { 60, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -14, 30, 0, 0, -0.4, -0.5 }, Waist = { -16, 34, 0 }, Neck = { 0, -24, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { -16, 34, 0, 0, -0.42, -0.56 }, Waist = { -18, 38, 0 }, Neck = { 0, -28, 0 }, RS = { 98, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 26, 0, -54 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.58 } },
					spin = { axis = "y", degrees = 720 }, hideProp = "cuvette", windupFx = { "super", { "symbols", symbols = { "🚽" }, count = 6, radius = 3, color = PORCELAIN } },
					fx = { { "burst", color = PORCELAIN, size = 4, at = "hand" }, { "ring", color = WATER, radius = 5, at = "front" }, { "shake", amount = 0.5 } },
					text = "BOULET DE PORCELAINE !", hitText = "KA-BLONG !",
				},
				-- ↑Y : geyser de chasse, elle colle la cuvette au sol, s'assoit dessus et tire la chaînette : une colonne d'eau arrache le couloir vers le plafond
				SUPER_up = {
					label = "Geyser de chasse !", startup = 0.4, active = 0.3, recovery = 0.8,
					damage = 24, hitbox = box(14, 14, 7, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 58),
					status = { name = "wet", duration = 3 },
					windup = { Root = { 8, 0, 0, 0, -0.7, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -10 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 12, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 110, 0, 0 }, LW = { -50, 0, 0 }, RH = { 90, 0, 25 }, RK = { -110, 0, 0 }, LH = { 90, 0, -25 }, LK = { -110, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 16, 0, 0 }, Neck = { 46, 0, 0 }, RS = { 64, 0, 44 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 26, 0, -32 }, LE = { 110, 0, 0 }, LW = { -54, 0, 0 }, RH = { 94, 0, 28 }, RK = { -112, 0, 0 }, LH = { 94, 0, -28 }, LK = { -112, 0, 0 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super" },
					fx = { { "pillar", color = WATER, height = 24, width = 5, at = "front" }, { "burst", color = WATER, size = 5, at = "feet" }, { "rain", shape = "ball", color = WATER, count = 16, radius = 8, size = 0.5 }, { "ring", color = WATER, radius = 7, at = "feet" }, { "screen", color = WATER, alpha = 0.25 }, { "shake", amount = 0.7 } },
					text = "GEYSER DE CHASSE !", hitText = "AU PLAFOND, TREMPÉ !",
				},
				-- ↓Y : raz-de-marée de WC, elle renverse la cuvette au sol et tire la chaînette : une vague déferle au ras du sol sur tout le couloir, tout le monde glisse
				SUPER_down = {
					label = "Raz-de-marée de WC !", startup = 0.4, active = 0.35, recovery = 0.75,
					damage = 22, hitbox = box(16, 5, 8, 0), kbBase = 42, kbGrowth = 86, kbAngle = 55,
					status = { name = "slippery", duration = 3 },
					windup = { Root = { 8, 0, 0, 0, -0.5, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.9, -0.2 }, Waist = { -30, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 100, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -20, 0, 0, 0, -0.95, -0.24 }, Waist = { -32, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 46, 0, 12 }, RE = { 0, 0, 0 }, RW = { 70, 0, 0 }, LS = { 36, 0, -22 }, LE = { 100, 0, 0 }, LW = { -56, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.25, trail = "prop", windupFx = { "super" },
					fx = { { "shake", amount = 0.8 }, { "puddle", color = WATER, width = 16, time = 2.5 }, { "beam", color = WATER, length = 16, width = 5, at = "feet" }, { "toss", shape = "ball", color = WATER, size = 0.7, count = 10, speed = 24 }, { "burst", color = PORCELAIN, size = 3, at = "front" }, { "text", text = "FLOUUUUSH", color = WATER, at = "front" } },
					text = "RAZ-DE-MARÉE !", hitText = "EMPORTÉ PAR LA CHASSE !",
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
	},

	look = {
		body = { head = SKIN, upper = SHIRT, lower = DENIM, arms = SHIRT, forearms = SKIN, hands = GLOVE, legs = DENIM, feet = BOOT },
		cubeHead = 1.25,
		parts = {
			-- casquette à l'envers (visière derrière), goutte d'eau sur le devant, frange et queue de cheval
			{ "Casquette", "Head", "ball", Vector3.new(1.38, 0.62, 1.38), Vector3.new(0, 0.6, 0), Vector3.zero, CAP, "Fabric" },
			{ "Visiere", "Head", "block", Vector3.new(1.0, 0.08, 0.65), Vector3.new(0, 0.5, 0.92), Vector3.new(-8, 0, 0), CAP, "Fabric" },
			{ "LogoGoutte", "Head", "ball", Vector3.new(0.26, 0.34, 0.08), Vector3.new(0, 0.66, -0.68), Vector3.zero, WATER, "SmoothPlastic" },
			{ "Frange", "Head", "block", Vector3.new(1.28, 0.18, 0.1), Vector3.new(0, 0.36, -0.64), Vector3.zero, HAIR, "Fabric" },
			{ "QueueDeCheval", "Head", "ball", Vector3.new(0.45, 0.85, 0.45), Vector3.new(0, -0.1, 0.8), Vector3.new(20, 0, 0), HAIR, "Fabric" },
			-- visage : yeux vifs, nez retroussé, grand sourire
			{ "OeilG", "Head", "ball", Vector3.new(0.18, 0.24, 0.1), Vector3.new(-0.26, 0.08, -0.63), Vector3.zero, Color3.fromRGB(25, 25, 30) },
			{ "OeilD", "Head", "ball", Vector3.new(0.18, 0.24, 0.1), Vector3.new(0.26, 0.08, -0.63), Vector3.zero, Color3.fromRGB(25, 25, 30) },
			{ "Nez", "Head", "ball", Vector3.new(0.24, 0.22, 0.25), Vector3.new(0, -0.1, -0.68), Vector3.zero, Color3.fromRGB(235, 160, 130) },
			{ "Sourire", "Head", "block", Vector3.new(0.45, 0.07, 0.06), Vector3.new(0, -0.34, -0.63), Vector3.zero, Color3.fromRGB(120, 40, 40) },
			-- salopette : bavette, bretelles, boutons dorés, poche
			{ "Bavette", "UpperTorso", "block", Vector3.new(1.3, 1.0, 0.1), Vector3.new(0, -0.3, -0.53), Vector3.zero, DENIM, "Fabric" },
			{ "BretelleG", "UpperTorso", "block", Vector3.new(0.25, 1.4, 0.08), Vector3.new(-0.55, 0.2, -0.53), Vector3.new(0, 0, -6), DENIM, "Fabric" },
			{ "BretelleD", "UpperTorso", "block", Vector3.new(0.25, 1.4, 0.08), Vector3.new(0.55, 0.2, -0.53), Vector3.new(0, 0, 6), DENIM, "Fabric" },
			{ "BoutonG", "UpperTorso", "cyl", Vector3.new(0.06, 0.2, 0.2), Vector3.new(-0.52, 0.18, -0.59), Vector3.zero, BRASS, "Metal", { axis = "z" } },
			{ "BoutonD", "UpperTorso", "cyl", Vector3.new(0.06, 0.2, 0.2), Vector3.new(0.52, 0.18, -0.59), Vector3.zero, BRASS, "Metal", { axis = "z" } },
			{ "PocheBavette", "UpperTorso", "block", Vector3.new(0.6, 0.4, 0.05), Vector3.new(0, -0.3, -0.6), Vector3.zero, DENIM_DARK, "Fabric" },
			-- ceinture d'outils : tournevis, mètre ruban, petite clé
			{ "Ceinture", "LowerTorso", "block", Vector3.new(2.1, 0.35, 1.15), Vector3.new(0, 0.15, 0), Vector3.zero, LEATHER, "Leather" },
			{ "Pochette", "LowerTorso", "block", Vector3.new(0.5, 0.5, 0.3), Vector3.new(0.72, -0.15, -0.6), Vector3.zero, LEATHER, "Leather" },
			{ "Tournevis", "LowerTorso", "cyl", Vector3.new(0.55, 0.14, 0.14), Vector3.new(0.82, 0.2, -0.66), Vector3.zero, BOOT, "SmoothPlastic" },
			{ "MetreRuban", "LowerTorso", "cyl", Vector3.new(0.3, 0.45, 0.45), Vector3.new(-1.1, 0, -0.2), Vector3.zero, BOOT, "SmoothPlastic", { axis = "x" } },
			{ "PetiteCle", "LowerTorso", "block", Vector3.new(0.14, 0.7, 0.08), Vector3.new(-0.45, -0.25, -0.62), Vector3.new(0, 0, 12), STEEL, "Metal" },
			-- bottes de caoutchouc jaunes
			{ "BotteG", "LeftLowerLeg", "block", Vector3.new(1.08, 0.95, 1.08), Vector3.new(0, -0.35, 0), Vector3.zero, BOOT, "Rubber" },
			{ "BotteD", "RightLowerLeg", "block", Vector3.new(1.08, 0.95, 1.08), Vector3.new(0, -0.35, 0), Vector3.zero, BOOT, "Rubber" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : la ventouse géante (manche en bois, cloche en caoutchouc vers le bas)
			{ name = "PropVentouse", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(3.0, 0.28, 0.28), Vector3.new(0, -1.2, 0), Vector3.zero, HANDLE, "Wood" },
				{ "Pommeau", "", "ball", Vector3.new(0.38, 0.38, 0.38), Vector3.new(0, 0.32, 0), Vector3.zero, HANDLE, "Wood" },
				{ "Cloche", "", "ball", Vector3.new(1.6, 1.1, 1.6), Vector3.new(0, -3.0, 0), Vector3.zero, RUBBER, "Rubber" },
				{ "Rebord", "", "cyl", Vector3.new(0.15, 1.75, 1.75), Vector3.new(0, -3.4, 0), Vector3.zero, RUBBER_DARK, "Rubber" },
			} },
			-- clé à molette (main gauche)
			{ name = "PropCle", hand = "Left", visible = false, pieces = {
				{ "Tige", "", "block", Vector3.new(0.25, 1.6, 0.12), Vector3.new(0, -0.75, 0), Vector3.zero, STEEL, "Metal" },
				{ "Machoire", "", "block", Vector3.new(0.75, 0.35, 0.16), Vector3.new(0.12, -1.65, 0), Vector3.zero, STEEL, "Metal" },
				{ "Molette", "", "cyl", Vector3.new(0.18, 0.3, 0.3), Vector3.new(0, -1.35, 0), Vector3.zero, BRASS, "Metal", { axis = "z" } },
			} },
			-- bout de tuyau (main gauche)
			{ name = "PropTuyau", hand = "Left", visible = false, pieces = {
				{ "Tuyau", "", "cyl", Vector3.new(3.2, 0.42, 0.42), Vector3.new(0, -1.25, 0), Vector3.zero, Color3.fromRGB(120, 140, 130), "Metal" },
				{ "Raccord", "", "cyl", Vector3.new(0.3, 0.55, 0.55), Vector3.new(0, 0.2, 0), Vector3.zero, BRASS, "Metal" },
				{ "Coude", "", "cyl", Vector3.new(0.4, 0.55, 0.55), Vector3.new(0, -2.85, 0), Vector3.zero, BRASS, "Metal" },
			} },
			-- serre-joint (main gauche)
			{ name = "PropSerre", hand = "Left", visible = false, pieces = {
				{ "Barre", "", "block", Vector3.new(0.15, 1.6, 0.15), Vector3.new(0, -0.8, 0), Vector3.zero, STEEL, "Metal" },
				{ "MorsHaut", "", "block", Vector3.new(0.85, 0.22, 0.32), Vector3.new(0.38, -0.2, 0), Vector3.zero, RUBBER, "SmoothPlastic" },
				{ "MorsBas", "", "block", Vector3.new(0.85, 0.22, 0.32), Vector3.new(0.38, -1.45, 0), Vector3.zero, RUBBER, "SmoothPlastic" },
			} },
			-- valve : bout de tuyau avec son volant rouge (Jet de fuite, Inondation, Pression)
			{ name = "PropValve", hand = "Left", visible = false, pieces = {
				{ "Tube", "", "cyl", Vector3.new(1.4, 0.45, 0.45), Vector3.new(0, -0.65, 0), Vector3.zero, STEEL, "Metal" },
				{ "Volant", "", "cyl", Vector3.new(0.12, 0.95, 0.95), Vector3.new(0, -0.55, -0.4), Vector3.zero, RUBBER, "Metal", { axis = "z" } },
				{ "Bec", "", "cyl", Vector3.new(0.3, 0.6, 0.6), Vector3.new(0, -1.4, 0), Vector3.zero, BRASS, "Metal" },
			} },
			-- ventouse gigantesque du Grand Débouchage
			{ name = "PropGeante", hand = "Right", visible = false, pieces = {
				{ "Manche", "", "cyl", Vector3.new(4.2, 0.5, 0.5), Vector3.new(0, -1.7, 0), Vector3.zero, HANDLE, "Wood" },
				{ "Cloche", "", "ball", Vector3.new(4.2, 2.8, 4.2), Vector3.new(0, -4.6, 0), Vector3.zero, RUBBER, "Rubber" },
				{ "Rebord", "", "cyl", Vector3.new(0.3, 4.5, 4.5), Vector3.new(0, -5.7, 0), Vector3.zero, RUBBER_DARK, "Rubber" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Clé à molette : crochet sec du gauche, la clé sortie de la ceinture
		P_neutral = {
			label = "Clé à molette", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 5, hitbox = box(4, 3, 2.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 2, 20, 0, 0, -0.2, 0.1 }, Waist = { 2, 22, 0 }, Neck = { 0, -15, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 70, 0, -60 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, -15, 0, 0, -0.25, -0.25 }, Waist = { -6, -22, 0 }, Neck = { 0, 12, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 95, 0, 10 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -7, -18, 0, 0, -0.25, -0.28 }, Waist = { -7, -26, 0 }, Neck = { 0, 14, 0 }, RS = { 25, 0, 26 }, RE = { 70, 0, 0 }, LS = { 92, 0, 22 }, LE = { 35, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
			prop = "cle", trail = "leftHand", hitText = "CLANK !",
		},
		-- Coup de botte (P P) : genou monté, la grosse botte jaune part droit dans le ventre
		P_combo2 = {
			label = "Coup de botte", startup = 0.08, active = 0.08, recovery = 0.16,
			damage = 6, hitbox = box(4.5, 3.5, 3, 0), kbBase = 20, kbGrowth = 28, kbAngle = 30,
			windup = { Root = { 6, -5, 0, 0, -0.15, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { 85, 0, 0 }, RK = { -110, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.1, -0.1 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 10, 0, 40 }, RE = { 50, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { 80, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 16, 0, 0, 0, -0.1, -0.12 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 5, 0, 42 }, RE = { 50, 0, 0 }, LS = { 52, 0, -42 }, LE = { 70, 0, 0 }, RH = { 84, 0, 0 }, RK = { -2, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", hitText = "BOTTE !",
		},
		-- Bonk de ventouse (P P P) : ventouse levée à deux mains au-dessus de la casquette puis plaquée devant
		P_combo3 = {
			label = "Bonk de ventouse", startup = 0.09, active = 0.1, recovery = 0.28,
			damage = 8, hitbox = box(5, 4, 3, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 40,
			windup = { Root = { 8, -10, 0, 0, -0.05, 0.2 }, Waist = { 14, -10, 0 }, Neck = { 8, 0, 0 }, RS = { 185, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, 25 }, LE = { 50, 0, 0 } },
			strike = { Root = { -14, 8, 0, 0, -0.45, -0.4 }, Waist = { -26, 10, 0 }, Neck = { -4, 0, 0 }, RS = { 90, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 25 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, 10, 0, 0, -0.5, -0.45 }, Waist = { -30, 12, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 0 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { 62, 0, 25 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", fx = { { "ring", color = RUBBER, radius = 2.5, at = "front" } }, text = "DÉBOUCHÉ !", hitText = "SPLOTCH !",
		},
		-- Coup de tuyau : le tuyau part de l'épaule droite et balaie violemment à l'horizontale (revers du gauche)
		P_side = {
			label = "Coup de tuyau", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(6, 3, 3.2, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 20, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { 4, 30, 0, 0, -0.3, 0.25 }, Waist = { 6, 35, 0 }, Neck = { 0, -30, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 }, LS = { 85, 0, 45 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, -25, 0, 0, -0.4, -0.4 }, Waist = { -12, -35, 0 }, Neck = { 0, 25, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 95, 0, -35 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -12, -34, 0, 0, -0.42, -0.45 }, Waist = { -14, -46, 0 }, Neck = { 0, 32, 0 }, RS = { 18, 0, 38 }, RE = { 60, 0, 0 }, LS = { 88, 0, -65 }, LE = { 10, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			prop = "tuyau", trail = "leftHand", hitText = "BLONG !",
		},
		-- Retour de tuyau (→P P) : le tuyau revient dans l'autre sens, coup droit
		P_side2 = {
			label = "Retour de tuyau", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 6, hitbox = box(5.5, 3.5, 3, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 25, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { -6, -30, 0, 0, -0.4, -0.3 }, Waist = { -8, -40, 0 }, Neck = { 0, 30, 0 }, RS = { 20, 0, 35 }, RE = { 60, 0, 0 }, LS = { 90, 0, -70 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, 20, 0, 0, -0.35, -0.4 }, Waist = { -8, 28, 0 }, Neck = { 0, -20, 0 }, RS = { 25, 0, 25 }, RE = { 65, 0, 0 }, LS = { 95, 0, 30 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -6, 28, 0, 0, -0.35, -0.42 }, Waist = { -8, 38, 0 }, Neck = { 0, -26, 0 }, RS = { 25, 0, 25 }, RE = { 65, 0, 0 }, LS = { 90, 0, 50 }, LE = { 15, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
			prop = "tuyau", trail = "leftHand", hitText = "BLING !",
		},
		-- Serre-joint : accroupie, elle plaque le serre-joint sur les orteils adverses et serre (il reste collé au sol)
		P_down = {
			label = "Serre-joint", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 5, hitbox = box(4, 1.6, 2.5, -2.2), kbBase = 15, kbGrowth = 15, kbAngle = 60,
			status = { name = "rooted", duration = 0.7 },
			windup = { Root = { -8, 15, 0, 0, -0.75, 0.1 }, Waist = { -20, 12, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 120, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, -5, 0, 0, -0.95, -0.15 }, Waist = { -30, -6, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, 35 }, RE = { 50, 0, 0 }, LS = { 35, 0, -10 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -15, -8, 0, 0, -0.95, -0.18 }, Waist = { -32, -8, 0 }, Neck = { -22, 0, 0 }, RS = { 52, 0, 36 }, RE = { 50, 0, 0 }, LS = { 30, 0, -12 }, LE = { 12, 0, 0 }, LW = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
			prop = "serre", text = "SERRÉ !", hitText = "AÏE MES ORTEILS !",
		},
		-- Ventouse anti-air (↑P, ex-←P) : accroupie, elle pique la ventouse tout droit vers le ciel à deux mains
		P_up = {
			label = "Ventouse anti-air", startup = 0.09, active = 0.12, recovery = 0.2,
			damage = 6, hitbox = box(4, 5, 1.2, 3.5), kbBase = 26, kbGrowth = 30, kbAngle = 88,
			windup = { Root = { -6, 0, 0, 0, -0.55, 0 }, Waist = { -12, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 100, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.25, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, 10 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.3, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 182, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 168, 0, 10 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			trail = "prop", hitText = "SPLOP !",
		},
		-- Double débouchage (↑P P) : elle repompe un grand coup vers le haut en sautillant
		P_up2 = {
			label = "Double débouchage", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 7, hitbox = box(4.5, 5, 2, 3.8), kbBase = 28, kbGrowth = 45, kbAngle = 88, selfVelocity = Vector2.new(0, 30),
			windup = { Root = { -4, 0, 0, 0, -0.35, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 130, 0, 5 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, 10 }, LE = { 70, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.35, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 180, 0, 3 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, 8 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.4, 0 }, Waist = { 14, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 185, 0, 3 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 176, 0, 8 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			trail = "prop", text = "ET ENCORE !", hitText = "SPLOP SPLOP !",
		},
		-- Rodéo sur tuyau (P en l'air) : à califourchon sur le tuyau, elle fait tournoyer la ventouse comme un lasso
		P_air = {
			label = "Rodéo sur tuyau", startup = 0.08, active = 0.18, recovery = 0.16,
			damage = 3, hits = 2, hitbox = box(6, 4, 0, 0.5), kbBase = 18, kbGrowth = 25, kbAngle = 45,
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 170, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, 10 }, LE = { 60, 0, 0 }, RH = { 70, 0, 25 }, RK = { -90, 0, 0 }, LH = { 70, 0, -25 }, LK = { -90, 0, 0 } },
			strike = { Root = { -4, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, 10 }, LE = { 60, 0, 0 }, RH = { 65, 0, 30 }, RK = { -95, 0, 0 }, LH = { 65, 0, -30 }, LK = { -95, 0, 0 } },
			follow = { Root = { -2, 0, 0 }, Waist = { -2, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 140, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 32, 0, 10 }, LE = { 60, 0, 0 }, RH = { 68, 0, 28 }, RK = { -92, 0, 0 }, LH = { 68, 0, -28 }, LK = { -92, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, prop = "tuyau", trail = "prop", text = "YIIIHAA !", hitText = "PATAPLONG !",
		},
		-- Ventouse frontale (→P en l'air) : ventouse pointée devant, elle se colle sur l'adversaire qui reste englué
		P_air_side = {
			label = "Ventouse frontale", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 7, hitbox = box(5.5, 3, 3.2, 0.3), kbBase = 20, kbGrowth = 35, kbAngle = 25,
			status = { name = "slowed", duration = 1 },
			windup = { Root = { -8, 20, 0 }, Waist = { -8, 20, 0 }, Neck = { 0, -15, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { 6, -10, 0 }, Waist = { 4, -12, 0 }, Neck = { 0, 10, 0 }, RS = { 92, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { 8, -12, 0 }, Waist = { 5, -14, 0 }, Neck = { 0, 12, 0 }, RS = { 94, 0, 4 }, RE = { 0, 0, 0 }, RW = { 4, 0, 0 }, LS = { -25, 0, -52 }, LE = { 30, 0, 0 }, RH = { 15, 0, 0 }, RK = { -45, 0, 0 }, LH = { 55, 0, 0 }, LK = { -85, 0, 0 } },
			trail = "prop", hitText = "SHLUP !",
		},
		-- Moulinet de ventouse (↑P en l'air) : la ventouse fait un grand arc d'arrière en avant au-dessus de la casquette
		P_air_up = {
			label = "Moulinet de ventouse", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -45, 0, 25 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 85, 0, 0 }, RK = { -115, 0, 0 }, LH = { 75, 0, 0 }, LK = { -115, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 168, 0, 12 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -15, 0, -45 }, LE = { 25, 0, 0 }, RH = { 10, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 196, 0, 6 }, RE = { 8, 0, 0 }, RW = { -15, 0, 0 }, LS = { -22, 0, -48 }, LE = { 25, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			trail = "prop", hitText = "FLOP !",
		},
		-- Glissade dans l'eau (↓P en l'air) : elle plonge les deux bottes en avant dans un grand plouf (smash vers le sol)
		P_air_down = {
			label = "Glissade dans l'eau", startup = 0.14, active = 0.14, recovery = 0.28,
			damage = 9, hitbox = box(4, 3.5, 0.8, -2.5), kbBase = 24, kbGrowth = 50, kbAngle = -75, selfVelocity = Vector2.new(0, -50),
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 100, 0, 50 }, RE = { 30, 0, 0 }, LS = { 100, 0, -50 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { 20, 0, 4 }, RK = { -5, 0, 0 }, RA = { -15, 0, 0 }, LH = { 15, 0, -4 }, LK = { -5, 0, 0 }, LA = { -15, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 168, 0, 48 }, RE = { 10, 0, 0 }, LS = { 168, 0, -48 }, LE = { 10, 0, 0 }, RH = { 15, 0, 6 }, RK = { -8, 0, 0 }, RA = { -15, 0, 0 }, LH = { 10, 0, -6 }, LK = { -8, 0, 0 }, LA = { -15, 0, 0 } },
			trail = "bothFeet", fx = { { "particles", tex = "smoke", color = WATER, dir = "up", at = "feet", time = 0.35, speed = 12 } },
			text = "PLOUF !", hitText = "SPLASH !",
		},
		-- Ventouse en course (dash puis P) : lancée, elle plante la ventouse en avant d'un grand coup d'épaule
		P_dash = {
			label = "Ventouse en course", startup = 0.08, active = 0.14, recovery = 0.24,
			damage = 8, hitbox = box(6, 2.5, 3.5, 0.6), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -8, -15, 0, 0, -0.3, 0.1 }, Waist = { -6, -15, 0 }, Neck = { 0, 10, 0 }, RS = { 50, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 10 }, LE = { 100, 0, 0 } },
			strike = { Root = { -18, 20, 0, 0, -0.45, -0.5 }, Waist = { -10, 20, 0 }, Neck = { 6, -20, 0 }, RS = { 92, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 25 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -20, 22, 0, 0, -0.47, -0.6 }, Waist = { -12, 22, 0 }, Neck = { 6, -22, 0 }, RS = { 95, 0, 5 }, RE = { 0, 0, 0 }, RW = { 5, 0, 0 }, LS = { 82, 0, 25 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
			trail = "prop", fx = { "dust" }, text = "URGENCE !", hitText = "SHPLOK !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Coup de botte : elle arme la jambe et enfonce la semelle de sa grosse botte de chantier
		K_neutral = {
			label = "Grand coup de botte", startup = 0.19, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, 0.3), kbBase = 30, kbGrowth = 70, kbAngle = 30,
			windup = { Root = { 8, -10, 0, 0, -0.15, 0.2 }, Waist = { 8, -8, 0 }, Neck = { 4, 0, 0 }, RS = { 50, 0, 40 }, RE = { 70, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, RA = { 15, 0, 0 } },
			strike = { Root = { 18, -5, 0, 0, -0.1, -0.1 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 50 }, RE = { 40, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 92, 0, 0 }, RK = { -2, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 20, -3, 0, 0, -0.1, -0.12 }, Waist = { 14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -25, 0, 52 }, RE = { 40, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, hitText = "BOUM DE BOTTE !",
		},
		-- Genou de chantier (K K) : elle attrape l'adversaire aux épaules et remonte le genou
		K_combo2 = {
			label = "Genou de chantier", startup = 0.09, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 40,
			windup = { Root = { 6, -8, 0, 0, -0.2, 0.15 }, Waist = { 8, -6, 0 }, RS = { 110, 0, 25 }, RE = { 40, 0, 0 }, LS = { 110, 0, -25 }, LE = { 40, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, 0.05, -0.3 }, Waist = { -14, 6, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 15 }, RE = { 90, 0, 0 }, LS = { 60, 0, -15 }, LE = { 90, 0, 0 }, RH = { 112, 0, 0 }, RK = { -125, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -12, 8, 0, 0, 0.08, -0.35 }, Waist = { -16, 8, 0 }, Neck = { -12, 0, 0 }, RS = { 52, 0, 12 }, RE = { 100, 0, 0 }, LS = { 52, 0, -12 }, LE = { 100, 0, 0 }, RH = { 118, 0, 0 }, RK = { -128, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightLeg", hitText = "GNOC !",
		},
		-- Uppercut à la clé (K K K) : de l'accroupi, la clé à molette remonte sous le menton, elle décolle
		K_combo3 = {
			label = "Uppercut à la clé", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 12, hitbox = box(4.5, 5, 2.5, 2.5), kbBase = 32, kbGrowth = 80, kbAngle = 82, selfVelocity = Vector2.new(5, 35),
			windup = { Root = { -8, 15, 0, 0, -0.75, 0.1 }, Waist = { -22, 15, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { -25, 0, -25 }, LE = { 70, 0, 0 } },
			strike = { Root = { 8, -12, 0, 0, 0.3, -0.2 }, Waist = { 16, -18, 0 }, Neck = { 26, 0, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 }, LS = { 172, 0, 0 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 10, -14, 0, 0, 0.35, -0.25 }, Waist = { 18, -20, 0 }, Neck = { 30, 0, 0 }, RS = { 15, 0, 42 }, RE = { 60, 0, 0 }, LS = { 180, 0, -5 }, LE = { 12, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			prop = "cle", trail = "leftHand", text = "ÇA VA DÉBLOQUER !", hitText = "CLONG !",
		},
		-- Coup de botte latéral : de profil, elle détend la jambe comme un vérin, tout son poids derrière
		K_side = {
			label = "Botte-vérin", startup = 0.22, active = 0.12, recovery = 0.35,
			damage = 13, hitbox = box(5.5, 3, 3.2, 0.3), kbBase = 32, kbGrowth = 85, kbAngle = 30, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 4, -60, 0, 0, -0.25, 0.25 }, Waist = { 4, -20, 0 }, Neck = { 0, 45, 0 }, RS = { 60, 0, 50 }, RE = { 80, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 95, 0, 30 }, RK = { -125, 0, 0 } },
			strike = { Root = { 20, -75, 0, 0, -0.15, -0.3 }, Waist = { 6, -15, 0 }, Neck = { 0, 55, 0 }, RS = { 40, 0, 80 }, RE = { 20, 0, 0 }, LS = { 70, 0, -60 }, LE = { 60, 0, 0 }, RH = { 85, 0, 60 }, RK = { -2, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 22, -78, 0, 0, -0.15, -0.35 }, Waist = { 8, -15, 0 }, Neck = { 0, 58, 0 }, RS = { 35, 0, 84 }, RE = { 20, 0, 0 }, LS = { 72, 0, -62 }, LE = { 60, 0, 0 }, RH = { 88, 0, 62 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightLeg", fx = { "dust" }, text = "VÉRIN !", hitText = "BLAM !",
		},
		-- Tacle du siphon (↓K) : elle se jette dans une flaque et glisse sur le dos, bottes en avant
		K_down = {
			label = "Tacle du siphon", startup = 0.18, active = 0.25, recovery = 0.35,
			damage = 12, hitbox = box(7, 2, 3, -2), kbBase = 30, kbGrowth = 60, kbAngle = 65, selfVelocity = Vector2.new(48, 0),
			status = { name = "wet", duration = 2 },
			windup = { Root = { -10, 0, 0, 0, -0.65, 0 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 30 }, RE = { 40, 0, 0 }, LS = { 70, 0, -30 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -95, 0, 0 }, LH = { 50, 0, 0 }, LK = { -95, 0, 0 } },
			strike = { Root = { 42, 0, 0, 0, -1.55, 0 }, Waist = { -24, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 20, 0, 60 }, RE = { 30, 0, 0 }, LS = { 20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 85, 0, 4 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 80, 0, -4 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 48, 0, -4, 0, -1.6, 0 }, Waist = { -26, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 15, 0, 65 }, RE = { 30, 0, 0 }, LS = { 15, 0, -65 }, LE = { 30, 0, 0 }, RH = { 88, 0, 4 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 84, 0, -4 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", fx = { { "puddle", color = WATER, width = 8 } }, hitText = "SPLATCH !",
		},
		-- Roulade arrière (↑K, ex-←K) : elle roule en arrière et se détend d'un coup de botte vers le haut
		K_up = {
			label = "Roulade arrière", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(4.5, 5, 1.5, 2.5), kbBase = 30, kbGrowth = 70, kbAngle = 80, selfVelocity = Vector2.new(-25, 0),
			windup = { Root = { 20, 0, 0, 0, -0.9, 0.2 }, Waist = { -30, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 70, 0, 20 }, RE = { 100, 0, 0 }, LS = { 70, 0, -20 }, LE = { 100, 0, 0 }, RH = { 120, 0, 0 }, RK = { -140, 0, 0 }, LH = { 120, 0, 0 }, LK = { -140, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.6, 0.3 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 32, 0, 0, 0, -0.6, 0.35 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -35, 0, 52 }, RE = { 20, 0, 0 }, LS = { -35, 0, -52 }, LE = { 20, 0, 0 }, RH = { 155, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 65, 0, 0 }, LK = { -105, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "rightFoot", text = "ROULADE !", hitText = "PAF DE BOTTE !",
		},
		-- Assise sur le siphon (K en l'air) : elle se laisse tomber assise, bottes devant et ventouse brandie, comme sur un tabouret de chantier
		K_air = {
			label = "Assise sur le siphon", startup = 0.15, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5.5, 4, 2.2, -0.5), kbBase = 30, kbGrowth = 70, kbAngle = 38,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 70, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 24, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 95, 0, 15 }, RK = { -30, 0, 0 }, RA = { 20, 0, 0 }, LH = { 95, 0, -15 }, LK = { -30, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 28, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 155, 0, 32 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 18, 0, -52 }, LE = { 30, 0, 0 }, RH = { 100, 0, 15 }, RK = { -28, 0, 0 }, RA = { 20, 0, 0 }, LH = { 100, 0, -15 }, LK = { -28, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", fx = { { "symbols", symbols = { "🪑", "💧" }, color = WATER, count = 2, radius = 2, at = "feet" } }, text = "PAUSE !", hitText = "ASSISE DESSUS !",
		},
		-- Botte volante (→K en l'air) : de profil, jambe droite détendue à l'horizontale, ventouse en balancier
		K_air_side = {
			label = "Botte volante", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -12, -30, 0 }, Waist = { -12, -10, 0 }, Neck = { 0, 25, 0 }, RS = { 60, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 105, 0, 20 }, RK = { -135, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 25, -45, 0 }, Waist = { 8, -10, 0 }, Neck = { -10, 40, 0 }, RS = { -20, 0, 70 }, RE = { 20, 0, 0 }, LS = { 50, 0, -70 }, LE = { 30, 0, 0 }, RH = { 80, 0, 40 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 28, -48, 0 }, Waist = { 10, -10, 0 }, Neck = { -12, 42, 0 }, RS = { -25, 0, 74 }, RE = { 20, 0, 0 }, LS = { 54, 0, -74 }, LE = { 30, 0, 0 }, RH = { 84, 0, 42 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SBLAF !",
		},
		-- Ciseau de plombière (↑K en l'air) : salto arrière, les bottes fouettent le ciel l'une après l'autre
		K_air_up = {
			label = "Ciseau de plombière", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 40 }, RE = { 50, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 55 }, RE = { 30, 0, 0 }, LS = { -40, 0, -55 }, LE = { 30, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 60 }, RE = { 30, 0, 0 }, LS = { -45, 0, -60 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "CLAC CLAC !",
		},
		-- Talon d'égoutière (↓K en l'air) : elle tombe d'un bloc, bottes jointes, comme sur une plaque d'égout (smash au sol)
		K_air_down = {
			label = "Talon d'égoutière", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 140, 0, 30 }, RE = { 40, 0, 0 }, LS = { 140, 0, -30 }, LE = { 40, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 50, 0, 70 }, RE = { 20, 0, 0 }, LS = { 50, 0, -70 }, LE = { 20, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "PLAQUE D'ÉGOUT !", hitText = "KLONK !",
		},
		-- Débouchage express (dash puis K) : elle décolle et frappe des deux bottes, ventouse brandie derrière
		K_dash = {
			label = "Débouchage express", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 3, 3, -0.3), kbBase = 30, kbGrowth = 65, kbAngle = 35, selfVelocity = Vector2.new(50, 25),
			windup = { Root = { -10, 0, 0, 0, -0.45, 0 }, Waist = { -12, 0, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 } },
			strike = { Root = { 20, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -50, 0, 50 }, RE = { 10, 0, 0 }, LS = { 60, 0, -50 }, LE = { 30, 0, 0 }, RH = { 82, 0, 5 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 78, 0, -5 }, LK = { -6, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 24, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -58, 0, 54 }, RE = { 10, 0, 0 }, LS = { 64, 0, -54 }, LE = { 30, 0, 0 }, RH = { 86, 0, 5 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 82, 0, -5 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", text = "INTERVENTION !", hitText = "SBAM !",
		},
		-- P puis K : Serre-nez à molette, elle pince le nez adverse dans la clé et donne un quart de tour… CRIIIC
		PK_combo = {
			label = "Serre-nez à molette", startup = 0.07, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 3.5, 2.8, 1), kbBase = 22, kbGrowth = 30, kbAngle = 40,
			windup = { Root = { 4, 10, 0, 0, -0.2, 0.15 }, Waist = { 4, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -10, 0, 0, -0.3, -0.3 }, Waist = { -10, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 20, 0, 35 }, RE = { 70, 0, 0 }, LS = { 98, 0, 5 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -8, -25, 0, 0, -0.3, -0.32 }, Waist = { -10, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 20, 0, 35 }, RE = { 70, 0, 0 }, LS = { 96, 0, 8 }, LE = { 5, 0, 0 }, LW = { 0, 0, -90 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			prop = "cle", trail = "leftHand", fx = { { "text", text = "CRIIIC", color = STEEL, at = "front" } }, hitText = "QUART DE TOUR !",
		},
		-- Clé dans les côtes (K puis P) : elle pivote et pique la clé à molette dans les côtes
		KP_combo = {
			label = "Clé dans les côtes", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 3.5, 2.6, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, 25, 0, 0, -0.25, 0.15 }, Waist = { 4, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 25 }, RE = { 70, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.35, -0.35 }, Waist = { -10, -28, 0 }, Neck = { 0, 15, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 }, LS = { 90, 0, 15 }, LE = { 15, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -9, -24, 0, 0, -0.36, -0.38 }, Waist = { -11, -32, 0 }, Neck = { 0, 18, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 }, LS = { 92, 0, 20 }, LE = { 12, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "cle", trail = "leftHand", hitText = "CRIC !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Jet de fuite (L) : elle brandit une valve et tourne le volant, le jet d'eau part droit sur l'adversaire et le trempe
		S_neutral = {
			label = "Jet de fuite", kind = "projectile", startup = 0.2, active = 0, recovery = 0.45,
			damage = 13, kbBase = 24, kbGrowth = 45, kbAngle = 40,
			projectile = { speed = 70, angle = 8, gravity = 0, lifetime = 0.6, size = 2, color = WATER, visual = "water" },
			status = { name = "wet", duration = 2 },
			windup = { Root = { 0, -10, 0, 0, -0.2, 0.1 }, Waist = { 0, -14, 0 }, Neck = { 4, 0, 0 }, RS = { 70, 0, -25 }, RE = { 80, 0, 0 }, LS = { 110, 0, 10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, 8, 0, 0, -0.25, -0.15 }, Waist = { 4, 10, 0 }, Neck = { 14, 0, 0 }, RS = { 75, 0, -35 }, RE = { 95, 0, 0 }, LS = { 95, 0, 5 }, LE = { 5, 0, 0 } },
			follow = { Root = { -4, 10, 0, 0, -0.25, -0.12 }, Waist = { 6, 12, 0 }, Neck = { 18, 0, 0 }, RS = { 72, 0, -30 }, RE = { 100, 0, 0 }, LS = { 98, 0, 5 }, LE = { 5, 0, 0 } },
			shake = true, prop = "valve", windupFx = { { "particles", tex = "smoke", color = WATER, dir = "up", at = "lhand", time = 0.15, speed = 4 } },
			fx = { { "particles", tex = "smoke", color = WATER, dir = "front", at = "lhand", time = 0.25, speed = 16, rate = 80 } }, text = "ÇA FUIT !", hitText = "SPLASH !",
		},
		-- Ventouse grappin (→L) : elle lance la ventouse comme un harpon le long du couloir ; un adversaire est collé et ramené, un mur la tire à lui
		S_side = {
			label = "Ventouse grappin", kind = "grapple", startup = 0.2, active = 0.2, recovery = 0.5,
			damage = 13, kbBase = 20, kbGrowth = 20, kbAngle = 20,
			grapple = { range = 30, angle = 0, speed = 85, pullEnemy = true },
			windup = { Root = { 4, -25, 0, 0, -0.25, 0.25 }, Waist = { 6, -25, 0 }, Neck = { 0, 20, 0 }, RS = { -30, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -14, 20, 0, 0, -0.4, -0.45 }, Waist = { -12, 25, 0 }, Neck = { 0, -15, 0 }, RS = { 95, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 10, 10, 0, 0, -0.3, 0.2 }, Waist = { 10, 12, 0 }, Neck = { 6, -6, 0 }, RS = { 75, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 70, 0, 0 } },
			trail = "prop", fx = { { "beam", color = RUBBER, length = 14, width = 0.8, at = "hand" } }, text = "ACCROCHÉ !", hitText = "SHLOOP !",
		},
		-- Inondation (↓L) : accroupie, elle ouvre la valve à ras du sol ; la mare s'étale sur tout le couloir et renverse qui s'y trouve
		-- (piège qui reste au sol)
		S_down = {
			label = "Inondation", kind = "trap", startup = 0.22, active = 0, recovery = 0.5,
			damage = 12, kbBase = 30, kbGrowth = 40, kbAngle = 80,
			status = { name = "slippery", duration = 2 },
			trap = { size = Vector3.new(16, 2, 6), offset = 8, lifetime = 5, max = 1, armTime = 0.2, persist = true, color = WATER,
				-- longue flaque à plat sur le sol, sur toute la longueur du couloir
				visual = { shape = "ball", size = 0.5, color = WATER, transparency = 0.3, trail = false, parts = {
					{ "block", Vector3.new(15, 0.12, 3), Vector3.new(0, -0.3, 0), WATER },
					{ "ball", Vector3.new(1.4, 0.2, 1.4), Vector3.new(6, -0.25, 0.6), WATER },
					{ "ball", Vector3.new(1.2, 0.2, 1.2), Vector3.new(-6.5, -0.25, -0.5), WATER },
					{ "ball", Vector3.new(1.0, 0.2, 1.0), Vector3.new(0.5, -0.25, 0.9), WATER },
				} } },
			windup = { Root = { -6, 10, 0, 0, -0.6, 0.1 }, Waist = { -20, 10, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 60, 0, 0 }, LS = { 45, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -10, -10, 0, 0, -0.85, -0.1 }, Waist = { -28, -10, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, -30 }, RE = { 70, 0, 0 }, LS = { 30, 0, -5 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -4, -5, 0, 0, -0.5, 0.05 }, Waist = { -10, -5, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -10 }, LE = { 30, 0, 0 } },
			prop = "valve", fx = { { "puddle", color = WATER, width = 16 }, { "particles", tex = "smoke", color = WATER, dir = "front", at = "feet", time = 0.4, speed = 16, rate = 90 } },
			text = "INONDATION !", hitText = "GLISSADE !",
		},
		-- POP ascensionnel (↑L, remontée) : elle plante la ventouse au sol, s'arc-boute, POP !, et part en diagonale comme un bouchon de
		-- champagne, ventouse tendue devant, bottes derrière : tout ce qu'elle croise est collé et emporté
		S_up = {
			label = "POP ascensionnel", startup = 0.15, active = 0.3, recovery = 0.45,
			damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 45, kbAngle = 80, selfVelocity = Vector2.new(42, 80),
			windup = { Root = { -10, 0, 0, 0, -0.75, 0 }, Waist = { -25, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 15 }, LE = { 0, 0, 0 } },
			strike = { Root = { -48, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 176, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -20 }, LE = { 110, 0, 0 }, LW = { -30, 0, 0 }, RH = { -25, 0, 6 }, RK = { -35, 0, 0 }, RA = { -30, 0, 0 }, LH = { -35, 0, -6 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -52, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 135, 0, -22 }, LE = { 110, 0, 0 }, LW = { -30, 0, 0 }, RH = { -30, 0, 8 }, RK = { -45, 0, 0 }, RA = { -30, 0, 0 }, LH = { -40, 0, -8 }, LK = { -60, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "prop", fx = { { "burst", color = RUBBER, size = 3.5, at = "feet" }, { "ring", color = RUBBER, radius = 4, at = "feet" }, { "particles", tex = "smoke", color = WATER, dir = "down", at = "feet", time = 0.4, speed = 14, rate = 90 } },
			text = "POP !", hitText = "COLLÉ ET EMPORTÉ !",
		},
		-- Chute ventouse (↓L en l'air) : ventouse pointée vers le sol à deux mains, elle s'y colle (POP !) et l'onde aplatit tout en dessous
		S_air_down = {
			label = "Chute ventouse", startup = 0.16, active = 0.35, recovery = 0.5,
			damage = 14, hitbox = box(8, 5, 0, -2), kbBase = 28, kbGrowth = 60, kbAngle = -65, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, 20 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -14, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 25, 0, 20 }, LE = { 20, 0, 0 }, RH = { 60, 0, 10 }, RK = { -100, 0, 0 }, LH = { 60, 0, -10 }, LK = { -100, 0, 0 } },
			follow = { Root = { -16, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 15, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, 20 }, LE = { 20, 0, 0 }, RH = { 55, 0, 12 }, RK = { -95, 0, 0 }, LH = { 55, 0, -12 }, LK = { -95, 0, 0 } },
			trail = "prop", fx = { { "ring", color = RUBBER, radius = 6, at = "feet" }, { "burst", color = WATER, size = 3, at = "feet" }, { "particles", tex = "smoke", color = WATER, dir = "all", at = "feet", time = 0.3, speed = 12 } },
			text = "POP !", hitText = "SPLOUTCH !",
		},
		-- Coup de bélier (ESQUIVE puis L) : elle braque un bout de tuyau sous pression : un boulet d'eau part droit sur l'adversaire
		-- et le recul la renvoie en arrière d'un bond (invulnérable)
		S_dodge = {
			label = "Coup de bélier", kind = "projectile", startup = 0.15, active = 0, recovery = 0.45,
			damage = 12, kbBase = 30, kbGrowth = 55, kbAngle = 30, selfVelocity = Vector2.new(-34, 18), invuln = 0.3,
			status = { name = "wet", duration = 1.5 },
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.5, size = 2.4, color = WATER, visual = "water" },
			windup = { Root = { 6, -20, 0, 0, -0.3, 0.15 }, Waist = { 4, -25, 0 }, Neck = { 0, 20, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 14, 10, 0, 0, -0.2, 0.3 }, Waist = { 10, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.4 } },
			follow = { Root = { 18, 10, 0, 0, -0.2, 0.45 }, Waist = { 12, 12, 0 }, Neck = { 8, -8, 0 }, RS = { 36, 0, 32 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -5 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.45 } },
			shake = true, prop = "tuyau", trail = "leftHand", windupFx = { { "particles", tex = "smoke", color = WATER, dir = "front", at = "lhand", time = 0.15, speed = 4 } },
			fx = { { "burst", color = WATER, size = 3, at = "lhand" }, { "particles", tex = "smoke", color = WATER, dir = "front", at = "lhand", time = 0.3, speed = 18, rate = 90 }, { "ring", color = WATER, radius = 3, at = "feet" } },
			text = "COUP DE BÉLIER !", hitText = "SPLAAASH !",
		},
		-- Pression (S maintenu) : genou à terre, elle ouvre la valve à fond ; la canalisation claque et une rangée de geysers jaillit sur
		-- toute la longueur du couloir
		S_hold = {
			label = "Pression", startup = 0.3, active = 0.25, recovery = 0.6,
			damage = 15, hitbox = box(14, 8, 7, 2), kbBase = 34, kbGrowth = 75, kbAngle = 85,
			status = { name = "wet", duration = 2 },
			windup = { Root = { -6, 15, 0, 0, -0.85, 0 }, Waist = { -20, 15, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -20 }, RE = { 90, 0, 0 }, LS = { 50, 0, -10 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.4 } },
			strike = { Root = { 10, -5, 0, 0, -0.3, 0.4 }, Waist = { 12, -5, 0 }, Neck = { 25, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 } },
			follow = { Root = { 12, -5, 0, 0, -0.25, 0.45 }, Waist = { 14, -5, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 50 }, RE = { 20, 0, 0 }, LS = { 160, 0, -50 }, LE = { 20, 0, 0 } },
			shake = true, prop = "valve",
			windupFx = { { "particles", tex = "smoke", color = WATER, dir = "up", at = "front", time = 0.3, speed = 5 } },
			fx = { { "pillar", color = WATER, height = 14, width = 2.5, at = "front" }, { "beam", color = WATER, length = 16, width = 3, at = "front" }, { "rain", shape = "ball", color = WATER, count = 10, radius = 8, size = 0.5 }, { "shake", amount = 0.4 } },
			text = "PLEINE PRESSION !", hitText = "GEYSER !",
		},
		-- Glissade dans un tuyau (→→L) : elle plonge à plat ventre et file au ras du sol tout le long du couloir, sous l'adversaire
		S_dash = {
			label = "Glissade dans un tuyau", startup = 0.15, active = 0.3, recovery = 0.5,
			damage = 13, hitbox = box(14, 5, 7, -0.5), kbBase = 30, kbGrowth = 50, kbAngle = 80, selfVelocity = Vector2.new(75, 0), invuln = 0.35,
			windup = { Root = { -20, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 20 }, RE = { 20, 0, 0 }, LS = { 120, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -72, 0, 0, 0, -1.6, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -10 }, LE = { 0, 0, 0 }, RH = { -10, 0, 0 }, RK = { -10, 0, 0 }, RA = { -40, 0, 0 }, LH = { -10, 0, 0 }, LK = { -15, 0, 0 }, LA = { -40, 0, 0 } },
			follow = { Root = { -75, 0, 0, 0, -1.65, 0 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -12, 0, 3 }, RK = { -15, 0, 0 }, RA = { -40, 0, 0 }, LH = { -8, 0, -3 }, LK = { -10, 0, 0 }, LA = { -40, 0, 0 } },
			trail = "body", fx = { { "puddle", color = WATER, width = 12 }, { "particles", tex = "smoke", color = WATER, dir = "front", at = "root", time = 0.3, speed = 12, rate = 80 } }, text = "PAR LES TUYAUX !", hitText = "ZLOUP !",
		},
		-- Ventouse volante (L en l'air) : elle tire la ventouse en diagonale vers le sol et ramène à elle ce qu'elle accroche
		S_air = {
			label = "Ventouse volante", kind = "grapple", startup = 0.18, active = 0.2, recovery = 0.45,
			damage = 13, kbBase = 20, kbGrowth = 25, kbAngle = 30,
			grapple = { range = 30, angle = -35, speed = 85, pullEnemy = true },
			windup = { Root = { -6, -15, 0 }, Waist = { -8, -15, 0 }, Neck = { 0, 10, 0 }, RS = { 150, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -10, 15, 0 }, Waist = { -14, 18, 0 }, Neck = { -10, -10, 0 }, RS = { 60, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 4, 10, 0 }, Waist = { 4, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 70, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -45 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -85, 0, 0 } },
			trail = "prop", fx = { { "beam", color = RUBBER, length = 12, width = 0.8, at = "hand" } }, text = "VIENS PAR ICI !", hitText = "SHLOOP !",
		},

		-- Pompage (P P puis →P) : ventouse collée en pleine figure, elle pompe trois fois comme sur un évier bouché (3 touches)
		P_pompe = {
			label = "Pompage", startup = 0.06, active = 0.2, recovery = 0.2,
			damage = 3, hits = 3, hitbox = box(5, 3.5, 2.8, 0.8), kbBase = 16, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.2 }, Waist = { 6, -12, 0 }, Neck = { 4, 6, 0 }, RS = { 80, 0, 15 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 25 }, LE = { 100, 0, 0 } },
			strike = { Root = { -12, 6, 0, 0, -0.35, -0.4 }, Waist = { -12, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 94, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 22 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -4, 6, 0, 0, -0.25, -0.25 }, Waist = { -4, 8, 0 }, Neck = { -2, 0, 0 }, RS = { 80, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 25 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "💧", "🫧" }, color = WATER, count = 3, radius = 2, at = "front" } }, text = "ÇA VIENT, ÇA VIENT…", hitText = "SPLOTCH SPLOTCH SPLOTCH !",
		},
		-- Lasso de tuyau (K K puis →K) : elle fait tournoyer le tuyau au-dessus de la casquette et le claque d'un tour complet
		K_lasso = {
			label = "Lasso de tuyau", startup = 0.08, active = 0.14, recovery = 0.22,
			damage = 7, hitbox = box(6.5, 4, 2.5, 0.8), kbBase = 24, kbGrowth = 35, kbAngle = 40,
			windup = { Root = { 4, -20, 0, 0, -0.25, 0.15 }, Waist = { 4, -20, 0 }, Neck = { 8, 15, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 }, LS = { 175, 0, -20 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, 25, 0, 0, -0.35, -0.35 }, Waist = { -8, 28, 0 }, Neck = { 0, -20, 0 }, RS = { 20, 0, 35 }, RE = { 70, 0, 0 }, LS = { 100, 0, -70 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -8, 35, 0, 0, -0.35, -0.38 }, Waist = { -8, 36, 0 }, Neck = { 0, -26, 0 }, RS = { 18, 0, 36 }, RE = { 70, 0, 0 }, LS = { 95, 0, -40 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			spin = { axis = "y", degrees = 360 }, prop = "tuyau", trail = "leftHand", text = "YIIIHAA !", hitText = "PATAPLONG !",
		},
		-- Home run de plombière (finition) : la clé à molette tenue à deux mains comme une batte, grand swing… et l'adversaire part dans les tuyaux
		K_homerun = {
			label = "Home run de plombière", startup = 0.1, active = 0.1, recovery = 0.36,
			damage = 12, hitbox = box(6, 4, 3, 0.8), kbBase = 40, kbGrowth = 92, kbAngle = 34,
			windup = { Root = { 4, 45, 0, 0, -0.3, 0.2 }, Waist = { 6, 40, 0 }, Neck = { 0, -35, 0 }, RS = { 60, 0, -30 }, RE = { 60, 0, 0 }, LS = { 80, 0, -60 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, -35, 0, 0, -0.4, -0.4 }, Waist = { -12, -40, 0 }, Neck = { 0, 30, 0 }, RS = { 90, 0, 10 }, RE = { 10, 0, 0 }, LS = { 95, 0, 0 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -12, -50, 0, 0, -0.42, -0.45 }, Waist = { -14, -55, 0 }, Neck = { 0, 40, 0 }, RS = { 85, 0, 35 }, RE = { 15, 0, 0 }, LS = { 90, 0, 30 }, LE = { 10, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "cle", trail = "leftHand", fx = { { "burst", color = STEEL, size = 3, at = "front" }, { "shake", amount = 0.4 } }, text = "HOME RUN !", hitText = "CLONG ! DANS LES TUYAUX !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- POP de ventouse (finition) : elle colle la ventouse sur l'adversaire, pousse, tire… POP ! Il part comme un bouchon de champagne
		S_finish_pop = {
			label = "POP de ventouse", startup = 0.12, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(5, 3.5, 3, 0.6), kbBase = 36, kbGrowth = 85, kbAngle = 25,
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.25 }, Waist = { 8, -12, 0 }, Neck = { 0, 6, 0 }, RS = { 80, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 25 }, LE = { 95, 0, 0 } },
			strike = { Root = { -12, 6, 0, 0, -0.35, -0.4 }, Waist = { -12, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 22 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { 10, 0, 0, 0, -0.25, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 80, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 78, 0, 25 }, LE = { 65, 0, 0 } },
			hold = 0.1, trail = "prop", fx = { { "burst", color = RUBBER, size = 3, at = "front" }, { "shake", amount = 0.3 } }, text = "ET… POP !", hitText = "BOUCHON DE CHAMPAGNE !",
		},
		-- Coup de pression : la valve pointée devant, un jet droit et puissant
		S_finish_jet = {
			label = "Coup de pression", kind = "projectile", startup = 0.12, active = 0, recovery = 0.28,
			damage = 9, kbBase = 36, kbGrowth = 82, kbAngle = 30,
			projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.35, size = 2, color = WATER, visual = "water" },
			windup = { Root = { 2, -12, 0, 0, -0.2, 0.15 }, Waist = { 2, -15, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, -20 }, RE = { 80, 0, 0 }, LS = { 70, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 10, 10, 0, 0, -0.25, 0.2 }, Waist = { 10, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 75, 0, -30 }, RE = { 85, 0, 0 }, LS = { 92, 0, 5 }, LE = { 0, 0, 0 } },
			follow = { Root = { 12, 12, 0, 0, -0.25, 0.28 }, Waist = { 12, 14, 0 }, Neck = { 8, -10, 0 }, RS = { 72, 0, -28 }, RE = { 85, 0, 0 }, LS = { 98, 0, 5 }, LE = { 0, 0, 0 } },
			prop = "valve", shake = true, text = "PSCHHHT !", hitText = "SPLAF !",
		},

		------------------------------------------------------------------ Supers
		-- Rupture de canalisation (Y) : elle frappe le sol de toutes ses forces avec la ventouse, les geysers jaillissent sur toute l'arène
		SUPER = {
			label = "Rupture de canalisation !", startup = 0.45, active = 0.3, recovery = 0.8,
			damage = 12, hits = 2, hitbox = box(60, 10, 0, 3), kbBase = 30, kbGrowth = 50, kbAngle = 88,
			status = { name = "wet", duration = 2 },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 190, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, 15 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.9, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 20 }, LE = { 20, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.95, -0.32 }, Waist = { -32, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 28, 0, 20 }, LE = { 20, 0, 0 } },
			hold = 0.3, windupFx = { "super" },
			fx = { { "pillar", color = WATER, height = 16, width = 3, at = "front" }, { "pillar", color = WATER, height = 12, width = 2, at = "root" },
				{ "rain", shape = "ball", color = WATER, count = 16, radius = 14, size = 0.6 }, { "screen", color = WATER, alpha = 0.3 }, { "shake", amount = 0.7 } },
			text = "RUPTURE DE CANALISATION !", hitText = "GEYSER !",
		},
		-- Plaque d'égout boomerang (→Y) : elle soulève une plaque d'égout à mains nues (HNNG), pivote comme une lanceuse de disque
		-- et l'envoie à plat : la plaque fauche tout le couloir en tournoyant, puis revient se planter dans sa main
		SUPER_side = {
			label = "Plaque d'égout boomerang !", kind = "projectile", startup = 0.42, active = 0, recovery = 0.7,
			damage = 25, kbBase = 46, kbGrowth = 96, kbAngle = 34,
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3.6, color = SEWER, returns = true, pierce = true, visual = MANHOLE },
			status = { name = "stunned", duration = 1.5 },
			windup = { Root = { 10, -60, 0, 0, -0.7, 0.2 }, Waist = { 14, -50, 0 }, Neck = { -10, 40, 0 }, RS = { 40, 0, 60 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, 40, 0, 0, -0.4, -0.5 }, Waist = { -16, 44, 0 }, Neck = { 0, -30, 0 }, RS = { 92, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			follow = { Root = { -16, 50, 0, 0, -0.42, -0.56 }, Waist = { -18, 54, 0 }, Neck = { 0, -36, 0 }, RS = { 90, 0, 60 }, RE = { 4, 0, 0 }, RW = { 10, 0, 0 }, LS = { 16, 0, -54 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.58 } },
			spin = { axis = "y", degrees = 360 }, hideProp = "ventouse", trail = "rightHand",
			windupFx = { "super", { "text", text = "HNNNG…", color = SEWER, at = "head" }, { "particles", tex = "smoke", color = SEWER, dir = "up", at = "feet", time = 0.3, speed = 6, size = 0.8 } },
			fx = { { "burst", color = SEWER, size = 3.5, at = "hand" }, { "ring", color = WATER, radius = 5, at = "front" }, { "shake", amount = 0.5 } },
			text = "PLAQUE D'ÉGOUT !", hitText = "DÉCAPITÉ… PRESQUE !",
		},
		-- Super ↑ : elle plaque la ventouse géante au sol devant elle, s'arc-boute de tout son poids… et la décolle d'un coup : le POP
		-- monstrueux arrache le carrelage de tout le couloir, l'adversaire part au plafond avec les tuyaux, elle avec, cramponnée au manche
		SUPER_up = {
			label = "Le Grand POP !", startup = 0.4, active = 0.25, recovery = 0.8,
			damage = 24, hitbox = box(14, 10, 7, 4), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -22, 0, 0, 0, -0.75, -0.2 }, Waist = { -36, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 55, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 55, 0, 15 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
			strike = { Root = { 30, 0, 0, 0, -0.3, 0.5 }, Waist = { 20, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 120, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, 15 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
			follow = { Root = { 18, 0, 0, 0, 0.6, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 185, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, 12 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -80, 0, 0 }, LH = { 10, 0, -10 }, LK = { -40, 0, 0 } },
			hold = 0.2, selfVelocity = Vector2.new(0, 60), prop = "geante", hideProp = "ventouse",
			windupFx = { "super", { "text", text = "HNNNNGH…", color = RUBBER, at = "head" } }, trail = "prop",
			fx = { { "burst", color = RUBBER, size = 6, at = "front" }, { "ring", color = RUBBER, radius = 8, at = "front" }, { "pillar", color = Color3.fromRGB(120, 200, 255), height = 22, width = 4, at = "front" }, { "beam", color = Color3.fromRGB(120, 200, 255), length = 18, width = 5, at = "front" }, { "toss", shape = "flat", color = Color3.fromRGB(230, 230, 235), count = 8, size = 0.8, speed = 24 }, { "particles", tex = "smoke", color = WATER, dir = "up", at = "front", time = 0.5, speed = 20, rate = 100 }, { "shake", amount = 0.7 } },
			text = "ÇA VA DÉBOUCHER !", hitText = "POP GÉANT !",
		},
		-- Le Grand Débouchage (↓Y) : une ventouse gigantesque qui aspire tout le couloir (projectiles compris) puis recrache d'un POP
		SUPER_down = {
			label = "Le Grand Débouchage !", kind = "absorb", startup = 0.4, active = 0.5, recovery = 0.8,
			damage = 22, hitbox = box(14, 8, 7, 1), kbBase = 40, kbGrowth = 70, kbAngle = 35,
			absorb = { radius = 10, offset = 6 },
			windup = { Root = { 8, -15, 0, 0, -0.2, 0.3 }, Waist = { 14, -15, 0 }, Neck = { 10, 10, 0 }, RS = { 175, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, 30 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 10, 0, 0, -0.5, -0.3 }, Waist = { -20, 10, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 25 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 12, 0, 0, 0, -0.3, 0.3 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 80, 0, 5 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 25 }, LE = { 60, 0, 0 } },
			hold = 0.3, prop = "geante", hideProp = "ventouse", windupFx = { "super" },
			fx = { { "particles", tex = "smoke", color = Color3.fromRGB(200, 220, 240), dir = "front", at = "front", time = 0.5, speed = 16, rate = 100 }, { "beam", color = RUBBER, length = 16, width = 4, at = "hand" }, { "ring", color = RUBBER, radius = 7, at = "front" }, { "shake", amount = 0.5 } },
			text = "LE GRAND DÉBOUCHAGE !", hitText = "SCHLOOOP… POP !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise à la ventouse : elle colle la ventouse en plein sur le visage adverse
		GRAB = {
			label = "Prise à la ventouse", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4.5, 4, 2.5, 0.6),
			windup = { Root = { 4, -10, 0, 0, -0.15, 0.15 }, Waist = { 6, -12, 0 }, Neck = { 0, 6, 0 }, RS = { 70, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 25 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, -0.3, -0.35 }, Waist = { -10, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 22 }, LE = { 20, 0, 0 } },
			follow = { Root = { -8, 6, 0, 0, -0.28, -0.32 }, Waist = { -8, 8, 0 }, Neck = { -4, 0, 0 }, RS = { 90, 0, 6 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 86, 0, 22 }, LE = { 30, 0, 0 } },
			trail = "prop", text = "COLLÉ !", hitText = "SHLUP !",
		},
		-- ✋ puis → : Débouchage, elle tire de tout son poids en arrière… POP ! la victime part devant
		THROW_fwd = {
			label = "Débouchage", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.3,
			damage = 10, kbBase = 40, kbGrowth = 55, kbAngle = 20,
			carry = { { 0, 2.6, 0.6 }, { 0.2, 2.0, 0.6 }, { 0.34, 3.8, 0.8 } },
			windup = { Root = { 18, 0, 0, 0, -0.35, 0.4 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 80, 0, 5 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 78, 0, 25 }, LE = { 55, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.4 }, Waist = { -14, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 95, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 22 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, 0, 0, 0, -0.37, -0.45 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 98, 0, 5 }, RE = { 0, 0, 0 }, RW = { 5, 0, 0 }, LS = { 94, 0, 22 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { { "burst", color = RUBBER, size = 3, at = "front" } }, text = "POP !", hitText = "DÉBOUCHÉ !",
		},
		-- ✋ puis ← : Clé à molette, elle fait tourner la victime comme un écrou et la lance derrière elle
		THROW_back = {
			label = "Tour de clé", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 40,
			carry = { { 0, 2.4, 0.6 }, { 0.12, 0.5, 2.6 }, { 0.26, -2.2, 1.2 }, { 0.4, -3.0, 0.6 } },
			windup = { Root = { 4, 30, 0, 0, -0.35, 0 }, Waist = { 6, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 90, 0, 40 }, RE = { 30, 0, 0 }, LS = { 90, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 6, -40, 0, 0, -0.45, 0.2 }, Waist = { 8, -40, 0 }, Neck = { 0, -40, 0 }, RS = { 95, 0, 70 }, RE = { 10, 0, 0 }, LS = { 95, 0, -70 }, LE = { 10, 0, 0 } },
			follow = { Root = { 8, -48, 0, 0, -0.45, 0.25 }, Waist = { 10, -46, 0 }, Neck = { 0, -45, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, LS = { 90, 0, -80 }, LE = { 10, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, prop = "cle", fx = { "dust" }, text = "UN TOUR DE CLÉ !", hitText = "CRIIIC !",
		},
		-- ✋ puis ↑ : Grappin, elle tire la victime vers le plafond au bout de la ventouse
		THROW_up = {
			label = "Grappin au plafond", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 2.0, 1.5 }, { 0.32, 1.0, 6.5 } },
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 70, 0, 5 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 65, 0, 20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.25, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 178, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, 10 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.3, -0.1 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 182, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 174, 0, 10 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			trail = "prop", text = "TOUT LÀ-HAUT !", hitText = "ZIOUUU !",
		},
		-- ✋ puis ↓ : Au fond du siphon, elle plaque la victime au sol et pompe dessus à la ventouse
		THROW_down = {
			label = "Au fond du siphon", kind = "throw", startup = 0.42, active = 0.1, hold = 0.25, recovery = 0.35,
			damage = 10, kbBase = 28, kbGrowth = 25, kbAngle = 80,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 2.0, 1.0 }, { 0.3, 1.8, -1.8 }, { 0.42, 1.8, -2.4 } },
			windup = { Root = { 8, 0, 0, 0, 0, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, 20 }, LE = { 35, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.7, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 20 }, LE = { 25, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.45, -0.25 }, Waist = { -20, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 0 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 65, 0, 20 }, LE = { 60, 0, 0 } },
			fx = { { "puddle", color = WATER, width = 5 }, { "symbols", symbols = { "💧", "🫧" }, count = 5, radius = 2, at = "front", color = WATER } },
			text = "GLOU GLOU !", hitText = "SIPHONNÉ !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "glouglou", label = "Glouglou", sequence = { "down", "down", "up" },
			-- une bonde d'évier géante s'ouvre sous l'adversaire qui tourne, rapetisse et disparaît dans le siphon
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, -2.9, 0), life = 3.5, pieces = {
					{ "Bonde", "", "cyl", Vector3.new(0.3, 6, 6), Vector3.new(0, 0, 0), Vector3.zero, STEEL, "Metal", { reflect = 0.3 } },
					{ "Trou", "", "cyl", Vector3.new(0.32, 3.4, 3.4), Vector3.new(0, 0.02, 0), Vector3.zero, Color3.fromRGB(20, 20, 30), "SmoothPlastic" },
					{ "Grille1", "", "block", Vector3.new(3.4, 0.36, 0.25), Vector3.new(0, 0.03, 0), Vector3.zero, STEEL, "Metal" },
					{ "Grille2", "", "block", Vector3.new(0.25, 0.36, 3.4), Vector3.new(0, 0.03, 0), Vector3.zero, STEEL, "Metal" },
				} },
				{ "fxAttacker", { "text", text = "C'EST BOUCHÉ ? J'ARRIVE !", color = WATER } },
				{ "fx", { "particles", tex = "smoke", color = WATER, dir = "all", at = "feet", time = 1.5, speed = 6 } },
				{ "text", "GLOU…" },
				{ "spin", 720, axis = "y", time = 1 },
				{ "shrink", 0.2, time = 0.8 },
				{ "text", "GLOUGLOU !" },
				{ "hide" },
				{ "fxAttacker", { "symbols", symbols = { "👍", "💧" }, count = 4, color = WATER } },
				{ "wait", 1 },
			},
		},
		{
			id = "le_reseau", label = "Le Réseau", sequence = { "forward", "back", "forward" },
			-- aspiré dans un tuyau transparent, il fait le tour de la tuyauterie et ressort goutte à goutte d'un robinet
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 1.6, pieces = {
					{ "TuyauVerre", "", "cyl", Vector3.new(14, 3.5, 3.5), Vector3.new(0, 4, 0), Vector3.zero, Color3.fromRGB(190, 230, 255), "Glass", { transparency = 0.5 } },
				} },
				{ "text", "SHLUUURP !" },
				{ "shrink", 0.4, time = 0.4 },
				{ "lift", 8, time = 0.6 },
				{ "hide" },
				{ "fxAttacker", { "text", text = "IL FAIT LE TOUR DU RÉSEAU…", color = WATER } },
				{ "wait", 1.0 },
				{ "spawn", at = "attacker", offset = Vector3.new(4, 3, 0), life = 3, pieces = {
					{ "Robinet", "", "cyl", Vector3.new(2, 0.5, 0.5), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), STEEL, "Metal", { axis = "x" } },
					{ "BecRobinet", "", "cyl", Vector3.new(0.8, 0.45, 0.45), Vector3.new(0.9, -0.4, 0), Vector3.zero, STEEL, "Metal" },
					{ "Croisillon", "", "block", Vector3.new(0.8, 0.15, 0.15), Vector3.new(-0.3, 0.45, 0), Vector3.zero, RUBBER, "SmoothPlastic" },
				} },
				{ "move", to = "attacker", offset = Vector3.new(4.9, 1.6, 0), time = 0.1 },
				{ "shrink", 0.15, time = 0.1 },
				{ "show" },
				{ "fx", { "particles", tex = "smoke", color = WATER, dir = "down", at = "root", time = 0.8, speed = 6 } },
				{ "text", "PLIC." },
				{ "wait", 0.8 },
				{ "fxAttacker", { "text", text = "FUITE RÉPARÉE !", color = WATER } },
				{ "wait", 0.6 },
			},
		},
		{
			id = "ventouse_a_vie", label = "Ventouse à vie", sequence = { "up", "forward", "down" },
			-- une ventouse collée sur la tête, impossible à enlever : il part en boudant
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, 2.6, 0), life = 2.2, pieces = {
					{ "Cloche", "", "ball", Vector3.new(1.8, 1.2, 1.8), Vector3.new(0, 0, 0), Vector3.zero, RUBBER, "Rubber" },
					{ "Manche", "", "cyl", Vector3.new(3, 0.3, 0.3), Vector3.new(0, 1.9, 0), Vector3.zero, HANDLE, "Wood" },
				} },
				{ "fx", { "burst", color = RUBBER, size = 3, at = "above" } },
				{ "text", "POP !" },
				{ "wait", 0.5 },
				{ "spin", 30, axis = "y", time = 0.3 },
				{ "spin", -60, axis = "y", time = 0.4 },
				{ "text", "ELLE COLLE !" },
				{ "fxAttacker", { "text", text = "ELLE EST GARANTIE À VIE !", color = WATER } },
				{ "wait", 0.8 },
				{ "fx", { "symbols", symbols = { "😤", "💢" }, count = 4, radius = 2 } },
				{ "text", "PFFF… JE BOUDE." },
				{ "launch", Vector3.new(30, 4, 0), time = 2 },
				{ "wait", 0.6 },
			},
		},
	},

	-- Mécanique : Grappin (rien de passif) ; ses ventouses kind = "grapple" s'accrochent aux adversaires et au décor
	passive = { kind = "grapple", name = "Grappin", icon = "🪠", color = RUBBER },

	-- Recharge ⚡ : elle débouche un évier invisible à grands coups de ventouse, GLOUGLOU, puis pouce levé
	charge = {
		label = "Débouchage d'évier",
		loop = 1.6,
		lockWrist = true, -- la ventouse reste pointée vers l'évier
		color = Color3.fromRGB(120, 220, 255),
		keys = {
			{ 0.0, { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -18, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, -5 }, RE = { 40, 0, 0 }, RW = { -60, 0, 0 }, LS = { 50, 0, 20 }, LE = { 50, 0, 0 } } },
			{ 0.2, { Root = { -8, 0, 0, 0, -0.55, 0 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 25, 0, -5 }, RE = { 25, 0, 0 }, RW = { -45, 0, 0 }, LS = { 35, 0, 20 }, LE = { 30, 0, 0 } } },
			{ 0.4, { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -18, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, -5 }, RE = { 40, 0, 0 }, RW = { -60, 0, 0 }, LS = { 50, 0, 20 }, LE = { 50, 0, 0 } } },
			{ 0.6, { Root = { -8, 0, 0, 0, -0.55, 0 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 25, 0, -5 }, RE = { 25, 0, 0 }, RW = { -45, 0, 0 }, LS = { 35, 0, 20 }, LE = { 30, 0, 0 } } },
			{ 0.85, { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 45, 0, -5 }, RE = { 50, 0, 0 }, RW = { -50, 0, 0 }, LS = { 30, 0, 10 }, LE = { 40, 0, 0 } } },
			{ 1.1, { Root = { 2, 10, 0, 0, -0.1, 0.05 }, Waist = { 4, 10, 0 }, Neck = { 10, -20, 0 }, RS = { 35, 0, 10 }, RE = { 50, 0, 0 }, RW = { -40, 0, 0 }, LS = { 150, 0, -20 }, LE = { 40, 0, 0 } } },
			{ 1.35, { Root = { 2, 10, 0, 0, -0.1, 0.05 }, Waist = { 4, 10, 0 }, Neck = { 12, -22, 0 }, RS = { 35, 0, 10 }, RE = { 50, 0, 0 }, RW = { -40, 0, 0 }, LS = { 155, 0, -22 }, LE = { 35, 0, 0 } } },
			{ 1.6, { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -18, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, -5 }, RE = { 40, 0, 0 }, RW = { -60, 0, 0 }, LS = { 50, 0, 20 }, LE = { 50, 0, 0 } } },
		},
		beats = {
			{ 0.2, { "symbols", symbols = { "🫧" }, count = 2, radius = 1.5, at = "front", color = WATER } },
			{ 0.6, { "symbols", symbols = { "🫧" }, count = 2, radius = 1.5, at = "front", color = WATER } },
			{ 0.85, { "text", text = "GLOUGLOU !", color = WATER } },
			{ 1.15, { "symbols", symbols = { "👍" }, count = 1, radius = 0.5, at = "above" } },
		},
	},

	-- Manies au repos : regarde l'heure (devis !), fait tourner la clé de sa ceinture, s'appuie sur la ventouse
	fidgets = {
		{ duration = 2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -20, 20, 0 }, LS = { 80, 0, 40 }, LE = { 100, 0, 0 } } },
			{ 1.2, { Neck = { -22, 22, 0 }, LS = { 82, 0, 40 }, LE = { 105, 0, 0 } } },
			{ 1.5, { Neck = { 5, -10, 0 } } },
			{ 2, {} },
		} },
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -15, 25, 0 }, LS = { 20, 0, 10 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } } },
			{ 0.8, { Neck = { -15, 25, 0 }, LS = { 20, 0, 10 }, LE = { 90, 0, 0 }, LW = { 0, 90, 0 } } },
			{ 1.2, { Neck = { -15, 25, 0 }, LS = { 20, 0, 10 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } } },
			{ 1.6, { Neck = { -15, 25, 0 }, LS = { 20, 0, 10 }, LE = { 90, 0, 0 }, LW = { 0, 90, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 2.4, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.5, { Root = { 0, 0, -6, 0, -0.05, 0 }, Waist = { 0, 0, -8 }, RS = { 15, 0, 25 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -15 }, LE = { 100, 0, 0 } } },
			{ 1.8, { Root = { 0, 0, -7, 0, -0.06, 0 }, Waist = { 0, 0, -9 }, Neck = { 0, 15, 0 }, RS = { 15, 0, 26 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -15 }, LE = { 100, 0, 0 } } },
			{ 2.4, {} },
		} },
	},
}

-- Pendant qu'elle tient quelqu'un : la ventouse collée sur son visage, les deux mains sur le manche, penchée en arrière
data.grabHold = {
	Root = { 8, 0, 0, 0, -0.15, 0.15 },
	Waist = { 10, 0, 0 },
	Neck = { 4, 0, 0 },
	RS = { 88, 0, -5 },
	RE = { 15, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 85, 0, 18 },
	LE = { 35, 0, 0 },
}

-- Retour 🪂 : elle jaillit d'une bouche d'égout comme un bouchon de champagne (POP), atterrit et fait tourner
-- sa ventouse comme un revolver avant de la rengainer
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Chaussee", "base", "block", Vector3.new(5, 1, 3), Vector3.new(0, -0.5, 0), Vector3.zero, Color3.fromRGB(70, 70, 78), "Concrete" },
		{ "Plaque", "", "cyl", Vector3.new(0.12, 2.6, 2.6), Vector3.new(0, 0.02, 0), Vector3.zero, Color3.fromRGB(55, 55, 60), "Metal" },
		{ "Rainure1", "", "block", Vector3.new(2.2, 0.14, 0.15), Vector3.new(0, 0.05, -0.5), Vector3.zero, Color3.fromRGB(35, 35, 40), "Metal" },
		{ "Rainure2", "", "block", Vector3.new(2.2, 0.14, 0.15), Vector3.new(0, 0.05, 0.5), Vector3.zero, Color3.fromRGB(35, 35, 40), "Metal" },
		{ "Couvercle", "", "cyl", Vector3.new(0.12, 2.6, 2.6), Vector3.new(2.3, 0.2, 0.4), Vector3.new(0, 0, 25), Color3.fromRGB(55, 55, 60), "Metal" },
		{ "Flaque", "", "block", Vector3.new(1.6, 0.05, 1), Vector3.new(-1.6, 0.02, -0.6), Vector3.zero, WATER, "Glass", { transparency = 0.3 } },
	} },
	keys = {
		{ 0.0, { Root = { -10, 0, 0, 0, -1.0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 80, 0, 0 }, LS = { 20, 0, -10 }, LE = { 80, 0, 0 } } },
		{ 0.2, { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 175, 0, 15 }, RE = { 0, 0, 0 }, LS = { 175, 0, -15 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.5, 0 }, FL = { 0, 0, 0, 0, 0.5, 0 } } },
		{ 0.5, { Root = { -6, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 55 }, RE = { 20, 0, 0 }, LS = { 90, 0, -55 }, LE = { 20, 0, 0 } } },
		{ 0.75, { Root = { 0, 10, 0, 0, -0.15, 0 }, Waist = { 4, 10, 0 }, Neck = { 8, -10, 0 }, RS = { 80, 0, 25 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } } },
		{ 0.95, { Root = { 0, 10, 0, 0, -0.15, 0 }, Waist = { 4, 10, 0 }, Neck = { 8, -10, 0 }, RS = { 80, 0, 25 }, RE = { 20, 0, 0 }, RW = { 120, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } } },
		{ 1.15, { Root = { 0, 10, 0, 0, -0.15, 0 }, Waist = { 4, 10, 0 }, Neck = { 8, -10, 0 }, RS = { 80, 0, 25 }, RE = { 20, 0, 0 }, RW = { -110, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } } },
		{ 1.35, { Root = { 0, 10, 0, 0, -0.15, 0 }, Waist = { 4, 10, 0 }, Neck = { 8, -10, 0 }, RS = { 80, 0, 25 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } } },
		{ 1.55, { Waist = { 2, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 10, 0, 15 }, RE = { 10, 0, 0 }, LS = { -10, 0, -20 }, LE = { 100, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.05, { "burst", color = WATER, size = 3, at = "feet" } },
		{ 0.15, { "text", text = "POP !", color = WATER } },
		{ 0.2, { "particles", tex = "smoke", color = WATER, dir = "up", at = "feet", time = 0.4, speed = 14 } },
		{ 0.5, { "puddle", color = WATER, width = 4 } },
		{ 1.2, { "text", text = "PLOMBERIE, BONJOUR !", color = WATER } },
	},
}

-- Arbre d'enchaînements : P → P → P (clé, botte, bonk de ventouse), K → K → K (botte, genou, uppercut à la clé),
-- chaque chaîne peut finir sur S (POP de ventouse qui colle, ou Coup de pression).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol, sans direction (P P P K : home run, finition ; P P →P : pompage)
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side2", S = "S_finish_pop" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", fwd_P = "P_pompe", S = "S_finish_jet" }, -- P P
	P_combo3 = { K = "K_homerun", P = "P_pompe", S = "S_finish_pop" }, -- P P P
	P_pompe = { P = "P_combo3", K = "K_lasso", S = "S_finish_pop" }, -- P P →P (pompage)
	PK_combo = { P = "KP_combo", K = "K_lasso", S = "S_finish_jet" }, -- P K
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_pop" },
	K_combo2 = { K = "K_combo3", P = "P_pompe", fwd_K = "K_lasso", S = "S_finish_jet" }, -- K K
	K_combo3 = { K = "K_air_side", P = "P_air", S = "S_air" }, -- K K K : elle décolle
	K_lasso = { K = "K_homerun", P = "P_combo3", S = "S_finish_pop" }, -- K K →K (lasso)
	KP_combo = { K = "K_lasso", P = "P_pompe", S = "S_finish_pop" }, -- K P
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_pop" },
	P_side2 = { K = "PK_combo", P = "P_pompe", S = "S_finish_jet" },
	P_down = { P = "P_up2", K = "K_down", S = "S_finish_pop" },
	P_up = { P = "P_up2", K = "K_up", S = "S_finish_jet" },
	P_up2 = { P = "P_air_up", K = "K_air_up", S = "S_air" },
	K_side = { P = "KP_combo", K = "K_lasso", S = "S_finish_jet" },
	K_down = { P = "P_up2", K = "K_lasso", S = "S_finish_pop" },
	K_up = { P = "P_up2", S = "S_finish_jet" },
	P_dash = { P = "P_side2", K = "K_combo2", S = "S_finish_pop" },
	K_dash = { P = "KP_combo", K = "K_lasso", S = "S_finish_jet" },
	-- en l'air ; ↓P et ↓K (smash vers le sol) sont des finitions sans suite
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

-- Dr Fraise, dentiste : blouse blanche, lampe frontale et sourire éblouissant ; il contrôle le terrain au gaz
-- hilarant (fou rire : ni K ni ⭐). Arme sortie de la Caisse Bizarre : fraise géante (et son miroir dentaire).
--
-- Même format que Gege.lua (voir l'en-tête de ce fichier et docs/fiche-perso.md).
-- Le bras droit tient la fraise ; la main gauche sort les petits instruments (miroir, fil, seringue, pince…)
-- le temps d'un coup (accessoires cachés, champ prop).
-- Signatures (L) et Supers (Y) « sûrs de toucher » : couloirs de 16 studs, projectiles qui visent l'adversaire,
-- ↑L = envol en diagonale ; plus aucun coût (voir docs/fiche-perso.md).

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(242, 204, 172)
local COAT = Color3.fromRGB(244, 247, 250)
local SCRUBS = Color3.fromRGB(70, 168, 170)
local GLOVE = Color3.fromRGB(150, 205, 240)
local HAIR = Color3.fromRGB(70, 45, 30)
local STEEL = Color3.fromRGB(190, 198, 210)
local DARK = Color3.fromRGB(35, 35, 45)
local MINT = Color3.fromRGB(120, 230, 210)
local GAS = Color3.fromRGB(255, 160, 210)
local RINSE = Color3.fromRGB(60, 150, 255)
local SPARK = Color3.fromRGB(255, 255, 220)
local CHAIR = Color3.fromRGB(90, 200, 200)
local TOOTH = Color3.fromRGB(255, 255, 250)

-- Molaire géante (projectile de la Dent de sagesse) et fauteuil à roulettes (projectile du Fauteuil fou)
local MOLAR = { shape = "block", size = 1.6, color = TOOTH, spin = 8, parts = {
	{ "ball", Vector3.new(0.5, 0.9, 0.5), Vector3.new(0.45, -0.9, 0), TOOTH },
	{ "ball", Vector3.new(0.5, 0.9, 0.5), Vector3.new(-0.45, -0.9, 0), TOOTH },
} }
local CHAIR_SHOT = { shape = "block", size = 2.4, color = CHAIR, spin = 4, parts = {
	{ "block", Vector3.new(2.2, 2.4, 0.5), Vector3.new(0, 1.6, 0.9), CHAIR },
	{ "block", Vector3.new(1.4, 0.4, 0.4), Vector3.new(0, 2.1, 1.3), COAT },
	{ "cyl", Vector3.new(0.3, 0.5, 0.5), Vector3.new(0.9, -1.4, 0), DARK },
	{ "cyl", Vector3.new(0.3, 0.5, 0.5), Vector3.new(-0.9, -1.4, 0), DARK },
} }

local PASTE = Color3.fromRGB(90, 200, 255) -- dentifrice (brosse géante, arme n° 2)
local ANESTH = Color3.fromRGB(180, 140, 255) -- produit anesthésiant (seringue XL, arme n° 3)
local data = {
	id = "Fraise",
	name = "Dr Fraise",
	costume = "Fraise",
	style = "doctor",
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la fraise géante (ses coups sont ceux de moves). n° 2 : la brosse à dents géante, lourde, qui balaie large
	-- et fait glisser sur la mousse. n° 3 : la seringue XL, piqûres rapides et jets d'anesthésiant qui endorment.
	weapons = {
		{ id = "fraise", name = "Fraise géante", icon = "🦷",
			ability = { status = { name = "laughing", duration = 1.5 }, text = "Les L font pouffer de rire 1,5 s (ni K ni ⭐)" } },
		{ id = "brosse", name = "Brosse à dents géante", icon = "🪥",
			prop = { name = "PropBrosse", hand = "Right", pieces = {
				{ "Manche", "", "cyl", Vector3.new(0.4, 3.2, 0.4), Vector3.new(0, -1.4, 0), Vector3.zero, MINT, "SmoothPlastic" },
				{ "Col", "", "cyl", Vector3.new(0.3, 0.8, 0.3), Vector3.new(0, -3.3, -0.1), Vector3.new(15, 0, 0), COAT, "SmoothPlastic" },
				{ "Tete", "", "block", Vector3.new(0.5, 1.3, 0.35), Vector3.new(0, -4.2, -0.3), Vector3.zero, COAT, "SmoothPlastic" },
				{ "Poils", "", "block", Vector3.new(0.46, 1.2, 0.4), Vector3.new(0, -4.2, -0.65), Vector3.zero, TOOTH, "Fabric" },
				{ "Mousse", "", "ball", Vector3.new(0.7, 0.9, 0.5), Vector3.new(0, -4.3, -0.95), Vector3.zero, PASTE, "SmoothPlastic", { transparency = 0.3 } },
			} },
			ability = { reach = 1.25, text = "Grand manche : portée de tous les coups +25 %" },
			moves = {
				-- J : il brosse l'adversaire de haut en bas, bras tendu, trois petits coups secs
				P_neutral = {
					label = "Brossage vertical", startup = 0.1, active = 0.18, recovery = 0.18, hits = 2,
					damage = 4, hitbox = box(5, 3.5, 3, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 25,
					windup = { Root = { 2, -10, 0, 0, -0.1, 0.1 }, Waist = { 2, -12, 0 }, Neck = { -6, 0, 0 }, RS = { 150, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 8, 0, 0, -0.25, -0.3 }, Waist = { -8, 10, 0 }, Neck = { -4, 0, 0 }, RS = { 70, 0, 0 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
					follow = { Root = { -10, 10, 0, 0, -0.28, -0.32 }, Waist = { -10, 12, 0 }, Neck = { -4, 0, 0 }, RS = { 110, 0, 0 }, RE = { 10, 0, 0 }, RW = { 20, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
					wobble = true, trail = "prop", fx = { { "particles", tex = "smoke", color = TOOTH, dir = "front", at = "hand", time = 0.2, speed = 6, size = 0.4, rate = 40 } }, hitText = "FROT FROT !",
				},
				-- →J : grand balayage horizontal de la brosse, de gauche à droite, le manche à deux mains
				P_side = {
					label = "Balayage mousseux", startup = 0.15, active = 0.12, recovery = 0.26,
					damage = 9, hitbox = box(7, 3.5, 4, 0.8), kbBase = 26, kbGrowth = 42, kbAngle = 26, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 4, 40, 0, 0, -0.2, 0.2 }, Waist = { 6, 46, 0 }, Neck = { 0, -20, 0 }, RS = { 80, 0, 60 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 20 }, LE = { 50, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 20, 0 }, RS = { 92, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -40, 0, 0, -0.32, -0.4 }, Waist = { -12, -46, 0 }, Neck = { 0, 26, 0 }, RS = { 96, 0, -36 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { { "toss", shape = "ball", color = TOOTH, size = 0.4, count = 4, speed = 14 } }, hitText = "SPLATCH !",
				},
				-- ↓J : accroupi, il frotte le sol avec la brosse et envoie la mousse dans les chevilles
				P_down = {
					label = "Récurage de chevilles", startup = 0.12, active = 0.14, recovery = 0.22,
					damage = 7, hitbox = box(6.5, 2, 3.5, -1.5), kbBase = 22, kbGrowth = 30, kbAngle = 70,
					windup = { Root = { 10, -10, 0, 0, -0.85, 0.1 }, Waist = { 16, -12, 0 }, Neck = { 10, 6, 0 }, RS = { 60, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, LH = { -40, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 16, 12, 0, 0, -0.95, -0.2 }, Waist = { 24, 14, 0 }, Neck = { 12, -6, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 18, 16, 0, 0, -0.95, -0.24 }, Waist = { 26, 18, 0 }, Neck = { 14, -8, 0 }, RS = { 34, 0, 14 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 44, 0, -32 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					wobble = true, trail = "prop", fx = { { "puddle", color = TOOTH, width = 5 } }, hitText = "FROTTÉ !",
				},
				-- ↑J : il remonte la brosse sous le menton comme pour brosser les dents du bas
				P_up = {
					label = "Brossage du bas", startup = 0.12, active = 0.12, recovery = 0.24,
					damage = 8, hitbox = box(4.5, 5.5, 1.5, 3), kbBase = 24, kbGrowth = 42, kbAngle = 86,
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 100, 0, 0 }, RW = { 20, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.1, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 174, 0, 10 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.14, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 180, 0, 12 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 44, 0, -32 }, LE = { 90, 0, 0 } },
					trail = "prop", fx = { { "burst", color = TOOTH, size = 1.5, at = "above" } }, hitText = "FRRRT !",
				},
				-- J en l'air : il abat la brosse sous lui comme une rame
				P_air = {
					label = "Coup de rame", startup = 0.12, active = 0.14, recovery = 0.18,
					damage = 9, hitbox = box(5, 4, 1.5, -1.5), kbBase = 22, kbGrowth = 40, kbAngle = -45,
					windup = { Root = { 8, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -20 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 20, 0, -10 }, LE = { 0, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 30, 0, -10 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 14, 0, 12 }, RE = { 4, 0, 0 }, RW = { -30, 0, 0 }, LS = { 14, 0, -12 }, LE = { 4, 0, 0 }, RH = { 16, 0, 10 }, RK = { -36, 0, 0 }, LH = { 26, 0, -10 }, LK = { -56, 0, 0 } },
					trail = "prop", hitText = "PAF !",
				},
				-- dash J : il court brosse en avant comme une lance de tournoi
				P_dash = {
					label = "Lance de tournoi", startup = 0.1, active = 0.16, recovery = 0.28,
					damage = 9, hitbox = box(6, 3, 4, 0.5), kbBase = 26, kbGrowth = 44, kbAngle = 24, selfVelocity = Vector2.new(40, 0),
					windup = { Root = { 8, -20, 0, 0, -0.2, 0.1 }, Waist = { 10, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { 14, 16, 0, 0, -0.3, -0.4 }, Waist = { 16, 20, 0 }, Neck = { -8, -12, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -30, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { 16, 18, 0, 0, -0.32, -0.44 }, Waist = { 18, 22, 0 }, Neck = { -10, -14, 0 }, RS = { 96, 0, 2 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -34, 0, -32 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					trail = "prop", fx = { "dust" }, hitText = "EMBROCHÉ !",
				},
				-- K : coup de pied frontal en s'appuyant sur le manche planté au sol, comme sur une canne
				K_neutral = {
					label = "Pied sur canne", startup = 0.15, active = 0.1, recovery = 0.28,
					damage = 10, hitbox = box(5, 3.5, 3, 0.3), kbBase = 28, kbGrowth = 58, kbAngle = 35,
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.1 }, Waist = { 6, -10, 0 }, Neck = { 0, 6, 0 }, RS = { 30, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { -30, 0, 0 }, RK = { -50, 0, 0 } },
					strike = { Root = { 8, 0, 0, 0, -0.1, 0.05 }, Waist = { 10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -55 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, -0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 44 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 74, 0, -60 }, LE = { 25, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
					trail = "rightFoot", hitText = "PAF !",
				},
				-- →K : saut à la perche : il plante le manche et bascule par-dessus pour arriver les deux pieds en avant
				K_side = {
					label = "Saut à la perche", startup = 0.18, active = 0.14, recovery = 0.34,
					damage = 13, hitbox = box(6, 4, 3.5, 0.5), kbBase = 34, kbGrowth = 72, kbAngle = 36, selfVelocity = Vector2.new(30, 22),
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 120, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -10 }, LE = { 20, 0, 0 } },
					strike = { Root = { -20, 0, 0, 0, 0.3, -0.2 }, Waist = { -16, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, RH = { 95, 0, 6 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { 95, 0, -6 }, LK = { -6, 0, 0 }, LA = { 10, 0, 0 } },
					follow = { Root = { -24, 0, 0, 0, 0.34, -0.24 }, Waist = { -18, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 36, 0, -12 }, LE = { 0, 0, 0 }, RH = { 100, 0, 8 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 100, 0, -8 }, LK = { 0, 0, 0 }, LA = { 14, 0, 0 } },
					trail = "bothFeet", hitText = "DOUBLE SEMELLE !",
				},
				-- ↓K : balayette basse avec le manche en appui, tête baissée
				K_down = {
					label = "Balayette au manche", startup = 0.14, active = 0.14, recovery = 0.3,
					damage = 9, hitbox = box(7, 2, 3.5, -1.6), kbBase = 26, kbGrowth = 52, kbAngle = 75,
					windup = { Root = { 12, 10, 0, 0, -0.85, 0.1 }, Waist = { 16, 14, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 16, -20, 0, 0, -0.95, -0.1 }, Waist = { 20, -26, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 18, -26, 0, 0, -0.95, -0.14 }, Waist = { 22, -32, 0 }, Neck = { 10, 0, 0 }, RS = { 42, 0, 42 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : coup de pied monté, la brosse levée bien haut hors du chemin
				K_up = {
					label = "Pied monté hygiénique", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 64, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.25, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 180, 0, 32 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", hitText = "KLANG !",
				},
				-- K en l'air : double pied en pédalant, la brosse tenue au-dessus de la tête comme un parapluie
				K_air = {
					label = "Pédalage sous la brosse", startup = 0.12, active = 0.2, recovery = 0.2,
					damage = 10, hits = 2, hitbox = box(5, 4, 2.5, -0.5), kbBase = 22, kbGrowth = 46, kbAngle = 40,
					windup = { Root = { -10, 0, 0 }, Waist = { -8, 0, 0 }, RS = { 180, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -6, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 184, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -44 }, LE = { 80, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { -4, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 186, 0, 14 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 66, 0, -46 }, LE = { 80, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "bothFeet", hitText = "TAC TAC !",
				},
				-- dash K : glissade sur la mousse, assis sur la tête de la brosse comme sur une luge
				K_dash = {
					label = "Luge mousseuse", startup = 0.1, active = 0.26, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3, -0.8), kbBase = 30, kbGrowth = 64, kbAngle = 38, selfVelocity = Vector2.new(55, 10),
					status = { name = "slippery", duration = 1.5 },
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 } },
					strike = { Root = { 20, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 24, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, RS = { -36, 0, 55 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "bothFeet", fx = { { "puddle", color = TOOTH, width = 8 }, "dust" }, hitText = "SKRRRT !",
				},
				-- L : grand brossage : trois allers-retours de la brosse à deux mains qui récurent tout le couloir dans une avalanche de mousse
				S_neutral = {
					label = "Grand brossage", startup = 0.22, active = 0.3, recovery = 0.5, hits = 3,
					damage = 5, hitbox = box(14, 5, 7, 0.8), kbBase = 24, kbGrowth = 44, kbAngle = 30,
					status = { name = "slippery", duration = 2 },
					windup = { Root = { 4, -30, 0, 0, -0.2, 0.2 }, Waist = { 6, -34, 0 }, Neck = { 0, 20, 0 }, RS = { 80, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 10 }, LE = { 60, 0, 0 } },
					strike = { Root = { -10, 30, 0, 0, -0.3, -0.35 }, Waist = { -12, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 92, 0, -40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -70 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -30, 0, 0, -0.3, -0.35 }, Waist = { -12, -34, 0 }, Neck = { 0, 20, 0 }, RS = { 92, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					wobble = true, trail = "prop", fx = { { "beam", color = TOOTH, length = 14, width = 4, at = "front" }, { "particles", tex = "smoke", color = TOOTH, dir = "front", at = "hand", time = 0.4, speed = 14, size = 0.8, rate = 80 }, { "puddle", color = PASTE, width = 12 } },
					text = "ON FROTTE !", hitText = "RÉCURÉ !",
				},
				-- →L : il presse la tête de la brosse comme un tube : un gros paquet de mousse mentholée file droit sur l'adversaire
				S_side = {
					label = "Boule de mousse", kind = "projectile", startup = 0.24, active = 0, recovery = 0.5,
					damage = 15, kbBase = 30, kbGrowth = 58, kbAngle = 32,
					projectile = { speed = 72, angle = 0, gravity = 0, lifetime = 0.7, size = 2.4, color = TOOTH,
						visual = { shape = "ball", size = 2.2, color = TOOTH, transparency = 0.15, spin = 4, parts = { { "ball", Vector3.new(1, 1, 1), Vector3.new(0.9, 0.7, 0), PASTE }, { "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(-0.8, -0.6, 0.4), MINT } } } },
					status = { name = "slippery", duration = 2 },
					windup = { Root = { 6, -26, 0, 0, -0.2, 0.2 }, Waist = { 8, -30, 0 }, Neck = { 4, 18, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 20, 0, 0, -0.3, -0.4 }, Waist = { -14, 24, 0 }, Neck = { -6, -14, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 94, 0, -6 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					follow = { Root = { -14, 24, 0, 0, -0.32, -0.45 }, Waist = { -16, 28, 0 }, Neck = { -8, -16, 0 }, RS = { 98, 0, 2 }, RE = { 4, 0, 0 }, RW = { -40, 0, 0 }, LS = { 98, 0, -8 }, LE = { 4, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					fx = { { "burst", color = TOOTH, size = 2.5, at = "hand" }, { "particles", tex = "smoke", color = TOOTH, dir = "front", at = "hand", time = 0.25, speed = 10, size = 0.6, rate = 50 } },
					text = "PSCHHH !", hitText = "MOUSSÉ !",
				},
				-- ↓L : il frotte le sol si fort que la mousse monte en vague et roule sur tout le couloir
				S_down = {
					label = "Vague de dentifrice", startup = 0.22, active = 0.22, recovery = 0.5,
					damage = 13, hitbox = box(14, 5, 7, 0.5), kbBase = 28, kbGrowth = 52, kbAngle = 45,
					status = { name = "slippery", duration = 2.5 },
					windup = { Root = { 14, 0, 0, 0, -0.9, 0.2 }, Waist = { 24, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 20, 0, 0, 0, -1.0, -0.3 }, Waist = { 30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -20 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 22, 0, 0, 0, -1.0, -0.34 }, Waist = { 32, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 22 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 20, 0, -22 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.1, wobble = true, trail = "prop", fx = { { "puddle", color = PASTE, width = 14 }, { "beam", color = TOOTH, length = 14, width = 3, at = "feet" }, { "ring", color = PASTE, radius = 6, at = "feet" } },
					text = "SCHLOUF !", hitText = "GLISSÉ !",
				},
				-- ↑L : il saute sur la brosse comme sur un bâton sauteur et le ressort de mousse le propulse en diagonale
				S_up = {
					label = "Bâton sauteur", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 74, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 60, 0, 0 }, RH = { 40, 0, 5 }, RK = { -80, 0, 0 }, LH = { 40, 0, -5 }, LK = { -80, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 34, 0, 12 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -12 }, LE = { 60, 0, 0 }, RH = { 44, 0, 6 }, RK = { -84, 0, 0 }, LH = { 44, 0, -6 }, LK = { -84, 0, 0 } },
					shake = true, trail = "prop", fx = { { "burst", color = TOOTH, size = 3, at = "feet" }, { "particles", tex = "smoke", color = TOOTH, dir = "down", at = "feet", time = 0.5, speed = 16, size = 0.7, rate = 90 }, { "ring", color = PASTE, radius = 5, at = "feet" } },
					text = "BOÏNG !", hitText = "PROPULSÉ !",
				},
				-- L en l'air : il brosse l'air sous lui en tourbillon, un cyclone de mousse descend sur l'adversaire
				S_air = {
					label = "Cyclone mousseux", startup = 0.16, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(9, 6, 1, -2), kbBase = 26, kbGrowth = 54, kbAngle = -50, selfVelocity = Vector2.new(4, -70),
					windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -26, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 10, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 20, 0, 0 }, RH = { -10, 0, 6 }, RK = { -10, 0, 0 }, LH = { -10, 0, -6 }, LK = { -10, 0, 0 } },
					follow = { Root = { -30, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 12, 0, 44 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 44, 0, -64 }, LE = { 20, 0, 0 }, RH = { -12, 0, 6 }, RK = { -14, 0, 0 }, LH = { -12, 0, -6 }, LK = { -14, 0, 0 } },
					spin = { axis = "y", degrees = 720 }, trail = "prop", fx = { { "particles", tex = "smoke", color = TOOTH, dir = "down", at = "hand", time = 0.3, speed = 14, size = 0.6, rate = 80 }, { "ring", color = PASTE, radius = 4, at = "feet" } },
					text = "CYCLONE !", hitText = "ESSORÉ !",
				},
				-- Y : brossage obligatoire : il attrape l'adversaire par la nuque et lui brosse les dents de force, trois minutes montre en main (en accéléré), mousse jusqu'au plafond
				SUPER = {
					label = "Brossage obligatoire !", startup = 0.4, active = 0.4, recovery = 0.7, hits = 4,
					damage = 6, hitbox = box(16, 6, 8, 1), kbBase = 36, kbGrowth = 70, kbAngle = 40,
					status = { name = "slippery", duration = 3 },
					windup = { Root = { 6, -24, 0, 0, -0.2, 0.25 }, Waist = { 8, -28, 0 }, Neck = { 6, 16, 0 }, RS = { 150, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -30 }, LE = { 30, 0, 0 } },
					strike = { Root = { -10, 24, 0, 0, -0.3, -0.4 }, Waist = { -12, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 100, 0, -20 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 92, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -10, -10, 0, 0, -0.3, -0.4 }, Waist = { -12, -12, 0 }, Neck = { -6, 8, 0 }, RS = { 100, 0, 30 }, RE = { 10, 0, 0 }, RW = { 40, 0, 0 }, LS = { 92, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					wobble = true, trail = "prop", windupFx = { "super", { "text", text = "3 MINUTES, PAS MOINS", color = PASTE, at = "above" } },
					fx = { { "beam", color = TOOTH, length = 16, width = 5, at = "front" }, { "particles", tex = "smoke", color = TOOTH, dir = "all", at = "front", time = 0.6, speed = 16, size = 1.2, rate = 120 }, { "symbols", symbols = { "🪥", "✨", "🦷" }, count = 8, radius = 5, color = PASTE }, { "shake", amount = 0.3 } },
					text = "ON BROSSE !", hitText = "HAUT, BAS, HAUT, BAS !",
				},
				-- →Y : la brosse-hélice : il la fait tournoyer à l'horizontale devant lui et la lâche : elle traverse le couloir en hélicoptère et revient dans sa main
				SUPER_side = {
					label = "Brosse-hélice !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 46, kbGrowth = 94, kbAngle = 34,
					projectile = { speed = 82, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = MINT, returns = true, pierce = true,
						visual = { shape = "block", size = 1, color = MINT, spin = 16, parts = { { "cyl", Vector3.new(0.5, 4.2, 0.5), Vector3.new(0, 0, 0), MINT }, { "block", Vector3.new(0.6, 1.3, 0.5), Vector3.new(0, 2.4, -0.3), TOOTH } } } },
					status = { name = "inverted", duration = 2 },
					windup = { Root = { 6, -36, 0, 0, -0.3, 0.3 }, Waist = { 10, -40, 0 }, Neck = { 10, 24, 0 }, RS = { 176, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -16, 26, 0, 0, -0.34, -0.5 }, Waist = { -18, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -18, 30, 0, 0, -0.36, -0.55 }, Waist = { -22, 34, 0 }, Neck = { -8, -20, 0 }, RS = { 98, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 46, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					spin = { axis = "y", degrees = 360 }, hideProp = "brosse", windupFx = { "super", { "symbols", symbols = { "🪥", "🚁" }, count = 6, radius = 3, color = MINT } },
					fx = { { "burst", color = TOOTH, size = 3, at = "hand" }, { "ring", color = PASTE, radius = 4, at = "front" }, { "shake", amount = 0.3 } },
					text = "HÉLICE !", hitText = "FAUCHÉ !",
				},
				-- ↑Y : geyser de mousse : il plante la brosse dans le sol et frotte comme un fou : un geyser de mousse mentholée jaillit sous lui et emporte tout au plafond
				SUPER_up = {
					label = "Geyser de mousse !", startup = 0.38, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					status = { name = "slippery", duration = 2 },
					windup = { Root = { 14, 0, 0, 0, -0.9, 0.1 }, Waist = { 24, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 156, 0, -66 }, LE = { 10, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 360 }, trail = "prop",
					windupFx = { "super", { "particles", tex = "smoke", color = TOOTH, dir = "up", at = "feet", time = 0.35, speed = 8, size = 0.6, rate = 60 } },
					fx = { { "pillar", color = TOOTH, height = 22, width = 4, at = "front" }, { "beam", color = PASTE, length = 16, width = 5, at = "feet" }, { "burst", color = MINT, size = 4, at = "above" }, { "ring", color = PASTE, radius = 6, at = "feet" }, { "shake", amount = 0.4 } },
					text = "GEYSER !", hitText = "MENTHE FRAÎCHE !",
				},
				-- ↓Y : le rinçage final : il crache un jet d'eau de rinçage de chaque côté sur toute la plateforme, comme une lance d'incendie
				SUPER_down = {
					label = "Rinçage final !", startup = 0.4, active = 0.2, recovery = 0.7,
					damage = 22, hitbox = box(34, 7, 0, 2), kbBase = 36, kbGrowth = 64, kbAngle = 55,
					status = { name = "wet", duration = 3 },
					windup = { Root = { 14, 0, 0, 0, -0.2, 0.3 }, Waist = { 24, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 40, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 90, 0, 0 } },
					strike = { Root = { -20, 0, 0, 0, -0.35, -0.3 }, Waist = { -26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -80 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.3, 0, 0 }, FL = { 0, 0, 0, -0.3, 0, 0 } },
					follow = { Root = { -22, 0, 0, 0, -0.38, -0.34 }, Waist = { -28, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 16, 0, 84 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 16, 0, -84 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.3, 0, 0 }, FL = { 0, 0, 0, -0.3, 0, 0 } },
					hold = 0.4, shake = true, windupFx = { "super", { "text", text = "GLOU GLOU GLOU", color = RINSE, at = "head" } },
					fx = { { "beam", color = RINSE, length = 34, width = 4, at = "head" }, { "particles", tex = "smoke", color = RINSE, dir = "all", at = "head", time = 0.6, speed = 30, size = 1, rate = 150 }, { "puddle", color = RINSE, width = 20 }, { "shake", amount = 0.4 } },
					text = "RINCEZ TOUS !", hitText = "TREMPÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_down" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "seringue", name = "Seringue XL", icon = "💉",
			prop = { name = "PropSeringueXL", hand = "Right", pieces = {
				{ "Corps", "", "cyl", Vector3.new(0.6, 2.2, 0.6), Vector3.new(0, -1.1, 0), Vector3.zero, Color3.fromRGB(220, 240, 255), "Glass", { transparency = 0.3 } },
				{ "Produit", "", "cyl", Vector3.new(0.45, 1.6, 0.45), Vector3.new(0, -1.2, 0), Vector3.zero, ANESTH, "Neon", { neon = true } },
				{ "Piston", "", "cyl", Vector3.new(0.2, 1.2, 0.2), Vector3.new(0, 0.5, 0), Vector3.zero, STEEL, "Metal" },
				{ "Poussoir", "", "cyl", Vector3.new(0.7, 0.15, 0.7), Vector3.new(0, 1.1, 0), Vector3.zero, STEEL, "Metal" },
				{ "Aiguille", "", "cyl", Vector3.new(0.1, 1.4, 0.1), Vector3.new(0, -2.9, 0), Vector3.zero, STEEL, "Metal" },
			} },
			ability = { heal = 0.3, text = "Ça pique mais ça soigne : 30 % des dégâts infligés le remettent sur pied" },
			moves = {
				-- J : petite piqûre sèche dans l'épaule, le poignet cassé comme un escrimeur
				P_neutral = {
					label = "Piqûre à l'épaule", startup = 0.06, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(4.5, 3, 3, 0.8), kbBase = 16, kbGrowth = 22, kbAngle = 25,
					windup = { Root = { 2, -14, 0, 0, -0.1, 0.1 }, Waist = { 2, -16, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -6, 12, 0, 0, -0.2, -0.3 }, Waist = { -6, 14, 0 }, Neck = { 0, -8, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -20, 0, -30 }, LE = { 70, 0, 0 } },
					follow = { Root = { -7, 14, 0, 0, -0.22, -0.33 }, Waist = { -7, 16, 0 }, Neck = { 0, -10, 0 }, RS = { 96, 0, -2 }, RE = { 4, 0, 0 }, RW = { 90, 0, 0 }, LS = { -24, 0, -32 }, LE = { 70, 0, 0 } },
					trail = "prop", hitText = "PIC !",
				},
				-- →J : fente d'escrimeur, la seringue en avant comme un fleuret
				P_side = {
					label = "Fente au fleuret", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 7, hitbox = box(7, 2.5, 4.5, 0.6), kbBase = 20, kbGrowth = 34, kbAngle = 20, selfVelocity = Vector2.new(20, 0),
					windup = { Root = { 0, -30, 0, 0, -0.15, 0.2 }, Waist = { 2, -34, 0 }, Neck = { 0, 24, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 60, 0, 0 }, LS = { 100, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, 30, 0, 0, -0.5, -0.5 }, Waist = { -6, 34, 0 }, Neck = { 0, -22, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 150, 0, -20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.9 } },
					follow = { Root = { -8, 32, 0, 0, -0.52, -0.55 }, Waist = { -8, 36, 0 }, Neck = { 0, -24, 0 }, RS = { 98, 0, -2 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 154, 0, -22 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.95 } },
					trail = "prop", text = "TOUCHÉ !", hitText = "PIC !",
				},
				-- ↓J : accroupi, petite piqûre dans le mollet, « ça ne fait pas mal »
				P_down = {
					label = "Piqûre au mollet", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 6, hitbox = box(6, 2, 3.5, -1.5), kbBase = 20, kbGrowth = 28, kbAngle = 70,
					windup = { Root = { 10, -14, 0, 0, -0.85, 0.1 }, Waist = { 16, -16, 0 }, Neck = { 10, 10, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, LH = { -40, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 14, 12, 0, 0, -0.95, -0.2 }, Waist = { 22, 14, 0 }, Neck = { 8, -8, 0 }, RS = { 50, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 16, 14, 0, 0, -0.95, -0.24 }, Waist = { 24, 16, 0 }, Neck = { 8, -10, 0 }, RS = { 46, 0, 2 }, RE = { 4, 0, 0 }, RW = { 90, 0, 0 }, LS = { 44, 0, -32 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", text = "ÇA NE FAIT PAS MAL…", hitText = "AÏE !",
				},
				-- ↑J : piqûre remontante sous le menton, l'aiguille pointée au ciel
				P_up = {
					label = "Piqûre au menton", startup = 0.1, active = 0.1, recovery = 0.22,
					damage = 7, hitbox = box(4, 5.5, 1.5, 3), kbBase = 22, kbGrowth = 40, kbAngle = 86,
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.1, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.14, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 182, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 44, 0, -32 }, LE = { 90, 0, 0 } },
					trail = "prop", hitText = "PIC !",
				},
				-- J en l'air : piqûre plongeante, l'aiguille pointée sous lui
				P_air = {
					label = "Piqûre plongeante", startup = 0.1, active = 0.12, recovery = 0.16,
					damage = 8, hitbox = box(4.5, 4, 1.5, -1.5), kbBase = 20, kbGrowth = 36, kbAngle = -45,
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 12 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 10, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 30, 0, -10 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 6, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 34, 0, -54 }, LE = { 60, 0, 0 }, RH = { 16, 0, 10 }, RK = { -36, 0, 0 }, LH = { 26, 0, -10 }, LK = { -56, 0, 0 } },
					trail = "prop", hitText = "PIC !",
				},
				-- dash J : en courant, il presse le piston et une giclée d'anesthésiant part devant lui
				P_dash = {
					label = "Giclée en courant", kind = "projectile", startup = 0.08, active = 0, recovery = 0.22,
					damage = 6, kbBase = 20, kbGrowth = 32, kbAngle = 28, selfVelocity = Vector2.new(30, 0),
					projectile = { speed = 85, angle = 4, gravity = 30, lifetime = 0.35, size = 1.2, color = ANESTH, aim = false,
						visual = { shape = "ball", size = 1, color = ANESTH, neon = true, transparency = 0.2 } },
					windup = { Root = { 8, -16, 0, 0, -0.15, 0.15 }, Waist = { 8, -20, 0 }, Neck = { 0, 12, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 }, LS = { -30, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 10, 14, 0, 0, -0.2, -0.3 }, Waist = { 10, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 10, 14, 0, 0, -0.2, -0.32 }, Waist = { 10, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 98, 0, -2 }, RE = { 4, 0, 0 }, RW = { 90, 0, 0 }, LS = { 64, 0, -10 }, LE = { 104, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					fx = { { "burst", color = ANESTH, size = 1, at = "hand" } }, text = "PSCHT !", hitText = "ASPERGÉ !",
				},
				-- K : coup de pied frontal, la seringue tenue haut comme une torche
				K_neutral = {
					label = "Pied du vaccinateur", startup = 0.15, active = 0.1, recovery = 0.28,
					damage = 10, hitbox = box(5, 3.5, 3, 0.3), kbBase = 28, kbGrowth = 58, kbAngle = 35,
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.1 }, Waist = { 6, -10, 0 }, Neck = { 0, 6, 0 }, RS = { 150, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { -30, 0, 0 }, RK = { -50, 0, 0 } },
					strike = { Root = { 8, 0, 0, 0, -0.1, 0.05 }, Waist = { 10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 160, 0, 34 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -55 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, -0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 164, 0, 36 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 74, 0, -60 }, LE = { 25, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
					trail = "rightFoot", hitText = "PAF !",
				},
				-- →K : coup de pied en avançant suivi d'une piqûre dans la foulée (deux touches)
				K_side = {
					label = "Pied puis piqûre", startup = 0.16, active = 0.2, recovery = 0.3, hits = 2,
					damage = 6, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 30, kbGrowth = 62, kbAngle = 34, selfVelocity = Vector2.new(22, 0),
					windup = { Root = { 6, 20, 0, 0, -0.2, 0.1 }, Waist = { 8, 26, 0 }, Neck = { 0, -14, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 6, -10, 0, 0, -0.15, -0.2 }, Waist = { 8, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -50 }, LE = { 60, 0, 0 }, RH = { 100, 0, 10 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { -8, 20, 0, 0, -0.3, -0.4 }, Waist = { -10, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -20, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					trail = "rightFoot", hitText = "PAF-PIC !",
				},
				-- ↓K : balayette basse, la seringue plantée dans le sol pour s'appuyer
				K_down = {
					label = "Balayette piquée", startup = 0.14, active = 0.14, recovery = 0.3,
					damage = 9, hitbox = box(7, 2, 3.5, -1.6), kbBase = 26, kbGrowth = 50, kbAngle = 75,
					windup = { Root = { 12, 10, 0, 0, -0.85, 0.1 }, Waist = { 16, 14, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 16, -20, 0, 0, -0.95, -0.1 }, Waist = { 20, -26, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 18, -26, 0, 0, -0.95, -0.14 }, Waist = { 22, -32, 0 }, Neck = { 10, 0, 0 }, RS = { 42, 0, 42 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : coup de pied monté, la seringue pointée au ciel pour chasser la bulle d'air (petite giclée)
				K_up = {
					label = "Pied monté, bulle chassée", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 64, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.25, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 180, 0, 22 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { { "particles", tex = "spark", color = ANESTH, dir = "up", at = "hand", time = 0.2, speed = 10, size = 0.3, rate = 40 } }, hitText = "KLANG !",
				},
				-- K en l'air : ciseaux de jambes, seringue pointée sur la cible
				K_air = {
					label = "Ciseaux stériles", startup = 0.12, active = 0.18, recovery = 0.2,
					damage = 10, hits = 2, hitbox = box(5, 4, 2.5, -0.5), kbBase = 22, kbGrowth = 46, kbAngle = 40,
					windup = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -4, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 44, 0, -44 }, LE = { 80, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { -30, 0, 0 }, LK = { -30, 0, 0 } },
					follow = { Root = { -2, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 46, 0, -46 }, LE = { 80, 0, 0 }, RH = { -30, 0, 0 }, RK = { -30, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "bothFeet", hitText = "TCHAC TCHAC !",
				},
				-- dash K : glissade à genoux, seringue en avant, comme un rockeur en fin de concert
				K_dash = {
					label = "Glissade à genoux", startup = 0.1, active = 0.24, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3.5, -0.5), kbBase = 30, kbGrowth = 62, kbAngle = 36, selfVelocity = Vector2.new(50, 0),
					windup = { Root = { 6, 0, 0, 0, -0.3, 0 }, Waist = { 8, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -1.0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 0, 0, 0 }, RK = { -130, 0, 0 }, LH = { 0, 0, 0 }, LK = { -130, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, -1.0, 0 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 154, 0, -44 }, LE = { 20, 0, 0 }, RH = { 0, 0, 0 }, RK = { -130, 0, 0 }, LH = { 0, 0, 0 }, LK = { -130, 0, 0 } },
					trail = "prop", fx = { "dust" }, hitText = "SKRRRT-PIC !",
				},
				-- L : jet d'anesthésiant : il presse le piston à fond, un long jet violet file droit sur l'adversaire, qui ralentit
				S_neutral = {
					label = "Jet d'anesthésiant", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 13, kbBase = 26, kbGrowth = 46, kbAngle = 30,
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.6, size = 1.6, color = ANESTH,
						visual = { shape = "ball", size = 1.4, color = ANESTH, neon = true, transparency = 0.2 } },
					status = { name = "slowed", duration = 2.5 },
					windup = { Root = { 4, -24, 0, 0, -0.2, 0.15 }, Waist = { 4, -28, 0 }, Neck = { 0, 18, 0 }, RS = { 70, 0, 10 }, RE = { 70, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 }, LW = { -40, 0, 0 } },
					strike = { Root = { -8, 20, 0, 0, -0.28, -0.3 }, Waist = { -10, 24, 0 }, Neck = { -4, -14, 0 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 90, 0, 0 }, LE = { 70, 0, 0 }, LW = { -80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -8, 20, 0, 0, -0.28, -0.3 }, Waist = { -10, 24, 0 }, Neck = { -4, -14, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 92, 0, 0 }, LE = { 60, 0, 0 }, LW = { -90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					fx = { { "beam", color = ANESTH, length = 10, width = 1.5, at = "hand" }, { "burst", color = ANESTH, size = 1.8, at = "hand" } }, text = "PSCHHHT !", hitText = "ENGOURDI !",
				},
				-- →L : la grande piqûre : fente profonde, l'aiguille s'enfonce dans tout le couloir et l'adversaire s'endort sur place
				S_side = {
					label = "La grande piqûre", startup = 0.26, active = 0.14, recovery = 0.5,
					damage = 15, hitbox = box(14, 4, 7, 0.6), kbBase = 24, kbGrowth = 44, kbAngle = 20, selfVelocity = Vector2.new(24, 0),
					status = { name = "asleep", duration = 2 },
					windup = { Root = { 0, -34, 0, 0, -0.15, 0.2 }, Waist = { 2, -38, 0 }, Neck = { 0, 26, 0 }, RS = { 30, 0, 20 }, RE = { 130, 0, 0 }, RW = { 60, 0, 0 }, LS = { 110, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, 34, 0, 0, -0.55, -0.6 }, Waist = { -6, 38, 0 }, Neck = { 0, -24, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 160, 0, -20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -1.0 } },
					follow = { Root = { -8, 36, 0, 0, -0.58, -0.65 }, Waist = { -8, 40, 0 }, Neck = { 0, -26, 0 }, RS = { 98, 0, -2 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 164, 0, -22 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -1.05 } },
					hold = 0.1, trail = "prop", fx = { { "beam", color = STEEL, length = 14, width = 1, at = "hand" }, { "symbols", symbols = { "💤", "Zzz" }, count = 4, radius = 3, color = ANESTH, at = "front" } },
					text = "PETITE PIQÛRE…", hitText = "DODO !",
				},
				-- ↓L : il plante la seringue dans le sol et pousse le piston : une flaque d'anesthésiant s'étale sur tout le couloir
				S_down = {
					label = "Flaque anesthésiante", startup = 0.24, active = 0.2, recovery = 0.5,
					damage = 13, hitbox = box(14, 4, 7, -0.5), kbBase = 26, kbGrowth = 48, kbAngle = 60,
					status = { name = "slowed", duration = 3 },
					windup = { Root = { 10, 0, 0, 0, -0.4, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
					strike = { Root = { 20, 0, 0, 0, -0.95, -0.3 }, Waist = { 30, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 22, 0, 0, 0, -1.0, -0.34 }, Waist = { 32, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 26, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 26, 0, -12 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.12, fx = { { "puddle", color = ANESTH, width = 14 }, { "beam", color = ANESTH, length = 14, width = 3, at = "feet" }, { "ring", color = ANESTH, radius = 6, at = "feet" } },
					text = "ÇA S'ÉTALE !", hitText = "ENGOURDI !",
				},
				-- ↑L : il s'injecte une dose de vitamines dans la cuisse et bondit en diagonale, frais comme un gardon
				S_up = {
					label = "Dose de vitamines", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 74, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 10, 0, 0, 0, -0.8, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 30 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 176, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -20 }, LE = { 0, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 180, 0, 22 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -22 }, LE = { 0, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					shake = true, trail = "body", fx = { { "burst", color = ANESTH, size = 2.5, at = "feet" }, { "symbols", symbols = { "💪", "✨" }, count = 4, radius = 3, color = SPARK }, { "ring", color = ANESTH, radius = 4, at = "feet" } },
					text = "EN PLEINE FORME !", hitText = "BONDI !",
				},
				-- L en l'air : pluie de gouttes anesthésiantes secouées au-dessus de l'adversaire
				S_air = {
					label = "Pluie anesthésiante", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 22, kbGrowth = 42, kbAngle = -40,
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.1, color = ANESTH, rain = { count = 4, spread = 6 },
						visual = { shape = "ball", size = 0.9, color = ANESTH, neon = true } },
					status = { name = "slowed", duration = 1.5 },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { 24, 0, 0 }, Waist = { 26, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 60, 0, 0 }, RH = { -20, 0, 10 }, RK = { -30, 0, 0 }, LH = { -20, 0, -10 }, LK = { -30, 0, 0 } },
					follow = { Root = { 28, 0, 0 }, Waist = { 30, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 16, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 64, 0, -54 }, LE = { 60, 0, 0 }, RH = { -24, 0, 10 }, RK = { -34, 0, 0 }, LH = { -24, 0, -10 }, LK = { -34, 0, 0 } },
					shake = true, fx = { { "burst", color = ANESTH, size = 2, at = "hand" } }, text = "SECOUÉ !", hitText = "ENGOURDI !",
				},
				-- Y : anesthésie générale : il fait le tour du couloir en piquant tout le monde à toute vitesse et tout le monde s'écroule en ronflant
				SUPER = {
					label = "Anesthésie générale !", startup = 0.4, active = 0.3, recovery = 0.7, hits = 3,
					damage = 8, hitbox = box(16, 6, 8, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(30, 0),
					status = { name = "asleep", duration = 3 },
					windup = { Root = { 4, -30, 0, 0, -0.2, 0.2 }, Waist = { 6, -34, 0 }, Neck = { 0, 24, 0 }, RS = { 40, 0, 20 }, RE = { 130, 0, 0 }, RW = { 60, 0, 0 }, LS = { 110, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, 30, 0, 0, -0.5, -0.55 }, Waist = { -8, 34, 0 }, Neck = { 0, -22, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 160, 0, -20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.9 } },
					follow = { Root = { -8, -30, 0, 0, -0.5, -0.55 }, Waist = { -8, -34, 0 }, Neck = { 0, 22, 0 }, RS = { 96, 0, 40 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 160, 0, -20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.9 } },
					wobble = true, trail = "prop", windupFx = { "super", { "text", text = "COMPTEZ JUSQU'À 10…", color = ANESTH, at = "above" } },
					fx = { { "beam", color = ANESTH, length = 16, width = 3, at = "hand" }, { "symbols", symbols = { "💤", "Zzz", "💤" }, count = 10, radius = 6, color = ANESTH }, { "screen", color = ANESTH, alpha = 0.25 }, { "shake", amount = 0.3 } },
					text = "PIC PIC PIC !", hitText = "RONFLE !",
				},
				-- →Y : la seringue-fusée : il pointe l'aiguille vers l'adversaire, presse le piston à fond et la seringue part comme une fusée en traînant son produit
				SUPER_side = {
					label = "Seringue-fusée !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 46, kbGrowth = 96, kbAngle = 32,
					projectile = { speed = 100, angle = 0, gravity = 0, lifetime = 0.8, size = 3, color = ANESTH, pierce = true,
						visual = { shape = "cyl", size = 1.2, color = Color3.fromRGB(220, 240, 255), spin = 0, parts = { { "cyl", Vector3.new(0.9, 3.2, 0.9), Vector3.new(0, 0, 0), ANESTH }, { "cyl", Vector3.new(0.2, 2.8, 0.2), Vector3.new(0, -3, 0), STEEL } } } },
					status = { name = "asleep", duration = 2.5 },
					windup = { Root = { 6, -30, 0, 0, -0.25, 0.25 }, Waist = { 8, -34, 0 }, Neck = { 4, 22, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, LW = { -40, 0, 0 } },
					strike = { Root = { -14, 22, 0, 0, -0.34, -0.5 }, Waist = { -16, 26, 0 }, Neck = { -6, -16, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 92, 0, 0 }, LE = { 60, 0, 0 }, LW = { -90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -4, 22, 0, 0, -0.26, -0.3 }, Waist = { -6, 26, 0 }, Neck = { -6, -16, 0 }, RS = { 110, 0, 0 }, RE = { 10, 0, 0 }, RW = { 40, 0, 0 }, LS = { 98, 0, 0 }, LE = { 60, 0, 0 }, LW = { -90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, hideProp = "seringuexl", windupFx = { "super", { "symbols", symbols = { "💉", "🚀" }, count = 6, radius = 3, color = ANESTH } },
					fx = { { "beam", color = ANESTH, length = 16, width = 2.5, at = "hand" }, { "burst", color = ANESTH, size = 3.5, at = "hand" }, { "particles", tex = "smoke", color = ANESTH, dir = "front", at = "hand", time = 0.4, speed = 20, size = 0.8, rate = 80 }, { "shake", amount = 0.4 } },
					text = "DÉCOLLAGE !", hitText = "PIQUÉ À VIF !",
				},
				-- ↑Y : la piqûre de rappel : il bondit en vrille, seringue au ciel, et retombe pour piquer tout le couloir qui part au plafond
				SUPER_up = {
					label = "Piqûre de rappel !", startup = 0.38, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					status = { name = "slowed", duration = 2 },
					windup = { Root = { 12, 0, 0, 0, -0.9, 0.1 }, Waist = { 20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 156, 0, -66 }, LE = { 10, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 720 }, trail = "prop",
					windupFx = { "super", { "text", text = "RAPPEL !", color = ANESTH, at = "above" } },
					fx = { { "pillar", color = ANESTH, height = 22, width = 3, at = "front" }, { "burst", color = SPARK, size = 4, at = "above" }, { "rain", shape = "ball", color = ANESTH, count = 10, radius = 6, size = 0.5 }, { "ring", color = ANESTH, radius = 6, at = "feet" }, { "shake", amount = 0.4 } },
					text = "PIQÛRE DE RAPPEL !", hitText = "AU PLAFOND !",
				},
				-- ↓Y : bombe de gaz : il presse le piston sans aiguille et un nuage violet envahit toute la plateforme : tout le monde pique du nez
				SUPER_down = {
					label = "Nuage d'anesthésiant !", startup = 0.4, active = 0.2, recovery = 0.7,
					damage = 20, hitbox = box(70, 50, 0, 10), kbBase = 10, kbGrowth = 10, kbAngle = 60,
					status = { name = "asleep", duration = 3 },
					windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -20 }, LE = { 100, 0, 0 }, LW = { -40, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 180, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 40, 0, 0 }, LW = { -90, 0, 0 } },
					follow = { Root = { 8, 0, 0, 0, 0.12, 0 }, Waist = { 18, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 184, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 174, 0, -12 }, LE = { 30, 0, 0 }, LW = { -90, 0, 0 } },
					hold = 0.4, windupFx = { "super" },
					fx = { { "screen", color = ANESTH, alpha = 0.35, time = 0.8 }, { "particles", tex = "smoke", color = ANESTH, at = "hand", dir = "all", time = 0.8, rate = 120, speed = 18, size = 2 }, { "symbols", symbols = { "💤", "Zzz", "😴" }, color = ANESTH, count = 12, radius = 9, at = "above" } },
					text = "TOUT LE MONDE DORT !", hitText = "RONFLEMENT !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_neutral" },
				K_side = { P = "P_up", K = "K_up", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_neutral" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

	look = {
		body = { head = SKIN, upper = COAT, lower = SCRUBS, arms = COAT, forearms = COAT, hands = GLOVE, legs = SCRUBS, feet = COAT },
		cubeHead = 1.25,
		parts = {
			-- coiffure impeccable, raie sur le côté
			{ "Cheveux", "Head", "block", Vector3.new(1.32, 0.3, 1.32), Vector3.new(0, 0.6, 0.04), Vector3.zero, HAIR, "SmoothPlastic" },
			{ "Meche", "Head", "wedge", Vector3.new(0.7, 0.3, 0.5), Vector3.new(0.3, 0.68, -0.45), Vector3.new(0, 180, 0), HAIR, "SmoothPlastic" },
			-- lampe frontale
			{ "Bandeau", "Head", "block", Vector3.new(1.34, 0.18, 1.34), Vector3.new(0, 0.32, 0), Vector3.zero, DARK, "Fabric" },
			{ "Lampe", "Head", "cyl", Vector3.new(0.3, 0.5, 0.5), Vector3.new(0, 0.34, -0.76), Vector3.zero, STEEL, "Metal", { axis = "z" } },
			{ "VerreLampe", "Head", "cyl", Vector3.new(0.06, 0.38, 0.38), Vector3.new(0, 0.34, -0.93), Vector3.zero, SPARK, "Neon", { axis = "z", neon = true, light = { SPARK, 8, 1 } } },
			-- visage : yeux rieurs et sourire éclatant
			{ "OeilDroit", "Head", "block", Vector3.new(0.2, 0.12, 0.05), Vector3.new(0.26, 0.06, -0.64), Vector3.zero, DARK },
			{ "OeilGauche", "Head", "block", Vector3.new(0.2, 0.12, 0.05), Vector3.new(-0.26, 0.06, -0.64), Vector3.zero, DARK },
			{ "Sourire", "Head", "block", Vector3.new(0.66, 0.18, 0.05), Vector3.new(0, -0.3, -0.64), Vector3.zero, Color3.fromRGB(255, 255, 255), "Neon", { neon = true } },
			{ "Fossette", "Head", "block", Vector3.new(0.66, 0.05, 0.06), Vector3.new(0, -0.2, -0.645), Vector3.zero, Color3.fromRGB(200, 90, 100) },
			-- masque chirurgical baissé sous le menton
			{ "Masque", "UpperTorso", "block", Vector3.new(0.95, 0.4, 0.12), Vector3.new(0, 0.72, -0.56), Vector3.new(-10, 0, 0), GLOVE, "Fabric" },
			-- blouse : revers, poche à stylos, badge
			{ "Revers", "UpperTorso", "wedge", Vector3.new(0.5, 0.9, 0.08), Vector3.new(0.34, 0.32, -0.54), Vector3.new(0, 0, 180), COAT, "Fabric" },
			{ "ReversG", "UpperTorso", "wedge", Vector3.new(0.5, 0.9, 0.08), Vector3.new(-0.34, 0.32, -0.54), Vector3.new(0, 0, 180), COAT, "Fabric" },
			{ "Poche", "UpperTorso", "block", Vector3.new(0.5, 0.45, 0.06), Vector3.new(-0.52, -0.05, -0.53), Vector3.zero, Color3.fromRGB(225, 230, 236), "Fabric" },
			{ "Stylo", "UpperTorso", "cyl", Vector3.new(0.5, 0.08, 0.08), Vector3.new(-0.6, 0.18, -0.55), Vector3.zero, Color3.fromRGB(220, 40, 60) },
			{ "Badge", "UpperTorso", "block", Vector3.new(0.4, 0.25, 0.05), Vector3.new(0.5, -0.05, -0.53), Vector3.zero, Color3.fromRGB(60, 140, 230) },
			{ "DentBadge", "UpperTorso", "ball", Vector3.new(0.2, 0.22, 0.1), Vector3.new(0.5, -0.05, -0.57), Vector3.zero, Color3.fromRGB(255, 255, 255) },
			-- basques de la blouse et boutons
			{ "Basques", "LowerTorso", "block", Vector3.new(2.06, 0.9, 1.08), Vector3.new(0, -0.45, 0), Vector3.zero, COAT, "Fabric" },
			{ "Bouton", "UpperTorso", "ball", Vector3.new(0.14, 0.14, 0.08), Vector3.new(0, -0.35, -0.53), Vector3.zero, STEEL },
			-- sabots de praticien
			{ "SaboD", "RightFoot", "block", Vector3.new(0.95, 0.4, 1.25), Vector3.new(0, -0.05, -0.15), Vector3.zero, Color3.fromRGB(235, 240, 245) },
			{ "SaboG", "LeftFoot", "block", Vector3.new(0.95, 0.4, 1.25), Vector3.new(0, -0.05, -0.15), Vector3.zero, Color3.fromRGB(235, 240, 245) },
		},
		props = {
			-- l'arme : la fraise géante (manche, bague, tête coudée et roulette qui vrombit)
			{ name = "PropFraise", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(2.1, 0.45, 0.45), Vector3.new(0, -1.0, 0), Vector3.zero, Color3.fromRGB(235, 238, 242), "SmoothPlastic" },
				{ "Bague", "", "cyl", Vector3.new(0.25, 0.55, 0.55), Vector3.new(0, -0.25, 0), Vector3.zero, MINT, "SmoothPlastic" },
				{ "Cordon", "", "cyl", Vector3.new(0.6, 0.2, 0.2), Vector3.new(0, 0.2, 0), Vector3.zero, DARK },
				{ "Tete", "", "block", Vector3.new(0.5, 0.55, 0.75), Vector3.new(0, -2.2, -0.15), Vector3.zero, STEEL, "Metal" },
				{ "Roulette", "", "cyl", Vector3.new(0.9, 0.22, 0.22), Vector3.new(0, -2.25, -0.85), Vector3.zero, Color3.fromRGB(240, 220, 120), "Metal", { axis = "z" } },
				{ "Pointe", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0, -2.25, -1.3), Vector3.zero, SPARK, "Neon", { neon = true } },
			} },
			-- petits instruments, main gauche, le temps d'un coup
			{ name = "PropMiroir", hand = "Left", visible = false, pieces = {
				{ "Tige", "", "cyl", Vector3.new(1.4, 0.14, 0.14), Vector3.new(0, -0.7, 0), Vector3.zero, STEEL, "Metal" },
				{ "Glace", "", "cyl", Vector3.new(0.1, 1.0, 1.0), Vector3.new(0, -1.55, 0), Vector3.zero, Color3.fromRGB(210, 235, 255), "Glass", { axis = "z", reflect = 0.6 } },
			} },
			{ name = "PropFil", hand = "Left", visible = false, pieces = {
				{ "Boite", "", "block", Vector3.new(0.5, 0.5, 0.3), Vector3.new(0, -0.3, 0), Vector3.zero, MINT },
				{ "Fil", "", "cyl", Vector3.new(4.5, 0.08, 0.08), Vector3.new(0, -2.6, 0), Vector3.zero, Color3.fromRGB(250, 250, 250), "Neon", { neon = true } },
			} },
			{ name = "PropSeringue", hand = "Left", visible = false, pieces = {
				{ "Corps", "", "cyl", Vector3.new(1.2, 0.35, 0.35), Vector3.new(0, -0.7, 0), Vector3.zero, Color3.fromRGB(220, 240, 255), "Glass", { transparency = 0.3 } },
				{ "Produit", "", "cyl", Vector3.new(0.8, 0.25, 0.25), Vector3.new(0, -0.75, 0), Vector3.zero, Color3.fromRGB(180, 140, 255), "Neon", { neon = true } },
				{ "Aiguille", "", "cyl", Vector3.new(0.7, 0.06, 0.06), Vector3.new(0, -1.6, 0), Vector3.zero, STEEL, "Metal" },
			} },
			{ name = "PropPince", hand = "Left", visible = false, pieces = {
				{ "Branche1", "", "block", Vector3.new(0.12, 1.6, 0.18), Vector3.new(0.12, -0.8, 0), Vector3.new(0, 0, 6), STEEL, "Metal" },
				{ "Branche2", "", "block", Vector3.new(0.12, 1.6, 0.18), Vector3.new(-0.12, -0.8, 0), Vector3.new(0, 0, -6), STEEL, "Metal" },
				{ "Bec", "", "block", Vector3.new(0.4, 0.4, 0.25), Vector3.new(0, -1.7, 0), Vector3.zero, STEEL, "Metal" },
			} },
			{ name = "PropTabouret", hand = "Left", visible = false, pieces = {
				{ "Assise", "", "cyl", Vector3.new(0.35, 1.6, 1.6), Vector3.new(0, -0.3, 0), Vector3.zero, CHAIR, "Fabric" },
				{ "Pied", "", "cyl", Vector3.new(1.4, 0.2, 0.2), Vector3.new(0, -1.1, 0), Vector3.zero, STEEL, "Metal" },
				{ "Etoile", "", "block", Vector3.new(1.8, 0.15, 0.25), Vector3.new(0, -1.8, 0), Vector3.zero, DARK },
				{ "Roue", "", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0.85, -1.95, 0), Vector3.zero, DARK },
				{ "Roue2", "", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(-0.85, -1.95, 0), Vector3.zero, DARK },
			} },
			{ name = "PropGobelet", hand = "Left", visible = false, pieces = {
				{ "Gobelet", "", "cyl", Vector3.new(0.6, 0.45, 0.45), Vector3.new(0, -0.35, -0.1), Vector3.zero, Color3.fromRGB(255, 255, 255) },
				{ "Eau", "", "cyl", Vector3.new(0.05, 0.38, 0.38), Vector3.new(0, -0.1, -0.1), Vector3.zero, RINSE, "Neon", { neon = true } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de miroir : droit comme un i, il sort le miroir de la main gauche et tape sec sur la pommette
		P_neutral = {
			label = "Coup de miroir dentaire", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 5, hitbox = box(4, 3, 2.6, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 2, 16, 0, 0, -0.05, 0.1 }, Waist = { 0, 14, 0 }, Neck = { 0, -10, 0 }, LS = { 110, 0, -30 }, LE = { 110, 0, 0 }, LW = { 20, 0, 0 }, RS = { 30, 0, 18 }, RE = { 70, 0, 0 } },
			strike = { Root = { -4, -14, 0, 0, -0.1, -0.25 }, Waist = { -4, -18, 0 }, Neck = { 0, 10, 0 }, LS = { 92, 0, 6 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 }, RS = { 25, 0, 22 }, RE = { 80, 0, 0 } },
			follow = { Root = { -5, -18, 0, 0, -0.1, -0.3 }, Waist = { -5, -22, 0 }, Neck = { 0, 12, 0 }, LS = { 88, 0, 18 }, LE = { 10, 0, 0 }, LW = { -25, 0, 0 }, RS = { 25, 0, 22 }, RE = { 80, 0, 0 } },
			prop = "miroir", trail = "leftHand", hitText = "TINK !",
		},
		-- Fraise vrombissante : fraise tenue à deux mains bras tendus, elle vrombit et grignote trois fois
		P_side = {
			label = "Fraise vrombissante", startup = 0.1, active = 0.24, recovery = 0.18, hits = 3,
			damage = 3, hitbox = box(5, 2.5, 3.5, 0.6), kbBase = 16, kbGrowth = 20, kbAngle = 15, selfVelocity = Vector2.new(14, 0),
			windup = { Root = { 0, -10, 0, 0, -0.15, 0.2 }, Waist = { 2, -12, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 70, 0, 0 }, LS = { 55, 0, -5 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, 4, 0, 0, -0.25, -0.35 }, Waist = { -6, 4, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, -6 }, RE = { 8, 0, 0 }, RW = { 85, 0, 0 }, LS = { 88, 0, 18 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -9, 6, 0, 0, -0.27, -0.4 }, Waist = { -7, 6, 0 }, Neck = { -6, 0, 0 }, RS = { 94, 0, -4 }, RE = { 6, 0, 0 }, RW = { 88, 0, 0 }, LS = { 90, 0, 16 }, LE = { 28, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			wobble = true, trail = "prop", fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "front", time = 0.25, rate = 80, speed = 10, size = 0.3 } },
			text = "BZZZZ !", hitText = "GRRRIK !",
		},
		-- Fil dentaire : accroupi, il lance le fil au ras du sol comme un lasso et ramène les chevilles
		P_down = {
			label = "Fil dentaire", startup = 0.1, active = 0.1, recovery = 0.2, pull = true,
			damage = 5, hitbox = box(6.5, 2, 3.8, -2), kbBase = 22, kbGrowth = 18, kbAngle = 70,
			windup = { Root = { -6, 20, 0, 0, -0.6, 0.15 }, Waist = { -10, 18, 0 }, Neck = { 6, -14, 0 }, LS = { 150, 0, -40 }, LE = { 40, 0, 0 }, RS = { 30, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -12, -10, 0, 0, -0.75, -0.1 }, Waist = { -18, -12, 0 }, Neck = { 10, 8, 0 }, LS = { 50, 0, 10 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 } },
			follow = { Root = { -8, -14, 0, 0, -0.7, 0.05 }, Waist = { -14, -16, 0 }, Neck = { 8, 10, 0 }, LS = { 20, 0, -10 }, LE = { 70, 0, 0 }, LW = { -10, 0, 0 }, RS = { 25, 0, 28 }, RE = { 65, 0, 0 } },
			prop = "fil", trail = "leftHand", hitText = "ZIP !",
		},
		-- Lampe aveuglante (anti-air) : il renverse la tête en arrière, la lampe frontale flashe vers le ciel
		P_up = {
			label = "Lampe aveuglante", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 6, hitbox = box(4.5, 5, 0.8, 3.8), kbBase = 26, kbGrowth = 28, kbAngle = 85,
			status = { name = "blinded", duration = 1.2 },
			windup = { Root = { -6, 0, 0, 0, -0.45, 0 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 20, 0, 20 }, RE = { 90, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.15, 0.05 }, Waist = { 18, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 40, 0, 50 }, RE = { 20, 0, 0 }, LS = { 150, 0, -15 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.2, 0.08 }, Waist = { 22, 0, 0 }, Neck = { 46, 0, 0 }, RS = { 45, 0, 55 }, RE = { 20, 0, 0 }, LS = { 160, 0, -20 }, LE = { 25, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			fx = { { "beam", color = SPARK, length = 6, width = 2.5, at = "above", time = 0.2 }, { "screen", color = SPARK, alpha = 0.15, time = 0.2 } },
			text = "AAAH !", hitText = "FLASH !",
		},
		-- Lampe aveuglante (en l'air) : il oriente le miroir sous la lampe et renvoie un éclair devant lui
		P_air = {
			label = "Reflet aveuglant", startup = 0.09, active = 0.12, recovery = 0.16,
			damage = 7, hitbox = box(4.5, 4, 2.5, 0.5), kbBase = 20, kbGrowth = 32, kbAngle = 30,
			windup = { Root = { -8, 10, 0 }, Waist = { -6, 12, 0 }, Neck = { -10, 0, 0 }, LS = { 150, 0, -10 }, LE = { 80, 0, 0 }, LW = { 30, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { 4, -8, 0 }, Waist = { 2, -10, 0 }, Neck = { 6, 0, 0 }, LS = { 95, 0, 5 }, LE = { 5, 0, 0 }, LW = { -20, 0, 0 }, RS = { 40, 0, 50 }, RE = { 50, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { 6, -10, 0 }, Waist = { 3, -12, 0 }, Neck = { 8, 0, 0 }, LS = { 90, 0, 12 }, LE = { 8, 0, 0 }, LW = { -25, 0, 0 }, RS = { 38, 0, 55 }, RE = { 50, 0, 0 }, RH = { 35, 0, 0 }, RK = { -55, 0, 0 }, LH = { 55, 0, 0 }, LK = { -85, 0, 0 } },
			prop = "miroir", fx = { { "burst", color = SPARK, size = 3, at = "lhand" } }, hitText = "ÉBLOUI !",
		},
		-- Piqûre éclair (dash puis P) : il fonce penché, seringue en avant dans la main gauche
		P_dash = {
			label = "Piqûre éclair", startup = 0.08, active = 0.14, recovery = 0.24,
			damage = 8, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 26, kbGrowth = 45, kbAngle = 25, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -6, 18, 0, 0, -0.2, 0.15 }, Waist = { -4, 14, 0 }, LS = { 70, 0, -40 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, RS = { -20, 0, 25 }, RE = { 40, 0, 0 } },
			strike = { Root = { -18, -12, 0, 0, -0.35, -0.3 }, Waist = { -8, -14, 0 }, Neck = { 12, 10, 0 }, LS = { 95, 0, 8 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { -40, 0, 30 }, RE = { 30, 0, 0 } },
			follow = { Root = { -20, -15, 0, 0, -0.38, -0.35 }, Waist = { -9, -16, 0 }, Neck = { 14, 12, 0 }, LS = { 92, 0, 12 }, LE = { 4, 0, 0 }, LW = { -10, 0, 0 }, RS = { -45, 0, 32 }, RE = { 30, 0, 0 } },
			prop = "seringue", fx = { "dust" }, text = "PIQÛRE !", hitText = "AÏE !",
		},

		-- Suites d'enchaînement P (voir LINKS)
		-- P P : revers de miroir, le poignet se retourne et frappe dans l'autre sens
		P_combo2 = {
			label = "Revers de miroir", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(5, 3.5, 2.8, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { -2, -20, 0, 0, -0.1, -0.2 }, Waist = { -3, -22, 0 }, LS = { 80, 0, 35 }, LE = { 90, 0, 0 }, LW = { -20, 0, 0 }, RS = { 25, 0, 22 }, RE = { 80, 0, 0 } },
			strike = { Root = { -4, 14, 0, 0, -0.12, -0.3 }, Waist = { -4, 18, 0 }, Neck = { 0, -8, 0 }, LS = { 92, 0, -35 }, LE = { 8, 0, 0 }, LW = { 10, 0, 0 }, RS = { 30, 0, 18 }, RE = { 75, 0, 0 } },
			follow = { Root = { -4, 20, 0, 0, -0.12, -0.32 }, Waist = { -4, 24, 0 }, Neck = { 0, -10, 0 }, LS = { 88, 0, -55 }, LE = { 12, 0, 0 }, LW = { 20, 0, 0 }, RS = { 30, 0, 18 }, RE = { 75, 0, 0 } },
			prop = "miroir", trail = "leftHand", hitText = "TINK TINK !",
		},
		-- P P P : coup de fraise piqué de haut en bas, comme sur une molaire récalcitrante
		P_combo3 = {
			label = "Fraisage de molaire", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(4.5, 4, 2.8, 0.6), kbBase = 30, kbGrowth = 58, kbAngle = 40,
			windup = { Root = { 6, -12, 0, 0, 0, 0.2 }, Waist = { 10, -14, 0 }, Neck = { 10, 0, 0 }, RS = { 175, 0, 10 }, RE = { 70, 0, 0 }, RW = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 110, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, -0.4, -0.35 }, Waist = { -22, 12, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 0 }, RE = { 10, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -45 }, LE = { 110, 0, 0 } },
			follow = { Root = { -14, 12, 0, 0, -0.45, -0.4 }, Waist = { -26, 14, 0 }, Neck = { -8, 0, 0 }, RS = { 62, 0, 0 }, RE = { 10, 0, 0 }, RW = { 65, 0, 0 }, LS = { 35, 0, -48 }, LE = { 110, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.15, rate = 120, speed = 12, size = 0.3 } },
			text = "ON NE BOUGE PLUS !", hitText = "CRRRAC !",
		},
		-- P puis K : coup de coude ganté, bras gauche replié, le buste pivote
		PK_combo = {
			label = "Coude ganté", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 7, hitbox = box(4.5, 3.5, 2.5, 0.6), kbBase = 24, kbGrowth = 36, kbAngle = 30,
			windup = { Root = { 2, 28, 0, 0, -0.15, 0.15 }, Waist = { 2, 26, 0 }, LS = { 50, 0, -70 }, LE = { 140, 0, 0 }, RS = { 30, 0, 20 }, RE = { 80, 0, 0 } },
			strike = { Root = { -8, -22, 0, 0, -0.25, -0.35 }, Waist = { -8, -28, 0 }, Neck = { 0, 12, 0 }, LS = { 92, 0, 12 }, LE = { 145, 0, 0 }, RS = { 20, 0, 25 }, RE = { 85, 0, 0 } },
			follow = { Root = { -9, -28, 0, 0, -0.27, -0.4 }, Waist = { -9, -32, 0 }, Neck = { 0, 14, 0 }, LS = { 94, 0, 20 }, LE = { 145, 0, 0 }, RS = { 18, 0, 26 }, RE = { 85, 0, 0 } },
			trail = "leftHand", hitText = "CLAC !",
		},
		-- ↓P P : deuxième passe de fil, il tire d'un coup sec vers le haut (fait décoller)
		P_down2 = {
			label = "Fil tiré", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 7, hitbox = box(5, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 40, kbAngle = 82,
			windup = { Root = { -10, -10, 0, 0, -0.75, 0.05 }, Waist = { -16, -10, 0 }, LS = { 40, 0, -10 }, LE = { 20, 0, 0 }, RS = { 40, 0, 10 }, RE = { 40, 0, 0 } },
			strike = { Root = { 6, 6, 0, 0, 0.1, 0.15 }, Waist = { 12, 6, 0 }, Neck = { 20, 0, 0 }, LS = { 170, 0, -10 }, LE = { 30, 0, 0 }, RS = { 150, 0, 15 }, RE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 8, 8, 0, 0, 0.12, 0.2 }, Waist = { 15, 8, 0 }, Neck = { 24, 0, 0 }, LS = { 178, 0, -15 }, LE = { 25, 0, 0 }, RS = { 160, 0, 18 }, RE = { 35, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			prop = "fil", trail = "bothHands", hitText = "HOP-LÀ !",
		},
		-- → P P : Polissage, la fraise balaie de droite à gauche en vrombissant, deux passes pour faire briller
		P_side2 = {
			label = "Polissage", startup = 0.07, active = 0.14, recovery = 0.16, hits = 2,
			damage = 3, hitbox = box(5.5, 3.5, 3, 0.6), kbBase = 18, kbGrowth = 24, kbAngle = 20,
			windup = { Root = { -6, -28, 0, 0, -0.2, -0.1 }, Waist = { -6, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 85, 0, 40 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 110, 0, 0 } },
			strike = { Root = { -8, 22, 0, 0, -0.25, -0.35 }, Waist = { -8, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, -30 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 110, 0, 0 } },
			follow = { Root = { -8, 32, 0, 0, -0.25, -0.38 }, Waist = { -8, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 90, 0, -45 }, RE = { 8, 0, 0 }, RW = { -10, 0, 0 }, LS = { 38, 0, -42 }, LE = { 110, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.15, rate = 80, speed = 8, size = 0.3 } }, text = "ET ON POLIT !", hitText = "BZZ-BZZ !",
		},
		-- → P P P : Plombage express, il tourne sur lui-même et tamponne la fraise sur la molaire : plombage posé, au suivant !
		P_side3 = {
			label = "Plombage express", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4, 3, 0.6), kbBase = 34, kbGrowth = 76, kbAngle = 42,
			windup = { Root = { 4, -40, 0, 0, -0.2, 0.1 }, Waist = { 4, -30, 0 }, Neck = { 0, 24, 0 }, RS = { 60, 0, 50 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 100, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, -0.3, -0.4 }, Waist = { -14, 12, 0 }, Neck = { -6, 0, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -14, 12, 0, 0, -0.32, -0.45 }, Waist = { -16, 14, 0 }, Neck = { -8, 0, 0 }, RS = { 98, 0, -6 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 28, 0, -52 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			spin = { axis = "y", degrees = 360 }, shake = true, trail = "prop", fx = { { "burst", color = STEEL, size = 3, at = "front" }, { "symbols", symbols = { "🦷", "✨" }, color = SPARK, count = 4, radius = 2.5, at = "front" } },
			text = "PLOMBAGE !", hitText = "CLONK !",
		},
		-- P P P K : Tabouret tournant, il attrape son tabouret à roulettes et tourne sur lui-même en le tenant à bout de bras
		PPPK_combo = {
			label = "Tabouret tournant", startup = 0.1, active = 0.16, recovery = 0.32,
			damage = 12, hitbox = box(6.5, 4, 2.5, 0.5), kbBase = 34, kbGrowth = 80, kbAngle = 40,
			windup = { Root = { 0, 40, 0, 0, -0.3, 0 }, Waist = { 0, 30, 0 }, Neck = { 0, -24, 0 }, LS = { 40, 0, -70 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RS = { 40, 0, 40 }, RE = { 70, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.25, -0.2 }, Waist = { -6, 0, 0 }, Neck = { -6, 0, 0 }, LS = { 92, 0, -85 }, LE = { 0, 0, 0 }, LW = { 40, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.25, -0.2 }, Waist = { -6, 0, 0 }, Neck = { -8, 0, 0 }, LS = { 92, 0, -88 }, LE = { 0, 0, 0 }, LW = { 40, 0, 0 }, RS = { 62, 0, 72 }, RE = { 20, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, prop = "tabouret", trail = "leftHand", fx = { "dust", { "ring", color = CHAIR, radius = 5, at = "root" } }, text = "SUIVANT !", hitText = "BLONG !",
		},
		-- ↓ P P P : Fil scie, l'adversaire est en l'air, il tend le fil à deux mains au-dessus de lui et le scie trois fois d'avant en arrière
		P_down3 = {
			label = "Fil scie", startup = 0.08, active = 0.2, recovery = 0.3, hits = 3,
			damage = 4, hitbox = box(5, 5.5, 2.5, 1.5), kbBase = 32, kbGrowth = 70, kbAngle = 55,
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 24, 0, 0 }, LS = { 150, 0, -10 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RS = { 150, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 } },
			strike = { Root = { -4, 18, 0, 0, -0.15, -0.2 }, Waist = { -4, 20, 0 }, Neck = { 22, -10, 0 }, LS = { 130, 0, -40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, RS = { 130, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 } },
			follow = { Root = { -4, -18, 0, 0, -0.15, -0.2 }, Waist = { -4, -20, 0 }, Neck = { 22, 10, 0 }, LS = { 130, 0, -10 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RS = { 130, 0, 40 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 } },
			wobble = true, prop = "fil", trail = "bothHands", fx = { { "symbols", symbols = { "〰️", "✂️" }, color = SPARK, count = 3, radius = 2, at = "above" } }, text = "ON SCIE !", hitText = "ZIP ZIP ZIP !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Pédale de fauteuil : genou très haut, puis il écrase devant lui comme sur la pédale du fauteuil
		K_neutral = {
			label = "Pédale de fauteuil", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(4.5, 3, 2.8, -1), kbBase = 30, kbGrowth = 68, kbAngle = 35,
			windup = { Root = { 6, -6, 0, 0, 0, 0.15 }, Waist = { 8, -6, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 35 }, RE = { 70, 0, 0 }, LS = { 40, 0, -35 }, LE = { 70, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { -8, 4, 0, 0, -0.2, -0.2 }, Waist = { -10, 4, 0 }, Neck = { -15, 0, 0 }, RS = { 30, 0, 45 }, RE = { 50, 0, 0 }, LS = { 30, 0, -45 }, LE = { 50, 0, 0 }, RH = { 55, 0, 0 }, RK = { -15, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -9, 6, 0, 0, -0.22, -0.25 }, Waist = { -11, 5, 0 }, Neck = { -16, 0, 0 }, RS = { 28, 0, 48 }, RE = { 50, 0, 0 }, LS = { 28, 0, -48 }, LE = { 50, 0, 0 }, RH = { 50, 0, 0 }, RK = { -12, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { { "ring", color = STEEL, radius = 3, at = "feet" } }, hitText = "PSCHHT !",
		},
		-- Genou stérile : mains gantées levées en l'air (surtout ne rien toucher !), il monte le genou en avançant
		K_side = {
			label = "Genou stérile", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(4.5, 3, 2.6, 0.4), kbBase = 32, kbGrowth = 78, kbAngle = 35, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.25 }, Waist = { 6, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 20, 0, 50 }, RE = { 140, 0, 0 }, LS = { 20, 0, -50 }, LE = { 140, 0, 0 }, RH = { -20, 0, 0 }, RK = { -50, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, 0.05, -0.35 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 30, 0, 55 }, RE = { 150, 0, 0 }, LS = { 30, 0, -55 }, LE = { 150, 0, 0 }, RH = { 112, 0, 0 }, RK = { -118, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, 0.08, -0.42 }, Waist = { -12, 0, 0 }, Neck = { 2, 0, 0 }, RS = { 32, 0, 56 }, RE = { 150, 0, 0 }, LS = { 32, 0, -56 }, LE = { 150, 0, 0 }, RH = { 118, 0, 0 }, RK = { -125, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightLeg", text = "STÉRILE !", hitText = "GNOC !",
		},
		-- Fauteuil balayé : accroupi, il balaie le sol avec son tabouret à roulettes tenu de la main gauche
		K_down = {
			label = "Fauteuil balayé", startup = 0.17, active = 0.14, recovery = 0.32,
			damage = 11, hitbox = box(7, 2.2, 2.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 70,
			windup = { Root = { -6, 40, 0, 0, -0.7, 0.1 }, Waist = { -14, 30, 0 }, Neck = { 0, -30, 0 }, LS = { 40, 0, -80 }, LE = { 20, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 } },
			strike = { Root = { -10, -20, 0, 0, -0.85, -0.1 }, Waist = { -18, -25, 0 }, Neck = { 0, 20, 0 }, LS = { 50, 0, 20 }, LE = { 10, 0, 0 }, LW = { 40, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 } },
			follow = { Root = { -10, -32, 0, 0, -0.85, -0.12 }, Waist = { -18, -35, 0 }, Neck = { 0, 26, 0 }, LS = { 45, 0, 40 }, LE = { 15, 0, 0 }, LW = { 40, 0, 0 }, RS = { 30, 0, 42 }, RE = { 60, 0, 0 } },
			prop = "tabouret", trail = "leftHand", fx = { "dust" }, hitText = "ROULEZ !",
		},
		-- « Rincez ! » : il recule d'un pas, renverse le gobelet et lance un grand coup de pied montant
		K_up = {
			label = "« Rincez ! »", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(4.5, 5, 1.8, 3), kbBase = 32, kbGrowth = 70, kbAngle = 82, selfVelocity = Vector2.new(-22, 0),
			windup = { Root = { 8, 0, 0, 0, -0.2, 0.3 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, LS = { 100, 0, -20 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -40, 0, 0 } },
			strike = { Root = { 24, 0, 0, 0, -0.05, 0.4 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, LS = { 120, 0, -30 }, LE = { 20, 0, 0 }, LW = { 70, 0, 0 }, RS = { -20, 0, 50 }, RE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 28, 0, 0, 0, -0.05, 0.5 }, Waist = { 14, 0, 0 }, Neck = { -12, 0, 0 }, LS = { 125, 0, -32 }, LE = { 20, 0, 0 }, LW = { 80, 0, 0 }, RS = { -25, 0, 52 }, RE = { 20, 0, 0 }, RH = { 158, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			prop = "gobelet", trail = "rightFoot", fx = { { "particles", tex = "smoke", color = RINSE, at = "lhand", dir = "up", time = 0.25, rate = 70, speed = 10, size = 0.5 } },
			text = "RINCEZ !", hitText = "SPLATCH !",
		},
		-- Coup de fauteuil (saut K) : en l'air, il abat le tabouret à roulettes tenu à bout de bras gauche
		K_air = {
			label = "Coup de fauteuil", startup = 0.17, active = 0.14, recovery = 0.26,
			damage = 12, hitbox = box(5, 4, 2.6, -0.5), kbBase = 30, kbGrowth = 68, kbAngle = 35,
			windup = { Root = { 10, 20, 0 }, Waist = { 10, 18, 0 }, Neck = { 0, -10, 0 }, LS = { 185, 0, -20 }, LE = { 30, 0, 0 }, RS = { 60, 0, 45 }, RE = { 60, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -14, -10, 0 }, Waist = { -20, -12, 0 }, Neck = { 8, 6, 0 }, LS = { 70, 0, 10 }, LE = { 5, 0, 0 }, LW = { 30, 0, 0 }, RS = { 40, 0, 55 }, RE = { 40, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -18, -12, 0 }, Waist = { -24, -14, 0 }, Neck = { 10, 6, 0 }, LS = { 50, 0, 14 }, LE = { 5, 0, 0 }, LW = { 30, 0, 0 }, RS = { 38, 0, 58 }, RE = { 40, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 64, 0, 0 }, LK = { -105, 0, 0 } },
			prop = "tabouret", trail = "leftHand", hitText = "BLONG !",
		},
		-- Glissade sur roulettes (dash puis K) : il file assis dans le vide, les deux sabots en avant
		K_dash = {
			label = "Glissade sur roulettes", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 62, kbAngle = 40, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -6, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -1.2, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 60 }, RE = { 20, 0, 0 }, LS = { 20, 0, -60 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { 75, 0, 0 }, LK = { -10, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 34, 0, 0, 0, -1.25, 0 }, Waist = { -22, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 15, 0, 65 }, RE = { 20, 0, 0 }, LS = { 15, 0, -65 }, LE = { 20, 0, 0 }, RH = { 84, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { 80, 0, 0 }, LK = { -8, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", fx = { "dust" }, hitText = "VROUM !",
		},

		-- Suites d'enchaînement K
		-- K K : talon de praticien, il pivote et frappe du talon du sabot
		K_combo2 = {
			label = "Talon de sabot", startup = 0.1, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(5, 3.5, 3, 0.3), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 4, -40, 0, 0, -0.15, 0.1 }, Waist = { 4, -24, 0 }, Neck = { 0, 30, 0 }, RS = { 30, 0, 50 }, RE = { 90, 0, 0 }, LS = { 30, 0, -50 }, LE = { 90, 0, 0 }, RH = { 60, 0, 30 }, RK = { -100, 0, 0 } },
			strike = { Root = { 12, 30, 0, 0, -0.1, 0 }, Waist = { 8, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 30, 0, 70 }, RE = { 40, 0, 0 }, LS = { 40, 0, -60 }, LE = { 60, 0, 0 }, RH = { 88, 0, 40 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 14, 40, 0, 0, -0.1, 0 }, Waist = { 10, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 28, 0, 72 }, RE = { 40, 0, 0 }, LS = { 42, 0, -62 }, LE = { 60, 0, 0 }, RH = { 84, 0, 30 }, RK = { -6, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", hitText = "CLOC !",
		},
		-- K K K : grand coup de pied retourné, il tourne sur lui-même blouse au vent
		K_combo3 = {
			label = "Ordonnance retournée", startup = 0.12, active = 0.14, recovery = 0.34,
			damage = 13, hitbox = box(5.5, 3.5, 2.8, 0.6), kbBase = 34, kbGrowth = 84, kbAngle = 38,
			windup = { Root = { 4, -60, 0, 0, -0.25, 0.1 }, Waist = { 4, -30, 0 }, Neck = { 0, 40, 0 }, RS = { 50, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -100, 0, 0 } },
			strike = { Root = { 22, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, 80 }, RE = { 10, 0, 0 }, LS = { 50, 0, -80 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 25, 0, 0, 0, -0.1, 0 }, Waist = { 7, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 35, 0, 85 }, RE = { 10, 0, 0 }, LS = { 45, 0, -85 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", text = "SUIVANT !", hitText = "VLAN !",
		},
		-- K puis P : coup de fraise remontant, de la hanche vers le menton
		KP_combo = {
			label = "Fraise remontante", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 8, hitbox = box(4.5, 4.5, 2.5, 1.5), kbBase = 28, kbGrowth = 42, kbAngle = 70,
			windup = { Root = { -6, -16, 0, 0, -0.45, 0.1 }, Waist = { -14, -16, 0 }, RS = { -20, 0, 25 }, RE = { 50, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 110, 0, 0 } },
			strike = { Root = { 6, 12, 0, 0, 0, -0.25 }, Waist = { 12, 16, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 8 }, RE = { 20, 0, 0 }, RW = { 70, 0, 0 }, LS = { 10, 0, -40 }, LE = { 110, 0, 0 } },
			follow = { Root = { 8, 15, 0, 0, 0.05, -0.3 }, Waist = { 15, 20, 0 }, Neck = { 16, 0, 0 }, RS = { 165, 0, 4 }, RE = { 15, 0, 0 }, RW = { 70, 0, 0 }, LS = { 5, 0, -42 }, LE = { 110, 0, 0 } },
			trail = "prop", hitText = "BZZIP !",
		},
		-- → K K : Deuxième genou stérile, l'autre genou monte dans la foulée, mains toujours en l'air (surtout ne rien toucher !)
		K_side2 = {
			label = "Deuxième genou stérile", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 24, kbGrowth = 36, kbAngle = 40, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 30, 0, 55 }, RE = { 150, 0, 0 }, LS = { 30, 0, -55 }, LE = { 150, 0, 0 }, LH = { -20, 0, 0 }, LK = { -50, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, 0.05, -0.35 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 32, 0, 56 }, RE = { 150, 0, 0 }, LS = { 32, 0, -56 }, LE = { 150, 0, 0 }, LH = { 112, 0, 0 }, LK = { -118, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, 0.08, -0.42 }, Waist = { -12, 0, 0 }, Neck = { 2, 0, 0 }, RS = { 34, 0, 58 }, RE = { 150, 0, 0 }, LS = { 34, 0, -58 }, LE = { 150, 0, 0 }, LH = { 118, 0, 0 }, LK = { -125, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "leftFoot", text = "TOUJOURS STÉRILE !", hitText = "GNOC GNOC !",
		},
		-- → K K K : Coup de lampe, il pique du nez et donne un grand coup de lampe frontale : flash et bosse
		K_side3 = {
			label = "Coup de lampe", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 4, 2.8, 0.8), kbBase = 34, kbGrowth = 80, kbAngle = 38,
			status = { name = "blinded", duration = 1 },
			windup = { Root = { 10, 0, 0, 0, -0.15, 0.2 }, Waist = { 14, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 130, 0, 0 }, LS = { 40, 0, -50 }, LE = { 130, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, -0.35, -0.4 }, Waist = { -26, 0, 0 }, Neck = { 42, 0, 0 }, RS = { -20, 0, 50 }, RE = { 40, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -24, 0, 0, 0, -0.38, -0.45 }, Waist = { -28, 0, 0 }, Neck = { 46, 0, 0 }, RS = { -25, 0, 52 }, RE = { 40, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "head", fx = { { "beam", color = SPARK, length = 6, width = 2, at = "head", time = 0.2 }, { "screen", color = SPARK, alpha = 0.2, time = 0.15 }, { "burst", color = SPARK, size = 3, at = "head" } },
			text = "REGARDEZ LA LUMIÈRE !", hitText = "FLASH-BONK !",
		},
		-- ↓ K K : Roulettes folles, il saute sur le tabouret à roulettes et tourne dessus en balayant tout, jambes tendues
		K_downK = {
			label = "Roulettes folles", startup = 0.08, active = 0.22, recovery = 0.26, hits = 2,
			damage = 5, hitbox = box(6, 3.5, 2.5, -0.8), kbBase = 24, kbGrowth = 40, kbAngle = 50, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { -6, 0, 0, 0, -0.8, 0 }, Waist = { -8, 0, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 } },
			strike = { Root = { 12, 0, 0, 0, -0.95, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 }, RH = { 85, 0, 10 }, RK = { -10, 0, 0 }, RA = { 15, 0, 0 }, LH = { 85, 0, -10 }, LK = { -10, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -0.95, 0 }, Waist = { 0, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 92, 0, 88 }, RE = { 0, 0, 0 }, LS = { 92, 0, -88 }, LE = { 0, 0, 0 }, RH = { 88, 0, 12 }, RK = { -8, 0, 0 }, RA = { 15, 0, 0 }, LH = { 88, 0, -12 }, LK = { -8, 0, 0 }, LA = { 15, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "bothFeet", fx = { "dust", { "symbols", symbols = { "🪑", "💨" }, color = CHAIR, count = 3, radius = 2.5, at = "feet" } }, text = "ROULEZ JEUNESSE !", hitText = "ROULETTE !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : Pince plongeante, la pince fond sur l'adversaire, buste penché en avant
		P_air_side = {
			label = "Pince plongeante", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(5, 3, 3, 0), kbBase = 22, kbGrowth = 38, kbAngle = 20,
			windup = { Root = { 10, 20, 0 }, Waist = { 10, 16, 0 }, Neck = { -6, -10, 0 }, LS = { 140, 0, -50 }, LE = { 80, 0, 0 }, RS = { 50, 0, 40 }, RE = { 60, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -16, -10, 0 }, Waist = { -14, -12, 0 }, Neck = { 12, 8, 0 }, LS = { 85, 0, 8 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 50 }, RE = { 40, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -20, -12, 0 }, Waist = { -16, -14, 0 }, Neck = { 14, 10, 0 }, LS = { 80, 0, 14 }, LE = { 4, 0, 0 }, LW = { -15, 0, 0 }, RS = { 15, 0, 52 }, RE = { 40, 0, 0 }, RH = { 5, 0, 0 }, RK = { -35, 0, 0 }, LH = { 64, 0, 0 }, LK = { -55, 0, 0 } },
			prop = "pince", trail = "leftHand", hitText = "CROC !",
		},
		-- ↑ P en l'air : Fraise au plafond, la fraise tendue au-dessus de la tête qui vrombit deux fois
		P_air_up = {
			label = "Fraise au plafond", startup = 0.09, active = 0.16, recovery = 0.18, hits = 2,
			damage = 4, hitbox = box(4.5, 4.5, 0.6, 3.5), kbBase = 24, kbGrowth = 40, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 30 }, RE = { 90, 0, 0 }, RW = { 40, 0, 0 }, LS = { 40, 0, -40 }, LE = { 100, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 8 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, RH = { -5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 182, 0, 4 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 25, 0, -52 }, LE = { 60, 0, 0 }, RH = { -8, 0, 0 }, RK = { -25, 0, 0 }, LH = { 18, 0, 0 }, LK = { -48, 0, 0 } },
			wobble = true, trail = "prop", text = "BZZ !", hitText = "GRIK !",
		},
		-- ↓ P en l'air : Coup de roulette de chaise, il abat la roulette du tabouret droit vers le bas (smash)
		P_air_down = {
			label = "Coup de roulette", startup = 0.15, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(4, 4, 0.8, -2.2), kbBase = 24, kbGrowth = 52, kbAngle = -78,
			windup = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, LS = { 190, 0, 5 }, LE = { 35, 0, 0 }, RS = { 150, 0, 25 }, RE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -18, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 10, 0, 0 }, LS = { 50, 0, 5 }, LE = { 0, 0, 0 }, RS = { 60, 0, 30 }, RE = { 40, 0, 0 }, RH = { 15, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 12, 0, 0 }, LS = { 30, 0, 5 }, LE = { 0, 0, 0 }, RS = { 50, 0, 32 }, RE = { 40, 0, 0 }, RH = { 10, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			prop = "tabouret", trail = "leftHand", text = "ROULETTE !", hitText = "KLONK !",
		},
		-- → K en l'air : Talonnette d'assistant, jambe droite détendue sur le côté, blouse qui flotte
		K_air_side = {
			label = "Talonnette d'assistant", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -10, 25, 0 }, Waist = { -10, 12, 0 }, RS = { 30, 0, 50 }, RE = { 120, 0, 0 }, LS = { 30, 0, -50 }, LE = { 120, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 25, 30, 0 }, Waist = { 8, 6, 0 }, Neck = { -14, 0, 0 }, RS = { 20, 0, 60 }, RE = { 130, 0, 0 }, LS = { 20, 0, -60 }, LE = { 130, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 28, 32, 0 }, Waist = { 9, 6, 0 }, Neck = { -16, 0, 0 }, RS = { 18, 0, 62 }, RE = { 130, 0, 0 }, LS = { 18, 0, -62 }, LE = { 130, 0, 0 }, RH = { 72, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 16, 0, 0 }, LK = { -98, 0, 0 } },
			trail = "rightFoot", hitText = "TAC !",
		},
		-- ↑ K en l'air : Salto du praticien, salto arrière, les sabots passent au-dessus de la tête
		K_air_up = {
			label = "Salto du praticien", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -18, 0, 0 }, RS = { 30, 0, 40 }, RE = { 110, 0, 0 }, LS = { 30, 0, -40 }, LE = { 110, 0, 0 }, RH = { 70, 0, 0 }, RK = { -120, 0, 0 }, LH = { 95, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -30, 0, 55 }, RE = { 30, 0, 0 }, LS = { -30, 0, -55 }, LE = { 30, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 50, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -35, 0, 60 }, RE = { 30, 0, 0 }, LS = { -35, 0, -60 }, LE = { 30, 0, 0 }, RH = { 110, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "HOP !",
		},
		-- ↓ K en l'air : Pédale écrasée, il tombe les deux sabots joints vers le sol (smash)
		K_air_down = {
			label = "Pédale écrasée", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 40 }, RE = { 130, 0, 0 }, LS = { 30, 0, -40 }, LE = { 130, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 2, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 40, 0, 60 }, RE = { 140, 0, 0 }, LS = { 40, 0, -60 }, LE = { 140, 0, 0 }, RH = { -2, 0, 3 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -3 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 2, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 42, 0, 62 }, RE = { 140, 0, 0 }, LS = { 42, 0, -62 }, LE = { 140, 0, 0 }, RH = { -2, 0, 5 }, RK = { -4, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -5 }, LK = { -4, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "PSCHHHT !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Bulle de gaz hilarant : il ouvre la bonbonne et souffle une grosse bulle rose qui fonce éclater au nez de l'adversaire (fou rire)
		S_neutral = {
			label = "Bulle de gaz hilarant", kind = "projectile", startup = 0.2, active = 0, recovery = 0.42,
			damage = 12, kbBase = 16, kbGrowth = 22, kbAngle = 45,
			projectile = { speed = 46, angle = 0, gravity = 0, lifetime = 0.6, size = 3.5, color = GAS,
				visual = { shape = "ball", size = 3.2, color = GAS, transparency = 0.45, spin = 2, text = "HA" } },
			status = { name = "laughing", duration = 3 },
			windup = { Root = { 6, 12, 0, 0, -0.1, 0.15 }, Waist = { 8, 10, 0 }, Neck = { 14, -10, 0 }, LS = { 70, 0, -10 }, LE = { 120, 0, 0 }, LW = { 30, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -8, -6, 0, 0, -0.2, -0.25 }, Waist = { -8, -8, 0 }, Neck = { -6, 0, 0 }, LS = { 95, 0, 8 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -10, -8, 0, 0, -0.22, -0.3 }, Waist = { -10, -10, 0 }, Neck = { -8, 0, 0 }, LS = { 100, 0, 12 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.1, windupFx = { { "particles", tex = "smoke", color = GAS, at = "lhand", dir = "front", time = 0.2, rate = 50, speed = 5, size = 0.8 } },
			fx = { { "burst", color = GAS, size = 3, at = "lhand" }, { "symbols", symbols = { "HA", "HI", "HO" }, color = GAS, count = 5, radius = 3, at = "front" } },
			text = "PSSSHH…", hitText = "HAHAHA !",
		},
		-- Fraise perforante : fraise à deux mains, il fonce d'un bout à l'autre du couloir et la roulette géante grignote quatre fois tout ce qui est sur son passage
		S_side = {
			label = "Fraise perforante", startup = 0.2, active = 0.3, recovery = 0.45, hits = 4,
			damage = 4, hitbox = box(14, 6, 7, 1), kbBase = 32, kbGrowth = 70, kbAngle = 30, selfVelocity = Vector2.new(60, 0),
			windup = { Root = { 6, -16, 0, 0, -0.3, 0.35 }, Waist = { 8, -18, 0 }, Neck = { 0, 10, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, RW = { 80, 0, 0 }, LS = { 50, 0, 10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.4, -0.45 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 92, 0, -4 }, RE = { 0, 0, 0 }, RW = { 88, 0, 0 }, LS = { 86, 0, 20 }, LE = { 18, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			follow = { Root = { -22, 0, 0, 0, -0.42, -0.5 }, Waist = { -14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 95, 0, -4 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 88, 0, 18 }, LE = { 16, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			shake = true, wobble = true, trail = "prop",
			windupFx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.2, rate = 60, speed = 6, size = 0.3 } },
			fx = { "dust", { "particles", tex = "spark", color = SPARK, at = "hand", dir = "front", time = 0.3, rate = 120, speed = 16, size = 0.35 }, { "beam", color = SPARK, length = 14, width = 0.8, at = "hand" } },
			text = "BZZZZZZ !", hitText = "PERFORÉ !",
		},
		-- Grand rinçage : il gargarise le gobelet entier et crache une vague de bain de bouche qui balaie tout le couloir au ras du sol (ça glisse)
		S_down = {
			label = "Grand rinçage", startup = 0.24, active = 0.2, recovery = 0.5,
			damage = 13, hitbox = box(14, 5, 7, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 25,
			status = { name = "slippery", duration = 2.5 },
			windup = { Root = { 8, 0, 0, 0, -0.05, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, LS = { 110, 0, -10 }, LE = { 120, 0, 0 }, LW = { -40, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.4, -0.2 }, Waist = { -26, 0, 0 }, Neck = { -22, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -18, 0, 0, 0, -0.42, -0.25 }, Waist = { -28, 0, 0 }, Neck = { -26, 0, 0 }, LS = { 34, 0, -42 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 }, RS = { 18, 0, 42 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.1, prop = "gobelet", shake = true,
			fx = { { "puddle", color = RINSE, width = 16 }, { "beam", color = RINSE, length = 14, width = 1.6, at = "head" }, { "toss", shape = "ball", color = RINSE, size = 0.5, count = 6, speed = 20, lift = 10 } },
			text = "GLOUGLOU… PTOUUU !", hitText = "ÇA GLISSE !",
		},
		-- Fauteuil éjectable (remontée) : le tabouret jaillit sous lui comme un siège éjectable et il file en diagonale, fraise pointée devant, blouse au vent
		S_up = {
			label = "Fauteuil éjectable", startup = 0.15, active = 0.3, recovery = 0.42,
			damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 80, selfVelocity = Vector2.new(44, 84),
			windup = { Root = { 4, 0, 0, 0, -0.85, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 25 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 }, LS = { -30, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -42, 0, 0, 0, 0.3, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 165, 0, 8 }, RE = { 0, 0, 0 }, RW = { 88, 0, 0 }, LS = { -40, 0, -25 }, LE = { 30, 0, 0 }, RH = { -24, 0, 4 }, RK = { -30, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -4 }, LK = { -40, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -46, 0, 0, 0, 0.35, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -44, 0, -28 }, LE = { 30, 0, 0 }, RH = { -28, 0, 4 }, RK = { -36, 0, 0 }, RA = { -30, 0, 0 }, LH = { -34, 0, -4 }, LK = { -46, 0, 0 }, LA = { -30, 0, 0 } },
			prop = "tabouret", trail = "prop", shake = true,
			fx = { { "pillar", color = CHAIR, height = 8, width = 3, at = "root", time = 0.4 }, { "burst", color = SPARK, size = 3.5, at = "feet" }, { "ring", color = CHAIR, radius = 5, at = "feet" },
				{ "particles", tex = "smoke", color = COAT, at = "feet", dir = "down", time = 0.35, rate = 70, speed = 14, size = 0.9 } },
			text = "ÉJECTION !", hitText = "BOING !",
		},
		-- Lasso de fil dentaire (esquive puis L) : il fait tourner le fil au-dessus de sa tête et le lance à travers tout le couloir pour ramener l'adversaire
		S_dodge = {
			label = "Lasso de fil dentaire", kind = "grapple", startup = 0.18, active = 0.12, recovery = 0.42,
			damage = 12, kbBase = 22, kbGrowth = 20, kbAngle = 15,
			grapple = { range = 30, angle = 0, speed = 85, pullEnemy = true },
			windup = { Root = { 2, 10, 0, 0, -0.15, 0.1 }, Waist = { 4, 8, 0 }, Neck = { 10, 0, 0 }, LS = { 170, 0, -30 }, LE = { 40, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -10, -10, 0, 0, -0.25, -0.3 }, Waist = { -10, -12, 0 }, Neck = { 0, 6, 0 }, LS = { 96, 0, 4 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, RS = { 20, 0, 30 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 6, 4, 0, 0, -0.2, 0.2 }, Waist = { 8, 4, 0 }, Neck = { 6, 0, 0 }, LS = { 60, 0, -20 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 30 }, RE = { 70, 0, 0 } },
			prop = "fil", trail = "leftHand", windupFx = { { "ring", color = Color3.fromRGB(250, 250, 250), radius = 2.5, at = "above" } },
			fx = { { "beam", color = Color3.fromRGB(250, 250, 250), length = 16, width = 0.3, at = "lhand" } }, text = "YIHAA !", hitText = "ATTRAPÉ !",
		},
		-- Anesthésie (L maintenu) : seringue géante levée, petite giclée de vérification, puis il se fend en avant et pique tout le couloir : l'adversaire devient mou
		S_hold = {
			label = "Anesthésie", startup = 0.28, active = 0.16, recovery = 0.5,
			damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 24, kbGrowth = 40, kbAngle = 25, selfVelocity = Vector2.new(26, 0),
			status = { name = "slowed", duration = 3 },
			windup = { Root = { 4, 14, 0, 0, -0.05, 0.15 }, Waist = { 6, 12, 0 }, Neck = { 20, -10, 0 }, LS = { 160, 0, -15 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -16, -12, 0, 0, -0.35, -0.45 }, Waist = { -14, -14, 0 }, Neck = { -4, 8, 0 }, LS = { 96, 0, 4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 30 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -18, -14, 0, 0, -0.37, -0.5 }, Waist = { -16, -16, 0 }, Neck = { -4, 10, 0 }, LS = { 98, 0, 8 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, RS = { 20, 0, 30 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
			hold = 0.15, prop = "seringue", trail = "leftHand", windupFx = { { "particles", tex = "spark", color = Color3.fromRGB(180, 140, 255), at = "lhand", dir = "up", time = 0.15, rate = 40, speed = 6, size = 0.25 } },
			fx = { { "beam", color = Color3.fromRGB(180, 140, 255), length = 12, width = 0.8, at = "lhand" }, { "symbols", symbols = { "💉", "~" }, color = Color3.fromRGB(180, 140, 255), count = 4, radius = 2.5, at = "front" } },
			text = "PETITE PIQÛRE…", hitText = "TOUT MOU…",
		},
		-- Charge en fauteuil (→→L) : assis sur le tabouret à roulettes, il traverse tout le couloir jambes tendues et bras croisés, impassible
		S_dash = {
			label = "Charge en fauteuil", startup = 0.15, active = 0.32, recovery = 0.42,
			damage = 14, hitbox = box(14, 5, 7, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 35, selfVelocity = Vector2.new(64, 0), invuln = 0.15,
			windup = { Root = { 0, 0, 0, 0, -0.6, 0.1 }, Waist = { 4, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.95, 0 }, Waist = { 6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 70, 0, -30 }, RE = { 110, 0, 0 }, LS = { 70, 0, 30 }, LE = { 110, 0, 0 }, RH = { 85, 0, 0 }, RK = { -30, 0, 0 }, LH = { 85, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -0.95, 0 }, Waist = { 8, 0, 0 }, Neck = { 2, 0, 0 }, RS = { 72, 0, -32 }, RE = { 112, 0, 0 }, LS = { 72, 0, 32 }, LE = { 112, 0, 0 }, RH = { 88, 0, 0 }, RK = { -26, 0, 0 }, LH = { 88, 0, 0 }, LK = { -26, 0, 0 } },
			trail = "bothFeet", fx = { "dust", { "particles", tex = "spark", color = SPARK, at = "feet", dir = "front", time = 0.3, rate = 60, speed = 10, size = 0.3 } },
			text = "PLACE AU DOCTEUR !", hitText = "BADABOUM !",
		},
		-- Dent de sagesse (L en l'air) : il sort une molaire géante de sa poche et la jette de toutes ses forces sur l'adversaire
		S_air = {
			label = "Dent de sagesse", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
			damage = 13, kbBase = 24, kbGrowth = 45, kbAngle = 35,
			projectile = { speed = 62, angle = -20, gravity = 30, lifetime = 0.8, size = 1.8, color = TOOTH, visual = MOLAR },
			windup = { Root = { 10, 15, 0 }, Waist = { 10, 15, 0 }, Neck = { 6, -10, 0 }, LS = { 165, 0, -40 }, LE = { 70, 0, 0 }, RS = { 50, 0, 40 }, RE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -16, -10, 0 }, Waist = { -16, -12, 0 }, Neck = { -4, 8, 0 }, LS = { 70, 0, 10 }, LE = { 5, 0, 0 }, LW = { -30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 50, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -18, -12, 0 }, Waist = { -18, -14, 0 }, Neck = { -6, 10, 0 }, LS = { 60, 0, 16 }, LE = { 10, 0, 0 }, LW = { -35, 0, 0 }, RS = { 38, 0, 52 }, RE = { 50, 0, 0 }, RH = { 28, 0, 0 }, RK = { -55, 0, 0 }, LH = { 52, 0, 0 }, LK = { -92, 0, 0 } },
			trail = "leftHand", fx = { { "symbols", symbols = { "🦷", "✨" }, color = TOOTH, count = 3, radius = 2, at = "lhand" } },
			text = "CADEAU !", hitText = "CRAC !",
		},
		-- Plongeon de la fraise (↓L en l'air) : il pique tout droit vers le sol, fraise pointée dessous, et perce tout ce qui est en dessous
		S_air_down = {
			label = "Plongeon de la fraise", startup = 0.16, active = 0.36, recovery = 0.45,
			damage = 14, hitbox = box(8, 6, 1, -2), kbBase = 28, kbGrowth = 60, kbAngle = -60, selfVelocity = Vector2.new(6, -88),
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 150, 0, -30 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -30, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 12 }, RE = { 0, 0, 0 }, RW = { 88, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 }, RH = { -10, 0, 6 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { -10, 0, -6 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { -34, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 22, 0, 14 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 64, 0, -64 }, LE = { 20, 0, 0 }, RH = { -12, 0, 6 }, RK = { -14, 0, 0 }, RA = { -20, 0, 0 }, LH = { -12, 0, -6 }, LK = { -14, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "prop", wobble = true, fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "down", time = 0.36, rate = 100, speed = 14, size = 0.35 }, { "burst", color = SPARK, size = 3, at = "feet" }, { "shake", amount = 0.4 } },
			text = "ON PERCE !", hitText = "CRAC CRAC !",
		},

		------------------------------------------------------------------ Finition avec S (dans un enchaînement)
		-- Jet de rinçage : il presse la poire à eau et envoie un jet bleu qui file droit sur l'adversaire
		S_finish_rinse = {
			label = "Jet de rinçage", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
			damage = 12, kbBase = 30, kbGrowth = 55, kbAngle = 30,
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.35, size = 1.6, color = RINSE,
				visual = { shape = "ball", size = 1.4, color = RINSE, neon = true, transparency = 0.2 } },
			windup = { Root = { 0, 12, 0, 0, -0.1, 0.1 }, Waist = { 0, 10, 0 }, LS = { 80, 0, -20 }, LE = { 100, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -4, -6, 0, 0, -0.15, -0.1 }, Waist = { -4, -8, 0 }, LS = { 92, 0, 6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			follow = { Root = { 2, -6, 0, 0, -0.15, 0.1 }, Waist = { 2, -8, 0 }, LS = { 100, 0, 6 }, LE = { 5, 0, 0 }, LW = { 10, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			prop = "gobelet", fx = { { "beam", color = RINSE, length = 6, width = 1, at = "lhand", time = 0.15 } }, text = "RINCEZ !", hitText = "SPLASH !",
		},

		------------------------------------------------------------------ Supers
		-- Fauteuil fou : il pousse son fauteuil à roulettes d'un grand coup de pied, le fauteuil traverse l'arène et installe l'adversaire de force
		SUPER = {
			label = "Fauteuil fou !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.65,
			damage = 24, kbBase = 36, kbGrowth = 70, kbAngle = 40,
			projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 0.8, size = 3, color = CHAIR, from = "feet", visual = CHAIR_SHOT },
			status = { name = "stunned", duration = 1.2 },
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.3 }, Waist = { 8, -12, 0 }, Neck = { 10, 6, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 40, 0, 0 }, LS = { 70, 0, -30 }, LE = { 100, 0, 0 }, LW = { -20, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, -0.1, -0.3 }, Waist = { -10, 12, 0 }, Neck = { 4, -6, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 120, 0, -50 }, LE = { 20, 0, 0 }, RH = { 95, 0, 6 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -14, 12, 0, 0, -0.12, -0.35 }, Waist = { -12, 14, 0 }, Neck = { 6, -8, 0 }, RS = { 36, 0, 54 }, RE = { 60, 0, 0 }, LS = { 126, 0, -54 }, LE = { 20, 0, 0 }, RH = { 100, 0, 8 }, RK = { -8, 0, 0 }, RA = { 10, 0, 0 } },
			hold = 0.1, trail = "rightFoot", windupFx = { "super", { "symbols", symbols = { "🪑", "💺" }, color = CHAIR, count = 3, radius = 2, at = "front" } },
			fx = { { "burst", color = CHAIR, size = 3.5, at = "front" }, "dust", { "shake", amount = 0.3 } },
			text = "INSTALLEZ-VOUS !", hitText = "OUVREZ GRAND !",
		},
		-- Dentifrice géant (→Y) : il sort un tube de dentifrice gros comme lui, le coince sous le bras et presse de tout son poids :
		-- un boudin de pâte mentholée rayée part à l'horizontale, traverse le couloir et laisse tout le monde glisser dessus
		SUPER_side = {
			label = "Dentifrice géant !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 26, kbBase = 46, kbGrowth = 96, kbAngle = 30,
			projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.9, size = 3.2, color = PASTE, pierce = true,
				visual = { shape = "cyl", size = 2.8, color = TOOTH, spin = 6, parts = {
					{ "block", Vector3.new(0.6, 3.0, 3.0), Vector3.new(1.2, 0, 0), PASTE },
					{ "block", Vector3.new(0.6, 3.0, 3.0), Vector3.new(-1.2, 0, 0), MINT },
					{ "ball", Vector3.new(2.6, 2.6, 2.6), Vector3.new(-2.4, 0, 0), TOOTH },
				} } },
			status = { name = "slippery", duration = 2.5 },
			windup = { Root = { 10, -30, 0, 0, -0.35, 0.25 }, Waist = { 14, -34, 0 }, Neck = { 6, 20, 0 }, RS = { 40, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -18, 20, 0, 0, -0.42, -0.5 }, Waist = { -22, 26, 0 }, Neck = { -8, -14, 0 }, RS = { 70, 0, -30 }, RE = { 60, 0, 0 }, RW = { -40, 0, 0 }, LS = { 70, 0, 30 }, LE = { 60, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -20, 24, 0, 0, -0.45, -0.55 }, Waist = { -24, 30, 0 }, Neck = { -10, -16, 0 }, RS = { 66, 0, -34 }, RE = { 64, 0, 0 }, RW = { -50, 0, 0 }, LS = { 66, 0, 34 }, LE = { 64, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
			shake = true, windupFx = { "super", { "symbols", symbols = { "🦷", "🪥" }, count = 6, radius = 3, color = PASTE } },
			fx = { { "burst", color = PASTE, size = 4, at = "front" }, { "beam", color = TOOTH, length = 14, width = 3, at = "front" }, { "puddle", color = PASTE, width = 10 }, { "shake", amount = 0.4 } },
			text = "PRESSEZ FORT !", hitText = "MENTHOLÉ !",
		},
		-- Super ↑ : Extraction royale, la pince géante racle tout le couloir au ras du sol, agrippe la « dent » et l'arrache d'un coup de reins vers le ciel
		SUPER_up = {
			label = "Extraction royale !", startup = 0.35, active = 0.25, recovery = 0.7,
			damage = 24, hitbox = box(14, 10, 7, 4), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -14, 10, 0, 0, -0.65, -0.1 }, Waist = { -26, 12, 0 }, Neck = { 10, -6, 0 }, LS = { 60, 0, -10 }, LE = { 10, 0, 0 }, LW = { -20, 0, 0 }, RS = { -30, 0, 40 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, 0.5, 0.1 }, Waist = { 22, 0, 0 }, Neck = { 45, 0, 0 }, LS = { 185, 0, -20 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, RS = { 40, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 18, 0, 0, 0, 0.55, 0.15 }, Waist = { 26, 0, 0 }, Neck = { 52, 0, 0 }, LS = { 192, 0, -26 }, LE = { 8, 0, 0 }, LW = { -10, 0, 0 }, RS = { 45, 0, 90 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			hold = 0.25, selfVelocity = Vector2.new(0, 45), shake = true, prop = "pince", trail = "leftHand",
			windupFx = { "super", { "particles", tex = "spark", color = STEEL, at = "lhand", dir = "all", time = 0.3, rate = 50, speed = 6, size = 0.3 } },
			status = { name = "laughing", duration = 2 },
			fx = { { "pillar", color = SPARK, height = 22, width = 3, at = "front" }, { "text", text = "🦷", at = "above" }, { "burst", color = GLOVE, size = 4, at = "lhand" }, { "shake", amount = 0.4 } },
			text = "OUVREZ GRAND !", hitText = "ARRACHÉ !",
		},
		-- Grand fou rire : il ouvre en grand toutes les bonbonnes, l'arène entière se remplit de gaz rose et tout le monde est plié en deux
		SUPER_down = {
			label = "Grand fou rire !", startup = 0.4, active = 0.2, recovery = 0.7,
			damage = 20, hitbox = box(70, 50, 0, 10), kbBase = 10, kbGrowth = 10, kbAngle = 60,
			status = { name = "laughing", duration = 3 },
			windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, LS = { 40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 60 }, RE = { 10, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.12, 0 }, Waist = { 18, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 160, 0, 70 }, RE = { 10, 0, 0 }, LS = { 160, 0, -70 }, LE = { 10, 0, 0 } },
			hold = 0.4, windupFx = { "super" },
			fx = { { "screen", color = GAS, alpha = 0.35, time = 0.8 }, { "particles", tex = "smoke", color = GAS, at = "root", dir = "all", time = 0.8, rate = 120, speed = 18, size = 2 },
				{ "symbols", symbols = { "HA", "HI", "HO", "😂" }, color = GAS, count = 12, radius = 9, at = "above" } },
			text = "TOUT LE MONDE RIGOLE !", hitText = "HAHAHAHA !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise de dentiste : il pose une main ferme sur l'épaule et attire le patient vers le fauteuil
		GRAB = {
			label = "Ouvrez grand", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 2, 10, 0, 0, -0.05, 0.1 }, Waist = { 4, 10, 0 }, Neck = { 8, 0, 0 }, LS = { 110, 0, -40 }, LE = { 30, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 } },
			strike = { Root = { -6, -4, 0, 0, -0.15, -0.25 }, Waist = { -8, -6, 0 }, LS = { 88, 0, 10 }, LE = { 20, 0, 0 }, RS = { 60, 0, 20 }, RE = { 80, 0, 0 } },
			follow = { Root = { -4, -4, 0, 0, -0.12, -0.2 }, Waist = { -6, -6, 0 }, LS = { 85, 0, 14 }, LE = { 40, 0, 0 }, RS = { 70, 0, 15 }, RE = { 90, 0, 0 } },
			text = "OUVREZ GRAND !", hitText = "AAAAH…",
		},
		-- ✋ puis → : « Ouvrez grand ! », il pousse le fauteuil à roulettes qui part au loin avec le patient
		THROW_fwd = {
			label = "Ouvrez grand !", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 12,
			carry = { { 0, 2.4, 0.4 }, { 0.15, 1.8, -0.4 }, { 0.3, 4.4, -0.8 } },
			windup = { Root = { 6, 15, 0, 0, -0.35, 0.3 }, Waist = { 6, 12, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, LS = { 60, 0, -10 }, LE = { 90, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.45, -0.45 }, Waist = { -14, 0, 0 }, RS = { 85, 0, -10 }, RE = { 5, 0, 0 }, LS = { 85, 0, 10 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -20, 0, 0, 0, -0.5, -0.55 }, Waist = { -16, 0, 0 }, RS = { 88, 0, -12 }, RE = { 5, 0, 0 }, LS = { 88, 0, 12 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { "dust" }, text = "AU SUIVANT !", hitText = "ROULEZ JEUNESSE !",
		},
		-- ✋ puis ← : Fauteuil basculé, il actionne le dossier et le patient bascule derrière lui
		THROW_back = {
			label = "Fauteuil basculé", kind = "throw", back = true, startup = 0.38, active = 0.1, recovery = 0.36,
			damage = 11, kbBase = 35, kbGrowth = 66, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.2, 1.2 }, { 0.26, -0.8, 2.6 }, { 0.38, -2.6, 0.2 } },
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.1 }, Waist = { -10, 0, 0 }, RS = { 80, 0, -10 }, RE = { 60, 0, 0 }, LS = { 80, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.4, 0.3 }, Waist = { 30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 190, 0, -10 }, RE = { 20, 0, 0 }, LS = { 190, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 22, 0, 0, 0, -0.42, 0.35 }, Waist = { 32, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 195, 0, -15 }, RE = { 20, 0, 0 }, LS = { 195, 0, 15 }, LE = { 20, 0, 0 } },
			fx = { "dust" }, text = "ON S'ALLONGE !", hitText = "BADABOUM !",
		},
		-- ✋ puis ↑ : Extraction, la pince serre et il tire le patient vers le haut comme une dent récalcitrante
		THROW_up = {
			label = "Extraction", kind = "throw", startup = 0.36, active = 0.08, recovery = 0.35,
			damage = 10, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.12, 2.0, -0.2 }, { 0.24, 2.0, 0.2 }, { 0.36, 1.2, 3.8 } },
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.05 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, LS = { 90, 0, 0 }, LE = { 40, 0, 0 }, RS = { 60, 0, 30 }, RE = { 80, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.25, 0.15 }, Waist = { 16, 0, 0 }, Neck = { 30, 0, 0 }, LS = { 175, 0, -5 }, LE = { 10, 0, 0 }, RS = { 140, 0, 30 }, RE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.3, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 36, 0, 0 }, LS = { 180, 0, -10 }, LE = { 10, 0, 0 }, RS = { 150, 0, 35 }, RE = { 25, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "pince", shake = true, text = "ELLE VIENT !", hitText = "PLOP !",
		},
		-- ✋ puis ↓ : Anesthésie, il allonge le patient au sol et lui fait une petite piqûre : dodo
		THROW_down = {
			label = "Anesthésie générale", kind = "throw", startup = 0.4, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 8, kbBase = 26, kbGrowth = 20, kbAngle = 70,
			status = { name = "asleep", duration = 1.5 },
			carry = { { 0, 2.2, 0.3 }, { 0.16, 2.2, -0.8 }, { 0.4, 2.0, -2.2 } },
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, LS = { 140, 0, -10 }, LE = { 50, 0, 0 }, RS = { 70, 0, 20 }, RE = { 80, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.9, -0.3 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, LS = { 60, 0, 0 }, LE = { 10, 0, 0 }, RS = { 50, 0, 20 }, RE = { 70, 0, 0 } },
			follow = { Root = { -14, 0, 0, 0, -0.85, -0.3 }, Waist = { -18, 0, 0 }, Neck = { 6, 0, 0 }, LS = { 50, 0, 0 }, LE = { 20, 0, 0 }, RS = { 40, 0, 25 }, RE = { 60, 0, 0 } },
			prop = "seringue", fx = { { "symbols", symbols = { "Z", "z", "💤" }, color = Color3.fromRGB(170, 200, 255), count = 5, radius = 3, at = "front" } },
			text = "COMPTEZ JUSQU'À DIX…", hitText = "ZZZ…",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "sourire_parfait", label = "Sourire parfait", sequence = { "forward", "down", "up" },
			-- un sourire si éclatant que l'adversaire, aveuglé, tourne de l'œil et tombe à la renverse
			scene = {
				{ "fxAttacker", { "symbols", symbols = { "✨", "✦" }, color = SPARK, count = 8, radius = 2.5 } },
				{ "fxAttacker", { "text", text = "TING !", color = SPARK } },
				{ "wait", 0.4 },
				{ "fxAttacker", { "beam", color = SPARK, length = 14, width = 3, at = "head", time = 0.8 } },
				{ "fx", { "screen", color = Color3.fromRGB(255, 255, 255), alpha = 0.7, time = 0.8 } },
				{ "text", "MES YEUX !" },
				{ "spin", 720, axis = "y", time = 0.8 },
				{ "fx", { "symbols", symbols = { "💫", "⭐" }, color = SPARK, count = 6, radius = 2 } },
				{ "spin", 90, axis = "z", time = 0.4 },
				{ "wait", 1.0 },
			},
		},
		{
			id = "appareil_dentaire", label = "Appareil dentaire", sequence = { "down", "forward", "down" },
			-- l'adversaire se retrouve ficelé dans un appareil dentaire géant et ne peut plus bouger
			scene = {
				{ "text", "UN PETIT APPAREIL ?" },
				{ "wait", 0.4 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 4, pieces = {
					{ "Bague1", "", "cyl", Vector3.new(0.4, 4.6, 4.6), Vector3.new(0, 1.4, 0), Vector3.new(0, 0, 90), STEEL, "Metal", { transparency = 0.1 } },
					{ "Bague2", "", "cyl", Vector3.new(0.4, 4.6, 4.6), Vector3.new(0, 0, 0), Vector3.new(0, 0, 90), STEEL, "Metal", { transparency = 0.1 } },
					{ "Bague3", "", "cyl", Vector3.new(0.4, 4.6, 4.6), Vector3.new(0, -1.4, 0), Vector3.new(0, 0, 90), STEEL, "Metal", { transparency = 0.1 } },
					{ "Fil", "", "block", Vector3.new(0.3, 4.4, 0.3), Vector3.new(0, 0, -2.3), Vector3.zero, Color3.fromRGB(120, 200, 255), "Neon", { neon = true } },
					{ "Elastique", "", "block", Vector3.new(0.3, 4.4, 0.3), Vector3.new(0, 0, 2.3), Vector3.zero, Color3.fromRGB(255, 120, 180), "Neon", { neon = true } },
				} },
				{ "fx", { "burst", color = STEEL, size = 4 } },
				{ "squash", 0.85 },
				{ "fxAttacker", { "text", text = "ET ON REVIENT DANS 2 ANS !", color = MINT } },
				{ "wait", 1.4 },
			},
		},
		{
			id = "petite_souris", label = "La petite souris", sequence = { "back", "forward", "up" },
			-- une souris l'emporte sous un oreiller et laisse une pièce à la place
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, -2.6, 0), life = 3.5, pieces = {
					{ "Oreiller", "", "block", Vector3.new(4.5, 0.9, 3), Vector3.zero, Vector3.zero, Color3.fromRGB(240, 240, 255), "Fabric" },
				} },
				{ "text", "BONNE NUIT…" },
				{ "shrink", 0.25, time = 0.7 },
				{ "spawn", at = "target", offset = Vector3.new(2.5, -1.8, 0), life = 2.5, pieces = {
					{ "Souris", "", "ball", Vector3.new(1.6, 1.1, 1.1), Vector3.zero, Vector3.zero, Color3.fromRGB(170, 170, 180), "Fabric" },
					{ "Oreille", "", "ball", Vector3.new(0.2, 0.7, 0.7), Vector3.new(-0.5, 0.6, 0), Vector3.zero, Color3.fromRGB(255, 180, 200) },
					{ "Queue", "", "cyl", Vector3.new(1.2, 0.1, 0.1), Vector3.new(1.2, 0, 0), Vector3.zero, Color3.fromRGB(255, 180, 200) },
				} },
				{ "wait", 0.6 },
				{ "hide" },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.1, 0), life = 2.5, pieces = {
					{ "Piece", "", "cyl", Vector3.new(0.2, 1.4, 1.4), Vector3.zero, Vector3.new(0, 0, 90), Color3.fromRGB(255, 205, 60), "Metal", { reflect = 0.3 } },
				} },
				{ "fx", { "symbols", symbols = { "🪙", "✨" }, color = Color3.fromRGB(255, 205, 60), count = 6, radius = 2 } },
				{ "fxAttacker", { "text", text = "UNE PIÈCE POUR LA PEINE !", color = SPARK } },
				{ "wait", 1.2 },
			},
		},
	},

	-- Mécanique : Fou rire. Rien de passif : ses coups marqués status laughing bloquent K et ⭐ (3 s)
	passive = { kind = "laugh", name = "Fou rire", icon = "😂" },

	-- Recharge ⚡ : assis sur son tabouret à roulettes, il se brosse les dents à toute vitesse (main gauche),
	-- puis découvre un sourire qui étincelle (« TING ! »)
	charge = {
		label = "Brossage express",
		loop = 1.4,
		lockWrist = false,
		color = MINT,
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.85, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 120, 0, 25 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } } },
			{ 0.12, { Root = { 0, 0, 0, 0, -0.85, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 120, 0, 10 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } } },
			{ 0.24, { Root = { 0, 0, 0, 0, -0.85, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 120, 0, 25 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } } },
			{ 0.36, { Root = { 0, 0, 0, 0, -0.85, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 120, 0, 10 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } } },
			{ 0.48, { Root = { 0, 0, 0, 0, -0.85, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 120, 0, 25 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } } },
			{ 0.6, { Root = { 0, 0, 0, 0, -0.85, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 120, 0, 10 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } } },
			{ 0.85, { Root = { -4, 0, 0, 0, -0.8, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 22, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 } } },
			{ 1.1, { Root = { -4, 0, 0, 0, -0.8, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 22, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 42, 0, -42 }, LE = { 60, 0, 0 }, RS = { 62, 0, 32 }, RE = { 90, 0, 0 } } },
			{ 1.4, { Root = { 0, 0, 0, 0, -0.85, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 6 }, RK = { -88, 0, 0 }, LH = { 85, 0, -6 }, LK = { -88, 0, 0 }, LS = { 120, 0, 25 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "particles", tex = "smoke", color = Color3.fromRGB(240, 255, 250), at = "head", dir = "all", time = 0.55, rate = 40, speed = 3, size = 0.5 } },
			{ 0.9, { "symbols", symbols = { "✨", "✦" }, color = SPARK, count = 4, radius = 1.8 } },
			{ 0.95, { "text", text = "TING !", color = SPARK } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- il règle sa lampe frontale du bout des doigts
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.35, { LS = { 160, 0, -10 }, LE = { 110, 0, 0 }, Neck = { 10, 0, 0 } } },
			{ 0.7, { LS = { 162, 0, -14 }, LE = { 115, 0, 0 }, LW = { 20, 0, 0 }, Neck = { 12, 6, 0 } } },
			{ 1.05, { LS = { 160, 0, -10 }, LE = { 110, 0, 0 }, LW = { -10, 0, 0 }, Neck = { 10, -6, 0 } } },
			{ 1.8, {} },
		} },
		-- il retend son gant d'un claquement sec
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.3, { RS = { 60, 0, -20 }, RE = { 90, 0, 0 }, LS = { 55, 0, 20 }, LE = { 100, 0, 0 }, Neck = { -10, 0, 0 } } },
			{ 0.6, { RS = { 60, 0, -20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -10 }, LE = { 60, 0, 0 }, Neck = { -10, 0, 0 } } },
			{ 0.75, { RS = { 62, 0, -18 }, RE = { 92, 0, 0 }, LS = { 58, 0, 18 }, LE = { 100, 0, 0 }, Neck = { -6, 0, 0 } } },
			{ 1.6, {} },
		} },
		-- il sourit de toutes ses dents au public, pouce levé
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.35, { Root = { 4, 0, 0 }, Neck = { 14, -20, 0 }, LS = { 90, 0, -40 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } } },
			{ 1.1, { Root = { 4, 0, 0 }, Neck = { 16, -24, 0 }, LS = { 92, 0, -42 }, LE = { 105, 0, 0 }, LW = { 0, 0, 0 } } },
			{ 1.6, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : la main gauche ferme sur l'épaule du patient, la fraise levée et prête
data.grabHold = {
	Root = { 2, 10, 0, 0, -0.1, 0.05 },
	Waist = { 2, 8, 0 },
	Neck = { 10, -6, 0 },
	LS = { 85, 0, 8 },
	LE = { 40, 0, 0 },
	RS = { 130, 0, 25 },
	RE = { 70, 0, 0 },
	RW = { 40, 0, 0 },
}

-- Retour 🪂 : il descend assis sur son fauteuil de dentiste qui s'abaisse en sifflant, enfile un gant d'un
-- claquement sec et sourit (« TING ! »)
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Socle", "base", "block", Vector3.new(5, 1, 3.2), Vector3.new(0, -0.5, 0), Vector3.zero, Color3.fromRGB(230, 235, 240), "SmoothPlastic" },
		{ "Pied", "", "cyl", Vector3.new(1.6, 0.9, 0.9), Vector3.new(0, -1.6, 0), Vector3.zero, STEEL, "Metal" },
		{ "Pompe", "", "block", Vector3.new(3, 0.5, 2), Vector3.new(0, -2.5, 0), Vector3.zero, STEEL, "Metal" },
		{ "Dossier", "", "block", Vector3.new(3.4, 4, 0.7), Vector3.new(0, 2, 1.6), Vector3.new(-12, 0, 0), CHAIR, "Fabric" },
		{ "Appuitete", "", "block", Vector3.new(1.6, 0.9, 0.7), Vector3.new(0, 4.4, 2), Vector3.new(-12, 0, 0), CHAIR, "Fabric" },
		{ "Accoudoir", "", "block", Vector3.new(0.4, 0.4, 2.4), Vector3.new(2, 1.2, 0.4), Vector3.zero, CHAIR, "Fabric" },
		{ "Tablette", "", "block", Vector3.new(1.8, 0.15, 1.2), Vector3.new(-2.6, 1.5, 0), Vector3.zero, Color3.fromRGB(240, 240, 240) },
		{ "BrasLampe", "", "cyl", Vector3.new(3, 0.2, 0.2), Vector3.new(-1.8, 5.2, 0.6), Vector3.new(0, 0, 60), STEEL, "Metal" },
		{ "Scialytique", "", "cyl", Vector3.new(0.4, 1.4, 1.4), Vector3.new(-0.6, 6.4, 0.2), Vector3.new(0, 0, 90), SPARK, "Neon", { neon = true, light = { SPARK, 10, 1 } } },
	} },
	keys = {
		{ 0.0, { Root = { -6, 0, 0, 0, -1.0, 0.25 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RH = { 85, 0, 4 }, RK = { -85, 0, 0 }, LH = { 85, 0, -4 }, LK = { -85, 0, 0 }, RS = { 30, 0, 15 }, RE = { 60, 0, 0 }, LS = { 30, 0, -15 }, LE = { 60, 0, 0 } } },
		{ 0.5, { Root = { -6, 0, 0, 0, -1.05, 0.25 }, Waist = { 8, 0, 0 }, Neck = { 0, -10, 0 }, RH = { 85, 0, 4 }, RK = { -85, 0, 0 }, LH = { 85, 0, -4 }, LK = { -85, 0, 0 }, RS = { 30, 0, 15 }, RE = { 60, 0, 0 }, LS = { 30, 0, -15 }, LE = { 60, 0, 0 } } },
		{ 0.75, { Root = { 2, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 60, 0, -20 }, RE = { 90, 0, 0 }, LS = { 50, 0, 20 }, LE = { 100, 0, 0 } } },
		{ 0.95, { Root = { 2, 0, 0, 0, -0.05, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, -20 }, RE = { 90, 0, 0 }, LS = { 35, 0, -10 }, LE = { 60, 0, 0 } } },
		{ 1.05, { Root = { 2, 0, 0, 0, -0.05, 0 }, Neck = { -4, 0, 0 }, RS = { 62, 0, -18 }, RE = { 92, 0, 0 }, LS = { 58, 0, 18 }, LE = { 100, 0, 0 } } },
		{ 1.35, { Root = { 4, 0, 0, 0, 0.02, 0 }, Neck = { 14, -15, 0 }, LS = { 90, 0, -40 }, LE = { 100, 0, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.1, { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 250), at = "feet", dir = "all", time = 0.5, rate = 50, speed = 4, size = 1 } },
		{ 0.1, { "text", text = "PSCHHHT…", color = STEEL } },
		{ 0.98, { "text", text = "CLAC !", color = GLOVE } },
		{ 1.35, { "symbols", symbols = { "✨", "✦" }, color = SPARK, count = 5, radius = 2 } },
		{ 1.38, { "text", text = "TING !", color = SPARK } },
	},
}

-- Arbre d'enchaînements (voir Gege.lua) : presque toutes les chaînes peuvent finir sur S
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol, P…
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_K = "K_side", S = "S_finish_rinse" },
	P_combo2 = { P = "P_combo3", K = "PK_combo", down_P = "P_down", S = "S_neutral" }, -- P P
	P_combo3 = { K = "PPPK_combo", S = "S_finish_rinse" }, -- P P P (P P P K : tabouret tournant, finition)
	PK_combo = { P = "P_combo3", K = "K_combo2", S = "S_neutral" }, -- P K
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_rinse" }, -- → P
	P_side2 = { P = "P_side3", K = "PK_combo", S = "S_neutral" }, -- → P P (→ P P P : plombage, finition)
	P_down = { P = "P_down2", K = "K_down", S = "S_finish_rinse" }, -- ↓ P
	P_down2 = { P = "P_down3", up_K = "K_up", K = "KP_combo", S = "S_neutral" }, -- ↓ P P (↓ P P P : fil scie, finition)
	P_up = { P = "P_combo2", K = "K_up", S = "S_finish_rinse" }, -- ↑ P
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_hold" }, -- dash P
	-- au sol, K…
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_rinse" },
	K_combo2 = { K = "K_combo3", P = "KP_combo", S = "S_neutral" }, -- K K
	K_combo3 = { S = "S_finish_rinse" }, -- K K K
	KP_combo = { K = "K_combo3", P = "P_combo3", S = "S_finish_rinse" }, -- K P
	K_side = { K = "K_side2", P = "KP_combo", S = "S_neutral" }, -- → K
	K_side2 = { K = "K_side3", P = "KP_combo", S = "S_finish_rinse" }, -- → K K (→ K K K : coup de lampe, finition)
	K_down = { K = "K_downK", P = "P_down2", S = "S_finish_rinse" }, -- ↓ K
	K_downK = { P = "KP_combo", S = "S_finish_rinse" }, -- ↓ K K
	K_up = { P = "P_air_up", S = "S_finish_rinse" }, -- ↑ K
	K_dash = { P = "KP_combo", S = "S_finish_rinse" }, -- dash K
	-- en l'air (↓P et ↓K, smashs vers le sol, finissent la chaîne)
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

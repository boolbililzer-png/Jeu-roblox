-- Marcel le Mime : visage blanc, marinière et béret, il ne dit jamais un mot (ses bulles sont vides) mais tout ce
-- qu'il mime devient vrai : murs, cordes, parapluies, pianos. Arme sortie de la Caisse Bizarre : ses accessoires
-- invisibles (une canne presque transparente et ses manchettes de mime ; ses gants blancs font partie du costume).
--
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
-- Mécanique « Murs invisibles » : S pose un mur invisible (kind = "wall", 2 au plus) qui bloque projectiles et
-- adversaires. Les accessoires ponctuels (corde, parapluie, ballon) sont presque transparents : on les devine.
-- Ses textes sont muets : « … » et onomatopées entre parenthèses, comme un film muet.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local FACE = Color3.fromRGB(248, 248, 250)
local WHITE = Color3.fromRGB(245, 245, 248)
local NAVY = Color3.fromRGB(30, 45, 95)
local BLACK = Color3.fromRGB(22, 22, 26)
local RED = Color3.fromRGB(205, 35, 45)
local PINK = Color3.fromRGB(240, 150, 170)
local GHOST = Color3.fromRGB(225, 238, 255) -- les objets invisibles : un reflet bleuté
local ROPE = Color3.fromRGB(235, 225, 200)
local BANANA = Color3.fromRGB(250, 225, 80)
local WIND = Color3.fromRGB(220, 230, 240)

local data = {
	id = "Marcel",
	name = "Marcel le Mime",
	costume = "Marcel",
	style = "mime",

	look = {
		body = {
			head = FACE, upper = WHITE, lower = BLACK, arms = WHITE, forearms = WHITE,
			hands = WHITE, legs = BLACK, feet = BLACK,
		},
		cubeHead = 1.25,
		parts = {
			-- béret penché et sa petite tige
			{ "Beret", "Head", "ball", Vector3.new(1.55, 0.45, 1.5), Vector3.new(0.15, 0.72, 0.02), Vector3.new(0, 0, -12), BLACK, "Fabric" },
			{ "TigeBeret", "Head", "cyl", Vector3.new(0.25, 0.09, 0.09), Vector3.new(0.12, 0.98, 0), Vector3.zero, BLACK, "Fabric" },
			-- maquillage de mime : yeux en amande, sourcils en accent circonflexe, larme, bouche rouge, pommettes
			{ "OeilG", "Head", "ball", Vector3.new(0.14, 0.27, 0.08), Vector3.new(-0.28, 0.14, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.14, 0.27, 0.08), Vector3.new(0.28, 0.14, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "SourcilG", "Head", "block", Vector3.new(0.32, 0.06, 0.05), Vector3.new(-0.3, 0.44, -0.64), Vector3.new(0, 0, 18), BLACK, "SmoothPlastic" },
			{ "SourcilD", "Head", "block", Vector3.new(0.32, 0.06, 0.05), Vector3.new(0.3, 0.44, -0.64), Vector3.new(0, 0, -18), BLACK, "SmoothPlastic" },
			{ "Larme", "Head", "block", Vector3.new(0.1, 0.1, 0.04), Vector3.new(0.3, -0.12, -0.64), Vector3.new(0, 0, 45), BLACK, "SmoothPlastic" },
			{ "Bouche", "Head", "block", Vector3.new(0.34, 0.1, 0.05), Vector3.new(0, -0.33, -0.64), Vector3.zero, RED, "SmoothPlastic" },
			{ "JoueG", "Head", "ball", Vector3.new(0.22, 0.15, 0.04), Vector3.new(-0.42, -0.14, -0.63), Vector3.zero, PINK, "SmoothPlastic", { transparency = 0.3 } },
			{ "JoueD", "Head", "ball", Vector3.new(0.22, 0.15, 0.04), Vector3.new(0.42, -0.14, -0.63), Vector3.zero, PINK, "SmoothPlastic", { transparency = 0.3 } },
			-- marinière : rayures marine, bretelles noires et foulard rouge
			{ "Rayure1", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, 0.5, 0), Vector3.zero, NAVY, "Fabric" },
			{ "Rayure2", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, 0.1, 0), Vector3.zero, NAVY, "Fabric" },
			{ "Rayure3", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, -0.3, 0), Vector3.zero, NAVY, "Fabric" },
			{ "Rayure4", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, -0.7, 0), Vector3.zero, NAVY, "Fabric" },
			{ "BretelleG", "UpperTorso", "block", Vector3.new(0.18, 1.62, 1.05), Vector3.new(-0.45, 0, 0), Vector3.zero, BLACK, "Fabric" },
			{ "BretelleD", "UpperTorso", "block", Vector3.new(0.18, 1.62, 1.05), Vector3.new(0.45, 0, 0), Vector3.zero, BLACK, "Fabric" },
			{ "Foulard", "UpperTorso", "block", Vector3.new(0.9, 0.26, 0.4), Vector3.new(0, 0.74, -0.38), Vector3.zero, RED, "Fabric" },
			{ "MancheRayeeG", "LeftUpperArm", "block", Vector3.new(1.04, 0.16, 1.04), Vector3.new(0, 0.05, 0), Vector3.zero, NAVY, "Fabric" },
			{ "MancheRayeeD", "RightUpperArm", "block", Vector3.new(1.04, 0.16, 1.04), Vector3.new(0, 0.05, 0), Vector3.zero, NAVY, "Fabric" },
		},
		props = {
			-- l'arme de la caisse : une canne invisible (on la devine à peine) et la manchette blanche du mime
			{ name = "PropCanne", hand = "Right", visible = true, pieces = {
				{ "Canne", "", "cyl", Vector3.new(3, 0.18, 0.18), Vector3.new(0, -1.5, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.82 } },
				{ "Crosse", "", "ball", Vector3.new(0.5, 0.5, 0.2), Vector3.new(0, 0.12, -0.22), Vector3.zero, GHOST, "Glass", { transparency = 0.82 } },
				{ "Manchette", "", "cyl", Vector3.new(0.22, 0.85, 0.85), Vector3.new(0, 0.42, 0), Vector3.zero, WHITE, "Fabric" },
			} },
			-- accessoires mimés : corde, parapluie et ballon presque invisibles
			{ name = "PropCorde", hand = "Right", visible = false, pieces = {
				{ "Corde", "", "cyl", Vector3.new(5, 0.14, 0.14), Vector3.new(0, -2.5, 0), Vector3.zero, ROPE, "Fabric", { transparency = 0.75 } },
			} },
			{ name = "PropParapluie", hand = "Right", visible = false, pieces = {
				{ "Tige", "", "cyl", Vector3.new(2.6, 0.1, 0.1), Vector3.new(0, -1.3, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.78 } },
				{ "Toile", "", "ball", Vector3.new(3.4, 1.2, 3.4), Vector3.new(0, -2.6, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.8 } },
			} },
			{ name = "PropBallon", hand = "Right", visible = false, pieces = {
				{ "Ficelle", "", "cyl", Vector3.new(2, 0.05, 0.05), Vector3.new(0, -1, 0), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.6 } },
				{ "Ballon", "", "ball", Vector3.new(1.7, 2, 1.7), Vector3.new(0, -2.9, 0), Vector3.zero, PINK, "Glass", { transparency = 0.8 } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Fausse claque : grand armé théâtral de la main gauche, gifle à plat, la tête de Marcel accompagne le geste
		P_neutral = {
			label = "Fausse claque", startup = 0.07, active = 0.07, recovery = 0.14,
			damage = 5, hitbox = box(4, 3, 2.5, 1), kbBase = 18, kbGrowth = 22, kbAngle = 28,
			windup = { Root = { 2, 25, 0, 0, -0.15, 0.1 }, Waist = { 0, 25, 0 }, Neck = { 0, -15, 6 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 85, 0, -95 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 } },
			strike = { Root = { -4, -15, 0, 0, -0.2, -0.2 }, Waist = { -4, -20, 0 }, Neck = { 0, 10, -6 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 95, 0, 15 }, LE = { 5, 0, 0 }, LW = { 0, 0, 20 } },
			follow = { Root = { -4, -20, 0, 0, -0.2, -0.22 }, Waist = { -4, -26, 0 }, Neck = { 0, 14, -8 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 90, 0, 35 }, LE = { 10, 0, 0 }, LW = { 0, 0, 30 } },
			trail = "leftHand", text = "…", hitText = "( CLAC )",
		},
		-- Coup de canne invisible : il fait tournoyer la canne qu'on ne voit pas et frappe d'un revers sec
		P_combo2 = {
			label = "Coup de canne invisible", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(5, 4, 3, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 30,
			windup = { Root = { 2, -20, 0, 0, -0.18, 0.1 }, Waist = { 2, -25, 0 }, Neck = { 0, 15, 0 }, RS = { 70, 0, 80 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 } },
			strike = { Root = { -6, 18, 0, 0, -0.22, -0.28 }, Waist = { -6, 22, 0 }, Neck = { 0, -12, 0 }, RS = { 95, 0, -5 }, RE = { 5, 0, 0 }, RW = { -80, 0, 0 }, LS = { 25, 0, -45 }, LE = { 90, 0, 0 } },
			follow = { Root = { -8, 22, 0, 0, -0.24, -0.32 }, Waist = { -8, 26, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, -20 }, RE = { 8, 0, 0 }, RW = { -85, 0, 0 }, LS = { 25, 0, -45 }, LE = { 90, 0, 0 } },
			trail = "prop", hitText = "( TOC )",
		},
		-- P P P P : Grand coup de canne, la canne invisible levée à deux mains comme un marteau de foire, puis abattue (finition)
		P_combo3 = {
			label = "Grand coup de canne", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 78, kbAngle = 48,
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 190, 0, 5 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, 5 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.45, -0.35 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, -5 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 75, 0, 15 }, LE = { 10, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.52, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 55, 0, -5 }, RE = { 0, 0, 0 }, RW = { -55, 0, 0 }, LS = { 55, 0, 15 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { { "ring", color = GHOST, radius = 3.5, at = "front" } }, text = "…!", hitText = "( BOUM )",
		},
		-- Corde tirée : il lance une corde invisible, puis tire main sur main, penché en arrière : l'adversaire vient à lui
		P_side = {
			label = "Corde tirée", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 6, hitbox = box(7, 3, 4, 0.6), kbBase = 18, kbGrowth = 15, kbAngle = 12, pull = true,
			windup = { Root = { -8, 0, 0, 0, -0.2, -0.2 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 5 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			strike = { Root = { 14, -10, 0, 0, -0.35, 0.35 }, Waist = { 16, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, -5 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 18, -14, 0, 0, -0.4, 0.45 }, Waist = { 20, -12, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -5 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "corde", hideProp = "canne", text = "…", hitText = "( HISSE )",
		},
		-- Marche d'escalier invisible : il descend une marche qui n'existe pas et écrase les orteils d'en face
		P_down = {
			label = "Marche d'escalier invisible", startup = 0.09, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(4.5, 2, 2.4, -2), kbBase = 24, kbGrowth = 22, kbAngle = 70,
			windup = { Root = { 2, 0, 0, 0, 0.05, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 15, 0, 35 }, RE = { 30, 0, 0 }, LS = { 15, 0, -35 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -95, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.5, -0.15 }, Waist = { -8, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 20, 0, 45 }, RE = { 20, 0, 0 }, LS = { 20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 35, 0, 0 }, RK = { -10, 0, 0 }, RA = { -15, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.6, -0.18 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 22, 0, 48 }, RE = { 20, 0, 0 }, LS = { 22, 0, -48 }, LE = { 20, 0, 0 }, RH = { 32, 0, 0 }, RK = { -12, 0, 0 }, RA = { -15, 0, 0 } },
			trail = "rightFoot", hitText = "( AÏE MES ORTEILS )",
		},
		-- Parapluie invisible (anti-air) : il ouvre d'un geste sec un parapluie au-dessus de son béret
		P_up = {
			label = "Parapluie invisible", startup = 0.08, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 1, 3.8), kbBase = 26, kbGrowth = 32, kbAngle = 86,
			windup = { Root = { -4, 0, 0, 0, -0.35, 0 }, Waist = { -6, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 40, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 172, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 30, 0, 0 }, LW = { 0, 0, -40 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 176, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 5, 0, -55 }, LE = { 30, 0, 0 }, LW = { 0, 0, -50 } },
			prop = "parapluie", hideProp = "canne", fx = { { "ring", color = GHOST, radius = 3, at = "above" } }, hitText = "( FLOP )",
		},
		-- Parapluie invisible en l'air : parapluie fermé tenu comme une épée, grand coup de haut en bas devant lui
		P_air = {
			label = "Coup de parapluie", startup = 0.08, active = 0.1, recovery = 0.16,
			damage = 7, hitbox = box(4.5, 4, 2.4, 0), kbBase = 22, kbGrowth = 32, kbAngle = 32,
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 175, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -10, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 85, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -14, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 5 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 25, 0, -72 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 65, 0, 0 }, LK = { -100, 0, 0 } },
			prop = "parapluie", hideProp = "canne", trail = "rightHand", hitText = "( PAF )",
		},
		-- Porte invisible (dash puis P) : il tourne une poignée imaginaire et ouvre la porte en grand… dans le nez d'en face
		P_dash = {
			label = "Porte invisible", startup = 0.08, active = 0.14, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 4.5, 2.4, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -4, 15, 0, 0, -0.2, 0.1 }, Waist = { -4, 15, 0 }, Neck = { 0, -10, 0 }, RS = { 70, 0, -30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -12, -20, 0, 0, -0.3, -0.3 }, Waist = { -10, -25, 0 }, Neck = { 0, 15, 0 }, RS = { 85, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			follow = { Root = { -14, -26, 0, 0, -0.32, -0.35 }, Waist = { -12, -30, 0 }, Neck = { 0, 18, 0 }, RS = { 80, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			trail = "rightHand", fx = { "dust" }, text = "( TOC TOC )", hitText = "( BLAM )",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Pied imaginaire : il pose un ballon invisible devant lui, recule d'un pas et tire dedans de toutes ses forces
		K_neutral = {
			label = "Pied imaginaire", startup = 0.19, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, -0.3), kbBase = 30, kbGrowth = 70, kbAngle = 38,
			windup = { Root = { 6, -8, 0, 0, -0.12, 0.25 }, Waist = { 10, -6, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 45 }, RE = { 20, 0, 0 }, LS = { 60, 0, -40 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 }, RH = { -45, 0, 0 }, RK = { -80, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 14, -2, 0, 0, -0.1, -0.05 }, Waist = { 16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, 50 }, RE = { 10, 0, 0 }, LS = { -30, 0, -55 }, LE = { 10, 0, 0 }, LW = { 0, 0, -40 }, RH = { 100, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, -0.1, 0 }, Waist = { 18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 55 }, RE = { 10, 0, 0 }, LS = { -35, 0, -60 }, LE = { 10, 0, 0 }, LW = { 0, 0, -40 }, RH = { 115, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", hitText = "( BUT )",
		},
		-- Canne invisible : fente d'escrimeur, la canne tendue loin devant, le bras gauche levé derrière
		K_side = {
			label = "Canne invisible", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 13, hitbox = box(6.5, 2.5, 4, 0.8), kbBase = 32, kbGrowth = 82, kbAngle = 25, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 4, -40, 0, 0, -0.2, 0.3 }, Waist = { 4, -30, 0 }, Neck = { 0, 35, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { -70, 0, 0 }, LS = { 150, 0, -40 }, LE = { 60, 0, 0 }, LW = { 30, 0, 0 } },
			strike = { Root = { -8, -55, 0, 0, -0.55, -0.6 }, Waist = { -4, -30, 0 }, Neck = { 0, 45, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 150, 0, -70 }, LE = { 60, 0, 0 }, LW = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.7 } },
			follow = { Root = { -10, -58, 0, 0, -0.6, -0.65 }, Waist = { -6, -32, 0 }, Neck = { 0, 48, 0 }, RS = { 93, 0, 0 }, RE = { 0, 0, 0 }, RW = { -90, 0, 0 }, LS = { 152, 0, -72 }, LE = { 55, 0, 0 }, LW = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.75 } },
			trail = "prop", text = "( TOUCHÉ )", hitText = "( PIC )",
		},
		-- Glissade « contre le vent » : penché comme dans une tempête, il glisse en avant au ras du sol, bras devant
		K_down = {
			label = "Glissade contre le vent", startup = 0.17, active = 0.22, recovery = 0.32,
			damage = 11, hitbox = box(6, 2.5, 2.8, -1.5), kbBase = 30, kbGrowth = 60, kbAngle = 65, selfVelocity = Vector2.new(38, 0),
			windup = { Root = { 10, 0, 0, 0, -0.2, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 110, 0, -20 }, LE = { 60, 0, 0 }, LW = { 60, 0, 0 } },
			strike = { Root = { -40, 0, 0, 0, -0.9, -0.3 }, Waist = { -15, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, 15 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 140, 0, -15 }, LE = { 10, 0, 0 }, LW = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -45, 0, 0, 0, -1.0, -0.35 }, Waist = { -18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 150, 0, 15 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 150, 0, -15 }, LE = { 10, 0, 0 }, LW = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
			trail = "body", fx = { { "particles", tex = "smoke", color = WIND, dir = "all", at = "front", time = 0.3, speed = 12, size = 0.6 } }, hitText = "( FIOU )",
		},
		-- Moonwalk arrière : il recule en moonwalk, s'arrête net sur la pointe des pieds et lance un coup de talon vers le ciel
		K_up = {
			label = "Moonwalk arrière", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(4.5, 5, 1.2, 3), kbBase = 32, kbGrowth = 74, kbAngle = 84, selfVelocity = Vector2.new(-22, 0),
			windup = { Root = { 0, 0, 0, 0, 0.1, 0.3 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 10, 0, 20 }, RE = { 40, 0, 0 }, LS = { 10, 0, -20 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0.4 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
			strike = { Root = { 25, 0, 0, 0, -0.05, 0.4 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { -30, 0, 55 }, RE = { 10, 0, 0 }, LS = { -30, 0, -55 }, LE = { 10, 0, 0 }, RH = { 155, 0, 0 }, RK = { -5, 0, 0 }, RA = { 25, 0, 0 } },
			follow = { Root = { 28, 0, 0, 0, -0.05, 0.45 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { -35, 0, 60 }, RE = { 10, 0, 0 }, LS = { -35, 0, -60 }, LE = { 10, 0, 0 }, RH = { 165, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			trail = "rightFoot", text = "( HI-HI )", hitText = "( POC )",
		},
		-- Ballon invisible : en l'air, reprise de volée dans un ballon que personne ne voit
		K_air = {
			label = "Ballon invisible", startup = 0.16, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3.5, 2.8, 0), kbBase = 30, kbGrowth = 68, kbAngle = 38,
			windup = { Root = { -12, 15, 0 }, Waist = { -10, 10, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 50 }, RE = { 30, 0, 0 }, LS = { 80, 0, -40 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -120, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 22, -10, 0 }, Waist = { 14, -10, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 26, -14, 0 }, Waist = { 16, -12, 0 }, Neck = { -10, 0, 0 }, RS = { -25, 0, 62 }, RE = { 20, 0, 0 }, LS = { 45, 0, -72 }, LE = { 20, 0, 0 }, RH = { 110, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 5, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "rightFoot", hitText = "( POUM )",
		},
		-- Second pied imaginaire : il reprend le ballon invisible du pied gauche (suite de K)
		K_combo2 = {
			label = "Reprise du gauche", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 4, 3, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 32,
			windup = { Root = { 6, 10, 0, 0, -0.12, 0.2 }, Waist = { 8, 8, 0 }, Neck = { -12, 0, 0 }, RS = { 50, 0, 40 }, RE = { 20, 0, 0 }, LS = { -20, 0, -40 }, LE = { 20, 0, 0 }, LH = { -40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 14, 4, 0, 0, -0.1, -0.05 }, Waist = { 14, 2, 0 }, Neck = { -8, 0, 0 }, RS = { -30, 0, 55 }, RE = { 10, 0, 0 }, LS = { 70, 0, -50 }, LE = { 10, 0, 0 }, LH = { 100, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 16, 6, 0, 0, -0.1, 0 }, Waist = { 16, 2, 0 }, Neck = { -6, 0, 0 }, RS = { -35, 0, 60 }, RE = { 10, 0, 0 }, LS = { 80, 0, -55 }, LE = { 10, 0, 0 }, LH = { 112, 0, 0 }, LK = { 0, 0, 0 }, LA = { 18, 0, 0 } },
			trail = "leftFoot", hitText = "( PAM )",
		},
		-- K K ↑K : Ciseau muet, il saute, les jambes se croisent en l'air et la droite frappe en hauteur (finition)
		K_combo3 = {
			label = "Ciseau muet", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 82, kbAngle = 42, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -12, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { 18, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { 105, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 22, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 165, 0, 45 }, RE = { 10, 0, 0 }, LS = { 165, 0, -45 }, LE = { 10, 0, 0 }, RH = { 115, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -25, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "rightFoot", text = "…!", hitText = "( CRAC )",
		},
		-- Trottinette invisible (dash puis K) : un pied pousse, l'autre glisse, et le pied d'appel finit dans le tibia
		K_dash = {
			label = "Trottinette invisible", startup = 0.1, active = 0.22, recovery = 0.3,
			damage = 11, hitbox = box(5.5, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 62, kbAngle = 40, selfVelocity = Vector2.new(52, 0),
			windup = { Root = { -6, 0, 0, 0, -0.25, 0 }, Waist = { -8, 0, 0 }, RS = { 70, 0, 10 }, RE = { 40, 0, 0 }, LS = { 70, 0, -10 }, LE = { 40, 0, 0 }, RH = { -30, 0, 0 }, RK = { -30, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.35, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 75, 0, 10 }, RE = { 35, 0, 0 }, LS = { 75, 0, -10 }, LE = { 35, 0, 0 }, RH = { 70, 0, 0 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.35, -0.25 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 75, 0, 10 }, RE = { 35, 0, 0 }, LS = { 75, 0, -10 }, LE = { 35, 0, 0 }, RH = { 75, 0, 0 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, hitText = "( DRING )",
		},
		-- P puis K : Croc-en-jambe mimé, la pointe du pied fauche la cheville
		PK_combo = {
			label = "Croc-en-jambe mimé", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5.5, 4, 3, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 40,
			windup = { Root = { 2, -12, 0, 0, -0.18, 0.1 }, Waist = { 4, -10, 0 }, Neck = { -8, 10, 0 }, RS = { 20, 0, 40 }, RE = { 50, 0, 0 }, LS = { 20, 0, -40 }, LE = { 50, 0, 0 }, RH = { -15, 0, 15 }, RK = { -60, 0, 0 } },
			strike = { Root = { -6, 12, 0, 0, -0.28, -0.2 }, Waist = { -6, 12, 0 }, Neck = { -12, -10, 0 }, RS = { 10, 0, 50 }, RE = { 30, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 55, 0, -10 }, RK = { -5, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -8, 16, 0, 0, -0.3, -0.24 }, Waist = { -8, 14, 0 }, Neck = { -12, -12, 0 }, RS = { 10, 0, 52 }, RE = { 30, 0, 0 }, LS = { 30, 0, -52 }, LE = { 30, 0, 0 }, RH = { 58, 0, -15 }, RK = { -6, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightFoot", hitText = "( HOP )",
		},
		-- K puis P : Coup de poing à ressort, il remonte un ressort invisible dans son bras et le poing part tout seul
		KP_combo = {
			label = "Poing à ressort", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, -10, 0, 0, -0.18, 0.15 }, Waist = { 4, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 40, 0, 10 }, RE = { 130, 0, 0 }, LS = { 50, 0, 30 }, LE = { 90, 0, 0 }, LW = { 0, 0, 60 } },
			strike = { Root = { -8, 12, 0, 0, -0.25, -0.3 }, Waist = { -10, 16, 0 }, Neck = { 0, -8, 0 }, RS = { 95, 0, -2 }, RE = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			follow = { Root = { -10, 14, 0, 0, -0.27, -0.34 }, Waist = { -12, 18, 0 }, Neck = { 0, -10, 0 }, RS = { 98, 0, -4 }, RE = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			trail = "rightHand", hitText = "( BOING )",
		},

		-- P P P : Claquement de porte, il referme la porte invisible d'un grand revers… elle claque sur l'adversaire
		P_porte2 = {
			label = "Claquement de porte", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { -6, -30, 0, 0, -0.25, 0.1 }, Waist = { -6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 85, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 20, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, 24, 0, 0, -0.3, -0.3 }, Waist = { -10, 28, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, -20 }, RE = { 5, 0, 0 }, RW = { 0, 0, 30 }, LS = { 25, 0, -35 }, LE = { 80, 0, 0 } },
			follow = { Root = { -12, 30, 0, 0, -0.32, -0.34 }, Waist = { -12, 34, 0 }, Neck = { 0, -18, 0 }, RS = { 90, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 25, 0, -35 }, LE = { 80, 0, 0 } },
			trail = "rightHand", fx = { { "ring", color = GHOST, radius = 3, at = "front" }, { "shake", amount = 0.2 } }, hitText = "( VLAN )",
		},
		-- → P P : Vitre invisible, il plaque les deux paumes sur une vitre qui n'existe pas… et la pousse dans le nez d'en face
		P_vitre = {
			label = "Vitre invisible", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(5.5, 4.5, 3, 1), kbBase = 20, kbGrowth = 26, kbAngle = 35, selfVelocity = Vector2.new(14, 0),
			windup = { Root = { 2, 0, 0, 0, -0.15, 0.1 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 25 }, RE = { 100, 0, 0 }, RW = { 85, 0, 0 }, LS = { 70, 0, -25 }, LE = { 100, 0, 0 }, LW = { 85, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.4 }, Waist = { -12, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 95, 0, 14 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, -14 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 0, 0, 0, -0.32, -0.45 }, Waist = { -14, 0, 0 }, Neck = { -16, 0, 6 }, RS = { 98, 0, 16 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 98, 0, -16 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			wobble = true, trail = "bothHands", fx = { { "ring", color = GHOST, radius = 3, at = "front" } }, text = "…", hitText = "( SPLATCH )",
		},
		-- → P P P : Canne à pêche invisible, il ferre d'un grand coup de poignet : l'adversaire mord et décolle (finition)
		P_peche = {
			label = "Canne à pêche invisible", startup = 0.09, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(6, 5, 3.5, 1.5), kbBase = 34, kbGrowth = 74, kbAngle = 82,
			windup = { Root = { -6, -16, 0, 0, -0.3, 0.1 }, Waist = { -10, -16, 0 }, Neck = { -6, 10, 0 }, RS = { 40, 0, 20 }, RE = { 70, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -10 }, LE = { 90, 0, 0 } },
			strike = { Root = { 12, 10, 0, 0, 0.05, 0.1 }, Waist = { 16, 12, 0 }, Neck = { 26, 0, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 110, 0, -20 }, LE = { 80, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 16, 14, 0, 0, 0.1, 0.15 }, Waist = { 20, 16, 0 }, Neck = { 32, 0, 0 }, RS = { 180, 0, 5 }, RE = { 10, 0, 0 }, RW = { -50, 0, 0 }, LS = { 120, 0, -25 }, LE = { 85, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "corde", hideProp = "canne", trail = "rightHand", fx = { { "burst", color = Color3.fromRGB(120, 180, 255), size = 3, at = "front" }, { "symbols", symbols = { "🐟", "💦" }, count = 3, radius = 2.5, at = "front" } }, text = "( ÇA MORD )", hitText = "( FERRÉ )",
		},
		-- ↓ P P : Chien invisible, il siffle, tend une laisse à bout de bras… et le chien qu'on ne voit pas mord le mollet d'en face
		P_chien = {
			label = "Chien invisible", startup = 0.08, active = 0.12, recovery = 0.2,
			damage = 3, hits = 2, hitbox = box(5.5, 4, 3.5, 0.6), kbBase = 18, kbGrowth = 24, kbAngle = 40,
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 0 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.3, -0.3 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, 0, 0, 0, -0.32, -0.35 }, Waist = { -18, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 50, 0, -12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, prop = "corde", hideProp = "canne", windupFx = { { "symbols", symbols = { "🐕", "♪" }, count = 2, radius = 2, color = WHITE } }, fx = { { "symbols", symbols = { "🐕", "💢" }, count = 3, radius = 2.5, at = "front", color = WHITE } }, text = "( SIFFLE )", hitText = "( GRRR-WAF )",
		},
		-- ↓ P P P : Tapis roulant invisible, il court sur place à toute vitesse sans avancer… puis le tapis le catapulte épaule en avant (finition)
		P_tapis = {
			label = "Tapis roulant invisible", startup = 0.1, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4.5, 3.2, 0.8), kbBase = 36, kbGrowth = 72, kbAngle = 24, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -12, 0, 0, 0, -0.25, 0.3 }, Waist = { -10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, LS = { -40, 0, -10 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { -30, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -26, -30, 0, 0, -0.4, -0.4 }, Waist = { -10, -20, 0 }, Neck = { 10, 20, 0 }, RS = { -30, 0, 40 }, RE = { 40, 0, 0 }, LS = { 40, 0, -10 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -28, -34, 0, 0, -0.42, -0.5 }, Waist = { -12, -22, 0 }, Neck = { 12, 22, 0 }, RS = { -40, 0, 45 }, RE = { 35, 0, 0 }, LS = { 35, 0, -10 }, LE = { 112, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, trail = "body", windupFx = { "dust" }, fx = { "dust", { "particles", tex = "smoke", color = WIND, dir = "front", at = "feet", time = 0.3, speed = 16, size = 0.8 } }, text = "( VITESSE 10 )", hitText = "( CATAPULTÉ )",
		},
		-- K K K : Tête dans le ballon, il saute et reprend le ballon invisible de la tête : but ! (finition, fait décoller)
		K_tete = {
			label = "Tête dans le ballon", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(5.5, 5, 3, 1.5), kbBase = 34, kbGrowth = 76, kbAngle = 70, selfVelocity = Vector2.new(10, 30),
			windup = { Root = { 8, 0, 0, 0, -0.5, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 25, 0, 0 }, RS = { -30, 0, 30 }, RE = { 40, 0, 0 }, LS = { -30, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, 0.3, -0.3 }, Waist = { -20, 0, 0 }, Neck = { -35, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { -26, 0, 0, 0, 0.3, -0.35 }, Waist = { -24, 0, 0 }, Neck = { -40, 0, 0 }, RS = { 65, 0, 65 }, RE = { 40, 0, 0 }, LS = { 65, 0, -65 }, LE = { 40, 0, 0 }, RH = { 35, 0, 0 }, RK = { -85, 0, 0 }, LH = { 25, 0, 0 }, LK = { -75, 0, 0 } },
			trail = "head", fx = { { "burst", color = WHITE, size = 3, at = "front" }, { "symbols", symbols = { "⚽", "!" }, count = 3, radius = 2.5, at = "front", color = WHITE } }, text = "…!", hitText = "( BUUUT )",
		},
		-- → K K : Double touche, il salue de la canne puis pique deux fois de suite comme un escrimeur pressé
		K_side2 = {
			label = "Double touche", startup = 0.07, active = 0.14, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(6, 4, 3.5, 0.8), kbBase = 20, kbGrowth = 28, kbAngle = 28, selfVelocity = Vector2.new(16, 0),
			windup = { Root = { 2, -45, 0, 0, -0.2, 0.15 }, Waist = { 2, -25, 0 }, Neck = { 0, 40, 0 }, RS = { 110, 0, -10 }, RE = { 120, 0, 0 }, RW = { -90, 0, 0 }, LS = { 140, 0, -50 }, LE = { 70, 0, 0 } },
			strike = { Root = { -8, -55, 0, 0, -0.45, -0.5 }, Waist = { -4, -30, 0 }, Neck = { 0, 45, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 150, 0, -70 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -6, -52, 0, 0, -0.4, -0.45 }, Waist = { -2, -28, 0 }, Neck = { 0, 44, 0 }, RS = { 70, 0, 0 }, RE = { 60, 0, 0 }, RW = { -88, 0, 0 }, LS = { 150, 0, -70 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			wobble = true, trail = "prop", text = "( SALUT )", hitText = "( TOUCHÉ-TOUCHÉ )",
		},
		-- → K K K : Moulinet de canne, un tour complet sur lui-même, la canne invisible tendue à l'horizontale (finition)
		K_side3 = {
			label = "Moulinet de canne", startup = 0.1, active = 0.2, recovery = 0.32,
			damage = 12, hitbox = box(7, 4, 2.5, 0.8), kbBase = 36, kbGrowth = 80, kbAngle = 32,
			windup = { Root = { 0, -50, 0, 0, -0.25, 0.1 }, Waist = { 0, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 80, 0, 60 }, RE = { 60, 0, 0 }, RW = { -60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -4, 0, 0, 0, -0.2, -0.1 }, Waist = { -4, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 10 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.2, -0.1 }, Waist = { -4, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 10 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", fx = { { "ring", color = GHOST, radius = 4, at = "root" } }, text = "…!", hitText = "( SBAM )",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Ballon éclaté, il gonfle un ballon invisible entre ses mains puis le fait éclater d'une claque
		P_air_side = {
			label = "Ballon éclaté", startup = 0.1, active = 0.08, recovery = 0.18,
			damage = 8, hitbox = box(5, 4, 2.8, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -50 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 90, 0, -12 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 12 }, LE = { 15, 0, 0 }, LW = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -40 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			fx = { { "burst", color = PINK, size = 3, at = "front" }, { "symbols", symbols = { "💥" }, count = 1, radius = 1, at = "front" } }, hitText = "( POP )",
		},
		-- ↑ P en l'air : Fenêtre à guillotine, il pousse une fenêtre invisible vers le haut à deux paumes
		P_air_up = {
			label = "Fenêtre à guillotine", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.6), kbBase = 26, kbGrowth = 45, kbAngle = 86,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 172, 0, 15 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 172, 0, -15 }, LE = { 10, 0, 0 }, LW = { 80, 0, 0 }, RH = { 0, 0, 0 }, RK = { -20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 18 }, RE = { 5, 0, 0 }, RW = { 80, 0, 0 }, LS = { 178, 0, -18 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 }, RH = { -5, 0, 0 }, RK = { -20, 0, 0 }, LH = { 5, 0, 0 }, LK = { -30, 0, 0 } },
			trail = "bothHands", hitText = "( CLAC )",
		},
		-- ↓ P en l'air : Ascenseur qui descend, bien droit, il « descend les étages » à toute vitesse (smash vers le sol)
		P_air_down = {
			label = "Ascenseur qui descend", startup = 0.15, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 0.5, -2.2), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(0, -55),
			windup = { Root = { 0, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -10 }, LE = { 10, 0, 0 }, RH = { 10, 0, 0 }, RK = { -15, 0, 0 }, LH = { 10, 0, 0 }, LK = { -15, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 0, 0, 0 }, RH = { 0, 0, 3 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, -3 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 175, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -8 }, LE = { 0, 0, 0 }, RH = { 0, 0, 3 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 }, LH = { 0, 0, -3 }, LK = { 0, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "body", text = "( DING )", hitText = "( REZ-DE-CHAUSSÉE )",
		},
		-- → K en l'air : Coup de pied dans la porte, pied à plat, il enfonce une porte invisible
		K_air_side = {
			label = "Coup de pied dans la porte", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 30,
			windup = { Root = { -10, 30, 0 }, Waist = { -10, 15, 0 }, Neck = { 0, -20, 0 }, RS = { 60, 0, 40 }, RE = { 70, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, RA = { 20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 25, 40, 0 }, Waist = { 8, 10, 0 }, Neck = { -12, -20, 0 }, RS = { -20, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -80 }, LE = { 10, 0, 0 }, LW = { 0, 0, -50 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 28, 42, 0 }, Waist = { 10, 10, 0 }, Neck = { -14, -20, 0 }, RS = { -25, 0, 64 }, RE = { 20, 0, 0 }, LS = { 42, 0, -82 }, LE = { 10, 0, 0 }, LW = { 0, 0, -50 }, RH = { 72, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "( BLAM )",
		},
		-- ↑ K en l'air : Saut à la corde, il saute une corde imaginaire et finit en salto arrière, pieds au ciel
		K_air_up = {
			label = "Saut à la corde", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 86,
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 30, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -130, 0, 0 }, LH = { 80, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 50 }, RE = { 20, 0, 0 }, LS = { -40, 0, -50 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 140, 0, 0 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 55 }, RE = { 20, 0, 0 }, LS = { -45, 0, -55 }, LE = { 20, 0, 0 }, RH = { 120, 0, 0 }, RK = { -30, 0, 0 }, LH = { 110, 0, 0 }, LK = { -40, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "( HOP-LÀ )",
		},
		-- ↓ K en l'air : Valise qui tombe, il porte au-dessus de sa tête une valise trop lourde et tombe pieds joints (smash vers le sol)
		K_air_down = {
			label = "Valise qui tombe", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 175, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 2, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 175, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -25 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 2, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 170, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			shake = true, trail = "bothFeet", text = "( UMPF )", hitText = "( BADABOUM )",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Mur invisible : les deux paumes à plat, il « trouve » un mur devant lui et le pousse d'un coup sec dans
		-- l'adversaire : le mur devient réel (2 au plus, le plus ancien disparaît ; bloquent projectiles et adversaires)
		S_neutral = {
			label = "Mur invisible", energyCost = 20, kind = "wall", startup = 0.14, active = 0.1, recovery = 0.3,
			hitbox = box(5, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 45, kbAngle = 30,
			damage = 7,
			wall = { size = Vector3.new(1.2, 8, 6), offset = 4, lifetime = 6, max = 2 },
			windup = { Root = { 4, 0, 0, 0, -0.15, 0.15 }, Waist = { 4, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 50, 0, -10 }, RE = { 120, 0, 0 }, RW = { 85, 0, 0 }, LS = { 50, 0, 10 }, LE = { 120, 0, 0 }, LW = { 85, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.45 }, Waist = { -12, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 94, 0, 16 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 94, 0, -16 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.5 }, Waist = { -14, 0, 0 }, Neck = { -2, 8, 0 }, RS = { 100, 0, 20 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 100, 0, -20 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			hold = 0.15, trail = "bothHands", fx = { { "ring", color = GHOST, radius = 3, at = "front" }, { "burst", color = GHOST, size = 2.5, at = "front" } }, text = "…", hitText = "( MUR )",
		},
		-- Tir à la corde : il fait tournoyer un lasso invisible au-dessus du béret et le lance ; s'il accroche,
		-- l'adversaire est tiré brusquement vers lui (sinon Marcel se hisse vers le décor)
		S_side = {
			label = "Tir à la corde", energyCost = 25, kind = "grapple", startup = 0.16, active = 0.1, recovery = 0.32,
			damage = 9, kbBase = 22, kbGrowth = 30, kbAngle = 15,
			grapple = { range = 24, angle = 0, speed = 70, pullEnemy = true },
			windup = { Root = { 4, -10, 0, 0, -0.15, 0.1 }, Waist = { 6, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 175, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.25, -0.3 }, Waist = { -10, 12, 0 }, Neck = { -4, 0, 0 }, RS = { 95, 0, 0 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 12, -6, 0, 0, -0.35, 0.25 }, Waist = { 16, -8, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 15 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			prop = "corde", hideProp = "canne", windupFx = { { "ring", color = ROPE, radius = 2, at = "above" } }, text = "( YIIHA )", hitText = "( TCHAC )",
		},
		-- Contre silencieux : il se fige en statue, puis sa paume part en « STOP » dans la figure d'en face ; un coup
		-- reçu pendant la pose est annulé et il riposte
		S_down = {
			label = "Contre silencieux", energyCost = 20, kind = "counter", startup = 0.04, active = 0.45, recovery = 0.3,
			hitbox = box(5, 4, 2.5, 0.5),
			damage = 7,
			counter = { window = 0.5, text = "…", riposte = { damage = 13, kbBase = 38, kbGrowth = 72, kbAngle = 35, hitText = "( RETOUR À L'ENVOYEUR )" } },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 96, 0, 4 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 }, LW = { 0, 0, 40 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -8, 0, 0, 0, -0.25, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 98, 0, 2 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 }, LW = { 0, 0, 40 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			hold = 0.2, trail = "rightHand", fx = { { "ring", color = GHOST, radius = 2.5, at = "root" }, { "symbols", symbols = { "✋" }, count = 1, radius = 1.5, at = "front", color = WHITE } }, text = "…", hitText = "( STOP )",
		},
		-- Échelle invisible : il agrippe des barreaux imaginaires et grimpe à toute vitesse (la montée frappe)
		-- (gratuit : c'est la remontée)
		S_up = {
			label = "Échelle invisible", energyCost = 0, startup = 0.05, active = 0.32, recovery = 0.3,
			damage = 4, hits = 2, hitbox = box(4, 7, 0.5, 3), kbBase = 28, kbGrowth = 35, kbAngle = 88, selfVelocity = Vector2.new(4, 92),
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -10 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.3, 0 }, Neck = { 25, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -10 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -100, 0, 0 }, LH = { 10, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.3, 0 }, Neck = { 25, 0, 0 }, RS = { 130, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -10 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -20, 0, 0 }, LH = { 80, 0, 0 }, LK = { -100, 0, 0 } },
			trail = "bothHands", text = "( GRIMPE )", hitText = "( TOC TOC )",
		},
		-- Le Piano (en l'air + ↓ + S) : il pousse un piano imaginaire par-dessus bord… et tombe avec, de tout son poids
		S_air_down = {
			label = "Le Piano", energyCost = 25, startup = 0.14, active = 0.35, recovery = 0.35,
			damage = 12, hitbox = box(5, 4, 0.5, -2), kbBase = 25, kbGrowth = 55, kbAngle = -70, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { 6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 95, 0, 20 }, RE = { 20, 0, 0 }, RW = { 80, 0, 0 }, LS = { 95, 0, -20 }, LE = { 20, 0, 0 }, LW = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 160, 0, 60 }, RE = { 20, 0, 0 }, LS = { 160, 0, -60 }, LE = { 20, 0, 0 }, RH = { -2, 0, 5 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -5 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -32, 0, 0 }, RS = { 165, 0, 65 }, RE = { 20, 0, 0 }, LS = { 165, 0, -65 }, LE = { 20, 0, 0 }, RH = { -2, 0, 8 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -8 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "body", fx = { { "shake", amount = 0.6 }, { "ring", color = GHOST, radius = 5, at = "feet" } }, text = "…", hitText = "( PLONK )",
		},
		-- Peau de banane invisible (esquive puis S) : il pèle une banane imaginaire, la mange et jette la peau devant lui
		S_dodge = {
			label = "Peau de banane invisible", energyCost = 20, kind = "trap", startup = 0.14, active = 0, recovery = 0.3,
			damage = 4, kbBase = 22, kbGrowth = 25, kbAngle = 80,
			status = { name = "slippery", duration = 2 },
			trap = { size = Vector3.new(3, 1.5, 6), offset = 3, lifetime = 10, max = 1, color = BANANA,
				visual = { shape = "ball", size = 0.9, color = BANANA, transparency = 0.8, trail = false,
					parts = { { "block", Vector3.new(0.9, 0.1, 0.3), Vector3.new(0.6, -0.3, 0), BANANA }, { "block", Vector3.new(0.9, 0.1, 0.3), Vector3.new(-0.6, -0.3, 0), BANANA } } } },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, -30 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 10 }, LE = { 100, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.15, -0.1 }, Waist = { -4, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 95, 0, 30 }, RE = { 10, 0, 0 }, RW = { 30, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			follow = { Root = { -4, 12, 0, 0, -0.15, -0.1 }, Waist = { -4, 12, 0 }, Neck = { 0, -12, 0 }, RS = { 80, 0, 40 }, RE = { 15, 0, 0 }, RW = { 40, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			text = "( MIAM )", hitText = "( WOUPS )",
		},
		-- Vent violent (S maintenu) : il gonfle les joues, se plante sur ses jambes et pousse une bourrasque à deux paumes
		S_hold = {
			label = "Vent violent", energyCost = 35, startup = 0.22, active = 0.25, recovery = 0.4,
			damage = 9, hitbox = box(9, 5, 5, 0.8), kbBase = 55, kbGrowth = 70, kbAngle = 18,
			windup = { Root = { 8, 0, 0, 0, -0.3, 0.3 }, Waist = { 16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 40, 0, 70 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			strike = { Root = { -10, 0, 0, 0, -0.45, -0.35 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 10 }, RE = { 5, 0, 0 }, RW = { 85, 0, 0 }, LS = { 92, 0, -10 }, LE = { 5, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -12, 0, 0, 0, -0.48, -0.4 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 12 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, -12 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			shake = true, wobble = true,
			fx = { { "particles", tex = "smoke", color = WIND, dir = "front", at = "front", time = 0.35, speed = 30, size = 1.2, rate = 90 }, { "swarm", shape = "flat", color = Color3.fromRGB(150, 190, 90), count = 6, distance = 18, size = 0.5, height = 2 } },
			text = "( FFFFFF )", hitText = "( WOUSH )",
		},
		-- Vélo invisible (→→S) : assis sur une selle qui n'existe pas, il pédale à toute allure, guidon en main
		S_dash = {
			label = "Vélo invisible", energyCost = 25, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 10, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 60, kbAngle = 32, selfVelocity = Vector2.new(62, 0), invuln = 0.15,
			windup = { Root = { -10, 0, 0, 0, -0.55, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 75, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -15 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.55, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 80, 0, 15 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -15 }, LE = { 35, 0, 0 }, LW = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 90, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.55, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 80, 0, 15 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -15 }, LE = { 35, 0, 0 }, LW = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			wobble = true, fx = { "dust" }, text = "( DRING DRING )", hitText = "( PROUT-PROUT )",
		},
		-- Piano lâché (S en l'air) : il fait signe à quelqu'un là-haut… et un piano invisible tombe devant lui
		S_air = {
			label = "Piano lâché", energyCost = 30, kind = "projectile", startup = 0.18, active = 0, recovery = 0.35,
			damage = 12, kbBase = 26, kbGrowth = 55, kbAngle = 70,
			status = { name = "stunned", duration = 0.6 },
			projectile = { speed = 55, gravity = 50, lifetime = 0.9, size = 3.4, color = BLACK, rain = { count = 1, spread = 1, ahead = 7, height = 20 },
				visual = { shape = "block", size = 3, color = Color3.fromRGB(40, 40, 45), transparency = 0.72, trail = false,
					parts = { { "block", Vector3.new(3.1, 0.3, 1.2), Vector3.new(0, 1.1, -0.6), WHITE }, { "block", Vector3.new(0.3, 1.2, 0.3), Vector3.new(-1.2, -2, 0), BLACK }, { "block", Vector3.new(0.3, 1.2, 0.3), Vector3.new(1.2, -2, 0), BLACK } } } },
			windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 10 }, RE = { 10, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 100, 0, 10 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			text = "( LÂCHEZ TOUT )", hitText = "( PLONK )",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Poussée du mur : il plaque un mur invisible contre l'adversaire et pousse de tout son corps
		S_finish_mur = {
			label = "Poussée du mur", energyCost = 20, startup = 0.14, active = 0.16, recovery = 0.32,
			damage = 10, hitbox = box(5, 6, 3, 1), kbBase = 34, kbGrowth = 66, kbAngle = 22, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { 4, 0, 0, 0, -0.25, 0.2 }, Waist = { 6, 0, 0 }, RS = { 70, 0, 20 }, RE = { 120, 0, 0 }, RW = { 80, 0, 0 }, LS = { 70, 0, -20 }, LE = { 120, 0, 0 }, LW = { 80, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.45, -0.5 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 15 }, RE = { 5, 0, 0 }, RW = { 85, 0, 0 }, LS = { 100, 0, -15 }, LE = { 5, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -24, 0, 0, 0, -0.5, -0.6 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 100, 0, 15 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 100, 0, -15 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			fx = { { "ring", color = GHOST, radius = 4, at = "front" } }, text = "( HAN )", hitText = "( SPLATCH )",
		},
		-- Coup de lasso : la corde invisible claque de bas en haut comme un fouet et fait décoller l'adversaire
		S_finish_corde = {
			label = "Coup de lasso", energyCost = 20, startup = 0.12, active = 0.14, recovery = 0.3,
			damage = 9, hitbox = box(6, 5, 3.5, 1.5), kbBase = 32, kbGrowth = 60, kbAngle = 78,
			windup = { Root = { -6, -10, 0, 0, -0.4, 0.1 }, Waist = { -14, -10, 0 }, RS = { -20, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { 8, 10, 0, 0, 0.1, -0.15 }, Waist = { 12, 12, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 60, 0, 0 } },
			follow = { Root = { 10, 12, 0, 0, 0.15, -0.18 }, Waist = { 14, 14, 0 }, Neck = { 26, 0, 0 }, RS = { 180, 0, 5 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 5, 0, -42 }, LE = { 60, 0, 0 } },
			prop = "corde", hideProp = "canne", trail = "rightHand", hitText = "( FLAC )",
		},

		------------------------------------------------------------------ Supers
		-- Le Silence : un doigt sur la bouche… plus un bruit ; l'adversaire touché est réduit au silence
		-- (muet : plus de spéciaux pendant 3 s)
		SUPER = {
			label = "Le Silence", superCost = 100, startup = 0.4, active = 0.2, recovery = 0.6,
			damage = 18, hitbox = box(50, 36, 0, 8), kbBase = 10, kbGrowth = 10, kbAngle = 60,
			status = { name = "muted", duration = 3 },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 130, 0, -35 }, RE = { 145, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 130, 0, -38 }, RE = { 150, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 130, 0, -38 }, RE = { 150, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -45 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			hold = 0.5, windupFx = { "super" },
			fx = { { "screen", color = Color3.fromRGB(10, 10, 20), alpha = 0.6, time = 0.8 }, { "symbols", symbols = { "🤫", "…", "🔇" }, count = 8, radius = 5, color = WHITE } },
			text = "CHUUUT…", hitText = "( … )",
		},
		-- Super ↑ : il appuie sur le bouton d'un ascenseur invisible, la cabine fuse vers le ciel et il en soulève
		-- le plafond à deux paumes ; tout ce qui est au-dessus monte au dernier étage avec lui
		SUPER_up = {
			label = "L'Ascenseur invisible !", superCost = 100, startup = 0.3, active = 0.3, recovery = 0.55,
			damage = 22, hitbox = box(6.5, 12, 1.5, 5), kbBase = 46, kbGrowth = 95, kbAngle = 88, invuln = 0.3,
			windup = { Root = { 0, -15, 0, 0, -0.1, 0.1 }, Waist = { 2, -12, 0 }, Neck = { 22, 10, 0 }, RS = { 110, 0, 5 }, RE = { 30, 0, 0 }, RW = { -40, 0, 0 }, LS = { 10, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.4, 0 }, Waist = { 0, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.5, 0 }, Waist = { 0, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 182, 0, 14 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 182, 0, -14 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			hold = 0.3, selfVelocity = Vector2.new(0, 60), trail = "bothHands",
			windupFx = { "super", { "text", text = "[ 12e ÉTAGE ]", color = WHITE, at = "above" } },
			fx = { { "pillar", color = GHOST, height = 26, width = 4, at = "root" }, { "ring", color = GHOST, radius = 5, at = "feet" }, { "symbols", symbols = { "▲", "( DING )" }, count = 5, radius = 3, color = WHITE } },
			text = "…", hitText = "[ DERNIER ÉTAGE ]",
		},
		-- La Boîte ultime : il mime une cage tout autour de l'adversaire, puis la secoue et cogne dedans
		SUPER_down = {
			label = "La Boîte ultime", superCost = 100, startup = 0.3, active = 0.8, recovery = 0.5,
			damage = 4, hits = 6, pull = true, hitbox = box(5, 5, 2.4, 1), kbBase = 14, kbGrowth = 20, kbAngle = 60,
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 40 }, RE = { 30, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, -40 }, LE = { 30, 0, 0 }, LW = { 85, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.2 }, Waist = { -8, 12, 0 }, Neck = { -4, 0, 0 }, RS = { 95, 0, 0 }, RE = { 10, 0, 0 }, RW = { 85, 0, 0 }, LS = { 120, 0, -10 }, LE = { 60, 0, 0 }, LW = { 85, 0, 0 } },
			follow = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -8, -12, 0 }, Neck = { -4, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, 0 }, LE = { 10, 0, 0 }, LW = { 85, 0, 0 } },
			wobble = true, windupFx = { "super" }, fx = { { "ring", color = GHOST, radius = 4, at = "front" }, { "symbols", symbols = { "▢", "( TOC )" }, count = 6, radius = 3, at = "front", color = GHOST } },
			text = "( LA BOÎTE )", hitText = "( BOÎTE )",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise invisible : il lance une corde mimée autour de l'adversaire et serre le nœud… qui tient vraiment
		GRAB = {
			label = "Prise invisible", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 2, 0, 0, 0, -0.1, 0.05 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, 40 }, RE = { 30, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.18, -0.25 }, Waist = { -8, 0, 0 }, RS = { 85, 0, -20 }, RE = { 70, 0, 0 }, LS = { 85, 0, 20 }, LE = { 70, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, RS = { 80, 0, -10 }, RE = { 90, 0, 0 }, LS = { 80, 0, 10 }, LE = { 90, 0, 0 } },
			text = "…", hitText = "( NŒUD )",
		},
		-- ✋ puis → : Tir à la corde, il prend appui, tire de toutes ses forces… et lâche : l'adversaire part au loin
		THROW_fwd = {
			label = "Tir à la corde", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 15,
			carry = { { 0, 2.4, 0.4 }, { 0.2, 1.4, 0.3 }, { 0.34, 4.0, 0.6 } },
			windup = { Root = { 16, 0, 0, 0, -0.4, 0.4 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 70, 0, 0 }, RE = { 100, 0, 0 }, LS = { 85, 0, 0 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 20 }, RE = { 5, 0, 0 }, LS = { 95, 0, -20 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 0, 0, 0, -0.3, -0.35 }, Waist = { -12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 100, 0, 40 }, RE = { 5, 0, 0 }, LS = { 100, 0, -40 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			text = "( HISSE… )", hitText = "( ET HOP )",
		},
		-- ✋ puis ← : Valise lourde, il soulève la victime comme une valise trop lourde, en peinant, et la jette derrière lui
		THROW_back = {
			label = "Valise lourde", kind = "throw", back = true, startup = 0.44, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 40,
			carry = { { 0, 2.2, 0.3 }, { 0.2, 1.6, 0.6 }, { 0.32, 0.4, 2.6 }, { 0.44, -2.6, 0.8 } },
			windup = { Root = { -14, 0, 0, 0, -0.6, 0.1 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 10, 0, 0 }, LS = { 30, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 10, 30, 0, 0, -0.2, 0.2 }, Waist = { 20, 40, 0 }, Neck = { 20, 0, 0 }, RS = { 190, 0, 10 }, RE = { 20, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { 14, 40, 0, 0, -0.2, 0.25 }, Waist = { 24, 50, 0 }, Neck = { 24, 0, 0 }, RS = { 200, 0, 10 }, RE = { 20, 0, 0 }, LS = { 30, 0, -65 }, LE = { 30, 0, 0 } },
			shake = true, text = "( HNNNGH )", hitText = "( BADABOUM )",
		},
		-- ✋ puis ↑ : Lâcher de ballon, il attache la victime à un ballon invisible et la regarde s'envoler en saluant
		THROW_up = {
			label = "Lâcher de ballon", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.38,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 90,
			carry = { { 0, 2.2, 0.3 }, { 0.16, 1.6, 1.4 }, { 0.34, 1.2, 4.2 } },
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 0 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 0 }, LE = { 80, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -30 }, LE = { 30, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 10, 0, -30 }, LE = { 30, 0, 0 } },
			prop = "ballon", hideProp = "canne", text = "( AU REVOIR )", hitText = "( FLOUP )",
		},
		-- ✋ puis ↓ : Coincé dans la boîte, il plaque la victime au sol et referme les parois invisibles sur elle
		THROW_down = {
			label = "Coincé dans la boîte", kind = "throw", startup = 0.42, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 26, kbGrowth = 25, kbAngle = 75,
			status = { name = "rooted", duration = 1.2 },
			carry = { { 0, 2.2, 0.3 }, { 0.16, 2.0, 1.2 }, { 0.3, 2.4, -1.6 }, { 0.42, 2.4, -2.0 } },
			windup = { Root = { 6, 0, 0, 0, 0, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 10 }, RE = { 30, 0, 0 }, LS = { 160, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.75, -0.3 }, Waist = { -20, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 50 }, RE = { 30, 0, 0 }, RW = { 85, 0, 0 }, LS = { 70, 0, -50 }, LE = { 30, 0, 0 }, LW = { 85, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.8, -0.35 }, Waist = { -22, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 5 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 75, 0, -5 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } },
			fx = { { "ring", color = GHOST, radius = 3, at = "front" } }, text = "( CLAC CLAC )", hitText = "( COINCÉ )",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "la_boite", label = "La Boîte", sequence = { "back", "forward", "back" },
			-- il enferme l'adversaire dans une boîte invisible, la plie encore et encore jusqu'à la taille d'un
			-- mouchoir, et la range dans sa poche
			scene = {
				{ "spawn", at = "target", offset = Vector3.zero, life = 2.2, pieces = {
					{ "Boite", "", "block", Vector3.new(4, 6, 4), Vector3.zero, Vector3.zero, GHOST, "Glass", { transparency = 0.82 } },
				} },
				{ "fxAttacker", { "text", text = "( UNE BOÎTE… )", color = WHITE } },
				{ "wait", 0.5 },
				{ "shrink", 0.6, time = 0.4 },
				{ "fx", { "ring", color = GHOST, radius = 2.5, at = "root" } },
				{ "shrink", 0.3, time = 0.4 },
				{ "fx", { "ring", color = GHOST, radius = 1.5, at = "root" } },
				{ "shrink", 0.12, time = 0.4 },
				{ "text", "PLIÉ" },
				{ "move", to = "attacker", offset = Vector3.new(0, 0, 0), time = 0.5 },
				{ "hide" },
				{ "fxAttacker", { "symbols", symbols = { "🤫", "✨" }, count = 4, color = WHITE } },
				{ "fxAttacker", { "text", text = "( DANS LA POCHE )", color = WHITE } },
				{ "wait", 1 },
			},
		},
		{
			id = "le_piano", label = "Le Piano", sequence = { "down", "down", "forward" },
			-- un piano invisible tombe du ciel : on n'entend qu'un « plonk », l'adversaire reste aplati comme un tapis
			scene = {
				{ "fxAttacker", { "text", text = "( LÂCHEZ TOUT ! )", color = WHITE } },
				{ "spawn", at = "above", offset = Vector3.new(0, 4, 0), life = 1.2, pieces = {
					{ "Piano", "", "block", Vector3.new(5, 3.5, 3), Vector3.zero, Vector3.zero, Color3.fromRGB(40, 40, 45), "Glass", { transparency = 0.75 } },
					{ "Clavier", "", "block", Vector3.new(5, 0.3, 1.2), Vector3.new(0, -0.6, -1.9), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.6 } },
				} },
				{ "wait", 0.6 },
				{ "squash" },
				{ "spawn", at = "target", offset = Vector3.new(0, -1.5, 0), life = 3, pieces = {
					{ "PianoAuSol", "", "block", Vector3.new(5, 3.5, 3), Vector3.zero, Vector3.zero, Color3.fromRGB(40, 40, 45), "Glass", { transparency = 0.8 } },
				} },
				{ "fx", { "shake", amount = 0.8 } },
				{ "text", "plonk." },
				{ "fx", { "burst", color = GHOST, size = 5, at = "feet" } },
				{ "wait", 0.8 },
				{ "fxAttacker", { "symbols", symbols = { "🎹", "…" }, count = 4, color = WHITE } },
				{ "wait", 0.8 },
			},
		},
		{
			id = "le_ballon", label = "Le Ballon", sequence = { "up", "back", "up" },
			-- il gonfle l'adversaire à la pompe invisible comme un ballon de baudruche et le lâche au vent
			scene = {
				{ "fxAttacker", { "text", text = "( POMPE… POMPE… )", color = WHITE } },
				{ "grow", 1.3, time = 0.4 },
				{ "fx", { "ring", color = PINK, radius = 3, at = "root" } },
				{ "grow", 1.7, time = 0.4 },
				{ "color", PINK },
				{ "material", "Glass" },
				{ "fx", { "ring", color = PINK, radius = 4, at = "root" } },
				{ "text", "GONFLÉ !" },
				{ "wait", 0.4 },
				{ "lift", 4, time = 0.8 },
				{ "fxAttacker", { "symbols", symbols = { "👋" }, count = 2, color = WHITE } },
				{ "launch", Vector3.new(25, 70, 0), time = 1.6 },
				{ "wait", 0.3 },
			},
		},
	},

	-- Mécanique « Murs invisibles » : 2 murs au plus (voir server/Specials.lua)
	passive = { kind = "walls", name = "Murs invisibles", icon = "🧱", max = 2 },

	-- Recharge ⚡ : il se branche une pompe à vélo invisible dans le nombril et se regonfle en pompant,
	-- pendant qu'une bulle de dialogue vide grossit au-dessus de sa tête
	charge = {
		label = "Pompe à vélo",
		loop = 1.2,
		lockWrist = true,
		color = Color3.fromRGB(200, 225, 255),
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 120, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 80 }, LS = { 115, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 0.3, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 45, 0, -20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 80 }, LS = { 40, 0, 20 }, LE = { 70, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 0.6, { Root = { 4, 0, 0, 0, -0.05, 0 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 80 }, LS = { 115, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 0.9, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 45, 0, -20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 80 }, LS = { 40, 0, 20 }, LE = { 70, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 1.2, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 120, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 80 }, LS = { 115, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, -80 } } },
		},
		beats = {
			{ 0.3, { "symbols", symbols = { "💬" }, count = 1, radius = 1.5, at = "above", color = WHITE } },
			{ 0.9, { "particles", tex = "smoke", color = WHITE, dir = "all", at = "root", time = 0.15, speed = 3, size = 0.4 } },
		},
	},

	-- Manies au repos : il tâte un mur invisible, tire une corde imaginaire, s'appuie sur sa canne qui n'existe pas
	fidgets = {
		{ duration = 2.4, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 0, 0, 0 }, RS = { 90, 0, 20 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 90, 0, -20 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 0.9, { Neck = { 0, 15, 0 }, RS = { 120, 0, 25 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 85, 0, -20 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 1.4, { Neck = { 0, -15, 0 }, RS = { 85, 0, 20 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 120, 0, -25 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 1.9, { Neck = { 10, 0, 0 }, RS = { 90, 0, 40 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 90, 0, -40 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 2.4, {} },
		} },
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.35, { Root = { -6, 0, 0, 0, -0.15, -0.1 }, Waist = { -6, 0, 0 }, RS = { 140, 0, 5 }, RE = { 30, 0, 0 }, LS = { 120, 0, -5 }, LE = { 40, 0, 0 } } },
			{ 0.8, { Root = { 10, 0, 0, 0, -0.25, 0.2 }, Waist = { 14, 0, 0 }, RS = { 90, 0, 5 }, RE = { 100, 0, 0 }, LS = { 140, 0, -5 }, LE = { 30, 0, 0 } } },
			{ 1.25, { Root = { 12, 0, 0, 0, -0.3, 0.25 }, Waist = { 16, 0, 0 }, RS = { 140, 0, 5 }, RE = { 30, 0, 0 }, LS = { 90, 0, -5 }, LE = { 100, 0, 0 } } },
			{ 1.7, { Root = { 14, 0, 0, 0, -0.32, 0.3 }, Waist = { 18, 0, 0 }, RS = { 90, 0, 5 }, RE = { 100, 0, 0 }, LS = { 140, 0, -5 }, LE = { 30, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 2.4, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Root = { 0, 0, 6, 0.1, -0.05, 0 }, Waist = { 0, 0, 6 }, Neck = { 0, 0, 8 }, RS = { 30, 0, 25 }, RE = { 20, 0, 0 }, LS = { 0, 0, -10 }, LE = { 100, 0, 0 } } },
			{ 1.6, { Root = { 0, 0, 8, 0.12, -0.05, 0 }, Waist = { 0, 0, 8 }, Neck = { 0, 10, 10 }, RS = { 30, 0, 25 }, RE = { 20, 0, 0 }, LS = { 0, 0, -10 }, LE = { 105, 0, 0 } } },
			{ 1.8, { Root = { 0, 0, -10, -0.2, -0.2, 0 }, Waist = { -10, 0, -4 }, Neck = { 10, 0, -10 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 } } },
			{ 2.4, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : il tient à deux mains une corde invisible bien tendue, penché en arrière
data.grabHold = {
	Root = { 8, 10, 0, 0, -0.18, 0.2 },
	Waist = { 14, 6, 0 },
	Neck = { 8, -6, 0 },
	RS = { 80, 0, -8 },
	RE = { 45, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 86, 0, 8 },
	LE = { 65, 0, 0 },
}

-- Retour 🪂 : il descend lentement accroché à un ballon invisible, le lâche, ouvre une porte invisible et salue
-- (la plateforme elle-même est presque invisible : un plancher de verre)
data.respawn = {
	duration = 2.0,
	platform = { pieces = {
		{ "Plancher", "base", "block", Vector3.new(6, 0.6, 4), Vector3.new(0, -0.3, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.7 } },
		{ "Bord", "", "block", Vector3.new(6.2, 0.08, 4.2), Vector3.new(0, 0.02, 0), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.5 } },
		{ "Ficelle", "", "cyl", Vector3.new(4, 0.06, 0.06), Vector3.new(1.2, 6.8, 0), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.5 } },
		{ "Ballon", "", "ball", Vector3.new(2.6, 3.2, 2.6), Vector3.new(1.2, 10.2, 0), Vector3.zero, PINK, "Glass", { transparency = 0.8 } },
		{ "Porte", "", "block", Vector3.new(0.2, 5.5, 2.6), Vector3.new(-2.6, 2.75, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.88 } },
		{ "Poignee", "", "ball", Vector3.new(0.25, 0.25, 0.25), Vector3.new(-2.45, 2.6, -0.9), Vector3.zero, GHOST, "Glass", { transparency = 0.6 } },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 3, 0, 0, 0 }, Waist = { 0, 0, 3 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -30 }, LE = { 20, 0, 0 } } },
		{ 0.5, { Root = { 0, 0, -3, 0, 0, 0 }, Waist = { 0, 0, -3 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -30 }, LE = { 20, 0, 0 } } },
		{ 0.75, { Neck = { 30, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 40 }, LS = { 10, 0, -30 }, LE = { 20, 0, 0 } } },
		{ 1.0, { Root = { 0, 30, 0 }, Waist = { 0, 20, 0 }, Neck = { 0, -30, 0 }, RS = { 20, 0, 20 }, RE = { 40, 0, 0 }, LS = { 80, 0, -40 }, LE = { 30, 0, 0 }, LW = { 0, 0, -60 } } },
		{ 1.25, { Root = { 0, 10, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, -10, 0 }, RS = { 20, 0, 20 }, RE = { 40, 0, 0 }, LS = { 70, 0, -90 }, LE = { 20, 0, 0 }, LW = { 0, 0, -60 } } },
		{ 1.55, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, -30 }, RE = { 100, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 } } },
		{ 1.75, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, -30 }, RE = { 100, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 } } },
		{ 2.0, {} },
	},
	beats = {
		{ 0.75, { "symbols", symbols = { "🎈" }, count = 1, radius = 2, at = "above", color = PINK } },
		{ 1.0, { "text", text = "( GRIIINCE )", color = WHITE } },
		{ 1.55, { "symbols", symbols = { "👏", "…" }, count = 4, radius = 3, color = WHITE } },
	},
}

-- Arbre d'enchaînements : après le coup de gauche, le bouton (avec sa direction) lance le coup de droite.
-- P P P P : claque, canne, porte claquée, grand coup de canne · → P P P : corde (ramène), vitre, canne à pêche (au ciel)
-- ↓ P P P : marche, chien invisible, tapis roulant (à l'horizontale) · K K K : pied, reprise, tête dans le ballon
-- (↑ K : ciseau muet) · → K K K : fente, double touche, moulinet. Les S finissent : Poussée du mur ou Coup de lasso.
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P P P P : fausse claque, canne invisible, claquement de porte, grand coup de canne (finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_mur" },
	P_combo2 = { P = "P_porte2", K = "K_combo2", up_K = "K_up", S = "S_finish_corde" },
	P_porte2 = { P = "P_combo3", K = "K_tete", S = "S_finish_mur" },
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_corde" },
	KP_combo = { P = "P_combo3", K = "K_tete", S = "S_finish_mur" },
	-- K K K : pied imaginaire, reprise du gauche, tête dans le ballon (↑ K : ciseau muet)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_mur" },
	K_combo2 = { K = "K_tete", up_K = "K_combo3", P = "P_porte2", S = "S_finish_corde" },
	-- → P P P : corde tirée (ramène), vitre invisible, canne à pêche (finition vers le ciel)
	P_side = { P = "P_vitre", K = "K_side", S = "S_finish_mur" },
	P_vitre = { P = "P_peche", K = "K_side2", S = "S_finish_corde" },
	-- ↓ P P P : marche d'escalier, chien invisible, tapis roulant (finition à l'horizontale)
	P_down = { P = "P_chien", K = "K_down", S = "S_finish_corde" },
	P_chien = { P = "P_tapis", K = "K_tete", S = "S_finish_mur" },
	-- → K K K : canne (fente), double touche, moulinet de canne (finition)
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_mur" },
	K_side2 = { K = "K_side3", P = "P_vitre", S = "S_finish_corde" },
	-- autres départs
	P_up = { K = "K_up", S = "S_finish_corde" },
	K_down = { P = "P_up", K = "K_up", S = "S_finish_corde" },
	K_up = { S = "S_finish_corde" },
	P_dash = { P = "P_porte2", K = "K_side", S = "S_finish_mur" },
	K_dash = { P = "P_up", K = "K_up", S = "S_finish_corde" },
	-- en l'air ; les smashs ↓ sont des finitions sans suite
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

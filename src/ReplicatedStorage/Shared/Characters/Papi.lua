-- Papi DJ (Gérard, 78 ans) : lunettes noires, casque énorme, chaînes dorées, le dos en compote mais le groove
-- intact. Sa Playlist alterne 3 morceaux (Rap = vitesse, Slow = soin, Techno = dégâts). Arme sortie de la
-- Caisse Bizarre : vinyles tranchants & platine.
--
-- Format : voir docs/fiche-perso.md et Characters/Gege.lua (clés de coups, poses, links, effets).
-- Mécanique « playlist » (server/Mechanics.lua) : les coups à selfEffect = { nextTrack = true } passent au
-- morceau suivant (Drop des basses →S, Changer de piste S maintenu).
-- Style « grandpa » : voûté, la main gauche souvent posée dans le bas du dos, hanches raides qui se dandinent.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(240, 200, 170)
local SKIN_DARK = Color3.fromRGB(225, 160, 140)
local SHIRT = Color3.fromRGB(120, 40, 160)
local TROUSERS = Color3.fromRGB(190, 170, 130)
local TARTAN = Color3.fromRGB(150, 40, 40)
local GOLD = Color3.fromRGB(255, 200, 40)
local BLACK = Color3.fromRGB(25, 25, 30)
local SILVER = Color3.fromRGB(200, 205, 215)
local WHITE = Color3.fromRGB(240, 240, 245)
local PINK = Color3.fromRGB(255, 60, 200)
local BLUE = Color3.fromRGB(60, 200, 255)
local RED = Color3.fromRGB(220, 40, 40)

-- Vinyle lancé : une étiquette rouge au centre d'un disque noir (vu de face par la caméra), qui tourne
local VINYL = { shape = "ball", size = 0.5, color = RED, spin = 14, parts = {
	{ "block", Vector3.new(1.7, 0.7, 0.1), Vector3.zero, BLACK },
	{ "block", Vector3.new(0.7, 1.7, 0.1), Vector3.zero, BLACK },
	{ "block", Vector3.new(1.25, 1.25, 0.1), Vector3.zero, BLACK },
} }

-- Mur d'enceintes : deux baffles empilés autour d'un caisson de basse
local SPEAKERS = { shape = "block", size = 2.6, color = BLACK, trail = false, parts = {
	{ "block", Vector3.new(2.6, 1.7, 1.56), Vector3.new(0, -2.15, 0), BLACK },
	{ "block", Vector3.new(2.6, 1.7, 1.56), Vector3.new(0, 2.15, 0), BLACK },
	{ "ball", Vector3.new(1.9, 1.9, 1.9), Vector3.new(0, 0, 0.2), Color3.fromRGB(70, 70, 80) },
	{ "ball", Vector3.new(1.1, 1.1, 1.1), Vector3.new(0, -2.15, 0.35), Color3.fromRGB(70, 70, 80) },
	{ "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0, 2.15, 0.45), PINK, "Neon" },
} }

local CASSETTE = Color3.fromRGB(90, 70, 50) -- radiocassette (arme n° 3)

-- Boule à facettes lancée (arme n° 2) : une sphère argentée hérissée de miroirs colorés, qui tourne
local BOULE = { shape = "ball", size = 1.6, color = SILVER, material = "Foil", spin = 12, parts = {
	{ "block", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.7, 0.5, 0), WHITE },
	{ "block", Vector3.new(0.45, 0.45, 0.45), Vector3.new(-0.65, -0.5, 0.3), PINK },
	{ "block", Vector3.new(0.4, 0.4, 0.4), Vector3.new(0.2, -0.75, -0.5), BLUE },
} }
-- Note de musique (arme n° 3) : une boule rose fluo marquée d'une croche
local NOTE = { shape = "ball", size = 1.0, color = PINK, neon = true, text = "♪" }
-- Cassette audio lancée (arme n° 3) : un boîtier brun avec ses deux bobines
local CASSETTE_VISUAL = { shape = "block", size = 0.6, color = CASSETTE, spin = 12, parts = {
	{ "block", Vector3.new(1.3, 0.8, 0.15), Vector3.zero, CASSETTE },
	{ "ball", Vector3.new(0.3, 0.3, 0.2), Vector3.new(-0.32, 0, -0.08), WHITE },
	{ "ball", Vector3.new(0.3, 0.3, 0.2), Vector3.new(0.32, 0, -0.08), WHITE },
} }

local data = {
	id = "Papi",
	name = "Papi DJ",
	costume = "Papi",
	style = "grandpa",
	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : bagarre de bal du samedi soir
	-- Ses propres J / K et ses combos sans arme (les L et les Y restent ceux de moves). Sans ses disques, Gérard se
	-- bat comme au bal de 1962 : pichenettes, doigt grondeur, taloches à l'ancienne, coups de montre, valse musette
	-- et claquement de bretelles. Le dos craque à chaque coup, mais le groove reste.
	bare = {
		moves = {
			-- J : pichenette sur le nez, main gauche dans le bas du dos, « de mon temps… »
			P_neutral = {
				label = "Pichenette", startup = 0.07, active = 0.07, recovery = 0.14,
				damage = 5, hitbox = box(4, 3, 2.7, 1), kbBase = 18, kbGrowth = 22, kbAngle = 25,
				windup = { Root = { -4, -10, 0, 0, -0.25, 0.1 }, Waist = { -12, -10, 0 }, Neck = { 10, 10, 0 }, RS = { 70, 0, 10 }, RE = { 100, 0, 0 }, RW = { 30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -6, 10, 0, 0, -0.25, -0.2 }, Waist = { -14, 10, 0 }, Neck = { 6, -6, 0 }, RS = { 100, 0, -5 }, RE = { 20, 0, 0 }, RW = { -40, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				follow = { Root = { -6, 12, 0, 0, -0.25, -0.22 }, Waist = { -14, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 102, 0, -6 }, RE = { 22, 0, 0 }, RW = { -50, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				trail = "rightHand", hitText = "PITCH !",
			},
			-- J J : doigt grondeur, l'index s'agite sous le nez de l'adversaire et le pique deux fois
			P_combo2 = {
				label = "Doigt grondeur", startup = 0.06, active = 0.14, recovery = 0.16,
				damage = 6, hits = 2, hitbox = box(4, 3, 2.6, 1.2), kbBase = 16, kbGrowth = 20, kbAngle = 30,
				windup = { Root = { -2, -6, 0, 0, -0.25, 0.08 }, Waist = { -10, -6, 0 }, Neck = { 14, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -6, 6, 0, 0, -0.25, -0.2 }, Waist = { -16, 6, 0 }, Neck = { 0, 0, 0 }, RS = { 110, 0, -10 }, RE = { 30, 0, 0 }, RW = { 0, 0, -30 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
				follow = { Root = { -6, 6, 0, 0, -0.25, -0.22 }, Waist = { -16, 6, 0 }, Neck = { 0, 0, 0 }, RS = { 110, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 30 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
				wobble = true, trail = "rightHand",
				fx = { { "text", text = "DE MON TEMPS…", color = PINK, at = "head" } }, hitText = "TUT-TUT !",
			},
			-- J J J : taloche à l'ancienne, le grand revers d'en haut qui remet les jeunes à leur place
			P_combo3 = {
				label = "Taloche à l'ancienne", startup = 0.12, active = 0.1, recovery = 0.28,
				damage = 9, hitbox = box(4.5, 3.5, 2.8, 1), kbBase = 28, kbGrowth = 55, kbAngle = 38, selfVelocity = Vector2.new(10, 0),
				windup = { Root = { 6, -30, 0, 0, -0.15, 0.15 }, Waist = { 4, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 160, 0, 50 }, RE = { 40, 0, 0 }, RW = { 20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -10, 25, 0, 0, -0.3, -0.3 }, Waist = { -18, 25, 0 }, Neck = { -6, -10, 0 }, RS = { 70, 0, -30 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -12, 30, 0, 0, -0.32, -0.34 }, Waist = { -20, 30, 0 }, Neck = { -6, -12, 0 }, RS = { 50, 0, -40 }, RE = { 14, 0, 0 }, RW = { -30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				trail = "rightHand", fx = { { "text", text = "CRAC", color = WHITE, at = "root" } }, hitText = "TALOCHE !",
			},
			-- J K : « c'est l'heure ! » : il regarde sa montre, bras gauche levé, et cogne du cadran en revers
			PK_combo = {
				label = "C'est l'heure !", startup = 0.1, active = 0.1, recovery = 0.22,
				damage = 7, hitbox = box(4.5, 3, 2.6, 1), kbBase = 24, kbGrowth = 40, kbAngle = 32,
				windup = { Root = { -2, 25, 0, 0, -0.2, 0.1 }, Waist = { -6, 20, 0 }, Neck = { 20, 25, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 90, 0, 30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
				strike = { Root = { -6, -20, 0, 0, -0.25, -0.25 }, Waist = { -12, -20, 0 }, Neck = { 0, -10, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 90, 0, -40 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
				follow = { Root = { -6, -25, 0, 0, -0.25, -0.27 }, Waist = { -12, -24, 0 }, Neck = { 0, -12, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 88, 0, -50 }, LE = { 12, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.27 } },
				trail = "leftHand", fx = { { "symbols", symbols = { "⌚" } } }, hitText = "TIC-TAC-BAM !",
			},
			-- J K J : il glisse les pouces sous ses bretelles, tire, tire… et les lâche : CLAC, l'onde éjecte (finition)
			PKP_combo = {
				label = "Bretelles claquées", startup = 0.14, active = 0.12, recovery = 0.32,
				damage = 10, hitbox = box(5, 4, 2.2, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 40,
				windup = { Root = { 10, 0, 0, 0, -0.1, 0.25 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -10, 0, 20 }, RE = { 120, 0, 0 }, LS = { -10, 0, -20 }, LE = { 120, 0, 0 } },
				strike = { Root = { -12, 0, 0, 0, -0.25, -0.35 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 10, 0, 0 }, LS = { 60, 0, -30 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -12, 0, 0, 0, -0.25, -0.37 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 64, 0, 34 }, RE = { 10, 0, 0 }, LS = { 64, 0, -34 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				hold = 0.1, shake = true,
				fx = { { "ring", color = PINK, radius = 5, at = "front" }, { "text", text = "CLAC !", color = GOLD, at = "front" } },
				hitText = "SCHLAC !",
			},
			-- K J : valse musette : il attrape l'adversaire comme une cavalière et l'emporte dans un tour complet (2 touches)
			KP_combo = {
				label = "Valse musette", startup = 0.1, active = 0.22, recovery = 0.28,
				damage = 8, hits = 2, hitbox = box(5, 3.5, 2, 0.8), kbBase = 24, kbGrowth = 45, kbAngle = 35, selfVelocity = Vector2.new(10, 0),
				windup = { Root = { 0, 15, 0, 0, -0.15, 0.1 }, Waist = { -4, 10, 0 }, Neck = { 10, -20, 0 }, RS = { 90, 0, 40 }, RE = { 70, 0, 0 }, LS = { 130, 0, -30 }, LE = { 80, 0, 0 } },
				strike = { Root = { -4, 0, 0, 0, -0.2, -0.15 }, Waist = { -6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 20 }, RE = { 80, 0, 0 }, LS = { 120, 0, -20 }, LE = { 30, 0, 0 } },
				follow = { Root = { -4, -10, 0, 0, -0.2, -0.17 }, Waist = { -6, -6, 0 }, Neck = { 0, 10, 0 }, RS = { 90, 0, 20 }, RE = { 80, 0, 0 }, LS = { 120, 0, -20 }, LE = { 30, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "bothHands",
				fx = { { "symbols", symbols = { "♪", "💃" } } }, hitText = "UN-DEUX-TROIS !",
			},
			-- K K : pas de bourrée : petit saut sur place et talon qui claque dans le tibia, « hop ! »
			K_combo2 = {
				label = "Pas de bourrée", startup = 0.11, active = 0.1, recovery = 0.24,
				damage = 8, hitbox = box(4.5, 2.5, 2.6, -0.8), kbBase = 24, kbGrowth = 42, kbAngle = 40,
				windup = { Root = { 0, -10, 0, 0, 0.3, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 60 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 30, 0, 0 }, RK = { -90, 0, 0 } },
				strike = { Root = { 4, 10, 0, 0, 0, -0.15 }, Waist = { -4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -10, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { 4, 12, 0, 0, 0, -0.17 }, Waist = { -4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 62, 0, 72 }, RE = { 20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 62, 0, 0 }, RK = { -8, 0, 0 }, RA = { 30, 0, 0 } },
				trail = "rightFoot", fx = { { "symbols", symbols = { "♪" } } }, hitText = "HOP-LÀ !",
			},
			-- →J : coup de coude de bal musette, il se fraie un passage vers la piste comme au buffet
			P_side = {
				label = "Coude de bal musette", startup = 0.1, active = 0.1, recovery = 0.18,
				damage = 7, hitbox = box(4.5, 3, 2.6, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 28, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { 0, 50, 0, 0, -0.2, 0.15 }, Waist = { -6, 30, 0 }, Neck = { 6, -40, 0 }, RS = { 20, 0, 70 }, RE = { 130, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -6, 70, 0, 0, -0.25, -0.3 }, Waist = { -10, 30, 0 }, Neck = { 6, -60, 0 }, RS = { 40, 0, 95 }, RE = { 140, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -6, 72, 0, 0, -0.25, -0.33 }, Waist = { -10, 32, 0 }, Neck = { 6, -62, 0 }, RS = { 42, 0, 98 }, RE = { 140, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.32 } },
				trail = "rightHand", hitText = "PARDON !",
			},
			-- ↓J : il se penche (aïe le dos) pour ramasser une pièce par terre et cogne les chevilles en se relevant
			P_down = {
				label = "Pièce par terre", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 5, hitbox = box(4, 2, 2.4, -1.3), kbBase = 20, kbGrowth = 25, kbAngle = 65,
				windup = { Root = { -10, 0, 0, 0, -0.5, 0.1 }, Waist = { -45, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 10 }, RE = { 20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -16, 0, 0, 0, -0.6, -0.15 }, Waist = { -60, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 20, 0, 0 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				follow = { Root = { -14, 0, 0, 0, -0.55, -0.15 }, Waist = { -55, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 60, 0, 0 }, RE = { 30, 0, 0 }, RW = { -10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
				trail = "rightHand", fx = { { "toss", shape = "ball", color = GOLD, size = 0.3, count = 1, speed = 10 } }, hitText = "OH, UN SOU !",
			},
			-- ↑J : il applaudit au-dessus de sa tête comme à la fin du concert, et les mains claquent le menton adverse
			P_up = {
				label = "Bravo l'artiste", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 6, hitbox = box(4, 5, 1.5, 3), kbBase = 22, kbGrowth = 38, kbAngle = 86,
				windup = { Root = { 0, 0, 0, 0, -0.35, 0.05 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 } },
				strike = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 170, 0, -5 }, RE = { 10, 0, 0 }, LS = { 170, 0, 5 }, LE = { 10, 0, 0 } },
				follow = { Root = { 4, 0, 0, 0, 0.02, 0 }, Waist = { 4, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 172, 0, -6 }, RE = { 10, 0, 0 }, LS = { 172, 0, 6 }, LE = { 10, 0, 0 } },
				trail = "bothHands", fx = { { "symbols", symbols = { "👏" } } }, hitText = "CLAP !",
			},
			-- J en l'air : brasse coulée de la piscine municipale, les deux bras balaient l'air vers le bas
			P_air = {
				label = "Brasse coulée", startup = 0.1, active = 0.14, recovery = 0.18,
				damage = 7, hitbox = box(5, 4, 1.8, -0.5), kbBase = 20, kbGrowth = 32, kbAngle = -30,
				windup = { Root = { -20, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 0, 0, 0 }, RH = { 20, 0, 20 }, RK = { -90, 0, 0 }, LH = { 20, 0, -20 }, LK = { -90, 0, 0 } },
				strike = { Root = { -30, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 80 }, RE = { 20, 0, 0 }, LS = { 60, 0, -80 }, LE = { 20, 0, 0 }, RH = { 0, 0, 30 }, RK = { 0, 0, 0 }, LH = { 0, 0, -30 }, LK = { 0, 0, 0 } },
				follow = { Root = { -32, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 60 }, RE = { 40, 0, 0 }, LS = { 20, 0, -60 }, LE = { 40, 0, 0 }, RH = { 0, 0, 10 }, RK = { 0, 0, 0 }, LH = { 0, 0, -10 }, LK = { 0, 0, 0 } },
				trail = "bothHands", fx = { { "toss", shape = "ball", color = BLUE, size = 0.3, count = 4, speed = 10 } }, hitText = "PLOUF !",
			},
			-- dash J : ruée vers le buffet, coudes écartés, assiette imaginaire, il bouscule tout le monde de l'épaule
			P_dash = {
				label = "Ruée vers le buffet", startup = 0.08, active = 0.18, recovery = 0.24,
				damage = 7, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 30, selfVelocity = Vector2.new(32, 0),
				windup = { Root = { -6, 20, 0, 0, -0.25, 0.15 }, Waist = { -10, 10, 0 }, Neck = { 6, -10, 0 }, RS = { 40, 0, 40 }, RE = { 100, 0, 0 }, LS = { 40, 0, -40 }, LE = { 100, 0, 0 } },
				strike = { Root = { -14, 40, 0, 0, -0.3, -0.35 }, Waist = { -14, 20, 0 }, Neck = { 6, -30, 0 }, RS = { 50, 0, 50 }, RE = { 110, 0, 0 }, LS = { 50, 0, -50 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { -14, 42, 0, 0, -0.3, -0.38 }, Waist = { -14, 22, 0 }, Neck = { 6, -32, 0 }, RS = { 52, 0, 52 }, RE = { 110, 0, 0 }, LS = { 52, 0, -52 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
				fx = { "dust" }, hitText = "LES PETITS FOURS !",
			},
			-- K : petit shoot dans le caillou, la charentaise rase le sol et cueille le tibia
			K_neutral = {
				label = "Shoot dans le caillou", startup = 0.12, active = 0.1, recovery = 0.24,
				damage = 8, hitbox = box(4.5, 2.5, 2.6, -0.8), kbBase = 24, kbGrowth = 45, kbAngle = 35,
				windup = { Root = { 4, 0, 0, 0, -0.2, 0.15 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -30, 0, 0 }, RK = { -40, 0, 0 } },
				strike = { Root = { -6, 0, 0, 0, -0.2, -0.1 }, Waist = { -12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { -6, 0, 0, 0, -0.2, -0.12 }, Waist = { -12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 42, 0, 42 }, RE = { 40, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 66, 0, 0 }, RK = { -2, 0, 0 }, RA = { 20, 0, 0 } },
				trail = "rightFoot", fx = { { "toss", shape = "ball", color = SILVER, size = 0.3, count = 1, speed = 18 } }, hitText = "TOC !",
			},
			-- →K : il ferme le tiroir du pied, jambe tendue sur le côté, sans même se retourner
			K_side = {
				label = "Tiroir fermé du pied", startup = 0.14, active = 0.12, recovery = 0.28,
				damage = 9, hitbox = box(5.5, 3, 3.2, 0.2), kbBase = 26, kbGrowth = 50, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
				windup = { Root = { 0, 70, 0, 0, -0.2, 0.15 }, Waist = { -8, 0, 0 }, Neck = { 0, -60, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 } },
				strike = { Root = { 0, 90, 15, 0, -0.15, -0.1 }, Waist = { -8, 0, 0 }, Neck = { 0, -80, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 10, 0, 70 }, RK = { -5, 0, 0 } },
				follow = { Root = { 0, 90, 16, 0, -0.15, -0.12 }, Waist = { -8, 0, 0 }, Neck = { 0, -80, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 10, 0, 74 }, RK = { -3, 0, 0 } },
				trail = "rightFoot", fx = { { "text", text = "CRAC", color = WHITE, at = "root" } }, hitText = "BLAM !",
			},
			-- ↓K : croche-pied de doyen : il lit son journal et avance le pied en douce sous les chevilles adverses
			K_down = {
				label = "Croche-pied de doyen", startup = 0.12, active = 0.14, recovery = 0.28,
				damage = 7, hitbox = box(5.5, 1.8, 3, -1.6), kbBase = 24, kbGrowth = 40, kbAngle = 75,
				windup = { Root = { 0, -10, 0, 0, -0.3, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 } },
				strike = { Root = { 0, -10, 0, 0, -0.45, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 }, RH = { 40, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { 0, -10, 0, 0, -0.45, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 }, RH = { 44, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
				trail = "rightFoot", fx = { { "symbols", symbols = { "📰" } } }, hitText = "OH PARDON…",
			},
			-- ↑K : cabriole de 1962 : petit saut, les deux talons claquent l'un contre l'autre très haut
			K_up = {
				label = "Cabriole de 1962", startup = 0.14, active = 0.12, recovery = 0.3,
				damage = 9, hitbox = box(4.5, 5.5, 1.2, 3), kbBase = 26, kbGrowth = 55, kbAngle = 85,
				windup = { Root = { 0, 0, 0, 0, -0.4, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, 0.6, 0 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 30 }, RE = { 10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 20, 0, -20 }, RK = { -100, 0, 0 }, RA = { -20, 0, 0 }, LH = { 20, 0, 20 }, LK = { -100, 0, 0 }, LA = { -20, 0, 0 } },
				follow = { Root = { 10, 0, 0, 0, 0.62, 0 }, Waist = { 10, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 162, 0, 32 }, RE = { 10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 22, 0, -22 }, RK = { -104, 0, 0 }, RA = { -20, 0, 0 }, LH = { 22, 0, 22 }, LK = { -104, 0, 0 }, LA = { -20, 0, 0 } },
				trail = "bothFeet", fx = { { "symbols", symbols = { "✨" } } }, hitText = "YOUPLA !",
			},
			-- K en l'air : ciseaux de gymnastique douce, les jambes se croisent lentement… mais deux fois
			K_air = {
				label = "Gym douce", startup = 0.1, active = 0.22, recovery = 0.2,
				damage = 8, hits = 2, hitbox = box(5, 3, 2.2, -0.8), kbBase = 22, kbGrowth = 40, kbAngle = 35,
				windup = { Root = { 10, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 40, 0, 20 }, RK = { 0, 0, 0 }, LH = { 40, 0, -20 }, LK = { 0, 0, 0 } },
				strike = { Root = { 14, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 70, 0, -15 }, RK = { 0, 0, 0 }, LH = { 50, 0, 15 }, LK = { 0, 0, 0 } },
				follow = { Root = { 14, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 50, 0, 20 }, RK = { 0, 0, 0 }, LH = { 70, 0, -20 }, LK = { 0, 0, 0 } },
				trail = "bothFeet", hitText = "ET UN, ET DEUX !",
			},
			-- dash K : il se prend les pieds dans le tapis et sa jambe part toute seule devant lui
			K_dash = {
				label = "Pris dans le tapis", startup = 0.1, active = 0.22, recovery = 0.3,
				damage = 9, hitbox = box(5.5, 2.5, 3, -0.6), kbBase = 28, kbGrowth = 55, kbAngle = 40, selfVelocity = Vector2.new(44, 6),
				windup = { Root = { -10, 0, 0, 0, -0.2, 0 }, Waist = { -14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 } },
				strike = { Root = { 20, 0, 0, 0, -0.5, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
				follow = { Root = { 22, 0, 0, 0, -0.52, 0.12 }, Waist = { 10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 154, 0, 44 }, RE = { 10, 0, 0 }, LS = { 154, 0, -44 }, LE = { 10, 0, 0 }, RH = { 94, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 12, 0, 0 }, LK = { -40, 0, 0 } },
				trail = "rightFoot", fx = { "dust" }, hitText = "OH LÀ LÀ !",
			},
		},
		-- Combos à mains nues : J J J (pichenette, doigt grondeur, taloche), J K J (montre puis bretelles claquées),
		-- K J (valse musette), K K (pas de bourrée). Un L pour finir envoie le spécial du perso (ses L restent les siens).
		links = {
			P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_neutral" },
			P_combo2 = { P = "P_combo3", down_K = "K_down", S = "S_side" },
			P_combo3 = { S = "S_side" },
			PK_combo = { P = "PKP_combo", K = "K_side", S = "S_neutral" },
			PKP_combo = { S = "S_down" },
			K_neutral = { P = "KP_combo", K = "K_combo2", S = "S_down" },
			KP_combo = { P = "P_up", K = "K_up", S = "S_neutral" },
			K_combo2 = { P = "PK_combo", up_K = "K_up", S = "S_side" },
			P_side = { P = "P_combo2", K = "K_combo2", S = "S_side" },
			P_down = { P = "P_up", K = "K_down", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			K_side = { P = "KP_combo", S = "S_side" },
			K_down = { P = "P_up", S = "S_down" },
			K_up = { S = "S_up" },
			P_dash = { P = "P_combo2", K = "K_side", S = "S_side" },
			K_dash = { P = "P_up", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : les vinyles tranchants (ses coups sont ceux de moves). n° 2 : la boule à facettes au bout d'une chaîne, un fléau
	-- lourd et lent qui éjecte loin et fait danser. n° 3 : la radiocassette des années 80, jeu de projectiles (notes, cassettes)
	-- dont la musique le soigne.
	weapons = {
		{ id = "vinyles", name = "Vinyles tranchants", icon = "💿",
			ability = { superCooldown = 0.7, text = "Supers rechargés 30 % plus vite : le show continue" } },
		{ id = "boule", name = "Boule à facettes à chaîne", icon = "🪩",
			prop = { name = "PropBoule", hand = "Right", pieces = {
				{ "Chaine", "", "cyl", Vector3.new(1.6, 0.12, 0.12), Vector3.new(0, -0.9, 0), Vector3.zero, GOLD, "Metal", { axis = "y" } },
				{ "Boule", "", "ball", Vector3.new(1.4, 1.4, 1.4), Vector3.new(0, -2.3, 0), Vector3.zero, SILVER, "Foil", { reflect = 0.5 } },
				{ "Facette1", "", "block", Vector3.new(0.45, 0.45, 0.45), Vector3.new(0.6, -2.0, 0.3), Vector3.new(20, 30, 0), WHITE, "Foil" },
				{ "Facette2", "", "block", Vector3.new(0.4, 0.4, 0.4), Vector3.new(-0.55, -2.5, -0.3), Vector3.new(0, 45, 20), PINK, "Neon", { neon = true } },
				{ "Facette3", "", "block", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0.2, -2.75, 0.55), Vector3.new(30, 0, 30), BLUE, "Neon", { neon = true } },
			} },
			ability = { knockback = 1.3, text = "Éjecte 30 % plus loin : elle pèse, la boule" },
			moves = {
				-- J : il abat la boule devant lui comme un marteau de foire, le dos craque
				P_neutral = {
					label = "Coup de boule à facettes", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(5, 3.5, 3, 0.5), kbBase = 24, kbGrowth = 32, kbAngle = 30,
					windup = { Root = { -4, -10, 0, 0, -0.25, 0.1 }, Waist = { -8, -12, 0 }, Neck = { 6, 8, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -12, 12, 0, 0, -0.32, -0.25 }, Waist = { -18, 14, 0 }, Neck = { 4, -6, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -14, 14, 0, 0, -0.34, -0.28 }, Waist = { -20, 16, 0 }, Neck = { 2, -8, 0 }, RS = { 70, 0, 2 }, RE = { 4, 0, 0 }, RW = { 30, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", hitText = "KLONG !",
				},
				-- →J : grand moulinet horizontal, il pivote sur ses charentaises et la boule balaie l'air
				P_side = {
					label = "Moulinet disco", startup = 0.14, active = 0.12, recovery = 0.26,
					damage = 9, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 26, kbGrowth = 40, kbAngle = 28, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { -2, 45, 0, 0, -0.22, 0.15 }, Waist = { -6, 40, 0 }, Neck = { 4, -20, 0 }, RS = { 90, 0, 70 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -8, -35, 0, 0, -0.3, -0.3 }, Waist = { -12, -30, 0 }, Neck = { 2, 10, 0 }, RS = { 92, 0, -30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, -45, 0, 0, -0.32, -0.34 }, Waist = { -14, -40, 0 }, Neck = { 0, 14, 0 }, RS = { 94, 0, -40 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", fx = { { "symbols", symbols = { "✨" }, color = WHITE, count = 3, radius = 2, at = "hand" } }, hitText = "VLAN !",
				},
				-- ↓J : penché en avant, il laisse tomber la boule par terre : elle roule dans les tibias
				P_down = {
					label = "Boule roulante", startup = 0.12, active = 0.14, recovery = 0.24,
					damage = 8, hitbox = box(6, 2.2, 3.5, -1.4), kbBase = 24, kbGrowth = 34, kbAngle = 72,
					windup = { Root = { -8, 0, 0, 0, -0.4, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 15 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.6, -0.15 }, Waist = { -28, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 10 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
					follow = { Root = { -18, 0, 0, 0, -0.62, -0.18 }, Waist = { -30, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 30, 0, 12 }, RE = { 6, 0, 0 }, RW = { -30, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
					fx = { { "toss", shape = "ball", color = SILVER, size = 0.6, count = 1, speed = 16 } }, hitText = "ROULE !",
				},
				-- ↑J : il fait remonter la boule d'un coup de poignet, uppercut scintillant
				P_up = {
					label = "Uppercut scintillant", startup = 0.12, active = 0.1, recovery = 0.24,
					damage = 8, hitbox = box(4, 5.5, 1.5, 3), kbBase = 26, kbGrowth = 42, kbAngle = 86,
					windup = { Root = { -6, 0, 0, 0, -0.35, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { 2, 0, 0, 0, -0.1, -0.1 }, Waist = { -4, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 165, 0, 15 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					follow = { Root = { 4, 0, 0, 0, -0.08, -0.12 }, Waist = { -2, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 175, 0, 18 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "spark", color = WHITE, dir = "up", at = "hand", time = 0.25, speed = 14, size = 0.5, rate = 60 } }, hitText = "BLING !",
				},
				-- J en l'air : la boule pendule sous lui comme un lustre qui se décroche
				P_air = {
					label = "Lustre décroché", startup = 0.12, active = 0.12, recovery = 0.2,
					damage = 9, hitbox = box(5, 4.5, 1.5, -1.8), kbBase = 24, kbGrowth = 38, kbAngle = -40,
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 180, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 14, 0, 6 }, RE = { 4, 0, 0 }, RW = { 20, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 4, 0, 0 }, RK = { -26, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					trail = "prop", hitText = "KLANG !",
				},
				-- dash J : il traîne la boule derrière lui en trottinant puis la projette en avant d'un coup de reins
				P_dash = {
					label = "Boule en traîneau", startup = 0.12, active = 0.12, recovery = 0.26,
					damage = 9, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 26, kbGrowth = 40, kbAngle = 32, selfVelocity = Vector2.new(28, 0),
					windup = { Root = { -10, 0, 0, 0, -0.2, 0.2 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -50, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.3, -0.35 }, Waist = { -20, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 100, 0, 5 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -16, 0, 0, 0, -0.32, -0.4 }, Waist = { -22, 0, 0 }, Neck = { -2, 0, 0 }, RS = { 104, 0, 6 }, RE = { 4, 0, 0 }, RW = { 16, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { "dust" }, hitText = "TRAÎNÉ !",
				},
				-- K : la boule levée en contrepoids, grand coup de charentaise toute raide dans le ventre
				K_neutral = {
					label = "Charentaise en contrepoids", startup = 0.2, active = 0.1, recovery = 0.32,
					damage = 11, hitbox = box(5, 3.5, 3, 0.4), kbBase = 30, kbGrowth = 62, kbAngle = 32,
					windup = { Root = { -6, -12, 0, 0, -0.2, 0.1 }, Waist = { -10, -10, 0 }, Neck = { 6, 6, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -30, 0, 0 }, RK = { -50, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, -0.12, 0 }, Waist = { 8, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 170, 0, 50 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 92, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 8, 0, 0, 0, -0.12, 0.04 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 174, 0, 54 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					trail = "rightFoot", hitText = "PAF !",
				},
				-- →K : coup de pied retourné, la boule tendue à bout de bras sert de balancier… et de deuxième coup
				K_side = {
					label = "Balancier retourné", startup = 0.18, active = 0.14, recovery = 0.34,
					damage = 12, hitbox = box(6.5, 3.5, 3.5, 0.6), kbBase = 32, kbGrowth = 72, kbAngle = 36, selfVelocity = Vector2.new(18, 0),
					windup = { Root = { -4, 30, 0, 0, -0.2, 0.1 }, Waist = { -6, 36, 0 }, Neck = { 4, -16, 0 }, RS = { 100, 0, 70 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 } },
					strike = { Root = { 6, -40, 0, 0, -0.1, -0.1 }, Waist = { 8, -46, 0 }, Neck = { 0, 12, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -50 }, LE = { 40, 0, 0 }, RH = { 100, 0, 20 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 8, -50, 0, 0, -0.1, -0.14 }, Waist = { 10, -56, 0 }, Neck = { 0, 16, 0 }, RS = { 92, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -54 }, LE = { 40, 0, 0 }, RH = { 108, 0, 24 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "DOUBLE VLAN !",
				},
				-- ↓K : il pose la boule par terre, s'appuie dessus comme sur une canne et fauche les chevilles
				K_down = {
					label = "Fauchage à la canne-boule", startup = 0.16, active = 0.14, recovery = 0.32,
					damage = 9, hitbox = box(7, 2, 3.5, -1.6), kbBase = 28, kbGrowth = 52, kbAngle = 76,
					windup = { Root = { -10, 10, 0, 0, -0.6, 0.1 }, Waist = { -18, 12, 0 }, Neck = { 12, 0, 0 }, RS = { 50, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -14, -18, 0, 0, -0.7, -0.1 }, Waist = { -22, -22, 0 }, Neck = { 14, 0, 0 }, RS = { 46, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { -16, -24, 0, 0, -0.72, -0.14 }, Waist = { -24, -28, 0 }, Neck = { 16, 0, 0 }, RS = { 48, 0, 14 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : coup de pied monté tout raide pendant que la boule lâchée tinte au plafond
				K_up = {
					label = "Pied au lustre", startup = 0.18, active = 0.12, recovery = 0.34,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 66, kbAngle = 88,
					windup = { Root = { -8, 0, 0, 0, -0.3, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 30 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 176, 0, 20 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 136, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.02, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 180, 0, 22 }, RE = { 10, 0, 0 }, RW = { -36, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 144, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { { "burst", color = WHITE, size = 2, at = "above" } }, hitText = "AÏE LA HANCHE !",
				},
				-- K en l'air : il pédale dans le vide, la boule tournant au-dessus de sa tête comme un lustre de bal (2 touches)
				K_air = {
					label = "Pédalage sous le lustre", startup = 0.14, active = 0.2, recovery = 0.22,
					damage = 10, hits = 2, hitbox = box(5, 4, 2.5, -0.5), kbBase = 22, kbGrowth = 46, kbAngle = 40,
					windup = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 178, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 2, 0, 0 }, RS = { 182, 0, 14 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { -2, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 184, 0, 16 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "rightFoot", hitText = "TAC TAC !",
				},
				-- dash K : glissade sur le dos, la boule serrée contre le bedon, charentaises en avant
				K_dash = {
					label = "Glissade au bedon", startup = 0.12, active = 0.26, recovery = 0.32,
					damage = 11, hitbox = box(6, 3, 3, -0.8), kbBase = 30, kbGrowth = 66, kbAngle = 38, selfVelocity = Vector2.new(52, 10),
					windup = { Root = { -10, 0, 0, 0, -0.4, 0 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { 22, 0, 0, 0, -0.7, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 70, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 110, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 26, 0, 0, 0, -0.72, 0.24 }, Waist = { 14, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 72, 0, 12 }, RE = { 112, 0, 0 }, RW = { 0, 0, 0 }, LS = { 72, 0, -12 }, LE = { 112, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "rightFoot", fx = { "dust" }, hitText = "SKRRRT !",
				},
				-- L : il fait tournoyer la boule autour de lui, les reflets forcent tout le monde à danser (3 touches)
				S_neutral = {
					label = "Lustre tournoyant", startup = 0.24, active = 0.3, recovery = 0.5,
					damage = 14, hits = 3, hitbox = box(12, 6, 2, 1), kbBase = 28, kbGrowth = 50, kbAngle = 40,
					status = { name = "dancing", duration = 1.5 },
					windup = { Root = { -6, -20, 0, 0, -0.3, 0.1 }, Waist = { -10, -24, 0 }, Neck = { 6, 12, 0 }, RS = { 170, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -8, 20, 0, 0, -0.3, -0.1 }, Waist = { -12, 24, 0 }, Neck = { 0, -10, 0 }, RS = { 100, 0, 80 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -10, -20, 0, 0, -0.32, -0.1 }, Waist = { -14, -24, 0 }, Neck = { 0, 10, 0 }, RS = { 100, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop",
					fx = { { "ring", color = WHITE, radius = 6, at = "root" }, { "symbols", symbols = { "✨", "🪩" }, color = WHITE, count = 6, radius = 4 } },
					text = "ÇA TOURNE !", hitText = "ÉBLOUI !",
				},
				-- →L : il lâche la chaîne : la boule part comme un boulet de canon scintillant droit sur l'adversaire
				S_side = {
					label = "Boulet scintillant", kind = "projectile", startup = 0.26, active = 0, recovery = 0.55,
					damage = 16, kbBase = 34, kbGrowth = 64, kbAngle = 32,
					projectile = { speed = 72, angle = 0, gravity = 0, lifetime = 0.8, size = 2.4, color = SILVER, visual = BOULE },
					status = { name = "dancing", duration = 1.5 },
					windup = { Root = { -4, -40, 0, 0, -0.3, 0.3 }, Waist = { -8, -44, 0 }, Neck = { 8, 26, 0 }, RS = { 176, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -14, 26, 0, 0, -0.34, -0.45 }, Waist = { -18, 30, 0 }, Neck = { -4, -18, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, 30, 0, 0, -0.36, -0.5 }, Waist = { -20, 34, 0 }, Neck = { -6, -20, 0 }, RS = { 100, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hideProp = "boule", fx = { { "burst", color = WHITE, size = 2.5, at = "hand" }, { "symbols", symbols = { "✨" }, color = WHITE, count = 4, radius = 2, at = "hand" } },
					text = "BOULET !", hitText = "KA-BLING !",
				},
				-- ↓L : boule de démolition : il la lève à deux mains (hnng, le dos) et l'écrase au sol, le dancefloor se fend sur tout le couloir
				S_down = {
					label = "Boule de démolition", startup = 0.28, active = 0.16, recovery = 0.6,
					damage = 15, hitbox = box(14, 5, 7, 0.5), kbBase = 32, kbGrowth = 60, kbAngle = 48,
					windup = { Root = { 6, 0, 0, 0, -0.15, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 185, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -10 }, LE = { 20, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.7, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -20, 0, 0, 0, -0.72, -0.34 }, Waist = { -32, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 44, 0, 12 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { 44, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.12, shake = true, trail = "prop", windupFx = { { "text", text = "HNNNG…", color = PINK, at = "head" } },
					fx = { { "beam", color = WHITE, length = 14, width = 2.5, at = "feet" }, { "toss", shape = "flat", color = Color3.fromRGB(230, 230, 235), count = 6, size = 0.7, speed = 22 }, { "shake", amount = 0.4 } },
					text = "DÉMOLITION !", hitText = "CRAAAC !",
				},
				-- ↑L : il s'accroche à la chaîne, la boule file au plafond comme un ballon et l'emporte en diagonale, charentaises ballantes
				S_up = {
					label = "Ascension au lustre", startup = 0.14, active = 0.3, recovery = 0.45,
					damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 78, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 90, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.3, 0 }, Waist = { -4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 182, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 182, 0, -6 }, LE = { 0, 0, 0 }, RH = { -20, 0, 6 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -6 }, LK = { -55, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.35, 0 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 186, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -8 }, LE = { 0, 0, 0 }, RH = { -26, 0, 8 }, RK = { -48, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -8 }, LK = { -62, 0, 0 }, LA = { -30, 0, 0 } },
					trail = "prop", fx = { { "burst", color = WHITE, size = 3, at = "above" }, { "symbols", symbols = { "✨", "🪩" }, color = WHITE, count = 6, radius = 3, at = "above" }, { "particles", tex = "spark", color = PINK, dir = "down", at = "feet", time = 0.4, speed = 12, rate = 80 } },
					text = "MONTEZ-MOI !", hitText = "EMPORTÉ AU LUSTRE !",
				},
				-- L en l'air : boule-marteau : il la fait passer au-dessus de sa tête et l'abat sous lui de tout son poids
				S_air = {
					label = "Boule-marteau", startup = 0.18, active = 0.16, recovery = 0.45,
					damage = 14, hitbox = box(6, 5, 2, -1.5), kbBase = 30, kbGrowth = 60, kbAngle = -60,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 186, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -10 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { 30, 0, -5 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -20, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 20, 0, 6 }, RE = { 4, 0, 0 }, RW = { 30, 0, 0 }, LS = { 20, 0, -6 }, LE = { 4, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					trail = "prop", fx = { { "burst", color = WHITE, size = 2.5, at = "hand" }, { "symbols", symbols = { "✨" }, color = WHITE, count = 3, radius = 2 } },
					text = "MARTEAU !", hitText = "BADABLING !",
				},
				-- Y : le grand bal : il fait tourner la boule au bout de la chaîne à toute vitesse, les reflets balaient tout l'écran et tout le monde danse
				SUPER = {
					label = "Le Grand Bal !", startup = 0.4, active = 0.3, recovery = 0.75,
					damage = 24, hitbox = box(30, 8, 0, 2), kbBase = 42, kbGrowth = 90, kbAngle = 45,
					status = { name = "dancing", duration = 3 },
					windup = { Root = { -6, 0, 0, 0, -0.4, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 } },
					strike = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 186, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -80 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
					follow = { Root = { 2, 0, 0, 0, -0.2, 0 }, Waist = { 6, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 188, 0, 24 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -84 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
					hold = 0.2, spin = { axis = "y", degrees = 720 }, trail = "prop",
					windupFx = { "super", { "text", text = "ON OUVRE LE BAL !", color = PINK, at = "head" } },
					fx = { { "screen", color = WHITE, alpha = 0.25 }, { "ring", color = WHITE, radius = 14, at = "root" }, { "symbols", symbols = { "✨", "🪩", "💃", "🕺" }, color = GOLD, count = 12, radius = 7 }, { "shake", amount = 0.5 } },
					text = "LE GRAND BAL !", hitText = "TOUT LE MONDE DANSE !",
				},
				-- →Y : la boule-comète : trois tours de chaîne au-dessus de la tête et il la lâche : une comète scintillante traverse tout le couloir
				SUPER_side = {
					label = "Boule-comète !", kind = "projectile", startup = 0.42, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 4, color = SILVER, visual = BOULE, pierce = true },
					status = { name = "dancing", duration = 2 },
					windup = { Root = { -6, -30, 0, 0, -0.3, 0.3 }, Waist = { -10, -34, 0 }, Neck = { 10, 22, 0 }, RS = { 178, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -18, 24, 0, 0, -0.34, -0.5 }, Waist = { -20, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 98, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 28, 0, 0, -0.36, -0.55 }, Waist = { -24, 32, 0 }, Neck = { -8, -18, 0 }, RS = { 102, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 56, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					spin = { axis = "y", degrees = 1080 }, hideProp = "boule", windupFx = { "super", { "symbols", symbols = { "🪩" }, count = 6, radius = 3, color = WHITE } },
					fx = { { "burst", color = WHITE, size = 4, at = "hand" }, { "beam", color = WHITE, length = 16, width = 3, at = "hand" }, { "shake", amount = 0.4 } },
					text = "COMÈTE !", hitText = "KA-BLIIING !",
				},
				-- ↑Y : le lustre géant : il lance la boule au plafond, elle s'y accroche et une pluie de lumière emporte tout le couloir vers le haut
				SUPER_up = {
					label = "Lustre géant !", startup = 0.38, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 52),
					status = { name = "dancing", duration = 2 },
					windup = { Root = { -10, 0, 0, 0, -0.8, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 8, 0, 0, 0, 0.5, 0 }, Waist = { 16, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 188, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, 0.55, 0 }, Waist = { 22, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 190, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 156, 0, -66 }, LE = { 10, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, hideProp = "boule",
					windupFx = { "super", { "text", text = "HNNNG… LE DOS…", color = PINK, at = "head" } },
					fx = { { "pillar", color = WHITE, height = 22, width = 3, at = "front" }, { "rain", shape = "ball", color = WHITE, count = 12, radius = 8, size = 0.5 }, { "burst", color = PINK, size = 4, at = "above" }, { "symbols", symbols = { "✨", "🪩" }, color = GOLD, count = 10, radius = 6, at = "above" }, { "shake", amount = 0.4 } },
					text = "LUSTRE GÉANT !", hitText = "ILLUMINÉ !",
				},
				-- ↓Y : dancefloor écrasé : il fait rebondir la boule sur le sol devant lui comme un marteau-piqueur, le couloir tremble et ralentit tout le monde
				SUPER_down = {
					label = "Dancefloor écrasé !", startup = 0.38, active = 0.35, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 62,
					status = { name = "slowed", duration = 2 },
					windup = { Root = { 4, 0, 0, 0, -0.3, 0.2 }, Waist = { 8, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 180, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -15 }, LE = { 40, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.75, -0.3 }, Waist = { -28, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 15 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { 40, 0, -15 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 0, 0, 0, -0.55, -0.26 }, Waist = { -22, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 15 }, RE = { 20, 0, 0 }, RW = { 10, 0, 0 }, LS = { 70, 0, -15 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.15, shake = true, wobble = true, trail = "prop", windupFx = { "super" },
					fx = { { "beam", color = WHITE, length = 16, width = 3, at = "feet" }, { "toss", shape = "flat", color = Color3.fromRGB(230, 230, 235), count = 8, size = 0.8, speed = 26 }, { "shake", amount = 0.6 }, { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 230), dir = "front", at = "feet", time = 0.4, speed = 14 } },
					text = "DANCEFLOOR ÉCRASÉ !", hitText = "BOUM BOUM BOUM !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_down" },
				K_side = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "radio", name = "Radiocassette des années 80", icon = "📻",
			prop = { name = "PropRadio", hand = "Right", pieces = {
				{ "Caisson", "", "block", Vector3.new(1.9, 0.9, 0.6), Vector3.new(0, -0.75, 0), Vector3.zero, BLACK, "SmoothPlastic" },
				{ "HautParleurD", "", "cyl", Vector3.new(0.1, 0.65, 0.65), Vector3.new(0.6, -0.75, -0.32), Vector3.zero, SILVER, "Metal", { axis = "z" } },
				{ "HautParleurG", "", "cyl", Vector3.new(0.1, 0.65, 0.65), Vector3.new(-0.6, -0.75, -0.32), Vector3.zero, SILVER, "Metal", { axis = "z" } },
				{ "Cassette", "", "block", Vector3.new(0.5, 0.3, 0.06), Vector3.new(0, -0.65, -0.33), Vector3.zero, CASSETTE, "SmoothPlastic" },
				{ "Antenne", "", "cyl", Vector3.new(1.4, 0.06, 0.06), Vector3.new(0.8, 0.1, 0), Vector3.new(0, 0, 20), SILVER, "Metal", { axis = "y" } },
				{ "Led", "", "block", Vector3.new(0.3, 0.08, 0.06), Vector3.new(0, -0.4, -0.33), Vector3.zero, PINK, "Neon", { neon = true } },
			} },
			ability = { heal = 0.25, text = "25 % des dégâts le soignent : la musique adoucit les douleurs" },
			moves = {
				-- J : coup de radio à bout de bras, plein volume dans l'oreille
				P_neutral = {
					label = "Coup de radio", startup = 0.08, active = 0.08, recovery = 0.14,
					damage = 6, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 20, kbGrowth = 25, kbAngle = 25,
					windup = { Root = { -4, -14, 0, 0, -0.25, 0.1 }, Waist = { -10, -18, 0 }, Neck = { 6, 10, 0 }, RS = { 50, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -8, 14, 0, 0, -0.28, -0.25 }, Waist = { -14, 18, 0 }, Neck = { 4, -8, 0 }, RS = { 96, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					follow = { Root = { -10, 16, 0, 0, -0.3, -0.28 }, Waist = { -16, 20, 0 }, Neck = { 2, -10, 0 }, RS = { 92, 0, 2 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "♪" }, color = PINK, count = 2, radius = 1.5, at = "hand" } }, hitText = "BLAM !",
				},
				-- →J : il éjecte la cassette d'un coup de pouce et la jette au front (petit projectile court)
				P_side = {
					label = "Cassette au front", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 6, kbBase = 22, kbGrowth = 34, kbAngle = 30,
					projectile = { speed = 70, angle = 5, gravity = 40, lifetime = 0.3, size = 1.2, color = CASSETTE, visual = CASSETTE_VISUAL, aim = false },
					windup = { Root = { -4, -24, 0, 0, -0.2, 0.15 }, Waist = { -8, -28, 0 }, Neck = { 6, 16, 0 }, RS = { 80, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 110, 0, 0 } },
					strike = { Root = { -10, 18, 0, 0, -0.3, -0.3 }, Waist = { -14, 24, 0 }, Neck = { 0, -10, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -10 }, LE = { 0, 0, 0 }, LW = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 22, 0, 0, -0.32, -0.34 }, Waist = { -16, 28, 0 }, Neck = { -2, -12, 0 }, RS = { 68, 0, 22 }, RE = { 64, 0, 0 }, RW = { 0, 0, 0 }, LS = { 98, 0, -12 }, LE = { 4, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					hitText = "CLAC !",
				},
				-- ↓J : penché, il pose la radio au sol et monte les basses : l'onde secoue les chevilles
				P_down = {
					label = "Basses au ras du sol", startup = 0.1, active = 0.12, recovery = 0.2,
					damage = 6, hitbox = box(6, 2, 3.5, -1.4), kbBase = 22, kbGrowth = 30, kbAngle = 70,
					windup = { Root = { -8, 0, 0, 0, -0.4, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 70, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.62, -0.15 }, Waist = { -28, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 10 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
					follow = { Root = { -18, 0, 0, 0, -0.64, -0.18 }, Waist = { -30, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 36, 0, 12 }, RE = { 10, 0, 0 }, RW = { -36, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
					fx = { { "ring", color = PINK, radius = 3, at = "feet" }, { "symbols", symbols = { "♪" }, color = PINK, count = 2, radius = 2, at = "feet" } }, hitText = "BZZZT !",
				},
				-- ↑J : coup d'antenne : il fouette vers le haut avec l'antenne télescopique, pile sous le menton
				P_up = {
					label = "Coup d'antenne", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 6, hitbox = box(4, 5, 1.5, 3), kbBase = 24, kbGrowth = 40, kbAngle = 85,
					windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 30, 0, 20 }, RE = { 110, 0, 0 }, RW = { 20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { 0, 0, 0, 0, -0.1, -0.1 }, Waist = { -6, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					follow = { Root = { 2, 0, 0, 0, -0.08, -0.12 }, Waist = { -4, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 172, 0, 12 }, RE = { 10, 0, 0 }, RW = { -50, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
					trail = "prop", hitText = "TZING !",
				},
				-- J en l'air : la radio sur l'épaule comme un jeune des années 80, il la balance sous lui
				P_air = {
					label = "Radio sur l'épaule", startup = 0.1, active = 0.12, recovery = 0.16,
					damage = 7, hitbox = box(4.5, 4, 1.5, -1.5), kbBase = 20, kbGrowth = 35, kbAngle = -35,
					windup = { Root = { 8, -10, 0 }, Waist = { 12, -12, 0 }, Neck = { 4, 10, 0 }, RS = { 150, 0, 40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 10, 0 }, Waist = { -28, 12, 0 }, Neck = { 14, -8, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -16, 12, 0 }, Waist = { -32, 14, 0 }, Neck = { 18, -10, 0 }, RS = { 20, 0, 6 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash J : jogging sonore : il trottine, radio à fond, et deux notes partent devant lui
				P_dash = {
					label = "Jogging sonore", kind = "projectile", startup = 0.08, active = 0, recovery = 0.22,
					damage = 6, kbBase = 22, kbGrowth = 35, kbAngle = 30, selfVelocity = Vector2.new(30, 0),
					projectile = { speed = 72, angle = 6, gravity = 20, lifetime = 0.4, size = 1.1, color = PINK, visual = NOTE, aim = false, fan = { count = 2, from = 0, to = 20 } },
					windup = { Root = { -8, -10, 0, 0, -0.15, 0.2 }, Waist = { -12, -12, 0 }, Neck = { 6, 8, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -12, 10, 0, 0, -0.22, -0.3 }, Waist = { -16, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 96, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 12, 0, 0, -0.24, -0.34 }, Waist = { -18, 14, 0 }, Neck = { -2, -8, 0 }, RS = { 94, 0, 2 }, RE = { 12, 0, 0 }, RW = { -8, 0, 0 }, LS = { -32, 0, -32 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					fx = { { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 3, radius = 2, at = "hand" } }, hitText = "TUTUT !",
				},
				-- K : il pose une cassette par terre et la shoote comme un ballon (projectile)
				K_neutral = {
					label = "Shoot de cassette", kind = "projectile", startup = 0.18, active = 0, recovery = 0.3,
					damage = 10, kbBase = 28, kbGrowth = 55, kbAngle = 30,
					projectile = { speed = 78, angle = 10, gravity = 60, lifetime = 0.45, size = 1.3, color = CASSETTE, visual = CASSETTE_VISUAL, aim = false },
					windup = { Root = { -6, -10, 0, 0, -0.15, 0.1 }, Waist = { -8, -8, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 40 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 8, 0, 0, 0, -0.1, 0.05 }, Waist = { 10, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 60, 0, 55 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, -0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 64, 0, 60 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
					trail = "rightFoot", hitText = "PÉNO !",
				},
				-- →K : pas de breakdance rouillé : coup de pied tournant, la radio tenue au-dessus de la tête
				K_side = {
					label = "Breakdance rouillé", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 32, kbGrowth = 70, kbAngle = 35, selfVelocity = Vector2.new(20, 0),
					windup = { Root = { -4, 30, 0, 0, -0.2, 0.1 }, Waist = { -6, 40, 0 }, Neck = { 4, -16, 0 }, RS = { 180, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 } },
					strike = { Root = { 8, -40, 0, 0, -0.1, -0.1 }, Waist = { 8, -50, 0 }, Neck = { 0, 12, 0 }, RS = { 184, 0, 24 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 100, 0, 20 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 10, -50, 0, 0, -0.1, -0.14 }, Waist = { 10, -60, 0 }, Neck = { 0, 16, 0 }, RS = { 186, 0, 26 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -54 }, LE = { 40, 0, 0 }, RH = { 108, 0, 24 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "rightFoot", fx = { { "symbols", symbols = { "♪", "🕺" }, color = GOLD, count = 3, radius = 2 } }, hitText = "VLAN !",
				},
				-- ↓K : balayette rythmée, en cadence avec les basses, la radio posée à côté
				K_down = {
					label = "Balayette en rythme", startup = 0.14, active = 0.14, recovery = 0.3,
					damage = 9, hitbox = box(7, 2, 3.5, -1.6), kbBase = 28, kbGrowth = 50, kbAngle = 75,
					windup = { Root = { -10, 10, 0, 0, -0.65, 0.1 }, Waist = { -16, 14, 0 }, Neck = { 12, 0, 0 }, RS = { 50, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -14, -20, 0, 0, -0.75, -0.1 }, Waist = { -20, -26, 0 }, Neck = { 14, 0, 0 }, RS = { 44, 0, 36 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { -16, -26, 0, 0, -0.77, -0.14 }, Waist = { -22, -32, 0 }, Neck = { 16, 0, 0 }, RS = { 46, 0, 38 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : coup de pied monté tout raide, la radio levée au ciel comme un trophée
				K_up = {
					label = "Coup de pied volume max", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 88,
					windup = { Root = { -8, 0, 0, 0, -0.25, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 100, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.05, -0.1 }, Waist = { -18, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 176, 0, 16 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.08, -0.12 }, Waist = { -20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 180, 0, 18 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { { "symbols", symbols = { "♪" }, color = PINK, count = 2, radius = 2, at = "above" } }, hitText = "AÏE LA HANCHE !",
				},
				-- K en l'air : pédalage disco, la radio collée à l'oreille (2 touches)
				K_air = {
					label = "Pédalage disco", startup = 0.12, active = 0.2, recovery = 0.2,
					damage = 10, hits = 2, hitbox = box(5, 4, 2.5, -0.5), kbBase = 22, kbGrowth = 45, kbAngle = 40,
					windup = { Root = { -10, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 20 }, RS = { 60, 0, 60 }, RE = { 140, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -6, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 0, 0, 24 }, RS = { 64, 0, 64 }, RE = { 140, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { -4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 0, 0, 26 }, RS = { 66, 0, 66 }, RE = { 140, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "rightFoot", hitText = "TAC TAC !",
				},
				-- dash K : glissade sur le dos à la breakdance, la radio posée sur le ventre, charentaises devant
				K_dash = {
					label = "Glissade sur le dos", startup = 0.1, active = 0.26, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3, -0.8), kbBase = 30, kbGrowth = 65, kbAngle = 38, selfVelocity = Vector2.new(55, 12),
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { 20, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 24, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 52, 0, 22 }, RE = { 112, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "rightFoot", fx = { "dust" }, hitText = "SKRRRT !",
				},
				-- L : rafale de notes : il monte le volume à fond et trois notes foncent sur l'adversaire (visée automatique)
				S_neutral = {
					label = "Rafale de notes", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 5, kbBase = 24, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.6, size = 1.3, color = PINK, visual = NOTE, fan = { count = 3, from = -8, to = 8 } },
					windup = { Root = { -4, -20, 0, 0, -0.25, 0.2 }, Waist = { -8, -26, 0 }, Neck = { 6, 16, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -16, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 100, 0, 6 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 55, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, fx = { { "burst", color = PINK, size = 2, at = "hand" }, { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 4, radius = 2, at = "hand" } }, text = "VOLUME !", hitText = "TUTUTUT !",
				},
				-- →L : cassette-boomerang : il la lance à plat, elle fonce sur l'adversaire en tournoyant, le tranche de sa bande et revient
				S_side = {
					label = "Cassette-boomerang", kind = "projectile", startup = 0.24, active = 0, recovery = 0.5,
					damage = 15, kbBase = 30, kbGrowth = 58, kbAngle = 34,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.9, size = 2, color = CASSETTE, visual = CASSETTE_VISUAL, returns = true },
					windup = { Root = { -2, 30, 0, 0, -0.25, 0.1 }, Waist = { -6, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -8, -15, 0, 0, -0.3, -0.25 }, Waist = { -12, -25, 0 }, Neck = { 0, 10, 0 }, RS = { 92, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, -18, 0, 0, -0.3, -0.28 }, Waist = { -14, -28, 0 }, Neck = { 0, 12, 0 }, RS = { 88, 0, 55 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 72, 0, -22 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					fx = { { "symbols", symbols = { "📼", "♪" }, color = PINK, count = 3, radius = 2, at = "hand" } }, text = "REMBOBINE !", hitText = "TCHAK !",
				},
				-- ↓L : onde de basses : il pose la radio au sol, s'agenouille (aïe) et monte les basses : l'onde roule sur tout le couloir et ralentit
				S_down = {
					label = "Onde de basses", startup = 0.24, active = 0.2, recovery = 0.5,
					damage = 13, hitbox = box(14, 5, 7, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 40,
					status = { name = "slowed", duration = 2 },
					windup = { Root = { -8, 0, 0, 0, -0.5, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.85, -0.2 }, Waist = { -26, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, 20 }, RE = { 20, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -20 }, LE = { 20, 0, 0 }, LW = { -30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -16, 0, 0, 0, -0.87, -0.24 }, Waist = { -28, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 36, 0, 22 }, RE = { 20, 0, 0 }, RW = { -36, 0, 0 }, LS = { 36, 0, -22 }, LE = { 20, 0, 0 }, LW = { -36, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.1, shake = true, fx = { { "ring", color = PINK, radius = 6, at = "front" }, { "beam", color = PINK, length = 14, width = 3, at = "feet" }, { "symbols", symbols = { "♪", "🔊" }, color = PINK, count = 4, radius = 3, at = "front" }, { "shake", amount = 0.3 } },
					text = "BASSES !", hitText = "BWOOOM !",
				},
				-- ↑L : la radio pointée vers le sol, il monte le volume à onze : le souffle des baffles le propulse en diagonale, moustache au vent
				S_up = {
					label = "Décollage à onze", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 76, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { -8, 0, 0, 0, -0.7, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -20, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -42, 0, 0, 0, 0.3, 0 }, Waist = { -4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -50, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -60 }, LE = { 0, 0, 0 }, RH = { -20, 0, 6 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -6 }, LK = { -55, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -46, 0, 0, 0, 0.35, 0 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { -56, 0, 44 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 166, 0, -66 }, LE = { 0, 0, 0 }, RH = { -26, 0, 8 }, RK = { -48, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -8 }, LK = { -62, 0, 0 }, LA = { -30, 0, 0 } },
					shake = true, trail = "body", fx = { { "ring", color = PINK, radius = 5, at = "feet" }, { "symbols", symbols = { "♪", "♫", "🔊" }, color = PINK, count = 6, radius = 3, at = "feet" }, { "particles", tex = "spark", color = BLUE, dir = "down", at = "feet", time = 0.5, speed = 18, size = 0.6, rate = 90 } },
					text = "ONZE !", hitText = "SOUFFLÉ !",
				},
				-- L en l'air : pluie de cassettes : il ouvre le compartiment et toute sa collection tombe sur l'adversaire
				S_air = {
					label = "Pluie de cassettes", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
					damage = 6, kbBase = 24, kbGrowth = 45, kbAngle = -40,
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.2, color = CASSETTE, visual = CASSETTE_VISUAL, rain = { count = 4, spread = 6 } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 20, 0, -10 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 16, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 16, 0, -12 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					fx = { { "symbols", symbols = { "📼" }, color = PINK, count = 4, radius = 3, at = "feet" } }, text = "MA COLLECTION !", hitText = "CLONK !",
				},
				-- Y : le tube de l'été : il lance le morceau, se déhanche, et huit notes géantes foncent sur l'adversaire : tout le monde danse
				SUPER = {
					label = "Le Tube de l'été !", kind = "projectile", startup = 0.38, active = 0, recovery = 0.65,
					damage = 4, kbBase = 25, kbGrowth = 40, kbAngle = 40,
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 1.0, size = 1.6, color = PINK, visual = NOTE, fan = { count = 8, from = -20, to = 40 } },
					status = { name = "dancing", duration = 3 },
					windup = { Root = { -4, 0, -8, 0, -0.3, 0.1 }, Waist = { -8, 0, 8 }, Neck = { 6, 0, 10 }, RS = { 60, 0, 40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -10, 0, 8, 0, -0.3, -0.2 }, Waist = { -12, 0, -8 }, Neck = { 0, 0, -10 }, RS = { 100, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 0, -8, 0, -0.32, -0.24 }, Waist = { -14, 0, 8 }, Neck = { 0, 0, 10 }, RS = { 104, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 174, 0, -34 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					wobble = true, windupFx = { "super", { "text", text = "ÇA, C'EST DU SON !", color = PINK, at = "head" } },
					fx = { { "screen", color = PINK, alpha = 0.2 }, { "symbols", symbols = { "♪", "♫", "🎶", "🕺" }, color = GOLD, count = 10, radius = 6 }, { "shake", amount = 0.4 } },
					text = "LE TUBE DE L'ÉTÉ !", hitText = "ENTRAÎNANT !",
				},
				-- →Y : le mur de son portable : il braque les deux baffles devant lui et pousse tous les potards : une onde énorme traverse le couloir et assomme
				SUPER_side = {
					label = "Mur de son portable !", kind = "projectile", startup = 0.42, active = 0, recovery = 0.7,
					damage = 25, kbBase = 48, kbGrowth = 98, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.8, size = 4.5, color = PINK, pierce = true,
						visual = { shape = "block", size = 4, color = PINK, neon = true, transparency = 0.4, text = "🔊" } },
					status = { name = "stunned", duration = 1 },
					windup = { Root = { -6, -20, 0, 0, -0.3, 0.3 }, Waist = { -10, -24, 0 }, Neck = { 8, 16, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 120, 0, 0 } },
					strike = { Root = { -16, 20, 0, 0, -0.34, -0.5 }, Waist = { -18, 24, 0 }, Neck = { -6, -14, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 4 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -18, 24, 0, 0, -0.36, -0.55 }, Waist = { -22, 28, 0 }, Neck = { -8, -16, 0 }, RS = { 100, 0, -4 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 96, 0, 6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					shake = true, windupFx = { "super", { "symbols", symbols = { "🔊" }, count = 6, radius = 3, color = PINK } },
					fx = { { "burst", color = PINK, size = 4, at = "hand" }, { "ring", color = PINK, radius = 6, at = "front" }, { "shake", amount = 0.5 } },
					text = "MUR DE SON !", hitText = "SOURD !",
				},
				-- ↑Y : volume onze : il brandit la radio au-dessus de sa tête, les baffles explosent en geyser de notes et emportent tout au plafond, lui compris
				SUPER_up = {
					label = "Volume onze !", startup = 0.36, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.9, 0 }, Waist = { -30, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 120, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -6 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 188, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 360 }, trail = "prop",
					windupFx = { "super", { "text", text = "ÇA VA MONTER…", color = PINK, at = "head" } },
					fx = { { "pillar", color = PINK, height = 22, width = 3, at = "front" }, { "beam", color = BLUE, length = 16, width = 5, at = "feet" }, { "symbols", symbols = { "♪", "♫", "🔊" }, color = GOLD, count = 10, radius = 6, at = "above" }, { "shake", amount = 0.5 } },
					text = "VOLUME ONZE !", hitText = "PROPULSÉ PAR LE SON !",
				},
				-- ↓Y : le larsen au sol : il pose la radio par terre, l'antenne contre les baffles : un larsen atroce rampe sur tout le couloir
				SUPER_down = {
					label = "Larsen au sol !", startup = 0.36, active = 0.35, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 42, kbGrowth = 88, kbAngle = 60,
					status = { name = "slowed", duration = 2 },
					windup = { Root = { -10, 0, 0, 0, -0.6, 0.2 }, Waist = { -20, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.9, -0.3 }, Waist = { -30, 0, 0 }, Neck = { 0, 0, 30 }, RS = { 40, 0, 20 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 60, 0, -70 }, LE = { 150, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -18, 0, 0, 0, -0.92, -0.34 }, Waist = { -32, 0, 0 }, Neck = { 0, 0, 34 }, RS = { 36, 0, 22 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 64, 0, -74 }, LE = { 150, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.2, shake = true, windupFx = { "super" },
					fx = { { "beam", color = BLUE, length = 16, width = 3, at = "feet" }, { "symbols", symbols = { "〰️", "🔊" }, color = BLUE, count = 8, radius = 5, at = "front" }, { "shake", amount = 0.5 }, { "screen", color = BLUE, alpha = 0.15 } },
					text = "LARSEN !", hitText = "IIIIIIIH !",
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
		body = {
			head = SKIN, upper = SHIRT, lower = TROUSERS, arms = SHIRT, hands = SKIN, legs = TROUSERS, feet = TARTAN,
			forearms = SKIN,
		},
		cubeHead = 1.25,
		parts = {
			-- l'énorme casque de DJ avec ses lumières
			{ "Arceau", "Head", "block", Vector3.new(1.65, 0.22, 0.35), Vector3.new(0, 0.8, 0), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "EcouteurD", "Head", "cyl", Vector3.new(0.45, 1.05, 1.05), Vector3.new(0.8, 0.05, 0), Vector3.zero, BLACK, "SmoothPlastic", { axis = "x" } },
			{ "EcouteurG", "Head", "cyl", Vector3.new(0.45, 1.05, 1.05), Vector3.new(-0.8, 0.05, 0), Vector3.zero, BLACK, "SmoothPlastic", { axis = "x" } },
			{ "LedD", "Head", "cyl", Vector3.new(0.05, 0.6, 0.6), Vector3.new(1.04, 0.05, 0), Vector3.zero, PINK, "Neon", { axis = "x", neon = true } },
			{ "LedG", "Head", "cyl", Vector3.new(0.05, 0.6, 0.6), Vector3.new(-1.04, 0.05, 0), Vector3.zero, BLUE, "Neon", { axis = "x", neon = true } },
			-- lunettes noires, gros nez, moustache et sourcils blancs, couronne de cheveux
			{ "Lunettes", "Head", "block", Vector3.new(1.15, 0.3, 0.08), Vector3.new(0, 0.12, -0.66), Vector3.zero, BLACK, "Glass", { reflect = 0.4 } },
			{ "Nez", "Head", "ball", Vector3.new(0.32, 0.38, 0.35), Vector3.new(0, -0.08, -0.72), Vector3.zero, SKIN_DARK, "SmoothPlastic" },
			{ "Moustache", "Head", "block", Vector3.new(0.75, 0.16, 0.12), Vector3.new(0, -0.3, -0.68), Vector3.zero, WHITE, "Fabric" },
			{ "Sourcils", "Head", "block", Vector3.new(1.0, 0.1, 0.08), Vector3.new(0, 0.36, -0.66), Vector3.zero, WHITE, "Fabric" },
			{ "Cheveux", "Head", "block", Vector3.new(1.3, 0.4, 0.2), Vector3.new(0, 0.05, 0.62), Vector3.zero, WHITE, "Fabric" },
			-- chaînes dorées, gros médaillon, bretelles
			{ "Medaillon", "UpperTorso", "cyl", Vector3.new(0.1, 0.6, 0.6), Vector3.new(0, -0.2, -0.58), Vector3.zero, GOLD, "Foil", { axis = "z", reflect = 0.3 } },
			{ "ChaineD", "UpperTorso", "block", Vector3.new(0.12, 1.05, 0.1), Vector3.new(0.28, 0.3, -0.53), Vector3.new(0, 0, 25), GOLD, "Foil" },
			{ "ChaineG", "UpperTorso", "block", Vector3.new(0.12, 1.05, 0.1), Vector3.new(-0.28, 0.3, -0.53), Vector3.new(0, 0, -25), GOLD, "Foil" },
			{ "BretelleD", "UpperTorso", "block", Vector3.new(0.2, 1.6, 0.06), Vector3.new(0.65, 0, -0.52), Vector3.zero, RED, "Fabric" },
			{ "BretelleG", "UpperTorso", "block", Vector3.new(0.2, 1.6, 0.06), Vector3.new(-0.65, 0, -0.52), Vector3.zero, RED, "Fabric" },
			-- petit bedon et ceinture remontée
			{ "Ventre", "LowerTorso", "ball", Vector3.new(1.7, 1.1, 0.9), Vector3.new(0, 0.35, -0.2), Vector3.zero, SHIRT, "Fabric" },
			{ "Ceinture", "LowerTorso", "block", Vector3.new(2.05, 0.25, 1.15), Vector3.new(0, 0.05, 0), Vector3.zero, Color3.fromRGB(90, 60, 40), "Fabric" },
			{ "Montre", "LeftLowerArm", "block", Vector3.new(0.6, 0.2, 0.6), Vector3.new(0, -0.45, 0), Vector3.zero, GOLD, "Foil" },
			-- les charentaises à pompon
			{ "ChaussonD", "RightFoot", "block", Vector3.new(0.9, 0.45, 1.3), Vector3.new(0, 0.05, -0.15), Vector3.zero, TARTAN, "Fabric" },
			{ "ChaussonG", "LeftFoot", "block", Vector3.new(0.9, 0.45, 1.3), Vector3.new(0, 0.05, -0.15), Vector3.zero, TARTAN, "Fabric" },
			{ "PomponD", "RightFoot", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, 0.3, -0.75), Vector3.zero, WHITE, "Fabric" },
			{ "PomponG", "LeftFoot", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, 0.3, -0.75), Vector3.zero, WHITE, "Fabric" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : un vinyle tranchant tenu par la tranche
			{ name = "PropVinyles", hand = "Right", visible = true, pieces = {
				{ "Vinyle", "", "cyl", Vector3.new(0.08, 1.7, 1.7), Vector3.new(0, -0.95, 0), Vector3.zero, BLACK, "SmoothPlastic", { axis = "x" } },
				{ "Sillons", "", "cyl", Vector3.new(0.1, 1.2, 1.2), Vector3.new(0, -0.95, 0), Vector3.zero, Color3.fromRGB(50, 50, 58), "SmoothPlastic", { axis = "x", reflect = 0.2 } },
				{ "Etiquette", "", "cyl", Vector3.new(0.12, 0.55, 0.55), Vector3.new(0, -0.95, 0), Vector3.zero, RED, "SmoothPlastic", { axis = "x" } },
			} },
			-- la platine, tenue de la main gauche comme un plateau de DJ
			{ name = "PropPlatine", hand = "Left", visible = false, pieces = {
				{ "Caisson", "", "block", Vector3.new(0.4, 1.9, 1.7), Vector3.new(0, -0.95, 0), Vector3.zero, BLACK, "SmoothPlastic" },
				{ "Plateau", "", "cyl", Vector3.new(0.1, 1.35, 1.35), Vector3.new(0.25, -0.95, 0), Vector3.zero, SILVER, "Metal", { axis = "x" } },
				{ "Disque", "", "cyl", Vector3.new(0.12, 1.2, 1.2), Vector3.new(0.3, -0.95, 0), Vector3.zero, BLACK, "SmoothPlastic", { axis = "x" } },
				{ "Bras", "", "block", Vector3.new(0.1, 0.9, 0.08), Vector3.new(0.3, -0.5, 0.6), Vector3.new(30, 0, 0), SILVER, "Metal" },
				{ "Led", "", "block", Vector3.new(0.42, 0.1, 1.7), Vector3.new(0, -1.85, 0), Vector3.zero, PINK, "Neon", { neon = true } },
			} },
			-- le câble jack qui fouette les chevilles
			{ name = "PropJack", hand = "Right", visible = false, pieces = {
				{ "Cable", "", "cyl", Vector3.new(3.6, 0.14, 0.14), Vector3.new(0, -1.9, 0), Vector3.zero, BLACK, "SmoothPlastic", { axis = "y" } },
				{ "Manchon", "", "cyl", Vector3.new(0.4, 0.3, 0.3), Vector3.new(0, -3.8, 0), Vector3.zero, BLACK, "SmoothPlastic", { axis = "y" } },
				{ "Fiche", "", "cyl", Vector3.new(0.5, 0.16, 0.16), Vector3.new(0, -4.2, 0), Vector3.zero, GOLD, "Foil", { axis = "y" } },
			} },
			-- le pied de micro (manié comme un bâton)
			{ name = "PropPiedMicro", hand = "Right", visible = false, pieces = {
				{ "Tige", "", "cyl", Vector3.new(4.2, 0.14, 0.14), Vector3.new(0, -1.6, 0), Vector3.zero, SILVER, "Metal", { axis = "y" } },
				{ "Micro", "", "ball", Vector3.new(0.5, 0.7, 0.5), Vector3.new(0, -3.9, 0), Vector3.zero, BLACK, "SmoothPlastic" },
				{ "Grille", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(0, -4.25, 0), Vector3.zero, SILVER, "Metal" },
				{ "Pied", "", "cyl", Vector3.new(0.15, 1, 1), Vector3.new(0, 0.5, 0), Vector3.zero, BLACK, "Metal", { axis = "y" } },
			} },
			-- le mégaphone (Montée du son)
			{ name = "PropMegaphone", hand = "Right", visible = false, pieces = {
				{ "Corps", "", "cyl", Vector3.new(1.2, 0.5, 0.5), Vector3.new(0, -0.6, 0), Vector3.zero, WHITE, "SmoothPlastic", { axis = "y" } },
				{ "Pavillon", "", "cyl", Vector3.new(0.4, 1.15, 1.15), Vector3.new(0, -1.35, 0), Vector3.zero, RED, "SmoothPlastic", { axis = "y" } },
			} },
			-- la charentaise retirée du pied pour une bonne fessée
			{ name = "PropCharentaise", hand = "Right", visible = false, pieces = {
				{ "Semelle", "", "block", Vector3.new(0.4, 1.5, 0.85), Vector3.new(0, -0.85, 0), Vector3.zero, TARTAN, "Fabric" },
				{ "Pompon", "", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, -1.45, -0.4), Vector3.zero, WHITE, "Fabric" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de vinyle : voûté, main gauche dans le dos, il pique avec le vinyle comme avec une dague
		P_neutral = {
			label = "Coup de vinyle", startup = 0.08, active = 0.08, recovery = 0.14,
			damage = 6, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 20, kbGrowth = 25, kbAngle = 25,
			windup = { Root = { -4, -12, 0, 0, -0.25, 0.1 }, Waist = { -10, -15, 0 }, Neck = { 6, 10, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, 14, 0, 0, -0.28, -0.25 }, Waist = { -14, 16, 0 }, Neck = { 8, -8, 0 }, RS = { 95, 0, -5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -9, 16, 0, 0, -0.28, -0.28 }, Waist = { -15, 18, 0 }, Neck = { 8, -10, 0 }, RS = { 92, 0, -8 }, RE = { 14, 0, 0 }, RW = { -8, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			trail = "prop", hitText = "SCRITCH !",
		},
		-- P P : Coup de charentaise, il retire sa pantoufle et la claque en revers
		P_combo2 = {
			label = "Coup de charentaise", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(4.5, 3.5, 2.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { 0, -25, 0, 0, -0.2, 0.1 }, Waist = { -6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 150, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, 20, 0, 0, -0.28, -0.3 }, Waist = { -12, 25, 0 }, Neck = { 0, -10, 0 }, RS = { 80, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -8, 24, 0, 0, -0.28, -0.32 }, Waist = { -13, 28, 0 }, Neck = { 0, -12, 0 }, RS = { 60, 0, -25 }, RE = { 30, 0, 0 }, RW = { -15, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			prop = "charentaise", hideProp = "vinyles", trail = "prop", hitText = "FLAP !",
		},
		-- P P P : Coup de 33 tours, vinyle levé à deux mains au-dessus de la tête puis abattu
		P_combo3 = {
			label = "Coup de 33 tours", startup = 0.09, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 2.5, 1), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 6, -8, 0, 0, -0.1, 0.2 }, Waist = { 10, -10, 0 }, Neck = { 15, 0, 0 }, RS = { 190, 0, 15 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -15 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, -0.45, -0.35 }, Waist = { -28, 10, 0 }, Neck = { -10, 0, 0 }, RS = { 75, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -5 }, LE = { 10, 0, 0 } },
			follow = { Root = { -14, 10, 0, 0, -0.5, -0.4 }, Waist = { -32, 12, 0 }, Neck = { -12, 0, 0 }, RS = { 50, 0, 5 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 48, 0, -5 }, LE = { 15, 0, 0 } },
			trail = "prop", text = "33 TOURS !", hitText = "SCHRAK !",
		},
		-- Scratch : double frappe en se dandinant, le vinyle va et vient comme sur la platine
		P_side = {
			label = "Scratch", startup = 0.1, active = 0.16, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5, 3, 3, 0.6), kbBase = 20, kbGrowth = 30, kbAngle = 25, selfVelocity = Vector2.new(15, 0),
			windup = { Root = { 0, -10, -8, 0, -0.25, 0.15 }, Waist = { -8, -15, 6 }, Neck = { 10, 0, -8 }, RS = { 80, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, 12, 8, 0, -0.3, -0.25 }, Waist = { -10, 15, -6 }, Neck = { 10, 0, 8 }, RS = { 92, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -6, -8, -8, 0, -0.3, -0.3 }, Waist = { -10, -10, 6 }, Neck = { 10, 0, -8 }, RS = { 90, 0, 25 }, RE = { 25, 0, 0 }, RW = { 10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 3, radius = 2 } }, hitText = "WIKI-WIKI !",
		},
		-- Câble jack : penché (il ne peut plus s'accroupir), il fouette les chevilles avec le câble
		P_down = {
			label = "Câble jack", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(6.5, 2, 3.5, -2), kbBase = 25, kbGrowth = 20, kbAngle = 70,
			windup = { Root = { -6, -20, 0, 0, -0.45, 0.15 }, Waist = { -20, -20, 0 }, Neck = { 10, 15, 0 }, RS = { 120, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 15, 0, 0, -0.55, -0.1 }, Waist = { -28, 20, 0 }, Neck = { 15, -5, 0 }, RS = { 30, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -10, 22, 0, 0, -0.55, -0.12 }, Waist = { -30, 26, 0 }, Neck = { 15, -8, 0 }, RS = { 15, 0, -20 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			prop = "jack", hideProp = "vinyles", trail = "prop", hitText = "CLAC !",
		},
		-- Coup de casque (anti-air) : recroquevillé, mains sur le casque, il se redresse d'un coup, casque en avant
		P_up = {
			label = "Coup de casque", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 5, 1, 3.5), kbBase = 28, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -10, 0, 0, 0, -0.55, 0 }, Waist = { -25, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 60, 0, 40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 120, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.25, 0 }, Waist = { 15, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 150, 0, 45 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -45 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.3, 0 }, Waist = { 18, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 155, 0, 48 }, RE = { 55, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -48 }, LE = { 55, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			trail = "head", fx = { { "symbols", symbols = { "♪", "🎧" }, color = BLUE, count = 3, radius = 2 } }, hitText = "BOUM-TCHAK !",
		},
		-- Pas chassé disco (dash puis P) : glissé latéral, doigt gauche pointé au ciel, vinyle en avant
		P_dash = {
			label = "Pas chassé disco", startup = 0.08, active = 0.14, recovery = 0.24,
			damage = 8, hitbox = box(5, 3, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 30, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { 0, -20, -6, 0, -0.3, 0.1 }, Waist = { -6, -20, 0 }, Neck = { 0, 15, 0 }, RS = { 40, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 0, 0, 0 } },
			strike = { Root = { -10, 15, 6, 0, -0.35, -0.35 }, Waist = { -10, 18, 0 }, Neck = { 0, -10, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -11, 18, 6, 0, -0.35, -0.4 }, Waist = { -11, 20, 0 }, Neck = { 0, -12, 0 }, RS = { 92, 0, -8 }, RE = { 0, 0, 0 }, RW = { -6, 0, 0 }, LS = { 152, 0, -32 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", text = "DISCO !", hitText = "SCHLING !",
		},
		-- Casque balancé (P en l'air) : un grand coup de tête de rockeur, le casque fend l'air
		P_air = {
			label = "Casque balancé", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 1.5, 0.5), kbBase = 22, kbGrowth = 38, kbAngle = 40,
			windup = { Root = { 0, -25, 0 }, Waist = { -5, -30, 0 }, Neck = { 10, -20, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -10, 25, 0 }, Waist = { -15, 30, 0 }, Neck = { -30, 20, 0 }, RS = { 30, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -12, 30, 0 }, Waist = { -16, 34, 0 }, Neck = { -34, 24, 0 }, RS = { 28, 0, 62 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 28, 0, -62 }, LE = { 30, 0, 0 }, RH = { 38, 0, 0 }, RK = { -58, 0, 0 }, LH = { 62, 0, 0 }, LK = { -90, 0, 0 } },
			trail = "head", hitText = "HEADBANG !",
		},
		-- Coup de charentaise : genou levé tout raide, la pantoufle s'envole au bout du coup de pied
		K_neutral = {
			label = "Coup de charentaise", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.15 }, Waist = { 0, -8, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 75, 0, 0 }, RK = { -100, 0, 0 }, RA = { -10, 0, 0 } },
			strike = { Root = { 16, -4, 0, 0, -0.12, 0.05 }, Waist = { 12, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 50, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { 95, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 18, -2, 0, 0, -0.12, 0.08 }, Waist = { 14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 52, 0, 64 }, RE = { 20, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", fx = { { "toss", shape = "flat", color = TARTAN, size = 0.8, count = 1, speed = 20 } }, hitText = "FLAP !",
		},
		-- K K : Charentaise gauche, même coup de pied tout raide, de l'autre pied
		K_combo2 = {
			label = "Charentaise gauche", startup = 0.09, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 6, 12, 0, 0, -0.2, 0.1 }, Waist = { 0, 8, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, LH = { 75, 0, 0 }, LK = { -100, 0, 0 }, LA = { -10, 0, 0 } },
			strike = { Root = { 16, 6, 0, 0, -0.12, -0.05 }, Waist = { 12, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, LS = { 50, 0, -60 }, LE = { 20, 0, 0 }, LH = { 95, 0, 0 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 18, 8, 0, 0, -0.12, -0.08 }, Waist = { 14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 62, 0, 42 }, RE = { 40, 0, 0 }, LS = { 52, 0, -64 }, LE = { 20, 0, 0 }, LH = { 100, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "leftFoot", hitText = "FLOP !",
		},
		-- K K K : Grand écart rouillé, bras en « ta-da » puis il tombe en grand écart… et se bloque le dos
		K_combo3 = {
			label = "Grand écart rouillé", startup = 0.1, active = 0.12, recovery = 0.38,
			damage = 12, hitbox = box(7, 3.5, 2.5, -0.5), kbBase = 32, kbGrowth = 80, kbAngle = 45,
			windup = { Root = { 0, 0, 0, 0, 0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 40 }, RE = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 0, 0, 0, 0, -1.0, 0 }, Waist = { -5, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 80 }, RE = { 0, 0, 0 }, LS = { 90, 0, -80 }, LE = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -70, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -1.05, 0 }, Waist = { -12, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 60 }, RE = { 10, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -72, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "GRAND ÉCART !", hitText = "CRAC… MON DOS !",
		},
		-- Pied de micro : il manie le pied de micro comme une lance et le plante droit devant (grande allonge)
		K_side = {
			label = "Pied de micro", startup = 0.22, active = 0.12, recovery = 0.34,
			damage = 13, hitbox = box(7.5, 2.5, 4.5, 0.8), kbBase = 32, kbGrowth = 85, kbAngle = 28, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { 6, -30, 0, 0, -0.25, 0.3 }, Waist = { 0, -25, 0 }, Neck = { 0, 15, 0 }, RS = { 70, 0, 40 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, 20, 0, 0, -0.3, -0.45 }, Waist = { -8, 22, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 15 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -12, 22, 0, 0, -0.32, -0.5 }, Waist = { -9, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 90, 0, -2 }, RE = { 0, 0, 0 }, RW = { -4, 0, 0 }, LS = { 84, 0, 14 }, LE = { 22, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "piedMicro", hideProp = "vinyles", trail = "prop", text = "UN, DEUX, UN, DEUX…", hitText = "TSOING !",
		},
		-- Glissade sur parquet : il glisse sur le dos comme sur un parquet ciré, les charentaises devant, bras en l'air
		K_down = {
			label = "Glissade sur parquet", startup = 0.18, active = 0.25, recovery = 0.35,
			damage = 12, hitbox = box(7, 2, 3, -2), kbBase = 30, kbGrowth = 60, kbAngle = 60, selfVelocity = Vector2.new(45, 0),
			windup = { Root = { -10, 0, 0, 0, -0.6, 0 }, Waist = { -20, 0, 0 }, RS = { 50, 0, 40 }, RE = { 40, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 45, 0, 0, 0, -1.5, 0 }, Waist = { -25, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 150, 0, 50 }, RE = { 10, 0, 0 }, LS = { -40, 0, -30 }, LE = { 100, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 70, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 50, 0, 4, 0, -1.55, 0 }, Waist = { -28, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 160, 0, 55 }, RE = { 15, 0, 0 }, LS = { -42, 0, -32 }, LE = { 100, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 }, LH = { 75, 0, 0 }, LK = { -15, 0, 0 } },
			trail = "bothFeet", fx = { { "particles", tex = "spark", color = GOLD, dir = "up", at = "feet", time = 0.3, speed = 6, size = 0.4, rate = 60 } }, hitText = "ZIIIP !",
		},
		-- Rewind (↑K, ex-recul) : petit moonwalk en arrière puis grand coup de pied vers le ciel
		K_up = {
			label = "Rewind", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(4, 5, 2, 2.5), kbBase = 32, kbGrowth = 70, kbAngle = 82, selfVelocity = Vector2.new(-25, 0),
			windup = { Root = { -6, 0, 0, 0, -0.3, 0.2 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.1, 0.3 }, Waist = { 15, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 22, 0, 0, 0, -0.1, 0.35 }, Waist = { 16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -32, 0, 62 }, RE = { 20, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { 155, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { { "symbols", symbols = { "⏪" }, color = BLUE, count = 2, radius = 2 } }, text = "REWIND !", hitText = "SCRATCH-BOUM !",
		},
		-- Glissade à genoux (dash puis K) : comme une rock star, il glisse à genoux bras au ciel… aïe
		K_dash = {
			label = "Glissade à genoux", startup = 0.1, active = 0.25, recovery = 0.32,
			damage = 10, hitbox = box(5, 3, 2.5, -0.5), kbBase = 30, kbGrowth = 60, kbAngle = 40, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -15, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -1.3, 0 }, Waist = { 25, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, RH = { -10, 0, 0 }, RK = { -100, 0, 0 }, LH = { -10, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -1.3, 0 }, Waist = { 28, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 165, 0, 45 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -45 }, LE = { 10, 0, 0 }, RH = { -10, 0, 0 }, RK = { -100, 0, 0 }, LH = { -10, 0, 0 }, LK = { -100, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = GOLD, dir = "up", at = "feet", time = 0.3, speed = 6, size = 0.4, rate = 70 } },
			text = "AÏE MES GENOUX !", hitText = "YEEEAH !",
		},
		-- Coup de talon rouillé (K en l'air) : une main dans le dos, il détend une seule jambe toute raide, la charentaise s'envole… aïe la hanche
		K_air = {
			label = "Coup de talon rouillé", startup = 0.16, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5.5, 4, 2.8, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -8, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 40 }, RE = { 70, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 18, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -40, 0, 55 }, RE = { 20, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { 92, 0, 0 }, RK = { -2, 0, 0 }, RA = { 15, 0, 0 }, LH = { 10, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 22, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -45, 0, 58 }, RE = { 20, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 5, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "rightFoot", fx = { { "toss", shape = "flat", color = TARTAN, size = 0.8, count = 1, speed = 20 }, { "text", text = "CRAC", color = WHITE, at = "root" } }, hitText = "FLAP ! AÏE MA HANCHE !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : Saut de scène, il plonge à plat ventre dans le public imaginaire, bras tendus
		P_air_side = {
			label = "Saut de scène", startup = 0.12, active = 0.18, recovery = 0.25,
			damage = 8, hitbox = box(6, 3, 3, 0), kbBase = 24, kbGrowth = 40, kbAngle = 25, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 10, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -70, 0, 0 }, Waist = { -5, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -40 }, LE = { 0, 0, 0 }, RH = { -10, 0, 0 }, RK = { -20, 0, 0 }, LH = { -10, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { -75, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 172, 0, 44 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, -44 }, LE = { 0, 0, 0 }, RH = { -12, 0, 0 }, RK = { -25, 0, 0 }, LH = { -8, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "body", text = "SAUT DE SCÈNE !", hitText = "SPLATCH !",
		},
		-- ↑ P en l'air : Vinyle au plafond, recroquevillé puis le vinyle balaie l'air au-dessus de sa tête
		P_air_up = {
			label = "Vinyle au plafond", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -15, 0, 0 }, RS = { -30, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 15, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -30 }, LE = { 90, 0, 0 }, RH = { 0, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 18, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 198, 0, 5 }, RE = { 8, 0, 0 }, RW = { -15, 0, 0 }, LS = { -32, 0, -32 }, LE = { 90, 0, 0 }, RH = { -5, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", hitText = "TCHIIING !",
		},
		-- ↓ P en l'air : Vinyle plongeant, le vinyle levé haut puis abattu droit vers le bas (smash vers le sol)
		P_air_down = {
			label = "Vinyle plongeant", startup = 0.15, active = 0.1, recovery = 0.28,
			damage = 9, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78,
			windup = { Root = { 15, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 190, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -18, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 5, 0, 0 }, RS = { 50, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 15, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -22, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 25, 0, 0 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 10, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "prop", hitText = "KRRRSH !",
		},
		-- → K en l'air : Coup de pied disco, jambe tendue de côté et index pointé vers la boule à facettes
		K_air_side = {
			label = "Coup de pied disco", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -14, 20, 0 }, Waist = { -16, 10, 0 }, RS = { 60, 0, 40 }, RE = { 80, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 28, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, 0, 0 }, RS = { 170, 0, 20 }, RE = { 0, 0, 0 }, LS = { -60, 0, -30 }, LE = { 20, 0, 0 }, RH = { 65, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 32, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, 0, 0 }, RS = { 172, 0, 22 }, RE = { 0, 0, 0 }, LS = { -62, 0, -32 }, LE = { 20, 0, 0 }, RH = { 68, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", text = "DISCO !", hitText = "FIÈVRE !",
		},
		-- ↑ K en l'air : Pédalage de tricycle, il pédale dans le vide et ses pieds cognent vers le haut (2 touches)
		K_air_up = {
			label = "Pédalage de tricycle", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 5, hits = 2, hitbox = box(4, 5, 0.5, 3), kbBase = 28, kbGrowth = 55, kbAngle = 85,
			windup = { Root = { -15, 0, 0 }, Waist = { -15, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 120, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 25, 0, 0 }, Waist = { 5, 0, 0 }, Neck = { 15, 0, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { -30, 0, -60 }, LE = { 20, 0, 0 }, RH = { 160, 0, 0 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 100, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 18, 0, 0 }, RS = { -32, 0, 62 }, RE = { 20, 0, 0 }, LS = { -32, 0, -62 }, LE = { 20, 0, 0 }, RH = { 110, 0, 0 }, RK = { -100, 0, 0 }, LH = { 165, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", text = "DRING DRING !", hitText = "POUET !",
		},
		-- ↓ K en l'air : Atterrissage arthrose, il retombe pieds joints de tout son poids (smash vers le sol)
		K_air_down = {
			label = "Atterrissage arthrose", startup = 0.18, active = 0.15, recovery = 0.32,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -55),
			windup = { Root = { -6, 0, 0 }, Waist = { -15, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 160, 0, 45 }, RE = { 10, 0, 0 }, LS = { -42, 0, -25 }, LE = { 100, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "MES ROTULES !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Vinyle-boomerang (L) : lancer en revers comme un frisbee, le disque fonce sur l'adversaire, le tranche et revient dans sa main
		S_neutral = {
			label = "Vinyle-boomerang", kind = "projectile", startup = 0.2, active = 0, recovery = 0.45,
			damage = 13, kbBase = 24, kbGrowth = 45, kbAngle = 30,
			projectile = { speed = 65, angle = 0, gravity = 0, lifetime = 1.0, size = 2, color = BLACK, returns = true, visual = VINYL },
			windup = { Root = { 0, 30, 0, 0, -0.25, 0.1 }, Waist = { -6, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, -15, 0, 0, -0.3, -0.25 }, Waist = { -10, -25, 0 }, Neck = { 0, 10, 0 }, RS = { 92, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -7, -18, 0, 0, -0.3, -0.28 }, Waist = { -11, -28, 0 }, Neck = { 0, 12, 0 }, RS = { 88, 0, 55 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			hideProp = "vinyles", fx = { { "symbols", symbols = { "♪", "💿" }, color = PINK, count = 3, radius = 2, at = "hand" } }, text = "ALLER-RETOUR !", hitText = "TCHAK !",
		},
		-- Drop des basses (→L) : il lève le poing et l'abat sur un bouton imaginaire, l'onde de basse file droit sur l'adversaire
		-- et la Playlist passe au morceau suivant
		S_side = {
			label = "Drop des basses", kind = "projectile", startup = 0.22, active = 0, recovery = 0.5,
			damage = 14, kbBase = 35, kbGrowth = 60, kbAngle = 15,
			selfEffect = { nextTrack = true },
			projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.5, size = 4.5, color = PINK, pierce = true,
				visual = { shape = "block", size = 3.5, color = PINK, neon = true, transparency = 0.45 } },
			windup = { Root = { 6, 0, 0, 0, -0.05, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 175, 0, 15 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.45, -0.15 }, Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.5, -0.18 }, Waist = { -24, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 55, 0, 5 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			hold = 0.1,
			windupFx = { { "text", text = "ATTENTION…", color = PINK } },
			fx = { { "ring", color = PINK, radius = 6, at = "front" }, { "symbols", symbols = { "♪", "♫", "🔊" }, color = PINK, count = 4, radius = 3 }, { "shake", amount = 0.3 } },
			text = "DROP !", hitText = "BWOOOM !",
		},
		-- Mur d'enceintes (↓L) : il tape du pied et lève les bras : deux baffles jaillissent du sol, l'onde de basse balaie tout le couloir
		-- et le mur bloque ensuite les tirs
		S_down = {
			label = "Mur d'enceintes", kind = "wall", startup = 0.25, active = 0.12, recovery = 0.5,
			hitbox = box(14, 6, 7, 1), kbBase = 30, kbGrowth = 50, kbAngle = 60,
			damage = 12,
			wall = { size = Vector3.new(2.6, 6, 6), offset = 3.5, lifetime = 5, max = 2, visual = SPEAKERS, color = BLACK },
			windup = { Root = { -6, 0, 0, 0, -0.45, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, -0.05, -0.1 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 5, 0, 0, 0, -0.05, 0 }, Waist = { 12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 165, 0, 32 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -32 }, LE = { 10, 0, 0 } },
			fx = { { "burst", color = PINK, size = 3, at = "front" }, { "beam", color = PINK, length = 16, width = 3, at = "front" }, { "symbols", symbols = { "♪", "🔊" }, color = PINK, count = 4, radius = 3, at = "front" }, { "shake", amount = 0.3 } },
			text = "MUR DE SON !", hitText = "BAFFLE DANS LE NEZ !",
		},
		-- Stage diving (↑L, remontée) : il se jette en diagonale dans une foule imaginaire, bras en croix, casque au vent, charentaises
		-- derrière : la foule le porte vers le haut et il emporte tout ce qu'il croise au passage
		S_up = {
			label = "Stage diving", startup = 0.15, active = 0.3, recovery = 0.45,
			damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 45, kbAngle = 80, selfVelocity = Vector2.new(42, 80),
			windup = { Root = { 6, 0, 0, 0, -0.7, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -35, 0, 35 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -48, 0, 0, 0, 0.3, 0 }, Waist = { 6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 150, 0, 70 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -70 }, LE = { 0, 0, 0 }, RH = { -25, 0, 8 }, RK = { -35, 0, 0 }, RA = { -30, 0, 0 }, LH = { -35, 0, -8 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -52, 0, 0, 0, 0.35, 0 }, Waist = { 8, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 155, 0, 75 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -75 }, LE = { 0, 0, 0 }, RH = { -30, 0, 10 }, RK = { -45, 0, 0 }, RA = { -30, 0, 0 }, LH = { -40, 0, -10 }, LK = { -60, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "body", fx = { { "burst", color = GOLD, size = 3, at = "feet" }, { "symbols", symbols = { "🙌", "🙌", "♪" }, color = GOLD, count = 6, radius = 3, at = "feet" }, { "particles", tex = "spark", color = PINK, dir = "down", at = "feet", time = 0.4, speed = 12, rate = 90 } },
			text = "STAGE DIVING !", hitText = "PORTÉ PAR LA FOULE !",
		},
		-- Rewind Drop (↓L en l'air) : il pique droit vers le sol, vinyle brandi, et l'impact fait sauter tout ce qui est en dessous
		S_air_down = {
			label = "Rewind Drop", startup = 0.16, active = 0.4, recovery = 0.5,
			damage = 14, hitbox = box(8, 5, 0, -2), kbBase = 28, kbGrowth = 65, kbAngle = -78, selfVelocity = Vector2.new(0, -105),
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 160, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 0, 0, 3 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, -3 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 162, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 0, 0, 4 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, -4 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "body", fx = { { "burst", color = BLUE, size = 3.5, at = "feet" }, { "ring", color = BLUE, radius = 6, at = "feet" }, { "symbols", symbols = { "⏪" }, color = BLUE, count = 2, radius = 2 } },
			text = "REWIND DROP !", hitText = "BADABOUM !",
		},
		-- Rewind (ESQUIVE puis L) : il fouette tout le couloir avec le câble jack, puis tourne les bras comme une bande qu'on
		-- rembobine et revient 12 studs en arrière (invulnérable)
		S_dodge = {
			label = "Rewind", startup = 0.15, active = 0.12, recovery = 0.45,
			damage = 12, hitbox = box(14, 5, 7, 0.6), kbBase = 30, kbGrowth = 55, kbAngle = 35, teleport = -12, invuln = 0.3,
			windup = { Root = { 4, -30, 0, 0, -0.25, 0.15 }, Waist = { 0, -35, 0 }, Neck = { 6, 25, 0 }, RS = { 130, 0, 45 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 25, 0, 0, -0.35, -0.35 }, Waist = { -12, 30, 0 }, Neck = { 0, -15, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 10, 0, 0, 0, -0.15, 0.3 }, Waist = { 8, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 120, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -30 }, LE = { 80, 0, 0 } },
			spin = { axis = "y", degrees = -360 }, prop = "jack", hideProp = "vinyles", trail = "prop",
			windupFx = { { "symbols", symbols = { "⏪", "⏪" }, color = BLUE, count = 3, radius = 2 } },
			fx = { { "beam", color = BLACK, length = 15, width = 1.2, at = "hand" }, { "ring", color = BLUE, radius = 3, at = "root" } }, text = "REWIND !", hitText = "CLAC ! REMBOBINÉ !",
		},
		-- Changer de piste (S maintenu) : platine dans la main gauche, il scratche comme un forcené ; l'onde repousse tout autour de lui,
		-- des deux côtés, et la Playlist passe au morceau suivant
		S_hold = {
			label = "Changer de piste", startup = 0.3, active = 0.15, recovery = 0.6,
			damage = 14, hitbox = box(24, 7, 0, 1), kbBase = 30, kbGrowth = 55, kbAngle = 50,
			selfEffect = { nextTrack = true },
			windup = { Root = { 0, 0, 0, 0, -0.25, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, -10, 0 }, RS = { 70, 0, -10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 0, 0, -6, 0, -0.3, 0 }, Waist = { -12, 0, 6 }, Neck = { -20, 0, 10 }, RS = { 75, 0, -30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 6, 0, -0.3, 0 }, Waist = { -12, 0, -6 }, Neck = { -20, 0, -10 }, RS = { 75, 0, -5 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			hold = 0.3, shake = true, wobble = true, prop = "platine",
			fx = { { "ring", color = PINK, radius = 12, at = "root" }, { "pillar", color = BLUE, height = 8, width = 4, at = "root" }, { "symbols", symbols = { "♪", "♫", "⏭️" }, color = BLUE, count = 6, radius = 4 }, { "shake", amount = 0.3 } },
			text = "CHANGEMENT DE PISTE !", hitText = "WIKI-WIKI !",
		},
		-- Pas de danse rétro (→→L) : twist endiablé lancé en avant, les hanches d'abord, il traverse tout le couloir en dansant
		S_dash = {
			label = "Pas de danse rétro", startup = 0.15, active = 0.3, recovery = 0.5,
			damage = 13, hitbox = box(14, 6, 7, 0.5), kbBase = 28, kbGrowth = 55, kbAngle = 35, selfVelocity = Vector2.new(60, 0), invuln = 0.15,
			windup = { Root = { 0, -30, -8, 0, -0.3, 0 }, Waist = { 0, -20, 8 }, RS = { 60, 0, 60 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 90, 0, 0 } },
			strike = { Root = { -10, 30, 8, 0, -0.35, -0.3 }, Waist = { -6, 20, -8 }, Neck = { 10, -10, 0 }, RS = { 160, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -10, -20, -8, 0, -0.35, -0.35 }, Waist = { -6, -15, 8 }, Neck = { 10, 10, 0 }, RS = { 150, 0, 35 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -32, 0, -42 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "♪", "🕺" }, color = GOLD, count = 4, radius = 2.5 }, { "particles", tex = "spark", color = GOLD, dir = "front", at = "feet", time = 0.3, speed = 10, rate = 70 } },
			text = "PAS DE DANSE RÉTRO", hitText = "TWIST !",
		},
		-- Pluie de vinyles (L en l'air) : il lance sa pile de disques en l'air, ils retombent pile sur la tête de l'adversaire
		S_air = {
			label = "Pluie de vinyles", kind = "projectile", startup = 0.2, active = 0, recovery = 0.45,
			damage = 12, kbBase = 22, kbGrowth = 40, kbAngle = 60,
			projectile = { speed = 55, gravity = 0, lifetime = 0.8, size = 2, color = BLACK, visual = VINYL,
				rain = { count = 3, spread = 3, ahead = 8, height = 18 } },
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 25 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -25 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -30 }, LE = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			hideProp = "vinyles", fx = { { "symbols", symbols = { "💿", "♪" }, color = PINK, count = 4, radius = 3 } },
			text = "PLUIE DE VINYLES !", hitText = "CLONK !",
		},

		------------------------------------------------------------------ Suites d'enchaînement (voir LINKS en bas)
		-- P puis K : Genou arthritique, il remonte le genou dans le ventre adverse en se tenant le dos… CRAC, ça craque de partout
		PK_combo = {
			label = "Genou arthritique", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 45,
			windup = { Root = { 6, 0, 0, 0, -0.25, 0.15 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -30, 0, 30 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -15, 0, 0 }, RK = { -40, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, 0.05, -0.3 }, Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -45, 0, 25 }, RE = { 60, 0, 0 }, LS = { -45, 0, -25 }, LE = { 100, 0, 0 }, RH = { 115, 0, 0 }, RK = { -125, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, 0.08, -0.35 }, Waist = { -22, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -48, 0, 25 }, RE = { 60, 0, 0 }, LS = { -48, 0, -25 }, LE = { 100, 0, 0 }, RH = { 120, 0, 0 }, RK = { -128, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightLeg", fx = { { "text", text = "CRAC", color = WHITE, at = "root" } }, hitText = "GNOC ! AÏE MON GENOU !",
		},
		-- K puis P : Scratch en pleine face, le vinyle frotte d'avant en arrière sur le nez de l'adversaire (2 touches), wiki-wiki
		KP_combo = {
			label = "Scratch en pleine face", startup = 0.07, active = 0.16, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5, 3.5, 2.8, 0.8), kbBase = 20, kbGrowth = 32, kbAngle = 35,
			windup = { Root = { 0, 10, 0, 0, -0.25, 0.1 }, Waist = { -8, 12, 0 }, Neck = { 8, -8, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, -12, 0, 0, -0.3, -0.3 }, Waist = { -12, -14, 0 }, Neck = { 8, 10, 0 }, RS = { 95, 0, 25 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -8, 12, 0, 0, -0.3, -0.3 }, Waist = { -12, 14, 0 }, Neck = { 8, -10, 0 }, RS = { 95, 0, -15 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 3, radius = 2 } }, hitText = "WIKI-WIKI !",
		},
		-- Dentier claqué (P P puis →P) : il sort son dentier et le fait claquer au bout du bras sur le nez de l'adversaire
		P_dentier = {
			label = "Dentier claqué", startup = 0.07, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(5, 3.5, 2.8, 0.8), kbBase = 22, kbGrowth = 32, kbAngle = 35,
			windup = { Root = { 2, -10, 0, 0, -0.2, 0.1 }, Waist = { -6, -12, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, LS = { 70, 0, -10 }, LE = { 130, 0, 0 }, LW = { -30, 0, 0 } },
			strike = { Root = { -10, 12, 0, 0, -0.3, -0.3 }, Waist = { -14, 16, 0 }, Neck = { 6, -8, 0 }, RS = { 30, 0, 35 }, RE = { 80, 0, 0 }, LS = { 95, 0, 5 }, LE = { 5, 0, 0 }, LW = { 20, 0, 0 } },
			follow = { Root = { -12, 14, 0, 0, -0.32, -0.35 }, Waist = { -16, 18, 0 }, Neck = { 6, -10, 0 }, RS = { 28, 0, 36 }, RE = { 80, 0, 0 }, LS = { 98, 0, 0 }, LE = { 5, 0, 0 }, LW = { -20, 0, 0 } },
			shake = true, trail = "leftHand", fx = { { "toss", shape = "flat", color = WHITE, count = 1, size = 0.6, speed = 10 }, { "text", text = "CLAC CLAC", color = WHITE, at = "front" } },
			text = "MON DENTIER !", hitText = "GNAC !",
		},
		-- Coup de hanche disco (K K puis ↓K) : un grand déhanché à la Travolta, la hanche part en avant… et le dos craque
		K_hanche = {
			label = "Coup de hanche disco", startup = 0.07, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 2.5, 0.5), kbBase = 24, kbGrowth = 35, kbAngle = 40, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 0, -35, -10, 0, -0.3, 0.1 }, Waist = { 0, -20, 10 }, Neck = { 6, 20, -6 }, RS = { 170, 0, 20 }, RE = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 0, 45, 14, 0, -0.3, -0.35 }, Waist = { 0, 25, -14 }, Neck = { 6, -25, 8 }, RS = { 150, 0, 40 }, RE = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 0, 50, 16, 0, -0.3, -0.4 }, Waist = { 0, 28, -16 }, Neck = { 6, -28, 10 }, RS = { 145, 0, 45 }, RE = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			wobble = true, trail = "body", fx = { { "symbols", symbols = { "🕺", "♪" }, color = GOLD, count = 3, radius = 2 }, { "text", text = "CRAC", color = WHITE, at = "root" } },
			text = "DISCO !", hitText = "BOUM DE HANCHE !",
		},
		-- Mégaphone (finition) : il sort le mégaphone, le colle à l'oreille adverse et hurle « ÇA VA LES JEUNES ?! » : l'onde l'éjecte
		K_mega = {
			label = "Mégaphone", startup = 0.1, active = 0.12, recovery = 0.36,
			damage = 12, hitbox = box(6, 4, 3.2, 0.8), kbBase = 38, kbGrowth = 90, kbAngle = 32,
			windup = { Root = { 0, -20, 0, 0, -0.25, 0.15 }, Waist = { -8, -20, 0 }, Neck = { -10, 10, 0 }, RS = { 60, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 15, 0, 0, -0.3, -0.35 }, Waist = { -12, 18, 0 }, Neck = { 10, -10, 0 }, RS = { 100, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 18, 0, 0, -0.32, -0.4 }, Waist = { -14, 20, 0 }, Neck = { 14, -12, 0 }, RS = { 104, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
			shake = true, prop = "megaphone", hideProp = "vinyles",
			fx = { { "ring", color = GOLD, radius = 4, at = "front" }, { "beam", color = GOLD, length = 8, width = 2, at = "hand" }, { "shake", amount = 0.4 } },
			text = "ÇA VA LES JEUNES ?!", hitText = "BWAAAAH !",
		},
		-- Scratch infernal (finition S) : platine en main, il scratche comme un forcené, l'onde éjecte l'adversaire
		S_finish_scratch = {
			label = "Scratch infernal", startup = 0.12, active = 0.16, recovery = 0.34,
			damage = 10, hitbox = box(6, 4, 3.5, 0.5), kbBase = 38, kbGrowth = 88, kbAngle = 35,
			windup = { Root = { 0, -10, 0, 0, -0.25, 0.1 }, Waist = { -10, -10, 0 }, Neck = { -15, 0, 0 }, RS = { 70, 0, -10 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, 10, -6, 0, -0.3, -0.25 }, Waist = { -12, 10, 6 }, Neck = { -20, 0, 10 }, RS = { 78, 0, -35 }, RE = { 55, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 10 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -6, 12, 6, 0, -0.3, -0.28 }, Waist = { -12, 12, -6 }, Neck = { -20, 0, -10 }, RS = { 75, 0, 0 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 76, 0, 10 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			wobble = true, prop = "platine",
			fx = { { "ring", color = PINK, radius = 4, at = "front" }, { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 4, radius = 2 } },
			text = "SCRATCH INFERNAL !", hitText = "WIKI-WIKI-BOUM !",
		},
		-- Tube de l'été (finition S) : il lance trois vinyles en éventail d'un grand geste de bras
		S_finish_tube = {
			label = "Tube de l'été", kind = "projectile", startup = 0.12, active = 0, recovery = 0.35,
			damage = 6, kbBase = 32, kbGrowth = 80, kbAngle = 30,
			projectile = { speed = 70, gravity = 0, lifetime = 0.5, size = 1.8, color = BLACK, visual = VINYL, fan = { count = 3, from = -5, to = 25 } },
			windup = { Root = { 0, 30, 0, 0, -0.25, 0.1 }, Waist = { -6, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, -20, 0, 0, -0.3, -0.25 }, Waist = { -10, -30, 0 }, Neck = { 10, 10, 0 }, RS = { 110, 0, 50 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -7, -24, 0, 0, -0.3, -0.28 }, Waist = { -11, -34, 0 }, Neck = { 12, 12, 0 }, RS = { 120, 0, 60 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			hideProp = "vinyles", text = "TUBE DE L'ÉTÉ !", hitText = "TCHAK TCHAK TCHAK !",
		},

		------------------------------------------------------------------ Supers
		-- Le Drop ultime (Y) : penché sur la platine, doigt levé pendant la montée… puis il abat la main : tout explose des deux côtés
		SUPER = {
			label = "Le Drop ultime !", startup = 0.45, active = 0.2, recovery = 0.8,
			damage = 24, hitbox = box(26, 10, 4, 1), kbBase = 40, kbGrowth = 100, kbAngle = 40,
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.6, -0.2 }, Waist = { -25, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 70, 0, -10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.1, 0 }, Waist = { 15, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 35 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -35 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			hold = 0.2, shake = true, prop = "platine",
			windupFx = { { "screen", color = PINK, alpha = 0.2 }, { "text", text = "3… 2… 1…", color = PINK } },
			fx = { { "ring", color = PINK, radius = 13, at = "root" }, { "pillar", color = BLUE, height = 14, width = 4, at = "front" }, { "symbols", symbols = { "♪", "♫", "🔊" }, color = GOLD, count = 8, radius = 6 }, { "shake", amount = 0.8 } },
			text = "LE DROP ULTIME !", hitText = "BOUM BOUM BOUM !",
		},
		-- Super ↑ : il sort une boule à facettes géante, la soulève à bout de bras (aïe le dos) et la lance : elle fonce sur l'adversaire
		-- en tournoyant, l'emporte vers le plafond et force tout le monde à danser
		SUPER_up = {
			label = "Boule à facettes !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.8,
			damage = 24, kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			projectile = { speed = 60, angle = 30, gravity = 0, lifetime = 1.2, size = 4.5, color = SILVER, from = "above", pierce = true,
				visual = { shape = "ball", size = 4, color = SILVER, material = "Foil", spin = 10, parts = {
					{ "block", Vector3.new(1, 1, 1), Vector3.new(1.6, 1.2, 0), WHITE },
					{ "block", Vector3.new(0.9, 0.9, 0.9), Vector3.new(-1.5, -1.1, 0.6), PINK },
					{ "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0.4, -1.7, -1.0), BLUE },
					{ "block", Vector3.new(0.3, 2.5, 0.3), Vector3.new(0, 2.8, 0), SILVER },
				} } },
			status = { name = "dancing", duration = 2 },
			windup = { Root = { -6, 0, 0, 0, -0.75, 0.1 }, Waist = { -26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, 25 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -25 }, LE = { 30, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.45, 0 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 182, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 182, 0, -12 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 14, 0, 0, 0, -0.1, 0.15 }, Waist = { 20, 0, 0 }, Neck = { 35, 0, 0 }, RS = { -40, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -30 }, LE = { 90, 0, 0 } },
			hold = 0.15, shake = true, hideProp = "vinyles",
			windupFx = { "super", { "text", text = "HNNNG… MON DOS…", color = PINK } },
			fx = { { "screen", color = PINK, alpha = 0.2 }, { "symbols", symbols = { "✨", "🪩", "♪" }, color = GOLD, count = 10, radius = 6, at = "above" }, { "beam", color = WHITE, length = 14, width = 1.2, at = "above" }, { "shake", amount = 0.4 } },
			text = "QUE LA LUMIÈRE SOIT !", hitText = "DISCO !",
		},
		-- Larsen infernal (→Y) : il sort le pied de micro, colle le micro sur le haut-parleur de son propre casque et braque le tout vers
		-- l'avant : le larsen qui en sort perce les tympans de tout le couloir (il grimace lui-même, main gauche sur l'oreille)
		SUPER_side = {
			label = "Larsen infernal !", startup = 0.4, active = 0.25, recovery = 0.7,
			damage = 24, hitbox = box(16, 6, 8, 1), kbBase = 44, kbGrowth = 92, kbAngle = 32,
			status = { name = "stunned", duration = 1.2 },
			windup = { Root = { -4, -20, 0, 0, -0.3, 0.2 }, Waist = { -10, -24, 0 }, Neck = { 10, 20, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -14, 20, 0, 0, -0.34, -0.45 }, Waist = { -16, 26, 0 }, Neck = { 0, -40, 20 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -70 }, LE = { 150, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, 24, 0, 0, -0.36, -0.5 }, Waist = { -20, 30, 0 }, Neck = { 0, -44, 24 }, RS = { 98, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 54, 0, -74 }, LE = { 150, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
			hold = 0.2, shake = true, prop = "piedMicro", hideProp = "vinyles", trail = "prop",
			windupFx = { "super", { "text", text = "UN… DEUX… UN DEUX…", color = PINK, at = "head" } },
			fx = { { "beam", color = BLUE, length = 18, width = 3, at = "hand" }, { "ring", color = BLUE, radius = 6, at = "front" }, { "symbols", symbols = { "🎤", "〰️", "🔊" }, color = BLUE, count = 8, radius = 5, at = "front" }, { "shake", amount = 0.5 }, { "screen", color = BLUE, alpha = 0.15 } },
			text = "LARSEN INFERNAL !", hitText = "IIIIIIIIH !",
		},
		-- Le Slow (↓Y) : il ouvre les bras et se balance ; tout le monde autour de lui est forcé de danser un slow pendant que Papi se soigne
		SUPER_down = {
			label = "Le Slow", startup = 0.4, active = 0.2, recovery = 0.7,
			damage = 22, hitbox = box(24, 8, 0, 1), kbBase = 12, kbGrowth = 15, kbAngle = 60,
			status = { name = "dancing", duration = 3 },
			selfEffect = { heal = 15 },
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Neck = { 10, 0, 8 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 0, 0, -6, 0, -0.22, 0 }, Waist = { 4, 0, -6 }, Neck = { 10, 0, -12 }, RS = { 85, 0, -25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, 25 }, LE = { 70, 0, 0 } },
			follow = { Root = { 0, 0, 6, 0, -0.22, 0 }, Waist = { 4, 0, 6 }, Neck = { 10, 0, 12 }, RS = { 85, 0, -25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, 25 }, LE = { 70, 0, 0 } },
			hold = 0.5,
			windupFx = { { "text", text = "UN PETIT SLOW ?", color = PINK } },
			fx = { { "ring", color = PINK, radius = 12, at = "root" }, { "symbols", symbols = { "💕", "♪", "🎶" }, color = PINK, count = 10, radius = 6 }, { "screen", color = PINK, alpha = 0.15 } },
			text = "LE SLOW…", hitText = "OH OUI…",
		},

		------------------------------------------------------------------ Chope (bouton ✋) et projections
		-- Prise de piste : bras grands ouverts, il attrape l'adversaire à deux mains comme un disque sur la platine
		GRAB = {
			label = "Prise de piste", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 3.5, 2.2, 0.5),
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, 50 }, RE = { 20, 0, 0 }, LS = { 110, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.25, -0.25 }, Waist = { -10, 0, 0 }, RS = { 85, 0, -15 }, RE = { 50, 0, 0 }, LS = { 85, 0, 15 }, LE = { 50, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.25, -0.28 }, Waist = { -10, 0, 0 }, RS = { 84, 0, -18 }, RE = { 55, 0, 0 }, LS = { 84, 0, 18 }, LE = { 55, 0, 0 } },
			text = "PRISE DE PISTE !", hitText = "TOURNE, TOURNE…",
		},
		-- ✋ puis → : Scratch, la victime part d'avant en arrière comme un disque… et il la lâche en plein scratch
		THROW_fwd = {
			label = "Scratch", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 15,
			carry = { { 0, 2.4, 0.6 }, { 0.1, 1.6, 0.8 }, { 0.2, 2.6, 0.6 }, { 0.32, 4.2, 0.8 } },
			windup = { Root = { 0, 0, -6, 0, -0.25, 0.1 }, Waist = { -10, 0, 6 }, Neck = { -10, 0, 8 }, RS = { 75, 0, -25 }, RE = { 60, 0, 0 }, LS = { 75, 0, 25 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, 0, 6, 0, -0.35, -0.4 }, Waist = { -15, 0, -6 }, Neck = { 10, 0, -8 }, RS = { 85, 0, 0 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 0 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 0, 6, 0, -0.35, -0.45 }, Waist = { -16, 0, -6 }, Neck = { 12, 0, -8 }, RS = { 88, 0, -4 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 4 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			wobble = true, fx = { { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 4, radius = 2 } }, text = "WIKI-WIKI…", hitText = "SCRATCH !",
		},
		-- ✋ puis ← : Retour arrière, il fait passer la victime au-dessus de sa tête comme une bande rembobinée
		THROW_back = {
			label = "Retour arrière", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 11, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 1, 3 }, { 0.3, -1.2, 2.6 }, { 0.4, -2.6, 0.8 } },
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.1 }, Waist = { -15, 0, 0 }, RS = { 80, 0, -15 }, RE = { 60, 0, 0 }, LS = { 80, 0, 15 }, LE = { 60, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.3, 0.3 }, Waist = { 25, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 190, 0, -10 }, RE = { 20, 0, 0 }, LS = { 190, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 22, 0, 0, 0, -0.32, 0.35 }, Waist = { 28, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 200, 0, -10 }, RE = { 20, 0, 0 }, LS = { 200, 0, 10 }, LE = { 20, 0, 0 } },
			fx = { { "symbols", symbols = { "⏪" }, color = BLUE, count = 3, radius = 2 } }, text = "RETOUR ARRIÈRE !", hitText = "AÏE MON DOS !",
		},
		-- ✋ puis ↑ : Montée du son, il sort le mégaphone et hurle dans l'oreille : les basses soulèvent la victime
		THROW_up = {
			label = "Montée du son", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.4, 0.6 }, { 0.2, 2.4, 1.6 }, { 0.34, 2.2, 5 } },
			windup = { Root = { 0, 0, 0, 0, -0.3, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, 0 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, -0.2, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 120, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.2, 0.25 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 130, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			prop = "megaphone", hideProp = "vinyles", shake = true,
			fx = { { "ring", color = GOLD, radius = 4, at = "hand" }, { "text", text = "MONTE LE SON !", color = GOLD } },
			text = "HÉÉÉ !", hitText = "BWAAAH !",
		},
		-- ✋ puis ↓ : Drop, il soulève la victime… tout s'arrête… puis BOUM, il la plaque au sol
		THROW_down = {
			label = "Drop", kind = "throw", startup = 0.45, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.4, 0.6 }, { 0.2, 2.2, 2.8 }, { 0.35, 2.2, 2.8 }, { 0.45, 2.4, -2.2 } },
			windup = { Root = { 6, 0, 0, 0, 0, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 165, 0, -10 }, RE = { 20, 0, 0 }, LS = { 165, 0, 10 }, LE = { 20, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.6, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, -10 }, RE = { 10, 0, 0 }, LS = { 40, 0, 10 }, LE = { 10, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.62, -0.32 }, Waist = { -32, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 35, 0, -10 }, RE = { 10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			windupFx = { { "text", text = "…", color = WHITE } },
			fx = { { "ring", color = PINK, radius = 5, at = "front" }, { "shake", amount = 0.5 } }, text = "DROP !", hitText = "BOUM !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	-- 1er fatal offert, 2e au niveau de maîtrise 5, 3e au niveau 15
	fatals = {
		{
			id = "disque_raye", label = "Disque rayé", sequence = { "forward", "down", "down" },
			-- l'adversaire saute comme un disque rayé, répète le même petit bond en boucle et rapetisse jusqu'à disparaître
			scene = {
				{ "fxAttacker", { "text", text = "OH… ÇA SAUTE !", color = PINK } },
				{ "text", "ÇA SAUTE !" },
				{ "lift", 1.2, time = 0.15 },
				{ "lift", -1.2, time = 0.15 },
				{ "shrink", 0.8, time = 0.1 },
				{ "text", "ÇA SAUTE !" },
				{ "lift", 1.2, time = 0.15 },
				{ "lift", -1.2, time = 0.15 },
				{ "shrink", 0.6, time = 0.1 },
				{ "text", "ÇA SAUTE !" },
				{ "lift", 1.2, time = 0.15 },
				{ "lift", -1.2, time = 0.15 },
				{ "shrink", 0.35, time = 0.1 },
				{ "fx", { "symbols", symbols = { "♪", "SKRR", "♫" }, count = 6, color = PINK, radius = 2 } },
				{ "lift", 1.2, time = 0.15 },
				{ "lift", -1.2, time = 0.15 },
				{ "shrink", 0.1, time = 0.2 },
				{ "hide" },
				{ "fxAttacker", { "text", text = "FIN DU MORCEAU.", color = WHITE } },
				{ "wait", 1 },
			},
		},
		{
			id = "quarante_cinq_tours", label = "Le 45 tours", sequence = { "up", "up", "forward" },
			-- pressé à plat comme un vinyle, il tourne sur la platine qui sort du sol
			scene = {
				{ "fxAttacker", { "text", text = "ON PRESSE LE DISQUE !", color = GOLD } },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.9, 0), life = 4, pieces = {
					{ "Platine", "", "block", Vector3.new(6, 0.8, 4), Vector3.new(0, 0, 0), Vector3.zero, BLACK, "SmoothPlastic" },
					{ "Plateau", "", "cyl", Vector3.new(0.2, 3.6, 3.6), Vector3.new(0, 0.5, 0), Vector3.zero, SILVER, "Metal", { axis = "y" } },
					{ "Bras", "", "block", Vector3.new(0.2, 0.2, 3), Vector3.new(2.5, 0.8, 0.3), Vector3.new(0, 25, 0), SILVER, "Metal" },
					{ "Diode", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(-2.6, 0.5, 1.6), Vector3.zero, PINK, "Neon", { neon = true } },
				} },
				{ "squash", time = 0.25 },
				{ "color", BLACK },
				{ "material", "SmoothPlastic" },
				{ "text", "45 TOURS !" },
				{ "fx", { "symbols", symbols = { "♪", "♫", "💿" }, count = 6, color = PINK, radius = 3 } },
				{ "spin", 1080, time = 1.6, axis = "y" },
				{ "fxAttacker", { "text", text = "UN CLASSIQUE !", color = GOLD } },
				{ "wait", 0.8 },
			},
		},
		{
			id = "les_basses", label = "Les Basses", sequence = { "back", "forward", "back" },
			-- les basses sont si fortes que l'adversaire vibre puis part s'encastrer dans la boule à facettes
			scene = {
				{ "fxAttacker", { "ring", color = PINK, radius = 8, at = "root" } },
				{ "fxAttacker", { "text", text = "BASSES À FOND !", color = PINK } },
				{ "fx", { "shake", amount = 0.6 } },
				{ "spin", 10, time = 0.1, axis = "z" },
				{ "spin", -20, time = 0.1, axis = "z" },
				{ "spin", 20, time = 0.1, axis = "z" },
				{ "spin", -10, time = 0.1, axis = "z" },
				{ "text", "BZZZZZ !" },
				{ "spawn", at = "above", offset = Vector3.new(0, 6, 0), life = 3.5, pieces = {
					{ "Boule", "", "ball", Vector3.new(3.4, 3.4, 3.4), Vector3.new(0, 0, 0), Vector3.zero, SILVER, "Foil", { reflect = 0.6 } },
					{ "Fil", "", "cyl", Vector3.new(4, 0.1, 0.1), Vector3.new(0, 3.7, 0), Vector3.zero, SILVER, "Metal", { axis = "y" } },
				} },
				{ "launch", Vector3.new(0, 12, 0), time = 0.4 },
				{ "fx", { "burst", color = Color3.fromRGB(255, 240, 150), size = 5 } },
				{ "text", "BOUM !" },
				{ "fx", { "symbols", symbols = { "✨", "♪" }, count = 8, color = BLUE, radius = 4 } },
				{ "fxAttacker", { "text", text = "ET ÇA, C'EST DU SON !", color = GOLD } },
				{ "wait", 1 },
			},
		},
	},

	-- Mécanique : Playlist (rap = vitesse, slow = soin, techno = dégâts), voir server/Mechanics.lua (« playlist »)
	passive = { kind = "playlist", name = "Playlist", icon = "🎧", tracks = { "rap", "slow", "techno" }, color = PINK },

	-- Recharge : il scratche sur ses platines, casque tenu sur une oreille, déhanché raide… puis se tient le dos
	charge = {
		label = "Recharge aux platines",
		loop = 2.0,
		lockWrist = true,
		color = PINK,
		keys = {
			{ 0.0, { Root = { 0, 0, -5, 0, -0.2, 0 }, Waist = { -10, 0, 5 }, Neck = { -10, 0, 15 }, RS = { 70, 0, -10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 120, 0, 0 } } },
			{ 0.3, { Root = { 0, 0, 5, 0, -0.2, 0 }, Waist = { -10, 0, -5 }, Neck = { -10, 0, 5 }, RS = { 75, 0, -30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 120, 0, 0 } } },
			{ 0.6, { Root = { 0, 0, -5, 0, -0.2, 0 }, Waist = { -10, 0, 5 }, Neck = { -10, 0, 15 }, RS = { 70, 0, 0 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 120, 0, 0 } } },
			{ 0.9, { Root = { 0, 0, 5, 0, -0.2, 0 }, Waist = { -10, 0, -5 }, Neck = { -10, 0, 5 }, RS = { 75, 0, -30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 120, 0, 0 } } },
			{ 1.2, { Root = { -10, 0, 0, 0, -0.3, 0 }, Waist = { -20, 0, 0 }, Neck = { -5, 0, 0 }, RS = { -40, 0, 25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 } } },
			{ 1.6, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -40, 0, 25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 } } },
			{ 2.0, { Root = { 0, 0, -5, 0, -0.2, 0 }, Waist = { -10, 0, 5 }, Neck = { -10, 0, 15 }, RS = { 70, 0, -10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 120, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 3, radius = 2 } },
			{ 0.3, { "text", text = "WIKI WIKI", color = PINK } },
			{ 1.25, { "text", text = "AÏE MON DOS…", color = WHITE } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- Il presse l'écouteur gauche contre son oreille et hoche la tête en rythme
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.4, { LS = { 150, 0, -30 }, LE = { 120, 0, 0 }, Neck = { 10, 0, 10 } } },
			{ 0.8, { LS = { 150, 0, -30 }, LE = { 120, 0, 0 }, Neck = { 22, 0, 10 } } },
			{ 1.2, { LS = { 150, 0, -30 }, LE = { 120, 0, 0 }, Neck = { 5, 0, 10 } } },
			{ 1.6, {} },
		} },
		-- Il se tient le dos à deux mains et se cambre (craquement)
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.5, { Waist = { -20, 0, 0 }, RS = { -40, 0, 25 }, RE = { 100, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 } } },
			{ 1.0, { Waist = { 8, 0, 0 }, Neck = { 15, 0, 0 }, RS = { -40, 0, 25 }, RE = { 100, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 } } },
			{ 1.6, {} },
		} },
		-- Petit pas de twist sur place
		{ duration = 1.5, keys = {
			{ 0, {} },
			{ 0.3, { Root = { 0, 10, -6, 0, -0.25, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } } },
			{ 0.6, { Root = { 0, -10, 6, 0, -0.25, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } } },
			{ 0.9, { Root = { 0, 10, -6, 0, -0.25, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } } },
			{ 1.2, { Root = { 0, -10, 6, 0, -0.25, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } } },
			{ 1.5, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : les deux mains posées sur la victime comme sur un disque, il se dandine
data.grabHold = {
	Root = { 4, 0, 4, 0, -0.25, 0.1 },
	Waist = { -6, 0, -4 },
	Neck = { 10, 0, 6 },
	RS = { 82, 0, -18 },
	RE = { 45, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 82, 0, 18 },
	LE = { 45, 0, 0 },
}

-- Retour après une chute : il descend sur ses platines suspendues à une boule à facettes, scratche une fois,
-- se tient le dos… puis lève le poing
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Platines", "base", "block", Vector3.new(5, 1, 3), Vector3.new(0, -0.5, 0), Vector3.zero, BLACK, "SmoothPlastic" },
		{ "PlateauG", "", "cyl", Vector3.new(0.1, 1.5, 1.5), Vector3.new(-1.4, 0.05, 0), Vector3.zero, SILVER, "Metal", { axis = "y" } },
		{ "PlateauD", "", "cyl", Vector3.new(0.1, 1.5, 1.5), Vector3.new(1.4, 0.05, 0), Vector3.zero, SILVER, "Metal", { axis = "y" } },
		{ "Facade", "", "block", Vector3.new(5, 0.3, 0.1), Vector3.new(0, -0.5, 1.55), Vector3.zero, PINK, "Neon", { neon = true } },
		{ "CordeG", "", "cyl", Vector3.new(9, 0.08, 0.08), Vector3.new(-2.3, 4.5, 0), Vector3.zero, SILVER, "Metal", { axis = "y" } },
		{ "CordeD", "", "cyl", Vector3.new(9, 0.08, 0.08), Vector3.new(2.3, 4.5, 0), Vector3.zero, SILVER, "Metal", { axis = "y" } },
		{ "Barre", "", "block", Vector3.new(4.8, 0.15, 0.15), Vector3.new(0, 9, 0), Vector3.zero, SILVER, "Metal" },
		{ "Boule", "", "ball", Vector3.new(2, 2, 2), Vector3.new(0, 10.2, 0), Vector3.zero, SILVER, "Foil", { reflect = 0.6 } },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -0.35, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 60, 0, 0 } } },
		{ 0.35, { Root = { 0, 0, -5, 0, -0.35, 0 }, Waist = { -10, 0, 5 }, Neck = { 10, 0, 10 }, RS = { 75, 0, -30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 60, 0, 0 } } },
		{ 0.6, { Root = { 0, 0, 5, 0, -0.35, 0 }, Waist = { -10, 0, -5 }, Neck = { 10, 0, -5 }, RS = { 70, 0, 0 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 60, 0, 0 } } },
		{ 0.9, { Root = { -10, 0, 0, 0, -0.4, 0 }, Waist = { -25, 0, 0 }, Neck = { -5, 0, 0 }, RS = { -40, 0, 25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 } } },
		{ 1.2, { Root = { -10, 0, 0, 0, -0.42, 0 }, Waist = { -28, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -40, 0, 25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 100, 0, 0 } } },
		{ 1.45, { Root = { 4, 0, 0, 0, -0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 175, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } } },
		{ 1.6, { Root = { 4, 0, 0, 0, -0.08, 0 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 178, 0, 18 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.1, { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 3, radius = 2 } },
		{ 0.35, { "text", text = "WIKI !", color = PINK } },
		{ 0.95, { "text", text = "OUILLE…", color = WHITE } },
		{ 1.45, { "text", text = "YEAH !", color = GOLD } },
		{ 1.45, { "burst", color = GOLD, size = 2, at = "hand" } },
	},
}

-- Arbre d'enchaînements. Lecture : après le coup de gauche, le bouton (avec la direction s'il y en a une) lance
-- le coup de droite. Les chaînes finissent sur S : Scratch infernal (éjection) ou Tube de l'été (3 vinyles).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P… : vinyle, charentaise, dentier, 33 tours (P P P K : mégaphone, finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side", S = "S_finish_scratch" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", fwd_P = "P_dentier", S = "S_finish_scratch" }, -- P P
	P_combo3 = { K = "K_mega", P = "P_dentier", S = "S_finish_tube" }, -- P P P
	P_dentier = { P = "P_combo3", K = "K_hanche", S = "S_finish_scratch" }, -- P P →P (dentier)
	PK_combo = { P = "KP_combo", K = "K_hanche", S = "S_finish_scratch" }, -- P K
	KP_combo = { P = "P_dentier", K = "K_mega", S = "S_finish_tube" }, -- K P / P K P
	-- K… : charentaises, hanches, mégaphone (K K K K et K K ↓K K : mégaphone)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_scratch" },
	K_combo2 = { K = "K_combo3", P = "P_dentier", down_K = "K_hanche", S = "S_finish_scratch" }, -- K K
	K_combo3 = { K = "K_mega", S = "S_finish_tube" }, -- K K K (grand écart)
	K_hanche = { K = "K_mega", P = "P_combo3", S = "S_finish_scratch" }, -- K K ↓K (hanche)
	-- avec une flèche
	P_side = { P = "P_combo2", K = "K_side", fwd_P = "P_dentier", S = "S_finish_tube" }, -- → P
	P_down = { P = "P_up", K = "K_down", S = "S_finish_scratch" }, -- ↓ P
	P_up = { K = "K_up", P = "P_dentier", S = "S_finish_tube" }, -- ↑ P
	K_side = { P = "KP_combo", K = "K_hanche", S = "S_finish_scratch" }, -- → K
	K_down = { P = "P_up", S = "S_finish_scratch" }, -- ↓ K
	K_up = { P = "P_combo3", K = "K_mega", S = "S_finish_tube" }, -- ↑ K
	P_dash = { P = "P_combo2", K = "K_side", S = "S_finish_scratch" }, -- dash P
	K_dash = { P = "P_up", K = "K_hanche", S = "S_finish_tube" }, -- dash K
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

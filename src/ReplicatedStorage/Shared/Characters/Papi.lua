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

local data = {
	id = "Papi",
	name = "Papi DJ",
	costume = "Papi",
	style = "grandpa",

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
			damage = 5, hitbox = box(4, 3, 2.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { 0, -25, 0, 0, -0.2, 0.1 }, Waist = { -6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 150, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, 20, 0, 0, -0.28, -0.3 }, Waist = { -12, 25, 0 }, Neck = { 0, -10, 0 }, RS = { 80, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -8, 24, 0, 0, -0.28, -0.32 }, Waist = { -13, 28, 0 }, Neck = { 0, -12, 0 }, RS = { 60, 0, -25 }, RE = { 30, 0, 0 }, RW = { -15, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			prop = "charentaise", hideProp = "vinyles", trail = "prop", hitText = "FLAP !",
		},
		-- P P P : Coup de 33 tours, vinyle levé à deux mains au-dessus de la tête puis abattu
		P_combo3 = {
			label = "Coup de 33 tours", startup = 0.14, active = 0.1, recovery = 0.3,
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
			label = "Charentaise gauche", startup = 0.14, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3, 3, 0), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 6, 12, 0, 0, -0.2, 0.1 }, Waist = { 0, 8, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, LH = { 75, 0, 0 }, LK = { -100, 0, 0 }, LA = { -10, 0, 0 } },
			strike = { Root = { 16, 6, 0, 0, -0.12, -0.05 }, Waist = { 12, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, LS = { 50, 0, -60 }, LE = { 20, 0, 0 }, LH = { 95, 0, 0 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 18, 8, 0, 0, -0.12, -0.08 }, Waist = { 14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 62, 0, 42 }, RE = { 40, 0, 0 }, LS = { 52, 0, -64 }, LE = { 20, 0, 0 }, LH = { 100, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "leftFoot", hitText = "FLOP !",
		},
		-- K K K : Grand écart rouillé, bras en « ta-da » puis il tombe en grand écart… et se bloque le dos
		K_combo3 = {
			label = "Grand écart rouillé", startup = 0.16, active = 0.12, recovery = 0.38,
			damage = 12, hitbox = box(7, 2.5, 1, -1), kbBase = 32, kbGrowth = 80, kbAngle = 45,
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
		-- Double charentaise (saut K) : genoux à la poitrine puis les deux charentaises partent devant
		K_air = {
			label = "Double charentaise", startup = 0.18, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -10, 0, 0 }, Waist = { -22, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 95, 0, 0 }, RK = { -130, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 20, 0, 0 }, Waist = { 20, 0, 0 }, RS = { -35, 0, 50 }, RE = { 20, 0, 0 }, LS = { -40, 0, -40 }, LE = { 100, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 78, 0, 0 }, LK = { -6, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 24, 0, 0 }, Waist = { 22, 0, 0 }, RS = { -40, 0, 54 }, RE = { 20, 0, 0 }, LS = { -40, 0, -42 }, LE = { 100, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 82, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", hitText = "FLAP FLAP !",
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
		-- Vinyle-boomerang : lancer en revers comme un frisbee, le disque fait l'aller-retour
		S_neutral = {
			label = "Vinyle-boomerang", kind = "projectile", energyCost = 20, startup = 0.15, active = 0, recovery = 0.3,
			damage = 8, kbBase = 22, kbGrowth = 40, kbAngle = 30,
			projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 1.0, size = 1.8, color = BLACK, returns = true, visual = VINYL },
			windup = { Root = { 0, 30, 0, 0, -0.25, 0.1 }, Waist = { -6, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, -15, 0, 0, -0.3, -0.25 }, Waist = { -10, -25, 0 }, Neck = { 0, 10, 0 }, RS = { 92, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -7, -18, 0, 0, -0.3, -0.28 }, Waist = { -11, -28, 0 }, Neck = { 0, 12, 0 }, RS = { 88, 0, 55 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			hideProp = "vinyles", text = "ALLER-RETOUR !", hitText = "TCHAK !",
		},
		-- Drop des basses : il lève le poing et l'abat sur un bouton imaginaire, une onde part à l'horizontale
		-- et la Playlist passe au morceau suivant
		S_side = {
			label = "Drop des basses", kind = "projectile", energyCost = 25, startup = 0.2, active = 0, recovery = 0.35,
			damage = 9, kbBase = 35, kbGrowth = 60, kbAngle = 15,
			selfEffect = { nextTrack = true },
			projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 0.45, size = 4, color = PINK, pierce = true,
				visual = { shape = "block", size = 3, color = PINK, neon = true, transparency = 0.45 } },
			windup = { Root = { 6, 0, 0, 0, -0.05, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 175, 0, 15 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.45, -0.15 }, Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.5, -0.18 }, Waist = { -24, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 55, 0, 5 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			hold = 0.1,
			windupFx = { { "text", text = "ATTENTION…", color = PINK } },
			fx = { { "ring", color = PINK, radius = 6, at = "front" }, { "symbols", symbols = { "♪", "♫", "🔊" }, color = PINK, count = 4, radius = 3 }, { "shake", amount = 0.3 } },
			text = "DROP !", hitText = "BWOOOM !",
		},
		-- Mur d'enceintes : il tape du pied et lève les bras, deux baffles jaillissent du sol et bloquent les tirs
		S_down = {
			label = "Mur d'enceintes", kind = "wall", energyCost = 25, startup = 0.2, active = 0, recovery = 0.35,
			hitbox = box(5, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 45, kbAngle = 30,
			damage = 7,
			wall = { size = Vector3.new(2.6, 6, 6), offset = 3.5, lifetime = 5, max = 2, visual = SPEAKERS, color = BLACK },
			windup = { Root = { -6, 0, 0, 0, -0.45, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, -0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 } },
			follow = { Root = { 5, 0, 0, 0, -0.05, 0 }, Waist = { 12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 165, 0, 32 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -32 }, LE = { 10, 0, 0 } },
			fx = { { "burst", color = PINK, size = 3, at = "front" }, { "shake", amount = 0.2 } },
			text = "MUR DE SON !",
		},
		-- Slam (remontée gratuite) : il se jette en arrière dans une foule imaginaire, bras écartés
		S_up = {
			label = "Slam", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 7, hitbox = box(5, 7, 0.5, 2), kbBase = 30, kbGrowth = 40, kbAngle = 80, selfVelocity = Vector2.new(10, 85),
			windup = { Root = { -6, 0, 0, 0, -0.7, 0 }, Waist = { -15, 0, 0 }, RS = { -30, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, 0.3, 0 }, Waist = { 15, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 60 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -60 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 38, 0, 0, 0, 0.35, 0 }, Waist = { 18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 175, 0, 65 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -65 }, LE = { 0, 0, 0 }, RH = { 25, 0, 0 }, RK = { -45, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			fx = { { "symbols", symbols = { "🙌", "♪" }, color = GOLD, count = 4, radius = 3 } }, text = "SLAAAM !", hitText = "YEAH !",
		},
		-- Rewind Drop (↓S en l'air) : il pique droit vers le sol, vinyle brandi (le retour à sa hauteur est approché)
		S_air_down = {
			label = "Rewind Drop", energyCost = 25, startup = 0.12, active = 0.4, recovery = 0.35,
			damage = 12, hitbox = box(4.5, 4, 0.5, -2.5), kbBase = 28, kbGrowth = 65, kbAngle = -78, selfVelocity = Vector2.new(0, -105),
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 160, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 0, 0, 3 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, -3 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 162, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 0, 0, 4 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, -4 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "body", fx = { { "burst", color = BLUE, size = 3, at = "feet" }, { "symbols", symbols = { "⏪" }, color = BLUE, count = 2, radius = 2 } },
			text = "REWIND DROP !", hitText = "BADABOUM !",
		},
		-- Rewind (ESQUIVE puis S) : il tourne les bras comme une bande qu'on rembobine et recule d'un bond
		S_dodge = {
			label = "Rewind", energyCost = 20, startup = 0.1, active = 0, recovery = 0.25,
			hitbox = box(6, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 9, teleport = -12, invuln = 0.3,
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 5, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.1, 0.3 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.15, 0.2 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 120, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -30 }, LE = { 80, 0, 0 } },
			spin = { axis = "y", degrees = -360 },
			windupFx = { { "symbols", symbols = { "⏪", "⏪" }, color = BLUE, count = 3, radius = 2 } },
			fx = { { "ring", color = BLUE, radius = 3, at = "root" } }, text = "REWIND !",
		},
		-- Changer de piste (S maintenu) : platine dans la main gauche, il scratche fort ; l'onde repousse autour de
		-- lui et la Playlist passe au morceau suivant
		S_hold = {
			label = "Changer de piste", energyCost = 25, startup = 0.25, active = 0.15, recovery = 0.4,
			damage = 9, hitbox = box(10, 6, 0, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 50,
			selfEffect = { nextTrack = true },
			windup = { Root = { 0, 0, 0, 0, -0.25, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, -10, 0 }, RS = { 70, 0, -10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 0, 0, -6, 0, -0.3, 0 }, Waist = { -12, 0, 6 }, Neck = { -20, 0, 10 }, RS = { 75, 0, -30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 6, 0, -0.3, 0 }, Waist = { -12, 0, -6 }, Neck = { -20, 0, -10 }, RS = { 75, 0, -5 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			hold = 0.3, shake = true, wobble = true, prop = "platine",
			fx = { { "ring", color = PINK, radius = 6, at = "root" }, { "symbols", symbols = { "♪", "♫", "⏭️" }, color = BLUE, count = 5, radius = 3 } },
			text = "CHANGEMENT DE PISTE !", hitText = "WIKI-WIKI !",
		},
		-- Pas de danse rétro (→→S) : twist endiablé lancé en avant, les hanches d'abord (2 touches)
		S_dash = {
			label = "Pas de danse rétro", energyCost = 25, startup = 0.05, active = 0.3, recovery = 0.3,
			damage = 5, hits = 2, hitbox = box(5, 4, 2, 0.3), kbBase = 26, kbGrowth = 50, kbAngle = 35, selfVelocity = Vector2.new(60, 0), invuln = 0.15,
			windup = { Root = { 0, -30, -8, 0, -0.3, 0 }, Waist = { 0, -20, 8 }, RS = { 60, 0, 60 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 90, 0, 0 } },
			strike = { Root = { -10, 30, 8, 0, -0.35, -0.3 }, Waist = { -6, 20, -8 }, Neck = { 10, -10, 0 }, RS = { 160, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -10, -20, -8, 0, -0.35, -0.35 }, Waist = { -6, -15, 8 }, Neck = { 10, 10, 0 }, RS = { 150, 0, 35 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -32, 0, -42 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "♪", "🕺" }, color = GOLD, count = 3, radius = 2 } },
			text = "PAS DE DANSE RÉTRO", hitText = "TWIST !",
		},
		-- Pluie de vinyles (S en l'air) : il lance sa pile de disques en l'air, ils retombent sur la piste devant lui
		S_air = {
			label = "Pluie de vinyles", kind = "projectile", energyCost = 25, startup = 0.18, active = 0, recovery = 0.32,
			damage = 5, kbBase = 20, kbGrowth = 35, kbAngle = 60,
			projectile = { speed = 50, gravity = 30, lifetime = 0.8, size = 1.8, color = BLACK, visual = VINYL,
				rain = { count = 5, spread = 7, ahead = 8, height = 18 } },
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 25 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -25 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -30 }, LE = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			hideProp = "vinyles", fx = { { "symbols", symbols = { "💿", "♪" }, color = PINK, count = 4, radius = 3 } },
			text = "PLUIE DE VINYLES !", hitText = "CLONK !",
		},

		------------------------------------------------------------------ Suites d'enchaînement (voir LINKS en bas)
		-- P puis K : Coup de talon pantouflard, petit coup de charentaise sec dans le tibia
		PK_combo = {
			label = "Coup de talon pantouflard", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 2, 3, -1.5), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { 4, -10, 0, 0, -0.25, 0.15 }, Waist = { -6, -12, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 8 }, RK = { -70, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.3, -0.2 }, Waist = { -10, 8, 0 }, RS = { 20, 0, 45 }, RE = { 40, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 62, 0, 6 }, RK = { -5, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.32, -0.25 }, Waist = { -12, 10, 0 }, RS = { 15, 0, 48 }, RE = { 40, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 }, RH = { 66, 0, 0 }, RK = { -8, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- K puis P : Revers de 45 tours, le buste pivote et le vinyle revient en revers
		KP_combo = {
			label = "Revers de 45 tours", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3, 2.8, 0.6), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { -4, 30, 0, 0, -0.22, 0 }, Waist = { -10, 30, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.25, -0.25 }, Waist = { -12, -30, 0 }, Neck = { 0, 10, 0 }, RS = { 90, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -8, -24, 0, 0, -0.25, -0.28 }, Waist = { -12, -34, 0 }, Neck = { 0, 12, 0 }, RS = { 86, 0, 55 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			trail = "prop", hitText = "SCRIIITCH !",
		},
		-- Scratch infernal (finition S) : platine en main, il scratche comme un forcené, l'onde éjecte l'adversaire
		S_finish_scratch = {
			label = "Scratch infernal", energyCost = 20, startup = 0.14, active = 0.16, recovery = 0.34,
			damage = 10, hitbox = box(6, 4, 3.5, 0.5), kbBase = 34, kbGrowth = 75, kbAngle = 35,
			windup = { Root = { 0, -10, 0, 0, -0.25, 0.1 }, Waist = { -10, -10, 0 }, Neck = { -15, 0, 0 }, RS = { 70, 0, -10 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, 10, -6, 0, -0.3, -0.25 }, Waist = { -12, 10, 6 }, Neck = { -20, 0, 10 }, RS = { 78, 0, -35 }, RE = { 55, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 10 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -6, 12, 6, 0, -0.3, -0.28 }, Waist = { -12, 12, -6 }, Neck = { -20, 0, -10 }, RS = { 75, 0, 0 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 76, 0, 10 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			wobble = true, prop = "platine",
			fx = { { "ring", color = PINK, radius = 4, at = "front" }, { "symbols", symbols = { "♪", "♫" }, color = PINK, count = 4, radius = 2 } },
			text = "SCRATCH INFERNAL !", hitText = "WIKI-WIKI-BOUM !",
		},
		-- Tube de l'été (finition S) : il lance trois vinyles en éventail d'un grand geste de bras
		S_finish_tube = {
			label = "Tube de l'été", kind = "projectile", energyCost = 25, startup = 0.16, active = 0, recovery = 0.35,
			damage = 6, kbBase = 26, kbGrowth = 55, kbAngle = 30,
			projectile = { speed = 70, gravity = 0, lifetime = 0.5, size = 1.8, color = BLACK, visual = VINYL, fan = { count = 3, from = -5, to = 25 } },
			windup = { Root = { 0, 30, 0, 0, -0.25, 0.1 }, Waist = { -6, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, -20, 0, 0, -0.3, -0.25 }, Waist = { -10, -30, 0 }, Neck = { 10, 10, 0 }, RS = { 110, 0, 50 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -7, -24, 0, 0, -0.3, -0.28 }, Waist = { -11, -34, 0 }, Neck = { 12, 12, 0 }, RS = { 120, 0, 60 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -42, 0, -20 }, LE = { 100, 0, 0 } },
			hideProp = "vinyles", text = "TUBE DE L'ÉTÉ !", hitText = "TCHAK TCHAK TCHAK !",
		},

		------------------------------------------------------------------ Supers
		-- Le Drop ultime : penché sur la platine, doigt levé pendant la montée… puis il abat la main : tout explose
		SUPER = {
			label = "Le Drop ultime !", superCost = 100, startup = 0.55, active = 0.2, recovery = 0.5,
			damage = 24, hitbox = box(26, 10, 4, 1), kbBase = 40, kbGrowth = 100, kbAngle = 40,
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.6, -0.2 }, Waist = { -25, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 70, 0, -10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.1, 0 }, Waist = { 15, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 35 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -35 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			hold = 0.2, shake = true, prop = "platine",
			windupFx = { { "screen", color = PINK, alpha = 0.2 }, { "text", text = "3… 2… 1…", color = PINK } },
			fx = { { "ring", color = PINK, radius = 12, at = "root" }, { "pillar", color = BLUE, height = 14, width = 4, at = "front" }, { "symbols", symbols = { "♪", "♫", "🔊" }, color = GOLD, count = 8, radius = 6 }, { "shake", amount = 0.8 } },
			text = "LE DROP ULTIME !", hitText = "BOUM BOUM BOUM !",
		},
		-- Super ↑ : il lance son vinyle vers le haut d'un grand scratch et fait trembler la piste
		SUPER_up = {
			label = "Scratch du ciel !", superCost = 100, startup = 0.3, active = 0.25, recovery = 0.55,
			damage = 22, hitbox = box(7, 10, 2, 4), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -10, -20, 0, 0, -0.9, 0.2 }, Waist = { -25, -20, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { 8, 15, 0, 0, 0.5, -0.2 }, Waist = { 18, 20, 0 }, Neck = { 35, 0, 0 }, RS = { 180, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.6, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			follow = { Root = { 12, 20, 0, 0, 0.6, -0.2 }, Waist = { 22, 25, 0 }, Neck = { 40, 0, 0 }, RS = { 190, 0, 15 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.7, 0 }, FL = { 0, 0, 0, 0, 0.5, 0 } },
			hold = 0.25, selfVelocity = Vector2.new(0, 45),
			windupFx = { "super" }, trail = "prop", status = { name = "dancing", duration = 2 }, fx = { { "symbols", symbols = { "♪", "♫", "🎶" }, count = 8, color = Color3.fromRGB(255, 200, 60) }, { "shake", amount = 0.4 } }, text = "ON MONTE LE SON !", hitText = "WIKI-WIKI !",
		},
		-- Le Slow : il ouvre les bras et se balance ; l'adversaire est forcé de danser un slow pendant que Papi se soigne
		SUPER_down = {
			label = "Le Slow", superCost = 100, startup = 0.4, active = 0.2, recovery = 0.5,
			damage = 18, hitbox = box(20, 8, 0, 1), kbBase = 12, kbGrowth = 15, kbAngle = 60,
			status = { name = "dancing", duration = 3 },
			selfEffect = { heal = 15 },
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Neck = { 10, 0, 8 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 0, 0, -6, 0, -0.22, 0 }, Waist = { 4, 0, -6 }, Neck = { 10, 0, -12 }, RS = { 85, 0, -25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, 25 }, LE = { 70, 0, 0 } },
			follow = { Root = { 0, 0, 6, 0, -0.22, 0 }, Waist = { 4, 0, 6 }, Neck = { 10, 0, 12 }, RS = { 85, 0, -25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, 25 }, LE = { 70, 0, 0 } },
			hold = 0.5,
			windupFx = { { "text", text = "UN PETIT SLOW ?", color = PINK } },
			fx = { { "symbols", symbols = { "💕", "♪", "🎶" }, color = PINK, count = 8, radius = 5 }, { "screen", color = PINK, alpha = 0.15 } },
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
	-- P… : vinyle, charentaise, 33 tours
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side", S = "S_finish_scratch" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", S = "S_finish_scratch" }, -- P P
	P_combo3 = { K = "K_combo3", S = "S_finish_tube" }, -- P P P
	PK_combo = { P = "KP_combo", K = "K_combo2", S = "S_finish_scratch" }, -- P K
	KP_combo = { P = "P_combo3", K = "K_combo3", S = "S_finish_tube" }, -- K P / P K P
	-- K… : charentaises
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_scratch" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_scratch" }, -- K K
	K_combo3 = { S = "S_finish_tube" }, -- K K K
	-- avec une flèche
	P_side = { P = "P_combo2", K = "K_side", S = "S_finish_tube" }, -- → P
	P_down = { P = "P_up", K = "K_down", S = "S_finish_scratch" }, -- ↓ P
	P_up = { K = "K_up", S = "S_finish_tube" }, -- ↑ P
	K_side = { P = "KP_combo", S = "S_finish_scratch" }, -- → K
	K_down = { P = "P_up", S = "S_finish_scratch" }, -- ↓ K
	K_up = { P = "P_combo3", S = "S_finish_tube" }, -- ↑ K
	P_dash = { P = "P_combo2", K = "K_side", S = "S_finish_scratch" }, -- dash P
	K_dash = { P = "P_up", S = "S_finish_tube" }, -- dash K
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

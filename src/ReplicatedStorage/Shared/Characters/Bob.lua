-- Gros Bob, le Yéti en vacances : énorme boule de poils en chemise hawaïenne et tongs, crème solaire sur le nez,
-- qui ne pense qu'à rester au frais. Choppeur : ses saisies et ses projections font mal. Arme sortie de la Caisse
-- Bizarre : Glacière & Tongs (les tongs sont toujours à ses pieds, la glacière n'apparaît qu'une fois la caisse ouverte).
--
-- Mécanique « fresh » (Fraîcheur ❄️) : la jauge baisse quand il bouge et remonte quand il reste planté ; haute
-- (≥ 70), ses coups au corps à corps gèlent l'adversaire. Le Granita (ESQUIVE puis S) et le Mur de glace (↓S)
-- la remontent d'un coup.
-- Format des coups, poses et effets : voir Gege.lua et docs/fiche-perso.md.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local FUR = Color3.fromRGB(238, 242, 250)
local FUR_SHADE = Color3.fromRGB(205, 215, 232)
local FACE = Color3.fromRGB(150, 172, 200)
local SHIRT = Color3.fromRGB(30, 170, 200)
local SHIRT_DARK = Color3.fromRGB(20, 120, 150)
local SHORTS = Color3.fromRGB(250, 150, 50)
local PINK = Color3.fromRGB(255, 105, 160)
local YELLOW = Color3.fromRGB(255, 220, 60)
local TONG = Color3.fromRGB(60, 200, 120)
local ICE = Color3.fromRGB(165, 225, 255)
local SNOW = Color3.fromRGB(248, 252, 255)
local COOLER = Color3.fromRGB(215, 45, 45)
local WHITE = Color3.fromRGB(245, 245, 248)
local BLACK = Color3.fromRGB(20, 20, 25)

local SNOWBALL = { shape = "ball", size = 2.2, color = SNOW, spin = 6, parts = {
	{ "ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0.6, 0.5, 0), ICE },
} }
local ICE_CUBE = { shape = "block", size = 0.9, color = ICE, material = "Ice", spin = 10 }

local data = {
	id = "Bob",
	name = "Gros Bob",
	costume = "Bob",
	style = "yeti",

	look = {
		body = { head = FUR, upper = SHIRT, lower = SHORTS, arms = SHIRT, hands = FACE, legs = FUR, feet = FUR,
			forearms = FUR, shins = FUR },
		cubeHead = 1.3,
		parts = {
			-- tête : touffe de poils, visage bleuté, gros sourcil, nez tartiné de crème solaire, lunettes relevées
			{ "Touffe", "Head", "ball", Vector3.new(1.5, 0.8, 1.5), Vector3.new(0, 0.72, 0.05), Vector3.new(0, 0, 0), FUR, "Fabric" },
			{ "Visage", "Head", "block", Vector3.new(1.0, 0.85, 0.06), Vector3.new(0, -0.08, -0.66), Vector3.new(0, 0, 0), FACE, "SmoothPlastic" },
			{ "Sourcil", "Head", "block", Vector3.new(1.1, 0.2, 0.18), Vector3.new(0, 0.38, -0.7), Vector3.new(0, 0, 0), FUR_SHADE, "Fabric" },
			{ "Nez", "Head", "ball", Vector3.new(0.5, 0.38, 0.4), Vector3.new(0, 0.05, -0.8), Vector3.new(0, 0, 0), Color3.fromRGB(70, 85, 120), "SmoothPlastic" },
			{ "CremeSolaire", "Head", "block", Vector3.new(0.34, 0.14, 0.12), Vector3.new(0, 0.18, -0.96), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
			{ "Lunettes", "Head", "block", Vector3.new(1.05, 0.26, 0.08), Vector3.new(0, 0.62, -0.68), Vector3.new(-10, 0, 0), BLACK, "Glass", { reflect = 0.3 } },
			{ "Branche", "Head", "block", Vector3.new(1.35, 0.06, 1.0), Vector3.new(0, 0.62, -0.2), Vector3.new(-10, 0, 0), Color3.fromRGB(255, 80, 150), "SmoothPlastic" },
			{ "CrocG", "Head", "block", Vector3.new(0.16, 0.2, 0.06), Vector3.new(-0.22, -0.4, -0.7), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
			{ "CrocD", "Head", "block", Vector3.new(0.16, 0.2, 0.06), Vector3.new(0.22, -0.4, -0.7), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
			-- chemise hawaïenne ouverte sur le ventre poilu, col pelle à tarte, fleurs
			{ "Ventre", "UpperTorso", "ball", Vector3.new(1.3, 1.6, 0.5), Vector3.new(0, -0.15, -0.45), Vector3.new(0, 0, 0), FUR, "Fabric" },
			{ "ColG", "UpperTorso", "block", Vector3.new(0.55, 0.4, 0.08), Vector3.new(-0.5, 0.72, -0.53), Vector3.new(0, 0, 28), SHIRT_DARK, "Fabric" },
			{ "ColD", "UpperTorso", "block", Vector3.new(0.55, 0.4, 0.08), Vector3.new(0.5, 0.72, -0.53), Vector3.new(0, 0, -28), SHIRT_DARK, "Fabric" },
			{ "Fleur1", "UpperTorso", "ball", Vector3.new(0.38, 0.38, 0.06), Vector3.new(-0.7, 0.1, -0.52), Vector3.new(0, 0, 0), PINK, "SmoothPlastic" },
			{ "Fleur2", "UpperTorso", "ball", Vector3.new(0.32, 0.32, 0.06), Vector3.new(0.75, -0.45, -0.52), Vector3.new(0, 0, 0), YELLOW, "SmoothPlastic" },
			{ "Fleur3", "UpperTorso", "ball", Vector3.new(0.45, 0.45, 0.06), Vector3.new(0.3, 0.3, 0.52), Vector3.new(0, 0, 0), PINK, "SmoothPlastic" },
			-- grosses épaules de fourrure (silhouette de yéti)
			{ "EpauleG", "LeftUpperArm", "ball", Vector3.new(1.3, 0.9, 1.3), Vector3.new(0, 0.45, 0), Vector3.new(0, 0, 0), FUR, "Fabric" },
			{ "EpauleD", "RightUpperArm", "ball", Vector3.new(1.3, 0.9, 1.3), Vector3.new(0, 0.45, 0), Vector3.new(0, 0, 0), FUR, "Fabric" },
			-- tongs vertes
			{ "SemelleG", "LeftFoot", "block", Vector3.new(1.05, 0.12, 1.6), Vector3.new(0, -0.32, -0.15), Vector3.new(0, 0, 0), TONG, "SmoothPlastic" },
			{ "SemelleD", "RightFoot", "block", Vector3.new(1.05, 0.12, 1.6), Vector3.new(0, -0.32, -0.15), Vector3.new(0, 0, 0), TONG, "SmoothPlastic" },
			{ "LanièreG", "LeftFoot", "block", Vector3.new(0.9, 0.12, 0.12), Vector3.new(0, 0, -0.4), Vector3.new(0, 0, 0), YELLOW, "SmoothPlastic" },
			{ "LanièreD", "RightFoot", "block", Vector3.new(0.9, 0.12, 0.12), Vector3.new(0, 0, -0.4), Vector3.new(0, 0, 0), YELLOW, "SmoothPlastic" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : la glacière rouge à couvercle blanc, tenue par l'anse
			{ name = "PropGlaciere", hand = "Right", visible = true, pieces = {
				{ "Anse", "", "block", Vector3.new(0.18, 0.5, 0.9), Vector3.new(0, -0.2, 0), Vector3.new(0, 0, 0), Color3.fromRGB(180, 180, 190), "SmoothPlastic" },
				{ "Couvercle", "", "block", Vector3.new(1.2, 0.25, 1.7), Vector3.new(0, -0.5, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
				{ "Caisse", "", "block", Vector3.new(1.1, 1.1, 1.6), Vector3.new(0, -1.15, 0), Vector3.new(0, 0, 0), COOLER, "SmoothPlastic" },
				{ "Bande", "", "block", Vector3.new(1.12, 0.15, 1.62), Vector3.new(0, -1.3, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
				{ "Paille", "", "cyl", Vector3.new(0.6, 0.08, 0.08), Vector3.new(0.2, -0.3, 0.5), Vector3.new(0, 0, 20), PINK, "SmoothPlastic", { axis = "y" } },
			} },
			-- parasol de plage (main gauche)
			{ name = "PropParasol", hand = "Left", visible = false, pieces = {
				{ "Mat", "", "cyl", Vector3.new(3.2, 0.12, 0.12), Vector3.new(0, -1.5, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic", { axis = "y" } },
				{ "Toile", "", "ball", Vector3.new(3.8, 0.9, 3.8), Vector3.new(0, -3.1, 0), Vector3.new(0, 0, 0), YELLOW, "Fabric" },
				{ "Bande", "", "ball", Vector3.new(1.4, 0.95, 3.85), Vector3.new(0, -3.12, 0), Vector3.new(0, 0, 0), PINK, "Fabric" },
				{ "Pointe", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0, -3.6, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
			} },
			-- boule de neige tassée (main gauche)
			{ name = "PropBouleNeige", hand = "Left", visible = false, pieces = {
				{ "Boule", "", "ball", Vector3.new(1.1, 1.1, 1.1), Vector3.new(0, -0.45, 0), Vector3.new(0, 0, 0), SNOW, "Sand" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Double claque poilue : les deux grosses paluches s'abattent l'une après l'autre (2 touches, très lourdes)
		P_neutral = {
			label = "Double claque poilue", startup = 0.1, active = 0.14, recovery = 0.18,
			damage = 4, hits = 2, hitbox = box(4.5, 3.2, 2.5, 0.8), kbBase = 22, kbGrowth = 28, kbAngle = 30,
			windup = { Root = { 6, 10, 0, 0, -0.25, 0.15 }, Waist = { 10, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 120, 0, 60 }, RE = { 60, 0, 0 }, LS = { 140, 0, -70 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, -14, 0, 0, -0.35, -0.3 }, Waist = { -14, -18, 0 }, Neck = { -4, 10, 0 }, RS = { 130, 0, 50 }, RE = { 40, 0, 0 }, LS = { 80, 0, 20 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -10, 14, 0, 0, -0.38, -0.35 }, Waist = { -14, 16, 0 }, Neck = { -4, -10, 0 }, RS = { 75, 0, -10 }, RE = { 15, 0, 0 }, LS = { 50, 0, 30 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			trail = "bothHands", hitText = "CLAC ! CLAC !",
		},
		-- J J : Claque retour, revers de la paluche gauche, les poils volent
		P_combo2 = {
			label = "Claque retour", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(4.5, 3, 2.5, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { -4, -20, 0, 0, -0.3, -0.2 }, Waist = { -6, -26, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 70, 0, 50 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, 18, 0, 0, -0.32, -0.3 }, Waist = { -10, 24, 0 }, RS = { 25, 0, 45 }, RE = { 60, 0, 0 }, LS = { 92, 0, -40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -8, 24, 0, 0, -0.32, -0.32 }, Waist = { -10, 30, 0 }, RS = { 25, 0, 48 }, RE = { 60, 0, 0 }, LS = { 85, 0, -65 }, LE = { 10, 0, 0 }, LW = { -10, 0, 0 } },
			trail = "leftHand", fx = { { "toss", shape = "ball", color = FUR, count = 3, size = 0.3, speed = 10 } }, hitText = "FLAAC !",
		},
		-- J J J : Glacière sur la tête, il soulève la glacière à deux mains et l'abat comme un marteau
		P_combo3 = {
			label = "Glacière sur la tête", startup = 0.16, active = 0.1, recovery = 0.32,
			damage = 9, hitbox = box(5, 4, 2.6, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 10, 0, 0, 0, 0, 0.25 }, Waist = { 16, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 190, 0, -8 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, 8 }, LE = { 40, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.55, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 75, 0, -8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 8 }, LE = { 0, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.6, -0.45 }, Waist = { -34, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 55, 0, -8 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 55, 0, 8 }, LE = { 0, 0, 0 } },
			trail = "prop", fx = { { "toss", shape = "flat", color = ICE, count = 4, size = 0.5, speed = 14 }, { "shake", amount = 0.3 } }, text = "AU FRAIS !", hitText = "BLONK !",
		},
		-- Coup de glacière : il la balance par l'anse d'arrière en avant, tout le poids derrière
		P_side = {
			label = "Coup de glacière", startup = 0.13, active = 0.1, recovery = 0.22,
			damage = 9, hitbox = box(5.5, 3.2, 3, 0.2), kbBase = 24, kbGrowth = 38, kbAngle = 22, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 6, -30, 0, 0, -0.3, 0.3 }, Waist = { 8, -36, 0 }, Neck = { 0, 20, 0 }, RS = { -70, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, 22, 0, 0, -0.42, -0.4 }, Waist = { -14, 34, 0 }, Neck = { 0, -16, 0 }, RS = { 95, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 34, 0, 0, -0.42, -0.5 }, Waist = { -16, 48, 0 }, Neck = { 0, -24, 0 }, RS = { 100, 0, -25 }, RE = { 15, 0, 0 }, RW = { -10, 0, 0 }, LS = { -40, 0, -45 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", hitText = "BONG !",
		},
		-- → J J : Revers de glacière, elle revient dans l'autre sens en tournant sur l'anse
		P_side2 = {
			label = "Revers de glacière", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 7, hitbox = box(5, 3, 3, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 28, selfVelocity = Vector2.new(10, 0),
			windup = { Root = { -10, 40, 0, 0, -0.4, -0.4 }, Waist = { -14, 50, 0 }, RS = { 95, 0, -40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, -20, 0, 0, -0.35, -0.45 }, Waist = { -10, -34, 0 }, RS = { 95, 0, 55 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			follow = { Root = { -6, -28, 0, 0, -0.35, -0.5 }, Waist = { -10, -44, 0 }, RS = { 85, 0, 75 }, RE = { 20, 0, 0 }, RW = { -15, 0, 0 }, LS = { 45, 0, -30 }, LE = { 70, 0, 0 } },
			trail = "prop", hitText = "BLOMP !",
		},
		-- Glissade sur glace : il glisse sur une plaque de glace, coup de tong rasant (fait décoller)
		P_down = {
			label = "Glissade sur glace", startup = 0.1, active = 0.14, recovery = 0.22,
			damage = 6, hitbox = box(6, 2, 2.8, -2), kbBase = 26, kbGrowth = 24, kbAngle = 75, selfVelocity = Vector2.new(26, 0),
			windup = { Root = { -8, -18, 0, 0, -0.7, 0.2 }, Waist = { -14, -10, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { -15, 0, 18 }, RK = { -60, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { 10, 20, 0, 0, -1.1, -0.2 }, Waist = { -16, 14, 0 }, RS = { 20, 0, 70 }, RE = { 20, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { 72, 0, 8 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 12, 28, 0, 0, -1.15, -0.25 }, Waist = { -16, 22, 0 }, RS = { 15, 0, 75 }, RE = { 20, 0, 0 }, LS = { 64, 0, -40 }, LE = { 40, 0, 0 }, RH = { 70, 0, -8 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { { "puddle", color = ICE, width = 6 } }, hitText = "SCHLIIIP !",
		},
		-- ↓ J J : Bourrade remontante, depuis l'accroupi, gros uppercut de la paluche gauche
		P_down2 = {
			label = "Bourrade remontante", startup = 0.11, active = 0.1, recovery = 0.26,
			damage = 8, hitbox = box(4, 5, 2, 2), kbBase = 30, kbGrowth = 45, kbAngle = 80,
			windup = { Root = { -10, 10, 0, 0, -0.9, 0.1 }, Waist = { -24, 10, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { -20, 0, -20 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, -12, 0, 0, 0.15, -0.2 }, Waist = { 14, -16, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 50 }, RE = { 50, 0, 0 }, LS = { 165, 0, -5 }, LE = { 15, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 8, -14, 0, 0, 0.2, -0.25 }, Waist = { 16, -18, 0 }, Neck = { 24, 0, 0 }, RS = { 42, 0, 52 }, RE = { 50, 0, 0 }, LS = { 175, 0, 0 }, LE = { 8, 0, 0 }, LW = { -10, 0, 0 } },
			trail = "leftHand", hitText = "BOUMF !",
		},
		-- Parasol (anti-air, ex-←J) : il plante le parasol vers le ciel et l'ouvre d'un coup sec au-dessus de lui
		P_up = {
			label = "Parasol", startup = 0.11, active = 0.12, recovery = 0.22,
			damage = 7, hitbox = box(5, 5, 1, 3.8), kbBase = 28, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -4, 10, 0, 0, -0.4, 0 }, Waist = { -10, 12, 0 }, RS = { 30, 0, 40 }, RE = { 50, 0, 0 }, LS = { 40, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, -6, 0, 0, 0.1, 0 }, Waist = { 12, -8, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 172, 0, -5 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 8, -8, 0, 0, 0.15, 0 }, Waist = { 14, -10, 0 }, Neck = { 34, 0, 0 }, RS = { 45, 0, 65 }, RE = { 30, 0, 0 }, LS = { 178, 0, -8 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			prop = "parasol", text = "À L'OMBRE !", hitText = "FLOP !",
		},
		-- Parasol ouvert (J en l'air) : parasol grand ouvert, il le fait tournoyer autour de lui
		P_air = {
			label = "Parasol ouvert", startup = 0.1, active = 0.2, recovery = 0.2,
			damage = 7, hitbox = box(6.5, 4.5, 0.5, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 38,
			windup = { Root = { 6, -30, 0 }, Waist = { 6, -20, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 120, 0, 40 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 100, 0, -80 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 30, 0, 10 }, RK = { -50, 0, 0 }, LH = { 30, 0, -10 }, LK = { -50, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 62 }, RE = { 20, 0, 0 }, LS = { 100, 0, -85 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 25, 0, 12 }, RK = { -45, 0, 0 }, LH = { 25, 0, -12 }, LK = { -45, 0, 0 } },
			prop = "parasol", spin = { axis = "y", degrees = 360 }, trail = "leftHand", hitText = "FLOUF !",
		},
		-- Bousculade de bedaine (dash puis J) : il fonce, rentre le cou et projette son gros ventre en avant
		P_dash = {
			label = "Bousculade de bedaine", startup = 0.09, active = 0.14, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 4, 2.2, 0.3), kbBase = 32, kbGrowth = 45, kbAngle = 25, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -10, 0, 0, 0, -0.3, 0.3 }, Waist = { -24, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 50, 0, 30 }, RE = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 16, 0, 0, 0, -0.2, -0.6 }, Waist = { 26, 0, 0 }, Neck = { -22, 0, 0 }, RS = { -50, 0, 40 }, RE = { 20, 0, 0 }, LS = { -50, 0, -40 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 20, 0, 0, 0, -0.2, -0.7 }, Waist = { 30, 0, 0 }, Neck = { -26, 0, 0 }, RS = { -60, 0, 45 }, RE = { 25, 0, 0 }, LS = { -60, 0, -45 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			fx = { "dust" }, text = "BEDAINE !", hitText = "BLOUMF !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Coup de tong : grand coup de pied de face, la tong claque sur la joue de l'adversaire
		K_neutral = {
			label = "Coup de tong", startup = 0.2, active = 0.1, recovery = 0.32,
			damage = 11, hitbox = box(5, 3, 3.2, 0.3), kbBase = 30, kbGrowth = 70, kbAngle = 36,
			windup = { Root = { 10, -10, 0, 0, -0.15, 0.15 }, Waist = { 10, -8, 0 }, RS = { 40, 0, 55 }, RE = { 50, 0, 0 }, LS = { 50, 0, -55 }, LE = { 50, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, RA = { -10, 0, 0 } },
			strike = { Root = { 16, -4, 0, 0, -0.1, 0.05 }, Waist = { 14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 72 }, RE = { 25, 0, 0 }, LS = { 65, 0, -72 }, LE = { 25, 0, 0 }, RH = { 98, 0, 0 }, RK = { -4, 0, 0 }, RA = { 25, 0, 0 } },
			follow = { Root = { 20, -2, 0, 0, -0.1, 0.1 }, Waist = { 16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 65, 0, 78 }, RE = { 25, 0, 0 }, LS = { 70, 0, -78 }, LE = { 25, 0, 0 }, RH = { 106, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			trail = "rightFoot", hitText = "FLAP !",
		},
		-- K K : Tong retournée, il pivote lourdement et fouette du talon gauche
		K_combo2 = {
			label = "Tong retournée", startup = 0.15, active = 0.1, recovery = 0.27,
			damage = 9, hitbox = box(5, 3, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 4, 40, 0, 0, -0.2, 0.1 }, Waist = { 4, 30, 0 }, RS = { 60, 0, 50 }, RE = { 50, 0, 0 }, LS = { 40, 0, -55 }, LE = { 40, 0, 0 }, LH = { 50, 0, -35 }, LK = { -100, 0, 0 } },
			strike = { Root = { 12, -50, 0, 0, -0.15, 0 }, Waist = { 10, -30, 0 }, RS = { 70, 0, 65 }, RE = { 40, 0, 0 }, LS = { 30, 0, -70 }, LE = { 30, 0, 0 }, LH = { 82, 0, -50 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 14, -68, 0, 0, -0.15, 0 }, Waist = { 12, -36, 0 }, RS = { 72, 0, 66 }, RE = { 40, 0, 0 }, LS = { 25, 0, -74 }, LE = { 30, 0, 0 }, LH = { 78, 0, -38 }, LK = { -8, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "leftFoot", hitText = "SCHLAC !",
		},
		-- K K K : Saut de yéti, il bondit lourdement et écrase un coup de pied tendu en retombant
		K_combo3 = {
			label = "Saut de yéti", startup = 0.18, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(5, 4, 3, 0.8), kbBase = 32, kbGrowth = 80, kbAngle = 38, selfVelocity = Vector2.new(14, 38),
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -16, 0, 0 }, RS = { -40, 0, 40 }, RE = { 30, 0, 0 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, 70 }, RE = { 20, 0, 0 }, LS = { 80, 0, -70 }, LE = { 20, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 18, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 65, 0, 76 }, RE = { 20, 0, 0 }, LS = { 75, 0, -76 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 35, 0, 0 }, LK = { -115, 0, 0 } },
			trail = "rightFoot", text = "YÉÉÉTI !", hitText = "BOUM !",
		},
		-- Pied de yéti (→K) : il soulève son énorme pied et pousse droit devant comme on enfonce une porte
		K_side = {
			label = "Pied de yéti", startup = 0.24, active = 0.12, recovery = 0.36,
			damage = 13, hitbox = box(5, 3.5, 3.2, 0), kbBase = 33, kbGrowth = 85, kbAngle = 25, selfVelocity = Vector2.new(25, 0),
			windup = { Root = { 18, 0, 0, 0, -0.1, 0.3 }, Waist = { 16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 60 }, RE = { 50, 0, 0 }, LS = { 40, 0, -60 }, LE = { 50, 0, 0 }, RH = { 110, 0, 0 }, RK = { -130, 0, 0 }, RA = { 20, 0, 0 } },
			strike = { Root = { 24, 0, 0, 0, -0.15, -0.3 }, Waist = { 10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -20, 0, 60 }, RE = { 30, 0, 0 }, LS = { -20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -2, 0, 0 }, RA = { 30, 0, 0 } },
			follow = { Root = { 26, 0, 0, 0, -0.15, -0.4 }, Waist = { 12, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -25, 0, 62 }, RE = { 30, 0, 0 }, LS = { -25, 0, -62 }, LE = { 30, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
			trail = "rightFoot", fx = { { "shake", amount = 0.25 } }, text = "POUSSE-TOI !", hitText = "BLAOUM !",
		},
		-- → K K : Écrase-orteils, il ramène la jambe et écrase le pied de l'adversaire (le fait rebondir)
		K_side2 = {
			label = "Écrase-orteils", startup = 0.15, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(4.5, 2.5, 2.5, -1.5), kbBase = 30, kbGrowth = 55, kbAngle = 72,
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.1 }, Waist = { 10, 0, 0 }, RS = { 60, 0, 50 }, RE = { 30, 0, 0 }, LS = { 60, 0, -50 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -110, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.4, -0.3 }, Waist = { -16, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 20, 0, 50 }, RE = { 40, 0, 0 }, LS = { 20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 30, 0, 0 }, RK = { -10, 0, 0 }, RA = { 0, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.45, -0.32 }, Waist = { -18, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 15, 0, 52 }, RE = { 40, 0, 0 }, LS = { 15, 0, -52 }, LE = { 40, 0, 0 }, RH = { 28, 0, 0 }, RK = { -12, 0, 0 }, RA = { 0, 0, 0 } },
			fx = { "dust", { "shake", amount = 0.3 } }, hitText = "AÏE MES ORTEILS !",
		},
		-- Boule de neige basse (↓K) : il ramasse la neige à ses pieds et fait rouler une grosse boule au ras du sol (ralentit)
		K_down = {
			label = "Boule de neige basse", kind = "projectile", startup = 0.2, active = 0, recovery = 0.32,
			damage = 10, kbBase = 26, kbGrowth = 55, kbAngle = 55,
			projectile = { speed = 45, angle = 0, gravity = 0, lifetime = 0.8, size = 2, color = SNOW, from = "feet", visual = SNOWBALL },
			status = { name = "slowed", duration = 1.5 },
			windup = { Root = { -14, 0, 0, 0, -0.9, 0.2 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 30 }, RE = { 40, 0, 0 }, LS = { 30, 0, -10 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.95, -0.2 }, Waist = { -34, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 40 }, RE = { 40, 0, 0 }, LS = { 70, 0, -5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -14, 0, 0, 0, -0.9, -0.25 }, Waist = { -30, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 20, 0, 42 }, RE = { 40, 0, 0 }, LS = { 80, 0, -8 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 } },
			prop = "bouleNeige", fx = { { "particles", tex = "smoke", color = SNOW, at = "feet", dir = "front", time = 0.25, speed = 8 } }, text = "ROULEZ !", hitText = "PLOUF !",
		},
		-- ↓ K K : Glissade de banquise, il se jette sur le ventre et glisse sur la glace, bras devant
		K_downK = {
			label = "Glissade de banquise", startup = 0.12, active = 0.24, recovery = 0.3,
			damage = 9, hitbox = box(6, 2.5, 2.5, -1.6), kbBase = 30, kbGrowth = 50, kbAngle = 70, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -16, 0, 0, 0, -0.7, 0.15 }, Waist = { -16, 0, 0 }, RS = { 140, 0, 20 }, RE = { 20, 0, 0 }, LS = { 140, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -78, 0, 0, 0, -1.45, -0.4 }, Waist = { 8, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 175, 0, 15 }, RE = { 0, 0, 0 }, LS = { 175, 0, -15 }, LE = { 0, 0, 0 }, RH = { -8, 0, 6 }, RK = { -20, 0, 0 }, RA = { 20, 0, 0 }, LH = { -8, 0, -6 }, LK = { -30, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { -80, 0, 0, 0, -1.5, -0.5 }, Waist = { 10, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -10, 0, 6 }, RK = { -35, 0, 0 }, RA = { 20, 0, 0 }, LH = { -10, 0, -6 }, LK = { -15, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "body", fx = { { "puddle", color = ICE, width = 8 } }, hitText = "ZIOUUUM !",
		},
		-- Bronzette (ex-←K, recul allongé) : il se laisse tomber en arrière comme sur un transat et rue des deux pieds vers le ciel
		K_up = {
			label = "Bronzette", startup = 0.2, active = 0.14, recovery = 0.34,
			damage = 11, hitbox = box(5, 5.5, 1, 3), kbBase = 32, kbGrowth = 72, kbAngle = 84, selfVelocity = Vector2.new(-16, 0),
			windup = { Root = { 10, 0, 0, 0, -0.4, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 140, 0, 20 }, RE = { 120, 0, 0 }, LS = { 140, 0, -20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 55, 0, 0, 0, -1.3, 0.5 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 30 }, RE = { 120, 0, 0 }, LS = { 160, 0, -30 }, LE = { 120, 0, 0 }, RH = { 120, 0, 6 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 115, 0, -6 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 58, 0, 0, 0, -1.35, 0.55 }, Waist = { 12, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 165, 0, 32 }, RE = { 125, 0, 0 }, LS = { 165, 0, -32 }, LE = { 125, 0, 0 }, RH = { 128, 0, 6 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 122, 0, -6 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", fx = { { "symbols", symbols = { "☀️", "😎" }, count = 3, radius = 2, at = "above" } }, text = "AAAH, LES VACANCES…", hitText = "PAF-PAF !",
		},
		-- ↑ K K : Ruade de transat, toujours allongé, il replie les genoux et détend les deux tongs plus haut encore
		K_upK = {
			label = "Ruade de transat", startup = 0.14, active = 0.12, recovery = 0.34,
			damage = 10, hitbox = box(4, 5.5, 1, 3.5), kbBase = 30, kbGrowth = 55, kbAngle = 86,
			windup = { Root = { 50, 0, 0, 0, -1.3, 0.5 }, Waist = { 10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 140, 0, 30 }, RE = { 100, 0, 0 }, LS = { 140, 0, -30 }, LE = { 100, 0, 0 }, RH = { 130, 0, 6 }, RK = { -120, 0, 0 }, LH = { 130, 0, -6 }, LK = { -120, 0, 0 } },
			strike = { Root = { 40, 0, 0, 0, -1.0, 0.4 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 30, 0, 0 }, LS = { 120, 0, -50 }, LE = { 30, 0, 0 }, RH = { 150, 0, 4 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 150, 0, -4 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 38, 0, 0, 0, -0.95, 0.4 }, Waist = { 6, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 115, 0, 55 }, RE = { 30, 0, 0 }, LS = { 115, 0, -55 }, LE = { 30, 0, 0 }, RH = { 158, 0, 4 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 158, 0, -4 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", hitText = "PATATRAS !",
		},
		-- Double tong (K en l'air) : genoux repliés sous la bedaine, puis les deux tongs claquent devant
		K_air = {
			label = "Double tong", startup = 0.18, active = 0.14, recovery = 0.26,
			damage = 12, hitbox = box(5, 4, 2.5, -0.3), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, RS = { 60, 0, 45 }, RE = { 60, 0, 0 }, LS = { 60, 0, -45 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -130, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 22, 0, 0 }, Waist = { 20, 0, 0 }, RS = { -30, 0, 55 }, RE = { 20, 0, 0 }, LS = { -30, 0, -55 }, LE = { 20, 0, 0 }, RH = { 88, 0, 5 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 80, 0, -5 }, LK = { -5, 0, 0 }, LA = { 25, 0, 0 } },
			follow = { Root = { 26, 0, 0 }, Waist = { 22, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 94, 0, 5 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 86, 0, -5 }, LK = { -4, 0, 0 }, LA = { 25, 0, 0 } },
			trail = "bothFeet", hitText = "FLIP-FLAP !",
		},
		-- Plaquage de yéti (dash puis K) : épaule en avant, il percute de tout son poids (encaisse sans broncher)
		K_dash = {
			label = "Plaquage de yéti", startup = 0.12, active = 0.2, recovery = 0.32,
			damage = 11, hitbox = box(4.5, 4, 2, 0.3), kbBase = 32, kbGrowth = 65, kbAngle = 30, selfVelocity = Vector2.new(50, 0), armor = true,
			windup = { Root = { -10, -20, 0, 0, -0.35, 0.15 }, Waist = { -8, -14, 0 }, RS = { -10, 0, 30 }, RE = { 50, 0, 0 }, LS = { 40, 0, -15 }, LE = { 100, 0, 0 } },
			strike = { Root = { -24, -45, 0, 0, -0.45, -0.3 }, Waist = { -10, -15, 0 }, Neck = { -10, 20, 0 }, RS = { -30, 0, 35 }, RE = { 40, 0, 0 }, LS = { 30, 0, -10 }, LE = { 115, 0, 0 } },
			follow = { Root = { -26, -50, 0, 0, -0.47, -0.35 }, Waist = { -12, -18, 0 }, Neck = { -12, 22, 0 }, RS = { -40, 0, 40 }, RE = { 35, 0, 0 }, LS = { 25, 0, -10 }, LE = { 118, 0, 0 } },
			fx = { "dust", { "shake", amount = 0.3 } }, text = "GRRROAR !", hitText = "BADABOUM !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (J / K)
		-- → J en l'air : Pied de yéti volant, il tend son énorme pied à l'horizontale, la tong en avant
		P_air_side = {
			label = "Pied de yéti volant", startup = 0.11, active = 0.12, recovery = 0.2,
			damage = 8, hitbox = box(5, 3, 3, 0), kbBase = 22, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { -12, 20, 0 }, Waist = { -10, 10, 0 }, RS = { 50, 0, 45 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 25, 20, 0 }, Waist = { 8, 5, 0 }, Neck = { -12, 0, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 72, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 28, 22, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, 0, 0 }, RS = { -36, 0, 64 }, RE = { 20, 0, 0 }, LS = { 45, 0, -74 }, LE = { 30, 0, 0 }, RH = { 76, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SPLONK !",
		},
		-- ↑ J en l'air : Claque au plafond, les deux paluches frappent l'une contre l'autre au-dessus de sa tête
		P_air_up = {
			label = "Claque au plafond", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 86,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 70 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, -5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, 5 }, LE = { 10, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, -8 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 178, 0, 8 }, LE = { 10, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "bothHands", hitText = "CLAP !",
		},
		-- ↓ J en l'air : Avalanche de ventre, il se met à plat ventre et s'écrase de tout son poids (smash vers le sol)
		P_air_down = {
			label = "Avalanche de ventre", startup = 0.16, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(5, 4, 0.5, -2), kbBase = 25, kbGrowth = 55, kbAngle = -75, selfVelocity = Vector2.new(0, -50),
			windup = { Root = { 15, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 40 }, RE = { 20, 0, 0 }, LS = { 170, 0, -40 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -80, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 90, 0, 85 }, RE = { 10, 0, 0 }, LS = { 90, 0, -85 }, LE = { 10, 0, 0 }, RH = { -10, 0, 15 }, RK = { -20, 0, 0 }, LH = { -10, 0, -15 }, LK = { -20, 0, 0 } },
			follow = { Root = { -84, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 90, 0, 88 }, RE = { 10, 0, 0 }, LS = { 90, 0, -88 }, LE = { 10, 0, 0 }, RH = { -12, 0, 18 }, RK = { -25, 0, 0 }, LH = { -12, 0, -18 }, LK = { -25, 0, 0 } },
			trail = "body", fx = { { "burst", color = SNOW, size = 4, at = "feet" } }, text = "AVALANCHE !", hitText = "FLOMP !",
		},
		-- → K en l'air : Tong volante, il tournoie en l'air et fouette du pied, la tong au bout
		K_air_side = {
			label = "Tong volante", startup = 0.16, active = 0.14, recovery = 0.26,
			damage = 11, hitbox = box(5.5, 3, 3, 0), kbBase = 30, kbGrowth = 70, kbAngle = 34,
			windup = { Root = { -10, 30, 0 }, Waist = { -10, 20, 0 }, RS = { 50, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 90, 0, 0 }, RK = { -130, 0, 0 }, LH = { 50, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 22, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 20, 0, 80 }, RE = { 10, 0, 0 }, LS = { 30, 0, -80 }, LE = { 10, 0, 0 }, RH = { 85, 0, 20 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 24, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 15, 0, 85 }, RE = { 10, 0, 0 }, LS = { 25, 0, -85 }, LE = { 10, 0, 0 }, RH = { 88, 0, 10 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 32, 0, 0 }, LK = { -104, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "FLAAAP !",
		},
		-- ↑ K en l'air : Coup de boule de yéti, il rentre la tête puis la projette vers le haut, touffe la première
		K_air_up = {
			label = "Coup de boule de yéti", startup = 0.15, active = 0.14, recovery = 0.26,
			damage = 10, hitbox = box(4, 4.5, 0.5, 3.2), kbBase = 30, kbGrowth = 65, kbAngle = 86,
			windup = { Root = { -14, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 30, 0, 30 }, RE = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 40, 0, 0 }, RS = { -40, 0, 50 }, RE = { 10, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 }, RH = { -10, 0, 5 }, RK = { -20, 0, 0 }, LH = { -10, 0, -5 }, LK = { -20, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 45, 0, 0 }, RS = { -48, 0, 55 }, RE = { 10, 0, 0 }, LS = { -48, 0, -55 }, LE = { 10, 0, 0 }, RH = { -15, 0, 5 }, RK = { -25, 0, 0 }, LH = { -15, 0, -5 }, LK = { -25, 0, 0 } },
			trail = "head", fx = { "headStar" }, hitText = "BONK !",
		},
		-- ↓ K en l'air : Atterrissage de yéti, il tombe comme une enclume, deux pieds joints (smash vers le sol)
		K_air_down = {
			label = "Atterrissage de yéti", startup = 0.2, active = 0.15, recovery = 0.32,
			damage = 12, hitbox = box(4.5, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -65),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 70 }, RE = { 10, 0, 0 }, LS = { 60, 0, -70 }, LE = { 10, 0, 0 }, RH = { -4, 0, 6 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { -4, 0, -6 }, LK = { 0, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 50, 0, 78 }, RE = { 10, 0, 0 }, LS = { 50, 0, -78 }, LE = { 10, 0, 0 }, RH = { -4, 0, 8 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { -4, 0, -8 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "bothFeet", fx = { { "shake", amount = 0.4 } }, text = "BOUM !", hitText = "KRAKOUM !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Boule de neige : il gonfle les joues, se penche en arrière et crache un gros boulet de glace (ralentit)
		S_neutral = {
			label = "Boule de neige", kind = "projectile", energyCost = 25, startup = 0.2, active = 0, recovery = 0.32,
			damage = 11, kbBase = 26, kbGrowth = 50, kbAngle = 25,
			projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 0.7, size = 2.4, color = SNOW, visual = SNOWBALL },
			status = { name = "slowed", duration = 2 },
			windup = { Root = { 8, 0, 0, 0, -0.15, 0.25 }, Waist = { 18, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 30, 0, -50 }, LE = { 50, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.2 }, Waist = { -18, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -30, 0, 50 }, RE = { 30, 0, 0 }, LS = { -30, 0, -50 }, LE = { 30, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.32, -0.25 }, Waist = { -20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { -35, 0, 52 }, RE = { 30, 0, 0 }, LS = { -35, 0, -52 }, LE = { 30, 0, 0 } },
			shake = true, windupFx = { { "particles", tex = "smoke", color = ICE, at = "head", dir = "up", time = 0.2, speed = 4 } },
			fx = { { "particles", tex = "smoke", color = SNOW, at = "head", dir = "front", time = 0.2, speed = 10 } }, text = "PTOU !", hitText = "PLAF !",
		},
		-- Charge en luge (→S) : il s'assoit sur sa glacière et fonce, rien ne l'arrête (super-armure)
		S_side = {
			label = "Charge en luge", energyCost = 25, startup = 0.12, active = 0.4, recovery = 0.32,
			damage = 12, hitbox = box(5, 3, 2.2, -0.8), kbBase = 32, kbGrowth = 68, kbAngle = 32, selfVelocity = Vector2.new(65, 0), armor = true,
			windup = { Root = { -10, 0, 0, 0, -0.6, 0.2 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -1.2, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -50 }, LE = { 20, 0, 0 }, RH = { 85, 0, 8 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 85, 0, -8 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -1.2, 0 }, Waist = { 8, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 20, 0, 22 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -55 }, LE = { 20, 0, 0 }, RH = { 88, 0, 8 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 88, 0, -8 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "body", fx = { { "particles", tex = "smoke", color = SNOW, at = "feet", dir = "up", time = 0.4, speed = 10, rate = 80 } }, text = "LUGE !", hitText = "SCHLAAAF !",
		},
		-- Mur de glace / Granita (↓S) : il frappe le sol, une barricade de glace jaillit devant lui ; ça le rafraîchit
		S_down = {
			label = "Mur de glace", kind = "wall", energyCost = 25, startup = 0.2, active = 0.1, recovery = 0.35,
			hitbox = box(5, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 45, kbAngle = 30,
			damage = 7, selfEffect = { meter = 35 },
			wall = { size = Vector3.new(1.8, 7, 6), offset = 3.5, lifetime = 6, max = 1, color = ICE,
				visual = { shape = "block", size = 0.2, color = ICE, material = "Ice", transparency = 0.15, trail = false, parts = {
					{ "block", Vector3.new(1.8, 7, 3), Vector3.new(0, 0, 0), ICE, "Ice" },
					{ "wedge", Vector3.new(1.8, 1.2, 3), Vector3.new(0, 4.1, 0), SNOW, "Ice" },
				} } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, LS = { 170, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.7, -0.2 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 10, 0, 0 }, LS = { 40, 0, -20 }, LE = { 10, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.75, -0.22 }, Waist = { -32, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 22 }, RE = { 10, 0, 0 }, LS = { 30, 0, -22 }, LE = { 10, 0, 0 } },
			fx = { { "pillar", color = ICE, height = 7, width = 2, at = "front" }, { "shake", amount = 0.3 } }, text = "MUR DE GLACE !",
		},
		-- Avalanche ascendante (remontée, gratuite) : une petite éruption de neige jaillit sous lui et le propulse vers le haut
		S_up = {
			label = "Avalanche ascendante", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.32,
			damage = 7, hitbox = box(5.5, 7, 0.5, 1.5), kbBase = 30, kbGrowth = 40, kbAngle = 82, selfVelocity = Vector2.new(6, 92),
			windup = { Root = { 0, 0, 0, 0, -0.85, 0 }, Waist = { -16, 0, 0 }, RS = { 20, 0, 40 }, RE = { 30, 0, 0 }, LS = { 20, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.4, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, LS = { 170, 0, -30 }, LE = { 10, 0, 0 }, RH = { 10, 0, 10 }, RK = { -40, 0, 0 }, LH = { 10, 0, -10 }, LK = { -40, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0.4, 0 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 178, 0, 35 }, RE = { 10, 0, 0 }, LS = { 178, 0, -35 }, LE = { 10, 0, 0 }, RH = { 15, 0, 12 }, RK = { -55, 0, 0 }, LH = { 15, 0, -12 }, LK = { -55, 0, 0 } },
			fx = { { "pillar", color = SNOW, height = 13, width = 3 }, { "particles", tex = "smoke", color = SNOW, at = "feet", dir = "all", time = 0.4, speed = 14, rate = 90 } }, text = "WOUUUSH !", hitText = "FLOCON !",
		},
		-- Souffle polaire (S maintenu) : il inspire à fond, bombe le torse, puis souffle un vent glacé qui gèle sur place
		S_hold = {
			label = "Souffle polaire", energyCost = 35, startup = 0.25, active = 0.3, recovery = 0.4,
			damage = 12, hitbox = box(8, 3.5, 4.5, 1), kbBase = 26, kbGrowth = 55, kbAngle = 25,
			status = { name = "frozen", duration = 1 },
			windup = { Root = { 10, 0, 0, 0, -0.1, 0.25 }, Waist = { 20, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 70 }, RE = { 40, 0, 0 }, LS = { 20, 0, -70 }, LE = { 40, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.2 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 40 }, RE = { 30, 0, 0 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.28, -0.3 }, Waist = { -18, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -45, 0, 42 }, RE = { 30, 0, 0 }, LS = { -45, 0, -42 }, LE = { 30, 0, 0 } },
			hold = 0.15, shake = true, fx = { { "beam", color = ICE, length = 9, width = 2.2, at = "head" }, { "particles", tex = "smoke", color = SNOW, at = "head", dir = "front", time = 0.35, speed = 16, rate = 90 } },
			text = "FFFFFFFFHHH !", hitText = "GLAGLA !",
		},
		-- Glissade pingouin (→→S) : il plonge sur le ventre et file sur la glace comme un pingouin, ailerons collés
		S_dash = {
			label = "Glissade pingouin", energyCost = 25, startup = 0.06, active = 0.35, recovery = 0.32,
			damage = 11, hitbox = box(5, 2.5, 2, -1.3), kbBase = 30, kbGrowth = 60, kbAngle = 40, selfVelocity = Vector2.new(74, 0), invuln = 0.15,
			windup = { Root = { -20, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, RS = { -20, 0, 15 }, LS = { -20, 0, -15 } },
			strike = { Root = { -80, 0, 0, 0, -1.5, -0.4 }, Waist = { 8, 0, 0 }, Neck = { 40, 0, 0 }, RS = { -10, 0, 12 }, RE = { 0, 0, 0 }, LS = { -10, 0, -12 }, LE = { 0, 0, 0 }, RH = { -6, 0, 4 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { -6, 0, -4 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { -82, 0, 0, 0, -1.5, -0.45 }, Waist = { 10, 0, 0 }, Neck = { 42, 0, 0 }, RS = { -14, 0, 18 }, RE = { 0, 0, 0 }, LS = { -14, 0, -18 }, LE = { 0, 0, 0 }, RH = { -8, 0, 4 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { -8, 0, -4 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "body", fx = { { "puddle", color = ICE, width = 10, time = 1 } }, text = "PINGOUIIIN !", hitText = "SCHLOUF !",
		},
		-- Granita (ESQUIVE puis S) : il ouvre la glacière, aspire un granita à la paille et frissonne de bonheur
		-- (soigne un peu et remonte beaucoup la Fraîcheur)
		S_dodge = {
			label = "Granita", energyCost = 25, startup = 0.15, active = 0, recovery = 0.55,
			hitbox = box(6, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 9, selfEffect = { heal = 6, meter = 50 },
			windup = { Neck = { 10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 90, 0, 0 }, RW = { -60, 0, 0 }, LS = { 60, 0, 10 }, LE = { 100, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 80, 0, -15 }, RE = { 110, 0, 0 }, RW = { -80, 0, 0 }, LS = { 60, 0, 15 }, LE = { 110, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { -8, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 82, 0, -15 }, RE = { 112, 0, 0 }, RW = { -82, 0, 0 }, LS = { 62, 0, 15 }, LE = { 112, 0, 0 } },
			hold = 0.3, shake = true, fx = { { "symbols", symbols = { "❄️", "💙" }, color = ICE, count = 5, radius = 3 }, { "text", text = "SLUUURP !", color = ICE } }, text = "GLAGLA… QUEL BONHEUR !",
		},
		-- Grêlons (S en l'air) : il secoue la glacière ouverte au-dessus de la zone, une pluie de glaçons tombe devant lui
		S_air = {
			label = "Grêlons", kind = "projectile", energyCost = 25, startup = 0.16, active = 0, recovery = 0.3,
			damage = 3, kbBase = 16, kbGrowth = 25, kbAngle = -30,
			projectile = { speed = 60, gravity = 0, lifetime = 0.9, size = 1.2, color = ICE, visual = ICE_CUBE, rain = { count = 5, spread = 6, ahead = 7, height = 16 } },
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 120, 0, -10 }, RE = { 20, 0, 0 }, RW = { 150, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 130, 0, 10 }, RE = { 20, 0, 0 }, RW = { 150, 0, 0 }, LS = { 60, 0, -62 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			wobble = true, fx = { { "rain", shape = "ball", color = ICE, count = 8, radius = 5, size = 0.4 } }, text = "IL GRÊLE !", hitText = "TOC TOC TOC !",
		},
		-- Pluie de grêlons (↓S en l'air, plongeon) : il tombe assis sur sa glacière, les glaçons pleuvent tout autour
		S_air_down = {
			label = "Pluie de grêlons", energyCost = 25, startup = 0.14, active = 0.4, recovery = 0.34,
			damage = 12, hitbox = box(8, 4, 0, -2), kbBase = 28, kbGrowth = 60, kbAngle = 42, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 6, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 10, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, RH = { 90, 0, 8 }, RK = { -80, 0, 0 }, RA = { 10, 0, 0 }, LH = { 90, 0, -8 }, LK = { -80, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 8, 0, 0 }, Waist = { 2, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 10, 0, 12 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 65, 0, -75 }, LE = { 20, 0, 0 }, RH = { 92, 0, 8 }, RK = { -82, 0, 0 }, RA = { 10, 0, 0 }, LH = { 92, 0, -8 }, LK = { -82, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "body", fx = { { "rain", shape = "ball", color = ICE, count = 12, radius = 6, size = 0.5 }, { "ring", color = SNOW, radius = 6, at = "feet" }, { "shake", amount = 0.4 } }, text = "GRÊLE !", hitText = "KRRRAC !",
		},

		------------------------------------------------------------------ Suites d'enchaînement
		-- J puis K : Coup de genou poilu, il remonte le genou droit dans le ventre de l'adversaire
		PK_combo = {
			label = "Genou poilu", startup = 0.11, active = 0.08, recovery = 0.22,
			damage = 7, hitbox = box(4, 3, 2.3, -0.2), kbBase = 24, kbGrowth = 35, kbAngle = 50,
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 6, -10, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, 0.05, -0.35 }, Waist = { -10, 6, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -14, 10, 0, 0, 0.08, -0.4 }, Waist = { -12, 8, 0 }, RS = { 55, 0, 18 }, RE = { 100, 0, 0 }, LS = { 55, 0, -18 }, LE = { 100, 0, 0 }, RH = { 116, 0, 0 }, RK = { -124, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightLeg", hitText = "OUMPF !",
		},
		-- K puis J : Claque de glacière au sol, il pivote et rabat la glacière de haut en bas
		KP_combo = {
			label = "Rabat de glacière", startup = 0.12, active = 0.08, recovery = 0.24,
			damage = 8, hitbox = box(4.5, 3.5, 2.5, 0.3), kbBase = 26, kbGrowth = 42, kbAngle = 55,
			windup = { Root = { 8, -8, 0, 0, -0.05, 0.2 }, Waist = { 12, -8, 0 }, RS = { 185, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, -0.4, -0.3 }, Waist = { -26, 10, 0 }, RS = { 70, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -30 }, LE = { 50, 0, 0 } },
			follow = { Root = { -14, 10, 0, 0, -0.45, -0.35 }, Waist = { -30, 12, 0 }, RS = { 50, 0, 5 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -15, 0, -32 }, LE = { 50, 0, 0 } },
			trail = "prop", hitText = "BLONG !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Boule à bout portant : il écrase une boule de neige sur le visage de l'adversaire (ralentit)
		S_finish_snow = {
			label = "Boule à bout portant", energyCost = 20, startup = 0.14, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(4.5, 3.5, 2.5, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 35,
			status = { name = "slowed", duration = 2 },
			windup = { Root = { 2, 20, 0, 0, -0.25, 0.2 }, Waist = { 4, 24, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 70, 0, 40 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -16, 0, 0, -0.3, -0.35 }, Waist = { -8, -20, 0 }, RS = { 35, 0, 45 }, RE = { 50, 0, 0 }, LS = { 95, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -10, -20, 0, 0, -0.32, -0.4 }, Waist = { -10, -24, 0 }, RS = { 32, 0, 48 }, RE = { 50, 0, 0 }, LS = { 98, 0, -5 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "bouleNeige", fx = { { "burst", color = SNOW, size = 3 } }, text = "TIENS, AU FRAIS !", hitText = "SPLAF !",
		},
		-- Pic de glace : il frappe le sol de la glacière, un pic de glace jaillit sous l'adversaire et le fait décoller
		S_finish_ice = {
			label = "Pic de glace", energyCost = 25, startup = 0.16, active = 0.14, recovery = 0.34,
			damage = 11, hitbox = box(4, 7, 3.5, 2), kbBase = 32, kbGrowth = 66, kbAngle = 86,
			windup = { Root = { 8, 0, 0, 0, 0, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.6, -0.3 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.65, -0.32 }, Waist = { -32, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 25, 0, -52 }, LE = { 30, 0, 0 } },
			fx = { { "pillar", color = ICE, height = 10, width = 2.2, at = "front" }, { "shake", amount = 0.3 } }, text = "PIC !", hitText = "KRIIIC !",
		},

		------------------------------------------------------------------ Supers
		-- Avalanche : il soulève une boule de neige géante au-dessus de sa tête et la fait dévaler sur l'adversaire
		SUPER = {
			label = "Avalanche !", kind = "projectile", superCost = 100, startup = 0.4, active = 0, recovery = 0.55,
			damage = 24, kbBase = 36, kbGrowth = 60, kbAngle = 45,
			projectile = { speed = 42, angle = 0, gravity = 0, lifetime = 1.6, size = 5, color = SNOW, from = "feet", pierce = true,
				visual = { shape = "ball", size = 5, color = SNOW, spin = 6, parts = {
					{ "ball", Vector3.new(1.5, 1.2, 1.2), Vector3.new(1.6, 1.2, 0), ICE },
					{ "ball", Vector3.new(1.2, 1, 1), Vector3.new(-1.4, -1.5, 0), ICE },
				} } },
			status = { name = "frozen", duration = 1.5 },
			windup = { Root = { 10, 0, 0, 0, -0.5, 0.2 }, Waist = { 20, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 185, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -20 }, LE = { 40, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.6, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 70, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 0, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.65, -0.45 }, Waist = { -34, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 55, 0, 15 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 55, 0, -15 }, LE = { 0, 0, 0 } },
			hold = 0.2, shake = true, windupFx = { "super" }, fx = { { "shake", amount = 0.6 }, { "particles", tex = "smoke", color = SNOW, at = "feet", dir = "all", time = 0.6, speed = 14, rate = 100 } },
			text = "AVALAAANCHE !", hitText = "BRRRRR !",
		},
		-- Super ↑ : il soulève la glacière d'un grand coup : un bloc de glace jaillit vers le ciel
		SUPER_up = {
			label = "Avalanche inversée !", superCost = 100, startup = 0.3, active = 0.25, recovery = 0.55,
			damage = 22, hitbox = box(7, 10, 2, 4), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -10, -20, 0, 0, -0.9, 0.2 }, Waist = { -25, -20, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { 8, 15, 0, 0, 0.5, -0.2 }, Waist = { 18, 20, 0 }, Neck = { 35, 0, 0 }, RS = { 180, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.6, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			follow = { Root = { 12, 20, 0, 0, 0.6, -0.2 }, Waist = { 22, 25, 0 }, Neck = { 40, 0, 0 }, RS = { 190, 0, 15 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.7, 0 }, FL = { 0, 0, 0, 0, 0.5, 0 } },
			hold = 0.25, selfVelocity = Vector2.new(0, 45),
			windupFx = { "super" }, trail = "prop", status = { name = "frozen", duration = 1.2 }, fx = { { "pillar", color = Color3.fromRGB(165, 225, 255), height = 18, width = 4, at = "front" }, { "rain", shape = "ball", color = Color3.fromRGB(248, 252, 255), count = 14, radius = 6 } }, text = "RAFRAÎCHISSANT !", hitText = "GLAGLA !",
		},
		-- Bonhomme de neige : il attrape l'adversaire dans un câlin, le transforme en bonhomme de neige gelé… puis grosse claque
		SUPER_down = {
			label = "Bonhomme de neige !", superCost = 100, startup = 0.3, active = 0.15, recovery = 0.55,
			damage = 20, hitbox = box(4.5, 4.5, 2.2, 0.5), kbBase = 38, kbGrowth = 65, kbAngle = 40,
			status = { name = "frozen", duration = 2 },
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 120, 0, 60 }, RE = { 10, 0, 0 }, LS = { 120, 0, -60 }, LE = { 10, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -14, 0, 0 }, RS = { 82, 0, -22 }, RE = { 80, 0, 0 }, LS = { 82, 0, 22 }, LE = { 80, 0, 0 } },
			follow = { Root = { -10, -20, 0, 0, -0.35, -0.4 }, Waist = { -14, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, LS = { 95, 0, -60 }, LE = { 5, 0, 0 } },
			hold = 0.45, windupFx = { "super" }, fx = { { "burst", color = SNOW, size = 4 }, { "symbols", symbols = { "⛄", "❄️" }, color = ICE, count = 6, radius = 3, at = "front" } },
			text = "UN BEAU BONHOMME DE NEIGE !", hitText = "PAF ! GLAGLA !",
		},

		------------------------------------------------------------------ Chope (bouton ✋) et projections
		-- Câlin glacé : bras immenses grands ouverts, il referme une énorme étreinte de fourrure (portée de choppeur)
		GRAB = {
			label = "Câlin glacé", kind = "grab", startup = 0.12, active = 0.14, recovery = 0.38,
			damage = 0, hitbox = box(5, 4.5, 2.2, 0.5),
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.15 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 100, 0, 80 }, RE = { 10, 0, 0 }, LS = { 100, 0, -80 }, LE = { 10, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.35 }, Waist = { -14, 0, 0 }, RS = { 85, 0, -25 }, RE = { 85, 0, 0 }, LS = { 85, 0, 25 }, LE = { 85, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.2, -0.35 }, Waist = { -10, 0, 0 }, RS = { 88, 0, -30 }, RE = { 92, 0, 0 }, LS = { 88, 0, 30 }, LE = { 92, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = ICE, at = "front", dir = "all", time = 0.2, speed = 5 } }, text = "VIENS FAIRE UN CÂLIN !", hitText = "BRRR !",
		},
		-- ✋ puis → : Glissade sur la banquise, il couche l'adversaire et le fait glisser au loin sur la glace
		THROW_fwd = {
			label = "Glissade sur la banquise", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.32,
			damage = 11, kbBase = 44, kbGrowth = 58, kbAngle = 8,
			carry = { { 0, 2.4, 0.4 }, { 0.16, 1.4, -0.6 }, { 0.34, 4.5, -1.4 } },
			windup = { Root = { 8, 20, 0, 0, -0.35, 0.3 }, Waist = { 12, 20, 0 }, RS = { 70, 0, 10 }, RE = { 70, 0, 0 }, LS = { 70, 0, -10 }, LE = { 70, 0, 0 } },
			strike = { Root = { -24, -10, 0, 0, -0.6, -0.5 }, Waist = { -24, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 0 }, RE = { 5, 0, 0 }, LS = { 70, 0, 0 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -28, -14, 0, 0, -0.65, -0.6 }, Waist = { -26, -12, 0 }, Neck = { 14, 0, 0 }, RS = { 75, 0, -5 }, RE = { 5, 0, 0 }, LS = { 75, 0, 5 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { { "puddle", color = ICE, width = 10 } }, text = "BON VOYAGE !", hitText = "ZIIIOU !",
		},
		-- ✋ puis ← : Bonhomme de neige jeté, il roule l'adversaire en boule de neige et le jette par-dessus son épaule
		THROW_back = {
			label = "Bonhomme de neige jeté", kind = "throw", back = true, startup = 0.44, active = 0.1, recovery = 0.42,
			damage = 13, kbBase = 38, kbGrowth = 72, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.6, 1.2 }, { 0.28, 0.4, 3.4 }, { 0.44, -2.8, 1 } },
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -20, 0, 0 }, RS = { 70, 0, -20 }, RE = { 80, 0, 0 }, LS = { 70, 0, 20 }, LE = { 80, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.2, 0.3 }, Waist = { 30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 200, 0, -10 }, RE = { 20, 0, 0 }, LS = { 200, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 24, 0, 0, 0, -0.2, 0.35 }, Waist = { 34, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 205, 0, -10 }, RE = { 20, 0, 0 }, LS = { 205, 0, 10 }, LE = { 20, 0, 0 } },
			fx = { { "burst", color = SNOW, size = 3 } }, text = "PAR-DESSUS !", hitText = "FLOMP !",
		},
		-- ✋ puis ↑ : Boule de neige, il roule l'adversaire en boule et le lance vers le ciel à deux mains
		THROW_up = {
			label = "Boule de neige", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.36,
			damage = 11, kbBase = 40, kbGrowth = 62, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.16, 1.8, -0.8 }, { 0.34, 0.8, 4.2 } },
			windup = { Root = { -10, 0, 0, 0, -0.85, 0.1 }, Waist = { -20, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 45, 0, -15 }, RE = { 50, 0, 0 }, LS = { 45, 0, 15 }, LE = { 50, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, -0.1 }, Waist = { 15, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.35, -0.1 }, Waist = { 18, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 180, 0, 20 }, RE = { 5, 0, 0 }, LS = { 180, 0, -20 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			fx = { { "particles", tex = "smoke", color = SNOW, at = "front", dir = "up", time = 0.3, speed = 12 } }, text = "HOP, EN BOULE !", hitText = "ZWOUUF !",
		},
		-- ✋ puis ↓ : Assis sur la glacière, il plaque l'adversaire au sol, pose la glacière dessus et s'assoit
		THROW_down = {
			label = "Assis sur la glacière", kind = "throw", startup = 0.42, active = 0.1, hold = 0.3, recovery = 0.38,
			damage = 12, kbBase = 30, kbGrowth = 28, kbAngle = 72,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, 1.8 }, { 0.3, 1.4, -2 }, { 0.42, 0.8, -2.3 } },
			windup = { Root = { 12, 0, 0, 0, 0.1, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 6, 0, 0, 0, -1.3, -0.6 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 40 }, RE = { 30, 0, 0 }, LS = { 30, 0, -40 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 2, 0, 0, 0, -1.25, -0.6 }, Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 10, 0, 50 }, RE = { 60, 0, 0 }, LS = { 10, 0, -50 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			fx = { "dust", { "shake", amount = 0.3 } }, text = "AH, ÇA REPOSE…", hitText = "CRRROUIC !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "esquimau", label = "Esquimau", sequence = { "down", "forward", "back" },
			-- l'adversaire est glacé sur un bâton, rapetissé et rangé dans la glacière
			scene = {
				{ "fxAttacker", { "text", text = "UN PETIT ESQUIMAU ?", color = ICE } },
				{ "fx", { "particles", tex = "smoke", color = ICE, at = "root", dir = "all", time = 0.6, speed = 8 } },
				{ "color", ICE },
				{ "material", "Ice" },
				{ "wait", 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, -3.5, 0), life = 1.6, pieces = {
					{ "Baton", "", "block", Vector3.new(0.5, 2.5, 0.25), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(220, 180, 120), "Wood" },
				} },
				{ "text", "GLA… GLA…" },
				{ "lift", 2, time = 0.4 },
				{ "shrink", 0.3, time = 0.6 },
				{ "spawn", at = "target", offset = Vector3.new(0, -1.5, 0), life = 2.5, pieces = {
					{ "Glaciere", "", "block", Vector3.new(3, 2, 2), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), COOLER, "SmoothPlastic" },
					{ "Couvercle", "", "block", Vector3.new(3.1, 0.35, 2.1), Vector3.new(0, 1.15, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
				} },
				{ "hide" },
				{ "fxAttacker", { "text", text = "AU FRAIS ! MIAM.", color = WHITE } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "coup_de_soleil", label = "Coup de soleil", sequence = { "forward", "forward", "up" },
			-- Bob ouvre le parasol pour lui… l'adversaire, lui, vire au rouge homard et s'enfuit dans la mer
			scene = {
				{ "fx", { "screen", color = Color3.fromRGB(255, 200, 80), alpha = 0.4 } },
				{ "spawn", at = "above", offset = Vector3.new(0, 4, 0), life = 2.5, pieces = {
					{ "Soleil", "", "ball", Vector3.new(3, 3, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), YELLOW, "Neon" },
				} },
				{ "fxAttacker", { "text", text = "T'AS PAS MIS DE CRÈME ?", color = WHITE } },
				{ "wait", 0.6 },
				{ "color", Color3.fromRGB(235, 60, 40) },
				{ "text", "AÏE AÏE AÏE AÏE !" },
				{ "fx", { "symbols", symbols = { "🦞", "🔥", "☀️" }, count = 6 } },
				{ "wait", 0.6 },
				{ "fx", { "puddle", color = Color3.fromRGB(60, 160, 240), width = 10, time = 2 } },
				{ "launch", Vector3.new(70, 12, 0), time = 1.2 },
				{ "text", "À LA MEEEER !" },
				{ "wait", 0.6 },
			},
		},
		{
			id = "bonhomme_de_neige", label = "Bonhomme de neige", sequence = { "back", "down", "down" },
			-- roulé dans la neige : un bonhomme de neige avec une carotte… et un pigeon du Roi Pigeon vient s'y poser
			scene = {
				{ "fx", { "particles", tex = "smoke", color = SNOW, at = "root", dir = "all", time = 0.6, speed = 10, size = 1.2 } },
				{ "wait", 0.4 },
				{ "hide" },
				{ "spawn", at = "target", offset = Vector3.new(0, -2, 0), life = 4, pieces = {
					{ "Bas", "", "ball", Vector3.new(3, 3, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), SNOW, "Sand" },
					{ "Milieu", "", "ball", Vector3.new(2.2, 2.2, 2.2), Vector3.new(0, 2.2, 0), Vector3.new(0, 0, 0), SNOW, "Sand" },
					{ "Tete", "", "ball", Vector3.new(1.6, 1.6, 1.6), Vector3.new(0, 3.9, 0), Vector3.new(0, 0, 0), SNOW, "Sand" },
					{ "Carotte", "", "cyl", Vector3.new(0.9, 0.3, 0.3), Vector3.new(0, 3.9, -1), Vector3.new(0, 0, 0), Color3.fromRGB(255, 130, 30), "SmoothPlastic", { axis = "z" } },
					{ "OeilG", "", "ball", Vector3.new(0.2, 0.2, 0.2), Vector3.new(-0.3, 4.2, -0.75), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
					{ "OeilD", "", "ball", Vector3.new(0.2, 0.2, 0.2), Vector3.new(0.3, 4.2, -0.75), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
				} },
				{ "fxAttacker", { "text", text = "MAGNIFIQUE !", color = WHITE } },
				{ "wait", 1 },
				{ "spawn", at = "target", offset = Vector3.new(0, 3.3, 0), life = 2.5, pieces = {
					{ "Pigeon", "", "ball", Vector3.new(0.9, 0.7, 1.1), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(130, 135, 150), "SmoothPlastic" },
					{ "TetePigeon", "", "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, 0.45, -0.45), Vector3.new(0, 0, 0), Color3.fromRGB(110, 120, 140), "SmoothPlastic" },
					{ "Bec", "", "block", Vector3.new(0.12, 0.1, 0.25), Vector3.new(0, 0.4, -0.75), Vector3.new(0, 0, 0), YELLOW, "SmoothPlastic" },
				} },
				{ "text", "ROUCOU." },
				{ "wait", 1.4 },
			},
		},
	},

	-- Mécanique : Fraîcheur, haute = ses coups au corps à corps gèlent (voir server/Mechanics.lua)
	passive = { kind = "fresh", name = "Fraîcheur", icon = "❄️", color = ICE },

	-- Recharge ⚡ : il se tartine de crème solaire, baisse ses lunettes de soleil, puis aspire à la paille dans la glacière
	charge = {
		label = "Pause bronzette",
		loop = 2,
		lockWrist = true,
		color = ICE,
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
			{ 0.25, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { 14, 10, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 125, 0, 35 }, LE = { 135, 0, 0 } } },
			{ 0.5, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { 10, -10, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 120, 0, 10 }, LE = { 140, 0, 0 } } },
			{ 0.8, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 160, 0, -10 }, LE = { 100, 0, 0 } } },
			{ 1.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { -5, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 130, 0, -10 }, LE = { 120, 0, 0 } } },
			{ 1.3, { Root = { -4, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 80, 0, -15 }, RE = { 110, 0, 0 }, RW = { -80, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } } },
			{ 1.6, { Root = { -4, 0, 0, 0, -0.32, 0 }, Waist = { -18, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 82, 0, -15 }, RE = { 112, 0, 0 }, RW = { -82, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } } },
			{ 2.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
		},
		beats = {
			{ 0.1, { "symbols", symbols = { "🧴", "☀️" }, color = YELLOW, count = 3, radius = 2 } },
			{ 0.85, { "text", text = "😎", color = WHITE } },
			{ 1.35, { "text", text = "SLUUURP…", color = ICE } },
			{ 1.7, { "particles", tex = "smoke", color = ICE, at = "head", dir = "up", time = 0.3, speed = 4 } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- il se gratte le ventre de la paluche gauche, l'air béat
		{ duration = 2, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { 10, 0, 0 }, LS = { 30, 0, 20 }, LE = { 110, 0, 0 } } },
			{ 0.55, { Neck = { 12, 0, 0 }, LS = { 25, 0, 30 }, LE = { 95, 0, 0 } } },
			{ 0.8, { Neck = { 10, 0, 0 }, LS = { 30, 0, 20 }, LE = { 110, 0, 0 } } },
			{ 1.05, { Neck = { 12, 0, 0 }, LS = { 25, 0, 30 }, LE = { 95, 0, 0 } } },
			{ 2, {} },
		} },
		-- il s'évente avec la main en soufflant, il fait trop chaud
		{ duration = 2, keys = {
			{ 0, {} },
			{ 0.3, { Root = { 0, 0, 0, 0, -0.05, 0 }, Neck = { 20, 0, 0 }, LS = { 130, 0, 10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } } },
			{ 0.5, { Neck = { 20, 0, 0 }, LS = { 130, 0, 30 }, LE = { 100, 0, 0 }, LW = { 30, 0, 0 } } },
			{ 0.7, { Neck = { 20, 0, 0 }, LS = { 130, 0, 10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } } },
			{ 0.9, { Neck = { 20, 0, 0 }, LS = { 130, 0, 30 }, LE = { 100, 0, 0 }, LW = { 30, 0, 0 } } },
			{ 2, {} },
		} },
		-- il soulève le couvercle de la glacière pour vérifier qu'il reste des granitas
		{ duration = 1.8, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.35, { Waist = { -14, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 50, 0, -10 }, RE = { 90, 0, 0 }, RW = { -50, 0, 0 }, LS = { 50, 0, 10 }, LE = { 80, 0, 0 } } },
			{ 0.9, { Waist = { -16, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 50, 0, -10 }, RE = { 90, 0, 0 }, RW = { -50, 0, 0 }, LS = { 70, 0, 10 }, LE = { 60, 0, 0 } } },
			{ 1.2, { Neck = { 5, 0, 0 } } },
			{ 1.8, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : énorme câlin, l'adversaire écrasé contre sa fourrure, Bob penché en arrière
data.grabHold = {
	Root = { 8, 0, 0, 0, -0.2, 0.1 },
	Waist = { 12, 0, 0 },
	Neck = { 6, 0, 6 },
	RS = { 88, 0, -30 },
	RE = { 70, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 88, 0, 30 },
	LE = { 70, 0, 0 },
}

-- Retour 🪂 : il descend en télésiège avec sa glacière et son transat, saute, enlève ses lunettes de soleil et
-- grogne de plaisir.
data.respawn = {
	duration = 1.9,
	platform = { pieces = {
		{ "Siege", "base", "block", Vector3.new(5, 0.8, 3), Vector3.new(0, -0.4, 0), Vector3.new(0, 0, 0), Color3.fromRGB(60, 70, 90), "Metal" },
		{ "Dossier", "", "block", Vector3.new(5, 2.4, 0.3), Vector3.new(0, 1, 1.4), Vector3.new(-10, 0, 0), Color3.fromRGB(60, 70, 90), "Metal" },
		{ "Coussin", "", "block", Vector3.new(4.6, 0.2, 2.6), Vector3.new(0, 0.05, 0.1), Vector3.new(0, 0, 0), SHIRT, "Fabric" },
		{ "Barre", "", "cyl", Vector3.new(5.2, 0.2, 0.2), Vector3.new(0, 2.6, -0.6), Vector3.new(0, 0, 0), Color3.fromRGB(180, 180, 190), "Metal", { axis = "x" } },
		{ "Suspente", "", "cyl", Vector3.new(6, 0.25, 0.25), Vector3.new(0, 5, 1.4), Vector3.new(0, 0, 0), Color3.fromRGB(180, 180, 190), "Metal", { axis = "y" } },
		{ "Cable", "", "cyl", Vector3.new(16, 0.15, 0.15), Vector3.new(0, 8, 1.4), Vector3.new(0, 0, 12), BLACK, "Metal", { axis = "x" } },
		{ "Glaciere", "", "block", Vector3.new(1.2, 1.1, 1.6), Vector3.new(-1.8, 0.55, 0.3), Vector3.new(0, 20, 0), COOLER, "SmoothPlastic" },
		{ "Couvercle", "", "block", Vector3.new(1.3, 0.25, 1.7), Vector3.new(-1.8, 1.2, 0.3), Vector3.new(0, 20, 0), WHITE, "SmoothPlastic" },
		{ "Transat", "", "wedge", Vector3.new(1.4, 1.2, 2.6), Vector3.new(1.9, 0.6, 0.4), Vector3.new(0, 180, 0), Color3.fromRGB(255, 150, 50), "Fabric" },
	} },
	keys = {
		{ 0.0, { Root = { -10, 0, 0, 0, -1.1, 0.4 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 }, RH = { 90, 0, 8 }, RK = { -90, 0, 0 }, LH = { 90, 0, -8 }, LK = { -90, 0, 0 } } },
		{ 0.4, { Root = { -8, 0, 0, 0, -1.1, 0.4 }, Waist = { 12, 0, 0 }, Neck = { 20, 10, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 }, RH = { 90, 0, 8 }, RK = { -80, 0, 0 }, LH = { 90, 0, -8 }, LK = { -100, 0, 0 } } },
		{ 0.65, { Root = { 6, 0, 0, 0, 0.5, -0.2 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 } } },
		{ 0.9, { Root = { -10, 0, 0, 0, -0.6, 0 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 40, 0, -40 }, LE = { 40, 0, 0 } } },
		{ 1.15, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { 10, 0, 0 }, LS = { 150, 0, -10 }, LE = { 120, 0, 0 } } },
		{ 1.4, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { 20, 0, 0 }, LS = { 175, 0, -15 }, LE = { 70, 0, 0 } } },
		{ 1.65, { Root = { 8, 0, 0, 0, -0.1, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 30, 0, 60 }, RE = { 60, 0, 0 }, LS = { 30, 0, -60 }, LE = { 60, 0, 0 } } },
		{ 1.9, {} },
	},
	beats = {
		{ 0.05, { "text", text = "♪ TOUT SCHUSS ♪", color = WHITE } },
		{ 0.9, { "burst", color = SNOW, size = 3, at = "feet" } },
		{ 0.92, { "shake", amount = 0.3 } },
		{ 1.65, { "text", text = "GRRRR… QUEL PIED !", color = ICE } },
	},
}

-- Arbre d'enchaînements. En l'air, J et K s'alternent, une flèche choisit la version directionnelle,
-- ↓S retombe sur la glacière et ↑S reste la remontée.
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol : J…
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side", down_P = "P_down", S = "S_finish_snow" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", up_K = "K_upK", S = "S_finish_ice" }, -- J J
	P_combo3 = { K = "K_combo3", S = "S_finish_ice" }, -- J J J
	PK_combo = { P = "KP_combo", K = "K_side", S = "S_finish_ice" }, -- J K
	-- au sol : K…
	K_neutral = { K = "K_combo2", P = "KP_combo", up_K = "K_upK", S = "S_finish_snow" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_ice" }, -- K K
	K_combo3 = { K = "K_air_side", S = "S_air" }, -- K K K (il décolle)
	KP_combo = { P = "P_combo3", K = "K_side2", S = "S_finish_snow" }, -- K J
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side2", S = "S_finish_snow" }, -- → J
	P_side2 = { K = "PK_combo", S = "S_finish_ice" }, -- → J J
	P_down = { P = "P_down2", K = "K_downK", S = "S_finish_ice" }, -- ↓ J
	P_down2 = { P = "P_air_up", K = "K_air_up", S = "S_finish_ice" }, -- ↓ J J (fait décoller)
	P_up = { K = "K_upK", P = "P_down2", S = "S_finish_snow" }, -- ↑ J
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_snow" }, -- → K
	K_side2 = { P = "P_down2", S = "S_finish_ice" }, -- → K K
	K_down = { K = "K_downK", S = "S_finish_snow" }, -- ↓ K (boule roulée)
	K_downK = { K = "K_air_up", S = "S_finish_ice" }, -- ↓ K K
	K_up = { K = "K_upK", S = "S_finish_ice" }, -- ↑ K
	K_upK = { S = "S_finish_snow" }, -- ↑ K K
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_finish_snow" }, -- dash J
	K_dash = { K = "K_side2", P = "KP_combo", S = "S_finish_ice" }, -- dash K
	-- en l'air ; ↓ J et ↓ K (smash vers le sol) sont des finitions sans suite
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

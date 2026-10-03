-- Chef Flambé : grand chef étoilé (enfin, presque), toque d'un mètre et moustache en guidon, qui se bat comme il
-- cuisine : avec panache, beaucoup de beurre et un peu trop de flammes. Arme sortie de la Caisse Bizarre :
-- la poêle (main droite) et le rouleau à pâtisserie (main gauche).
--
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
-- Mécanique « Cuisson » : les coups de feu (burn = true) laissent une brûlure cartoon (dégâts dans la durée).
-- Les ustensiles ponctuels (louche, fouet, couvercle, couteau à oignon, plateau, salière) sont des accessoires
-- cachés qui n'apparaissent que le temps du coup (prop = "…") ; la poêle se cache quand un autre ustensile
-- prend la main droite (hideProp = "poele").

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(240, 196, 160)
local WHITE = Color3.fromRGB(246, 244, 238)
local CREAM = Color3.fromRGB(236, 228, 210)
local BLACK = Color3.fromRGB(30, 26, 24)
local IRON = Color3.fromRGB(45, 45, 50)
local WOOD = Color3.fromRGB(196, 150, 96)
local SAUCE = Color3.fromRGB(190, 40, 30)
local FIRE = Color3.fromRGB(255, 120, 30)
local FLAME = Color3.fromRGB(255, 210, 70)
local CREPE = Color3.fromRGB(235, 190, 110)
local PASTA = Color3.fromRGB(245, 215, 120)
local OIL = Color3.fromRGB(230, 200, 60)
local SILVER = Color3.fromRGB(200, 205, 215)

local data = {
	id = "Chef",
	name = "Chef Flambé",
	costume = "Chef",
	style = "proud",

	look = {
		body = {
			head = SKIN, upper = WHITE, lower = Color3.fromRGB(55, 55, 65), arms = WHITE, forearms = WHITE,
			hands = SKIN, legs = Color3.fromRGB(60, 60, 72), feet = BLACK,
		},
		cubeHead = 1.25,
		parts = {
			-- toque d'un mètre : bandeau, cheminée et champignon de tissu
			{ "ToqueBandeau", "Head", "cyl", Vector3.new(0.6, 1.36, 1.36), Vector3.new(0, 0.9, 0), Vector3.zero, WHITE, "Fabric" },
			{ "ToqueCheminee", "Head", "cyl", Vector3.new(2.4, 1.5, 1.5), Vector3.new(0, 2.3, 0), Vector3.zero, WHITE, "Fabric" },
			{ "ToqueChampignon", "Head", "ball", Vector3.new(2.2, 1.1, 2.2), Vector3.new(0, 3.55, 0), Vector3.zero, WHITE, "Fabric" },
			-- visage : yeux, gros nez, moustache en guidon recourbée
			{ "OeilG", "Head", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(-0.28, 0.2, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(0.28, 0.2, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "Nez", "Head", "ball", Vector3.new(0.36, 0.34, 0.42), Vector3.new(0, -0.02, -0.72), Vector3.zero, Color3.fromRGB(235, 150, 130), "SmoothPlastic" },
			{ "MoustacheG", "Head", "block", Vector3.new(0.62, 0.18, 0.14), Vector3.new(-0.32, -0.24, -0.68), Vector3.new(0, 0, -14), BLACK, "Fabric" },
			{ "MoustacheD", "Head", "block", Vector3.new(0.62, 0.18, 0.14), Vector3.new(0.32, -0.24, -0.68), Vector3.new(0, 0, 14), BLACK, "Fabric" },
			{ "GuidonG", "Head", "ball", Vector3.new(0.22, 0.24, 0.16), Vector3.new(-0.66, -0.1, -0.68), Vector3.zero, BLACK, "Fabric" },
			{ "GuidonD", "Head", "ball", Vector3.new(0.22, 0.24, 0.16), Vector3.new(0.66, -0.1, -0.68), Vector3.zero, BLACK, "Fabric" },
			-- veste croisée de chef et foulard rouge
			{ "Foulard", "UpperTorso", "block", Vector3.new(1.1, 0.32, 0.5), Vector3.new(0, 0.72, -0.35), Vector3.zero, SAUCE, "Fabric" },
			{ "NoeudFoulard", "UpperTorso", "ball", Vector3.new(0.4, 0.4, 0.3), Vector3.new(0.18, 0.5, -0.56), Vector3.zero, SAUCE, "Fabric" },
			{ "BoutonHG", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(-0.36, 0.25, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "BoutonHD", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(0.36, 0.25, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "BoutonBG", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(-0.36, -0.3, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "BoutonBD", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(0.36, -0.3, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			-- tablier taché de sauce et torchon à la ceinture
			{ "Tablier", "LowerTorso", "block", Vector3.new(1.9, 1.9, 0.1), Vector3.new(0, -0.65, -0.52), Vector3.zero, CREAM, "Fabric" },
			{ "TacheSauce", "LowerTorso", "ball", Vector3.new(0.55, 0.38, 0.05), Vector3.new(0.4, -0.35, -0.58), Vector3.new(0, 0, 20), SAUCE, "SmoothPlastic" },
			{ "TacheChocolat", "LowerTorso", "ball", Vector3.new(0.35, 0.3, 0.05), Vector3.new(-0.35, -1.05, -0.58), Vector3.zero, Color3.fromRGB(110, 60, 30), "SmoothPlastic" },
			{ "Torchon", "LowerTorso", "block", Vector3.new(0.12, 1.1, 0.6), Vector3.new(1.02, -0.45, 0), Vector3.zero, Color3.fromRGB(110, 160, 225), "Fabric" },
		},
		props = {
			-- l'arme de la caisse : la poêle en fonte (main droite)…
			{ name = "PropPoele", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.5, 0.24, 0.24), Vector3.new(0, -0.75, 0), Vector3.zero, BLACK, "Metal" },
				{ "Corps", "", "cyl", Vector3.new(0.22, 1.9, 1.9), Vector3.new(0, -2.3, 0), Vector3.zero, IRON, "Metal", { axis = "z", reflect = 0.1 } },
				{ "Rebord", "", "cyl", Vector3.new(0.12, 2.05, 2.05), Vector3.new(0, -2.3, 0.1), Vector3.zero, BLACK, "Metal", { axis = "z" } },
			} },
			-- … et le rouleau à pâtisserie (main gauche)
			{ name = "PropRouleau", hand = "Left", visible = true, pieces = {
				{ "Poignee", "", "cyl", Vector3.new(0.6, 0.2, 0.2), Vector3.new(0, -0.3, 0), Vector3.zero, Color3.fromRGB(160, 110, 60), "Wood" },
				{ "Rouleau", "", "cyl", Vector3.new(2.2, 0.55, 0.55), Vector3.new(0, -1.7, 0), Vector3.zero, WOOD, "Wood" },
				{ "Poignee2", "", "cyl", Vector3.new(0.6, 0.2, 0.2), Vector3.new(0, -3.1, 0), Vector3.zero, Color3.fromRGB(160, 110, 60), "Wood" },
			} },
			-- ustensiles ponctuels
			{ name = "PropLouche", hand = "Right", visible = false, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.8, 0.14, 0.14), Vector3.new(0, -0.9, 0), Vector3.zero, SILVER, "Metal" },
				{ "Cuilleron", "", "ball", Vector3.new(0.8, 0.5, 0.8), Vector3.new(0, -1.9, -0.25), Vector3.zero, SILVER, "Metal", { reflect = 0.2 } },
			} },
			{ name = "PropFouet", hand = "Right", visible = false, pieces = {
				{ "Manche", "", "cyl", Vector3.new(0.8, 0.2, 0.2), Vector3.new(0, -0.4, 0), Vector3.zero, BLACK, "SmoothPlastic" },
				{ "Fils", "", "ball", Vector3.new(0.7, 1.5, 0.7), Vector3.new(0, -1.4, 0), Vector3.zero, SILVER, "Metal", { transparency = 0.35 } },
			} },
			{ name = "PropCouvercle", hand = "Right", visible = false, pieces = {
				{ "Couvercle", "", "cyl", Vector3.new(0.15, 1.9, 1.9), Vector3.new(0, -0.35, 0), Vector3.zero, SILVER, "Metal", { axis = "z", reflect = 0.2 } },
				{ "Bouton", "", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, -0.35, 0.12), Vector3.zero, BLACK, "SmoothPlastic" },
			} },
			{ name = "PropOignon", hand = "Right", visible = false, pieces = {
				{ "Lame", "", "block", Vector3.new(0.06, 1.4, 0.4), Vector3.new(0, -1.0, -0.1), Vector3.zero, SILVER, "Metal", { reflect = 0.3 } },
				{ "Oignon", "", "ball", Vector3.new(0.7, 0.75, 0.7), Vector3.new(0, -1.9, 0), Vector3.zero, Color3.fromRGB(230, 200, 220), "SmoothPlastic" },
				{ "Tige", "", "cyl", Vector3.new(0.4, 0.1, 0.1), Vector3.new(0, -2.35, 0), Vector3.zero, Color3.fromRGB(110, 170, 70), "SmoothPlastic" },
			} },
			{ name = "PropPlateau", hand = "Right", visible = false, pieces = {
				{ "Plateau", "", "cyl", Vector3.new(0.1, 2.2, 2.2), Vector3.new(0, -0.3, -0.6), Vector3.new(90, 0, 0), SILVER, "Metal", { reflect = 0.3 } },
				{ "Cloche", "", "ball", Vector3.new(1.5, 1.0, 1.5), Vector3.new(0, 0.15, -0.6), Vector3.zero, SILVER, "Metal", { reflect = 0.3 } },
			} },
			{ name = "PropSaliere", hand = "Left", visible = false, pieces = {
				{ "Saliere", "", "cyl", Vector3.new(0.6, 0.35, 0.35), Vector3.new(0, -0.35, 0), Vector3.zero, WHITE, "Glass" },
				{ "Bouchon", "", "ball", Vector3.new(0.36, 0.2, 0.36), Vector3.new(0, -0.7, 0), Vector3.zero, SILVER, "Metal" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de louche : la poêle se range, une louche sort et tape sèchement sur le crâne, petit doigt levé
		P_neutral = {
			label = "Coup de louche", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 6, hitbox = box(4, 3, 2.6, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { 6, -10, 0, 0, -0.12, 0.15 }, Waist = { 10, -16, 0 }, Neck = { 8, 10, 0 }, RS = { 150, 0, 25 }, RE = { 70, 0, 0 }, RW = { -20, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.2 }, Waist = { -10, 14, 0 }, Neck = { -4, -6, 0 }, RS = { 95, 0, 5 }, RE = { 10, 0, 0 }, RW = { 10, 0, 0 }, LS = { 5, 0, -42 }, LE = { 88, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.22, -0.25 }, Waist = { -12, 18, 0 }, Neck = { -4, -8, 0 }, RS = { 75, 0, 5 }, RE = { 18, 0, 0 }, RW = { 25, 0, 0 }, LS = { 5, 0, -42 }, LE = { 88, 0, 0 } },
			prop = "louche", hideProp = "poele", trail = "rightHand", hitText = "TOC !",
		},
		-- Poêle frontale : il arme la poêle derrière l'épaule et l'écrase à plat devant lui en avançant d'un pas
		P_side = {
			label = "Poêle frontale", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 9, hitbox = box(5, 3.5, 3, 0.8), kbBase = 24, kbGrowth = 40, kbAngle = 22, selfVelocity = Vector2.new(22, 0),
			windup = { Root = { 8, -30, 0, 0, -0.2, 0.3 }, Waist = { 12, -30, 0 }, Neck = { 6, 22, 0 }, RS = { 120, 0, 70 }, RE = { 80, 0, 0 }, RW = { -30, 0, 0 }, LS = { 60, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -10, 18, 0, 0, -0.35, -0.45 }, Waist = { -12, 22, 0 }, Neck = { -6, -12, 0 }, RS = { 95, 0, -5 }, RE = { 5, 0, 0 }, RW = { -70, 0, 0 }, LS = { -20, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -12, 24, 0, 0, -0.38, -0.5 }, Waist = { -14, 28, 0 }, Neck = { -8, -14, 0 }, RS = { 92, 0, -15 }, RE = { 8, 0, 0 }, RW = { -80, 0, 0 }, LS = { -25, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "prop", fx = { { "ring", color = SILVER, radius = 3, at = "front" } }, hitText = "BLONNNG !",
		},
		-- Coup de tablier : il attrape le bas du tablier et le claque au ras des chevilles comme un torchon
		P_down = {
			label = "Coup de tablier", startup = 0.09, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(5, 2, 2.6, -2), kbBase = 24, kbGrowth = 22, kbAngle = 75,
			windup = { Root = { -10, -25, 0, 0, -0.65, 0.15 }, Waist = { -18, -20, 0 }, Neck = { 10, 15, 0 }, RS = { 40, 0, 30 }, RE = { 50, 0, 0 }, LS = { 20, 0, -55 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, 25, 0, 0, -0.8, -0.15 }, Waist = { -26, 25, 0 }, Neck = { 14, -15, 0 }, RS = { 30, 0, 45 }, RE = { 40, 0, 0 }, LS = { 45, 0, 25 }, LE = { 10, 0, 0 }, LW = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -16, 34, 0, 0, -0.82, -0.2 }, Waist = { -26, 32, 0 }, Neck = { 14, -18, 0 }, RS = { 25, 0, 48 }, RE = { 40, 0, 0 }, LS = { 40, 0, 40 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			trail = "leftHand", fx = { { "particles", tex = "smoke", color = CREAM, dir = "front", at = "feet", time = 0.2, speed = 6, size = 0.5 } }, hitText = "FLAC !",
		},
		-- Couvercle anti-air : il brandit un couvercle au-dessus de la toque comme un bouclier et le relève d'un coup sec
		P_up = {
			label = "Couvercle", startup = 0.08, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 1, 3.8), kbBase = 26, kbGrowth = 32, kbAngle = 86,
			windup = { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.25, 0 }, Waist = { 14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 170, 0, 10 }, RE = { 20, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -45 }, LE = { 70, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.3, 0 }, Waist = { 16, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 178, 0, 8 }, RE = { 15, 0, 0 }, RW = { 90, 0, 0 }, LS = { 15, 0, -48 }, LE = { 75, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			prop = "couvercle", hideProp = "poele", fx = { { "ring", color = SILVER, radius = 3, at = "above" } }, hitText = "DONG !",
		},
		-- Coup de couvercle : en l'air, il plaque le couvercle devant lui comme une cymbale
		P_air = {
			label = "Coup de couvercle", startup = 0.08, active = 0.1, recovery = 0.16,
			damage = 7, hitbox = box(4.5, 4, 2.2, 0), kbBase = 22, kbGrowth = 32, kbAngle = 35,
			windup = { Root = { 8, -15, 0 }, Waist = { 10, -15, 0 }, RS = { 60, 0, 70 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -8, 12, 0 }, Waist = { -10, 16, 0 }, RS = { 95, 0, -10 }, RE = { 10, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -10, 16, 0 }, Waist = { -12, 20, 0 }, RS = { 92, 0, -18 }, RE = { 12, 0, 0 }, RW = { 90, 0, 0 }, LS = { 25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 25, 0, 0 }, RK = { -45, 0, 0 }, LH = { 65, 0, 0 }, LK = { -100, 0, 0 } },
			prop = "couvercle", hideProp = "poele", hitText = "CLANG !",
		},
		-- Coup de fouet : ventre en avant, il fouette l'air en petits moulinets (suite de la louche)
		P_combo2 = {
			label = "Coup de fouet", startup = 0.06, active = 0.12, recovery = 0.16,
			damage = 3, hitbox = box(4, 3, 2.5, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 35, hits = 2,
			windup = { Root = { 4, 14, 0, 0, -0.15, 0.05 }, Waist = { 6, 18, 0 }, RS = { 70, 0, -20 }, RE = { 100, 0, 0 }, RW = { -30, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -8, -14, 0 }, RS = { 90, 0, 20 }, RE = { 40, 0, 0 }, RW = { 40, 0, 0 }, LS = { 8, 0, -42 }, LE = { 88, 0, 0 } },
			follow = { Root = { -6, -14, 0, 0, -0.2, -0.22 }, Waist = { -8, -18, 0 }, RS = { 85, 0, 30 }, RE = { 60, 0, 0 }, RW = { -40, 0, 0 }, LS = { 8, 0, -42 }, LE = { 88, 0, 0 } },
			wobble = true, prop = "fouet", hideProp = "poele", trail = "rightHand", hitText = "TCHIK TCHIK !",
		},
		-- Poêle sur la tête : la poêle revient, levée à deux mains, et s'abat sur le crâne (fin de la série)
		P_combo3 = {
			label = "Poêle sur la tête", startup = 0.13, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 2.5, 1), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 10, -8, 0, 0, 0, 0.25 }, Waist = { 16, -10, 0 }, Neck = { 14, 0, 0 }, RS = { 195, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -15 }, LE = { 70, 0, 0 } },
			strike = { Root = { -14, 8, 0, 0, -0.45, -0.4 }, Waist = { -28, 10, 0 }, Neck = { -10, 0, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 70, 0, -10 }, LE = { 30, 0, 0 } },
			follow = { Root = { -18, 10, 0, 0, -0.55, -0.45 }, Waist = { -34, 12, 0 }, Neck = { -12, 0, 0 }, RS = { 55, 0, 0 }, RE = { 0, 0, 0 }, RW = { -75, 0, 0 }, LS = { 50, 0, -15 }, LE = { 35, 0, 0 } },
			trail = "prop", fx = { { "ring", color = SILVER, radius = 4, at = "front" }, { "shake", amount = 0.3 } }, text = "À TABLE !", hitText = "BOIIING !",
		},
		-- Service en salle (dash puis P) : il fonce poêle tendue devant comme s'il apportait un plat brûlant
		P_dash = {
			label = "Poêle en avant", startup = 0.08, active = 0.15, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 3.5, 2.6, 0.6), kbBase = 28, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -6, -15, 0, 0, -0.25, 0.1 }, Waist = { -4, -10, 0 }, RS = { 40, 0, 25 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			strike = { Root = { -20, 10, 0, 0, -0.38, -0.3 }, Waist = { -8, 10, 0 }, Neck = { 10, 0, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { -85, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } },
			follow = { Root = { -22, 12, 0, 0, -0.4, -0.35 }, Waist = { -10, 12, 0 }, Neck = { 12, 0, 0 }, RS = { 97, 0, -5 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { -35, 0, -42 }, LE = { 40, 0, 0 } },
			trail = "prop", fx = { "dust" }, text = "CHAUD DEVANT !", hitText = "BLANG !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Sabot de cuisine : torse bombé, poings sur les hanches, il monte le genou et détend le sabot en pleine face
		K_neutral = {
			label = "Sabot de cuisine", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, 0.2), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { 10, -10, 0, 0, -0.12, 0.2 }, Waist = { 14, -6, 0 }, Neck = { 10, 0, 0 }, RS = { 15, 0, 45 }, RE = { 95, 0, 0 }, LS = { 15, 0, -45 }, LE = { 95, 0, 0 }, RH = { 90, 0, 0 }, RK = { -115, 0, 0 }, RA = { -10, 0, 0 } },
			strike = { Root = { 18, -4, 0, 0, -0.1, 0.05 }, Waist = { 16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 20, 0, 50 }, RE = { 90, 0, 0 }, LS = { 20, 0, -50 }, LE = { 90, 0, 0 }, RH = { 98, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 20, -2, 0, 0, -0.1, 0.1 }, Waist = { 18, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 22, 0, 52 }, RE = { 88, 0, 0 }, LS = { 22, 0, -52 }, LE = { 88, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 } },
			trail = "rightFoot", text = "OUSTE !", hitText = "CLOC !",
		},
		-- Rouleau à pâtisserie : grand revers du rouleau tenu à gauche, il pivote et avance d'un pas chassé
		K_side = {
			label = "Rouleau à pâtisserie", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 13, hitbox = box(5.5, 3.5, 3.2, 0.8), kbBase = 32, kbGrowth = 82, kbAngle = 28, selfVelocity = Vector2.new(32, 0),
			windup = { Root = { 6, 35, 0, 0, -0.25, 0.25 }, Waist = { 8, 30, 0 }, Neck = { 4, -30, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, LS = { 90, 0, -100 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, -25, 0, 0, -0.38, -0.45 }, Waist = { -14, -30, 0 }, Neck = { -6, 20, 0 }, RS = { 10, 0, 45 }, RE = { 60, 0, 0 }, LS = { 92, 0, 15 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, -38, 0, 0, -0.4, -0.5 }, Waist = { -16, -42, 0 }, Neck = { -8, 26, 0 }, RS = { 5, 0, 50 }, RE = { 60, 0, 0 }, LS = { 85, 0, 40 }, LE = { 10, 0, 0 }, LW = { -15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "leftHand", fx = { "dust" }, hitText = "BAOUM !",
		},
		-- Balayage au rouleau : accroupi, il fait rouler le rouleau au ras du carrelage en tournant sur lui-même
		K_down = {
			label = "Balayage au rouleau", startup = 0.17, active = 0.16, recovery = 0.32,
			damage = 11, hitbox = box(8, 2, 0.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 72,
			windup = { Root = { -8, 25, 0, 0, -0.95, 0 }, Waist = { -20, 20, 0 }, Neck = { 10, -20, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -80 }, LE = { 20, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -1.2, 0 }, Waist = { -24, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 65 }, RE = { 20, 0, 0 }, LS = { 30, 0, -85 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -1.15, 0 }, Waist = { -22, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 25, 0, 62 }, RE = { 20, 0, 0 }, LS = { 35, 0, -82 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "leftHand", fx = { "dust" }, hitText = "ROULÉ !",
		},
		-- Retourné de crêpe : il glisse la poêle sous l'adversaire, ploie les genoux et le fait sauter comme une crêpe
		K_up = {
			label = "Retourné de crêpe", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 5, 2, 2.5), kbBase = 34, kbGrowth = 72, kbAngle = 88,
			windup = { Root = { -12, -10, 0, 0, -0.85, 0 }, Waist = { -26, -10, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 20 }, RE = { 20, 0, 0 }, RW = { -80, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 5, 0, 0, 0.35, -0.1 }, Waist = { 16, 5, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 15 }, RE = { 10, 0, 0 }, RW = { -90, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 8, 8, 0, 0, 0.4, -0.12 }, Waist = { 20, 8, 0 }, Neck = { 36, 0, 0 }, RS = { 172, 0, 10 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 25, 0, -65 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			trail = "prop", text = "HOP LA CRÊPE !", hitText = "FLIP !",
		},
		-- Coup de toque : en l'air, il rentre le menton et fonce toque en avant comme un bélier
		K_air = {
			label = "Coup de toque", startup = 0.16, active = 0.14, recovery = 0.26,
			damage = 11, hitbox = box(4.5, 4, 2.5, 1.2), kbBase = 30, kbGrowth = 68, kbAngle = 38,
			windup = { Root = { 15, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -30, 0, 40 }, RE = { 40, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -30, 0, 0 }, Waist = { -25, 0, 0 }, Neck = { -30, 0, 0 }, RS = { -50, 0, 30 }, RE = { 10, 0, 0 }, LS = { -50, 0, -30 }, LE = { 10, 0, 0 }, RH = { -10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 0, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -34, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -34, 0, 0 }, RS = { -55, 0, 32 }, RE = { 10, 0, 0 }, LS = { -55, 0, -32 }, LE = { 10, 0, 0 }, RH = { -15, 0, 0 }, RK = { -35, 0, 0 }, LH = { -5, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "head", hitText = "TOQUÉ !",
		},
		-- Revers de rouleau : le rouleau revient dans l'autre sens, en coup droit (suite de K)
		K_combo2 = {
			label = "Revers de rouleau", startup = 0.14, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 3, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 4, -30, 0, 0, -0.2, 0.1 }, Waist = { 6, -30, 0 }, Neck = { 0, 25, 0 }, RS = { 20, 0, 40 }, RE = { 80, 0, 0 }, LS = { 95, 0, 30 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, 25, 0, 0, -0.3, -0.3 }, Waist = { -10, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 25, 0, 40 }, RE = { 80, 0, 0 }, LS = { 92, 0, -60 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -10, 32, 0, 0, -0.32, -0.35 }, Waist = { -12, 38, 0 }, Neck = { 0, -24, 0 }, RS = { 25, 0, 42 }, RE = { 80, 0, 0 }, LS = { 85, 0, -85 }, LE = { 10, 0, 0 }, LW = { -15, 0, 0 } },
			trail = "leftHand", hitText = "VLAM !",
		},
		-- Sabot sauté : petit bond de commis, le sabot droit part en avant, bras écartés pour la frime
		K_combo3 = {
			label = "Sabot sauté", startup = 0.16, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 4, 3, 1), kbBase = 32, kbGrowth = 80, kbAngle = 40, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -12, 0, 0 }, RS = { -30, 0, 35 }, RE = { 40, 0, 0 }, LS = { -30, 0, -35 }, LE = { 40, 0, 0 } },
			strike = { Root = { 16, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 80, 0, 80 }, RE = { 10, 0, 0 }, LS = { 80, 0, -80 }, LE = { 10, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 85, 0, 85 }, RE = { 10, 0, 0 }, LS = { 85, 0, -85 }, LE = { 10, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 }, LH = { 25, 0, 0 }, LK = { -115, 0, 0 } },
			trail = "rightFoot", text = "VOILÀÀÀ !", hitText = "BAM !",
		},
		-- Glissade de commis (dash puis K) : il glisse sur le carrelage gras, sabots en avant
		K_dash = {
			label = "Glissade de commis", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.5, 3, -1.5), kbBase = 30, kbGrowth = 62, kbAngle = 50, selfVelocity = Vector2.new(52, 0),
			windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, RS = { 40, 0, 35 }, LS = { 40, 0, -35 } },
			strike = { Root = { 40, 0, 0, 0, -1.5, 0 }, Waist = { -20, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 55 }, RE = { 10, 0, 0 }, LS = { 120, 0, -55 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 70, 0, 0 }, LK = { -25, 0, 0 } },
			follow = { Root = { 45, 0, 0, 0, -1.55, 0 }, Waist = { -22, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 130, 0, 60 }, RE = { 15, 0, 0 }, LS = { 130, 0, -60 }, LE = { 15, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 }, LH = { 74, 0, 0 }, LK = { -20, 0, 0 } },
			trail = "bothFeet", fx = { { "puddle", color = OIL, width = 6 } }, hitText = "SCHLIIIP !",
		},
		-- P puis K : Coup de sabot dans le tibia, sec et vexant
		PK_combo = {
			label = "Sabot dans le tibia", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 2, 3, -1.5), kbBase = 22, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { 6, -10, 0, 0, -0.18, 0.15 }, Waist = { 8, -10, 0 }, Neck = { 6, 10, 0 }, RS = { 20, 0, 40 }, RE = { 90, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 }, RH = { -20, 0, 6 }, RK = { -70, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.28, -0.2 }, Waist = { -6, 8, 0 }, Neck = { 0, -6, 0 }, RS = { 25, 0, 45 }, RE = { 85, 0, 0 }, LS = { 15, 0, -45 }, LE = { 85, 0, 0 }, RH = { 60, 0, 4 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.3, -0.25 }, Waist = { -8, 10, 0 }, Neck = { 0, -8, 0 }, RS = { 25, 0, 45 }, RE = { 85, 0, 0 }, LS = { 15, 0, -45 }, LE = { 85, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { -22, 0, 0 } },
			trail = "rightFoot", hitText = "TAC !",
		},
		-- K puis P : Coup de manche, il retourne la poêle et enfonce le manche dans l'estomac
		KP_combo = {
			label = "Coup de manche", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4, 3, 2.2, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, -20, 0, 0, -0.18, 0.15 }, Waist = { 4, -24, 0 }, RS = { 30, 0, 50 }, RE = { 120, 0, 0 }, RW = { 80, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -8, 18, 0, 0, -0.28, -0.35 }, Waist = { -12, 24, 0 }, RS = { 85, 0, -5 }, RE = { 30, 0, 0 }, RW = { 100, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 } },
			follow = { Root = { -10, 22, 0, 0, -0.3, -0.4 }, Waist = { -14, 28, 0 }, RS = { 88, 0, -10 }, RE = { 25, 0, 0 }, RW = { 100, 0, 0 }, LS = { 18, 0, -42 }, LE = { 90, 0, 0 } },
			hitText = "OUF !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Crêpe retournée, la poêle part de sous la ceinture et remonte devant lui d'un coup de poignet
		P_air_side = {
			label = "Crêpe retournée", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(5, 3.5, 3, 0.5), kbBase = 22, kbGrowth = 40, kbAngle = 50,
			windup = { Root = { -8, 10, 0 }, Waist = { -10, 12, 0 }, RS = { -20, 0, 25 }, RE = { 20, 0, 0 }, RW = { -80, 0, 0 }, LS = { 40, 0, -50 }, LE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 8, -8, 0 }, Waist = { 10, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, 10 }, RE = { 10, 0, 0 }, RW = { -90, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 12, -12, 0 }, Waist = { 14, -14, 0 }, Neck = { 14, 0, 0 }, RS = { 135, 0, 10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 25, 0, -62 }, LE = { 40, 0, 0 }, RH = { 15, 0, 0 }, RK = { -45, 0, 0 }, LH = { 65, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", hitText = "FLOP !",
		},
		-- ↑ P en l'air : Poêle au plafond, recroquevillé, il balaie l'air au-dessus de sa toque
		P_air_up = {
			label = "Poêle au plafond", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.8), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -50 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 185, 0, -20 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { -20, 0, -55 }, LE = { 20, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", hitText = "DZING !",
		},
		-- ↓ P en l'air : Sabot plongeant, il pointe le talon vers le sol et tombe dessus de tout son poids (smash vers le sol)
		P_air_down = {
			label = "Sabot plongeant", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 0.8, -2.2), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(0, -45),
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 30, 0, 0 }, LS = { 120, 0, -50 }, LE = { 30, 0, 0 }, RH = { 110, 0, 0 }, RK = { -130, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 45 }, RE = { 10, 0, 0 }, LS = { 160, 0, -45 }, LE = { 10, 0, 0 }, RH = { -2, 0, 4 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 6, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 165, 0, 50 }, RE = { 10, 0, 0 }, LS = { 165, 0, -50 }, LE = { 10, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 45, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "rightFoot", text = "PLONGEON !", hitText = "CLOMP !",
		},
		-- → K en l'air : Rouleau volant, le rouleau balaie l'horizon de gauche à droite, jambes repliées
		K_air_side = {
			label = "Rouleau volant", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5.5, 3.5, 3.2, 0.5), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { -6, 30, 0 }, Waist = { -8, 30, 0 }, Neck = { 0, -25, 0 }, RS = { 40, 0, 40 }, RE = { 70, 0, 0 }, LS = { 90, 0, -100 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 6, -25, 0 }, Waist = { -6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 20, 0, 50 }, RE = { 60, 0, 0 }, LS = { 92, 0, 20 }, LE = { 5, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 70, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 8, -35, 0 }, Waist = { -6, -40, 0 }, Neck = { 0, 26, 0 }, RS = { 15, 0, 55 }, RE = { 60, 0, 0 }, LS = { 85, 0, 45 }, LE = { 10, 0, 0 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 75, 0, 0 }, LK = { -90, 0, 0 } },
			trail = "leftHand", hitText = "VLOUF !",
		},
		-- ↑ K en l'air : Ciseau de commis, salto arrière, les sabots passent au-dessus de la toque
		K_air_up = {
			label = "Ciseau de commis", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 55 }, RE = { 40, 0, 0 }, LS = { 40, 0, -55 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "CLAC-CLAC !",
		},
		-- ↓ K en l'air : Rouleau-pilon, rouleau levé à deux mains au-dessus de la toque puis abattu (smash vers le sol)
		K_air_down = {
			label = "Rouleau-pilon", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(4.5, 4, 1.2, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80,
			windup = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 10 }, RE = { 40, 0, 0 }, LS = { 190, 0, -10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 10 }, RE = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -26, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 45, 0, 10 }, RE = { 0, 0, 0 }, LS = { 45, 0, -10 }, LE = { 5, 0, 0 }, LW = { -15, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "leftHand", text = "AU PILON !", hitText = "PAF-POUF !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Crêpe volante : il fait sauter une crêpe d'un coup de poignet, elle plane en zigzag vers l'adversaire
		S_neutral = {
			label = "Crêpe volante", energyCost = 20, kind = "projectile", startup = 0.14, active = 0, recovery = 0.3,
			damage = 8, kbBase = 20, kbGrowth = 45, kbAngle = 35,
			projectile = { speed = 42, angle = 8, gravity = 10, lifetime = 1.3, size = 2, color = CREPE, homing = 0.25,
				visual = { shape = "disc", size = 2, color = CREPE, spin = 14, parts = { { "block", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0.2, 0, 0), Color3.fromRGB(255, 235, 120) } } } },
			windup = { Root = { 4, -15, 0, 0, -0.3, 0.1 }, Waist = { 6, -18, 0 }, Neck = { 12, 10, 0 }, RS = { 35, 0, 20 }, RE = { 60, 0, 0 }, RW = { -80, 0, 0 }, LS = { 5, 0, -40 }, LE = { 90, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.15, -0.15 }, Waist = { 8, 12, 0 }, Neck = { 22, -6, 0 }, RS = { 100, 0, 5 }, RE = { 10, 0, 0 }, RW = { -95, 0, 0 }, LS = { 5, 0, -42 }, LE = { 90, 0, 0 } },
			follow = { Root = { -4, 12, 0, 0, -0.12, -0.18 }, Waist = { 10, 14, 0 }, Neck = { 26, -8, 0 }, RS = { 115, 0, 5 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 5, 0, -42 }, LE = { 90, 0, 0 } },
			text = "HOP !", hitText = "SPLAF !",
		},
		-- Flambage : il prend une grande inspiration, torse bombé, et crache un jet de flammes court mais très large
		S_side = {
			label = "Flambage", energyCost = 30, startup = 0.18, active = 0.24, recovery = 0.35,
			damage = 5, hits = 2, burn = true, hitbox = box(7, 5, 4, 0.8), kbBase = 26, kbGrowth = 55, kbAngle = 30,
			windup = { Root = { 10, 0, 0, 0, -0.1, 0.25 }, Waist = { 18, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 30, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.2 }, Waist = { -14, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 60, 0, 85 }, RE = { 10, 0, 0 }, LS = { 60, 0, -85 }, LE = { 10, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.28, -0.25 }, Waist = { -16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 90 }, RE = { 10, 0, 0 }, LS = { 70, 0, -90 }, LE = { 10, 0, 0 } },
			shake = true, windupFx = { { "particles", tex = "smoke", color = Color3.fromRGB(90, 90, 90), dir = "up", at = "head", time = 0.2, speed = 4 } },
			fx = { "fire", { "beam", color = FIRE, length = 7, width = 3.4, at = "head" }, { "particles", tex = "fire", color = FLAME, dir = "front", at = "head", time = 0.3, speed = 22, size = 1.4, rate = 90 } },
			text = "FLAMBÉÉÉ !", hitText = "CRAMÉ !",
		},
		-- Oignon émincé : il émince un oignon à toute vitesse sous le nez de l'adversaire, qui fond en larmes
		S_down = {
			label = "Oignon émincé", energyCost = 25, startup = 0.16, active = 0.25, recovery = 0.3,
			damage = 8, hitbox = box(8, 4, 1.5, 0.5), kbBase = 14, kbGrowth = 20, kbAngle = 40,
			status = { name = "blinded", duration = 1.5 },
			windup = { Root = { 4, -10, 0, 0, -0.3, 0 }, Waist = { -10, -10, 0 }, Neck = { -15, 0, 0 }, RS = { 120, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.35, -0.1 }, Waist = { -18, 10, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 5 }, RE = { 60, 0, 0 }, RW = { 20, 0, 0 }, LS = { 60, 0, 22 }, LE = { 85, 0, 0 } },
			follow = { Root = { -4, 10, 0, 0, -0.35, -0.1 }, Waist = { -18, 10, 0 }, Neck = { -20, 0, 0 }, RS = { 110, 0, 5 }, RE = { 90, 0, 0 }, RW = { -10, 0, 0 }, LS = { 60, 0, 22 }, LE = { 85, 0, 0 } },
			wobble = true, prop = "oignon", hideProp = "poele",
			fx = { { "symbols", symbols = { "💧", "😭", "💧" }, color = Color3.fromRGB(120, 180, 255), count = 7, radius = 3, at = "front" }, { "toss", shape = "flat", color = Color3.fromRGB(235, 215, 230), size = 0.4, count = 5, speed = 10 } },
			text = "TCHAC TCHAC TCHAC !", hitText = "SNIF !",
		},
		-- Sauté à la poêle : il frappe l'air sous ses pieds avec la poêle géante et rebondit dessus, toque au vent
		-- (gratuit : c'est la remontée)
		S_up = {
			label = "Sauté à la poêle", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 7, hitbox = box(5, 6, 0.5, 2.5), kbBase = 30, kbGrowth = 40, kbAngle = 85, selfVelocity = Vector2.new(8, 88),
			windup = { Root = { 0, 0, 0, 0, -0.7, 0 }, Waist = { -10, 0, 0 }, RS = { 160, 0, 30 }, RE = { 30, 0, 0 }, RW = { -60, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.3, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -20, 0, 30 }, RE = { 0, 0, 0 }, RW = { -80, 0, 0 }, LS = { 170, 0, -20 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 }, LH = { 50, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.35, 0 }, Waist = { 14, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 40, 0, 40 }, RE = { 30, 0, 0 }, RW = { -40, 0, 0 }, LS = { 178, 0, -12 }, LE = { 5, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { -10, 0, 0 }, LK = { -30, 0, 0 } },
			trail = "prop", fx = { { "ring", color = SILVER, radius = 4, at = "feet" }, { "burst", color = Color3.fromRGB(255, 240, 200), size = 3, at = "feet" } }, text = "SAUTÉ !", hitText = "BOING !",
		},
		-- Pluie de spaghettis (en l'air + ↓ + S) : poêle pleine au-dessus de la tête, il tombe comme une enclume
		-- et les spaghettis ligotent ceux qui sont dessous
		S_air_down = {
			label = "Pluie de spaghettis", energyCost = 25, startup = 0.12, active = 0.35, recovery = 0.35,
			damage = 11, hitbox = box(6, 4, 0.5, -2), kbBase = 18, kbGrowth = 35, kbAngle = -40, selfVelocity = Vector2.new(0, -80),
			status = { name = "rooted", duration = 1.2 },
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 175, 0, 10 }, RE = { 40, 0, 0 }, RW = { -90, 0, 0 }, LS = { 175, 0, -10 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 170, 0, 15 }, RE = { 30, 0, 0 }, RW = { -90, 0, 0 }, LS = { 170, 0, -15 }, LE = { 30, 0, 0 }, RH = { 0, 0, 5 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { 0, 0, -5 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 60 }, RE = { 20, 0, 0 }, RW = { -40, 0, 0 }, LS = { 120, 0, -60 }, LE = { 20, 0, 0 }, RH = { 2, 0, 8 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { 2, 0, -8 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "body", fx = { { "rain", shape = "cyl", color = PASTA, count = 16, radius = 4, size = 1.2 }, { "shake", amount = 0.4 } }, text = "AL DENTE !", hitText = "LIGOTÉ !",
		},
		-- Sol huilé (esquive puis S) : il vide un filet d'huile d'olive sur le carrelage, la flaque fait glisser
		S_dodge = {
			label = "Sol huilé", energyCost = 20, kind = "trap", startup = 0.12, active = 0, recovery = 0.3,
			damage = 3, kbBase = 12, kbGrowth = 10, kbAngle = 70,
			status = { name = "slippery", duration = 2.5 },
			trap = { size = Vector3.new(5, 1, 6), offset = 2.5, lifetime = 8, max = 1, color = OIL,
				visual = { shape = "ball", size = 0.6, color = OIL, transparency = 0.25, trail = false,
					parts = { { "block", Vector3.new(4.5, 0.12, 3), Vector3.new(0, -0.25, 0), OIL }, { "ball", Vector3.new(0.9, 0.12, 0.9), Vector3.new(2.6, -0.25, 0.4), OIL } } } },
			windup = { Root = { 6, -10, 0, 0, -0.15, 0.1 }, Waist = { 10, -10, 0 }, Neck = { 14, 0, 0 }, RS = { 110, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -4, 6, 0, 0, -0.2, -0.05 }, Waist = { -6, 6, 0 }, Neck = { -10, 0, 0 }, RS = { 95, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 80 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			follow = { Root = { -4, 6, 0, 0, -0.2, -0.05 }, Waist = { -6, 6, 0 }, Neck = { -10, 0, 0 }, RS = { 92, 0, 25 }, RE = { 20, 0, 0 }, RW = { 0, 0, 95 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			hold = 0.15, fx = { { "puddle", color = OIL, width = 6, time = 1.5 } }, text = "UN FILET D'HUILE…", hitText = "OUPS !",
		},
		-- Mijotage (S maintenu) : la poêle rougit sur un feu imaginaire, puis il l'abat brûlante (le coup brûle)
		S_hold = {
			label = "Mijotage", energyCost = 35, startup = 0.2, active = 0.15, recovery = 0.4,
			damage = 14, burn = true, hitbox = box(6, 4.5, 3, 0.8), kbBase = 32, kbGrowth = 82, kbAngle = 38,
			windup = { Root = { 8, -15, 0, 0, -0.3, 0.25 }, Waist = { 14, -18, 0 }, Neck = { 10, 15, 0 }, RS = { 185, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -50 }, LE = { 40, 0, 0 } },
			strike = { Root = { -16, 12, 0, 0, -0.5, -0.45 }, Waist = { -30, 14, 0 }, Neck = { -10, -6, 0 }, RS = { 75, 0, 0 }, RE = { 0, 0, 0 }, RW = { -70, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 } },
			follow = { Root = { -18, 14, 0, 0, -0.55, -0.5 }, Waist = { -34, 16, 0 }, Neck = { -12, -8, 0 }, RS = { 55, 0, 0 }, RE = { 0, 0, 0 }, RW = { -80, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 } },
			shake = true, trail = "prop",
			windupFx = { { "particles", tex = "fire", color = FIRE, dir = "up", at = "hand", time = 0.25, speed = 6, size = 0.9 } },
			fx = { { "burst", color = FIRE, size = 3.5, at = "front" }, { "particles", tex = "fire", color = FLAME, dir = "all", at = "front", time = 0.25, speed = 10, size = 1 } },
			text = "ÇA MIJOTE !", hitText = "TSSSS !",
		},
		-- Service rapide (→→S) : plateau d'argent levé comme un serveur pressé, il fonce et sert le plateau au visage
		S_dash = {
			label = "Service rapide", energyCost = 25, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 10, hitbox = box(5, 4, 2.5, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(60, 0), invuln = 0.15,
			windup = { Root = { -6, 0, 0, 0, -0.2, 0 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 25 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -30 }, LE = { 100, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, -0.3, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 100, 0, 5 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -35 }, LE = { 90, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.3, -0.25 }, Waist = { -6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 98, 0, 0 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { -35, 0, -38 }, LE = { 90, 0, 0 } },
			prop = "plateau", hideProp = "poele", fx = { "dust" }, text = "SERVICE !", hitText = "BON APPÉTIT !",
		},
		-- Assiette de spaghettis (S en l'air) : il lance une assiette au ciel, les spaghettis retombent devant lui et ligotent
		S_air = {
			label = "Assiette de spaghettis", energyCost = 25, kind = "projectile", startup = 0.14, active = 0, recovery = 0.3,
			damage = 3, kbBase = 12, kbGrowth = 20, kbAngle = 60,
			status = { name = "rooted", duration = 1 },
			projectile = { speed = 35, gravity = 30, lifetime = 0.9, size = 1.6, color = PASTA, rain = { count = 5, spread = 6, ahead = 8, height = 16 },
				visual = { shape = "ball", size = 1.2, color = PASTA, parts = { { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.25, 0.35, 0), SAUCE } } } },
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 40, 0, 20 }, RE = { 80, 0, 0 }, RW = { -80, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { -90, 0, 0 }, LS = { 20, 0, -60 }, LE = { 40, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 15, 0, -62 }, LE = { 40, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			text = "MAMMA MIA !", hitText = "SLURP !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Flambé minute : il balaie l'air de la poêle en feu en demi-cercle (brûle)
		S_finish_flambe = {
			label = "Flambé minute", energyCost = 25, startup = 0.14, active = 0.2, recovery = 0.32,
			damage = 10, burn = true, hitbox = box(7, 4, 3, 0.8), kbBase = 30, kbGrowth = 62, kbAngle = 35,
			windup = { Root = { 4, -35, 0, 0, -0.3, 0.2 }, Waist = { 6, -35, 0 }, Neck = { 0, 30, 0 }, RS = { 70, 0, 90 }, RE = { 30, 0, 0 }, RW = { -80, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -8, 20, 0, 0, -0.35, -0.3 }, Waist = { -10, 25, 0 }, Neck = { 0, -15, 0 }, RS = { 95, 0, 0 }, RE = { 5, 0, 0 }, RW = { -85, 0, 0 }, LS = { -10, 0, -45 }, LE = { 50, 0, 0 } },
			follow = { Root = { -10, 35, 0, 0, -0.35, -0.35 }, Waist = { -12, 40, 0 }, Neck = { 0, -25, 0 }, RS = { 90, 0, -40 }, RE = { 10, 0, 0 }, RW = { -85, 0, 0 }, LS = { -15, 0, -48 }, LE = { 50, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "fire", color = FIRE, dir = "up", at = "hand", time = 0.3, speed = 9, size = 1.1, rate = 90 } }, text = "FLAMBÉ MINUTE !", hitText = "GRILLÉ !",
		},
		-- Trois crêpes : trois crêpes partent en éventail d'un seul coup de poêle
		S_finish_crepes = {
			label = "Trois crêpes", kind = "projectile", energyCost = 20, startup = 0.12, active = 0, recovery = 0.3,
			damage = 5, kbBase = 22, kbGrowth = 45, kbAngle = 35,
			projectile = { speed = 55, gravity = 20, lifetime = 0.7, size = 1.8, color = CREPE, fan = { count = 3, from = -5, to = 25 },
				visual = { shape = "disc", size = 1.8, color = CREPE, spin = 16 } },
			windup = { Root = { 4, -12, 0, 0, -0.3, 0.1 }, Waist = { 6, -14, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { -80, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.15 }, Waist = { -6, 12, 0 }, Neck = { 12, 0, 0 }, RS = { 105, 0, 0 }, RE = { 5, 0, 0 }, RW = { -95, 0, 0 }, LS = { 10, 0, -42 }, LE = { 85, 0, 0 } },
			follow = { Root = { -6, 12, 0, 0, -0.2, -0.18 }, Waist = { -6, 14, 0 }, Neck = { 14, 0, 0 }, RS = { 118, 0, 0 }, RE = { 5, 0, 0 }, RW = { -60, 0, 0 }, LS = { 10, 0, -42 }, LE = { 85, 0, 0 } },
			text = "ET TROIS CRÊPES !", hitText = "FLAP !",
		},

		------------------------------------------------------------------ Supers
		-- Flambée Impériale : il lève la poêle au ciel et une colonne de feu géante jaillit devant lui (brûle)
		SUPER = {
			label = "Flambée Impériale !", superCost = 100, startup = 0.35, active = 0.45, recovery = 0.5,
			damage = 8, hits = 3, burn = true, hitbox = box(8, 22, 4, 9), kbBase = 30, kbGrowth = 60, kbAngle = 82,
			windup = { Root = { 6, 0, 0, 0, -0.6, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 90, 0, 0 }, LS = { 60, 0, -60 }, LE = { 90, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.2, 0 }, Waist = { 22, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -60 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.25, 0 }, Waist = { 25, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -70 }, LE = { 10, 0, 0 } },
			hold = 0.3, windupFx = { "super" },
			fx = { { "pillar", color = FIRE, height = 24, width = 5, at = "front" }, { "particles", tex = "fire", color = FLAME, dir = "up", at = "front", time = 0.7, speed = 30, size = 2.2, rate = 120 }, { "screen", color = FIRE, alpha = 0.3 }, { "shake", amount = 0.7 } },
			text = "FLAMBÉE IMPÉRIALE !", hitText = "BIEN CUIT !",
		},
		-- Menu Dégustation : plateau en main, il sert sept plats d'affilée au visage de l'adversaire
		SUPER_down = {
			label = "Menu Dégustation !", superCost = 100, startup = 0.3, active = 0.7, recovery = 0.5,
			damage = 3, hits = 7, hitbox = box(5, 4.5, 2.6, 0.8), kbBase = 12, kbGrowth = 25, kbAngle = 35,
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 150, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 95, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.25, -0.3 }, Waist = { -10, 14, 0 }, Neck = { 10, 0, 0 }, RS = { 95, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { -8, -10, 0, 0, -0.25, -0.3 }, Waist = { -10, -14, 0 }, Neck = { 10, 0, 0 }, RS = { 95, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -20 }, LE = { 20, 0, 0 } },
			wobble = true, prop = "plateau", hideProp = "poele", windupFx = { "super" },
			fx = { { "toss", shape = "flat", color = WHITE, size = 1.2, count = 7, speed = 18 }, { "symbols", symbols = { "🍝", "🥖", "🧀", "🍰", "🥩", "🍲", "🥐" }, count = 7, radius = 3, at = "front" } },
			text = "MENU DÉGUSTATION !", hitText = "MIAM !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise du chef : il attrape l'adversaire comme un poulet à farcir et le sale copieusement
		GRAB = {
			label = "Prise du chef", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 110, 0, 50 }, RE = { 20, 0, 0 }, LS = { 110, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -12, 0, 0 }, RS = { 85, 0, -15 }, RE = { 60, 0, 0 }, LS = { 85, 0, 15 }, LE = { 60, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.18, -0.3 }, Waist = { -10, 0, 0 }, RS = { 88, 0, -22 }, RE = { 70, 0, 0 }, LS = { 88, 0, 22 }, LE = { 70, 0, 0 } },
			prop = "saliere", fx = { { "particles", tex = "spark", color = WHITE, dir = "down", at = "lhand", time = 0.4, speed = 4, size = 0.25 } }, text = "UN PEU DE SEL ?", hitText = "ATCHOUM !",
		},
		-- ✋ puis → : Envoyé en salle, il fait tourner la victime comme une assiette et l'envoie au loin
		THROW_fwd = {
			label = "Envoyé en salle", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 12,
			carry = { { 0, 2.4, 0.4 }, { 0.14, -1.2, 0.6 }, { 0.32, 4.5, 0.2 } },
			windup = { Root = { 4, 45, 0, 0, -0.3, 0.2 }, Waist = { 6, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -30 }, RE = { 40, 0, 0 }, LS = { 85, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -12, -25, 0, 0, -0.4, -0.4 }, Waist = { -14, -30, 0 }, Neck = { 0, 15, 0 }, RS = { 90, 0, 40 }, RE = { 5, 0, 0 }, LS = { 90, 0, 0 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, -32, 0, 0, -0.42, -0.45 }, Waist = { -16, -36, 0 }, Neck = { 0, 18, 0 }, RS = { 85, 0, 60 }, RE = { 5, 0, 0 }, LS = { 80, 0, 20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { "dust" }, text = "TABLE SIX !", hitText = "SERVI !",
		},
		-- ✋ puis ← : Retourné à la poêle, il glisse la poêle sous la victime et la fait sauter par-dessus sa tête
		THROW_back = {
			label = "Retourné à la poêle", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 50,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 2.4, -0.6 }, { 0.28, 0.5, 4.2 }, { 0.4, -2.6, 1.5 } },
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -20, 0, 0 }, RS = { 40, 0, 10 }, RE = { 30, 0, 0 }, RW = { -85, 0, 0 }, LS = { 40, 0, -20 }, LE = { 40, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.2, 0.3 }, Waist = { 28, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 195, 0, 5 }, RE = { 10, 0, 0 }, RW = { -85, 0, 0 }, LS = { 120, 0, -30 }, LE = { 20, 0, 0 } },
			follow = { Root = { 34, 0, 0, 0, -0.2, 0.35 }, Waist = { 32, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 205, 0, 5 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 130, 0, -35 }, LE = { 20, 0, 0 } },
			trail = "prop", text = "ET HOP, RETOURNÉ !", hitText = "FLOP !",
		},
		-- ✋ puis ↑ : Flambé, il lance la victime en l'air et souffle une flamme dessous (brûle)
		THROW_up = {
			label = "Flambé", kind = "throw", startup = 0.34, active = 0.1, recovery = 0.38,
			damage = 9, burn = true, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, -0.6 }, { 0.34, 1.0, 4.2 } },
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -18, 0, 0 }, RS = { 45, 0, -15 }, RE = { 40, 0, 0 }, LS = { 45, 0, 15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.1, 0 }, Waist = { 20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 170, 0, 15 }, RE = { 5, 0, 0 }, LS = { 170, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 14, 0, 0, 0, -0.1, 0.1 }, Waist = { 26, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 60, 0, 60 }, RE = { 10, 0, 0 }, LS = { 60, 0, -60 }, LE = { 10, 0, 0 } },
			fx = { { "particles", tex = "fire", color = FIRE, dir = "up", at = "head", time = 0.4, speed = 26, size = 1.6, rate = 90 } }, text = "FLAMBÉ !", hitText = "CARAMÉLISÉ !",
		},
		-- ✋ puis ↓ : Écrasé au rouleau, il plaque la victime au sol et l'aplatit au rouleau comme une pâte brisée
		THROW_down = {
			label = "Écrasé au rouleau", kind = "throw", startup = 0.42, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 2.0, 1.6 }, { 0.28, 2.4, -2.0 }, { 0.42, 2.4, -2.4 } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -25, 0, 0, 0, -0.9, -0.4 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 10, 0, 0 }, LS = { 70, 0, -20 }, LE = { 10, 0, 0 }, LW = { 80, 0, 0 } },
			follow = { Root = { -28, 0, 0, 0, -0.95, -0.6 }, Waist = { -32, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 25 }, RE = { 5, 0, 0 }, LS = { 60, 0, -25 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 } },
			fx = { "dust" }, text = "PÂTE BRISÉE !", hitText = "CRRRONCH !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "le_souffle", label = "Le Soufflé", sequence = { "forward", "down", "forward" },
			-- l'adversaire gonfle dans un ramequin comme un soufflé, puis s'envole par une cheminée
			scene = {
				{ "fxAttacker", { "text", text = "UN SOUFFLÉ, MONSIEUR ?", color = FLAME } },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.2, 0), life = 4, pieces = {
					{ "Ramequin", "", "cyl", Vector3.new(1.6, 4.2, 4.2), Vector3.zero, Vector3.zero, WHITE, "SmoothPlastic" },
					{ "Cannelures", "", "cyl", Vector3.new(1.4, 4.4, 4.4), Vector3.new(0, -0.1, 0), Vector3.zero, CREAM, "SmoothPlastic" },
				} },
				{ "fx", { "particles", tex = "smoke", color = WHITE, dir = "up", at = "root", time = 1.2, speed = 6, size = 1.2 } },
				{ "color", CREPE },
				{ "grow", 1.7, time = 0.9 },
				{ "text", "IL MONTE… IL MONTE…" },
				{ "wait", 0.4 },
				{ "spawn", at = "above", offset = Vector3.new(0, 8, 0), life = 3, pieces = {
					{ "Cheminee", "", "block", Vector3.new(3, 6, 3), Vector3.zero, Vector3.zero, Color3.fromRGB(170, 70, 50), "Slate" },
					{ "Fumee", "", "ball", Vector3.new(3, 2, 3), Vector3.new(0, 4, 0), Vector3.zero, Color3.fromRGB(220, 220, 220), "SmoothPlastic", { transparency = 0.4 } },
				} },
				{ "launch", Vector3.new(0, 90, 0), time = 1 },
				{ "fxAttacker", { "symbols", symbols = { "💋", "⭐" }, count = 5, color = FLAME } },
				{ "wait", 0.5 },
			},
		},
		{
			id = "croque_monsieur", label = "Croque-Monsieur", sequence = { "back", "forward", "down" },
			-- coincé entre deux tranches de pain géantes, passé au grill, il ressort en sandwich grognon
			scene = {
				{ "spawn", at = "target", offset = Vector3.zero, life = 4.5, name = "Croque", pieces = {
					{ "PainArriere", "", "block", Vector3.new(4.5, 5.5, 0.8), Vector3.new(0, 0, 1.2), Vector3.zero, Color3.fromRGB(230, 190, 120), "Sand" },
					{ "PainAvant", "", "block", Vector3.new(4.5, 5.5, 0.8), Vector3.new(0, 0, -1.2), Vector3.zero, Color3.fromRGB(230, 190, 120), "Sand" },
					{ "Fromage", "", "block", Vector3.new(4.8, 0.4, 2.8), Vector3.new(0, 2.9, 0), Vector3.zero, Color3.fromRGB(255, 210, 60), "SmoothPlastic" },
					{ "Jambon", "", "block", Vector3.new(4.6, 0.3, 2.6), Vector3.new(0, -2.9, 0), Vector3.zero, Color3.fromRGB(240, 150, 160), "SmoothPlastic" },
				} },
				{ "text", "CROQUE-MONSIEUR !" },
				{ "wait", 0.5 },
				{ "fx", { "particles", tex = "fire", color = FIRE, dir = "up", at = "feet", time = 1.2, speed = 10, size = 1.4 } },
				{ "fxAttacker", { "text", text = "AU GRILL !", color = FIRE } },
				{ "color", Color3.fromRGB(150, 95, 45) },
				{ "wait", 1 },
				{ "text", "GRRR…" },
				{ "fx", { "symbols", symbols = { "💢", "🔥" }, count = 5, color = FIRE } },
				{ "wait", 0.8 },
			},
		},
		{
			id = "zero_etoile", label = "Zéro étoile", sequence = { "down", "up", "down" },
			-- un critique gastronomique colle « 0 étoile » à l'adversaire, qu'on emporte sous une cloche d'argent
			scene = {
				{ "fxAttacker", { "text", text = "LA NOTE DU CRITIQUE…", color = SILVER } },
				{ "wait", 0.5 },
				{ "text", "0 ÉTOILE" },
				{ "fx", { "symbols", symbols = { "☆", "0", "☆" }, count = 5, color = Color3.fromRGB(255, 220, 80) } },
				{ "shrink", 0.5, time = 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, -1.6, 0), life = 4, pieces = {
					{ "Plateau", "", "cyl", Vector3.new(0.2, 5, 5), Vector3.zero, Vector3.zero, SILVER, "Metal", { reflect = 0.4 } },
				} },
				{ "wait", 0.4 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0.2, 0), life = 3.6, pieces = {
					{ "Cloche", "", "ball", Vector3.new(4.4, 4, 4.4), Vector3.zero, Vector3.zero, SILVER, "Metal", { reflect = 0.4 } },
					{ "Bouton", "", "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0, 2.1, 0), Vector3.zero, SILVER, "Metal" },
				} },
				{ "hide" },
				{ "fxAttacker", { "text", text = "DÉBARRASSEZ !", color = WHITE } },
				{ "wait", 0.5 },
				{ "launch", Vector3.new(30, 0, 0), time = 0.8 },
				{ "wait", 0.4 },
			},
		},
	},

	-- Mécanique « Cuisson » : les coups marqués burn = true brûlent (voir server/Mechanics.lua)
	passive = { kind = "burn", name = "Cuisson", icon = "🔥" },

	-- Recharge ⚡ : il goûte sa sauce à la cuillère, sale d'un geste théâtral du coude et embrasse ses doigts
	charge = {
		label = "Goûter la sauce",
		loop = 2.0,
		lockWrist = false,
		color = FLAME,
		keys = {
			{ 0.0, { Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 15 }, RE = { 70, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 0.3, { Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 118, 0, -25 }, RE = { 132, 0, 0 }, RW = { -40, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 0.6, { Waist = { 12, 0, 0 }, Neck = { 22, 18, 0 }, RS = { 115, 0, -25 }, RE = { 130, 0, 0 }, RW = { -45, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 0.85, { Root = { 0, 12, 0 }, Waist = { 10, 15, 0 }, Neck = { 14, -10, 0 }, RS = { 25, 0, 30 }, RE = { 70, 0, 0 }, LS = { 150, 0, -65 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 1.05, { Root = { 0, 14, 0 }, Waist = { 12, 18, 0 }, Neck = { 16, -12, 0 }, RS = { 25, 0, 30 }, RE = { 70, 0, 0 }, LS = { 160, 0, -50 }, LE = { 75, 0, 0 }, LW = { 25, 0, 0 } } },
			{ 1.3, { Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 122, 0, -30 }, RE = { 138, 0, 0 }, RW = { -60, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 1.55, { Waist = { 16, 0, 0 }, Neck = { 26, -15, 0 }, RS = { 120, 0, 70 }, RE = { 10, 0, 0 }, RW = { 20, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 1.8, { Waist = { 12, 0, 0 }, Neck = { 18, -8, 0 }, RS = { 70, 0, 50 }, RE = { 30, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 2.0, { Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 15 }, RE = { 70, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		},
		beats = {
			{ 0.4, { "symbols", symbols = { "😋" }, count = 1, radius = 1.5, color = FLAME } },
			{ 0.95, { "particles", tex = "spark", color = WHITE, dir = "down", at = "lhand", time = 0.3, speed = 4, size = 0.25 } },
			{ 1.5, { "symbols", symbols = { "💋" }, count = 2, radius = 2, color = SAUCE } },
			{ 1.55, { "text", text = "PARFAIT !", color = FLAME } },
		},
	},

	-- Manies au repos : il frise sa moustache, redresse sa toque, astique sa poêle avec le torchon
	fidgets = {
		{ duration = 2.0, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 14, -10, 0 }, RS = { 112, 0, -38 }, RE = { 142, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 0.8, { Neck = { 16, -14, 0 }, RS = { 115, 0, -32 }, RE = { 140, 0, 0 }, RW = { 10, 0, 0 } } },
			{ 1.2, { Neck = { 14, -10, 0 }, RS = { 112, 0, -38 }, RE = { 142, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 2.0, {} },
		} },
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.5, { Waist = { 10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 165, 0, 30 }, RE = { 70, 0, 0 }, LS = { 165, 0, -30 }, LE = { 70, 0, 0 } } },
			{ 1.0, { Waist = { 12, 0, 0 }, Neck = { -6, 0, 6 }, RS = { 168, 0, 28 }, RE = { 72, 0, 0 }, LS = { 162, 0, -32 }, LE = { 68, 0, 0 } } },
			{ 1.5, { Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 20, 0, 40 }, RE = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 2.4, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 60, 0, 25 }, LE = { 90, 0, 0 } } },
			{ 0.7, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 70, 0, 10 }, LE = { 80, 0, 0 } } },
			{ 1.0, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 60, 0, 25 }, LE = { 90, 0, 0 } } },
			{ 1.3, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 70, 0, 10 }, LE = { 80, 0, 0 } } },
			{ 1.8, { Neck = { 10, 0, 0 }, RS = { 100, 0, 20 }, RE = { 30, 0, 0 }, RW = { -90, 0, 0 } } },
			{ 2.4, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : il le tient à bout de bras comme un poulet à farcir, torse bombé de fierté
data.grabHold = {
	Root = { 8, 0, 0, 0, -0.12, 0.1 },
	Waist = { 10, 0, 0 },
	Neck = { 14, 0, 0 },
	RS = { 95, 0, -15 },
	RE = { 50, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 90, 0, 12 },
	LE = { 55, 0, 0 },
}

-- Retour 🪂 : il atterrit dans une marmite géante qui fume, en sort d'un bond en faisant tourner sa poêle
-- et lance « Service ! »
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Fond", "base", "cyl", Vector3.new(1, 6.4, 6.4), Vector3.new(0, -0.5, 0), Vector3.zero, IRON, "Metal" },
		{ "Marmite", "", "cyl", Vector3.new(3.2, 6.8, 6.8), Vector3.new(0, -0.3, 0), Vector3.zero, Color3.fromRGB(150, 150, 160), "Metal", { transparency = 0.25, reflect = 0.2 } },
		{ "Bouillon", "", "cyl", Vector3.new(0.2, 6.4, 6.4), Vector3.new(0, 1.0, 0), Vector3.zero, Color3.fromRGB(220, 110, 50), "SmoothPlastic", { transparency = 0.3 } },
		{ "AnseG", "", "block", Vector3.new(0.8, 0.3, 1.6), Vector3.new(-3.7, 1.0, 0), Vector3.zero, BLACK, "Metal" },
		{ "AnseD", "", "block", Vector3.new(0.8, 0.3, 1.6), Vector3.new(3.7, 1.0, 0), Vector3.zero, BLACK, "Metal" },
		{ "Vapeur1", "", "ball", Vector3.new(2, 1.4, 2), Vector3.new(-2.2, 3.4, 0.5), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.5 } },
		{ "Vapeur2", "", "ball", Vector3.new(2.4, 1.6, 2), Vector3.new(2.4, 4.6, 0.8), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.6 } },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -1.0, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 70 }, RE = { 50, 0, 0 }, LS = { 50, 0, -70 }, LE = { 50, 0, 0 } } },
		{ 0.5, { Root = { 0, 0, 0, 0, -0.95, 0 }, Waist = { -4, 0, 0 }, Neck = { 16, 8, 0 }, RS = { 55, 0, 72 }, RE = { 45, 0, 0 }, LS = { 55, 0, -72 }, LE = { 45, 0, 0 } } },
		{ 0.75, { Root = { 0, 0, 0, 0, 0.6, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } } },
		{ 1.0, { Root = { 0, 20, 0, 0, 0, 0 }, Waist = { 10, 20, 0 }, Neck = { 16, -10, 0 }, RS = { 165, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		{ 1.2, { Root = { 0, -15, 0, 0, 0, 0 }, Waist = { 10, -20, 0 }, Neck = { 16, 10, 0 }, RS = { 165, 0, 5 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		{ 1.45, { Root = { -4, 0, 0, 0, -0.1, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 100, 0, 5 }, RE = { 5, 0, 0 }, RW = { -85, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.05, { "particles", tex = "smoke", color = WHITE, dir = "up", at = "root", time = 1.2, speed = 6, size = 1.5 } },
		{ 0.75, { "burst", color = Color3.fromRGB(220, 110, 50), size = 3, at = "feet" } },
		{ 1.0, { "ring", color = SILVER, radius = 3, at = "hand" } },
		{ 1.45, { "text", text = "SERVICE !", color = FLAME } },
	},
}

-- Arbre d'enchaînements : après le coup de gauche, le bouton (avec sa direction) lance le coup de droite.
-- Presque toutes les chaînes finissent sur S (Flambé minute brûle, Trois crêpes tient à distance).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- louche, fouet, poêle sur la tête
	P_neutral = { P = "P_combo2", K = "PK_combo", up_K = "K_up", S = "S_finish_crepes" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", S = "S_finish_flambe" },
	P_combo3 = { K = "K_combo3", S = "S_finish_flambe" },
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_crepes" },
	-- sabot, revers de rouleau, sabot sauté
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_flambe" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", up_K = "K_up", S = "S_finish_flambe" },
	K_combo3 = { K = "K_air_side", P = "P_air_side", S = "S_air" }, -- il décolle : la suite se joue en l'air
	KP_combo = { P = "P_combo3", K = "K_combo3", S = "S_finish_crepes" },
	-- avec une flèche
	P_side = { P = "P_combo3", K = "K_combo2", S = "S_finish_flambe" },
	P_down = { P = "P_combo2", K = "K_up", S = "S_finish_crepes" },
	P_up = { K = "K_up", P = "P_combo3", S = "S_finish_flambe" },
	K_side = { P = "KP_combo", S = "S_finish_flambe" },
	K_down = { P = "P_up", K = "K_up", S = "S_finish_crepes" },
	K_up = { S = "S_finish_crepes" },
	P_dash = { P = "P_combo3", K = "K_side", S = "S_finish_flambe" },
	K_dash = { P = "P_up", K = "K_up", S = "S_finish_crepes" },
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

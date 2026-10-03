-- Bébé Colosse : un bébé de 2,50 m en couche, tétine au bec et bonnet à oreilles d'ours. Maladroit, capricieux
-- et terriblement costaud : il serre, il jette, il hurle. Arme sortie de la Caisse Bizarre : le hochet géant
-- (et sa couche, qui sert de bélier).
--
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
-- Mécanique « Caprice » : les coups reçus remplissent la jauge ; pleine, il pique une crise et encaisse sans
-- broncher pendant 5 s (bonus « caprice », voir server/Mechanics.lua).
-- Accessoires ponctuels : le biberon (main droite, le hochet se range) et le bol de purée (main gauche).

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(255, 214, 186)
local CHEEK = Color3.fromRGB(255, 150, 150)
local DIAPER = Color3.fromRGB(250, 250, 245)
local BONNET = Color3.fromRGB(150, 200, 240)
local EAR_IN = Color3.fromRGB(255, 190, 200)
local BLACK = Color3.fromRGB(25, 25, 30)
local PINK = Color3.fromRGB(250, 140, 180)
local YELLOW = Color3.fromRGB(255, 220, 70)
local BLUE = Color3.fromRGB(90, 160, 240)
local PUREE = Color3.fromRGB(240, 150, 50)
local MILK = Color3.fromRGB(255, 255, 250)
local TEARS = Color3.fromRGB(110, 180, 255)
local WOOD = Color3.fromRGB(205, 160, 110)

local data = {
	id = "Bebe",
	name = "Bébé Colosse",
	costume = "Bebe",
	style = "baby",

	look = {
		body = {
			head = SKIN, upper = SKIN, lower = DIAPER, arms = SKIN, forearms = SKIN,
			hands = SKIN, legs = SKIN, feet = SKIN,
		},
		cubeHead = 1.4,
		parts = {
			-- bonnet à oreilles d'ours
			{ "Bonnet", "Head", "ball", Vector3.new(1.6, 1.0, 1.6), Vector3.new(0, 0.55, 0.05), Vector3.zero, BONNET, "Fabric" },
			{ "OreilleG", "Head", "ball", Vector3.new(0.6, 0.6, 0.28), Vector3.new(-0.58, 1.05, 0), Vector3.zero, BONNET, "Fabric" },
			{ "OreilleD", "Head", "ball", Vector3.new(0.6, 0.6, 0.28), Vector3.new(0.58, 1.05, 0), Vector3.zero, BONNET, "Fabric" },
			{ "OreilleIntG", "Head", "ball", Vector3.new(0.35, 0.35, 0.1), Vector3.new(-0.58, 1.05, -0.12), Vector3.zero, EAR_IN, "Fabric" },
			{ "OreilleIntD", "Head", "ball", Vector3.new(0.35, 0.35, 0.1), Vector3.new(0.58, 1.05, -0.12), Vector3.zero, EAR_IN, "Fabric" },
			{ "Meche", "Head", "ball", Vector3.new(0.28, 0.22, 0.15), Vector3.new(0.05, 0.42, -0.68), Vector3.new(0, 0, 25), Color3.fromRGB(150, 100, 60), "SmoothPlastic" },
			-- grands yeux brillants, joues roses et tétine
			{ "OeilG", "Head", "ball", Vector3.new(0.26, 0.3, 0.1), Vector3.new(-0.3, 0.1, -0.71), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.26, 0.3, 0.1), Vector3.new(0.3, 0.1, -0.71), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "RefletG", "Head", "ball", Vector3.new(0.08, 0.08, 0.04), Vector3.new(-0.26, 0.17, -0.76), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
			{ "RefletD", "Head", "ball", Vector3.new(0.08, 0.08, 0.04), Vector3.new(0.34, 0.17, -0.76), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
			{ "JoueG", "Head", "ball", Vector3.new(0.32, 0.22, 0.06), Vector3.new(-0.5, -0.2, -0.7), Vector3.zero, CHEEK, "SmoothPlastic", { transparency = 0.25 } },
			{ "JoueD", "Head", "ball", Vector3.new(0.32, 0.22, 0.06), Vector3.new(0.5, -0.2, -0.7), Vector3.zero, CHEEK, "SmoothPlastic", { transparency = 0.25 } },
			{ "Tetine", "Head", "ball", Vector3.new(0.7, 0.42, 0.14), Vector3.new(0, -0.36, -0.76), Vector3.zero, PINK, "SmoothPlastic" },
			{ "AnneauTetine", "Head", "cyl", Vector3.new(0.08, 0.4, 0.4), Vector3.new(0, -0.36, -0.86), Vector3.zero, YELLOW, "SmoothPlastic", { axis = "z" } },
			-- gros ventre et nombril
			{ "Bedon", "UpperTorso", "ball", Vector3.new(1.9, 1.5, 1.2), Vector3.new(0, -0.25, -0.15), Vector3.zero, SKIN, "SmoothPlastic" },
			{ "Nombril", "UpperTorso", "ball", Vector3.new(0.14, 0.14, 0.05), Vector3.new(0, -0.35, -0.75), Vector3.zero, Color3.fromRGB(220, 160, 140), "SmoothPlastic" },
			-- couche bien rembourrée, épingle à nourrice et scratch
			{ "Couche", "LowerTorso", "ball", Vector3.new(2.5, 1.5, 1.7), Vector3.new(0, -0.25, 0), Vector3.zero, DIAPER, "Fabric" },
			{ "Epingle", "LowerTorso", "block", Vector3.new(0.4, 0.1, 0.06), Vector3.new(0.75, 0.05, -0.82), Vector3.new(0, 0, 15), BLUE, "SmoothPlastic" },
			{ "Scratch", "LowerTorso", "block", Vector3.new(0.35, 0.3, 0.05), Vector3.new(-0.75, 0.05, -0.82), Vector3.zero, YELLOW, "SmoothPlastic" },
			-- bourrelets de bébé aux poignets
			{ "BourreletG", "LeftLowerArm", "cyl", Vector3.new(0.25, 1.1, 1.1), Vector3.new(0, -0.35, 0), Vector3.zero, SKIN, "SmoothPlastic" },
			{ "BourreletD", "RightLowerArm", "cyl", Vector3.new(0.25, 1.1, 1.1), Vector3.new(0, -0.35, 0), Vector3.zero, SKIN, "SmoothPlastic" },
		},
		props = {
			-- l'arme de la caisse : le hochet géant
			{ name = "PropHochet", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.4, 0.3, 0.3), Vector3.new(0, -0.7, 0), Vector3.zero, PINK, "SmoothPlastic" },
				{ "Boule", "", "ball", Vector3.new(1.7, 1.7, 1.7), Vector3.new(0, -2.1, 0), Vector3.zero, YELLOW, "SmoothPlastic" },
				{ "Anneau", "", "cyl", Vector3.new(0.22, 2.1, 2.1), Vector3.new(0, -2.1, 0), Vector3.zero, BLUE, "SmoothPlastic", { axis = "z", transparency = 0.2 } },
				{ "Grelot1", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(0.85, -2.1, 0), Vector3.zero, PINK, "SmoothPlastic" },
				{ "Grelot2", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(-0.85, -2.1, 0), Vector3.zero, Color3.fromRGB(120, 210, 120), "SmoothPlastic" },
			} },
			-- accessoires ponctuels
			{ name = "PropBiberon", hand = "Right", visible = false, pieces = {
				{ "Flacon", "", "cyl", Vector3.new(1.5, 0.7, 0.7), Vector3.new(0, -0.6, 0), Vector3.zero, Color3.new(1, 1, 1), "Glass", { transparency = 0.35 } },
				{ "Lait", "", "cyl", Vector3.new(1.1, 0.6, 0.6), Vector3.new(0, -0.45, 0), Vector3.zero, MILK, "SmoothPlastic" },
				{ "Bague", "", "cyl", Vector3.new(0.2, 0.75, 0.75), Vector3.new(0, -1.4, 0), Vector3.zero, BLUE, "SmoothPlastic" },
				{ "TetineBib", "", "ball", Vector3.new(0.35, 0.5, 0.35), Vector3.new(0, -1.7, 0), Vector3.zero, Color3.fromRGB(240, 190, 120), "SmoothPlastic" },
			} },
			{ name = "PropPuree", hand = "Left", visible = false, pieces = {
				{ "Bol", "", "ball", Vector3.new(1.4, 0.6, 1.4), Vector3.new(0, -0.45, -0.2), Vector3.zero, BLUE, "SmoothPlastic" },
				{ "Puree", "", "ball", Vector3.new(1.2, 0.5, 1.2), Vector3.new(0, -0.25, -0.2), Vector3.zero, PUREE, "SmoothPlastic" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Hochet maladroit : il secoue le hochet au-dessus de sa tête et l'abat de travers, le corps suit tout seul
		P_neutral = {
			label = "Hochet maladroit", startup = 0.08, active = 0.08, recovery = 0.16,
			damage = 6, hitbox = box(4.5, 3.5, 2.6, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { 4, -10, -6, 0, -0.1, 0.1 }, Waist = { 6, -10, -6 }, Neck = { 10, 0, 8 }, RS = { 160, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, 12, 6, 0, -0.2, -0.2 }, Waist = { -10, 14, 6 }, Neck = { -6, 0, -6 }, RS = { 85, 0, -10 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { -8, 16, 8, 0, -0.22, -0.22 }, Waist = { -12, 18, 8 }, Neck = { -8, 0, -8 }, RS = { 60, 0, -20 }, RE = { 15, 0, 0 }, RW = { -40, 0, 0 }, LS = { 55, 0, -65 }, LE = { 30, 0, 0 } },
			trail = "prop", hitText = "GLING !",
		},
		-- Hochet retour : le hochet revient de l'autre côté, en revers, bébé manque de tomber (suite de P)
		P_combo2 = {
			label = "Hochet retour", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(4.5, 3.5, 2.6, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 32,
			windup = { Root = { -4, 25, 6, 0, -0.2, -0.1 }, Waist = { -6, 25, 6 }, Neck = { 0, -10, -6 }, RS = { 80, 0, -50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 20, 0, 0 } },
			strike = { Root = { -6, -15, -6, 0, -0.22, -0.2 }, Waist = { -8, -20, -6 }, Neck = { 0, 10, 6 }, RS = { 90, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 30, 0, 0 } },
			follow = { Root = { -8, -22, -8, 0, -0.25, -0.24 }, Waist = { -10, -26, -8 }, Neck = { 0, 14, 8 }, RS = { 85, 0, 65 }, RE = { 15, 0, 0 }, RW = { -20, 0, 0 }, LS = { 25, 0, -40 }, LE = { 30, 0, 0 } },
			trail = "prop", hitText = "GLANG !",
		},
		-- Gros hochet : il lève le hochet à deux mains en tirant la langue et l'abat de tout son poids de bébé
		P_combo3 = {
			label = "Gros hochet", startup = 0.14, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 2.6, 1), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 12, 0, 0, 0, 0.05, 0.25 }, Waist = { 16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 195, 0, 5 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -5 }, LE = { 50, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 75, 0, 0 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 75, 0, 10 }, LE = { 10, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.6, -0.45 }, Waist = { -34, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 0 }, RE = { 0, 0, 0 }, RW = { -45, 0, 0 }, LS = { 50, 0, 10 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { { "ring", color = YELLOW, radius = 4, at = "front" }, { "shake", amount = 0.3 } }, text = "AREUH !", hitText = "BADING !",
		},
		-- Coup de couche : il se retourne et donne un violent coup de fesses rembourrées vers l'avant
		P_side = {
			label = "Coup de couche", startup = 0.12, active = 0.1, recovery = 0.22,
			damage = 9, hitbox = box(4.5, 3, 2.4, -0.4), kbBase = 26, kbGrowth = 40, kbAngle = 25, selfVelocity = Vector2.new(24, 0),
			windup = { Root = { -6, 60, 0, 0, -0.25, 0.1 }, Waist = { -8, 20, 0 }, Neck = { 0, -40, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 40, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -22, 170, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 } },
			follow = { Root = { -26, 175, 0, 0, -0.5, 0 }, Waist = { -12, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 70, 0, 65 }, RE = { 20, 0, 0 }, LS = { 70, 0, -65 }, LE = { 20, 0, 0 } },
			trail = "body", fx = { { "burst", color = DIAPER, size = 3, at = "front" } }, text = "POUF !", hitText = "PROUT !",
		},
		-- Roulade à quatre pattes : il plonge en boule sous les coups et roule dans les jambes (esquive basse et frappe)
		P_down = {
			label = "Roulade à quatre pattes", startup = 0.08, active = 0.14, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 2.5, 2, -1.5), kbBase = 24, kbGrowth = 25, kbAngle = 68, selfVelocity = Vector2.new(30, 0), invuln = 0.12,
			windup = { Root = { -30, 0, 0, 0, -0.8, 0 }, Waist = { -30, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, LS = { 120, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -1.3, -0.3 }, Waist = { -40, 0, 0 }, Neck = { -35, 0, 0 }, RS = { 60, 0, 20 }, RE = { 120, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 }, RH = { 120, 0, 0 }, RK = { -140, 0, 0 }, LH = { 120, 0, 0 }, LK = { -140, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -1.2, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 70, 0, 20 }, RE = { 110, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			spin = { axis = "x", degrees = 360 }, trail = "body", fx = { "dust" }, hitText = "ROULI-ROULA !",
		},
		-- Tétine-ressort (anti-air) : accroupi, il se détend d'un coup tête en l'air, tétine pointée vers le ciel
		P_up = {
			label = "Tétine-ressort", startup = 0.09, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 5, 1, 3.6), kbBase = 26, kbGrowth = 32, kbAngle = 86,
			windup = { Root = { -6, 0, 0, 0, -0.75, 0 }, Waist = { -20, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.35, 0 }, Waist = { 14, 0, 0 }, Neck = { 45, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.4, 0 }, Waist = { 16, 0, 0 }, Neck = { 50, 0, 0 }, RS = { -35, 0, 55 }, RE = { 20, 0, 0 }, LS = { -35, 0, -55 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			trail = "head", hitText = "TCHOUP !",
		},
		-- Coup de tétine : en l'air, il fonce la tétine la première, bras et jambes ballants
		P_air = {
			label = "Coup de tétine", startup = 0.08, active = 0.1, recovery = 0.16,
			damage = 7, hitbox = box(4, 3.5, 2.2, 0.8), kbBase = 22, kbGrowth = 32, kbAngle = 35,
			windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -50, 0, 0 } },
			strike = { Root = { -25, 0, 0 }, Waist = { -15, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -20, 0, 60 }, RE = { 30, 0, 0 }, LS = { -20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 10, 0, 10 }, RK = { -40, 0, 0 }, LH = { 0, 0, -10 }, LK = { -50, 0, 0 } },
			follow = { Root = { -28, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { -25, 0, 62 }, RE = { 30, 0, 0 }, LS = { -25, 0, -62 }, LE = { 30, 0, 0 }, RH = { 5, 0, 12 }, RK = { -40, 0, 0 }, LH = { -5, 0, -12 }, LK = { -50, 0, 0 } },
			trail = "head", hitText = "SUÇOTE !",
		},
		-- Pincement (dash puis P) : il arrive en trottinant et pince les deux joues de l'adversaire en tirant fort
		P_dash = {
			label = "Pincement", startup = 0.08, active = 0.14, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 3.5, 2.4, 1), kbBase = 26, kbGrowth = 48, kbAngle = 30, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -8, 0, 0, 0, -0.2, 0 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 50 }, RE = { 60, 0, 0 }, LS = { 70, 0, -50 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 100, 0, -8 }, RE = { 20, 0, 0 }, LS = { 100, 0, 8 }, LE = { 20, 0, 0 }, LW = { 0, 0, 30 } },
			follow = { Root = { 10, 0, 0, 0, -0.3, -0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 95, 0, 20 }, RE = { 50, 0, 0 }, LS = { 95, 0, -20 }, LE = { 50, 0, 0 }, LW = { 0, 0, 30 } },
			fx = { "dust" }, text = "GUILI-GUILI !", hitText = "AÏE MES JOUES !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Petit pied potelé : il lève haut la jambe en se dandinant et tape un grand coup de pied à plat
		K_neutral = {
			label = "Petit pied potelé", startup = 0.19, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, -0.2), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 10, 0, -8, 0, -0.1, 0.2 }, Waist = { 12, 0, -6 }, Neck = { 10, 0, 8 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -110, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { 16, 0, 4, 0, -0.1, 0 }, Waist = { 16, 0, 4 }, Neck = { 14, 0, -4 }, RS = { 40, 0, 70 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, RH = { 95, 0, 0 }, RK = { -5, 0, 0 }, RA = { 25, 0, 0 } },
			follow = { Root = { 18, 0, 6, 0, -0.1, 0.05 }, Waist = { 18, 0, 6 }, Neck = { 16, 0, -6 }, RS = { 35, 0, 75 }, RE = { 20, 0, 0 }, LS = { 35, 0, -75 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			trail = "rightFoot", hitText = "PATAPON !",
		},
		-- Gifle de bébé : la grosse main gauche s'ouvre et part en grand arc, tout le corps tourne avec
		K_side = {
			label = "Gifle de bébé", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 13, hitbox = box(5, 4, 3, 1), kbBase = 32, kbGrowth = 82, kbAngle = 30, selfVelocity = Vector2.new(25, 0),
			windup = { Root = { 6, 40, 0, 0, -0.2, 0.25 }, Waist = { 8, 35, 0 }, Neck = { 6, -25, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 100, 0, -110 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 } },
			strike = { Root = { -12, -25, 0, 0, -0.35, -0.4 }, Waist = { -14, -30, 0 }, Neck = { -6, 20, 0 }, RS = { 20, 0, 50 }, RE = { 40, 0, 0 }, LS = { 95, 0, 20 }, LE = { 5, 0, 0 }, LW = { 0, 0, 30 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, -40, 0, 0, -0.38, -0.45 }, Waist = { -16, -42, 0 }, Neck = { -8, 28, 0 }, RS = { 15, 0, 55 }, RE = { 40, 0, 0 }, LS = { 85, 0, 50 }, LE = { 10, 0, 0 }, LW = { 0, 0, 30 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "leftHand", text = "NA !", hitText = "PAF BÉBÉ !",
		},
		-- Assis par terre : il se laisse tomber sur les fesses de tout son poids, le sol tremble autour (encaisse sans broncher)
		K_down = {
			label = "Assis par terre", startup = 0.18, active = 0.12, recovery = 0.35,
			damage = 11, hitbox = box(8, 2.2, 0.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 75, armor = true,
			windup = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 120, 0, 40 }, RE = { 20, 0, 0 }, LS = { 120, 0, -40 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 10, 0, 0, 0, -1.5, 0.2 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 85, 0, 10 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { 85, 0, -10 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -1.5, 0.2 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 45, 0, 65 }, RE = { 20, 0, 0 }, LS = { 45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 80, 0, 15 }, RK = { -10, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, -15 }, LK = { -10, 0, 0 }, LA = { 10, 0, 0 } },
			fx = { { "ring", color = DIAPER, radius = 5, at = "feet" }, { "shake", amount = 0.4 }, "dust" }, text = "POUF !", hitText = "BOUM-BOUM !",
		},
		-- Porte-moi ! (anti-air) : il tend brusquement les deux bras au ciel en sautillant pour qu'on le prenne
		K_up = {
			label = "Porte-moi !", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 5, 0.8, 3.5), kbBase = 34, kbGrowth = 74, kbAngle = 88,
			windup = { Root = { -4, 0, 0, 0, -0.7, 0 }, Waist = { -12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 90, 0, 0 }, LS = { 20, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.45, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 22 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -22 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			trail = "bothHands", text = "PORTE-MOI !", hitText = "HOPLA !",
		},
		-- Plat ventre : en l'air, il s'étale à plat ventre bras et jambes en étoile sur l'adversaire
		K_air = {
			label = "Plat ventre", startup = 0.16, active = 0.14, recovery = 0.28,
			damage = 11, hitbox = box(5.5, 3.5, 1.8, -0.5), kbBase = 30, kbGrowth = 68, kbAngle = 30,
			windup = { Root = { 15, 0, 0 }, Waist = { 15, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -70, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 60 }, RE = { 10, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { -10, 0, 25 }, RK = { -10, 0, 0 }, LH = { -10, 0, -25 }, LK = { -10, 0, 0 } },
			follow = { Root = { -75, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 155, 0, 65 }, RE = { 10, 0, 0 }, LS = { 155, 0, -65 }, LE = { 10, 0, 0 }, RH = { -12, 0, 28 }, RK = { -12, 0, 0 }, LH = { -12, 0, -28 }, LK = { -12, 0, 0 } },
			trail = "body", hitText = "SPLATCH !",
		},
		-- Petit pied gauche : l'autre pied potelé tape à son tour en tapant du talon (suite de K)
		K_combo2 = {
			label = "Petit pied gauche", startup = 0.14, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3, 3, -0.2), kbBase = 28, kbGrowth = 50, kbAngle = 32,
			windup = { Root = { 10, 0, 8, 0, -0.1, 0.15 }, Waist = { 12, 0, 6 }, Neck = { 10, 0, -8 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, LH = { 95, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 16, 0, -4, 0, -0.1, 0 }, Waist = { 16, 0, -4 }, Neck = { 14, 0, 4 }, RS = { 40, 0, 70 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, LH = { 95, 0, 0 }, LK = { -5, 0, 0 }, LA = { 25, 0, 0 } },
			follow = { Root = { 18, 0, -6, 0, -0.1, 0.05 }, Waist = { 18, 0, -6 }, Neck = { 16, 0, 6 }, RS = { 35, 0, 75 }, RE = { 20, 0, 0 }, LS = { 35, 0, -75 }, LE = { 20, 0, 0 }, LH = { 100, 0, 0 }, LK = { 0, 0, 0 }, LA = { 25, 0, 0 } },
			trail = "leftFoot", hitText = "PATAPAN !",
		},
		-- Coup de pied colère : il saute en tapant des deux pieds en l'air comme un bébé en pleine crise
		K_combo3 = {
			label = "Coup de pied colère", startup = 0.16, active = 0.14, recovery = 0.3,
			damage = 12, hitbox = box(5, 4, 2.8, 0.5), kbBase = 32, kbGrowth = 80, kbAngle = 40, selfVelocity = Vector2.new(12, 38),
			windup = { Root = { -8, 0, 0, 0, -0.65, 0.1 }, Waist = { -14, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 140, 0, 40 }, RE = { 60, 0, 0 }, LS = { 140, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 25, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 60 }, RE = { 30, 0, 0 }, LS = { 160, 0, -60 }, LE = { 30, 0, 0 }, RH = { 90, 0, 8 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 80, 0, -8 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 165, 0, 65 }, RE = { 30, 0, 0 }, LS = { 165, 0, -65 }, LE = { 30, 0, 0 }, RH = { 100, 0, 10 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 90, 0, -10 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", text = "OUIIIN !", hitText = "BAM BAM !",
		},
		-- Bébé bulldozer (dash puis K) : il se jette à plat ventre et glisse sur le bedon comme sur une luge
		K_dash = {
			label = "Bébé bulldozer", startup = 0.1, active = 0.25, recovery = 0.32,
			damage = 11, hitbox = box(6, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 62, kbAngle = 45, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { -20, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 50, 0, 0 }, LS = { 40, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { -75, 0, 0, 0, -1.6, -0.3 }, Waist = { -5, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 165, 0, 20 }, RE = { 10, 0, 0 }, LS = { 165, 0, -20 }, LE = { 10, 0, 0 }, RH = { -10, 0, 10 }, RK = { -20, 0, 0 }, LH = { -10, 0, -10 }, LK = { -20, 0, 0 } },
			follow = { Root = { -78, 0, 0, 0, -1.65, -0.35 }, Waist = { -6, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 170, 0, 25 }, RE = { 10, 0, 0 }, LS = { 170, 0, -25 }, LE = { 10, 0, 0 }, RH = { -12, 0, 12 }, RK = { -25, 0, 0 }, LH = { -12, 0, -12 }, LK = { -25, 0, 0 } },
			trail = "body", fx = { "dust" }, text = "VROUM !", hitText = "BOULDOZÉ !",
		},
		-- P puis K : Coup de genou potelé, petit genou qui remonte dans le ventre
		PK_combo = {
			label = "Genou potelé", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4, 3, 2.2, 0), kbBase = 22, kbGrowth = 32, kbAngle = 45,
			windup = { Root = { 4, 0, 0, 0, -0.15, 0.1 }, Waist = { 6, 0, 0 }, RS = { 50, 0, 40 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 40, 0, 0 }, RH = { -15, 0, 0 }, RK = { -50, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, 0.05, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 50 }, RE = { 50, 0, 0 }, LS = { 20, 0, -50 }, LE = { 50, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, 0.08, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 15, 0, 52 }, RE = { 50, 0, 0 }, LS = { 15, 0, -52 }, LE = { 50, 0, 0 }, RH = { 108, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 } },
			trail = "rightLeg", hitText = "POC !",
		},
		-- K puis P : Tape-tape, il tape deux fois à deux mains comme sur un tambour
		KP_combo = {
			label = "Tape-tape", startup = 0.08, active = 0.14, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(4.5, 3.5, 2.4, 0.8), kbBase = 20, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 15 }, RE = { 60, 0, 0 }, LS = { 150, 0, -15 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 10 }, RE = { 20, 0, 0 }, LS = { 80, 0, -10 }, LE = { 20, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -0.25, -0.25 }, Waist = { -10, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 120, 0, 10 }, RE = { 50, 0, 0 }, LS = { 120, 0, -10 }, LE = { 50, 0, 0 } },
			wobble = true, trail = "bothHands", hitText = "TAPE TAPE !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Jet de purée, il plonge la main dans le bol et envoie une poignée de purée qui ralentit
		P_air_side = {
			label = "Jet de purée", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
			damage = 6, kbBase = 16, kbGrowth = 25, kbAngle = 25,
			status = { name = "slowed", duration = 1.5 },
			projectile = { speed = 55, angle = 5, gravity = 40, lifetime = 0.7, size = 1.4, color = PUREE,
				visual = { shape = "ball", size = 1.1, color = PUREE, parts = { { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.5, 0.2, 0), PUREE } } } },
			windup = { Root = { 6, 20, 0 }, Waist = { 8, 20, 0 }, Neck = { 0, -15, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 80, 0, -90 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, -15, 0 }, Waist = { -8, -20, 0 }, Neck = { 0, 12, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 100, 0, 10 }, LE = { 5, 0, 0 }, LW = { 0, 0, 20 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -8, -20, 0 }, Waist = { -10, -24, 0 }, Neck = { 0, 15, 0 }, RS = { 30, 0, 52 }, RE = { 40, 0, 0 }, LS = { 95, 0, 30 }, LE = { 10, 0, 0 }, LW = { 0, 0, 30 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 55, 0, 0 }, LK = { -90, 0, 0 } },
			prop = "puree", text = "BEURK !", hitText = "SPLOTCH !",
		},
		-- ↑ P en l'air : Hochet hélice, il fait tourner le hochet au-dessus de sa tête comme une hélice
		P_air_up = {
			label = "Hochet hélice", startup = 0.09, active = 0.16, recovery = 0.18,
			damage = 4, hits = 2, hitbox = box(5, 4, 0.5, 3.6), kbBase = 24, kbGrowth = 40, kbAngle = 86,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 8, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 5 }, RE = { 5, 0, 0 }, RW = { 90, 0, 0 }, LS = { 15, 0, -62 }, LE = { 30, 0, 0 }, RH = { 5, 0, 0 }, RK = { -35, 0, 0 }, LH = { 15, 0, 0 }, LK = { -45, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "GLING GLING !",
		},
		-- ↓ P en l'air : Atterrissage fesses, il tombe assis de tout son poids, couche en avant (smash vers le sol)
		P_air_down = {
			label = "Atterrissage fesses", startup = 0.15, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(4.5, 3.5, 0, -2.4), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(0, -55),
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 140, 0, 40 }, RE = { 30, 0, 0 }, LS = { 140, 0, -40 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 90, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 25, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, RH = { 90, 0, 15 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { 90, 0, -15 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 28, 0, 0 }, Waist = { 2, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 55, 0, 75 }, RE = { 20, 0, 0 }, LS = { 55, 0, -75 }, LE = { 20, 0, 0 }, RH = { 92, 0, 18 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { 92, 0, -18 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "body", fx = { { "ring", color = DIAPER, radius = 4, at = "feet" } }, text = "POUF !", hitText = "ÉCRABOUILLÉ !",
		},
		-- → K en l'air : Coup de couche volant, il pivote en l'air et présente la couche la première
		K_air_side = {
			label = "Coup de couche volant", startup = 0.15, active = 0.12, recovery = 0.26,
			damage = 11, hitbox = box(5, 3.5, 2.6, -0.3), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { -6, 60, 0 }, Waist = { -6, 20, 0 }, Neck = { 0, -40, 0 }, RS = { 60, 0, 50 }, RE = { 40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -20, 170, 0 }, Waist = { -10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 90, 0, 70 }, RE = { 20, 0, 0 }, LS = { 90, 0, -70 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -24, 175, 0 }, Waist = { -12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 95, 0, 72 }, RE = { 20, 0, 0 }, LS = { 95, 0, -72 }, LE = { 20, 0, 0 }, RH = { 55, 0, 0 }, RK = { -55, 0, 0 }, LH = { 55, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "body", hitText = "POUF-POUF !",
		},
		-- ↑ K en l'air : Pédalage de berceau, couché sur le dos dans le vide, il pédale des deux pieds vers le haut
		K_air_up = {
			label = "Pédalage de berceau", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 5, hits = 2, hitbox = box(4.5, 5, 0.5, 3.4), kbBase = 28, kbGrowth = 60, kbAngle = 86,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 45, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 100, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 45, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -110, 0, 0 }, LH = { 140, 0, 0 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", hitText = "GIGOTE !",
		},
		-- ↓ K en l'air : Talons de bébé, il pique vers le sol en tapant des deux talons (smash vers le sol)
		K_air_down = {
			label = "Talons de bébé", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 50 }, RE = { 50, 0, 0 }, LS = { 110, 0, -50 }, LE = { 50, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 60 }, RE = { 20, 0, 0 }, LS = { 150, 0, -60 }, LE = { 20, 0, 0 }, RH = { -4, 0, 6 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -4, 0, -6 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 160, 0, 65 }, RE = { 20, 0, 0 }, LS = { 160, 0, -65 }, LE = { 20, 0, 0 }, RH = { -4, 0, 8 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { -4, 0, -8 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "PATATRAS !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Hurlement : il gonfle les joues, se cambre poings serrés et pousse un cri qui repousse tout autour de lui
		S_neutral = {
			label = "Hurlement", energyCost = 25, startup = 0.18, active = 0.2, recovery = 0.35,
			damage = 9, hitbox = box(10, 8, 0, 1), kbBase = 45, kbGrowth = 55, kbAngle = 30,
			windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 10, 0, 15 }, RE = { 110, 0, 0 }, LS = { 10, 0, -15 }, LE = { 110, 0, 0 } },
			strike = { Root = { -4, 0, 0, 0, -0.15, 0 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -25, 0, 35 }, RE = { 10, 0, 0 }, LS = { -25, 0, -35 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.1, 0 }, FL = { 0, 0, 0, 0, 0.1, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.15, 0 }, Waist = { -8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { -30, 0, 40 }, RE = { 10, 0, 0 }, LS = { -30, 0, -40 }, LE = { 10, 0, 0 } },
			hold = 0.15, shake = true,
			fx = { { "ring", color = TEARS, radius = 6, at = "head" }, { "ring", color = Color3.new(1, 1, 1), radius = 9, at = "head", time = 0.5 }, { "symbols", symbols = { "😭", "WAAAH" }, count = 5, radius = 4, color = TEARS }, { "shake", amount = 0.5 } },
			text = "OUIIIIIN !", hitText = "MES OREILLES !",
		},
		-- Charge à quatre pattes : il fonce à quatre pattes, attrape l'adversaire au passage et le jette par-dessus
		-- son épaule (l'adversaire part derrière lui)
		S_side = {
			label = "Charge à quatre pattes", energyCost = 25, startup = 0.1, active = 0.3, recovery = 0.32,
			damage = 11, hitbox = box(4.5, 3, 2.2, -1), kbBase = 34, kbGrowth = 60, kbAngle = 140, selfVelocity = Vector2.new(55, 0),
			windup = { Root = { -40, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 90, 0, 20 }, RE = { 20, 0, 0 }, LS = { 90, 0, -20 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -60, 0, 0, 0, -1.1, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 120, 0, 15 }, RE = { 10, 0, 0 }, LS = { 50, 0, -15 }, LE = { 20, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.4, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 200, 0, 10 }, RE = { 20, 0, 0 }, LS = { 200, 0, -10 }, LE = { 20, 0, 0 } },
			wobble = true, fx = { "dust" }, text = "ATTRAPÉ !", hitText = "PAR-DESSUS !",
		},
		-- Colère sismique : il frappe le sol des deux poings en hurlant, un séisme de courte portée renverse tout
		S_down = {
			label = "Colère sismique", energyCost = 25, startup = 0.2, active = 0.15, recovery = 0.35,
			damage = 11, hitbox = box(10, 2.5, 0, -2), kbBase = 32, kbGrowth = 55, kbAngle = 82,
			windup = { Root = { 8, 0, 0, 0, 0, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 185, 0, 20 }, RE = { 50, 0, 0 }, LS = { 185, 0, -20 }, LE = { 50, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.9, -0.2 }, Waist = { -40, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 15 }, RE = { 10, 0, 0 }, LS = { 70, 0, -15 }, LE = { 10, 0, 0 } },
			follow = { Root = { -22, 0, 0, 0, -0.95, -0.2 }, Waist = { -44, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 20 }, RE = { 10, 0, 0 }, LS = { 60, 0, -20 }, LE = { 10, 0, 0 } },
			shake = true,
			fx = { { "ring", color = WOOD, radius = 6, at = "feet" }, { "shake", amount = 0.7 }, { "particles", tex = "smoke", color = Color3.fromRGB(190, 170, 140), dir = "up", at = "feet", time = 0.3, speed = 8, size = 1.2 } },
			text = "NAAAN !", hitText = "BRRROUM !",
		},
		-- Saut du lit : un lit à barreaux élastique apparaît sous lui, il rebondit dessus bras en l'air
		-- (gratuit : c'est la remontée)
		S_up = {
			label = "Saut du lit", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 8, hitbox = box(5, 6, 0.5, 3), kbBase = 30, kbGrowth = 40, kbAngle = 85, selfVelocity = Vector2.new(5, 95),
			windup = { Root = { 0, 0, 0, 0, -0.85, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.4, 0 }, Waist = { 8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 175, 0, 25 }, RE = { 10, 0, 0 }, LS = { 175, 0, -25 }, LE = { 10, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 20, 0, -10 }, LK = { -40, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0.4, 0 }, Waist = { 10, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 160, 0, 50 }, RE = { 10, 0, 0 }, LS = { 160, 0, -50 }, LE = { 10, 0, 0 }, RH = { 40, 0, 15 }, RK = { -70, 0, 0 }, LH = { 40, 0, -15 }, LK = { -70, 0, 0 } },
			fx = { { "pillar", color = WOOD, height = 2.5, width = 6, at = "root", neon = false, time = 0.5 }, { "ring", color = BLUE, radius = 4, at = "feet" } }, text = "BOING !", hitText = "DEBOUT !",
		},
		-- Plongeon Dodo (en l'air + ↓ + S) : il tombe lourdement sur le ventre et s'endort une fraction de seconde
		S_air_down = {
			label = "Plongeon Dodo", energyCost = 25, startup = 0.12, active = 0.35, recovery = 0.5,
			damage = 12, hitbox = box(5.5, 3.5, 0.8, -1.8), kbBase = 26, kbGrowth = 55, kbAngle = -70, selfVelocity = Vector2.new(10, -80),
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 30 }, RE = { 20, 0, 0 }, LS = { 160, 0, -30 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -75, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 50 }, RE = { 10, 0, 0 }, LS = { 170, 0, -50 }, LE = { 10, 0, 0 }, RH = { -10, 0, 15 }, RK = { -10, 0, 0 }, LH = { -10, 0, -15 }, LK = { -10, 0, 0 } },
			follow = { Root = { -80, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 20 }, RS = { 120, 0, 70 }, RE = { 30, 0, 0 }, LS = { 120, 0, -70 }, LE = { 30, 0, 0 }, RH = { -12, 0, 18 }, RK = { -15, 0, 0 }, LH = { -12, 0, -18 }, LK = { -15, 0, 0 } },
			trail = "body", fx = { { "shake", amount = 0.5 }, { "symbols", symbols = { "Z", "z", "💤" }, count = 4, radius = 2, color = Color3.fromRGB(170, 200, 255) } }, text = "DODO !", hitText = "ZZZ-BAM !",
		},
		-- Biberon (esquive puis S) : il s'assoit, tète un biberon en fermant les yeux et se soigne (vulnérable)
		S_dodge = {
			label = "Biberon", energyCost = 25, startup = 0.15, active = 0, recovery = 0.8,
			hitbox = box(6, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 9, selfEffect = { heal = 6 },
			windup = { Root = { -4, 0, 0, 0, -0.4, 0.1 }, Neck = { 10, 0, 0 }, RS = { 110, 0, -15 }, RE = { 110, 0, 0 }, RW = { -80, 0, 0 }, LS = { 100, 0, 10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.5, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, -15 }, RE = { 120, 0, 0 }, RW = { -110, 0, 0 }, LS = { 130, 0, 15 }, LE = { 120, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.5, 0.15 }, Waist = { 12, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 145, 0, -15 }, RE = { 118, 0, 0 }, RW = { -115, 0, 0 }, LS = { 135, 0, 15 }, LE = { 118, 0, 0 } },
			hold = 0.4, prop = "biberon", hideProp = "hochet", fx = { { "symbols", symbols = { "🍼", "♥" }, count = 3, radius = 2, color = MILK } }, text = "GLOU GLOU",
		},
		-- Cri supersonique (S maintenu) : il retient sa respiration, devient tout rouge… et lâche une onde de cri qui traverse tout
		S_hold = {
			label = "Cri supersonique", energyCost = 35, kind = "projectile", startup = 0.24, active = 0, recovery = 0.4,
			damage = 13, kbBase = 38, kbGrowth = 75, kbAngle = 25,
			projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 0.6, size = 3.5, color = TEARS, pierce = true,
				visual = { shape = "disc", size = 3.5, color = TEARS, transparency = 0.45, neon = true, trail = false } },
			windup = { Root = { 8, 0, 0, 0, -0.35, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 20, 0, 10 }, RE = { 120, 0, 0 }, LS = { 20, 0, -10 }, LE = { 120, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.3, -0.2 }, Waist = { -12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 40 }, RE = { 10, 0, 0 }, LS = { -30, 0, -40 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -35, 0, 45 }, RE = { 10, 0, 0 }, LS = { -35, 0, -45 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			shake = true, windupFx = { { "symbols", symbols = { "😤" }, count = 1, radius = 1.5, color = Color3.fromRGB(255, 90, 90) } },
			fx = { { "ring", color = TEARS, radius = 4, at = "front" }, { "shake", amount = 0.4 } }, text = "AAAAAAAH !", hitText = "TYMPANS !",
		},
		-- Rampe éclair (→→S) : il file à quatre pattes à une vitesse indécente, tête la première
		S_dash = {
			label = "Rampe éclair", energyCost = 25, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 10, hitbox = box(5, 2.5, 2.2, -1.2), kbBase = 30, kbGrowth = 60, kbAngle = 40, selfVelocity = Vector2.new(65, 0), invuln = 0.15,
			windup = { Root = { -40, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 80, 0, 20 }, RE = { 10, 0, 0 }, LS = { 80, 0, -20 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -62, 0, 0, 0, -1.15, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 110, 0, 15 }, RE = { 10, 0, 0 }, LS = { 50, 0, -15 }, LE = { 10, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { -62, 0, 0, 0, -1.15, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 50, 0, 15 }, RE = { 10, 0, 0 }, LS = { 110, 0, -15 }, LE = { 10, 0, 0 }, RH = { 75, 0, 0 }, RK = { -110, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
			wobble = true, fx = { "dust" }, text = "GAGA-GOUGOU !", hitText = "BAM !",
		},
		-- Bol de purée (S en l'air) : il renverse tout le bol par-dessus bord, la purée pleut devant lui et colle les pieds
		S_air = {
			label = "Bol de purée", energyCost = 25, kind = "projectile", startup = 0.14, active = 0, recovery = 0.3,
			damage = 3, kbBase = 12, kbGrowth = 20, kbAngle = 60,
			status = { name = "slowed", duration = 1.5 },
			projectile = { speed = 35, gravity = 30, lifetime = 0.9, size = 1.6, color = PUREE, rain = { count = 4, spread = 5, ahead = 7, height = 16 },
				visual = { shape = "ball", size = 1.3, color = PUREE, parts = { { "ball", Vector3.new(0.6, 0.5, 0.6), Vector3.new(0.4, 0.3, 0), PUREE } } } },
			windup = { Root = { 8, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 165, 0, -10 }, LE = { 10, 0, 0 }, LW = { 0, 0, 90 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 40, 0, 52 }, RE = { 40, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 }, LW = { 0, 0, 120 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			prop = "puree", text = "PAS MANGÉ !", hitText = "SPLOTCH !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Caprice tape-sol : il se jette par terre et tape des poings et des pieds en hurlant (fait décoller)
		S_finish_caprice = {
			label = "Caprice tape-sol", energyCost = 20, startup = 0.12, active = 0.3, recovery = 0.35,
			damage = 4, hits = 3, hitbox = box(6, 3, 1.5, -1.5), kbBase = 26, kbGrowth = 45, kbAngle = 72,
			windup = { Root = { 10, 0, 0, 0, -0.5, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 30 }, RE = { 40, 0, 0 }, LS = { 160, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -15, 0, 0, 0, -1.1, -0.1 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 25 }, RE = { 10, 0, 0 }, LS = { 120, 0, -25 }, LE = { 30, 0, 0 } },
			follow = { Root = { -15, 0, 0, 0, -1.1, -0.1 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 25 }, RE = { 30, 0, 0 }, LS = { 60, 0, -25 }, LE = { 10, 0, 0 } },
			wobble = true, fx = { { "shake", amount = 0.3 }, "dust" }, text = "NAN NAN NAN !", hitText = "PAF PAF PAF !",
		},
		-- Petit cri : un cri bref et perçant, bouche grande ouverte, qui éjecte à l'horizontale
		S_finish_cri = {
			label = "Petit cri", energyCost = 20, startup = 0.1, active = 0.15, recovery = 0.3,
			damage = 9, hitbox = box(7, 5, 3.5, 0.8), kbBase = 38, kbGrowth = 60, kbAngle = 25,
			windup = { Root = { 6, 0, 0, 0, -0.25, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 20 }, RE = { 100, 0, 0 }, LS = { 20, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.15 }, Waist = { -10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -20, 0, 40 }, RE = { 10, 0, 0 }, LS = { -20, 0, -40 }, LE = { 10, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.2, -0.15 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -25, 0, 45 }, RE = { 10, 0, 0 }, LS = { -25, 0, -45 }, LE = { 10, 0, 0 } },
			fx = { { "ring", color = TEARS, radius = 4, at = "front" } }, text = "IIIIH !", hitText = "AÏE !",
		},

		------------------------------------------------------------------ Supers
		-- Crise de larmes : il éclate en sanglots et un torrent de larmes balaie l'écran devant lui (trempe)
		SUPER = {
			label = "Crise de larmes !", kind = "projectile", superCost = 100, startup = 0.4, active = 0, recovery = 0.6,
			damage = 22, kbBase = 35, kbGrowth = 70, kbAngle = 25,
			status = { name = "wet", duration = 2.5 },
			projectile = { speed = 45, angle = 0, gravity = 0, lifetime = 1.4, size = 6, color = TEARS, pierce = true, from = "feet",
				visual = { shape = "block", size = 4.5, color = TEARS, transparency = 0.35, trail = false,
					parts = { { "ball", Vector3.new(5, 1.5, 3), Vector3.new(0, 2.6, 0), Color3.fromRGB(220, 240, 255) }, { "ball", Vector3.new(1.4, 1.4, 1.4), Vector3.new(1.5, 3.2, 0), Color3.fromRGB(220, 240, 255) } } } },
			windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, -30 }, RE = { 140, 0, 0 }, LS = { 120, 0, 30 }, LE = { 140, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, -0.2, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -0.2, 0.1 }, Waist = { 18, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 50, 0, 70 }, RE = { 30, 0, 0 }, LS = { 50, 0, -70 }, LE = { 30, 0, 0 } },
			hold = 0.3, shake = true, windupFx = { "super", { "symbols", symbols = { "😭", "💧" }, count = 6, radius = 2.5, color = TEARS } },
			fx = { { "screen", color = TEARS, alpha = 0.35 }, { "puddle", color = TEARS, width = 10, time = 2 }, { "particles", tex = "smoke", color = TEARS, dir = "front", at = "head", time = 0.8, speed = 18, size = 1, rate = 90 } },
			text = "BOUHOUHOUUU !", hitText = "PLOUF !",
		},
		-- Super ↑ : il pique une colère en tournoyant et projette ses jouets vers le ciel
		SUPER_up = {
			label = "Lancer de jouets !", superCost = 100, startup = 0.25, active = 0.45, recovery = 0.55,
			damage = 22, hitbox = box(9, 10, 0, 3), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -4.8, 0, 0, 0, -0.7, 0 }, Waist = { -14.4, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 24, 0, 24 }, RE = { 108, 0, 0 }, LS = { 24, 0, -24 }, LE = { 108, 0, 0 } },
			strike = { Root = { 4.8, 0, 0, 0, 0.45, 0 }, Waist = { 12, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 210, 0, 18 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 210, 0, -18 }, LE = { 6, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			follow = { Root = { 7.2, 0, 0, 0, 0.5, 0 }, Waist = { 14.4, 0, 0 }, Neck = { 40.8, 0, 0 }, RS = { 213.6, 0, 26.4 }, RE = { 12, 0, 0 }, RW = { 0, 0, 0 }, LS = { 213.6, 0, -26.4 }, LE = { 12, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			spin = { axis = "y", degrees = 720 }, selfVelocity = Vector2.new(0, 70),
			windupFx = { "super" }, trail = "prop", fx = { { "toss", shape = "ball", color = Color3.fromRGB(150, 200, 255), count = 8, speed = 12, lift = 45 }, { "symbols", symbols = { "😭", "🧸", "🍼" }, count = 6 } }, text = "OUIIIN !", hitText = "BOING !",
		},
		-- « Encore ! » : il attrape l'adversaire comme un jouet et le fait tourner autour de lui à toute vitesse
		SUPER_down = {
			label = "Encore !", superCost = 100, startup = 0.3, active = 0.9, recovery = 0.5,
			damage = 4, hits = 5, pull = true, hitbox = box(6, 5, 1.5, 1), kbBase = 16, kbGrowth = 20, kbAngle = 80,
			windup = { Root = { 4, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 110, 0, 50 }, RE = { 20, 0, 0 }, LS = { 110, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 10 }, RE = { 10, 0, 0 }, LS = { 120, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.2, 0 }, Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 130, 0, 10 }, RE = { 10, 0, 0 }, LS = { 130, 0, -10 }, LE = { 10, 0, 0 } },
			spin = { axis = "y", degrees = 1080 }, windupFx = { "super" }, fx = { { "symbols", symbols = { "ENCORE !", "😆" }, count = 5, radius = 4, color = YELLOW } },
			text = "ENCORE ! ENCORE !", hitText = "WIIIIZ !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Câlin de bébé : bras grands ouverts, il serre l'adversaire contre son bedon comme un doudou
		GRAB = {
			label = "Câlin de bébé", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4.5, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 120, 0, 70 }, RE = { 10, 0, 0 }, LS = { 120, 0, -70 }, LE = { 10, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.3 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 15 }, RS = { 85, 0, -35 }, RE = { 70, 0, 0 }, LS = { 85, 0, 35 }, LE = { 70, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.18, -0.3 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 18 }, RS = { 88, 0, -40 }, RE = { 75, 0, 0 }, LS = { 88, 0, 40 }, LE = { 75, 0, 0 } },
			fx = { { "symbols", symbols = { "♥" }, count = 3, radius = 2, color = PINK } }, text = "DOUDOU !", hitText = "CÂLIIIN !",
		},
		-- ✋ puis → : Jouet jeté, il secoue le « jouet » au-dessus de sa tête et le jette hors du parc
		THROW_fwd = {
			label = "Jouet jeté", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 20,
			carry = { { 0, 2.4, 0.4 }, { 0.16, 0.5, 3.6 }, { 0.32, 3.8, 1.6 } },
			windup = { Root = { 10, 0, 0, 0, -0.1, 0.25 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 185, 0, 10 }, RE = { 30, 0, 0 }, LS = { 185, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -20, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 90, 0, 10 }, RE = { 5, 0, 0 }, LS = { 90, 0, -10 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.4 }, Waist = { -24, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 15 }, RE = { 5, 0, 0 }, LS = { 75, 0, -15 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			text = "VEUX PLUS !", hitText = "HORS DU PARC !",
		},
		-- ✋ puis ← : Pas mangé !, il jette la victime par-dessus l'épaule comme une assiette de purée qu'il refuse
		THROW_back = {
			label = "Pas mangé !", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.6, 1.0 }, { 0.28, 0.2, 3.8 }, { 0.4, -2.6, 1.6 } },
			windup = { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 80, 0, -20 }, RE = { 60, 0, 0 }, LS = { 80, 0, 20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.2, 0.25 }, Waist = { 25, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 200, 0, 10 }, RE = { 30, 0, 0 }, LS = { 200, 0, -10 }, LE = { 30, 0, 0 } },
			follow = { Root = { 24, 0, 0, 0, -0.2, 0.3 }, Waist = { 28, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 210, 0, 15 }, RE = { 30, 0, 0 }, LS = { 210, 0, -15 }, LE = { 30, 0, 0 } },
			text = "PAS MANGÉ !", hitText = "BEURK !",
		},
		-- ✋ puis ↑ : Avion ! Vroum !, il fait voler la victime au-dessus de sa tête en courant sur place et la lâche vers le ciel
		THROW_up = {
			label = "Avion ! Vroum !", kind = "throw", startup = 0.36, active = 0.08, recovery = 0.38,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 0.5, 4.2 }, { 0.26, -0.5, 4.4 }, { 0.36, 0.5, 4.6 } },
			windup = { Root = { 0, 20, 0, 0, -0.1, 0 }, Waist = { 6, 15, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, LS = { 175, 0, -10 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 0, -20, 0, 0, 0.2, 0 }, Waist = { 10, -15, 0 }, Neck = { 40, 0, 0 }, RS = { 180, 0, 15 }, RE = { 5, 0, 0 }, LS = { 180, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 0, -10, 0, 0, 0.1, 0 }, Waist = { 12, -10, 0 }, Neck = { 45, 0, 0 }, RS = { 170, 0, 40 }, RE = { 10, 0, 0 }, LS = { 170, 0, -40 }, LE = { 10, 0, 0 } },
			text = "VROUUUM !", hitText = "AVION !",
		},
		-- ✋ puis ↓ : Assis sur le doudou, il pose la victime par terre et s'assoit dessus, ravi
		THROW_down = {
			label = "Assis sur le doudou", kind = "throw", startup = 0.42, active = 0.1, hold = 0.25, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, 1.2 }, { 0.3, 0.6, -2.0 }, { 0.42, 0, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 20 }, RE = { 30, 0, 0 }, LS = { 150, 0, -20 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 10, 0, 0, 0, -1.4, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 50 }, RE = { 20, 0, 0 }, LS = { 60, 0, -50 }, LE = { 20, 0, 0 }, RH = { 85, 0, 10 }, RK = { -10, 0, 0 }, LH = { 85, 0, -10 }, LK = { -10, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -1.4, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 160, 0, 30 }, RE = { 20, 0, 0 }, LS = { 160, 0, -30 }, LE = { 20, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } },
			fx = { { "ring", color = DIAPER, radius = 4, at = "feet" }, { "shake", amount = 0.3 } }, text = "ASSIS !", hitText = "ÉCRASÉ !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "le_doudou", label = "Le Doudou", sequence = { "forward", "back", "down" },
			-- l'adversaire rétrécit en peluche toute douce, Bébé le câline et s'endort avec
			scene = {
				{ "fxAttacker", { "text", text = "DOUDOU ?", color = PINK } },
				{ "shrink", 0.4, time = 0.7 },
				{ "color", Color3.fromRGB(190, 140, 100) },
				{ "material", "Fabric" },
				{ "fx", { "symbols", symbols = { "🧸" }, count = 2, radius = 1.5, color = WOOD } },
				{ "text", "PELUCHE !" },
				{ "wait", 0.4 },
				{ "move", to = "attacker", offset = Vector3.new(0, 0.5, -1.2), time = 0.5 },
				{ "fxAttacker", { "symbols", symbols = { "♥", "♥" }, count = 4, color = PINK } },
				{ "wait", 0.6 },
				{ "fxAttacker", { "symbols", symbols = { "Z", "z", "💤" }, count = 6, color = Color3.fromRGB(170, 200, 255) } },
				{ "fxAttacker", { "text", text = "ZZZ…", color = Color3.fromRGB(170, 200, 255) } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "la_berceuse", label = "La Berceuse", sequence = { "down", "forward", "up" },
			-- un mobile géant descend du plafond, l'adversaire y est accroché et tourne en musique
			scene = {
				{ "spawn", at = "above", offset = Vector3.new(0, 4, 0), life = 4.5, pieces = {
					{ "Tige", "", "cyl", Vector3.new(6, 0.2, 0.2), Vector3.new(0, 3, 0), Vector3.zero, WOOD, "Wood" },
					{ "Croisillon", "", "block", Vector3.new(7, 0.25, 0.25), Vector3.zero, Vector3.zero, WOOD, "Wood" },
					{ "Lune", "", "ball", Vector3.new(1.2, 1.2, 0.4), Vector3.new(-3.2, -1.5, 0), Vector3.zero, YELLOW, "SmoothPlastic" },
					{ "Etoile", "", "ball", Vector3.new(1, 1, 0.4), Vector3.new(3.2, -1.5, 0), Vector3.zero, PINK, "SmoothPlastic" },
					{ "Fil", "", "cyl", Vector3.new(2.5, 0.06, 0.06), Vector3.new(0, -1.2, 0), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
				} },
				{ "fxAttacker", { "text", text = "DODO, L'ENFANT DO…", color = BLUE } },
				{ "lift", 5, time = 0.8 },
				{ "fx", { "symbols", symbols = { "♪", "♫" }, count = 6, radius = 4, color = BLUE } },
				{ "spin", 720, time = 1.4, axis = "y" },
				{ "fx", { "symbols", symbols = { "♪", "♫", "💤" }, count = 6, radius = 4, color = PINK } },
				{ "spin", 720, time = 1.4, axis = "y" },
				{ "text", "TOURNI-TOURNA…" },
				{ "wait", 0.5 },
			},
		},
		{
			id = "range", label = "Rangé !", sequence = { "back", "up", "forward" },
			-- jeté dans le coffre à jouets, le couvercle claque
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, -1.5, 0), life = 4, pieces = {
					{ "Coffre", "", "block", Vector3.new(5, 3, 3.5), Vector3.zero, Vector3.zero, BLUE, "Wood" },
					{ "Bande", "", "block", Vector3.new(5.1, 0.4, 3.6), Vector3.new(0, 0.6, 0), Vector3.zero, YELLOW, "Wood" },
					{ "Cube", "", "block", Vector3.new(0.9, 0.9, 0.9), Vector3.new(-1.6, 1.9, 0), Vector3.new(0, 30, 15), PINK, "SmoothPlastic" },
				} },
				{ "fxAttacker", { "text", text = "ON RANGE !", color = YELLOW } },
				{ "lift", 4, time = 0.4 },
				{ "shrink", 0.6, time = 0.3 },
				{ "lift", -4.5, time = 0.35 },
				{ "hide" },
				{ "spawn", at = "target", offset = Vector3.new(0, 0.3, 0), life = 2.5, pieces = {
					{ "Couvercle", "", "block", Vector3.new(5.2, 0.5, 3.7), Vector3.zero, Vector3.zero, BLUE, "Wood" },
				} },
				{ "fx", { "burst", color = YELLOW, size = 4, at = "root" } },
				{ "text", "CLAC !" },
				{ "fxAttacker", { "symbols", symbols = { "😊", "✨" }, count = 4, color = YELLOW } },
				{ "wait", 1.2 },
			},
		},
	},

	-- Mécanique « Caprice » : les coups reçus remplissent la jauge ; pleine, crise de 5 s sans broncher
	passive = { kind = "caprice", name = "Caprice", icon = "😭" },

	-- Recharge ⚡ : assis par terre, il tète un biberon géant à deux mains, puis lâche un rot qui fait trembler l'écran
	charge = {
		label = "Biberon géant",
		loop = 1.8,
		lockWrist = true,
		color = MILK,
		keys = {
			{ 0.0, { Root = { 10, 0, 0, 0, -1.4, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, -15 }, RE = { 115, 0, 0 }, RW = { -100, 0, 0 }, LS = { 135, 0, 15 }, LE = { 115, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 0.3, { Root = { 12, 0, 0, 0, -1.4, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 145, 0, -15 }, RE = { 112, 0, 0 }, RW = { -105, 0, 0 }, LS = { 140, 0, 15 }, LE = { 112, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 0.6, { Root = { 10, 0, 0, 0, -1.4, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, -15 }, RE = { 115, 0, 0 }, RW = { -100, 0, 0 }, LS = { 135, 0, 15 }, LE = { 115, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 0.9, { Root = { 12, 0, 0, 0, -1.4, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 145, 0, -15 }, RE = { 112, 0, 0 }, RW = { -105, 0, 0 }, LS = { 140, 0, 15 }, LE = { 112, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 1.2, { Root = { 4, 0, 0, 0, -1.4, 0.2 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 1.35, { Root = { 16, 0, 0, 0, -1.35, 0.25 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 1.8, { Root = { 10, 0, 0, 0, -1.4, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, -15 }, RE = { 115, 0, 0 }, RW = { -100, 0, 0 }, LS = { 135, 0, 15 }, LE = { 115, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "symbols", symbols = { "🍼" }, count = 1, radius = 1.5, color = MILK } },
			{ 1.35, { "shake", amount = 0.5 } },
			{ 1.35, { "text", text = "BUUURP !", color = YELLOW } },
		},
	},

	-- Manies au repos : il suce son pouce, tape dans ses mains tout content, secoue son hochet près de l'oreille
	fidgets = {
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 6, 0, 8 }, LS = { 110, 0, 25 }, LE = { 140, 0, 0 }, LW = { -20, 0, 0 } } },
			{ 1.6, { Neck = { 10, 0, 12 }, LS = { 112, 0, 25 }, LE = { 142, 0, 0 }, LW = { -20, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 1.8, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { 15, 0, 0 }, RS = { 80, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 0.5, { Neck = { 18, 0, 0 }, RS = { 85, 0, -5 }, RE = { 50, 0, 0 }, LS = { 85, 0, 5 }, LE = { 50, 0, 0 } } },
			{ 0.7, { Neck = { 15, 0, 0 }, RS = { 80, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 0.9, { Neck = { 18, 0, 0 }, RS = { 85, 0, -5 }, RE = { 50, 0, 0 }, LS = { 85, 0, 5 }, LE = { 50, 0, 0 } } },
			{ 1.1, { Neck = { 15, 0, 0 }, RS = { 80, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.8, {} },
		} },
		{ duration = 2.0, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 0, 0, -15 }, RS = { 150, 0, 40 }, RE = { 110, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 0.6, { Neck = { 0, 0, -15 }, RS = { 150, 0, 45 }, RE = { 100, 0, 0 }, RW = { 20, 0, 0 } } },
			{ 0.8, { Neck = { 0, 0, -15 }, RS = { 150, 0, 40 }, RE = { 110, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 1.0, { Neck = { 0, 0, -15 }, RS = { 150, 0, 45 }, RE = { 100, 0, 0 }, RW = { 20, 0, 0 } } },
			{ 1.4, { Neck = { 20, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 } } },
			{ 2.0, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : gros câlin d'ours, bras serrés autour de la victime, joue collée contre elle
data.grabHold = {
	Root = { -6, 0, 0, 0, -0.15, 0 },
	Waist = { -8, 0, 0 },
	Neck = { -10, 0, 15 },
	RS = { 85, 0, -35 },
	RE = { 70, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 85, 0, 35 },
	LE = { 70, 0, 0 },
}

-- Retour 🪂 : il arrive dans un landau volant tiré par des cigognes, en sort à quatre pattes, se dresse et
-- tape sur son torse avec son hochet
data.respawn = {
	duration = 2.0,
	platform = { pieces = {
		{ "Nacelle", "base", "block", Vector3.new(5.5, 1, 3.6), Vector3.new(0, -0.5, 0), Vector3.zero, PINK, "Fabric" },
		{ "BordAvant", "", "block", Vector3.new(5.5, 1.2, 0.25), Vector3.new(0, 0.4, -1.75), Vector3.zero, PINK, "Fabric" },
		{ "BordArriere", "", "block", Vector3.new(5.5, 1.2, 0.25), Vector3.new(0, 0.4, 1.75), Vector3.zero, PINK, "Fabric" },
		{ "Capote", "", "ball", Vector3.new(2.6, 3.6, 3.8), Vector3.new(2.4, 1.2, 0), Vector3.zero, Color3.fromRGB(220, 110, 160), "Fabric" },
		{ "RoueAG", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(-1.9, -1.3, -1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "RoueAD", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(1.9, -1.3, -1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "RoueRG", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(-1.9, -1.3, 1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "RoueRD", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(1.9, -1.3, 1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "Cigogne1", "", "ball", Vector3.new(1.6, 1, 1), Vector3.new(-3.5, 8, 0), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
		{ "Bec1", "", "wedge", Vector3.new(0.3, 0.3, 1), Vector3.new(-4.5, 8.1, 0), Vector3.new(0, 90, 0), Color3.fromRGB(250, 140, 50), "SmoothPlastic" },
		{ "Cigogne2", "", "ball", Vector3.new(1.6, 1, 1), Vector3.new(3.5, 8.6, 0), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
		{ "Bec2", "", "wedge", Vector3.new(0.3, 0.3, 1), Vector3.new(4.5, 8.7, 0), Vector3.new(0, -90, 0), Color3.fromRGB(250, 140, 50), "SmoothPlastic" },
		{ "Ruban1", "", "cyl", Vector3.new(7.5, 0.06, 0.06), Vector3.new(-2.2, 4.3, 0), Vector3.new(0, 0, 18), Color3.fromRGB(255, 240, 240), "SmoothPlastic" },
		{ "Ruban2", "", "cyl", Vector3.new(7.8, 0.06, 0.06), Vector3.new(2.2, 4.6, 0), Vector3.new(0, 0, -18), Color3.fromRGB(255, 240, 240), "SmoothPlastic" },
	} },
	keys = {
		{ 0.0, { Root = { -55, 0, 0, 0, -1.1, 0 }, Waist = { -10, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 60, 0, 15 }, RE = { 10, 0, 0 }, LS = { 60, 0, -15 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } } },
		{ 0.35, { Root = { -55, 0, 0, 0, -1.1, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 80, 0, 15 }, RE = { 10, 0, 0 }, LS = { 45, 0, -15 }, LE = { 10, 0, 0 }, RH = { 45, 0, 0 }, RK = { -80, 0, 0 }, LH = { 75, 0, 0 }, LK = { -100, 0, 0 } } },
		{ 0.7, { Root = { -55, 0, 0, 0, -1.1, -0.4 }, Waist = { -10, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 45, 0, 15 }, RE = { 10, 0, 0 }, LS = { 80, 0, -15 }, LE = { 10, 0, 0 }, RH = { 75, 0, 0 }, RK = { -100, 0, 0 }, LH = { 45, 0, 0 }, LK = { -80, 0, 0 } } },
		{ 1.05, { Root = { 0, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 20, 0, 0 }, LS = { 160, 0, -40 }, LE = { 20, 0, 0 } } },
		{ 1.25, { Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 70, 0, -30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 30 }, LE = { 120, 0, 0 } } },
		{ 1.4, { Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 90, 0, 0 } } },
		{ 1.55, { Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 70, 0, -30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 30 }, LE = { 120, 0, 0 } } },
		{ 1.7, { Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 90, 0, 0 } } },
		{ 2.0, {} },
	},
	beats = {
		{ 0.1, { "symbols", symbols = { "♪", "🍼" }, count = 3, radius = 3, at = "above", color = PINK } },
		{ 1.05, { "burst", color = YELLOW, size = 3, at = "head" } },
		{ 1.25, { "text", text = "BÉBÉ FORT !", color = YELLOW } },
		{ 1.4, { "shake", amount = 0.3 } },
	},
}

-- Arbre d'enchaînements : après le coup de gauche, le bouton (avec sa direction) lance le coup de droite.
-- Les chaînes finissent sur S : Caprice tape-sol (fait décoller) ou Petit cri (éjecte à l'horizontale).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- hochet maladroit, hochet retour, gros hochet
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side", S = "S_finish_cri" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", up_K = "K_up", S = "S_finish_caprice" },
	P_combo3 = { K = "K_combo3", S = "S_finish_cri" },
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_caprice" },
	-- petit pied potelé, petit pied gauche, coup de pied colère
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_cri" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_caprice" },
	K_combo3 = { K = "K_air_side", P = "P_air_side", S = "S_air" }, -- il décolle : la suite se joue en l'air
	KP_combo = { P = "P_combo3", K = "K_combo3", S = "S_finish_cri" },
	-- avec une flèche
	P_side = { P = "P_combo2", K = "K_side", S = "S_finish_cri" },
	P_down = { P = "P_up", K = "K_up", S = "S_finish_caprice" },
	P_up = { K = "K_up", S = "S_finish_caprice" },
	K_side = { P = "KP_combo", S = "S_finish_cri" },
	K_down = { P = "P_up", K = "K_up", S = "S_finish_caprice" },
	K_up = { S = "S_finish_caprice" },
	P_dash = { P = "P_combo3", K = "K_side", S = "S_finish_cri" },
	K_dash = { P = "P_up", K = "K_up", S = "S_finish_caprice" },
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

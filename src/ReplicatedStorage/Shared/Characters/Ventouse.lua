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

local data = {
	id = "Ventouse",
	name = "Madame Ventouse",
	costume = "Ventouse",
	style = "plumber",

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
			damage = 6, hitbox = box(4.5, 2.5, 3, -0.6), kbBase = 20, kbGrowth = 28, kbAngle = 30,
			windup = { Root = { 6, -5, 0, 0, -0.15, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { 85, 0, 0 }, RK = { -110, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.1, -0.1 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 10, 0, 40 }, RE = { 50, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { 80, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 16, 0, 0, 0, -0.1, -0.12 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 5, 0, 42 }, RE = { 50, 0, 0 }, LS = { 52, 0, -42 }, LE = { 70, 0, 0 }, RH = { 84, 0, 0 }, RK = { -2, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", hitText = "BOTTE !",
		},
		-- Bonk de ventouse (P P P) : ventouse levée à deux mains au-dessus de la casquette puis plaquée devant
		P_combo3 = {
			label = "Bonk de ventouse", startup = 0.12, active = 0.1, recovery = 0.28,
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
			damage = 6, hitbox = box(5.5, 3, 3, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 25, selfVelocity = Vector2.new(12, 0),
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
			damage = 7, hitbox = box(4, 5, 1.2, 3.8), kbBase = 28, kbGrowth = 45, kbAngle = 88, selfVelocity = Vector2.new(0, 30),
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
			label = "Genou de chantier", startup = 0.14, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(4, 3, 2.5, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 40,
			windup = { Root = { 6, -8, 0, 0, -0.2, 0.15 }, Waist = { 8, -6, 0 }, RS = { 110, 0, 25 }, RE = { 40, 0, 0 }, LS = { 110, 0, -25 }, LE = { 40, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, 0.05, -0.3 }, Waist = { -14, 6, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 15 }, RE = { 90, 0, 0 }, LS = { 60, 0, -15 }, LE = { 90, 0, 0 }, RH = { 112, 0, 0 }, RK = { -125, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -12, 8, 0, 0, 0.08, -0.35 }, Waist = { -16, 8, 0 }, Neck = { -12, 0, 0 }, RS = { 52, 0, 12 }, RE = { 100, 0, 0 }, LS = { 52, 0, -12 }, LE = { 100, 0, 0 }, RH = { 118, 0, 0 }, RK = { -128, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightLeg", hitText = "GNOC !",
		},
		-- Uppercut à la clé (K K K) : de l'accroupi, la clé à molette remonte sous le menton, elle décolle
		K_combo3 = {
			label = "Uppercut à la clé", startup = 0.15, active = 0.1, recovery = 0.3,
			damage = 12, hitbox = box(4, 5, 2, 2.5), kbBase = 32, kbGrowth = 80, kbAngle = 82, selfVelocity = Vector2.new(5, 35),
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
		-- Double botte (K en l'air) : genoux repliés puis les deux bottes jaunes partent devant
		K_air = {
			label = "Double botte", startup = 0.17, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 70, 0, 40 }, RE = { 70, 0, 0 }, LS = { 70, 0, -40 }, LE = { 70, 0, 0 }, RH = { 100, 0, 0 }, RK = { -135, 0, 0 }, LH = { 95, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 22, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -40, 0, 45 }, RE = { 30, 0, 0 }, LS = { -40, 0, -45 }, LE = { 30, 0, 0 }, RH = { 88, 0, 5 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 84, 0, -5 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 26, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -48, 0, 50 }, RE = { 30, 0, 0 }, LS = { -48, 0, -50 }, LE = { 30, 0, 0 }, RH = { 94, 0, 5 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 90, 0, -5 }, LK = { -2, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", hitText = "BOING BOING !",
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
		-- Botte au tibia (P puis K) : petit coup de pointe de botte, bien sec, sous la garde
		PK_combo = {
			label = "Botte au tibia", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 2, 3, -1.5), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 6, -12, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 }, RH = { -20, 0, 8 }, RK = { -70, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.3, -0.2 }, Waist = { -8, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 45 }, RE = { 40, 0, 0 }, LS = { 70, 0, -35 }, LE = { 60, 0, 0 }, RH = { 60, 0, 6 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.32, -0.25 }, Waist = { -10, 10, 0 }, Neck = { -8, 0, 0 }, RS = { 15, 0, 48 }, RE = { 40, 0, 0 }, LS = { 72, 0, -35 }, LE = { 60, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- Clé dans les côtes (K puis P) : elle pivote et pique la clé à molette dans les côtes
		KP_combo = {
			label = "Clé dans les côtes", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4, 3, 2.2, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, 25, 0, 0, -0.25, 0.15 }, Waist = { 4, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 25 }, RE = { 70, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.35, -0.35 }, Waist = { -10, -28, 0 }, Neck = { 0, 15, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 }, LS = { 90, 0, 15 }, LE = { 15, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -9, -24, 0, 0, -0.36, -0.38 }, Waist = { -11, -32, 0 }, Neck = { 0, 18, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 }, LS = { 92, 0, 20 }, LE = { 12, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "cle", trail = "leftHand", hitText = "CRIC !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Jet de fuite : elle brandit une valve et tourne le volant, l'eau part en cloche et trempe l'adversaire
		S_neutral = {
			label = "Jet de fuite", kind = "projectile", energyCost = 20, startup = 0.18, active = 0, recovery = 0.3,
			damage = 9, kbBase = 22, kbGrowth = 40, kbAngle = 45,
			projectile = { speed = 45, angle = 50, gravity = 85, lifetime = 1.4, size = 1.8, color = WATER, visual = "water" },
			status = { name = "wet", duration = 2 },
			windup = { Root = { 0, -10, 0, 0, -0.2, 0.1 }, Waist = { 0, -14, 0 }, Neck = { 4, 0, 0 }, RS = { 70, 0, -25 }, RE = { 80, 0, 0 }, LS = { 110, 0, 10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, 8, 0, 0, -0.25, -0.15 }, Waist = { 4, 10, 0 }, Neck = { 14, 0, 0 }, RS = { 75, 0, -35 }, RE = { 95, 0, 0 }, LS = { 135, 0, 5 }, LE = { 10, 0, 0 } },
			follow = { Root = { -4, 10, 0, 0, -0.25, -0.12 }, Waist = { 6, 12, 0 }, Neck = { 18, 0, 0 }, RS = { 72, 0, -30 }, RE = { 100, 0, 0 }, LS = { 138, 0, 5 }, LE = { 10, 0, 0 } },
			shake = true, prop = "valve", windupFx = { { "particles", tex = "smoke", color = WATER, dir = "up", at = "lhand", time = 0.15, speed = 4 } },
			text = "ÇA FUIT !", hitText = "SPLASH !",
		},
		-- Ventouse grappin : elle lance la ventouse comme un harpon ; un adversaire est ramené, un mur la tire à lui
		S_side = {
			label = "Ventouse grappin", kind = "grapple", energyCost = 25, startup = 0.14, active = 0.2, recovery = 0.3,
			damage = 7, kbBase = 20, kbGrowth = 20, kbAngle = 20,
			grapple = { range = 28, angle = 0, speed = 85, pullEnemy = true },
			windup = { Root = { 4, -25, 0, 0, -0.25, 0.25 }, Waist = { 6, -25, 0 }, Neck = { 0, 20, 0 }, RS = { -30, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -14, 20, 0, 0, -0.4, -0.45 }, Waist = { -12, 25, 0 }, Neck = { 0, -15, 0 }, RS = { 95, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 10, 10, 0, 0, -0.3, 0.2 }, Waist = { 10, 12, 0 }, Neck = { 6, -6, 0 }, RS = { 75, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 70, 0, 0 } },
			trail = "prop", text = "ACCROCHÉ !", hitText = "SHLOOP !",
		},
		-- Inondation : accroupie, elle ouvre la valve à ras du sol ; la mare glissante renverse qui marche dedans
		S_down = {
			label = "Inondation", kind = "trap", energyCost = 25, startup = 0.2, active = 0, recovery = 0.35,
			damage = 6, kbBase = 30, kbGrowth = 35, kbAngle = 80,
			status = { name = "slippery", duration = 2 },
			trap = { size = Vector3.new(7, 1, 6), offset = 3, lifetime = 5, max = 1, persist = true, color = WATER,
				-- flaque à plat sur le sol
				visual = { shape = "ball", size = 0.5, color = WATER, transparency = 0.3, trail = false, parts = {
					{ "block", Vector3.new(6.5, 0.12, 3), Vector3.new(0, -0.3, 0), WATER },
					{ "ball", Vector3.new(1.2, 0.2, 1.2), Vector3.new(2.6, -0.25, 0.6), WATER },
					{ "ball", Vector3.new(1.0, 0.2, 1.0), Vector3.new(-2.8, -0.25, -0.5), WATER },
				} } },
			windup = { Root = { -6, 10, 0, 0, -0.6, 0.1 }, Waist = { -20, 10, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 60, 0, 0 }, LS = { 45, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -10, -10, 0, 0, -0.85, -0.1 }, Waist = { -28, -10, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, -30 }, RE = { 70, 0, 0 }, LS = { 30, 0, -5 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -4, -5, 0, 0, -0.5, 0.05 }, Waist = { -10, -5, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -10 }, LE = { 30, 0, 0 } },
			prop = "valve", fx = { { "puddle", color = WATER, width = 7 }, { "particles", tex = "smoke", color = WATER, dir = "up", at = "front", time = 0.3, speed = 8 } },
			text = "INONDATION !", hitText = "GLISSADE !",
		},
		-- Ventouse au plafond (remontée, gratuite) : elle tire le grappin tout droit vers le haut et se hisse
		S_up = {
			label = "Ventouse au plafond", kind = "grapple", energyCost = 0, startup = 0.06, active = 0.25, recovery = 0.3,
			damage = 0, kbBase = 0, kbGrowth = 0, kbAngle = 90, selfVelocity = Vector2.new(6, 70),
			grapple = { range = 34, angle = 90, speed = 95, pullEnemy = false },
			windup = { Root = { 0, 0, 0, 0, -0.5, 0 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.3, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 180, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, RA = { -20, 0, 0 }, LH = { -5, 0, 0 }, LK = { -20, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 2, 0, 0, 0, 0.35, 0 }, Waist = { 10, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 168, 0, -10 }, LE = { 45, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			trail = "prop", text = "AU PLAFOND !",
		},
		-- Chute ventouse (↓S en l'air) : ventouse pointée vers le sol à deux mains, elle s'y colle (POP !) et fait une onde
		S_air_down = {
			label = "Chute ventouse", energyCost = 25, startup = 0.12, active = 0.35, recovery = 0.32,
			damage = 11, hitbox = box(6, 4, 0.5, -2), kbBase = 26, kbGrowth = 55, kbAngle = -65, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, 20 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -14, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 25, 0, 20 }, LE = { 20, 0, 0 }, RH = { 60, 0, 10 }, RK = { -100, 0, 0 }, LH = { 60, 0, -10 }, LK = { -100, 0, 0 } },
			follow = { Root = { -16, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 15, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, 20 }, LE = { 20, 0, 0 }, RH = { 55, 0, 12 }, RK = { -95, 0, 0 }, LH = { 55, 0, -12 }, LK = { -95, 0, 0 } },
			trail = "prop", fx = { { "ring", color = RUBBER, radius = 5, at = "feet" }, { "particles", tex = "smoke", color = WATER, dir = "all", at = "feet", time = 0.3, speed = 10 } },
			text = "POP !", hitText = "SPLOUTCH !",
		},
		-- Grappin mural (ESQUIVE puis S) : elle lance la ventouse derrière elle, sur le mur, et s'y propulse
		S_dodge = {
			label = "Grappin mural", kind = "grapple", energyCost = 20, startup = 0.08, active = 0.2, recovery = 0.25,
			damage = 0, kbBase = 0, kbGrowth = 0, kbAngle = 0, selfVelocity = Vector2.new(-30, 18),
			grapple = { range = 30, angle = 175, speed = 85, pullEnemy = false },
			windup = { Root = { 0, -20, 0, 0, -0.3, 0 }, Waist = { 0, -25, 0 }, Neck = { 0, -40, 0 }, RS = { 80, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 10, -35, 0, 0, -0.2, 0.3 }, Waist = { 8, -35, 0 }, Neck = { 6, -60, 0 }, RS = { -70, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -40 }, LE = { 30, 0, 0 } },
			follow = { Root = { 14, -30, 0, 0, -0.2, 0.4 }, Waist = { 10, -30, 0 }, Neck = { 8, -55, 0 }, RS = { -60, 0, 25 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -45 }, LE = { 30, 0, 0 } },
			trail = "prop", text = "HOP, AU MUR !",
		},
		-- Pression (S maintenu) : genou à terre, elle ouvre la valve à fond ; un geyser jaillit devant elle
		S_hold = {
			label = "Pression", energyCost = 35, startup = 0.35, active = 0.2, recovery = 0.45,
			damage = 15, hitbox = box(4, 11, 3.5, 4), kbBase = 34, kbGrowth = 80, kbAngle = 88,
			status = { name = "wet", duration = 2 },
			windup = { Root = { -6, 15, 0, 0, -0.85, 0 }, Waist = { -20, 15, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -20 }, RE = { 90, 0, 0 }, LS = { 50, 0, -10 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.4 } },
			strike = { Root = { 10, -5, 0, 0, -0.3, 0.4 }, Waist = { 12, -5, 0 }, Neck = { 25, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 } },
			follow = { Root = { 12, -5, 0, 0, -0.25, 0.45 }, Waist = { 14, -5, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 50 }, RE = { 20, 0, 0 }, LS = { 160, 0, -50 }, LE = { 20, 0, 0 } },
			shake = true, prop = "valve",
			windupFx = { { "particles", tex = "smoke", color = WATER, dir = "up", at = "front", time = 0.3, speed = 5 } },
			fx = { { "pillar", color = WATER, height = 14, width = 2.5, at = "front" }, { "shake", amount = 0.4 } },
			text = "PLEINE PRESSION !", hitText = "GEYSER !",
		},
		-- Glissade dans un tuyau (→→S) : elle plonge à plat ventre et file au ras du sol, sous l'adversaire
		S_dash = {
			label = "Glissade dans un tuyau", energyCost = 20, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 8, hitbox = box(5, 2, 1.5, -1.5), kbBase = 30, kbGrowth = 45, kbAngle = 80, selfVelocity = Vector2.new(75, 0), invuln = 0.35,
			windup = { Root = { -20, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 20 }, RE = { 20, 0, 0 }, LS = { 120, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -72, 0, 0, 0, -1.6, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -10 }, LE = { 0, 0, 0 }, RH = { -10, 0, 0 }, RK = { -10, 0, 0 }, RA = { -40, 0, 0 }, LH = { -10, 0, 0 }, LK = { -15, 0, 0 }, LA = { -40, 0, 0 } },
			follow = { Root = { -75, 0, 0, 0, -1.65, 0 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -12, 0, 3 }, RK = { -15, 0, 0 }, RA = { -40, 0, 0 }, LH = { -8, 0, -3 }, LK = { -10, 0, 0 }, LA = { -40, 0, 0 } },
			trail = "body", fx = { { "puddle", color = WATER, width = 6 } }, text = "PAR LES TUYAUX !", hitText = "ZLOUP !",
		},
		-- Ventouse volante (S en l'air) : elle tire la ventouse en diagonale vers le bas et ramène ce qu'elle accroche
		S_air = {
			label = "Ventouse volante", kind = "grapple", energyCost = 20, startup = 0.12, active = 0.2, recovery = 0.3,
			damage = 7, kbBase = 20, kbGrowth = 25, kbAngle = 30,
			grapple = { range = 26, angle = -35, speed = 85, pullEnemy = true },
			windup = { Root = { -6, -15, 0 }, Waist = { -8, -15, 0 }, Neck = { 0, 10, 0 }, RS = { 150, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -10, 15, 0 }, Waist = { -14, 18, 0 }, Neck = { -10, -10, 0 }, RS = { 60, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 4, 10, 0 }, Waist = { 4, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 70, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -45 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -85, 0, 0 } },
			trail = "prop", text = "VIENS PAR ICI !", hitText = "SHLOOP !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- POP de ventouse : elle colle la ventouse sur l'adversaire, pousse, tire… POP ! Il reste collé sur place
		S_finish_pop = {
			label = "POP de ventouse", energyCost = 20, startup = 0.12, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4.5, 3.5, 3, 0.6), kbBase = 15, kbGrowth = 20, kbAngle = 20,
			status = { name = "rooted", duration = 1 },
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.25 }, Waist = { 8, -12, 0 }, Neck = { 0, 6, 0 }, RS = { 80, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 25 }, LE = { 95, 0, 0 } },
			strike = { Root = { -12, 6, 0, 0, -0.35, -0.4 }, Waist = { -12, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 22 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { 10, 0, 0, 0, -0.25, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 80, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 78, 0, 25 }, LE = { 65, 0, 0 } },
			hold = 0.1, trail = "prop", fx = { { "burst", color = RUBBER, size = 2.5, at = "front" } }, text = "ET… POP !", hitText = "COLLÉ !",
		},
		-- Coup de pression : la valve pointée devant, un jet droit et puissant
		S_finish_jet = {
			label = "Coup de pression", kind = "projectile", energyCost = 20, startup = 0.13, active = 0, recovery = 0.28,
			damage = 9, kbBase = 32, kbGrowth = 60, kbAngle = 30,
			projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.35, size = 2, color = WATER, visual = "water" },
			windup = { Root = { 2, -12, 0, 0, -0.2, 0.15 }, Waist = { 2, -15, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, -20 }, RE = { 80, 0, 0 }, LS = { 70, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 10, 10, 0, 0, -0.25, 0.2 }, Waist = { 10, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 75, 0, -30 }, RE = { 85, 0, 0 }, LS = { 92, 0, 5 }, LE = { 0, 0, 0 } },
			follow = { Root = { 12, 12, 0, 0, -0.25, 0.28 }, Waist = { 12, 14, 0 }, Neck = { 8, -10, 0 }, RS = { 72, 0, -28 }, RE = { 85, 0, 0 }, LS = { 98, 0, 5 }, LE = { 0, 0, 0 } },
			prop = "valve", shake = true, text = "PSCHHHT !", hitText = "SPLAF !",
		},

		------------------------------------------------------------------ Supers
		-- Rupture de canalisation : elle frappe le sol de toutes ses forces avec la ventouse, les geysers jaillissent partout
		SUPER = {
			label = "Rupture de canalisation !", superCost = 100, startup = 0.45, active = 0.3, recovery = 0.5,
			damage = 10, hits = 2, hitbox = box(60, 10, 0, 3), kbBase = 30, kbGrowth = 50, kbAngle = 88,
			status = { name = "wet", duration = 2 },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 190, 0, 5 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, 15 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.9, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 20 }, LE = { 20, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.95, -0.32 }, Waist = { -32, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 28, 0, 20 }, LE = { 20, 0, 0 } },
			hold = 0.3, windupFx = { "super" },
			fx = { { "pillar", color = WATER, height = 16, width = 3, at = "front" }, { "pillar", color = WATER, height = 12, width = 2, at = "root" },
				{ "rain", shape = "ball", color = WATER, count = 16, radius = 14, size = 0.6 }, { "screen", color = WATER, alpha = 0.3 }, { "shake", amount = 0.7 } },
			text = "RUPTURE DE CANALISATION !", hitText = "GEYSER !",
		},
		-- Le Grand Débouchage : une ventouse gigantesque qui aspire tout devant elle (projectiles compris) puis recrache
		SUPER_down = {
			label = "Le Grand Débouchage !", kind = "absorb", superCost = 100, startup = 0.4, active = 0.5, recovery = 0.6,
			damage = 22, hitbox = box(14, 8, 7, 1), kbBase = 40, kbGrowth = 70, kbAngle = 35,
			absorb = { radius = 8, offset = 5 },
			windup = { Root = { 8, -15, 0, 0, -0.2, 0.3 }, Waist = { 14, -15, 0 }, Neck = { 10, 10, 0 }, RS = { 175, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, 30 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 10, 0, 0, -0.5, -0.3 }, Waist = { -20, 10, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 25 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 12, 0, 0, 0, -0.3, 0.3 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 80, 0, 5 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 25 }, LE = { 60, 0, 0 } },
			hold = 0.3, prop = "geante", hideProp = "ventouse", windupFx = { "super" },
			fx = { { "particles", tex = "smoke", color = Color3.fromRGB(200, 220, 240), dir = "front", at = "front", time = 0.5, speed = 14 }, { "ring", color = RUBBER, radius = 6, at = "front" }, { "shake", amount = 0.5 } },
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
	-- au sol, sans direction
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side2", S = "S_finish_pop" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", S = "S_finish_jet" }, -- P P
	P_combo3 = { K = "K_combo3", S = "S_finish_pop" }, -- P P P
	PK_combo = { P = "KP_combo", K = "K_combo2", S = "S_finish_jet" }, -- P K
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_pop" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_jet" }, -- K K
	K_combo3 = { K = "K_air_side", P = "P_air", S = "S_air" }, -- K K K : elle décolle
	KP_combo = { K = "K_combo3", P = "P_side2", S = "S_finish_pop" }, -- K P
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_pop" },
	P_side2 = { K = "PK_combo", P = "P_combo3", S = "S_finish_jet" },
	P_down = { P = "P_up2", K = "K_down", S = "S_finish_pop" },
	P_up = { P = "P_up2", K = "K_up", S = "S_finish_jet" },
	P_up2 = { P = "P_air_up", K = "K_air_up", S = "S_air" },
	K_side = { P = "KP_combo", S = "S_finish_jet" },
	K_down = { P = "P_up2", S = "S_finish_pop" },
	K_up = { P = "P_up2", S = "S_finish_jet" },
	P_dash = { P = "P_side2", K = "K_combo2", S = "S_finish_pop" },
	K_dash = { P = "KP_combo", S = "S_finish_jet" },
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

-- Dr Fraise, dentiste : blouse blanche, lampe frontale et sourire éblouissant ; il contrôle le terrain au gaz
-- hilarant (fou rire : ni K ni ⭐). Arme sortie de la Caisse Bizarre : fraise géante (et son miroir dentaire).
--
-- Même format que Gege.lua (voir l'en-tête de ce fichier et docs/fiche-perso.md).
-- Le bras droit tient la fraise ; la main gauche sort les petits instruments (miroir, fil, seringue, pince…)
-- le temps d'un coup (accessoires cachés, champ prop).

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

local data = {
	id = "Fraise",
	name = "Dr Fraise",
	costume = "Fraise",
	style = "doctor",

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
			damage = 5, hitbox = box(4, 3, 2.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { -2, -20, 0, 0, -0.1, -0.2 }, Waist = { -3, -22, 0 }, LS = { 80, 0, 35 }, LE = { 90, 0, 0 }, LW = { -20, 0, 0 }, RS = { 25, 0, 22 }, RE = { 80, 0, 0 } },
			strike = { Root = { -4, 14, 0, 0, -0.12, -0.3 }, Waist = { -4, 18, 0 }, Neck = { 0, -8, 0 }, LS = { 92, 0, -35 }, LE = { 8, 0, 0 }, LW = { 10, 0, 0 }, RS = { 30, 0, 18 }, RE = { 75, 0, 0 } },
			follow = { Root = { -4, 20, 0, 0, -0.12, -0.32 }, Waist = { -4, 24, 0 }, Neck = { 0, -10, 0 }, LS = { 88, 0, -55 }, LE = { 12, 0, 0 }, LW = { 20, 0, 0 }, RS = { 30, 0, 18 }, RE = { 75, 0, 0 } },
			prop = "miroir", trail = "leftHand", hitText = "TINK TINK !",
		},
		-- P P P : coup de fraise piqué de haut en bas, comme sur une molaire récalcitrante
		P_combo3 = {
			label = "Fraisage de molaire", startup = 0.13, active = 0.1, recovery = 0.3,
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
			damage = 7, hitbox = box(4, 3, 2, 0.8), kbBase = 24, kbGrowth = 36, kbAngle = 30,
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
			label = "Talon de sabot", startup = 0.15, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(5, 3, 3, 0.3), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 4, -40, 0, 0, -0.15, 0.1 }, Waist = { 4, -24, 0 }, Neck = { 0, 30, 0 }, RS = { 30, 0, 50 }, RE = { 90, 0, 0 }, LS = { 30, 0, -50 }, LE = { 90, 0, 0 }, RH = { 60, 0, 30 }, RK = { -100, 0, 0 } },
			strike = { Root = { 12, 30, 0, 0, -0.1, 0 }, Waist = { 8, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 30, 0, 70 }, RE = { 40, 0, 0 }, LS = { 40, 0, -60 }, LE = { 60, 0, 0 }, RH = { 88, 0, 40 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 14, 40, 0, 0, -0.1, 0 }, Waist = { 10, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 28, 0, 72 }, RE = { 40, 0, 0 }, LS = { 42, 0, -62 }, LE = { 60, 0, 0 }, RH = { 84, 0, 30 }, RK = { -6, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", hitText = "CLOC !",
		},
		-- K K K : grand coup de pied retourné, il tourne sur lui-même blouse au vent
		K_combo3 = {
			label = "Ordonnance retournée", startup = 0.18, active = 0.14, recovery = 0.34,
			damage = 13, hitbox = box(5.5, 3.5, 2.8, 0.6), kbBase = 34, kbGrowth = 84, kbAngle = 38,
			windup = { Root = { 4, -60, 0, 0, -0.25, 0.1 }, Waist = { 4, -30, 0 }, Neck = { 0, 40, 0 }, RS = { 50, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -100, 0, 0 } },
			strike = { Root = { 22, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, 80 }, RE = { 10, 0, 0 }, LS = { 50, 0, -80 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 25, 0, 0, 0, -0.1, 0 }, Waist = { 7, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 35, 0, 85 }, RE = { 10, 0, 0 }, LS = { 45, 0, -85 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", text = "SUIVANT !", hitText = "VLAN !",
		},
		-- K puis P : coup de fraise remontant, de la hanche vers le menton
		KP_combo = {
			label = "Fraise remontante", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 8, hitbox = box(4, 4.5, 2.4, 1.8), kbBase = 28, kbGrowth = 42, kbAngle = 70,
			windup = { Root = { -6, -16, 0, 0, -0.45, 0.1 }, Waist = { -14, -16, 0 }, RS = { -20, 0, 25 }, RE = { 50, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 110, 0, 0 } },
			strike = { Root = { 6, 12, 0, 0, 0, -0.25 }, Waist = { 12, 16, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 8 }, RE = { 20, 0, 0 }, RW = { 70, 0, 0 }, LS = { 10, 0, -40 }, LE = { 110, 0, 0 } },
			follow = { Root = { 8, 15, 0, 0, 0.05, -0.3 }, Waist = { 15, 20, 0 }, Neck = { 16, 0, 0 }, RS = { 165, 0, 4 }, RE = { 15, 0, 0 }, RW = { 70, 0, 0 }, LS = { 5, 0, -42 }, LE = { 110, 0, 0 } },
			trail = "prop", hitText = "BZZIP !",
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
		-- Gaz hilarant : il ouvre la bonbonne, une grosse bulle rose reste en suspens devant lui (fou rire)
		S_neutral = {
			label = "Bulle de gaz hilarant", energyCost = 25, kind = "projectile", startup = 0.18, active = 0, recovery = 0.32,
			damage = 5, kbBase = 12, kbGrowth = 10, kbAngle = 45,
			projectile = { speed = 18, angle = 0, gravity = 0, lifetime = 0.5, linger = 2.5, size = 3.5, color = GAS, pierce = true,
				visual = { shape = "ball", size = 3.2, color = GAS, transparency = 0.45, spin = 2, text = "HA" } },
			status = { name = "laughing", duration = 3 },
			windup = { Root = { 0, 12, 0, 0, -0.1, 0.1 }, Waist = { 2, 10, 0 }, Neck = { 6, -10, 0 }, LS = { 70, 0, -10 }, LE = { 110, 0, 0 }, LW = { 30, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -4, -4, 0, 0, -0.15, -0.1 }, Waist = { -4, -6, 0 }, Neck = { 10, 0, 0 }, LS = { 90, 0, 10 }, LE = { 20, 0, 0 }, LW = { -30, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			follow = { Root = { -4, -6, 0, 0, -0.15, -0.12 }, Waist = { -4, -8, 0 }, Neck = { 12, 0, 0 }, LS = { 92, 0, 14 }, LE = { 15, 0, 0 }, LW = { -40, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			hold = 0.1, windupFx = { { "particles", tex = "smoke", color = GAS, at = "lhand", dir = "front", time = 0.2, rate = 50, speed = 5, size = 0.8 } },
			fx = { { "symbols", symbols = { "HA", "HI", "HO" }, color = GAS, count = 5, radius = 3, at = "front" } },
			text = "PSSSHH…", hitText = "HAHAHA !",
		},
		-- Fraise perforante : il charge la fraise à deux mains puis fonce, la roulette géante grignote quatre fois
		S_side = {
			label = "Fraise perforante", energyCost = 30, startup = 0.22, active = 0.32, recovery = 0.34, hits = 4,
			damage = 3.5, hitbox = box(5, 3, 3, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 28, selfVelocity = Vector2.new(55, 0),
			windup = { Root = { 6, -16, 0, 0, -0.3, 0.35 }, Waist = { 8, -18, 0 }, Neck = { 0, 10, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, RW = { 80, 0, 0 }, LS = { 50, 0, 10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.4, -0.4 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, -4 }, RE = { 0, 0, 0 }, RW = { 88, 0, 0 }, LS = { 85, 0, 22 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -20, 0, 0, 0, -0.42, -0.45 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 92, 0, -4 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 88, 0, 20 }, LE = { 18, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, wobble = true, trail = "prop",
			windupFx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.2, rate = 60, speed = 6, size = 0.3 } },
			fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "front", time = 0.32, rate = 120, speed = 14, size = 0.35 } },
			text = "BZZZZZZ !", hitText = "PERFORÉ !",
		},
		-- Bain de bouche : il gargarise, se penche et crache une grande flaque bleue glissante au sol
		S_down = {
			label = "Bain de bouche", energyCost = 25, kind = "trap", startup = 0.2, active = 0.1, recovery = 0.3,
			damage = 4, kbBase = 10, kbGrowth = 10, kbAngle = 20,
			status = { name = "slippery", duration = 2.5 },
			trap = { size = Vector3.new(6, 1.5, 6), offset = 3.5, lifetime = 8, max = 2, color = RINSE,
				visual = { shape = "disc", size = 5, color = RINSE, transparency = 0.35, trail = false } },
			windup = { Root = { 8, 0, 0, 0, -0.05, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, LS = { 110, 0, -10 }, LE = { 120, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.15 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.18 }, Waist = { -26, 0, 0 }, Neck = { -24, 0, 0 }, LS = { 25, 0, -42 }, LE = { 60, 0, 0 }, RS = { 18, 0, 42 }, RE = { 60, 0, 0 } },
			prop = "gobelet", shake = true, fx = { { "puddle", color = RINSE, width = 6 } }, text = "GLOUGLOU… PTOU !",
		},
		-- Fauteuil éjectable (remontée, gratuite) : accroupi, un fauteuil jaillit du sol et le catapulte en l'air
		S_up = {
			label = "Fauteuil éjectable", energyCost = 0, startup = 0.06, active = 0.28, recovery = 0.3,
			damage = 7, hitbox = box(5, 6, 0.5, 2), kbBase = 30, kbGrowth = 40, kbAngle = 82, selfVelocity = Vector2.new(8, 88),
			windup = { Root = { -6, 0, 0, 0, -0.9, 0 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, LS = { 170, 0, -20 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { -90, 0, 0 }, LH = { 80, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.3, 0 }, Waist = { 12, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 178, 0, 25 }, RE = { 10, 0, 0 }, LS = { 178, 0, -25 }, LE = { 10, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
			fx = { { "pillar", color = CHAIR, height = 7, width = 3, time = 0.5 }, { "burst", color = SPARK, size = 3, at = "feet" } },
			text = "ÉJECTION !", hitText = "BOING !",
		},
		-- Lasso de fil dentaire (esquive puis S) : il fait tourner le fil au-dessus de sa tête et le lance au loin
		S_dodge = {
			label = "Lasso de fil dentaire", energyCost = 25, kind = "grapple", startup = 0.16, active = 0.1, recovery = 0.3,
			damage = 7, kbBase = 22, kbGrowth = 20, kbAngle = 15,
			grapple = { range = 24, angle = 0, speed = 80, pullEnemy = true },
			windup = { Root = { 2, 10, 0, 0, -0.15, 0.1 }, Waist = { 4, 8, 0 }, Neck = { 10, 0, 0 }, LS = { 170, 0, -30 }, LE = { 40, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -8, -10, 0, 0, -0.25, -0.2 }, Waist = { -8, -12, 0 }, Neck = { 0, 6, 0 }, LS = { 95, 0, 5 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, RS = { 20, 0, 30 }, RE = { 70, 0, 0 } },
			follow = { Root = { 6, 4, 0, 0, -0.2, 0.2 }, Waist = { 8, 4, 0 }, Neck = { 6, 0, 0 }, LS = { 60, 0, -20 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 30 }, RE = { 70, 0, 0 } },
			prop = "fil", windupFx = { { "ring", color = Color3.fromRGB(250, 250, 250), radius = 2.5, at = "above" } }, text = "YIHAA !", hitText = "ATTRAPÉ !",
		},
		-- Anesthésie (S maintenu) : seringue levée, petite giclée de vérification, puis piqûre : l'adversaire devient mou
		S_hold = {
			label = "Anesthésie", energyCost = 30, startup = 0.24, active = 0.12, recovery = 0.36,
			damage = 9, hitbox = box(4.5, 3, 2.6, 0.6), kbBase = 20, kbGrowth = 35, kbAngle = 25,
			status = { name = "slowed", duration = 3 },
			windup = { Root = { 4, 14, 0, 0, -0.05, 0.15 }, Waist = { 6, 12, 0 }, Neck = { 20, -10, 0 }, LS = { 160, 0, -15 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -10, -10, 0, 0, -0.25, -0.3 }, Waist = { -8, -12, 0 }, Neck = { -4, 8, 0 }, LS = { 92, 0, 6 }, LE = { 2, 0, 0 }, LW = { 0, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			follow = { Root = { -11, -12, 0, 0, -0.27, -0.33 }, Waist = { -9, -14, 0 }, Neck = { -4, 10, 0 }, LS = { 92, 0, 10 }, LE = { 2, 0, 0 }, LW = { -10, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			hold = 0.15, prop = "seringue", windupFx = { { "particles", tex = "spark", color = Color3.fromRGB(180, 140, 255), at = "lhand", dir = "up", time = 0.15, rate = 40, speed = 6, size = 0.25 } },
			fx = { { "symbols", symbols = { "💉", "~" }, color = Color3.fromRGB(180, 140, 255), count = 4, radius = 2.5, at = "front" } },
			text = "PETITE PIQÛRE…", hitText = "TOUT MOU…",
		},
		-- Charge en fauteuil (→→S) : assis sur le tabouret, il fonce en avant jambes tendues et bras croisés
		S_dash = {
			label = "Charge en fauteuil", energyCost = 25, startup = 0.06, active = 0.32, recovery = 0.3,
			damage = 10, hitbox = box(5, 3.5, 2.5, 0), kbBase = 30, kbGrowth = 60, kbAngle = 35, selfVelocity = Vector2.new(62, 0), invuln = 0.15,
			windup = { Root = { 0, 0, 0, 0, -0.6, 0.1 }, Waist = { 4, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -0.95, 0 }, Waist = { 6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 70, 0, -30 }, RE = { 110, 0, 0 }, LS = { 70, 0, 30 }, LE = { 110, 0, 0 }, RH = { 85, 0, 0 }, RK = { -30, 0, 0 }, LH = { 85, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -0.95, 0 }, Waist = { 8, 0, 0 }, Neck = { 2, 0, 0 }, RS = { 72, 0, -32 }, RE = { 112, 0, 0 }, LS = { 72, 0, 32 }, LE = { 112, 0, 0 }, RH = { 88, 0, 0 }, RK = { -26, 0, 0 }, LH = { 88, 0, 0 }, LK = { -26, 0, 0 } },
			fx = { "dust" }, text = "PLACE AU DOCTEUR !", hitText = "BADABOUM !",
		},
		-- Dents de lait (S en l'air) : il jette une poignée de dents en sucre en éventail vers le bas
		S_air = {
			label = "Dents de lait", energyCost = 20, kind = "projectile", startup = 0.14, active = 0, recovery = 0.3,
			damage = 4, kbBase = 18, kbGrowth = 25, kbAngle = 30,
			projectile = { speed = 60, angle = -30, gravity = 40, lifetime = 0.7, size = 1.2, color = Color3.fromRGB(255, 255, 255), fan = { count = 3, from = -45, to = -10 },
				visual = { shape = "block", size = 0.8, color = Color3.fromRGB(255, 255, 250), spin = 12, parts = { { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, -0.45, 0), Color3.fromRGB(255, 200, 220) } } } },
			windup = { Root = { 10, 15, 0 }, Waist = { 10, 15, 0 }, LS = { 150, 0, -40 }, LE = { 70, 0, 0 }, RS = { 50, 0, 40 }, RE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -14, -8, 0 }, Waist = { -14, -10, 0 }, LS = { 50, 0, 15 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 50, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -16, -10, 0 }, Waist = { -16, -12, 0 }, LS = { 40, 0, 20 }, LE = { 10, 0, 0 }, LW = { -35, 0, 0 }, RS = { 38, 0, 52 }, RE = { 50, 0, 0 }, RH = { 28, 0, 0 }, RK = { -55, 0, 0 }, LH = { 52, 0, 0 }, LK = { -92, 0, 0 } },
			text = "CADEAU !", hitText = "CRAC !",
		},
		-- Pluie de dents (↓S en l'air) : il tombe tout droit, bras écartés, en semant des dents en sucre autour de lui
		S_air_down = {
			label = "Pluie de dents", energyCost = 25, startup = 0.14, active = 0.35, recovery = 0.32,
			damage = 11, hitbox = box(6, 4, 0, -1.5), kbBase = 26, kbGrowth = 55, kbAngle = -60, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 20 }, RE = { 30, 0, 0 }, LS = { 160, 0, -20 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 90, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 100, 0, 80 }, RE = { 10, 0, 0 }, LS = { 100, 0, -80 }, LE = { 10, 0, 0 }, RH = { 5, 0, 8 }, RK = { -5, 0, 0 }, RA = { -15, 0, 0 }, LH = { 5, 0, -8 }, LK = { -5, 0, 0 }, LA = { -15, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 105, 0, 85 }, RE = { 10, 0, 0 }, LS = { 105, 0, -85 }, LE = { 10, 0, 0 }, RH = { 5, 0, 10 }, RK = { -8, 0, 0 }, RA = { -15, 0, 0 }, LH = { 5, 0, -10 }, LK = { -8, 0, 0 }, LA = { -15, 0, 0 } },
			trail = "body", fx = { { "rain", shape = "block", color = Color3.fromRGB(255, 255, 250), count = 12, radius = 6, size = 0.6 }, { "shake", amount = 0.4 } },
			text = "PLUIE DE DENTS !", hitText = "CRAC CRAC !",
		},

		------------------------------------------------------------------ Finition avec S (dans un enchaînement)
		-- Jet de rinçage : il presse la poire à eau et envoie un jet bleu qui repousse
		S_finish_rinse = {
			label = "Jet de rinçage", energyCost = 20, kind = "projectile", startup = 0.12, active = 0, recovery = 0.28,
			damage = 8, kbBase = 30, kbGrowth = 55, kbAngle = 30,
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.3, size = 1.6, color = RINSE,
				visual = { shape = "ball", size = 1.4, color = RINSE, neon = true, transparency = 0.2 } },
			windup = { Root = { 0, 12, 0, 0, -0.1, 0.1 }, Waist = { 0, 10, 0 }, LS = { 80, 0, -20 }, LE = { 100, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -4, -6, 0, 0, -0.15, -0.1 }, Waist = { -4, -8, 0 }, LS = { 92, 0, 6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			follow = { Root = { 2, -6, 0, 0, -0.15, 0.1 }, Waist = { 2, -8, 0 }, LS = { 100, 0, 6 }, LE = { 5, 0, 0 }, LW = { 10, 0, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 } },
			prop = "gobelet", fx = { { "beam", color = RINSE, length = 6, width = 1, at = "lhand", time = 0.15 } }, text = "RINCEZ !", hitText = "SPLASH !",
		},

		------------------------------------------------------------------ Supers
		-- Détartrage : il avance en vrombissant, fraise en avant, six passes rapides sur les dents de l'adversaire
		SUPER = {
			label = "Détartrage !", superCost = 100, startup = 0.3, active = 0.6, recovery = 0.45, hits = 6,
			damage = 4, hitbox = box(5.5, 4, 3, 0.6), kbBase = 36, kbGrowth = 70, kbAngle = 35, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { 6, -20, 0, 0, -0.2, 0.3 }, Waist = { 8, -20, 0 }, Neck = { 6, 15, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -50 }, LE = { 140, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, -0.3, -0.35 }, Waist = { -10, 10, 0 }, Neck = { 6, 0, 0 }, RS = { 92, 0, -8 }, RE = { 5, 0, 0 }, RW = { 88, 0, 0 }, LS = { 70, 0, -40 }, LE = { 120, 0, 0 } },
			follow = { Root = { -14, 14, 0, 0, -0.32, -0.45 }, Waist = { -12, 16, 0 }, Neck = { 8, 0, 0 }, RS = { 96, 0, 10 }, RE = { 5, 0, 0 }, RW = { 90, 0, 0 }, LS = { 72, 0, -42 }, LE = { 120, 0, 0 } },
			wobble = true, trail = "prop", windupFx = { "super" },
			fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.6, rate = 150, speed = 14, size = 0.35 }, { "shake", amount = 0.3, time = 0.6 } },
			text = "DÉTARTRAGE !", hitText = "BZZZRRRIIIK !",
		},
		-- Grand fou rire : il ouvre en grand toutes les bonbonnes, l'arène entière se remplit de gaz rose
		SUPER_down = {
			label = "Grand fou rire !", superCost = 100, startup = 0.4, active = 0.2, recovery = 0.6,
			damage = 9, hitbox = box(70, 50, 0, 10), kbBase = 10, kbGrowth = 10, kbAngle = 60,
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
	P_combo3 = { K = "K_combo3", S = "S_finish_rinse" }, -- P P P
	PK_combo = { P = "P_combo3", K = "K_combo2", S = "S_neutral" }, -- P K
	P_side = { P = "P_combo3", K = "K_side", S = "S_finish_rinse" }, -- → P
	P_down = { P = "P_down2", K = "K_down", S = "S_finish_rinse" }, -- ↓ P
	P_down2 = { up_K = "K_up", K = "KP_combo", S = "S_neutral" }, -- ↓ P P
	P_up = { P = "P_combo2", K = "K_up", S = "S_finish_rinse" }, -- ↑ P
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_hold" }, -- dash P
	-- au sol, K…
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_rinse" },
	K_combo2 = { K = "K_combo3", P = "KP_combo", S = "S_neutral" }, -- K K
	K_combo3 = { S = "S_finish_rinse" }, -- K K K
	KP_combo = { K = "K_combo3", P = "P_combo3", S = "S_finish_rinse" }, -- K P
	K_side = { P = "KP_combo", K = "K_combo3", S = "S_neutral" }, -- → K
	K_down = { P = "P_down2", K = "K_combo2", S = "S_finish_rinse" }, -- ↓ K
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

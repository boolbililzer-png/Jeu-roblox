-- Sumo Gélatine : un sumo en gelée verte translucide (un canard en plastique flotte dans son ventre). Tank pour
-- débutants : coups simples, lents et lourds ; qui le frappe au corps à corps rebondit sur lui.
-- Arme sortie de la Caisse Bizarre : gants en guimauve (il se bat surtout avec son propre corps).
--
-- Même format que Gege.lua (voir l'en-tête de ce fichier et docs/fiche-perso.md).
-- Garde de sumo : jambes écartées (FR / FL décalés vers l'extérieur), bassin bas, paumes ouvertes.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local JELLY = Color3.fromRGB(110, 220, 90)
local JELLY_DARK = Color3.fromRGB(70, 170, 60)
local MAWASHI = Color3.fromRGB(60, 40, 110)
local DUCK = Color3.fromRGB(255, 215, 40)
local BEAK = Color3.fromRGB(255, 130, 30)
local HAIR = Color3.fromRGB(25, 25, 30)
local MARSH = Color3.fromRGB(255, 238, 242)
local PINK = Color3.fromRGB(255, 170, 200)
local SALT = Color3.fromRGB(250, 250, 255)
local CLAY = Color3.fromRGB(205, 170, 120)

-- pieds écartés de la garde de sumo (à ajouter aux poses au sol)
local WIDE_R = { 0, 0, 0, 0.35, 0, 0 }
local WIDE_L = { 0, 0, 0, -0.35, 0, 0 }

local data = {
	id = "Sumo",
	name = "Sumo Gélatine",
	costume = "Sumo",
	style = "jelly",

	look = {
		body = { head = JELLY, upper = JELLY, lower = JELLY, arms = JELLY, hands = JELLY, legs = JELLY, feet = JELLY_DARK },
		cubeHead = 1.3,
		transparency = 0.3,
		parts = {
			-- chignon de sumo (chonmage)
			{ "Chignon", "Head", "ball", Vector3.new(0.6, 0.45, 0.9), Vector3.new(0, 0.82, 0.1), Vector3.zero, HAIR, "SmoothPlastic" },
			{ "Cheveux", "Head", "block", Vector3.new(1.34, 0.22, 1.34), Vector3.new(0, 0.6, 0.02), Vector3.zero, HAIR, "SmoothPlastic" },
			-- visage jovial
			{ "OeilDroit", "Head", "ball", Vector3.new(0.22, 0.12, 0.06), Vector3.new(0.27, 0.12, -0.66), Vector3.zero, HAIR },
			{ "OeilGauche", "Head", "ball", Vector3.new(0.22, 0.12, 0.06), Vector3.new(-0.27, 0.12, -0.66), Vector3.zero, HAIR },
			{ "Sourcils", "Head", "block", Vector3.new(0.9, 0.1, 0.06), Vector3.new(0, 0.3, -0.66), Vector3.zero, HAIR },
			{ "Bouche", "Head", "block", Vector3.new(0.4, 0.1, 0.06), Vector3.new(0, -0.3, -0.66), Vector3.zero, Color3.fromRGB(40, 90, 40) },
			{ "JoueD", "Head", "ball", Vector3.new(0.35, 0.3, 0.2), Vector3.new(0.45, -0.15, -0.6), Vector3.zero, Color3.fromRGB(150, 235, 120), "SmoothPlastic", { transparency = 0.2 } },
			{ "JoueG", "Head", "ball", Vector3.new(0.35, 0.3, 0.2), Vector3.new(-0.45, -0.15, -0.6), Vector3.zero, Color3.fromRGB(150, 235, 120), "SmoothPlastic", { transparency = 0.2 } },
			-- gros ventre de gelée et le canard qui flotte dedans
			{ "Bedaine", "UpperTorso", "ball", Vector3.new(2.5, 2.1, 1.9), Vector3.new(0, -0.35, -0.35), Vector3.zero, JELLY, "SmoothPlastic", { transparency = 0.35 } },
			{ "Canard", "UpperTorso", "ball", Vector3.new(0.6, 0.45, 0.75), Vector3.new(0.2, -0.45, -0.55), Vector3.zero, DUCK, "SmoothPlastic" },
			{ "TeteCanard", "UpperTorso", "ball", Vector3.new(0.38, 0.38, 0.38), Vector3.new(0.2, -0.12, -0.8), Vector3.zero, DUCK, "SmoothPlastic" },
			{ "BecCanard", "UpperTorso", "block", Vector3.new(0.2, 0.08, 0.2), Vector3.new(0.2, -0.15, -1.0), Vector3.zero, BEAK, "SmoothPlastic" },
			-- épaules et cuisses dodues
			{ "EpauleD", "RightUpperArm", "ball", Vector3.new(1.3, 1.2, 1.3), Vector3.new(0, 0.2, 0), Vector3.zero, JELLY, "SmoothPlastic", { transparency = 0.35 } },
			{ "EpauleG", "LeftUpperArm", "ball", Vector3.new(1.3, 1.2, 1.3), Vector3.new(0, 0.2, 0), Vector3.zero, JELLY, "SmoothPlastic", { transparency = 0.35 } },
			{ "CuisseD", "RightUpperLeg", "ball", Vector3.new(1.35, 1.4, 1.35), Vector3.new(0, 0.1, 0), Vector3.zero, JELLY, "SmoothPlastic", { transparency = 0.35 } },
			{ "CuisseG", "LeftUpperLeg", "ball", Vector3.new(1.35, 1.4, 1.35), Vector3.new(0, 0.1, 0), Vector3.zero, JELLY, "SmoothPlastic", { transparency = 0.35 } },
			-- mawashi (ceinture de sumo) avec son nœud et ses franges
			{ "Mawashi", "LowerTorso", "block", Vector3.new(2.2, 0.75, 1.25), Vector3.new(0, 0.05, 0), Vector3.zero, MAWASHI, "Fabric" },
			{ "Noeud", "LowerTorso", "block", Vector3.new(0.7, 0.8, 0.4), Vector3.new(0, 0.1, 0.75), Vector3.zero, MAWASHI, "Fabric" },
			{ "Frange1", "LowerTorso", "block", Vector3.new(0.12, 0.8, 0.12), Vector3.new(-0.35, -0.6, -0.65), Vector3.zero, MAWASHI, "Fabric" },
			{ "Frange2", "LowerTorso", "block", Vector3.new(0.12, 0.8, 0.12), Vector3.new(0, -0.6, -0.65), Vector3.zero, MAWASHI, "Fabric" },
			{ "Frange3", "LowerTorso", "block", Vector3.new(0.12, 0.8, 0.12), Vector3.new(0.35, -0.6, -0.65), Vector3.zero, MAWASHI, "Fabric" },
			-- bulles d'air piégées dans la gelée
			{ "Bulle1", "UpperTorso", "ball", Vector3.new(0.2, 0.2, 0.2), Vector3.new(-0.5, 0.2, -0.6), Vector3.zero, Color3.fromRGB(220, 255, 220), "Glass", { transparency = 0.3 } },
			{ "Bulle2", "UpperTorso", "ball", Vector3.new(0.14, 0.14, 0.14), Vector3.new(-0.3, -0.8, -0.9), Vector3.zero, Color3.fromRGB(220, 255, 220), "Glass", { transparency = 0.3 } },
		},
		props = {
			-- l'arme : deux gants en guimauve, moelleux et rebondissants
			{ name = "PropGant", hand = "Right", visible = true, pieces = {
				{ "Guimauve", "", "cyl", Vector3.new(1.0, 1.25, 1.25), Vector3.new(0, -0.25, 0), Vector3.zero, MARSH, "SmoothPlastic" },
				{ "Bout", "", "ball", Vector3.new(1.25, 0.6, 1.25), Vector3.new(0, -0.75, 0), Vector3.zero, MARSH, "SmoothPlastic" },
				{ "Rayure", "", "cyl", Vector3.new(0.2, 1.3, 1.3), Vector3.new(0, 0.1, 0), Vector3.zero, PINK, "SmoothPlastic" },
			} },
			{ name = "PropGantG", hand = "Left", visible = true, pieces = {
				{ "Guimauve", "", "cyl", Vector3.new(1.0, 1.25, 1.25), Vector3.new(0, -0.25, 0), Vector3.zero, MARSH, "SmoothPlastic" },
				{ "Bout", "", "ball", Vector3.new(1.25, 0.6, 1.25), Vector3.new(0, -0.75, 0), Vector3.zero, MARSH, "SmoothPlastic" },
				{ "Rayure", "", "cyl", Vector3.new(0.2, 1.3, 1.3), Vector3.new(0, 0.1, 0), Vector3.zero, PINK, "SmoothPlastic" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Claque molle : pieds écartés, il lance la paume droite ouverte, l'épaule suit lourdement
		P_neutral = {
			label = "Claque molle", startup = 0.1, active = 0.08, recovery = 0.16,
			damage = 6, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 20, kbGrowth = 25, kbAngle = 25,
			windup = { Root = { 2, -16, 0, 0, -0.35, 0.15 }, Waist = { 0, -14, 0 }, RS = { 60, 0, 45 }, RE = { 100, 0, 0 }, RW = { -40, 0, 0 }, LS = { 60, 0, -30 }, LE = { 70, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -8, 14, 0, 0, -0.42, -0.3 }, Waist = { -6, 16, 0 }, RS = { 92, 0, 5 }, RE = { 5, 0, 0 }, RW = { -70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { -9, 18, 0, 0, -0.44, -0.35 }, Waist = { -7, 20, 0 }, RS = { 94, 0, -5 }, RE = { 8, 0, 0 }, RW = { -75, 0, 0 }, LS = { 38, 0, -42 }, LE = { 80, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, trail = "rightHand", hitText = "FLOP !",
		},
		-- Ventre-rebond : il rentre le ventre puis le projette en avant, bras rejetés en arrière (élastique)
		P_side = {
			label = "Ventre-rebond", startup = 0.12, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(4.5, 4, 2.4, 0.2), kbBase = 32, kbGrowth = 36, kbAngle = 20, selfVelocity = Vector2.new(24, 0),
			windup = { Root = { -12, 0, 0, 0, -0.4, 0.35 }, Waist = { -22, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 16, 0, 0, 0, -0.3, -0.6 }, Waist = { 22, 0, 0 }, Neck = { -16, 0, 0 }, RS = { -45, 0, 35 }, RE = { 15, 0, 0 }, LS = { -45, 0, -35 }, LE = { 15, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.35, 0, -0.4 } },
			follow = { Root = { 20, 0, 0, 0, -0.3, -0.7 }, Waist = { 26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -55, 0, 40 }, RE = { 20, 0, 0 }, LS = { -55, 0, -40 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.35, 0, -0.45 } },
			wobble = true, text = "BLOING !", hitText = "BOÏNG !",
		},
		-- Glissade gluante : il se jette à plat ventre et glisse sur la gelée, bras tendus devant
		P_down = {
			label = "Glissade gluante", startup = 0.12, active = 0.2, recovery = 0.26,
			damage = 7, hitbox = box(6, 2, 2.5, -2), kbBase = 26, kbGrowth = 22, kbAngle = 72, selfVelocity = Vector2.new(38, 0),
			windup = { Root = { -20, 0, 0, 0, -0.75, 0 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 30, 0, 0 }, LS = { 60, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -75, 0, 0, 0, -1.55, -0.3 }, Waist = { 0, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 175, 0, 15 }, RE = { 0, 0, 0 }, LS = { 175, 0, -15 }, LE = { 0, 0, 0 }, RH = { -5, 0, 5 }, RK = { -20, 0, 0 }, LH = { -5, 0, -5 }, LK = { -25, 0, 0 } },
			follow = { Root = { -78, 0, 0, 0, -1.6, -0.35 }, Waist = { 0, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 178, 0, 18 }, RE = { 0, 0, 0 }, LS = { 178, 0, -18 }, LE = { 0, 0, 0 }, RH = { -5, 0, 8 }, RK = { -25, 0, 0 }, LH = { -5, 0, -8 }, LK = { -30, 0, 0 } },
			trail = "body", fx = { { "puddle", color = JELLY, width = 7 } }, hitText = "SPLOUTCH !",
		},
		-- Bras-ressort (anti-air) : il se ramasse puis son bras droit s'étire tout droit vers le ciel
		P_up = {
			label = "Bras-ressort", startup = 0.11, active = 0.12, recovery = 0.22,
			damage = 7, hitbox = box(4, 6, 1, 4), kbBase = 28, kbGrowth = 30, kbAngle = 86,
			windup = { Root = { -6, -10, 0, 0, -0.7, 0 }, Waist = { -14, -10, 0 }, Neck = { -10, 0, 0 }, RS = { -10, 0, 30 }, RE = { 120, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 6, 10, 0, 0, 0.1, 0 }, Waist = { 10, 10, 0 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -50 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 8, 12, 0, 0, 0.15, 0 }, Waist = { 12, 12, 0 }, Neck = { 30, 0, 0 }, RS = { 182, 0, 2 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 15, 0, -52 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, trail = "rightHand", text = "BOÏÏNG !", hitText = "TCHAC !",
		},
		-- Bras-ressort élastique (en l'air) : le bras droit part comme un élastique tendu devant lui
		P_air = {
			label = "Bras-ressort élastique", startup = 0.1, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5.5, 3, 3.2, 0.5), kbBase = 22, kbGrowth = 32, kbAngle = 30,
			windup = { Root = { -6, -20, 0 }, Waist = { -6, -18, 0 }, RS = { 40, 0, 60 }, RE = { 130, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 10 }, RK = { -90, 0, 0 }, LH = { 50, 0, -10 }, LK = { -90, 0, 0 } },
			strike = { Root = { 4, 14, 0 }, Waist = { 4, 16, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, RH = { 40, 0, 10 }, RK = { -70, 0, 0 }, LH = { 60, 0, -10 }, LK = { -100, 0, 0 } },
			follow = { Root = { 6, 18, 0 }, Waist = { 6, 20, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { -65, 0, 0 }, LS = { 28, 0, -52 }, LE = { 60, 0, 0 }, RH = { 38, 0, 10 }, RK = { -65, 0, 0 }, LH = { 62, 0, -10 }, LK = { -100, 0, 0 } },
			wobble = true, trail = "rightHand", hitText = "BOÏNG !",
		},
		-- Tachiai (dash puis P) : la charge d'ouverture du sumo, tête basse et épaule en avant
		P_dash = {
			label = "Tachiai", startup = 0.09, active = 0.16, recovery = 0.26,
			damage = 9, hitbox = box(4.5, 4, 2.2, 0.4), kbBase = 32, kbGrowth = 55, kbAngle = 25, selfVelocity = Vector2.new(44, 0),
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.15 }, Waist = { -20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -10, 0, 20 }, RE = { 30, 0, 0 }, LS = { -10, 0, -20 }, LE = { 30, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -28, -20, 0, 0, -0.55, -0.35 }, Waist = { -12, -10, 0 }, Neck = { 22, 0, 0 }, RS = { 60, 0, 30 }, RE = { 70, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			follow = { Root = { -30, -24, 0, 0, -0.58, -0.4 }, Waist = { -14, -12, 0 }, Neck = { 24, 0, 0 }, RS = { 62, 0, 32 }, RE = { 70, 0, 0 }, LS = { 28, 0, -42 }, LE = { 80, 0, 0 } },
			fx = { "dust" }, text = "HAKKEYOI !", hitText = "BAM !",
		},

		-- Suites d'enchaînement P
		-- P P : claque molle de la main gauche
		P_combo2 = {
			label = "Claque molle gauche", startup = 0.1, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { 2, 16, 0, 0, -0.35, 0.1 }, Waist = { 0, 14, 0 }, LS = { 60, 0, -45 }, LE = { 100, 0, 0 }, LW = { -40, 0, 0 }, RS = { 60, 0, 30 }, RE = { 70, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -8, -14, 0, 0, -0.42, -0.3 }, Waist = { -6, -16, 0 }, LS = { 92, 0, -5 }, LE = { 5, 0, 0 }, LW = { -70, 0, 0 }, RS = { 40, 0, 40 }, RE = { 80, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { -9, -18, 0, 0, -0.44, -0.35 }, Waist = { -7, -20, 0 }, LS = { 94, 0, 5 }, LE = { 8, 0, 0 }, LW = { -75, 0, 0 }, RS = { 38, 0, 42 }, RE = { 80, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, trail = "leftHand", hitText = "FLIP !",
		},
		-- P P P : Tsuppari, poussée des deux paumes à plat, tout le poids du corps derrière
		P_combo3 = {
			label = "Poussée de paumes", startup = 0.14, active = 0.1, recovery = 0.32,
			damage = 9, hitbox = box(5, 3.5, 2.8, 0.6), kbBase = 32, kbGrowth = 62, kbAngle = 25, selfVelocity = Vector2.new(15, 0),
			windup = { Root = { -6, 0, 0, 0, -0.55, 0.3 }, Waist = { -8, 0, 0 }, RS = { 70, 0, 20 }, RE = { 130, 0, 0 }, RW = { -60, 0, 0 }, LS = { 70, 0, -20 }, LE = { 130, 0, 0 }, LW = { -60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -14, 0, 0, 0, -0.5, -0.55 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 90, 0, 10 }, RE = { 0, 0, 0 }, RW = { -80, 0, 0 }, LS = { 90, 0, -10 }, LE = { 0, 0, 0 }, LW = { -80, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.35, 0, -0.5 } },
			follow = { Root = { -16, 0, 0, 0, -0.5, -0.62 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 92, 0, 8 }, RE = { 0, 0, 0 }, RW = { -85, 0, 0 }, LS = { 92, 0, -8 }, LE = { 0, 0, 0 }, LW = { -85, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.35, 0, -0.55 } },
			trail = "bothHands", text = "TSUPPARI !", hitText = "BLAM !",
		},
		-- P puis K : coup de hanche, il pivote et envoie sa grosse hanche gélatineuse
		PK_combo = {
			label = "Coup de hanche", startup = 0.12, active = 0.1, recovery = 0.24,
			damage = 8, hitbox = box(4, 3.5, 2, 0), kbBase = 28, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { 0, 30, 0, 0, -0.4, 0.1 }, Waist = { 0, 10, 0 }, Neck = { 0, -25, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 0, 75, 12, 0, -0.45, -0.4 }, Waist = { 0, -15, 0 }, Neck = { 0, -50, 0 }, RS = { 20, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 0, 80, 14, 0, -0.45, -0.45 }, Waist = { 0, -18, 0 }, Neck = { 0, -52, 0 }, RS = { 18, 0, 62 }, RE = { 40, 0, 0 }, LS = { 28, 0, -62 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, hitText = "POUF !",
		},
		-- ↓P P : Rebond de bedaine, de la glissade il rebondit sur le ventre et remonte d'un coup (fait décoller)
		P_down2 = {
			label = "Rebond de bedaine", startup = 0.12, active = 0.12, recovery = 0.28,
			damage = 8, hitbox = box(5, 5, 1.5, 1.5), kbBase = 30, kbGrowth = 42, kbAngle = 84,
			windup = { Root = { -40, 0, 0, 0, -1.3, 0 }, Waist = { -10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 120, 0, 40 }, RE = { 20, 0, 0 }, LS = { 120, 0, -40 }, LE = { 20, 0, 0 }, RH = { 20, 0, 10 }, RK = { -60, 0, 0 }, LH = { 20, 0, -10 }, LK = { -60, 0, 0 } },
			strike = { Root = { 16, 0, 0, 0, 0.25, 0 }, Waist = { 24, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 140, 0, 60 }, RE = { 10, 0, 0 }, LS = { 140, 0, -60 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.35, 0.3, 0 }, FL = { 0, 0, 0, -0.35, 0.3, 0 } },
			follow = { Root = { 18, 0, 0, 0, 0.3, 0 }, Waist = { 26, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 150, 0, 66 }, RE = { 10, 0, 0 }, LS = { 150, 0, -66 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.35, 0.35, 0 }, FL = { 0, 0, 0, -0.35, 0.35, 0 } },
			wobble = true, text = "BOÏNG !", hitText = "HOP !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Shiko : il lève la jambe droite très haut sur le côté, puis l'écrase au sol : l'arène tremble
		K_neutral = {
			label = "Shiko", startup = 0.24, active = 0.1, recovery = 0.32,
			damage = 12, hitbox = box(7, 2.5, 1.5, -1.6), kbBase = 32, kbGrowth = 70, kbAngle = 70,
			windup = { Root = { 0, 0, -14, -0.3, -0.2, 0 }, Waist = { 4, 0, -10 }, Neck = { 0, 0, 10 }, RS = { 20, 0, 40 }, RE = { 30, 0, 0 }, LS = { 10, 0, -30 }, LE = { 60, 0, 0 }, RH = { 30, 0, 70 }, RK = { -30, 0, 0 }, FL = WIDE_L },
			strike = { Root = { 6, 0, 2, 0, -0.65, 0 }, Waist = { 10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 30, 0, 30 }, RE = { 100, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0.45, 0, 0 }, FL = WIDE_L },
			follow = { Root = { 8, 0, 0, 0, -0.7, 0 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 28, 0, 32 }, RE = { 105, 0, 0 }, LS = { 28, 0, -32 }, LE = { 105, 0, 0 }, FR = { 0, 0, 0, 0.45, 0, 0 }, FL = WIDE_L },
			hold = 0.08, trail = "rightFoot", fx = { { "ring", color = JELLY, radius = 6, at = "feet" }, { "shake", amount = 0.4 } }, text = "DOSUKOI !", hitText = "BOUM !",
		},
		-- Poussée de paume géante : un grand pas, puis la paume droite à plat enfonce l'adversaire
		K_side = {
			label = "Poussée de paume géante", startup = 0.22, active = 0.12, recovery = 0.34,
			damage = 13, hitbox = box(5, 4, 3, 0.6), kbBase = 34, kbGrowth = 84, kbAngle = 28, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 4, -30, 0, 0, -0.4, 0.4 }, Waist = { 6, -26, 0 }, Neck = { 0, 20, 0 }, RS = { 50, 0, 60 }, RE = { 130, 0, 0 }, RW = { -50, 0, 0 }, LS = { 70, 0, -10 }, LE = { 30, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -14, 18, 0, 0, -0.5, -0.6 }, Waist = { -10, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, 6 }, RE = { 0, 0, 0 }, RW = { -85, 0, 0 }, LS = { -20, 0, -40 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.35, 0, -0.6 } },
			follow = { Root = { -16, 22, 0, 0, -0.52, -0.68 }, Waist = { -12, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 94, 0, 2 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { -25, 0, -42 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.35, 0, -0.65 } },
			wobble = true, trail = "rightHand", fx = { { "ring", color = MARSH, radius = 3, at = "front" } }, hitText = "PLAF !",
		},
		-- Coup de bide bas : accroupi au ras du sol, il propulse son ventre vers l'avant comme un bélier
		K_down = {
			label = "Coup de bide bas", startup = 0.2, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(5, 2.5, 2.4, -1.3), kbBase = 32, kbGrowth = 64, kbAngle = 55, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { -14, 0, 0, 0, -0.95, 0.35 }, Waist = { -24, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 20, 0, -30 }, LE = { 60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 18, 0, 0, 0, -0.95, -0.55 }, Waist = { 26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -50, 0, 40 }, RE = { 20, 0, 0 }, LS = { -50, 0, -40 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 20, 0, 0, 0, -0.95, -0.62 }, Waist = { 28, 0, 0 }, Neck = { -22, 0, 0 }, RS = { -58, 0, 45 }, RE = { 20, 0, 0 }, LS = { -58, 0, -45 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, fx = { "dust" }, hitText = "BLOUB !",
		},
		-- Absorption (recul) : il recule en gonflant le ventre qui avale les projectiles, puis le ventre rebondit vers le haut
		K_up = {
			label = "Absorption", kind = "absorb", startup = 0.16, active = 0.3, recovery = 0.32,
			damage = 11, hitbox = box(5, 5, 1.5, 2.5), kbBase = 32, kbGrowth = 68, kbAngle = 80, selfVelocity = Vector2.new(-18, 0),
			absorb = { radius = 5, offset = 1.5 },
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.3 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 22, 0, 0, 0, -0.15, 0.45 }, Waist = { 26, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 75 }, RE = { 10, 0, 0 }, LS = { 120, 0, -75 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 24, 0, 0, 0, -0.12, 0.5 }, Waist = { 28, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 128, 0, 80 }, RE = { 10, 0, 0 }, LS = { 128, 0, -80 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, fx = { { "ring", color = JELLY, radius = 4, at = "root" } }, text = "GLOUP !", hitText = "BOÏNG !",
		},
		-- Bombe gélatineuse (saut K) : genoux serrés dans les bras, il se roule en boule et percute
		K_air = {
			label = "Bombe gélatineuse", startup = 0.18, active = 0.16, recovery = 0.28,
			damage = 12, hitbox = box(5, 5, 1.8, -0.5), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -10, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 30, 0, 0 }, LS = { 150, 0, -40 }, LE = { 30, 0, 0 }, RH = { 40, 0, 10 }, RK = { -60, 0, 0 }, LH = { 40, 0, -10 }, LK = { -60, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -35, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 110, 0, 0 }, LS = { 60, 0, 10 }, LE = { 110, 0, 0 }, RH = { 120, 0, 5 }, RK = { -140, 0, 0 }, LH = { 120, 0, -5 }, LK = { -140, 0, 0 } },
			follow = { Root = { -22, 0, 0 }, Waist = { -36, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 62, 0, -12 }, RE = { 112, 0, 0 }, LS = { 62, 0, 12 }, LE = { 112, 0, 0 }, RH = { 122, 0, 5 }, RK = { -140, 0, 0 }, LH = { 122, 0, -5 }, LK = { -140, 0, 0 } },
			spin = { axis = "x", degrees = 360 }, trail = "body", hitText = "BLOMP !",
		},
		-- Kekaeshi glissé (dash puis K) : il glisse et fauche les jambes d'un grand coup de pied intérieur
		K_dash = {
			label = "Kekaeshi glissé", startup = 0.12, active = 0.2, recovery = 0.32,
			damage = 11, hitbox = box(5.5, 2.5, 2.5, -1.5), kbBase = 30, kbGrowth = 62, kbAngle = 65, selfVelocity = Vector2.new(46, 0),
			windup = { Root = { -6, -20, 0, 0, -0.55, 0.1 }, Waist = { -8, -10, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 70, 0, 0 }, RH = { -20, 0, 30 }, RK = { -40, 0, 0 } },
			strike = { Root = { -8, 25, 0, 0, -0.65, -0.3 }, Waist = { -10, 15, 0 }, RS = { 30, 0, 60 }, RE = { 40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 60, 0, 0 }, RH = { 60, 0, -20 }, RK = { -10, 0, 0 }, RA = { -10, 0, 0 } },
			follow = { Root = { -8, 32, 0, 0, -0.66, -0.35 }, Waist = { -10, 18, 0 }, RS = { 28, 0, 62 }, RE = { 40, 0, 0 }, LS = { 62, 0, -52 }, LE = { 60, 0, 0 }, RH = { 62, 0, -30 }, RK = { -10, 0, 0 }, RA = { -10, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
		},

		-- Suites d'enchaînement K
		-- K K : Shiko de la jambe gauche
		K_combo2 = {
			label = "Shiko gauche", startup = 0.22, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(7, 2.5, 1.5, -1.6), kbBase = 30, kbGrowth = 55, kbAngle = 70,
			windup = { Root = { 0, 0, 14, 0.3, -0.2, 0 }, Waist = { 4, 0, 10 }, Neck = { 0, 0, -10 }, LS = { 20, 0, -40 }, LE = { 30, 0, 0 }, RS = { 10, 0, 30 }, RE = { 60, 0, 0 }, LH = { 30, 0, -70 }, LK = { -30, 0, 0 }, FR = WIDE_R },
			strike = { Root = { 6, 0, -2, 0, -0.65, 0 }, Waist = { 10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 30, 0, 30 }, RE = { 100, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.45, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -0.7, 0 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 28, 0, 32 }, RE = { 105, 0, 0 }, LS = { 28, 0, -32 }, LE = { 105, 0, 0 }, FR = WIDE_R, FL = { 0, 0, 0, -0.45, 0, 0 } },
			trail = "leftFoot", fx = { { "ring", color = JELLY, radius = 6, at = "feet" }, { "shake", amount = 0.35 } }, hitText = "BOUM !",
		},
		-- K K K : Double Shiko sauté, il saute pieds écartés et retombe des deux pieds (fait décoller)
		K_combo3 = {
			label = "Double Shiko sauté", startup = 0.26, active = 0.12, recovery = 0.38,
			damage = 13, hitbox = box(9, 3, 1, -1.5), kbBase = 34, kbGrowth = 82, kbAngle = 78,
			windup = { Root = { 0, 0, 0, 0, 0.5, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 70 }, RE = { 20, 0, 0 }, LS = { 120, 0, -70 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0.5, 0.5, 0 }, FL = { 0, 0, 0, -0.5, 0.5, 0 } },
			strike = { Root = { 8, 0, 0, 0, -0.8, 0 }, Waist = { 12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 35 }, RE = { 100, 0, 0 }, LS = { 30, 0, -35 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0.55, 0, 0 }, FL = { 0, 0, 0, -0.55, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.85, 0 }, Waist = { 14, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 28, 0, 36 }, RE = { 105, 0, 0 }, LS = { 28, 0, -36 }, LE = { 105, 0, 0 }, FR = { 0, 0, 0, 0.55, 0, 0 }, FL = { 0, 0, 0, -0.55, 0, 0 } },
			hold = 0.1, fx = { { "ring", color = JELLY, radius = 9, at = "feet" }, { "shake", amount = 0.6 } }, text = "DOSUKOIII !", hitText = "BADABOUM !",
		},
		-- K puis P : gifle tournante, il tourne sur lui-même bras tendu comme une hélice molle
		KP_combo = {
			label = "Gifle tournante", startup = 0.12, active = 0.14, recovery = 0.26,
			damage = 8, hitbox = box(7, 3.5, 0.5, 0.5), kbBase = 26, kbGrowth = 40, kbAngle = 35,
			windup = { Root = { 0, -30, 0, 0, -0.35, 0 }, Waist = { 0, -20, 0 }, RS = { 80, 0, 70 }, RE = { 20, 0, 0 }, LS = { 80, 0, -70 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 0, 0, 0, 0, -0.35, 0 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 0, 0, 0, 0, -0.35, 0 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			spin = { axis = "y", degrees = 360 }, trail = "bothHands", hitText = "FLAP FLAP !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : Coup de bide, il cambre le dos et lance son ventre devant lui
		P_air_side = {
			label = "Coup de bide volant", startup = 0.11, active = 0.12, recovery = 0.2,
			damage = 8, hitbox = box(4.5, 4, 2.4, 0), kbBase = 26, kbGrowth = 40, kbAngle = 25,
			windup = { Root = { -16, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 80, 0, 20 }, RE = { 60, 0, 0 }, LS = { 80, 0, -20 }, LE = { 60, 0, 0 }, RH = { 80, 0, 5 }, RK = { -110, 0, 0 }, LH = { 80, 0, -5 }, LK = { -110, 0, 0 } },
			strike = { Root = { 24, 0, 0 }, Waist = { 24, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -50, 0, 40 }, RE = { 15, 0, 0 }, LS = { -50, 0, -40 }, LE = { 15, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 }, LH = { -20, 0, -10 }, LK = { -50, 0, 0 } },
			follow = { Root = { 28, 0, 0 }, Waist = { 26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -55, 0, 45 }, RE = { 15, 0, 0 }, LS = { -55, 0, -45 }, LE = { 15, 0, 0 }, RH = { -25, 0, 12 }, RK = { -55, 0, 0 }, LH = { -25, 0, -12 }, LK = { -55, 0, 0 } },
			wobble = true, hitText = "BLOING !",
		},
		-- ↑ P en l'air : Claque au plafond, les deux paumes se rejoignent au-dessus de sa tête (CLAP)
		P_air_up = {
			label = "Claque au plafond", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 42, kbAngle = 86,
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 120, 0, 90 }, RE = { 10, 0, 0 }, LS = { 120, 0, -90 }, LE = { 10, 0, 0 }, RH = { 70, 0, 10 }, RK = { -100, 0, 0 }, LH = { 70, 0, -10 }, LK = { -100, 0, 0 } },
			strike = { Root = { 8, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, -2 }, RE = { 0, 0, 0 }, LS = { 178, 0, 2 }, LE = { 0, 0, 0 }, RH = { 10, 0, 10 }, RK = { -40, 0, 0 }, LH = { 10, 0, -10 }, LK = { -40, 0, 0 } },
			follow = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, -4 }, RE = { 0, 0, 0 }, LS = { 180, 0, 4 }, LE = { 0, 0, 0 }, RH = { 8, 0, 10 }, RK = { -38, 0, 0 }, LH = { 8, 0, -10 }, LK = { -38, 0, 0 } },
			trail = "bothHands", fx = { { "burst", color = MARSH, size = 2.5, at = "above" } }, text = "CLAP !", hitText = "PAF !",
		},
		-- ↓ P en l'air : Plat ventre amorti, il s'étale à plat ventre et tombe sur l'adversaire (smash)
		P_air_down = {
			label = "Plat ventre amorti", startup = 0.15, active = 0.14, recovery = 0.3,
			damage = 9, hitbox = box(5.5, 3.5, 0.5, -2), kbBase = 24, kbGrowth = 52, kbAngle = -75,
			windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 40 }, RE = { 20, 0, 0 }, LS = { 160, 0, -40 }, LE = { 20, 0, 0 }, RH = { 60, 0, 10 }, RK = { -90, 0, 0 }, LH = { 60, 0, -10 }, LK = { -90, 0, 0 } },
			strike = { Root = { -60, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, LS = { 90, 0, -80 }, LE = { 10, 0, 0 }, RH = { -10, 0, 20 }, RK = { -20, 0, 0 }, LH = { -10, 0, -20 }, LK = { -20, 0, 0 } },
			follow = { Root = { -64, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 92, 0, 84 }, RE = { 10, 0, 0 }, LS = { 92, 0, -84 }, LE = { 10, 0, 0 }, RH = { -12, 0, 22 }, RK = { -22, 0, 0 }, LH = { -12, 0, -22 }, LK = { -22, 0, 0 } },
			wobble = true, trail = "body", text = "PLAT VENTRE !", hitText = "SPLAF !",
		},
		-- → K en l'air : Ruade gélatineuse, il lance ses deux gros pieds devant lui en se penchant en arrière
		K_air_side = {
			label = "Ruade gélatineuse", startup = 0.16, active = 0.14, recovery = 0.26,
			damage = 11, hitbox = box(5, 3.5, 3, -0.3), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { -12, 0, 0 }, Waist = { -20, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 100, 0, 8 }, RK = { -130, 0, 0 }, LH = { 100, 0, -8 }, LK = { -130, 0, 0 } },
			strike = { Root = { 26, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { 85, 0, 8 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 80, 0, -8 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -36, 0, 55 }, RE = { 20, 0, 0 }, LS = { -36, 0, -55 }, LE = { 20, 0, 0 }, RH = { 90, 0, 8 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 86, 0, -8 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			wobble = true, trail = "bothFeet", hitText = "BLONK !",
		},
		-- ↑ K en l'air : Tête-ressort, son cou de gelée s'étire et sa tête part vers le haut
		K_air_up = {
			label = "Tête-ressort", startup = 0.15, active = 0.14, recovery = 0.26,
			damage = 10, hitbox = box(4, 5, 0.5, 3.8), kbBase = 30, kbGrowth = 66, kbAngle = 86,
			windup = { Root = { -12, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 30, 0, 30 }, RE = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, RH = { 90, 0, 10 }, RK = { -120, 0, 0 }, LH = { 90, 0, -10 }, LK = { -120, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 45, 0, 0 }, RS = { -40, 0, 30 }, RE = { 10, 0, 0 }, LS = { -40, 0, -30 }, LE = { 10, 0, 0 }, RH = { -10, 0, 8 }, RK = { -20, 0, 0 }, LH = { -10, 0, -8 }, LK = { -20, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 50, 0, 0 }, RS = { -45, 0, 32 }, RE = { 10, 0, 0 }, LS = { -45, 0, -32 }, LE = { 10, 0, 0 }, RH = { -12, 0, 8 }, RK = { -18, 0, 0 }, LH = { -12, 0, -8 }, LK = { -18, 0, 0 } },
			wobble = true, trail = "head", hitText = "BOÏNG !",
		},
		-- ↓ K en l'air : Shiko aérien, jambe levée sur le côté puis il retombe des deux pieds (smash)
		K_air_down = {
			label = "Shiko aérien", startup = 0.2, active = 0.16, recovery = 0.32,
			damage = 12, hitbox = box(5, 3, 0.5, -3), kbBase = 25, kbGrowth = 56, kbAngle = -80, selfVelocity = Vector2.new(0, -65),
			windup = { Root = { 0, 0, -12 }, Waist = { 4, 0, -8 }, RS = { 20, 0, 50 }, RE = { 40, 0, 0 }, LS = { 20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 30, 0, 70 }, RK = { -30, 0, 0 }, LH = { 10, 0, -10 }, LK = { -20, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 30, 0, 35 }, RE = { 100, 0, 0 }, LS = { 30, 0, -35 }, LE = { 100, 0, 0 }, RH = { -2, 0, 12 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -12 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 28, 0, 36 }, RE = { 105, 0, 0 }, LS = { 28, 0, -36 }, LE = { 105, 0, 0 }, RH = { -2, 0, 14 }, RK = { -4, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -14 }, LK = { -4, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "DOSUKOI !", hitText = "BOUM !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Boulette de gelée : il arrache un bout de son ventre et le lance en cloche (projectile ralentissant)
		S_neutral = {
			label = "Boulette de gelée", energyCost = 25, kind = "projectile", startup = 0.2, active = 0, recovery = 0.32,
			damage = 8, kbBase = 18, kbGrowth = 25, kbAngle = 35,
			projectile = { speed = 55, angle = 18, gravity = 70, lifetime = 1.2, size = 1.8, color = JELLY,
				visual = { shape = "ball", size = 1.6, color = JELLY, transparency = 0.3, spin = 6 } },
			status = { name = "slowed", duration = 2 },
			windup = { Root = { -4, -14, 0, 0, -0.35, 0.2 }, Waist = { -10, -16, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, -25 }, RE = { 110, 0, 0 }, LS = { 40, 0, -20 }, LE = { 80, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -8, 14, 0, 0, -0.4, -0.25 }, Waist = { -10, 18, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, 5 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { -10, 18, 0, 0, -0.42, -0.3 }, Waist = { -12, 22, 0 }, Neck = { 8, 0, 0 }, RS = { 100, 0, -5 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 15, 0, -42 }, LE = { 60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			shake = true, windupFx = { { "burst", color = JELLY, size = 1.5, at = "root" } }, text = "SCHLOUP !", hitText = "SPLOTCH !",
		},
		-- Charge Sumo : tête baissée, mains en avant, il fonce et rien ne l'arrête (super-armure)
		S_side = {
			label = "Charge Sumo", energyCost = 30, startup = 0.18, active = 0.36, recovery = 0.36,
			damage = 12, hitbox = box(5, 4, 2.4, 0.4), kbBase = 34, kbGrowth = 74, kbAngle = 28, selfVelocity = Vector2.new(62, 0), armor = true,
			windup = { Root = { -10, 0, 0, 0, -0.8, 0.3 }, Waist = { -18, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, 30 }, RE = { 100, 0, 0 }, LS = { 40, 0, -30 }, LE = { 100, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -24, 0, 0, 0, -0.55, -0.35 }, Waist = { -12, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 88, 0, 12 }, RE = { 20, 0, 0 }, RW = { -70, 0, 0 }, LS = { 88, 0, -12 }, LE = { 20, 0, 0 }, LW = { -70, 0, 0 } },
			follow = { Root = { -26, 0, 0, 0, -0.56, -0.4 }, Waist = { -13, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 90, 0, 10 }, RE = { 18, 0, 0 }, RW = { -72, 0, 0 }, LS = { 90, 0, -10 }, LE = { 18, 0, 0 }, LW = { -72, 0, 0 } },
			wobble = true, trail = "body", fx = { "dust", { "shake", amount = 0.3 } }, text = "CHARGE SUMO !", hitText = "BOUM !",
		},
		-- La Flaque : il se liquéfie en flaque (les tirs passent au-dessus), puis rejaillit en uppercut massif
		S_down = {
			label = "La Flaque", energyCost = 30, startup = 0.4, active = 0.14, recovery = 0.36, invuln = 0.4,
			damage = 14, hitbox = box(5, 7, 1.5, 2.5), kbBase = 34, kbGrowth = 82, kbAngle = 86,
			windup = { Root = { 0, 0, 0, 0, -1.8, 0 }, Waist = { -40, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 30, 0, 85 }, RE = { 10, 0, 0 }, LS = { 30, 0, -85 }, LE = { 10, 0, 0 }, RH = { 80, 0, 40 }, RK = { -120, 0, 0 }, LH = { 80, 0, -40 }, LK = { -120, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.35, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 15 }, RE = { 5, 0, 0 }, LS = { 175, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0.3, 0.35, 0 }, FL = { 0, 0, 0, -0.3, 0.35, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.4, 0 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 20 }, RE = { 5, 0, 0 }, LS = { 180, 0, -20 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0.3, 0.4, 0 }, FL = { 0, 0, 0, -0.3, 0.4, 0 } },
			wobble = true, windupFx = { { "puddle", color = JELLY, width = 6, time = 0.5 } },
			fx = { { "pillar", color = JELLY, height = 9, width = 3.5, at = "front", time = 0.5 }, { "toss", shape = "ball", color = JELLY, size = 0.8, count = 5, speed = 14, lift = 26 } },
			text = "GLOUBI…", hitText = "BOULGA !",
		},
		-- Tremblote géante (remontée, gratuite) : il s'étire vers le ciel comme un ressort vert, frappe deux fois
		S_up = {
			label = "Tremblote géante", energyCost = 0, startup = 0.08, active = 0.3, recovery = 0.3, hits = 2,
			damage = 4, hitbox = box(4.5, 8, 0.5, 3), kbBase = 28, kbGrowth = 38, kbAngle = 84, selfVelocity = Vector2.new(6, 92),
			windup = { Root = { 0, 0, 0, 0, -1.0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 } },
			strike = { Root = { 2, 0, 0, 0, 0.6, 0 }, Waist = { 6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 180, 0, 6 }, RE = { 0, 0, 0 }, LS = { 180, 0, -6 }, LE = { 0, 0, 0 }, RH = { -4, 0, 3 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { -4, 0, -3 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 2, 0, 0, 0, 0.6, 0 }, Waist = { 8, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 178, 0, 12 }, RE = { 5, 0, 0 }, LS = { 178, 0, -12 }, LE = { 5, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 10, 0, -10 }, LK = { -30, 0, 0 } },
			wobble = true, trail = "body", fx = { { "pillar", color = JELLY, height = 6, width = 2.5, time = 0.35 } }, text = "BOÏÏÏNG !", hitText = "TCHAC !",
		},
		-- Trampoline (esquive puis S) : ventre gonflé à bloc, bras écartés, il renvoie les projectiles
		S_dodge = {
			label = "Trampoline", energyCost = 25, kind = "wall", startup = 0.1, active = 0.6, recovery = 0.3,
			hitbox = box(5, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 45, kbAngle = 30,
			damage = 7,
			wall = { size = Vector3.new(1.5, 6, 6), offset = 2.2, lifetime = 1.4, max = 1, reflect = true, follow = true, solid = false, color = JELLY,
				visual = { shape = "disc", size = 5.5, color = JELLY, transparency = 0.45, trail = false } },
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.2 }, Waist = { -14, 0, 0 }, RS = { 60, 0, 20 }, RE = { 70, 0, 0 }, LS = { 60, 0, -20 }, LE = { 70, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 20, 0, 0, 0, -0.3, -0.1 }, Waist = { 24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 85 }, RE = { 10, 0, 0 }, LS = { 60, 0, -85 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 22, 0, 0, 0, -0.3, -0.1 }, Waist = { 26, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 62, 0, 88 }, RE = { 10, 0, 0 }, LS = { 62, 0, -88 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			hold = 0.2, wobble = true, fx = { { "ring", color = JELLY, radius = 4, at = "front" } }, text = "TRAMPOLINE !",
		},
		-- Gonflement (S maintenu) : il inspire, gonfle comme un ballon et devient inébranlable un moment
		S_hold = {
			label = "Gonflement", energyCost = 35, startup = 0.3, active = 0, recovery = 0.4,
			hitbox = box(6, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 9,
			selfEffect = { heal = 6, armor = 2.5 },
			windup = { Root = { -4, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 6, 0, 0, 0, -0.05, 0 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 80 }, RE = { 10, 0, 0 }, LS = { 40, 0, -80 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.5, 0, 0 }, FL = { 0, 0, 0, -0.5, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.05, 0 }, Waist = { 16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 42, 0, 84 }, RE = { 10, 0, 0 }, LS = { 42, 0, -84 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.5, 0, 0 }, FL = { 0, 0, 0, -0.5, 0, 0 } },
			hold = 0.4, shake = true, fx = { { "ring", color = JELLY, radius = 5, at = "root" }, { "symbols", symbols = { "💪", "🍮" }, color = JELLY, count = 4, radius = 3 } },
			text = "INÉBRANLABLE !",
		},
		-- Roulade gluante (→→S) : il se met en boule et roule deux fois en avant
		S_dash = {
			label = "Roulade gluante", energyCost = 25, startup = 0.08, active = 0.34, recovery = 0.32, hits = 2,
			damage = 5, hitbox = box(5, 4, 1.8, 0), kbBase = 28, kbGrowth = 55, kbAngle = 40, selfVelocity = Vector2.new(58, 0), invuln = 0.12,
			windup = { Root = { -16, 0, 0, 0, -0.7, 0 }, Waist = { -30, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 70, 0, 20 }, RE = { 110, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 } },
			strike = { Root = { -30, 0, 0, 0, -1.0, 0 }, Waist = { -40, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 60, 0, -10 }, RE = { 120, 0, 0 }, LS = { 60, 0, 10 }, LE = { 120, 0, 0 }, RH = { 120, 0, 5 }, RK = { -140, 0, 0 }, LH = { 120, 0, -5 }, LK = { -140, 0, 0 } },
			follow = { Root = { -30, 0, 0, 0, -1.0, 0 }, Waist = { -40, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 60, 0, -10 }, RE = { 120, 0, 0 }, LS = { 60, 0, 10 }, LE = { 120, 0, 0 }, RH = { 120, 0, 5 }, RK = { -140, 0, 0 }, LH = { 120, 0, -5 }, LK = { -140, 0, 0 } },
			spin = { axis = "x", degrees = 720 }, trail = "body", fx = { { "puddle", color = JELLY, width = 6 } }, text = "ROULÉ-BOULÉ !", hitText = "SPLOTCH !",
		},
		-- Pluie de gelée (S en l'air) : il secoue le ventre et trois boulettes de gelée partent vers le bas
		S_air = {
			label = "Pluie de gelée", energyCost = 20, kind = "projectile", startup = 0.16, active = 0, recovery = 0.3,
			damage = 5, kbBase = 16, kbGrowth = 22, kbAngle = 30,
			projectile = { speed = 50, angle = -35, gravity = 50, lifetime = 0.8, size = 1.4, color = JELLY, fan = { count = 3, from = -60, to = -15 },
				visual = { shape = "ball", size = 1.2, color = JELLY, transparency = 0.3 } },
			status = { name = "slowed", duration = 1.5 },
			windup = { Root = { -8, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 40, 0, -20 }, RE = { 110, 0, 0 }, LS = { 40, 0, 20 }, LE = { 110, 0, 0 }, RH = { 70, 0, 10 }, RK = { -100, 0, 0 }, LH = { 70, 0, -10 }, LK = { -100, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 70, 0, 60 }, RE = { 10, 0, 0 }, LS = { 70, 0, -60 }, LE = { 10, 0, 0 }, RH = { 20, 0, 10 }, RK = { -50, 0, 0 }, LH = { 20, 0, -10 }, LK = { -50, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 72, 0, 64 }, RE = { 10, 0, 0 }, LS = { 72, 0, -64 }, LE = { 10, 0, 0 }, RH = { 18, 0, 10 }, RK = { -48, 0, 0 }, LH = { 18, 0, -10 }, LK = { -48, 0, 0 } },
			shake = true, wobble = true, text = "SCHLOUP SCHLOUP !", hitText = "SPLOTCH !",
		},
		-- Le Splash (↓S en l'air) : bombe à eau, il tombe en boule et la gelée gicle de part et d'autre
		S_air_down = {
			label = "Le Splash", energyCost = 25, startup = 0.16, active = 0.36, recovery = 0.34,
			damage = 12, hitbox = box(7, 4, 0, -1.5), kbBase = 28, kbGrowth = 60, kbAngle = 45, selfVelocity = Vector2.new(0, -90),
			windup = { Root = { -10, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 30 }, RE = { 20, 0, 0 }, LS = { 160, 0, -30 }, LE = { 20, 0, 0 }, RH = { 60, 0, 10 }, RK = { -90, 0, 0 }, LH = { 60, 0, -10 }, LK = { -90, 0, 0 } },
			strike = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 110, 0, 0 }, LS = { 60, 0, 10 }, LE = { 110, 0, 0 }, RH = { 120, 0, 5 }, RK = { -140, 0, 0 }, LH = { 120, 0, -5 }, LK = { -140, 0, 0 } },
			follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 62, 0, -12 }, RE = { 112, 0, 0 }, LS = { 62, 0, 12 }, LE = { 112, 0, 0 }, RH = { 122, 0, 5 }, RK = { -140, 0, 0 }, LH = { 122, 0, -5 }, LK = { -140, 0, 0 } },
			trail = "body", fx = { { "puddle", color = JELLY, width = 9 }, { "toss", shape = "ball", color = JELLY, size = 0.9, count = 6, speed = 18, lift = 20 }, { "shake", amount = 0.5 } },
			text = "SPLAAASH !", hitText = "PLOUF !",
		},

		------------------------------------------------------------------ Finition avec S (dans un enchaînement)
		-- Grand Shiko : les deux bras en l'air puis un piétinement qui fait trembler toute la zone
		S_finish_shiko = {
			label = "Grand Shiko", energyCost = 20, startup = 0.22, active = 0.12, recovery = 0.34,
			damage = 11, hitbox = box(10, 3, 0.5, -1.5), kbBase = 34, kbGrowth = 70, kbAngle = 80,
			windup = { Root = { 0, 0, -16, -0.35, -0.1, 0 }, Waist = { 4, 0, -12 }, Neck = { 10, 0, 10 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, LS = { 170, 0, -30 }, LE = { 10, 0, 0 }, RH = { 30, 0, 80 }, RK = { -20, 0, 0 }, FL = WIDE_L },
			strike = { Root = { 8, 0, 0, 0, -0.75, 0 }, Waist = { 12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 30 }, RE = { 100, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0.5, 0, 0 }, FL = WIDE_L },
			follow = { Root = { 10, 0, 0, 0, -0.8, 0 }, Waist = { 14, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 28, 0, 32 }, RE = { 105, 0, 0 }, LS = { 28, 0, -32 }, LE = { 105, 0, 0 }, FR = { 0, 0, 0, 0.5, 0, 0 }, FL = WIDE_L },
			hold = 0.1, trail = "rightFoot", fx = { { "ring", color = JELLY, radius = 10, at = "feet" }, { "shake", amount = 0.7 } }, text = "GRAND SHIKO !", hitText = "BADABOUM !",
		},

		------------------------------------------------------------------ Supers
		-- Division : il se secoue, se coupe en trois et trois mini-sumos roulent vers l'adversaire
		SUPER = {
			label = "Division !", kind = "projectile", superCost = 100, startup = 0.35, active = 0, recovery = 0.5,
			damage = 8, kbBase = 30, kbGrowth = 55, kbAngle = 40,
			projectile = { speed = 40, angle = 12, gravity = 80, lifetime = 1.8, size = 2.4, color = JELLY, bounce = 3, fan = { count = 3, from = 0, to = 35 },
				visual = { shape = "ball", size = 2.2, color = JELLY, transparency = 0.25, spin = 4, parts = {
					{ "ball", Vector3.new(0.6, 0.5, 0.6), Vector3.new(0, 1.15, 0), HAIR },
					{ "block", Vector3.new(2.2, 0.5, 2.2), Vector3.new(0, -0.4, 0), MAWASHI },
				} } },
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 140, 0, 70 }, RE = { 0, 0, 0 }, LS = { 140, 0, -70 }, LE = { 0, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 8, 0, 0, 0, 0.12, 0 }, Waist = { 16, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 150, 0, 75 }, RE = { 0, 0, 0 }, LS = { 150, 0, -75 }, LE = { 0, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			shake = true, windupFx = { "super" }, fx = { { "burst", color = JELLY, size = 4, at = "root" } }, text = "DIVISION !", hitText = "TRIPLE BOÏNG !",
		},
		-- Super ↑ : il tape du pied si fort que la gelée du sol jaillit en geyser
		SUPER_up = {
			label = "Shiko volcanique !", superCost = 100, startup = 0.4, active = 0.3, recovery = 0.6,
			damage = 22, hitbox = box(8, 14, 4, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -9.6, 0, 0, 0, -0.6, 0.3 }, Waist = { -19.2, 0, 0 }, Neck = { -7.2, 0, 0 }, RS = { 72, 0, 24 }, RE = { 108, 0, 0 }, LS = { 72, 0, -24 }, LE = { 108, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 26.4, 0, 0, 0, -0.15, 0.45 }, Waist = { 31.2, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 144, 0, 90 }, RE = { 12, 0, 0 }, LS = { 144, 0, -90 }, LE = { 12, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 28.8, 0, 0, 0, -0.12, 0.5 }, Waist = { 33.6, 0, 0 }, Neck = { 28.8, 0, 0 }, RS = { 153.6, 0, 96 }, RE = { 12, 0, 0 }, LS = { 153.6, 0, -96 }, LE = { 12, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			hold = 0.45, shake = true,
			windupFx = { "super" }, status = { name = "slowed", duration = 2 }, fx = { { "pillar", color = Color3.fromRGB(110, 220, 90), height = 20, width = 6, at = "front" }, { "shake", amount = 0.6 } }, text = "DOSUKOI !", hitText = "GLOUP !",
		},
		-- Tsunami de gelée : il frappe le sol à deux mains, une énorme vague verte traverse l'arène
		SUPER_down = {
			label = "Tsunami de gelée !", kind = "projectile", superCost = 100, startup = 0.4, active = 0, recovery = 0.55,
			damage = 20, kbBase = 34, kbGrowth = 70, kbAngle = 40,
			projectile = { speed = 45, angle = 0, gravity = 0, lifetime = 1.3, size = 6, color = JELLY, pierce = true, from = "feet",
				visual = { shape = "block", size = 6, color = JELLY, transparency = 0.35, parts = { { "ball", Vector3.new(4, 2.5, 4), Vector3.new(0, 3, 0), JELLY } } } },
			status = { name = "slowed", duration = 3 },
			windup = { Root = { 6, 0, 0, 0, 0.2, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 180, 0, 20 }, RE = { 10, 0, 0 }, LS = { 180, 0, -20 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -20, 0, 0, 0, -0.9, -0.2 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { -22, 0, 0, 0, -0.95, -0.25 }, Waist = { -32, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 55, 0, 12 }, RE = { 0, 0, 0 }, RW = { -65, 0, 0 }, LS = { 55, 0, -12 }, LE = { 0, 0, 0 }, LW = { -65, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			hold = 0.3, windupFx = { "super" }, fx = { { "shake", amount = 0.8, time = 0.6 }, { "puddle", color = JELLY, width = 12, time = 1.5 } },
			text = "TSUNAMI DE GELÉE !", hitText = "GLOUGLOUBLOUB !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Absorption : bras grands ouverts, il referme sa bedaine sur l'adversaire, qui s'enfonce dans la gelée
		GRAB = {
			label = "Avalé tout cru", kind = "grab", startup = 0.12, active = 0.12, recovery = 0.38,
			damage = 0, hitbox = box(4.5, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, 70 }, RE = { 10, 0, 0 }, LS = { 110, 0, -70 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { -10, 0, 0, 0, -0.4, -0.35 }, Waist = { -10, 0, 0 }, RS = { 80, 0, -25 }, RE = { 85, 0, 0 }, LS = { 80, 0, 25 }, LE = { 85, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { -6, 0, 0, 0, -0.35, -0.3 }, Waist = { -6, 0, 0 }, RS = { 82, 0, -30 }, RE = { 92, 0, 0 }, LS = { 82, 0, 30 }, LE = { 92, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, text = "GLOUP !", hitText = "AVALÉ !",
		},
		-- ✋ puis → : Recraché, il contracte le ventre et recrache l'adversaire au loin (boing !)
		THROW_fwd = {
			label = "Recraché", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 42, kbGrowth = 55, kbAngle = 18,
			carry = { { 0, 1.6, 0.2 }, { 0.18, 1.0, 0.1 }, { 0.32, 4.2, 0.3 } },
			windup = { Root = { -12, 0, 0, 0, -0.5, 0.3 }, Waist = { -22, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -20 }, RE = { 90, 0, 0 }, LS = { 70, 0, 20 }, LE = { 90, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 18, 0, 0, 0, -0.3, -0.5 }, Waist = { 24, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -40, 0, 50 }, RE = { 15, 0, 0 }, LS = { -40, 0, -50 }, LE = { 15, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 20, 0, 0, 0, -0.3, -0.55 }, Waist = { 26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -45, 0, 55 }, RE = { 15, 0, 0 }, LS = { -45, 0, -55 }, LE = { 15, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, text = "PTOUI !", hitText = "BOING !",
		},
		-- ✋ puis ← : Rebond arrière, il se cambre et l'adversaire rebondit par-dessus sa tête derrière lui
		THROW_back = {
			label = "Rebond arrière", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.38,
			damage = 11, kbBase = 36, kbGrowth = 66, kbAngle = 45,
			carry = { { 0, 1.6, 0.2 }, { 0.14, 1.0, 1.6 }, { 0.28, -0.6, 3.4 }, { 0.4, -2.6, 0.8 } },
			windup = { Root = { -6, 0, 0, 0, -0.7, 0.1 }, Waist = { -14, 0, 0 }, RS = { 80, 0, -15 }, RE = { 70, 0, 0 }, LS = { 80, 0, 15 }, LE = { 70, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 30, 0, 0, 0, -0.5, 0.3 }, Waist = { 30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 190, 0, -10 }, RE = { 20, 0, 0 }, LS = { 190, 0, 10 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			follow = { Root = { 34, 0, 0, 0, -0.55, 0.35 }, Waist = { 34, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 196, 0, -12 }, RE = { 20, 0, 0 }, LS = { 196, 0, 12 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			wobble = true, text = "HOP !", hitText = "BOÏNG BOÏNG !",
		},
		-- ✋ puis ↑ : Trampoline, l'adversaire posé sur son ventre, il s'accroupit puis le fait rebondir vers le ciel
		THROW_up = {
			label = "Trampoline de bedaine", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.36,
			damage = 10, kbBase = 40, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 1.6, 0.2 }, { 0.16, 1.2, 1.2 }, { 0.26, 1.0, 0.6 }, { 0.34, 1.0, 4.5 } },
			windup = { Root = { 20, 0, 0, 0, -0.9, 0.2 }, Waist = { 20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 24, 0, 0, 0, 0.3, 0.2 }, Waist = { 26, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 60 }, RE = { 10, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.35, 0.25, 0 }, FL = { 0, 0, 0, -0.35, 0.25, 0 } },
			follow = { Root = { 26, 0, 0, 0, 0.35, 0.2 }, Waist = { 28, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 158, 0, 66 }, RE = { 10, 0, 0 }, LS = { 158, 0, -66 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0.35, 0.3, 0 }, FL = { 0, 0, 0, -0.35, 0.3, 0 } },
			wobble = true, text = "BOÏÏÏNG !", hitText = "VERS LE CIEL !",
		},
		-- ✋ puis ↓ : Dodo dans la gelée, il pose l'adversaire par terre et s'assoit lourdement dessus
		THROW_down = {
			label = "Dodo dans la gelée", kind = "throw", startup = 0.42, active = 0.1, hold = 0.3, recovery = 0.38,
			damage = 11, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 1.6, 0.2 }, { 0.16, 2.0, 1.2 }, { 0.3, 1.2, -2.0 }, { 0.42, 0.4, -2.4 } },
			windup = { Root = { 8, 0, 0, 0, 0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 }, FR = WIDE_R, FL = WIDE_L },
			strike = { Root = { 10, 0, 0, 0, -1.5, -0.6 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 }, RH = { 85, 0, 20 }, RK = { -40, 0, 0 }, LH = { 85, 0, -20 }, LK = { -40, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -1.5, -0.6 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 40 }, RE = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 }, RH = { 88, 0, 20 }, RK = { -40, 0, 0 }, LH = { 88, 0, -20 }, LK = { -40, 0, 0 } },
			wobble = true, fx = { { "shake", amount = 0.5 }, { "symbols", symbols = { "Z", "z" }, color = Color3.fromRGB(170, 200, 255), count = 3, radius = 2 } },
			text = "BONNE NUIT !", hitText = "SQUISH !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "le_dessert", label = "Le Dessert", sequence = { "down", "down", "forward" },
			-- figé dans un moule à gelée, servi sur une assiette avec une cerise
			scene = {
				{ "text", "À TABLE !" },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.9, 0), life = 4, pieces = {
					{ "Assiette", "", "cyl", Vector3.new(0.3, 7, 7), Vector3.zero, Vector3.new(0, 0, 90), Color3.fromRGB(250, 250, 255), "Marble" },
				} },
				{ "wait", 0.3 },
				{ "color", JELLY },
				{ "material", "Glass" },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 3.7, pieces = {
					{ "Moule", "", "block", Vector3.new(4.5, 5.6, 4.5), Vector3.zero, Vector3.zero, JELLY, "Glass", { transparency = 0.5 } },
					{ "Chantilly", "", "ball", Vector3.new(3, 1.2, 3), Vector3.new(0, 3.2, 0), Vector3.zero, Color3.fromRGB(255, 252, 245), "SmoothPlastic" },
					{ "Cerise", "", "ball", Vector3.new(1, 1, 1), Vector3.new(0, 4.2, 0), Vector3.zero, Color3.fromRGB(220, 20, 40), "SmoothPlastic" },
					{ "Queue", "", "cyl", Vector3.new(0.8, 0.1, 0.1), Vector3.new(0.2, 4.9, 0), Vector3.new(0, 0, 70), Color3.fromRGB(60, 120, 40) },
				} },
				{ "squash", 0.8 },
				{ "fxAttacker", { "text", text = "BON APPÉTIT !", color = PINK } },
				{ "wait", 1.4 },
			},
		},
		{
			id = "le_bain", label = "Le Bain", sequence = { "forward", "back", "forward" },
			-- englouti dans la gelée, il flotte tout petit à côté du canard en plastique
			scene = {
				{ "text", "GLOUP ?" },
				{ "move", to = "attacker", offset = Vector3.new(0, 0, -0.6), time = 0.5 },
				{ "shrink", 0.35, time = 0.5 },
				{ "fxAttacker", { "ring", color = JELLY, radius = 4, at = "root" } },
				{ "fxAttacker", { "text", text = "PLOUF !", color = JELLY } },
				{ "spawn", at = "attacker", offset = Vector3.new(0.8, 0.3, -1.2), life = 3, pieces = {
					{ "Canard", "", "ball", Vector3.new(0.9, 0.7, 1.1), Vector3.zero, Vector3.zero, DUCK },
					{ "TeteCanard", "", "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0, 0.55, -0.35), Vector3.zero, DUCK },
					{ "Bec", "", "block", Vector3.new(0.3, 0.12, 0.3), Vector3.new(0, 0.5, -0.75), Vector3.zero, BEAK },
				} },
				{ "orbit", 1.2, turns = 2, time = 2 },
				{ "fx", { "symbols", symbols = { "🫧", "🦆" }, color = JELLY, count = 5, radius = 1.5 } },
				{ "wait", 0.6 },
			},
		},
		{
			id = "rebond_infini", label = "Rebond infini", sequence = { "up", "down", "down" },
			-- il rebondit sur le ventre du Sumo, de plus en plus haut, jusqu'à quitter l'atmosphère
			scene = {
				{ "move", to = "attacker", offset = Vector3.new(0, 3.5, 0), time = 0.3 },
				{ "fxAttacker", { "text", text = "BOÏNG !", color = JELLY } },
				{ "lift", 4, time = 0.3 },
				{ "move", to = "attacker", offset = Vector3.new(0, 3.5, 0), time = 0.25 },
				{ "fxAttacker", { "text", text = "BOÏÏNG !", color = JELLY } },
				{ "lift", 8, time = 0.35 },
				{ "move", to = "attacker", offset = Vector3.new(0, 3.5, 0), time = 0.3 },
				{ "fxAttacker", { "text", text = "BOÏÏÏÏNG !!!", color = JELLY } },
				{ "fxAttacker", { "ring", color = JELLY, radius = 6, at = "root" } },
				{ "launch", Vector3.new(0, 160, 0), time = 1.2 },
				{ "fx", { "burst", color = Color3.fromRGB(255, 240, 150), size = 5 } },
				{ "text", "BONJOUR LA LUNE !" },
				{ "wait", 0.4 },
			},
		},
	},

	-- Mécanique : Rebond. Qui le frappe au corps à corps rebondit un peu en arrière (server/Mechanics.lua)
	passive = { kind = "bounce", name = "Rebond", icon = "🍮", color = JELLY },

	-- Recharge ⚡ : rituel du sel lancé en l'air, puis il tape des pieds (shiko droite, shiko gauche) :
	-- toute la gelée tremblote et le canard tourne en rond
	charge = {
		label = "Rituel du sel",
		loop = 2.0,
		lockWrist = false,
		color = JELLY,
		keys = {
			{ 0.0, { Root = { 0, -10, 0, 0, -0.4, 0 }, Waist = { -6, -10, 0 }, RS = { -30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 20, 0, -30 }, LE = { 70, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
			{ 0.3, { Root = { 4, 10, 0, 0, -0.25, 0 }, Waist = { 10, 10, 0 }, Neck = { 20, 0, 0 }, RS = { 165, 0, 30 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 20, 0, -30 }, LE = { 70, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
			{ 0.55, { Root = { 0, 0, 0, 0, -0.45, 0 }, Waist = { 4, 0, 0 }, RS = { 30, 0, 30 }, RE = { 100, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
			{ 0.85, { Root = { 0, 0, -14, -0.3, -0.25, 0 }, Waist = { 4, 0, -10 }, RS = { 20, 0, 40 }, RE = { 30, 0, 0 }, LS = { 10, 0, -30 }, LE = { 60, 0, 0 }, RH = { 30, 0, 70 }, RK = { -30, 0, 0 }, FL = WIDE_L } },
			{ 1.05, { Root = { 6, 0, 0, 0, -0.65, 0 }, Waist = { 10, 0, 0 }, RS = { 30, 0, 30 }, RE = { 100, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
			{ 1.35, { Root = { 0, 0, 14, 0.3, -0.25, 0 }, Waist = { 4, 0, 10 }, LS = { 20, 0, -40 }, LE = { 30, 0, 0 }, RS = { 10, 0, 30 }, RE = { 60, 0, 0 }, LH = { 30, 0, -70 }, LK = { -30, 0, 0 }, FR = WIDE_R } },
			{ 1.55, { Root = { 6, 0, 0, 0, -0.65, 0 }, Waist = { 10, 0, 0 }, RS = { 30, 0, 30 }, RE = { 100, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
			{ 2.0, { Root = { 0, -10, 0, 0, -0.4, 0 }, Waist = { -6, -10, 0 }, RS = { -30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 20, 0, -30 }, LE = { 70, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		},
		beats = {
			{ 0.3, { "rain", shape = "ball", color = SALT, count = 10, radius = 3, size = 0.25 } },
			{ 1.05, { "ring", color = JELLY, radius = 4, at = "feet" } },
			{ 1.05, { "text", text = "DOSU…", color = JELLY } },
			{ 1.55, { "ring", color = JELLY, radius = 4, at = "feet" } },
			{ 1.55, { "text", text = "…KOI !", color = JELLY } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- il se tapote la bedaine des deux mains, ça tremblote de partout
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.3, { RS = { 40, 0, -10 }, RE = { 70, 0, 0 }, LS = { 40, 0, 10 }, LE = { 70, 0, 0 }, Neck = { -15, 0, 0 } } },
			{ 0.5, { RS = { 30, 0, -5 }, RE = { 60, 0, 0 }, LS = { 30, 0, 5 }, LE = { 60, 0, 0 }, Neck = { -15, 0, 0 }, Root = { 2, 0, 3 } } },
			{ 0.7, { RS = { 40, 0, -10 }, RE = { 70, 0, 0 }, LS = { 40, 0, 10 }, LE = { 70, 0, 0 }, Neck = { -15, 0, 0 }, Root = { -2, 0, -3 } } },
			{ 0.9, { RS = { 30, 0, -5 }, RE = { 60, 0, 0 }, LS = { 30, 0, 5 }, LE = { 60, 0, 0 }, Neck = { -15, 0, 0 }, Root = { 2, 0, 3 } } },
			{ 1.8, {} },
		} },
		-- il lance une pincée de sel par-dessus son épaule
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.35, { RS = { -20, 0, 30 }, RE = { 50, 0, 0 }, Waist = { 0, -10, 0 } } },
			{ 0.7, { RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, Waist = { 6, 10, 0 }, Neck = { 20, 0, 0 } } },
			{ 1.0, { RS = { 172, 0, 25 }, RE = { 10, 0, 0 }, Waist = { 6, 10, 0 }, Neck = { 22, 0, 0 } } },
			{ 1.6, {} },
		} },
		-- il regarde son canard dans son ventre et lui fait coucou
		{ duration = 2.0, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -35, 0, 0 }, Waist = { -10, 0, 0 }, LS = { 60, 0, 10 }, LE = { 100, 0, 0 } } },
			{ 0.7, { Neck = { -35, 0, 0 }, Waist = { -10, 0, 0 }, LS = { 60, 0, 10 }, LE = { 100, 0, 0 }, LW = { 0, 30, 0 } } },
			{ 1.0, { Neck = { -35, 0, 0 }, Waist = { -10, 0, 0 }, LS = { 60, 0, 10 }, LE = { 100, 0, 0 }, LW = { 0, -30, 0 } } },
			{ 1.3, { Neck = { -35, 0, 0 }, Waist = { -10, 0, 0 }, LS = { 60, 0, 10 }, LE = { 100, 0, 0 }, LW = { 0, 30, 0 } } },
			{ 2.0, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : l'adversaire est enfoncé dans sa bedaine, les deux bras le serrent dedans
data.grabHold = {
	Root = { 12, 0, 0, 0, -0.35, 0.05 },
	Waist = { 14, 0, 0 },
	Neck = { 10, 0, 0 },
	RS = { 72, 0, -32 },
	RE = { 80, 0, 0 },
	LS = { 72, 0, 32 },
	LE = { 80, 0, 0 },
	FR = WIDE_R,
	FL = WIDE_L,
}

-- Retour 🪂 : il tombe du ciel sur un petit dohyō, gros PLOUF qui fait trembler l'arène, la gelée oscille
-- trois fois, puis il lance du sel en l'air
data.respawn = {
	duration = 1.9,
	platform = { pieces = {
		{ "Dohyo", "base", "block", Vector3.new(6, 1, 3.4), Vector3.new(0, -0.5, 0), Vector3.zero, CLAY, "Sand" },
		{ "Socle", "", "block", Vector3.new(6.4, 0.8, 3.8), Vector3.new(0, -1.3, 0), Vector3.zero, Color3.fromRGB(170, 135, 90), "Sand" },
		{ "Tawara1", "", "cyl", Vector3.new(5.6, 0.35, 0.35), Vector3.new(0, 0.05, -1.5), Vector3.new(0, 0, 90), Color3.fromRGB(230, 210, 150), "Fabric", { axis = "x" } },
		{ "Tawara2", "", "cyl", Vector3.new(5.6, 0.35, 0.35), Vector3.new(0, 0.05, 1.5), Vector3.new(0, 0, 90), Color3.fromRGB(230, 210, 150), "Fabric", { axis = "x" } },
		{ "Gelee", "", "ball", Vector3.new(2.4, 0.4, 2), Vector3.new(1.6, 0.1, 0.4), Vector3.zero, JELLY, "SmoothPlastic", { transparency = 0.3 } },
		{ "Sel", "", "cyl", Vector3.new(0.6, 0.5, 0.5), Vector3.new(-2.4, 0.3, 0.8), Vector3.zero, SALT, "SmoothPlastic" },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -1.0, 0 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 0.22, { Root = { 0, 0, 0, 0, 0.15, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 40 }, RE = { 10, 0, 0 }, LS = { 120, 0, -40 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 0.42, { Root = { 0, 0, 0, 0, -0.7, 0 }, Waist = { -8, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 0.6, { Root = { 0, 0, 0, 0, -0.05, 0 }, Waist = { 6, 0, 0 }, RS = { 90, 0, 40 }, RE = { 10, 0, 0 }, LS = { 90, 0, -40 }, LE = { 10, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 0.78, { Root = { 0, 0, 0, 0, -0.5, 0 }, Waist = { -4, 0, 0 }, RS = { 50, 0, 50 }, RE = { 30, 0, 0 }, LS = { 50, 0, -50 }, LE = { 30, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 0.95, { Root = { 0, 0, 0, 0, -0.3, 0 }, RS = { 30, 0, 30 }, RE = { 80, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 1.2, { Root = { 0, -10, 0, 0, -0.4, 0 }, Waist = { -6, -10, 0 }, RS = { -30, 0, 30 }, RE = { 60, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 1.45, { Root = { 4, 10, 0, 0, -0.25, 0 }, Waist = { 10, 10, 0 }, Neck = { 20, 0, 0 }, RS = { 168, 0, 30 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, FR = WIDE_R, FL = WIDE_L } },
		{ 1.9, {} },
	},
	beats = {
		{ 0.0, { "ring", color = JELLY, radius = 7, at = "feet" } },
		{ 0.0, { "shake", amount = 0.7 } },
		{ 0.02, { "text", text = "PLOUF !", color = JELLY } },
		{ 0.22, { "symbols", symbols = { "~", "≈" }, color = JELLY, count = 4, radius = 2.5 } },
		{ 1.45, { "rain", shape = "ball", color = SALT, count = 12, radius = 3, size = 0.25 } },
	},
}

-- Arbre d'enchaînements (voir Gege.lua) : simple et lisible pour les débutants (P P P, K K K, P K, K P)
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol, P…
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_shiko" },
	P_combo2 = { P = "P_combo3", K = "PK_combo", S = "S_finish_shiko" }, -- P P
	P_combo3 = { K = "K_neutral", S = "S_side" }, -- P P P
	PK_combo = { P = "P_combo3", K = "K_combo2", S = "S_finish_shiko" }, -- P K
	P_side = { P = "P_combo3", K = "K_side", S = "S_side" }, -- → P
	P_down = { P = "P_down2", K = "K_down", S = "S_finish_shiko" }, -- ↓ P
	P_down2 = { P = "P_air_up", K = "K_air_up", S = "S_air" }, -- ↓ P P (il décolle)
	P_up = { P = "P_combo2", K = "K_up", S = "S_finish_shiko" }, -- ↑ P
	P_dash = { P = "P_combo3", K = "K_combo2", S = "S_side" }, -- dash P
	-- au sol, K…
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_shiko" },
	K_combo2 = { K = "K_combo3", P = "KP_combo", S = "S_finish_shiko" }, -- K K
	K_combo3 = { S = "S_down" }, -- K K K
	KP_combo = { K = "K_combo3", P = "P_combo3", S = "S_finish_shiko" }, -- K P
	K_side = { P = "KP_combo", S = "S_side" }, -- → K
	K_down = { P = "P_down2", K = "K_combo3", S = "S_finish_shiko" }, -- ↓ K
	K_up = { P = "P_air_up", S = "S_finish_shiko" }, -- ↑ K
	K_dash = { P = "KP_combo", S = "S_finish_shiko" }, -- dash K
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

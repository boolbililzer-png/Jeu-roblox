-- Le Roi Pigeon : marquis déchu en cape de plumes, couronne en capsule, roucoule et commande sa nuée.
-- Invocateur : jauge « Nuée » de 6 pigeons qui reviennent avec le temps ; ses envois coûtent des pigeons (meterCost).
-- Arme sortie de la Caisse Bizarre : Baguette de pain (et la Nuée).
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local FEATHER = Color3.fromRGB(125, 130, 150)
local FEATHER_DARK = Color3.fromRGB(85, 90, 112)
local NECK = Color3.fromRGB(95, 140, 125) -- reflets verts du cou
local VELVET = Color3.fromRGB(105, 70, 130)
local VELVET_DARK = Color3.fromRGB(80, 52, 102)
local GOLD = Color3.fromRGB(225, 180, 60)
local BREAD = Color3.fromRGB(205, 150, 80)
local CRUST = Color3.fromRGB(240, 205, 140)
local CRUMB = Color3.fromRGB(232, 196, 130)
local SKIN = Color3.fromRGB(240, 214, 192)
local WIG = Color3.fromRGB(226, 226, 232)
local BEAK = Color3.fromRGB(215, 160, 140)
local WHITE = Color3.fromRGB(245, 245, 240)
local MARBLE = Color3.fromRGB(215, 215, 220)
local BRONZE = Color3.fromRGB(150, 110, 60)

-- Pigeon lancé (projectile) : corps, tête, bec, deux ailes ; symétrique car le projectile ne se retourne pas
local PIGEON_VISUAL = {
	shape = "ball", size = 1.1, color = FEATHER, spin = 0,
	parts = {
		{ "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0, 0.55, 0), NECK },
		{ "block", Vector3.new(0.18, 0.15, 0.35), Vector3.new(0, 0.5, -0.38), BEAK },
		{ "block", Vector3.new(0.9, 0.12, 0.6), Vector3.new(0.65, 0.25, 0), FEATHER_DARK },
		{ "block", Vector3.new(0.9, 0.12, 0.6), Vector3.new(-0.65, 0.25, 0), FEATHER_DARK },
	},
}
local function pigeonPieces(prefix, y)
	return {
		{ prefix .. "Corps", "", "ball", Vector3.new(0.8, 0.65, 1.0), Vector3.new(0, y, 0), Vector3.zero, FEATHER, "Fabric" },
		{ prefix .. "Tete", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(0, y + 0.45, -0.38), Vector3.zero, NECK, "SmoothPlastic" },
		{ prefix .. "Bec", "", "block", Vector3.new(0.12, 0.1, 0.25), Vector3.new(0, y + 0.4, -0.66), Vector3.zero, BEAK, "SmoothPlastic" },
	}
end

local data = {
	id = "Pigeon",
	name = "Le Roi Pigeon",
	costume = "Pigeon",
	style = "pigeon",
	flying = true, -- sait voler : un saut en l\'air de plus, plané, et un ↑L très puissant

	look = {
		body = { head = SKIN, upper = VELVET, lower = VELVET_DARK, arms = VELVET, hands = WHITE, legs = WHITE,
			feet = Color3.fromRGB(35, 30, 42) },
		cubeHead = 1.25,
		parts = {
			-- perruque poudrée de marquis, deux rouleaux sur les côtés et le catogan derrière
			{ "Perruque", "Head", "ball", Vector3.new(1.45, 0.75, 1.45), Vector3.new(0, 0.45, 0.08), Vector3.zero, WIG, "Fabric" },
			{ "RouleauG", "Head", "cyl", Vector3.new(0.6, 0.42, 0.42), Vector3.new(-0.72, 0.02, 0.15), Vector3.zero, WIG, "Fabric", { axis = "z" } },
			{ "RouleauD", "Head", "cyl", Vector3.new(0.6, 0.42, 0.42), Vector3.new(0.72, 0.02, 0.15), Vector3.zero, WIG, "Fabric", { axis = "z" } },
			{ "Catogan", "Head", "block", Vector3.new(0.5, 0.25, 0.12), Vector3.new(0, -0.15, 0.7), Vector3.zero, Color3.fromRGB(40, 30, 50), "Fabric" },
			-- la couronne : une capsule de soda, crans dorés
			{ "Capsule", "Head", "cyl", Vector3.new(0.3, 0.95, 0.95), Vector3.new(0.05, 0.92, 0), Vector3.new(0, 0, 8), GOLD, "Metal", { reflect = 0.2 } },
			{ "Crans", "Head", "cyl", Vector3.new(0.1, 1.08, 1.08), Vector3.new(0.05, 0.8, 0), Vector3.new(0, 0, 8), Color3.fromRGB(200, 150, 40), "Metal" },
			-- visage : petits yeux hautains, nez pincé, moustache fine
			{ "OeilG", "Head", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(-0.25, 0.12, -0.63), Vector3.zero, Color3.fromRGB(20, 20, 25) },
			{ "OeilD", "Head", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(0.25, 0.12, -0.63), Vector3.zero, Color3.fromRGB(20, 20, 25) },
			{ "Nez", "Head", "ball", Vector3.new(0.26, 0.3, 0.4), Vector3.new(0, -0.08, -0.72), Vector3.zero, Color3.fromRGB(235, 190, 175) },
			{ "Moustache", "Head", "block", Vector3.new(0.62, 0.07, 0.08), Vector3.new(0, -0.3, -0.66), Vector3.new(0, 0, 0), Color3.fromRGB(150, 150, 160) },
			-- jabot, col de plumes, grande cape, traîne
			{ "Jabot", "UpperTorso", "ball", Vector3.new(0.7, 0.85, 0.35), Vector3.new(0, 0.4, -0.55), Vector3.zero, WHITE, "Fabric" },
			{ "ColDePlumes", "UpperTorso", "ball", Vector3.new(2.3, 0.65, 1.45), Vector3.new(0, 0.85, 0.12), Vector3.zero, FEATHER_DARK, "Fabric" },
			{ "Cape", "UpperTorso", "block", Vector3.new(2.3, 2.7, 0.22), Vector3.new(0, -0.55, 0.68), Vector3.new(8, 0, 0), FEATHER, "Fabric" },
			{ "Traine", "UpperTorso", "wedge", Vector3.new(2.1, 0.9, 0.5), Vector3.new(0, -2.1, 0.95), Vector3.new(0, 180, 0), FEATHER_DARK, "Fabric" },
			{ "Echarpe", "UpperTorso", "block", Vector3.new(0.28, 2.0, 0.06), Vector3.new(0.15, 0, -0.52), Vector3.new(0, 0, 35), Color3.fromRGB(190, 40, 50), "Fabric" },
			{ "Medaille", "UpperTorso", "cyl", Vector3.new(0.06, 0.38, 0.38), Vector3.new(-0.5, 0.35, -0.54), Vector3.zero, GOLD, "Metal", { axis = "z" } },
			-- les deux pigeons perchés sur ses épaules
			{ "PigeonG", "LeftUpperArm", "ball", Vector3.new(0.75, 0.6, 0.95), Vector3.new(0, 0.85, 0.05), Vector3.zero, FEATHER, "Fabric" },
			{ "PigeonGTete", "LeftUpperArm", "ball", Vector3.new(0.42, 0.42, 0.42), Vector3.new(0, 1.25, -0.32), Vector3.zero, NECK },
			{ "PigeonGBec", "LeftUpperArm", "block", Vector3.new(0.12, 0.1, 0.22), Vector3.new(0, 1.2, -0.6), Vector3.zero, BEAK },
			{ "PigeonD", "RightUpperArm", "ball", Vector3.new(0.75, 0.6, 0.95), Vector3.new(0, 0.85, 0.05), Vector3.zero, FEATHER, "Fabric" },
			{ "PigeonDTete", "RightUpperArm", "ball", Vector3.new(0.42, 0.42, 0.42), Vector3.new(0, 1.25, -0.32), Vector3.zero, NECK },
			{ "PigeonDBec", "RightUpperArm", "block", Vector3.new(0.12, 0.1, 0.22), Vector3.new(0, 1.2, -0.6), Vector3.zero, BEAK },
			-- boucles dorées des souliers
			{ "BoucleG", "LeftFoot", "block", Vector3.new(0.45, 0.12, 0.08), Vector3.new(0, 0.12, -0.45), Vector3.zero, GOLD, "Metal" },
			{ "BoucleD", "RightFoot", "block", Vector3.new(0.45, 0.12, 0.08), Vector3.new(0, 0.12, -0.45), Vector3.zero, GOLD, "Metal" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : une longue baguette de pain bien dorée
			{ name = "PropBaguette", hand = "Right", visible = true, pieces = {
				{ "Pain", "", "cyl", Vector3.new(3.3, 0.42, 0.42), Vector3.new(0, -1.25, 0), Vector3.zero, BREAD, "Sand" },
				{ "Quignon", "", "ball", Vector3.new(0.42, 0.5, 0.42), Vector3.new(0, -2.9, 0), Vector3.zero, BREAD, "Sand" },
				{ "Croupion", "", "ball", Vector3.new(0.42, 0.45, 0.42), Vector3.new(0, 0.4, 0), Vector3.zero, BREAD, "Sand" },
				{ "Grigne1", "", "block", Vector3.new(0.1, 0.45, 0.1), Vector3.new(0, -0.6, -0.19), Vector3.new(25, 0, 0), CRUST },
				{ "Grigne2", "", "block", Vector3.new(0.1, 0.45, 0.1), Vector3.new(0, -1.35, -0.19), Vector3.new(25, 0, 0), CRUST },
				{ "Grigne3", "", "block", Vector3.new(0.1, 0.45, 0.1), Vector3.new(0, -2.1, -0.19), Vector3.new(25, 0, 0), CRUST },
			} },
			-- un pigeon dans la main gauche, prêt à partir (S, plongeons, Super)
			{ name = "PropPigeon", hand = "Left", visible = false, pieces = {
				{ "Corps", "", "ball", Vector3.new(0.8, 0.65, 1.0), Vector3.new(0, -0.45, 0), Vector3.zero, FEATHER, "Fabric" },
				{ "Tete", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(0, -0.05, -0.42), Vector3.zero, NECK },
				{ "Bec", "", "block", Vector3.new(0.12, 0.1, 0.25), Vector3.new(0, -0.1, -0.7), Vector3.zero, BEAK },
				{ "AileG", "", "block", Vector3.new(0.1, 0.45, 0.75), Vector3.new(-0.42, -0.4, 0.05), Vector3.new(0, 0, -25), FEATHER_DARK },
				{ "AileD", "", "block", Vector3.new(0.1, 0.45, 0.75), Vector3.new(0.42, -0.4, 0.05), Vector3.new(0, 0, 25), FEATHER_DARK },
			} },
			-- sachet de miettes (Jet de miettes, recharge)
			{ name = "PropMiettes", hand = "Left", visible = false, pieces = {
				{ "Sachet", "", "ball", Vector3.new(0.75, 0.9, 0.75), Vector3.new(0, -0.55, 0), Vector3.zero, Color3.fromRGB(210, 190, 150), "Fabric" },
				{ "Noeud", "", "ball", Vector3.new(0.3, 0.25, 0.3), Vector3.new(0, -0.08, 0), Vector3.zero, Color3.fromRGB(190, 40, 50), "Fabric" },
				{ "Miette", "", "ball", Vector3.new(0.18, 0.18, 0.18), Vector3.new(0.2, -1.1, -0.1), Vector3.zero, CRUMB },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Petit pied royal : menton levé, petit doigt en l'air, il pointe la pointe du soulier dans le tibia
		P_neutral = {
			label = "Petit pied royal", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 5, hitbox = box(4, 2.5, 2.6, -0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 4, -10, 0, 0, -0.15, 0.1 }, Waist = { 8, -6, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 25 }, RE = { 40, 0, 0 }, LS = { 30, 0, -40 }, LE = { 95, 0, 0 }, LW = { 0, 0, -30 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, RA = { -30, 0, 0 } },
			strike = { Root = { 10, 8, 0, 0, -0.1, -0.1 }, Waist = { 12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { -10, 0, 35 }, RE = { 20, 0, 0 }, LS = { 40, 0, -55 }, LE = { 95, 0, 0 }, LW = { 0, 0, -30 }, RH = { 82, 0, 0 }, RK = { -5, 0, 0 }, RA = { -35, 0, 0 } },
			follow = { Root = { 12, 10, 0, 0, -0.1, -0.15 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { -15, 0, 38 }, RE = { 20, 0, 0 }, LS = { 42, 0, -58 }, LE = { 95, 0, 0 }, LW = { 0, 0, -30 }, RH = { 88, 0, 0 }, RK = { -2, 0, 0 }, RA = { -40, 0, 0 } },
			trail = "rightFoot", hitText = "PLIC !",
		},
		-- Picorage rapide (P P) : il tend le cou comme un pigeon et les pigeons de ses épaules picorent trois fois
		P_combo2 = {
			label = "Picorage rapide", startup = 0.06, active = 0.18, recovery = 0.16,
			damage = 2, hits = 3, hitbox = box(4.5, 3.5, 2.5, 1), kbBase = 12, kbGrowth = 15, kbAngle = 20,
			windup = { Root = { 2, 0, 0, 0, -0.1, 0.15 }, Waist = { 8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 30, 0, 40 }, RE = { 70, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.25, -0.3 }, Waist = { -18, 0, 0 }, Neck = { -38, 0, 0 }, RS = { -20, 0, 55 }, RE = { 60, 0, 0 }, LS = { -20, 0, -55 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -8, 0, 0, 0, -0.2, -0.25 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -25, 0, 60 }, RE = { 60, 0, 0 }, LS = { -25, 0, -60 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			wobble = true, trail = "head",
			fx = { { "swarm", shape = "ball", color = FEATHER, count = 3, distance = 5, size = 0.6, height = 2.5 } },
			text = "ROUCOU !", hitText = "PIC PIC PIC !",
		},
		-- Coup de baguette (P P P) : la baguette monte au-dessus de la perruque et s'abat comme un sceptre
		P_combo3 = {
			label = "Coup de baguette", startup = 0.09, active = 0.1, recovery = 0.28,
			damage = 8, hitbox = box(5, 4, 3, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 45,
			windup = { Root = { 8, -12, 0, 0, -0.05, 0.2 }, Waist = { 14, -14, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -45 }, LE = { 80, 0, 0 }, LW = { 0, 0, -30 } },
			strike = { Root = { -12, 12, 0, 0, -0.4, -0.35 }, Waist = { -24, 14, 0 }, Neck = { -6, 0, 0 }, RS = { 85, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -14, 14, 0, 0, -0.45, -0.4 }, Waist = { -28, 16, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 5 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -25, 0, -55 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			trail = "prop", text = "DU PAIN !", hitText = "CROUSTI !",
		},
		-- Baguette en estoc : fente d'escrimeur, main gauche levée derrière lui, la baguette pique loin devant
		P_side = {
			label = "Baguette en estoc", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(6.5, 2.2, 4, 0.8), kbBase = 24, kbGrowth = 40, kbAngle = 20, selfVelocity = Vector2.new(22, 0),
			windup = { Root = { 4, -15, 0, 0, -0.2, 0.3 }, Waist = { 6, -10, 0 }, Neck = { 6, 15, 0 }, RS = { 60, 0, 25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -45 }, LE = { 70, 0, 0 }, LW = { 0, 0, -25 } },
			strike = { Root = { -10, 25, 0, 0, -0.55, -0.6 }, Waist = { -8, 25, 0 }, Neck = { 0, -35, 0 }, RS = { 95, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -35 }, LE = { 50, 0, 0 }, LW = { 0, 0, -25 }, FL = { 0, 0, 0, 0, 0, -0.7 } },
			follow = { Root = { -12, 28, 0, 0, -0.6, -0.7 }, Waist = { -10, 28, 0 }, Neck = { 0, -38, 0 }, RS = { 98, 0, 12 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 165, 0, -30 }, LE = { 45, 0, 0 }, LW = { 0, 0, -25 }, FL = { 0, 0, 0, 0, 0, -0.75 } },
			trail = "prop", text = "EN GARDE !", hitText = "TOUCHÉ !",
		},
		-- Remise (→P P) : il ramène la baguette contre l'épaule et repique aussitôt, encore plus loin
		P_side2 = {
			label = "Remise en estoc", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 6, hitbox = box(6, 3.5, 3.8, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 25, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 2, 20, 0, 0, -0.35, -0.2 }, Waist = { 0, 15, 0 }, Neck = { 0, -25, 0 }, RS = { 80, 0, 10 }, RE = { 95, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -35 }, LE = { 55, 0, 0 }, LW = { 0, 0, -25 } },
			strike = { Root = { -8, 30, 0, 0, -0.5, -0.55 }, Waist = { -6, 30, 0 }, Neck = { 0, -40, 0 }, RS = { 100, 0, 8 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 170, 0, -30 }, LE = { 40, 0, 0 }, LW = { 0, 0, -25 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -9, 32, 0, 0, -0.52, -0.6 }, Waist = { -7, 32, 0 }, Neck = { 0, -42, 0 }, RS = { 102, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, -28 }, LE = { 40, 0, 0 }, LW = { 0, 0, -25 }, FL = { 0, 0, 0, 0, 0, -0.62 } },
			trail = "prop", hitText = "RE-TOUCHÉ !",
		},
		-- Miettes glissantes : nez en l'air, il relève un pan de cape et balaie du bout du soulier une traînée de miettes sous les pieds adverses
		P_down = {
			label = "Miettes glissantes", startup = 0.09, active = 0.1, recovery = 0.18,
			damage = 5, hitbox = box(5, 1.8, 2.6, -2), kbBase = 22, kbGrowth = 22, kbAngle = 75,
			status = { name = "slippery", duration = 1.5 },
			windup = { Root = { 6, -20, 0, 0, -0.4, 0.15 }, Waist = { 10, -12, 0 }, Neck = { 18, 10, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 60, 0, -60 }, LE = { 110, 0, 0 }, LW = { 0, 0, -30 }, RH = { -30, 0, 10 }, RK = { -40, 0, 0 }, RA = { -40, 0, 0 } },
			strike = { Root = { 8, 25, 0, 0, -0.35, -0.1 }, Waist = { 12, 18, 0 }, Neck = { 20, -10, 0 }, RS = { 10, 0, 40 }, RE = { 60, 0, 0 }, LS = { 70, 0, -65 }, LE = { 110, 0, 0 }, LW = { 0, 0, -30 }, RH = { 45, 0, 25 }, RK = { -5, 0, 0 }, RA = { -45, 0, 0 } },
			follow = { Root = { 8, 34, 0, 0, -0.35, -0.15 }, Waist = { 12, 26, 0 }, Neck = { 20, -14, 0 }, RS = { 8, 0, 42 }, RE = { 60, 0, 0 }, LS = { 72, 0, -66 }, LE = { 110, 0, 0 }, LW = { 0, 0, -30 }, RH = { 40, 0, 40 }, RK = { -8, 0, 0 }, RA = { -45, 0, 0 } },
			trail = "rightFoot", fx = { { "toss", shape = "ball", color = CRUMB, count = 6, size = 0.3, speed = 14 } }, hitText = "GLISSE !",
		},
		-- Envol de pigeons (↑P, anti-air) : recroquevillé dans sa cape, il l'ouvre d'un coup et des pigeons s'envolent
		P_up = {
			label = "Envol de pigeons", startup = 0.09, active = 0.12, recovery = 0.2,
			damage = 6, hitbox = box(5, 5, 1, 3.5), kbBase = 26, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -15, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 10, 0, 30 }, RE = { 95, 0, 0 }, LS = { 10, 0, -30 }, LE = { 95, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.2, 0 }, Waist = { 14, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 150, 0, 60 }, RE = { 15, 0, 0 }, LS = { 150, 0, -60 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.25, 0 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 70 }, RE = { 15, 0, 0 }, LS = { 165, 0, -70 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			fx = { { "particles", tex = "smoke", color = FEATHER, dir = "up", at = "above", time = 0.4, speed = 14 }, { "symbols", symbols = { "🐦", "🕊️" }, count = 4, radius = 3, at = "above" } },
			text = "ENVOLEZ-VOUS !", hitText = "FROUFROU !",
		},
		-- Baguette au ciel (↑P P) : de l'accroupi, il pique la baguette tout droit vers le ciel en sautillant
		P_up2 = {
			label = "Baguette au ciel", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 7, hitbox = box(4.5, 5, 2, 3.5), kbBase = 28, kbGrowth = 45, kbAngle = 88, selfVelocity = Vector2.new(0, 30),
			windup = { Root = { -8, -10, 0, 0, -0.6, 0.05 }, Waist = { -14, -10, 0 }, Neck = { -6, 0, 0 }, RS = { -10, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { 6, 10, 0, 0, 0.3, 0 }, Waist = { 14, 12, 0 }, Neck = { 28, 0, 0 }, RS = { 175, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -40 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 8, 12, 0, 0, 0.35, 0 }, Waist = { 16, 14, 0 }, Neck = { 32, 0, 0 }, RS = { 180, 0, 4 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -5, 0, -42 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			trail = "prop", hitText = "HOP-LÀ !",
		},
		-- Battement d'ailes (P en l'air) : il bat de la cape comme des ailes, deux fois, et plane un instant
		P_air = {
			label = "Battement d'ailes", startup = 0.08, active = 0.16, recovery = 0.16,
			damage = 3, hits = 2, hitbox = box(6, 4, 0.5, 0.5), kbBase = 18, kbGrowth = 25, kbAngle = 45, selfVelocity = Vector2.new(0, 18),
			windup = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 80 }, RE = { 20, 0, 0 }, LS = { 100, 0, -80 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { 20, 0, -70 }, LE = { 10, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { 10, 0, 0 }, LK = { -30, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 2, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 80, 0, 85 }, RE = { 15, 0, 0 }, LS = { 80, 0, -85 }, LE = { 15, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, RA = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -45, 0, 0 }, LA = { -30, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = FEATHER, dir = "all", at = "root", time = 0.3, speed = 10 } }, hitText = "FLAP FLAP !",
		},
		-- Serres de pigeon (→P en l'air) : genou replié puis le soulier part devant, orteils crochus comme des serres
		P_air_side = {
			label = "Serres de pigeon", startup = 0.09, active = 0.1, recovery = 0.18,
			damage = 7, hitbox = box(5, 3, 3, -0.5), kbBase = 22, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { -10, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { -30, 0, 50 }, RE = { 30, 0, 0 }, LS = { -30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 15, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 85, 0, 0 }, RK = { -5, 0, 0 }, RA = { 25, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 18, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -50, 0, 70 }, RE = { 20, 0, 0 }, LS = { -50, 0, -70 }, LE = { 20, 0, 0 }, RH = { 90, 0, 0 }, RK = { -15, 0, 0 }, RA = { 30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "rightFoot", hitText = "GRIFF !",
		},
		-- Moulinet de baguette (↑P en l'air) : la baguette part de derrière et balaie le ciel au-dessus de la couronne
		P_air_up = {
			label = "Moulinet de baguette", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -40, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, LW = { 0, 0, -30 }, RH = { 0, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 198, 0, 5 }, RE = { 8, 0, 0 }, RW = { -15, 0, 0 }, LS = { -28, 0, -50 }, LE = { 20, 0, 0 }, LW = { 0, 0, -30 }, RH = { -8, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", hitText = "ZWING !",
		},
		-- Piqué de baguette (↓P en l'air) : baguette levée à deux mains puis plantée tout droit vers le bas (smash au sol)
		P_air_down = {
			label = "Piqué de baguette", startup = 0.14, active = 0.12, recovery = 0.28,
			damage = 9, hitbox = box(3.5, 4, 0.8, -2.2), kbBase = 24, kbGrowth = 50, kbAngle = -75,
			windup = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -15 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -18, 0, 0 }, Waist = { -22, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 40, 0, 0 }, RH = { 10, 0, 0 }, RK = { -60, 0, 0 }, LH = { 25, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { -22, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 8, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 20, 0, -12 }, LE = { 45, 0, 0 }, RH = { 5, 0, 0 }, RK = { -65, 0, 0 }, LH = { 20, 0, 0 }, LK = { -85, 0, 0 } },
			trail = "prop", text = "PIQUÉ !", hitText = "CRAC CROÛTE !",
		},
		-- Estoc de course (dash puis P) : lancé, la cape au vent, il charge baguette pointée comme un mousquetaire
		P_dash = {
			label = "Estoc de mousquetaire", startup = 0.08, active = 0.14, recovery = 0.24,
			damage = 8, hitbox = box(6, 2.5, 3.5, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -6, 10, 0, 0, -0.3, 0.1 }, Waist = { -4, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { -18, 30, 0, 0, -0.5, -0.5 }, Waist = { -10, 22, 0 }, Neck = { 6, -35, 0 }, RS = { 92, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -60, 0, -50 }, LE = { 15, 0, 0 }, LW = { 0, 0, -25 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -20, 32, 0, 0, -0.52, -0.6 }, Waist = { -12, 24, 0 }, Neck = { 6, -36, 0 }, RS = { 95, 0, 8 }, RE = { 0, 0, 0 }, RW = { -6, 0, 0 }, LS = { -65, 0, -52 }, LE = { 15, 0, 0 }, LW = { 0, 0, -25 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
			trail = "prop", fx = { "dust" }, text = "POUR LE ROI !", hitText = "TCHAC !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Grand pied royal : buste cambré, il lève la jambe tendue jusqu'au menton adverse, pointe du pied bien pointée
		K_neutral = {
			label = "Grand pied royal", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, 0.5), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 10, -10, 0, 0, -0.1, 0.15 }, Waist = { 12, -8, 0 }, Neck = { 15, 0, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 60, 0, -60 }, LE = { 80, 0, 0 }, LW = { 0, 0, -30 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, RA = { -25, 0, 0 } },
			strike = { Root = { 18, -5, 0, 0, -0.05, 0 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 10, 0, 70 }, RE = { 10, 0, 0 }, LS = { 80, 0, -75 }, LE = { 60, 0, 0 }, LW = { 0, 0, -30 }, RH = { 110, 0, 0 }, RK = { -2, 0, 0 }, RA = { -40, 0, 0 } },
			follow = { Root = { 20, -2, 0, 0, -0.05, 0.05 }, Waist = { 18, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 5, 0, 74 }, RE = { 10, 0, 0 }, LS = { 84, 0, -78 }, LE = { 60, 0, 0 }, LW = { 0, 0, -30 }, RH = { 118, 0, 0 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 } },
			trail = "rightFoot", text = "ROYAL !", hitText = "PAF ROYAL !",
		},
		-- Talon de cour (K K) : il pivote sur la pointe du pied gauche, cape tournoyante, talon droit en arc
		K_combo2 = {
			label = "Talon de cour", startup = 0.09, active = 0.12, recovery = 0.26,
			damage = 9, hitbox = box(5, 3.5, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 4, -40, 0, 0, -0.2, 0.1 }, Waist = { 4, -25, 0 }, Neck = { 10, 30, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, RH = { 50, 0, 30 }, RK = { -100, 0, 0 } },
			strike = { Root = { 14, 45, 0, 0, -0.1, 0 }, Waist = { 10, 25, 0 }, Neck = { 12, -20, 0 }, RS = { 40, 0, 80 }, RE = { 10, 0, 0 }, LS = { 50, 0, -80 }, LE = { 10, 0, 0 }, RH = { 90, 0, 45 }, RK = { -4, 0, 0 }, RA = { -35, 0, 0 } },
			follow = { Root = { 16, 60, 0, 0, -0.1, 0 }, Waist = { 12, 32, 0 }, Neck = { 14, -26, 0 }, RS = { 35, 0, 84 }, RE = { 10, 0, 0 }, LS = { 45, 0, -84 }, LE = { 10, 0, 0 }, RH = { 85, 0, 30 }, RK = { -6, 0, 0 }, RA = { -35, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "VLAN !",
		},
		-- Coup de pied du sacre (K K K) : il bondit, couronne de travers, et frappe des deux pieds joints
		K_combo3 = {
			label = "Coup de pied du sacre", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 4, 3, 1), kbBase = 32, kbGrowth = 80, kbAngle = 45, selfVelocity = Vector2.new(15, 40),
			windup = { Root = { -8, 0, 0, 0, -0.65, 0.1 }, Waist = { -15, 0, 0 }, Neck = { -5, 0, 0 }, RS = { -40, 0, 35 }, RE = { 30, 0, 0 }, LS = { -40, 0, -35 }, LE = { 30, 0, 0 } },
			strike = { Root = { 22, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { -12, 0, 6 }, RS = { 120, 0, 70 }, RE = { 20, 0, 0 }, LS = { 120, 0, -70 }, LE = { 20, 0, 0 }, RH = { 88, 0, 4 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { 85, 0, -4 }, LK = { -4, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 26, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { -14, 0, 8 }, RS = { 130, 0, 75 }, RE = { 20, 0, 0 }, LS = { 130, 0, -75 }, LE = { 20, 0, 0 }, RH = { 95, 0, 4 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { 92, 0, -4 }, LK = { -2, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "bothFeet", text = "VIVE LE ROI !", hitText = "BAM !",
		},
		-- Ruade de plumes : genou à la poitrine puis coup de semelle, buste rejeté en arrière et ailes déployées
		K_side = {
			label = "Ruade de plumes", startup = 0.22, active = 0.12, recovery = 0.35,
			damage = 13, hitbox = box(5, 3, 3.2, 0.3), kbBase = 32, kbGrowth = 85, kbAngle = 30, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 8, -10, 0, 0, -0.2, 0.2 }, Waist = { 10, -8, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 30 }, RE = { 80, 0, 0 }, LS = { 70, 0, -30 }, LE = { 80, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, RA = { 15, 0, 0 } },
			strike = { Root = { 24, 5, 0, 0, -0.1, -0.3 }, Waist = { 14, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -35, 0, 70 }, RE = { 20, 0, 0 }, LS = { -35, 0, -70 }, LE = { 20, 0, 0 }, RH = { 95, 0, 0 }, RK = { -2, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 28, 6, 0, 0, -0.1, -0.35 }, Waist = { 16, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -42, 0, 75 }, RE = { 20, 0, 0 }, LS = { -42, 0, -75 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightLeg", fx = { { "particles", tex = "smoke", color = FEATHER, dir = "front", at = "root", time = 0.35, speed = 12 } },
			hitText = "PLOUF DE PLUMES !",
		},
		-- Glissade sur miettes : il glisse sur une hanche, pied pointé devant, baguette levée comme un sceptre
		K_down = {
			label = "Glissade sur miettes", startup = 0.18, active = 0.25, recovery = 0.35,
			damage = 12, hitbox = box(7, 2, 3, -2), kbBase = 30, kbGrowth = 60, kbAngle = 65, selfVelocity = Vector2.new(45, 0),
			windup = { Root = { -10, 0, 0, 0, -0.65, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -95, 0, 0 }, LH = { 40, 0, 0 }, LK = { -95, 0, 0 } },
			strike = { Root = { 38, 15, 8, 0, -1.45, 0 }, Waist = { -20, -10, 0 }, Neck = { -18, 0, 0 }, RS = { 160, 0, 20 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, LW = { 0, 0, -30 }, RH = { 82, 0, 5 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { 40, 0, -10 }, LK = { -80, 0, 0 } },
			follow = { Root = { 42, 18, 10, 0, -1.5, 0 }, Waist = { -22, -12, 0 }, Neck = { -20, 0, 0 }, RS = { 168, 0, 25 }, RE = { 20, 0, 0 }, LS = { 35, 0, -75 }, LE = { 20, 0, 0 }, LW = { 0, 0, -30 }, RH = { 86, 0, 5 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { 45, 0, -10 }, LK = { -85, 0, 0 } },
			trail = "rightFoot", fx = { { "puddle", color = CRUMB, width = 6 } }, hitText = "SCRITCH !",
		},
		-- Battement d'ailes (↑K, ex-←K) : grands bras-ailes rabattus d'en haut, la rafale soulève l'adversaire, lui recule
		K_up = {
			label = "Battement d'ailes", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(5, 5, 1.5, 3), kbBase = 30, kbGrowth = 70, kbAngle = 82, selfVelocity = Vector2.new(-22, 28),
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 170, 0, 60 }, RE = { 15, 0, 0 }, LS = { 170, 0, -60 }, LE = { 15, 0, 0 } },
			strike = { Root = { 12, 0, 0, 0, 0.3, 0.3 }, Waist = { 14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 20, 0, 75 }, RE = { 10, 0, 0 }, LS = { 20, 0, -75 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 14, 0, 0, 0, 0.35, 0.35 }, Waist = { 16, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 5, 0, 70 }, RE = { 10, 0, 0 }, LS = { 5, 0, -70 }, LE = { 10, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 35, 0, 0 }, LK = { -65, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = FEATHER, dir = "up", at = "front", time = 0.35, speed = 16 }, { "ring", color = FEATHER, radius = 4, at = "front" } },
			text = "FLAAAP !", hitText = "WOUSH !",
		},
		-- Serres royales (K en l'air) : ailes déployées, il tend une serre crochue devant lui, l'autre patte repliée sous la cape
		K_air = {
			label = "Serres royales", startup = 0.17, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, -0.8), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -12, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 70 }, RE = { 20, 0, 0 }, LS = { 100, 0, -70 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, RA = { 20, 0, 0 }, LH = { 95, 0, 0 }, LK = { -130, 0, 0 }, LA = { 20, 0, 0 } },
			strike = { Root = { 18, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 85 }, RE = { 10, 0, 0 }, LS = { 110, 0, -85 }, LE = { 10, 0, 0 }, RH = { 85, 0, 10 }, RK = { -10, 0, 0 }, RA = { 45, 0, 0 }, LH = { 105, 0, -10 }, LK = { -135, 0, 0 } },
			follow = { Root = { 22, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 115, 0, 88 }, RE = { 10, 0, 0 }, LS = { 115, 0, -88 }, LE = { 10, 0, 0 }, RH = { 90, 0, 10 }, RK = { -15, 0, 0 }, RA = { 50, 0, 0 }, LH = { 108, 0, -10 }, LK = { -136, 0, 0 } },
			trail = "rightFoot", hitText = "CRAC CRAC !",
		},
		-- Grand jeté royal (→K en l'air) : écart de danseur de cour, jambe avant tendue, bras en couronne
		K_air_side = {
			label = "Grand jeté royal", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5.5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -8, 15, 0 }, Waist = { -10, 10, 0 }, Neck = { 10, -10, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { -10, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 6, 10, 0 }, Waist = { 14, 5, 0 }, Neck = { 20, -5, 0 }, RS = { 170, 0, 30 }, RE = { 30, 0, 0 }, LS = { 170, 0, -30 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -50, 0, 0 }, LK = { -10, 0, 0 }, LA = { -40, 0, 0 } },
			follow = { Root = { 8, 12, 0 }, Waist = { 16, 5, 0 }, Neck = { 22, -5, 0 }, RS = { 175, 0, 32 }, RE = { 30, 0, 0 }, LS = { 175, 0, -32 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -55, 0, 0 }, LK = { -8, 0, 0 }, LA = { -40, 0, 0 } },
			trail = "rightFoot", text = "OLÉ !", hitText = "SBLAF !",
		},
		-- Salto du paon (↑K en l'air) : cape déployée en roue de paon, salto arrière, les talons fouettent le ciel
		K_air_up = {
			label = "Salto du paon", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 80 }, RE = { 10, 0, 0 }, LS = { 120, 0, -80 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { -125, 0, 0 }, LH = { 90, 0, 0 }, LK = { -125, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -30, 0, 80 }, RE = { 10, 0, 0 }, LS = { -30, 0, -80 }, LE = { 10, 0, 0 }, RH = { 150, 0, 6 }, RK = { -5, 0, 0 }, RA = { -30, 0, 0 }, LH = { 140, 0, -6 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -35, 0, 82 }, RE = { 10, 0, 0 }, LS = { -35, 0, -82 }, LE = { 10, 0, 0 }, RH = { 110, 0, 6 }, RK = { -40, 0, 0 }, LH = { 100, 0, -6 }, LK = { -45, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "PAON !", hitText = "POC !",
		},
		-- Atterrissage du gros pigeon (↓K en l'air) : ailes au ciel, il tombe pieds joints comme un pigeon trop nourri
		K_air_down = {
			label = "Atterrissage du gros pigeon", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -8, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 80 }, RE = { 30, 0, 0 }, LS = { 60, 0, -80 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 165, 0, 50 }, RE = { 10, 0, 0 }, LS = { 165, 0, -50 }, LE = { 10, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 172, 0, 60 }, RE = { 10, 0, 0 }, LS = { 172, 0, -60 }, LE = { 10, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", fx = { { "particles", tex = "smoke", color = FEATHER, dir = "up", at = "feet", time = 0.3, speed = 10 } },
			text = "ROUCOUPLOF !", hitText = "PATATRAS !",
		},
		-- Coup de pied voyageur (dash puis K) : il s'envole, jambe droite tendue, bras-ailes rejetés en arrière
		K_dash = {
			label = "Coup de pied voyageur", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 3, 3, -0.5), kbBase = 30, kbGrowth = 65, kbAngle = 35, selfVelocity = Vector2.new(50, 25),
			windup = { Root = { -10, 0, 0, 0, -0.45, 0 }, Waist = { -12, 0, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -40, 0, 70 }, RE = { 15, 0, 0 }, LS = { -40, 0, -70 }, LE = { 15, 0, 0 }, RH = { 82, 0, 0 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { -15, 0, 0 }, LK = { -95, 0, 0 } },
			follow = { Root = { 18, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -48, 0, 74 }, RE = { 15, 0, 0 }, LS = { -48, 0, -74 }, LE = { 15, 0, 0 }, RH = { 86, 0, 0 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { -20, 0, 0 }, LK = { -100, 0, 0 } },
			trail = "rightFoot", text = "PAR AVION !", hitText = "SBAM !",
		},
		-- P puis K : Croc-en-jambe de cour, il tend le soulier en travers des chevilles adverses en faisant la révérence (chapeau bas !)
		PK_combo = {
			label = "Croc-en-jambe de cour", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 2.8, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 55,
			windup = { Root = { 6, 20, 0, 0, -0.3, 0.15 }, Waist = { 10, 15, 0 }, Neck = { 12, -10, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { -30, 0, -40 }, LE = { 60, 0, 0 }, LW = { 0, 0, -30 }, RH = { -20, 0, 20 }, RK = { -30, 0, 0 } },
			strike = { Root = { -16, -10, 0, 0, -0.45, -0.3 }, Waist = { -30, -8, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 85 }, RE = { 20, 0, 0 }, LS = { -40, 0, -30 }, LE = { 50, 0, 0 }, LW = { 0, 0, -30 }, RH = { 50, 0, 30 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -18, -14, 0, 0, -0.47, -0.32 }, Waist = { -32, -10, 0 }, Neck = { -22, 0, 0 }, RS = { 72, 0, 88 }, RE = { 20, 0, 0 }, LS = { -42, 0, -30 }, LE = { 50, 0, 0 }, LW = { 0, 0, -30 }, RH = { 54, 0, 35 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			trail = "rightFoot", fx = { { "symbols", symbols = { "🎩" }, color = GOLD, count = 1, radius = 1.5, at = "head" } }, text = "RÉVÉRENCE !", hitText = "CHAPEAU BAS !",
		},
		-- K puis P : Coup de perruque, il fouette de la tête et sa perruque poudrée claque l'adversaire dans un nuage de talc
		KP_combo = {
			label = "Coup de perruque", startup = 0.07, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 2.6, 1), kbBase = 22, kbGrowth = 35, kbAngle = 35,
			windup = { Root = { 10, 0, 0, 0, -0.15, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, LW = { 0, 0, -30 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -24, 0, 0 }, Neck = { -40, 0, 0 }, RS = { -30, 0, 50 }, RE = { 30, 0, 0 }, LS = { -30, 0, -50 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.4 }, Waist = { -28, 0, 0 }, Neck = { -44, 0, 0 }, RS = { -34, 0, 52 }, RE = { 30, 0, 0 }, LS = { -34, 0, -52 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			trail = "head", fx = { { "particles", tex = "smoke", color = WIG, dir = "front", at = "head", time = 0.25, speed = 10, size = 0.8, rate = 70 } }, text = "MA PERRUQUE !", hitText = "POUF ! TALC !",
		},

		------------------------------------------------------------------ Spéciaux (S) : la plupart coûtent des pigeons
		-- Pigeon chercheur : il serre un pigeon contre son jabot puis le lâche vers le ciel ; le pigeon suit l'adversaire
		S_neutral = {
			label = "Pigeon chercheur", kind = "projectile", energyCost = 15, meterCost = 1, startup = 0.16, active = 0, recovery = 0.3,
			damage = 8, kbBase = 22, kbGrowth = 40, kbAngle = 35,
			projectile = { speed = 26, angle = 10, gravity = 0, lifetime = 2.4, size = 1.6, color = FEATHER, homing = 0.35, visual = PIGEON_VISUAL },
			windup = { Root = { 4, 10, 0, 0, -0.15, 0.1 }, Waist = { 8, 12, 0 }, Neck = { -6, 10, 0 }, RS = { 20, 0, 20 }, RE = { 50, 0, 0 }, LS = { 40, 0, 10 }, LE = { 110, 0, 0 }, LW = { -20, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -6, -12, 0 }, Neck = { 14, 0, 0 }, RS = { 85, 0, 20 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -30 }, LE = { 10, 0, 0 }, LW = { 0, 0, -30 } },
			follow = { Root = { -7, -12, 0, 0, -0.2, -0.22 }, Waist = { -7, -14, 0 }, Neck = { 18, 0, 0 }, RS = { 88, 0, 22 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 152, 0, -34 }, LE = { 8, 0, 0 }, LW = { 0, 0, -30 } },
			prop = "pigeon", hold = 0.1, text = "VA, MON PIGEON !", hitText = "PIC !",
		},
		-- Charge de la Nuée : bras joints devant en pointe de lance, la nuée l'entoure et il fonce
		S_side = {
			label = "Charge de la Nuée", energyCost = 25, meterCost = 2, startup = 0.12, active = 0.3, recovery = 0.32,
			damage = 4, hits = 3, hitbox = box(5, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(60, 0),
			windup = { Root = { 6, 0, 0, 0, -0.4, 0.2 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 } },
			strike = { Root = { -30, 0, 0, 0, -0.4, -0.4 }, Waist = { -15, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 150, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -34, 0, 0, 0, -0.42, -0.45 }, Waist = { -16, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 155, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "prop",
			fx = { { "swarm", shape = "ball", color = FEATHER, count = 8, distance = 18, size = 0.8, time = 0.4, height = 1.5, spreadY = 2 }, { "particles", tex = "smoke", color = FEATHER, dir = "front", at = "root", time = 0.3, speed = 12 } },
			text = "CHAAARGEZ !", hitText = "ROUCOUBAM !",
		},
		-- Jet de miettes : geste du semeur, il lance des miettes au sol ; qui marche dessus voit fondre la nuée sur lui
		S_down = {
			label = "Jet de miettes", kind = "trap", energyCost = 20, meterCost = 1, startup = 0.15, active = 0, recovery = 0.3,
			damage = 9, kbBase = 25, kbGrowth = 45, kbAngle = 70,
			status = { name = "blinded", duration = 1.5 },
			trap = { size = Vector3.new(4, 1, 6), offset = 3.5, lifetime = 10, max = 2, color = CRUMB,
				-- tas de miettes à plat sur le sol
				visual = { shape = "ball", size = 0.6, color = CRUMB, trail = false, parts = {
					{ "block", Vector3.new(3.2, 0.12, 2.2), Vector3.new(0, -0.3, 0), CRUMB },
					{ "ball", Vector3.new(0.35, 0.3, 0.35), Vector3.new(0.9, -0.15, 0.4), CRUST },
					{ "ball", Vector3.new(0.3, 0.25, 0.3), Vector3.new(-0.8, -0.15, -0.3), BREAD },
					{ "ball", Vector3.new(0.25, 0.2, 0.25), Vector3.new(-0.2, -0.15, 0.7), CRUST },
				} } },
			windup = { Root = { 2, 15, 0, 0, -0.2, 0.15 }, Waist = { 4, 18, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { -20, 0, -50 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, -10, 0, 0, -0.45, -0.15 }, Waist = { -18, -12, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 70, 0, -20 }, LE = { 10, 0, 0 }, LW = { -20, 0, 0 } },
			follow = { Root = { -11, -14, 0, 0, -0.47, -0.18 }, Waist = { -20, -16, 0 }, Neck = { -18, 0, 0 }, RS = { 42, 0, 42 }, RE = { 50, 0, 0 }, LS = { 80, 0, -35 }, LE = { 8, 0, 0 }, LW = { -25, 0, 0 } },
			prop = "miettes", fx = { { "toss", shape = "ball", color = CRUMB, count = 8, size = 0.25, speed = 12 } },
			text = "PETITS PETITS !", hitText = "ROUCOUCOUCOU !",
		},
		-- Envol porté (remontée, gratuite) : ses pigeons l'attrapent par la cape et le hissent très haut, jambes ballantes ; qui vole au-dessus se fait emporter au passage
		S_up = {
			label = "Envol porté", energyCost = 0, startup = 0.08, active = 0.3, recovery = 0.3,
			hitbox = box(5.5, 7, 1, 3), kbBase = 30, kbGrowth = 45, kbAngle = 82,
			damage = 8, selfVelocity = Vector2.new(10, 95),
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 60, 0, 40 }, RE = { 80, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 } },
			strike = { Root = { -4, 0, 0, 0, 0.3, 0 }, Waist = { 6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 165, 0, 25 }, RE = { 30, 0, 0 }, LS = { 165, 0, -25 }, LE = { 30, 0, 0 }, RH = { 10, 0, 0 }, RK = { -20, 0, 0 }, RA = { -35, 0, 0 }, LH = { -5, 0, 0 }, LK = { -35, 0, 0 }, LA = { -35, 0, 0 } },
			follow = { Root = { -2, 0, 0, 0, 0.35, 0 }, Waist = { 8, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 170, 0, 22 }, RE = { 25, 0, 0 }, LS = { 170, 0, -22 }, LE = { 25, 0, 0 }, RH = { -8, 0, 0 }, RK = { -40, 0, 0 }, RA = { -35, 0, 0 }, LH = { 12, 0, 0 }, LK = { -15, 0, 0 }, LA = { -35, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = FEATHER, dir = "up", at = "above", time = 0.5, speed = 12 }, { "symbols", symbols = { "🐦", "🕊️" }, count = 5, radius = 2.5, at = "above" } },
			text = "EMPORTEZ-MOI !", hitText = "EMPORTÉ AVEC MOI !",
		},
		-- Piqué collectif (↓S en l'air) : baguette pointée vers le sol, il tourne comme une perceuse au milieu de la nuée
		S_air_down = {
			label = "Piqué collectif", energyCost = 25, meterCost = 2, startup = 0.12, active = 0.35, recovery = 0.3,
			damage = 4, hits = 3, hitbox = box(4, 4, 0.5, -1.5), kbBase = 25, kbGrowth = 55, kbAngle = -70, selfVelocity = Vector2.new(8, -80),
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 10, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 15, 0, -8 }, LE = { 10, 0, 0 }, RH = { -2, 0, 2 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -2, 0, -2 }, LK = { 0, 0, 0 }, LA = { -40, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 8, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 12, 0, -10 }, LE = { 10, 0, 0 }, RH = { -2, 0, 3 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 }, LH = { -2, 0, -3 }, LK = { 0, 0, 0 }, LA = { -40, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "prop",
			fx = { { "particles", tex = "smoke", color = FEATHER, dir = "all", at = "root", time = 0.35, speed = 12 }, { "symbols", symbols = { "🐦" }, count = 4, radius = 2.5, at = "root" } },
			text = "PIQUÉ COLLECTIF !", hitText = "VRRRRR !",
		},
		-- Bouclier de plumes (ESQUIVE puis S) : cape grande ouverte, il la referme d'un coup sec : le pan de cape claque l'adversaire,
		-- et le prochain coup reçu est amorti, la nuée riposte
		S_dodge = {
			label = "Bouclier de plumes", kind = "counter", energyCost = 20, startup = 0.04, active = 0.5, recovery = 0.3,
			damage = 7, hitbox = box(5.5, 4, 2.8, 0.6), kbBase = 24, kbGrowth = 40, kbAngle = 35,
			counter = { window = 0.5, text = "PLUMÉ !", riposte = { damage = 10, kbBase = 35, kbGrowth = 60, kbAngle = 40, hitText = "PICOREZ-LE !" } },
			windup = { Root = { 2, 0, 0, 0, -0.25, 0.15 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 80, 0, 75 }, RE = { 10, 0, 0 }, LS = { 80, 0, -75 }, LE = { 10, 0, 0 } },
			strike = { Root = { -8, -15, 0, 0, -0.4, -0.25 }, Waist = { -14, -8, 0 }, Neck = { -14, 12, 0 }, RS = { 88, 0, -60 }, RE = { 70, 0, 0 }, LS = { 88, 0, 60 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -6, -20, 0, 0, -0.42, -0.25 }, Waist = { -13, -12, 0 }, Neck = { -15, 18, 0 }, RS = { 86, 0, -58 }, RE = { 72, 0, 0 }, LS = { 86, 0, 58 }, LE = { 72, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			trail = "bothHands", fx = { { "particles", tex = "smoke", color = FEATHER, dir = "front", at = "root", time = 0.4, speed = 8 } }, text = "PAS TOUCHE !", hitText = "FROUCH !",
		},
		-- Appel de la nuée (S maintenu) : deux doigts à la bouche, il siffle ; trois pigeons rappliquent à toute vitesse et
		-- percutent ce qui se trouve devant lui avant de se poser (recharge 3 pigeons)
		S_hold = {
			label = "Appel de la nuée", energyCost = 15, startup = 0.25, active = 0.2, recovery = 0.5,
			damage = 9, hitbox = box(6.5, 4.5, 3.5, 1), kbBase = 30, kbGrowth = 55, kbAngle = 40,
			selfEffect = { meter = 3 },
			windup = { Root = { 2, 0, 0, 0, -0.15, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 110, 0, 15 }, LE = { 130, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.3, -0.3 }, Waist = { -10, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 96, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, LW = { 0, 0, -30 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { 4, 0, 0, 0, 0.05, 0 }, Waist = { 16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 } },
			hold = 0.2, trail = "prop", windupFx = { { "text", text = "FUUUIIIT !", color = WHITE, at = "head" } },
			fx = { { "swarm", shape = "ball", color = FEATHER, count = 3, distance = 16, size = 0.8, time = 0.4, height = 2.5, spreadY = 2 }, { "symbols", symbols = { "🐦", "🕊️" }, count = 5, radius = 4, at = "above" }, { "ring", color = FEATHER, radius = 5, at = "front" } },
			text = "ROUCOUUUU !", hitText = "RETOUR DE NUÉE !",
		},
		-- Dash de plumes (→→S) : drapé dans sa cape, il file au ras du sol dans un nuage de plumes
		S_dash = {
			label = "Dash de plumes", energyCost = 20, startup = 0.05, active = 0.25, recovery = 0.3,
			damage = 8, hitbox = box(5, 4, 2, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 30, selfVelocity = Vector2.new(70, 0), invuln = 0.2,
			windup = { Root = { -10, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, -30 }, RE = { 90, 0, 0 }, LS = { 60, 0, 30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -35, 0, 0, 0, -0.6, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { -40, 0, 60 }, RE = { 10, 0, 0 }, LS = { -40, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 }, FR = { 0, 0, 0, 0, 0, 0.4 } },
			follow = { Root = { -32, 0, 0, 0, -0.58, -0.3 }, Waist = { -9, 0, 0 }, Neck = { 24, 0, 0 }, RS = { -45, 0, 65 }, RE = { 10, 0, 0 }, LS = { -45, 0, -65 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 }, FR = { 0, 0, 0, 0, 0, 0.45 } },
			trail = "body", fx = { { "particles", tex = "smoke", color = FEATHER, dir = "all", at = "root", time = 0.3, speed = 8 } }, hitText = "FRRRT !",
		},
		-- Escadrille (S en l'air) : il lance trois pigeons en éventail vers le bas, ils corrigent un peu leur vol
		S_air = {
			label = "Escadrille", kind = "projectile", energyCost = 20, meterCost = 2, startup = 0.15, active = 0, recovery = 0.3,
			damage = 6, kbBase = 22, kbGrowth = 40, kbAngle = 30,
			projectile = { speed = 40, gravity = 0, lifetime = 1.0, size = 1.5, color = FEATHER, visual = PIGEON_VISUAL, homing = 0.15, fan = { count = 3, from = -45, to = -5 } },
			windup = { Root = { -8, 10, 0 }, Waist = { -10, 12, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 50 }, RE = { 40, 0, 0 }, LS = { 30, 0, 20 }, LE = { 120, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 10, -10, 0 }, Waist = { 8, -12, 0 }, Neck = { -10, 0, 0 }, RS = { 80, 0, 40 }, RE = { 10, 0, 0 }, LS = { 70, 0, -30 }, LE = { 5, 0, 0 }, LW = { -20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 12, -12, 0 }, Waist = { 10, -14, 0 }, Neck = { -12, 0, 0 }, RS = { 75, 0, 44 }, RE = { 10, 0, 0 }, LS = { 60, 0, -34 }, LE = { 5, 0, 0 }, LW = { -25, 0, 0 }, RH = { 35, 0, 0 }, RK = { -75, 0, 0 }, LH = { 25, 0, 0 }, LK = { -65, 0, 0 } },
			prop = "pigeon", text = "ESCADRILLE !", hitText = "ROUCOUPAF !",
		},

		-- Coup de bec royal (P P puis →P) : il tend le cou comme un pigeon et donne trois coups de bec secs du bout du nez
		P_peck = {
			label = "Coup de bec royal", startup = 0.06, active = 0.18, recovery = 0.18,
			damage = 3, hits = 3, hitbox = box(5, 3.5, 2.6, 1), kbBase = 16, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 20, 0, 40 }, RE = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 }, LW = { 0, 0, -30 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -22, 0, 0 }, Neck = { -36, 0, 0 }, RS = { -30, 0, 60 }, RE = { 70, 0, 0 }, LS = { -30, 0, -60 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -6, 0, 0, 0, -0.25, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -20, 0, 55 }, RE = { 70, 0, 0 }, LS = { -20, 0, -55 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			wobble = true, trail = "head", fx = { { "swarm", shape = "ball", color = FEATHER, count = 2, distance = 5, size = 0.5, height = 2.5 } }, text = "ROUCOU-COU !", hitText = "PIC PIC PIC !",
		},
		-- Passe de matador (K K puis →K) : il fait tournoyer sa cape de plumes d'un tour complet comme un matador, OLÉ, la cape claque
		K_cape = {
			label = "Passe de matador", startup = 0.08, active = 0.12, recovery = 0.22,
			damage = 7, hitbox = box(6, 4, 2.5, 0.8), kbBase = 24, kbGrowth = 35, kbAngle = 40,
			windup = { Root = { 4, -30, 0, 0, -0.25, 0.15 }, Waist = { 6, -25, 0 }, Neck = { 10, 20, 0 }, RS = { 60, 0, -40 }, RE = { 80, 0, 0 }, LS = { 100, 0, -60 }, LE = { 20, 0, 0 }, LW = { 0, 0, -30 } },
			strike = { Root = { -6, 30, 0, 0, -0.3, -0.3 }, Waist = { -8, 30, 0 }, Neck = { 10, -25, 0 }, RS = { 95, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -6, 40, 0, 0, -0.3, -0.32 }, Waist = { -8, 36, 0 }, Neck = { 10, -30, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, -72 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", fx = { { "particles", tex = "smoke", color = FEATHER, dir = "all", at = "root", time = 0.3, speed = 10 } }, text = "OLÉ !", hitText = "FROUCH !",
		},
		-- Baguette brisée (finition) : il lève la baguette à deux mains et la brise en deux sur le crâne adverse, les miettes volent
		K_bread = {
			label = "Baguette brisée", startup = 0.1, active = 0.1, recovery = 0.36,
			damage = 12, hitbox = box(5.5, 4.5, 2.8, 1), kbBase = 38, kbGrowth = 90, kbAngle = 40,
			windup = { Root = { 10, 0, 0, 0, 0, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 200, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 200, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.55, -0.4 }, Waist = { -32, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -5 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -18, 0, 0, 0, -0.6, -0.45 }, Waist = { -36, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 50, 0, 5 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, -5 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", fx = { { "toss", shape = "ball", color = CRUMB, count = 10, size = 0.3, speed = 16 }, { "burst", color = CRUST, size = 3, at = "front" }, { "shake", amount = 0.35 } }, text = "PAS LE PAIN !", hitText = "CROUSTI-CRAC !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Nuée vorace : baguette levée comme un chef d'orchestre, il lâche la nuée qui picore quatre fois
		S_finish_peck = {
			label = "Nuée vorace", energyCost = 20, meterCost = 1, startup = 0.12, active = 0.3, recovery = 0.3,
			damage = 3, hits = 4, hitbox = box(6, 5, 3, 1), kbBase = 36, kbGrowth = 85, kbAngle = 45,
			windup = { Root = { 6, 10, 0, 0, -0.1, 0.1 }, Waist = { 10, 10, 0 }, Neck = { 14, 0, 0 }, RS = { 150, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 70, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -6, -12, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -10 }, LE = { 10, 0, 0 }, LW = { 0, 0, -30 } },
			follow = { Root = { -6, -12, 0, 0, -0.2, -0.22 }, Waist = { -7, -14, 0 }, Neck = { 8, 0, 0 }, RS = { 105, 0, 22 }, RE = { 0, 0, 0 }, RW = { 8, 0, 0 }, LS = { 98, 0, -14 }, LE = { 10, 0, 0 }, LW = { 0, 0, -30 } },
			wobble = true, fx = { { "swarm", shape = "ball", color = FEATHER, count = 6, distance = 6, size = 0.7, height = 2, spreadY = 2 } },
			text = "À TABLE !", hitText = "PICPICPICPIC !",
		},
		-- Baguette volante : lancer de côté façon frisbee, la baguette tournoie et revient dans sa main
		S_finish_bread = {
			label = "Baguette volante", kind = "projectile", energyCost = 20, startup = 0.12, active = 0, recovery = 0.3,
			damage = 8, kbBase = 34, kbGrowth = 80, kbAngle = 40,
			projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 0.9, size = 1.6, color = BREAD, returns = true,
				visual = { shape = "cyl", size = 3.0, color = BREAD, material = "Sand", spin = 18 } },
			windup = { Root = { 2, 30, 0, 0, -0.25, 0.1 }, Waist = { 4, 35, 0 }, Neck = { 0, -30, 0 }, RS = { 80, 0, -40 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 50, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.35, -0.3 }, Waist = { -8, -26, 0 }, Neck = { 0, 20, 0 }, RS = { 90, 0, 60 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, LW = { 0, 0, -30 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -8, -28, 0, 0, -0.35, -0.32 }, Waist = { -8, -34, 0 }, Neck = { 0, 26, 0 }, RS = { 85, 0, 80 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 25, 0, -62 }, LE = { 40, 0, 0 }, LW = { 0, 0, -30 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			hideProp = "baguette", text = "ATTRAPE !", hitText = "BOING CROUSTI !",
		},

		------------------------------------------------------------------ Supers
		-- La Grande Volée : drapé dans sa cape, il l'ouvre d'un coup et pointe la baguette ; cent pigeons traversent l'écran
		SUPER = {
			label = "La Grande Volée !", kind = "projectile", superCost = 100, startup = 0.35, active = 0, recovery = 0.5,
			damage = 3, kbBase = 20, kbGrowth = 30, kbAngle = 30,
			projectile = { speed = 65, gravity = 0, lifetime = 1.4, size = 1.8, color = FEATHER, visual = PIGEON_VISUAL, pierce = true, fan = { count = 10, from = -8, to = 30, gap = 0.05 } },
			windup = { Root = { -6, 0, 0, 0, -0.7, 0.15 }, Waist = { -20, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 70, 0, -45 }, RE = { 90, 0, 0 }, LS = { 70, 0, 45 }, LE = { 90, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.1, -0.1 }, Waist = { 16, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 100, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -60 }, LE = { 10, 0, 0 }, LW = { 0, 0, -30 } },
			follow = { Root = { 6, 0, 0, 0, 0.1, -0.12 }, Waist = { 18, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 104, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 168, 0, -66 }, LE = { 10, 0, 0 }, LW = { 0, 0, -30 } },
			hold = 0.3, windupFx = { "super" },
			fx = { { "screen", color = FEATHER, alpha = 0.25 }, { "shake", amount = 0.6 }, { "swarm", shape = "ball", color = FEATHER, count = 12, distance = 30, size = 1, time = 0.8, height = 2, spreadY = 4 } },
			text = "LA GRANDE VOLÉE !", hitText = "ROUCOUROUCOU !",
		},
		-- Super ↑ : il se drape dans sa cape, tape du soulier… et la nuée entière décolle avec lui en tornade de plumes : bras en
		-- croix, il tourne comme une toupie en montant, perruque au vent, et emporte tout ce qui vole au-dessus
		SUPER_up = {
			label = "Tornade roucoulante !", superCost = 100, startup = 0.35, active = 0.4, recovery = 0.6,
			damage = 22, hitbox = box(9, 14, 0.5, 6), kbBase = 45, kbGrowth = 95, kbAngle = 88, invuln = 0.3,
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 70, 0, -50 }, RE = { 100, 0, 0 }, LS = { 70, 0, 50 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 90, 0, 95 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -95 }, LE = { 0, 0, 0 }, LW = { 0, 0, -30 }, RH = { 20, 0, 10 }, RK = { -60, 0, 0 }, RA = { -30, 0, 0 }, LH = { 20, 0, -10 }, LK = { -60, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.6, 0 }, Waist = { 10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 95, 0, 98 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -98 }, LE = { 0, 0, 0 }, LW = { 0, 0, -30 }, RH = { 25, 0, 12 }, RK = { -65, 0, 0 }, RA = { -30, 0, 0 }, LH = { 25, 0, -12 }, LK = { -65, 0, 0 }, LA = { -30, 0, 0 } },
			spin = { axis = "y", degrees = 1080 }, selfVelocity = Vector2.new(0, 70), status = { name = "blinded", duration = 1.5 },
			windupFx = { "super", { "symbols", symbols = { "🐦", "🕊️" }, count = 6, radius = 4, at = "above" } }, trail = "body",
			fx = { { "pillar", color = FEATHER, height = 22, width = 7, at = "root" }, { "swarm", shape = "ball", color = FEATHER, count = 14, distance = 10, size = 0.9, time = 0.8, height = 8, spreadY = 8 }, { "particles", tex = "smoke", color = FEATHER, dir = "all", at = "root", time = 0.6, speed = 14, rate = 110 }, { "shake", amount = 0.5 } },
			text = "TORNADE ROUCOULANTE !", hitText = "ROUCOULÉ AU CIEL !",
		},
		-- La Statue : il cadre l'adversaire entre ses mains, puis le fige d'un coup de baguette ; les pigeons s'y posent
		SUPER_down = {
			label = "La Statue !", superCost = 100, startup = 0.4, active = 0.2, recovery = 0.6,
			damage = 10, hitbox = box(40, 20, 8, 4), kbBase = 10, kbGrowth = 10, kbAngle = 60,
			status = { name = "statue", duration = 2 },
			windup = { Root = { 2, 0, 0, 0, -0.15, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 95, 0, -30 }, RE = { 60, 0, 0 }, LS = { 95, 0, 30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 10, 0, 0, -0.05, -0.1 }, Waist = { 14, 10, 0 }, Neck = { 24, -10, 0 }, RS = { 125, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -40 }, LE = { 100, 0, 0 } },
			follow = { Root = { 7, 12, 0, 0, -0.05, -0.1 }, Waist = { 16, 12, 0 }, Neck = { 28, -10, 0 }, RS = { 128, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -12, 0, -42 }, LE = { 102, 0, 0 } },
			hold = 0.5, windupFx = { "super" },
			fx = { { "screen", color = MARBLE, alpha = 0.3 }, { "symbols", symbols = { "🐦", "🕊️", "🗿" }, count = 8, radius = 6, at = "front" } },
			text = "NE BOUGEZ PLUS !", hitText = "STATUE !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise de la nuée : il referme sa cape comme deux ailes et les pigeons agrippent l'adversaire
		GRAB = {
			label = "Prise de la nuée", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 75 }, RE = { 10, 0, 0 }, LS = { 100, 0, -75 }, LE = { 10, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -12, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 85, 0, -15 }, RE = { 50, 0, 0 }, LS = { 85, 0, 15 }, LE = { 50, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.18, -0.3 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 86, 0, -20 }, RE = { 55, 0, 0 }, LS = { 86, 0, 20 }, LE = { 55, 0, 0 } },
			fx = { { "swarm", shape = "ball", color = FEATHER, count = 4, distance = 4, size = 0.6, height = 2.5 } },
			text = "SAISISSEZ-LE !", hitText = "ROUCOU ?!",
		},
		-- ✋ puis → : Envol royal, baguette pointée vers l'horizon, la nuée emporte la victime devant
		THROW_fwd = {
			label = "Envol royal", kind = "throw", startup = 0.35, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 25,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 2.8, 2.0 }, { 0.35, 5.5, 3.5 } },
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.15 }, Waist = { 10, -10, 0 }, Neck = { 15, 0, 0 }, RS = { 150, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { -10, 15, 0, 0, -0.3, -0.4 }, Waist = { -12, 15, 0 }, Neck = { 10, -10, 0 }, RS = { 100, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 }, LW = { 0, 0, -30 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -11, 18, 0, 0, -0.32, -0.45 }, Waist = { -13, 18, 0 }, Neck = { 12, -12, 0 }, RS = { 104, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 58, 0, -64 }, LE = { 20, 0, 0 }, LW = { 0, 0, -30 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			fx = { { "swarm", shape = "ball", color = FEATHER, count = 6, distance = 14, size = 0.8, height = 3, spreadY = 2 } },
			text = "EMPORTEZ-LE !", hitText = "BON VENT !",
		},
		-- ✋ puis ← : Lâcher royal, les pigeons passent la victime par-dessus sa perruque et la lâchent derrière ; il fait « au revoir »
		THROW_back = {
			label = "Lâcher royal", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 11, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 1.5, 3.5 }, { 0.3, -1.0, 4.5 }, { 0.4, -2.8, 2.0 } },
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 160, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { 4, -30, 0, 0, -0.15, 0.2 }, Waist = { 8, -25, 0 }, Neck = { 10, -50, 0 }, RS = { -40, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 } },
			follow = { Root = { 4, -34, 0, 0, -0.15, 0.22 }, Waist = { 8, -28, 0 }, Neck = { 10, -55, 0 }, RS = { -45, 0, 32 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -20 }, LE = { 45, 0, 0 }, LW = { 0, 0, 10 } },
			fx = { { "symbols", symbols = { "🐦", "👋" }, count = 4, radius = 3, at = "above" } },
			text = "LÂCHEZ TOUT !", hitText = "PLOUF !",
		},
		-- ✋ puis ↑ : Montgolfière de plumes, il lève les bras et la nuée hisse la victime tout droit vers le ciel
		THROW_up = {
			label = "Montgolfière de plumes", kind = "throw", startup = 0.35, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 1.8, 2.5 }, { 0.35, 0.8, 7.0 } },
			windup = { Root = { -6, 0, 0, 0, -0.6, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 70, 0, -10 }, RE = { 60, 0, 0 }, LS = { 70, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.25, -0.1 }, Waist = { 15, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 172, 0, 15 }, RE = { 5, 0, 0 }, LS = { 172, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.3, -0.1 }, Waist = { 18, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 178, 0, 25 }, RE = { 5, 0, 0 }, LS = { 178, 0, -25 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			fx = { { "particles", tex = "smoke", color = FEATHER, dir = "up", at = "above", time = 0.5, speed = 14 }, { "symbols", symbols = { "🎈", "🐦" }, count = 4, radius = 3, at = "above" } },
			text = "EN MONTGOLFIÈRE !", hitText = "ZOUIIIP !",
		},
		-- ✋ puis ↓ : Le trône, il plaque la victime au sol, s'assoit dessus, baguette en sceptre ; les pigeons applaudissent
		THROW_down = {
			label = "Le trône", kind = "throw", startup = 0.4, active = 0.1, hold = 0.3, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 1.8, 1.5 }, { 0.28, 1.2, -2.0 }, { 0.4, 0.6, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, -1.3, -0.6 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 30 }, RE = { 30, 0, 0 }, LS = { 50, 0, -40 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 2, 0, 0, 0, -1.25, -0.6 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 150, 0, 15 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 95, 0, 0 }, LW = { 0, 0, -30 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			fx = { { "symbols", symbols = { "👏", "🐦", "👑" }, count = 6, radius = 3.5, at = "above" } },
			text = "MON TRÔNE !", hitText = "APPLAUDISSEZ !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "statue_de_bronze", label = "Statue de bronze", sequence = { "up", "forward", "up" },
			-- l'adversaire se fige en statue de bronze sur un socle de place publique, un pigeon se pose sur sa tête
			scene = {
				{ "fxAttacker", { "text", text = "NE BOUGEZ PLUS…", color = GOLD } },
				{ "wait", 0.5 },
				{ "color", BRONZE },
				{ "material", "Metal" },
				{ "fx", { "burst", color = BRONZE, size = 4, at = "root" } },
				{ "spawn", at = "target", offset = Vector3.new(0, -3.4, 0), life = 5, pieces = {
					{ "Socle", "", "block", Vector3.new(4, 1.2, 3), Vector3.new(0, 0, 0), Vector3.zero, MARBLE, "Marble" },
					{ "Plaque", "", "block", Vector3.new(2.2, 0.6, 0.1), Vector3.new(0, 0, -1.55), Vector3.zero, GOLD, "Metal" },
				} },
				{ "wait", 0.6 },
				{ "spawn", at = "target", offset = Vector3.new(0, 3.1, 0), life = 4.2, pieces = pigeonPieces("Perche", 0) },
				{ "fx", { "symbols", symbols = { "🐦", "🕊️" }, count = 6, color = FEATHER } },
				{ "text", "POUR L'ÉTERNITÉ." },
				{ "fxAttacker", { "symbols", symbols = { "👑" }, count = 1, radius = 0.5, color = GOLD } },
				{ "wait", 1.4 },
			},
		},
		{
			id = "emporte", label = "Emporté", sequence = { "down", "forward", "down" },
			-- la nuée agrippe l'adversaire et l'emporte dans le ciel, on le voit passer devant la lune
			scene = {
				{ "fxAttacker", { "text", text = "MES AMIS… EMPORTEZ-LE !", color = GOLD } },
				{ "fx", { "symbols", symbols = { "🐦", "🕊️" }, count = 8, radius = 3, color = FEATHER } },
				{ "wait", 0.6 },
				{ "lift", 5, time = 0.8 },
				{ "spawn", at = "above", offset = Vector3.new(16, 26, 12), life = 4, pieces = {
					{ "Lune", "", "ball", Vector3.new(12, 12, 12), Vector3.new(0, 0, 0), Vector3.zero, Color3.fromRGB(250, 240, 190), "Neon" },
					{ "Cratere", "", "ball", Vector3.new(2.5, 2.5, 2.5), Vector3.new(-2, 2, -5.2), Vector3.zero, Color3.fromRGB(225, 215, 165), "SmoothPlastic" },
				} },
				{ "text", "AU REVOIR !" },
				{ "launch", Vector3.new(25, 80, 0), time = 1.6 },
				{ "fxAttacker", { "text", text = "BON VOYAGE !", color = GOLD } },
				{ "wait", 1 },
			},
		},
		{
			id = "le_nid", label = "Le Nid", sequence = { "back", "back", "forward" },
			-- l'adversaire rapetisse dans un nid ; l'œuf éclot et en sort un mini Roi Pigeon
			scene = {
				{ "text", "QUEL JOLI NID…" },
				{ "shrink", 0.3, time = 0.6 },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.5, 0), life = 4.5, pieces = {
					{ "Nid", "", "cyl", Vector3.new(0.9, 3.4, 3.4), Vector3.new(0, 0, 0), Vector3.zero, Color3.fromRGB(130, 95, 55), "Grass" },
					{ "Brindille1", "", "block", Vector3.new(3.6, 0.15, 0.15), Vector3.new(0, 0.4, 0), Vector3.new(0, 30, 10), Color3.fromRGB(110, 80, 45), "Wood" },
					{ "Brindille2", "", "block", Vector3.new(3.4, 0.15, 0.15), Vector3.new(0, 0.4, 0), Vector3.new(0, -40, -8), Color3.fromRGB(110, 80, 45), "Wood" },
					{ "Oeuf", "", "ball", Vector3.new(1.3, 1.7, 1.3), Vector3.new(0, 1.1, 0), Vector3.zero, WHITE, "SmoothPlastic" },
				} },
				{ "hide" },
				{ "wait", 0.9 },
				{ "fx", { "burst", color = WHITE, size = 3, at = "root" } },
				{ "text", "CRAC !" },
				{ "spawn", at = "target", offset = Vector3.new(0, -0.9, 0), life = 3, pieces = {
					{ "MiniCorps", "", "ball", Vector3.new(1.1, 1.2, 1.0), Vector3.new(0, 0, 0), Vector3.zero, VELVET, "Fabric" },
					{ "MiniTete", "", "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0, 0.95, 0), Vector3.zero, SKIN },
					{ "MiniCouronne", "", "cyl", Vector3.new(0.25, 0.6, 0.6), Vector3.new(0, 1.45, 0), Vector3.zero, GOLD, "Metal" },
					{ "MiniCape", "", "block", Vector3.new(1.0, 1.0, 0.12), Vector3.new(0, 0.1, 0.5), Vector3.zero, FEATHER, "Fabric" },
				} },
				{ "fx", { "symbols", symbols = { "👑", "🐣" }, count = 5, color = GOLD } },
				{ "fxAttacker", { "text", text = "MON HÉRITIER !", color = GOLD } },
				{ "wait", 1.3 },
			},
		},
	},

	-- Mécanique : la Nuée (6 pigeons au plus, un pigeon revient toutes les 2 s) ; ses envois coûtent meterCost
	passive = { kind = "flock", name = "Nuée", icon = "🐦", max = 6, regen = 0.5, start = 6, color = FEATHER },

	-- Recharge ⚡ : accroupi, il jette des miettes et picore avec ses pigeons, puis se relève et lisse sa cape en roucoulant
	charge = {
		label = "Picorage royal",
		loop = 1.6,
		lockWrist = false,
		color = Color3.fromRGB(120, 220, 255),
		keys = {
			{ 0.0, { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -20, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 20 }, RE = { 40, 0, 0 }, LS = { 55, 0, -20 }, LE = { 70, 0, 0 } } },
			{ 0.25, { Root = { -8, 0, 0, 0, -0.55, 0 }, Waist = { -24, 0, 0 }, Neck = { -38, 0, 0 }, RS = { 30, 0, 22 }, RE = { 40, 0, 0 }, LS = { 80, 0, -35 }, LE = { 20, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 0.45, { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -20, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 30, 0, 20 }, RE = { 40, 0, 0 }, LS = { 60, 0, -25 }, LE = { 60, 0, 0 } } },
			{ 0.65, { Root = { -8, 0, 0, 0, -0.55, 0 }, Waist = { -24, 0, 0 }, Neck = { -38, 0, 0 }, RS = { 30, 0, 22 }, RE = { 40, 0, 0 }, LS = { 60, 0, -25 }, LE = { 60, 0, 0 } } },
			{ 0.9, { Root = { 2, 0, 0, 0, -0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { 15, 25, 0 }, RS = { 20, 0, 15 }, RE = { 50, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } } },
			{ 1.15, { Root = { 2, 0, 0, 0, -0.12, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 30, 0 }, RS = { 20, 0, 15 }, RE = { 50, 0, 0 }, LS = { -50, 0, -25 }, LE = { 20, 0, 0 } } },
			{ 1.35, { Root = { 0, 0, 0, 0, -0.25, 0 }, Waist = { 4, 0, 0 }, Neck = { 6, 10, 0 }, RS = { 25, 0, 18 }, RE = { 45, 0, 0 }, LS = { -20, 0, -35 }, LE = { 40, 0, 0 } } },
			{ 1.6, { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -20, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 20 }, RE = { 40, 0, 0 }, LS = { 55, 0, -20 }, LE = { 70, 0, 0 } } },
		},
		beats = {
			{ 0.2, { "toss", shape = "ball", color = CRUMB, count = 4, size = 0.25, speed = 8 } },
			{ 0.3, { "symbols", symbols = { "🐦" }, count = 2, radius = 2.5, at = "feet", color = FEATHER } },
			{ 1.0, { "text", text = "ROUCOULOU…", color = Color3.fromRGB(200, 205, 230) } },
		},
	},

	-- Manies au repos : lisse sa cape, donne une miette au pigeon de l'épaule, roucoule la main sur le jabot
	fidgets = {
		{ duration = 2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.5, { Neck = { 0, 30, 0 }, LS = { -40, 0, -35 }, LE = { 30, 0, 0 } } },
			{ 1.0, { Neck = { 6, 35, 0 }, LS = { -55, 0, -20 }, LE = { 15, 0, 0 } } },
			{ 1.4, { Neck = { 8, 20, 0 }, LS = { -30, 0, -30 }, LE = { 30, 0, 0 } } },
			{ 2, {} },
		} },
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.5, { Neck = { -6, -35, 0 }, LS = { 95, 0, 35 }, LE = { 110, 0, 0 } } },
			{ 0.9, { Neck = { -14, -40, 0 }, LS = { 100, 0, 40 }, LE = { 120, 0, 0 } } },
			{ 1.3, { Neck = { -4, -35, 0 }, LS = { 95, 0, 35 }, LE = { 110, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 1.8, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.3, { Waist = { 10, 0, 0 }, Neck = { 18, 0, 0 }, LS = { 50, 0, 15 }, LE = { 120, 0, 0 } } },
			{ 0.6, { Waist = { 12, 0, 0 }, Neck = { -15, 0, 0 }, LS = { 50, 0, 15 }, LE = { 120, 0, 0 } } },
			{ 0.9, { Waist = { 10, 0, 0 }, Neck = { 18, 0, 0 }, LS = { 50, 0, 15 }, LE = { 120, 0, 0 } } },
			{ 1.2, { Waist = { 12, 0, 0 }, Neck = { -15, 0, 0 }, LS = { 50, 0, 15 }, LE = { 120, 0, 0 } } },
			{ 1.8, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : la nuée le serre, lui lève la baguette comme un sceptre, menton en l'air
data.grabHold = {
	Root = { 6, 0, 0, 0, -0.1, 0 },
	Waist = { 10, 0, 0 },
	Neck = { 18, 0, 0 },
	RS = { 150, 0, 25 },
	RE = { 40, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 85, 0, -15 },
	LE = { 30, 0, 0 },
	LW = { 0, 0, -30 },
}

-- Retour 🪂 : une nuée le dépose sur un socle de statue, il réajuste sa couronne pendant que les pigeons se posent
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Socle", "base", "block", Vector3.new(5, 1, 3), Vector3.new(0, -0.5, 0), Vector3.zero, MARBLE, "Marble" },
		{ "Corniche", "", "block", Vector3.new(5.4, 0.25, 3.4), Vector3.new(0, -0.1, 0), Vector3.zero, Color3.fromRGB(195, 195, 205), "Marble" },
		{ "Plaque", "", "block", Vector3.new(2, 0.5, 0.1), Vector3.new(0, -0.55, -1.55), Vector3.zero, GOLD, "Metal" },
		{ "PigeonPose1", "", "ball", Vector3.new(0.8, 0.65, 1.0), Vector3.new(-2.1, 0.32, 0.6), Vector3.zero, FEATHER, "Fabric" },
		{ "PigeonPose1Tete", "", "ball", Vector3.new(0.42, 0.42, 0.42), Vector3.new(-2.1, 0.78, 0.25), Vector3.zero, NECK },
		{ "PigeonPose2", "", "ball", Vector3.new(0.8, 0.65, 1.0), Vector3.new(2.1, 0.32, 0.5), Vector3.zero, FEATHER, "Fabric" },
		{ "PigeonPose2Tete", "", "ball", Vector3.new(0.42, 0.42, 0.42), Vector3.new(2.1, 0.78, 0.15), Vector3.zero, NECK },
		{ "Miettes", "", "block", Vector3.new(0.8, 0.1, 0.5), Vector3.new(1.2, 0.05, -0.8), Vector3.zero, CRUMB },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, 0.3, 0 }, Waist = { 8, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 30 }, RE = { 20, 0, 0 }, LS = { 160, 0, -30 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } } },
		{ 0.45, { Root = { -6, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 100, 0, 60 }, RE = { 20, 0, 0 }, LS = { 100, 0, -60 }, LE = { 20, 0, 0 } } },
		{ 0.8, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, -8 }, RS = { 150, 0, -30 }, RE = { 110, 0, 0 }, LS = { 20, 0, -20 }, LE = { 30, 0, 0 } } },
		{ 1.1, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 14, 0, 6 }, RS = { 155, 0, -25 }, RE = { 115, 0, 0 }, LS = { 20, 0, -20 }, LE = { 30, 0, 0 } } },
		{ 1.45, { Waist = { 10, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 30, 0, 20 }, RE = { 40, 0, 0 }, LS = { 40, 0, -60 }, LE = { 90, 0, 0 }, LW = { 0, 0, -30 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.05, { "symbols", symbols = { "🐦", "🕊️" }, count = 6, radius = 3, at = "above", color = FEATHER } },
		{ 0.45, { "burst", color = FEATHER, size = 3, at = "feet" } },
		{ 0.85, { "symbols", symbols = { "👑" }, count = 1, radius = 0.5, at = "above", color = GOLD } },
		{ 1.3, { "text", text = "SA MAJESTÉ EST DE RETOUR !", color = GOLD } },
	},
}

-- Arbre d'enchaînements : P → P → P (pied, picorage, baguette), K → K → K (talons et coup de pied du sacre),
-- chaque chaîne peut finir sur S (Nuée vorace ou Baguette volante).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol, sans direction (P P P K : baguette brisée, finition ; P P →P : coups de bec)
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side2", S = "S_finish_peck" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", fwd_P = "P_peck", S = "S_finish_peck" }, -- P P
	P_combo3 = { K = "K_bread", P = "P_peck", S = "S_finish_bread" }, -- P P P
	P_peck = { P = "P_combo3", K = "K_cape", S = "S_finish_peck" }, -- P P →P (coups de bec)
	PK_combo = { P = "KP_combo", K = "K_cape", S = "S_finish_bread" }, -- P K
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_peck" },
	K_combo2 = { K = "K_combo3", P = "P_peck", fwd_K = "K_cape", S = "S_finish_bread" }, -- K K
	K_combo3 = { K = "K_air_side", P = "P_air", S = "S_air" }, -- K K K : il décolle
	K_cape = { K = "K_bread", P = "P_combo3", S = "S_finish_peck" }, -- K K →K (matador)
	KP_combo = { K = "K_cape", P = "P_peck", S = "S_finish_peck" }, -- K P (perruque)
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_bread" },
	P_side2 = { K = "PK_combo", P = "P_peck", S = "S_finish_peck" },
	P_down = { P = "P_up2", K = "K_down", S = "S_finish_peck" },
	P_up = { P = "P_up2", K = "K_up", S = "S_finish_peck" },
	P_up2 = { P = "P_air_up", K = "K_air_up", S = "S_air" },
	K_side = { P = "KP_combo", K = "K_cape", S = "S_finish_bread" },
	K_down = { P = "P_up2", K = "K_cape", S = "S_finish_peck" },
	K_up = { P = "P_up2", S = "S_finish_bread" },
	P_dash = { P = "P_side2", K = "K_combo2", S = "S_finish_peck" },
	K_dash = { P = "KP_combo", K = "K_cape", S = "S_finish_bread" },
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

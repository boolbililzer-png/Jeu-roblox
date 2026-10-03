-- Ramsès le Patraque : momie hypocondriaque aux bandelettes qui se défont, thermomètre en bouche, écharpe
-- et pantoufles ; il se plaint en permanence et enrhume tout le monde (contagion : l'enrhumé éternue au hasard).
-- Arme sortie de la Caisse Bizarre : bandelettes et thermomètre géant.
--
-- Même format que Gege.lua (voir l'en-tête de ce fichier et docs/fiche-perso.md).
-- Le bras droit tient le thermomètre géant ; la main gauche sort la bandelette, le mouchoir, la bouillotte,
-- le couvercle de sarcophage ou la fiole de sirop le temps d'un coup (accessoires cachés, champ prop).
-- Signatures (L) et Supers (Y) « sûrs de toucher » : couloirs de 16 studs, projectiles qui visent l'adversaire,
-- ↑L = envol en diagonale ; plus aucun coût (voir docs/fiche-perso.md).

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local BANDAGE = Color3.fromRGB(228, 214, 176)
local BANDAGE_DARK = Color3.fromRGB(196, 178, 136)
local SCARF = Color3.fromRGB(200, 50, 50)
local GERM = Color3.fromRGB(150, 210, 90)
local FEVER = Color3.fromRGB(255, 110, 70)
local GLASS = Color3.fromRGB(230, 245, 255)
local MERCURY = Color3.fromRGB(230, 30, 40)
local GOLD = Color3.fromRGB(230, 180, 60)
local LAPIS = Color3.fromRGB(40, 70, 170)
local SYRUP = Color3.fromRGB(230, 90, 160)
local SLIPPER = Color3.fromRGB(120, 70, 140)
local TISSUE = Color3.fromRGB(250, 250, 255)
local EYE = Color3.fromRGB(255, 235, 160)

-- Monstre-microbe géant (projectile du Grand Rhume) : grosse boule verte, deux yeux globuleux, dents, antennes
local GERM_MONSTER = { shape = "ball", size = 6, color = GERM, transparency = 0.35, spin = 2, parts = {
	{ "ball", Vector3.new(1.4, 1.4, 1.4), Vector3.new(1.4, 1.2, -2.4), Color3.fromRGB(255, 255, 255) },
	{ "ball", Vector3.new(1.4, 1.4, 1.4), Vector3.new(-1.4, 1.2, -2.4), Color3.fromRGB(255, 255, 255) },
	{ "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(1.4, 1.2, -3.0), Color3.fromRGB(30, 30, 40) },
	{ "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-1.4, 1.2, -3.0), Color3.fromRGB(30, 30, 40) },
	{ "block", Vector3.new(2.2, 0.6, 0.3), Vector3.new(0, -0.8, -2.8), Color3.fromRGB(255, 255, 255) },
	{ "ball", Vector3.new(2.2, 2.2, 2.2), Vector3.new(2.8, 1.8, 0), GERM },
	{ "ball", Vector3.new(2, 2, 2), Vector3.new(-2.6, -1.8, 0), GERM },
	{ "ball", Vector3.new(1.8, 1.8, 1.8), Vector3.new(0.4, 3, 0), GERM },
} }

local data = {
	id = "Ramses",
	name = "Ramsès le Patraque",
	costume = "Ramses",
	style = "sick",

	look = {
		body = { head = BANDAGE, upper = BANDAGE, lower = BANDAGE, arms = BANDAGE, hands = BANDAGE_DARK, legs = BANDAGE, feet = SLIPPER },
		cubeHead = 1.25,
		parts = {
			-- tête emmaillotée, yeux fatigués qui luisent au fond des bandes
			{ "BandeFront", "Head", "block", Vector3.new(1.32, 0.2, 1.32), Vector3.new(0, 0.38, 0), Vector3.new(0, 0, 7), BANDAGE_DARK, "Fabric" },
			{ "BandeJoues", "Head", "block", Vector3.new(1.32, 0.18, 1.32), Vector3.new(0, -0.12, 0), Vector3.new(0, 0, -6), BANDAGE_DARK, "Fabric" },
			{ "BandeMenton", "Head", "block", Vector3.new(1.32, 0.16, 1.32), Vector3.new(0, -0.48, 0), Vector3.new(0, 0, 4), BANDAGE_DARK, "Fabric" },
			{ "OeilDroit", "Head", "ball", Vector3.new(0.22, 0.16, 0.06), Vector3.new(0.27, 0.12, -0.65), Vector3.zero, EYE, "Neon", { neon = true } },
			{ "OeilGauche", "Head", "ball", Vector3.new(0.18, 0.12, 0.06), Vector3.new(-0.27, 0.1, -0.65), Vector3.zero, EYE, "Neon", { neon = true } },
			{ "Sparadrap1", "Head", "block", Vector3.new(0.4, 0.1, 0.04), Vector3.new(-0.35, -0.28, -0.66), Vector3.new(0, 0, 40), Color3.fromRGB(240, 200, 170) },
			{ "Sparadrap2", "Head", "block", Vector3.new(0.4, 0.1, 0.04), Vector3.new(-0.35, -0.28, -0.665), Vector3.new(0, 0, -40), Color3.fromRGB(240, 200, 170) },
			-- thermomètre en bouche et poche de glace sur le crâne
			{ "Thermometre", "Head", "cyl", Vector3.new(0.75, 0.1, 0.1), Vector3.new(0.18, -0.36, -0.95), Vector3.new(-12, 15, 0), GLASS, "Glass", { axis = "z" } },
			{ "BoutRouge", "Head", "ball", Vector3.new(0.14, 0.14, 0.14), Vector3.new(0.27, -0.43, -1.3), Vector3.zero, MERCURY, "Neon", { neon = true } },
			{ "PocheGlace", "Head", "ball", Vector3.new(1.0, 0.4, 0.95), Vector3.new(0.12, 0.8, 0.05), Vector3.new(0, 0, -10), Color3.fromRGB(120, 190, 240), "Fabric" },
			{ "BouchonPoche", "Head", "cyl", Vector3.new(0.2, 0.3, 0.3), Vector3.new(0.15, 1.02, 0.05), Vector3.zero, Color3.fromRGB(240, 240, 245) },
			-- grosse écharpe de laine (il a froid)
			{ "Echarpe", "UpperTorso", "block", Vector3.new(1.9, 0.42, 1.18), Vector3.new(0, 0.86, 0), Vector3.zero, SCARF, "Fabric" },
			{ "PanEcharpe", "UpperTorso", "block", Vector3.new(0.4, 1.2, 0.12), Vector3.new(0.42, 0.15, -0.58), Vector3.new(0, 0, -8), SCARF, "Fabric" },
			-- bandelettes du corps, dont une qui pend et traîne
			{ "BandeTorse1", "UpperTorso", "block", Vector3.new(2.06, 0.22, 1.06), Vector3.new(0, 0.3, 0), Vector3.new(0, 0, 9), BANDAGE_DARK, "Fabric" },
			{ "BandeTorse2", "UpperTorso", "block", Vector3.new(2.06, 0.22, 1.06), Vector3.new(0, -0.35, 0), Vector3.new(0, 0, -11), BANDAGE_DARK, "Fabric" },
			{ "BandePendante", "LowerTorso", "block", Vector3.new(0.26, 1.5, 0.06), Vector3.new(-0.65, -0.8, -0.55), Vector3.new(0, 0, 12), BANDAGE, "Fabric" },
			{ "BandeBras", "LeftLowerArm", "block", Vector3.new(1.05, 0.16, 1.05), Vector3.new(0, 0.1, 0), Vector3.new(0, 0, 14), BANDAGE_DARK, "Fabric" },
			{ "BoutBras", "LeftLowerArm", "block", Vector3.new(0.2, 1.1, 0.05), Vector3.new(0.35, -0.75, 0.2), Vector3.new(0, 0, -10), BANDAGE, "Fabric" },
			{ "BandeCuisse", "LeftUpperLeg", "block", Vector3.new(1.06, 0.18, 1.06), Vector3.new(0, 0.1, 0), Vector3.new(0, 0, -10), BANDAGE_DARK, "Fabric" },
			-- pied plâtré et pantoufles
			{ "Platre", "RightLowerLeg", "block", Vector3.new(1.15, 1.3, 1.15), Vector3.new(0, -0.1, 0), Vector3.zero, Color3.fromRGB(250, 250, 250), "SmoothPlastic" },
			{ "Signature", "RightLowerLeg", "block", Vector3.new(0.5, 0.12, 0.04), Vector3.new(0.1, 0, -0.59), Vector3.new(0, 0, 15), Color3.fromRGB(40, 90, 220) },
			{ "PantoufleD", "RightFoot", "block", Vector3.new(1.0, 0.42, 1.35), Vector3.new(0, -0.05, -0.15), Vector3.zero, SLIPPER, "Fabric" },
			{ "PantoufleG", "LeftFoot", "block", Vector3.new(1.0, 0.42, 1.35), Vector3.new(0, -0.05, -0.15), Vector3.zero, SLIPPER, "Fabric" },
			{ "Pompon", "LeftFoot", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, 0.2, -0.75), Vector3.zero, Color3.fromRGB(255, 200, 230), "Fabric" },
		},
		props = {
			-- l'arme : le thermomètre géant (tube de verre, mercure rouge, réservoir)
			{ name = "PropThermometre", hand = "Right", visible = true, pieces = {
				{ "Tube", "", "cyl", Vector3.new(2.8, 0.42, 0.42), Vector3.new(0, -1.3, 0), Vector3.zero, GLASS, "Glass", { transparency = 0.25 } },
				{ "Mercure", "", "cyl", Vector3.new(2.2, 0.16, 0.16), Vector3.new(0, -1.55, 0), Vector3.zero, MERCURY, "Neon", { neon = true } },
				{ "Reservoir", "", "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0, -2.75, 0), Vector3.zero, MERCURY, "SmoothPlastic" },
				{ "Bouchon", "", "cyl", Vector3.new(0.3, 0.46, 0.46), Vector3.new(0, 0.05, 0), Vector3.zero, Color3.fromRGB(190, 195, 205), "Metal" },
				{ "Graduation", "", "block", Vector3.new(0.05, 1.6, 0.2), Vector3.new(0, -1.2, -0.2), Vector3.zero, Color3.fromRGB(40, 40, 50) },
			} },
			-- objets de la main gauche, le temps d'un coup
			{ name = "PropBandelette", hand = "Left", visible = false, pieces = {
				{ "Bande", "", "block", Vector3.new(0.32, 5, 0.06), Vector3.new(0, -2.5, 0), Vector3.zero, BANDAGE, "Fabric" },
				{ "Bout", "", "block", Vector3.new(0.36, 0.5, 0.08), Vector3.new(0, -5.1, 0), Vector3.new(0, 0, 20), BANDAGE_DARK, "Fabric" },
			} },
			{ name = "PropMouchoir", hand = "Left", visible = false, pieces = {
				{ "Mouchoir", "", "block", Vector3.new(0.9, 2.6, 0.05), Vector3.new(0, -1.4, 0), Vector3.zero, TISSUE, "Fabric" },
				{ "Noeud", "", "ball", Vector3.new(0.6, 0.5, 0.5), Vector3.new(0, -2.8, 0), Vector3.zero, TISSUE, "Fabric" },
				{ "Tache", "", "ball", Vector3.new(0.3, 0.3, 0.08), Vector3.new(0.1, -1.6, -0.04), Vector3.zero, GERM, "Neon", { neon = true } },
			} },
			{ name = "PropBouillotte", hand = "Left", visible = false, pieces = {
				{ "Poche", "", "block", Vector3.new(1.1, 1.4, 0.4), Vector3.new(0, -1.0, 0), Vector3.zero, Color3.fromRGB(220, 60, 60), "SmoothPlastic" },
				{ "Goulot", "", "cyl", Vector3.new(0.35, 0.3, 0.3), Vector3.new(0, -0.2, 0), Vector3.zero, Color3.fromRGB(180, 40, 40) },
			} },
			{ name = "PropSarcophage", hand = "Left", visible = false, pieces = {
				{ "Couvercle", "", "block", Vector3.new(1.8, 3.8, 0.4), Vector3.new(0, -1.6, -0.3), Vector3.zero, GOLD, "Metal", { reflect = 0.15 } },
				{ "Visage", "", "block", Vector3.new(0.9, 1, 0.12), Vector3.new(0, -0.3, -0.55), Vector3.zero, Color3.fromRGB(240, 200, 120), "SmoothPlastic" },
				{ "Coiffe", "", "block", Vector3.new(1.6, 0.25, 0.1), Vector3.new(0, -1.2, -0.55), Vector3.zero, LAPIS, "SmoothPlastic" },
				{ "Bande2", "", "block", Vector3.new(1.6, 0.25, 0.1), Vector3.new(0, -2.2, -0.55), Vector3.zero, LAPIS, "SmoothPlastic" },
			} },
			{ name = "PropFiole", hand = "Left", visible = false, pieces = {
				{ "Fiole", "", "ball", Vector3.new(0.7, 0.8, 0.7), Vector3.new(0, -0.6, 0), Vector3.zero, SYRUP, "Glass", { transparency = 0.15 } },
				{ "Col", "", "cyl", Vector3.new(0.35, 0.22, 0.22), Vector3.new(0, -0.1, 0), Vector3.zero, GLASS, "Glass" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de thermomètre : voûté, une main sur les reins (« aïe mon dos »), il pique mollement le thermomètre en avant comme une canne à pêche
		P_neutral = {
			label = "Coup de thermomètre", startup = 0.08, active = 0.08, recovery = 0.15,
			damage = 6, hitbox = box(5, 3, 3, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { -8, -14, 0, 0, -0.2, 0.15 }, Waist = { -12, -16, 0 }, Neck = { 12, 10, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 10, 0, 0 }, LS = { -30, 0, -20 }, LE = { 70, 0, 0 }, LW = { 40, 0, 0 } },
			strike = { Root = { -14, 12, 0, 0, -0.28, -0.3 }, Waist = { -16, 14, 0 }, Neck = { 4, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -20 }, LE = { 70, 0, 0 }, LW = { 40, 0, 0 } },
			follow = { Root = { -15, 14, 0, 0, -0.3, -0.33 }, Waist = { -17, 16, 0 }, Neck = { 2, 0, 0 }, RS = { 98, 0, -4 }, RE = { 4, 0, 0 }, RW = { -8, 0, 0 }, LS = { -30, 0, -20 }, LE = { 70, 0, 0 }, LW = { 40, 0, 0 } },
			trail = "prop", hitText = "TOC !",
		},
		-- Mouchoir-fouet : il fait claquer son mouchoir usagé à mi-distance comme une serviette (enrhume)
		P_side = {
			label = "Mouchoir-fouet", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(6.5, 2.5, 4.2, 0.8), kbBase = 20, kbGrowth = 32, kbAngle = 25,
			status = { name = "sneezy", duration = 1.5 },
			windup = { Root = { -4, 20, 0, 0, -0.15, 0.2 }, Waist = { -6, 22, 0 }, Neck = { 6, -14, 0 }, LS = { 120, 0, -70 }, LE = { 60, 0, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 } },
			strike = { Root = { -10, -16, 0, 0, -0.25, -0.3 }, Waist = { -10, -20, 0 }, Neck = { 0, 10, 0 }, LS = { 92, 0, 8 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 }, RS = { 15, 0, 30 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -11, -22, 0, 0, -0.27, -0.33 }, Waist = { -11, -26, 0 }, Neck = { 0, 14, 0 }, LS = { 80, 0, 30 }, LE = { 5, 0, 0 }, LW = { -40, 0, 0 }, RS = { 15, 0, 30 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			prop = "mouchoir", trail = "leftHand", fx = { { "particles", tex = "smoke", color = GERM, at = "lhand", dir = "front", time = 0.2, rate = 40, speed = 6, size = 0.4 } },
			text = "BEURK !", hitText = "SCHLAK !",
		},
		-- Bandelette traînante : accroupi, il défait une bandelette de son bras et fouette les chevilles
		P_down = {
			label = "Bandelette traînante", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(6, 2, 3.6, -2), kbBase = 24, kbGrowth = 20, kbAngle = 74,
			windup = { Root = { -10, 25, 0, 0, -0.65, 0.15 }, Waist = { -14, 20, 0 }, Neck = { 10, -15, 0 }, LS = { 60, 0, -80 }, LE = { 30, 0, 0 }, RS = { 30, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { -14, -15, 0, 0, -0.8, -0.1 }, Waist = { -20, -18, 0 }, Neck = { 12, 10, 0 }, LS = { 40, 0, 15 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, RS = { 25, 0, 30 }, RE = { 65, 0, 0 } },
			follow = { Root = { -14, -22, 0, 0, -0.8, -0.12 }, Waist = { -20, -24, 0 }, Neck = { 12, 14, 0 }, LS = { 30, 0, 35 }, LE = { 5, 0, 0 }, LW = { -40, 0, 0 }, RS = { 25, 0, 30 }, RE = { 65, 0, 0 } },
			prop = "bandelette", trail = "leftHand", hitText = "FOUET !",
		},
		-- Atchoum (anti-air) : il inspire en se cambrant (« AAAH… ») puis éternue vers le ciel, la tête en avant
		P_up = {
			label = "Atchoum", startup = 0.12, active = 0.12, recovery = 0.22,
			damage = 7, hitbox = box(5, 5, 1.5, 3.5), kbBase = 26, kbGrowth = 30, kbAngle = 82,
			status = { name = "sneezy", duration = 2 },
			windup = { Root = { 10, 0, 0, 0, -0.05, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 35 }, RE = { 50, 0, 0 }, LS = { 30, 0, -35 }, LE = { 50, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.25, -0.15 }, Waist = { -16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 10, 0, 40 }, RE = { 40, 0, 0 }, LS = { 10, 0, -40 }, LE = { 40, 0, 0 } },
			follow = { Root = { -14, 0, 0, 0, -0.28, -0.2 }, Waist = { -18, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 5, 0, 42 }, RE = { 40, 0, 0 }, LS = { 5, 0, -42 }, LE = { 40, 0, 0 } },
			shake = true, fx = { { "particles", tex = "smoke", color = GERM, at = "above", dir = "up", time = 0.25, rate = 80, speed = 12, size = 0.8 } },
			text = "AAAH… ATCHOUM !", hitText = "BEURK !",
		},
		-- Atchoum volant (en l'air) : en plein saut, un éternuement violent part devant lui
		P_air = {
			label = "Atchoum volant", startup = 0.1, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 2.8, 0.8), kbBase = 22, kbGrowth = 32, kbAngle = 30,
			status = { name = "sneezy", duration = 1.5 },
			windup = { Root = { 10, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -14, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 45 }, RE = { 40, 0, 0 }, LS = { 20, 0, -45 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -16, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 18, 0, 46 }, RE = { 40, 0, 0 }, LS = { 18, 0, -46 }, LE = { 40, 0, 0 }, RH = { 62, 0, 0 }, RK = { -92, 0, 0 }, LH = { 72, 0, 0 }, LK = { -102, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = GERM, at = "head", dir = "front", time = 0.2, rate = 80, speed = 12, size = 0.7 } },
			text = "ATCHOUM !", hitText = "BEURK !",
		},
		-- Bouillotte volante (dash puis P) : il fonce en faisant tournoyer sa bouillotte de la main gauche
		P_dash = {
			label = "Bouillotte volante", startup = 0.09, active = 0.14, recovery = 0.25,
			damage = 8, hitbox = box(5, 3, 2.8, 0.6), kbBase = 26, kbGrowth = 46, kbAngle = 28, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -6, 25, 0, 0, -0.2, 0.15 }, Waist = { -6, 25, 0 }, LS = { 60, 0, -90 }, LE = { 20, 0, 0 }, RS = { -20, 0, 25 }, RE = { 40, 0, 0 } },
			strike = { Root = { -16, -18, 0, 0, -0.3, -0.3 }, Waist = { -10, -22, 0 }, Neck = { 10, 12, 0 }, LS = { 90, 0, 20 }, LE = { 5, 0, 0 }, RS = { -40, 0, 30 }, RE = { 30, 0, 0 } },
			follow = { Root = { -18, -24, 0, 0, -0.32, -0.35 }, Waist = { -11, -28, 0 }, Neck = { 12, 14, 0 }, LS = { 85, 0, 40 }, LE = { 8, 0, 0 }, RS = { -45, 0, 32 }, RE = { 30, 0, 0 } },
			prop = "bouillotte", trail = "leftHand", fx = { "dust" }, text = "ELLE EST CHAUDE !", hitText = "FLOC !",
		},

		-- Suites d'enchaînement P
		-- P P : revers de thermomètre, il ramène le thermomètre dans l'autre sens en grimaçant
		P_combo2 = {
			label = "Revers de thermomètre", startup = 0.08, active = 0.08, recovery = 0.17,
			damage = 5, hitbox = box(5, 3.5, 2.8, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { -12, 22, 0, 0, -0.25, -0.2 }, Waist = { -12, 28, 0 }, RS = { 80, 0, -40 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 15 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, -14, 0, 0, -0.25, -0.3 }, Waist = { -10, -18, 0 }, Neck = { 0, 8, 0 }, RS = { 92, 0, 35 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 15 }, LE = { 80, 0, 0 } },
			follow = { Root = { -10, -20, 0, 0, -0.25, -0.32 }, Waist = { -10, -24, 0 }, Neck = { 0, 10, 0 }, RS = { 86, 0, 55 }, RE = { 12, 0, 0 }, RW = { -15, 0, 0 }, LS = { 35, 0, 15 }, LE = { 80, 0, 0 } },
			trail = "prop", hitText = "TIC !",
		},
		-- P P P : Prise de température, il plante le thermomètre en avant… et constate de la fièvre (enrhume)
		P_combo3 = {
			label = "Prise de température", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 3.5, 3.2, 0.6), kbBase = 30, kbGrowth = 58, kbAngle = 30,
			status = { name = "sneezy", duration = 2 },
			windup = { Root = { 0, -20, 0, 0, -0.15, 0.3 }, Waist = { 0, -22, 0 }, Neck = { 8, 14, 0 }, RS = { 60, 0, 35 }, RE = { 120, 0, 0 }, RW = { 80, 0, 0 }, LS = { 50, 0, -10 }, LE = { 90, 0, 0 } },
			strike = { Root = { -14, 10, 0, 0, -0.3, -0.45 }, Waist = { -12, 12, 0 }, Neck = { 0, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 88, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -15, 12, 0, 0, -0.32, -0.5 }, Waist = { -13, 14, 0 }, Neck = { 4, 0, 0 }, RS = { 93, 0, -2 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 25, 0, -32 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			hold = 0.08, trail = "prop", fx = { { "symbols", symbols = { "🌡️", "39°" }, color = FEVER, count = 3, radius = 2, at = "front" } },
			text = "VOUS AVEZ DE LA FIÈVRE !", hitText = "PIC !",
		},
		-- P puis K : pied plâtré traînant, il balance sa jambe raide au ras du sol
		PK_combo = {
			label = "Plâtre traînant", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 7, hitbox = box(5.5, 3.5, 2.8, -1), kbBase = 24, kbGrowth = 34, kbAngle = 40,
			windup = { Root = { -8, -12, 0, 0, -0.3, 0.15 }, Waist = { -10, -10, 0 }, RS = { 30, 0, 40 }, RE = { 50, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, RH = { -30, 0, 15 }, RK = { 0, 0, 0 } },
			strike = { Root = { 0, 14, 0, 0, -0.35, -0.2 }, Waist = { -6, 10, 0 }, RS = { 20, 0, 45 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { 50, 0, -5 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 } },
			follow = { Root = { 0, 18, 0, 0, -0.35, -0.22 }, Waist = { -6, 12, 0 }, RS = { 18, 0, 46 }, RE = { 40, 0, 0 }, LS = { 52, 0, -42 }, LE = { 70, 0, 0 }, RH = { 52, 0, -12 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 } },
			trail = "rightFoot", hitText = "CLONK !",
		},
		-- ↓P P : Bandelette remontante, il tire sa bandelette vers le haut d'un coup sec (fait décoller)
		P_down2 = {
			label = "Bandelette remontante", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 7, hitbox = box(5, 4.5, 2.6, 1), kbBase = 30, kbGrowth = 40, kbAngle = 82,
			windup = { Root = { -12, 10, 0, 0, -0.8, 0.1 }, Waist = { -18, 10, 0 }, LS = { 20, 0, 10 }, LE = { 10, 0, 0 }, RS = { 30, 0, 25 }, RE = { 70, 0, 0 } },
			strike = { Root = { 4, -6, 0, 0, 0.05, 0.1 }, Waist = { 10, -8, 0 }, Neck = { 20, 0, 0 }, LS = { 172, 0, -10 }, LE = { 10, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 6, -8, 0, 0, 0.1, 0.15 }, Waist = { 12, -10, 0 }, Neck = { 24, 0, 0 }, LS = { 182, 0, -15 }, LE = { 10, 0, 0 }, RS = { 30, 0, 32 }, RE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			prop = "bandelette", trail = "leftHand", hitText = "ZIOUP !",
		},
		-- P P P P : Thermomètre qui explose, 42° !, le mercure monte, monte… et le thermomètre éclate au nez de l'adversaire
		P_combo4 = {
			label = "Thermomètre qui explose", startup = 0.1, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 34, kbGrowth = 80, kbAngle = 45,
			status = { name = "sneezy", duration = 2 },
			windup = { Root = { -6, 0, 0, 0, -0.2, 0.2 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.3, -0.4 }, Waist = { -14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 15 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 14, 0, 0, 0, -0.15, 0.3 }, Waist = { 18, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } },
			shake = true, trail = "prop", windupFx = { { "symbols", symbols = { "40°", "41°", "42°" }, color = FEVER, count = 3, radius = 2, at = "hand" } },
			fx = { { "burst", color = MERCURY, size = 4, at = "front" }, { "symbols", symbols = { "🌡️", "💥" }, color = MERCURY, count = 4, radius = 3, at = "front" }, { "shake", amount = 0.4 } },
			text = "TROP DE FIÈVRE !", hitText = "KABOUM !",
		},
		-- → P P : Mouchoir essoré, il l'essore d'un coup de poignet et le fait claquer dans l'autre sens (enrhume)
		P_side2 = {
			label = "Mouchoir essoré", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(6, 3.5, 3.5, 0.6), kbBase = 18, kbGrowth = 26, kbAngle = 25,
			status = { name = "sneezy", duration = 1 },
			windup = { Root = { -8, -24, 0, 0, -0.22, -0.2 }, Waist = { -8, -28, 0 }, Neck = { 0, 18, 0 }, LS = { 80, 0, 40 }, LE = { 70, 0, 0 }, LW = { 30, 0, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 } },
			strike = { Root = { -10, 20, 0, 0, -0.26, -0.32 }, Waist = { -10, 24, 0 }, Neck = { 0, -14, 0 }, LS = { 92, 0, -40 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 }, RS = { 15, 0, 32 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -10, 28, 0, 0, -0.26, -0.35 }, Waist = { -10, 32, 0 }, Neck = { 0, -18, 0 }, LS = { 86, 0, -60 }, LE = { 5, 0, 0 }, LW = { -40, 0, 0 }, RS = { 15, 0, 32 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			prop = "mouchoir", trail = "leftHand", fx = { { "particles", tex = "smoke", color = GERM, at = "lhand", dir = "front", time = 0.15, rate = 40, speed = 6, size = 0.4 } }, text = "RE-BEURK !", hitText = "SCHLAK SCHLAK !",
		},
		-- → P P P : Mouche-toi !, il plaque le mouchoir usagé à deux mains sur le visage de l'adversaire et appuie fort
		P_side3 = {
			label = "Mouche-toi !", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 34, kbGrowth = 78, kbAngle = 40,
			status = { name = "sneezy", duration = 2.5 },
			windup = { Root = { 6, 0, 0, 0, -0.15, 0.25 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, LS = { 60, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RS = { 60, 0, -20 }, RE = { 110, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.3, -0.45 }, Waist = { -18, 0, 0 }, Neck = { 0, 0, 0 }, LS = { 92, 0, 10 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -18, 0, 0, 0, -0.32, -0.5 }, Waist = { -20, 0, 0 }, Neck = { -4, 0, 0 }, LS = { 94, 0, 12 }, LE = { 2, 0, 0 }, LW = { -35, 0, 0 }, RS = { 94, 0, -12 }, RE = { 2, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			prop = "mouchoir", trail = "bothHands", fx = { { "burst", color = GERM, size = 3, at = "front" }, { "symbols", symbols = { "🤧", "🤢" }, color = GERM, count = 4, radius = 3, at = "front" } },
			text = "ET ON SE MOUCHE !", hitText = "SCHMOLF !",
		},
		-- P K P : Bouillotte sur le crâne, il sort sa bouillotte bouillante et l'abat à deux mains sur la tête de l'adversaire
		PKP_combo = {
			label = "Bouillotte sur le crâne", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 4.5, 2.8, 0.8), kbBase = 34, kbGrowth = 76, kbAngle = 35, burn = true, burnTime = 1.5,
			windup = { Root = { 8, 0, 0, 0, -0.05, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, LS = { 185, 0, -10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RS = { 170, 0, 15 }, RE = { 50, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.4, -0.35 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, LS = { 78, 0, 5 }, LE = { 5, 0, 0 }, LW = { 30, 0, 0 }, RS = { 70, 0, 10 }, RE = { 20, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.45, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -8, 0, 0 }, LS = { 58, 0, 5 }, LE = { 8, 0, 0 }, LW = { 30, 0, 0 }, RS = { 52, 0, 12 }, RE = { 20, 0, 0 } },
			prop = "bouillotte", trail = "leftHand", fx = { { "particles", tex = "fire", color = FEVER, at = "lhand", dir = "up", time = 0.2, rate = 40, speed = 6, size = 0.5 }, { "burst", color = Color3.fromRGB(220, 60, 60), size = 2.5, at = "front" } },
			text = "ELLE EST BOUILLANTE !", hitText = "FLOC !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Coup de sarcophage : il sort le couvercle de son sarcophage et le pousse de l'épaule comme un bouclier
		K_neutral = {
			label = "Coup de sarcophage", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(5, 4.5, 2.6, 0.6), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { 0, 30, 0, 0, -0.3, 0.3 }, Waist = { -4, 26, 0 }, Neck = { 0, -20, 0 }, LS = { 70, 0, -60 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 } },
			strike = { Root = { -14, -10, 0, 0, -0.4, -0.5 }, Waist = { -12, -12, 0 }, Neck = { 6, 6, 0 }, LS = { 90, 0, 10 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 40 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, -12, 0, 0, -0.42, -0.58 }, Waist = { -14, -14, 0 }, Neck = { 8, 8, 0 }, LS = { 92, 0, 14 }, LE = { 66, 0, 0 }, LW = { 0, 0, 0 }, RS = { 18, 0, 42 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "sarcophage", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(210, 190, 150), at = "front", dir = "all", time = 0.2, rate = 40, speed = 5, size = 0.8 } }, hitText = "BONG !",
		},
		-- Pied plâtré : la jambe droite raide comme un piquet part devant lui avec un petit saut (« aïe aïe aïe »)
		K_side = {
			label = "Pied plâtré", startup = 0.22, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(5, 3, 3.2, -0.3), kbBase = 32, kbGrowth = 80, kbAngle = 30, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { 10, 0, 0, 0, -0.1, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { -35, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { 22, 0, 0, 0, 0, -0.35 }, Waist = { 8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 55 }, RE = { 30, 0, 0 }, LS = { -20, 0, -55 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { 25, 0, 0, 0, 0, -0.42 }, Waist = { 9, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -25, 0, 58 }, RE = { 30, 0, 0 }, LS = { -25, 0, -58 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", text = "AÏE AÏE AÏE !", hitText = "CLONK !",
		},
		-- Thermomètre balayé : accroupi, il balaie le sol avec le thermomètre tenu à l'horizontale
		K_down = {
			label = "Thermomètre balayé", startup = 0.18, active = 0.14, recovery = 0.32,
			damage = 11, hitbox = box(7, 2.2, 2.6, -2), kbBase = 30, kbGrowth = 60, kbAngle = 70,
			windup = { Root = { -8, -40, 0, 0, -0.7, 0.1 }, Waist = { -14, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 60, 0, 80 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -12, 20, 0, 0, -0.85, -0.1 }, Waist = { -18, 25, 0 }, Neck = { 0, -20, 0 }, RS = { 50, 0, -20 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			follow = { Root = { -12, 32, 0, 0, -0.85, -0.12 }, Waist = { -18, 35, 0 }, Neck = { 0, -26, 0 }, RS = { 45, 0, -40 }, RE = { 15, 0, 0 }, RW = { 70, 0, 0 }, LS = { 42, 0, -42 }, LE = { 60, 0, 0 } },
			trail = "prop", fx = { "dust" }, hitText = "FAUCHÉ !",
		},
		-- Malaise (recul) : il tourne de l'œil et tombe en arrière… les deux jambes partent vers le haut
		K_up = {
			label = "Malaise", startup = 0.16, active = 0.14, recovery = 0.36, invuln = 0.2,
			damage = 11, hitbox = box(4.5, 5, 1.6, 2.8), kbBase = 32, kbGrowth = 70, kbAngle = 80, selfVelocity = Vector2.new(-20, 0),
			windup = { Root = { -6, 0, 0, 0, -0.2, 0 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 10 }, RS = { 20, 0, 30 }, RE = { 30, 0, 0 }, LS = { 150, 0, -10 }, LE = { 120, 0, 0 } },
			strike = { Root = { 40, 0, 0, 0, -0.9, 0.4 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 60 }, RE = { 20, 0, 0 }, LS = { 120, 0, -60 }, LE = { 20, 0, 0 }, RH = { 120, 0, 5 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { 105, 0, -5 }, LK = { -20, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 44, 0, 0, 0, -0.95, 0.45 }, Waist = { 12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 125, 0, 65 }, RE = { 20, 0, 0 }, LS = { 125, 0, -65 }, LE = { 20, 0, 0 }, RH = { 125, 0, 5 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { 110, 0, -5 }, LK = { -18, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "JE ME SENS MAL…", hitText = "POUF !",
		},
		-- Sarcophage écrasé (saut K) : couvercle levé au-dessus de la tête, il l'abat devant lui
		K_air = {
			label = "Sarcophage écrasé", startup = 0.18, active = 0.14, recovery = 0.28,
			damage = 12, hitbox = box(5, 4.5, 2.6, -0.6), kbBase = 30, kbGrowth = 68, kbAngle = 30,
			windup = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, LS = { 190, 0, 0 }, LE = { 30, 0, 0 }, RS = { 150, 0, 20 }, RE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -16, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { 6, 0, 0 }, LS = { 75, 0, 5 }, LE = { 10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { -20, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 8, 0, 0 }, LS = { 60, 0, 5 }, LE = { 10, 0, 0 }, RS = { 60, 0, 22 }, RE = { 30, 0, 0 }, RH = { 15, 0, 0 }, RK = { -72, 0, 0 }, LH = { 25, 0, 0 }, LK = { -82, 0, 0 } },
			prop = "sarcophage", hitText = "BOOONG !",
		},
		-- Glissade en pantoufles (dash puis K) : penché en arrière, il glisse sur une pantoufle, plâtre en avant
		K_dash = {
			label = "Glissade en pantoufles", startup = 0.1, active = 0.26, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 62, kbAngle = 38, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { -8, 0, 0, 0, -0.45, 0 }, Waist = { -8, 0, 0 }, RS = { 40, 0, 30 }, RE = { 50, 0, 0 }, LS = { 40, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { 25, 0, 0, 0, -0.9, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { 70, 0, -70 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 28, 0, 0, 0, -0.95, 0 }, Waist = { -12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 62, 0, 75 }, RE = { 20, 0, 0 }, LS = { 72, 0, -75 }, LE = { 20, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 18, 0, 0 }, LK = { -92, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, text = "OUH LÀ LÀ !", hitText = "CLONK !",
		},

		-- Suites d'enchaînement K
		-- K K : couvercle retourné, il ramène le couvercle dans l'autre sens
		K_combo2 = {
			label = "Couvercle retourné", startup = 0.1, active = 0.12, recovery = 0.28,
			damage = 9, hitbox = box(5, 4, 2.6, 0.6), kbBase = 28, kbGrowth = 50, kbAngle = 35,
			windup = { Root = { -6, -26, 0, 0, -0.3, -0.1 }, Waist = { -8, -28, 0 }, Neck = { 0, 20, 0 }, LS = { 80, 0, 40 }, LE = { 60, 0, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 } },
			strike = { Root = { -10, 20, 0, 0, -0.35, -0.3 }, Waist = { -10, 22, 0 }, Neck = { 0, -14, 0 }, LS = { 88, 0, -45 }, LE = { 10, 0, 0 }, RS = { 25, 0, 35 }, RE = { 70, 0, 0 } },
			follow = { Root = { -10, 26, 0, 0, -0.35, -0.32 }, Waist = { -10, 28, 0 }, Neck = { 0, -18, 0 }, LS = { 84, 0, -65 }, LE = { 12, 0, 0 }, RS = { 25, 0, 35 }, RE = { 70, 0, 0 } },
			prop = "sarcophage", hitText = "BANG !",
		},
		-- K K K : Sarcophage claqué, il soulève le couvercle à deux mains et le rabat de tout son poids
		K_combo3 = {
			label = "Sarcophage claqué", startup = 0.12, active = 0.12, recovery = 0.36,
			damage = 13, hitbox = box(5, 4.5, 2.8, 0.3), kbBase = 34, kbGrowth = 84, kbAngle = 40,
			windup = { Root = { 10, 0, 0, 0, 0, 0.25 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, LS = { 190, 0, 5 }, LE = { 30, 0, 0 }, RS = { 185, 0, -5 }, RE = { 30, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.5, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -6, 0, 0 }, LS = { 70, 0, 5 }, LE = { 5, 0, 0 }, RS = { 65, 0, -5 }, RE = { 10, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.55, -0.45 }, Waist = { -34, 0, 0 }, Neck = { -8, 0, 0 }, LS = { 55, 0, 5 }, LE = { 5, 0, 0 }, RS = { 50, 0, -5 }, RE = { 10, 0, 0 } },
			prop = "sarcophage", fx = { { "ring", color = GOLD, radius = 4, at = "front" }, { "shake", amount = 0.35 } }, text = "REPOS !", hitText = "BOOOONG !",
		},
		-- K puis P : coup de coude grincheux, il pivote en ronchonnant et plante le coude droit
		KP_combo = {
			label = "Coude grincheux", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 8, hitbox = box(4.5, 3.5, 2.5, 0.6), kbBase = 24, kbGrowth = 38, kbAngle = 30,
			windup = { Root = { -4, -25, 0, 0, -0.2, 0.15 }, Waist = { -6, -28, 0 }, RS = { 40, 0, 60 }, RE = { 140, 0, 0 }, LS = { 35, 0, 15 }, LE = { 80, 0, 0 } },
			strike = { Root = { -12, 20, 0, 0, -0.3, -0.35 }, Waist = { -14, 26, 0 }, Neck = { 0, -10, 0 }, RS = { 88, 0, -12 }, RE = { 145, 0, 0 }, LS = { 35, 0, 15 }, LE = { 80, 0, 0 } },
			follow = { Root = { -13, 25, 0, 0, -0.32, -0.4 }, Waist = { -15, 30, 0 }, Neck = { 0, -12, 0 }, RS = { 90, 0, -18 }, RE = { 145, 0, 0 }, LS = { 35, 0, 15 }, LE = { 80, 0, 0 } },
			hitText = "GRMBL !",
		},
		-- → K K : Pied plâtré bis, petit sautillement et la jambe raide repart, il grimace encore plus
		K_side2 = {
			label = "Pied plâtré bis", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(5, 3.5, 3, 0), kbBase = 24, kbGrowth = 38, kbAngle = 30, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 8, 0, 0, 0, -0.1, 0.15 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 8 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { -25, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, 0.05, -0.3 }, Waist = { 8, 0, 0 }, Neck = { -8, 0, -8 }, RS = { -20, 0, 55 }, RE = { 30, 0, 0 }, LS = { -20, 0, -55 }, LE = { 30, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { 22, 0, 0, 0, 0.05, -0.36 }, Waist = { 9, 0, 0 }, Neck = { -10, 0, -8 }, RS = { -25, 0, 58 }, RE = { 30, 0, 0 }, LS = { -25, 0, -58 }, LE = { 30, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", text = "AÏE !", hitText = "CLONK CLONK !",
		},
		-- → K K K : Plâtre qui casse, un coup de pied si fort que le plâtre vole en éclats… « AÏE MON PIED ! »
		K_side3 = {
			label = "Plâtre qui casse", startup = 0.1, active = 0.12, recovery = 0.36,
			damage = 13, hitbox = box(5.5, 4, 3.2, 0.2), kbBase = 36, kbGrowth = 86, kbAngle = 35, selfVelocity = Vector2.new(24, 0),
			windup = { Root = { 12, 0, 0, 0, -0.15, 0.25 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 50 }, RE = { 40, 0, 0 }, LS = { 50, 0, -50 }, LE = { 40, 0, 0 }, RH = { -40, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { 26, 0, 0, 0, 0.05, -0.4 }, Waist = { 10, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -30, 0, 60 }, RE = { 30, 0, 0 }, LS = { -30, 0, -60 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.3, -0.2 }, Waist = { 16, 0, 0 }, Neck = { 30, 0, 12 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 }, RH = { 60, 0, 10 }, RK = { -90, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", fx = { { "burst", color = TISSUE, size = 3.5, at = "front" }, { "symbols", symbols = { "🦴", "💥" }, color = TISSUE, count = 4, radius = 3, at = "front" }, { "toss", shape = "flat", color = TISSUE, size = 0.5, count = 5, speed = 16 }, { "shake", amount = 0.4 } },
			text = "AÏE MON PIED !", hitText = "CRAAAC !",
		},
		-- ↓ K K : Luge de sarcophage, accroupi sur le couvercle il glisse en avant comme sur une luge, couvercle en étrave
		K_downK = {
			label = "Luge de sarcophage", startup = 0.08, active = 0.22, recovery = 0.26,
			damage = 8, hitbox = box(6, 3.5, 3, -1), kbBase = 24, kbGrowth = 40, kbAngle = 45, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -6, 0, 0, 0, -0.8, 0 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, LS = { 120, 0, -30 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, -1.1, -0.2 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, LS = { 92, 0, -20 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 60 }, RE = { 30, 0, 0 }, RH = { 85, 0, 8 }, RK = { -15, 0, 0 }, RA = { 10, 0, 0 }, LH = { 85, 0, -8 }, LK = { -15, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -1.1, -0.25 }, Waist = { -18, 0, 0 }, Neck = { -8, 0, 0 }, LS = { 94, 0, -22 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, RS = { 18, 0, 62 }, RE = { 30, 0, 0 }, RH = { 88, 0, 8 }, RK = { -12, 0, 0 }, RA = { 10, 0, 0 }, LH = { 88, 0, -8 }, LK = { -12, 0, 0 }, LA = { 10, 0, 0 } },
			prop = "sarcophage", trail = "leftHand", fx = { "dust", { "particles", tex = "smoke", color = Color3.fromRGB(210, 190, 150), at = "feet", dir = "all", time = 0.2, rate = 40, speed = 5, size = 0.8 } }, text = "ET QUE ÇA GLISSE !", hitText = "BONG !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : Coup de pied plâtré, la jambe raide part à l'horizontale, il se tient le dos
		P_air_side = {
			label = "Coup de pied plâtré", startup = 0.11, active = 0.12, recovery = 0.2,
			damage = 8, hitbox = box(5, 3, 3.2, -0.3), kbBase = 24, kbGrowth = 38, kbAngle = 28,
			windup = { Root = { -10, 15, 0 }, Waist = { -10, 10, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { -20, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 0 }, RK = { 0, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 22, 20, 0 }, Waist = { 6, 6, 0 }, Neck = { -10, 0, 0 }, RS = { -10, 0, 60 }, RE = { 30, 0, 0 }, LS = { -30, 0, -25 }, LE = { 100, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 20, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 25, 22, 0 }, Waist = { 7, 6, 0 }, Neck = { -12, 0, 0 }, RS = { -14, 0, 62 }, RE = { 30, 0, 0 }, LS = { -32, 0, -26 }, LE = { 100, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 18, 0, 0 }, LK = { -100, 0, 0 } },
			trail = "rightFoot", text = "MON DOS !", hitText = "CLONK !",
		},
		-- ↑ P en l'air : Thermomètre au plafond, il pique le thermomètre droit vers le haut
		P_air_up = {
			label = "Thermomètre au plafond", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(4, 5, 0.6, 3.6), kbBase = 26, kbGrowth = 42, kbAngle = 86,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 15 }, LE = { 80, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 178, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 }, RH = { 0, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 184, 0, 2 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 28, 0, -32 }, LE = { 60, 0, 0 }, RH = { -4, 0, 0 }, RK = { -26, 0, 0 }, LH = { 18, 0, 0 }, LK = { -56, 0, 0 } },
			trail = "prop", hitText = "PIC !",
		},
		-- ↓ P en l'air : Bandelette plongeante, la bandelette claque droit vers le sol (smash)
		P_air_down = {
			label = "Bandelette plongeante", startup = 0.14, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(4, 4.5, 0.8, -2.4), kbBase = 24, kbGrowth = 52, kbAngle = -76,
			windup = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, LS = { 190, 0, 5 }, LE = { 20, 0, 0 }, RS = { 60, 0, 40 }, RE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -16, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 10, 0, 0 }, LS = { 30, 0, 5 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, RS = { 50, 0, 40 }, RE = { 50, 0, 0 }, RH = { 15, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -20, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 12, 0, 0 }, LS = { 15, 0, 5 }, LE = { 0, 0, 0 }, LW = { -35, 0, 0 }, RS = { 48, 0, 42 }, RE = { 50, 0, 0 }, RH = { 10, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			prop = "bandelette", trail = "leftHand", hitText = "SCHLAK !",
		},
		-- → K en l'air : Genou rhumatisant, genou en avant… et la main sur le genou douloureux
		K_air_side = {
			label = "Genou rhumatisant", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(4.5, 3, 2.4, 0), kbBase = 30, kbGrowth = 68, kbAngle = 35,
			windup = { Root = { -10, 0, 0 }, Waist = { -12, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -40, 0, 0 } },
			strike = { Root = { -16, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 15 }, RE = { 60, 0, 0 }, LS = { -30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 115, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 }, LH = { -10, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -18, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 72, 0, 12 }, RE = { 62, 0, 0 }, LS = { -32, 0, -52 }, LE = { 30, 0, 0 }, RH = { 120, 0, 0 }, RK = { -128, 0, 0 }, RA = { -20, 0, 0 }, LH = { -12, 0, 0 }, LK = { -62, 0, 0 } },
			trail = "rightLeg", text = "MON GENOU !", hitText = "CRAC !",
		},
		-- ↑ K en l'air : Coup de tête fiévreux, tête renversée en arrière, le thermomètre de la bouche pointe vers le haut
		K_air_up = {
			label = "Coup de tête fiévreux", startup = 0.14, active = 0.14, recovery = 0.26,
			damage = 10, hitbox = box(4, 4.5, 0.5, 3.6), kbBase = 30, kbGrowth = 64, kbAngle = 86,
			windup = { Root = { -14, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 20, 0, 30 }, RE = { 80, 0, 0 }, LS = { 20, 0, -30 }, LE = { 80, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 90, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 45, 0, 0 }, RS = { -40, 0, 40 }, RE = { 10, 0, 0 }, LS = { -40, 0, -40 }, LE = { 10, 0, 0 }, RH = { -10, 0, 5 }, RK = { -30, 0, 0 }, LH = { -10, 0, -5 }, LK = { -30, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { -45, 0, 42 }, RE = { 10, 0, 0 }, LS = { -45, 0, -42 }, LE = { 10, 0, 0 }, RH = { -12, 0, 5 }, RK = { -28, 0, 0 }, LH = { -12, 0, -5 }, LK = { -28, 0, 0 } },
			trail = "head", fx = { { "particles", tex = "fire", color = FEVER, at = "head", dir = "up", time = 0.2, rate = 40, speed = 6, size = 0.5 } }, hitText = "BOUILLANT !",
		},
		-- ↓ K en l'air : Talon plâtré, il tombe jambe plâtrée tendue vers le sol (smash)
		K_air_down = {
			label = "Talon plâtré", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -8, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { 110, 0, 0 }, RK = { 0, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 140, 0, 40 }, RE = { 10, 0, 0 }, LS = { 140, 0, -40 }, LE = { 10, 0, 0 }, RH = { -4, 0, 2 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 45 }, RE = { 10, 0, 0 }, LS = { 150, 0, -45 }, LE = { 10, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { 38, 0, 0 }, LK = { -92, 0, 0 } },
			trail = "rightFoot", text = "ATTENTION AU PLÂTRE !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Éternuement : grande inspiration en se cambrant, puis l'éternuement part en boule de microbes droit dans la figure de l'adversaire (contagion garantie)
		S_neutral = {
			label = "Éternuement", kind = "projectile", startup = 0.24, active = 0, recovery = 0.45,
			damage = 12, kbBase = 16, kbGrowth = 20, kbAngle = 30,
			projectile = { speed = 46, angle = 0, gravity = 0, lifetime = 0.6, size = 3.5, color = GERM,
				visual = { shape = "ball", size = 3.2, color = GERM, transparency = 0.5, spin = 3, parts = {
					{ "ball", Vector3.new(1.6, 1.6, 1.6), Vector3.new(1.2, 0.8, 0), GERM },
					{ "ball", Vector3.new(1.4, 1.4, 1.4), Vector3.new(-1.1, -0.6, 0), GERM },
				} } },
			status = { name = "sneezy", duration = 3 },
			windup = { Root = { 12, 0, 0, 0, -0.05, 0.25 }, Waist = { 20, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 30, 0, 40 }, RE = { 50, 0, 0 }, LS = { 70, 0, -10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.3, -0.3 }, Waist = { -24, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 10, 0, 45 }, RE = { 40, 0, 0 }, LS = { 20, 0, -40 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -20, 0, 0, 0, -0.32, -0.35 }, Waist = { -26, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 8, 0, 46 }, RE = { 40, 0, 0 }, LS = { 18, 0, -42 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.1, shake = true, fx = { { "particles", tex = "smoke", color = GERM, at = "head", dir = "front", time = 0.3, rate = 100, speed = 14, size = 1 }, { "burst", color = GERM, size = 2.5, at = "head" } },
			text = "AAAH… AAAAH… ATCHOUM !", hitText = "CONTAGIÉ !",
		},
		-- Grappin bandelette : il lance son bras gauche à travers tout le couloir, la bandelette s'accroche et ramène l'adversaire contre lui
		S_side = {
			label = "Grappin bandelette", kind = "grapple", startup = 0.18, active = 0.12, recovery = 0.42,
			damage = 12, kbBase = 22, kbGrowth = 20, kbAngle = 15,
			grapple = { range = 30, angle = 0, speed = 85, pullEnemy = true },
			windup = { Root = { 0, 25, 0, 0, -0.2, 0.2 }, Waist = { -4, 22, 0 }, Neck = { 0, -15, 0 }, LS = { 90, 0, -80 }, LE = { 100, 0, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 } },
			strike = { Root = { -12, -14, 0, 0, -0.25, -0.35 }, Waist = { -12, -18, 0 }, Neck = { 0, 10, 0 }, LS = { 94, 0, 4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 35 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { 6, 6, 0, 0, -0.2, 0.2 }, Waist = { 8, 6, 0 }, Neck = { 6, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 35 }, RE = { 70, 0, 0 } },
			prop = "bandelette", trail = "leftHand", fx = { { "beam", color = BANDAGE, length = 16, width = 0.4, at = "lhand" } }, text = "VIENS PAR ICI !", hitText = "ENROULÉ !",
		},
		-- Traînée de mouchoirs : il secoue sa manche et une traînée de mouchoirs sales tapisse tout le couloir ; qui reste dessus attrape le rhume
		S_down = {
			label = "Traînée de mouchoirs", kind = "trap", startup = 0.2, active = 0.12, recovery = 0.45,
			damage = 12, kbBase = 16, kbGrowth = 14, kbAngle = 40,
			status = { name = "sneezy", duration = 3 },
			trap = { size = Vector3.new(16, 2, 6), offset = 8, lifetime = 8, max = 1, color = TISSUE,
				visual = { shape = "ball", size = 1.0, color = TISSUE, trail = false, parts = {
					{ "ball", Vector3.new(0.9, 0.7, 0.9), Vector3.new(-6, 0.1, 0), TISSUE },
					{ "ball", Vector3.new(0.8, 0.7, 0.8), Vector3.new(-3, 0.1, 0.3), TISSUE },
					{ "ball", Vector3.new(0.9, 0.7, 0.9), Vector3.new(3, 0.1, -0.3), TISSUE },
					{ "ball", Vector3.new(0.8, 0.7, 0.8), Vector3.new(6, 0.1, 0), TISSUE },
					{ "ball", Vector3.new(0.4, 0.4, 0.2), Vector3.new(-4.5, 0.4, -0.4), GERM, "Neon" },
					{ "ball", Vector3.new(0.4, 0.4, 0.2), Vector3.new(1.5, 0.4, -0.4), GERM, "Neon" },
					{ "ball", Vector3.new(0.4, 0.4, 0.2), Vector3.new(5, 0.4, -0.4), GERM, "Neon" },
				} } },
			windup = { Root = { -6, 0, 0, 0, -0.2, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, LS = { 120, 0, -10 }, LE = { 120, 0, 0 }, RS = { 30, 0, 30 }, RE = { 70, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.2 }, Waist = { -26, 0, 0 }, Neck = { -10, 0, 0 }, LS = { 70, 0, 10 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, RS = { 25, 0, 35 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -14, 0, 0, 0, -0.5, -0.2 }, Waist = { -24, 0, 0 }, Neck = { -12, 0, 0 }, LS = { 40, 0, 40 }, LE = { 10, 0, 0 }, LW = { -40, 0, 0 }, RS = { 25, 0, 35 }, RE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			prop = "mouchoir", trail = "leftHand", shake = true,
			fx = { { "toss", shape = "ball", color = TISSUE, size = 0.7, count = 6, speed = 22, lift = 8 }, { "particles", tex = "smoke", color = GERM, at = "front", dir = "up", time = 0.3, rate = 30, speed = 3, size = 0.6 } },
			text = "OUPS, MES MOUCHOIRS…", hitText = "ATCHOUM !",
		},
		-- Sortie de sarcophage (remontée) : le couvercle doré jaillit sous ses pantoufles et il file en diagonale, thermomètre pointé vers le ciel, bandelettes au vent
		S_up = {
			label = "Sortie de sarcophage", startup = 0.15, active = 0.3, recovery = 0.42,
			damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 44, kbAngle = 76, selfVelocity = Vector2.new(44, 84),
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 70, 0, -45 }, RE = { 120, 0, 0 }, LS = { 70, 0, 45 }, LE = { 120, 0, 0 } },
			strike = { Root = { -42, 0, 0, 0, 0.3, -0.1 }, Waist = { -4, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 166, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -22 }, LE = { 20, 0, 0 }, RH = { -24, 0, 4 }, RK = { -30, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -4 }, LK = { -40, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -46, 0, 0, 0, 0.35, -0.15 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 172, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -44, 0, -26 }, LE = { 20, 0, 0 }, RH = { -28, 0, 4 }, RK = { -36, 0, 0 }, RA = { -30, 0, 0 }, LH = { -34, 0, -4 }, LK = { -46, 0, 0 }, LA = { -30, 0, 0 } },
			prop = "sarcophage", trail = "body",
			fx = { { "pillar", color = GOLD, height = 8, width = 3, at = "root", time = 0.4 }, { "burst", color = GOLD, size = 3.5, at = "feet" }, { "ring", color = GOLD, radius = 5, at = "feet" },
				{ "particles", tex = "smoke", color = Color3.fromRGB(210, 190, 150), at = "feet", dir = "down", time = 0.35, rate = 60, speed = 10, size = 1 }, { "symbols", symbols = { "𓂀", "✨" }, color = GOLD, count = 4, radius = 3, at = "above" } },
			text = "JE SORS !", hitText = "BONG !",
		},
		-- Arrêt maladie (esquive puis L) : « je me sens mal… », il titube et s'effondre de tout son long sur tout le couloir, puis reste au sol, invulnérable un instant
		S_dodge = {
			label = "Arrêt maladie", startup = 0.15, active = 0.6, recovery = 0.42, invuln = 0.8,
			damage = 13, hitbox = box(14, 5, 7, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			selfEffect = { heal = 2 },
			windup = { Root = { -16, 0, 0, 0, -0.3, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 12 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { -84, 0, 0, 0, -1.7, -0.8 }, Waist = { 0, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 20 }, RE = { 0, 0, 0 }, LS = { 165, 0, -20 }, LE = { 0, 0, 0 }, RH = { 0, 0, 4 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 0, 0, -4 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { -86, 0, 0, 0, -1.75, -0.85 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -40 }, RE = { 120, 0, 0 }, LS = { 60, 0, 40 }, LE = { 120, 0, 0 }, RH = { 0, 0, 4 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 0, 0, -4 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			hold = 0.4, trail = "body", fx = { "dust", { "shake", amount = 0.3 }, { "text", text = "ARRÊT MALADIE", color = Color3.fromRGB(255, 255, 255), at = "above" }, { "symbols", symbols = { "📄", "🤒" }, color = TISSUE, count = 3, radius = 2 } },
			text = "JE SUIS EN ARRÊT !", hitText = "ÉCRASÉ !",
		},
		-- Fièvre (L maintenu) : il tremble de tout son corps, la fièvre monte… et trois bouffées de chaleur brûlante balaient tout le couloir
		S_hold = {
			label = "Fièvre", startup = 0.3, active = 0.3, recovery = 0.5, hits = 3,
			damage = 5, hitbox = box(14, 6, 7, 1), kbBase = 26, kbGrowth = 50, kbAngle = 40, burn = true, burnTime = 2,
			windup = { Root = { -10, 0, 0, 0, -0.45, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, -20 }, RE = { 120, 0, 0 }, LS = { 40, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.15, -0.3 }, Waist = { -6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 92, 0, 30 }, RE = { 0, 0, 0 }, LS = { 92, 0, -30 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -10, 0, 0, 0, -0.15, -0.35 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 96, 0, 34 }, RE = { 0, 0, 0 }, LS = { 96, 0, -34 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.1, shake = true, wobble = true, windupFx = { { "text", text = "40° DE FIÈVRE !", color = FEVER }, { "particles", tex = "fire", color = FEVER, at = "root", dir = "up", time = 0.3, rate = 50, speed = 6, size = 0.7 } },
			fx = { { "ring", color = FEVER, radius = 6, at = "front" }, { "beam", color = FEVER, length = 14, width = 3, at = "root" }, { "particles", tex = "fire", color = FEVER, at = "front", dir = "front", time = 0.3, rate = 100, speed = 16, size = 0.9 } },
			text = "J'AI CHAUD !", hitText = "BRÛLANT !",
		},
		-- Course en brancard (→→L) : allongé raide, bras croisés, il traverse tout le couloir les pieds devant comme sur un brancard lancé à toute allure
		S_dash = {
			label = "Course en brancard", startup = 0.15, active = 0.32, recovery = 0.45,
			damage = 14, hitbox = box(14, 5, 7, 0.5), kbBase = 30, kbGrowth = 60, kbAngle = 38, selfVelocity = Vector2.new(62, 0), invuln = 0.15,
			windup = { Root = { 20, 0, 0, 0, -0.6, 0 }, Waist = { 0, 0, 0 }, RS = { 60, 0, -40 }, RE = { 110, 0, 0 }, LS = { 60, 0, 40 }, LE = { 110, 0, 0 } },
			strike = { Root = { 75, 0, 0, 0, -1.6, 0 }, Waist = { 0, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, -45 }, RE = { 120, 0, 0 }, LS = { 60, 0, 45 }, LE = { 120, 0, 0 }, RH = { 10, 0, 2 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, -2 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 76, 0, 0, 0, -1.6, 0 }, Waist = { 0, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 60, 0, -45 }, RE = { 120, 0, 0 }, LS = { 60, 0, 45 }, LE = { 120, 0, 0 }, RH = { 10, 0, 2 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, -2 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "body", fx = { "dust", { "symbols", symbols = { "🚑", "+" }, color = Color3.fromRGB(230, 50, 50), count = 3, radius = 2 } }, text = "PLACE, URGENCE !", hitText = "PIN-PON !",
		},
		-- Pilule effervescente (L en l'air) : il lance un comprimé géant qui file droit dans la bouche de l'adversaire et pétille (enrhume)
		S_air = {
			label = "Pilule effervescente", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
			damage = 13, kbBase = 22, kbGrowth = 36, kbAngle = 35,
			projectile = { speed = 60, angle = -20, gravity = 30, lifetime = 0.8, size = 1.8, color = TISSUE,
				visual = { shape = "block", size = 1.4, color = TISSUE, spin = 10, parts = { { "block", Vector3.new(0.75, 0.75, 0.9), Vector3.new(0.4, 0, 0), SYRUP } } } },
			status = { name = "sneezy", duration = 2 },
			windup = { Root = { 8, 15, 0 }, Waist = { 10, 15, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 160, 0, -30 }, LE = { 70, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -14, -8, 0 }, Waist = { -16, -10, 0 }, RS = { 40, 0, 45 }, RE = { 50, 0, 0 }, LS = { 70, 0, 10 }, LE = { 5, 0, 0 }, LW = { -30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -16, -10, 0 }, Waist = { -18, -12, 0 }, RS = { 38, 0, 46 }, RE = { 50, 0, 0 }, LS = { 60, 0, 14 }, LE = { 10, 0, 0 }, LW = { -35, 0, 0 }, RH = { 28, 0, 0 }, RK = { -56, 0, 0 }, LH = { 52, 0, 0 }, LK = { -92, 0, 0 } },
			trail = "leftHand", fx = { { "symbols", symbols = { "💊", "✨" }, color = TISSUE, count = 3, radius = 2, at = "lhand" } },
			text = "PRENEZ VOTRE CACHET !", hitText = "PSCHIIT !",
		},
		-- Sirop gluant (↓L en l'air) : il tombe lourdement en brisant une fiole de sirop qui englue tout ce qui est en dessous
		S_air_down = {
			label = "Sirop gluant", startup = 0.16, active = 0.35, recovery = 0.45,
			damage = 14, hitbox = box(8, 5, 0, -2), kbBase = 26, kbGrowth = 52, kbAngle = -55, selfVelocity = Vector2.new(0, -85),
			status = { name = "slowed", duration = 2.5 },
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, LS = { 185, 0, -10 }, LE = { 30, 0, 0 }, RS = { 60, 0, 40 }, RE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, LS = { 20, 0, -10 }, LE = { 10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 20, 0, 0 }, RH = { 0, 0, 6 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { 0, 0, -6 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { -6, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -18, 0, 0 }, LS = { 15, 0, -12 }, LE = { 10, 0, 0 }, RS = { 125, 0, 55 }, RE = { 20, 0, 0 }, RH = { 0, 0, 8 }, RK = { -4, 0, 0 }, RA = { -10, 0, 0 }, LH = { 0, 0, -8 }, LK = { -4, 0, 0 }, LA = { -10, 0, 0 } },
			prop = "fiole", trail = "body", fx = { { "puddle", color = SYRUP, width = 10, time = 2 }, { "burst", color = SYRUP, size = 3, at = "feet" }, { "shake", amount = 0.4 } },
			text = "SIROP !", hitText = "GLUANT !",
		},

		------------------------------------------------------------------ Finition avec S (dans un enchaînement)
		-- Quinte de toux : plié en deux, il tousse trois fois en direction de l'adversaire, chaque quinte traverse le couloir (enrhume)
		S_finish_cough = {
			label = "Quinte de toux", startup = 0.15, active = 0.3, recovery = 0.4, hits = 3,
			damage = 4, hitbox = box(14, 5, 7, 1), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			status = { name = "sneezy", duration = 2.5 },
			windup = { Root = { 6, 0, 0, 0, -0.15, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 25, 0, 30 }, RE = { 70, 0, 0 }, LS = { 90, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.35, -0.2 }, Waist = { -26, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 35 }, RE = { 70, 0, 0 }, LS = { 40, 0, 10 }, LE = { 110, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.38, -0.22 }, Waist = { -28, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 18, 0, 36 }, RE = { 70, 0, 0 }, LS = { 38, 0, 10 }, LE = { 112, 0, 0 } },
			shake = true, fx = { { "particles", tex = "smoke", color = GERM, at = "head", dir = "front", time = 0.3, rate = 60, speed = 14, size = 0.7 } },
			text = "KOF KOF KOF !", hitText = "BEURK !",
		},

		------------------------------------------------------------------ Supers
		-- Le Grand Rhume : il gonfle, gonfle… et lâche un éternuement si énorme qu'un monstre-microbe en sort et fonce dévorer l'adversaire
		SUPER = {
			label = "Le Grand Rhume !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 22, kbBase = 30, kbGrowth = 55, kbAngle = 35,
			projectile = { speed = 34, angle = 0, gravity = 0, lifetime = 0.8, size = 7, color = GERM, visual = GERM_MONSTER },
			status = { name = "sneezy", duration = 3 },
			windup = { Root = { 14, 0, 0, 0, 0, 0.3 }, Waist = { 24, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 } },
			strike = { Root = { -24, 0, 0, 0, -0.4, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 0, 0, 50 }, RE = { 30, 0, 0 }, LS = { 0, 0, -50 }, LE = { 30, 0, 0 } },
			follow = { Root = { -26, 0, 0, 0, -0.42, -0.35 }, Waist = { -32, 0, 0 }, Neck = { -22, 0, 0 }, RS = { -5, 0, 52 }, RE = { 30, 0, 0 }, LS = { -5, 0, -52 }, LE = { 30, 0, 0 } },
			hold = 0.2, shake = true, windupFx = { "super" },
			fx = { { "screen", color = GERM, alpha = 0.3, time = 0.5 }, { "shake", amount = 0.6 }, { "particles", tex = "smoke", color = GERM, at = "head", dir = "front", time = 0.5, rate = 150, speed = 20, size = 1.5 } },
			text = "AAAAAH… AAAAAAH… ATCHOUUUM !", hitText = "DÉVORÉ !",
		},
		-- Super ↑ : Tornade de bandelettes, il attrape le bout qui pend, tire… et se déroule en toupie, bras écartés, en montant vers le ciel ; les bandelettes fauchent tout le couloir
		SUPER_up = {
			label = "Tornade de bandelettes !", startup = 0.4, active = 0.3, recovery = 0.7,
			damage = 24, hitbox = box(14, 14, 7, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -24, 0, 0 }, Neck = { 14, 0, 0 }, LS = { 50, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RS = { 50, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.5, 0 }, Waist = { 6, 0, 0 }, Neck = { 30, 0, 0 }, LS = { 100, 0, -90 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 100, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.55, 0 }, Waist = { 8, 0, 0 }, Neck = { 36, 0, 0 }, LS = { 110, 0, -92 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 110, 0, 92 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			hold = 0.3, shake = true, spin = { axis = "y", degrees = 1080 }, selfVelocity = Vector2.new(0, 45), prop = "bandelette", trail = "leftHand",
			windupFx = { "super" }, status = { name = "sneezy", duration = 3 },
			fx = { { "pillar", color = BANDAGE, height = 22, width = 5, at = "front" }, { "swarm", shape = "ball", color = BANDAGE, count = 6, distance = 16, size = 0.8 }, { "symbols", symbols = { "🤧", "🦠", "🌀" }, count = 6, radius = 5, at = "above" }, { "shake", amount = 0.4 } },
			text = "DÉROULEZ-MOI !", hitText = "EMMAILLOTÉ !",
		},
		-- Malédiction du pharaon : bras levés vers le ciel, une nuée de scarabées cartoon s'abat sur l'adversaire, où qu'il soit
		SUPER_down = {
			label = "Malédiction du pharaon !", kind = "projectile", startup = 0.45, active = 0, recovery = 0.7,
			damage = 5, kbBase = 22, kbGrowth = 35, kbAngle = 50,
			projectile = { speed = 60, gravity = 0, lifetime = 0.8, size = 2, color = Color3.fromRGB(40, 120, 110),
				rain = { count = 8, spread = 6, ahead = 9, height = 20 },
				visual = { shape = "ball", size = 1.2, color = Color3.fromRGB(40, 120, 110), spin = 15, parts = {
					{ "block", Vector3.new(1.4, 0.2, 0.6), Vector3.new(0, 0.3, 0), GOLD },
					{ "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, 0.7, 0), Color3.fromRGB(30, 80, 70) },
				} } },
			windup = { Root = { 6, 0, 0, 0, -0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 60, 0, -45 }, RE = { 120, 0, 0 }, LS = { 60, 0, 45 }, LE = { 120, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.1, 0 }, Waist = { 16, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 170, 0, 35 }, RE = { 10, 0, 0 }, LS = { 170, 0, -35 }, LE = { 10, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.12, 0 }, Waist = { 18, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 175, 0, 40 }, RE = { 10, 0, 0 }, LS = { 175, 0, -40 }, LE = { 10, 0, 0 } },
			hold = 0.4, shake = true, windupFx = { "super" },
			fx = { { "screen", color = GOLD, alpha = 0.25, time = 0.5 }, { "swarm", shape = "ball", color = Color3.fromRGB(40, 120, 110), count = 8, distance = 14, size = 0.8 }, { "symbols", symbols = { "𓂀", "🪲" }, color = GOLD, count = 6, radius = 4, at = "above" } },
			text = "MALÉDICTION !", hitText = "SCRITCH SCRITCH !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Momification : il lance les deux bras en avant et ses bandelettes s'enroulent autour de l'adversaire
		GRAB = {
			label = "Prise momifiée", kind = "grab", startup = 0.11, active = 0.12, recovery = 0.36,
			damage = 0, hitbox = box(4.5, 4, 2.2, 0.5),
			windup = { Root = { 4, 0, 0, 0, -0.15, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 100, 0, 50 }, RE = { 10, 0, 0 }, LS = { 100, 0, -50 }, LE = { 10, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.25, -0.3 }, Waist = { -10, 0, 0 }, RS = { 90, 0, 0 }, RE = { 0, 0, 0 }, LS = { 90, 0, 0 }, LE = { 0, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -0.22, -0.25 }, Waist = { -8, 0, 0 }, RS = { 86, 0, -15 }, RE = { 40, 0, 0 }, LS = { 86, 0, 15 }, LE = { 40, 0, 0 } },
			prop = "bandelette", text = "BOUGEZ PAS…", hitText = "MOMIFIÉ !",
		},
		-- ✋ puis → : Toupie de bandelettes, il tire d'un coup sec sur la bandelette : l'adversaire tourne et part
		THROW_fwd = {
			label = "Toupie de bandelettes", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 15,
			carry = { { 0, 2.4, 0.4 }, { 0.12, 2.6, 0.4 }, { 0.22, 3.4, 0.3 }, { 0.32, 4.6, 0.2 } },
			windup = { Root = { -6, 10, 0, 0, -0.3, 0.1 }, Waist = { -6, 10, 0 }, LS = { 90, 0, 0 }, LE = { 20, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 } },
			strike = { Root = { 12, -40, 0, 0, -0.4, 0.4 }, Waist = { 10, -30, 0 }, Neck = { 0, 25, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, RS = { 30, 0, 40 }, RE = { 70, 0, 0 } },
			follow = { Root = { 14, -45, 0, 0, -0.42, 0.45 }, Waist = { 12, -34, 0 }, Neck = { 0, 28, 0 }, LS = { 20, 0, -70 }, LE = { 30, 0, 0 }, RS = { 28, 0, 42 }, RE = { 70, 0, 0 } },
			prop = "bandelette", text = "ET QUE ÇA TOURNE !", hitText = "ZIOUUU !",
		},
		-- ✋ puis ← : Sarcophage, il retourne l'adversaire dans un sarcophage derrière lui, qui se referme et l'éjecte
		THROW_back = {
			label = "Sarcophage", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.38,
			damage = 11, kbBase = 36, kbGrowth = 66, kbAngle = 42,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.0, 0.8 }, { 0.28, -1.4, 1.0 }, { 0.4, -2.8, 0 } },
			windup = { Root = { -4, 0, 0, 0, -0.3, 0.1 }, Waist = { -6, 0, 0 }, RS = { 80, 0, -10 }, RE = { 60, 0, 0 }, LS = { 80, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 120, 0, 0, -0.35, 0 }, Waist = { 6, 30, 0 }, Neck = { 0, 20, 0 }, RS = { 90, 0, 20 }, RE = { 20, 0, 0 }, LS = { 120, 0, -20 }, LE = { 40, 0, 0 } },
			follow = { Root = { 8, 130, 0, 0, -0.35, 0 }, Waist = { 8, 34, 0 }, Neck = { 0, 22, 0 }, RS = { 92, 0, 22 }, RE = { 20, 0, 0 }, LS = { 125, 0, -22 }, LE = { 40, 0, 0 } },
			prop = "sarcophage", fx = { { "burst", color = GOLD, size = 3, at = "root" } }, text = "AU LIT !", hitText = "BOOONG !",
		},
		-- ✋ puis ↑ : Éternuement, il tient l'adversaire au-dessus de lui… et un « ATCHOUM » le propulse au ciel
		THROW_up = {
			label = "Atchoum propulseur", kind = "throw", startup = 0.36, active = 0.08, recovery = 0.35,
			damage = 10, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			status = { name = "sneezy", duration = 3 },
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.0, 2.6 }, { 0.36, 0.6, 3.2 } },
			windup = { Root = { 12, 0, 0, 0, -0.1, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 160, 0, 20 }, RE = { 30, 0, 0 }, LS = { 160, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 175, 0, 30 }, RE = { 10, 0, 0 }, LS = { 175, 0, -30 }, LE = { 10, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -0.32, 0 }, Waist = { -12, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 178, 0, 34 }, RE = { 10, 0, 0 }, LS = { 178, 0, -34 }, LE = { 10, 0, 0 } },
			shake = true, fx = { { "particles", tex = "smoke", color = GERM, at = "above", dir = "up", time = 0.3, rate = 100, speed = 16, size = 1 } },
			text = "AAAH… ATCHOUM !", hitText = "DÉCOLLAGE !",
		},
		-- ✋ puis ↓ : Pansement géant, il plaque l'adversaire au sol et lui colle un énorme pansement dessus
		THROW_down = {
			label = "Pansement géant", kind = "throw", startup = 0.4, active = 0.1, hold = 0.2, recovery = 0.36,
			damage = 9, kbBase = 26, kbGrowth = 20, kbAngle = 70,
			status = { name = "rooted", duration = 1.5 },
			carry = { { 0, 2.2, 0.3 }, { 0.16, 2.2, 1.4 }, { 0.3, 2.0, -1.8 }, { 0.4, 2.0, -2.3 } },
			windup = { Root = { 8, 0, 0, 0, 0.05, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 165, 0, -10 }, RE = { 30, 0, 0 }, LS = { 165, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.9, -0.3 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 10 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 10, 0, 0 }, LW = { -60, 0, 0 } },
			follow = { Root = { -22, 0, 0, 0, -0.92, -0.32 }, Waist = { -28, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 55, 0, 12 }, RE = { 10, 0, 0 }, RW = { -70, 0, 0 }, LS = { 55, 0, -12 }, LE = { 10, 0, 0 }, LW = { -70, 0, 0 } },
			fx = { "dust", { "burst", color = Color3.fromRGB(240, 200, 170), size = 3 } }, text = "ET UN PANSEMENT !", hitText = "SCOTCHÉ !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "ne_pas_deranger", label = "Ne pas déranger", sequence = { "back", "down", "forward" },
			-- momifié en tournant, rangé dans un sarcophage avec la pancarte « Ne pas déranger »
			scene = {
				{ "text", "ON VA VOUS EMMAILLOTER…" },
				{ "spin", 1080, axis = "y", time = 1.0 },
				{ "color", BANDAGE },
				{ "material", "Fabric" },
				{ "fx", { "symbols", symbols = { "〰", "〰" }, color = BANDAGE, count = 6, radius = 2 } },
				{ "wait", 0.3 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0.6), life = 3.5, pieces = {
					{ "Cuve", "", "block", Vector3.new(4, 6.6, 1), Vector3.new(0, 0, 1.2), Vector3.zero, GOLD, "Metal", { reflect = 0.15 } },
					{ "Couvercle", "", "block", Vector3.new(4, 6.6, 0.5), Vector3.new(0, 0, -1.4), Vector3.zero, GOLD, "Metal", { transparency = 0.1 } },
					{ "Visage", "", "block", Vector3.new(1.8, 1.8, 0.2), Vector3.new(0, 2, -1.7), Vector3.zero, Color3.fromRGB(240, 200, 120) },
					{ "Bande", "", "block", Vector3.new(3.8, 0.4, 0.2), Vector3.new(0, 0.3, -1.7), Vector3.zero, LAPIS },
					{ "Pancarte", "", "block", Vector3.new(2.6, 1.1, 0.12), Vector3.new(0, -1.3, -1.8), Vector3.new(0, 0, -6), Color3.fromRGB(250, 250, 250) },
					{ "Cordon", "", "cyl", Vector3.new(1.6, 0.06, 0.06), Vector3.new(0, -0.6, -1.8), Vector3.zero, SCARF },
				} },
				{ "hide" },
				{ "fxAttacker", { "text", text = "NE PAS DÉRANGER !", color = GOLD } },
				{ "wait", 1.6 },
			},
		},
		{
			id = "grand_atchoum", label = "Le Grand Atchoum", sequence = { "forward", "up", "back" },
			-- un éternuement si énorme que l'adversaire est soufflé hors de la carte
			scene = {
				{ "fxAttacker", { "text", text = "AAAH…", color = GERM } },
				{ "wait", 0.4 },
				{ "fxAttacker", { "text", text = "AAAAAAH…", color = GERM } },
				{ "wait", 0.5 },
				{ "fxAttacker", { "particles", tex = "smoke", color = GERM, at = "head", dir = "front", time = 0.8, rate = 200, speed = 25, size = 2 } },
				{ "fxAttacker", { "screen", color = GERM, alpha = 0.35, time = 0.6 } },
				{ "text", "ATCHOUUUUUM !" },
				{ "spin", 360, axis = "z", time = 0.3 },
				{ "launch", Vector3.new(140, 30, 0), time = 1.0 },
				{ "fx", { "burst", color = GERM, size = 5 } },
				{ "wait", 0.4 },
			},
		},
		{
			id = "inapte", label = "Inapte", sequence = { "down", "down", "back" },
			-- il reçoit un certificat « Inapte au combat » et repart dans une ambulance-jouet
			scene = {
				{ "spawn", at = "above", offset = Vector3.new(0, 0, 0), life = 2.5, pieces = {
					{ "Certificat", "", "block", Vector3.new(2.4, 3, 0.1), Vector3.zero, Vector3.new(0, 0, 8), Color3.fromRGB(250, 250, 245), "SmoothPlastic" },
					{ "Croix1", "", "block", Vector3.new(0.9, 0.3, 0.12), Vector3.new(0, 0.8, -0.02), Vector3.zero, Color3.fromRGB(220, 40, 40) },
					{ "Croix2", "", "block", Vector3.new(0.3, 0.9, 0.12), Vector3.new(0, 0.8, -0.02), Vector3.zero, Color3.fromRGB(220, 40, 40) },
					{ "Tampon", "", "cyl", Vector3.new(0.1, 0.8, 0.8), Vector3.new(0.5, -0.8, -0.02), Vector3.zero, LAPIS, "SmoothPlastic", { axis = "z" } },
				} },
				{ "text", "INAPTE AU COMBAT" },
				{ "wait", 0.8 },
				{ "shrink", 0.4, time = 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, -1.6, 0), life = 2.5, pieces = {
					{ "Caisse", "", "block", Vector3.new(3, 1.6, 1.6), Vector3.zero, Vector3.zero, Color3.fromRGB(250, 250, 250) },
					{ "Cabine", "", "block", Vector3.new(1.1, 1, 1.5), Vector3.new(1.9, -0.3, 0), Vector3.zero, Color3.fromRGB(250, 250, 250) },
					{ "Croix", "", "block", Vector3.new(0.8, 0.25, 0.05), Vector3.new(0, 0.2, -0.82), Vector3.zero, Color3.fromRGB(220, 40, 40) },
					{ "Gyrophare", "", "ball", Vector3.new(0.4, 0.4, 0.4), Vector3.new(0.5, 0.95, 0), Vector3.zero, Color3.fromRGB(60, 120, 255), "Neon", { neon = true, light = { Color3.fromRGB(60, 120, 255), 8, 2 } } },
					{ "Roue1", "", "cyl", Vector3.new(0.3, 0.7, 0.7), Vector3.new(-1, -0.85, 0), Vector3.zero, Color3.fromRGB(30, 30, 30), "SmoothPlastic", { axis = "z" } },
					{ "Roue2", "", "cyl", Vector3.new(0.3, 0.7, 0.7), Vector3.new(1.6, -0.85, 0), Vector3.zero, Color3.fromRGB(30, 30, 30), "SmoothPlastic", { axis = "z" } },
				} },
				{ "hide" },
				{ "fx", { "text", text = "PIN-PON ! PIN-PON !", color = Color3.fromRGB(60, 120, 255) } },
				{ "fxAttacker", { "text", text = "PROMPT RÉTABLISSEMENT !", color = TISSUE } },
				{ "wait", 1.4 },
			},
		},
	},

	-- Mécanique : Contagion. Ses coups marqués status sneezy enrhument : l'enrhumé éternue au hasard,
	-- ce qui coupe son action en cours (server/Mechanics.lua)
	passive = { kind = "contagion", name = "Contagion", icon = "🤧", color = GERM },

	-- Recharge ⚡ : il recolle ses bandelettes avec du sparadrap, avale un comprimé et vérifie son thermomètre
	charge = {
		label = "Petits soins",
		loop = 2.4,
		lockWrist = false,
		color = GERM,
		keys = {
			{ 0.0, { Root = { -8, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, -10 }, RE = { 80, 0, 0 }, LS = { 60, 0, 20 }, LE = { 110, 0, 0 } } },
			{ 0.25, { Root = { -8, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, -10 }, RE = { 80, 0, 0 }, LS = { 70, 0, 35 }, LE = { 95, 0, 0 } } },
			{ 0.5, { Root = { -8, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, -10 }, RE = { 80, 0, 0 }, LS = { 55, 0, 15 }, LE = { 120, 0, 0 } } },
			{ 0.75, { Root = { -8, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, -10 }, RE = { 80, 0, 0 }, LS = { 70, 0, 35 }, LE = { 95, 0, 0 } } },
			{ 1.0, { Root = { -4, 0, 0, 0, -0.1, 0 }, Waist = { -4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 120, 0, 15 }, LE = { 135, 0, 0 } } },
			{ 1.25, { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 40, 0, -10 }, LE = { 80, 0, 0 } } },
			{ 1.55, { Root = { -6, 0, 0, 0, -0.15, 0 }, Waist = { -6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 120, 0, -25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, 10 }, LE = { 70, 0, 0 } } },
			{ 1.9, { Root = { -6, 0, 0, 0, -0.15, 0 }, Waist = { -6, 0, 0 }, Neck = { -6, 14, 0 }, RS = { 122, 0, -25 }, RE = { 102, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, 10 }, LE = { 70, 0, 0 } } },
			{ 2.1, { Root = { -6, 0, 0, 0, -0.15, 0 }, Waist = { -6, 0, 0 }, Neck = { -6, -14, 0 }, RS = { 120, 0, -25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, 10 }, LE = { 70, 0, 0 } } },
			{ 2.4, { Root = { -8, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, -10 }, RE = { 80, 0, 0 }, LS = { 60, 0, 20 }, LE = { 110, 0, 0 } } },
		},
		beats = {
			{ 0.2, { "text", text = "SCRITCH…", color = BANDAGE } },
			{ 1.0, { "toss", shape = "ball", color = TISSUE, size = 0.3, count = 1, speed = 2, lift = 6 } },
			{ 1.25, { "text", text = "GLOUPS !", color = TISSUE } },
			{ 1.6, { "symbols", symbols = { "🌡️" }, color = FEVER, count = 1, radius = 1 } },
			{ 1.9, { "text", text = "39,2° ! JE SUIS PERDU…", color = FEVER } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- il se mouche bruyamment dans ses bandelettes
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { 20, 0, 0 }, Waist = { 10, 0, 0 }, LS = { 130, 0, 20 }, LE = { 130, 0, 0 }, RS = { 120, 0, -20 }, RE = { 120, 0, 0 } } },
			{ 0.6, { Neck = { -15, 0, 0 }, Waist = { -14, 0, 0 }, LS = { 120, 0, 20 }, LE = { 135, 0, 0 }, RS = { 112, 0, -20 }, RE = { 125, 0, 0 } } },
			{ 0.8, { Neck = { -10, 0, 0 }, Waist = { -10, 0, 0 }, LS = { 125, 0, 20 }, LE = { 132, 0, 0 }, RS = { 116, 0, -20 }, RE = { 122, 0, 0 } } },
			{ 1.0, { Neck = { -15, 0, 0 }, Waist = { -14, 0, 0 }, LS = { 120, 0, 20 }, LE = { 135, 0, 0 }, RS = { 112, 0, -20 }, RE = { 125, 0, 0 } } },
			{ 1.8, {} },
		} },
		-- il vérifie sa fièvre du dos de la main, l'air dramatique
		{ duration = 2.0, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 20, 0, 0 }, Waist = { 8, 0, 0 }, LS = { 160, 0, 10 }, LE = { 120, 0, 0 }, LW = { 30, 0, 0 } } },
			{ 1.2, { Neck = { 26, 0, 6 }, Waist = { 10, 0, 0 }, Root = { 4, 0, 4 }, LS = { 162, 0, 12 }, LE = { 118, 0, 0 }, LW = { 30, 0, 0 } } },
			{ 2.0, {} },
		} },
		-- il réenroule une bandelette qui se défait sur son bras
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { -25, 10, 0 }, RS = { 60, 0, -20 }, RE = { 110, 0, 0 }, LS = { 50, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 0.6, { Neck = { -25, 10, 0 }, RS = { 70, 0, -35 }, RE = { 95, 0, 0 }, LS = { 50, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 0.9, { Neck = { -25, 10, 0 }, RS = { 55, 0, -15 }, RE = { 120, 0, 0 }, LS = { 50, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 1.2, { Neck = { -25, 10, 0 }, RS = { 70, 0, -35 }, RE = { 95, 0, 0 }, LS = { 50, 0, 10 }, LE = { 90, 0, 0 } } },
			{ 1.8, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : bras tendus devant, les bandelettes enroulées autour de la victime, l'air las
data.grabHold = {
	Root = { -6, 0, 0, 0, -0.2, 0.05 },
	Waist = { -8, 0, 0 },
	Neck = { 14, 0, 6 },
	RS = { 88, 0, -18 },
	RE = { 55, 0, 0 },
	LS = { 92, 0, 22 },
	LE = { 45, 0, 0 },
}

-- Retour 🪂 : il sort d'un sarcophage qui se pose debout, éternue dans un nuage de poussière et réajuste
-- ses bandelettes
data.respawn = {
	duration = 1.9,
	platform = { pieces = {
		{ "Dalle", "base", "block", Vector3.new(5, 1, 3.2), Vector3.new(0, -0.5, 0), Vector3.zero, Color3.fromRGB(200, 180, 130), "Sand" },
		{ "Socle", "", "block", Vector3.new(5.4, 0.6, 3.6), Vector3.new(0, -1.3, 0), Vector3.zero, Color3.fromRGB(170, 150, 105), "Slate" },
		{ "Cuve", "", "block", Vector3.new(3, 6.4, 0.8), Vector3.new(0, 3.2, 1.4), Vector3.zero, GOLD, "Metal", { reflect = 0.15 } },
		{ "Coiffe", "", "block", Vector3.new(3.2, 1.6, 0.9), Vector3.new(0, 5.6, 1.35), Vector3.zero, LAPIS, "SmoothPlastic" },
		{ "Couvercle", "", "block", Vector3.new(3, 6.4, 0.4), Vector3.new(-2.6, 3.2, 0.2), Vector3.new(0, 40, 0), GOLD, "Metal", { reflect = 0.15 } },
		{ "VisageCouvercle", "", "block", Vector3.new(1.4, 1.4, 0.1), Vector3.new(-2.7, 5, -0.05), Vector3.new(0, 40, 0), Color3.fromRGB(240, 200, 120) },
		{ "Bandelette", "", "block", Vector3.new(0.3, 2.4, 0.05), Vector3.new(1.2, 1.4, 0.95), Vector3.new(0, 0, 15), BANDAGE, "Fabric" },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, 0, 0.5 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, -45 }, RE = { 120, 0, 0 }, LS = { 60, 0, 45 }, LE = { 120, 0, 0 } } },
		{ 0.45, { Root = { 0, 0, 0, 0, 0, 0.5 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, -45 }, RE = { 120, 0, 0 }, LS = { 60, 0, 45 }, LE = { 120, 0, 0 } } },
		{ 0.7, { Root = { -6, 0, 0, 0, -0.1, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 30, 0, -20 }, LE = { 50, 0, 0 } } },
		{ 0.95, { Root = { 10, 0, 0, 0, -0.05, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 35 }, RE = { 50, 0, 0 }, LS = { 30, 0, -35 }, LE = { 50, 0, 0 } } },
		{ 1.1, { Root = { -16, 0, 0, 0, -0.3, -0.15 }, Waist = { -24, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 10, 0, 40 }, RE = { 40, 0, 0 }, LS = { 10, 0, -40 }, LE = { 40, 0, 0 } } },
		{ 1.4, { Root = { -6, 0, 0, 0, -0.1, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, -10 }, RE = { 120, 0, 0 }, LS = { 150, 0, 10 }, LE = { 120, 0, 0 } } },
		{ 1.6, { Root = { -6, 0, 0, 0, -0.1, 0 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 4 }, RS = { 145, 0, -15 }, RE = { 125, 0, 0 }, LS = { 152, 0, 12 }, LE = { 118, 0, 0 } } },
		{ 1.9, {} },
	},
	beats = {
		{ 0.05, { "particles", tex = "smoke", color = Color3.fromRGB(210, 190, 150), at = "feet", dir = "all", time = 0.6, rate = 50, speed = 4, size = 1.2 } },
		{ 0.95, { "text", text = "AAAH…", color = GERM } },
		{ 1.1, { "particles", tex = "smoke", color = Color3.fromRGB(210, 190, 150), at = "head", dir = "front", time = 0.4, rate = 120, speed = 10, size = 1.2 } },
		{ 1.12, { "text", text = "ATCHOUM !", color = GERM } },
	},
}

-- Arbre d'enchaînements (voir Gege.lua) : presque toutes les chaînes peuvent finir sur S (Quinte de toux)
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol, P…
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side", S = "S_finish_cough" },
	P_combo2 = { P = "P_combo3", K = "PK_combo", S = "S_finish_cough" }, -- P P
	P_combo3 = { P = "P_combo4", K = "K_combo3", S = "S_neutral" }, -- P P P (P P P P : thermomètre qui explose, finition)
	PK_combo = { P = "PKP_combo", K = "K_combo2", S = "S_finish_cough" }, -- P K (P K P : bouillotte sur le crâne, finition)
	P_side = { P = "P_side2", K = "K_side", S = "S_side" }, -- → P
	P_side2 = { P = "P_side3", K = "PK_combo", S = "S_finish_cough" }, -- → P P (→ P P P : mouche-toi, finition)
	P_down = { P = "P_down2", K = "K_down", S = "S_finish_cough" }, -- ↓ P
	P_down2 = { up_K = "K_up", K = "KP_combo", S = "S_finish_cough" }, -- ↓ P P
	P_up = { P = "P_combo2", K = "K_up", S = "S_neutral" }, -- ↑ P
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_finish_cough" }, -- dash P
	-- au sol, K…
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_cough" },
	K_combo2 = { K = "K_combo3", P = "KP_combo", S = "S_finish_cough" }, -- K K
	K_combo3 = { S = "S_neutral" }, -- K K K
	KP_combo = { K = "K_combo3", P = "P_combo3", S = "S_finish_cough" }, -- K P
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_cough" }, -- → K
	K_side2 = { K = "K_side3", P = "KP_combo", S = "S_finish_cough" }, -- → K K (→ K K K : plâtre qui casse, finition)
	K_down = { K = "K_downK", P = "P_down2", S = "S_finish_cough" }, -- ↓ K
	K_downK = { P = "KP_combo", S = "S_finish_cough" }, -- ↓ K K
	K_up = { P = "P_air_up", S = "S_finish_cough" }, -- ↑ K
	K_dash = { P = "KP_combo", S = "S_finish_cough" }, -- dash K
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

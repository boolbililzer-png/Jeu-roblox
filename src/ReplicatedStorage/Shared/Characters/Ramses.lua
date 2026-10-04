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

local CHROME = Color3.fromRGB(190, 195, 205) -- potence de perfusion (arme n° 2)
local SERUM = Color3.fromRGB(120, 230, 200)
local SAND = Color3.fromRGB(225, 195, 130) -- sable du sceptre (arme n° 3)
local FROG = Color3.fromRGB(90, 190, 70)

-- seringue express (projectile de la perfusion) et seringue géante du →Y
local SYRINGE = { shape = "cyl", size = 1.4, color = GLASS, transparency = 0.2, spin = 0, parts = {
	{ "cyl", Vector3.new(0.9, 0.3, 0.3), Vector3.new(1.1, 0, 0), CHROME },
	{ "block", Vector3.new(0.2, 0.9, 0.9), Vector3.new(-0.8, 0, 0), CHROME },
	{ "cyl", Vector3.new(0.9, 0.5, 0.5), Vector3.new(0, 0, 0), SERUM },
} }
local SYRINGE_GIANT = { shape = "cyl", size = 4, color = GLASS, transparency = 0.2, spin = 0, parts = {
	{ "cyl", Vector3.new(2.8, 0.5, 0.5), Vector3.new(3.2, 0, 0), CHROME },
	{ "block", Vector3.new(0.4, 2.6, 2.6), Vector3.new(-2.3, 0, 0), CHROME },
	{ "cyl", Vector3.new(3, 1.5, 1.5), Vector3.new(0, 0, 0), SERUM },
	{ "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(4.8, 0.3, 0), SERUM },
} }
-- œil d'Horus (rayon du sceptre)
local HORUS = { shape = "ball", size = 1.6, color = GOLD, neon = true, spin = 4, parts = {
	{ "ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0, 0, 0), Color3.fromRGB(30, 30, 40) },
	{ "block", Vector3.new(1.8, 0.2, 0.2), Vector3.new(0, -0.6, 0), LAPIS },
} }
-- grenouille des dix plaies
local FROG_SHOT = { shape = "ball", size = 1.2, color = FROG, spin = 6, parts = {
	{ "ball", Vector3.new(0.4, 0.4, 0.4), Vector3.new(0.3, 0.5, -0.3), Color3.fromRGB(255, 255, 255) },
	{ "ball", Vector3.new(0.4, 0.4, 0.4), Vector3.new(0.3, 0.5, 0.3), Color3.fromRGB(255, 255, 255) },
} }
local data = {
	id = "Ramses",
	name = "Ramsès le Patraque",
	costume = "Ramses",
	style = "sick",
	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : le malade imaginaire
	-- Ses propres J / K et ses combos sans thermomètre ni bandelettes : Ramsès tâte le front et le pouls des autres,
	-- tend ses bras raides de momie, se fait des crampes, tombe dans les pommes et panique pour un rien.
	bare = {
		moves = {
			-- J : il plaque sa main moite sur le front de l'adversaire pour vérifier sa fièvre
			P_neutral = {
				label = "Main sur le front", startup = 0.08, active = 0.08, recovery = 0.16,
				damage = 5, hitbox = box(4, 3, 2.6, 1.4), kbBase = 18, kbGrowth = 22, kbAngle = 28,
				windup = { Root = { 4, -10, 0, 0, -0.1, 0.1 }, Waist = { 6, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 20 }, RE = { 90, 0, 0 }, RW = { -50, 0, 0 }, LS = { 20, 0, -10 }, LE = { 100, 0, 0 } },
				strike = { Root = { -6, 6, 0, 0, -0.12, -0.22 }, Waist = { -6, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 110, 0, 0 }, RE = { 10, 0, 0 }, RW = { -70, 0, 0 }, LS = { 20, 0, -10 }, LE = { 110, 0, 0 } },
				follow = { Root = { -7, 8, 0, 0, -0.12, -0.25 }, Waist = { -7, 10, 0 }, Neck = { -8, 0, 0 }, RS = { 112, 0, -4 }, RE = { 12, 0, 0 }, RW = { -76, 0, 0 }, LS = { 22, 0, -10 }, LE = { 112, 0, 0 } },
				trail = "rightHand", fx = { { "text", text = "39,5° ?!", color = FEVER, at = "head" } }, hitText = "T'ES BRÛLANT !",
			},
			-- J J : deux doigts plantés dans le cou de l'adversaire : il prend son pouls… très fort
			P_combo2 = {
				label = "Tâte-pouls", startup = 0.06, active = 0.08, recovery = 0.16,
				damage = 5, hitbox = box(4, 3, 2.8, 1), kbBase = 18, kbGrowth = 24, kbAngle = 32,
				windup = { Root = { 4, 14, 0, 0, -0.1, 0.08 }, Waist = { 4, 16, 0 }, Neck = { 0, 10, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, LS = { 70, 0, -30 }, LE = { 100, 0, 0 }, LW = { 20, 0, 0 } },
				strike = { Root = { -6, -12, 0, 0, -0.15, -0.28 }, Waist = { -6, -14, 0 }, Neck = { -6, -10, 0 }, RS = { 30, 0, 20 }, RE = { 100, 0, 0 }, LS = { 100, 0, 10 }, LE = { 6, 0, 0 }, LW = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
				follow = { Root = { -7, -14, 0, 0, -0.15, -0.3 }, Waist = { -7, -16, 0 }, Neck = { -8, -12, 0 }, RS = { 28, 0, 22 }, RE = { 104, 0, 0 }, LS = { 102, 0, 14 }, LE = { 4, 0, 0 }, LW = { 26, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
				trail = "bothHands", hitText = "TOUDOUM !",
			},
			-- J J J : son dos se coince puis se redresse d'un coup sec, l'épaule cogne au passage
			P_combo3 = {
				label = "Lumbago", startup = 0.12, active = 0.1, recovery = 0.28,
				damage = 8, hitbox = box(4.5, 3.5, 2.4, 1), kbBase = 26, kbGrowth = 46, kbAngle = 38, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { 30, 0, 0, 0, -0.35, 0.15 }, Waist = { 30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -30, 0, 20 }, RE = { 90, 0, 0 }, RW = { 30, 0, 0 }, LS = { -30, 0, -20 }, LE = { 90, 0, 0 } },
				strike = { Root = { -14, -30, 0, 0, 0, -0.35 }, Waist = { -18, -20, 0 }, Neck = { 12, 0, 0 }, RS = { -40, 0, 30 }, RE = { 100, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -16, -34, 0, 0, 0, -0.38 }, Waist = { -20, -24, 0 }, Neck = { 14, 0, 0 }, RS = { -44, 0, 32 }, RE = { 104, 0, 0 }, LS = { 44, 0, -64 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				trail = "body", fx = { { "text", text = "AÏE MON DOS !", color = BANDAGE, at = "head" } }, hitText = "CRAAAC !",
			},
			-- J K : il tombe dans les pommes, raide comme une planche, droit sur l'adversaire
			PK_combo = {
				label = "Tombé dans les pommes", startup = 0.12, active = 0.14, recovery = 0.32,
				damage = 8, hitbox = box(5, 3, 3, 0), kbBase = 24, kbGrowth = 44, kbAngle = 30, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { -8, 0, 0, 0, 0, 0.1 }, Waist = { -6, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 10, 0, 10 }, RE = { 120, 0, 0 }, RW = { -40, 0, 0 }, LS = { 0, 0, -10 }, LE = { 0, 0, 0 } },
				strike = { Root = { 60, 0, 0, 0, -0.6, -0.4 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 0, 0, 10 }, RE = { 0, 0, 0 }, LS = { 0, 0, -10 }, LE = { 0, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
				follow = { Root = { 70, 0, 0, 0, -0.75, -0.45 }, Waist = { 0, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 0, 0, 12 }, RE = { 0, 0, 0 }, LS = { 0, 0, -12 }, LE = { 0, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
				trail = "body", fx = { "dust" }, hitText = "POUF… ZZZ !",
			},
			-- K K : sa jambe s'engourdit, il la secoue par saccades pour chasser les fourmis (deux coups)
			K_combo2 = {
				label = "Jambe engourdie", startup = 0.1, active = 0.2, recovery = 0.26,
				damage = 7, hits = 2, hitbox = box(5, 2.5, 2.8, -0.8), kbBase = 22, kbGrowth = 40, kbAngle = 35,
				windup = { Root = { 6, 0, 0, 0, -0.15, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, LS = { 50, 0, -20 }, LE = { 90, 0, 0 }, RH = { 40, 0, 10 }, RK = { -70, 0, 0 } },
				strike = { Root = { -4, 0, 4, 0, -0.1, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 50, 0, 50 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 70, 0, 20 }, RK = { -10, 0, 0 }, RA = { -30, 0, 0 } },
				follow = { Root = { -4, 0, -4, 0, -0.1, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 54, 0, 54 }, RE = { 40, 0, 0 }, LS = { 54, 0, -44 }, LE = { 60, 0, 0 }, RH = { 50, 0, -10 }, RK = { -40, 0, 0 }, RA = { 20, 0, 0 } },
				wobble = true, trail = "rightFoot", fx = { { "symbols", symbols = { "🐜", "⚡" }, color = BANDAGE, count = 4, radius = 2 } }, hitText = "ÇA PIQUE !",
			},
			-- K J : il se mouche dans sa manche d'un grand revers de bras
			KP_combo = {
				label = "Revers de manche", startup = 0.1, active = 0.1, recovery = 0.24,
				damage = 7, hitbox = box(4.5, 3, 2.6, 1.2), kbBase = 24, kbGrowth = 40, kbAngle = 30,
				windup = { Root = { 2, 20, 0, 0, -0.1, 0.05 }, Waist = { 4, 24, 0 }, Neck = { -10, 30, 0 }, RS = { 90, 0, -40 }, RE = { 110, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
				strike = { Root = { -6, -24, 0, 0, -0.15, -0.25 }, Waist = { -6, -28, 0 }, Neck = { 6, -20, 0 }, RS = { 90, 0, 60 }, RE = { 20, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } },
				follow = { Root = { -7, -30, 0, 0, -0.15, -0.28 }, Waist = { -7, -34, 0 }, Neck = { 8, -24, 0 }, RS = { 86, 0, 76 }, RE = { 24, 0, 0 }, LS = { 18, 0, -32 }, LE = { 92, 0, 0 } },
				trail = "rightHand", fx = { { "toss", shape = "ball", color = GERM, size = 0.3, count = 4, speed = 14 } }, hitText = "SNIIIF-PAF !",
			},
			-- K K J : crise d'hypocondrie : il panique, bras qui moulinent, et frappe tout ce qui bouge (finition)
			KKP_combo = {
				label = "Crise d'hypocondrie", startup = 0.12, active = 0.24, recovery = 0.34,
				damage = 10, hits = 3, hitbox = box(5.5, 4, 2.4, 0.8), kbBase = 30, kbGrowth = 58, kbAngle = 42,
				windup = { Root = { -10, 0, 0, 0, 0.05, 0.15 }, Waist = { -12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 160, 0, 40 }, RE = { 40, 0, 0 }, LS = { 160, 0, -40 }, LE = { 40, 0, 0 } },
				strike = { Root = { 8, 0, 6, 0, -0.1, -0.3 }, Waist = { 10, 10, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 90 }, RE = { 30, 0, 0 }, LS = { 40, 0, -20 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { 8, 0, -6, 0, -0.1, -0.34 }, Waist = { 10, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 30, 0, 0 }, LS = { 120, 0, -90 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				hold = 0.1, wobble = true, trail = "bothHands", fx = { { "text", text = "JE VAIS MOURIR !", color = FEVER, at = "head" }, { "symbols", symbols = { "💊", "🤒" }, color = GERM, count = 5, radius = 3 } }, hitText = "AU SECOURS !",
			},
			-- →J : les deux bras tendus raides devant lui, la démarche classique de la momie
			P_side = {
				label = "Bras raides de momie", startup = 0.1, active = 0.12, recovery = 0.2,
				damage = 7, hitbox = box(5, 3, 3, 1), kbBase = 22, kbGrowth = 34, kbAngle = 25, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { -6, 0, 0, 0, 0, 0.15 }, Waist = { -6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 60, 0, -10 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 } },
				strike = { Root = { 6, 0, 0, 0, -0.05, -0.4 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 92, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { 8, 0, 0, 0, -0.05, -0.44 }, Waist = { 8, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 94, 0, 2 }, RE = { 0, 0, 0 }, RW = { 6, 0, 0 }, LS = { 94, 0, -2 }, LE = { 0, 0, 0 }, LW = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				trail = "bothHands", hitText = "MMMHHH !",
			},
			-- ↓J : accroupi, il grelotte si fort que ses coudes tapent les tibias de l'adversaire
			P_down = {
				label = "Grelottement", startup = 0.07, active = 0.12, recovery = 0.18,
				damage = 5, hitbox = box(4.5, 2, 2.4, -1.3), kbBase = 20, kbGrowth = 24, kbAngle = 65,
				windup = { Root = { 10, 0, 0, 0, -0.8, 0.05 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 130, 0, 0 }, LS = { 60, 0, -30 }, LE = { 130, 0, 0 } },
				strike = { Root = { 14, 0, 6, 0, -0.9, -0.15 }, Waist = { 20, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 50 }, RE = { 130, 0, 0 }, LS = { 40, 0, -50 }, LE = { 130, 0, 0 } },
				follow = { Root = { 14, 0, -6, 0, -0.9, -0.17 }, Waist = { 20, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 44, 0, 54 }, RE = { 130, 0, 0 }, LS = { 44, 0, -54 }, LE = { 130, 0, 0 } },
				wobble = true, fx = { { "symbols", symbols = { "❄️" }, color = GLASS, count = 3, radius = 2 } }, hitText = "BRRRR !",
			},
			-- ↑J : il lève les bras au ciel en se lamentant « pourquoi moi ? » et cogne ce qui est au-dessus
			P_up = {
				label = "Pourquoi moi ?!", startup = 0.09, active = 0.1, recovery = 0.22,
				damage = 6, hitbox = box(4, 5, 1, 3.2), kbBase = 22, kbGrowth = 38, kbAngle = 86,
				windup = { Root = { 10, 0, 0, 0, -0.35, 0.05 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 30 }, RE = { 120, 0, 0 }, LS = { 20, 0, -30 }, LE = { 120, 0, 0 } },
				strike = { Root = { -10, 0, 0, 0, 0.05, 0 }, Waist = { -14, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 165, 0, 30 }, RE = { 10, 0, 0 }, LS = { 165, 0, -30 }, LE = { 10, 0, 0 } },
				follow = { Root = { -12, 0, 0, 0, 0.05, 0 }, Waist = { -16, 0, 0 }, Neck = { -38, 0, 0 }, RS = { 170, 0, 38 }, RE = { 14, 0, 0 }, LS = { 170, 0, -38 }, LE = { 14, 0, 0 } },
				trail = "bothHands", hitText = "OUIIIN !",
			},
			-- J en l'air : mal au ventre, il se roule en boule les mains sur le bide et tombe sur l'adversaire
			P_air = {
				label = "Mal au ventre", startup = 0.1, active = 0.14, recovery = 0.2,
				damage = 7, hitbox = box(4.5, 4, 0.8, -1.2), kbBase = 20, kbGrowth = 32, kbAngle = -45,
				windup = { Root = { -10, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 10, 0, 0 }, LK = { -30, 0, 0 } },
				strike = { Root = { 30, 0, 0 }, Waist = { 24, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 10 }, RE = { 120, 0, 0 }, LS = { 30, 0, -10 }, LE = { 120, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, LH = { 110, 0, 0 }, LK = { -120, 0, 0 } },
				follow = { Root = { 34, 0, 0 }, Waist = { 26, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 28, 0, 8 }, RE = { 124, 0, 0 }, LS = { 28, 0, -8 }, LE = { 124, 0, 0 }, RH = { 114, 0, 0 }, RK = { -124, 0, 0 }, LH = { 114, 0, 0 }, LK = { -124, 0, 0 } },
				trail = "body", hitText = "GARGOUILLE !",
			},
			-- dash J : urgence toilettes ! il court genoux serrés et bouscule du coude
			P_dash = {
				label = "Urgence !", startup = 0.08, active = 0.16, recovery = 0.24,
				damage = 7, hitbox = box(4.5, 3.5, 2.4, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 30, selfVelocity = Vector2.new(34, 0),
				windup = { Root = { 10, 20, 0, 0, -0.2, 0.15 }, Waist = { 10, 20, 0 }, Neck = { -10, -10, 0 }, RS = { 20, 0, 10 }, RE = { 130, 0, 0 }, LS = { 30, 0, -10 }, LE = { 100, 0, 0 } },
				strike = { Root = { 14, -20, 0, 0, -0.25, -0.35 }, Waist = { 12, -24, 0 }, Neck = { 10, 10, 0 }, RS = { 70, 0, 60 }, RE = { 140, 0, 0 }, LS = { 40, 0, -10 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
				follow = { Root = { 16, -24, 0, 0, -0.25, -0.38 }, Waist = { 14, -28, 0 }, Neck = { 12, 12, 0 }, RS = { 74, 0, 64 }, RE = { 140, 0, 0 }, LS = { 40, 0, -12 }, LE = { 112, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
				fx = { "dust" }, hitText = "PARDON PARDON !",
			},
			-- K : il pose son pied nu tout glacé sur le ventre de l'adversaire et pousse
			K_neutral = {
				label = "Pied glacé", startup = 0.1, active = 0.1, recovery = 0.22,
				damage = 7, hitbox = box(4.5, 3, 2.8, 0), kbBase = 24, kbGrowth = 40, kbAngle = 30,
				windup = { Root = { -6, 0, 0, 0, -0.1, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 50 }, RE = { 70, 0, 0 }, LS = { 30, 0, -50 }, LE = { 70, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 } },
				strike = { Root = { -14, 0, 0, 0, -0.05, 0.05 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 60 }, RE = { 50, 0, 0 }, LS = { 40, 0, -60 }, LE = { 50, 0, 0 }, RH = { 90, 0, 0 }, RK = { -4, 0, 0 }, RA = { -40, 0, 0 } },
				follow = { Root = { -16, 0, 0, 0, -0.05, 0.05 }, Waist = { -12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 44, 0, 64 }, RE = { 50, 0, 0 }, LS = { 44, 0, -64 }, LE = { 50, 0, 0 }, RH = { 94, 0, 0 }, RK = { 0, 0, 0 }, RA = { -44, 0, 0 } },
				trail = "rightFoot", fx = { { "symbols", symbols = { "❄️" }, color = GLASS, count = 3, radius = 2 } }, hitText = "GLAGLA !",
			},
			-- →K : son genou lâche d'un coup et la jambe part sur le côté en fauchant
			K_side = {
				label = "Genou qui lâche", startup = 0.12, active = 0.12, recovery = 0.28,
				damage = 8, hitbox = box(5.5, 2.5, 3, -0.6), kbBase = 26, kbGrowth = 46, kbAngle = 35, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { 0, 10, 0, 0, -0.1, 0.1 }, Waist = { 0, 10, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 40 }, RE = { 80, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, RH = { 10, 0, 0 }, RK = { -50, 0, 0 } },
				strike = { Root = { 10, -20, -10, 0, -0.45, -0.2 }, Waist = { 6, -10, 10 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 100 }, RE = { 20, 0, 0 }, LS = { 60, 0, -100 }, LE = { 20, 0, 0 }, RH = { 80, 0, 30 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { 12, -24, -12, 0, -0.5, -0.22 }, Waist = { 8, -12, 12 }, Neck = { -12, 0, 0 }, RS = { 64, 0, 106 }, RE = { 20, 0, 0 }, LS = { 64, 0, -106 }, LE = { 20, 0, 0 }, RH = { 84, 0, 34 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
				wobble = true, trail = "rightLeg", hitText = "CRIC-CRAC !",
			},
			-- ↓K : une crampe au mollet : il attrape sa jambe et le pied part tout seul au ras du sol
			K_down = {
				label = "Crampe au mollet", startup = 0.12, active = 0.12, recovery = 0.3,
				damage = 8, hitbox = box(5.5, 2, 3, -1.5), kbBase = 26, kbGrowth = 44, kbAngle = 72,
				windup = { Root = { 20, 0, 0, 0, -0.6, 0.1 }, Waist = { 24, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 10 }, RE = { 40, 0, 0 }, LS = { 60, 0, -10 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, -0.8, -0.1 }, Waist = { 14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 20 }, RE = { 30, 0, 0 }, LS = { 40, 0, -20 }, LE = { 30, 0, 0 }, RH = { 60, 0, 10 }, RK = { -4, 0, 0 }, RA = { 40, 0, 0 } },
				follow = { Root = { 12, 0, 0, 0, -0.8, -0.12 }, Waist = { 16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 38, 0, 22 }, RE = { 30, 0, 0 }, LS = { 38, 0, -22 }, LE = { 30, 0, 0 }, RH = { 64, 0, 12 }, RK = { 0, 0, 0 }, RA = { 44, 0, 0 } },
				trail = "rightFoot", fx = { "dust" }, hitText = "OUILLE !",
			},
			-- ↑K : grand étirement du réveil en bâillant, le pied monte au ciel
			K_up = {
				label = "Étirement du matin", startup = 0.14, active = 0.12, recovery = 0.3,
				damage = 9, hitbox = box(4, 6, 1, 3.4), kbBase = 26, kbGrowth = 52, kbAngle = 88,
				windup = { Root = { 6, 0, 0, 0, -0.3, 0.05 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 100, 0, 0 }, LS = { 20, 0, -20 }, LE = { 100, 0, 0 }, RH = { -10, 0, 0 }, RK = { -60, 0, 0 } },
				strike = { Root = { -20, 0, 0, 0, 0.05, 0.05 }, Waist = { -16, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 175, 0, 20 }, RE = { 0, 0, 0 }, LS = { 175, 0, -20 }, LE = { 0, 0, 0 }, RH = { 150, 0, 0 }, RK = { -4, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { -22, 0, 0, 0, 0.05, 0.05 }, Waist = { -18, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 178, 0, 24 }, RE = { 0, 0, 0 }, LS = { 178, 0, -24 }, LE = { 0, 0, 0 }, RH = { 156, 0, 0 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 } },
				trail = "rightFoot", fx = { { "text", text = "AAAAWH…", color = BANDAGE, at = "head" } }, hitText = "HOP-LÀ !",
			},
			-- K en l'air : la fièvre le fait trembler, ses jambes battent l'air deux fois
			K_air = {
				label = "Frissons volants", startup = 0.1, active = 0.2, recovery = 0.22,
				damage = 8, hits = 2, hitbox = box(5, 3.5, 2, -0.8), kbBase = 22, kbGrowth = 38, kbAngle = 38,
				windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 120, 0, 0 }, LS = { 40, 0, -30 }, LE = { 120, 0, 0 }, RH = { 50, 0, 0 }, RK = { -100, 0, 0 }, LH = { 50, 0, 0 }, LK = { -100, 0, 0 } },
				strike = { Root = { 4, 0, 6 }, Waist = { 2, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 44, 0, 34 }, RE = { 120, 0, 0 }, LS = { 44, 0, -34 }, LE = { 120, 0, 0 }, RH = { 85, 0, 0 }, RK = { -6, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
				follow = { Root = { 4, 0, -6 }, Waist = { 2, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 44, 0, 34 }, RE = { 120, 0, 0 }, LS = { 44, 0, -34 }, LE = { 120, 0, 0 }, RH = { 30, 0, 0 }, RK = { -90, 0, 0 }, LH = { 85, 0, 0 }, LK = { -6, 0, 0 } },
				wobble = true, trail = "leftFoot", hitText = "GLA-GLA !",
			},
			-- dash K : il rate une marche invisible et dégringole cul par-dessus tête
			K_dash = {
				label = "Dégringolade", startup = 0.1, active = 0.24, recovery = 0.32,
				damage = 9, hitbox = box(5, 3, 2.2, -0.6), kbBase = 28, kbGrowth = 52, kbAngle = 55, selfVelocity = Vector2.new(42, 0),
				windup = { Root = { 20, 0, 0, 0, -0.3, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 130, 0, 40 }, RE = { 20, 0, 0 }, LS = { 130, 0, -40 }, LE = { 20, 0, 0 } },
				strike = { Root = { 50, 0, 0, 0, -0.85, -0.25 }, Waist = { 40, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 30 }, RE = { 80, 0, 0 }, LS = { 150, 0, -30 }, LE = { 80, 0, 0 }, RH = { 120, 0, 0 }, RK = { -120, 0, 0 }, LH = { 120, 0, 0 }, LK = { -120, 0, 0 } },
				follow = { Root = { 54, 0, 0, 0, -0.85, -0.28 }, Waist = { 42, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 154, 0, 32 }, RE = { 84, 0, 0 }, LS = { 154, 0, -32 }, LE = { 84, 0, 0 }, RH = { 124, 0, 0 }, RK = { -124, 0, 0 }, LH = { 124, 0, 0 }, LK = { -124, 0, 0 } },
				spin = { axis = "x", degrees = 360 }, trail = "body", fx = { "dust" }, hitText = "PATATRAS !",
			},
		},
		-- Combos à mains nues : J J J (front, pouls, lumbago) puis K pour la crise, J K (tombé dans les pommes),
		-- K K J (fourmis puis crise d'hypocondrie), K J (revers de manche). Un S pour finir envoie le spécial du perso.
		links = {
			P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_neutral" },
			P_combo2 = { P = "P_combo3", K = "K_side", S = "S_down" },
			P_combo3 = { K = "KKP_combo", S = "S_side" },
			PK_combo = { P = "P_up", S = "S_down" },
			K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_neutral" },
			K_combo2 = { P = "KKP_combo", K = "K_up", S = "S_side" },
			KP_combo = { P = "P_combo3", K = "K_up", S = "S_up" },
			KKP_combo = { S = "S_neutral" },
			P_side = { P = "P_combo2", K = "PK_combo", S = "S_side" },
			P_down = { K = "K_down", up_P = "P_up", S = "S_down" },
			K_down = { K = "K_combo2", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			K_side = { P = "KP_combo", S = "S_side" },
			P_dash = { P = "P_side", K = "PK_combo", S = "S_side" },
			K_dash = { P = "P_up", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : bandelettes et thermomètre géant (ses coups sont ceux de moves). n° 2 : la perfusion à roulettes, rapide et
	-- courte, qui le remplume à chaque coup. n° 3 : le sceptre du pharaon, lourd et lent, qui éjecte loin et pétrifie.
	weapons = {
		{ id = "thermometre", name = "Bandelettes & thermomètre géant", icon = "🌡️",
			ability = { status = { name = "sneezy", duration = 2 }, text = "Les spéciaux enrhument (éternuements au hasard)" } },
		{ id = "perfusion", name = "Perfusion à roulettes", icon = "💉",
			prop = { name = "PropPerfusion", hand = "Right", pieces = {
				{ "Tige", "", "cyl", Vector3.new(3.4, 0.14, 0.14), Vector3.new(0, -1.2, 0), Vector3.zero, CHROME, "Metal" },
				{ "Crochet", "", "block", Vector3.new(0.7, 0.1, 0.1), Vector3.new(0.3, 0.52, 0), Vector3.zero, CHROME, "Metal" },
				{ "Poche", "", "block", Vector3.new(0.7, 1.0, 0.25), Vector3.new(0.6, -0.05, 0), Vector3.zero, GLASS, "Glass", { transparency = 0.3 } },
				{ "Serum", "", "block", Vector3.new(0.6, 0.6, 0.18), Vector3.new(0.6, -0.2, 0), Vector3.zero, SERUM, "Neon", { neon = true } },
				{ "Tube", "", "cyl", Vector3.new(1.8, 0.06, 0.06), Vector3.new(0.55, -1.4, 0.15), Vector3.new(0, 0, 8), GLASS, "Glass" },
				{ "Roulettes", "", "ball", Vector3.new(0.6, 0.25, 0.6), Vector3.new(0, -2.95, 0), Vector3.zero, Color3.fromRGB(40, 40, 50), "SmoothPlastic" },
			} },
			ability = { heal = 0.3, text = "30 % des dégâts infligés le remplument" },
			moves = {
				-- J : petite piqûre sèche, la potence pointée comme un fleuret (« ça ne fera pas mal »)
				P_neutral = {
					label = "Piqûre", startup = 0.06, active = 0.08, recovery = 0.12,
					damage = 5, hitbox = box(5, 2.5, 3.2, 0.8), kbBase = 16, kbGrowth = 20, kbAngle = 25,
					windup = { Root = { -8, -16, 0, 0, -0.2, 0.15 }, Waist = { -10, -18, 0 }, Neck = { 10, 12, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 90, 0, 0 }, LS = { -20, 0, -25 }, LE = { 60, 0, 0 } },
					strike = { Root = { -14, 14, 0, 0, -0.26, -0.3 }, Waist = { -16, 16, 0 }, Neck = { 2, -4, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -25, 0, -25 }, LE = { 60, 0, 0 } },
					follow = { Root = { -15, 16, 0, 0, -0.28, -0.33 }, Waist = { -17, 18, 0 }, Neck = { 0, -6, 0 }, RS = { 98, 0, -4 }, RE = { 4, 0, 0 }, RW = { 90, 0, 0 }, LS = { -25, 0, -25 }, LE = { 60, 0, 0 } },
					trail = "prop", hitText = "PIC !",
				},
				-- →J : il fouette l'adversaire avec la poche de sérum au bout de son tube
				P_side = {
					label = "Poche-fouet", startup = 0.09, active = 0.1, recovery = 0.16,
					damage = 6, hitbox = box(6, 3, 3.6, 0.8), kbBase = 18, kbGrowth = 28, kbAngle = 25,
					windup = { Root = { -6, 28, 0, 0, -0.2, 0.2 }, Waist = { -8, 30, 0 }, Neck = { 6, -18, 0 }, RS = { 110, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -12, -18, 0, 0, -0.28, -0.3 }, Waist = { -12, -22, 0 }, Neck = { 0, 12, 0 }, RS = { 92, 0, -20 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 15, 0, -35 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -13, -26, 0, 0, -0.3, -0.33 }, Waist = { -13, -30, 0 }, Neck = { 0, 16, 0 }, RS = { 86, 0, -40 }, RE = { 5, 0, 0 }, RW = { -40, 0, 0 }, LS = { 15, 0, -35 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", fx = { { "toss", shape = "ball", color = SERUM, size = 0.3, count = 3, speed = 10 } }, hitText = "SCHLAK !",
				},
				-- ↓J : accroupi, il fait rouler la potence sur les orteils de l'adversaire
				P_down = {
					label = "Roulettes sur les orteils", startup = 0.08, active = 0.1, recovery = 0.16,
					damage = 5, hitbox = box(6, 2, 3.5, -2), kbBase = 20, kbGrowth = 22, kbAngle = 72,
					windup = { Root = { -10, 20, 0, 0, -0.7, 0.1 }, Waist = { -14, 18, 0 }, Neck = { 10, -12, 0 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, -12, 0, 0, -0.85, -0.1 }, Waist = { -20, -14, 0 }, Neck = { 12, 8, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -35 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -14, -18, 0, 0, -0.85, -0.12 }, Waist = { -20, -20, 0 }, Neck = { 12, 12, 0 }, RS = { 40, 0, 20 }, RE = { 5, 0, 0 }, RW = { -40, 0, 0 }, LS = { 32, 0, -37 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { "dust" }, hitText = "CRIC CRIC !",
				},
				-- ↑J : il hisse la potence sous le menton d'un petit coup sec (anti-air)
				P_up = {
					label = "Potence au menton", startup = 0.08, active = 0.1, recovery = 0.18,
					damage = 6, hitbox = box(4, 5.5, 1.2, 3.5), kbBase = 22, kbGrowth = 30, kbAngle = 86,
					windup = { Root = { -6, 0, 0, 0, -0.4, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.05, -0.1 }, Waist = { 8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 } },
					follow = { Root = { 8, 0, 0, 0, 0.1, -0.12 }, Waist = { 10, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 182, 0, 8 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 54, 0, -32 }, LE = { 80, 0, 0 } },
					trail = "prop", hitText = "TING !",
				},
				-- J en l'air : la potence piquée vers le bas comme un bâton de ski
				P_air = {
					label = "Bâton de ski", startup = 0.08, active = 0.12, recovery = 0.14,
					damage = 6, hitbox = box(4.5, 4.5, 1.5, -2), kbBase = 20, kbGrowth = 30, kbAngle = -40,
					windup = { Root = { 8, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 15 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 50, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 10, 0, 12 }, RE = { 6, 0, 0 }, RW = { 10, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
					trail = "prop", hitText = "PIC !",
				},
				-- dash J : un pied sur les roulettes, il file en trottinette et pique devant lui
				P_dash = {
					label = "Trottinette à perfusion", startup = 0.07, active = 0.16, recovery = 0.2,
					damage = 7, hitbox = box(6, 3, 3.5, 0.3), kbBase = 24, kbGrowth = 42, kbAngle = 26, selfVelocity = Vector2.new(46, 0),
					windup = { Root = { -8, -10, 0, 0, -0.35, 0.1 }, Waist = { -10, -12, 0 }, Neck = { 8, 6, 0 }, RS = { 60, 0, 10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 80, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.3, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 5 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -5 }, LE = { 60, 0, 0 }, RH = { 10, 0, 0 }, RK = { -20, 0, 0 }, LH = { -40, 0, 0 }, LK = { -30, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, -0.32, -0.36 }, Waist = { -14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 64, 0, 5 }, RE = { 56, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -5 }, LE = { 56, 0, 0 }, RH = { 10, 0, 0 }, RK = { -20, 0, 0 }, LH = { -50, 0, 0 }, LK = { -30, 0, 0 } },
					trail = "prop", fx = { "dust", { "particles", tex = "spark", color = CHROME, dir = "front", at = "feet", time = 0.2, speed = 8, size = 0.3 } }, text = "PLACE !", hitText = "CRIIIC !",
				},
				-- K : il décroche la poche et la balance à bout de tube comme un fléau mou
				K_neutral = {
					label = "Fléau de sérum", startup = 0.14, active = 0.12, recovery = 0.24,
					damage = 10, hitbox = box(6, 4, 3.2, 0.8), kbBase = 26, kbGrowth = 54, kbAngle = 32,
					windup = { Root = { -6, 0, 0, 0, -0.25, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 175, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -22, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { 40, 0, 0 }, LS = { 20, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -16, 0, 0, 0, -0.38, -0.4 }, Waist = { -26, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 0 }, RE = { 6, 0, 0 }, RW = { 50, 0, 0 }, LS = { 18, 0, -42 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { { "burst", color = SERUM, size = 1.6, at = "front" } }, hitText = "FLOC !",
				},
				-- →K : il presse la poche d'un coup de poing : un jet de sérum part au visage (enrhume)
				K_side = {
					label = "Jet de sérum", kind = "projectile", startup = 0.14, active = 0, recovery = 0.26,
					damage = 9, kbBase = 24, kbGrowth = 44, kbAngle = 28,
					projectile = { speed = 70, angle = 2, gravity = 20, lifetime = 0.35, size = 1.4, color = SERUM, visual = "water", aim = false },
					status = { name = "sneezy", duration = 1.5 },
					windup = { Root = { -6, -16, 0, 0, -0.25, 0.15 }, Waist = { -8, -18, 0 }, Neck = { 6, 12, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 10, 0, 0, -0.3, -0.3 }, Waist = { -14, 12, 0 }, Neck = { 0, -6, 0 }, RS = { 90, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -5 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -13, 12, 0, 0, -0.32, -0.34 }, Waist = { -15, 14, 0 }, Neck = { 0, -8, 0 }, RS = { 92, 0, 12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 98, 0, -8 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "leftHand", fx = { { "particles", tex = "smoke", color = SERUM, dir = "front", at = "hand", time = 0.2, speed = 14, size = 0.4, rate = 60 } }, hitText = "SPLITCH !",
				},
				-- ↓K : accroupi, il fait rouler la potence au ras du sol pour faucher les chevilles
				K_down = {
					label = "Croche-pied à roulettes", startup = 0.14, active = 0.14, recovery = 0.26,
					damage = 9, hitbox = box(7, 2, 3.5, -2), kbBase = 26, kbGrowth = 50, kbAngle = 72,
					windup = { Root = { -8, -36, 0, 0, -0.7, 0.1 }, Waist = { -14, -30, 0 }, Neck = { 0, 26, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -12, 20, 0, 0, -0.85, -0.1 }, Waist = { -18, 24, 0 }, Neck = { 0, -18, 0 }, RS = { 50, 0, -20 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					follow = { Root = { -12, 32, 0, 0, -0.85, -0.12 }, Waist = { -18, 34, 0 }, Neck = { 0, -24, 0 }, RS = { 45, 0, -40 }, RE = { 15, 0, 0 }, RW = { 70, 0, 0 }, LS = { 42, 0, -42 }, LE = { 60, 0, 0 } },
					trail = "prop", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : il plante la potence au sol et s'en sert de perche pour un coup de pantoufle montant
				K_up = {
					label = "Pantoufle à la perche", startup = 0.14, active = 0.12, recovery = 0.28,
					damage = 10, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 28, kbGrowth = 60, kbAngle = 86,
					windup = { Root = { 10, 0, 0, 0, -0.35, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 40, 0, 20 }, RE = { 40, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.05, -0.1 }, Waist = { -18, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, 20 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.08, -0.12 }, Waist = { -20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 28, 0, 22 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", text = "HOP, AÏE !", hitText = "CLONK !",
				},
				-- K en l'air : les roulettes en pleine face, potence tenue à deux mains devant lui
				K_air = {
					label = "Roulettes en pleine face", startup = 0.12, active = 0.14, recovery = 0.22,
					damage = 10, hitbox = box(5.5, 3.5, 3, -0.3), kbBase = 26, kbGrowth = 52, kbAngle = 35,
					windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
					strike = { Root = { 8, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 6 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 88, 0, -6 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
					follow = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 96, 0, 8 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 92, 0, -8 }, LE = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -45, 0, 0 }, LH = { 55, 0, 0 }, LK = { -85, 0, 0 } },
					trail = "prop", hitText = "CLANG !",
				},
				-- dash K : il s'assoit sur les roulettes et fonce en chaise roulante improvisée, pantoufles devant
				K_dash = {
					label = "Chaise roulante express", startup = 0.1, active = 0.26, recovery = 0.28,
					damage = 10, hitbox = box(6, 3, 3, -0.8), kbBase = 28, kbGrowth = 60, kbAngle = 38, selfVelocity = Vector2.new(54, 8),
					windup = { Root = { -8, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -0.75, 0.2 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, RW = { 60, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 22, 0, 0, 0, -0.78, 0.24 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 44, 0, 32 }, RE = { 80, 0, 0 }, RW = { 60, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "bothFeet", fx = { "dust" }, text = "PIN-PON !", hitText = "CLONK !",
				},
				-- L : seringue express, il décroche la seringue du tube et la lance comme une fléchette, droit sur l'adversaire
				S_neutral = {
					label = "Seringue express", kind = "projectile", startup = 0.2, active = 0, recovery = 0.42,
					damage = 12, kbBase = 24, kbGrowth = 42, kbAngle = 30,
					projectile = { speed = 100, angle = 0, gravity = 0, lifetime = 0.6, size = 1.5, color = SERUM, visual = SYRINGE },
					status = { name = "slowed", duration = 1.5 },
					windup = { Root = { 4, -26, 0, 0, -0.2, 0.2 }, Waist = { 6, -30, 0 }, Neck = { 6, 20, 0 }, RS = { 150, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 80, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { -2, -12, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.32, -0.42 }, Waist = { -18, 28, 0 }, Neck = { -4, -16, 0 }, RS = { 98, 0, 6 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 26, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					fx = { { "burst", color = SERUM, size = 1.8, at = "hand" }, { "symbols", symbols = { "💉" }, color = SERUM, count = 2, radius = 2, at = "hand" } }, text = "UNE PETITE PIQÛRE !", hitText = "PIC !",
				},
				-- →L : goutte-à-goutte, il balaie tout le couloir d'un grand revers de potence, le tube claque comme un fouet… et il se sent déjà mieux
				S_side = {
					label = "Goutte-à-goutte", startup = 0.22, active = 0.2, recovery = 0.45,
					damage = 14, hitbox = box(14, 5, 7, 1), kbBase = 30, kbGrowth = 58, kbAngle = 34, selfEffect = { heal = 3 },
					windup = { Root = { -4, 40, 0, 0, -0.25, 0.2 }, Waist = { -6, 44, 0 }, Neck = { 6, -30, 0 }, RS = { 100, 0, 70 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, -30, 0, 0, -0.35, -0.4 }, Waist = { -16, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 92, 0, -40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, -44, 0, 0, -0.37, -0.45 }, Waist = { -18, -50, 0 }, Neck = { 0, 34, 0 }, RS = { 88, 0, -60 }, RE = { 4, 0, 0 }, RW = { -10, 0, 0 }, LS = { 18, 0, -47 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					trail = "prop", fx = { { "ring", color = SERUM, radius = 5, at = "front" }, { "symbols", symbols = { "💧", "💚" }, color = SERUM, count = 4, radius = 3, at = "head" } }, text = "ÇA FAIT DU BIEN !", hitText = "SCHLAK !",
				},
				-- ↓L : roulettes folles, il monte sur la potence et file au ras du sol tout le long du couloir, en zigzag
				S_down = {
					label = "Roulettes folles", startup = 0.2, active = 0.3, recovery = 0.45,
					damage = 13, hitbox = box(14, 4, 7, -0.5), kbBase = 30, kbGrowth = 56, kbAngle = 40, selfVelocity = Vector2.new(58, 0),
					windup = { Root = { -8, 0, 0, 0, -0.45, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 80, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.3, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 70, 0, 5 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -5 }, LE = { 50, 0, 0 }, RH = { 10, 0, 10 }, RK = { -30, 0, 0 }, LH = { 10, 0, -10 }, LK = { -30, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, -0.32, -0.36 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 74, 0, 5 }, RE = { 46, 0, 0 }, RW = { 0, 0, 0 }, LS = { 74, 0, -5 }, LE = { 46, 0, 0 }, RH = { 12, 0, 12 }, RK = { -32, 0, 0 }, LH = { 12, 0, -12 }, LK = { -32, 0, 0 } },
					wobble = true, trail = "prop", fx = { "dust", { "particles", tex = "spark", color = CHROME, dir = "front", at = "feet", time = 0.4, speed = 10, size = 0.4 } }, text = "JE NE SAIS PAS FREINER !", hitText = "RENVERSÉ !",
				},
				-- ↑L : perfusion-fusée, il presse la poche sous ses pantoufles, le sérum gicle et il décolle en diagonale, cramponné à la potence
				S_up = {
					label = "Perfusion-fusée", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 46, kbAngle = 76, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 0, 0, 0, 0, -0.7, 0 }, Waist = { -10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -42, 0, 0, 0, 0.3, -0.1 }, Waist = { -4, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 170, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 20, 0, 0 }, RH = { -24, 0, 4 }, RK = { -30, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -4 }, LK = { -40, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -46, 0, 0, 0, 0.35, -0.15 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 176, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -12 }, LE = { 20, 0, 0 }, RH = { -28, 0, 4 }, RK = { -36, 0, 0 }, RA = { -30, 0, 0 }, LH = { -34, 0, -4 }, LK = { -46, 0, 0 }, LA = { -30, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = SERUM, dir = "down", at = "feet", time = 0.5, speed = 18, size = 0.6, rate = 90 }, { "ring", color = SERUM, radius = 5, at = "feet" } },
					text = "JE M'ENVOLE… AÏE !", hitText = "TING !",
				},
				-- L en l'air : il presse la poche au-dessus de l'adversaire : une pluie de sérum lui tombe dessus (enrhume)
				S_air = {
					label = "Sérum en pluie", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 22, kbGrowth = 40, kbAngle = -40,
					projectile = { speed = 55, angle = -70, gravity = 40, lifetime = 0.7, size = 1.2, color = SERUM, visual = "water", rain = { count = 4, spread = 6 } },
					status = { name = "sneezy", duration = 2 },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 20, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 56, 0, 12 }, RE = { 24, 0, 0 }, RW = { 0, 0, 0 }, LS = { 56, 0, -12 }, LE = { 24, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					fx = { { "burst", color = SERUM, size = 2, at = "feet" } }, text = "ARROSAGE !", hitText = "SPLITCH !",
				},
				-- Y : il lance la perfusion entière comme un javelot olympique, roulettes en tête, à travers tout le couloir
				SUPER = {
					label = "Javelot à roulettes !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.65,
					damage = 24, kbBase = 46, kbGrowth = 96, kbAngle = 30,
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = CHROME, pierce = true,
						visual = { shape = "cyl", size = 3.4, color = CHROME, spin = 0, parts = { { "ball", Vector3.new(1, 0.5, 1), Vector3.new(1.9, 0, 0), Color3.fromRGB(40, 40, 50) }, { "block", Vector3.new(0.9, 1.2, 0.3), Vector3.new(-0.8, 0.9, 0), SERUM } } } },
					status = { name = "sneezy", duration = 3 },
					windup = { Root = { 8, -36, 0, 0, -0.3, 0.3 }, Waist = { 12, -40, 0 }, Neck = { 10, 26, 0 }, RS = { 170, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 40, 0, 0 } },
					strike = { Root = { -18, 26, 0, 0, -0.36, -0.5 }, Waist = { -20, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { -20, 30, 0, 0, -0.38, -0.56 }, Waist = { -24, 34, 0 }, Neck = { -8, -20, 0 }, RS = { 100, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.58 } },
					hideProp = "perfusion", windupFx = { "super", { "symbols", symbols = { "💉", "🏅" }, count = 5, radius = 3, color = SERUM } },
					fx = { { "burst", color = SERUM, size = 3, at = "hand" }, { "beam", color = CHROME, length = 14, width = 1.5, at = "hand" }, { "shake", amount = 0.4 } },
					text = "JAVELOT !", hitText = "EMBROCHÉ !",
				},
				-- →Y : overdose de vitamines, il s'injecte toute la poche d'un coup, retrouve vingt ans… et traverse le couloir en sprint, bras en moulin
				SUPER_side = {
					label = "Overdose de vitamines !", startup = 0.42, active = 0.34, recovery = 0.7,
					damage = 24, hitbox = box(14, 6, 7, 1), kbBase = 46, kbGrowth = 92, kbAngle = 32, selfVelocity = Vector2.new(66, 0), armor = true, selfEffect = { heal = 10 },
					windup = { Root = { -10, 0, 0, 0, -0.3, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 10 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 120, 0, 0 }, LW = { 60, 0, 0 } },
					strike = { Root = { -24, 0, 0, 0, -0.3, -0.4 }, Waist = { -10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 120, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 10, 0, 0 } },
					follow = { Root = { -26, 0, 0, 0, -0.32, -0.46 }, Waist = { -12, 0, 0 }, Neck = { 26, 0, 0 }, RS = { -40, 0, 50 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 } },
					shake = true, trail = "body", windupFx = { "super", { "symbols", symbols = { "💪", "⚡", "💊" }, count = 6, radius = 3, color = SERUM } },
					fx = { "dust", { "ring", color = SERUM, radius = 5, at = "front" }, { "beam", color = SERUM, length = 14, width = 3, at = "root" }, { "screen", color = SERUM, alpha = 0.2 }, { "shake", amount = 0.4 } },
					text = "JE SUIS GUÉRI !", hitText = "ÉCRASÉ PAR UN MIRACULÉ !",
				},
				-- ↑Y : bulle de sérum, il gonfle la poche à bloc comme un ballon, elle éclate sous ses pieds et le geyser l'emporte au plafond avec le couloir
				SUPER_up = {
					label = "Bulle de sérum !", startup = 0.38, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(14, 14, 7, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					status = { name = "sneezy", duration = 3 },
					windup = { Root = { -8, 0, 0, 0, -0.8, 0 }, Waist = { -24, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 16, 0, 0 }, Neck = { 46, 0, 0 }, RS = { 186, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -8 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 22, 0, 0 }, Neck = { 52, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 188, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, windupFx = { "super", { "symbols", symbols = { "🫧" }, count = 6, radius = 3, color = SERUM } },
					fx = { { "pillar", color = SERUM, height = 22, width = 4, at = "front" }, { "burst", color = SERUM, size = 5, at = "feet" }, { "rain", shape = "ball", color = SERUM, count = 12, radius = 6, size = 0.4 }, { "ring", color = SERUM, radius = 6, at = "feet" }, { "shake", amount = 0.6 } },
					text = "ÇA DÉBORDE !", hitText = "ÉCLABOUSSÉ !",
				},
				-- ↓Y : lit d'hôpital, il siffle et un lit à roulettes déboule d'on ne sait où, roule sur tout le couloir et endort qui il renverse
				SUPER_down = {
					label = "Lit d'hôpital !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 22, kbBase = 42, kbGrowth = 86, kbAngle = 38,
					projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 1.1, size = 4.5, color = TISSUE, pierce = true, from = "feet", aim = false,
						visual = { shape = "block", size = 4, color = TISSUE, spin = 0, parts = {
							{ "block", Vector3.new(4.5, 0.3, 2.4), Vector3.new(0, 0.2, 0), CHROME },
							{ "block", Vector3.new(1.2, 0.6, 2.2), Vector3.new(-1.6, 0.8, 0), TISSUE },
							{ "block", Vector3.new(0.3, 2, 2.4), Vector3.new(2.3, 1.0, 0), CHROME },
							{ "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(1.8, -0.3, 1), Color3.fromRGB(40, 40, 50) },
							{ "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-1.8, -0.3, -1), Color3.fromRGB(40, 40, 50) },
						} } },
					status = { name = "asleep", duration = 2 },
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.3, -0.2 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 0, 0, 0, -0.32, -0.24 }, Waist = { -18, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 100, 0, -8 }, RE = { 4, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, 12 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.2, windupFx = { "super", { "text", text = "SIFFLET !", color = TISSUE, at = "head" } },
					fx = { { "shake", amount = 0.5 }, { "beam", color = TISSUE, length = 16, width = 3, at = "feet" }, { "symbols", symbols = { "🛏️", "💤" }, color = TISSUE, count = 4, radius = 3, at = "front" }, { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 225), dir = "front", at = "feet", time = 0.4, speed = 14 } },
					text = "DODO !", hitText = "ENDORMI !",
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
		{ id = "sceptre", name = "Sceptre du pharaon", icon = "👑",
			prop = { name = "PropSceptre", hand = "Right", pieces = {
				{ "Manche", "", "cyl", Vector3.new(2.6, 0.22, 0.22), Vector3.new(0, -1.1, 0), Vector3.zero, GOLD, "Metal" },
				{ "Bande1", "", "cyl", Vector3.new(0.3, 0.27, 0.27), Vector3.new(0, -0.6, 0), Vector3.zero, LAPIS, "SmoothPlastic" },
				{ "Bande2", "", "cyl", Vector3.new(0.3, 0.27, 0.27), Vector3.new(0, -1.6, 0), Vector3.zero, LAPIS, "SmoothPlastic" },
				{ "Crosse", "", "cyl", Vector3.new(0.8, 0.22, 0.22), Vector3.new(0.3, -2.45, 0), Vector3.zero, GOLD, "Metal", { axis = "x" } },
				{ "Pommeau", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(0, 0.25, 0), Vector3.zero, LAPIS, "SmoothPlastic" },
				{ "Oeil", "", "ball", Vector3.new(0.2, 0.2, 0.1), Vector3.new(0, 0.25, -0.2), Vector3.zero, GOLD, "Neon", { neon = true } },
			} },
			ability = { knockback = 1.25, superCooldown = 0.6, text = "Éjecte 25 % plus loin ; les Supers reviennent plus vite" },
			moves = {
				-- J : coup de crosse lourd, le sceptre tenu bien droit comme un roi qui tape du bâton
				P_neutral = {
					label = "Coup de crosse", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(5, 3.5, 3, 0.8), kbBase = 24, kbGrowth = 30, kbAngle = 30,
					windup = { Root = { 4, -16, 0, 0, -0.1, 0.2 }, Waist = { 6, -20, 0 }, Neck = { -6, 10, 0 }, RS = { 150, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -10, 14, 0, 0, -0.28, -0.3 }, Waist = { -12, 18, 0 }, Neck = { -2, -4, 0 }, RS = { 80, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 18, 0, 0, -0.3, -0.36 }, Waist = { -14, 22, 0 }, Neck = { 0, -6, 0 }, RS = { 64, 0, 6 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { 18, 0, -32 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", hitText = "KLONK !",
				},
				-- →J : fauchage royal, grand balayage horizontal du sceptre, il pivote sur ses pantoufles
				P_side = {
					label = "Fauchage royal", startup = 0.15, active = 0.12, recovery = 0.26,
					damage = 10, hitbox = box(6.5, 3.5, 3.6, 0.8), kbBase = 26, kbGrowth = 42, kbAngle = 28, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 4, 44, 0, 0, -0.15, 0.2 }, Waist = { 6, 48, 0 }, Neck = { 0, -34, 0 }, RS = { 80, 0, 70 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 92, 0, -30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -42, 0, 0, -0.32, -0.4 }, Waist = { -12, -48, 0 }, Neck = { 0, 32, 0 }, RS = { 94, 0, -40 }, RE = { 4, 0, 0 }, RW = { -10, 0, 0 }, LS = { 44, 0, -54 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- ↓J : accroupi, il accroche les chevilles avec la crosse et tire l'adversaire à lui
				P_down = {
					label = "Crochet aux chevilles", startup = 0.12, active = 0.12, recovery = 0.24,
					damage = 7, hitbox = box(6.5, 2, 3.8, -2), kbBase = 20, kbGrowth = 20, kbAngle = 40, pull = true,
					windup = { Root = { -8, 10, 0, 0, -0.7, 0.1 }, Waist = { -14, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 110, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, -4, 0, 0, -0.85, -0.1 }, Waist = { -22, -6, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -35 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -6, 10, 0, 0, -0.7, 0.1 }, Waist = { -10, 12, 0 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 32, 0, -37 }, LE = { 70, 0, 0 } },
					trail = "prop", text = "VIENS LÀ !", hitText = "ACCROCHÉ !",
				},
				-- ↑J : il lève le sceptre bien droit sous le menton, le pommeau de lapis cogne (anti-air)
				P_up = {
					label = "Pommeau au menton", startup = 0.12, active = 0.12, recovery = 0.24,
					damage = 9, hitbox = box(4.5, 5.5, 1.5, 3.2), kbBase = 26, kbGrowth = 44, kbAngle = 86,
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 15 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.05, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 176, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 80, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.1, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 182, 0, 8 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 64, 0, -32 }, LE = { 80, 0, 0 } },
					trail = "prop", fx = { { "burst", color = GOLD, size = 1.5, at = "above" } }, hitText = "KLING !",
				},
				-- J en l'air : il abat le sceptre sous lui à deux mains, comme un marteau de juge
				P_air = {
					label = "Verdict", startup = 0.12, active = 0.14, recovery = 0.18,
					damage = 10, hitbox = box(5, 4, 1.5, -1.8), kbBase = 24, kbGrowth = 42, kbAngle = -50,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, 10 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, 5 }, LE = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 16, 0, 6 }, RE = { 8, 0, 0 }, RW = { -20, 0, 0 }, LS = { 16, 0, 6 }, LE = { 8, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
					trail = "prop", text = "COUPABLE !", hitText = "BLAM !",
				},
				-- dash J : charge impériale, le sceptre tenu en lance, bandelettes au vent, rien ne l'arrête
				P_dash = {
					label = "Charge impériale", startup = 0.1, active = 0.2, recovery = 0.3,
					damage = 11, hitbox = box(6.5, 4, 3.5, 0.5), kbBase = 30, kbGrowth = 56, kbAngle = 30, selfVelocity = Vector2.new(46, 0), armor = true,
					windup = { Root = { 6, -24, 0, 0, -0.2, 0.2 }, Waist = { 8, -28, 0 }, Neck = { 0, 16, 0 }, RS = { 40, 0, 30 }, RE = { 120, 0, 0 }, RW = { 90, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -18, 14, 0, 0, -0.35, -0.4 }, Waist = { -12, 18, 0 }, Neck = { 6, -10, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } },
					follow = { Root = { -20, 16, 0, 0, -0.37, -0.46 }, Waist = { -14, 20, 0 }, Neck = { 8, -12, 0 }, RS = { 100, 0, 2 }, RE = { 4, 0, 0 }, RW = { 90, 0, 0 }, LS = { -36, 0, -44 }, LE = { 40, 0, 0 } },
					trail = "prop", fx = { "dust", { "symbols", symbols = { "𓂀" }, color = GOLD, count = 2, radius = 2, at = "head" } }, text = "POUR L'ÉGYPTE !", hitText = "EMBROCHÉ !",
				},
				-- K : le décret, il frappe le sol du sceptre de toute sa (petite) force : la dalle tremble
				K_neutral = {
					label = "Décret royal", startup = 0.22, active = 0.12, recovery = 0.34,
					damage = 12, hitbox = box(7, 3, 2.5, -1.2), kbBase = 32, kbGrowth = 70, kbAngle = 70,
					windup = { Root = { 8, 0, 0, 0, -0.1, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.5, -0.3 }, Waist = { -28, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -18, 0, 0, 0, -0.52, -0.34 }, Waist = { -30, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 36, 0, 6 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 28, 0, -42 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.08, trail = "prop", fx = { { "ring", color = GOLD, radius = 6, at = "feet" }, { "shake", amount = 0.45 }, "dust" }, text = "J'ORDONNE !", hitText = "BOUM !",
				},
				-- →K : pantoufle royale, grand coup de pantoufle à pompon, le sceptre levé derrière en balancier
				K_side = {
					label = "Pantoufle royale", startup = 0.2, active = 0.12, recovery = 0.34,
					damage = 13, hitbox = box(5.5, 3.5, 3.4, 0), kbBase = 34, kbGrowth = 82, kbAngle = 30, selfVelocity = Vector2.new(26, 0),
					windup = { Root = { 8, 0, 0, 0, -0.15, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 4, 0, 0 }, RS = { -30, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, LH = { -35, 0, 0 }, LK = { -60, 0, 0 } },
					strike = { Root = { 20, 0, 0, 0, -0.05, -0.3 }, Waist = { 8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -50, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -55 }, LE = { 30, 0, 0 }, LH = { 88, 0, 0 }, LK = { -2, 0, 0 }, LA = { 15, 0, 0 } },
					follow = { Root = { 22, 0, 0, 0, -0.05, -0.36 }, Waist = { 9, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -55, 0, 54 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -25, 0, -58 }, LE = { 30, 0, 0 }, LH = { 92, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
					trail = "leftFoot", text = "PANTOUFLE !", hitText = "POMPON !",
				},
				-- ↓K : balayage du sceptre au ras du sol, à genoux, comme pour tracer une ligne dans le sable
				K_down = {
					label = "Trait dans le sable", startup = 0.18, active = 0.14, recovery = 0.32,
					damage = 11, hitbox = box(7.5, 2.2, 3.5, -2), kbBase = 30, kbGrowth = 62, kbAngle = 72,
					windup = { Root = { -8, -40, 0, 0, -0.7, 0.1 }, Waist = { -14, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 60, 0, 80 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -12, 20, 0, 0, -0.85, -0.1 }, Waist = { -18, 25, 0 }, Neck = { 0, -20, 0 }, RS = { 50, 0, -20 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					follow = { Root = { -12, 32, 0, 0, -0.85, -0.12 }, Waist = { -18, 35, 0 }, Neck = { 0, -26, 0 }, RS = { 45, 0, -40 }, RE = { 15, 0, 0 }, RW = { 70, 0, 0 }, LS = { 42, 0, -42 }, LE = { 60, 0, 0 } },
					trail = "prop", fx = { { "beam", color = SAND, length = 7, width = 0.8, at = "feet" }, "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : ordre d'en haut, il lève le sceptre vers le ciel d'un grand geste : la crosse remonte sous le menton
				K_up = {
					label = "Ordre d'en haut", startup = 0.18, active = 0.14, recovery = 0.34,
					damage = 12, hitbox = box(5, 6, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.4, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -20, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 180, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 186, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
					trail = "prop", fx = { { "pillar", color = GOLD, height = 6, width = 1.2, at = "front" } }, hitText = "ET HOP !",
				},
				-- K en l'air : chute du pharaon, il tombe assis en tailleur, le sceptre planté devant lui, royal jusque dans la chute
				K_air = {
					label = "Chute du pharaon", startup = 0.16, active = 0.16, recovery = 0.26,
					damage = 12, hitbox = box(5.5, 4, 2, -1), kbBase = 30, kbGrowth = 70, kbAngle = -40,
					windup = { Root = { -8, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 90, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -60 }, LE = { 60, 0, 0 }, RH = { 95, 0, 45 }, RK = { -120, 0, 0 }, LH = { 95, 0, -45 }, LK = { -120, 0, 0 } },
					follow = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 94, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -64 }, LE = { 60, 0, 0 }, RH = { 100, 0, 48 }, RK = { -124, 0, 0 }, LH = { 100, 0, -48 }, LK = { -124, 0, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "𓂀", "👑" }, color = GOLD, count = 3, radius = 2, at = "feet" } }, hitText = "ÉCRASÉ ROYALEMENT !",
				},
				-- dash K : char du pharaon, il glisse sur ses pantoufles, le sceptre pointé comme un timon, en hurlant « HUE ! »
				K_dash = {
					label = "Char du pharaon", startup = 0.12, active = 0.26, recovery = 0.32,
					damage = 12, hitbox = box(6.5, 3.5, 3.5, -0.3), kbBase = 32, kbGrowth = 66, kbAngle = 36, selfVelocity = Vector2.new(52, 0), armor = true,
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 16, 0, 0, 0, -0.7, 0.1 }, Waist = { -6, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 120, 0, -40 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
					follow = { Root = { 18, 0, 0, 0, -0.74, 0.14 }, Waist = { -8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 124, 0, -44 }, LE = { 20, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 18, 0, 0 }, LK = { -92, 0, 0 } },
					trail = "prop", fx = { "dust", { "particles", tex = "smoke", color = SAND, dir = "front", at = "feet", time = 0.3, speed = 10, size = 0.8 } }, text = "HUE !", hitText = "RENVERSÉ !",
				},
				-- L : rayon d'Horus, l'œil du pommeau s'allume et un œil doré file sur l'adversaire, qui se fige en statue
				S_neutral = {
					label = "Rayon d'Horus", kind = "projectile", startup = 0.24, active = 0, recovery = 0.48,
					damage = 13, kbBase = 26, kbGrowth = 44, kbAngle = 30,
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.6, size = 1.8, color = GOLD, visual = HORUS },
					status = { name = "statue", duration = 1.2 },
					windup = { Root = { 2, -20, 0, 0, -0.2, 0.2 }, Waist = { 4, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 60, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
					strike = { Root = { -10, 14, 0, 0, -0.3, -0.35 }, Waist = { -12, 18, 0 }, Neck = { -2, -10, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 16, 0, 0, -0.32, -0.4 }, Waist = { -14, 20, 0 }, Neck = { -4, -12, 0 }, RS = { 98, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -42 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.1, windupFx = { { "symbols", symbols = { "𓂀" }, color = GOLD, count = 3, radius = 2, at = "hand" } }, fx = { { "beam", color = GOLD, length = 12, width = 1.4, at = "hand" }, { "burst", color = GOLD, size = 2, at = "hand" } },
					text = "REGARDE-MOI !", hitText = "PÉTRIFIÉ !",
				},
				-- →L : le fléau, il fait tournoyer le sceptre comme un fléau de pharaon et fauche tout le couloir d'un grand moulinet
				S_side = {
					label = "Fléau du pharaon", startup = 0.24, active = 0.22, recovery = 0.5,
					damage = 15, hitbox = box(14, 6, 7, 1), kbBase = 34, kbGrowth = 70, kbAngle = 30,
					windup = { Root = { 0, -50, 0, 0, -0.2, 0.2 }, Waist = { -4, -46, 0 }, Neck = { 0, 34, 0 }, RS = { 170, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 80, 0, 0 } },
					strike = { Root = { -10, 30, 0, 0, -0.3, -0.4 }, Waist = { -12, 34, 0 }, Neck = { 0, -24, 0 }, RS = { 92, 0, -20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -12, 60, 0, 0, -0.32, -0.45 }, Waist = { -14, 56, 0 }, Neck = { 0, -40, 0 }, RS = { 86, 0, -50 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -54 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", fx = { { "ring", color = GOLD, radius = 6, at = "front" }, { "shake", amount = 0.3 } }, text = "FLÉAU !", hitText = "FAUCHÉ ROYALEMENT !",
				},
				-- ↓L : tempête de sable, il frappe le sol du sceptre et une bourrasque de sable balaie tout le couloir ; on n'y voit plus rien
				S_down = {
					label = "Tempête de sable", startup = 0.24, active = 0.24, recovery = 0.5,
					damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 28, kbGrowth = 52, kbAngle = 36,
					status = { name = "blinded", duration = 2.5 },
					windup = { Root = { 8, 0, 0, 0, -0.5, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 175, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.85, -0.2 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -70 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -16, 0, 0, 0, -0.88, -0.24 }, Waist = { -28, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 36, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 64, 0, -74 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.1, shake = true, trail = "prop", fx = { { "particles", tex = "smoke", color = SAND, dir = "front", at = "feet", time = 0.5, speed = 20, size = 1.2, rate = 120 }, { "beam", color = SAND, length = 14, width = 4, at = "feet" }, { "screen", color = SAND, alpha = 0.25 } },
					text = "KHAMSIN !", hitText = "ENSABLÉ !",
				},
				-- ↑L : ascension divine, le sceptre levé, un pilier de lumière dorée le soulève et il monte en diagonale, raide comme une statue
				S_up = {
					label = "Ascension divine", startup = 0.15, active = 0.3, recovery = 0.44,
					damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 78, selfVelocity = Vector2.new(42, 84),
					windup = { Root = { 0, 0, 0, 0, -0.55, 0 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.3, -0.1 }, Waist = { -2, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 180, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 0, 0, 0 }, RH = { -20, 0, 3 }, RK = { -20, 0, 0 }, RA = { -30, 0, 0 }, LH = { -20, 0, -3 }, LK = { -20, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.35, -0.15 }, Waist = { -4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 186, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -74 }, LE = { 0, 0, 0 }, RH = { -24, 0, 3 }, RK = { -24, 0, 0 }, RA = { -30, 0, 0 }, LH = { -24, 0, -3 }, LK = { -24, 0, 0 }, LA = { -30, 0, 0 } },
					trail = "prop", fx = { { "pillar", color = GOLD, height = 10, width = 3, at = "root", time = 0.4 }, { "burst", color = GOLD, size = 3, at = "feet" }, { "symbols", symbols = { "☀️", "𓂀" }, color = GOLD, count = 4, radius = 3, at = "above" } },
					text = "RÂ M'APPELLE !", hitText = "ILLUMINÉ !",
				},
				-- L en l'air : foudre du pharaon, il pointe le sceptre vers le bas et un éclair doré fond sur l'adversaire
				S_air = {
					label = "Foudre du pharaon", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
					damage = 13, kbBase = 26, kbGrowth = 48, kbAngle = -45,
					projectile = { speed = 95, angle = -50, gravity = 0, lifetime = 0.6, size = 1.8, color = GOLD, visual = { shape = "block", size = 1.6, color = GOLD, neon = true, spin = 12 } },
					status = { name = "stunned", duration = 1 },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 50, 0, 0 }, LK = { -85, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 34, 0, 12 }, RE = { 4, 0, 0 }, RW = { 0, 0, 0 }, LS = { -26, 0, -48 }, LE = { 30, 0, 0 }, RH = { 16, 0, 0 }, RK = { -46, 0, 0 }, LH = { 54, 0, 0 }, LK = { -88, 0, 0 } },
					fx = { { "beam", color = GOLD, length = 10, width = 1.2, at = "hand" }, { "burst", color = GOLD, size = 2, at = "hand" } }, text = "FOUDRE !", hitText = "ZAP !",
				},
				-- Y : pétrification, il lève le sceptre, l'œil d'Horus s'ouvre en grand et tout le couloir est changé en statues de sable
				SUPER = {
					label = "Pétrification !", startup = 0.42, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(14, 7, 7, 1), kbBase = 40, kbGrowth = 80, kbAngle = 35,
					status = { name = "statue", duration = 3 },
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, 0.05, -0.2 }, Waist = { -12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 180, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 0 }, LE = { 0, 0, 0 }, LW = { -80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 0, 0, 0, 0.08, -0.24 }, Waist = { -14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 186, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 98, 0, 0 }, LE = { 0, 0, 0 }, LW = { -85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.3, shake = true, windupFx = { "super", { "symbols", symbols = { "𓂀" }, color = GOLD, count = 6, radius = 3, at = "above" } },
					fx = { { "screen", color = GOLD, alpha = 0.3 }, { "beam", color = GOLD, length = 16, width = 4, at = "hand" }, { "ring", color = SAND, radius = 7, at = "front" }, { "shake", amount = 0.5 } },
					text = "SOYEZ STATUES !", hitText = "PÉTRIFIÉ !",
				},
				-- →Y : char solaire, un char doré tiré par deux scarabées surgit sous ses pantoufles et traverse le couloir à fond, lui cramponné au sceptre
				SUPER_side = {
					label = "Char solaire !", startup = 0.4, active = 0.36, recovery = 0.7,
					damage = 25, hitbox = box(14, 6, 7, 1), kbBase = 48, kbGrowth = 98, kbAngle = 30, selfVelocity = Vector2.new(70, 0), armor = true,
					windup = { Root = { 6, 0, 0, 0, -0.4, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.25, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 100, 0, -20 }, LE = { 60, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -16, 0, 0, 0, -0.27, -0.36 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 104, 0, -22 }, LE = { 60, 0, 0 }, LW = { -44, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					shake = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🪲", "☀️", "🪲" }, color = GOLD, count = 6, radius = 3 } },
					fx = { "dust", { "beam", color = GOLD, length = 16, width = 4, at = "feet" }, { "ring", color = GOLD, radius = 6, at = "front" }, { "particles", tex = "smoke", color = SAND, dir = "front", at = "feet", time = 0.5, speed = 20, size = 1.2, rate = 100 }, { "shake", amount = 0.6 } },
					text = "EN AVANT, SCARABÉES !", hitText = "ÉCRASÉ PAR LE CHAR !",
				},
				-- ↑Y : pyramide, il plante le sceptre et une pyramide entière sort du sol sous le couloir, pointe en premier, tout le monde au sommet
				SUPER_up = {
					label = "Pyramide !", startup = 0.42, active = 0.3, recovery = 0.75,
					damage = 24, hitbox = box(14, 14, 7, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 50),
					windup = { Root = { 8, 0, 0, 0, -0.5, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.85, -0.2 }, Waist = { -26, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 14, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 186, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -10 }, LE = { 0, 0, 0 }, RH = { 30, 0, 10 }, RK = { -70, 0, 0 }, LH = { 30, 0, -10 }, LK = { -70, 0, 0 } },
					hold = 0.2, shake = true, windupFx = { "super" },
					fx = { { "pillar", color = SAND, height = 24, width = 8, at = "front" }, { "burst", color = GOLD, size = 5, at = "front" }, { "toss", shape = "flat", color = SAND, size = 1, count = 8, speed = 24 }, { "symbols", symbols = { "🔺", "𓂀" }, color = GOLD, count = 5, radius = 4, at = "above" }, { "shake", amount = 0.8 } },
					text = "PYRAMIDE !", hitText = "AU SOMMET !",
				},
				-- ↓Y : sables mouvants, il trace un cercle dans le sable avec le sceptre et tout le couloir s'enfonce : les pieds collés, impossible de bouger
				SUPER_down = {
					label = "Sables mouvants !", startup = 0.4, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 40, kbGrowth = 80, kbAngle = 60,
					status = { name = "rooted", duration = 2.5 },
					windup = { Root = { -6, -40, 0, 0, -0.6, 0.1 }, Waist = { -12, -36, 0 }, Neck = { 0, 30, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -12, 40, 0, 0, -0.85, -0.1 }, Waist = { -18, 44, 0 }, Neck = { 0, -30, 0 }, RS = { 50, 0, -40 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					follow = { Root = { 4, 0, 0, 0, -0.3, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					hold = 0.25, spin = { axis = "y", degrees = 360 }, trail = "prop", windupFx = { "super" },
					fx = { { "puddle", color = SAND, width = 16, time = 2.5 }, { "ring", color = SAND, radius = 8, at = "front" }, { "particles", tex = "smoke", color = SAND, dir = "up", at = "front", time = 0.5, speed = 8, size = 1, rate = 80 }, { "shake", amount = 0.5 } },
					text = "ENGLOUTIS !", hitText = "ENSABLÉ JUSQU'AU COU !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_neutral", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				K_side = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

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
		-- La Piqûre (→Y) : il sort de ses bandelettes une seringue géante, la secoue, chasse la bulle d'air d'une pichenette…
		-- et la lance comme un javelot : elle file à travers le couloir et pique l'adversaire, qui s'engourdit
		SUPER_side = {
			label = "La Piqûre !", kind = "projectile", startup = 0.42, active = 0, recovery = 0.7,
			damage = 25, kbBase = 46, kbGrowth = 96, kbAngle = 30,
			projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.9, size = 3.4, color = SERUM, pierce = true, visual = SYRINGE_GIANT },
			status = { name = "slowed", duration = 2.5 },
			windup = { Root = { 6, -30, 0, 0, -0.25, 0.3 }, Waist = { 10, -34, 0 }, Neck = { 12, 24, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 110, 0, 0 }, LW = { -30, 0, 0 } },
			strike = { Root = { -16, 26, 0, 0, -0.35, -0.5 }, Waist = { -18, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -18, 30, 0, 0, -0.37, -0.55 }, Waist = { -22, 34, 0 }, Neck = { -8, -20, 0 }, RS = { 100, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
			shake = true, hideProp = "thermometre", windupFx = { "super", { "symbols", symbols = { "💉", "🫧" }, color = SERUM, count = 5, radius = 3, at = "hand" } },
			fx = { { "burst", color = SERUM, size = 3, at = "hand" }, { "beam", color = SERUM, length = 14, width = 1.5, at = "hand" }, { "shake", amount = 0.4 } },
			text = "ÇA NE FERA PAS MAL…", hitText = "AÏE ! ÇA FAIT MAL !",
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

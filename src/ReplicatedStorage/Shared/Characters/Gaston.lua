-- Gaston le Magnifique : magicien de cabaret raté, cape trop grande, haut-de-forme habité par un lapin grognon,
-- baguette qui crépite. Rien ne se passe jamais comme prévu. Arme sortie de la Caisse Bizarre : Baguette de
-- Magie & Chapeau (le chapeau est toujours sur sa tête, la baguette n'apparaît qu'une fois la caisse ouverte).
--
-- Mécanique « tricks » (Tours ratés) : chacun de ses spéciaux (S_*) a 3 résultats possibles (variants), dans
-- l'ordre des icônes du passif : 🕊️ colombe, 💥 confettis explosifs, 🐇 lapin agressif. Le prochain résultat est
-- affiché au-dessus de lui (NextTrick) pour garder de la stratégie. L'animation reste la même, seul l'effet change.
-- Format des coups, poses et effets : voir Gege.lua et docs/fiche-perso.md.
-- Signatures (L) et Supers (Y) « sûrs de toucher » : couloirs de 16 studs, projectiles qui visent l'adversaire
-- (les projectiles des variants portent eux-mêmes aimed = true), ↑L = envol en diagonale très puissant (il vole :
-- flying = true) ; plus aucun coût.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local MAGIC = Color3.fromRGB(190, 110, 255)
local SPARK = Color3.fromRGB(255, 235, 120)
local TUX = Color3.fromRGB(28, 26, 38)
local VELVET = Color3.fromRGB(190, 25, 45)
local SATIN = Color3.fromRGB(95, 40, 130)
local WHITE = Color3.fromRGB(245, 245, 250)
local SKIN = Color3.fromRGB(245, 205, 175)
local RABBIT = Color3.fromRGB(215, 215, 220)
local PINK = Color3.fromRGB(255, 160, 185)
local GOLD = Color3.fromRGB(235, 190, 60)
local SMOKE = Color3.fromRGB(170, 170, 185)

-- Projectiles décrits (voir client/Fx.lua buildCustomProjectile)
local CARD = { shape = "ball", size = 0.1, color = WHITE, spin = 18, parts = {
	{ "block", Vector3.new(0.9, 1.25, 0.08), Vector3.new(0, 0, 0), WHITE },
	{ "block", Vector3.new(0.35, 0.35, 0.1), Vector3.new(0, 0, 0), VELVET },
} }
local DOVE = { shape = "ball", size = 0.9, color = WHITE, parts = {
	{ "ball", Vector3.new(0.55, 0.55, 0.55), Vector3.new(0.55, 0.3, 0), WHITE },
	{ "block", Vector3.new(0.25, 0.12, 0.15), Vector3.new(0.9, 0.28, 0), GOLD },
	{ "block", Vector3.new(0.7, 0.08, 1.6), Vector3.new(-0.05, 0.25, 0), WHITE },
} }
local CONFETTI_BOMB = { shape = "ball", size = 1.2, color = MAGIC, neon = true, spin = 8, parts = {
	{ "block", Vector3.new(0.3, 0.3, 0.05), Vector3.new(0.7, 0.3, 0), SPARK },
	{ "block", Vector3.new(0.3, 0.3, 0.05), Vector3.new(-0.6, 0.4, 0), PINK },
	{ "block", Vector3.new(0.3, 0.3, 0.05), Vector3.new(0.1, -0.7, 0), Color3.fromRGB(90, 220, 140) },
} }
local BUNNY = { shape = "ball", size = 1.3, color = RABBIT, parts = {
	{ "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0.55, 0.55, 0), RABBIT },
	{ "ball", Vector3.new(0.22, 0.9, 0.18), Vector3.new(0.45, 1.3, 0.15), RABBIT },
	{ "ball", Vector3.new(0.22, 0.9, 0.18), Vector3.new(0.7, 1.25, -0.15), RABBIT },
	{ "block", Vector3.new(0.12, 0.2, 0.1), Vector3.new(0.95, 0.4, 0), WHITE },
} }
local HAT = { shape = "disc", size = 1.9, color = TUX, spin = 14, parts = {
	{ "block", Vector3.new(1, 1.1, 1), Vector3.new(0, 0.5, 0), TUX },
	{ "block", Vector3.new(1.05, 0.25, 1.05), Vector3.new(0, 0.15, 0), VELVET },
} }

local CRYSTAL = Color3.fromRGB(150, 200, 255) -- boule de cristal (arme n° 3)
local SAW = Color3.fromRGB(200, 205, 215) -- scie de la boîte à scier (arme n° 2)
-- Boule de cristal lancée (projectile de l'arme n° 3)
local ORB = { shape = "ball", size = 1.5, color = CRYSTAL, neon = true, spin = 6, parts = {
	{ "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, 0.45, 0), WHITE },
	{ "cyl", Vector3.new(0.3, 0.9, 0.9), Vector3.new(0, -0.8, 0), GOLD },
} }
-- Lame de scie circulaire (projectile de la boîte)
local SAWBLADE = { shape = "ball", size = 0.3, color = SAW, spin = 20, parts = {
	{ "cyl", Vector3.new(0.12, 2.6, 2.6), Vector3.new(0, 0, 0), SAW },
	{ "block", Vector3.new(0.14, 3.0, 0.4), Vector3.new(0, 0, 0), SAW },
	{ "block", Vector3.new(0.14, 0.4, 3.0), Vector3.new(0, 0, 0), SAW },
	{ "cyl", Vector3.new(0.16, 0.6, 0.6), Vector3.new(0, 0, 0), VELVET },
} }

local data = {
	id = "Gaston",
	name = "Gaston le Magnifique",
	costume = "Gaston",
	style = "magician",
	flying = true, -- sait voler : un saut en l\'air de plus, plané, et un ↑L très puissant

	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : la magie à mains vides
	-- Ses propres J / K et ses combos sans baguette : Gaston gifle au gant blanc, sort une pièce de l'oreille d'autrui,
	-- hypnotise du bout des doigts, détache son pouce, se tord le buste à l'impossible et finit en « Ta-daaa ! ».
	bare = {
		moves = {
			-- J : gifle au gant blanc, comme pour provoquer en duel
			P_neutral = {
				label = "Gifle au gant blanc", startup = 0.07, active = 0.08, recovery = 0.16,
				damage = 5, hitbox = box(4, 3, 2.6, 1), kbBase = 18, kbGrowth = 22, kbAngle = 25,
				windup = { Root = { -4, 20, 0, 0, 0, 0.1 }, Waist = { -4, 22, 0 }, Neck = { -10, -20, 0 }, RS = { 90, 0, -50 }, RE = { 60, 0, 0 }, RW = { 20, 0, 0 }, LS = { 0, 0, -10 }, LE = { 90, 0, 0 } },
				strike = { Root = { -6, -14, 0, 0, -0.05, -0.2 }, Waist = { -6, -18, 0 }, Neck = { -14, 10, 0 }, RS = { 95, 0, 40 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 0, 0, -10 }, LE = { 100, 0, 0 } },
				follow = { Root = { -7, -18, 0, 0, -0.05, -0.22 }, Waist = { -7, -22, 0 }, Neck = { -16, 12, 0 }, RS = { 92, 0, 56 }, RE = { 14, 0, 0 }, RW = { -30, 0, 0 }, LS = { 0, 0, -10 }, LE = { 100, 0, 0 } },
				trail = "rightHand", hitText = "EN GARDE !",
			},
			-- J J : il passe la main derrière l'oreille de l'adversaire et en sort une pièce… en lui tirant l'oreille
			P_combo2 = {
				label = "Pièce derrière l'oreille", startup = 0.06, active = 0.1, recovery = 0.16,
				damage = 6, hitbox = box(4, 3, 2.6, 1.4), kbBase = 20, kbGrowth = 24, kbAngle = 35,
				windup = { Root = { 0, -10, 0, 0, 0, 0.05 }, Waist = { 0, -12, 0 }, Neck = { 0, 10, 0 }, RS = { 20, 0, 10 }, RE = { 40, 0, 0 }, LS = { 120, 0, -40 }, LE = { 60, 0, 0 }, LW = { 30, 0, 0 } },
				strike = { Root = { -6, 10, 0, 0, -0.05, -0.25 }, Waist = { -6, 12, 0 }, Neck = { -6, -10, 0 }, RS = { 20, 0, 10 }, RE = { 40, 0, 0 }, LS = { 130, 0, 10 }, LE = { 70, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
				follow = { Root = { -4, 6, 0, 0, -0.05, -0.2 }, Waist = { -4, 8, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 40, 0, 0 }, LS = { 150, 0, -20 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
				trail = "bothHands", fx = { { "symbols", symbols = { "🪙" }, color = GOLD, count = 2, radius = 2 } }, hitText = "TIENS, UNE PIÈCE !",
			},
			-- J J J : jazz hands : les deux mains grandes ouvertes jaillissent vers l'avant, étincelles comprises
			P_combo3 = {
				label = "Ta-daaa !", startup = 0.12, active = 0.12, recovery = 0.28,
				damage = 8, hitbox = box(5, 4, 2.6, 1), kbBase = 26, kbGrowth = 46, kbAngle = 38, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { 6, 0, 0, 0, -0.35, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 10 }, RE = { 130, 0, 0 }, LS = { 30, 0, -10 }, LE = { 130, 0, 0 } },
				strike = { Root = { -10, 0, 0, 0, 0, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 50 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 120, 0, -50 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
				follow = { Root = { -12, 0, 0, 0, 0, -0.32 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 126, 0, 60 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 126, 0, -60 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
				hold = 0.1, trail = "bothHands", fx = { { "burst", color = SPARK, size = 2.5, at = "front" }, { "text", text = "TA-DAAA !", color = GOLD, at = "head" } }, hitText = "APPLAUDISSEZ !",
			},
			-- J K : le tour du pouce détaché : il « arrache » son pouce gauche et frappe du poing droit pendant la distraction
			PK_combo = {
				label = "Pouce détaché", startup = 0.1, active = 0.1, recovery = 0.24,
				damage = 7, hitbox = box(4.5, 3, 2.8, 0.8), kbBase = 24, kbGrowth = 40, kbAngle = 30,
				windup = { Root = { 0, 10, 0, 0, -0.05, 0.05 }, Waist = { 0, 10, 0 }, Neck = { 20, 10, 0 }, RS = { 50, 0, -20 }, RE = { 100, 0, 0 }, LS = { 50, 0, 20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -6, -12, 0, 0, -0.1, -0.3 }, Waist = { -6, -16, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, LS = { 50, 0, -60 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -7, -14, 0, 0, -0.1, -0.32 }, Waist = { -7, -18, 0 }, Neck = { -8, 0, 0 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, LS = { 54, 0, -64 }, LE = { 94, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				trail = "rightHand", fx = { { "text", text = "MON POUCE !", color = WHITE, at = "head" } }, hitText = "DISTRAIT !",
			},
			-- K K : grand écart de music-hall, raté : les deux jambes partent chacune de son côté
			K_combo2 = {
				label = "Grand écart raté", startup = 0.1, active = 0.18, recovery = 0.3,
				damage = 8, hits = 2, hitbox = box(6.5, 2.5, 1.2, -1.2), kbBase = 24, kbGrowth = 42, kbAngle = 50,
				windup = { Root = { 0, 0, 0, 0, 0.1, 0.05 }, Waist = { -4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 30 }, RE = { 10, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 } },
				strike = { Root = { 0, 0, 0, 0, -1.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, LH = { -80, 0, 0 }, LK = { 0, 0, 0 } },
				follow = { Root = { 0, 0, 0, 0, -1.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 94, 0, 94 }, RE = { 0, 0, 0 }, LS = { 94, 0, -94 }, LE = { 0, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, LH = { -84, 0, 0 }, LK = { 0, 0, 0 } },
				trail = "rightLeg", fx = { { "text", text = "CRAC… MON PANTALON !", color = WHITE, at = "head" } }, hitText = "SCRATCH !",
			},
			-- K J : hypnose : il fait tourner ses doigts devant les yeux de l'adversaire puis lui pique le front
			KP_combo = {
				label = "Regardez mes doigts…", startup = 0.12, active = 0.1, recovery = 0.24,
				damage = 7, hitbox = box(4, 3, 2.6, 1.6), kbBase = 22, kbGrowth = 40, kbAngle = 30,
				windup = { Root = { 0, 0, 0, 0, 0, 0.05 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 30 }, LS = { 100, 0, -20 }, LE = { 60, 0, 0 }, LW = { 0, 0, -30 } },
				strike = { Root = { -6, 0, 0, 0, -0.05, -0.25 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 105, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, -20 }, LS = { 90, 0, -30 }, LE = { 70, 0, 0 }, LW = { 0, 0, 30 } },
				follow = { Root = { -7, 0, 0, 0, -0.05, -0.27 }, Waist = { -9, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 106, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 20 }, LS = { 92, 0, -32 }, LE = { 72, 0, 0 }, LW = { 0, 0, -30 } },
				fx = { { "symbols", symbols = { "🌀", "💫" }, color = MAGIC, count = 5, radius = 3 } }, hitText = "DORMEZ !",
			},
			-- K K J : torsion impossible : il fait faire un tour complet à son buste, bras en hélice (finition)
			KKP_combo = {
				label = "Torsion impossible", startup = 0.12, active = 0.24, recovery = 0.34,
				damage = 10, hits = 3, hitbox = box(6, 4, 1.6, 0.8), kbBase = 30, kbGrowth = 58, kbAngle = 45,
				windup = { Root = { 0, 0, 0, 0, -0.2, 0.05 }, Waist = { 0, 60, 0 }, Neck = { 0, -40, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 } },
				strike = { Root = { 0, 0, 0, 0, -0.2, -0.2 }, Waist = { 0, -90, 0 }, Neck = { 0, 60, 0 }, RS = { 90, 0, 100 }, RE = { 0, 0, 0 }, LS = { 90, 0, -100 }, LE = { 0, 0, 0 } },
				follow = { Root = { 0, 0, 0, 0, -0.2, -0.22 }, Waist = { 0, -100, 0 }, Neck = { 0, 70, 0 }, RS = { 92, 0, 104 }, RE = { 0, 0, 0 }, LS = { 92, 0, -104 }, LE = { 0, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "bothHands", fx = { { "ring", color = MAGIC, radius = 5, at = "root" }, { "text", text = "AUCUN TRUCAGE !", color = SPARK, at = "head" } }, hitText = "IMPOSSIBLE !",
			},
			-- →J : le tour de la nappe : il tire une nappe invisible d'un grand revers de bras
			P_side = {
				label = "Tour de la nappe", startup = 0.1, active = 0.1, recovery = 0.2,
				damage = 7, hitbox = box(5.5, 3, 3, 0.4), kbBase = 22, kbGrowth = 34, kbAngle = 22, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { 0, -30, 0, 0, -0.15, 0.1 }, Waist = { 0, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 60, 0, -40 }, RE = { 20, 0, 0 }, LS = { 60, 0, 40 }, LE = { 20, 0, 0 } },
				strike = { Root = { -4, 30, 0, 0, -0.2, -0.3 }, Waist = { -4, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 70, 0, 90 }, RE = { 0, 0, 0 }, LS = { 70, 0, -90 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -5, 36, 0, 0, -0.2, -0.32 }, Waist = { -5, 40, 0 }, Neck = { 0, -24, 0 }, RS = { 66, 0, 100 }, RE = { 0, 0, 0 }, LS = { 66, 0, -100 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				trail = "bothHands", hitText = "ZIIIP !",
			},
			-- ↓J : accroupi, il noue les lacets de l'adversaire en un tour de main et tire dessus
			P_down = {
				label = "Lacets noués", startup = 0.07, active = 0.1, recovery = 0.18,
				damage = 5, hitbox = box(4, 2, 2.4, -1.4), kbBase = 20, kbGrowth = 24, kbAngle = 70,
				windup = { Root = { 20, 0, 0, 0, -0.85, 0.05 }, Waist = { 20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 20 }, RE = { 40, 0, 0 }, LS = { 60, 0, -20 }, LE = { 40, 0, 0 } },
				strike = { Root = { 6, 0, 0, 0, -0.9, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 10 }, RE = { 100, 0, 0 }, LS = { 30, 0, -10 }, LE = { 100, 0, 0 } },
				follow = { Root = { 4, 0, 0, 0, -0.9, 0.18 }, Waist = { 4, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 20, 0, 14 }, RE = { 110, 0, 0 }, LS = { 20, 0, -14 }, LE = { 110, 0, 0 } },
				trail = "bothHands", hitText = "NOUÉ !",
			},
			-- ↑J : lâcher de colombe invisible : les deux mains jointes s'ouvrent vers le ciel
			P_up = {
				label = "Colombe invisible", startup = 0.09, active = 0.1, recovery = 0.22,
				damage = 6, hitbox = box(4, 5, 1, 3.2), kbBase = 22, kbGrowth = 38, kbAngle = 88,
				windup = { Root = { 6, 0, 0, 0, -0.4, 0.05 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 6 }, RE = { 90, 0, 0 }, LS = { 60, 0, -6 }, LE = { 90, 0, 0 } },
				strike = { Root = { -8, 0, 0, 0, 0.05, 0 }, Waist = { -10, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 170, 0, 6 }, RE = { 0, 0, 0 }, LS = { 170, 0, -6 }, LE = { 0, 0, 0 } },
				follow = { Root = { -10, 0, 0, 0, 0.05, 0 }, Waist = { -12, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 160, 0, 40 }, RE = { 0, 0, 0 }, LS = { 160, 0, -40 }, LE = { 0, 0, 0 } },
				trail = "bothHands", fx = { { "symbols", symbols = { "🕊️" }, color = WHITE, count = 2, radius = 2 } }, hitText = "ENVOLÉE !",
			},
			-- J en l'air : « rideau ! » : les deux bras retombent comme un rideau de scène sur l'adversaire
			P_air = {
				label = "Rideau !", startup = 0.1, active = 0.12, recovery = 0.2,
				damage = 7, hitbox = box(5, 4, 1, -1), kbBase = 20, kbGrowth = 32, kbAngle = -45,
				windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 175, 0, 20 }, RE = { 0, 0, 0 }, LS = { 175, 0, -20 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 20, 0, 0 }, LK = { -40, 0, 0 } },
				strike = { Root = { 20, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -30, 0, 0 }, LH = { 40, 0, 0 }, LK = { -30, 0, 0 } },
				follow = { Root = { 22, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 30, 0, 8 }, RE = { 0, 0, 0 }, LS = { 30, 0, -8 }, LE = { 0, 0, 0 }, RH = { 44, 0, 0 }, RK = { -30, 0, 0 }, LH = { 44, 0, 0 }, LK = { -30, 0, 0 } },
				trail = "bothHands", fx = { { "particles", tex = "spark", color = VELVET, dir = "down", at = "hand", time = 0.3 } }, hitText = "FIN DU SPECTACLE !",
			},
			-- dash J : entrée en scène : il déboule bras grands ouverts pour saluer un public imaginaire
			P_dash = {
				label = "Entrée en scène", startup = 0.08, active = 0.16, recovery = 0.24,
				damage = 7, hitbox = box(5, 3.5, 2.4, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 30, selfVelocity = Vector2.new(34, 0),
				windup = { Root = { -6, 0, 0, 0, -0.1, 0.15 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 20, 0, -20 }, LE = { 60, 0, 0 } },
				strike = { Root = { 6, 0, 0, 0, -0.15, -0.35 }, Waist = { 4, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 110, 0, 80 }, RE = { 0, 0, 0 }, LS = { 110, 0, -80 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { 8, 0, 0, 0, -0.15, -0.38 }, Waist = { 6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 114, 0, 86 }, RE = { 0, 0, 0 }, LS = { 114, 0, -86 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
				fx = { { "symbols", symbols = { "⭐", "✨" }, color = SPARK, count = 4, radius = 3 } }, hitText = "MESDAMES, MESSIEURS !",
			},
			-- K : pointe de danseuse : un petit coup de pied tendu, pointe vernie bien dressée
			K_neutral = {
				label = "Pointe de danseuse", startup = 0.1, active = 0.1, recovery = 0.22,
				damage = 7, hitbox = box(4.5, 3, 2.8, 0), kbBase = 22, kbGrowth = 40, kbAngle = 32,
				windup = { Root = { -4, 0, 0, 0, 0.1, 0.05 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 140, 0, 30 }, RE = { 30, 0, 0 }, LS = { 140, 0, -30 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, RA = { -30, 0, 0 } },
				strike = { Root = { -10, 0, 0, 0, 0.15, -0.05 }, Waist = { -8, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { -40, 0, 0 } },
				follow = { Root = { -12, 0, 0, 0, 0.15, -0.06 }, Waist = { -10, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 152, 0, 44 }, RE = { 20, 0, 0 }, LS = { 152, 0, -44 }, LE = { 20, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { -44, 0, 0 } },
				trail = "rightFoot", hitText = "PLIÉ-TOC !",
			},
			-- →K : il pivote sur lui-même et ses pans de queue-de-pie fouettent l'adversaire
			K_side = {
				label = "Queue-de-pie fouettée", startup = 0.12, active = 0.14, recovery = 0.26,
				damage = 8, hitbox = box(5.5, 3, 2.6, 0), kbBase = 26, kbGrowth = 46, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
				windup = { Root = { 0, 40, 0, 0, -0.1, 0.1 }, Waist = { 0, 30, 0 }, Neck = { 0, -30, 0 }, RS = { 20, 0, 70 }, RE = { 60, 0, 0 }, LS = { 20, 0, -70 }, LE = { 60, 0, 0 } },
				strike = { Root = { 10, -40, 0, 0, -0.15, -0.25 }, Waist = { 6, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 30, 0, 90 }, RE = { 20, 0, 0 }, LS = { 30, 0, -90 }, LE = { 20, 0, 0 }, RH = { -40, 0, 30 }, RK = { -40, 0, 0 } },
				follow = { Root = { 12, -50, 0, 0, -0.15, -0.28 }, Waist = { 8, -36, 0 }, Neck = { 0, 34, 0 }, RS = { 32, 0, 94 }, RE = { 20, 0, 0 }, LS = { 32, 0, -94 }, LE = { 20, 0, 0 }, RH = { -44, 0, 34 }, RK = { -44, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "body", hitText = "FLOUTCH !",
			},
			-- ↓K : balayette des coulisses : il s'enfonce comme dans une trappe et fauche au ras des planches
			K_down = {
				label = "Balayette des coulisses", startup = 0.12, active = 0.14, recovery = 0.3,
				damage = 8, hitbox = box(6, 2, 2.8, -1.5), kbBase = 26, kbGrowth = 44, kbAngle = 75,
				windup = { Root = { 0, 20, 0, 0, -0.9, 0 }, Waist = { 10, 20, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 0, 0, 0 } },
				strike = { Root = { 6, -30, 0, 0, -1.05, -0.1 }, Waist = { 10, -20, 0 }, Neck = { 10, 10, 0 }, RS = { 60, 0, 80 }, RE = { 10, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 }, RH = { 80, 0, 20 }, RK = { -4, 0, 0 }, LH = { 0, 0, 0 }, LK = { -120, 0, 0 } },
				follow = { Root = { 8, -40, 0, 0, -1.05, -0.12 }, Waist = { 12, -24, 0 }, Neck = { 10, 12, 0 }, RS = { 56, 0, 84 }, RE = { 10, 0, 0 }, LS = { 56, 0, -84 }, LE = { 10, 0, 0 }, RH = { 84, 0, 24 }, RK = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { -120, 0, 0 } },
				trail = "rightFoot", fx = { { "particles", tex = "smoke", color = SMOKE, dir = "up", at = "feet", time = 0.3 } }, hitText = "PSSHT !",
			},
			-- ↑K : bond de lapin : il saute pieds joints, les deux talons remontent vers le ciel
			K_up = {
				label = "Bond de lapin", startup = 0.12, active = 0.12, recovery = 0.3,
				damage = 9, hitbox = box(4, 6, 0.8, 3), kbBase = 26, kbGrowth = 52, kbAngle = 88, selfVelocity = Vector2.new(0, 16),
				windup = { Root = { 10, 0, 0, 0, -0.7, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, LW = { 60, 0, 0 } },
				strike = { Root = { -40, 0, 0, 0, 0.2, 0.1 }, Waist = { -14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 10 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 70, 0, -10 }, LE = { 110, 0, 0 }, LW = { 60, 0, 0 }, RH = { 130, 0, 6 }, RK = { -10, 0, 0 }, LH = { 130, 0, -6 }, LK = { -10, 0, 0 } },
				follow = { Root = { -44, 0, 0, 0, 0.2, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 72, 0, 12 }, RE = { 112, 0, 0 }, RW = { 60, 0, 0 }, LS = { 72, 0, -12 }, LE = { 112, 0, 0 }, LW = { 60, 0, 0 }, RH = { 134, 0, 4 }, RK = { -6, 0, 0 }, LH = { 134, 0, -4 }, LK = { -6, 0, 0 } },
				trail = "rightFoot", fx = { { "symbols", symbols = { "🐇" }, color = RABBIT, count = 1, radius = 1 } }, hitText = "BOING-LAPIN !",
			},
			-- K en l'air : ciseaux de l'assistante : les jambes se croisent et se décroisent comme une scie (deux coups)
			K_air = {
				label = "Ciseaux de scène", startup = 0.1, active = 0.2, recovery = 0.22,
				damage = 8, hits = 2, hitbox = box(5, 3.5, 2, -0.8), kbBase = 22, kbGrowth = 38, kbAngle = 38,
				windup = { Root = { -14, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 70 }, RE = { 30, 0, 0 }, LS = { 60, 0, -70 }, LE = { 30, 0, 0 }, RH = { 100, 0, 30 }, RK = { 0, 0, 0 }, LH = { 40, 0, -30 }, LK = { 0, 0, 0 } },
				strike = { Root = { -16, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 64, 0, 74 }, RE = { 30, 0, 0 }, LS = { 64, 0, -74 }, LE = { 30, 0, 0 }, RH = { 40, 0, -20 }, RK = { 0, 0, 0 }, LH = { 100, 0, 20 }, LK = { 0, 0, 0 } },
				follow = { Root = { -16, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 64, 0, 74 }, RE = { 30, 0, 0 }, LS = { 64, 0, -74 }, LE = { 30, 0, 0 }, RH = { 100, 0, 30 }, RK = { 0, 0, 0 }, LH = { 40, 0, -30 }, LK = { 0, 0, 0 } },
				trail = "leftFoot", hitText = "CRIC-CRAC !",
			},
			-- dash K : moonwalk… à l'envers : il glisse en avant sur les pointes puis donne un coup de talon
			K_dash = {
				label = "Moonwalk à l'envers", startup = 0.1, active = 0.22, recovery = 0.3,
				damage = 9, hitbox = box(5.5, 3, 2.8, -0.2), kbBase = 28, kbGrowth = 52, kbAngle = 35, selfVelocity = Vector2.new(44, 0),
				windup = { Root = { -6, 0, 0, 0, 0.05, 0.1 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 90, 0, 0 }, LS = { 0, 0, -10 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, RA = { -40, 0, 0 } },
				strike = { Root = { -14, 0, 0, 0, 0.1, -0.2 }, Waist = { -8, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 30, 0, 20 }, RE = { 100, 0, 0 }, LS = { 30, 0, -40 }, LE = { 20, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { -16, 0, 0, 0, 0.1, -0.22 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 32, 0, 22 }, RE = { 102, 0, 0 }, LS = { 32, 0, -44 }, LE = { 20, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 } },
				trail = "rightFoot", fx = { "dust" }, hitText = "HI-HI !",
			},
		},
		-- Combos à mains nues : J J J (gant, pièce, Ta-daaa !), J K J (pouce détaché puis hypnose), K K J (grand écart,
		-- torsion impossible), →J →K (nappe puis queue-de-pie). Un S pour finir envoie le spécial du perso.
		links = {
			P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_neutral" },
			P_combo2 = { P = "P_combo3", K = "KP_combo", S = "S_side" },
			P_combo3 = { S = "S_up" },
			PK_combo = { P = "KP_combo", K = "K_up", S = "S_down" },
			K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_side" },
			K_combo2 = { P = "KKP_combo", down_K = "K_down", S = "S_down" },
			KP_combo = { P = "P_combo3", S = "S_neutral" },
			KKP_combo = { S = "S_side" },
			P_side = { K = "K_side", P = "P_combo2", S = "S_side" },
			K_side = { K = "K_combo2", S = "S_side" },
			P_down = { K = "K_down", P = "PK_combo", S = "S_down" },
			K_down = { P = "P_up", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			P_dash = { P = "P_combo3", K = "K_side", S = "S_side" },
			K_dash = { K = "K_up", P = "KKP_combo", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la baguette et le chapeau (ses coups sont ceux de moves). n° 2 : la boîte à scier en deux, lourde et lente, qui
	-- encaisse pendant les spéciaux et éjecte loin (avec des tours ratés à 3 fins). n° 3 : la boule de cristal, rapide, lancée,
	-- roulée, jonglée, et des prédictions qui ne se réalisent jamais comme prévu.
	weapons = {
		{ id = "baguette", name = "Baguette magique & chapeau", icon = "🪄",
			ability = { superCooldown = 0.6, text = "Supers rechargés 40 % plus vite" } },
		{ id = "boite", name = "Boîte à scier en deux", icon = "🪚",
			prop = { name = "PropBoite", hand = "Right", pieces = {
				{ "Caisse", "", "block", Vector3.new(1.4, 1.1, 2.2), Vector3.new(0, -1.1, 0), Vector3.new(0, 0, 0), TUX, "Wood" },
				{ "Liseret", "", "block", Vector3.new(1.45, 0.15, 2.25), Vector3.new(0, -0.6, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
				{ "Etoile", "", "ball", Vector3.new(0.4, 0.4, 0.06), Vector3.new(-0.72, -1.1, 0), Vector3.new(0, 0, 0), SPARK, "Neon" },
				{ "Scie", "", "block", Vector3.new(0.06, 0.9, 1.6), Vector3.new(0.75, -1.0, 0), Vector3.new(0, 0, 0), SAW, "Metal" },
				{ "PoigneeScie", "", "block", Vector3.new(0.2, 0.3, 0.5), Vector3.new(0.75, -0.4, 0.5), Vector3.new(0, 0, 0), VELVET, "Wood" },
				{ "Pieds", "", "block", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0, -1.75, 0.95), Vector3.new(0, 0, 0), PINK, "SmoothPlastic" },
			} },
			ability = { armor = true, text = "Ses spéciaux encaissent sans broncher" },
			moves = {
				-- J : coin de boîte, il pique l'adversaire du coin de la boîte comme avec une valise trop lourde
				P_neutral = {
					label = "Coin de boîte", startup = 0.1, active = 0.08, recovery = 0.16,
					damage = 7, hitbox = box(4.5, 3.5, 2.8, 0.6), kbBase = 24, kbGrowth = 30, kbAngle = 25,
					windup = { Root = { 4, -16, 0, 0, -0.2, 0.15 }, Waist = { 6, -18, 0 }, Neck = { 6, 12, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, 14, 0, 0, -0.28, -0.3 }, Waist = { -8, 16, 0 }, Neck = { -4, -8, 0 }, RS = { 86, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -8, 16, 0, 0, -0.28, -0.34 }, Waist = { -8, 18, 0 }, Neck = { -4, -10, 0 }, RS = { 82, 0, -4 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -74 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", hitText = "TOC !",
				},
				-- →J : il pousse la boîte en avant à deux mains comme un déménageur pressé
				P_side = {
					label = "Boîte en avant", startup = 0.11, active = 0.1, recovery = 0.2,
					damage = 8, hitbox = box(5, 4, 3, 0.5), kbBase = 26, kbGrowth = 40, kbAngle = 22, selfVelocity = Vector2.new(16, 0),
					windup = { Root = { 6, 0, 0, 0, -0.25, 0.25 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.35, -0.4 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 0, 0, 0, -0.36, -0.45 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 96, 0, 0 }, LE = { 0, 0, 0 }, LW = { -8, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- ↓J : il laisse tomber la boîte sur les orteils de l'adversaire, qui bondit de douleur
				P_down = {
					label = "Boîte sur les orteils", startup = 0.1, active = 0.1, recovery = 0.22,
					damage = 6, hitbox = box(5, 2.5, 3, -1.6), kbBase = 26, kbGrowth = 28, kbAngle = 78,
					windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.85, -0.2 }, Waist = { -26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -16, 0, 0, 0, -0.9, -0.24 }, Waist = { -28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 34, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -42 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { "dust" }, hitText = "AÏE MES ORTEILS !",
				},
				-- ↑J : le couvercle claque vers le haut et cogne le menton de qui passe au-dessus
				P_up = {
					label = "Couvercle claqué", startup = 0.1, active = 0.12, recovery = 0.22,
					damage = 7, hitbox = box(4.5, 5.5, 1.5, 3.5), kbBase = 28, kbGrowth = 32, kbAngle = 85,
					windup = { Root = { 4, 0, 0, 0, -0.4, 0.1 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.1, -0.1 }, Waist = { -12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 160, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 20, 0, 0 }, LW = { -60, 0, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.12, -0.12 }, Waist = { -14, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 166, 0, 12 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { 156, 0, -12 }, LE = { 20, 0, 0 }, LW = { -80, 0, 0 } },
					trail = "leftHand", fx = { { "burst", color = SPARK, size = 1.5, at = "above" } }, hitText = "CLAC !",
				},
				-- J en l'air : il glisse la boîte sous ses chaussures vernies et tape dessus du talon
				P_air = {
					label = "Boîte sous les pieds", startup = 0.1, active = 0.12, recovery = 0.2,
					damage = 8, hitbox = box(5, 4, 1, -1.5), kbBase = 24, kbGrowth = 40, kbAngle = -40,
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 }, RH = { 10, 0, 5 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, -5 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 16, 0, 10 }, RE = { 4, 0, 0 }, RW = { -10, 0, 0 }, LS = { 36, 0, -54 }, LE = { 30, 0, 0 }, RH = { 6, 0, 5 }, RK = { -14, 0, 0 }, RA = { 20, 0, 0 }, LH = { 6, 0, -5 }, LK = { -14, 0, 0 }, LA = { 20, 0, 0 } },
					trail = "prop", hitText = "BONK !",
				},
				-- dash J : bélier de boîte, il fonce boîte devant comme un bélier de cirque
				P_dash = {
					label = "Bélier de boîte", startup = 0.08, active = 0.14, recovery = 0.24,
					damage = 9, hitbox = box(5, 4, 3, 0.5), kbBase = 30, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(42, 0),
					windup = { Root = { -8, 0, 0, 0, -0.3, 0.1 }, Waist = { -6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.4, -0.35 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
					follow = { Root = { -20, 0, 0, 0, -0.42, -0.4 }, Waist = { -12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 92, 0, -2 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 92, 0, 2 }, LE = { 0, 0, 0 }, LW = { -8, 0, 0 } },
					trail = "prop", fx = { "dust" }, text = "PLACE !", hitText = "BOUM !",
				},
				-- K : grand coup de scie en avant, elle zigzague en vibrant
				K_neutral = {
					label = "Scie en avant", startup = 0.18, active = 0.12, recovery = 0.3,
					damage = 12, hitbox = box(6, 3.5, 3.5, 0.6), kbBase = 30, kbGrowth = 75, kbAngle = 35,
					windup = { Root = { 6, 30, 0, 0, -0.2, 0.15 }, Waist = { 8, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 60, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, -20, 0, 0, -0.3, -0.35 }, Waist = { -12, -24, 0 }, Neck = { 0, 14, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -10 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, -26, 0, 0, -0.3, -0.4 }, Waist = { -14, -30, 0 }, Neck = { 0, 18, 0 }, RS = { 36, 0, 54 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -30 }, LE = { 5, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					wobble = true, trail = "leftHand", fx = { { "particles", tex = "spark", color = SPARK, at = "lhand", dir = "front", time = 0.2, speed = 10 } }, hitText = "ZZZRIC !",
				},
				-- →K : la boîte balancée à deux mains d'arrière en avant, tout le poids du lapin dedans
				K_side = {
					label = "Grand coup de boîte", startup = 0.24, active = 0.12, recovery = 0.36,
					damage = 13, hitbox = box(6, 4, 3.5, 0.5), kbBase = 34, kbGrowth = 88, kbAngle = 32, selfVelocity = Vector2.new(20, 0),
					windup = { Root = { 8, -40, 0, 0, -0.3, 0.3 }, Waist = { 10, -44, 0 }, Neck = { 4, 26, 0 }, RS = { -60, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -20 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -14, 26, 0, 0, -0.4, -0.45 }, Waist = { -16, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 96, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -16, 34, 0, 0, -0.42, -0.5 }, Waist = { -18, 40, 0 }, Neck = { -8, -22, 0 }, RS = { 104, 0, 0 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 102, 0, 0 }, LE = { 6, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					trail = "prop", fx = { { "shake", amount = 0.25 } }, text = "HAN !", hitText = "KRAK !",
				},
				-- ↓K : accroupi, il scie au ras du sol en deux passes, le lapin proteste dans la boîte
				K_down = {
					label = "Scie au ras du sol", startup = 0.16, active = 0.2, recovery = 0.3,
					damage = 6, hits = 2, hitbox = box(7, 2, 3.5, -1.6), kbBase = 26, kbGrowth = 50, kbAngle = 70,
					windup = { Root = { -6, -20, 0, 0, -0.85, 0.1 }, Waist = { -14, -14, 0 }, Neck = { -6, 12, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 16, 0, 0, -0.95, -0.1 }, Waist = { -20, 18, 0 }, Neck = { -6, -8, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -10, -16, 0, 0, -0.95, -0.14 }, Waist = { -20, -18, 0 }, Neck = { -6, 8, 0 }, RS = { 20, 0, 44 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 20 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					wobble = true, trail = "leftHand", fx = { "dust", { "text", text = "GRRR !", color = RABBIT } }, hitText = "ZRIC ZRIC !",
				},
				-- ↑K : il soulève la boîte au-dessus de sa tête comme un haltérophile, les genoux qui tremblent
				K_up = {
					label = "Boîte levée", startup = 0.18, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.6, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -6, 0, 0, 0, 0.1, 0 }, Waist = { -10, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 180, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -8 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					follow = { Root = { -8, 0, 0, 0, 0.12, 0 }, Waist = { -12, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 186, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 186, 0, -10 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					shake = true, trail = "prop", text = "HAN !", hitText = "KLONG !",
				},
				-- K en l'air : il lâche la boîte sous lui, elle s'écrase sur le crâne de l'adversaire
				K_air = {
					label = "Chute de boîte", startup = 0.16, active = 0.14, recovery = 0.26,
					damage = 12, hitbox = box(5, 4, 1.5, -2), kbBase = 28, kbGrowth = 65, kbAngle = -60,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -12 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -8 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -20, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 20, 0, 8 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 20, 0, -8 }, LE = { 6, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", fx = { { "shake", amount = 0.3 } }, hitText = "KRABOUM !",
				},
				-- dash K : il saute sur la boîte et glisse dessus comme sur un traîneau, scie tendue devant (encaisse tout)
				K_dash = {
					label = "Boîte-traîneau", startup = 0.1, active = 0.24, recovery = 0.32,
					damage = 11, hitbox = box(6, 3, 3, -1), kbBase = 30, kbGrowth = 65, kbAngle = 40, selfVelocity = Vector2.new(52, 0), armor = true,
					windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -12, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 100, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, -1.1, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -10 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, RH = { 85, 0, 8 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 85, 0, -8 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, -1.1, 0 }, Waist = { 8, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 20, 0, 22 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -12 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, RH = { 88, 0, 8 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 88, 0, -8 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
					trail = "leftHand", fx = { "dust", { "particles", tex = "spark", color = SPARK, at = "feet", dir = "up", time = 0.3, speed = 8 } }, text = "TRAÎNEAU !", hitText = "SCHRRR !",
				},
				-- L : la femme coupée en deux… sans femme : il pose la boîte sur tout le couloir et scie à grands coups ; 3 fins possibles
				S_neutral = {
					label = "Coupé en deux", startup = 0.22, active = 0.2, recovery = 0.48,
					damage = 14, hitbox = box(14, 6, 7, 1), kbBase = 30, kbGrowth = 60, kbAngle = 38,
					variants = {
						{ label = "Coupé en deux : des colombes en sortent !", damage = 12, kbBase = 24, kbGrowth = 40, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !" },
						{ label = "Coupé en deux : la boîte explose !", damage = 18, kbBase = 36, kbGrowth = 80, hitText = "KABOUM !" },
						{ label = "Coupé en deux : le lapin mord la scie !", damage = 12, kbBase = 26, kbGrowth = 40, status = { name = "rooted", duration = 1.5 }, hitText = "GRRR !" },
					},
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, 30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -14, 20, 0, 0, -0.5, -0.35 }, Waist = { -22, 24, 0 }, Neck = { -6, -14, 0 }, RS = { 60, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, -10, 0, 0, -0.5, -0.4 }, Waist = { -22, -14, 0 }, Neck = { -6, 10, 0 }, RS = { 60, 0, 24 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 10, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.1, wobble = true, trail = "leftHand", windupFx = { { "symbols", symbols = { "🪚", "✨" }, color = SPARK, count = 3, radius = 2, at = "front" } },
					fx = { { "beam", color = SAW, length = 14, width = 1.6, at = "front" }, { "particles", tex = "spark", color = SPARK, at = "front", dir = "all", time = 0.3, speed = 12, rate = 80 }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 3, radius = 3, at = "front" } },
					text = "ET HOP, EN DEUX !", hitText = "ZZZRIIIC !",
				},
				-- →L : la boîte-bélier, il charge boîte devant lui à travers tout le couloir, rien ne l'arrête (super-armure)
				S_side = {
					label = "Boîte-bélier", startup = 0.18, active = 0.4, recovery = 0.5,
					damage = 15, hitbox = box(14, 6, 7, 0), kbBase = 34, kbGrowth = 75, kbAngle = 30, selfVelocity = Vector2.new(60, 0), armor = true,
					windup = { Root = { -10, 0, 0, 0, -0.5, 0.2 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -22, 0, 0, 0, -0.45, -0.5 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -24, 0, 0, 0, -0.47, -0.55 }, Waist = { -16, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { -6, 0, 0 }, LS = { 96, 0, 0 }, LE = { 0, 0, 0 }, LW = { -6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = SMOKE, at = "feet", dir = "up", time = 0.4, speed = 10, rate = 80 }, { "beam", color = GOLD, length = 14, width = 2, at = "front" }, { "shake", amount = 0.25 } },
					text = "CHARGEZ !", hitText = "BLAM-BOÎTE !",
				},
				-- ↓L : il abat la boîte sur les planches : l'onde de choc fait sauter tout le couloir, et la boîte réserve une surprise
				S_down = {
					label = "Boîte abattue", startup = 0.22, active = 0.16, recovery = 0.48,
					damage = 13, hitbox = box(14, 5, 7, 0.5), kbBase = 32, kbGrowth = 60, kbAngle = 80,
					variants = {
						{ label = "Boîte abattue : nuée de colombes", damage = 12, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !" },
						{ label = "Boîte abattue : boîte piégée", damage = 17, kbBase = 40, kbGrowth = 75, hitText = "KABOUM !" },
						{ label = "Boîte abattue : le lapin s'accroche", damage = 12, kbBase = 24, kbGrowth = 40, status = { name = "rooted", duration = 1.5 }, hitText = "GRRR !" },
					},
					windup = { Root = { 10, 0, 0, 0, -0.1, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 186, 0, 14 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -14 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.75, -0.35 }, Waist = { -34, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -20, 0, 0, 0, -0.8, -0.4 }, Waist = { -36, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.12, shake = true, trail = "prop",
					fx = { { "beam", color = GOLD, length = 14, width = 2.5, at = "feet" }, { "ring", color = MAGIC, radius = 6, at = "feet" }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 3, radius = 3, at = "front" }, { "shake", amount = 0.35 } },
					text = "SÉSAME, FERME-TOI !", hitText = "KRAKOUM !",
				},
				-- ↑L : la boîte-catapulte, il s'assoit dans la boîte, le ressort du fond le propulse en diagonale, couvercle au vent
				S_up = {
					label = "Boîte-catapulte", startup = 0.15, active = 0.3, recovery = 0.45,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 52, kbAngle = 78, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 0, 0, 0, 0, -0.9, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.3, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { 60, 0, 5 }, RK = { -100, 0, 0 }, RA = { -20, 0, 0 }, LH = { 60, 0, -5 }, LK = { -100, 0, 0 }, LA = { -20, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.35, -0.15 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 166, 0, 44 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 166, 0, -44 }, LE = { 10, 0, 0 }, RH = { 64, 0, 5 }, RK = { -104, 0, 0 }, RA = { -20, 0, 0 }, LH = { 64, 0, -5 }, LK = { -104, 0, 0 }, LA = { -20, 0, 0 } },
					shake = true, trail = "body", fx = { { "burst", color = SPARK, size = 4, at = "feet" }, { "ring", color = MAGIC, radius = 6, at = "feet" }, { "particles", tex = "spark", color = SPARK, at = "feet", dir = "down", time = 0.4, speed = 16, rate = 100 }, { "symbols", symbols = { "🎩", "✨" }, color = SPARK, count = 4, radius = 3, at = "above" } },
					text = "CATAPULTE !", hitText = "ZWIIING !",
				},
				-- L en l'air : il largue la boîte sur l'adversaire, qui la reçoit sur la tête (le lapin dedans n'apprécie pas)
				S_air = {
					label = "Boîte larguée", kind = "projectile", startup = 0.18, active = 0, recovery = 0.44,
					damage = 14, kbBase = 28, kbGrowth = 55, kbAngle = -50, selfVelocity = Vector2.new(0, 16),
					projectile = { speed = 60, angle = -60, gravity = 60, lifetime = 0.8, size = 2.4, color = TUX,
						visual = { shape = "block", size = 0.3, color = TUX, spin = 4, parts = {
							{ "block", Vector3.new(1.4, 1.1, 2.2), Vector3.new(0, 0, 0), TUX },
							{ "block", Vector3.new(1.45, 0.15, 2.25), Vector3.new(0, 0.5, 0), GOLD },
							{ "block", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0, -0.3, 1.25), PINK },
						} } },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -12 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 30, 0, 12 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -12 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 24, 0, 14 }, RE = { 4, 0, 0 }, RW = { -40, 0, 0 }, LS = { 24, 0, -14 }, LE = { 4, 0, 0 }, LW = { -40, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					hideProp = "boite", fx = { { "burst", color = GOLD, size = 2, at = "hand" }, { "text", text = "GRRR !", color = RABBIT } }, text = "LARGAGE !", hitText = "KRABOUM !",
				},
				-- Y : la Grande Illusion : il referme la boîte sur tout le couloir, tape trois fois du pied… et l'ouvre : surprise (3 fins)
				SUPER = {
					label = "La Grande Illusion !", startup = 0.4, active = 0.2, recovery = 0.7,
					damage = 26, hitbox = box(14, 6, 7, 1), kbBase = 50, kbGrowth = 100, kbAngle = 40, armor = true,
					variants = {
						{ label = "La Grande Illusion : envolés en colombes !", damage = 24, status = { name = "blinded", duration = 2.5 }, hitText = "ROUCOULE !" },
						{ label = "La Grande Illusion : feu d'artifice !", damage = 28, kbBase = 54, kbGrowth = 105, hitText = "KABOUM !" },
						{ label = "La Grande Illusion : changé en lapin !", damage = 24, status = { name = "dog", duration = 2.5 }, hitText = "COUIC ?!" },
					},
					windup = { Root = { 8, 0, 0, 0, -0.2, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 120, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -30 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.45, -0.4 }, Waist = { -24, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { 8, 0, 0, 0, -0.1, 0 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -60 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
					hold = 0.4, shake = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🎩", "✨", "★" }, count = 6, radius = 3, color = SPARK } },
					fx = { { "screen", color = TUX, alpha = 0.45 }, { "beam", color = GOLD, length = 14, width = 6, at = "root", time = 0.5 }, { "burst", color = SPARK, size = 5, at = "front" }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 6, radius = 5, at = "front" }, { "shake", amount = 0.5 } },
					text = "ET MAINTENANT… LA GRANDE ILLUSION !", hitText = "TA-DAAA !",
				},
				-- →Y : la scie circulaire : il décroche la scie, la fait tourner sur un doigt et la lance ; elle traverse tout le couloir en hurlant
				SUPER_side = {
					label = "Scie circulaire !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 46, kbGrowth = 90, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = SAW, visual = SAWBLADE, pierce = true, hits = 2 },
					windup = { Root = { 6, -30, 0, 0, -0.3, 0.25 }, Waist = { 10, -34, 0 }, Neck = { 8, 22, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -20 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -16, 24, 0, 0, -0.36, -0.45 }, Waist = { -18, 28, 0 }, Neck = { -8, -16, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -18, 28, 0, 0, -0.38, -0.5 }, Waist = { -22, 32, 0 }, Neck = { -10, -18, 0 }, RS = { 36, 0, 54 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -6 }, LE = { 4, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					shake = true, windupFx = { "super", { "particles", tex = "spark", color = SPARK, at = "lhand", dir = "all", time = 0.3, speed = 10 } },
					fx = { { "burst", color = SAW, size = 3, at = "lhand" }, { "beam", color = SAW, length = 14, width = 2, at = "lhand" }, { "shake", amount = 0.35 } },
					text = "ZZZRRRIIIING !", hitText = "SCIÉ !",
				},
				-- ↑Y : la boîte-fusée : il saute dans la boîte, allume la mèche, et la boîte décolle à la verticale en vrille, étoiles partout
				SUPER_up = {
					label = "Boîte-fusée !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(14, 12, 7, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, armor = true, selfVelocity = Vector2.new(0, 65),
					windup = { Root = { -6, 0, 0, 0, -0.95, 0 }, Waist = { -20, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 10, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 186, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 10 }, RK = { -100, 0, 0 }, RA = { -20, 0, 0 }, LH = { 60, 0, -10 }, LK = { -100, 0, 0 }, LA = { -20, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 14, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 190, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 190, 0, -12 }, LE = { 0, 0, 0 }, RH = { 64, 0, 12 }, RK = { -104, 0, 0 }, RA = { -20, 0, 0 }, LH = { 64, 0, -12 }, LK = { -104, 0, 0 }, LA = { -20, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 720 }, trail = "prop", windupFx = { "super", { "text", text = "3… 2… 1…", color = SPARK } },
					fx = { { "pillar", color = SPARK, height = 22, width = 3.5, at = "root" }, { "particles", tex = "fire", color = SPARK, dir = "down", at = "feet", time = 0.5, speed = 18, size = 0.9, rate = 110 }, { "burst", color = MAGIC, size = 4, at = "feet" }, { "symbols", symbols = { "✨", "★", "🎩" }, color = SPARK, count = 8, radius = 5, at = "above" }, { "shake", amount = 0.5 } },
					text = "DÉCOLLAGE MAGIQUE !", hitText = "EN ORBITE !",
				},
				-- ↓Y : le tombé de la boîte : il saute très haut, la boîte à bout de bras, et l'écrase sur tout le couloir comme une enclume
				SUPER_down = {
					label = "Tombé de la boîte !", startup = 0.35, active = 0.22, recovery = 0.7,
					damage = 22, hitbox = box(16, 5, 8, 0), kbBase = 42, kbGrowth = 85, kbAngle = 45,
					status = { name = "stunned", duration = 1.5 },
					windup = { Root = { -6, 0, 0, 0, 0.5, 0 }, Waist = { -10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 190, 0, 14 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -14 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.5, 0 }, FL = { 0, 0, 0, 0, 0.5, 0 } },
					strike = { Root = { -22, 0, 0, 0, -0.85, -0.4 }, Waist = { -36, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -24, 0, 0, 0, -0.9, -0.45 }, Waist = { -38, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -10 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hold = 0.25, shake = true, trail = "prop", windupFx = { "super" },
					fx = { { "beam", color = GOLD, length = 16, width = 4, at = "feet" }, { "burst", color = SMOKE, size = 5, at = "front" }, { "ring", color = MAGIC, radius = 8, at = "feet" }, { "symbols", symbols = { "💫", "★" }, color = SPARK, count = 6, radius = 5, at = "front" }, { "shake", amount = 0.6 } },
					text = "TOMBÉ DE RIDEAU !", hitText = "KRAKABOUM !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_neutral" },
				K_side = { P = "P_up", K = "K_up", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "boule", name = "Boule de cristal", icon = "🔮",
			prop = { name = "PropBoule", hand = "Right", pieces = {
				{ "Socle", "", "cyl", Vector3.new(0.3, 0.9, 0.9), Vector3.new(0, -0.3, 0), Vector3.new(0, 0, 0), GOLD, "Metal", { axis = "y" } },
				{ "Boule", "", "ball", Vector3.new(1.3, 1.3, 1.3), Vector3.new(0, -1.1, 0), Vector3.new(0, 0, 0), CRYSTAL, "Glass", { transparency = 0.3, reflect = 0.4 } },
				{ "Lueur", "", "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, -1.1, 0), Vector3.new(0, 0, 0), MAGIC, "Neon", { light = { MAGIC, 6, 1.5 } } },
			} },
			ability = { speed = 1.15, text = "Trottine 15 % plus vite, la boule devant lui" },
			moves = {
				-- J : pichenette sur la boule, qui vient toquer le nez de l'adversaire
				P_neutral = {
					label = "Pichenette de cristal", startup = 0.07, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(4.5, 3, 2.8, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 28,
					windup = { Root = { 2, -12, 0, 0, -0.15, 0.1 }, Waist = { 4, -14, 0 }, Neck = { 6, 10, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, 10, 0, 0, -0.2, -0.25 }, Waist = { -6, 12, 0 }, Neck = { -4, -8, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
					follow = { Root = { -7, 12, 0, 0, -0.2, -0.28 }, Waist = { -7, 14, 0 }, Neck = { -5, -10, 0 }, RS = { 88, 0, -5 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 25, 0, -75 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
					trail = "prop", fx = { { "particles", tex = "spark", color = CRYSTAL, at = "hand", dir = "all", time = 0.15, speed = 6 } }, hitText = "TING !",
				},
				-- →J : la boule roulée à bout de bras, qui rebondit sur le front avant de revenir dans sa main
				P_side = {
					label = "Boule roulée", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 6, kbBase = 20, kbGrowth = 30, kbAngle = 28,
					projectile = { speed = 65, angle = 4, gravity = 20, lifetime = 0.32, size = 1.4, color = CRYSTAL, visual = ORB, aim = false },
					windup = { Root = { 4, -24, 0, 0, -0.2, 0.2 }, Waist = { 6, -28, 0 }, RS = { 150, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 } },
					strike = { Root = { -10, 18, 0, 0, -0.3, -0.35 }, Waist = { -12, 22, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 30, 0, -70 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 22, 0, 0, -0.32, -0.4 }, Waist = { -14, 26, 0 }, RS = { 90, 0, 4 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 25, 0, -75 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hideProp = "boule", hitText = "BLONG !",
				},
				-- ↓J : accroupi, il fait rouler la boule au sol dans les chevilles
				P_down = {
					label = "Boule au sol", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 6, kbBase = 22, kbGrowth = 28, kbAngle = 70,
					projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 0.35, size = 1.3, color = CRYSTAL, visual = ORB, aim = false, from = "feet" },
					windup = { Root = { 8, 0, 0, 0, -0.85, 0.1 }, Waist = { 18, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -1.0, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 16, 0, 0, 0, -1.0, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 20, 0, 12 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 44, 0, -42 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					hideProp = "boule", fx = { { "symbols", symbols = { "✦" }, color = CRYSTAL, count = 3, radius = 2, at = "feet" } }, hitText = "ROULE !",
				},
				-- ↑J : jonglage, il lance la boule en l'air et la rattrape deux fois sur le menton de qui passe au-dessus (2 touches)
				P_up = {
					label = "Jonglage de cristal", startup = 0.1, active = 0.18, recovery = 0.2,
					damage = 4, hits = 2, hitbox = box(4.5, 5.5, 1, 3.5), kbBase = 26, kbGrowth = 30, kbAngle = 85,
					windup = { Root = { 4, 0, 0, 0, -0.3, 0 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -6, 0, 0, 0, 0.1, 0 }, Waist = { -10, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 150, 0, 20 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 90, 0, -30 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 } },
					follow = { Root = { -6, 0, 0, 0, 0.1, 0 }, Waist = { -10, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 90, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -20 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 } },
					wobble = true, trail = "prop", fx = { { "symbols", symbols = { "✦", "✧" }, color = CRYSTAL, count = 4, radius = 2, at = "above" } }, hitText = "HOP HOP !",
				},
				-- J en l'air : il lâche la boule sous lui, elle tombe sur le crâne de l'adversaire et revient par magie
				P_air = {
					label = "Boule lâchée", kind = "projectile", startup = 0.09, active = 0, recovery = 0.18,
					damage = 7, kbBase = 20, kbGrowth = 35, kbAngle = -40,
					projectile = { speed = 55, angle = -70, gravity = 50, lifetime = 0.4, size = 1.4, color = CRYSTAL, visual = ORB, aim = false },
					windup = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 150, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -22, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -14, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 16, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 26, 0, -54 }, LE = { 40, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					hideProp = "boule", hitText = "PLONK !",
				},
				-- dash J : boule-bowling, lancé sur sa cape il fait rouler la boule devant lui comme au bowling
				P_dash = {
					label = "Boule-bowling", kind = "projectile", startup = 0.08, active = 0, recovery = 0.22,
					damage = 8, kbBase = 26, kbGrowth = 45, kbAngle = 30, selfVelocity = Vector2.new(36, 0),
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.4, size = 1.5, color = CRYSTAL, visual = ORB, aim = false, from = "feet" },
					windup = { Root = { -8, -20, 0, 0, -0.3, 0.1 }, Waist = { -6, -22, 0 }, RS = { -60, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -18, 14, 0, 0, -0.55, -0.35 }, Waist = { -14, 16, 0 }, Neck = { 6, 0, 0 }, RS = { 70, 0, 0 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 40, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 16, 0, 0, -0.55, -0.4 }, Waist = { -16, 18, 0 }, Neck = { 8, 0, 0 }, RS = { 80, 0, 0 }, RE = { 6, 0, 0 }, RW = { -30, 0, 0 }, LS = { 36, 0, -64 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hideProp = "boule", fx = { "dust" }, text = "STRIKE !", hitText = "QUILLE !",
				},
				-- K : la boule brandie à deux mains au-dessus de la tête, puis abattue comme un marteau
				K_neutral = {
					label = "Boule brandie", startup = 0.18, active = 0.12, recovery = 0.3,
					damage = 11, hitbox = box(5, 4, 3, 0.8), kbBase = 30, kbGrowth = 70, kbAngle = 40,
					windup = { Root = { 8, 0, 0, 0, -0.1, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 185, 0, 14 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -14 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.45, -0.4 }, Waist = { -28, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -16, 0, 0, 0, -0.5, -0.45 }, Waist = { -32, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 54, 0, 6 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 54, 0, -6 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { { "burst", color = CRYSTAL, size = 2, at = "front" } }, hitText = "KLONG !",
				},
				-- →K : le lancer du prophète, boule propulsée d'un grand geste théâtral, à bout de bras
				K_side = {
					label = "Lancer du prophète", kind = "projectile", startup = 0.2, active = 0, recovery = 0.32,
					damage = 12, kbBase = 30, kbGrowth = 70, kbAngle = 30, selfVelocity = Vector2.new(12, 0),
					projectile = { speed = 75, angle = 5, gravity = 20, lifetime = 0.5, size = 1.8, color = CRYSTAL, visual = ORB, aim = false },
					windup = { Root = { 8, -40, 0, 0, -0.3, 0.3 }, Waist = { 10, -44, 0 }, Neck = { 6, 28, 0 }, RS = { 176, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -30 }, LE = { 40, 0, 0 } },
					strike = { Root = { -14, 24, 0, 0, -0.34, -0.45 }, Waist = { -16, 28, 0 }, Neck = { -6, -18, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, 28, 0, 0, -0.36, -0.5 }, Waist = { -20, 32, 0 }, Neck = { -8, -20, 0 }, RS = { 100, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -64 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hideProp = "boule", fx = { { "burst", color = CRYSTAL, size = 2, at = "hand" } }, text = "JE VOIS… UN BLEU !", hitText = "BLANG !",
				},
				-- ↓K : la boule de bowling lourde, roulée au sol d'une main, qui écrase les orteils et ralentit
				K_down = {
					label = "Boule de bowling lourde", kind = "projectile", startup = 0.2, active = 0, recovery = 0.32,
					damage = 11, kbBase = 26, kbGrowth = 55, kbAngle = 55,
					projectile = { speed = 48, angle = 0, gravity = 0, lifetime = 0.7, size = 2.2, color = CRYSTAL, visual = ORB, aim = false, from = "feet" },
					status = { name = "slowed", duration = 1.2 },
					windup = { Root = { -10, -20, 0, 0, -0.7, 0.2 }, Waist = { -20, -16, 0 }, Neck = { -8, 14, 0 }, RS = { -50, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, 16, 0, 0, -0.95, -0.2 }, Waist = { -26, 18, 0 }, Neck = { 6, -8, 0 }, RS = { 60, 0, 0 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -14, 20, 0, 0, -0.95, -0.24 }, Waist = { -26, 22, 0 }, Neck = { 8, -10, 0 }, RS = { 70, 0, 0 }, RE = { 4, 0, 0 }, RW = { -40, 0, 0 }, LS = { 64, 0, -42 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hideProp = "boule", fx = { { "particles", tex = "smoke", color = SMOKE, at = "feet", dir = "front", time = 0.2, speed = 8 } }, text = "STRIKE !", hitText = "ÉCRASÉ !",
				},
				-- ↑K : la boule envoyée au ciel d'un coup de genou, elle cueille tout ce qui passe
				K_up = {
					label = "Boule au ciel", kind = "projectile", startup = 0.16, active = 0, recovery = 0.3,
					damage = 10, kbBase = 30, kbGrowth = 60, kbAngle = 85,
					projectile = { speed = 60, angle = 85, gravity = 60, lifetime = 0.6, size = 1.8, color = CRYSTAL, visual = ORB, aim = false },
					windup = { Root = { 6, 0, 0, 0, -0.4, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.05, -0.1 }, Waist = { -12, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 110, 0, 0 }, RK = { -110, 0, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.08, -0.12 }, Waist = { -14, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 120, 0, 0 }, RK = { -100, 0, 0 } },
					hideProp = "boule", fx = { { "burst", color = CRYSTAL, size = 2, at = "above" } }, hitText = "KLING !",
				},
				-- K en l'air : la boule-météore, il l'abat à deux mains sous lui, boule la première
				K_air = {
					label = "Boule-météore", startup = 0.15, active = 0.14, recovery = 0.26,
					damage = 11, hitbox = box(5, 4, 1.5, -1.5), kbBase = 28, kbGrowth = 65, kbAngle = -50,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -12 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -8 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -20, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 24, 0, 8 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 24, 0, -8 }, LE = { 6, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "spark", color = CRYSTAL, at = "hand", dir = "down", time = 0.2, speed = 10 } }, hitText = "MÉTÉORE !",
				},
				-- dash K : roulé-boulé de cristal, il fait un roulé-boulé avec la boule serrée contre lui et percute en roulant
				K_dash = {
					label = "Roulé-boulé de cristal", startup = 0.1, active = 0.22, recovery = 0.3,
					damage = 10, hitbox = box(5, 3.5, 3, -1), kbBase = 30, kbGrowth = 60, kbAngle = 35, selfVelocity = Vector2.new(50, 0),
					windup = { Root = { -12, 0, 0, 0, -0.6, 0.1 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, -0.5, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 80, 0, 10 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 130, 0, 0 }, RH = { 110, 0, 8 }, RK = { -130, 0, 0 }, LH = { 110, 0, -8 }, LK = { -130, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, -0.5, -0.35 }, Waist = { -32, 0, 0 }, Neck = { -32, 0, 0 }, RS = { 82, 0, 10 }, RE = { 132, 0, 0 }, RW = { 0, 0, 0 }, LS = { 82, 0, -10 }, LE = { 132, 0, 0 }, RH = { 112, 0, 8 }, RK = { -132, 0, 0 }, LH = { 112, 0, -8 }, LK = { -132, 0, 0 } },
					spin = { axis = "x", degrees = 360 }, trail = "body", fx = { "dust" }, text = "ROULÉ-BOULÉ !", hitText = "BADABOUM !",
				},
				-- L : la prédiction, il scrute la boule, annonce l'avenir… et la lance sur l'adversaire ; 3 avenirs possibles
				S_neutral = {
					label = "Prédiction", kind = "projectile", startup = 0.22, active = 0, recovery = 0.48,
					damage = 13, kbBase = 28, kbGrowth = 55, kbAngle = 35,
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 0.7, size = 1.8, color = CRYSTAL, visual = ORB },
					variants = {
						{ label = "Prédiction : je vois… des colombes !", damage = 12, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !",
							projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 1.0, size = 1.8, color = WHITE, visual = DOVE, aimed = true, homing = 0.8 } },
						{ label = "Prédiction : je vois… une explosion !", damage = 17, kbBase = 34, kbGrowth = 75, hitText = "BOUM !",
							projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.8, size = 2.1, color = MAGIC, visual = CONFETTI_BOMB, aimed = true } },
						{ label = "Prédiction : je vois… un lapin ?!", damage = 12, status = { name = "rooted", duration = 1.2 }, hitText = "CROC !",
							projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.9, size = 2.2, color = RABBIT, visual = BUNNY, aimed = true } },
					},
					windup = { Root = { 6, 0, 0, 0, -0.25, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 70, 0, 10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 20, 0, 0, -0.32, -0.4 }, Waist = { -14, 24, 0 }, Neck = { -6, -16, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 24, 0, 0, -0.34, -0.45 }, Waist = { -16, 28, 0 }, Neck = { -8, -18, 0 }, RS = { 100, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -64 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hideProp = "boule", shake = true, windupFx = { { "particles", tex = "spark", color = CRYSTAL, at = "hand", dir = "all", time = 0.2, speed = 5 }, { "text", text = "JE VOIS…", color = CRYSTAL } },
					fx = { { "burst", color = CRYSTAL, size = 2.5, at = "hand" }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 3, radius = 3, at = "front" } },
					text = "L'AVENIR EST… LÀ !", hitText = "PRÉDIT !",
				},
				-- →L : la boule-comète, lancée en vrille, elle laisse une traînée d'étoiles et suit l'adversaire à la trace
				S_side = {
					label = "Boule-comète", kind = "projectile", startup = 0.24, active = 0, recovery = 0.5,
					damage = 14, kbBase = 30, kbGrowth = 62, kbAngle = 32,
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.7, size = 2, color = CRYSTAL, visual = ORB, homing = 0.5, pierce = true },
					windup = { Root = { 8, -36, 0, 0, -0.25, 0.25 }, Waist = { 10, -40, 0 }, Neck = { 6, 24, 0 }, RS = { 170, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -20 }, LE = { 40, 0, 0 } },
					strike = { Root = { -14, 24, 0, 0, -0.32, -0.45 }, Waist = { -16, 28, 0 }, Neck = { -6, -18, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, 28, 0, 0, -0.34, -0.5 }, Waist = { -18, 32, 0 }, Neck = { -8, -20, 0 }, RS = { 100, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -64 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hideProp = "boule", spin = { axis = "y", degrees = 360 }, fx = { { "beam", color = CRYSTAL, length = 12, width = 1.6, at = "hand" }, { "symbols", symbols = { "✦", "★", "✧" }, color = CRYSTAL, count = 5, radius = 3, at = "front" } },
					text = "COMÈTE !", hitText = "ÉTOILÉ !",
				},
				-- ↓L : la boule posée au sol tourne comme une toupie hypnotique et file lentement vers l'adversaire, qui reste à la regarder
				S_down = {
					label = "Toupie hypnotique", kind = "projectile", startup = 0.22, active = 0, recovery = 0.48,
					damage = 12, kbBase = 14, kbGrowth = 12, kbAngle = 60,
					status = { name = "slowed", duration = 2.5 },
					projectile = { speed = 30, angle = 0, gravity = 0, lifetime = 0.8, size = 4, color = CRYSTAL, linger = 2, from = "feet",
						visual = { shape = "ball", size = 3, color = CRYSTAL, neon = true, spin = 20, transparency = 0.3, parts = { { "cyl", Vector3.new(0.2, 3.4, 3.4), Vector3.new(0, -1.3, 0), GOLD } } } },
					windup = { Root = { 8, 0, 0, 0, -0.5, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 60, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.95, -0.3 }, Waist = { -26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 2, 0, 0, 0, -0.3, 0 }, Waist = { 4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } },
					hideProp = "boule", fx = { { "ring", color = CRYSTAL, radius = 4, at = "feet" }, { "symbols", symbols = { "🌀", "✦" }, color = CRYSTAL, count = 4, radius = 3, at = "front" } },
					text = "REGARDEZ LA BOULE…", hitText = "HYPNOTISÉ !",
				},
				-- ↑L : l'envol voyant, il s'assoit sur la boule qui s'envole en diagonale comme un tapis volant rond
				S_up = {
					label = "Envol voyant", startup = 0.15, active = 0.3, recovery = 0.45,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 52, kbAngle = 78, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 0, 0, 0, 0, -0.85, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.3, -0.1 }, Waist = { -4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -80 }, LE = { 10, 0, 0 }, RH = { 80, 0, 20 }, RK = { -100, 0, 0 }, RA = { -20, 0, 0 }, LH = { 80, 0, -20 }, LK = { -100, 0, 0 }, LA = { -20, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.35, -0.15 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 94, 0, 84 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -84 }, LE = { 10, 0, 0 }, RH = { 84, 0, 22 }, RK = { -104, 0, 0 }, RA = { -20, 0, 0 }, LH = { 84, 0, -22 }, LK = { -104, 0, 0 }, LA = { -20, 0, 0 } },
					wobble = true, trail = "body", fx = { { "pillar", color = CRYSTAL, height = 12, width = 3, at = "root", time = 0.4 }, { "burst", color = CRYSTAL, size = 4, at = "feet" }, { "ring", color = MAGIC, radius = 6, at = "feet" }, { "symbols", symbols = { "✦", "★", "🔮" }, color = CRYSTAL, count = 6, radius = 4, at = "above" } },
					text = "LÉVITATION… POUR DE VRAI !", hitText = "ENVOLÉ !",
				},
				-- L en l'air : pluie de boules, il en sort trois de sa manche et les lâche sur l'adversaire
				S_air = {
					label = "Pluie de cristal", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
					damage = 6, kbBase = 24, kbGrowth = 45, kbAngle = -40,
					projectile = { speed = 55, angle = -70, gravity = 40, lifetime = 0.8, size = 1.4, color = CRYSTAL, visual = ORB, rain = { count = 3, spread = 5 } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 60, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 20, 0, 12 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 20, 0, -12 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 16, 0, 14 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 16, 0, -14 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					hideProp = "boule", fx = { { "burst", color = CRYSTAL, size = 2, at = "feet" } }, text = "PLUIE D'AVENIR !", hitText = "PLONK PLONK !",
				},
				-- Y : l'apocalypse prédite : la boule grossit jusqu'à devenir une planète et roule sur tout le couloir ; 3 fins du monde possibles
				SUPER = {
					label = "Apocalypse prédite !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 25, kbBase = 48, kbGrowth = 95, kbAngle = 35,
					projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 1.0, size = 4.2, color = CRYSTAL, pierce = true, from = "feet",
						visual = { shape = "ball", size = 4, color = CRYSTAL, neon = true, spin = 8, transparency = 0.2, parts = { { "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 0, 0), WHITE } } } },
					status = { name = "stunned", duration = 1.5 },
					variants = {
						{ label = "Apocalypse prédite : la fin du monde en colombes !", damage = 24, status = { name = "blinded", duration = 2.5 }, hitText = "ROUCOULE !" },
						{ label = "Apocalypse prédite : BOUM !", damage = 28, kbBase = 52, kbGrowth = 100, hitText = "KABOUM !" },
						{ label = "Apocalypse prédite : règne des lapins !", damage = 24, status = { name = "dog", duration = 2.5 }, hitText = "COUIC ?!" },
					},
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.9, -0.4 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 60, 0, -10 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { 6, 0, 0, 0, -0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 170, 0, 50 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -50 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
					hideProp = "boule", hold = 0.2, shake = true, windupFx = { "super", { "symbols", symbols = { "🔮", "☄️", "✦" }, count = 6, radius = 3, color = CRYSTAL } },
					fx = { { "burst", color = CRYSTAL, size = 5, at = "feet" }, { "screen", color = CRYSTAL, alpha = 0.3 }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 6, radius = 5, at = "front" }, { "shake", amount = 0.5 } },
					text = "LA FIN DU MONDE EST POUR… MAINTENANT !", hitText = "PRÉDIT !",
				},
				-- →Y : la boule géante : gonflée comme un ballon, il la pousse à deux mains et elle roule sur tout le couloir comme un katamari
				SUPER_side = {
					label = "Boule géante !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 46, kbGrowth = 90, kbAngle = 30, selfVelocity = Vector2.new(10, 0),
					projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 1.0, size = 3.6, color = CRYSTAL, pierce = true, from = "feet",
						visual = { shape = "ball", size = 3.4, color = CRYSTAL, neon = true, spin = 10, transparency = 0.25, parts = { { "cyl", Vector3.new(0.3, 2.0, 2.0), Vector3.new(0, -1.7, 0), GOLD } } } },
					windup = { Root = { 10, 0, 0, 0, -0.4, 0.3 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 50, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.5, -0.5 }, Waist = { -20, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 96, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 0, 0, 0, -0.52, -0.55 }, Waist = { -24, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 100, 0, 8 }, RE = { 4, 0, 0 }, RW = { -8, 0, 0 }, LS = { 100, 0, -8 }, LE = { 4, 0, 0 }, LW = { -8, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hideProp = "boule", shake = true, windupFx = { "super", { "particles", tex = "spark", color = CRYSTAL, at = "hand", dir = "all", time = 0.3, speed = 8 } },
					fx = { { "burst", color = CRYSTAL, size = 4, at = "front" }, { "beam", color = CRYSTAL, length = 14, width = 3.5, at = "feet" }, { "shake", amount = 0.4 } },
					text = "KATAMARI MAGIQUE !", hitText = "ROULÉ DESSUS !",
				},
				-- ↑Y : la boule-ascenseur : il monte sur la boule qui enfle et le hisse en vrille à la verticale, tout le couloir décolle avec lui
				SUPER_up = {
					label = "Boule-ascenseur !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(14, 12, 7, 5), kbBase = 44, kbGrowth = 92, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 60),
					windup = { Root = { -6, 0, 0, 0, -0.9, 0 }, Waist = { -20, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, RH = { 10, 0, 10 }, RK = { -20, 0, 0 }, LH = { 10, 0, -10 }, LK = { -20, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 14, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 90, 0, 92 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 90, 0, -92 }, LE = { 0, 0, 0 }, RH = { 14, 0, 12 }, RK = { -24, 0, 0 }, LH = { 14, 0, -12 }, LK = { -24, 0, 0 } },
					hold = 0.2, spin = { axis = "y", degrees = 720 }, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🔮", "✦" }, count = 6, radius = 3, color = CRYSTAL } },
					fx = { { "pillar", color = CRYSTAL, height = 22, width = 4, at = "root" }, { "ring", color = MAGIC, radius = 8, at = "feet" }, { "burst", color = CRYSTAL, size = 4, at = "above" }, { "shake", amount = 0.4 } },
					text = "ASCENSEUR POUR L'ÉCHAFAUD !", hitText = "MONTÉ !",
				},
				-- ↓Y : la séance de spiritisme : il pose la boule au sol, agite les mains au-dessus, et tout le couloir s'endort ; Gaston récupère au passage
				SUPER_down = {
					label = "Séance de spiritisme !", startup = 0.4, active = 0.2, recovery = 0.7,
					damage = 22, hitbox = box(14, 6, 7, 1), kbBase = 20, kbGrowth = 30, kbAngle = 60,
					status = { name = "asleep", duration = 2.5 }, selfEffect = { heal = 8 },
					windup = { Root = { 10, 0, 0, 0, -0.5, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 70, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -30 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -4, 0, 0, 0, -0.4, -0.2 }, Waist = { -8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 100, 0, 50 }, RE = { 20, 0, 0 }, RW = { -40, 0, 0 }, LS = { 100, 0, -50 }, LE = { 20, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -4, 0, 0, 0, -0.4, -0.2 }, Waist = { -8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 110, 0, 40 }, RE = { 20, 0, 0 }, RW = { -60, 0, 0 }, LS = { 110, 0, -40 }, LE = { 20, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					hold = 0.4, wobble = true, windupFx = { "super", { "text", text = "ESPRITS, ÊTES-VOUS LÀ ?", color = CRYSTAL } },
					fx = { { "screen", color = SATIN, alpha = 0.35 }, { "beam", color = CRYSTAL, length = 14, width = 5, at = "root", time = 0.5 }, { "symbols", symbols = { "💤", "👻", "✦" }, color = CRYSTAL, count = 8, radius = 5, at = "front" }, { "ring", color = MAGIC, radius = 8, at = "feet" } },
					text = "DORMEZ, JE LE VEUX !", hitText = "ZZZ…",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_neutral", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_neutral" },
				K_dash = { P = "P_up", K = "K_up", S = "S_up" },
			},
		},
	},

	look = {
		body = { head = SKIN, upper = TUX, lower = TUX, arms = TUX, hands = WHITE, legs = TUX,
			feet = Color3.fromRGB(15, 15, 20), forearms = TUX, shins = TUX },
		cubeHead = 1.25,
		parts = {
			-- haut-de-forme avec le lapin grognon qui dépasse (une oreille droite, une oreille tombante)
			{ "Chapeau", "Head", "cyl", Vector3.new(1.5, 1.15, 1.15), Vector3.new(0, 1.35, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
			{ "Bord", "Head", "cyl", Vector3.new(0.1, 1.9, 1.9), Vector3.new(0, 0.66, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
			{ "Ruban", "Head", "cyl", Vector3.new(0.28, 1.18, 1.18), Vector3.new(0, 0.85, 0), Vector3.new(0, 0, 0), VELVET, "Fabric", { axis = "y" } },
			{ "OreilleLapinG", "Head", "ball", Vector3.new(0.3, 1.1, 0.22), Vector3.new(-0.22, 2.55, 0.1), Vector3.new(0, 0, 8), RABBIT, "Fabric" },
			{ "OreilleLapinD", "Head", "ball", Vector3.new(0.3, 1.0, 0.22), Vector3.new(0.4, 2.3, 0.1), Vector3.new(0, 0, -55), RABBIT, "Fabric" },
			{ "InterieurOreille", "Head", "ball", Vector3.new(0.14, 0.8, 0.1), Vector3.new(-0.22, 2.55, -0.02), Vector3.new(0, 0, 8), PINK, "SmoothPlastic" },
			-- visage : moustache en guidon, sourcils dramatiques, nez rond
			{ "MoustacheG", "Head", "ball", Vector3.new(0.55, 0.18, 0.12), Vector3.new(-0.3, -0.2, -0.67), Vector3.new(0, 0, 18), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "MoustacheD", "Head", "ball", Vector3.new(0.55, 0.18, 0.12), Vector3.new(0.3, -0.2, -0.67), Vector3.new(0, 0, -18), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "SourcilG", "Head", "block", Vector3.new(0.38, 0.08, 0.06), Vector3.new(-0.3, 0.32, -0.64), Vector3.new(0, 0, -12), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "SourcilD", "Head", "block", Vector3.new(0.38, 0.08, 0.06), Vector3.new(0.3, 0.32, -0.64), Vector3.new(0, 0, 12), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "Nez", "Head", "ball", Vector3.new(0.3, 0.35, 0.3), Vector3.new(0, 0.02, -0.72), Vector3.new(0, 0, 0), Color3.fromRGB(240, 165, 150), "SmoothPlastic" },
			-- smoking : plastron blanc, revers en satin, nœud papillon
			{ "Plastron", "UpperTorso", "block", Vector3.new(0.7, 1.3, 0.05), Vector3.new(0, 0.15, -0.51), Vector3.new(0, 0, 0), WHITE, "Fabric" },
			{ "ReversG", "UpperTorso", "block", Vector3.new(0.3, 1.1, 0.06), Vector3.new(-0.48, 0.25, -0.52), Vector3.new(0, 0, -14), SATIN, "Fabric" },
			{ "ReversD", "UpperTorso", "block", Vector3.new(0.3, 1.1, 0.06), Vector3.new(0.48, 0.25, -0.52), Vector3.new(0, 0, 14), SATIN, "Fabric" },
			{ "Noeud", "UpperTorso", "block", Vector3.new(0.65, 0.3, 0.1), Vector3.new(0, 0.7, -0.55), Vector3.new(0, 0, 0), VELVET, "Fabric" },
			{ "NoeudCentre", "UpperTorso", "ball", Vector3.new(0.18, 0.18, 0.12), Vector3.new(0, 0.7, -0.6), Vector3.new(0, 0, 0), GOLD, "SmoothPlastic" },
			-- la cape trop grande : grand col dressé, doublure rouge, elle traîne presque par terre
			{ "Cape", "UpperTorso", "block", Vector3.new(2.7, 3.8, 0.12), Vector3.new(0, -0.75, 0.66), Vector3.new(8, 0, 0), TUX, "Fabric" },
			{ "Doublure", "UpperTorso", "block", Vector3.new(2.6, 3.7, 0.08), Vector3.new(0, -0.72, 0.58), Vector3.new(8, 0, 0), VELVET, "Fabric" },
			{ "Col", "UpperTorso", "block", Vector3.new(2.5, 1.0, 0.12), Vector3.new(0, 1.2, 0.55), Vector3.new(-18, 0, 0), VELVET, "Fabric" },
			{ "Etoile", "UpperTorso", "ball", Vector3.new(0.3, 0.3, 0.06), Vector3.new(0.6, -0.8, 0.74), Vector3.new(0, 0, 0), SPARK, "Neon" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : baguette noire à bout blanc qui crépite
			{ name = "PropBaguette", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.6, 0.13, 0.13), Vector3.new(0, -0.85, 0), Vector3.new(0, 0, 0), Color3.fromRGB(15, 15, 20), "SmoothPlastic", { axis = "y" } },
				{ "Bout", "", "cyl", Vector3.new(0.32, 0.15, 0.15), Vector3.new(0, -1.78, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic", { axis = "y" } },
				{ "Etincelle", "", "ball", Vector3.new(0.22, 0.22, 0.22), Vector3.new(0, -2.0, 0), Vector3.new(0, 0, 0), SPARK, "Neon", { light = { SPARK, 5, 1 } } },
			} },
			-- éventail de cartes (main gauche)
			{ name = "PropCartes", hand = "Left", visible = false, pieces = {
				{ "Carte1", "", "block", Vector3.new(0.5, 0.75, 0.04), Vector3.new(-0.2, -0.5, 0), Vector3.new(0, 0, 25), WHITE, "SmoothPlastic" },
				{ "Carte2", "", "block", Vector3.new(0.5, 0.75, 0.04), Vector3.new(0, -0.55, -0.03), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
				{ "Carte3", "", "block", Vector3.new(0.5, 0.75, 0.04), Vector3.new(0.2, -0.5, -0.06), Vector3.new(0, 0, -25), WHITE, "SmoothPlastic" },
				{ "Coeur", "", "block", Vector3.new(0.18, 0.18, 0.05), Vector3.new(0, -0.6, -0.07), Vector3.new(0, 0, 45), VELVET, "SmoothPlastic" },
			} },
			-- foulards noués sans fin qui sortent de la manche (main gauche)
			{ name = "PropFoulard", hand = "Left", visible = false, pieces = {
				{ "Foulard1", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -0.45, 0), Vector3.new(0, 0, 10), VELVET, "Fabric" },
				{ "Foulard2", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -1.0, 0), Vector3.new(0, 0, -10), SPARK, "Fabric" },
				{ "Foulard3", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -1.55, 0), Vector3.new(0, 0, 10), Color3.fromRGB(80, 200, 120), "Fabric" },
				{ "Foulard4", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -2.1, 0), Vector3.new(0, 0, -10), Color3.fromRGB(70, 140, 240), "Fabric" },
				{ "Foulard5", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -2.65, 0), Vector3.new(0, 0, 10), PINK, "Fabric" },
			} },
			-- canne magique à pommeau doré (main gauche)
			{ name = "PropCanne", hand = "Left", visible = false, pieces = {
				{ "Tige", "", "cyl", Vector3.new(3, 0.18, 0.18), Vector3.new(0, -1.2, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
				{ "Pommeau", "", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, 0.3, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
				{ "Embout", "", "cyl", Vector3.new(0.3, 0.2, 0.2), Vector3.new(0, -2.7, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic", { axis = "y" } },
			} },
			-- le lapin grognon, tenu par les oreilles (main gauche)
			{ name = "PropLapin", hand = "Left", visible = false, pieces = {
				{ "Oreilles", "", "ball", Vector3.new(0.35, 0.7, 0.2), Vector3.new(0, -0.3, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
				{ "Tete", "", "ball", Vector3.new(0.75, 0.7, 0.7), Vector3.new(0, -0.85, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
				{ "Corps", "", "ball", Vector3.new(0.9, 1.1, 0.8), Vector3.new(0, -1.6, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
				{ "Dents", "", "block", Vector3.new(0.2, 0.18, 0.1), Vector3.new(0, -1.05, -0.35), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de baguette crépitante : petit tapotement sec du bout de la baguette, qui crache des étincelles
		P_neutral = {
			label = "Coup de baguette", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 6, hitbox = box(4.5, 3, 2.8, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 28,
			windup = { Root = { 2, -12, 0, 0, -0.15, 0.1 }, Waist = { 6, -14, 0 }, Neck = { 8, 10, 0 }, RS = { 110, 0, 25 }, RE = { 70, 0, 0 }, RW = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.25 }, Waist = { -6, 12, 0 }, Neck = { -4, -8, 0 }, RS = { 92, 0, 0 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -70 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -7, 12, 0, 0, -0.2, -0.28 }, Waist = { -7, 14, 0 }, Neck = { -5, -10, 0 }, RS = { 88, 0, -5 }, RE = { 10, 0, 0 }, RW = { -25, 0, 0 }, LS = { 25, 0, -75 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.15, speed = 6 } }, hitText = "BZZT !",
		},
		-- Foulard sans fin (J J) : il tire de sa manche gauche une guirlande de foulards et la fouette devant lui
		P_combo2 = {
			label = "Foulard sans fin", startup = 0.08, active = 0.12, recovery = 0.18,
			damage = 5, hitbox = box(6, 3.5, 3.5, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 2, 20, 0, 0, -0.2, 0.15 }, Waist = { 4, 22, 0 }, Neck = { 0, -14, 0 }, RS = { 50, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, 40 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, -16, 0, 0, -0.22, -0.25 }, Waist = { -6, -20, 0 }, Neck = { 0, 12, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 92, 0, -20 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -6, -22, 0, 0, -0.22, -0.3 }, Waist = { -6, -26, 0 }, Neck = { 0, 16, 0 }, RS = { 35, 0, 45 }, RE = { 50, 0, 0 }, LS = { 90, 0, -45 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "foulard", trail = "leftHand", text = "ET ENCORE UN…", hitText = "FLOUF !",
		},
		-- Tour de passe-passe final (J J J) : il fait tournoyer la baguette au-dessus de sa tête puis l'abat, gerbe d'étincelles
		P_combo3 = {
			label = "Final étincelant", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 8, hitbox = box(5, 4, 2.6, 1), kbBase = 30, kbGrowth = 60, kbAngle = 48,
			windup = { Root = { 8, -8, 0, 0, -0.05, 0.2 }, Waist = { 14, -10, 0 }, Neck = { 18, 0, 0 }, RS = { 190, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -60 }, LE = { 20, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, -0.45, -0.4 }, Waist = { -26, 12, 0 }, Neck = { -8, 0, 0 }, RS = { 75, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -80 }, LE = { 10, 0, 0 } },
			follow = { Root = { -16, 12, 0, 0, -0.5, -0.45 }, Waist = { -30, 14, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 5 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 35, 0, -85 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { { "burst", color = SPARK, size = 3 }, { "symbols", symbols = { "✨", "★" }, color = SPARK, count = 5, radius = 3, at = "front" } },
			text = "TA-DAAA !", hitText = "BADABZING !",
		},
		-- Cartes en éventail : de la main gauche, il lance trois cartes tranchantes en éventail court
		P_side = {
			label = "Cartes en éventail", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
			damage = 3, kbBase = 16, kbGrowth = 22, kbAngle = 20,
			projectile = { speed = 85, gravity = 0, lifetime = 0.24, size = 1.2, color = WHITE, visual = CARD, fan = { count = 3, from = -12, to = 12 } },
			windup = { Root = { 0, 26, 0, 0, -0.2, 0.15 }, Waist = { 2, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 70, 0, 50 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -4, -18, 0, 0, -0.22, -0.2 }, Waist = { -4, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 35, 0, 45 }, RE = { 50, 0, 0 }, LS = { 90, 0, -40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -4, -24, 0, 0, -0.22, -0.25 }, Waist = { -4, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 85, 0, -60 }, LE = { 10, 0, 0 }, LW = { -20, 0, 0 } },
			prop = "cartes", text = "FLICK !", hitText = "TCHAK !",
		},
		-- → J J : Pichenette magique, il s'avance et pique du bout de la baguette
		P_side2 = {
			label = "Pichenette magique", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 3.2, 0.6), kbBase = 22, kbGrowth = 35, kbAngle = 25, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 4, -24, 0, 0, -0.25, 0.25 }, Waist = { 4, -26, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 } },
			strike = { Root = { -12, 16, 0, 0, -0.35, -0.45 }, Waist = { -10, 20, 0 }, RS = { 98, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -75 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 20, 0, 0, -0.36, -0.5 }, Waist = { -12, 24, 0 }, RS = { 96, 0, -6 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -80 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = MAGIC, at = "hand", dir = "front", time = 0.15, speed = 8 } }, hitText = "PIC !",
		},
		-- Chaussure vernie en balayage : accroupi, il balaie au ras du sol, la chaussure laisse une traînée d'étoiles
		P_down = {
			label = "Balayage verni", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(5.5, 2, 2.5, -2), kbBase = 26, kbGrowth = 22, kbAngle = 76,
			windup = { Root = { -8, -20, 0, 0, -0.75, 0.2 }, Waist = { -14, -10, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { -15, 0, 20 }, RK = { -60, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -12, 24, 0, 0, -0.9, -0.1 }, Waist = { -20, 16, 0 }, RS = { 40, 0, 80 }, RE = { 10, 0, 0 }, LS = { 70, 0, -30 }, LE = { 40, 0, 0 }, RH = { 64, 0, 10 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -12, 34, 0, 0, -0.9, -0.15 }, Waist = { -20, 26, 0 }, RS = { 35, 0, 85 }, RE = { 10, 0, 0 }, LS = { 75, 0, -28 }, LE = { 40, 0, 0 }, RH = { 60, 0, -12 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { { "symbols", symbols = { "✦", "✧" }, color = SPARK, count = 4, radius = 2, at = "feet" } }, hitText = "ZIP !",
		},
		-- ↓ J J : Révérence remontante, du fond de sa révérence il remonte la baguette jusqu'au ciel
		P_down2 = {
			label = "Révérence remontante", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 8, hitbox = box(5, 5, 2.5, 2), kbBase = 30, kbGrowth = 45, kbAngle = 82,
			windup = { Root = { -14, 0, 0, 0, -0.6, 0.1 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -20, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 } },
			strike = { Root = { 8, 10, 0, 0, 0.15, -0.2 }, Waist = { 16, 12, 0 }, Neck = { 25, 0, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 20, 0, 0 } },
			follow = { Root = { 10, 12, 0, 0, 0.2, -0.25 }, Waist = { 18, 14, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 5 }, RE = { 8, 0, 0 }, RW = { -15, 0, 0 }, LS = { 25, 0, -75 }, LE = { 20, 0, 0 } },
			trail = "prop", hitText = "HOP LÀ !",
		},
		-- Lapin mordeur (anti-air, ex-←J) : il brandit le lapin par les oreilles au-dessus de lui, le lapin mord
		P_up = {
			label = "Lapin mordeur", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 5, 1, 3.5), kbBase = 28, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -4, 10, 0, 0, -0.4, 0 }, Waist = { -10, 12, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, -6, 0, 0, 0.2, 0 }, Waist = { 14, -8, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, -8, 0, 0, 0.25, 0 }, Waist = { 16, -10, 0 }, Neck = { 34, 0, 0 }, RS = { 45, 0, 65 }, RE = { 30, 0, 0 }, LS = { 178, 0, -14 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "lapin", text = "GRRR !", hitText = "CROC !",
		},
		-- Cape tournoyante (J en l'air) : il s'enroule dans sa cape et tourne sur lui-même, bras écartés
		P_air = {
			label = "Cape tournoyante", startup = 0.08, active = 0.2, recovery = 0.18,
			damage = 7, hitbox = box(6, 4, 0, 0), kbBase = 22, kbGrowth = 35, kbAngle = 35,
			windup = { Root = { 6, -40, 0 }, Waist = { 6, -20, 0 }, RS = { 60, 0, -30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 90, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 20, 0, -10 }, LK = { -40, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 }, RH = { 15, 0, 12 }, RK = { -35, 0, 0 }, LH = { 15, 0, -12 }, LK = { -35, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", hitText = "FWOUSH !",
		},
		-- Courbette fonceuse (dash puis J) : il fonce penché en une grande révérence, le haut-de-forme en bélier
		P_dash = {
			label = "Courbette fonceuse", startup = 0.08, active = 0.14, recovery = 0.24,
			damage = 8, hitbox = box(4, 3, 2.2, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 30, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 60 }, RE = { 30, 0, 0 }, LS = { 100, 0, -70 }, LE = { 20, 0, 0 } },
			strike = { Root = { -30, 0, 0, 0, -0.45, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -40, 0, 50 }, RE = { 20, 0, 0 }, LS = { 70, 0, 10 }, LE = { 100, 0, 0 } },
			follow = { Root = { -32, 0, 0, 0, -0.48, -0.4 }, Waist = { -32, 0, 0 }, Neck = { -16, 0, 0 }, RS = { -48, 0, 55 }, RE = { 20, 0, 0 }, LS = { 72, 0, 12 }, LE = { 105, 0, 0 } },
			fx = { "dust" }, text = "MESDAMES ET MESSIEURS !", hitText = "BONG !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Chaussure vernie : coup de pied de cancan, il relève les pans de sa cape des deux mains et lance la jambe tout en haut, pointe brillante
		K_neutral = {
			label = "Chaussure vernie", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 4.5, 3, 1.2), kbBase = 30, kbGrowth = 70, kbAngle = 45,
			windup = { Root = { 6, 0, 0, 0, -0.25, 0.15 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 70 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 90, 0, 0 }, RH = { 40, 0, 0 }, RK = { -110, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 16, 0, 0, 0, 0.1, 0.05 }, Waist = { 10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 35, 0, 80 }, RE = { 95, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, -80 }, LE = { 95, 0, 0 }, RH = { 128, 0, 0 }, RK = { -2, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { 20, 0, 0, 0, 0.12, 0.08 }, Waist = { 12, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 38, 0, 84 }, RE = { 95, 0, 0 }, RW = { 0, 0, 0 }, LS = { 38, 0, -84 }, LE = { 95, 0, 0 }, RH = { 136, 0, 0 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", fx = { { "burst", color = SPARK, size = 1.5 }, { "symbols", symbols = { "♪", "✦" }, color = SPARK, count = 3, radius = 2, at = "front" } }, text = "CANCAN !", hitText = "BLING !",
		},
		-- K K : Talon vernis, il pivote et fouette du talon gauche, cape qui vole
		K_combo2 = {
			label = "Talon vernis", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 32,
			windup = { Root = { 4, 40, 0, 0, -0.15, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 0, -25, 0 }, RS = { 60, 0, 50 }, RE = { 50, 0, 0 }, LS = { 40, 0, -55 }, LE = { 40, 0, 0 }, LH = { 55, 0, -40 }, LK = { -105, 0, 0 } },
			strike = { Root = { 12, -50, 0, 0, -0.1, 0 }, Waist = { 10, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 70, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -70 }, LE = { 30, 0, 0 }, LH = { 85, 0, -55 }, LK = { -5, 0, 0 }, LA = { -15, 0, 0 } },
			follow = { Root = { 14, -70, 0, 0, -0.1, 0 }, Waist = { 12, -38, 0 }, Neck = { 0, 26, 0 }, RS = { 72, 0, 62 }, RE = { 40, 0, 0 }, LS = { 25, 0, -75 }, LE = { 30, 0, 0 }, LH = { 80, 0, -40 }, LK = { -8, 0, 0 }, LA = { -15, 0, 0 } },
			trail = "leftFoot", hitText = "CLAC !",
		},
		-- K K K : Coup de pied théâtral, il saute, salue de la baguette et lance une ruade en l'air
		K_combo3 = {
			label = "Coup de pied théâtral", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 4, 3, 1), kbBase = 32, kbGrowth = 80, kbAngle = 40, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, LS = { -30, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { 16, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 170, 0, 40 }, RE = { 10, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 175, 0, 45 }, RE = { 10, 0, 0 }, LS = { 55, 0, -75 }, LE = { 20, 0, 0 }, RH = { 108, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 35, 0, 0 }, LK = { -115, 0, 0 } },
			trail = "rightFoot", text = "OLÉ !", hitText = "BAM !",
		},
		-- Canne magique (→K) : il sort une canne de sa cape et donne un grand coup d'estoc de la main gauche
		K_side = {
			label = "Canne magique", startup = 0.22, active = 0.12, recovery = 0.35,
			damage = 13, hitbox = box(6, 2.5, 4, 0.5), kbBase = 32, kbGrowth = 85, kbAngle = 28, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { 6, 30, 0, 0, -0.25, 0.3 }, Waist = { 8, 30, 0 }, Neck = { 0, -24, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, 60 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, -20, 0, 0, -0.4, -0.5 }, Waist = { -12, -24, 0 }, Neck = { 0, 18, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { 92, 0, 0 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, -24, 0, 0, -0.42, -0.55 }, Waist = { -14, -28, 0 }, Neck = { 0, 22, 0 }, RS = { -35, 0, 55 }, RE = { 20, 0, 0 }, LS = { 95, 0, 0 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "canne", trail = "leftHand", text = "EN GARDE !", hitText = "TOC !",
		},
		-- → K K : Crochet de canne, il accroche l'adversaire par le cou avec la canne et le ramène vers lui
		K_side2 = {
			label = "Crochet de canne", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 9, hitbox = box(6, 3.5, 4, 0.8), kbBase = 26, kbGrowth = 30, kbAngle = 20, pull = true,
			windup = { Root = { -6, -20, 0, 0, -0.3, -0.2 }, Waist = { -8, -24, 0 }, RS = { 30, 0, 40 }, RE = { 50, 0, 0 }, LS = { 120, 0, 10 }, LE = { 10, 0, 0 }, LW = { 90, 0, 0 } },
			strike = { Root = { 10, 20, 0, 0, -0.3, 0.3 }, Waist = { 14, 26, 0 }, Neck = { 0, -16, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, 30 }, LE = { 110, 0, 0 }, LW = { 90, 0, 0 } },
			follow = { Root = { 12, 26, 0, 0, -0.3, 0.4 }, Waist = { 16, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 52 }, RE = { 60, 0, 0 }, LS = { 40, 0, 30 }, LE = { 125, 0, 0 }, LW = { 90, 0, 0 } },
			prop = "canne", trail = "leftHand", text = "VIENS PAR ICI !", hitText = "CROCHET !",
		},
		-- Trappe ratée (↓K) : il marche sur sa propre trappe, tombe jusqu'à la taille et moulinet des bras au ras du sol
		K_down = {
			label = "Trappe ratée", startup = 0.18, active = 0.2, recovery = 0.35,
			damage = 12, hitbox = box(7, 2.5, 1, -1.5), kbBase = 30, kbGrowth = 62, kbAngle = 65,
			windup = { Root = { 6, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 40 }, RE = { 30, 0, 0 }, LS = { 40, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -1.8, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 70, 0, 80 }, RE = { 0, 0, 0 }, LS = { 70, 0, -80 }, LE = { 0, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -1.8, 0 }, Waist = { -10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 110, 0, 85 }, RE = { 10, 0, 0 }, LS = { 30, 0, -85 }, LE = { 10, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
			wobble = true, fx = { "dust", { "text", text = "OUPS…", color = WHITE } }, hitText = "BLOMP !",
		},
		-- ↓ K K : Sortie de trappe, il jaillit de la trappe comme un diable de sa boîte, pieds en avant
		K_downK = {
			label = "Sortie de trappe", startup = 0.1, active = 0.14, recovery = 0.3,
			damage = 9, hitbox = box(5, 5, 2.5, 2.5), kbBase = 30, kbGrowth = 52, kbAngle = 84,
			windup = { Root = { 0, 0, 0, 0, -1.6, 0 }, Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, 0.6, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 175, 0, 20 }, RE = { 0, 0, 0 }, LS = { 175, 0, -20 }, LE = { 0, 0, 0 }, RH = { -10, 0, 5 }, RK = { -20, 0, 0 }, LH = { -10, 0, -5 }, LK = { -20, 0, 0 } },
			follow = { Root = { -22, 0, 0, 0, 0.7, 0 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 180, 0, 25 }, RE = { 0, 0, 0 }, LS = { 180, 0, -25 }, LE = { 0, 0, 0 }, RH = { -12, 0, 8 }, RK = { -30, 0, 0 }, LH = { -12, 0, -8 }, LK = { -30, 0, 0 } },
			fx = { { "burst", color = SMOKE, size = 3, at = "feet" } }, text = "TA-DAM !", hitText = "BOING !",
		},
		-- Disparition ratée (ex-←K, recul) : pouf de fumée, il tente de disparaître et ne réussit qu'à reculer en ruant vers le haut
		K_up = {
			label = "Disparition ratée", startup = 0.18, active = 0.14, recovery = 0.3,
			damage = 11, hitbox = box(5, 5.5, 1, 3.5), kbBase = 32, kbGrowth = 72, kbAngle = 86, selfVelocity = Vector2.new(-20, 0),
			windup = { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 160, 0, -20 }, RE = { 100, 0, 0 }, LS = { 160, 0, 20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 28, 0, 0, 0, -0.15, 0.35 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { -30, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { 32, 0, 0, 0, -0.15, 0.45 }, Waist = { 14, 0, 0 }, Neck = { 24, 0, 0 }, RS = { -35, 0, 65 }, RE = { 20, 0, 0 }, LS = { -35, 0, -65 }, LE = { 20, 0, 0 }, RH = { 160, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 } },
			trail = "rightFoot", fx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.4, speed = 8, size = 1.2 } }, text = "POUF !", hitText = "KOF KOF !",
		},
		-- ↑ K K : Chandelle de cabaret, coup de pied tendu à la verticale, l'autre jambe pliée, bras en V
		K_upK = {
			label = "Chandelle de cabaret", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4.5, 5, 2.5, 3), kbBase = 30, kbGrowth = 55, kbAngle = 85,
			windup = { Root = { 8, 0, 0, 0, 0.1, 0 }, Waist = { 8, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 } },
			strike = { Root = { 22, 0, 0, 0, 0.3, 0 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, RH = { 160, 0, 0 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { 26, 0, 0, 0, 0.35, 0 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 155, 0, 45 }, RE = { 10, 0, 0 }, LS = { 155, 0, -45 }, LE = { 10, 0, 0 }, RH = { 168, 0, 0 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TCHAC !",
		},
		-- Double vernies (K en l'air) : il replie les genoux sous la cape puis détend les deux pieds devant
		K_air = {
			label = "Double vernies", startup = 0.17, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -130, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 20, 0, 0 }, Waist = { 20, 0, 0 }, RS = { -30, 0, 60 }, RE = { 10, 0, 0 }, LS = { -30, 0, -60 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 80, 0, 0 }, LK = { -5, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 24, 0, 0 }, Waist = { 22, 0, 0 }, RS = { -38, 0, 66 }, RE = { 10, 0, 0 }, LS = { -38, 0, -66 }, LE = { 10, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 86, 0, 0 }, LK = { -4, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "bothFeet", hitText = "CLIC-CLAC !",
		},
		-- Glissade sur cape (dash puis K) : il glisse sur sa cape comme sur un tapis, pied droit en avant
		K_dash = {
			label = "Glissade sur cape", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 65, kbAngle = 45, selfVelocity = Vector2.new(52, 0),
			windup = { Root = { -10, 0, 0, 0, -0.45, 0 }, Waist = { -12, 0, 0 }, RS = { 50, 0, 40 }, LS = { 50, 0, -40 } },
			strike = { Root = { 30, 0, 0, 0, -1.2, 0 }, Waist = { -8, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 32, 0, 0, 0, -1.25, 0 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 15, 0, 75 }, RE = { 10, 0, 0 }, LS = { 125, 0, -42 }, LE = { 30, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 42, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, hitText = "ZOUIP !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (J / K)
		-- → J en l'air : Disparition volante, pouf de fumée, il réapparaît un peu plus loin en donnant un coup de baguette
		P_air_side = {
			label = "Disparition volante", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 3, 3, 0.5), kbBase = 22, kbGrowth = 40, kbAngle = 30, teleport = 4,
			windup = { Root = { 0, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, -40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 40 }, LE = { 120, 0, 0 }, RH = { 80, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { -6, 10, 0 }, Waist = { -6, 14, 0 }, RS = { 95, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -8, 12, 0 }, Waist = { -8, 16, 0 }, RS = { 92, 0, 20 }, RE = { 8, 0, 0 }, RW = { -15, 0, 0 }, LS = { 35, 0, -75 }, LE = { 20, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 55, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "prop", windupFx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.2, speed = 6, size = 1.2 } },
			fx = { { "burst", color = SMOKE, size = 2.5, at = "root" } }, text = "POUF !", hitText = "BZING !",
		},
		-- ↑ J en l'air : Arc-en-ciel de baguette, la baguette dessine un grand arc d'étoiles au-dessus de sa tête
		P_air_up = {
			label = "Arc-en-ciel de baguette", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 20 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 18, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 195, 0, -10 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -30, 0, -55 }, LE = { 20, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", fx = { { "symbols", symbols = { "✨", "★" }, color = SPARK, count = 5, radius = 3, at = "above" } }, hitText = "TWINKLE !",
		},
		-- ↓ J en l'air : Chapeau plongeant, il pique tête la première, le haut-de-forme en avant (smash vers le sol)
		P_air_down = {
			label = "Chapeau plongeant", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(4, -45),
			windup = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -30 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -120, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 10, 0, 0 }, RH = { 0, 0, 5 }, RK = { -10, 0, 0 }, RA = { -25, 0, 0 }, LH = { 0, 0, -5 }, LK = { -10, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -125, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 25 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -25 }, LE = { 10, 0, 0 }, RH = { -5, 0, 5 }, RK = { -15, 0, 0 }, RA = { -25, 0, 0 }, LH = { -5, 0, -5 }, LK = { -15, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "head", text = "CHAPEAU !", hitText = "BONK !",
		},
		-- → K en l'air : Canne volante, il balaie l'air devant lui avec la canne, à bout de bras
		K_air_side = {
			label = "Canne volante", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(6, 3, 3.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -6, 30, 0 }, Waist = { -6, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 70, 0, 80 }, LE = { 40, 0, 0 }, LW = { 90, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 6, -20, 0 }, Waist = { 0, -26, 0 }, Neck = { 0, 16, 0 }, RS = { 20, 0, 60 }, RE = { 30, 0, 0 }, LS = { 90, 0, -20 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 8, -30, 0 }, Waist = { 2, -34, 0 }, Neck = { 0, 22, 0 }, RS = { 15, 0, 62 }, RE = { 30, 0, 0 }, LS = { 85, 0, -50 }, LE = { 5, 0, 0 }, LW = { 90, 0, 0 }, RH = { 15, 0, 0 }, RK = { -45, 0, 0 }, LH = { 65, 0, 0 }, LK = { -55, 0, 0 } },
			prop = "canne", trail = "leftHand", hitText = "VLAN !",
		},
		-- ↑ K en l'air : Salto de cape, salto arrière, la cape claque au-dessus de lui
		K_air_up = {
			label = "Salto de cape", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(5, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 165, 0, 45 }, RE = { 10, 0, 0 }, LS = { 165, 0, -45 }, LE = { 10, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { -20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "body", hitText = "FLAP !",
		},
		-- ↓ K en l'air : Talon de prestidigitateur, il retombe talons joints, la cape en parachute (smash vers le sol)
		K_air_down = {
			label = "Talon de prestidigitateur", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 70 }, RE = { 10, 0, 0 }, LS = { 150, 0, -70 }, LE = { 10, 0, 0 }, RH = { -4, 0, 3 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { -4, 0, -3 }, LK = { 0, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 160, 0, 78 }, RE = { 10, 0, 0 }, LS = { 160, 0, -78 }, LE = { 10, 0, 0 }, RH = { -4, 0, 5 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { -4, 0, -5 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "bothFeet", text = "ABRACA-BAM !", hitText = "CLONK !",
		},

		------------------------------------------------------------------ Spéciaux (S) : 3 résultats possibles (🕊️ / 💥 / 🐇)
		-- Tour aléatoire : baguette pointée, formule magique… et un rayon de magie traverse tout le couloir ; il en sort colombe, confettis ou lapin
		S_neutral = {
			label = "Tour aléatoire", startup = 0.2, active = 0.16, recovery = 0.45,
			damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 28, kbGrowth = 55, kbAngle = 40,
			variants = {
				{ label = "Tour aléatoire : colombe !", damage = 12, kbBase = 22, kbGrowth = 35, kbAngle = 60, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !" },
				{ label = "Tour aléatoire : confettis explosifs !", damage = 17, kbBase = 34, kbGrowth = 75, kbAngle = 40, hitText = "BOUM !" },
				{ label = "Tour aléatoire : lapin agressif !", damage = 5, hits = 3, kbBase = 22, kbGrowth = 40, kbAngle = 30, hitText = "CROC CROC CROC !" },
			},
			windup = { Root = { 4, -14, 0, 0, -0.15, 0.1 }, Waist = { 10, -16, 0 }, Neck = { 14, 12, 0 }, RS = { 160, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -70 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, 10, 0, 0, -0.25, -0.35 }, Waist = { -12, 12, 0 }, Neck = { -6, -8, 0 }, RS = { 96, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -80 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -10, 12, 0, 0, -0.25, -0.38 }, Waist = { -12, 14, 0 }, Neck = { -8, -10, 0 }, RS = { 100, 0, -8 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 75, 0, -85 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.1, shake = true, trail = "prop", windupFx = { { "particles", tex = "spark", color = MAGIC, at = "hand", dir = "all", time = 0.2, speed = 5 } },
			fx = { { "beam", color = MAGIC, length = 14, width = 1.4, at = "hand" }, { "burst", color = MAGIC, size = 2.5 }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 3, radius = 3, at = "front" } },
			text = "ABRACADABRA !", hitText = "TA-DA !",
		},
		-- Passe-passe (→L) : cape rabattue devant le visage, il se téléporte à l'autre bout du couloir ; tout ce qui est sur le chemin est sonné
		S_side = {
			label = "Passe-passe", startup = 0.16, active = 0.14, recovery = 0.42,
			damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 22, kbGrowth = 32, kbAngle = 35, teleport = 12, invuln = 0.25,
			variants = {
				{ label = "Passe-passe : nuée de colombes", teleport = 12, damage = 12, status = { name = "stunned", duration = 0.8 }, hitText = "ROUCOULE !" },
				{ label = "Passe-passe : sortie explosive", teleport = 12, damage = 16, kbBase = 30, kbGrowth = 60, hitText = "BOUM !" },
				{ label = "Passe-passe : le lapin s'accroche", teleport = 6, damage = 12, status = { name = "rooted", duration = 1.2 }, hitText = "GRRR !" },
			},
			windup = { Root = { 4, 0, 0, 0, -0.2, 0.1 }, Waist = { 8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, -50 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, 40 }, LE = { 100, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.35, -0.35 }, Waist = { -14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -85 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 6, 0, 0, 0, -0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 } },
			trail = "body", windupFx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.2, speed = 6, size = 1.4 } },
			fx = { { "burst", color = SMOKE, size = 3, at = "root" }, { "beam", color = MAGIC, length = 14, width = 1.2, at = "root" }, { "burst", color = SMOKE, size = 3, at = "front" } }, text = "PASSE-PASSE !", hitText = "OÙ IL EST ?!",
		},
		-- Trappe (↓L) : coup de baguette au sol, une trappe s'ouvre sur toute la longueur du couloir ; qui est dessus tombe… et ressort par le haut
		S_down = {
			label = "Trappe", kind = "trap", startup = 0.2, active = 0.12, recovery = 0.45,
			damage = 13, kbBase = 46, kbGrowth = 60, kbAngle = 90,
			trap = { size = Vector3.new(16, 1, 6), offset = 8, lifetime = 8, max = 1, color = MAGIC,
				visual = { shape = "ball", size = 0.2, color = TUX, trail = false, parts = {
					{ "block", Vector3.new(15, 0.15, 2.6), Vector3.new(0, -0.35, 0), Color3.fromRGB(10, 10, 15) },
					{ "block", Vector3.new(15.6, 0.12, 0.3), Vector3.new(0, -0.3, 1.4), GOLD },
					{ "block", Vector3.new(15.6, 0.12, 0.3), Vector3.new(0, -0.3, -1.4), GOLD },
					{ "block", Vector3.new(0.3, 0.12, 2.8), Vector3.new(7.8, -0.3, 0), GOLD },
					{ "block", Vector3.new(0.3, 0.12, 2.8), Vector3.new(-7.8, -0.3, 0), GOLD },
					{ "block", Vector3.new(3, 0.1, 2.6), Vector3.new(-6, 0.3, 0), Color3.fromRGB(120, 80, 50), "Wood" },
					{ "block", Vector3.new(3, 0.1, 2.6), Vector3.new(6, 0.3, 0), Color3.fromRGB(120, 80, 50), "Wood" },
				} } },
			variants = {
				{ label = "Trappe aux colombes", damage = 12, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !" },
				{ label = "Trappe piégée", damage = 16, kbBase = 50, kbGrowth = 70, hitText = "KABOUM !" },
				{ label = "Trappe du lapin", damage = 12, kbBase = 30, kbGrowth = 40, status = { name = "rooted", duration = 1.5 }, hitText = "GRRR !" },
			},
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.25 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -18, 0, 0, 0, -0.55, -0.3 }, Waist = { -32, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 25, 0, -62 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			trail = "prop", fx = { { "ring", color = MAGIC, radius = 4, at = "front" }, { "beam", color = MAGIC, length = 14, width = 0.8, at = "hand" }, { "symbols", symbols = { "✨", "🎩" }, color = MAGIC, count = 4, radius = 3, at = "front" } },
			text = "SÉSAME…", hitText = "AAAAAH !",
		},
		-- Envol du lapin (remontée) : le lapin jaillit du chapeau, l'attrape par le col et le tire en diagonale vers le ciel ; la cape claque et fauche tout sur le passage
		S_up = {
			label = "Envol du lapin", startup = 0.15, active = 0.32, recovery = 0.45,
			damage = 17, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 56, kbAngle = 80, selfVelocity = Vector2.new(46, 88),
			variants = {
				{ label = "Envol du lapin : colombes porteuses", status = { name = "blinded", duration = 1 }, hitText = "ROUCOULE !" },
				{ label = "Envol du lapin : décollage explosif", kbAngle = 78, kbGrowth = 64, hitText = "KABOUM !" },
				{ label = "Envol du lapin : le lapin tire !", kbBase = 36, hitText = "ZWIIING !" },
			},
			windup = { Root = { 0, 0, 0, 0, -0.7, 0 }, Waist = { -12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 20, 0, 0 } },
			strike = { Root = { -44, 0, 0, 0, 0.3, -0.1 }, Waist = { -4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 24 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -8 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { -26, 0, 5 }, RK = { -34, 0, 0 }, RA = { -30, 0, 0 }, LH = { -32, 0, -5 }, LK = { -44, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -48, 0, 0, 0, 0.35, -0.15 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 156, 0, 28 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { -30, 0, 5 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -5 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
			prop = "lapin", wobble = true, trail = "body", shake = true,
			fx = { { "pillar", color = MAGIC, height = 12, width = 3, at = "root", time = 0.4 }, { "burst", color = SPARK, size = 4.5, at = "feet" }, { "ring", color = MAGIC, radius = 7, at = "feet" },
				{ "particles", tex = "spark", color = MAGIC, at = "feet", dir = "down", time = 0.4, speed = 16, rate = 120, size = 0.4 }, { "symbols", symbols = { "🐇", "✨", "★" }, color = SPARK, count = 6, radius = 4, at = "above" }, { "shake", amount = 0.4 } },
			text = "AÏE, MES OREILLES… ENFIN, SES OREILLES !", hitText = "ZWIIING !",
		},
		-- Abracadabra (L maintenu) : il agite la baguette en grands cercles en psalmodiant, puis la pique en avant : un rayon de magie traverse le couloir et un des trois tours lui profite
		-- (le moteur ne sait pas « garantir le prochain tour » : chaque résultat donne un bonus différent)
		S_hold = {
			label = "Abracadabra", startup = 0.3, active = 0.16, recovery = 0.5,
			damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			selfEffect = { heal = 4 },
			variants = {
				{ label = "Abracadabra : colombe guérisseuse", selfEffect = { heal = 7 }, hitText = "ROUCOULE !" },
				{ label = "Abracadabra : feu d'artifice !", damage = 16, selfEffect = { buff = { "turbo", 4 } }, hitText = "BOUM !" },
				{ label = "Abracadabra : lapin garde du corps", selfEffect = { armor = 2 }, hitText = "CROC !" },
			},
			windup = { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 30, 0, 0 } },
			strike = { Root = { -12, 14, 0, 0, -0.3, -0.35 }, Waist = { -14, 16, 0 }, Neck = { -6, -8, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -80 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 16, 0, 0, -0.3, -0.38 }, Waist = { -14, 18, 0 }, Neck = { -8, -10, 0 }, RS = { 98, 0, -6 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 62, 0, -82 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.3, shake = true, trail = "prop", windupFx = { { "symbols", symbols = { "✨", "★", "✦" }, color = MAGIC, count = 6, radius = 3, at = "above" } },
			fx = { { "beam", color = SPARK, length = 14, width = 1.6, at = "hand" }, { "burst", color = SPARK, size = 3, at = "front" }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 3, radius = 2, at = "above" } }, text = "ABRACADABRAAA !", hitText = "BZZAP !",
		},
		-- Téléportation (→→L) : il s'enroule dans la cape et disparaît… réussi, en l'air, ou raté (il réapparaît derrière) ; la cape s'ouvre d'un grand coup qui balaie tout le couloir
		S_dash = {
			label = "Téléportation", startup = 0.16, active = 0.14, recovery = 0.42,
			damage = 14, hitbox = box(14, 6, 7, 1), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			teleport = 14, invuln = 0.25,
			variants = {
				{ label = "Téléportation réussie !", teleport = 14, hitText = "SURPRISE !" },
				{ label = "Téléportation… en l'air !", teleport = 9, teleportUp = 7, hitText = "OUPS !" },
				{ label = "Téléportation ratée !", teleport = -6, damage = 16, hitText = "BOUM !" },
			},
			windup = { Root = { 0, -60, 0, 0, -0.2, 0 }, Waist = { 0, -20, 0 }, Neck = { -10, 0, 0 }, RS = { 100, 0, -70 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 110, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.2, -0.25 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 88, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, -85 }, LE = { 0, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.2, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 92, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -90 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", windupFx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.25, speed = 6, size = 1.5 } },
			fx = { { "burst", color = SMOKE, size = 4, at = "root" }, { "ring", color = MAGIC, radius = 6, at = "front" }, { "burst", color = MAGIC, size = 3, at = "front" } }, text = "ET HOP !", hitText = "SURPRISE !",
		},
		-- Cartes lancées (esquive puis L) : il lance une grosse carte qui vole droit vers la tête de l'adversaire… et qui change en route
		S_dodge = {
			label = "Cartes lancées", kind = "projectile", startup = 0.16, active = 0, recovery = 0.42,
			damage = 13, kbBase = 22, kbGrowth = 45, kbAngle = 25,
			projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 0.6, size = 1.6, color = WHITE, visual = CARD },
			variants = {
				{ label = "Cartes lancées : la carte devient colombe", damage = 12, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !",
					projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 1.4, size = 1.6, color = WHITE, visual = DOVE, aimed = true, homing = 0.9 } },
				{ label = "Cartes lancées : carte explosive", damage = 16, kbBase = 30, kbGrowth = 60, hitText = "BOUM !",
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 0.85, size = 1.9, color = MAGIC, visual = CONFETTI_BOMB, aimed = true } },
				{ label = "Cartes lancées : le lapin la rapporte", damage = 7, hits = 2, hitText = "CROC !",
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1.5, size = 1.6, color = RABBIT, visual = CARD, returns = true, hits = 2, aimed = true } },
			},
			windup = { Root = { 0, 30, 0, 0, -0.2, 0.15 }, Waist = { 2, 34, 0 }, Neck = { 0, -24, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, 70 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -22, 0, 0, -0.25, -0.3 }, Waist = { -8, -26, 0 }, Neck = { 0, 18, 0 }, RS = { 35, 0, 45 }, RE = { 50, 0, 0 }, LS = { 94, 0, -30 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -8, -28, 0, 0, -0.25, -0.35 }, Waist = { -8, -32, 0 }, Neck = { 0, 22, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 90, 0, -55 }, LE = { 5, 0, 0 }, LW = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "cartes", trail = "leftHand", fx = { { "symbols", symbols = { "♠", "♥", "♣", "♦" }, color = WHITE, count = 4, radius = 2, at = "lhand" } }, text = "VOTRE CARTE ?", hitText = "TCHAK !",
		},
		-- Pluie de colombes (L en l'air) : il ouvre sa cape en grand, et il en tombe quelque chose… droit sur la tête de l'adversaire
		S_air = {
			label = "Pluie de colombes", kind = "projectile", startup = 0.2, active = 0, recovery = 0.45,
			damage = 12, kbBase = 18, kbGrowth = 25, kbAngle = -30,
			projectile = { speed = 50, gravity = 0, lifetime = 1, size = 1.6, color = WHITE, visual = DOVE, rain = { count = 4, spread = 4, ahead = 8, height = 16 } },
			variants = {
				{ label = "Pluie de colombes", damage = 3, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !",
					projectile = { speed = 50, gravity = 0, lifetime = 1.4, size = 1.6, color = WHITE, visual = DOVE, aimed = true, rain = { count = 4, spread = 4, ahead = 8, height = 16 } } },
				{ label = "Pluie de confettis explosifs", damage = 6, kbBase = 22, kbGrowth = 35, hitText = "BOUM !",
					projectile = { speed = 50, gravity = 0, lifetime = 1.4, size = 1.8, color = MAGIC, visual = CONFETTI_BOMB, aimed = true, rain = { count = 3, spread = 3, ahead = 8, height = 16 } } },
				{ label = "Pluie de… un lapin ?!", damage = 14, kbBase = 28, kbGrowth = 55, kbAngle = -50, hitText = "CROC !",
					projectile = { speed = 45, gravity = 0, lifetime = 1.5, size = 2.6, color = RABBIT, visual = BUNNY, aimed = true, rain = { count = 1, spread = 1, ahead = 8, height = 16 } } },
			},
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 100, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 140, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -80 }, LE = { 10, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 20, 0, -10 }, LK = { -40, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 150, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -85 }, LE = { 10, 0, 0 }, RH = { 15, 0, 12 }, RK = { -35, 0, 0 }, LH = { 15, 0, -12 }, LK = { -35, 0, 0 } },
			hold = 0.15, fx = { { "symbols", symbols = { "🕊️", "✨" }, color = WHITE, count = 5, radius = 4, at = "above" }, { "burst", color = WHITE, size = 3, at = "above" } }, text = "ENVOLEZ-VOUS !", hitText = "ROUCOULE !",
		},
		-- Piqué des colombes (↓L en l'air, plongeon) : il pique vers le sol, cape grande ouverte, et écrase tout ce qui est en dessous en lâchant des colombes
		S_air_down = {
			label = "Piqué des colombes", startup = 0.16, active = 0.36, recovery = 0.45,
			damage = 14, hitbox = box(8, 5, 1, -2), kbBase = 26, kbGrowth = 56, kbAngle = -50, selfVelocity = Vector2.new(15, -80),
			variants = {
				{ label = "Piqué des colombes", damage = 12, status = { name = "blinded", duration = 2 }, hitText = "ROUCOULE !" },
				{ label = "Piqué aux confettis", damage = 16, kbBase = 30, kbGrowth = 65, hitText = "BADABOUM !" },
				{ label = "Piqué du lapin", damage = 13, status = { name = "stunned", duration = 0.6 }, hitText = "CROC !" },
			},
			windup = { Root = { 20, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -65, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 120, 0, 80 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -80 }, LE = { 0, 0, 0 }, RH = { -10, 0, 5 }, RK = { -15, 0, 0 }, RA = { -25, 0, 0 }, LH = { -10, 0, -5 }, LK = { -25, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -70, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 125, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 125, 0, -85 }, LE = { 0, 0, 0 }, RH = { -15, 0, 5 }, RK = { -25, 0, 0 }, RA = { -25, 0, 0 }, LH = { -5, 0, -5 }, LK = { -15, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "body", fx = { { "toss", shape = "ball", color = WHITE, count = 4, size = 0.8, speed = 16 }, { "burst", color = WHITE, size = 3.5, at = "feet" }, { "shake", amount = 0.3 } }, text = "EN PIQUÉ !", hitText = "FLAP-FLAP !",
		},

		------------------------------------------------------------------ Suites d'enchaînement
		-- J puis K : Croc-en-jambe de scène, petit coup de pied sec dans le tibia en saluant
		PK_combo = {
			label = "Croc-en-jambe de scène", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 3, -1), kbBase = 22, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 6, -12, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 30, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 }, RH = { -20, 0, 8 }, RK = { -70, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.3, -0.2 }, Waist = { -8, 8, 0 }, Neck = { 0, 0, 0 }, RS = { 130, 0, 60 }, RE = { 20, 0, 0 }, LS = { 70, 0, -35 }, LE = { 60, 0, 0 }, RH = { 62, 0, 6 }, RK = { -5, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.32, -0.25 }, Waist = { -10, 10, 0 }, Neck = { 0, 0, 0 }, RS = { 135, 0, 62 }, RE = { 20, 0, 0 }, LS = { 72, 0, -35 }, LE = { 60, 0, 0 }, RH = { 66, 0, 0 }, RK = { -8, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- K puis J : Revers de baguette, il pivote et fouette du revers de la baguette
		KP_combo = {
			label = "Revers de baguette", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 3.5, 2.6, 0.6), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { -6, 24, 0, 0, -0.25, -0.2 }, Waist = { -8, 34, 0 }, RS = { 70, 0, -40 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, -14, 0, 0, -0.28, -0.35 }, Waist = { -10, -24, 0 }, RS = { 95, 0, 35 }, RE = { 8, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			follow = { Root = { -8, -22, 0, 0, -0.28, -0.38 }, Waist = { -10, -34, 0 }, RS = { 85, 0, 55 }, RE = { 15, 0, 0 }, RW = { -15, 0, 0 }, LS = { 45, 0, -45 }, LE = { 60, 0, 0 } },
			trail = "prop", hitText = "FWIP !",
		},
		-- J J J J : Lapin catapulté, il sort le lapin grognon du chapeau et le lance à bout de bras sur l'adversaire, qui mord
		P_combo4 = {
			label = "Lapin catapulté", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5.5, 4, 3, 0.8), kbBase = 34, kbGrowth = 80, kbAngle = 42,
			windup = { Root = { 6, 16, 0, 0, -0.1, 0.2 }, Waist = { 10, 18, 0 }, Neck = { 14, -10, 0 }, LS = { 175, 0, -20 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 } },
			strike = { Root = { -14, -14, 0, 0, -0.3, -0.4 }, Waist = { -16, -16, 0 }, Neck = { -4, 10, 0 }, LS = { 95, 0, 4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 50 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, -16, 0, 0, -0.32, -0.45 }, Waist = { -18, -18, 0 }, Neck = { -6, 12, 0 }, LS = { 98, 0, 0 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, RS = { 18, 0, 52 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "lapin", trail = "leftHand", fx = { { "burst", color = RABBIT, size = 3, at = "front" }, { "symbols", symbols = { "🐇", "💢", "GRRR" }, color = RABBIT, count = 4, radius = 3, at = "front" } },
			text = "ET MERCI, LE LAPIN !", hitText = "CROC !",
		},
		-- → J J J : Foulard géant, la guirlande de foulards n'en finit plus : il tourne sur lui-même et fouette tout le tour
		P_side3 = {
			label = "Foulard géant", startup = 0.1, active = 0.16, recovery = 0.3,
			damage = 11, hitbox = box(6.5, 4, 2.5, 0.5), kbBase = 34, kbGrowth = 76, kbAngle = 45,
			windup = { Root = { 2, 30, 0, 0, -0.2, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 0, -20, 0 }, LS = { 60, 0, 50 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 }, RS = { 50, 0, 30 }, RE = { 60, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.25, -0.2 }, Waist = { -6, 0, 0 }, Neck = { -6, 0, 0 }, LS = { 92, 0, -85 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 70, 0, 80 }, RE = { 10, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.25, -0.2 }, Waist = { -6, 0, 0 }, Neck = { -8, 0, 0 }, LS = { 92, 0, -88 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, RS = { 72, 0, 82 }, RE = { 10, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, prop = "foulard", trail = "leftHand", fx = { { "ring", color = VELVET, radius = 5, at = "root" }, { "symbols", symbols = { "🧣", "✨" }, color = PINK, count = 5, radius = 3.5 } },
			text = "ET ENCORE, ET ENCORE !", hitText = "FLOUF-FLOUF !",
		},
		-- → K K K : Swing de canne, l'adversaire ramené contre lui, il prend la canne à deux mains et swingue de bas en haut : envolez-vous !
		K_side3 = {
			label = "Swing de canne", startup = 0.1, active = 0.12, recovery = 0.34,
			damage = 13, hitbox = box(5.5, 5, 2.8, 1), kbBase = 36, kbGrowth = 84, kbAngle = 75,
			windup = { Root = { -8, 24, 0, 0, -0.45, 0.1 }, Waist = { -16, 26, 0 }, Neck = { 6, -16, 0 }, LS = { -20, 0, 10 }, LE = { 10, 0, 0 }, LW = { 90, 0, 0 }, RS = { -10, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 } },
			strike = { Root = { 8, -20, 0, 0, 0.05, -0.2 }, Waist = { 14, -24, 0 }, Neck = { 24, 10, 0 }, LS = { 150, 0, -10 }, LE = { 10, 0, 0 }, LW = { 90, 0, 0 }, RS = { 140, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 10, -26, 0, 0, 0.08, -0.25 }, Waist = { 16, -30, 0 }, Neck = { 28, 12, 0 }, LS = { 165, 0, -14 }, LE = { 10, 0, 0 }, LW = { 90, 0, 0 }, RS = { 150, 0, 8 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			prop = "canne", trail = "leftHand", fx = { { "burst", color = GOLD, size = 3, at = "front" }, { "symbols", symbols = { "⛳", "✨", "★" }, color = GOLD, count = 4, radius = 3, at = "above" } },
			text = "ET HOP, EN L'AIR !", hitText = "TCHONK !",
		},
		-- K J K : Claquettes, numéro de claquettes à toute vitesse dans les tibias, mains en jazz, chaussures qui étincellent
		KPK_combo = {
			label = "Claquettes", startup = 0.08, active = 0.24, recovery = 0.3, hits = 3,
			damage = 4, hitbox = box(5, 3.5, 2.8, -0.5), kbBase = 30, kbGrowth = 68, kbAngle = 40,
			windup = { Root = { 4, 0, 0, 0, -0.15, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 80 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -80 }, LE = { 40, 0, 0 }, RH = { -10, 0, 0 }, RK = { -60, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.05, -0.2 }, Waist = { -6, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 85 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -85 }, LE = { 20, 0, 0 }, RH = { 60, 0, 6 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
			follow = { Root = { -6, -10, 0, 0, -0.05, -0.2 }, Waist = { -6, -8, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 85 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -85 }, LE = { 20, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, LH = { 60, 0, -6 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
			wobble = true, trail = "bothFeet", fx = { { "symbols", symbols = { "♪", "♫", "✦" }, color = SPARK, count = 5, radius = 3, at = "feet" }, { "particles", tex = "spark", color = SPARK, at = "feet", dir = "all", time = 0.25, speed = 6, size = 0.3 } },
			text = "SHUFFLE !", hitText = "CLAC CLAC CLAC !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement), elles aussi à 3 résultats
		-- Pouf magique : baguette tendue, un gros nuage magique traverse le couloir et éclate sur l'adversaire
		S_finish_poof = {
			label = "Pouf magique", startup = 0.15, active = 0.14, recovery = 0.4,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 30, kbGrowth = 55, kbAngle = 40,
			variants = {
				{ label = "Pouf magique : envol de colombes", damage = 12, kbAngle = 70, status = { name = "blinded", duration = 1.2 }, hitText = "ROUCOULE !" },
				{ label = "Pouf magique : confettis !", damage = 15, kbBase = 34, kbGrowth = 68, hitText = "BOUM !" },
				{ label = "Pouf magique : lapin teigneux", damage = 5, hits = 3, kbBase = 24, hitText = "CROC CROC CROC !" },
			},
			windup = { Root = { 0, -14, 0, 0, -0.2, 0.15 }, Waist = { 0, -16, 0 }, RS = { 70, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.28, -0.3 }, Waist = { -8, 12, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -80 }, LE = { 20, 0, 0 } },
			follow = { Root = { -10, 12, 0, 0, -0.3, -0.32 }, Waist = { -10, 14, 0 }, RS = { 98, 0, -5 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 25, 0, -82 }, LE = { 20, 0, 0 } },
			shake = true, trail = "prop", fx = { { "burst", color = MAGIC, size = 3.5 }, { "particles", tex = "smoke", color = MAGIC, at = "front", dir = "front", time = 0.3, speed = 16, size = 1 } }, text = "POUF !", hitText = "PAF-POUF !",
		},
		-- Chapeau boomerang : il lance son haut-de-forme qui tournoie droit sur l'adversaire et revient (le lapin s'y cramponne)
		S_finish_hat = {
			label = "Chapeau boomerang", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
			damage = 12, kbBase = 26, kbGrowth = 50, kbAngle = 35,
			projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1, size = 1.8, color = TUX, visual = HAT, returns = true },
			variants = {
				{ label = "Chapeau boomerang : une colombe en sort", damage = 12, status = { name = "blinded", duration = 1.2 }, hitText = "ROUCOULE !" },
				{ label = "Chapeau boomerang : il explose !", damage = 15, kbBase = 32, kbGrowth = 62, hitText = "BOUM !" },
				{ label = "Chapeau boomerang : le lapin mord au passage", damage = 7, hitText = "CROC !",
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1.4, size = 1.8, color = TUX, visual = HAT, returns = true, hits = 2, aimed = true } },
			},
			windup = { Root = { 6, -24, 0, 0, -0.2, 0.2 }, Waist = { 8, -28, 0 }, Neck = { 0, 18, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 175, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, 20, 0, 0, -0.3, -0.25 }, Waist = { -10, 26, 0 }, Neck = { 0, -16, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 90, 0, -30 }, LE = { 0, 0, 0 } },
			follow = { Root = { -10, 26, 0, 0, -0.3, -0.3 }, Waist = { -12, 32, 0 }, Neck = { 0, -20, 0 }, RS = { 28, 0, 52 }, RE = { 50, 0, 0 }, LS = { 85, 0, -55 }, LE = { 5, 0, 0 } },
			trail = "leftHand", text = "ET HOP, LE CHAPEAU !", hitText = "TCHONK !",
		},

		------------------------------------------------------------------ Supers
		-- Le Grand Final : il tire un immense rideau de scène sur tout le couloir… l'adversaire disparaît derrière et réapparaît sonné (ou pire)
		SUPER = {
			label = "Le Grand Final !", startup = 0.4, active = 0.2, recovery = 0.7,
			damage = 24, hitbox = box(14, 7, 7, 1), kbBase = 22, kbGrowth = 35, kbAngle = 70,
			status = { name = "stunned", duration = 2 },
			variants = {
				{ label = "Le Grand Final : disparu dans un nuage de colombes !", status = { name = "stunned", duration = 2 }, hitText = "OÙ SUIS-JE ?" },
				{ label = "Le Grand Final : feu d'artifice !", damage = 28, kbBase = 30, kbGrowth = 50, hitText = "KABOUM !" },
				{ label = "Le Grand Final : il ressort en lapin !", status = { name = "dog", duration = 2 }, hitText = "COUIC ?!" },
			},
			windup = { Root = { 6, -20, 0, 0, -0.1, 0.2 }, Waist = { 10, -20, 0 }, Neck = { 15, 10, 0 }, RS = { 170, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -12, 20, 0, 0, -0.3, -0.35 }, Waist = { -14, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 100, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 30 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 10, 0, 0, 0, -0.5, 0 }, Waist = { -40, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 } },
			hold = 0.5, windupFx = { "super" },
			fx = { { "screen", color = VELVET, alpha = 0.45 }, { "pillar", color = VELVET, height = 10, width = 5, at = "front", neon = false, transparency = 0, time = 0.6 }, { "beam", color = VELVET, length = 14, width = 7, at = "root", time = 0.5 }, { "symbols", symbols = { "✨", "🎩", "★" }, color = SPARK, count = 8, radius = 5, at = "front" } },
			text = "MESDAMES ET MESSIEURS… TA-DAAAA !", hitText = "OÙ SUIS-JE ?",
		},
		-- Super → : Lapin-canon, il sort un canon de cirque de sous sa cape, y fourre le lapin grognon par les oreilles et allume la mèche :
		-- le lapin traverse tout le couloir comme un boulet… et comme toujours, le tour a 3 fins possibles
		SUPER_side = {
			label = "Lapin-canon !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 24, kbBase = 46, kbGrowth = 92, kbAngle = 30,
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = RABBIT, visual = BUNNY, pierce = true },
			variants = {
				{ label = "Lapin-canon : une volée de colombes !", damage = 22, status = { name = "blinded", duration = 2.5 }, hitText = "ROUCOULE !",
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1.2, size = 3, color = WHITE, visual = DOVE, aimed = true, pierce = true, fan = { count = 3, from = -10, to = 10 } } },
				{ label = "Lapin-canon : le canon explose !", damage = 28, kbBase = 52, kbGrowth = 100, hitText = "KABOUM !",
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.9, size = 3.4, color = MAGIC, visual = CONFETTI_BOMB, aimed = true, pierce = true } },
				{ label = "Lapin-canon : le lapin mord !", damage = 24, status = { name = "rooted", duration = 2 }, hitText = "CROC !",
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = RABBIT, visual = BUNNY, aimed = true, pierce = true } },
			},
			windup = { Root = { 8, -30, 0, 0, -0.3, 0.3 }, Waist = { 12, -34, 0 }, Neck = { 10, 24, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, 24, 0, 0, -0.36, -0.45 }, Waist = { -18, 28, 0 }, Neck = { -8, -16, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -18, 28, 0, 0, -0.38, -0.5 }, Waist = { -22, 32, 0 }, Neck = { -10, -18, 0 }, RS = { 100, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 26, 0, -74 }, LE = { 20, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
			prop = "lapin", shake = true, windupFx = { "super", { "symbols", symbols = { "🐇", "💣", "🎪" }, count = 6, radius = 3, color = SPARK } },
			fx = { { "burst", color = SPARK, size = 4, at = "hand" }, { "beam", color = SMOKE, length = 12, width = 2.5, at = "hand" }, { "particles", tex = "smoke", color = SMOKE, at = "hand", dir = "front", time = 0.3, speed = 18, rate = 90 }, { "shake", amount = 0.4 } },
			text = "FEU, MON LAPIN !", hitText = "GRRR-BOUM !",
		},
		-- Super ↑ : Lévitation ratée, assis en lotus il psalmodie… et décolle pour de bon en toupie, dans un tourbillon d'étincelles qui fauche tout le couloir
		SUPER_up = {
			label = "Lévitation ratée !", startup = 0.3, active = 0.45, recovery = 0.7,
			damage = 24, hitbox = box(14, 12, 7, 4), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -6, 0, 0, 0, -0.7, 0 }, Waist = { -16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 170, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 110, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 6, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 60, 0, 70 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 60, 0, -70 }, LE = { 110, 0, 0 }, LW = { -40, 0, 0 }, RH = { 95, 0, 55 }, RK = { -125, 0, 0 }, LH = { 95, 0, -55 }, LK = { -125, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.6, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 65, 0, 75 }, RE = { 110, 0, 0 }, RW = { -40, 0, 0 }, LS = { 65, 0, -75 }, LE = { 110, 0, 0 }, LW = { -40, 0, 0 }, RH = { 98, 0, 58 }, RK = { -128, 0, 0 }, LH = { 98, 0, -58 }, LK = { -128, 0, 0 } },
			hold = 0.2, spin = { axis = "y", degrees = 720 }, selfVelocity = Vector2.new(0, 70), wobble = true,
			windupFx = { "super", { "symbols", symbols = { "✨", "★", "✦" }, color = MAGIC, count = 6, radius = 3, at = "above" } }, trail = "prop",
			variants = { { label = "Lévitation ratée : colombes !", hitText = "ROUCOU !" }, { label = "Lévitation ratée : BOUM !", damage = 28, hitText = "KABOUM !" }, { label = "Lévitation ratée : lapin !", status = { name = "dog", duration = 2 }, hitText = "COUIC !" } },
			fx = { { "particles", tex = "spark", color = MAGIC, dir = "all", at = "root", time = 0.7 }, { "ring", color = MAGIC, radius = 8, at = "feet" }, { "burst", color = SPARK, size = 4, at = "above" }, { "shake", amount = 0.4 } },
			text = "OMMMM… ABRACADA… OUPS !", hitText = "TA-DAAA !",
		},
		-- Vol à la tire : son bras s'allonge comme un télescope à travers tout le couloir, serre la main de l'adversaire, lui fait les poches… et le laisse muet de stupeur
		-- (le moteur ne sait pas voler la jauge Super : il lui chipe un peu de santé et le rend muet)
		SUPER_down = {
			label = "Vol à la tire !", startup = 0.35, active = 0.18, recovery = 0.65,
			damage = 22, hitbox = box(14, 6, 7, 1), kbBase = 20, kbGrowth = 30, kbAngle = 30,
			status = { name = "muted", duration = 3 }, selfEffect = { heal = 6 },
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.35, -0.45 }, Waist = { -18, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, 6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 6, 30, 0, 0, -0.2, 0.2 }, Waist = { 8, 30, 0 }, Neck = { 20, -20, 0 }, RS = { 150, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 120, 0, 0 } },
			hold = 0.3, trail = "leftHand", windupFx = { "super" },
			fx = { { "beam", color = WHITE, length = 14, width = 1, at = "lhand", time = 0.3 }, { "symbols", symbols = { "💰", "⭐", "✨" }, color = SPARK, count = 6, radius = 3, at = "front" } },
			text = "MERCI POUR LE POURBOIRE !", hitText = "HÉ ! MON PORTEFEUILLE !",
		},

		------------------------------------------------------------------ Chope (bouton ✋) et projections
		-- Prise magique : il ôte son chapeau d'un grand geste et le rabat sur l'adversaire, qui disparaît dedans
		GRAB = {
			label = "Prise magique", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, -0.05, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 100, 0, 60 }, RE = { 30, 0, 0 }, LS = { 175, 0, -10 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, -10 }, RE = { 50, 0, 0 }, LS = { 100, 0, 10 }, LE = { 30, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.15, -0.3 }, Waist = { -12, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 82, 0, -16 }, RE = { 60, 0, 0 }, LS = { 95, 0, 14 }, LE = { 40, 0, 0 } },
			fx = { { "particles", tex = "spark", color = MAGIC, at = "front", dir = "all", time = 0.2, speed = 6 } }, text = "UN VOLONTAIRE !", hitText = "HOP !",
		},
		-- ✋ puis → : Et hop !, coup de baguette sur le chapeau : l'adversaire en ressort devant, propulsé
		THROW_fwd = {
			label = "Et hop !", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 25,
			carry = { { 0, 2.4, 0.4 }, { 0.16, 2.4, 1.2 }, { 0.32, 4.5, 0.5 } },
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 70, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -20, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.4 }, Waist = { -22, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 95, 0, -15 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			fx = { { "burst", color = SMOKE, size = 3 } }, text = "ET HOP !", hitText = "PLOP !",
		},
		-- ✋ puis ← : Boîte coupée en deux, une boîte de magie se referme sur l'adversaire et l'éjecte derrière Gaston
		THROW_back = {
			label = "Boîte coupée en deux", kind = "throw", back = true, startup = 0.42, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 36, kbGrowth = 68, kbAngle = 40,
			carry = { { 0, 2.2, 0.3 }, { 0.15, 2.2, 0.3 }, { 0.28, 0.5, 1.5 }, { 0.42, -2.6, 0.4 } },
			windup = { Root = { 0, 30, 0, 0, -0.2, 0 }, Waist = { 4, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 120, 0, 40 }, RE = { 30, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 0, -120, 0, 0, -0.35, 0 }, Waist = { -10, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, LS = { 90, 0, -80 }, LE = { 10, 0, 0 } },
			follow = { Root = { 0, -150, 0, 0, -0.35, 0 }, Waist = { -10, -30, 0 }, Neck = { 0, 34, 0 }, RS = { 95, 0, 85 }, RE = { 10, 0, 0 }, LS = { 95, 0, -85 }, LE = { 10, 0, 0 } },
			fx = { { "burst", color = VELVET, size = 3 } }, text = "ET JE COUPE…", hitText = "CLAC-CLAC !",
		},
		-- ✋ puis ↑ : Lapin furieux, le lapin jaillit du chapeau et bouscule l'adversaire vers le ciel
		THROW_up = {
			label = "Lapin furieux", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.15, 2, 0 }, { 0.3, 0.8, 4.2 } },
			windup = { Root = { -6, 0, 0, 0, -0.4, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, LS = { 50, 0, -10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.2, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 60, 0, 70 }, RE = { 10, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.25, -0.1 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 65, 0, 75 }, RE = { 10, 0, 0 }, LS = { 180, 0, -12 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "lapin", text = "GRRRR !", hitText = "BOUM-LAPIN !",
		},
		-- ✋ puis ↓ : Tour raté, l'adversaire ressort du chapeau… et c'est le chapeau qui lui tombe dessus
		THROW_down = {
			label = "Tour raté", kind = "throw", startup = 0.4, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 72,
			carry = { { 0, 2.2, 0.3 }, { 0.15, 2.2, 2 }, { 0.4, 2.4, -2.2 } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, -10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.5, -0.4 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 5 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.3, -0.3 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			fx = { "dust", { "symbols", symbols = { "🎩" }, count = 2, color = WHITE, radius = 1, at = "front" } }, text = "OUPS…", hitText = "BONK !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "la_disparition", label = "La Disparition", sequence = { "forward", "back", "up" },
			-- rideau ! l'adversaire disparaît… et il n'en reste qu'un lapin dans le chapeau
			scene = {
				{ "fxAttacker", { "text", text = "REGARDEZ BIEN…", color = SPARK } },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, -1.6), life = 1.6, pieces = {
					{ "Rideau", "", "block", Vector3.new(5, 7, 0.3), Vector3.new(0, 0.5, 0), Vector3.new(0, 0, 0), VELVET, "Fabric" },
					{ "Tringle", "", "cyl", Vector3.new(5.6, 0.25, 0.25), Vector3.new(0, 4.1, 0), Vector3.new(0, 0, 0), GOLD, "Metal", { axis = "x" } },
					{ "Frange", "", "block", Vector3.new(5, 0.3, 0.35), Vector3.new(0, -3, 0), Vector3.new(0, 0, 0), GOLD, "Fabric" },
				} },
				{ "wait", 0.6 },
				{ "hide" },
				{ "fx", { "burst", color = SMOKE, size = 5 } },
				{ "wait", 1 },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.3, 0), life = 3, pieces = {
					{ "Chapeau", "", "cyl", Vector3.new(1.4, 1.4, 1.4), Vector3.new(0, 0.7, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
					{ "Bord", "", "cyl", Vector3.new(0.12, 2.2, 2.2), Vector3.new(0, 0.06, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
					{ "TeteLapin", "", "ball", Vector3.new(0.9, 0.8, 0.8), Vector3.new(0, 1.6, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
					{ "OreilleG", "", "ball", Vector3.new(0.25, 1, 0.2), Vector3.new(-0.2, 2.4, 0), Vector3.new(0, 0, 10), RABBIT, "Fabric" },
					{ "OreilleD", "", "ball", Vector3.new(0.25, 1, 0.2), Vector3.new(0.2, 2.4, 0), Vector3.new(0, 0, -10), RABBIT, "Fabric" },
				} },
				{ "text", "COUIC ?!" },
				{ "fxAttacker", { "text", text = "TA-DAAAA !", color = SPARK } },
				{ "fxAttacker", { "symbols", symbols = { "✨", "👏" }, count = 6, color = SPARK } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "coupe_en_deux", label = "Coupé en deux", sequence = { "down", "down", "up" },
			-- le tour de la boîte : les deux moitiés partent chacune de leur côté en se disputant
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 1.6, pieces = {
					{ "Boite", "", "block", Vector3.new(3, 5, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), SATIN, "WoodPlanks" },
					{ "Etoile", "", "ball", Vector3.new(0.8, 0.8, 0.1), Vector3.new(0, 1, -1.55), Vector3.new(0, 0, 0), SPARK, "Neon" },
					{ "Scie", "", "block", Vector3.new(4.5, 0.2, 3.6), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 200, 210), "Metal" },
				} },
				{ "hide" },
				{ "fxAttacker", { "text", text = "ET JE SCIE… JE SCIE…", color = WHITE } },
				{ "fx", { "particles", tex = "spark", color = SPARK, at = "root", dir = "all", time = 1, speed = 8 } },
				{ "wait", 1.4 },
				{ "spawn", at = "target", offset = Vector3.new(-3, 1, 0), life = 2.2, pieces = {
					{ "MoitieHaut", "", "block", Vector3.new(3, 2.5, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, 10), SATIN, "WoodPlanks" },
				} },
				{ "spawn", at = "target", offset = Vector3.new(3, -1.2, 0), life = 2.2, pieces = {
					{ "MoitieBas", "", "block", Vector3.new(3, 2.5, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, -10), SATIN, "WoodPlanks" },
				} },
				{ "text", "C'EST TA FAUTE ! — NON, LA TIENNE !" },
				{ "wait", 1.4 },
			},
		},
		{
			id = "tour_rate", label = "Tour raté", sequence = { "back", "forward", "down" },
			-- Gaston se transforme lui-même en lapin… et c'est le vrai lapin qui achève l'adversaire d'une pichenette
			scene = {
				{ "fxAttacker", { "text", text = "ABRACADA… OH NON.", color = SPARK } },
				{ "fxAttacker", { "burst", color = SMOKE, size = 5, at = "root" } },
				{ "spawn", at = "attacker", offset = Vector3.new(0, -1.5, 0), life = 3.5, pieces = {
					{ "LapinGaston", "", "ball", Vector3.new(1.6, 2, 1.4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
					{ "Moustache", "", "block", Vector3.new(0.9, 0.15, 0.1), Vector3.new(0, 0.5, -0.72), Vector3.new(0, 0, 0), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
					{ "MiniChapeau", "", "cyl", Vector3.new(0.8, 0.7, 0.7), Vector3.new(0, 1.4, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
				} },
				{ "wait", 0.8 },
				{ "spawn", at = "between", offset = Vector3.new(0, -1.5, 0), life = 2.5, pieces = {
					{ "VraiLapin", "", "ball", Vector3.new(1.2, 1.4, 1), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
					{ "OreilleG", "", "ball", Vector3.new(0.25, 1, 0.2), Vector3.new(-0.2, 1.1, 0), Vector3.new(0, 0, 10), RABBIT, "Fabric" },
					{ "OreilleD", "", "ball", Vector3.new(0.25, 0.9, 0.2), Vector3.new(0.3, 1, 0), Vector3.new(0, 0, -40), RABBIT, "Fabric" },
				} },
				{ "text", "… UN LAPIN ?" },
				{ "wait", 0.5 },
				{ "fx", { "text", text = "PICHENETTE.", color = WHITE } },
				{ "spin", 720, time = 0.6, axis = "y" },
				{ "launch", Vector3.new(50, 70, 0), time = 1 },
				{ "wait", 0.5 },
			},
		},
	},

	-- Mécanique : Tours ratés, 3 résultats par spécial, le prochain est annoncé (voir server/Mechanics.lua)
	passive = { kind = "tricks", name = "Tours ratés", icon = "🎩", icons = { "🕊️", "💥", "🐇" }, color = MAGIC },

	-- Recharge ⚡ : il tente un tour de cartes (elles s'envolent partout), puis tend la baguette au lapin du chapeau
	-- qui la recharge à contrecœur.
	charge = {
		label = "Tour de cartes",
		loop = 1.8,
		lockWrist = true,
		color = MAGIC,
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, -20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 20 }, LE = { 90, 0, 0 } } },
			{ 0.25, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, -10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 45, 0, 25 }, LE = { 100, 0, 0 } } },
			{ 0.5, { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 } } },
			{ 0.8, { Root = { 6, 0, 0, 0, -0.15, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 30, 15, 0 }, RS = { 140, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } } },
			{ 1.1, { Root = { 2, 0, 0, 0, -0.15, 0 }, Waist = { 6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, -5 }, RE = { 40, 0, 0 }, RW = { 30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.4, { Root = { 2, 0, 0, 0, -0.15, 0 }, Waist = { 6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 165, 0, -8 }, RE = { 45, 0, 0 }, RW = { 30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.8, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, -20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 20 }, LE = { 90, 0, 0 } } },
		},
		beats = {
			{ 0.5, { "symbols", symbols = { "♠", "♥", "♦", "♣" }, color = WHITE, count = 8, radius = 4, at = "above" } },
			{ 0.8, { "text", text = "… OUPS.", color = WHITE } },
			{ 1.15, { "text", text = "GRMBL…", color = RABBIT, at = "above" } },
			{ 1.3, { "particles", tex = "spark", color = MAGIC, at = "hand", dir = "all", time = 0.4, speed = 5 } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- il lisse sa moustache d'un air important
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.35, { Neck = { 10, -10, 0 }, LS = { 120, 0, 30 }, LE = { 140, 0, 0 } } },
			{ 0.7, { Neck = { 12, -10, 0 }, LS = { 115, 0, 10 }, LE = { 145, 0, 0 } } },
			{ 1.05, { Neck = { 10, -10, 0 }, LS = { 120, 0, 30 }, LE = { 140, 0, 0 } } },
			{ 1.8, {} },
		} },
		-- il soulève son chapeau, le lapin le fusille du regard, il le repose vite
		{ duration = 2, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 25, 0, 0 }, LS = { 175, 0, -10 }, LE = { 60, 0, 0 } } },
			{ 0.9, { Root = { 0, 0, 0, 0, 0, 0.2 }, Neck = { 30, 10, 0 }, LS = { 178, 0, -15 }, LE = { 50, 0, 0 } } },
			{ 1.3, { Neck = { 5, 0, 0 }, LS = { 165, 0, -10 }, LE = { 80, 0, 0 } } },
			{ 2, {} },
		} },
		-- grande révérence au public imaginaire
		{ duration = 2.2, keys = {
			{ 0, {} },
			{ 0.4, { Waist = { 0, 0, 0 }, RS = { 120, 0, 70 }, RE = { 20, 0, 0 }, LS = { 30, 0, -30 }, LE = { 20, 0, 0 } } },
			{ 0.9, { Root = { -10, 0, 0, 0, -0.2, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, LS = { 10, 0, -60 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.4 } } },
			{ 1.5, { Root = { -10, 0, 0, 0, -0.2, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, LS = { 10, 0, -60 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.4 } } },
			{ 2.2, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : la main gauche tient le chapeau ouvert au-dessus de l'adversaire,
-- la baguette fait des moulinets au-dessus
data.grabHold = {
	Root = { 4, 0, 0, 0, -0.1, 0 },
	Waist = { 10, 0, 0 },
	Neck = { 14, 0, 0 },
	RS = { 150, 0, 30 },
	RE = { 30, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 100, 0, 10 },
	LE = { 40, 0, 0 },
}

-- Retour 🪂 : il apparaît dans un nuage de fumée raté (il tousse) sur sa malle de scène, le lapin sort du chapeau,
-- lève les yeux au ciel et lui rend sa baguette ; Gaston salue.
data.respawn = {
	duration = 1.9,
	platform = { pieces = {
		{ "Malle", "base", "block", Vector3.new(5, 1.6, 3), Vector3.new(0, -0.8, 0), Vector3.new(0, 0, 0), SATIN, "WoodPlanks" },
		{ "Cerclage1", "", "block", Vector3.new(5.1, 0.2, 3.1), Vector3.new(0, -0.2, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
		{ "Cerclage2", "", "block", Vector3.new(5.1, 0.2, 3.1), Vector3.new(0, -1.4, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
		{ "EtoileG", "", "ball", Vector3.new(0.6, 0.6, 0.1), Vector3.new(-1.4, -0.8, -1.55), Vector3.new(0, 0, 0), SPARK, "Neon" },
		{ "EtoileD", "", "ball", Vector3.new(0.6, 0.6, 0.1), Vector3.new(1.4, -0.8, -1.55), Vector3.new(0, 0, 0), SPARK, "Neon" },
		{ "Fumee1", "", "ball", Vector3.new(3, 2, 2), Vector3.new(-1.8, 0.6, 1.2), Vector3.new(0, 0, 0), SMOKE, "SmoothPlastic", { transparency = 0.4 } },
		{ "Fumee2", "", "ball", Vector3.new(2.6, 1.8, 2), Vector3.new(1.9, 1, 1.3), Vector3.new(0, 0, 0), SMOKE, "SmoothPlastic", { transparency = 0.45 } },
	} },
	keys = {
		{ 0.0, { Root = { -14, 0, 0, 0, -0.35, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 30, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
		{ 0.2, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -18, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 10 }, RE = { 30, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
		{ 0.4, { Root = { -14, 0, 0, 0, -0.35, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 30, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
		{ 0.75, { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 20 }, RE = { 20, 0, 0 }, LS = { 30, 0, -20 }, LE = { 30, 0, 0 } } },
		{ 1.05, { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 165, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 30, 0, 0 } } },
		{ 1.3, { Root = { 2, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 } } },
		{ 1.6, { Root = { -8, 0, 0, 0, -0.15, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, LS = { 10, 0, -60 }, LE = { 20, 0, 0 } } },
		{ 1.9, {} },
	},
	beats = {
		{ 0.0, { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.8, speed = 6, size = 1.4 } },
		{ 0.15, { "text", text = "KOF ! KOF !", color = WHITE } },
		{ 0.8, { "text", text = "*soupir de lapin*", color = RABBIT, at = "above" } },
		{ 1.05, { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.3, speed = 5 } },
		{ 1.6, { "symbols", symbols = { "✨", "★" }, color = SPARK, count = 5, radius = 3 } },
	},
}

-- Arbre d'enchaînements. En l'air, J et K s'alternent, une flèche choisit la version directionnelle,
-- ↓S pique en lâchant des colombes et ↑S reste la remontée.
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol : J…
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side2", down_K = "P_down", S = "S_finish_poof" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", up_K = "K_upK", S = "S_finish_hat" }, -- J J (foulard)
	P_combo3 = { P = "P_combo4", K = "K_combo3", S = "S_finish_poof" }, -- J J J (J J J J : lapin catapulté, finition)
	PK_combo = { P = "KP_combo", K = "K_side", S = "S_finish_poof" }, -- J K
	-- au sol : K…
	K_neutral = { K = "K_combo2", P = "KP_combo", up_K = "K_upK", S = "S_finish_hat" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_poof" }, -- K K
	K_combo3 = { K = "K_air_side", S = "S_air" }, -- K K K (il décolle)
	KP_combo = { P = "P_combo3", K = "KPK_combo", S = "S_finish_hat" }, -- K J (K J K : claquettes, finition)
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_hat" }, -- → J (cartes)
	P_side2 = { P = "P_side3", K = "K_side2", S = "S_finish_poof" }, -- → J J (→ J J J : foulard géant, finition)
	P_down = { P = "P_down2", K = "K_downK", S = "S_finish_poof" }, -- ↓ J
	P_down2 = { P = "P_air_up", K = "K_air_up", S = "S_finish_hat" }, -- ↓ J J (fait décoller)
	P_up = { K = "K_upK", P = "P_down2", S = "S_finish_poof" }, -- ↑ J
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_hat" }, -- → K (canne)
	K_side2 = { K = "K_side3", P = "P_combo3", S = "S_finish_poof" }, -- → K K (il ramène l'adversaire contre lui ; → K K K : swing de canne, finition)
	K_down = { K = "K_downK", P = "P_down2", S = "S_finish_poof" }, -- ↓ K
	K_downK = { K = "K_air_up", S = "S_finish_hat" }, -- ↓ K K
	K_up = { K = "K_upK", S = "S_finish_hat" }, -- ↑ K
	K_upK = { S = "S_finish_poof" }, -- ↑ K K
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_finish_poof" }, -- dash J
	K_dash = { K = "K_downK", P = "KP_combo", S = "S_finish_hat" }, -- dash K
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

-- Capitaine Canard : vieux loup de mer de piscine municipale, coincé dans sa bouée canard, masque de plongée,
-- palmes aux pieds. Il se dandine, triple-saute et plane. Arme sortie de la Caisse Bizarre : Bouée Canard &
-- Pistolet à eau (la bouée est toujours autour de sa taille, le pistolet n'apparaît qu'une fois la caisse ouverte).
--
-- Mécanique « float » (Flottaison) : triple saut (2 sauts en l'air), plané en tenant SAUT, et jauge de Pression
-- d'eau 💧 qui remonte toute seule (sans limite : elle ne bloque plus aucun tir).
-- Signatures (L) et Supers (Y) « sûrs de toucher » : couloirs de 16 studs, projectiles qui visent l'adversaire,
-- ↑L = envol en diagonale très puissant (il vole : flying = true), voir docs/fiche-perso.md.
-- Format des coups, poses et effets : voir Gege.lua et docs/fiche-perso.md.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local WATER = Color3.fromRGB(80, 180, 255)
local FOAM = Color3.fromRGB(225, 245, 255)
local DUCK = Color3.fromRGB(255, 212, 40)
local BEAK = Color3.fromRGB(255, 135, 30)
local NAVY = Color3.fromRGB(30, 45, 110)
local SKIN = Color3.fromRGB(250, 200, 165)
local BLACK = Color3.fromRGB(25, 25, 30)
local WHITE = Color3.fromRGB(245, 245, 248)
local GOLD = Color3.fromRGB(235, 185, 50)
local TOY_GREEN = Color3.fromRGB(70, 210, 90)

-- Canard en plastique (projectile du Raz-de-marée)
local RUBBER_DUCK = {
	shape = "ball", size = 1.3, color = DUCK, spin = 0,
	parts = {
		{ "ball", Vector3.new(0.85, 0.85, 0.85), Vector3.new(0.35, 0.75, 0), DUCK },
		{ "block", Vector3.new(0.5, 0.18, 0.4), Vector3.new(0.85, 0.7, 0), BEAK },
		{ "ball", Vector3.new(0.18, 0.18, 0.18), Vector3.new(0.6, 0.95, -0.3), BLACK },
	},
}

local NOODLE = Color3.fromRGB(255, 95, 175) -- frite de piscine (arme n° 2)
local BAZOOKA = Color3.fromRGB(80, 100, 125) -- bazooka à canards (arme n° 3)

local data = {
	id = "Canard",
	name = "Capitaine Canard",
	costume = "Canard",
	style = "duck",
	flying = true, -- sait voler : un saut en l\'air de plus, plané, et un ↑L très puissant

	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : maître nageur à la retraite
	-- Ses propres J / K et ses combos sans pistolet : le Capitaine se bat en nageant hors de l'eau (brasse, crawl,
	-- papillon, petit chien), salue comme un vieux marin, danse la gigue et part à l'abordage.
	bare = {
		moves = {
			-- J : brasse coulée : les deux mains jointes partent devant puis s'ouvrent en grand
			P_neutral = {
				label = "Brasse coulée", startup = 0.08, active = 0.1, recovery = 0.16,
				damage = 5, hitbox = box(4.5, 3, 2.6, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
				windup = { Root = { 6, 0, 0, 0, -0.15, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 120, 0, 0 }, LS = { 40, 0, -10 }, LE = { 120, 0, 0 } },
				strike = { Root = { -8, 0, 0, 0, -0.2, -0.25 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 95, 0, -6 }, RE = { 0, 0, 0 }, LS = { 95, 0, 6 }, LE = { 0, 0, 0 } },
				follow = { Root = { -9, 0, 0, 0, -0.2, -0.28 }, Waist = { -11, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 90, 0, 50 }, RE = { 4, 0, 0 }, LS = { 90, 0, -50 }, LE = { 4, 0, 0 } },
				trail = "bothHands", hitText = "BLOUP !",
			},
			-- J J : crawl : les bras moulinent l'un après l'autre par-dessus la tête
			P_combo2 = {
				label = "Crawl", startup = 0.06, active = 0.14, recovery = 0.16,
				damage = 6, hits = 2, hitbox = box(4.5, 3.5, 2.6, 1.2), kbBase = 20, kbGrowth = 24, kbAngle = 30,
				windup = { Root = { 4, 16, 0, 0, -0.15, 0.05 }, Waist = { 4, 18, 0 }, Neck = { 0, -20, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, LS = { 20, 0, -20 }, LE = { 30, 0, 0 } },
				strike = { Root = { -8, -16, 0, 0, -0.2, -0.25 }, Waist = { -8, -18, 0 }, Neck = { 0, 20, 0 }, RS = { 60, 0, 10 }, RE = { 10, 0, 0 }, LS = { 170, 0, -20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
				follow = { Root = { -9, -18, 0, 0, -0.2, -0.28 }, Waist = { -9, -20, 0 }, Neck = { 0, 24, 0 }, RS = { 20, 0, 14 }, RE = { 20, 0, 0 }, LS = { 70, 0, -10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
				trail = "bothHands", fx = { { "toss", shape = "ball", color = WATER, size = 0.3, count = 4, speed = 12 } }, hitText = "SPLISH-SPLASH !",
			},
			-- J J J : papillon : les deux bras passent ensemble par-dessus la tête et il plonge en avant
			P_combo3 = {
				label = "Papillon", startup = 0.12, active = 0.12, recovery = 0.28,
				damage = 8, hitbox = box(5, 3.5, 2.8, 0.8), kbBase = 26, kbGrowth = 46, kbAngle = 35, selfVelocity = Vector2.new(20, 0),
				windup = { Root = { -10, 0, 0, 0, -0.1, 0.2 }, Waist = { -12, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 175, 0, 30 }, RE = { 0, 0, 0 }, LS = { 175, 0, -30 }, LE = { 0, 0, 0 } },
				strike = { Root = { 24, 0, 0, 0, -0.35, -0.45 }, Waist = { 20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 70, 0, 30 }, RE = { 0, 0, 0 }, LS = { 70, 0, -30 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				follow = { Root = { 28, 0, 0, 0, -0.38, -0.5 }, Waist = { 22, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, 50 }, RE = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
				trail = "bothHands", fx = { { "burst", color = WATER, size = 2.5, at = "front" } }, hitText = "PLAOUF !",
			},
			-- J K : salut militaire du capitaine, si raide que le coude cogne l'adversaire
			PK_combo = {
				label = "Salut du capitaine", startup = 0.1, active = 0.1, recovery = 0.24,
				damage = 7, hitbox = box(4, 3, 2.2, 1.4), kbBase = 24, kbGrowth = 40, kbAngle = 40,
				windup = { Root = { -4, 30, 0, 0, 0, 0.05 }, Waist = { -4, 30, 0 }, Neck = { -10, -30, 0 }, RS = { 20, 0, 20 }, RE = { 30, 0, 0 }, LS = { 0, 0, -6 }, LE = { 0, 0, 0 } },
				strike = { Root = { -8, -10, 0, 0, 0.05, -0.2 }, Waist = { -8, -14, 0 }, Neck = { -14, 10, 0 }, RS = { 100, 0, 80 }, RE = { 140, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -4 }, LE = { 0, 0, 0 } },
				follow = { Root = { -9, -12, 0, 0, 0.05, -0.22 }, Waist = { -9, -16, 0 }, Neck = { -16, 12, 0 }, RS = { 104, 0, 84 }, RE = { 144, 0, 0 }, LS = { 0, 0, -4 }, LE = { 0, 0, 0 } },
				trail = "rightHand", fx = { { "text", text = "À VOS ORDRES !", color = NAVY, at = "head" } }, hitText = "GARDE-À-VOUS !",
			},
			-- K K : gigue du matelot, deux petits coups de pied sautillés bras croisés
			K_combo2 = {
				label = "Gigue du matelot", startup = 0.08, active = 0.2, recovery = 0.24,
				damage = 7, hits = 2, hitbox = box(5, 2.5, 2.6, -0.8), kbBase = 22, kbGrowth = 40, kbAngle = 40,
				windup = { Root = { 0, 0, 0, 0, 0.1, 0.05 }, Waist = { -4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, -30 }, RE = { 100, 0, 0 }, LS = { 70, 0, 30 }, LE = { 100, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 } },
				strike = { Root = { -4, 0, 4, 0, 0.15, -0.1 }, Waist = { -6, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 72, 0, -32 }, RE = { 104, 0, 0 }, LS = { 72, 0, 32 }, LE = { 104, 0, 0 }, RH = { 80, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { -4, 0, -4, 0, 0.15, -0.12 }, Waist = { -6, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 72, 0, -32 }, RE = { 104, 0, 0 }, LS = { 72, 0, 32 }, LE = { 104, 0, 0 }, LH = { 80, 0, 0 }, LK = { -6, 0, 0 }, LA = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 } },
				trail = "leftFoot", fx = { { "symbols", symbols = { "♪", "⚓" }, color = NAVY, count = 4, radius = 3 } }, hitText = "HISSEZ HO !",
			},
			-- K J : il tire l'élastique de son masque de plongée vers l'avant et le lâche : CLAC
			KP_combo = {
				label = "Élastique de masque", startup = 0.1, active = 0.08, recovery = 0.24,
				damage = 7, hitbox = box(4.5, 3, 2.6, 1.6), kbBase = 24, kbGrowth = 40, kbAngle = 32,
				windup = { Root = { -6, 0, 0, 0, 0, 0.15 }, Waist = { -8, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 140, 0, 20 }, RE = { 120, 0, 0 }, LS = { 140, 0, -20 }, LE = { 120, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, -0.1, -0.3 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 110, 0, 30 }, RE = { 20, 0, 0 }, LS = { 110, 0, -30 }, LE = { 20, 0, 0 } },
				follow = { Root = { 12, 0, 0, 0, -0.1, -0.32 }, Waist = { 14, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 100, 0, 40 }, RE = { 24, 0, 0 }, LS = { 100, 0, -40 }, LE = { 24, 0, 0 } },
				trail = "head", hitText = "CLAC !",
			},
			-- K K J : « À l'abordage ! » : il bondit poing levé et retombe sur l'adversaire (finition)
			KKP_combo = {
				label = "À l'abordage !", startup = 0.12, active = 0.18, recovery = 0.34,
				damage = 10, hitbox = box(5, 4, 2.6, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 45, selfVelocity = Vector2.new(26, 22),
				windup = { Root = { 10, 0, 0, 0, -0.6, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 175, 0, 20 }, RE = { 10, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } },
				strike = { Root = { 20, 0, 0, 0, 0.1, -0.4 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 10 }, RE = { 0, 0, 0 }, LS = { 20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -80, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
				follow = { Root = { 24, 0, 0, 0, 0.05, -0.45 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 12 }, RE = { 0, 0, 0 }, LS = { 18, 0, -62 }, LE = { 30, 0, 0 }, RH = { 64, 0, 0 }, RK = { -84, 0, 0 }, LH = { 12, 0, 0 }, LK = { -42, 0, 0 } },
				trail = "rightHand", fx = { { "text", text = "À L'ABORDAGE !", color = NAVY, at = "head" }, { "burst", color = FOAM, size = 3, at = "front" } }, hitText = "MOUSSAILLON !",
			},
			-- →J : longue-vue de poings : il colle ses deux poings l'un devant l'autre comme une longue-vue et les projette
			P_side = {
				label = "Longue-vue de poings", startup = 0.1, active = 0.1, recovery = 0.2,
				damage = 7, hitbox = box(5, 3, 3, 1.2), kbBase = 22, kbGrowth = 34, kbAngle = 25, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { 0, 10, 0, 0, -0.1, 0.15 }, Waist = { 0, 10, 0 }, Neck = { -6, -10, 0 }, RS = { 80, 0, -10 }, RE = { 90, 0, 0 }, LS = { 80, 0, 20 }, LE = { 90, 0, 0 } },
				strike = { Root = { 6, 0, 0, 0, -0.15, -0.4 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 92, 0, -4 }, RE = { 0, 0, 0 }, LS = { 90, 0, 4 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { 8, 0, 0, 0, -0.15, -0.44 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, LS = { 92, 0, 2 }, LE = { 26, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
				trail = "bothHands", hitText = "TERRE EN VUE !",
			},
			-- ↓J : accroupi, il écope l'eau du sol à pleines mains et la balance sur les chevilles
			P_down = {
				label = "Écope", startup = 0.07, active = 0.1, recovery = 0.18,
				damage = 5, hitbox = box(4.5, 2, 2.6, -1.3), kbBase = 20, kbGrowth = 24, kbAngle = 68,
				windup = { Root = { 16, 0, 0, 0, -0.8, 0.1 }, Waist = { 20, 0, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 20, 0, -20 }, LE = { 60, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, -0.85, -0.15 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 10 }, RE = { 30, 0, 0 }, RW = { 40, 0, 0 }, LS = { 70, 0, -10 }, LE = { 30, 0, 0 }, LW = { 40, 0, 0 } },
				follow = { Root = { 8, 0, 0, 0, -0.85, -0.18 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 90, 0, 14 }, RE = { 20, 0, 0 }, RW = { 50, 0, 0 }, LS = { 90, 0, -14 }, LE = { 20, 0, 0 }, LW = { 50, 0, 0 } },
				trail = "bothHands", fx = { { "toss", shape = "ball", color = WATER, size = 0.35, count = 5, speed = 14 } }, hitText = "SPLATCH !",
			},
			-- ↑J : il bat des coudes comme des ailes de canard, vers le ciel
			P_up = {
				label = "Battement d'ailerons", startup = 0.09, active = 0.12, recovery = 0.22,
				damage = 6, hits = 2, hitbox = box(4.5, 5, 0.8, 3), kbBase = 22, kbGrowth = 36, kbAngle = 86,
				windup = { Root = { 0, 0, 0, 0, -0.35, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 0, 0, 20 }, RE = { 140, 0, 0 }, LS = { 0, 0, -20 }, LE = { 140, 0, 0 } },
				strike = { Root = { -6, 0, 0, 0, 0.1, 0 }, Waist = { -8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, 120 }, RE = { 120, 0, 0 }, LS = { 30, 0, -120 }, LE = { 120, 0, 0 } },
				follow = { Root = { -8, 0, 0, 0, 0.12, 0 }, Waist = { -10, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 30, 0, 140 }, RE = { 110, 0, 0 }, LS = { 30, 0, -140 }, LE = { 110, 0, 0 } },
				wobble = true, fx = { { "symbols", symbols = { "🪶" }, color = DUCK, count = 3, radius = 2 } }, hitText = "COIN-COIN !",
			},
			-- J en l'air : nage du petit chien, les mains pédalent vite devant lui (deux coups)
			P_air = {
				label = "Nage du petit chien", startup = 0.08, active = 0.18, recovery = 0.2,
				damage = 7, hits = 2, hitbox = box(4.5, 3.5, 2.2, -0.2), kbBase = 20, kbGrowth = 32, kbAngle = 30,
				windup = { Root = { 10, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 10 }, RE = { 100, 0, 0 }, LS = { 70, 0, -10 }, LE = { 100, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
				strike = { Root = { 14, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 100, 0, 10 }, RE = { 20, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
				follow = { Root = { 14, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, LS = { 100, 0, -10 }, LE = { 20, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
				trail = "bothHands", hitText = "OUAF-PLOUF !",
			},
			-- dash J : il se dandine à toute allure et bouscule d'un coup de bouée-hanche
			P_dash = {
				label = "Dandinade express", startup = 0.08, active = 0.16, recovery = 0.24,
				damage = 7, hitbox = box(4.5, 3.5, 2.2, 0.2), kbBase = 24, kbGrowth = 38, kbAngle = 28, selfVelocity = Vector2.new(34, 0),
				windup = { Root = { 0, 20, 14, 0, -0.1, 0.1 }, Waist = { 0, 10, -10 }, Neck = { 0, -10, 10 }, RS = { -20, 0, 40 }, RE = { 20, 0, 0 }, LS = { -20, 0, -40 }, LE = { 20, 0, 0 } },
				strike = { Root = { 6, -30, -14, 0, -0.15, -0.4 }, Waist = { 4, -14, 10 }, Neck = { 0, 14, -10 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
				follow = { Root = { 8, -34, -16, 0, -0.15, -0.44 }, Waist = { 6, -16, 12 }, Neck = { 0, 16, -12 }, RS = { -34, 0, 54 }, RE = { 20, 0, 0 }, LS = { -34, 0, -54 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
				wobble = true, trail = "body", fx = { "dust" }, hitText = "COIN-POUSSE !",
			},
			-- K : ciseau de brasse : les deux genoux s'ouvrent puis les jambes claquent ensemble devant lui
			K_neutral = {
				label = "Ciseau de brasse", startup = 0.1, active = 0.1, recovery = 0.22,
				damage = 7, hitbox = box(4.5, 3, 2.6, -0.4), kbBase = 24, kbGrowth = 40, kbAngle = 35,
				windup = { Root = { -10, 0, 0, 0, 0.1, 0.1 }, Waist = { -10, 0, 0 }, RS = { 20, 0, 60 }, RE = { 30, 0, 0 }, LS = { 20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 60, 0, 40 }, RK = { -100, 0, 0 }, LH = { 60, 0, -40 }, LK = { -100, 0, 0 } },
				strike = { Root = { -20, 0, 0, 0, 0.15, -0.05 }, Waist = { -14, 0, 0 }, RS = { 30, 0, 70 }, RE = { 20, 0, 0 }, LS = { 30, 0, -70 }, LE = { 20, 0, 0 }, RH = { 85, 0, 4 }, RK = { -4, 0, 0 }, LH = { 85, 0, -4 }, LK = { -4, 0, 0 } },
				follow = { Root = { -22, 0, 0, 0, 0.15, -0.06 }, Waist = { -16, 0, 0 }, RS = { 32, 0, 74 }, RE = { 20, 0, 0 }, LS = { 32, 0, -74 }, LE = { 20, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, LH = { 88, 0, 0 }, LK = { 0, 0, 0 } },
				trail = "rightFoot", hitText = "FLAP !",
			},
			-- →K : godille : il fait pivoter la jambe tendue de droite à gauche comme une rame à l'arrière d'une barque
			K_side = {
				label = "Godille", startup = 0.12, active = 0.14, recovery = 0.26,
				damage = 8, hitbox = box(5.5, 3, 3, -0.2), kbBase = 26, kbGrowth = 46, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
				windup = { Root = { 0, 30, 0, 0, -0.15, 0.1 }, Waist = { 0, 24, 0 }, RS = { 50, 0, 60 }, RE = { 30, 0, 0 }, LS = { 50, 0, -60 }, LE = { 30, 0, 0 }, RH = { 60, 0, 40 }, RK = { -10, 0, 0 } },
				strike = { Root = { 6, -30, 0, 0, -0.2, -0.15 }, Waist = { 4, -26, 0 }, RS = { 60, 0, 80 }, RE = { 20, 0, 0 }, LS = { 60, 0, -80 }, LE = { 20, 0, 0 }, RH = { 85, 0, -20 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { 8, -36, 0, 0, -0.2, -0.18 }, Waist = { 6, -30, 0 }, RS = { 64, 0, 84 }, RE = { 20, 0, 0 }, LS = { 64, 0, -84 }, LE = { 20, 0, 0 }, RH = { 85, 0, -30 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
				trail = "rightLeg", hitText = "RAME, MOUSSE !",
			},
			-- ↓K : « Jetez l'ancre ! » : il lève le talon très haut et le laisse tomber comme une ancre au ras du sol
			K_down = {
				label = "Jetez l'ancre !", startup = 0.14, active = 0.1, recovery = 0.3,
				damage = 8, hitbox = box(4.5, 2.5, 2.4, -1.4), kbBase = 26, kbGrowth = 44, kbAngle = 70,
				windup = { Root = { -14, 0, 0, 0, 0.1, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 140, 0, 0 }, RK = { -4, 0, 0 } },
				strike = { Root = { 16, 0, 0, 0, -0.5, -0.15 }, Waist = { 16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 40 }, RE = { 20, 0, 0 }, LS = { 20, 0, -40 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -10, 0, 0 }, RA = { 10, 0, 0 } },
				follow = { Root = { 18, 0, 0, 0, -0.55, -0.18 }, Waist = { 18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 18, 0, 42 }, RE = { 20, 0, 0 }, LS = { 18, 0, -42 }, LE = { 20, 0, 0 }, RH = { 34, 0, 0 }, RK = { -14, 0, 0 }, RA = { 14, 0, 0 } },
				trail = "rightFoot", fx = { { "ring", color = WATER, radius = 4, at = "feet" } }, hitText = "BLONG !",
			},
			-- ↑K : saut de dauphin : il cambre tout le corps et fouette vers le haut avec les deux pieds joints
			K_up = {
				label = "Saut de dauphin", startup = 0.14, active = 0.12, recovery = 0.3,
				damage = 9, hitbox = box(4.5, 6, 0.6, 3), kbBase = 26, kbGrowth = 52, kbAngle = 88, selfVelocity = Vector2.new(0, 18),
				windup = { Root = { 20, 0, 0, 0, -0.5, 0 }, Waist = { 20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 0, 0, 0 } },
				strike = { Root = { -40, 0, 0, 0, 0.2, 0.2 }, Waist = { -20, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 175, 0, 8 }, RE = { 0, 0, 0 }, LS = { 175, 0, -8 }, LE = { 0, 0, 0 }, RH = { 120, 0, 4 }, RK = { -4, 0, 0 }, LH = { 120, 0, -4 }, LK = { -4, 0, 0 } },
				follow = { Root = { -44, 0, 0, 0, 0.2, 0.22 }, Waist = { -22, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 178, 0, 6 }, RE = { 0, 0, 0 }, LS = { 178, 0, -6 }, LE = { 0, 0, 0 }, RH = { 126, 0, 2 }, RK = { 0, 0, 0 }, LH = { 126, 0, -2 }, LK = { 0, 0, 0 } },
				trail = "rightFoot", fx = { { "toss", shape = "ball", color = FOAM, size = 0.35, count = 4, speed = 16 } }, hitText = "IIIK-IIIK !",
			},
			-- K en l'air : ballet nautique : une jambe tendue vers le ciel, l'autre fouette en dessous (deux coups)
			K_air = {
				label = "Ballet nautique", startup = 0.1, active = 0.2, recovery = 0.22,
				damage = 8, hits = 2, hitbox = box(4.5, 4.5, 1.6, -0.6), kbBase = 22, kbGrowth = 38, kbAngle = 40,
				windup = { Root = { -10, 0, 0 }, Waist = { -6, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { -90, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
				strike = { Root = { -24, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 100, 0, 100 }, RE = { 0, 0, 0 }, LS = { 100, 0, -100 }, LE = { 0, 0, 0 }, RH = { 170, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 60, 0, 0 }, LK = { -4, 0, 0 } },
				follow = { Root = { -26, 0, 0 }, Waist = { -12, 0, 0 }, RS = { 104, 0, 104 }, RE = { 0, 0, 0 }, LS = { 104, 0, -104 }, LE = { 0, 0, 0 }, RH = { 175, 0, 0 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 }, LH = { 90, 0, 0 }, LK = { 0, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "rightFoot", fx = { { "symbols", symbols = { "✨", "💧" }, color = WATER, count = 4, radius = 3 } }, hitText = "OLÉ-PLOUF !",
			},
			-- dash K : virage culbute de nageur : roulade avant puis poussée des deux pieds
			K_dash = {
				label = "Virage culbute", startup = 0.1, active = 0.24, recovery = 0.3,
				damage = 9, hitbox = box(5.5, 3, 2.8, -0.4), kbBase = 28, kbGrowth = 54, kbAngle = 35, selfVelocity = Vector2.new(46, 0),
				windup = { Root = { 30, 0, 0, 0, -0.6, 0.1 }, Waist = { 30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, LS = { 60, 0, -20 }, LE = { 100, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -120, 0, 0 } },
				strike = { Root = { -20, 0, 0, 0, -0.7, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 0, 0, 0 }, RH = { 88, 0, 6 }, RK = { 0, 0, 0 }, LH = { 88, 0, -6 }, LK = { 0, 0, 0 } },
				follow = { Root = { -22, 0, 0, 0, -0.72, -0.22 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 174, 0, 8 }, RE = { 0, 0, 0 }, LS = { 174, 0, -8 }, LE = { 0, 0, 0 }, RH = { 90, 0, 4 }, RK = { 0, 0, 0 }, LH = { 90, 0, -4 }, LK = { 0, 0, 0 } },
				spin = { axis = "x", degrees = 360 }, trail = "body", fx = { { "puddle", color = WATER, width = 6 } }, hitText = "CULBUTO !",
			},
		},
		-- Combos à mains nues : J J J (brasse, crawl, papillon), →J J (longue-vue puis papillon), J K K J (salut, gigue,
		-- abordage), K J (élastique de masque) puis J (crawl). Un S pour finir envoie le spécial du perso.
		links = {
			P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_side" },
			P_combo2 = { P = "P_combo3", up_K = "K_up", S = "S_neutral" },
			P_combo3 = { up_P = "P_up", S = "S_side" },
			PK_combo = { K = "K_combo2", P = "KP_combo", S = "S_down" },
			K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_neutral" },
			K_combo2 = { P = "KKP_combo", S = "S_up" },
			KP_combo = { P = "P_combo2", S = "S_side" },
			KKP_combo = { S = "S_neutral" },
			P_side = { P = "P_combo3", S = "S_side" },
			P_down = { P = "P_up", K = "K_down", S = "S_down" },
			K_down = { K = "K_up", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			K_side = { K = "K_combo2", S = "S_side" },
			K_up = { S = "S_up" },
			P_dash = { K = "PK_combo", S = "S_side" },
			K_dash = { P = "KKP_combo", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la bouée et le pistolet à eau (ses coups sont ceux de moves). n° 2 : la frite de piscine géante, longue, molle
	-- et rapide, qui tapote de partout sans éjecter loin. n° 3 : le bazooka à canards, lourd et lent, qui tire des canards
	-- en plastique comme des obus et éjecte à l'autre bout de la piscine.
	weapons = {
		{ id = "pistolet", name = "Bouée canard & pistolet à eau", icon = "🔫",
			ability = { jumps = 1, text = "Un saut en l'air de plus pour planer encore plus haut" } },
		{ id = "frite", name = "Frite de piscine géante", icon = "🍟",
			prop = { name = "PropFrite", hand = "Right", pieces = {
				{ "Frite", "", "cyl", Vector3.new(4.6, 0.55, 0.55), Vector3.new(0, -2.3, 0), Vector3.new(0, 0, 0), NOODLE, "SmoothPlastic", { axis = "y" } },
				{ "Rayure1", "", "cyl", Vector3.new(0.3, 0.62, 0.62), Vector3.new(0, -1.3, 0), Vector3.new(0, 0, 0), TOY_GREEN, "SmoothPlastic", { axis = "y" } },
				{ "Rayure2", "", "cyl", Vector3.new(0.3, 0.62, 0.62), Vector3.new(0, -3.3, 0), Vector3.new(0, 0, 0), TOY_GREEN, "SmoothPlastic", { axis = "y" } },
				{ "Bout", "", "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0, -4.6, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
			} },
			ability = { reach = 1.25, text = "Portée +25 % : la frite est longue, longue, longue" },
			moves = {
				-- J : pichenette du bout de la frite, qui tremblote dans tous les sens
				P_neutral = {
					label = "Pichenette de frite", startup = 0.07, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(6, 2.5, 4, 0.8), kbBase = 16, kbGrowth = 20, kbAngle = 25,
					windup = { Root = { 2, -14, 0, 0, -0.15, 0.1 }, Waist = { 4, -16, 0 }, RS = { 70, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -6, 12, 0, 0, -0.2, -0.25 }, Waist = { -6, 14, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
					follow = { Root = { -6, 14, 0, 0, -0.2, -0.28 }, Waist = { -6, 16, 0 }, RS = { 90, 0, -4 }, RE = { 6, 0, 0 }, RW = { -25, 0, 0 }, LS = { 26, 0, -42 }, LE = { 70, 0, 0 } },
					wobble = true, trail = "prop", hitText = "FLOP !",
				},
				-- →J : la frite fouette deux fois d'un revers mou, comme une nouille géante
				P_side = {
					label = "Fouet de frite", startup = 0.08, active = 0.14, recovery = 0.18,
					damage = 4, hits = 2, hitbox = box(7, 3, 4.5, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 28, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 4, 30, 0, 0, -0.2, 0.15 }, Waist = { 4, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, RW = { 20, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, -24, 0, 0, -0.25, -0.3 }, Waist = { -6, -28, 0 }, Neck = { 0, 14, 0 }, RS = { 92, 0, -20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -6, 20, 0, 0, -0.25, -0.32 }, Waist = { -6, 24, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 46, 0, -34 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					wobble = true, trail = "prop", hitText = "FLAP FLAP !",
				},
				-- ↓J : accroupi, la frite rase le carrelage et cueille les chevilles
				P_down = {
					label = "Frite sous les palmes", startup = 0.09, active = 0.1, recovery = 0.2,
					damage = 5, hitbox = box(7, 2, 4, -1.6), kbBase = 22, kbGrowth = 24, kbAngle = 70,
					windup = { Root = { -6, -24, 0, 0, -0.8, 0.15 }, Waist = { -14, -16, 0 }, Neck = { -6, 16, 0 }, RS = { 20, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -10, 22, 0, 0, -0.9, -0.1 }, Waist = { -20, 24, 0 }, Neck = { -6, -10, 0 }, RS = { 50, 0, -10 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -10, 32, 0, 0, -0.9, -0.14 }, Waist = { -20, 34, 0 }, Neck = { -6, -14, 0 }, RS = { 44, 0, -30 }, RE = { 5, 0, 0 }, RW = { -30, 0, 0 }, LS = { 26, 0, -42 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "puddle", color = WATER, width = 5 } }, hitText = "FLIP !",
				},
				-- ↑J : grand moulinet vers le ciel, la frite se plie en arc au-dessus de lui
				P_up = {
					label = "Frite au plafond", startup = 0.09, active = 0.12, recovery = 0.2,
					damage = 6, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 26, kbGrowth = 30, kbAngle = 85,
					windup = { Root = { 6, 0, 0, 0, -0.4, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 30 }, RE = { 90, 0, 0 }, RW = { 20, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.1, -0.1 }, Waist = { -12, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 172, 0, 10 }, RE = { 5, 0, 0 }, RW = { -30, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.12, -0.12 }, Waist = { -14, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 182, 0, 12 }, RE = { 5, 0, 0 }, RW = { -45, 0, 0 }, LS = { 54, 0, -42 }, LE = { 70, 0, 0 } },
					wobble = true, trail = "prop", hitText = "FLOUP !",
				},
				-- J en l'air : bras tendu, la frite tourne autour de lui comme une hélice molle (2 touches)
				P_air = {
					label = "Hélice de frite", startup = 0.08, active = 0.18, recovery = 0.18,
					damage = 4, hits = 2, hitbox = box(7, 3.5, 0.5, 0), kbBase = 20, kbGrowth = 30, kbAngle = 35,
					windup = { Root = { 0, -30, 0 }, Waist = { 0, -20, 0 }, RS = { 70, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
					strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 }, RH = { 30, 0, 10 }, RK = { -50, 0, 0 }, LH = { 30, 0, -10 }, LK = { -50, 0, 0 } },
					follow = { Root = { 0, 10, 0 }, Waist = { 0, 5, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, RH = { 25, 0, 12 }, RK = { -45, 0, 0 }, LH = { 25, 0, -12 }, LK = { -45, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "VROUF !",
				},
				-- dash J : il court en pointant la frite devant lui comme une lance en mousse
				P_dash = {
					label = "Lance-frite", startup = 0.08, active = 0.12, recovery = 0.22,
					damage = 7, hitbox = box(7, 2.5, 4.5, 0.8), kbBase = 24, kbGrowth = 40, kbAngle = 25, selfVelocity = Vector2.new(40, 0),
					windup = { Root = { -8, -16, 0, 0, -0.3, 0.1 }, Waist = { -6, -14, 0 }, RS = { 50, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -18, 10, 0, 0, -0.4, -0.35 }, Waist = { -8, 12, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 40, 0, 0 } },
					follow = { Root = { -20, 12, 0, 0, -0.42, -0.4 }, Waist = { -10, 14, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -44, 0, -26 }, LE = { 40, 0, 0 } },
					wobble = true, trail = "prop", fx = { "dust" }, hitText = "POC !",
				},
				-- K : moulinet à deux mains au-dessus de la tête, la frite claque trois fois comme un battoir
				K_neutral = {
					label = "Moulinet de frite", startup = 0.14, active = 0.24, recovery = 0.28,
					damage = 4, hits = 3, hitbox = box(6, 4, 3.5, 1), kbBase = 20, kbGrowth = 40, kbAngle = 40,
					windup = { Root = { 8, 0, 0, 0, -0.1, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 180, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -15 }, LE = { 40, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.4, -0.35 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 0 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { 6, 0, 0, 0, -0.15, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 20, 0, 0 } },
					wobble = true, trail = "prop", hitText = "FLOP FLOP FLOP !",
				},
				-- →K : grand coup de frite à deux mains en tournant sur lui-même, la mousse siffle
				K_side = {
					label = "Grand coup de frite", startup = 0.18, active = 0.14, recovery = 0.32,
					damage = 11, hitbox = box(7.5, 3.5, 4, 0.5), kbBase = 28, kbGrowth = 62, kbAngle = 35, selfVelocity = Vector2.new(16, 0),
					windup = { Root = { 6, 44, 0, 0, -0.2, 0.2 }, Waist = { 8, 40, 0 }, Neck = { 0, -30, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, RW = { 20, 0, 0 }, LS = { 70, 0, 20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -10, -30, 0, 0, -0.3, -0.35 }, Waist = { -12, -36, 0 }, Neck = { 0, 20, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, -40, 0, 0, -0.3, -0.4 }, Waist = { -14, -46, 0 }, Neck = { 0, 26, 0 }, RS = { 88, 0, -30 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 88, 0, -10 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "SCHPLAF !",
				},
				-- ↓K : accroupi, il tourne sur lui-même frite tendue au ras du sol, comme une toupie en mousse
				K_down = {
					label = "Toupie de frite", startup = 0.14, active = 0.2, recovery = 0.3,
					damage = 9, hitbox = box(8, 2, 0.5, -1.5), kbBase = 26, kbGrowth = 50, kbAngle = 72,
					windup = { Root = { -6, -30, 0, 0, -0.9, 0 }, Waist = { -16, -10, 0 }, RS = { 30, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, -1.1, 0 }, Waist = { -18, 0, 0 }, RS = { 10, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -70 }, LE = { 15, 0, 0 } },
					follow = { Root = { -10, 0, 0, 0, -1.1, 0 }, Waist = { -16, 0, 0 }, RS = { 12, 0, 88 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 25, 0, -72 }, LE = { 15, 0, 0 } },
					spin = { axis = "y", degrees = 720 }, trail = "prop", fx = { { "puddle", color = WATER, width = 6 } }, hitText = "FWIP !",
				},
				-- ↑K : il plie la frite contre le sol et la lâche : elle se détend d'un coup vers le ciel
				K_up = {
					label = "Frite-catapulte", startup = 0.16, active = 0.12, recovery = 0.3,
					damage = 10, hitbox = box(4.5, 6, 2, 3.5), kbBase = 30, kbGrowth = 62, kbAngle = 88,
					windup = { Root = { -14, 0, 0, 0, -0.7, 0.1 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, 0.2, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 176, 0, 8 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					follow = { Root = { 12, 0, 0, 0, 0.25, -0.12 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 184, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 64, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
					shake = true, trail = "prop", fx = { { "burst", color = NOODLE, size = 2, at = "above" } }, hitText = "BOÏNG !",
				},
				-- K en l'air : il se sert de la frite comme d'un bâton de pogo et rebondit sur la tête de l'adversaire
				K_air = {
					label = "Frite-pogo", startup = 0.14, active = 0.14, recovery = 0.24,
					damage = 10, hitbox = box(5, 4, 1, -2), kbBase = 26, kbGrowth = 55, kbAngle = -40, selfVelocity = Vector2.new(4, 28),
					windup = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -5 }, LE = { 0, 0, 0 }, RH = { 20, 0, 5 }, RK = { -30, 0, 0 }, LH = { 20, 0, -5 }, LK = { -30, 0, 0 } },
					follow = { Root = { -6, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 26, 0, 6 }, RE = { 4, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -6 }, LE = { 4, 0, 0 }, RH = { 30, 0, 5 }, RK = { -50, 0, 0 }, LH = { 30, 0, -5 }, LK = { -50, 0, 0 } },
					shake = true, trail = "prop", hitText = "POGO !",
				},
				-- dash K : il plante la frite et saute à la perche par-dessus, palmes en avant
				K_dash = {
					label = "Perche de piscine", startup = 0.1, active = 0.2, recovery = 0.3,
					damage = 10, hitbox = box(5, 4, 3, 0.5), kbBase = 28, kbGrowth = 60, kbAngle = 55, selfVelocity = Vector2.new(40, 40),
					windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 60, 0, 0 }, RW = { 40, 0, 0 }, LS = { 50, 0, -10 }, LE = { 70, 0, 0 } },
					strike = { Root = { 20, 0, 0, 0, 0.2, 0 }, Waist = { 14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -20 }, LE = { 10, 0, 0 }, RH = { 90, 0, 5 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 90, 0, -5 }, LK = { 0, 0, 0 }, LA = { 30, 0, 0 } },
					follow = { Root = { 24, 0, 0, 0, 0.25, 0 }, Waist = { 16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -36, 0, 22 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -36, 0, -22 }, LE = { 10, 0, 0 }, RH = { 96, 0, 5 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 96, 0, -5 }, LK = { 0, 0, 0 }, LA = { 30, 0, 0 } },
					trail = "bothFeet", fx = { "dust" }, text = "HOP !", hitText = "SPLATCH !",
				},
				-- L : frite-tornade, il tourne trois tours sur lui-même et la frite fouette tout le couloir (3 touches)
				S_neutral = {
					label = "Frite-tornade", startup = 0.2, active = 0.4, recovery = 0.45,
					damage = 5, hits = 3, hitbox = box(14, 5, 7, 1), kbBase = 24, kbGrowth = 40, kbAngle = 40,
					windup = { Root = { 4, -50, 0, 0, -0.3, 0.1 }, Waist = { 6, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 70, 0, 60 }, RE = { 30, 0, 0 }, RW = { 20, 0, 0 }, LS = { 50, 0, -50 }, LE = { 40, 0, 0 } },
					strike = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 0, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -85 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 0, 20, 0, 0, -0.2, 0 }, Waist = { 0, 10, 0 }, Neck = { -8, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					spin = { axis = "y", degrees = 1080 }, wobble = true, trail = "prop",
					fx = { { "ring", color = NOODLE, radius = 7, at = "root" }, { "particles", tex = "smoke", color = FOAM, at = "root", dir = "all", time = 0.4, speed = 10, rate = 80 } },
					text = "TORNADE !", hitText = "WOUP WOUP WOUP !",
				},
				-- →L : la frite-javelot, lancée comme un javelot en mousse, qui fonce sur l'adversaire et revient en boomerang mou
				S_side = {
					label = "Frite-javelot", kind = "projectile", startup = 0.22, active = 0, recovery = 0.48,
					damage = 14, kbBase = 28, kbGrowth = 55, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.7, size = 2, color = NOODLE, returns = true,
						visual = { shape = "ball", size = 0.4, color = NOODLE, spin = 6, parts = {
							{ "cyl", Vector3.new(4.4, 0.55, 0.55), Vector3.new(0, 0, 0), NOODLE },
							{ "cyl", Vector3.new(0.3, 0.62, 0.62), Vector3.new(1, 0, 0), TOY_GREEN },
							{ "cyl", Vector3.new(0.3, 0.62, 0.62), Vector3.new(-1, 0, 0), TOY_GREEN },
						} } },
					windup = { Root = { 6, -36, 0, 0, -0.25, 0.25 }, Waist = { 8, -40, 0 }, Neck = { 6, 24, 0 }, RS = { 170, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 50, 0, 0 } },
					strike = { Root = { -14, 24, 0, 0, -0.32, -0.45 }, Waist = { -16, 28, 0 }, Neck = { -6, -18, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, 28, 0, 0, -0.34, -0.5 }, Waist = { -18, 32, 0 }, Neck = { -8, -20, 0 }, RS = { 100, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hideProp = "frite", fx = { { "burst", color = NOODLE, size = 2, at = "hand" } }, text = "JAVELOT !", hitText = "ZIOUUU !",
				},
				-- ↓L : il plante la frite dans le carrelage ; elle se plie, se tend et claque tout le couloir vers le haut
				S_down = {
					label = "Frite plantée", startup = 0.22, active = 0.18, recovery = 0.48,
					damage = 13, hitbox = box(14, 5, 7, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 80,
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 30, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.7, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { 40, 0, 0 }, LS = { 60, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 8, 0, 0, 0, -0.1, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 150, 0, 20 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 150, 0, -20 }, LE = { 0, 0, 0 } },
					hold = 0.12, shake = true, trail = "prop",
					fx = { { "beam", color = NOODLE, length = 14, width = 2, at = "feet" }, { "toss", shape = "ball", color = WATER, size = 0.5, count = 6, speed = 20 }, { "ring", color = FOAM, radius = 6, at = "feet" } },
					text = "PLANTÉE !", hitText = "BOÏÏÏNG !",
				},
				-- ↑L : saut à la perche sur la frite : décollage en diagonale, palmes qui battent, la frite traîne derrière
				S_up = {
					label = "Perche de frite", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 78, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 60, 0, 0 }, RW = { 40, 0, 0 }, LS = { 60, 0, -10 }, LE = { 60, 0, 0 } },
					strike = { Root = { -42, 0, 0, 0, 0.3, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -60, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -20 }, LE = { 10, 0, 0 }, RH = { -24, 0, 5 }, RK = { -34, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -5 }, LK = { -44, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -46, 0, 0, 0, 0.35, -0.15 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { -66, 0, 22 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 166, 0, -22 }, LE = { 10, 0, 0 }, RH = { -28, 0, 5 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -34, 0, -5 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
					wobble = true, trail = "body", fx = { { "burst", color = NOODLE, size = 3.5, at = "feet" }, { "ring", color = WATER, radius = 6, at = "feet" }, { "particles", tex = "smoke", color = FOAM, at = "feet", dir = "down", time = 0.4, speed = 16, rate = 100 } },
					text = "HOP LÀ !", hitText = "ENVOLÉ !",
				},
				-- L en l'air : la frite tourne au-dessus de sa tête comme un rotor d'hélico et hache tout autour (3 touches)
				S_air = {
					label = "Frite-rotor", startup = 0.14, active = 0.36, recovery = 0.4,
					damage = 5, hits = 3, hitbox = box(9, 4, 0, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 35, selfVelocity = Vector2.new(0, 18),
					windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 30, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 80, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 178, 0, 0 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 10, 0, -40 }, LE = { 40, 0, 0 }, RH = { 10, 0, 5 }, RK = { -20, 0, 0 }, LH = { 10, 0, -5 }, LK = { -20, 0, 0 } },
					follow = { Root = { 6, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 182, 0, 4 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 14, 0, -42 }, LE = { 40, 0, 0 }, RH = { 14, 0, 5 }, RK = { -24, 0, 0 }, LH = { 14, 0, -5 }, LK = { -24, 0, 0 } },
					spin = { axis = "y", degrees = 1080 }, trail = "prop", fx = { { "ring", color = NOODLE, radius = 5, at = "above" } }, text = "ROTOR !", hitText = "TAC TAC TAC !",
				},
				-- Y : la frite XXL, gonflée jusqu'à devenir un tronc d'arbre en mousse, abattue sur tout le couloir
				SUPER = {
					label = "Frite XXL !", startup = 0.4, active = 0.2, recovery = 0.7,
					damage = 24, hitbox = box(14, 6, 7, 1), kbBase = 44, kbGrowth = 90, kbAngle = 40,
					status = { name = "slippery", duration = 2 },
					windup = { Root = { 10, 0, 0, 0, -0.1, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 190, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -20 }, LE = { 30, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.6, -0.4 }, Waist = { -34, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -20, 0, 0, 0, -0.65, -0.45 }, Waist = { -36, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 52, 0, 8 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 52, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🍟", "💦" }, count = 6, radius = 3, color = NOODLE } },
					fx = { { "beam", color = NOODLE, length = 16, width = 4, at = "front" }, { "puddle", color = WATER, width = 14 }, { "burst", color = FOAM, size = 4, at = "front" }, { "shake", amount = 0.5 } },
					text = "FRITE XXL !", hitText = "ÉCRABOUILLÉ !",
				},
				-- →Y : la frite-harpon : lancée à travers tout le couloir comme un harpon de baleinier, elle embroche et traverse
				SUPER_side = {
					label = "Frite-harpon !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 46, kbGrowth = 90, kbAngle = 28,
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = NOODLE, pierce = true,
						visual = { shape = "ball", size = 0.4, color = NOODLE, parts = {
							{ "cyl", Vector3.new(5.2, 0.7, 0.7), Vector3.new(0, 0, 0), NOODLE },
							{ "wedge", Vector3.new(0.8, 0.9, 0.9), Vector3.new(2.9, 0, 0), WHITE },
							{ "cyl", Vector3.new(0.3, 0.76, 0.76), Vector3.new(-1.2, 0, 0), TOY_GREEN },
						} } },
					status = { name = "wet", duration = 2 },
					windup = { Root = { 8, -40, 0, 0, -0.3, 0.3 }, Waist = { 10, -44, 0 }, Neck = { 8, 28, 0 }, RS = { 176, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -10 }, LE = { 30, 0, 0 } },
					strike = { Root = { -18, 28, 0, 0, -0.36, -0.5 }, Waist = { -20, 32, 0 }, Neck = { -8, -20, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 32, 0, 0, -0.38, -0.55 }, Waist = { -24, 36, 0 }, Neck = { -10, -22, 0 }, RS = { 100, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hideProp = "frite", windupFx = { "super" }, fx = { { "burst", color = NOODLE, size = 3, at = "hand" }, { "beam", color = FOAM, length = 12, width = 1.5, at = "hand" }, { "shake", amount = 0.3 } },
					text = "HARPON !", hitText = "EMBROCHÉ !",
				},
				-- ↑Y : la frite-trampoline : il la plie en arc sous ses palmes et se fait catapulter à la verticale en vrille, tout le couloir part avec lui
				SUPER_up = {
					label = "Frite-trampoline !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(14, 12, 7, 5), kbBase = 44, kbGrowth = 92, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 60),
					windup = { Root = { -8, 0, 0, 0, -0.95, 0 }, Waist = { -30, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 184, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 184, 0, -10 }, LE = { 0, 0, 0 }, RH = { 30, 0, 10 }, RK = { -80, 0, 0 }, LH = { 20, 0, -10 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 20, 0, 0 }, Neck = { 46, 0, 0 }, RS = { 188, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 188, 0, -12 }, LE = { 0, 0, 0 }, RH = { 50, 0, 20 }, RK = { -100, 0, 0 }, LH = { 10, 0, -20 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 720 }, trail = "body", windupFx = { "super" },
					fx = { { "pillar", color = NOODLE, height = 20, width = 3, at = "root" }, { "burst", color = FOAM, size = 4, at = "feet" }, { "ring", color = WATER, radius = 7, at = "feet" }, { "shake", amount = 0.5 } },
					text = "TRAMPOLINE !", hitText = "BOÏÏÏNG !",
				},
				-- ↓Y : battement de frite : il frappe le carrelage à répétition avec la frite, la mousse claque trois fois sur tout le couloir
				SUPER_down = {
					label = "Battement de frite !", startup = 0.35, active = 0.45, recovery = 0.7,
					damage = 8, hits = 3, hitbox = box(16, 4, 8, -0.5), kbBase = 40, kbGrowth = 70, kbAngle = 60,
					status = { name = "stunned", duration = 0.8 },
					windup = { Root = { 12, 0, 0, 0, -0.2, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 180, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -10 }, LE = { 30, 0, 0 } },
					strike = { Root = { -20, 0, 0, 0, -0.8, -0.3 }, Waist = { -34, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 10, 0, 0, 0, -0.2, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -12 }, LE = { 10, 0, 0 } },
					shake = true, wobble = true, trail = "prop", windupFx = { "super" },
					fx = { { "beam", color = NOODLE, length = 16, width = 3, at = "feet" }, { "puddle", color = WATER, width = 16, time = 1.2 }, { "toss", shape = "ball", color = WATER, size = 0.6, count = 8, speed = 24 }, { "shake", amount = 0.5 } },
					text = "PLAF PLAF PLAF !", hitText = "APLATI !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_neutral" },
				K_side = { P = "P_up", K = "K_up", S = "S_side" },
				P_dash = { P = "P_side", K = "K_dash", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "bazooka", name = "Bazooka à canards", icon = "🦆",
			prop = { name = "PropBazooka", hand = "Right", pieces = {
				{ "Poignee", "", "block", Vector3.new(0.28, 0.5, 0.42), Vector3.new(0, -0.12, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
				{ "Tube", "", "cyl", Vector3.new(2.8, 0.72, 0.72), Vector3.new(0, -1.35, 0.32), Vector3.new(0, 0, 0), BAZOOKA, "Metal", { axis = "y" } },
				{ "Bouche", "", "cyl", Vector3.new(0.32, 0.98, 0.98), Vector3.new(0, -2.78, 0.32), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic", { axis = "y" } },
				{ "CanardCharge", "", "ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0, -2.86, 0.32), Vector3.new(0, 0, 0), DUCK, "SmoothPlastic" },
				{ "Viseur", "", "block", Vector3.new(0.14, 0.42, 0.14), Vector3.new(0, -1.5, -0.14), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
				{ "Ancre", "", "block", Vector3.new(0.3, 0.3, 0.05), Vector3.new(0, -1.0, 0.72), Vector3.new(0, 0, 45), GOLD, "Metal" },
			} },
			ability = { knockback = 1.25, text = "Éjection +25 % : chaque canard est un boulet de canon" },
			moves = {
				-- J : coup de crosse du bazooka, lourd, en pivotant les hanches
				P_neutral = {
					label = "Coup de crosse", startup = 0.1, active = 0.08, recovery = 0.16,
					damage = 7, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 24, kbGrowth = 30, kbAngle = 25,
					windup = { Root = { 2, 24, 0, 0, -0.2, 0.15 }, Waist = { 4, 28, 0 }, Neck = { 0, -18, 0 }, RS = { 40, 0, 40 }, RE = { 100, 0, 0 }, RW = { 60, 0, 0 }, LS = { 70, 0, -10 }, LE = { 90, 0, 0 } },
					strike = { Root = { -6, -18, 0, 0, -0.25, -0.3 }, Waist = { -8, -22, 0 }, Neck = { 0, 12, 0 }, RS = { 70, 0, 50 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 90, 0, -10 }, LE = { 70, 0, 0 } },
					follow = { Root = { -6, -24, 0, 0, -0.25, -0.34 }, Waist = { -8, -28, 0 }, Neck = { 0, 16, 0 }, RS = { 66, 0, 56 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 92, 0, -12 }, LE = { 70, 0, 0 } },
					trail = "prop", hitText = "BONK !",
				},
				-- →J : un canard tiré à bout portant, qui rebondit sur le front (recul sur ses palmes)
				P_side = {
					label = "Canard à bout portant", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
					damage = 8, kbBase = 26, kbGrowth = 45, kbAngle = 30, selfVelocity = Vector2.new(-6, 0),
					projectile = { speed = 70, angle = 4, gravity = 30, lifetime = 0.3, size = 1.3, color = DUCK, visual = RUBBER_DUCK, aim = false },
					windup = { Root = { 4, -20, 0, 0, -0.25, 0.1 }, Waist = { 4, -22, 0 }, RS = { 80, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 25 }, LE = { 70, 0, 0 } },
					strike = { Root = { 6, 10, 0, 0, -0.28, 0.2 }, Waist = { 6, 10, 0 }, Neck = { 8, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 22 }, LE = { 30, 0, 0 } },
					follow = { Root = { 10, 10, 0, 0, -0.28, 0.3 }, Waist = { 10, 10, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 0 }, RE = { 5, 0, 0 }, RW = { 10, 0, 0 }, LS = { 92, 0, 22 }, LE = { 30, 0, 0 } },
					shake = true, fx = { { "burst", color = FOAM, size = 1.5, at = "hand" } }, text = "POUF !", hitText = "COUIC !",
				},
				-- ↓J : canon posé sur le carrelage, il tire un canard qui ricoche dans les tibias
				P_down = {
					label = "Tir dans les tibias", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
					damage = 7, kbBase = 24, kbGrowth = 35, kbAngle = 70,
					projectile = { speed = 65, angle = 0, gravity = 0, lifetime = 0.3, size = 1.2, color = DUCK, visual = RUBBER_DUCK, aim = false, from = "feet" },
					windup = { Root = { -8, -16, 0, 0, -0.85, 0.1 }, Waist = { -16, -12, 0 }, Neck = { -8, 10, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 90, 0, 0 } },
					strike = { Root = { -10, 6, 0, 0, -0.95, -0.1 }, Waist = { -20, 6, 0 }, Neck = { -4, -4, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, 10 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -8, 6, 0, 0, -0.95, 0 }, Waist = { -18, 6, 0 }, Neck = { -4, -4, 0 }, RS = { 44, 0, 0 }, RE = { 4, 0, 0 }, RW = { -20, 0, 0 }, LS = { 52, 0, 10 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					shake = true, fx = { { "particles", tex = "smoke", color = FOAM, at = "feet", dir = "front", time = 0.15, speed = 10 } }, hitText = "COUIC !",
				},
				-- ↑J : canon pointé au ciel, un canard part en cloche cueillir ce qui passe au-dessus
				P_up = {
					label = "Canard anti-aérien", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
					damage = 7, kbBase = 26, kbGrowth = 40, kbAngle = 85,
					projectile = { speed = 60, angle = 80, gravity = 40, lifetime = 0.4, size = 1.3, color = DUCK, visual = RUBBER_DUCK, aim = false },
					windup = { Root = { 6, 0, 0, 0, -0.4, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 90, 0, 0 } },
					strike = { Root = { -4, 0, 0, 0, -0.35, -0.05 }, Waist = { -8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, 0 }, LE = { 20, 0, 0 } },
					follow = { Root = { 0, 0, 0, 0, -0.4, 0 }, Waist = { -4, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 160, 0, 12 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 140, 0, 0 }, LE = { 30, 0, 0 } },
					shake = true, fx = { { "burst", color = FOAM, size = 1.5, at = "above" } }, hitText = "COUIC !",
				},
				-- J en l'air : il vise sous lui et tire un canard en piqué
				P_air = {
					label = "Tir en piqué", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 8, kbBase = 22, kbGrowth = 40, kbAngle = -40, selfVelocity = Vector2.new(0, 10),
					projectile = { speed = 70, angle = -45, gravity = 20, lifetime = 0.35, size = 1.3, color = DUCK, visual = RUBBER_DUCK, aim = false },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -8, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 46, 0, 0 }, RE = { 4, 0, 0 }, RW = { 10, 0, 0 }, LS = { 44, 0, 20 }, LE = { 20, 0, 0 }, RH = { 24, 0, 0 }, RK = { -44, 0, 0 }, LH = { 34, 0, 0 }, LK = { -64, 0, 0 } },
					shake = true, fx = { { "burst", color = FOAM, size = 1.5, at = "hand" } }, hitText = "COUIC !",
				},
				-- dash J : charge à la baïonnette, le canard chargé dans le canon sert de pointe
				P_dash = {
					label = "Charge à la baïonnette", startup = 0.08, active = 0.12, recovery = 0.24,
					damage = 8, hitbox = box(5, 3, 3, 0.6), kbBase = 28, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(42, 0),
					windup = { Root = { -8, -16, 0, 0, -0.3, 0.1 }, Waist = { -6, -14, 0 }, RS = { 50, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -18, 12, 0, 0, -0.4, -0.35 }, Waist = { -8, 12, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 20 }, LE = { 20, 0, 0 } },
					follow = { Root = { -20, 14, 0, 0, -0.42, -0.4 }, Waist = { -10, 14, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 92, 0, 20 }, LE = { 20, 0, 0 } },
					trail = "prop", fx = { "dust" }, text = "À L'ABORDAGE !", hitText = "PIQUÉ !",
				},
				-- K : le gros canard : un canard de bain géant tiré de face, le recul le fait reculer d'un pas
				K_neutral = {
					label = "Gros canard", kind = "projectile", startup = 0.2, active = 0, recovery = 0.32,
					damage = 11, kbBase = 30, kbGrowth = 80, kbAngle = 30, selfVelocity = Vector2.new(-12, 0),
					projectile = { speed = 60, angle = 2, gravity = 20, lifetime = 0.5, size = 2.4, color = DUCK, visual = RUBBER_DUCK, aim = false },
					windup = { Root = { 6, -24, 0, 0, -0.3, 0.2 }, Waist = { 8, -26, 0 }, Neck = { 6, 16, 0 }, RS = { 76, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 25 }, LE = { 70, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
					strike = { Root = { 12, 10, 0, 0, -0.3, 0.35 }, Waist = { 12, 10, 0 }, Neck = { 14, -4, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.4 } },
					follow = { Root = { 16, 10, 0, 0, -0.3, 0.45 }, Waist = { 16, 10, 0 }, Neck = { 16, -4, 0 }, RS = { 102, 0, 0 }, RE = { 6, 0, 0 }, RW = { 12, 0, 0 }, LS = { 92, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.5 } },
					shake = true, fx = { { "burst", color = FOAM, size = 2.5, at = "hand" }, { "particles", tex = "smoke", color = FOAM, at = "hand", dir = "front", time = 0.2, speed = 16 } }, text = "BOUM !", hitText = "COUIIIC !",
				},
				-- →K : un genou à terre, bazooka à l'épaule : tir lourd qui éjecte loin et le fait glisser en arrière
				K_side = {
					label = "Tir à l'épaule", kind = "projectile", startup = 0.24, active = 0, recovery = 0.36,
					damage = 13, kbBase = 34, kbGrowth = 90, kbAngle = 28, selfVelocity = Vector2.new(-16, 0),
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 0.6, size = 2, color = DUCK, visual = RUBBER_DUCK, aim = false },
					windup = { Root = { 4, -16, 0, 0, -0.7, 0.1 }, Waist = { 6, -18, 0 }, Neck = { 4, 12, 0 }, RS = { 110, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 20 }, LE = { 60, 0, 0 }, RH = { -40, 0, 0 }, RK = { -90, 0, 0 }, RA = { -20, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, -0.75, 0.3 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 25 }, LE = { 30, 0, 0 }, RH = { -40, 0, 0 }, RK = { -90, 0, 0 }, RA = { -20, 0, 0 } },
					follow = { Root = { 14, 0, 0, 0, -0.75, 0.4 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 108, 0, 0 }, RE = { 6, 0, 0 }, RW = { 12, 0, 0 }, LS = { 98, 0, 25 }, LE = { 30, 0, 0 }, RH = { -40, 0, 0 }, RK = { -90, 0, 0 }, RA = { -20, 0, 0 } },
					shake = true, fx = { { "burst", color = BEAK, size = 3, at = "hand" }, { "beam", color = FOAM, length = 8, width = 1.4, at = "hand" }, { "shake", amount = 0.25 } }, text = "FEU !", hitText = "KABOUM-COUIC !",
				},
				-- ↓K : mortier de canard : accroupi, il tire en cloche un canard qui retombe lourdement devant lui
				K_down = {
					label = "Mortier de canard", kind = "projectile", startup = 0.2, active = 0, recovery = 0.34,
					damage = 11, kbBase = 28, kbGrowth = 60, kbAngle = 60,
					projectile = { speed = 55, angle = 70, gravity = 90, lifetime = 0.9, size = 1.8, color = DUCK, visual = RUBBER_DUCK, aim = false },
					windup = { Root = { -6, 0, 0, 0, -0.9, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 10 }, LE = { 90, 0, 0 } },
					strike = { Root = { -2, 0, 0, 0, -0.95, 0 }, Waist = { -10, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 150, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, 0 }, LE = { 20, 0, 0 } },
					follow = { Root = { 2, 0, 0, 0, -0.95, 0.05 }, Waist = { -6, 0, 0 }, Neck = { -32, 0, 0 }, RS = { 140, 0, 12 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 130, 0, 0 }, LE = { 30, 0, 0 } },
					shake = true, fx = { { "burst", color = FOAM, size = 2, at = "hand" }, { "particles", tex = "smoke", color = FOAM, at = "hand", dir = "up", time = 0.2, speed = 14 } }, text = "PLOMB !", hitText = "SPLATCH-COUIC !",
				},
				-- ↑K : recul vertical : il tire droit dans le carrelage, le recul le propulse et le canon cogne tout ce qui est au-dessus
				K_up = {
					label = "Recul vertical", startup = 0.16, active = 0.14, recovery = 0.3,
					damage = 10, hitbox = box(4.5, 5.5, 0.5, 3), kbBase = 32, kbGrowth = 70, kbAngle = 88, selfVelocity = Vector2.new(0, 36),
					windup = { Root = { -8, 0, 0, 0, -0.6, 0 }, Waist = { -20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, 10 }, LE = { 30, 0, 0 } },
					strike = { Root = { 8, 0, 0, 0, 0.4, 0 }, Waist = { 14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -8 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.5, 0 }, Waist = { 16, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 182, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 176, 0, -10 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
					shake = true, trail = "prop", fx = { { "pillar", color = FOAM, height = 8, width = 1.8, at = "feet" }, { "burst", color = DUCK, size = 2, at = "feet" } }, text = "PSCHOUM !", hitText = "KLONG !",
				},
				-- K en l'air : bazooka-marteau, il abat le tube à deux mains sur la tête de l'adversaire
				K_air = {
					label = "Bazooka-marteau", startup = 0.16, active = 0.12, recovery = 0.26,
					damage = 11, hitbox = box(5, 4, 2, -1), kbBase = 28, kbGrowth = 65, kbAngle = -45,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -12 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -16, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -8 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -20, 0, 0 }, Waist = { -36, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 30, 0, 8 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -8 }, LE = { 6, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "KLONK !",
				},
				-- dash K : il tire vers l'arrière pour se propulser et percute avec la crosse en glissant sur ses palmes
				K_dash = {
					label = "Recul-glissade", startup = 0.1, active = 0.22, recovery = 0.3,
					damage = 11, hitbox = box(5, 3.5, 3, 0), kbBase = 30, kbGrowth = 65, kbAngle = 35, selfVelocity = Vector2.new(56, 0),
					windup = { Root = { -8, 40, 0, 0, -0.4, 0 }, Waist = { -10, 30, 0 }, Neck = { 0, -30, 0 }, RS = { -60, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 18, -10, 0, 0, -0.6, 0 }, Waist = { 8, -10, 0 }, Neck = { -10, 6, 0 }, RS = { -70, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -30 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -20, 0, 0 }, RA = { 20, 0, 0 }, LH = { 80, 0, 0 }, LK = { -90, 0, 0 } },
					follow = { Root = { 20, -12, 0, 0, -0.62, 0 }, Waist = { 10, -12, 0 }, Neck = { -12, 6, 0 }, RS = { -74, 0, 32 }, RE = { 10, 0, 0 }, RW = { -5, 0, 0 }, LS = { 92, 0, -32 }, LE = { 30, 0, 0 }, RH = { 62, 0, 0 }, RK = { -20, 0, 0 }, RA = { 20, 0, 0 }, LH = { 82, 0, 0 }, LK = { -92, 0, 0 } },
					shake = true, trail = "prop", fx = { { "burst", color = FOAM, size = 2.5, at = "root" }, { "puddle", color = WATER, width = 6 } }, text = "VRRROUM !", hitText = "BLAM !",
				},
				-- L : rafale de canards, trois canards tirés à la suite qui filent tous sur l'adversaire
				S_neutral = {
					label = "Rafale de canards", kind = "projectile", startup = 0.22, active = 0, recovery = 0.48,
					damage = 6, kbBase = 26, kbGrowth = 45, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.6, size = 1.5, color = DUCK, visual = RUBBER_DUCK, fan = { count = 3, from = -8, to = 8, gap = 0.06 } },
					windup = { Root = { 6, -24, 0, 0, -0.3, 0.2 }, Waist = { 8, -28, 0 }, Neck = { 4, 18, 0 }, RS = { 74, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 25 }, LE = { 70, 0, 0 } },
					strike = { Root = { 10, 12, 0, 0, -0.3, 0.3 }, Waist = { 10, 12, 0 }, Neck = { 10, -6, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
					follow = { Root = { 14, 12, 0, 0, -0.3, 0.4 }, Waist = { 14, 12, 0 }, Neck = { 12, -6, 0 }, RS = { 102, 0, 0 }, RE = { 6, 0, 0 }, RW = { 12, 0, 0 }, LS = { 94, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.4 } },
					shake = true, wobble = true, fx = { { "burst", color = FOAM, size = 2.5, at = "hand" }, { "symbols", symbols = { "COIN", "🦆" }, color = DUCK, count = 4, radius = 3, at = "front" } }, text = "RAFALE !", hitText = "COIN COIN COIN !",
				},
				-- →L : le canard-obus : un canard géant tiré à pleine charge, qui traverse tout sur son passage et éjecte très loin
				S_side = {
					label = "Canard-obus", kind = "projectile", startup = 0.26, active = 0, recovery = 0.52,
					damage = 15, kbBase = 34, kbGrowth = 80, kbAngle = 28, selfVelocity = Vector2.new(-14, 0),
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.7, size = 2.8, color = DUCK, visual = RUBBER_DUCK, pierce = true },
					windup = { Root = { 8, -30, 0, 0, -0.35, 0.25 }, Waist = { 10, -34, 0 }, Neck = { 6, 20, 0 }, RS = { 70, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 25 }, LE = { 80, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
					strike = { Root = { 14, 14, 0, 0, -0.35, 0.4 }, Waist = { 14, 14, 0 }, Neck = { 14, -8, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.45 } },
					follow = { Root = { 18, 14, 0, 0, -0.35, 0.5 }, Waist = { 18, 14, 0 }, Neck = { 16, -8, 0 }, RS = { 104, 0, 0 }, RE = { 6, 0, 0 }, RW = { 14, 0, 0 }, LS = { 94, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.55 } },
					shake = true, fx = { { "burst", color = BEAK, size = 3.5, at = "hand" }, { "beam", color = FOAM, length = 12, width = 2, at = "hand" }, { "particles", tex = "smoke", color = FOAM, at = "hand", dir = "front", time = 0.3, speed = 20, rate = 80 }, { "shake", amount = 0.3 } },
					text = "OBUS !", hitText = "KABLAM-COUIC !",
				},
				-- ↓L : la mine canard : il pose un canard piégé devant lui ; le premier qui marche dessus décolle
				S_down = {
					label = "Mine canard", kind = "trap", startup = 0.22, active = 0.12, recovery = 0.48,
					damage = 13, kbBase = 40, kbGrowth = 60, kbAngle = 82,
					trap = { size = Vector3.new(4, 2, 6), offset = 5, lifetime = 8, max = 2, color = DUCK,
						visual = { shape = "ball", size = 1.4, color = DUCK, spin = 0, trail = false, parts = {
							{ "ball", Vector3.new(0.85, 0.85, 0.85), Vector3.new(0.35, 0.75, 0), DUCK },
							{ "block", Vector3.new(0.5, 0.18, 0.4), Vector3.new(0.85, 0.7, 0), BEAK },
							{ "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(-0.4, 0.9, 0), Color3.fromRGB(220, 40, 40) },
						} } },
					windup = { Root = { 6, 0, 0, 0, -0.5, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -14, 10, 0, 0, -0.9, -0.3 }, Waist = { -24, 12, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 4, 0, 0, 0, -0.3, 0.2 }, Waist = { 8, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					trail = "leftHand", fx = { { "symbols", symbols = { "💣", "🦆" }, color = DUCK, count = 3, radius = 2, at = "front" } }, text = "MINE POSÉE…", hitText = "COUIC-BOUM !",
				},
				-- ↑L : recul-décollage : il tire plein pot vers le bas et le recul le catapulte en diagonale, bazooka fumant derrière lui
				S_up = {
					label = "Recul-décollage", startup = 0.15, active = 0.3, recovery = 0.45,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 78, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -20, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -42, 0, 0, 0, 0.3, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -70, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 10, 0, 0 }, RH = { -24, 0, 5 }, RK = { -34, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -5 }, LK = { -44, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -46, 0, 0, 0, 0.35, -0.15 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { -76, 0, 22 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -22 }, LE = { 10, 0, 0 }, RH = { -28, 0, 5 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -34, 0, -5 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
					shake = true, trail = "body", fx = { { "burst", color = BEAK, size = 4, at = "feet" }, { "pillar", color = FOAM, height = 10, width = 3, at = "feet" }, { "particles", tex = "smoke", color = FOAM, at = "feet", dir = "down", time = 0.45, speed = 18, rate = 110 }, { "shake", amount = 0.3 } },
					text = "RECUL !", hitText = "EMPORTÉ !",
				},
				-- L en l'air : bombardement, il vise le sol et lâche trois canards qui tombent sur l'adversaire
				S_air = {
					label = "Bombardement", kind = "projectile", startup = 0.16, active = 0, recovery = 0.42,
					damage = 7, kbBase = 24, kbGrowth = 45, kbAngle = -40, selfVelocity = Vector2.new(0, 14),
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.4, color = DUCK, visual = RUBBER_DUCK, rain = { count = 3, spread = 5 } },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 80, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 30, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, 20 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -10, 0, 0 }, Waist = { -22, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 36, 0, 0 }, RE = { 4, 0, 0 }, RW = { 10, 0, 0 }, LS = { 34, 0, 20 }, LE = { 20, 0, 0 }, RH = { 24, 0, 0 }, RK = { -44, 0, 0 }, LH = { 34, 0, 0 }, LK = { -64, 0, 0 } },
					shake = true, fx = { { "burst", color = FOAM, size = 2, at = "hand" } }, text = "BOMBARDEMENT !", hitText = "COUIC COUIC !",
				},
				-- Y : le canard nucléaire : un canard de bain énorme, jaune fluo, tiré à pleine charge qui traverse tout le couloir
				SUPER = {
					label = "Canard nucléaire !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30, selfVelocity = Vector2.new(-20, 0),
					projectile = { speed = 65, angle = 0, gravity = 0, lifetime = 1.0, size = 4.2, color = DUCK, pierce = true,
						visual = { shape = "ball", size = 3.6, color = DUCK, neon = true, spin = 0, parts = {
							{ "ball", Vector3.new(2.2, 2.2, 2.2), Vector3.new(1, 1.9, 0), DUCK },
							{ "block", Vector3.new(1.3, 0.45, 1.0), Vector3.new(2.3, 1.75, 0), BEAK },
							{ "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(1.6, 2.4, -0.8), BLACK },
						} } },
					status = { name = "wet", duration = 3 },
					windup = { Root = { 10, -34, 0, 0, -0.5, 0.3 }, Waist = { 12, -38, 0 }, Neck = { 8, 24, 0 }, RS = { 70, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 25 }, LE = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
					strike = { Root = { 18, 16, 0, 0, -0.4, 0.5 }, Waist = { 18, 16, 0 }, Neck = { 16, -8, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.5 } },
					follow = { Root = { 24, 16, 0, 0, -0.4, 0.6 }, Waist = { 24, 16, 0 }, Neck = { 18, -8, 0 }, RS = { 108, 0, 0 }, RE = { 8, 0, 0 }, RW = { 16, 0, 0 }, LS = { 96, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.6 } },
					shake = true, windupFx = { "super", { "symbols", symbols = { "☢️", "🦆" }, count = 6, radius = 3, color = DUCK } },
					fx = { { "burst", color = DUCK, size = 5, at = "hand" }, { "beam", color = BEAK, length = 14, width = 3, at = "hand" }, { "screen", color = DUCK, alpha = 0.2 }, { "shake", amount = 0.6 } },
					text = "CANARD NUCLÉAIRE !", hitText = "KA-COUIIIC !",
				},
				-- →Y : tir à la chevrotine : six canards tirés d'un coup en éventail, qui filent tous sur l'adversaire
				SUPER_side = {
					label = "Chevrotine de canards !", kind = "projectile", startup = 0.38, active = 0, recovery = 0.7,
					damage = 5, kbBase = 30, kbGrowth = 50, kbAngle = 35, selfVelocity = Vector2.new(-18, 0),
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 1.5, color = DUCK, visual = RUBBER_DUCK, fan = { count = 6, from = -18, to = 24 } },
					status = { name = "wet", duration = 2 },
					windup = { Root = { 8, -28, 0, 0, -0.35, 0.25 }, Waist = { 10, -32, 0 }, Neck = { 6, 20, 0 }, RS = { 72, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 82, 0, 25 }, LE = { 80, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 } },
					strike = { Root = { 14, 12, 0, 0, -0.35, 0.4 }, Waist = { 14, 12, 0 }, Neck = { 12, -6, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.45 } },
					follow = { Root = { 18, 12, 0, 0, -0.35, 0.5 }, Waist = { 18, 12, 0 }, Neck = { 14, -6, 0 }, RS = { 104, 0, 0 }, RE = { 6, 0, 0 }, RW = { 14, 0, 0 }, LS = { 94, 0, 22 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.55 } },
					shake = true, windupFx = { "super" }, fx = { { "burst", color = BEAK, size = 4, at = "hand" }, { "symbols", symbols = { "COIN", "COIN", "🦆" }, color = DUCK, count = 8, radius = 5, at = "front" }, { "shake", amount = 0.4 } },
					text = "CHEVROTINE !", hitText = "COIN-COIN-COIN-COIN !",
				},
				-- ↑Y : le tire-bouchon : il tire dans le carrelage et le recul l'envoie en vrille à la verticale, le canon fauche tout le couloir
				SUPER_up = {
					label = "Tire-bouchon de bazooka !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(14, 12, 7, 5), kbBase = 44, kbGrowth = 92, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 65),
					windup = { Root = { -8, 0, 0, 0, -0.9, 0 }, Waist = { -26, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 10, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, 10 }, LE = { 20, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 90, 0, 90 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 0, 0, 0 }, RH = { 20, 0, 10 }, RK = { -60, 0, 0 }, LH = { 20, 0, -10 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 90, 0, 92 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 90, 0, -92 }, LE = { 0, 0, 0 }, RH = { 30, 0, 14 }, RK = { -70, 0, 0 }, LH = { 30, 0, -14 }, LK = { -70, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 1080 }, trail = "prop", windupFx = { "super" },
					fx = { { "pillar", color = BEAK, height = 22, width = 3.5, at = "root" }, { "burst", color = FOAM, size = 5, at = "feet" }, { "ring", color = DUCK, radius = 8, at = "feet" }, { "shake", amount = 0.5 } },
					text = "TIRE-BOUCHON !", hitText = "VRILLÉ !",
				},
				-- ↓Y : la balayeuse : allongé sur le ventre, il tire en rafale au ras du carrelage en balayant tout le couloir (2 touches)
				SUPER_down = {
					label = "Bazooka-balayeuse !", startup = 0.35, active = 0.4, recovery = 0.7,
					damage = 11, hits = 2, hitbox = box(16, 4, 8, -0.5), kbBase = 42, kbGrowth = 80, kbAngle = 55,
					status = { name = "slowed", duration = 2 },
					windup = { Root = { -14, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -78, 0, 0, 0, -1.45, -0.3 }, Waist = { 8, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 176, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -10 }, LE = { 0, 0, 0 }, RH = { -8, 0, 6 }, RK = { -20, 0, 0 }, RA = { -30, 0, 0 }, LH = { -8, 0, -6 }, LK = { -20, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -80, 0, 0, 0, -1.5, -0.35 }, Waist = { 10, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 178, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -30 }, LE = { 0, 0, 0 }, RH = { -10, 0, 6 }, RK = { -30, 0, 0 }, RA = { -30, 0, 0 }, LH = { -10, 0, -6 }, LK = { -30, 0, 0 }, LA = { -30, 0, 0 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super" },
					fx = { { "beam", color = BEAK, length = 16, width = 2.5, at = "feet" }, { "toss", shape = "ball", color = DUCK, size = 1, count = 6, speed = 26 }, { "particles", tex = "smoke", color = FOAM, at = "hand", dir = "front", time = 0.5, speed = 18, rate = 100 }, { "shake", amount = 0.4 } },
					text = "BALAYAGE !", hitText = "COUIC-COUIC-COUIC !",
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
		body = { head = SKIN, upper = WHITE, lower = Color3.fromRGB(210, 50, 50), arms = SKIN, hands = SKIN,
			legs = SKIN, feet = BEAK, forearms = SKIN, shins = SKIN },
		cubeHead = 1.25,
		parts = {
			-- casquette de capitaine (blanche, visière noire, ancre dorée)
			{ "Casquette", "Head", "cyl", Vector3.new(0.45, 1.35, 1.35), Vector3.new(0, 0.82, 0.02), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic", { axis = "y" } },
			{ "Bandeau", "Head", "cyl", Vector3.new(0.18, 1.3, 1.3), Vector3.new(0, 0.66, 0.02), Vector3.new(0, 0, 0), NAVY, "Fabric", { axis = "y" } },
			{ "Visiere", "Head", "block", Vector3.new(1.05, 0.08, 0.45), Vector3.new(0, 0.6, -0.72), Vector3.new(-8, 0, 0), BLACK, "SmoothPlastic" },
			{ "Ancre", "Head", "block", Vector3.new(0.25, 0.25, 0.05), Vector3.new(0, 0.68, -0.67), Vector3.new(0, 0, 45), GOLD, "Metal" },
			-- masque de plongée sur les yeux et tuba
			{ "Masque", "Head", "block", Vector3.new(1.0, 0.45, 0.14), Vector3.new(0, 0.18, -0.68), Vector3.new(0, 0, 0), Color3.fromRGB(170, 225, 255), "Glass", { transparency = 0.35, reflect = 0.2 } },
			{ "CadreMasque", "Head", "block", Vector3.new(1.12, 0.56, 0.08), Vector3.new(0, 0.18, -0.64), Vector3.new(0, 0, 0), Color3.fromRGB(40, 120, 200), "SmoothPlastic" },
			{ "Sangle", "Head", "block", Vector3.new(1.32, 0.14, 1.32), Vector3.new(0, 0.18, 0), Vector3.new(0, 0, 0), Color3.fromRGB(40, 120, 200), "Fabric" },
			{ "Tuba", "Head", "cyl", Vector3.new(1.3, 0.2, 0.2), Vector3.new(0.72, 0.5, -0.15), Vector3.new(0, 0, -8), Color3.fromRGB(255, 230, 40), "SmoothPlastic", { axis = "y" } },
			-- barbe blanche de vieux capitaine
			{ "Barbe", "Head", "block", Vector3.new(1.1, 0.45, 0.22), Vector3.new(0, -0.42, -0.66), Vector3.new(0, 0, 0), WHITE, "Fabric" },
			{ "Nez", "Head", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0, -0.08, -0.72), Vector3.new(0, 0, 0), Color3.fromRGB(240, 150, 130), "SmoothPlastic" },
			-- marinière : deux rayures bleues
			{ "Rayure1", "UpperTorso", "block", Vector3.new(2.02, 0.22, 1.02), Vector3.new(0, 0.35, 0), Vector3.new(0, 0, 0), NAVY, "Fabric" },
			{ "Rayure2", "UpperTorso", "block", Vector3.new(2.02, 0.22, 1.02), Vector3.new(0, -0.2, 0), Vector3.new(0, 0, 0), NAVY, "Fabric" },
			-- la bouée canard autour de la taille (tête de canard devant, queue derrière)
			{ "Bouee", "LowerTorso", "ball", Vector3.new(3.4, 1.15, 2.6), Vector3.new(0, 0.25, 0), Vector3.new(0, 0, 0), DUCK, "SmoothPlastic", { reflect = 0.1 } },
			{ "CouCanard", "LowerTorso", "cyl", Vector3.new(0.9, 0.55, 0.55), Vector3.new(0, 0.85, -1.3), Vector3.new(-15, 0, 0), DUCK, "SmoothPlastic", { axis = "y" } },
			{ "TeteCanard", "LowerTorso", "ball", Vector3.new(0.95, 0.95, 0.95), Vector3.new(0, 1.35, -1.4), Vector3.new(0, 0, 0), DUCK, "SmoothPlastic" },
			{ "BecCanard", "LowerTorso", "ball", Vector3.new(0.55, 0.25, 0.6), Vector3.new(0, 1.25, -1.9), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic" },
			{ "OeilG", "LowerTorso", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(-0.25, 1.5, -1.82), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
			{ "OeilD", "LowerTorso", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(0.25, 1.5, -1.82), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
			{ "QueueCanard", "LowerTorso", "wedge", Vector3.new(0.5, 0.6, 0.6), Vector3.new(0, 0.6, 1.45), Vector3.new(0, 180, 0), DUCK, "SmoothPlastic" },
			-- palmes orange
			{ "PalmeD", "RightFoot", "block", Vector3.new(0.95, 0.12, 1.7), Vector3.new(0, -0.22, -0.55), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic" },
			{ "PalmeG", "LeftFoot", "block", Vector3.new(0.95, 0.12, 1.7), Vector3.new(0, -0.22, -0.55), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : pistolet à eau en plastique, réservoir transparent
			{ name = "PropPistolet", hand = "Right", visible = true, pieces = {
				{ "Crosse", "", "block", Vector3.new(0.35, 0.55, 0.45), Vector3.new(0, -0.15, 0), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic" },
				{ "Corps", "", "block", Vector3.new(0.45, 0.85, 0.55), Vector3.new(0, -0.6, 0.05), Vector3.new(0, 0, 0), TOY_GREEN, "SmoothPlastic" },
				{ "Canon", "", "cyl", Vector3.new(0.75, 0.28, 0.28), Vector3.new(0, -1.3, 0), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic", { axis = "y" } },
				{ "Embout", "", "cyl", Vector3.new(0.14, 0.2, 0.2), Vector3.new(0, -1.72, 0), Vector3.new(0, 0, 0), Color3.fromRGB(220, 40, 40), "SmoothPlastic", { axis = "y" } },
				{ "Reservoir", "", "ball", Vector3.new(0.6, 0.7, 0.6), Vector3.new(0, -0.55, 0.45), Vector3.new(0, 0, 0), WATER, "Glass", { transparency = 0.3 } },
			} },
			-- corne de brume (coin-coin), main gauche
			{ name = "PropCorne", hand = "Left", visible = false, pieces = {
				{ "Poire", "", "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0, -0.15, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 40, 40), "SmoothPlastic" },
				{ "Pavillon", "", "cyl", Vector3.new(0.9, 0.45, 0.45), Vector3.new(0, -0.7, 0), Vector3.new(0, 0, 0), GOLD, "Metal", { axis = "y" } },
				{ "Bouche", "", "cyl", Vector3.new(0.12, 0.85, 0.85), Vector3.new(0, -1.2, 0), Vector3.new(0, 0, 0), GOLD, "Metal", { axis = "y" } },
			} },
			-- canard en plastique qui fait COUIC, main gauche
			{ name = "PropCanardJouet", hand = "Left", visible = false, pieces = {
				{ "Corps", "", "ball", Vector3.new(0.8, 0.6, 0.9), Vector3.new(0, -0.45, 0), Vector3.new(0, 0, 0), DUCK, "SmoothPlastic" },
				{ "Tete", "", "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, -0.1, -0.25), Vector3.new(0, 0, 0), DUCK, "SmoothPlastic" },
				{ "Bec", "", "block", Vector3.new(0.3, 0.12, 0.25), Vector3.new(0, -0.12, -0.55), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de bouée : il se tortille et donne un coup de hanche, la bouée caoutchouteuse rebondit et éclabousse
		P_neutral = {
			label = "Coup de bouée", startup = 0.08, active = 0.08, recovery = 0.15,
			damage = 6, hitbox = box(4, 3, 2.3, -0.3), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { 6, -26, 8, 0, -0.2, 0.2 }, Waist = { 6, -12, -6 }, Neck = { 0, 14, 4 }, RS = { 60, 0, 45 }, RE = { 75, 0, 0 }, RW = { 10, 0, 0 }, LS = { 50, 0, -45 }, LE = { 70, 0, 0 } },
			strike = { Root = { -4, 28, -10, 0, -0.26, -0.35 }, Waist = { 14, 12, 8 }, Neck = { -6, -12, -4 }, RS = { 35, 0, 75 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, -75 }, LE = { 25, 0, 0 } },
			follow = { Root = { -6, 34, -12, 0, -0.28, -0.4 }, Waist = { 16, 16, 10 }, Neck = { -8, -16, -6 }, RS = { 30, 0, 82 }, RE = { 25, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -82 }, LE = { 25, 0, 0 } },
			trail = "body", fx = { { "particles", tex = "smoke", color = WATER, at = "front", dir = "all", time = 0.15, speed = 10, size = 0.5 } }, hitText = "BLOING !",
		},
		-- Jet court (J J) : pistolet tendu à bout de bras, petite giclée à bout portant
		P_combo2 = {
			label = "Jet court", startup = 0.07, active = 0.1, recovery = 0.15,
			damage = 5, hitbox = box(5, 3.5, 3.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 2, -16, 0, 0, -0.2, 0.15 }, Waist = { 2, -14, 0 }, RS = { 70, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -4, 12, 0, 0, -0.22, -0.2 }, Waist = { -4, 14, 0 }, RS = { 92, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -35 }, LE = { 70, 0, 0 } },
			follow = { Root = { 2, 12, 0, 0, -0.2, -0.05 }, Waist = { 6, 14, 0 }, RS = { 100, 0, -2 }, RE = { 8, 0, 0 }, RW = { 10, 0, 0 }, LS = { 25, 0, -35 }, LE = { 70, 0, 0 } },
			fx = { { "beam", color = WATER, length = 5, width = 0.7, at = "hand" } }, text = "PSCHIT !", hitText = "SPLICH !",
		},
		-- Gros plouf (J J J) : il saute à pieds joints et retombe ventre en avant, bouée la première
		P_combo3 = {
			label = "Gros plouf", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 8, hitbox = box(5, 3.5, 2.5, -0.5), kbBase = 30, kbGrowth = 60, kbAngle = 45, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 10, 0, 0, 0, 0.35, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			strike = { Root = { -38, 0, 0, 0, -0.55, -0.6 }, Waist = { -10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 120, 0, 70 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -70 }, LE = { 10, 0, 0 } },
			follow = { Root = { -42, 0, 0, 0, -0.6, -0.65 }, Waist = { -12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 110, 0, 80 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 110, 0, -80 }, LE = { 10, 0, 0 } },
			fx = { { "puddle", color = WATER, width = 7 }, { "burst", color = FOAM, size = 3 } }, text = "PLOUF !", hitText = "SPLATCH !",
		},
		-- Bec de bouée tendu : il projette le bassin en avant, la tête du canard en plastique donne un coup de bec
		P_side = {
			label = "Bec de bouée tendu", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(4.5, 2.5, 3, -0.2), kbBase = 22, kbGrowth = 35, kbAngle = 22, selfVelocity = Vector2.new(24, 0),
			windup = { Root = { -10, -6, 0, 0, -0.3, 0.35 }, Waist = { -16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 50, 0, 25 }, RE = { 85, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -25 }, LE = { 85, 0, 0 } },
			strike = { Root = { 8, 4, 0, 0, -0.3, -0.6 }, Waist = { 22, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -40, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -30 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { 10, 6, 0, 0, -0.3, -0.7 }, Waist = { 26, 0, 0 }, Neck = { -22, 0, 0 }, RS = { -50, 0, 35 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { -50, 0, -35 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			trail = "body", text = "COIN !", hitText = "TCHAK !",
		},
		-- → J J : Coup de crosse mouillé, revers du pistolet à eau en pivotant
		P_side2 = {
			label = "Coup de crosse mouillé", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3, 3, 0.6), kbBase = 22, kbGrowth = 35, kbAngle = 28, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 0, 30, 0, 0, -0.25, 0 }, Waist = { 0, 34, 0 }, RS = { 80, 0, -50 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -6, -20, 0, 0, -0.3, -0.35 }, Waist = { -6, -28, 0 }, RS = { 95, 0, 40 }, RE = { 10, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
			follow = { Root = { -6, -28, 0, 0, -0.3, -0.4 }, Waist = { -6, -36, 0 }, RS = { 85, 0, 62 }, RE = { 15, 0, 0 }, RW = { 50, 0, 0 }, LS = { 45, 0, -30 }, LE = { 80, 0, 0 } },
			trail = "prop", hitText = "PLOC !",
		},
		-- Glissade palmée : il se jette à plat ventre et glisse sur sa bouée, bras devant, palmes derrière (fait décoller)
		P_down = {
			label = "Glissade palmée", startup = 0.1, active = 0.15, recovery = 0.22,
			damage = 6, hitbox = box(6, 2, 2.5, -1.8), kbBase = 26, kbGrowth = 25, kbAngle = 72, selfVelocity = Vector2.new(32, 0),
			windup = { Root = { -14, 0, 0, 0, -0.6, 0.15 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 140, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -78, 0, 0, 0, -1.45, -0.4 }, Waist = { 8, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 175, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -15 }, LE = { 0, 0, 0 }, RH = { -8, 0, 6 }, RK = { -25, 0, 0 }, RA = { -30, 0, 0 }, LH = { -8, 0, -6 }, LK = { -35, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -80, 0, 0, 0, -1.5, -0.5 }, Waist = { 10, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, RW = { -5, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -10, 0, 6 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -10, 0, -6 }, LK = { -20, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "body", fx = { { "puddle", color = WATER, width = 6 } }, hitText = "ZOUIIP !",
		},
		-- ↓ J J : Remontée de bouée, depuis le ventre il se redresse d'un coup de reins, bouée vers le ciel
		P_down2 = {
			label = "Remontée de bouée", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 7, hitbox = box(5, 5, 2.5, 2), kbBase = 28, kbGrowth = 40, kbAngle = 82,
			windup = { Root = { -40, 0, 0, 0, -1.1, 0 }, Waist = { -10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, 0.35, -0.1 }, Waist = { 20, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 35 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -35 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 16, 0, 0, 0, 0.45, -0.1 }, Waist = { 22, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 175, 0, 40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 175, 0, -40 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			hitText = "BOING !",
		},
		-- Bouée anti-air (ex-←J) : petit bond, il pousse la bouée vers le haut à deux mains comme un ballon
		P_up = {
			label = "Bouée anti-air", startup = 0.09, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5, 5, 1, 3.5), kbBase = 28, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -6, 0, 0, 0, -0.7, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.45, 0 }, Waist = { 16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 20 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -20 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 20, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 178, 0, 26 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 178, 0, -26 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			hitText = "POUÊT !",
		},
		-- Jet d'eau court en l'air : il vise devant lui et tire une giclée
		P_air = {
			label = "Jet d'eau court", kind = "projectile", startup = 0.08, active = 0, recovery = 0.18,
			damage = 6, kbBase = 18, kbGrowth = 25, kbAngle = 20,
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.25, size = 1.4, color = WATER },
			windup = { Root = { 6, -10, 0 }, Waist = { 6, -10, 0 }, RS = { 75, 0, 15 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -4, 8, 0 }, Waist = { -4, 10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 55, 0, 0 }, LK = { -95, 0, 0 } },
			follow = { Root = { 2, 8, 0 }, Waist = { 4, 10, 0 }, RS = { 100, 0, 0 }, RE = { 5, 0, 0 }, RW = { 12, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -75, 0, 0 }, LH = { 55, 0, 0 }, LK = { -95, 0, 0 } },
			text = "PSCHIT !", hitText = "SPLICH !",
		},
		-- Coup de canard en plastique (dash puis J) : il fonce et écrase son canard de bain sur le nez de l'adversaire
		P_dash = {
			label = "Couic de bain", startup = 0.08, active = 0.12, recovery = 0.22,
			damage = 8, hitbox = box(4, 3, 2.2, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -8, 20, 0, 0, -0.3, 0.1 }, Waist = { -4, 18, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 60, 0, -60 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, -14, 0, 0, -0.35, -0.35 }, Waist = { -8, -18, 0 }, RS = { -20, 0, 35 }, RE = { 30, 0, 0 }, LS = { 95, 0, 5 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -18, -18, 0, 0, -0.38, -0.4 }, Waist = { -10, -20, 0 }, RS = { -25, 0, 38 }, RE = { 30, 0, 0 }, LS = { 92, 0, 2 }, LE = { 10, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "canardJouet", fx = { "dust" }, text = "COUIC !", hitText = "COUIIIC !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Claque de palme : il pivote sur une palme et claque l'adversaire du plat de l'autre, à l'horizontale, comme une tapette à mouches
		K_neutral = {
			label = "Claque de palme", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3.5, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 4, 32, 0, 0, -0.15, 0.1 }, Waist = { 4, 22, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, -50 }, LE = { 50, 0, 0 }, RH = { 25, 0, 65 }, RK = { -95, 0, 0 }, RA = { 20, 0, 0 } },
			strike = { Root = { 10, -26, 0, 0, -0.1, -0.1 }, Waist = { 8, -22, 0 }, Neck = { -10, 10, 0 }, RS = { 20, 0, 70 }, RE = { 30, 0, 0 }, LS = { 70, 0, -70 }, LE = { 30, 0, 0 }, RH = { 95, 0, 12 }, RK = { -4, 0, 0 }, RA = { 35, 0, 0 } },
			follow = { Root = { 12, -34, 0, 0, -0.1, -0.12 }, Waist = { 10, -28, 0 }, Neck = { -12, 14, 0 }, RS = { 15, 0, 75 }, RE = { 30, 0, 0 }, LS = { 75, 0, -72 }, LE = { 30, 0, 0 }, RH = { 100, 0, 4 }, RK = { -6, 0, 0 }, RA = { 35, 0, 0 } },
			trail = "rightFoot", fx = { { "particles", tex = "smoke", color = WATER, at = "front", dir = "all", time = 0.15, speed = 8, size = 0.4 } }, hitText = "FLAP !",
		},
		-- K K : Palme fouettée, il pivote sur la jambe droite et fouette avec la palme gauche
		K_combo2 = {
			label = "Palme fouettée", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 3, 0.2), kbBase = 26, kbGrowth = 45, kbAngle = 32,
			windup = { Root = { 6, 40, 0, 0, -0.15, 0.1 }, Waist = { 4, 26, 0 }, RS = { 60, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -55 }, LE = { 40, 0, 0 }, LH = { 50, 0, -35 }, LK = { -100, 0, 0 } },
			strike = { Root = { 14, -45, 0, 0, -0.1, 0 }, Waist = { 10, -30, 0 }, RS = { 70, 0, 60 }, RE = { 30, 0, 0 }, LS = { 30, 0, -70 }, LE = { 30, 0, 0 }, LH = { 85, 0, -50 }, LK = { -5, 0, 0 }, LA = { 25, 0, 0 } },
			follow = { Root = { 16, -60, 0, 0, -0.1, 0 }, Waist = { 12, -36, 0 }, RS = { 72, 0, 62 }, RE = { 30, 0, 0 }, LS = { 25, 0, -72 }, LE = { 30, 0, 0 }, LH = { 80, 0, -35 }, LK = { -8, 0, 0 }, LA = { 25, 0, 0 } },
			trail = "leftFoot", hitText = "SPLAF !",
		},
		-- K K K : Double palmes, petit saut et les deux palmes partent ensemble droit devant
		K_combo3 = {
			label = "Double palmes", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 3.5, 3, 0.2), kbBase = 32, kbGrowth = 80, kbAngle = 38, selfVelocity = Vector2.new(18, 35),
			windup = { Root = { -12, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, RS = { -30, 0, 30 }, RE = { 40, 0, 0 }, LS = { -30, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 28, 0, 0, 0, 0.1, 0 }, Waist = { 18, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -40, 0, 55 }, RE = { 20, 0, 0 }, LS = { -40, 0, -55 }, LE = { 20, 0, 0 }, RH = { 85, 0, 6 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 85, 0, -6 }, LK = { 0, 0, 0 }, LA = { 30, 0, 0 } },
			follow = { Root = { 32, 0, 0, 0, 0.1, 0 }, Waist = { 20, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -48, 0, 60 }, RE = { 20, 0, 0 }, LS = { -48, 0, -60 }, LE = { 20, 0, 0 }, RH = { 92, 0, 6 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 92, 0, -6 }, LK = { 0, 0, 0 }, LA = { 30, 0, 0 } },
			trail = "bothFeet", text = "À L'ABORDAGE !", hitText = "SPLAAATCH !",
		},
		-- Bec de bouée plongeant (→K) : élan, puis il plonge à l'horizontale, bouée devant comme une étrave
		K_side = {
			label = "Bec de bouée plongeant", startup = 0.22, active = 0.14, recovery = 0.35,
			damage = 13, hitbox = box(5, 3, 3, 0), kbBase = 32, kbGrowth = 82, kbAngle = 30, selfVelocity = Vector2.new(40, 12),
			windup = { Root = { 10, 0, 0, 0, -0.55, 0.35 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -50, 0, 30 }, RE = { 30, 0, 0 }, LS = { -50, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { -70, 0, 0, 0, -0.4, -0.6 }, Waist = { 10, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 170, 0, 20 }, RE = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 0, 0, 0 }, RH = { -10, 0, 5 }, RK = { -10, 0, 0 }, RA = { -30, 0, 0 }, LH = { -10, 0, -5 }, LK = { -20, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -74, 0, 0, 0, -0.45, -0.7 }, Waist = { 12, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 175, 0, 25 }, RE = { 0, 0, 0 }, LS = { 175, 0, -25 }, LE = { 0, 0, 0 }, RH = { -12, 0, 5 }, RK = { -25, 0, 0 }, RA = { -30, 0, 0 }, LH = { -12, 0, -5 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "body", text = "COIN-COIN !", hitText = "TCHONK !",
		},
		-- → K K : Hélice de palmes, accroupi il tourne sur lui-même, jambe tendue au ras de l'eau
		K_side2 = {
			label = "Hélice de palmes", startup = 0.1, active = 0.16, recovery = 0.3,
			damage = 11, hitbox = box(7, 3.5, 1.5, -1.2), kbBase = 30, kbGrowth = 70, kbAngle = 70,
			windup = { Root = { -6, -30, 0, 0, -0.95, 0 }, Waist = { -16, -10, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -1.2, 0 }, Waist = { -18, 0, 0 }, RS = { 20, 0, 70 }, RE = { 15, 0, 0 }, LS = { 20, 0, -70 }, LE = { 15, 0, 0 }, RH = { 78, 0, 18 }, RK = { -4, 0, 0 }, RA = { 25, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -1.2, 0 }, Waist = { -16, 0, 0 }, RS = { 25, 0, 72 }, RE = { 15, 0, 0 }, LS = { 25, 0, -72 }, LE = { 15, 0, 0 }, RH = { 74, 0, 20 }, RK = { -6, 0, 0 }, RA = { 25, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "FLIP-FLAP !",
		},
		-- Glissade palmée (↓K) : sur le dos, il glisse les deux palmes devant comme un toboggan
		K_down = {
			label = "Glissade palmée", startup = 0.18, active = 0.24, recovery = 0.35,
			damage = 12, hitbox = box(7, 2, 3, -2), kbBase = 30, kbGrowth = 62, kbAngle = 60, selfVelocity = Vector2.new(44, 0),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0 }, Waist = { -18, 0, 0 }, RS = { 50, 0, 40 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 48, 0, 0, 0, -1.6, 0 }, Waist = { -22, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { 20, 0, -70 }, LE = { 10, 0, 0 }, RH = { 80, 0, 5 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 80, 0, -5 }, LK = { 0, 0, 0 }, LA = { 30, 0, 0 } },
			follow = { Root = { 52, 0, 0, 0, -1.65, 0 }, Waist = { -26, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 15, 0, 78 }, RE = { 10, 0, 0 }, LS = { 15, 0, -78 }, LE = { 10, 0, 0 }, RH = { 86, 0, 5 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 86, 0, -5 }, LK = { 0, 0, 0 }, LA = { 30, 0, 0 } },
			trail = "bothFeet", fx = { { "puddle", color = WATER, width = 8 } }, hitText = "ZIOUUUP !",
		},
		-- ↓ K K : Rebond de bouée, sorti de la glissade il roule en boule sur la bouée et rebondit pieds devant
		K_downK = {
			label = "Rebond de bouée", startup = 0.1, active = 0.2, recovery = 0.3,
			damage = 9, hitbox = box(5, 3.5, 2.5, -1), kbBase = 30, kbGrowth = 50, kbAngle = 75, selfVelocity = Vector2.new(20, 30),
			windup = { Root = { -20, 0, 0, 0, -1.0, 0.1 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 20 }, RE = { 100, 0, 0 }, LS = { 70, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.3, -0.3 }, Waist = { 10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { 95, 0, 6 }, RK = { -10, 0, 0 }, RA = { 25, 0, 0 }, LH = { 95, 0, -6 }, LK = { -10, 0, 0 }, LA = { 25, 0, 0 } },
			follow = { Root = { 34, 0, 0, 0, -0.25, -0.35 }, Waist = { 12, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -35, 0, 55 }, RE = { 20, 0, 0 }, LS = { -35, 0, -55 }, LE = { 20, 0, 0 }, RH = { 100, 0, 6 }, RK = { -5, 0, 0 }, RA = { 25, 0, 0 }, LH = { 100, 0, -6 }, LK = { -5, 0, 0 }, LA = { 25, 0, 0 } },
			spin = { axis = "x", degrees = 360 }, trail = "bothFeet", hitText = "BOING BOING !",
		},
		-- Dégonflage (ex-←K, recul) : il presse la valve de sa bouée, le jet d'air file vers le haut et le fait reculer
		K_up = {
			label = "Dégonflage", startup = 0.18, active = 0.14, recovery = 0.3,
			damage = 11, hitbox = box(5, 5.5, 0.5, 3.5), kbBase = 32, kbGrowth = 72, kbAngle = 88, selfVelocity = Vector2.new(-18, 0),
			windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -20, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, -20 }, RE = { 110, 0, 0 }, LS = { 30, 0, 20 }, LE = { 110, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.1, 0.4 }, Waist = { 20, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 75 }, RE = { 10, 0, 0 }, LS = { 60, 0, -75 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.4 }, FL = { 0, 0, 0, 0, 0, 0.3 } },
			follow = { Root = { 16, 0, 0, 0, -0.1, 0.5 }, Waist = { 24, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 70, 0, 82 }, RE = { 10, 0, 0 }, LS = { 70, 0, -82 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.5 }, FL = { 0, 0, 0, 0, 0, 0.4 } },
			shake = true, fx = { { "pillar", color = FOAM, height = 9, width = 1.6 }, { "particles", tex = "smoke", color = FOAM, dir = "up", at = "root", time = 0.3, speed = 14 } },
			text = "PSCHHHH !", hitText = "FIOUUU !",
		},
		-- ↑ K K : Ciseau de palmes, il bascule en arrière et croise les palmes au-dessus de sa tête
		K_upK = {
			label = "Ciseau de palmes", startup = 0.1, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(4.5, 5, 2.5, 3), kbBase = 30, kbGrowth = 55, kbAngle = 85,
			windup = { Root = { 10, 0, 0, 0, 0.2, 0 }, Waist = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, LH = { 120, 0, 0 }, LK = { -30, 0, 0 }, RH = { -10, 0, 0 }, RK = { -40, 0, 0 } },
			strike = { Root = { 28, 0, 0, 0, 0.5, 0 }, Waist = { 12, 0, 0 }, Neck = { 15, 0, 0 }, RS = { -35, 0, 65 }, RE = { 20, 0, 0 }, LS = { -35, 0, -65 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { -20, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { 32, 0, 0, 0, 0.55, 0 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { -40, 0, 70 }, RE = { 20, 0, 0 }, LS = { -40, 0, -70 }, LE = { 20, 0, 0 }, RH = { 160, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { -25, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "rightFoot", hitText = "CLAP-CLAP !",
		},
		-- Ruade palmée en l'air : genoux à la poitrine, puis les deux palmes claquent devant
		K_air = {
			label = "Ruade palmée", startup = 0.17, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, -0.3), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -12, 0, 0 }, Waist = { -22, 0, 0 }, RS = { 70, 0, 45 }, RE = { 50, 0, 0 }, LS = { 70, 0, -45 }, LE = { 50, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 24, 0, 0 }, Waist = { 20, 0, 0 }, RS = { -30, 0, 55 }, RE = { 20, 0, 0 }, LS = { -30, 0, -55 }, LE = { 20, 0, 0 }, RH = { 88, 0, 5 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 80, 0, -5 }, LK = { -5, 0, 0 }, LA = { 30, 0, 0 } },
			follow = { Root = { 28, 0, 0 }, Waist = { 22, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 94, 0, 5 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 86, 0, -5 }, LK = { -4, 0, 0 }, LA = { 30, 0, 0 } },
			trail = "bothFeet", hitText = "SPLAF !",
		},
		-- Coup de palme glissé (dash puis K) : il glisse sur une jambe, l'autre palme tendue au ras du sol
		K_dash = {
			label = "Coup de palme glissé", startup = 0.1, active = 0.24, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.2, 3, -1.6), kbBase = 30, kbGrowth = 65, kbAngle = 50, selfVelocity = Vector2.new(52, 0),
			windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -12, 0, 0 }, RS = { 50, 0, 40 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { 25, 0, 0, 0, -1.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -20, 0, 50 }, RE = { 10, 0, 0 }, LS = { 80, 0, -40 }, LE = { 20, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 28, 0, 0, 0, -1.35, 0 }, Waist = { -12, 0, 0 }, Neck = { -18, 0, 0 }, RS = { -25, 0, 55 }, RE = { 10, 0, 0 }, LS = { 85, 0, -45 }, LE = { 20, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -115, 0, 0 } },
			trail = "rightFoot", fx = { { "puddle", color = WATER, width = 6 } }, hitText = "SCHLAF !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (J / K)
		-- → J en l'air : Battement de palmes, allongé sur le dos il pédale des palmes vers l'avant (3 touches)
		P_air_side = {
			label = "Battement de palmes", startup = 0.09, active = 0.24, recovery = 0.18,
			damage = 3, hits = 3, hitbox = box(5, 3, 2.8, -0.3), kbBase = 20, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 20, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 45, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 10, 0, 75 }, RE = { 20, 0, 0 }, LS = { 10, 0, -75 }, LE = { 20, 0, 0 }, RH = { 95, 0, 0 }, RK = { -5, 0, 0 }, RA = { 30, 0, 0 }, LH = { 55, 0, 0 }, LK = { -40, 0, 0 }, LA = { 30, 0, 0 } },
			follow = { Root = { 45, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 10, 0, 75 }, RE = { 20, 0, 0 }, LS = { 10, 0, -75 }, LE = { 20, 0, 0 }, RH = { 55, 0, 0 }, RK = { -40, 0, 0 }, RA = { 30, 0, 0 }, LH = { 95, 0, 0 }, LK = { -5, 0, 0 }, LA = { 30, 0, 0 } },
			wobble = true, trail = "bothFeet", fx = { { "particles", tex = "smoke", color = WATER, at = "feet", dir = "front", time = 0.25, speed = 10 } }, hitText = "FLAP FLAP FLAP !",
		},
		-- ↑ J en l'air : Tête de canard au plafond, salto avant, la bouée cogne au-dessus de lui
		P_air_up = {
			label = "Bouée au plafond", startup = 0.09, active = 0.14, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -16, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, RH = { 95, 0, 0 }, RK = { -125, 0, 0 }, LH = { 95, 0, 0 }, LK = { -125, 0, 0 } },
			strike = { Root = { 20, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 10, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 24, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 35 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 180, 0, -35 }, LE = { 10, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 5, 0, 0 }, LK = { -45, 0, 0 } },
			spin = { axis = "x", degrees = 360 }, trail = "body", hitText = "POUÊT !",
		},
		-- ↓ J en l'air : Plongeon bec en piqué, tête et bouée en avant vers le sol (smash vers le bas)
		P_air_down = {
			label = "Plongeon bec en piqué", startup = 0.14, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -75, selfVelocity = Vector2.new(6, -45),
			windup = { Root = { 20, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 180, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -20 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -110, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -10 }, LE = { 0, 0, 0 }, RH = { 0, 0, 5 }, RK = { -5, 0, 0 }, RA = { -30, 0, 0 }, LH = { 0, 0, -5 }, LK = { -5, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -115, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 8 }, RE = { 0, 0, 0 }, RW = { -5, 0, 0 }, LS = { 178, 0, -8 }, LE = { 0, 0, 0 }, RH = { -5, 0, 5 }, RK = { -10, 0, 0 }, RA = { -30, 0, 0 }, LH = { -5, 0, -5 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "body", text = "PIQUÉ !", hitText = "PLONK !",
		},
		-- → K en l'air : Palme volante, buste en arrière, jambe droite détendue à l'horizontale
		K_air_side = {
			label = "Palme volante", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -14, 20, 0 }, Waist = { -14, 10, 0 }, RS = { 50, 0, 45 }, RE = { 70, 0, 0 }, LS = { 70, 0, -35 }, LE = { 70, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 28, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 68, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 32, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, 0, 0 }, RS = { -38, 0, 65 }, RE = { 20, 0, 0 }, LS = { 45, 0, -75 }, LE = { 30, 0, 0 }, RH = { 72, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SCHPLAF !",
		},
		-- ↑ K en l'air : Hélice de bouée, il tournoie à la verticale, palmes au ciel
		K_air_up = {
			label = "Hélice de bouée", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 30, 0, 0 }, LH = { 140, 0, 0 }, LK = { -10, 0, 0 }, LA = { 30, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 120, 0, 0 }, RK = { -40, 0, 0 }, LH = { 155, 0, 0 }, LK = { -5, 0, 0 }, LA = { 30, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "FLOUP !",
		},
		-- ↓ K en l'air : Plat de palmes, il tombe pieds joints, palmes à plat comme deux tapettes à mouches
		K_air_down = {
			label = "Plat de palmes", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 165, 0, 45 }, RE = { 10, 0, 0 }, LS = { 165, 0, -45 }, LE = { 10, 0, 0 }, RH = { -4, 0, 5 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -4, 0, -5 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 172, 0, 52 }, RE = { 10, 0, 0 }, LS = { 172, 0, -52 }, LE = { 10, 0, 0 }, RH = { -4, 0, 7 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { -4, 0, -7 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", fx = { { "puddle", color = WATER, width = 6 } }, text = "SPLASH !", hitText = "FLATCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Coin-coin de brume : corne de brume collée à la bouche, il souffle de toutes ses forces ; l'onde sonore balaie tout le couloir et étourdit
		S_neutral = {
			label = "Coin-coin de brume", startup = 0.2, active = 0.18, recovery = 0.45,
			damage = 13, hitbox = box(14, 7, 7, 1), kbBase = 26, kbGrowth = 36, kbAngle = 45,
			status = { name = "stunned", duration = 0.6 },
			windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 120, 0, 20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.2, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 70 }, RE = { 15, 0, 0 }, LS = { 150, 0, 10 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -14, 0, 0, 0, -0.2, -0.35 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 65, 0, 78 }, RE = { 15, 0, 0 }, LS = { 155, 0, 8 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.15, prop = "corne", shake = true,
			fx = { { "ring", color = FOAM, radius = 6, at = "front" }, { "ring", color = DUCK, radius = 10, at = "front", time = 0.5 }, { "beam", color = DUCK, length = 14, width = 3, at = "head" }, { "symbols", symbols = { "COIN", "♪" }, color = DUCK, count = 6, radius = 5, at = "front" } },
			text = "COIN-COIIIN !", hitText = "BZZZ !",
		},
		-- Torpille canard : à l'horizontale, il tire au pistolet vers l'arrière et traverse tout le couloir en tourbillonnant, bec de bouée en avant
		S_side = {
			label = "Torpille canard", startup = 0.18, active = 0.34, recovery = 0.45,
			damage = 15, hitbox = box(14, 5, 7, 0.5), kbBase = 30, kbGrowth = 70, kbAngle = 30, selfVelocity = Vector2.new(72, 8),
			windup = { Root = { -20, 0, 0, 0, -0.5, 0.2 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -60, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -80, 0, 0, 0, -0.3, -0.4 }, Waist = { 0, 0, 0 }, Neck = { 40, 0, 0 }, RS = { -10, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -10 }, LE = { 0, 0, 0 }, RH = { -5, 0, 5 }, RK = { -5, 0, 0 }, RA = { -30, 0, 0 }, LH = { -5, 0, -5 }, LK = { -5, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -82, 0, 0, 0, -0.3, -0.45 }, Waist = { 0, 0, 0 }, Neck = { 42, 0, 0 }, RS = { -12, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -8 }, LE = { 0, 0, 0 }, RH = { -8, 0, 5 }, RK = { -8, 0, 0 }, RA = { -30, 0, 0 }, LH = { -8, 0, -5 }, LK = { -8, 0, 0 }, LA = { -30, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "body",
			fx = { { "particles", tex = "smoke", color = WATER, at = "hand", dir = "all", time = 0.35, speed = 12, rate = 90 }, { "puddle", color = WATER, width = 12, time = 0.8 } },
			text = "TORPILLE !", hitText = "SPLONK !",
		},
		-- Piscine gonflable : il la jette devant lui, elle se déplie sur tout le couloir et se remplit d'un coup ; qui est dedans est trempé (ralenti) et la piscine se dégonfle
		S_down = {
			label = "Piscine gonflable", kind = "trap", startup = 0.22, active = 0.12, recovery = 0.45,
			damage = 12, kbBase = 14, kbGrowth = 14, kbAngle = 60,
			status = { name = "wet", duration = 2.5 },
			trap = { size = Vector3.new(16, 1.5, 6), offset = 8, lifetime = 8, max = 1, persist = false, color = WATER,
				visual = { shape = "ball", size = 0.2, color = WATER, trail = false, parts = {
					{ "block", Vector3.new(15, 0.3, 3), Vector3.new(0, -0.2, 0), WATER, "Glass" },
					{ "cyl", Vector3.new(15.5, 0.9, 0.9), Vector3.new(0, 0, 1.8), Color3.fromRGB(60, 140, 230) },
					{ "cyl", Vector3.new(15.5, 0.9, 0.9), Vector3.new(0, 0, -1.8), Color3.fromRGB(60, 140, 230) },
					{ "ball", Vector3.new(0.9, 0.9, 4.4), Vector3.new(7.8, 0, 0), DUCK },
					{ "ball", Vector3.new(0.9, 0.9, 4.4), Vector3.new(-7.8, 0, 0), DUCK },
					{ "ball", Vector3.new(0.9, 0.7, 1.0), Vector3.new(-4, 0.2, 0), DUCK },
					{ "ball", Vector3.new(0.9, 0.7, 1.0), Vector3.new(4, 0.2, 0.5), DUCK },
				} } },
			windup = { Root = { 6, -20, 0, 0, -0.3, 0.2 }, Waist = { 10, -20, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 120, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -14, 14, 0, 0, -0.55, -0.25 }, Waist = { -24, 16, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 20, 0, 0 }, LS = { 92, 0, -20 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, 16, 0, 0, -0.6, -0.3 }, Waist = { -26, 18, 0 }, Neck = { 12, 0, 0 }, RS = { 55, 0, 35 }, RE = { 20, 0, 0 }, LS = { 96, 0, -24 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "leftHand", fx = { { "puddle", color = WATER, width = 16, time = 1.5 }, { "toss", shape = "ball", color = WATER, size = 0.5, count = 6, speed = 22, lift = 10 } }, text = "PISCINE !", hitText = "TREMPÉ !",
		},
		-- Décollage en bouée (remontée) : la bouée canard se gonfle d'un coup et il décolle en diagonale comme une torpille, pistolet pointé devant, palmes qui battent derrière
		S_up = {
			label = "Décollage en bouée", startup = 0.15, active = 0.32, recovery = 0.45,
			damage = 17, hitbox = box(10, 11, 3, 4), kbBase = 34, kbGrowth = 60, kbAngle = 80, selfVelocity = Vector2.new(46, 88),
			windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 50 }, RE = { 20, 0, 0 }, LS = { 20, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -44, 0, 0, 0, 0.3, -0.1 }, Waist = { -4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 168, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -30 }, LE = { 20, 0, 0 }, RH = { -26, 0, 5 }, RK = { -34, 0, 0 }, RA = { -30, 0, 0 }, LH = { -32, 0, -5 }, LK = { -44, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -48, 0, 0, 0, 0.35, -0.15 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 174, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -44, 0, -34 }, LE = { 20, 0, 0 }, RH = { -30, 0, 5 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -5 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
			wobble = true, trail = "body", shake = true,
			fx = { { "pillar", color = WATER, height = 14, width = 3.5, at = "root", time = 0.45 }, { "burst", color = FOAM, size = 4.5, at = "feet" }, { "ring", color = WATER, radius = 7, at = "feet" }, { "ring", color = DUCK, radius = 4, at = "feet" },
				{ "particles", tex = "smoke", color = FOAM, at = "feet", dir = "down", time = 0.4, speed = 20, rate = 120, size = 0.9 }, { "symbols", symbols = { "COIN", "🦆", "💦" }, color = DUCK, count = 5, radius = 4, at = "above" }, { "shake", amount = 0.4 } },
			text = "DÉCOLLAGE !", hitText = "SPLOOSH !",
		},
		-- Gonflage (L maintenu) : il gonfle sa bouée à bloc et la cogne en avant d'un grand coup de bassin qui balaie le couloir ; le prochain coup reçu rebondit dessus et repart à l'envoyeur
		S_hold = {
			label = "Gonflage", kind = "counter", startup = 0.16, active = 0.6, recovery = 0.42,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 26, kbGrowth = 40, kbAngle = 35,
			counter = { window = 0.6, text = "BOING !", riposte = { damage = 14, kbBase = 42, kbGrowth = 70, kbAngle = 40, hitText = "REBOND !" } },
			windup = { Root = { -8, 0, 0, 0, -0.3, 0.25 }, Waist = { -22, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 70, 0, -20 }, RE = { 120, 0, 0 }, LS = { 70, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.15, -0.4 }, Waist = { 28, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -40, 0, 50 }, RE = { 20, 0, 0 }, LS = { -40, 0, -50 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 12, 0, 0, 0, -0.15, -0.35 }, Waist = { 24, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, 88 }, RE = { 30, 0, 0 }, LS = { 40, 0, -88 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			hold = 0.3, shake = true, trail = "body", fx = { { "ring", color = DUCK, radius = 6, at = "front" }, { "burst", color = DUCK, size = 3.5, at = "front" }, { "text", text = "GONFLÉ À BLOC !", color = DUCK } },
			text = "PFFFFF… !", hitText = "BOING !",
		},
		-- Toboggan aquatique (→→L) : il plonge à plat ventre sur un tapis d'eau et glisse d'un bout à l'autre du couloir, bras tendus devant
		S_dash = {
			label = "Toboggan aquatique", startup = 0.15, active = 0.34, recovery = 0.45,
			damage = 14, hitbox = box(14, 5, 7, 0.5), kbBase = 30, kbGrowth = 60, kbAngle = 40, selfVelocity = Vector2.new(74, 0), invuln = 0.15,
			windup = { Root = { -20, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, RS = { 150, 0, 20 }, LS = { 150, 0, -20 } },
			strike = { Root = { -80, 0, 0, 0, -1.5, -0.4 }, Waist = { 8, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 178, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -10 }, LE = { 0, 0, 0 }, RH = { -6, 0, 5 }, RK = { -10, 0, 0 }, RA = { -30, 0, 0 }, LH = { -6, 0, -5 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -82, 0, 0, 0, -1.5, -0.45 }, Waist = { 10, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 178, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -14 }, LE = { 0, 0, 0 }, RH = { -8, 0, 5 }, RK = { -25, 0, 0 }, RA = { -30, 0, 0 }, LH = { -8, 0, -5 }, LK = { -15, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "body", fx = { { "puddle", color = WATER, width = 16, time = 1 }, { "particles", tex = "smoke", color = FOAM, at = "feet", dir = "up", time = 0.35, speed = 8 } },
			text = "WIIIIIZ !", hitText = "SPLAAASH !",
		},
		-- Jet d'eau (esquive puis L) : pistolet à deux mains, un long jet à haute pression qui fonce droit sur l'adversaire et le trempe
		S_dodge = {
			label = "Jet d'eau", kind = "projectile", startup = 0.16, active = 0, recovery = 0.42,
			damage = 13, kbBase = 24, kbGrowth = 42, kbAngle = 15,
			projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.55, size = 1.8, color = WATER,
				visual = { shape = "ball", size = 1.6, color = WATER, neon = true, transparency = 0.2 } },
			status = { name = "wet", duration = 2 },
			windup = { Root = { 0, -10, 0, 0, -0.25, 0.15 }, Waist = { 0, -12, 0 }, RS = { 80, 0, 5 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 25 }, LE = { 55, 0, 0 } },
			strike = { Root = { 6, 8, 0, 0, -0.28, 0.2 }, Waist = { 8, 10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 22 }, LE = { 20, 0, 0 } },
			follow = { Root = { 10, 8, 0, 0, -0.28, 0.3 }, Waist = { 12, 10, 0 }, RS = { 100, 0, 0 }, RE = { 5, 0, 0 }, RW = { 10, 0, 0 }, LS = { 94, 0, 22 }, LE = { 25, 0, 0 } },
			shake = true, fx = { { "beam", color = WATER, length = 10, width = 1.2, at = "hand", time = 0.2 }, { "particles", tex = "smoke", color = FOAM, at = "hand", dir = "front", time = 0.2, speed = 14 } }, text = "PSCHHHH !", hitText = "SPLASH !",
		},
		-- Ballon d'eau (L en l'air) : il lance un gros ballon gonflé d'eau qui fonce éclater sur l'adversaire
		S_air = {
			label = "Ballon d'eau", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
			damage = 13, kbBase = 26, kbGrowth = 48, kbAngle = 40,
			projectile = { speed = 60, angle = -15, gravity = 30, lifetime = 0.8, size = 2.2, color = WATER,
				visual = { shape = "ball", size = 2, color = WATER, transparency = 0.2, parts = { { "ball", Vector3.new(0.4, 0.4, 0.4), Vector3.new(0, 1.1, 0), Color3.fromRGB(230, 60, 60) } } } },
			status = { name = "wet", duration = 2 },
			windup = { Root = { 10, -20, 0 }, Waist = { 12, -24, 0 }, RS = { 60, 0, 20 }, RE = { 60, 0, 0 }, LS = { 185, 0, 10 }, LE = { 70, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { -14, 18, 0 }, Waist = { -20, 22, 0 }, RS = { 40, 0, 40 }, RE = { 30, 0, 0 }, LS = { 80, 0, -10 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -18, 22, 0 }, Waist = { -24, 26, 0 }, RS = { 35, 0, 45 }, RE = { 30, 0, 0 }, LS = { 50, 0, -15 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 65, 0, 0 }, LK = { -100, 0, 0 } },
			trail = "leftHand", fx = { { "burst", color = WATER, size = 2, at = "lhand" } }, text = "BALLON D'EAU !", hitText = "SPLOUTCH !",
		},
		-- Bombe à eau (↓L en l'air, plongeon) : genoux repliés contre la bouée, il tombe en boule ; grande gerbe qui éclabousse tout en dessous
		S_air_down = {
			label = "Bombe à eau !", startup = 0.16, active = 0.4, recovery = 0.45,
			damage = 14, hitbox = box(9, 5, 0, -2), kbBase = 28, kbGrowth = 60, kbAngle = 45, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, LS = { 170, 0, -30 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { -25, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 75, 0, -20 }, RE = { 110, 0, 0 }, LS = { 75, 0, 20 }, LE = { 110, 0, 0 }, RH = { 120, 0, 0 }, RK = { -140, 0, 0 }, RA = { 20, 0, 0 }, LH = { 120, 0, 0 }, LK = { -140, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 72, 0, -22 }, RE = { 115, 0, 0 }, LS = { 72, 0, 22 }, LE = { 115, 0, 0 }, RH = { 122, 0, 0 }, RK = { -142, 0, 0 }, RA = { 20, 0, 0 }, LH = { 122, 0, 0 }, LK = { -142, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "body", fx = { { "puddle", color = WATER, width = 12, time = 1.2 }, { "ring", color = FOAM, radius = 7, at = "feet" }, { "toss", shape = "ball", color = WATER, count = 6, size = 0.6, speed = 18 }, { "shake", amount = 0.4 } },
			text = "BOMBE !", hitText = "SPLAAAATCH !",
		},

		------------------------------------------------------------------ Suites d'enchaînement
		-- J puis K : Coup de genou-bouée, il remonte le genou contre la bouée qui rebondit sur l'adversaire
		PK_combo = {
			label = "Genou-bouée", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 3.5, 2.5, 0), kbBase = 24, kbGrowth = 35, kbAngle = 50,
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 6, -10, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 70, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -10, 8, 0, 0, 0.05, -0.35 }, Waist = { -8, 6, 0 }, RS = { -10, 0, 50 }, RE = { 40, 0, 0 }, LS = { -10, 0, -50 }, LE = { 40, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -12, 10, 0, 0, 0.08, -0.4 }, Waist = { -10, 8, 0 }, RS = { -15, 0, 52 }, RE = { 40, 0, 0 }, LS = { -15, 0, -52 }, LE = { 40, 0, 0 }, RH = { 116, 0, 0 }, RK = { -124, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightLeg", hitText = "BOUMF !",
		},
		-- K puis J : Coup de crosse plongeant, il abat la crosse du pistolet de haut en bas
		KP_combo = {
			label = "Crosse plongeante", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 7, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 55,
			windup = { Root = { 8, -8, 0, 0, -0.05, 0.2 }, Waist = { 12, -8, 0 }, RS = { 185, 0, 10 }, RE = { 60, 0, 0 }, RW = { 70, 0, 0 }, LS = { 60, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, -0.35, -0.3 }, Waist = { -26, 10, 0 }, RS = { 80, 0, 5 }, RE = { 0, 0, 0 }, RW = { 70, 0, 0 }, LS = { -10, 0, -30 }, LE = { 50, 0, 0 } },
			follow = { Root = { -14, 10, 0, 0, -0.4, -0.35 }, Waist = { -30, 12, 0 }, RS = { 55, 0, 5 }, RE = { 5, 0, 0 }, RW = { 60, 0, 0 }, LS = { -15, 0, -32 }, LE = { 50, 0, 0 } },
			trail = "prop", hitText = "TONK !",
		},
		-- J J J J : Bec tournoyant, il se relève d'un bond et tourne sur lui-même, le bec de la bouée fauche tout, bras en ballerine
		P_combo4 = {
			label = "Bec tournoyant", startup = 0.1, active = 0.16, recovery = 0.32,
			damage = 12, hitbox = box(6, 4, 2.5, 0), kbBase = 34, kbGrowth = 80, kbAngle = 40,
			windup = { Root = { -20, 0, 0, 0, -0.7, 0 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, -0.1, -0.1 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 4, 0, 0, 0, -0.1, -0.1 }, Waist = { 8, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 175, 0, 25 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -25 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", fx = { { "ring", color = DUCK, radius = 5, at = "root" }, { "particles", tex = "smoke", color = WATER, at = "root", dir = "all", time = 0.2, speed = 12, size = 0.5 }, { "symbols", symbols = { "COIN", "🦆" }, color = DUCK, count = 4, radius = 3 } },
			text = "COIN-COIN-COIN !", hitText = "TCHAK-TCHAK !",
		},
		-- → J J J : Corne de brume au nez, il colle la corne sur le nez de l'adversaire et souffle de toutes ses forces
		P_side3 = {
			label = "Corne de brume au nez", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 34, kbGrowth = 76, kbAngle = 38,
			status = { name = "stunned", duration = 0.4 },
			windup = { Root = { 4, 20, 0, 0, -0.2, 0.2 }, Waist = { 6, 18, 0 }, Neck = { -10, -10, 0 }, LS = { 60, 0, -40 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 } },
			strike = { Root = { -14, -14, 0, 0, -0.3, -0.4 }, Waist = { -16, -16, 0 }, Neck = { 20, 10, 0 }, LS = { 94, 0, 4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 20, 0, 50 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, -16, 0, 0, -0.32, -0.45 }, Waist = { -18, -18, 0 }, Neck = { 24, 12, 0 }, LS = { 96, 0, 2 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RS = { 18, 0, 52 }, RE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "corne", trail = "leftHand", shake = true, fx = { { "ring", color = DUCK, radius = 5, at = "front" }, { "ring", color = FOAM, radius = 3, at = "front" }, { "symbols", symbols = { "COIN", "♪", "💢" }, color = DUCK, count = 5, radius = 3, at = "front" } },
			text = "COIN-COIIIN !", hitText = "BZZZ-BOUM !",
		},
		-- → K K K : Plongeon du capitaine, il s'élance tête la première, bouée devant, comme dans une piscine… sans eau
		K_side3 = {
			label = "Plongeon du capitaine", startup = 0.1, active = 0.16, recovery = 0.34,
			damage = 13, hitbox = box(6, 3.5, 3, -0.5), kbBase = 36, kbGrowth = 84, kbAngle = 35, selfVelocity = Vector2.new(34, 10),
			windup = { Root = { 8, 0, 0, 0, -0.5, 0.3 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -50, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -50, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { -72, 0, 0, 0, -0.5, -0.6 }, Waist = { 8, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -8, 0, 5 }, RK = { -10, 0, 0 }, RA = { -30, 0, 0 }, LH = { -8, 0, -5 }, LK = { -20, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -76, 0, 0, 0, -0.55, -0.7 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 180, 0, 16 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -16 }, LE = { 0, 0, 0 }, RH = { -10, 0, 5 }, RK = { -25, 0, 0 }, RA = { -30, 0, 0 }, LH = { -10, 0, -5 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "body", fx = { { "puddle", color = WATER, width = 8 }, { "burst", color = FOAM, size = 3.5, at = "front" }, { "toss", shape = "ball", color = WATER, count = 5, size = 0.5, speed = 16 } },
			text = "À L'EAU !", hitText = "SPLAAASH !",
		},
		-- J K K : Pédalo, il bascule sur le dos et pédale des palmes à toute vitesse dans le ventre de l'adversaire
		PKK_combo = {
			label = "Pédalo", startup = 0.08, active = 0.24, recovery = 0.3, hits = 3,
			damage = 4, hitbox = box(5, 4, 2.8, -0.3), kbBase = 30, kbGrowth = 68, kbAngle = 55,
			windup = { Root = { 10, 0, 0, 0, -0.4, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 } },
			strike = { Root = { 55, 0, 0, 0, -1.2, 0 }, Waist = { -20, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { 20, 0, -70 }, LE = { 10, 0, 0 }, RH = { 100, 0, 5 }, RK = { -10, 0, 0 }, RA = { 30, 0, 0 }, LH = { 60, 0, -5 }, LK = { -90, 0, 0 }, LA = { 30, 0, 0 } },
			follow = { Root = { 55, 0, 0, 0, -1.2, 0 }, Waist = { -20, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { 20, 0, -70 }, LE = { 10, 0, 0 }, RH = { 60, 0, 5 }, RK = { -90, 0, 0 }, RA = { 30, 0, 0 }, LH = { 100, 0, -5 }, LK = { -10, 0, 0 }, LA = { 30, 0, 0 } },
			wobble = true, trail = "bothFeet", fx = { { "particles", tex = "smoke", color = WATER, at = "feet", dir = "front", time = 0.25, speed = 12, rate = 80, size = 0.5 }, { "puddle", color = WATER, width = 5 } },
			text = "PÉDALO !", hitText = "FLAP FLAP FLAP !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Gerbe d'eau : pistolet secoué puis arrosage en balayant tout le couloir devant lui
		S_finish_jet = {
			label = "Gerbe d'eau", startup = 0.15, active = 0.2, recovery = 0.4,
			damage = 12, hitbox = box(14, 5, 7, 1), kbBase = 30, kbGrowth = 50, kbAngle = 30,
			status = { name = "wet", duration = 2 },
			windup = { Root = { 0, -12, 0, 0, -0.2, 0.1 }, Waist = { 0, -18, 0 }, RS = { 75, 0, 5 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.25, -0.15 }, Waist = { -8, -10, 0 }, RS = { 92, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 25 }, LE = { 25, 0, 0 } },
			follow = { Root = { -6, 18, 0, 0, -0.25, -0.2 }, Waist = { -8, 24, 0 }, RS = { 95, 0, -25 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 0 }, LE = { 30, 0, 0 } },
			shake = true, fx = { { "beam", color = WATER, length = 14, width = 1.4, at = "hand" }, { "particles", tex = "smoke", color = FOAM, at = "front", dir = "all", time = 0.2, speed = 10 } },
			text = "SPLOOOSH !", hitText = "SPLASH !",
		},
		-- Geyser de poche : il vise le sol devant lui, une colonne d'eau jaillit tout le long du couloir et fait décoller l'adversaire
		S_finish_geyser = {
			label = "Geyser de poche", startup = 0.16, active = 0.15, recovery = 0.4,
			damage = 12, hitbox = box(14, 7, 7, 2), kbBase = 32, kbGrowth = 65, kbAngle = 86,
			windup = { Root = { 6, -8, 0, 0, -0.2, 0.15 }, Waist = { 8, -8, 0 }, RS = { 140, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, -0.4, -0.1 }, Waist = { -20, 8, 0 }, Neck = { -10, 0, 0 }, RS = { 45, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 50, 0, 0 } },
			follow = { Root = { 4, 6, 0, 0, -0.3, 0 }, Waist = { 6, 8, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 5 }, RE = { 5, 0, 0 }, RW = { 10, 0, 0 }, LS = { 30, 0, -45 }, LE = { 50, 0, 0 } },
			fx = { { "pillar", color = WATER, height = 12, width = 2.2, at = "front" } }, text = "PFIOUUU !", hitText = "SPLOOSH !",
		},

		------------------------------------------------------------------ Supers
		-- Raz-de-marée de canards en plastique : il souffle dans la corne, une vague de canards de bain déferle au sol et tous foncent sur l'adversaire en rafale
		SUPER = {
			label = "Raz-de-marée de canards !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 4, kbBase = 26, kbGrowth = 40, kbAngle = 35,
			projectile = { speed = 50, gravity = 0, lifetime = 1.2, size = 1.6, color = DUCK, from = "feet", visual = RUBBER_DUCK, fan = { count = 6, from = -4, to = 18, gap = 0.08 } },
			windup = { Root = { -6, 0, 0, 0, -0.4, 0.15 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 120, 0, 20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, -0.1, 0 }, Waist = { 18, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 120, 0, 60 }, RE = { 10, 0, 0 }, LS = { 150, 0, 10 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.1, 0 }, Waist = { 20, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 135, 0, 70 }, RE = { 10, 0, 0 }, LS = { 155, 0, 8 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			hold = 0.2, prop = "corne", windupFx = { "super" },
			fx = { { "puddle", color = WATER, width = 16, time = 1.5 }, { "symbols", symbols = { "🦆", "COIN" }, color = DUCK, count = 8, radius = 6 }, { "shake", amount = 0.4 } },
			text = "RAZ-DE-MARÉE !", hitText = "COUIIIC !",
		},
		-- Super → : Vague scélérate, pistolet pointé dans le carrelage à pression maximale : une vague géante se dresse devant lui et roule
		-- sur tout le couloir, le Capitaine debout sur la crête comme un surfeur, bouée en guise de planche
		SUPER_side = {
			label = "Vague scélérate !", startup = 0.4, active = 0.3, recovery = 0.7,
			damage = 25, hitbox = box(14, 7, 7, 1), kbBase = 46, kbGrowth = 92, kbAngle = 42, selfVelocity = Vector2.new(34, 18),
			status = { name = "wet", duration = 3 },
			windup = { Root = { 10, 0, 0, 0, -0.5, 0.2 }, Waist = { 20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 10 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -10, 30, 0, 0, 0.2, -0.3 }, Waist = { -8, 20, 0 }, Neck = { 0, -20, 0 }, RS = { 60, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0.3 }, FL = { 0, 0, 0, 0, 0.3, -0.4 } },
			follow = { Root = { -12, 36, 0, 0, 0.25, -0.4 }, Waist = { -10, 26, 0 }, Neck = { 0, -24, 0 }, RS = { 64, 0, 84 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 64, 0, -84 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0.3 }, FL = { 0, 0, 0, 0, 0.35, -0.45 } },
			hold = 0.2, shake = true, wobble = true, trail = "body", windupFx = { "super", { "particles", tex = "smoke", color = FOAM, at = "feet", dir = "up", time = 0.35, speed = 12, rate = 80 } },
			fx = { { "pillar", color = WATER, height = 12, width = 7, at = "front", time = 0.5 }, { "beam", color = WATER, length = 16, width = 6, at = "feet" }, { "puddle", color = FOAM, width = 16, time = 1.5 }, { "symbols", symbols = { "🌊", "🏄", "COIN" }, color = WATER, count = 6, radius = 5, at = "above" }, { "shake", amount = 0.5 } },
			text = "SURF'S UP, MOUSSAILLON !", hitText = "EMPORTÉ PAR LA VAGUE !",
		},
		-- Super ↑ : Fusée de bain, pistolet à deux mains pointé entre ses palmes, le jet le propulse en vrille verticale comme une fusée et la gerbe fauche tout le couloir
		SUPER_up = {
			label = "Fusée de bain !", startup = 0.4, active = 0.3, recovery = 0.7,
			damage = 24, hitbox = box(14, 14, 7, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -8, 0, 0, 0, -0.75, 0 }, Waist = { -16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -10, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -12 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 2, 0, 0, 0, 0.6, 0 }, Waist = { 4, 0, 0 }, Neck = { 35, 0, 0 }, RS = { -15, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -15, 0, -8 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { -6, 0, 2 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { -6, 0, -2 }, LK = { 0, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0.65, 0 }, Waist = { 6, 0, 0 }, Neck = { 40, 0, 0 }, RS = { -18, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -18, 0, -6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { -8, 0, 2 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { -8, 0, -2 }, LK = { 0, 0, 0 }, LA = { -30, 0, 0 } },
			hold = 0.2, shake = true, spin = { axis = "y", degrees = 720 }, selfVelocity = Vector2.new(0, 70), trail = "body",
			windupFx = { "super" }, status = { name = "wet", duration = 2 },
			fx = { { "pillar", color = WATER, height = 24, width = 4, at = "root" }, { "puddle", color = FOAM, width = 14 }, { "particles", tex = "smoke", color = FOAM, at = "feet", dir = "down", time = 0.5, rate = 120, speed = 20, size = 0.8 }, { "shake", amount = 0.5 } },
			text = "DÉCOLLAGE IMMÉDIAT !", hitText = "SPLAAASH !",
		},
		-- Escadrille : il décolle en planant et siffle ; une escadrille de canards en plastique bombardiers pique du ciel et s'abat sur l'adversaire
		SUPER_down = {
			label = "Escadrille !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 4, kbBase = 22, kbGrowth = 24, kbAngle = 70, selfVelocity = Vector2.new(0, 60),
			projectile = { speed = 70, gravity = 0, lifetime = 1.2, size = 2, color = DUCK, visual = RUBBER_DUCK, rain = { count = 8, spread = 6, ahead = 8, height = 24 } },
			status = { name = "wet", duration = 3 },
			windup = { Root = { 0, 0, 0, 0, -0.7, 0 }, Waist = { -18, 0, 0 }, RS = { 20, 0, 50 }, RE = { 30, 0, 0 }, LS = { 20, 0, -50 }, LE = { 30, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, 0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -95 }, LE = { 10, 0, 0 }, RH = { 10, 0, 8 }, RK = { -40, 0, 0 }, LH = { 10, 0, -8 }, LK = { -40, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, 0.4, 0 }, Waist = { -12, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 25, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -100 }, LE = { 10, 0, 0 }, RH = { 15, 0, 8 }, RK = { -50, 0, 0 }, LH = { 15, 0, -8 }, LK = { -50, 0, 0 } },
			hold = 0.4, windupFx = { "super" }, fx = { { "rain", shape = "ball", color = DUCK, count = 12, radius = 8, size = 0.8 }, { "screen", color = WATER, alpha = 0.25 }, { "symbols", symbols = { "🦆", "✈️", "COIN" }, color = DUCK, count = 8, radius = 7, at = "above" } },
			text = "ESCADRILLE, EN AVANT !", hitText = "COUIC-SPLASH !",
		},

		------------------------------------------------------------------ Chope (bouton ✋) et projections
		-- Prise de bouée : il lève les bras comme pour passer une bouée par-dessus la tête de l'adversaire et la referme
		GRAB = {
			label = "Prise de bouée", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, 0.05, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 165, 0, 30 }, RE = { 30, 0, 0 }, LS = { 165, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -14, 0, 0 }, RS = { 90, 0, -15 }, RE = { 60, 0, 0 }, LS = { 90, 0, 15 }, LE = { 60, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.15, -0.3 }, Waist = { -10, 0, 0 }, RS = { 86, 0, -24 }, RE = { 80, 0, 0 }, LS = { 86, 0, 24 }, LE = { 80, 0, 0 } },
			text = "BOUÉE À LA MER !", hitText = "HOP !",
		},
		-- ✋ puis → : À l'eau !, il pousse l'adversaire des deux mains comme au bord de la piscine
		THROW_fwd = {
			label = "À l'eau !", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 18,
			carry = { { 0, 2.4, 0.4 }, { 0.15, 1.8, 0.4 }, { 0.3, 4.2, 0.2 } },
			windup = { Root = { 6, 0, 0, 0, -0.3, 0.3 }, Waist = { 10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 100, 0, 0 }, LS = { 70, 0, 10 }, LE = { 100, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.4, -0.5 }, Waist = { -14, 0, 0 }, RS = { 92, 0, -5 }, RE = { 0, 0, 0 }, LS = { 92, 0, 5 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -24, 0, 0, 0, -0.45, -0.6 }, Waist = { -16, 0, 0 }, RS = { 96, 0, -5 }, RE = { 0, 0, 0 }, LS = { 96, 0, 5 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { { "puddle", color = WATER, width = 8 } }, text = "À L'EAU !", hitText = "PLOUF !",
		},
		-- ✋ puis ← : Plongeon arrière, il bascule en arrière avec l'adversaire coincé dans la bouée
		THROW_back = {
			label = "Plongeon arrière", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 11, kbBase = 36, kbGrowth = 65, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.12, 1.2, 0.6 }, { 0.26, 0.2, 3 }, { 0.4, -2.6, -1.4 } },
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, RS = { 75, 0, -20 }, RE = { 70, 0, 0 }, LS = { 75, 0, 20 }, LE = { 70, 0, 0 } },
			strike = { Root = { 55, 0, 0, 0, -0.8, 0.4 }, Waist = { 30, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 195, 0, -10 }, RE = { 20, 0, 0 }, LS = { 195, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 60, 0, 0, 0, -0.9, 0.5 }, Waist = { 34, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 205, 0, -10 }, RE = { 20, 0, 0 }, LS = { 205, 0, 10 }, LE = { 20, 0, 0 } },
			fx = { { "puddle", color = WATER, width = 8 } }, text = "PLONGEON !", hitText = "SPLAAATCH !",
		},
		-- ✋ puis ↑ : Jet de bouée, il gonfle la bouée autour de l'adversaire, qui s'envole comme un ballon
		THROW_up = {
			label = "Jet de bouée", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 40, kbGrowth = 58, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.16, 2.2, 1 }, { 0.32, 1, 4.2 } },
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.1 }, Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 80, 0, -20 }, RE = { 120, 0, 0 }, LS = { 80, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.25, -0.1 }, Waist = { 15, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 175, 0, 15 }, RE = { 5, 0, 0 }, LS = { 175, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.3, -0.1 }, Waist = { 18, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 180, 0, 25 }, RE = { 5, 0, 0 }, LS = { 180, 0, -25 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			shake = true, fx = { { "symbols", symbols = { "💨" }, count = 4, color = FOAM } }, text = "GONFLÉ !", hitText = "FIIIOUU !",
		},
		-- ✋ puis ↓ : Bouée dégonflée, il plaque l'adversaire au sol et saute à pieds joints sur la bouée, pschhh
		THROW_down = {
			label = "Bouée dégonflée", kind = "throw", startup = 0.42, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 70,
			carry = { { 0, 2.2, 0.3 }, { 0.15, 2, 1.5 }, { 0.3, 1.6, -2 }, { 0.42, 1, -2.4 } },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { -6, 0, 0, 0, 0.6, -0.8 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 70 }, RE = { 10, 0, 0 }, LS = { 60, 0, -70 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.8, -0.9 }, FL = { 0, 0, 0, 0, 0.8, -0.7 } },
			follow = { Root = { 4, 0, 0, 0, -0.2, -0.9 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 60 }, RE = { 10, 0, 0 }, LS = { 120, 0, -60 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.9 }, FL = { 0, 0, 0, 0, 0, -0.7 } },
			fx = { { "particles", tex = "smoke", color = FOAM, at = "front", dir = "all", time = 0.4, speed = 12 } }, text = "PSCHHHH !", hitText = "PFFFT !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "petit_bain", label = "Le Petit Bain", sequence = { "up", "up", "up" },
			-- l'adversaire rapetisse, devient jaune canard et finit dans une baignoire pleine de mousse
			scene = {
				{ "fxAttacker", { "text", text = "C'EST L'HEURE DU BAIN !", color = DUCK } },
				{ "fx", { "burst", color = FOAM, size = 5 } },
				{ "shrink", 0.35, time = 0.6 },
				{ "color", DUCK },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.4, 0), life = 4, pieces = {
					{ "Fond", "", "block", Vector3.new(4.4, 0.4, 2.4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
					{ "BordAvant", "", "block", Vector3.new(4.4, 1.4, 0.3), Vector3.new(0, 0.7, -1.1), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
					{ "BordArriere", "", "block", Vector3.new(4.4, 1.4, 0.3), Vector3.new(0, 0.7, 1.1), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
					{ "BordG", "", "block", Vector3.new(0.3, 1.4, 2.4), Vector3.new(-2.1, 0.7, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
					{ "BordD", "", "block", Vector3.new(0.3, 1.4, 2.4), Vector3.new(2.1, 0.7, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
					{ "Eau", "", "block", Vector3.new(3.9, 0.2, 1.9), Vector3.new(0, 1.1, 0), Vector3.new(0, 0, 0), WATER, "Glass", { transparency = 0.3 } },
					{ "Mousse1", "", "ball", Vector3.new(1.2, 0.8, 1), Vector3.new(-1.2, 1.4, 0), Vector3.new(0, 0, 0), FOAM, "SmoothPlastic" },
					{ "Mousse2", "", "ball", Vector3.new(1, 0.7, 0.9), Vector3.new(1.3, 1.35, 0.2), Vector3.new(0, 0, 0), FOAM, "SmoothPlastic" },
					{ "Robinet", "", "cyl", Vector3.new(1, 0.25, 0.25), Vector3.new(2.1, 1.9, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 200, 210), "Metal", { axis = "y" } },
				} },
				{ "fx", { "symbols", symbols = { "🫧", "🦆", "COUIC" }, count = 8, color = FOAM } },
				{ "wait", 0.8 },
				{ "text", "COUIC ?" },
				{ "fxAttacker", { "text", text = "COIN-COIIIN !", color = DUCK } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "le_degonfle", label = "Le Dégonflé", sequence = { "forward", "down", "forward" },
			-- Canard plante la valve de sa bouée dans l'adversaire : il gonfle, se dégonfle et part en sifflant
			scene = {
				{ "fxAttacker", { "text", text = "UNE PETITE VALVE…", color = DUCK } },
				{ "wait", 0.5 },
				{ "grow", 1.6, time = 0.6 },
				{ "text", "BLOUUUP ?" },
				{ "wait", 0.4 },
				{ "fx", { "particles", tex = "smoke", color = FOAM, at = "root", dir = "all", time = 1.2, speed = 16, rate = 100 } },
				{ "squash", 0.4 },
				{ "text", "PFFFFFIIIIIIIIOU !" },
				{ "spin", 1080, time = 0.8, axis = "y" },
				{ "launch", Vector3.new(30, 80, 0), time = 1.2 },
				{ "fxAttacker", { "text", text = "BON VENT, MOUSSAILLON !", color = WHITE } },
				{ "wait", 0.6 },
			},
		},
		{
			id = "dents_de_la_piscine", label = "Les Dents de la piscine", sequence = { "down", "back", "up" },
			-- un requin gonflable surgit de l'eau, avale l'adversaire et repart en surfant
			scene = {
				{ "fx", { "puddle", color = WATER, width = 10, time = 3 } },
				{ "text", "TA-DAM… TA-DAM…" },
				{ "wait", 0.7 },
				{ "spawn", at = "target", offset = Vector3.new(0, -0.5, 0), life = 3, pieces = {
					{ "Corps", "", "ball", Vector3.new(5, 3.4, 2.6), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(120, 140, 170), "SmoothPlastic" },
					{ "Ventre", "", "ball", Vector3.new(4.2, 2, 2.7), Vector3.new(0.2, -0.6, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
					{ "Aileron", "", "wedge", Vector3.new(0.4, 1.8, 1.6), Vector3.new(0, 2.2, 0.4), Vector3.new(0, 90, 0), Color3.fromRGB(120, 140, 170), "SmoothPlastic" },
					{ "Dents", "", "block", Vector3.new(2.6, 0.3, 2.65), Vector3.new(1.2, -0.2, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
					{ "Oeil", "", "ball", Vector3.new(0.5, 0.5, 2.7), Vector3.new(1.6, 0.8, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
					{ "Queue", "", "wedge", Vector3.new(0.4, 2, 1.4), Vector3.new(-2.8, 0.6, 0), Vector3.new(0, -90, 0), Color3.fromRGB(120, 140, 170), "SmoothPlastic" },
				} },
				{ "hide" },
				{ "text", "CROC !" },
				{ "fx", { "burst", color = WATER, size = 6 } },
				{ "wait", 0.8 },
				{ "fxAttacker", { "text", text = "JE CROIS QU'IL VA NOUS FALLOIR UNE PLUS GRANDE BOUÉE…", color = WHITE } },
				{ "wait", 1.2 },
			},
		},
	},

	-- Mécanique : Flottaison (triple saut, plané) et jauge de Pression d'eau, voir server/Mechanics.lua
	passive = { kind = "float", name = "Pression", icon = "💧", max = 100, regen = 22, airJumps = 2, glide = true, color = WATER },

	-- Recharge ⚡ : il gonfle sa bouée à la bouche, penché sur la valve, les joues gonflées… puis un coin-coin de
	-- corne de brume, poing levé.
	charge = {
		label = "Gonflage de bouée",
		loop = 1.8,
		lockWrist = false,
		color = WATER,
		keys = {
			{ 0.0, { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -24, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, LS = { 40, 0, 10 }, LE = { 110, 0, 0 } } },
			{ 0.3, { Root = { -2, 0, 0, 0, -0.25, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 45, 0, -10 }, RE = { 105, 0, 0 }, LS = { 45, 0, 10 }, LE = { 105, 0, 0 } } },
			{ 0.55, { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -24, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, LS = { 40, 0, 10 }, LE = { 110, 0, 0 } } },
			{ 0.85, { Root = { -2, 0, 0, 0, -0.25, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 45, 0, -10 }, RE = { 105, 0, 0 }, LS = { 45, 0, 10 }, LE = { 105, 0, 0 } } },
			{ 1.2, { Root = { 8, 0, 0, 0, -0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.45, { Root = { 6, 0, 0, 0, -0.15, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 25 }, RE = { 30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.8, { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -24, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 40, 0, -10 }, RE = { 110, 0, 0 }, LS = { 40, 0, 10 }, LE = { 110, 0, 0 } } },
		},
		beats = {
			{ 0.15, { "symbols", symbols = { "💨" }, count = 2, color = FOAM, radius = 2, at = "front" } },
			{ 0.7, { "symbols", symbols = { "💨" }, count = 2, color = FOAM, radius = 2, at = "front" } },
			{ 1.2, { "text", text = "COIN-COIIIN !", color = DUCK } },
			{ 1.22, { "ring", color = DUCK, radius = 5, at = "root" } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- il penche la tête et secoue l'eau de son oreille en sautillant sur une palme
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { 0, 0, 30 }, Waist = { 0, 0, 10 }, LS = { 60, 0, -80 }, LE = { 120, 0, 0 } } },
			{ 0.5, { Root = { 0, 0, 0, 0, 0.15, 0 }, Neck = { 0, 0, 36 }, Waist = { 0, 0, 12 }, LS = { 60, 0, -85 }, LE = { 130, 0, 0 } } },
			{ 0.7, { Neck = { 0, 0, 28 }, Waist = { 0, 0, 10 }, LS = { 60, 0, -80 }, LE = { 120, 0, 0 } } },
			{ 0.9, { Root = { 0, 0, 0, 0, 0.15, 0 }, Neck = { 0, 0, 36 }, Waist = { 0, 0, 12 }, LS = { 60, 0, -85 }, LE = { 130, 0, 0 } } },
			{ 1.2, { Neck = { 0, 0, 20 } } },
			{ 1.8, {} },
		} },
		-- il remet son masque en place et ajuste sa casquette d'un air digne
		{ duration = 2, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 10, 0, 0 }, LS = { 150, 0, -30 }, LE = { 120, 0, 0 } } },
			{ 0.8, { Neck = { 14, 0, 0 }, LS = { 160, 0, -25 }, LE = { 130, 0, 0 }, RS = { 150, 0, 30 }, RE = { 120, 0, 0 } } },
			{ 1.3, { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 12, 0, 0 } } },
			{ 2, {} },
		} },
		-- il tapote le réservoir de son pistolet pour vérifier la pression
		{ duration = 1.8, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.35, { Neck = { -20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -30, 0, 0 }, LS = { 50, 0, 20 }, LE = { 90, 0, 0 } } },
			{ 0.6, { Neck = { -20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -30, 0, 0 }, LS = { 55, 0, 20 }, LE = { 75, 0, 0 } } },
			{ 0.85, { Neck = { -20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -30, 0, 0 }, LS = { 50, 0, 20 }, LE = { 90, 0, 0 } } },
			{ 1.1, { Neck = { -20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -30, 0, 0 }, LS = { 55, 0, 20 }, LE = { 75, 0, 0 } } },
			{ 1.8, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : bras serrés autour de la victime coincée dans la bouée, bassin en avant
data.grabHold = {
	Root = { 4, 0, 4, 0, -0.2, 0 },
	Waist = { 10, 0, 0 },
	Neck = { 8, 0, -6 },
	RS = { 85, 0, -25 },
	RE = { 40, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 85, 0, 25 },
	LE = { 40, 0, 0 },
}

-- Retour 🪂 : il arrive en surfant sur une bouée canard géante portée par une petite vague qui retombe,
-- fait le salut militaire, puis souffle dans sa corne de brume.
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Bouee", "base", "cyl", Vector3.new(1, 6, 4), Vector3.new(0, -0.5, 0), Vector3.new(0, 0, 0), DUCK, "SmoothPlastic", { axis = "y" } },
		{ "Cou", "", "cyl", Vector3.new(1.4, 0.9, 0.9), Vector3.new(0, 0.4, -2.2), Vector3.new(-20, 0, 0), DUCK, "SmoothPlastic", { axis = "y" } },
		{ "Tete", "", "ball", Vector3.new(1.6, 1.6, 1.6), Vector3.new(0, 1.3, -2.5), Vector3.new(0, 0, 0), DUCK, "SmoothPlastic" },
		{ "Bec", "", "ball", Vector3.new(0.9, 0.4, 1), Vector3.new(0, 1.15, -3.3), Vector3.new(0, 0, 0), BEAK, "SmoothPlastic" },
		{ "OeilG", "", "ball", Vector3.new(0.25, 0.3, 0.15), Vector3.new(-0.4, 1.55, -3.2), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
		{ "OeilD", "", "ball", Vector3.new(0.25, 0.3, 0.15), Vector3.new(0.4, 1.55, -3.2), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic" },
		{ "Vague", "", "wedge", Vector3.new(7, 2.4, 4), Vector3.new(0, -2.2, 1.5), Vector3.new(0, 0, 0), WATER, "Glass", { transparency = 0.25 } },
		{ "Ecume1", "", "ball", Vector3.new(2, 1, 1.5), Vector3.new(-2, -1, 2.8), Vector3.new(0, 0, 0), FOAM, "SmoothPlastic" },
		{ "Ecume2", "", "ball", Vector3.new(2.4, 1.2, 1.6), Vector3.new(1.5, -0.9, 3), Vector3.new(0, 0, 0), FOAM, "SmoothPlastic" },
	} },
	keys = {
		{ 0.0, { Root = { 0, 70, 0, 0, -0.5, 0 }, Waist = { 0, -20, 0 }, Neck = { 0, -50, 0 }, RS = { 30, 0, 80 }, RE = { 20, 0, 0 }, LS = { 30, 0, -80 }, LE = { 20, 0, 0 } } },
		{ 0.35, { Root = { 0, 60, 8, 0, -0.55, 0 }, Waist = { 0, -20, -6 }, Neck = { 0, -45, 0 }, RS = { 40, 0, 85 }, RE = { 20, 0, 0 }, LS = { 20, 0, -75 }, LE = { 20, 0, 0 } } },
		{ 0.6, { Root = { 0, 70, -8, 0, -0.5, 0 }, Waist = { 0, -20, 6 }, Neck = { 0, -50, 0 }, RS = { 20, 0, 75 }, RE = { 20, 0, 0 }, LS = { 40, 0, -85 }, LE = { 20, 0, 0 } } },
		{ 0.8, { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 6, 0, 0 } } },
		{ 1.0, { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 125, 0, -40 }, RE = { 135, 0, 0 }, LS = { 0, 0, -8 }, LE = { 5, 0, 0 } } },
		{ 1.25, { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 125, 0, -40 }, RE = { 135, 0, 0 }, LS = { 0, 0, -8 }, LE = { 5, 0, 0 } } },
		{ 1.5, { Root = { 8, 0, 0, 0, -0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.05, { "particles", tex = "smoke", color = FOAM, at = "feet", dir = "all", time = 0.6, speed = 10 } },
		{ 0.75, { "puddle", color = WATER, width = 8 } },
		{ 1.0, { "text", text = "CAPITAINE À BORD !", color = WHITE } },
		{ 1.5, { "text", text = "COIN-COIIIN !", color = DUCK } },
		{ 1.52, { "ring", color = DUCK, radius = 5, at = "root" } },
	},
}

-- Arbre d'enchaînements. En l'air, J et K s'alternent, une flèche choisit la version directionnelle,
-- ↓S plonge en bombe et ↑S reste la remontée.
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol : J…
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side", down_P = "P_down", S = "S_finish_jet" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", up_K = "K_upK", S = "S_finish_jet" }, -- J J
	P_combo3 = { P = "P_combo4", K = "K_combo3", S = "S_finish_geyser" }, -- J J J (J J J J : bec tournoyant, finition)
	PK_combo = { P = "KP_combo", K = "PKK_combo", S = "S_finish_geyser" }, -- J K (J K K : pédalo)
	PKK_combo = { S = "S_finish_geyser" }, -- J K K
	-- au sol : K…
	K_neutral = { K = "K_combo2", P = "KP_combo", up_K = "K_upK", S = "S_finish_jet" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_geyser" }, -- K K
	K_combo3 = { K = "K_air_side", S = "S_air" }, -- K K K (il décolle)
	KP_combo = { P = "P_combo3", K = "K_side2", S = "S_finish_jet" }, -- K J
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side2", S = "S_finish_jet" }, -- → J
	P_side2 = { P = "P_side3", K = "PK_combo", S = "S_finish_geyser" }, -- → J J (→ J J J : corne de brume au nez, finition)
	P_down = { P = "P_down2", K = "K_downK", S = "S_finish_geyser" }, -- ↓ J
	P_down2 = { P = "P_air_up", K = "K_air_up", S = "S_finish_geyser" }, -- ↓ J J (fait décoller)
	P_up = { P = "P_air_up", K = "K_upK", S = "S_finish_geyser" }, -- ↑ J
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_jet" }, -- → K
	K_side2 = { K = "K_side3", S = "S_finish_geyser" }, -- → K K (→ K K K : plongeon du capitaine, finition)
	K_down = { K = "K_downK", P = "P_down2", S = "S_finish_jet" }, -- ↓ K
	K_downK = { K = "K_air_up", S = "S_finish_geyser" }, -- ↓ K K
	K_up = { K = "K_upK", P = "P_up", S = "S_finish_geyser" }, -- ↑ K
	K_upK = { S = "S_finish_jet" }, -- ↑ K K
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_finish_jet" }, -- dash J
	K_dash = { K = "K_downK", P = "KP_combo", S = "S_finish_geyser" }, -- dash K
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

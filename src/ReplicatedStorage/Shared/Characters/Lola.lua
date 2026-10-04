-- Lola Filtre : influenceuse qui se bat pour la story, chaque touche lui rapporte des likes. Arme sortie de la
-- Caisse Bizarre : la perche à selfie (téléphone à paillettes au bout) et sa ring light.
--
-- Même format que Gege.lua (voir son en-tête et docs/fiche-perso.md).
-- Mécanique « likes » : +100 likes par touche ; à 1 000 elle devient « virale » (dégâts renforcés 8 s).
-- Ses poses sont des poses photo : déhanché, main sur la hanche, signe V, bras tendu vers l'objectif.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local PEAU = Color3.fromRGB(255, 215, 190)
local ROSE = Color3.fromRGB(255, 170, 210)
local ROSE_VIF = Color3.fromRGB(255, 60, 150)
local CHEVEUX = Color3.fromRGB(250, 205, 230)
local LILAS = Color3.fromRGB(190, 150, 255)
local BLANC = Color3.fromRGB(250, 250, 250)
local NOIR = Color3.fromRGB(25, 25, 30)
local OR = Color3.fromRGB(255, 205, 80)
local ARGENT = Color3.fromRGB(200, 200, 210)
local BLEU = Color3.fromRGB(60, 140, 255)
local FLASH = Color3.fromRGB(255, 255, 240)

local CHAUD = Color3.fromRGB(255, 160, 90) -- air chaud du sèche-cheveux (arme n° 2)
local GIVRE = Color3.fromRGB(190, 235, 255) -- mode froid du sèche-cheveux (arme n° 2)
local CUIR_ROSE = Color3.fromRGB(230, 120, 170) -- sac à main de luxe (arme n° 3)
local data = {
	id = "Lola",
	name = "Lola Filtre",
	costume = "Lola",
	style = "diva",

	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : diva sans téléphone
	-- Ses propres J / K et ses combos sans perche (les L et les Y restent ceux de moves). Lola se bat avec ses
	-- faux ongles, ses cheveux, ses bisous volants et ses gifles de diva ; ses talons cassent au mauvais moment.
	bare = {
		moves = {
			-- J : pichenette du bout de ses faux ongles vernis, petit doigt levé
			P_neutral = {
				label = "Pichenette manucurée", startup = 0.06, active = 0.07, recovery = 0.13,
				damage = 5, hitbox = box(4, 2.5, 2.6, 1.1), kbBase = 18, kbGrowth = 22, kbAngle = 25,
				windup = { Root = { 0, -10, 6, 0, -0.08, 0.1 }, Waist = { 0, -12, -6 }, Neck = { 0, 12, 4 }, RS = { 70, 0, 20 }, RE = { 120, 0, 0 }, RW = { 40, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 } },
				strike = { Root = { -4, 10, -4, 0, -0.1, -0.18 }, Waist = { -4, 12, 6 }, Neck = { 0, -8, -4 }, RS = { 92, 0, 4 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 20, 0, -40 }, LE = { 115, 0, 0 } },
				follow = { Root = { -5, 12, -4, 0, -0.1, -0.2 }, Waist = { -5, 14, 6 }, Neck = { 0, -10, -4 }, RS = { 90, 0, 0 }, RE = { 12, 0, 0 }, RW = { -50, 0, 0 }, LS = { 20, 0, -40 }, LE = { 116, 0, 0 } },
				trail = "rightHand", fx = { { "particles", tex = "spark", color = ROSE_VIF, dir = "front", at = "hand", time = 0.2, speed = 6, size = 0.3, rate = 40 } }, hitText = "TCHIC !",
			},
			-- J J : coup de griffe des faux ongles de l'autre main, en diagonale
			P_combo2 = {
				label = "Griffe de faux ongles", startup = 0.06, active = 0.08, recovery = 0.14,
				damage = 5, hitbox = box(4.5, 3, 2.8, 1), kbBase = 18, kbGrowth = 22, kbAngle = 30,
				windup = { Root = { 0, 14, 0, 0, -0.1, 0.1 }, Waist = { 0, 16, 0 }, Neck = { 0, -12, 0 }, RS = { 20, 0, 30 }, RE = { 90, 0, 0 }, LS = { 160, 0, 20 }, LE = { 40, 0, 0 }, LW = { -30, 0, 0 } },
				strike = { Root = { -6, -14, 0, 0, -0.15, -0.22 }, Waist = { -6, -16, 0 }, Neck = { 0, 12, 0 }, RS = { 20, 0, 34 }, RE = { 90, 0, 0 }, LS = { 70, 0, 30 }, LE = { 10, 0, 0 }, LW = { -40, 0, 0 } },
				follow = { Root = { -7, -16, 0, 0, -0.16, -0.24 }, Waist = { -7, -18, 0 }, Neck = { 0, 14, 0 }, RS = { 20, 0, 36 }, RE = { 92, 0, 0 }, LS = { 50, 0, 40 }, LE = { 12, 0, 0 }, LW = { -46, 0, 0 } },
				trail = "leftHand", fx = { { "symbols", symbols = { "💅" }, color = ROSE_VIF, count = 2, radius = 2, at = "front" } }, hitText = "SCRATCH !",
			},
			-- J J K : coup de mèche ! elle fait tourner la tête et sa chevelure fouette l'adversaire
			PPK_combo = {
				label = "Hair flip", startup = 0.12, active = 0.12, recovery = 0.28,
				damage = 9, hitbox = box(5, 3.5, 2.4, 1.6), kbBase = 26, kbGrowth = 48, kbAngle = 35,
				windup = { Root = { 0, 30, 0, 0, -0.1, 0.1 }, Waist = { -10, 30, 0 }, Neck = { -30, 20, 0 }, RS = { 30, 0, 40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 120, 0, 0 } },
				strike = { Root = { 0, -30, 0, 0, -0.1, -0.2 }, Waist = { 10, -30, 0 }, Neck = { 24, -30, 0 }, RS = { 20, 0, 30 }, RE = { 130, 0, 0 }, LS = { 20, 0, -30 }, LE = { 130, 0, 0 } },
				follow = { Root = { 0, -36, 0, 0, -0.1, -0.22 }, Waist = { 12, -34, 0 }, Neck = { 28, -34, 0 }, RS = { 18, 0, 28 }, RE = { 132, 0, 0 }, LS = { 18, 0, -28 }, LE = { 132, 0, 0 } },
				hold = 0.08, spin = { axis = "y", degrees = 360 }, trail = "head", fx = { { "particles", tex = "spark", color = CHEVEUX, dir = "all", at = "head", time = 0.3, speed = 8, size = 0.5, rate = 60 } }, text = "HAIR FLIP !", hitText = "FOUETTÉ !",
			},
			-- K J : elle souffle un bisou volant… qui claque comme une gifle
			KP_combo = {
				label = "Bisou volant", startup = 0.1, active = 0.12, recovery = 0.26,
				damage = 8, hitbox = box(5.5, 3, 3.2, 1.4), kbBase = 24, kbGrowth = 42, kbAngle = 30,
				windup = { Root = { 0, 10, 0, 0, -0.05, 0.1 }, Waist = { 0, 10, 0 }, Neck = { 10, -6, 0 }, RS = { 120, 0, -40 }, RE = { 140, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -6, -10, 0, 0, -0.08, -0.2 }, Waist = { -6, -12, 0 }, Neck = { -6, 8, 0 }, RS = { 100, 0, 20 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 10, 0, -30 }, LE = { 110, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
				follow = { Root = { -7, -12, 0, 0, -0.08, -0.22 }, Waist = { -7, -14, 0 }, Neck = { -8, 10, 0 }, RS = { 98, 0, 26 }, RE = { 0, 0, 0 }, RW = { -24, 0, 0 }, LS = { 10, 0, -32 }, LE = { 112, 0, 0 }, RH = { -34, 0, 0 }, RK = { -70, 0, 0 } },
				trail = "rightHand", fx = { { "symbols", symbols = { "💋", "♥" }, color = ROSE_VIF, count = 4, radius = 3, at = "front" } }, text = "MWAH !", hitText = "SMACK !",
			},
			-- →J : « Parle à ma main ! » : paume plaquée devant elle, tête détournée
			P_side = {
				label = "Parle à ma main", startup = 0.1, active = 0.1, recovery = 0.2,
				damage = 7, hitbox = box(5, 3, 3, 1.2), kbBase = 22, kbGrowth = 35, kbAngle = 22, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { 0, 20, 0, 0, -0.1, 0.15 }, Waist = { 0, 20, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 10 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 110, 0, 0 } },
				strike = { Root = { -6, -10, 0, 0, -0.15, -0.35 }, Waist = { -4, -10, 0 }, Neck = { 0, 50, 10 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { -80, 0, 0 }, LS = { 20, 0, -30 }, LE = { 115, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.35 } },
				follow = { Root = { -7, -12, 0, 0, -0.16, -0.38 }, Waist = { -5, -12, 0 }, Neck = { 0, 54, 12 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { -84, 0, 0 }, LS = { 20, 0, -32 }, LE = { 116, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.38 } },
				hold = 0.06, trail = "rightHand", text = "PARLE À MA MAIN !", hitText = "STOP !",
			},
			-- →J J : la gifle de diva, grand aller du revers, bracelets qui cliquettent
			sidePP_combo = {
				label = "Gifle de diva", startup = 0.1, active = 0.1, recovery = 0.28,
				damage = 9, hitbox = box(5, 3, 2.8, 1.3), kbBase = 26, kbGrowth = 48, kbAngle = 28,
				windup = { Root = { 0, -30, 0, 0, -0.1, 0.15 }, Waist = { 0, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 100, 0, 100 }, RE = { 20, 0, 0 }, RW = { 20, 0, 0 }, LS = { 30, 0, -20 }, LE = { 110, 0, 0 } },
				strike = { Root = { -6, 30, 0, 0, -0.15, -0.25 }, Waist = { -6, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 92, 0, -40 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -24 }, LE = { 112, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -7, 36, 0, 0, -0.16, -0.28 }, Waist = { -7, 40, 0 }, Neck = { 0, -24, 0 }, RS = { 88, 0, -56 }, RE = { 14, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -26 }, LE = { 114, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				hold = 0.06, trail = "rightHand", fx = { { "burst", color = ROSE, size = 2.2, at = "front" } }, text = "PAS LE VISAGE !", hitText = "CLAAAQUE !",
			},
			-- ↓J : révérence de gala, elle plonge en saluant et sa main balaie le sol
			P_down = {
				label = "Révérence de gala", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 6, hitbox = box(5, 2, 2.6, -1.3), kbBase = 20, kbGrowth = 26, kbAngle = 70,
				windup = { Root = { 0, 0, 0, 0, -0.2, 0.1 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { 20, 0, -70 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.3 } },
				strike = { Root = { -20, 0, 0, 0, -0.85, -0.1 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 50, 0, 20 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { -30, 0, -40 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.5 } },
				follow = { Root = { -22, 0, 0, 0, -0.9, -0.12 }, Waist = { -32, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 40, 0, 40 }, RE = { 0, 0, 0 }, RW = { 24, 0, 0 }, LS = { -32, 0, -42 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.52 } },
				trail = "rightHand", text = "MERCI, MERCI !", hitText = "RÉVÉRENCE !",
			},
			-- ↑J : un cœur avec les mains, brandi bien haut vers l'objectif
			P_up = {
				label = "Cœur avec les mains", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 6, hitbox = box(4, 5, 1.2, 3), kbBase = 22, kbGrowth = 38, kbAngle = 86,
				windup = { Root = { 0, 0, 0, 0, -0.3, 0.05 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, -30 }, RE = { 110, 0, 0 }, LS = { 70, 0, 30 }, LE = { 110, 0, 0 } },
				strike = { Root = { 6, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, -20 }, RE = { 40, 0, 0 }, LS = { 170, 0, 20 }, LE = { 40, 0, 0 } },
				follow = { Root = { 8, 0, 0, 0, 0.18, 0 }, Waist = { 10, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 174, 0, -22 }, RE = { 44, 0, 0 }, LS = { 174, 0, 22 }, LE = { 44, 0, 0 } },
				trail = "bothHands", fx = { { "symbols", symbols = { "♥", "❤️" }, color = ROSE_VIF, count = 3, radius = 2, at = "above" } }, hitText = "LOVE !",
			},
			-- J en l'air : plongeon glamour, bras joints devant comme pour la photo de piscine
			P_air = {
				label = "Plongeon glamour", startup = 0.1, active = 0.14, recovery = 0.18,
				damage = 7, hitbox = box(4.5, 3, 2.4, -1), kbBase = 20, kbGrowth = 32, kbAngle = -35,
				windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 6 }, RE = { 0, 0, 0 }, LS = { 170, 0, -6 }, LE = { 0, 0, 0 }, RH = { -10, 0, 0 }, RK = { -60, 0, 0 }, LH = { 10, 0, 0 }, LK = { -10, 0, 0 } },
				strike = { Root = { -40, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 4 }, RE = { 0, 0, 0 }, LS = { 150, 0, -4 }, LE = { 0, 0, 0 }, RH = { -20, 0, 0 }, RK = { -10, 0, 0 }, RA = { -30, 0, 0 }, LH = { -20, 0, 0 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
				follow = { Root = { -44, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 148, 0, 4 }, RE = { 0, 0, 0 }, LS = { 148, 0, -4 }, LE = { 0, 0, 0 }, RH = { -22, 0, 0 }, RK = { -8, 0, 0 }, RA = { -34, 0, 0 }, LH = { -22, 0, 0 }, LK = { -8, 0, 0 }, LA = { -34, 0, 0 } },
				trail = "bothHands", fx = { { "symbols", symbols = { "✨" }, color = OR, count = 3, radius = 2, at = "root" } }, hitText = "SPLASH CHIC !",
			},
			-- dash J : course aux soldes, coudes écartés, elle bouscule tout le monde
			P_dash = {
				label = "Ruée des soldes", startup = 0.08, active = 0.18, recovery = 0.24,
				damage = 7, hits = 2, hitbox = box(5, 3.5, 2.4, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 30, selfVelocity = Vector2.new(34, 0),
				windup = { Root = { -6, 0, 0, 0, -0.1, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 60, 0, 90 }, RE = { 120, 0, 0 }, LS = { 60, 0, -90 }, LE = { 120, 0, 0 } },
				strike = { Root = { -16, 20, 0, 0, -0.15, -0.35 }, Waist = { -10, 20, 0 }, Neck = { 0, -14, 0 }, RS = { 60, 0, 70 }, RE = { 130, 0, 0 }, LS = { 90, 0, -40 }, LE = { 120, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { -16, -20, 0, 0, -0.15, -0.4 }, Waist = { -10, -20, 0 }, Neck = { 0, 14, 0 }, RS = { 90, 0, 40 }, RE = { 120, 0, 0 }, LS = { 60, 0, -70 }, LE = { 130, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.4 } },
				wobble = true, trail = "body", fx = { "dust" }, text = "-70 % !", hitText = "POUSSE-TOI !",
			},
			-- K : genou de shooting, elle remonte le genou en prenant la pose, pointe tendue
			K_neutral = {
				label = "Genou de shooting", startup = 0.1, active = 0.1, recovery = 0.22,
				damage = 7, hitbox = box(4, 3, 2.3, 0.1), kbBase = 24, kbGrowth = 42, kbAngle = 45,
				windup = { Root = { 0, -8, 0, 0, -0.1, 0.1 }, Waist = { 0, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 10, 0, 40 }, RE = { 100, 0, 0 }, LS = { 10, 0, -40 }, LE = { 100, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 } },
				strike = { Root = { 6, 8, -6, 0, 0, -0.1 }, Waist = { 4, 8, 6 }, Neck = { 0, -10, 6 }, RS = { 160, 0, 10 }, RE = { 120, 0, 0 }, LS = { 10, 0, -30 }, LE = { 120, 0, 0 }, RH = { 110, 0, 0 }, RK = { -100, 0, 0 }, RA = { -30, 0, 0 } },
				follow = { Root = { 8, 10, -6, 0, 0, -0.12 }, Waist = { 6, 10, 6 }, Neck = { 0, -12, 6 }, RS = { 164, 0, 12 }, RE = { 124, 0, 0 }, LS = { 10, 0, -32 }, LE = { 122, 0, 0 }, RH = { 114, 0, 0 }, RK = { -104, 0, 0 }, RA = { -34, 0, 0 } },
				trail = "rightLeg", fx = { { "burst", color = FLASH, size = 1.6, at = "head" } }, hitText = "CLIC-CLAC !",
			},
			-- K K : son talon casse en plein coup de pied, la cheville se tord… et le pied part quand même
			K_combo2 = {
				label = "Talon cassé", startup = 0.12, active = 0.12, recovery = 0.26,
				damage = 8, hitbox = box(5, 2.5, 3, -0.3), kbBase = 26, kbGrowth = 45, kbAngle = 38,
				windup = { Root = { 0, 0, 14, 0, -0.3, 0.05 }, Waist = { 0, 0, -10 }, Neck = { 0, 0, -10 }, RS = { 40, 0, 90 }, RE = { 20, 0, 0 }, LS = { 40, 0, -90 }, LE = { 20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 }, LA = { -40, 0, 0 } },
				strike = { Root = { 10, 0, -10, 0, -0.1, -0.1 }, Waist = { 6, 0, 8 }, Neck = { -10, 0, 8 }, RS = { 70, 0, 70 }, RE = { 10, 0, 0 }, LS = { 70, 0, -70 }, LE = { 10, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 30, 0, 0 } },
				follow = { Root = { 12, 0, -12, 0, -0.1, -0.12 }, Waist = { 8, 0, 10 }, Neck = { -12, 0, 10 }, RS = { 72, 0, 72 }, RE = { 10, 0, 0 }, LS = { 72, 0, -72 }, LE = { 10, 0, 0 }, LH = { 100, 0, 0 }, LK = { 0, 0, 0 }, LA = { 34, 0, 0 } },
				wobble = true, trail = "leftFoot", fx = { { "toss", shape = "cyl", color = ROSE_VIF, size = 0.5, count = 1, speed = 20 } }, text = "MON LOUBOUTIN !", hitText = "CRAC !",
			},
			-- →K : pointe de pied vernie, jambe tendue comme sur le podium
			K_side = {
				label = "Pointe vernie", startup = 0.12, active = 0.12, recovery = 0.26,
				damage = 8, hitbox = box(5.5, 2.5, 3.3, 0), kbBase = 26, kbGrowth = 48, kbAngle = 28, selfVelocity = Vector2.new(14, 0),
				windup = { Root = { 0, -14, 0, 0, -0.1, 0.15 }, Waist = { 0, -14, 0 }, Neck = { 0, 14, 0 }, RS = { 20, 0, 50 }, RE = { 110, 0, 0 }, LS = { 20, 0, -50 }, LE = { 110, 0, 0 }, RH = { 40, 0, 0 }, RK = { -100, 0, 0 } },
				strike = { Root = { 10, 6, 0, 0, -0.05, 0 }, Waist = { 8, 6, 0 }, Neck = { 0, -8, 0 }, RS = { 40, 0, 100 }, RE = { 0, 0, 0 }, LS = { 40, 0, -100 }, LE = { 0, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 40, 0, 0 } },
				follow = { Root = { 12, 8, 0, 0, -0.05, -0.02 }, Waist = { 10, 8, 0 }, Neck = { 0, -10, 0 }, RS = { 42, 0, 104 }, RE = { 0, 0, 0 }, LS = { 42, 0, -104 }, LE = { 0, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 44, 0, 0 } },
				trail = "rightLeg", fx = { { "particles", tex = "spark", color = ROSE_VIF, dir = "front", at = "feet", time = 0.25, speed = 8, size = 0.4, rate = 40 } }, hitText = "PODIUM !",
			},
			-- ↓K : elle tourne sur elle-même accroupie, la jambe tendue balaie comme une traîne de robe
			K_down = {
				label = "Traîne de robe", startup = 0.12, active = 0.14, recovery = 0.28,
				damage = 7, hitbox = box(6, 2, 2.6, -1.6), kbBase = 24, kbGrowth = 40, kbAngle = 72,
				windup = { Root = { 0, 30, 0, 0, -0.6, 0.05 }, Waist = { -10, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 30, 0, 70 }, RE = { 30, 0, 0 }, LS = { 30, 0, -70 }, LE = { 30, 0, 0 } },
				strike = { Root = { 0, -20, 0, 0, -1.0, 0 }, Waist = { -10, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 80, 0, 90 }, RE = { 0, 0, 0 }, LS = { 0, 0, -60 }, LE = { 30, 0, 0 }, RH = { 80, 0, 30 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { 0, -30, 0, 0, -1.0, 0 }, Waist = { -10, -14, 0 }, Neck = { 0, 12, 0 }, RS = { 82, 0, 92 }, RE = { 0, 0, 0 }, LS = { 0, 0, -62 }, LE = { 30, 0, 0 }, RH = { 84, 0, 30 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "rightLeg", fx = { "dust" }, hitText = "FROUFROU !",
			},
			-- ↓K K : elle se relève d'un pivot de podium, le talon arrière remonte dans le menton
			downKK_combo = {
				label = "Pivot de podium", startup = 0.1, active = 0.12, recovery = 0.3,
				damage = 9, hitbox = box(4.5, 4.5, 2, 1.8), kbBase = 28, kbGrowth = 52, kbAngle = 75,
				windup = { Root = { 0, 40, 0, 0, -0.8, 0 }, Waist = { -10, 20, 0 }, Neck = { 0, -20, 0 }, RS = { 20, 0, 60 }, RE = { 60, 0, 0 }, LS = { 20, 0, -60 }, LE = { 60, 0, 0 } },
				strike = { Root = { 20, -40, 0, 0, 0.1, -0.1 }, Waist = { 10, -20, 0 }, Neck = { -10, 20, 0 }, RS = { 120, 0, 60 }, RE = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 0, 0, 0 }, RH = { 140, 0, 10 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { 22, -46, 0, 0, 0.12, -0.12 }, Waist = { 12, -22, 0 }, Neck = { -12, 22, 0 }, RS = { 124, 0, 62 }, RE = { 0, 0, 0 }, LS = { 124, 0, -62 }, LE = { 0, 0, 0 }, RH = { 146, 0, 10 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 } },
				trail = "rightFoot", fx = { { "burst", color = FLASH, size = 2, at = "above" } }, text = "ET… POSE !", hitText = "TOP MODEL !",
			},
			-- ↑K : la pose du flamant rose, genou haut puis pointe qui jaillit vers le ciel
			K_up = {
				label = "Flamant rose", startup = 0.12, active = 0.12, recovery = 0.28,
				damage = 8, hitbox = box(4, 5.5, 1.4, 2.8), kbBase = 26, kbGrowth = 50, kbAngle = 87,
				windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 10, 0, 50 }, RE = { 120, 0, 0 }, LS = { 10, 0, -50 }, LE = { 120, 0, 0 }, RH = { 110, 0, 0 }, RK = { -130, 0, 0 } },
				strike = { Root = { 14, 0, 0, 0, 0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 40 }, RE = { 30, 0, 0 }, LS = { 160, 0, -40 }, LE = { 30, 0, 0 }, RH = { 160, 0, 0 }, RK = { -4, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { 16, 0, 0, 0, 0.12, 0.12 }, Waist = { 12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 164, 0, 42 }, RE = { 32, 0, 0 }, LS = { 164, 0, -42 }, LE = { 32, 0, 0 }, RH = { 166, 0, 0 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 } },
				trail = "rightFoot", fx = { { "symbols", symbols = { "🦩" }, color = ROSE, count = 1, radius = 1, at = "above" } }, hitText = "FLAMINGO !",
			},
			-- K en l'air : saut de joie d'unboxing, les jambes ramenées puis lancées en ciseaux
			K_air = {
				label = "Saut d'unboxing", startup = 0.1, active = 0.16, recovery = 0.2,
				damage = 8, hits = 2, hitbox = box(5, 3.5, 2.2, -0.6), kbBase = 22, kbGrowth = 40, kbAngle = 40,
				windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 160, 0, 30 }, RE = { 30, 0, 0 }, LS = { 160, 0, -30 }, LE = { 30, 0, 0 }, RH = { -20, 0, 0 }, RK = { -120, 0, 0 }, LH = { -20, 0, 0 }, LK = { -120, 0, 0 } },
				strike = { Root = { 10, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 150, 0, 60 }, RE = { 10, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { -4, 0, 0 }, RA = { 30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -40, 0, 0 } },
				follow = { Root = { 12, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 150, 0, 64 }, RE = { 10, 0, 0 }, LS = { 150, 0, -64 }, LE = { 10, 0, 0 }, RH = { 30, 0, 0 }, RK = { -40, 0, 0 }, LH = { 90, 0, 0 }, LK = { -4, 0, 0 }, LA = { 30, 0, 0 } },
				trail = "rightFoot", fx = { { "symbols", symbols = { "📦", "✨" }, color = OR, count = 3, radius = 2, at = "root" } }, hitText = "UNBOXING !",
			},
			-- dash K : glissade sur le tapis rouge, un pied loin devant, l'autre bras sur la hanche
			K_dash = {
				label = "Glissade tapis rouge", startup = 0.1, active = 0.22, recovery = 0.3,
				damage = 8, hitbox = box(6, 2.2, 3, -1.2), kbBase = 28, kbGrowth = 50, kbAngle = 42, selfVelocity = Vector2.new(46, 0),
				windup = { Root = { 0, -10, 0, 0, -0.3, 0.1 }, Waist = { 0, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 30, 0, 40 }, RE = { 110, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 } },
				strike = { Root = { 20, 0, 0, 0, -1.0, -0.2 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 140, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 }, RH = { 85, 0, 4 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -100, 0, 0 } },
				follow = { Root = { 22, 0, 0, 0, -1.02, -0.24 }, Waist = { -12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 144, 0, 22 }, RE = { 0, 0, 0 }, LS = { 20, 0, -42 }, LE = { 112, 0, 0 }, RH = { 88, 0, 4 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 }, LH = { 22, 0, 0 }, LK = { -102, 0, 0 } },
				trail = "rightFoot", fx = { { "puddle", color = ROSE_VIF, width = 7 } }, hitText = "RED CARPET !",
			},
		},
		-- Combos à mains nues : J J K (pichenette, griffe, hair flip), → J J (parle à ma main puis gifle de diva),
		-- K J (bisou volant), K K (talon cassé), ↓K K (traîne de robe puis pivot de podium). S envoie son spécial.
		links = {
			P_neutral = { P = "P_combo2", K = "K_neutral", S = "S_neutral" },
			P_combo2 = { K = "PPK_combo", P = "P_side", S = "S_side" },
			PPK_combo = { S = "S_up" },
			P_side = { P = "sidePP_combo", K = "K_side", S = "S_side" },
			sidePP_combo = { K = "K_up", S = "S_neutral" },
			K_neutral = { P = "KP_combo", K = "K_combo2", S = "S_neutral" },
			KP_combo = { P = "P_up", K = "K_side", S = "S_side" },
			K_combo2 = { P = "P_combo2", K = "K_up", S = "S_down" },
			K_side = { P = "KP_combo", S = "S_side" },
			P_down = { P = "P_up", K = "K_down", S = "S_down" },
			K_down = { K = "downKK_combo", P = "P_up", S = "S_down" },
			downKK_combo = { S = "S_up" },
			P_up = { K = "K_up", S = "S_up" },
			K_up = { S = "S_up" },
			P_dash = { P = "sidePP_combo", K = "K_combo2", S = "S_side" },
			K_dash = { P = "KP_combo", K = "downKK_combo", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la perche à selfie (ses coups sont ceux de moves). n° 2 : le sèche-cheveux turbo, jeu de souffles et de
	-- projectiles d'air chaud (un saut de plus). n° 3 : le sac à main de luxe, lourd, bourré d'affaires, qui éjecte loin.
	weapons = {
		{ id = "perche", name = "Perche à selfie", icon = "🤳",
			ability = { reach = 1.15, text = "Perche télescopique : portée de tous les coups +15 %" } },
		{ id = "seche_cheveux", name = "Sèche-cheveux turbo", icon = "💨",
			prop = { name = "PropSeche", hand = "Right", pieces = {
				{ "Poignee", "", "block", Vector3.new(0.32, 0.95, 0.42), Vector3.new(0, -0.45, 0.05), Vector3.zero, ROSE_VIF, "SmoothPlastic" },
				{ "Corps", "", "cyl", Vector3.new(0.72, 0.72, 1.5), Vector3.new(0, -1.05, -0.35), Vector3.zero, ROSE_VIF, "SmoothPlastic", { axis = "z" } },
				{ "Embout", "", "cyl", Vector3.new(0.5, 0.5, 0.6), Vector3.new(0, -1.05, -1.35), Vector3.zero, ARGENT, "Metal", { axis = "z" } },
				{ "Grille", "", "cyl", Vector3.new(0.76, 0.76, 0.16), Vector3.new(0, -1.05, 0.45), Vector3.zero, NOIR, "SmoothPlastic", { axis = "z" } },
				{ "Bouton", "", "ball", Vector3.new(0.18, 0.18, 0.18), Vector3.new(-0.2, -0.5, -0.1), Vector3.zero, OR, "Metal" },
			} },
			ability = { jumps = 1, text = "Air chaud : un saut en l'air de plus" },
			moves = {
				-- J : coup de sèche-cheveux, un petit coup sec de l'embout sur le front, hanche sortie
				P_neutral = {
					label = "Coup de sèche-cheveux", startup = 0.07, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(4.5, 3, 2.6, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 28,
					windup = { Root = { 2, -12, 4, 0, -0.12, 0.1 }, Waist = { 2, -14, -6 }, Neck = { 4, 10, 0 }, RS = { 70, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 } },
					strike = { Root = { -4, 10, -4, 0, -0.2, -0.2 }, Waist = { -4, 12, 6 }, Neck = { 0, -8, 0 }, RS = { 92, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 } },
					follow = { Root = { -6, 12, -4, 0, -0.22, -0.24 }, Waist = { -6, 14, 6 }, Neck = { 0, -10, 0 }, RS = { 94, 0, -2 }, RE = { 12, 0, 0 }, RW = { -6, 0, 0 }, LS = { 10, 0, -46 }, LE = { 115, 0, 0 } },
					trail = "prop", hitText = "TOC !",
				},
				-- →J : souffle chaud, une bouffée d'air brûlant à bout portant, cheveux d'en face en pétard
				P_side = {
					label = "Souffle chaud", kind = "projectile", startup = 0.08, active = 0, recovery = 0.18,
					damage = 6, kbBase = 22, kbGrowth = 34, kbAngle = 25,
					projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 0.3, size = 1.6, color = CHAUD, aim = false,
						visual = { shape = "ball", size = 1.4, color = CHAUD, transparency = 0.4, trail = false, parts = { { "ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0.6, 0.3, 0), CHAUD } } } },
					windup = { Root = { 4, -16, 0, 0, -0.15, 0.15 }, Waist = { 4, -14, 0 }, Neck = { 0, 12, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 } },
					strike = { Root = { -8, 14, 0, 0, -0.28, -0.3 }, Waist = { -6, 16, 0 }, Neck = { 4, -12, 0 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -35 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, 16, 0, 0, -0.3, -0.34 }, Waist = { -8, 18, 0 }, Neck = { 6, -14, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -36 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					fx = { { "particles", tex = "smoke", color = CHAUD, dir = "front", at = "hand", time = 0.25, speed = 18, size = 0.5, rate = 60 } }, hitText = "FSHHH !",
				},
				-- ↓J : sèche-chaussettes, accroupie, elle souffle sur les pieds d'en face qui décollent du sol
				P_down = {
					label = "Sèche-chaussettes", startup = 0.08, active = 0.12, recovery = 0.16,
					damage = 5, hitbox = box(6, 2, 3.5, -1.6), kbBase = 20, kbGrowth = 26, kbAngle = 72,
					windup = { Root = { 6, -10, 0, 0, -0.8, 0.1 }, Waist = { 10, -10, 0 }, Neck = { 10, 8, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { 10, 8, 0, 0, -0.95, -0.15 }, Waist = { 16, 10, 0 }, Neck = { 14, -6, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 10, 10, 0, 0, -0.95, -0.18 }, Waist = { 16, 12, 0 }, Neck = { 14, -8, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { 24, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = CHAUD, dir = "front", at = "feet", time = 0.3, speed = 14, size = 0.5, rate = 50 }, "dust" }, hitText = "FSHT !",
				},
				-- ↑J : brushing au plafond, le sèche-cheveux braqué vers le ciel, l'air chaud soulève ce qui passe
				P_up = {
					label = "Brushing au plafond", startup = 0.08, active = 0.14, recovery = 0.18,
					damage = 6, hitbox = box(4.5, 6, 1, 3.8), kbBase = 26, kbGrowth = 30, kbAngle = 87,
					windup = { Root = { -4, 0, 0, 0, -0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 } },
					strike = { Root = { 4, 8, 4, 0, 0.1, 0 }, Waist = { 8, 8, 6 }, Neck = { 26, 0, 0 }, RS = { 178, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					follow = { Root = { 6, 10, 6, 0, 0.12, 0 }, Waist = { 10, 10, 8 }, Neck = { 30, 0, 4 }, RS = { 182, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -46 }, LE = { 115, 0, 0 }, FR = { 0, 0, 0, 0, 0.22, 0 }, FL = { 0, 0, 0, 0, 0.22, 0 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = CHAUD, dir = "up", at = "hand", time = 0.3, speed = 16, size = 0.5, rate = 60 } }, text = "VOLUME !", hitText = "SOULEVÉ !",
				},
				-- J en l'air : souffle plongeant, elle braque le sèche-cheveux vers le sol et crache un souffle sous elle
				P_air = {
					label = "Souffle plongeant", kind = "projectile", startup = 0.08, active = 0, recovery = 0.16,
					damage = 6, kbBase = 20, kbGrowth = 32, kbAngle = -40,
					projectile = { speed = 55, angle = -60, gravity = 0, lifetime = 0.35, size = 1.6, color = CHAUD, aim = false,
						visual = { shape = "ball", size = 1.3, color = CHAUD, transparency = 0.4, trail = false } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -12, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 24, 0, 12 }, RE = { 4, 0, 0 }, RW = { 0, 0, 0 }, LS = { 26, 0, -42 }, LE = { 60, 0, 0 }, RH = { 26, 0, 0 }, RK = { -46, 0, 0 }, LH = { 36, 0, 0 }, LK = { -66, 0, 0 } },
					fx = { { "particles", tex = "smoke", color = CHAUD, dir = "down", at = "hand", time = 0.25, speed = 16, size = 0.5, rate = 50 } }, hitText = "FSHHH !",
				},
				-- dash J : brushing en courant, elle fonce en se coiffant, le sèche-cheveux brûlant devant elle
				P_dash = {
					label = "Brushing en courant", startup = 0.08, active = 0.14, recovery = 0.22,
					damage = 7, hitbox = box(5, 3.5, 3, 0.8), kbBase = 26, kbGrowth = 46, kbAngle = 28, selfVelocity = Vector2.new(40, 0),
					windup = { Root = { -6, -10, 0, 0, -0.2, 0.1 }, Waist = { -4, -10, 0 }, Neck = { 0, 8, -8 }, RS = { 120, 0, 40 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 120, 0, 0 } },
					strike = { Root = { -14, 8, 0, 0, -0.3, -0.3 }, Waist = { -8, 8, 0 }, Neck = { 8, -6, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -20 }, LE = { 120, 0, 0 } },
					follow = { Root = { -16, 10, 0, 0, -0.32, -0.34 }, Waist = { -8, 10, 0 }, Neck = { 10, -8, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 162, 0, -22 }, LE = { 120, 0, 0 } },
					trail = "prop", fx = { "dust", { "particles", tex = "smoke", color = CHAUD, dir = "front", at = "hand", time = 0.3, speed = 16, size = 0.5, rate = 50 } }, text = "ATTENTION, ÇA CHAUFFE !", hitText = "GRILLÉ !",
				},
				-- K : talon brûlant, elle se sèche la semelle d'un coup de souffle et décoche un coup de talon fumant
				K_neutral = {
					label = "Talon brûlant", startup = 0.17, active = 0.1, recovery = 0.28,
					damage = 11, hitbox = box(5, 3.5, 3, 0.5), kbBase = 30, kbGrowth = 68, kbAngle = 35,
					windup = { Root = { 6, -10, 0, 0, -0.15, 0.1 }, Waist = { 8, -8, 0 }, Neck = { 6, 6, 0 }, RS = { 40, 0, 30 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 } },
					strike = { Root = { 16, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 30, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { 18, 0, 0, 0, -0.1, 0.14 }, Waist = { 14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 32, 0, 52 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 32, 0, -62 }, LE = { 40, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
					trail = "rightFoot", fx = { { "particles", tex = "smoke", color = CHAUD, dir = "front", at = "feet", time = 0.2, speed = 10, size = 0.4, rate = 40 } }, hitText = "TSSS !",
				},
				-- →K : pivot soufflant, elle tourne sur elle-même sèche-cheveux à bout de bras, la jambe suit en fouetté
				K_side = {
					label = "Pivot soufflant", startup = 0.18, active = 0.12, recovery = 0.3,
					damage = 12, hitbox = box(6, 3.5, 3.4, 0.6), kbBase = 32, kbGrowth = 76, kbAngle = 30, selfVelocity = Vector2.new(20, 0),
					windup = { Root = { 6, 36, 0, 0, -0.2, 0.1 }, Waist = { 8, 40, 0 }, Neck = { 0, -30, 0 }, RS = { 80, 0, 70 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 } },
					strike = { Root = { 10, -40, 0, 0, -0.1, -0.1 }, Waist = { 10, -50, 0 }, Neck = { 0, 30, 0 }, RS = { 90, 0, 80 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 100, 0, 20 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 12, -50, 0, 0, -0.1, -0.14 }, Waist = { 12, -60, 0 }, Neck = { 0, 36, 0 }, RS = { 92, 0, 84 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -54 }, LE = { 40, 0, 0 }, RH = { 108, 0, 24 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "rightFoot", fx = { { "ring", color = CHAUD, radius = 4, at = "root" } }, text = "PIVOT !", hitText = "VLAN !",
				},
				-- ↓K : balayage à air chaud, accroupie, le souffle soulève la poussière et la jambe fauche les chevilles
				K_down = {
					label = "Balayage à air chaud", startup = 0.15, active = 0.16, recovery = 0.3,
					damage = 11, hitbox = box(7, 2, 2, -1.8), kbBase = 28, kbGrowth = 58, kbAngle = 76,
					windup = { Root = { -6, -24, 0, 0, -0.9, 0.1 }, Waist = { -10, -16, 0 }, Neck = { 0, 16, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, RH = { 60, 0, 30 }, RK = { -120, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, -1.0, -0.1 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 30, 0, 0 }, LS = { 20, 0, -70 }, LE = { 90, 0, 0 }, RH = { 76, 0, 12 }, RK = { -4, 0, 0 }, RA = { -20, 0, 0 } },
					follow = { Root = { -8, 0, 0, 0, -1.0, -0.12 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 18, 0, 12 }, RE = { 0, 0, 0 }, RW = { 34, 0, 0 }, LS = { 18, 0, -72 }, LE = { 90, 0, 0 }, RH = { 74, 0, 12 }, RK = { -6, 0, 0 }, RA = { -20, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "rightFoot", fx = { "dust", { "ring", color = CHAUD, radius = 4, at = "feet" } }, text = "ON BALAIE !", hitText = "ZOUIP !",
				},
				-- ↑K : jet vertical, le sèche-cheveux braqué au sol la propulse et son talon monte dans le menton
				K_up = {
					label = "Jet vertical", startup = 0.16, active = 0.14, recovery = 0.3,
					damage = 11, hitbox = box(4.5, 5.5, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 87, selfVelocity = Vector2.new(0, 34),
					windup = { Root = { 2, 0, 0, 0, -0.5, 0 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -20, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -6, 0, 0, 0, 0.4, 0 }, Waist = { -4, 0, 0 }, Neck = { 24, 0, 0 }, RS = { -40, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -8, 0, 0, 0, 0.45, 0 }, Waist = { -6, 0, 0 }, Neck = { 28, 0, 0 }, RS = { -44, 0, 22 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 154, 0, -44 }, LE = { 20, 0, 0 }, RH = { 158, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 24, 0, 0 }, LK = { -64, 0, 0 } },
					trail = "rightLeg", fx = { { "particles", tex = "smoke", color = CHAUD, dir = "down", at = "hand", time = 0.35, speed = 18, size = 0.6, rate = 70 } }, text = "TURBO !", hitText = "TCHAK !",
				},
				-- K en l'air : talon turbo, le souffle dans le dos la pousse en avant et le talon compensé part à l'horizontale
				K_air = {
					label = "Talon turbo", startup = 0.14, active = 0.14, recovery = 0.24,
					damage = 12, hitbox = box(5.5, 3.5, 3, 0), kbBase = 30, kbGrowth = 70, kbAngle = 36, selfVelocity = Vector2.new(22, 0),
					windup = { Root = { -10, 20, 0 }, Waist = { -10, 10, 0 }, Neck = { 0, -10, 0 }, RS = { -40, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 70, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { 24, 20, 0 }, Waist = { 10, 5, 0 }, Neck = { -12, 0, 0 }, RS = { -60, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { 28, 22, 0 }, Waist = { 12, 5, 0 }, Neck = { -14, 0, 0 }, RS = { -64, 0, 32 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 42, 0, -72 }, LE = { 30, 0, 0 }, RH = { 74, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 16, 0, 0 }, LK = { -106, 0, 0 } },
					trail = "rightFoot", fx = { { "particles", tex = "smoke", color = CHAUD, dir = "front", at = "hand", time = 0.3, speed = 16, size = 0.5, rate = 60 } }, hitText = "CLAC !",
				},
				-- dash K : propulsion sèche-cheveux, le souffle braqué derrière elle la catapulte en coup de pied volant
				K_dash = {
					label = "Propulsion sèche-cheveux", startup = 0.1, active = 0.22, recovery = 0.3,
					damage = 12, hitbox = box(6, 3.5, 3, 0.3), kbBase = 32, kbGrowth = 68, kbAngle = 32, selfVelocity = Vector2.new(56, 10),
					windup = { Root = { -8, 0, 0, 0, -0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -40, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 12, 0, 0 }, RS = { -70, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -70 }, LE = { 10, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -50, 0, 0 }, LK = { -20, 0, 0 } },
					follow = { Root = { -4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 14, 0, 0 }, RS = { -74, 0, 32 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 104, 0, -74 }, LE = { 10, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -54, 0, 0 }, LK = { -20, 0, 0 } },
					trail = "rightFoot", fx = { { "particles", tex = "smoke", color = CHAUD, dir = "front", at = "root", time = 0.35, speed = 20, size = 0.7, rate = 80 }, "dust" }, text = "FUSÉE !", hitText = "SBAM !",
				},
				-- L : grand souffle, le sèche-cheveux à deux mains comme une lance à incendie : un cône d'air chaud traverse le couloir
				S_neutral = {
					label = "Grand souffle", kind = "projectile", startup = 0.22, active = 0, recovery = 0.46,
					damage = 14, kbBase = 40, kbGrowth = 62, kbAngle = 22,
					projectile = { speed = 72, angle = 0, gravity = 0, lifetime = 0.8, size = 3, color = CHAUD, pierce = true,
						visual = { shape = "ball", size = 2.4, color = CHAUD, transparency = 0.35, parts = { { "ball", Vector3.new(1.6, 1.6, 1.6), Vector3.new(-1.2, 0.4, 0), CHAUD }, { "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(-2.2, -0.3, 0), CHAUD } } } },
					windup = { Root = { 6, -14, 0, 0, -0.25, 0.2 }, Waist = { 8, -16, 0 }, Neck = { 6, 12, 0 }, RS = { 50, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 10, 0, 0, -0.32, -0.4 }, Waist = { -14, 12, 0 }, Neck = { -4, -8, 0 }, RS = { 96, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -2 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -14, 12, 0, 0, -0.34, -0.45 }, Waist = { -16, 14, 0 }, Neck = { -6, -10, 0 }, RS = { 100, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					shake = true, windupFx = { { "symbols", symbols = { "💨" }, count = 2, radius = 2, at = "hand", color = CHAUD } },
					fx = { { "beam", color = CHAUD, length = 14, width = 3, at = "hand" }, { "particles", tex = "smoke", color = CHAUD, dir = "front", at = "hand", time = 0.4, speed = 26, size = 0.8, rate = 100 } },
					text = "GRAND SOUFFLE !", hitText = "DÉCOIFFÉ !",
				},
				-- →L : tornade de boucles, un tourbillon d'air chaud qui tourne sur lui-même et poursuit l'adversaire
				S_side = {
					label = "Tornade de boucles", kind = "projectile", startup = 0.24, active = 0, recovery = 0.48,
					damage = 14, kbBase = 30, kbGrowth = 56, kbAngle = 60,
					projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 1.0, size = 2.6, color = CHAUD, homing = 0.5,
						visual = { shape = "cyl", size = 2.6, color = CHAUD, transparency = 0.3, spin = 20, parts = { { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, 1.0, 0.9), CHEVEUX }, { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, -0.8, -0.9), CHEVEUX } } } },
					windup = { Root = { 4, -24, 0, 0, -0.2, 0.15 }, Waist = { 6, -28, 0 }, Neck = { 4, 20, 0 }, RS = { 60, 0, 50 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.38 }, Waist = { -14, 22, 0 }, Neck = { -4, -14, 0 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					follow = { Root = { -14, 22, 0, 0, -0.32, -0.42 }, Waist = { -16, 26, 0 }, Neck = { -6, -16, 0 }, RS = { 98, 0, -6 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 26, 0, -48 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					spin = { axis = "y", degrees = 360 }, fx = { { "ring", color = CHAUD, radius = 4, at = "front" }, { "symbols", symbols = { "🌪️", "💇" }, count = 3, radius = 2.5, at = "front", color = CHAUD } },
					text = "TORNADE !", hitText = "FRISÉ !",
				},
				-- ↓L : mode froid, elle bascule le bouton et souffle une nappe d'air glacé au sol qui reste un moment
				S_down = {
					label = "Mode froid", kind = "projectile", startup = 0.22, active = 0, recovery = 0.48,
					damage = 12, kbBase = 20, kbGrowth = 36, kbAngle = 45,
					status = { name = "frozen", duration = 1 },
					projectile = { speed = 48, angle = 0, gravity = 0, lifetime = 0.8, size = 3, color = GIVRE, linger = 1.5, from = "feet",
						visual = { shape = "ball", size = 2.4, color = GIVRE, transparency = 0.35, neon = true, parts = { { "ball", Vector3.new(1.4, 1.4, 1.4), Vector3.new(1.2, 0.2, 0), GIVRE }, { "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(-1.2, 0.2, 0.4), GIVRE } } } },
					windup = { Root = { 6, 0, 0, 0, -0.5, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 40 } },
					strike = { Root = { 12, 0, 0, 0, -0.9, -0.2 }, Waist = { 24, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 30, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 14, 0, 0, 0, -0.92, -0.24 }, Waist = { 26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { 34, 0, 0 }, LS = { 36, 0, -42 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", windupFx = { { "text", text = "CLIC : FROID", color = GIVRE, at = "hand" } }, fx = { { "puddle", color = GIVRE, width = 8 }, { "particles", tex = "smoke", color = GIVRE, dir = "front", at = "feet", time = 0.4, speed = 18, size = 0.7, rate = 70 } },
					text = "BRRR !", hitText = "GELÉ !",
				},
				-- ↑L : décollage brushing, le sèche-cheveux braqué vers le sol à pleine puissance l'emporte en diagonale, cheveux au vent
				S_up = {
					label = "Décollage brushing", startup = 0.15, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 72, selfVelocity = Vector2.new(44, 84),
					windup = { Root = { 4, 0, 0, 0, -0.65, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { -20, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -38, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { -40, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -40 }, LE = { 20, 0, 0 }, RH = { -22, 0, 6 }, RK = { -35, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -6 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -42, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { -44, 0, 22 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 164, 0, -44 }, LE = { 20, 0, 0 }, RH = { -30, 0, 8 }, RK = { -45, 0, 0 }, RA = { -30, 0, 0 }, LH = { -42, 0, -8 }, LK = { -60, 0, 0 }, LA = { -30, 0, 0 } },
					trail = "body", fx = { { "ring", color = CHAUD, radius = 5, at = "feet" }, { "particles", tex = "smoke", color = CHAUD, dir = "down", at = "hand", time = 0.5, speed = 22, size = 0.8, rate = 90 }, { "symbols", symbols = { "💇", "✨" }, count = 3, radius = 2 } },
					text = "DÉCOLLAGE !", hitText = "SOUFFLÉ !",
				},
				-- L en l'air : rafale d'air chaud, trois bouffées lâchées en éventail sous elle, qui foncent sur l'adversaire
				S_air = {
					label = "Rafale d'air chaud", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
					damage = 5, kbBase = 22, kbGrowth = 40, kbAngle = -30,
					projectile = { speed = 70, angle = -30, gravity = 0, lifetime = 0.7, size = 1.6, color = CHAUD, fan = { count = 3, from = -12, to = 12 },
						visual = { shape = "ball", size = 1.3, color = CHAUD, transparency = 0.35, trail = false } },
					windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 20 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -12, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 44, 0, 12 }, RE = { 4, 0, 0 }, RW = { 0, 0, 0 }, LS = { 26, 0, -42 }, LE = { 60, 0, 0 }, RH = { 26, 0, 0 }, RK = { -46, 0, 0 }, LH = { 36, 0, 0 }, LK = { -66, 0, 0 } },
					fx = { { "burst", color = CHAUD, size = 2, at = "hand" } }, text = "RAFALE !", hitText = "FSH-FSH-FSH !",
				},
				-- Y : tempête de chaleur, le sèche-cheveux poussé en mode sauna : une vague d'air brûlant traverse le couloir et fait fondre les coiffures
				SUPER = {
					label = "Tempête de chaleur !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 46, kbGrowth = 94, kbAngle = 30, burn = true,
					projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 1.1, size = 6, color = CHAUD, pierce = true,
						visual = { shape = "ball", size = 4.5, color = CHAUD, transparency = 0.3, neon = true, parts = { { "ball", Vector3.new(3, 3, 3), Vector3.new(-2.5, 0.8, 0), CHAUD }, { "ball", Vector3.new(2.4, 2.4, 2.4), Vector3.new(-4, -0.6, 0.5), CHAUD }, { "ball", Vector3.new(1.4, 1.4, 1.4), Vector3.new(1.8, 1.2, 0), Color3.fromRGB(255, 240, 180) } } } },
					windup = { Root = { 6, -14, 0, 0, -0.3, 0.2 }, Waist = { 10, -16, 0 }, Neck = { 8, 12, 0 }, RS = { 50, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 40 } },
					strike = { Root = { -16, 10, 0, 0, -0.36, -0.5 }, Waist = { -18, 12, 0 }, Neck = { -6, -8, 0 }, RS = { 96, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -2 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { -18, 12, 0, 0, -0.38, -0.55 }, Waist = { -22, 14, 0 }, Neck = { -8, -10, 0 }, RS = { 100, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.58 } },
					hold = 0.2, shake = true, windupFx = { "super", { "text", text = "MODE SAUNA", color = CHAUD, at = "hand" } },
					fx = { { "beam", color = CHAUD, length = 18, width = 6, at = "hand" }, { "particles", tex = "fire", color = CHAUD, dir = "front", at = "hand", time = 0.6, speed = 30, size = 1.2, rate = 120 }, { "screen", color = CHAUD, alpha = 0.25 }, { "shake", amount = 0.45 } },
					text = "ÇA VA CHAUFFER !", hitText = "CRAMÉ !",
				},
				-- →Y : ouragan capillaire, elle lance le sèche-cheveux qui tourne sur lui-même : un ouragan qui traverse le couloir et revient
				SUPER_side = {
					label = "Ouragan capillaire !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 44, kbGrowth = 90, kbAngle = 70,
					status = { name = "slowed", duration = 2 },
					projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 1.0, size = 4.5, color = CHAUD, pierce = true, returns = true,
						visual = { shape = "cyl", size = 4.5, color = CHAUD, transparency = 0.3, spin = 24, parts = { { "block", Vector3.new(0.4, 1.0, 0.5), Vector3.new(0, 0, 0), ROSE_VIF }, { "cyl", Vector3.new(1.4, 0.7, 0.7), Vector3.new(0, 0, -0.6), ROSE_VIF }, { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(1.4, 1.2, 0), CHEVEUX }, { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-1.4, -1.2, 0), CHEVEUX } } } },
					windup = { Root = { 4, -36, 0, 0, -0.3, 0.2 }, Waist = { 6, -40, 0 }, Neck = { 6, 26, 0 }, RS = { 170, 0, 40 }, RE = { 30, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -16, 24, 0, 0, -0.36, -0.5 }, Waist = { -18, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { 2, 0, 0, 0, -0.25, 0 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					spin = { axis = "y", degrees = 720 }, shake = true, hideProp = "seche", windupFx = { "super", { "symbols", symbols = { "🌪️", "💇", "💨" }, count = 5, radius = 3, color = CHAUD } },
					fx = { { "ring", color = CHAUD, radius = 6, at = "front" }, { "burst", color = ROSE_VIF, size = 3, at = "hand" }, { "shake", amount = 0.4 } },
					text = "OURAGAN !", hitText = "PERMANENTE !",
				},
				-- ↑Y : montgolfière, le sèche-cheveux braqué au sol gonfle une bulle d'air chaud sous tout le couloir : tout le monde monte au plafond
				SUPER_up = {
					label = "Montgolfière !", startup = 0.36, active = 0.34, recovery = 0.7,
					damage = 24, hitbox = box(14, 12, 7, 4), kbBase = 46, kbGrowth = 94, kbAngle = 88, invuln = 0.3, selfVelocity = Vector2.new(0, 58),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -30, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 2, 0, 0, 0, 0.5, 0 }, Waist = { 6, 0, 0 }, Neck = { 40, 0, 0 }, RS = { -50, 0, 24 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -20 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -80, 0, 0 }, LH = { 40, 0, -10 }, LK = { -80, 0, 0 } },
					follow = { Root = { 4, 0, 0, 0, 0.55, 0 }, Waist = { 8, 0, 0 }, Neck = { 44, 0, 0 }, RS = { -54, 0, 26 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 184, 0, -22 }, LE = { 0, 0, 0 }, RH = { 50, 0, 12 }, RK = { -90, 0, 0 }, LH = { 50, 0, -12 }, LK = { -90, 0, 0 } },
					hold = 0.25, shake = true, trail = "body", windupFx = { "super", { "text", text = "PLEINE PUISSANCE…", color = CHAUD } },
					fx = { { "pillar", color = CHAUD, height = 24, width = 8, at = "front" }, { "ring", color = CHAUD, radius = 9, at = "feet" }, { "particles", tex = "fire", color = CHAUD, dir = "down", at = "hand", time = 0.6, speed = 24, size = 1, rate = 110 }, { "symbols", symbols = { "🎈", "💨" }, count = 6, radius = 4, color = ROSE }, { "shake", amount = 0.4 } },
					text = "ET ON S'ENVOLE !", hitText = "MONTGOLFIÈRE !",
				},
				-- ↓Y : chaud-froid, elle alterne les deux modes à toute vitesse au ras du sol : tout le couloir gèle, dégèle, regèle…
				SUPER_down = {
					label = "Chaud-froid !", startup = 0.38, active = 0.5, recovery = 0.7,
					damage = 4, hits = 6, hitbox = box(14, 5, 7, 0.5), kbBase = 18, kbGrowth = 26, kbAngle = 60,
					status = { name = "frozen", duration = 1.5 },
					windup = { Root = { 8, -20, 0, 0, -0.85, 0.1 }, Waist = { 12, -24, 0 }, Neck = { 8, 16, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 40 } },
					strike = { Root = { 8, 30, 0, 0, -0.95, -0.2 }, Waist = { 12, 34, 0 }, Neck = { 8, -24, 0 }, RS = { 36, 0, -20 }, RE = { 0, 0, 0 }, RW = { 30, 0, 0 }, LS = { 110, 0, 20 }, LE = { 130, 0, 0 }, LW = { 0, 0, 40 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 8, -30, 0, 0, -0.95, -0.2 }, Waist = { 12, -34, 0 }, Neck = { 8, 24, 0 }, RS = { 36, 0, 40 }, RE = { 0, 0, 0 }, RW = { 30, 0, 0 }, LS = { 110, 0, 20 }, LE = { 130, 0, 0 }, LW = { 0, 0, 40 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					wobble = true, shake = true, trail = "prop", windupFx = { "super", { "text", text = "CLIC-CLIC-CLIC !", color = GIVRE } },
					fx = { { "beam", color = GIVRE, length = 16, width = 4, at = "feet" }, { "beam", color = CHAUD, length = 16, width = 3, at = "feet" }, { "puddle", color = GIVRE, width = 14, time = 2 }, { "symbols", symbols = { "❄️", "🔥", "❄️" }, count = 8, radius = 4, color = GIVRE }, { "shake", amount = 0.35 } },
					text = "CHAUD… FROID… CHAUD !", hitText = "CONGELÉ-GRILLÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_neutral", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_neutral" },
				K_side = { P = "P_up", K = "K_up", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "sac_luxe", name = "Sac à main de luxe", icon = "👜",
			prop = { name = "PropSac", hand = "Right", pieces = {
				{ "Anse", "", "block", Vector3.new(0.16, 0.9, 0.16), Vector3.new(0, -0.4, 0), Vector3.zero, OR, "Metal" },
				{ "Sac", "", "block", Vector3.new(1.7, 1.3, 0.65), Vector3.new(0, -1.55, 0), Vector3.zero, CUIR_ROSE, "Leather" },
				{ "Rabat", "", "block", Vector3.new(1.72, 0.55, 0.68), Vector3.new(0, -1.1, 0), Vector3.zero, ROSE_VIF, "Leather" },
				{ "Fermoir", "", "ball", Vector3.new(0.34, 0.34, 0.16), Vector3.new(0, -1.3, -0.38), Vector3.zero, OR, "Metal" },
				{ "Logo", "", "block", Vector3.new(0.45, 0.45, 0.06), Vector3.new(0.4, -1.75, -0.36), Vector3.new(0, 0, 45), OR, "Metal" },
			} },
			ability = { knockback = 1.25, armor = true, text = "Sac de luxe (et tout ce qu'il y a dedans) : éjecte 25 % plus loin, les L encaissent" },
			moves = {
				-- J : coup de sac, elle balance le sac d'un coup sec dans la figure, main sur la hanche
				P_neutral = {
					label = "Coup de sac", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 3.5, 2.8, 0.8), kbBase = 24, kbGrowth = 32, kbAngle = 30,
					windup = { Root = { 4, -20, 4, 0, -0.15, 0.15 }, Waist = { 4, -22, -6 }, Neck = { 4, 14, 0 }, RS = { 120, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 } },
					strike = { Root = { -8, 14, -4, 0, -0.26, -0.3 }, Waist = { -8, 16, 6 }, Neck = { -4, -10, 0 }, RS = { 92, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, 18, -4, 0, -0.28, -0.34 }, Waist = { -10, 20, 6 }, Neck = { -6, -12, 0 }, RS = { 80, 0, -14 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 10, 0, -46 }, LE = { 115, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", text = "PARDON ?", hitText = "BLAM !",
				},
				-- →J : grand coup de sac, le sac part de derrière l'épaule en grand arc horizontal
				P_side = {
					label = "Grand coup de sac", startup = 0.14, active = 0.12, recovery = 0.26,
					damage = 9, hitbox = box(6, 3.5, 3.4, 0.8), kbBase = 26, kbGrowth = 42, kbAngle = 28, selfVelocity = Vector2.new(16, 0),
					windup = { Root = { 6, 44, 0, 0, -0.2, 0.2 }, Waist = { 8, 48, 0 }, Neck = { 0, -34, 0 }, RS = { 70, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.38 }, Waist = { -10, -36, 0 }, Neck = { 0, 26, 0 }, RS = { 90, 0, -30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					follow = { Root = { -10, -42, 0, 0, -0.32, -0.42 }, Waist = { -12, -48, 0 }, Neck = { 0, 32, 0 }, RS = { 86, 0, -50 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -54 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					trail = "prop", hitText = "VLAN !",
				},
				-- ↓J : sac aux chevilles, elle pose le sac lourdement par terre… sur les pieds d'en face
				P_down = {
					label = "Sac aux chevilles", startup = 0.13, active = 0.1, recovery = 0.24,
					damage = 8, hitbox = box(5, 2.5, 2.8, -1.5), kbBase = 24, kbGrowth = 36, kbAngle = 74,
					windup = { Root = { 6, 0, 0, 0, -0.5, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.95, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 16, 0, 0, 0, -0.97, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 26, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -46 }, LE = { 115, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "shake", amount = 0.25 }, "dust" }, text = "OUPS.", hitText = "ÉCRASÉ !",
				},
				-- ↑J : sac au menton, un uppercut de sac depuis la hanche jusqu'au ciel
				P_up = {
					label = "Sac au menton", startup = 0.13, active = 0.12, recovery = 0.24,
					damage = 9, hitbox = box(4.5, 5.5, 1.2, 3.5), kbBase = 28, kbGrowth = 40, kbAngle = 86,
					windup = { Root = { 4, 20, 0, 0, -0.4, 0.1 }, Waist = { 6, 24, 0 }, Neck = { -8, -16, 0 }, RS = { -30, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 } },
					strike = { Root = { -4, -10, 0, 0, 0.1, -0.1 }, Waist = { -6, -12, 0 }, Neck = { 28, 6, 0 }, RS = { 178, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -46 }, LE = { 115, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					follow = { Root = { -6, -12, 0, 0, 0.12, -0.12 }, Waist = { -8, -14, 0 }, Neck = { 32, 8, 0 }, RS = { 184, 0, 8 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 10, 0, -46 }, LE = { 115, 0, 0 }, FR = { 0, 0, 0, 0, 0.22, 0 }, FL = { 0, 0, 0, 0, 0.22, 0 } },
					trail = "prop", hitText = "TCHONK !",
				},
				-- J en l'air : sac plongeant, le sac tenu à deux mains au-dessus de la tête puis abattu sous elle
				P_air = {
					label = "Sac plongeant", startup = 0.12, active = 0.12, recovery = 0.2,
					damage = 9, hitbox = box(4.5, 4, 1.5, -1.5), kbBase = 24, kbGrowth = 40, kbAngle = -42,
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 182, 0, 12 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 36, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 36, 0, -6 }, LE = { 0, 0, 0 }, RH = { 24, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 24, 0, 8 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 24, 0, -8 }, LE = { 6, 0, 0 }, RH = { 20, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					trail = "prop", hitText = "BOUM !",
				},
				-- dash J : shopping express, elle fonce sac en avant comme dans les soldes, tout le monde pousse
				P_dash = {
					label = "Shopping express", startup = 0.1, active = 0.16, recovery = 0.26,
					damage = 10, hitbox = box(5.5, 3.5, 3, 0.6), kbBase = 28, kbGrowth = 50, kbAngle = 26, selfVelocity = Vector2.new(44, 0),
					windup = { Root = { -6, -10, 0, 0, -0.2, 0.1 }, Waist = { -4, -10, 0 }, Neck = { 6, 8, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.35, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 94, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -6 }, LE = { 0, 0, 0 } },
					follow = { Root = { -20, 0, 0, 0, -0.38, -0.34 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 96, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -8 }, LE = { 0, 0, 0 } },
					trail = "prop", fx = { "dust", { "symbols", symbols = { "-70 %", "🛍️" }, count = 3, radius = 2.5, color = ROSE_VIF } }, text = "SOLDES !", hitText = "POUSSÉ !",
				},
				-- K : talon de luxe, elle pose le sac au creux du coude et décoche un coup de talon compensé bien lourd
				K_neutral = {
					label = "Talon de luxe", startup = 0.2, active = 0.1, recovery = 0.32,
					damage = 12, hitbox = box(5, 3.5, 3, 0.5), kbBase = 32, kbGrowth = 74, kbAngle = 35,
					windup = { Root = { 6, -10, 0, 0, -0.15, 0.1 }, Waist = { 8, -8, 0 }, Neck = { 6, 6, 0 }, RS = { 20, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 } },
					strike = { Root = { 16, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 20, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { 18, 0, 0, 0, -0.1, 0.14 }, Waist = { 14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 32 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 32, 0, -62 }, LE = { 40, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
					trail = "rightFoot", text = "DÉGAGE !", hitText = "CLAC !",
				},
				-- →K : tourniquet du sac, un tour complet sur elle-même, le sac au bout de l'anse comme un fléau
				K_side = {
					label = "Tourniquet du sac", startup = 0.22, active = 0.14, recovery = 0.36,
					damage = 13, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 34, kbGrowth = 86, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 4, -50, 0, 0, -0.2, 0.15 }, Waist = { 6, -50, 0 }, Neck = { 6, 36, 0 }, RS = { 60, 0, 80 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, 0, 0, 0, -0.32, -0.34 }, Waist = { -12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 94, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 36, 0, -54 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", text = "TOURNIQUET !", hitText = "FLÉAU !",
				},
				-- ↓K : sac posé sur les pieds, accroupie, elle pose le sac par terre et le pousse d'un coup de talon dans les tibias
				K_down = {
					label = "Sac dans les tibias", startup = 0.18, active = 0.14, recovery = 0.34,
					damage = 12, hitbox = box(6, 2.5, 3.5, -1.5), kbBase = 30, kbGrowth = 62, kbAngle = 74, selfVelocity = Vector2.new(10, 0),
					windup = { Root = { 8, -10, 0, 0, -0.9, 0.1 }, Waist = { 12, -10, 0 }, Neck = { 6, 6, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 6 }, RK = { -60, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, -0.95, -0.15 }, Waist = { 10, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 70, 0, 4 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { 6, 0, 0, 0, -0.95, -0.18 }, Waist = { 10, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 18, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 74, 0, 4 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					trail = "rightFoot", fx = { "dust" }, hitText = "TONK !",
				},
				-- ↑K : lancer de sac au plafond, elle balance le sac droit en l'air pour dégager le ciel
				K_up = {
					label = "Sac au plafond", kind = "projectile", startup = 0.18, active = 0, recovery = 0.32,
					damage = 12, kbBase = 32, kbGrowth = 68, kbAngle = 88,
					projectile = { speed = 60, angle = 82, gravity = 60, lifetime = 0.55, size = 2, color = CUIR_ROSE, aim = false,
						visual = { shape = "block", size = 1.6, color = CUIR_ROSE, spin = 4, parts = { { "block", Vector3.new(1.62, 0.5, 1.0), Vector3.new(0, 0.5, 0), ROSE_VIF }, { "block", Vector3.new(0.3, 0.3, 0.1), Vector3.new(0.4, -0.2, -0.5), OR } } } },
					windup = { Root = { 8, 0, 0, 0, -0.4, 0.1 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.1, -0.1 }, Waist = { -12, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 180, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.12, -0.12 }, Waist = { -14, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 186, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 16, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.16, 0 }, FL = { 0, 0, 0, 0, 0.16, 0 } },
					hideProp = "sac", fx = { { "symbols", symbols = { "👜", "▲" }, count = 2, radius = 2, at = "above", color = ROSE_VIF } }, text = "ATTENTION LA TÊTE !", hitText = "BLONG !",
				},
				-- K en l'air : sac tombant, elle serre le sac contre elle et tombe dessus genoux en avant
				K_air = {
					label = "Sac tombant", startup = 0.16, active = 0.14, recovery = 0.28,
					damage = 12, hitbox = box(5, 4, 1.8, -1), kbBase = 30, kbGrowth = 66, kbAngle = -40,
					windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 120, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -30, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 70, 0, -20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 130, 0, 0 }, RH = { 100, 0, 10 }, RK = { -130, 0, 0 }, LH = { 100, 0, -10 }, LK = { -130, 0, 0 } },
					follow = { Root = { -34, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 72, 0, -22 }, RE = { 132, 0, 0 }, RW = { 0, 0, 0 }, LS = { 72, 0, 22 }, LE = { 132, 0, 0 }, RH = { 104, 0, 12 }, RK = { -134, 0, 0 }, LH = { 104, 0, -12 }, LK = { -134, 0, 0 } },
					trail = "body", hitText = "SPLATCH !",
				},
				-- dash K : charge VIP, elle traverse la file d'attente sac devant, « laissez passer ! », elle encaisse tout
				K_dash = {
					label = "Charge VIP", startup = 0.12, active = 0.22, recovery = 0.34,
					damage = 12, hitbox = box(5.5, 3.5, 3, 0.3), kbBase = 32, kbGrowth = 66, kbAngle = 34, selfVelocity = Vector2.new(50, 0), armor = true,
					windup = { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -22, 0, 0, 0, -0.45, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 94, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -10 }, LE = { 0, 0, 0 } },
					follow = { Root = { -24, 0, 0, 0, -0.48, -0.34 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 96, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -12 }, LE = { 0, 0, 0 } },
					shake = true, trail = "prop", fx = { "dust", { "text", text = "VIP", color = OR, at = "above" } }, text = "LAISSEZ PASSER !", hitText = "ENFONCÉ !",
				},
				-- L : vide-sac, elle retourne le sac : rouge à lèvres, parfum, téléphone, tout vole sur l'adversaire
				S_neutral = {
					label = "Vide-sac", kind = "projectile", startup = 0.22, active = 0, recovery = 0.46,
					damage = 5, kbBase = 22, kbGrowth = 38, kbAngle = 30,
					projectile = { speed = 78, angle = 0, gravity = 10, lifetime = 0.7, size = 1.4, color = ROSE_VIF, fan = { count = 4, from = -12, to = 12 },
						visual = { shape = "block", size = 1.0, color = ROSE_VIF, spin = 10, parts = { { "cyl", Vector3.new(1.0, 0.3, 0.3), Vector3.new(0.6, 0.4, 0), OR }, { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-0.5, -0.4, 0), LILAS } } } },
					windup = { Root = { 6, -20, 0, 0, -0.2, 0.2 }, Waist = { 8, -24, 0 }, Neck = { 6, 16, 0 }, RS = { 150, 0, 40 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -12, 16, 0, 0, -0.3, -0.35 }, Waist = { -14, 22, 0 }, Neck = { -2, -12, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 180, 0, 0 }, LS = { 90, 0, 6 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 20, 0, 0, -0.34, -0.42 }, Waist = { -18, 26, 0 }, Neck = { -4, -16, 0 }, RS = { 100, 0, 4 }, RE = { 4, 0, 0 }, RW = { 180, 0, 0 }, LS = { 94, 0, 8 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, trail = "prop", fx = { { "toss", shape = "cyl", color = OR, size = 0.5, count = 5, speed = 22 }, { "symbols", symbols = { "💄", "📱", "🧴" }, count = 4, radius = 3, at = "front" } },
					text = "TIENS, TOUT ÇA !", hitText = "PAF-PAF-PAF !",
				},
				-- →L : lancer de sac, le sac part en tournoyant au bout de son anse, fauche l'adversaire et lui revient dans la main
				S_side = {
					label = "Lancer de sac", kind = "projectile", startup = 0.26, active = 0, recovery = 0.52,
					damage = 16, kbBase = 34, kbGrowth = 66, kbAngle = 32,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.9, size = 2.4, color = CUIR_ROSE, returns = true,
						visual = { shape = "block", size = 1.8, color = CUIR_ROSE, spin = 10, parts = { { "block", Vector3.new(1.82, 0.55, 1.1), Vector3.new(0, 0.55, 0), ROSE_VIF }, { "block", Vector3.new(0.16, 1.2, 0.16), Vector3.new(0, 1.4, 0), OR }, { "block", Vector3.new(0.4, 0.4, 0.1), Vector3.new(0.4, -0.3, -0.55), OR } } } },
					windup = { Root = { 6, -40, 0, 0, -0.25, 0.25 }, Waist = { 8, -44, 0 }, Neck = { 6, 30, 0 }, RS = { 150, 0, 60 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -14, 24, 0, 0, -0.34, -0.45 }, Waist = { -16, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { 2, 10, 4, 0, -0.22, 0 }, Waist = { 4, 10, 6 }, Neck = { 4, -8, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					shake = true, hideProp = "sac", fx = { { "burst", color = ROSE_VIF, size = 3, at = "hand" }, { "symbols", symbols = { "👜", "💫" }, count = 3, radius = 2.5, at = "front", color = OR } },
					text = "C'EST DU CUIR !", hitText = "ET RETOUR !",
				},
				-- ↓L : sac écrasant, le sac levé à deux mains puis abattu au sol : tout ce qu'il y a dedans fait trembler le couloir
				S_down = {
					label = "Sac écrasant", startup = 0.26, active = 0.16, recovery = 0.52,
					damage = 15, hitbox = box(14, 6, 7, 0.5), kbBase = 34, kbGrowth = 62, kbAngle = 80,
					windup = { Root = { 8, 0, 0, 0, 0.1, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 184, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 184, 0, -10 }, LE = { 30, 0, 0 } },
					strike = { Root = { -24, 0, 0, 0, -0.9, -0.25 }, Waist = { -44, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -12 }, LE = { 0, 0, 0 } },
					follow = { Root = { -26, 0, 0, 0, -0.95, -0.25 }, Waist = { -48, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -14 }, LE = { 0, 0, 0 } },
					shake = true, trail = "prop", fx = { { "ring", color = ROSE_VIF, radius = 7, at = "feet" }, { "pillar", color = CUIR_ROSE, height = 3, width = 8, at = "front", time = 0.4 }, { "shake", amount = 0.6 }, "dust" },
					text = "IL PÈSE UNE TONNE !", hitText = "BRRROUM !",
				},
				-- ↑L : sac-parachute, le sac tenu au-dessus de la tête se gonfle comme un parachute et l'emporte en diagonale
				S_up = {
					label = "Sac-parachute", startup = 0.16, active = 0.3, recovery = 0.42,
					damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 56, kbAngle = 72, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 6, 0, 0, 0, -0.75, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -36, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 182, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 }, RH = { -20, 0, 8 }, RK = { -40, 0, 0 }, RA = { -25, 0, 0 }, LH = { -30, 0, -8 }, LK = { -50, 0, 0 }, LA = { -25, 0, 0 } },
					follow = { Root = { -40, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 186, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 124, 0, -44 }, LE = { 30, 0, 0 }, RH = { -26, 0, 10 }, RK = { -48, 0, 0 }, RA = { -25, 0, 0 }, LH = { -36, 0, -10 }, LK = { -58, 0, 0 }, LA = { -25, 0, 0 } },
					trail = "prop", fx = { { "ring", color = ROSE, radius = 5, at = "feet" }, { "burst", color = ROSE_VIF, size = 3, at = "feet" }, { "symbols", symbols = { "👜", "✨" }, count = 3, radius = 2, color = OR } },
					text = "ENVOLÉE !", hitText = "PLOF !",
				},
				-- L en l'air : sac-enclume, elle lâche le sac qui tombe comme une enclume pile sur la tête de l'adversaire
				S_air = {
					label = "Sac-enclume", kind = "projectile", startup = 0.16, active = 0, recovery = 0.42,
					damage = 15, kbBase = 30, kbGrowth = 58, kbAngle = -65,
					projectile = { speed = 60, gravity = 70, lifetime = 0.8, size = 2.4, color = CUIR_ROSE, rain = { count = 1, spread = 0.5, ahead = 6, height = 18 },
						visual = { shape = "block", size = 1.8, color = CUIR_ROSE, spin = 2, parts = { { "block", Vector3.new(1.82, 0.55, 1.1), Vector3.new(0, 0.55, 0), ROSE_VIF }, { "block", Vector3.new(0.16, 1.2, 0.16), Vector3.new(0, 1.4, 0), OR } } } },
					windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 180, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					strike = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 40 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					follow = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 50, 0, 44 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 120, 0, -10 }, LE = { 130, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					hideProp = "sac", fx = { { "symbols", symbols = { "👜", "⬇" }, count = 3, radius = 2, at = "above", color = ROSE_VIF } }, text = "OUPS, MON SAC !", hitText = "ENCLUME !",
				},
				-- Y : sac XXL, le sac gonfle jusqu'à devenir énorme et elle le balance d'un grand coup sur tout le couloir
				SUPER = {
					label = "Sac XXL !", startup = 0.42, active = 0.24, recovery = 0.7,
					damage = 26, hitbox = box(14, 8, 7, 1.5), kbBase = 50, kbGrowth = 100, kbAngle = 32, armor = true,
					windup = { Root = { 6, -50, 0, 0, -0.3, 0.2 }, Waist = { 8, -54, 0 }, Neck = { 8, 36, 0 }, RS = { 150, 0, 70 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -16, 20, 0, 0, -0.4, -0.5 }, Waist = { -18, 24, 0 }, Neck = { -6, -16, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { -18, 34, 0, 0, -0.42, -0.55 }, Waist = { -20, 40, 0 }, Neck = { -8, -22, 0 }, RS = { 84, 0, -40 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -54 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.58 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "👜", "💰", "✨" }, count = 6, radius = 3, color = OR } },
					fx = { { "burst", color = ROSE_VIF, size = 5, at = "front" }, { "ring", color = OR, radius = 7, at = "front" }, { "beam", color = CUIR_ROSE, length = 16, width = 6, at = "hand" }, { "shake", amount = 0.5 } },
					text = "ÉDITION LIMITÉE !", hitText = "KA-BLAM !",
				},
				-- →Y : le sac à 10 000 €, elle le lance comme un boulet de canon : il traverse tout le couloir, rebondit et personne n'y touche
				SUPER_side = {
					label = "Le sac à 10 000 € !", kind = "projectile", startup = 0.42, active = 0, recovery = 0.72,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 82, angle = 0, gravity = 0, lifetime = 0.9, size = 3.6, color = CUIR_ROSE, pierce = true, bounce = 1,
						visual = { shape = "block", size = 3, color = CUIR_ROSE, spin = 8, parts = { { "block", Vector3.new(3.02, 0.9, 1.9), Vector3.new(0, 0.9, 0), ROSE_VIF }, { "block", Vector3.new(0.3, 2.2, 0.3), Vector3.new(0, 2.4, 0), OR }, { "block", Vector3.new(0.8, 0.8, 0.12), Vector3.new(0.7, -0.4, -0.95), OR } } } },
					windup = { Root = { 8, -36, 0, 0, -0.4, 0.3 }, Waist = { 12, -40, 0 }, Neck = { 10, 26, 0 }, RS = { 40, 0, 20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -18, 24, 0, 0, -0.38, -0.55 }, Waist = { -20, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					follow = { Root = { -20, 28, 0, 0, -0.4, -0.6 }, Waist = { -24, 32, 0 }, Neck = { -8, -18, 0 }, RS = { 100, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 96, 0, 6 }, LE = { 0, 0, 0 }, LW = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.62 } },
					shake = true, hideProp = "sac", windupFx = { "super", { "text", text = "10 000 € !", color = OR, at = "above" } },
					fx = { { "burst", color = OR, size = 4, at = "hand" }, { "beam", color = ROSE_VIF, length = 14, width = 3, at = "hand" }, { "shake", amount = 0.45 } },
					text = "ATTRAPE, C'EST CADEAU !", hitText = "HORS DE PRIX !",
				},
				-- ↑Y : la note de frais, elle sort du sac un ticket de caisse interminable qui se déroule jusqu'au plafond et emporte tout le couloir
				SUPER_up = {
					label = "La note de frais !", startup = 0.36, active = 0.34, recovery = 0.7,
					damage = 24, hitbox = box(14, 12, 7, 4), kbBase = 46, kbGrowth = 94, kbAngle = 88, invuln = 0.3, selfVelocity = Vector2.new(0, 50),
					windup = { Root = { 6, 0, 0, 0, -0.6, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 20 }, LE = { 130, 0, 0 } },
					strike = { Root = { 2, 0, 0, 0, 0.45, 0 }, Waist = { 6, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 30, 0, 10 }, RK = { -70, 0, 0 }, LH = { 30, 0, -10 }, LK = { -70, 0, 0 } },
					follow = { Root = { 4, 0, 0, 0, 0.5, 0 }, Waist = { 8, 0, 0 }, Neck = { 48, 0, 0 }, RS = { 154, 0, 32 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -12 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 40, 0, 12 }, RK = { -80, 0, 0 }, LH = { 40, 0, -12 }, LK = { -80, 0, 0 } },
					hold = 0.25, shake = true, trail = "leftHand", windupFx = { "super", { "text", text = "TICKET DE CAISSE…", color = BLANC, at = "hand" } },
					fx = { { "pillar", color = BLANC, height = 26, width = 4, at = "front" }, { "ring", color = OR, radius = 8, at = "feet" }, { "symbols", symbols = { "🧾", "€", "€€€" }, count = 8, radius = 4, color = OR }, { "shake", amount = 0.4 } },
					text = "ET VOILÀ LA NOTE !", hitText = "RUINÉ !",
				},
				-- ↓Y : remboursement, elle renverse le sac sur tout le couloir : flacons de parfum brisés, tout le monde glisse dedans
				SUPER_down = {
					label = "Remboursement !", startup = 0.4, active = 0.3, recovery = 0.72,
					damage = 22, hitbox = box(14, 5, 7, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 60,
					status = { name = "slippery", duration = 2.5 },
					windup = { Root = { 8, -30, 0, 0, -0.5, 0.2 }, Waist = { 12, -34, 0 }, Neck = { 10, 24, 0 }, RS = { 160, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 40, 0, 0 } },
					strike = { Root = { 14, 20, 0, 0, -1.0, -0.3 }, Waist = { 26, 24, 0 }, Neck = { 6, -14, 0 }, RS = { 40, 0, -10 }, RE = { 0, 0, 0 }, RW = { 180, 0, 0 }, LS = { 40, 0, 10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 16, 30, 0, 0, -1.0, -0.34 }, Waist = { 28, 34, 0 }, Neck = { 8, -20, 0 }, RS = { 34, 0, -20 }, RE = { 0, 0, 0 }, RW = { 180, 0, 0 }, LS = { 34, 0, 20 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super", { "text", text = "JE VEUX ÊTRE REMBOURSÉE !", color = ROSE_VIF } },
					fx = { { "puddle", color = LILAS, width = 16, time = 2 }, { "toss", shape = "cyl", color = OR, size = 0.8, count = 8, speed = 26 }, { "beam", color = LILAS, length = 16, width = 3, at = "feet" }, { "symbols", symbols = { "💄", "🧴", "📱", "💳" }, count = 8, radius = 5, at = "front" }, { "shake", amount = 0.4 } },
					text = "TOUT PAR TERRE !", hitText = "GLISSÉ DANS LE PARFUM !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_down" },
				K_side = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

	look = {
		body = {
			head = PEAU, upper = ROSE, lower = LILAS, arms = PEAU, forearms = PEAU, hands = PEAU,
			legs = PEAU, shins = PEAU, feet = BLANC,
		},
		cubeHead = 1.25,
		parts = {
			-- longue chevelure rose pastel, frange, queue de cheval haute et chouchou
			{ "Cheveux", "Head", "ball", Vector3.new(1.6, 1.55, 1.5), Vector3.new(0, 0.3, 0.32), Vector3.zero, CHEVEUX, "Fabric" },
			{ "Frange", "Head", "block", Vector3.new(1.32, 0.38, 0.45), Vector3.new(0, 0.5, -0.45), Vector3.zero, CHEVEUX, "Fabric" },
			{ "Queue", "Head", "ball", Vector3.new(0.75, 1.7, 0.75), Vector3.new(0, 0.3, 1.0), Vector3.new(-25, 0, 0), CHEVEUX, "Fabric" },
			{ "Chouchou", "Head", "cyl", Vector3.new(0.35, 0.6, 0.6), Vector3.new(0, 0.95, 0.7), Vector3.new(-25, 0, 0), ROSE_VIF, "Fabric", { axis = "z" } },
			-- lunettes en cœur : deux boules et un losange par verre
			{ "CoeurG1", "Head", "ball", Vector3.new(0.26, 0.26, 0.08), Vector3.new(-0.4, 0.14, -0.66), Vector3.zero, ROSE_VIF, "SmoothPlastic", { transparency = 0.1 } },
			{ "CoeurG2", "Head", "ball", Vector3.new(0.26, 0.26, 0.08), Vector3.new(-0.22, 0.14, -0.66), Vector3.zero, ROSE_VIF, "SmoothPlastic", { transparency = 0.1 } },
			{ "CoeurGPointe", "Head", "block", Vector3.new(0.24, 0.24, 0.07), Vector3.new(-0.31, 0.02, -0.66), Vector3.new(0, 0, 45), ROSE_VIF, "SmoothPlastic", { transparency = 0.1 } },
			{ "CoeurD1", "Head", "ball", Vector3.new(0.26, 0.26, 0.08), Vector3.new(0.22, 0.14, -0.66), Vector3.zero, ROSE_VIF, "SmoothPlastic", { transparency = 0.1 } },
			{ "CoeurD2", "Head", "ball", Vector3.new(0.26, 0.26, 0.08), Vector3.new(0.4, 0.14, -0.66), Vector3.zero, ROSE_VIF, "SmoothPlastic", { transparency = 0.1 } },
			{ "CoeurDPointe", "Head", "block", Vector3.new(0.24, 0.24, 0.07), Vector3.new(0.31, 0.02, -0.66), Vector3.new(0, 0, 45), ROSE_VIF, "SmoothPlastic", { transparency = 0.1 } },
			{ "Branches", "Head", "block", Vector3.new(1.3, 0.06, 0.9), Vector3.new(0, 0.14, -0.22), Vector3.zero, OR, "Metal" },
			-- visage : petit nez, bouche en cœur (duck face)
			{ "Nez", "Head", "block", Vector3.new(0.16, 0.22, 0.14), Vector3.new(0, -0.12, -0.68), Vector3.zero, Color3.fromRGB(245, 195, 170), "SmoothPlastic" },
			{ "Levres", "Head", "ball", Vector3.new(0.38, 0.18, 0.12), Vector3.new(0, -0.36, -0.65), Vector3.zero, ROSE_VIF, "SmoothPlastic" },
			-- crop top à cœur, téléphone de secours dans la poche arrière, bracelet
			{ "Collier", "UpperTorso", "ball", Vector3.new(0.32, 0.32, 0.1), Vector3.new(0, 0.42, -0.54), Vector3.zero, ROSE_VIF, "SmoothPlastic" },
			{ "Ventre", "UpperTorso", "block", Vector3.new(1.96, 0.45, 0.96), Vector3.new(0, -0.6, 0), Vector3.zero, PEAU, "SmoothPlastic" },
			{ "CoquePoche", "LowerTorso", "block", Vector3.new(0.55, 0.8, 0.12), Vector3.new(0.4, 0, 0.55), Vector3.zero, OR, "Foil", { reflect = 0.3 } },
			{ "BraceletG", "LeftLowerArm", "cyl", Vector3.new(0.2, 0.62, 0.62), Vector3.new(0, -0.4, 0), Vector3.zero, OR, "Metal", { axis = "y" } },
			-- talons compensés
			{ "SemelleD", "RightFoot", "block", Vector3.new(1.05, 0.45, 1.2), Vector3.new(0, -0.32, 0), Vector3.zero, BLANC, "SmoothPlastic" },
			{ "SemelleG", "LeftFoot", "block", Vector3.new(1.05, 0.45, 1.2), Vector3.new(0, -0.32, 0), Vector3.zero, BLANC, "SmoothPlastic" },
		},
		props = {
			-- l'arme : la perche à selfie, téléphone à paillettes au bout
			{ name = "PropPerche", hand = "Right", visible = true, pieces = {
				{ "Poignee", "", "cyl", Vector3.new(0.3, 0.7, 0.3), Vector3.new(0, -0.25, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "y" } },
				{ "Tige", "", "cyl", Vector3.new(0.14, 2.9, 0.14), Vector3.new(0, -2.0, 0), Vector3.zero, ARGENT, "Metal", { axis = "y" } },
				{ "Pince", "", "block", Vector3.new(0.3, 0.25, 0.7), Vector3.new(0, -3.45, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Telephone", "", "block", Vector3.new(0.14, 0.7, 1.1), Vector3.new(0, -3.75, 0), Vector3.zero, ROSE_VIF, "Foil", { reflect = 0.3 } },
				{ "Ecran", "", "block", Vector3.new(0.16, 0.6, 0.95), Vector3.new(0.02, -3.75, 0), Vector3.zero, Color3.fromRGB(160, 220, 255), "Neon", { neon = true } },
			} },
			-- ring light (coup de ring light, blocage)
			{ name = "PropRinglight", hand = "Right", visible = false, pieces = {
				{ "Manche", "", "block", Vector3.new(0.22, 0.8, 0.22), Vector3.new(0, -0.35, 0), Vector3.zero, BLANC, "SmoothPlastic" },
				{ "Anneau", "", "cyl", Vector3.new(0.18, 2.5, 2.5), Vector3.new(0, -1.9, 0), Vector3.zero, FLASH, "Neon", { axis = "x", neon = true, light = { FLASH, 14, 2 } } },
				{ "Centre", "", "cyl", Vector3.new(0.22, 1.7, 1.7), Vector3.new(0, -1.9, 0), Vector3.zero, ROSE_VIF, "SmoothPlastic", { axis = "x" } },
			} },
			-- drone de vlog (remontée) : il pend au-dessus d'elle quand elle lève le bras
			{ name = "PropDrone", hand = "Right", visible = false, pieces = {
				{ "Fil", "", "cyl", Vector3.new(0.06, 0.9, 0.06), Vector3.new(0, -0.45, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "y" } },
				{ "Corps", "", "block", Vector3.new(1.0, 0.35, 1.0), Vector3.new(0, -1.05, 0), Vector3.zero, BLANC, "SmoothPlastic" },
				{ "HeliceAv", "", "cyl", Vector3.new(0.05, 0.8, 0.8), Vector3.new(0, -1.25, -0.75), Vector3.zero, ARGENT, "SmoothPlastic", { axis = "y", transparency = 0.3 } },
				{ "HeliceAr", "", "cyl", Vector3.new(0.05, 0.8, 0.8), Vector3.new(0, -1.25, 0.75), Vector3.zero, ARGENT, "SmoothPlastic", { axis = "y", transparency = 0.3 } },
				{ "Objectif", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0, -0.9, -0.5), Vector3.zero, Color3.fromRGB(255, 40, 40), "Neon", { neon = true } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de smartphone : petit coup sec du bout de la perche, téléphone en avant, hanche sortie
		P_neutral = {
			label = "Coup de smartphone", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 5, hitbox = box(5, 2.5, 3.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 2, -10, 4, 0, -0.15, 0.12 }, Waist = { 2, -12, -6 }, Neck = { 4, 10, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 25, 0, -30 }, LE = { 100, 0, 0 } },
			strike = { Root = { -4, 12, -4, 0, -0.2, -0.2 }, Waist = { -4, 12, 6 }, Neck = { 0, -10, 0 }, RS = { 90, 0, 0 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 25, 0, -35 }, LE = { 110, 0, 0 } },
			follow = { Root = { -5, 14, -4, 0, -0.22, -0.24 }, Waist = { -5, 14, 6 }, Neck = { 0, -12, 0 }, RS = { 92, 0, -2 }, RE = { 5, 0, 0 }, RW = { -6, 0, 0 }, LS = { 25, 0, -36 }, LE = { 112, 0, 0 } },
			trail = "prop", hitText = "TAP !",
		},
		-- Estoc à la perche : grande fente en avant, la perche tendue comme un fleuret (longue portée)
		P_side = {
			label = "Estoc à la perche", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(7, 2.5, 4.5, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 18, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 6, -20, 0, 0, -0.2, 0.3 }, Waist = { 6, -16, 0 }, Neck = { 0, 14, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, 18, 0, 0, -0.45, -0.5 }, Waist = { -6, 20, 0 }, Neck = { 6, -16, 0 }, RS = { 92, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -12, 20, 0, 0, -0.5, -0.58 }, Waist = { -8, 22, 0 }, Neck = { 8, -18, 0 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { -4, 0, 0 }, LS = { 125, 0, -62 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
			trail = "prop", text = "EN GARDE !", hitText = "PIC !",
		},
		-- Glissade pose photo : elle glisse assise sur une hanche, perche au ras du sol, signe V près du visage
		P_down = {
			label = "Glissade pose photo", startup = 0.1, active = 0.18, recovery = 0.2,
			damage = 6, hitbox = box(5, 2, 2.5, -2), kbBase = 25, kbGrowth = 22, kbAngle = 75, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { -6, 0, 0, 0, -0.6, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 20 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 22, 0, 6, 0, -1.4, -0.3 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 10 }, RS = { 60, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -10 }, LE = { 130, 0, 0 }, RH = { 80, 0, 0 }, RK = { -10, 0, 0 }, RA = { 15, 0, 0 }, LH = { 60, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { 24, 0, 8, 0, -1.45, -0.35 }, Waist = { -12, 0, 0 }, Neck = { -12, 0, 12 }, RS = { 58, 0, 22 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 122, 0, -10 }, LE = { 132, 0, 0 }, RH = { 82, 0, 0 }, RK = { -10, 0, 0 }, RA = { 15, 0, 0 }, LH = { 62, 0, 0 }, LK = { -82, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, text = "CHEESE !", hitText = "ZIP !",
		},
		-- Selfie vertical (anti-air, ex-←P) : la perche monte droit au ciel et le flash part vers le haut
		P_up = {
			label = "Selfie vertical", startup = 0.09, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(4, 5.5, 1, 4), kbBase = 28, kbGrowth = 30, kbAngle = 86,
			windup = { Root = { -4, 0, 0, 0, -0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 6, 10, 4, 0, 0.05, 0 }, Waist = { 10, 8, 6 }, Neck = { 24, 0, 0 }, RS = { 176, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -10 }, LE = { 130, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 8, 12, 6, 0, 0.08, 0 }, Waist = { 12, 10, 8 }, Neck = { 28, 0, 6 }, RS = { 180, 0, 2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 112, 0, -10 }, LE = { 132, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			trail = "prop", fx = { { "burst", color = FLASH, size = 3, at = "above" } }, text = "SELFIE !", hitText = "FLASH !",
		},
		-- Coup de ring light : en l'air, elle sort sa ring light et la balance devant elle comme un cerceau
		P_air = {
			label = "Coup de ring light", startup = 0.09, active = 0.12, recovery = 0.16,
			damage = 8, hitbox = box(5, 4, 2.5, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 35,
			windup = { Root = { -6, -20, 0 }, Waist = { -6, -20, 0 }, Neck = { 0, 15, 0 }, RS = { 120, 0, 60 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { -8, 18, 0 }, Waist = { -10, 18, 0 }, Neck = { 0, -10, 0 }, RS = { 95, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -10, 24, 0 }, Waist = { -12, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 90, 0, -25 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -55 }, LE = { 40, 0, 0 }, RH = { 38, 0, 0 }, RK = { -68, 0, 0 }, LH = { 52, 0, 0 }, LK = { -92, 0, 0 } },
			prop = "ringlight", hideProp = "perche", trail = "prop", hitText = "BZZZT !",
		},
		-- Défilé express (dash puis P) : elle fonce en défilé, perche pointée comme une lance, cheveux au vent
		P_dash = {
			label = "Défilé express", startup = 0.08, active = 0.15, recovery = 0.24,
			damage = 8, hitbox = box(6, 2.5, 3.5, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -6, -16, 0, 0, -0.2, 0.1 }, Waist = { -4, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 10, 0, 0, -0.3, -0.3 }, Waist = { -6, 8, 0 }, Neck = { 10, -6, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -35 }, LE = { 20, 0, 0 } },
			follow = { Root = { -16, 12, 0, 0, -0.32, -0.35 }, Waist = { -6, 10, 0 }, Neck = { 12, -8, 0 }, RS = { 94, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -45, 0, -38 }, LE = { 20, 0, 0 } },
			trail = "prop", fx = { "dust" }, text = "PLACE !", hitText = "TCHAC !",
		},

		-- P P : Flash éblouissant, le téléphone braqué sous le nez d'en face, flash en pleine figure
		P_combo2 = {
			label = "Flash éblouissant", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(5, 4, 3, 0.8), kbBase = 20, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { 2, 10, 0, 0, -0.2, 0.1 }, Waist = { 2, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -4, -6, 0, 0, -0.22, -0.18 }, Waist = { -4, -6, 0 }, Neck = { -6, 12, 0 }, RS = { 100, 0, 6 }, RE = { 15, 0, 0 }, RW = { 20, 0, 0 }, LS = { 140, 0, 30 }, LE = { 130, 0, 0 } },
			follow = { Root = { -4, -8, 0, 0, -0.22, -0.2 }, Waist = { -4, -8, 0 }, Neck = { -8, 14, 0 }, RS = { 102, 0, 6 }, RE = { 15, 0, 0 }, RW = { 22, 0, 0 }, LS = { 142, 0, 30 }, LE = { 132, 0, 0 } },
			trail = "prop", fx = { { "burst", color = FLASH, size = 3, at = "front" } }, text = "FLASH !", hitText = "AÏE MES YEUX !",
		},
		-- P P P P : Selfie de groupe, grand balayage de perche pour faire entrer tout le monde dans le cadre (finition)
		P_combo3 = {
			label = "Selfie de groupe", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(6, 4.5, 3, 1), kbBase = 36, kbGrowth = 78, kbAngle = 45,
			windup = { Root = { 6, -30, 0, 0, -0.15, 0.25 }, Waist = { 8, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 160, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, 24, 0, 0, -0.4, -0.4 }, Waist = { -14, 30, 0 }, Neck = { 0, -16, 0 }, RS = { 85, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 30, 0, 0 } },
			follow = { Root = { -14, 32, 0, 0, -0.42, -0.45 }, Waist = { -16, 38, 0 }, Neck = { 0, -20, 0 }, RS = { 70, 0, -35 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -25, 0, -45 }, LE = { 30, 0, 0 } },
			trail = "prop", text = "TOUT LE MONDE SOURIT !", hitText = "CLIC-CLAC !",
		},
		-- → P P : Swipe à gauche, la perche revient en revers comme un « suivant ! »
		P_side2 = {
			label = "Swipe à gauche", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(6, 4, 3.5, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 25,
			windup = { Root = { -6, 24, 0, 0, -0.35, -0.35 }, Waist = { -8, 30, 0 }, RS = { 85, 0, -40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 50, 0, 0 } },
			strike = { Root = { -6, -16, 0, 0, -0.3, -0.4 }, Waist = { -8, -24, 0 }, RS = { 92, 0, 45 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			follow = { Root = { -6, -22, 0, 0, -0.3, -0.42 }, Waist = { -8, -30, 0 }, RS = { 88, 0, 65 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 45, 0, -30 }, LE = { 70, 0, 0 } },
			trail = "prop", text = "SUIVANT !", hitText = "SWIPE !",
		},

		-- Talon compensé : elle tourne le dos, prend la pose pour un selfie… et lâche une ruade en arrière sans regarder,
		-- la semelle compensée en pleine figure (le téléphone n'a rien manqué)
		K_neutral = {
			label = "Talon compensé", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3.5, 3, 0.6), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 0, 150, 0, 0, -0.2, 0.1 }, Waist = { 4, 20, 0 }, Neck = { 6, -30, 8 }, RS = { 140, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 }, RH = { 20, 0, 0 }, RK = { -70, 0, 0 } },
			strike = { Root = { -30, 176, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { 20, -40, 8 }, RS = { 150, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 }, RH = { -100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -34, 178, 0, 0, -0.32, 0 }, Waist = { -18, 0, 0 }, Neck = { 22, -42, 8 }, RS = { 152, 0, 12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 }, RH = { -106, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { { "burst", color = FLASH, size = 2, at = "hand" } }, text = "CHEESE !", hitText = "CLAC !",
		},
		-- Kick « pose photo » : coup de pied tendu et elle reste figée dans la pose, perche levée pour la photo
		K_side = {
			label = "Kick « pose photo »", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 3, 3.2, 0.5), kbBase = 32, kbGrowth = 80, kbAngle = 28, selfVelocity = Vector2.new(25, 0),
			windup = { Root = { 4, -16, 0, 0, -0.15, 0.2 }, Waist = { 4, -12, 0 }, Neck = { 0, 16, 0 }, RS = { 40, 0, 40 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, RH = { 70, 0, 0 }, RK = { -115, 0, 0 } },
			strike = { Root = { 14, 8, 0, 0, -0.15, -0.3 }, Waist = { 10, 6, 0 }, Neck = { 6, 20, 0 }, RS = { 160, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 110, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 15, 9, 0, 0, -0.15, -0.34 }, Waist = { 11, 7, 0 }, Neck = { 8, 22, 0 }, RS = { 162, 0, 42 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 112, 0, 0 }, RH = { 102, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			hold = 0.12, trail = "rightFoot", fx = { { "burst", color = FLASH, size = 2, at = "hand" } }, text = "CLIC !", hitText = "POSE !",
		},
		-- Balayette talon : accroupie, elle tourne sur elle-même, talon compensé au ras du sol (fait décoller)
		K_down = {
			label = "Balayette talon", startup = 0.16, active = 0.16, recovery = 0.32,
			damage = 11, hitbox = box(7, 2, 0.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 78,
			windup = { Root = { -6, -20, 0, 0, -0.95, 0 }, Waist = { -14, -10, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -1.2, 0 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 65 }, RE = { 20, 0, 0 }, LS = { 30, 0, -65 }, LE = { 20, 0, 0 }, RH = { 76, 0, 15 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -1.18, 0 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 25, 0, 66 }, RE = { 20, 0, 0 }, LS = { 35, 0, -66 }, LE = { 20, 0, 0 }, RH = { 74, 0, 18 }, RK = { -8, 0, 0 }, RA = { 20, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", text = "TENDANCE !", hitText = "ZOUIP !",
		},
		-- « Pas de photo ! » (anti-air, ex-←K) : main gauche devant l'objectif, elle se penche en avant et sa jambe droite
		-- passe par-dessus son dos en coup du scorpion, le talon compensé pointé vers le ciel
		K_up = {
			label = "« Pas de photo ! »", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(4.5, 5.5, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 85,
			windup = { Root = { 8, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -10, 20, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 100, 0, 20 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -34, 0, 0, 0, -0.3, -0.1 }, Waist = { -24, 0, 0 }, Neck = { 30, 20, 0 }, RS = { 40, 0, 60 }, RE = { 10, 0, 0 }, LS = { 120, 0, 10 }, LE = { 10, 0, 0 }, LW = { -60, 0, 0 }, RH = { 150, 0, 0 }, RK = { -70, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -38, 0, 0, 0, -0.32, -0.12 }, Waist = { -26, 0, 0 }, Neck = { 34, 22, 0 }, RS = { 42, 0, 62 }, RE = { 10, 0, 0 }, LS = { 122, 0, 10 }, LE = { 10, 0, 0 }, LW = { -60, 0, 0 }, RH = { 160, 0, 0 }, RK = { -80, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightLeg", text = "PAS DE PHOTO !", hitText = "NON MAIS !",
		},
		-- Saut photogénique : en l'air, grand écart complet, une jambe devant, une derrière, la perche cadre la scène
		-- et le flash part au sommet du saut
		K_air = {
			label = "Saut photogénique", startup = 0.16, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5.5, 3.5, 3, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 80, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 40, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 6, 10, 0 }, Waist = { 8, 6, 0 }, Neck = { 10, -10, 0 }, RS = { 150, 0, 50 }, RE = { 20, 0, 0 }, LS = { 130, 0, 10 }, LE = { 130, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -85, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 8, 12, 0 }, Waist = { 10, 6, 0 }, Neck = { 12, -12, 0 }, RS = { 155, 0, 52 }, RE = { 20, 0, 0 }, LS = { 132, 0, 10 }, LE = { 132, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -88, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "bothFeet", fx = { { "burst", color = FLASH, size = 2, at = "hand" } }, hitText = "PHOTOGÉNIQUE !",
		},
		-- Coup de hanche défilé (dash puis K) : elle file en défilé et donne un grand coup de hanche
		K_dash = {
			label = "Coup de hanche défilé", startup = 0.1, active = 0.2, recovery = 0.3,
			damage = 11, hitbox = box(4.5, 3.5, 2, 0), kbBase = 32, kbGrowth = 65, kbAngle = 30, selfVelocity = Vector2.new(46, 0),
			windup = { Root = { 0, -30, -10, 0.15, -0.2, 0 }, Waist = { 0, -14, -12 }, Neck = { 0, 26, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 10, 0, -40 }, LE = { 120, 0, 0 } },
			strike = { Root = { -6, -70, 14, -0.3, -0.3, -0.3 }, Waist = { 0, 10, 16 }, Neck = { 6, 50, 0 }, RS = { 150, 0, 40 }, RE = { 30, 0, 0 }, LS = { 10, 0, -45 }, LE = { 120, 0, 0 } },
			follow = { Root = { -6, -76, 16, -0.32, -0.3, -0.35 }, Waist = { 0, 12, 18 }, Neck = { 6, 54, 0 }, RS = { 155, 0, 42 }, RE = { 30, 0, 0 }, LS = { 10, 0, -46 }, LE = { 122, 0, 0 } },
			fx = { "dust" }, text = "DÉFILÉ !", hitText = "BOUM-HANCHE !",
		},

		-- K K : Talon retourné, un tour sur elle-même, le talon compensé tendu comme une aiguille
		K_combo2 = {
			label = "Talon retourné", startup = 0.09, active = 0.12, recovery = 0.22,
			damage = 8, hitbox = box(5.5, 4, 3, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { 4, -40, 0, 0, -0.15, 0.1 }, Waist = { 4, -24, 0 }, Neck = { 0, 30, 0 }, RS = { 50, 0, 50 }, RE = { 40, 0, 0 }, LS = { 50, 0, -50 }, LE = { 50, 0, 0 }, RH = { 50, 0, 20 }, RK = { -100, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 80 }, RE = { 10, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			follow = { Root = { 16, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 58, 0, 84 }, RE = { 10, 0, 0 }, LS = { 58, 0, -84 }, LE = { 10, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "VLAN !",
		},
		-- K K K K : Coup de pied vlog, elle saute et décoche un coup de pied face caméra, « abonnez-vous ! » (finition)
		K_combo3 = {
			label = "Coup de pied vlog", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 82, kbAngle = 42, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { -30, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { 16, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, LS = { 70, 0, -70 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 155, 0, 32 }, RE = { 20, 0, 0 }, LS = { 72, 0, -72 }, LE = { 20, 0, 0 }, RH = { 108, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 34, 0, 0 }, LK = { -114, 0, 0 } },
			trail = "rightFoot", text = "ABONNEZ-VOUS !", hitText = "BAM !",
		},
		-- P puis K : Petit coup de talon dans le tibia, en gardant la pose
		PK_combo = {
			label = "Coup de talon en douce", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { 4, -10, 0, 0, -0.15, 0.1 }, Waist = { 4, -10, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 }, RH = { -20, 0, 6 }, RK = { -70, 0, 0 } },
			strike = { Root = { -4, 8, 0, 0, -0.22, -0.2 }, Waist = { -6, 8, 0 }, RS = { 75, 0, 25 }, RE = { 30, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 }, RH = { 60, 0, 4 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -6, 10, 0, 0, -0.24, -0.24 }, Waist = { -6, 10, 0 }, RS = { 76, 0, 26 }, RE = { 30, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- K puis P : Revers de perche, en se remettant d'aplomb elle fouette de la perche en revers
		KP_combo = {
			label = "Revers de perche", startup = 0.08, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(6, 4, 3.5, 1), kbBase = 24, kbGrowth = 38, kbAngle = 40,
			windup = { Root = { 2, 26, 0, 0, -0.2, 0.1 }, Waist = { 2, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 120, 0, -30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, -16, 0, 0, -0.3, -0.3 }, Waist = { -10, -24, 0 }, Neck = { 0, 14, 0 }, RS = { 100, 0, 50 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
			follow = { Root = { -8, -22, 0, 0, -0.3, -0.34 }, Waist = { -10, -30, 0 }, Neck = { 0, 18, 0 }, RS = { 95, 0, 70 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 32, 0, -30 }, LE = { 70, 0, 0 } },
			trail = "prop", hitText = "FLIP !",
		},

		-- P P P : Duckface, elle avance les lèvres en cœur et colle sa moue dans le nez d'en face
		P_duckface = {
			label = "Duckface", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(5, 4, 2.8, 1), kbBase = 20, kbGrowth = 26, kbAngle = 35,
			windup = { Root = { 6, 10, 4, 0, -0.1, 0.1 }, Waist = { 8, 10, 6 }, Neck = { 12, -10, 8 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -10 }, LE = { 130, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.3, -0.4 }, Waist = { -14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -16, 0, 0, 0, -0.32, -0.45 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 6 }, RS = { 28, 0, 52 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 28, 0, -52 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "head", fx = { { "symbols", symbols = { "💋", "😘" }, count = 3, radius = 2, at = "front", color = ROSE_VIF } }, text = "MWAH !", hitText = "SMACK !",
		},
		-- → P P P : Scroll infini, la perche monte et descend à toute vitesse comme un pouce qui scrolle, trois coups
		P_scroll = {
			label = "Scroll infini", startup = 0.06, active = 0.2, recovery = 0.18,
			damage = 3, hits = 3, hitbox = box(5.5, 4.5, 3.2, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 45,
			windup = { Root = { -4, 10, 0, 0, -0.2, 0.1 }, Waist = { -6, 10, 0 }, Neck = { -10, -10, 0 }, RS = { 130, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, 6, 0, 0, -0.28, -0.3 }, Waist = { -10, 6, 0 }, Neck = { -14, -6, 0 }, RS = { 60, 0, 5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 } },
			follow = { Root = { -8, 6, 0, 0, -0.28, -0.3 }, Waist = { -10, 6, 0 }, Neck = { -12, -6, 0 }, RS = { 125, 0, 5 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "👍", "💬", "❤️" }, count = 4, radius = 2.5, at = "front" } }, text = "SCROLL-SCROLL !", hitText = "TAP-TAP-TAP !",
		},
		-- → P P P P : Unfollow !, un revers de perche méprisant qui envoie l'adversaire tout au bout de l'arène (finition)
		P_unfollow = {
			label = "Unfollow !", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(6, 4.5, 3.5, 0.8), kbBase = 38, kbGrowth = 78, kbAngle = 22,
			windup = { Root = { 2, 36, 0, 0, -0.2, 0.2 }, Waist = { 2, 40, 0 }, Neck = { 6, -30, 10 }, RS = { 100, 0, -45 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 } },
			strike = { Root = { -8, -30, 0, 0, -0.3, -0.4 }, Waist = { -10, -40, 0 }, Neck = { 6, 30, 10 }, RS = { 92, 0, 55 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -8, -40, 0, 0, -0.3, -0.42 }, Waist = { -10, -50, 0 }, Neck = { 8, 36, 12 }, RS = { 86, 0, 80 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 20, 0, -40 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", fx = { { "text", text = "ABONNÉS : -1", color = ROSE_VIF, at = "above" }, { "burst", color = LILAS, size = 3, at = "front" } }, text = "UNFOLLOW !", hitText = "BLOQUÉ, SUPPRIMÉ !",
		},
		-- ↓ P P : Story en direct, de sa glissade elle se relève en filmant, la perche remonte dans le menton
		P_story = {
			label = "Story en direct", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 5, 2.8, 1.5), kbBase = 22, kbGrowth = 30, kbAngle = 70,
			windup = { Root = { 10, 0, 6, 0, -1.0, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 10 }, RS = { 40, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -10 }, LE = { 130, 0, 0 }, RH = { 70, 0, 0 }, RK = { -40, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 6, 8, 4, 0, -0.1, -0.2 }, Waist = { 10, 8, 6 }, Neck = { 20, -6, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -10 }, LE = { 130, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 8, 10, 6, 0, -0.05, -0.22 }, Waist = { 12, 10, 8 }, Neck = { 24, -8, 0 }, RS = { 175, 0, 6 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 132, 0, -10 }, LE = { 132, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 } },
			trail = "prop", fx = { { "text", text = "🔴 EN DIRECT", color = Color3.fromRGB(255, 60, 60), at = "above" } }, text = "ON EST EN LIVE !", hitText = "DIS BONJOUR !",
		},
		-- ↓ P P P : Boomerang, la perche décrit un tour complet autour d'elle façon vidéo boomerang (finition)
		P_boomerang = {
			label = "Boomerang", startup = 0.1, active = 0.2, recovery = 0.3,
			damage = 11, hitbox = box(7, 4, 2.5, 0.8), kbBase = 36, kbGrowth = 78, kbAngle = 40,
			windup = { Root = { 0, -40, 0, 0, -0.25, 0 }, Waist = { 0, -30, 0 }, Neck = { 0, 25, 0 }, RS = { 90, 0, 70 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 50, 0, 0 } },
			strike = { Root = { -2, 0, 0, 0, -0.15, -0.1 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			follow = { Root = { -2, 0, 0, 0, -0.15, -0.1 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", fx = { { "symbols", symbols = { "🔁", "✨" }, count = 4, radius = 3, color = LILAS } }, text = "BOOMERANG !", hitText = "ET RETOUR !",
		},
		-- K K K : Pas de catwalk, deux pas de défilé croisés, chaque genou qui monte cogne au passage
		K_catwalk = {
			label = "Pas de catwalk", startup = 0.07, active = 0.16, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5, 4, 3, 0.8), kbBase = 18, kbGrowth = 26, kbAngle = 45, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { -2, 10, -4, 0, -0.1, 0.1 }, Waist = { 0, 10, -8 }, Neck = { 4, -8, 0 }, RS = { -30, 0, 15 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 110, 0, 0 }, RH = { 40, 0, -10 }, RK = { -60, 0, 0 } },
			strike = { Root = { -6, -10, 4, 0, -0.15, -0.25 }, Waist = { -4, -10, 8 }, Neck = { 4, 8, 0 }, RS = { -40, 0, 15 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 110, 0, 0 }, RH = { 100, 0, -10 }, RK = { -100, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -6, 10, -4, 0, -0.15, -0.3 }, Waist = { -4, 10, -8 }, Neck = { 4, -8, 0 }, RS = { 30, 0, 15 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 110, 0, 0 }, LH = { 100, 0, 10 }, LK = { -100, 0, 0 }, LA = { -20, 0, 0 } },
			wobble = true, trail = "bothFeet", fx = { { "symbols", symbols = { "📸", "✨" }, count = 3, radius = 3, color = FLASH } }, text = "CATWALK !", hitText = "GENOU-GENOU !",
		},
		-- → K K : Changement de pose, elle change de jambe d'appui et reprend la pose : la gauche part tendue, perche levée
		K_side2 = {
			label = "Changement de pose", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(5.5, 4, 3.2, 0.8), kbBase = 22, kbGrowth = 32, kbAngle = 30,
			windup = { Root = { 4, 20, 0, 0, -0.15, 0.1 }, Waist = { 4, 16, 0 }, Neck = { 0, -16, 0 }, RS = { 150, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 110, 0, 0 }, LH = { 60, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 14, -10, 0, 0, -0.15, -0.25 }, Waist = { 10, -8, 0 }, Neck = { 6, -20, 0 }, RS = { 165, 0, 35 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 110, 0, 0 }, LH = { 100, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 15, -12, 0, 0, -0.15, -0.28 }, Waist = { 11, -9, 0 }, Neck = { 8, -22, 0 }, RS = { 167, 0, 37 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 112, 0, 0 }, LH = { 102, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
			hold = 0.08, trail = "leftFoot", fx = { { "burst", color = FLASH, size = 2, at = "hand" } }, text = "AUTRE POSE !", hitText = "CLIC !",
		},
		-- → K K K : Saut photo final, elle saute en ciseaux, perche braquée sur elle, flash au sommet (finition)
		K_side3 = {
			label = "Saut photo final", startup = 0.1, active = 0.14, recovery = 0.34,
			damage = 12, hitbox = box(6, 5, 3, 1.2), kbBase = 36, kbGrowth = 80, kbAngle = 45, selfVelocity = Vector2.new(16, 36),
			windup = { Root = { -8, 0, 0, 0, -0.55, 0.1 }, Waist = { -12, 0, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 12, 10, 0 }, Waist = { 10, 6, 0 }, Neck = { 12, -12, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, 10 }, LE = { 130, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -40, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 14, 12, 0 }, Waist = { 12, 6, 0 }, Neck = { 14, -14, 0 }, RS = { 175, 0, 32 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 132, 0, 10 }, LE = { 132, 0, 0 }, RH = { 106, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -44, 0, 0 }, LK = { -20, 0, 0 } },
			hold = 0.1, trail = "rightFoot", fx = { { "burst", color = FLASH, size = 4, at = "above" }, { "screen", color = FLASH, alpha = 0.2 }, { "symbols", symbols = { "📸", "⭐" }, count = 4, radius = 3 } }, text = "ET… SAUTE !", hitText = "PHOTO DU SIÈCLE !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Kick compensé, la semelle compensée part à l'horizontale, perche en arrière
		P_air_side = {
			label = "Kick compensé", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(5, 3, 3, 0), kbBase = 22, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { -12, 10, 0 }, Waist = { -10, 6, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -125, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 20, 12, 0 }, Waist = { 10, 4, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 55 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 72, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 20, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 24, 14, 0 }, Waist = { 12, 4, 0 }, Neck = { -12, 0, 0 }, RS = { -35, 0, 58 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 42, 0, -72 }, LE = { 30, 0, 0 }, RH = { 76, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 16, 0, 0 }, LK = { -98, 0, 0 } },
			trail = "rightFoot", hitText = "CLAC !",
		},
		-- ↑ P en l'air : Selfie en plongée, la perche décrit un grand arc au-dessus de sa tête
		P_air_up = {
			label = "Selfie en plongée", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5.5, 4, 0.5, 3.8), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -30, 0, 35 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 165, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -10 }, LE = { 130, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 198, 0, 5 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 112, 0, -10 }, LE = { 132, 0, 0 }, RH = { 5, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -45, 0, 0 } },
			trail = "prop", fx = { { "burst", color = FLASH, size = 2, at = "above" } }, hitText = "CLIC !",
		},
		-- ↓ P en l'air : Perche plongeante, la perche pointée droit vers le sol, tout le corps derrière (smash vers le bas)
		P_air_down = {
			label = "Perche plongeante", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(3, 4.5, 1, -2.5), kbBase = 25, kbGrowth = 55, kbAngle = -78,
			windup = { Root = { 14, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 15 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -40 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { -16, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -50 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -20, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 10, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 125, 0, -55 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -55, 0, 0 }, LH = { 35, 0, 0 }, LK = { -85, 0, 0 } },
			trail = "prop", text = "EN PLONGÉE !", hitText = "TCHONK !",
		},
		-- → K en l'air : Talon star, buste en arrière, la jambe droite fouette à l'horizontale
		K_air_side = {
			label = "Talon star", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { -14, 20, 0 }, Waist = { -14, 10, 0 }, RS = { 60, 0, 40 }, RE = { 70, 0, 0 }, LS = { 70, 0, -30 }, LE = { 80, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 28, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -14, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 30, 0, -70 }, LE = { 40, 0, 0 }, RH = { 66, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 32, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -16, 0, 0 }, RS = { 155, 0, 42 }, RE = { 20, 0, 0 }, LS = { 32, 0, -72 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 }, LH = { 16, 0, 0 }, LK = { -106, 0, 0 } },
			trail = "rightFoot", hitText = "STAR !",
		},
		-- ↑ K en l'air : Backflip story, salto arrière en pointe de pied, comme dans ses vidéos
		K_air_up = {
			label = "Backflip story", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 120, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 25, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 162, 0, 42 }, RE = { 10, 0, 0 }, LS = { 122, 0, -62 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 25, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "BACKFLIP !", hitText = "POC !",
		},
		-- ↓ K en l'air : Talons aiguilles, les deux talons compensés plantés vers le sol (smash vers le bas)
		K_air_down = {
			label = "Talons aiguilles", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 150, 0, 45 }, RE = { 10, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 155, 0, 48 }, RE = { 10, 0, 0 }, LS = { 10, 0, -42 }, LE = { 115, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "TALONS !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Signatures (L) : sûres de toucher (couloir / projectiles visés, voir docs/fiche-perso.md)
		-- Le Flash : téléphone braqué devant elle, un flash énorme éclaire tout le couloir et étourdit tout ce qu'il y a dedans
		S_neutral = {
			label = "Le Flash", startup = 0.18, active = 0.12, recovery = 0.42,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 12, kbGrowth = 12, kbAngle = 20,
			status = { name = "stunned", duration = 0.6 },
			windup = { Root = { 4, -10, 0, 0, -0.15, 0.15 }, Waist = { 4, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 70, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, 30 }, LE = { 140, 0, 0 } },
			strike = { Root = { -8, 8, 0, 0, -0.25, -0.3 }, Waist = { -6, 8, 0 }, Neck = { -6, -8, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { 15, 0, 0 }, LS = { 150, 0, 40 }, LE = { 140, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -8, 10, 0, 0, -0.25, -0.32 }, Waist = { -6, 10, 0 }, Neck = { -6, -10, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 18, 0, 0 }, LS = { 152, 0, 40 }, LE = { 142, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			hold = 0.1, trail = "prop", fx = { { "burst", color = FLASH, size = 6, at = "front" }, { "beam", color = FLASH, length = 16, width = 4, at = "hand" }, { "screen", color = FLASH, alpha = 0.2 } },
			text = "FLASH !", hitText = "ÉBLOUI !",
		},
		-- Hashtag : elle tape le hashtag sur son téléphone et un gros # bleu fonce droit sur la tête de l'adversaire
		S_side = {
			label = "Hashtag", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
			damage = 14, kbBase = 26, kbGrowth = 52, kbAngle = 30,
			projectile = { speed = 48, angle = 0, gravity = 0, lifetime = 1.0, size = 2.4, color = BLEU, homing = 0.3,
				visual = { shape = "block", size = 2, color = BLEU, neon = true, transparency = 0.15, text = "#", spin = 3 } },
			windup = { Root = { 2, -14, 0, 0, -0.15, 0.15 }, Waist = { 0, -12, 0 }, Neck = { -12, 0, 0 }, RS = { 80, 0, -20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 110, 0, 0 } },
			strike = { Root = { -8, 16, 0, 0, -0.25, -0.3 }, Waist = { -8, 18, 0 }, Neck = { 6, -10, 0 }, RS = { 50, 0, 40 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -10, 18, 0, 0, -0.25, -0.35 }, Waist = { -10, 20, 0 }, Neck = { 8, -12, 0 }, RS = { 48, 0, 42 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			trail = "leftHand", fx = { { "symbols", symbols = { "#" }, count = 3, radius = 2, at = "lhand", color = BLEU } }, text = "#BAGARRE !", hitText = "#OUILLE !",
		},
		-- Filtre chien : elle tape sur l'écran et le filtre tombe du ciel pile sur la tête de l'adversaire : oreilles de chien,
		-- plus de signatures ni de coups lourds pendant 3 s
		S_down = {
			label = "Filtre chien", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
			damage = 12, kbBase = 14, kbGrowth = 14, kbAngle = 60,
			status = { name = "dog", duration = 3 },
			projectile = { speed = 55, gravity = 50, lifetime = 0.9, size = 3, color = ROSE, rain = { count = 1, spread = 0.5, ahead = 8, height = 18 },
				visual = { shape = "disc", size = 2.6, color = ROSE, neon = true, transparency = 0.2, text = "🐶", spin = 4 } },
			windup = { Root = { -4, -10, 0, 0, -0.2, 0.1 }, Waist = { -8, -8, 0 }, Neck = { -14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 6, 10, 0, 0, 0.05, 0 }, Waist = { 10, 10, 0 }, Neck = { 28, 0, 0 }, RS = { 176, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -30 }, LE = { 120, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 6, 12, 0, 0, 0.05, 0 }, Waist = { 10, 12, 0 }, Neck = { 30, 0, 0 }, RS = { 180, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 122, 0, -32 }, LE = { 120, 0, 0 } },
			trail = "prop", fx = { { "symbols", symbols = { "🐶", "✨" }, count = 5, radius = 3, at = "above" }, { "burst", color = ROSE, size = 2.5, at = "above" } }, text = "FILTRE CHIEN !", hitText = "OUAF !",
		},
		-- Drone caméra (remontée) : elle attrape son drone de vlog qui l'emporte en diagonale vers l'avant, bras tendu vers
		-- le ciel, jambes qui flottent derrière, et elle filme tout ce qu'elle percute au passage
		S_up = {
			label = "Drone caméra", startup = 0.15, active = 0.32, recovery = 0.4,
			damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 70, selfVelocity = Vector2.new(44, 86),
			windup = { Root = { 4, 0, 0, 0, -0.6, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 150, 0, 15 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { -40, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -50 }, LE = { 30, 0, 0 }, RH = { -22, 0, 6 }, RK = { -35, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -6 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -44, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 174, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 115, 0, -55 }, LE = { 30, 0, 0 }, RH = { -30, 0, 8 }, RK = { -45, 0, 0 }, RA = { -30, 0, 0 }, LH = { -42, 0, -8 }, LK = { -60, 0, 0 }, LA = { -30, 0, 0 } },
			prop = "drone", hideProp = "perche", trail = "body",
			windupFx = { { "symbols", symbols = { "🔴" }, count = 1, radius = 1.5, at = "hand", color = Color3.fromRGB(255, 60, 60) } },
			fx = { { "ring", color = ARGENT, radius = 4, at = "feet" }, { "particles", tex = "smoke", color = BLANC, dir = "down", at = "hand", time = 0.35, speed = 16, size = 0.7, rate = 70 }, { "symbols", symbols = { "📹", "✨" }, count = 3, radius = 2 } },
			text = "DRONE !", hitText = "VZZZ !",
		},
		-- Pluie de cœurs (plongeon) : elle pique vers le sol perche en avant dans une cascade de cœurs, sur tout ce qu'il y a dessous (+likes)
		S_air_down = {
			label = "Pluie de cœurs", startup = 0.16, active = 0.35, recovery = 0.45,
			damage = 14, hitbox = box(8, 6, 1, -2), kbBase = 28, kbGrowth = 55, kbAngle = -60, selfVelocity = Vector2.new(8, -82),
			selfEffect = { meter = 100 },
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -30, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -40 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -34, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 25, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -45 }, LE = { 20, 0, 0 }, RH = { -12, 0, 0 }, RK = { -40, 0, 0 }, LH = { 8, 0, 0 }, LK = { -58, 0, 0 } },
			trail = "prop", fx = { { "rain", shape = "ball", color = ROSE_VIF, count = 12, radius = 6, size = 0.6 }, { "ring", color = ROSE, radius = 6, at = "feet" }, { "symbols", symbols = { "❤️", "💖" }, count = 6, radius = 4 } },
			text = "LOVE !", hitText = "+100 ❤️",
		},
		-- Bloquer l'utilisateur (esquive puis S) : ring light brandie en bouclier, puis poussée d'un coup sec sur toute la
		-- longueur du couloir ; le prochain coup reçu pendant la pose est bloqué et elle riposte
		S_dodge = {
			label = "Bloquer l'utilisateur", kind = "counter", startup = 0.15, active = 0.4, recovery = 0.45,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 32, kbGrowth = 56, kbAngle = 32,
			counter = { window = 0.6, text = "BLOQUÉ !", riposte = { damage = 16, kbBase = 40, kbGrowth = 75, kbAngle = 35, hitText = "UTILISATEUR BLOQUÉ !" } },
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 6, 20, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { -70, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.45 }, Waist = { -10, 0, 0 }, Neck = { 6, 30, 0 }, RS = { 98, 0, -6 }, RE = { 0, 0, 0 }, RW = { -75, 0, 0 }, LS = { 10, 0, -45 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, 0, 0, 0, -0.35, -0.45 }, Waist = { -10, 0, 0 }, Neck = { 8, 32, 0 }, RS = { 100, 0, -6 }, RE = { 0, 0, 0 }, RW = { -76, 0, 0 }, LS = { 10, 0, -46 }, LE = { 112, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			hold = 0.2, prop = "ringlight", hideProp = "perche", trail = "prop", fx = { { "ring", color = FLASH, radius = 4, at = "front" }, { "beam", color = FLASH, length = 14, width = 3, at = "hand" } }, text = "BLOQUÉE !", hitText = "UTILISATEUR BLOQUÉ !",
		},
		-- Panoramique en live (S maintenu) : elle lance le direct et balaie tout le couloir d'un grand panoramique de perche,
		-- de gauche à droite (« dis bonjour aux abonnés ! »), puis salue ses abonnés ; les likes pleuvent (+300 likes)
		S_hold = {
			label = "Panoramique en live", startup = 0.26, active = 0.16, recovery = 0.5,
			damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 32, kbGrowth = 58, kbAngle = 35,
			selfEffect = { meter = 300 },
			windup = { Root = { 4, -34, 4, 0, -0.15, 0.1 }, Waist = { 4, -30, 6 }, Neck = { 10, 16, 0 }, RS = { 80, 0, 70 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, 26, 0, 0, -0.3, -0.4 }, Waist = { -10, 30, 0 }, Neck = { 0, -16, 0 }, RS = { 98, 0, -24 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -35 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { 4, 10, 6, 0, -0.1, 0 }, Waist = { 6, 8, 8 }, Neck = { 20, -6, 6 }, RS = { 145, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 40, 0, 0 } },
			hold = 0.4, trail = "prop", fx = { { "symbols", symbols = { "❤️", "👍", "💬" }, count = 8, radius = 4 }, { "text", text = "🔴 LIVE", color = Color3.fromRGB(255, 60, 60), at = "above" }, { "ring", color = ROSE, radius = 5, at = "front" } },
			text = "COUCOU LES LOLAS !", hitText = "DIS BONJOUR !",
		},
		-- Swipe (→→S) : grand geste de swipe de la main gauche et elle file en un éclair d'un bout à l'autre du couloir
		S_dash = {
			label = "Swipe", startup = 0.15, active = 0.24, recovery = 0.42,
			damage = 13, hitbox = box(12, 5, 5, 0.5), kbBase = 32, kbGrowth = 58, kbAngle = 25, selfVelocity = Vector2.new(80, 0), invuln = 0.2,
			windup = { Root = { -6, -20, 0, 0, -0.25, 0.1 }, Waist = { -4, -20, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, LS = { 80, 0, 60 }, LE = { 30, 0, 0 } },
			strike = { Root = { -18, 10, 0, 0, -0.35, -0.2 }, Waist = { -8, 16, 0 }, Neck = { 10, -10, 0 }, RS = { -20, 0, 40 }, RE = { 40, 0, 0 }, LS = { 90, 0, -80 }, LE = { 5, 0, 0 } },
			follow = { Root = { -20, 12, 0, 0, -0.35, -0.25 }, Waist = { -8, 18, 0 }, Neck = { 12, -12, 0 }, RS = { -25, 0, 42 }, RE = { 40, 0, 0 }, LS = { 85, 0, -95 }, LE = { 5, 0, 0 } },
			trail = "body", fx = { "dust", { "symbols", symbols = { "👉", "✨" }, count = 3, radius = 2 } }, text = "SWIPE !", hitText = "SKIP !",
		},
		-- Gros cœur (S en l'air) : elle envoie un gros cœur à tête chercheuse qui file droit sur l'adversaire, depuis les airs
		S_air = {
			label = "Gros cœur", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
			damage = 13, kbBase = 24, kbGrowth = 45, kbAngle = 35,
			projectile = { speed = 55, angle = -20, gravity = 0, lifetime = 0.7, size = 2.2, color = ROSE_VIF, homing = 0.5,
				visual = { shape = "ball", size = 1.8, color = ROSE_VIF, neon = true, text = "❤", spin = 2 } },
			windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, 20 }, LE = { 130, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -14, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 0, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -16, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 72, 0, 42 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -12 }, LE = { 0, 0, 0 }, RH = { 48, 0, 0 }, RK = { -78, 0, 0 }, LH = { 18, 0, 0 }, LK = { -58, 0, 0 } },
			trail = "leftHand", fx = { { "symbols", symbols = { "❤️", "💖" }, count = 4, radius = 2, at = "lhand" } }, text = "BISOUS !", hitText = "❤️",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Pose finale : grand balayage de perche, puis flash de la photo de fin
		S_finish_pose = {
			label = "Pose finale", startup = 0.15, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(7, 4, 3.5, 0.8), kbBase = 32, kbGrowth = 65, kbAngle = 35,
			windup = { Root = { 6, -30, 0, 0, -0.2, 0.25 }, Waist = { 6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 } },
			strike = { Root = { -8, 22, 0, 0, -0.3, -0.35 }, Waist = { -10, 28, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, -20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 118, 0, 0 } },
			follow = { Root = { 6, 26, 6, 0, -0.25, -0.38 }, Waist = { 6, 30, 8 }, Neck = { 10, -16, 6 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 118, 0, 0 } },
			hold = 0.12, trail = "prop", fx = { { "burst", color = FLASH, size = 4, at = "front" } }, text = "ET… CLIC !", hitText = "PHOTO FINALE !",
		},
		-- Ring light tournante : elle sort la ring light et tourne deux fois sur elle-même, cercle de lumière à bout de bras
		S_finish_ring = {
			label = "Ring light tournante", startup = 0.1, active = 0.3, recovery = 0.3,
			damage = 11, hitbox = box(8, 4, 0, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 45,
			windup = { Root = { 0, -30, 0, 0, -0.3, 0 }, Waist = { 0, -20, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -0.1, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.1, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, prop = "ringlight", hideProp = "perche", trail = "prop", text = "LUMIÈRE !", hitText = "BZZZT !",
		},

		------------------------------------------------------------------ Supers (Y) : couloir 1,3 fois plus grand, plus farfelus
		-- Virale ! (Y) : elle publie la vidéo, une avalanche de notifications tombe du ciel pile sur l'adversaire et elle devient virale
		SUPER = {
			label = "Virale !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 4, kbBase = 18, kbGrowth = 22, kbAngle = 50,
			selfEffect = { buff = { "viral", 4 } },
			projectile = { speed = 55, gravity = 30, lifetime = 1.2, size = 2, color = ROSE_VIF, rain = { count = 6, spread = 5, ahead = 9, height = 22 },
				visual = { shape = "block", size = 1.5, color = BLANC, text = "🔔", parts = { { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0.8, 0.8, 0), ROSE_VIF } } } },
			windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 90, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 6, 10, 4, 0, 0.1, 0 }, Waist = { 12, 10, 6 }, Neck = { 26, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 6, 14, 6, 0, 0.1, 0 }, Waist = { 14, 12, 8 }, Neck = { 30, 0, 6 }, RS = { 172, 0, 32 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -55 }, LE = { 20, 0, 0 } },
			hold = 0.3, windupFx = { "super", { "text", text = "PUBLIER…", color = BLEU } },
			fx = { { "symbols", symbols = { "🔔", "❤️", "💬", "📈" }, count = 12, radius = 6 }, { "screen", color = ROSE, alpha = 0.25 }, { "ring", color = ROSE_VIF, radius = 8, at = "above" } },
			text = "JE SUIS VIRALE !", hitText = "DING DING DING !",
		},
		-- Perche télescopique (→Y) : elle déplie la perche cran par cran, encore, encore… jusqu'à ce qu'elle traverse tout le
		-- couloir comme une lance de tournoi, le téléphone au bout en pleine figure de tout le monde, et flash pour la photo
		SUPER_side = {
			label = "Perche télescopique !", startup = 0.42, active = 0.24, recovery = 0.72,
			damage = 26, hitbox = box(14, 6, 7, 1), kbBase = 50, kbGrowth = 100, kbAngle = 24,
			status = { name = "stunned", duration = 0.5 },
			windup = { Root = { 6, -30, 0, 0, -0.25, 0.25 }, Waist = { 8, -32, 0 }, Neck = { 4, 22, 0 }, RS = { 50, 0, 20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, 24, 0, 0, -0.45, -0.6 }, Waist = { -12, 28, 0 }, Neck = { 6, -18, 0 }, RS = { 94, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.75 } },
			follow = { Root = { -18, 26, 0, 0, -0.48, -0.65 }, Waist = { -14, 30, 0 }, Neck = { 8, -20, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { -4, 0, 0 }, LS = { 134, 0, -62 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.8 } },
			hold = 0.3, shake = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "CLIC", "CLIC", "CLIC" }, count = 5, radius = 2.5, at = "hand", color = ARGENT } },
			fx = { { "beam", color = ARGENT, length = 18, width = 1.6, at = "hand" }, { "burst", color = FLASH, size = 5, at = "front" }, { "screen", color = FLASH, alpha = 0.25 }, { "symbols", symbols = { "📸", "✨" }, count = 6, radius = 4, at = "front" }, { "shake", amount = 0.4 } },
			text = "ENCORE PLUS LOIN !", hitText = "EMBROCHÉ-FLASHÉ !",
		},
		-- Auréole de ring light (Y↑) : accroupie, elle sort la ring light, se dresse sur les pointes et la brandit au-dessus de sa
		-- tête en tournant : une auréole de lumière qui aspire tout le couloir vers le ciel (et aveugle)
		SUPER_up = {
			label = "Auréole de ring light !", startup = 0.35, active = 0.3, recovery = 0.7,
			damage = 24, hitbox = box(14, 12, 7, 3), kbBase = 46, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			status = { name = "blinded", duration = 1.5 },
			windup = { Root = { -8, 0, 0, 0, -0.7, 0.05 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 40, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.35, 0 }, Waist = { 8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 182, 0, 6 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 182, 0, -6 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.4, 0 }, Waist = { 10, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 185, 0, 8 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 185, 0, -8 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			hold = 0.35, spin = { axis = "y", degrees = 360 }, selfVelocity = Vector2.new(0, 40), prop = "ringlight", hideProp = "perche", trail = "prop",
			windupFx = { "super", { "text", text = "LUMIÈRE…", color = FLASH, at = "above" } },
			fx = { { "pillar", color = FLASH, height = 24, width = 7, at = "front" }, { "screen", color = FLASH, alpha = 0.45 }, { "burst", color = ROSE_VIF, size = 5, at = "above" }, { "symbols", symbols = { "✨", "📸", "😇" }, count = 8, radius = 4 } },
			text = "AURÉOLE !", hitText = "SAINTE LOLA !",
		},
		-- Collab ! (Y↓) : elle lance un appel en live et un perso du roster débarque pour balayer tout le couloir (3 invités possibles)
		SUPER_down = {
			label = "Collab !", startup = 0.45, active = 0.2, recovery = 0.75,
			damage = 24, hitbox = box(14, 8, 7, 1), kbBase = 36, kbGrowth = 72, kbAngle = 45,
			variants = {
				{ label = "Collab avec Gégé !", status = { name = "inverted", duration = 3 }, hitText = "SODA DOUTEUX !" },
				{ label = "Collab avec Mamie !", status = { name = "rooted", duration = 2 }, hitText = "LIGOTÉ PAR MAMIE !" },
				{ label = "Collab avec Chef Flambé !", burn = true, hitText = "FLAMBÉ !" },
			},
			windup = { Root = { 2, 10, 0, 0, -0.15, 0 }, Waist = { 4, 10, 0 }, Neck = { 10, -10, 0 }, RS = { 140, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 40 }, LE = { 130, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -6, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 150, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -10 }, LE = { 0, 0, 0 } },
			follow = { Root = { -6, -12, 0, 0, -0.2, -0.22 }, Waist = { -6, -12, 0 }, Neck = { 0, 12, 0 }, RS = { 152, 0, 22 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 98, 0, -12 }, LE = { 0, 0, 0 } },
			hold = 0.4, windupFx = { "super", { "text", text = "📞 APPEL EN LIVE…", color = BLEU, at = "above" } },
			fx = { { "pillar", color = BLEU, height = 14, width = 4, at = "front" }, { "burst", color = FLASH, size = 5, at = "front" }, { "beam", color = FLASH, length = 18, width = 4, at = "front" }, { "symbols", symbols = { "🤝", "✨", "📸" }, count = 8, radius = 5 } },
			text = "COLLAB !", hitText = "SURPRISE !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise selfie : elle attrape l'adversaire par l'épaule et colle sa joue à la sienne pour la photo
		GRAB = {
			label = "Prise selfie", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 4, 10, 0, 0, -0.1, 0.1 }, Waist = { 6, 10, 0 }, Neck = { 6, -10, 0 }, RS = { 130, 0, 20 }, RE = { 30, 0, 0 }, LS = { 100, 0, -60 }, LE = { 20, 0, 0 } },
			strike = { Root = { -6, -6, 0, 0, -0.2, -0.3 }, Waist = { -6, -6, 0 }, Neck = { 0, 0, 12 }, RS = { 140, 0, 20 }, RE = { 30, 0, 0 }, LS = { 90, 0, 20 }, LE = { 50, 0, 0 } },
			follow = { Root = { -6, -8, 0, 0, -0.2, -0.3 }, Waist = { -6, -8, 0 }, Neck = { 0, 0, 14 }, RS = { 142, 0, 20 }, RE = { 30, 0, 0 }, LS = { 92, 0, 24 }, LE = { 55, 0, 0 } },
			text = "UN PETIT SELFIE ?", hitText = "CHEESE !",
		},
		-- ✋ puis → : Story en direct, le flash l'aveugle, puis elle le repousse d'un coup de perche
		THROW_fwd = {
			label = "Story en direct", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 12,
			status = { name = "blinded", duration = 1.5 },
			carry = { { 0, 2.4, 0.4 }, { 0.16, 2.2, 0.4 }, { 0.32, 4.5, 0.2 } },
			windup = { Root = { 4, 10, 0, 0, -0.15, 0.2 }, Waist = { 4, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 120, 0, -10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, -10, 0, 0, -0.35, -0.45 }, Waist = { -12, -10, 0 }, Neck = { 6, 10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 0 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, -12, 0, 0, -0.38, -0.5 }, Waist = { -14, -12, 0 }, Neck = { 8, 12, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { -4, 0, 0 }, LS = { 92, 0, 0 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			fx = { { "burst", color = FLASH, size = 4, at = "front" } }, text = "EN DIRECT !", hitText = "ZIOUUU !",
		},
		-- ✋ puis ← : Unfollow, sans même regarder elle jette l'adversaire par-dessus son épaule
		THROW_back = {
			label = "Unfollow", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 11, kbBase = 35, kbGrowth = 70, kbAngle = 40,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.0, 1.5 }, { 0.28, -1.0, 2.5 }, { 0.4, -2.6, 0.5 } },
			windup = { Root = { -6, 20, 0, 0, -0.3, 0 }, Waist = { -6, 20, 0 }, Neck = { 0, -30, 0 }, RS = { 60, 0, 20 }, RE = { 60, 0, 0 }, LS = { 80, 0, 20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 10, -20, 0, 0, -0.2, 0.2 }, Waist = { 10, -20, 0 }, Neck = { 0, 40, 0 }, RS = { 120, 0, 30 }, RE = { 30, 0, 0 }, LS = { 175, 0, -20 }, LE = { 30, 0, 0 } },
			follow = { Root = { 6, -10, 6, 0, -0.15, 0.2 }, Waist = { 6, -10, 8 }, Neck = { 10, 40, 6 }, RS = { 125, 0, 30 }, RE = { 30, 0, 0 }, LS = { 30, 0, -40 }, LE = { 100, 0, 0 } },
			text = "UNFOLLOW !", hitText = "BYE !",
		},
		-- ✋ puis ↑ : Mise en avant, elle glisse la perche sous l'adversaire et le propulse vers le ciel
		THROW_up = {
			label = "Mise en avant", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 2.6, -0.6 }, { 0.32, 1.0, 4.5 } },
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 50, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.25, -0.1 }, Waist = { 12, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 178, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.3, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 182, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 125, 0, -45 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			trail = "prop", text = "MISE EN AVANT !", hitText = "TENDANCE !",
		},
		-- ✋ puis ↓ : Filtre écrasé, elle plaque l'adversaire au sol et s'assoit dessus pour un selfie
		THROW_down = {
			label = "Filtre écrasé", kind = "throw", startup = 0.4, active = 0.1, hold = 0.3, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, 1.6 }, { 0.28, 1.4, -2.0 }, { 0.4, 0.8, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 8, 0, 0, 0, -1.3, -0.6 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 30, 0, 0 }, LS = { 50, 0, -40 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 4, 10, 4, 0, -1.25, -0.6 }, Waist = { 8, 10, 6 }, Neck = { 22, -10, 6 }, RS = { 140, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -10 }, LE = { 130, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			fx = { "dust", { "burst", color = FLASH, size = 3, at = "hand" } }, text = "FILTRE ÉCRASÉ !", hitText = "CLIC !",
		},
	},

	-- Fatals (→ = forward, ← = back) : 1er offert, 2e au niveau de maîtrise 5, 3e au niveau 15
	fatals = {
		{
			id = "filtre_permanent", label = "Filtre permanent", sequence = { "up", "up", "down" },
			-- l'adversaire reste coincé avec des oreilles de chien et la langue pendante
			scene = {
				{ "fxAttacker", { "text", text = "FILTRE CHIEN… POUR TOUJOURS !", color = ROSE_VIF } },
				{ "fx", { "burst", color = FLASH, size = 4, at = "head" } },
				{ "spawn", at = "target", offset = Vector3.new(0, 2.6, 0), life = 4.5, pieces = {
					{ "OreilleG", "", "ball", Vector3.new(0.5, 1.3, 0.35), Vector3.new(-0.6, 0.2, 0), Vector3.new(0, 0, 25), Color3.fromRGB(140, 90, 50), "Fabric" },
					{ "OreilleD", "", "ball", Vector3.new(0.5, 1.3, 0.35), Vector3.new(0.6, 0.2, 0), Vector3.new(0, 0, -25), Color3.fromRGB(140, 90, 50), "Fabric" },
					{ "Truffe", "", "ball", Vector3.new(0.4, 0.3, 0.3), Vector3.new(0, -1.0, -0.7), Vector3.zero, NOIR, "SmoothPlastic" },
					{ "Langue", "", "ball", Vector3.new(0.35, 0.6, 0.12), Vector3.new(0, -1.55, -0.68), Vector3.zero, Color3.fromRGB(255, 110, 140), "SmoothPlastic" },
				} },
				{ "text", "OUAF ?" },
				{ "wait", 0.6 },
				{ "fx", { "symbols", symbols = { "🐶", "🦴", "✨" }, count = 8, radius = 4 } },
				{ "squash", time = 0.3 },
				{ "text", "OUAF OUAF !" },
				{ "fxAttacker", { "text", text = "TROP MIGNON, 1 MILLION DE LIKES !", color = ROSE } },
				{ "wait", 1.4 },
			},
		},
		{
			id = "story_24h", label = "Story 24 h", sequence = { "forward", "down", "back" },
			-- aplati dans un cadre photo, il disparaît quand le chrono « 24h » tombe à zéro
			scene = {
				{ "fxAttacker", { "text", text = "EN STORY !", color = ROSE_VIF } },
				{ "fx", { "screen", color = FLASH, alpha = 0.4 } },
				{ "squash", time = 0.25 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0.5, 0), life = 4, pieces = {
					{ "CadreHaut", "", "block", Vector3.new(5.5, 0.4, 0.4), Vector3.new(0, 2.6, 0), Vector3.zero, BLANC, "SmoothPlastic" },
					{ "CadreBas", "", "block", Vector3.new(5.5, 1.2, 0.4), Vector3.new(0, -2.8, 0), Vector3.zero, BLANC, "SmoothPlastic" },
					{ "CadreG", "", "block", Vector3.new(0.4, 5.6, 0.4), Vector3.new(-2.6, 0, 0), Vector3.zero, BLANC, "SmoothPlastic" },
					{ "CadreD", "", "block", Vector3.new(0.4, 5.6, 0.4), Vector3.new(2.6, 0, 0), Vector3.zero, BLANC, "SmoothPlastic" },
					{ "Chrono", "", "ball", Vector3.new(0.9, 0.9, 0.2), Vector3.new(2.2, 2.2, -0.3), Vector3.zero, ROSE_VIF, "Neon", { neon = true } },
				} },
				{ "text", "24h" },
				{ "wait", 0.6 },
				{ "text", "12h" },
				{ "wait", 0.6 },
				{ "text", "1h…" },
				{ "wait", 0.5 },
				{ "text", "0h" },
				{ "fx", { "burst", color = ROSE, size = 4, at = "root" } },
				{ "hide" },
				{ "fxAttacker", { "text", text = "STORY EXPIRÉE !", color = BLEU } },
				{ "wait", 1 },
			},
		},
		{
			id = "unfollow", label = "Unfollow", sequence = { "down", "back", "down" },
			-- il se pixelise et part à la corbeille avec un « pouf »
			scene = {
				{ "fxAttacker", { "text", text = "UNFOLLOW.", color = BLEU } },
				{ "material", "Slate" },
				{ "color", Color3.fromRGB(150, 150, 170) },
				{ "fx", { "symbols", symbols = { "▓", "░", "▒" }, count = 10, radius = 3, color = BLEU } },
				{ "spawn", at = "target", offset = Vector3.new(4, -1.5, 0), life = 4, pieces = {
					{ "Corbeille", "", "cyl", Vector3.new(2.2, 2.4, 2.4), Vector3.zero, Vector3.zero, ARGENT, "Metal", { axis = "y" } },
					{ "Couvercle", "", "cyl", Vector3.new(0.3, 2.7, 2.7), Vector3.new(-0.6, 1.5, 0), Vector3.new(0, 0, 30), ARGENT, "Metal", { axis = "y" } },
				} },
				{ "shrink", 0.25, time = 0.6 },
				{ "launch", Vector3.new(4, 1.5, 0), time = 0.5 },
				{ "hide" },
				{ "fx", { "burst", color = Color3.fromRGB(220, 220, 230), size = 3, at = "root" } },
				{ "text", "POUF" },
				{ "fxAttacker", { "text", text = "-1 ABONNÉ, BON DÉBARRAS !", color = ROSE_VIF } },
				{ "wait", 1.2 },
			},
		},
	},

	-- Mécanique « likes » : +100 likes par touche ; à 1 000 elle devient virale 8 s (dégâts renforcés)
	passive = { kind = "likes", name = "Likes", icon = "❤️", max = 1000, gain = 100, duration = 8, color = ROSE_VIF },

	-- Recharge ⚡ : selfie à la perche sous la ring light, des cœurs de likes montent et remplissent la barre.
	-- Trois poses photo en boucle : bouche en cœur, signe V, clin d'œil penché.
	charge = {
		label = "Séance selfie",
		loop = 1.5,
		lockWrist = true,
		color = ROSE_VIF,
		keys = {
			{ 0.0, { Root = { 2, 10, 4, 0, -0.15, 0 }, Waist = { 4, 10, 6 }, Neck = { 20, -10, 6 }, RS = { 145, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 15, 0, -35 }, LE = { 110, 0, 0 } } },
			{ 0.35, { Root = { 2, 14, 6, 0, -0.18, 0 }, Waist = { 4, 12, 8 }, Neck = { 22, -14, 10 }, RS = { 146, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 15, 0, -35 }, LE = { 110, 0, 0 } } },
			{ 0.55, { Root = { 2, -6, -4, 0, -0.15, 0 }, Waist = { 4, -6, -6 }, Neck = { 22, -6, -8 }, RS = { 150, 0, 15 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, 10 }, LE = { 140, 0, 0 } } },
			{ 0.9, { Root = { 2, -8, -4, 0, -0.17, 0 }, Waist = { 4, -8, -6 }, Neck = { 24, -8, -10 }, RS = { 151, 0, 15 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 132, 0, 10 }, LE = { 142, 0, 0 } } },
			{ 1.05, { Root = { 6, 0, 8, 0.1, -0.2, 0 }, Waist = { 8, 0, 12 }, Neck = { 26, 0, 16 }, RS = { 140, 0, 20 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 } } },
			{ 1.3, { Root = { 6, 0, 8, 0.1, -0.2, 0 }, Waist = { 8, 0, 12 }, Neck = { 26, 0, 18 }, RS = { 141, 0, 20 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 } } },
			{ 1.5, { Root = { 2, 10, 4, 0, -0.15, 0 }, Waist = { 4, 10, 6 }, Neck = { 20, -10, 6 }, RS = { 145, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 15, 0, -35 }, LE = { 110, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "burst", color = FLASH, size = 1.5, at = "hand" } },
			{ 0.4, { "symbols", symbols = { "❤️", "💖" }, count = 3, radius = 2, at = "above" } },
			{ 0.6, { "burst", color = FLASH, size = 1.5, at = "hand" } },
			{ 1.1, { "burst", color = FLASH, size = 1.5, at = "hand" } },
			{ 1.2, { "text", text = "+1 LIKE", color = ROSE_VIF, at = "above" } },
		},
	},

	-- Manies au repos : elle se recoiffe, vérifie ses likes, prend la pose main sur la hanche
	fidgets = {
		{ duration = 2.0, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 10, -20, -14 }, Waist = { 0, -6, -6 }, LS = { 165, 0, -20 }, LE = { 120, 0, 0 }, LW = { -20, 0, 0 } } },
			{ 0.9, { Neck = { 16, 20, 10 }, Waist = { 0, 6, 6 }, LS = { 150, 0, -60 }, LE = { 60, 0, 0 }, LW = { 10, 0, 0 } } },
			{ 1.3, { Neck = { 6, 0, 0 }, LS = { 30, 0, -20 }, LE = { 50, 0, 0 } } },
			{ 2.0, {} },
		} },
		{ duration = 2.4, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -24, 0, 0 }, Waist = { -6, 0, 0 }, RS = { 70, 0, -20 }, RE = { 130, 0, 0 }, RW = { -60, 0, 0 }, LS = { 40, 0, 10 }, LE = { 100, 0, 0 } } },
			{ 1.6, { Neck = { -26, 6, 0 }, Waist = { -6, 0, 0 }, RS = { 72, 0, -20 }, RE = { 132, 0, 0 }, RW = { -60, 0, 0 }, LS = { 42, 0, 10 }, LE = { 105, 0, 0 } } },
			{ 1.9, { Neck = { 14, 0, 0 }, RS = { 50, 0, 20 }, RE = { 70, 0, 0 }, LS = { 120, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 2.4, {} },
		} },
		{ duration = 1.8, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.35, { Root = { 0, 20, 10, 0.2, -0.2, 0 }, Waist = { 0, -8, -10 }, Neck = { 10, -20, 10 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 } } },
			{ 1.3, { Root = { 0, 22, 12, 0.22, -0.2, 0 }, Waist = { 0, -8, -12 }, Neck = { 12, -24, 12 }, LS = { 10, 0, -46 }, LE = { 116, 0, 0 } } },
			{ 1.8, {} },
		} },
	},
}

-- Pendant qu'elle tient quelqu'un : bras gauche autour de ses épaules, perche levée pour la photo,
-- joue contre joue
data.grabHold = {
	Root = { 0, -10, 6, 0, -0.18, 0.05 },
	Waist = { 2, -8, 8 },
	Neck = { 14, 10, 14 },
	RS = { 150, 0, 15 },
	RE = { 25, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 95, 0, 25 },
	LE = { 70, 0, 0 },
}

-- Retour 🪂 : elle tombe sur une ring light plantée au sol, prend la pose en selfie, flash, puis cache son
-- téléphone dans sa poche arrière
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Socle", "base", "block", Vector3.new(4, 0.5, 3.5), Vector3.new(0, -0.25, 0), Vector3.zero, BLANC, "SmoothPlastic", { reflect = 0.2 } },
		{ "Tapis", "", "cyl", Vector3.new(0.1, 3.2, 3.2), Vector3.new(0, 0.02, 0), Vector3.zero, ROSE, "Fabric", { axis = "y" } },
		{ "Pied", "", "cyl", Vector3.new(5.5, 0.22, 0.22), Vector3.new(2.2, 2.6, 1.0), Vector3.zero, NOIR, "Metal", { axis = "y" } },
		{ "Anneau", "", "cyl", Vector3.new(0.2, 3, 3), Vector3.new(2.2, 6.4, 1.0), Vector3.zero, FLASH, "Neon", { axis = "z", neon = true, light = { FLASH, 16, 2 } } },
		{ "CentreAnneau", "", "cyl", Vector3.new(0.24, 2.2, 2.2), Vector3.new(2.2, 6.4, 1.0), Vector3.zero, ROSE_VIF, "SmoothPlastic", { axis = "z" } },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 30, 0, 0 }, LS = { 120, 0, -50 }, LE = { 30, 0, 0 } } },
		{ 0.35, { Root = { 0, 10, 6, 0, -0.1, 0 }, Waist = { 4, 10, 8 }, Neck = { 20, -10, 8 }, RS = { 145, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, 10 }, LE = { 140, 0, 0 } } },
		{ 0.85, { Root = { 0, 12, 6, 0, -0.1, 0 }, Waist = { 4, 12, 8 }, Neck = { 22, -12, 10 }, RS = { 146, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 132, 0, 10 }, LE = { 142, 0, 0 } } },
		{ 1.15, { Root = { 0, -10, 0, 0, -0.15, 0 }, Waist = { 6, -20, 0 }, Neck = { 0, 30, 0 }, RS = { -40, 0, 40 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 50, 0, 0 } } },
		{ 1.45, { Root = { 0, 6, 4, 0, -0.18, 0 }, Waist = { 0, 6, 6 }, Neck = { 6, -10, 0 }, RS = { 22, 0, 12 }, RE = { 55, 0, 0 }, LS = { 10, 0, -45 }, LE = { 115, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.3, { "symbols", symbols = { "✨", "📸" }, count = 4, radius = 3 } },
		{ 0.7, { "burst", color = FLASH, size = 3, at = "hand" } },
		{ 0.75, { "text", text = "CLIC !", color = ROSE_VIF } },
		{ 1.45, { "text", text = "EN DIRECT DE L'ARÈNE !", color = ROSE } },
	},
}

-- Arbre d'enchaînements : P P P P = smartphone, flash, duckface, selfie de groupe ; → P P P P = estoc, swipe, scroll,
-- unfollow ; ↓ P P P = glissade, story en direct, boomerang ; K K K K = talon, talon retourné, catwalk, coup de pied
-- vlog ; → K K K = pose photo, changement de pose, saut photo final. S finit presque toutes les chaînes (pose finale
-- de près, ring light tournante tout autour).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P P P P : smartphone, flash éblouissant, duckface, selfie de groupe (finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_pose" },
	P_combo2 = { P = "P_duckface", K = "PK_combo", S = "S_neutral" }, -- le flash enchaîne sur le Flash
	P_duckface = { P = "P_combo3", K = "K_catwalk", S = "S_finish_ring" },
	PK_combo = { K = "K_catwalk", P = "KP_combo", S = "S_finish_ring" },
	KP_combo = { P = "P_combo3", S = "S_finish_pose" },
	-- K K K K : talon compensé, talon retourné, pas de catwalk, coup de pied vlog (finition)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_ring" },
	K_combo2 = { K = "K_catwalk", P = "P_duckface", S = "S_finish_pose" },
	K_catwalk = { K = "K_combo3", P = "P_unfollow", S = "S_finish_ring" },
	-- → P P P P : estoc, swipe à gauche, scroll infini, unfollow (finition à l'horizontale)
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_pose" },
	P_side2 = { P = "P_scroll", K = "K_side2", S = "S_finish_ring" },
	P_scroll = { P = "P_unfollow", K = "K_catwalk", S = "S_finish_pose" },
	-- ↓ P P P : glissade pose photo, story en direct, boomerang (finition)
	P_down = { P = "P_story", K = "K_down", up_K = "K_up", S = "S_finish_ring" },
	P_story = { P = "P_boomerang", K = "K_up", S = "S_finish_pose" },
	-- → K K K : kick pose photo, changement de pose, saut photo final (finition)
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_pose" },
	K_side2 = { K = "K_side3", P = "P_scroll", S = "S_finish_ring" },
	-- autres départs
	P_up = { K = "K_up", P = "P_duckface", S = "S_finish_pose" },
	P_dash = { P = "P_scroll", K = "K_side2", S = "S_finish_pose" },
	K_down = { up_K = "K_up", P = "P_story", S = "S_finish_ring" },
	K_up = { S = "S_finish_pose" },
	K_dash = { P = "KP_combo", K = "K_side2", S = "S_finish_ring" },
	-- en l'air ; ↓ P et ↓ K (smash vers le sol) sont des finitions sans suite
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

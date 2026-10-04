-- Dylan le Livreur : toujours en retard, rushdown nerveux qui enchaîne pour faire monter sa note client.
-- Arme sortie de la Caisse Bizarre : trottinette électrique (main droite) & sac cube isotherme (sur le dos).
--
-- Même format que Gege.lua (voir l'en-tête de Gege.lua et docs/fiche-perso.md).
-- Dylan est pressé : startups courts, petits dégâts, beaucoup d'élan (selfVelocity) et des pieds qui ne
-- tiennent pas en place. La trottinette pliée pend à la main droite comme une massue ; la main gauche sert
-- au klaxon, au ticket de caisse, au téléphone et aux colis.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(200, 150, 110)
local TEAL = Color3.fromRGB(0, 180, 165)
local TEAL_DARK = Color3.fromRGB(0, 120, 110)
local ORANGE = Color3.fromRGB(255, 140, 30)
local SHORTS = Color3.fromRGB(55, 60, 70)
local WHITE = Color3.fromRGB(250, 250, 250)
local BLACK = Color3.fromRGB(30, 30, 35)
local METAL = Color3.fromRGB(170, 175, 185)
local CARDBOARD = Color3.fromRGB(190, 145, 90)
local TAPE = Color3.fromRGB(225, 195, 120)
local SCREEN = Color3.fromRGB(120, 220, 255)
local PIZZA = Color3.fromRGB(240, 190, 80)
local STAR = Color3.fromRGB(255, 215, 40)

-- Colis en carton (projectiles, piège, Super)
local PARCEL = { shape = "block", size = 1.4, color = CARDBOARD, spin = 4, parts = {
	{ "block", Vector3.new(1.45, 0.25, 0.9), Vector3.new(0, 0, 0), TAPE },
	{ "block", Vector3.new(0.5, 0.4, 0.86), Vector3.new(0.3, 0.3, 0), WHITE },
} }

local CONE = Color3.fromRGB(255, 110, 20) -- cône de chantier (arme n° 2)
local FIRE_D = Color3.fromRGB(255, 200, 60)
local SAUCE_D = Color3.fromRGB(200, 40, 30) -- sauce tomate (arme n° 3)
local CREPE_D = Color3.fromRGB(235, 190, 110) -- pâte dorée du calzone
-- Part de pizza (projectiles de l'arme n° 3)
local SLICE = { shape = "block", size = 1.2, color = PIZZA, spin = 8, parts = {
	{ "block", Vector3.new(0.5, 0.12, 0.5), Vector3.new(0.3, 0.1, 0), SAUCE_D },
	{ "ball", Vector3.new(0.3, 0.14, 0.3), Vector3.new(-0.25, 0.1, 0.2), SAUCE_D },
} }

local data = {
	id = "Dylan",
	name = "Dylan le Livreur",
	costume = "Dylan",
	style = "hurry",

	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : le coursier à pied
	-- Ses propres J / K et ses combos sans arme (les L et les Y restent ceux de moves). Sans trottinette ni sac,
	-- Dylan court partout : jabs à la chaîne, check trop appuyé, piétinement d'impatience, tacle et retourné.
	-- Combos : J J J J (rafale de jabs qui finit en crochet), K K (double coup de pied), K J K (course-poursuite).
	bare = {
		moves = {
			-- J : petit jab sec en sautillant, l'autre main vérifie la montre connectée
			P_neutral = {
				label = "Jab chrono", startup = 0.06, active = 0.06, recovery = 0.12,
				damage = 5, hitbox = box(3.6, 2.8, 2.4, 0.8), kbBase = 14, kbGrowth = 20, kbAngle = 20,
				windup = { Root = { -4, 14, 0, 0, -0.1, 0.08 }, Waist = { -6, 16, 0 }, Neck = { -4, -10, 0 }, RS = { 50, 0, 10 }, RE = { 110, 0, 0 }, LS = { 70, 0, -10 }, LE = { 120, 0, 0 }, FR = { 0, 0, 0, 0, 0.1, 0 } },
				strike = { Root = { -8, -12, 0, 0, -0.12, -0.2 }, Waist = { -10, -16, 0 }, Neck = { -4, 10, 0 }, RS = { 92, 0, -6 }, RE = { 4, 0, 0 }, LS = { 70, 0, -10 }, LE = { 125, 0, 0 } },
				follow = { Root = { -8, -14, 0, 0, -0.12, -0.22 }, Waist = { -10, -18, 0 }, Neck = { -4, 12, 0 }, RS = { 88, 0, -8 }, RE = { 10, 0, 0 }, LS = { 70, 0, -10 }, LE = { 125, 0, 0 } },
				trail = "rightHand", hitText = "TIC !",
			},
			-- J J : jab de l'autre main, encore plus vite
			P_combo2 = {
				label = "Jab pressé", startup = 0.06, active = 0.06, recovery = 0.12,
				damage = 5, hitbox = box(3.6, 2.8, 2.5, 0.8), kbBase = 14, kbGrowth = 20, kbAngle = 22,
				windup = { Root = { -4, -14, 0, 0, -0.1, 0.06 }, Waist = { -6, -16, 0 }, Neck = { -4, 10, 0 }, RS = { 70, 0, 10 }, RE = { 120, 0, 0 }, LS = { 50, 0, -10 }, LE = { 110, 0, 0 } },
				strike = { Root = { -8, 12, 0, 0, -0.12, -0.24 }, Waist = { -10, 16, 0 }, Neck = { -4, -10, 0 }, RS = { 70, 0, 10 }, RE = { 125, 0, 0 }, LS = { 92, 0, 6 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
				follow = { Root = { -8, 14, 0, 0, -0.12, -0.26 }, Waist = { -10, 18, 0 }, Neck = { -4, -12, 0 }, RS = { 70, 0, 10 }, RE = { 125, 0, 0 }, LS = { 88, 0, 8 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.22 } },
				trail = "bothHands", hitText = "TAC !",
			},
			-- J J J : trois jabs mitraillés, il ne prend même plus le temps de respirer
			P_combo3 = {
				label = "Mitraillette de jabs", startup = 0.06, active = 0.16, recovery = 0.16,
				damage = 6, hits = 3, hitbox = box(4, 3, 2.6, 0.8), kbBase = 14, kbGrowth = 22, kbAngle = 25,
				windup = { Root = { -6, 0, 0, 0, -0.15, 0.05 }, Waist = { -8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 10 }, RE = { 120, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 } },
				strike = { Root = { -10, 8, 0, 0, -0.15, -0.2 }, Waist = { -12, 10, 0 }, Neck = { -6, -6, 0 }, RS = { 92, 0, 0 }, RE = { 5, 0, 0 }, LS = { 70, 0, -12 }, LE = { 110, 0, 0 } },
				follow = { Root = { -10, -8, 0, 0, -0.15, -0.24 }, Waist = { -12, -10, 0 }, Neck = { -6, 6, 0 }, RS = { 70, 0, 12 }, RE = { 110, 0, 0 }, LS = { 92, 0, 0 }, LE = { 5, 0, 0 } },
				wobble = true, trail = "bothHands", fx = { { "particles", tex = "spark", color = STAR, dir = "front", at = "hand", time = 0.2, speed = 10, size = 0.4 } }, hitText = "TACTACTAC !",
			},
			-- J J J J : crochet de retard, grand arc du bras « désolé, j'étais coincé dans les bouchons ! » (finition)
			P_combo4 = {
				label = "Crochet du retard", startup = 0.1, active = 0.1, recovery = 0.28,
				damage = 9, hitbox = box(4.5, 3.2, 2.8, 0.8), kbBase = 28, kbGrowth = 58, kbAngle = 36, selfVelocity = Vector2.new(14, 0),
				windup = { Root = { -2, 40, 0, 0, -0.2, 0.15 }, Waist = { -4, 44, 0 }, Neck = { -4, -30, 0 }, RS = { 70, 0, 100 }, RE = { 50, 0, 0 }, LS = { 50, 0, -20 }, LE = { 100, 0, 0 } },
				strike = { Root = { -12, -30, 0, 0, -0.25, -0.35 }, Waist = { -14, -36, 0 }, Neck = { -6, 20, 0 }, RS = { 95, 0, -30 }, RE = { 40, 0, 0 }, LS = { 30, 0, -30 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
				follow = { Root = { -14, -40, 0, 0, -0.26, -0.4 }, Waist = { -16, -46, 0 }, Neck = { -6, 26, 0 }, RS = { 88, 0, -50 }, RE = { 44, 0, 0 }, LS = { 26, 0, -32 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				trail = "rightHand", fx = { { "burst", color = ORANGE, size = 2.5, at = "front" } }, text = "DÉSOLÉ, LES BOUCHONS !", hitText = "BLAM !",
			},
			-- →J : check du poing beaucoup trop appuyé, il tend le poing en avançant
			P_side = {
				label = "Check trop appuyé", startup = 0.08, active = 0.1, recovery = 0.18,
				damage = 7, hitbox = box(4.5, 2.8, 3, 0.8), kbBase = 22, kbGrowth = 36, kbAngle = 22, selfVelocity = Vector2.new(22, 0),
				windup = { Root = { 2, 10, 0, 0, -0.1, 0.15 }, Waist = { 4, 14, 0 }, Neck = { -6, -8, 0 }, RS = { 40, 0, 30 }, RE = { 120, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
				strike = { Root = { -12, -6, 0, 0, -0.2, -0.45 }, Waist = { -14, -8, 0 }, Neck = { -8, 4, 0 }, RS = { 90, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -20 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				follow = { Root = { -14, -8, 0, 0, -0.22, -0.5 }, Waist = { -16, -10, 0 }, Neck = { -8, 6, 0 }, RS = { 90, 0, 2 }, RE = { 0, 0, 0 }, LS = { -34, 0, -22 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
				trail = "rightHand", text = "TCHEK !", hitText = "BOUM !",
			},
			-- ↓J : il s'accroupit pour refaire son lacet… et assène un coup de coude au tibia
			P_down = {
				label = "Lacet défait", startup = 0.07, active = 0.08, recovery = 0.18,
				damage = 5, hitbox = box(4, 2, 2.2, -1.4), kbBase = 18, kbGrowth = 24, kbAngle = 68,
				windup = { Root = { -16, 0, 0, 0, -0.9, 0.05 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 0 }, RE = { 90, 0, 0 }, LS = { 60, 0, 0 }, LE = { 90, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 } },
				strike = { Root = { -16, -20, 0, 0, -0.95, -0.15 }, Waist = { -20, -30, 0 }, Neck = { -10, 20, 0 }, RS = { 20, 0, 70 }, RE = { 120, 0, 0 }, LS = { 60, 0, -10 }, LE = { 90, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 } },
				follow = { Root = { -16, -24, 0, 0, -0.95, -0.18 }, Waist = { -20, -34, 0 }, Neck = { -10, 24, 0 }, RS = { 18, 0, 74 }, RE = { 125, 0, 0 }, LS = { 60, 0, -10 }, LE = { 90, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 } },
				trail = "rightHand", hitText = "TOC !",
			},
			-- ↑J : « c'est ici, le livreur ! », il lève la main pour se signaler et claque le menton au passage
			P_up = {
				label = "C'est ici !", startup = 0.07, active = 0.1, recovery = 0.18,
				damage = 6, hitbox = box(3.5, 5, 1.4, 3), kbBase = 22, kbGrowth = 36, kbAngle = 86,
				windup = { Root = { -4, -10, 0, 0, -0.35, 0 }, Waist = { -8, -10, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 20 }, RE = { 100, 0, 0 }, LS = { 30, 0, -10 }, LE = { 60, 0, 0 } },
				strike = { Root = { 4, 10, 0, 0, 0.15, 0 }, Waist = { 6, 10, 0 }, Neck = { 20, 0, 0 }, RS = { 178, 0, -6 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { 10, 0, -30 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 } },
				follow = { Root = { 4, 12, 0, 0, 0.18, 0 }, Waist = { 6, 12, 0 }, Neck = { 24, 0, 0 }, RS = { 178, 0, 14 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 10, 0, -30 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 } },
				trail = "rightHand", text = "C'EST ICI !", hitText = "HOP !",
			},
			-- J en l'air : il fait des moulinets de bras pour aller plus vite, même en l'air
			P_air = {
				label = "Moulinets pressés", startup = 0.07, active = 0.2, recovery = 0.16,
				damage = 7, hits = 2, hitbox = box(4.5, 4, 1.6, 0.4), kbBase = 18, kbGrowth = 32, kbAngle = 38,
				windup = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, RS = { -40, 0, 20 }, RE = { 20, 0, 0 }, LS = { 160, 0, -20 }, LE = { 20, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
				strike = { Root = { -10, 0, 0 }, Waist = { -12, 0, 0 }, RS = { 160, 0, 20 }, RE = { 20, 0, 0 }, LS = { -40, 0, -20 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
				follow = { Root = { -10, 0, 0 }, Waist = { -12, 0, 0 }, RS = { 60, 0, 30 }, RE = { 20, 0, 0 }, LS = { 90, 0, -30 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
				trail = "bothHands", hitText = "WHIRR !",
			},
			-- dash J : sprint du coursier, épaule en avant, il bouscule tout sur le trottoir
			P_dash = {
				label = "Coup d'épaule du sprinteur", startup = 0.07, active = 0.18, recovery = 0.22,
				damage = 7, hitbox = box(4.5, 3.5, 2.4, 0.6), kbBase = 24, kbGrowth = 38, kbAngle = 28, selfVelocity = Vector2.new(46, 0),
				windup = { Root = { -14, 20, 0, 0, -0.25, 0.1 }, Waist = { -16, 24, 0 }, Neck = { -4, -16, 0 }, RS = { -40, 0, 10 }, RE = { 90, 0, 0 }, LS = { 70, 0, -10 }, LE = { 90, 0, 0 } },
				strike = { Root = { -24, 40, 0, 0, -0.3, -0.4 }, Waist = { -18, 30, 0 }, Neck = { -6, -30, 0 }, RS = { -20, 0, 30 }, RE = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				follow = { Root = { -26, 42, 0, 0, -0.32, -0.45 }, Waist = { -20, 32, 0 }, Neck = { -6, -32, 0 }, RS = { -24, 0, 32 }, RE = { 90, 0, 0 }, LS = { 20, 0, -42 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
				fx = { { "particles", tex = "smoke", color = Color3.fromRGB(210, 210, 215), dir = "front", at = "feet", time = 0.25, speed = 8 } }, text = "PLACE !", hitText = "BAM !",
			},
			-- K : piétinement d'impatience, trois petits coups de pied rapides devant lui
			K_neutral = {
				label = "Piétinement d'impatience", startup = 0.09, active = 0.18, recovery = 0.22,
				damage = 7, hits = 3, hitbox = box(4, 2.4, 2.4, -1), kbBase = 20, kbGrowth = 36, kbAngle = 40,
				windup = { Root = { 2, 0, 0, 0, -0.05, 0.05 }, Waist = { 4, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -10, 0, 20 }, RE = { 30, 0, 0 }, LS = { -10, 0, -20 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -80, 0, 0 } },
				strike = { Root = { 0, 0, 0, 0, 0, -0.1 }, Waist = { 2, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -14, 0, 24 }, RE = { 30, 0, 0 }, LS = { -14, 0, -24 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 } },
				follow = { Root = { 0, 0, 0, 0, 0.05, -0.12 }, Waist = { 2, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -14, 0, 24 }, RE = { 30, 0, 0 }, LS = { -14, 0, -24 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -70, 0, 0 }, LH = { 60, 0, 0 }, LK = { -10, 0, 0 } },
				wobble = true, trail = "rightFoot", hitText = "TAP TAP TAP !",
			},
			-- K K : double coup de pied en ciseau, comme pour sauter un portillon
			K_combo2 = {
				label = "Saute-portillon", startup = 0.1, active = 0.14, recovery = 0.26,
				damage = 8, hitbox = box(5, 3, 3, 0.2), kbBase = 26, kbGrowth = 46, kbAngle = 40,
				windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 50 }, RE = { 40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
				strike = { Root = { 16, 0, 0, 0, 0.4, -0.25 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 70 }, RE = { 10, 0, 0 }, LS = { 30, 0, -70 }, LE = { 10, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, LH = { 70, 0, 0 }, LK = { -40, 0, 0 }, FR = { 0, 0, 0, 0, 0.6, -0.3 }, FL = { 0, 0, 0, 0, 0.6, -0.2 } },
				follow = { Root = { 18, 0, 0, 0, 0.3, -0.3 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 28, 0, 72 }, RE = { 10, 0, 0 }, LS = { 28, 0, -72 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -40, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, -0.3 }, FL = { 0, 0, 0, 0, 0.4, -0.3 } },
				trail = "rightFoot", hitText = "HOP-HOP !",
			},
			-- K J : course-poursuite, il sprinte sur place puis fonce les deux poings en avant
			KP_combo = {
				label = "Course-poursuite", startup = 0.1, active = 0.16, recovery = 0.24,
				damage = 7, hitbox = box(4.5, 3, 2.6, 0.8), kbBase = 22, kbGrowth = 40, kbAngle = 30, selfVelocity = Vector2.new(36, 0),
				windup = { Root = { -10, 0, 0, 0, -0.15, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 10 }, RE = { 90, 0, 0 }, LS = { -40, 0, -10 }, LE = { 90, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 70, 0, 0 }, LK = { -60, 0, 0 } },
				strike = { Root = { -20, 0, 0, 0, -0.2, -0.4 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 90, 0, 10 }, RE = { 0, 0, 0 }, LS = { 90, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				follow = { Root = { -22, 0, 0, 0, -0.22, -0.45 }, Waist = { -18, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 14 }, RE = { 0, 0, 0 }, LS = { 92, 0, -14 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
				trail = "bothHands", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(210, 210, 215), dir = "front", at = "feet", time = 0.2, speed = 8 } }, hitText = "ATTENDS !",
			},
			-- K J K : il attrape la balle au bond et finit par un retourné acrobatique (finition qui éjecte)
			KPK_combo = {
				label = "Retourné de la dernière chance", startup = 0.12, active = 0.14, recovery = 0.32,
				damage = 10, hitbox = box(4.5, 4.5, 2, 1.5), kbBase = 30, kbGrowth = 64, kbAngle = 55,
				windup = { Root = { 10, 0, 0, 0, -0.35, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
				strike = { Root = { 40, 0, 0, 0, 0.4, 0 }, Waist = { 20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 80 }, RE = { 10, 0, 0 }, LS = { 20, 0, -80 }, LE = { 10, 0, 0 }, RH = { 150, 0, 0 }, RK = { -6, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
				follow = { Root = { 44, 0, 0, 0, 0.3, 0 }, Waist = { 22, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 18, 0, 82 }, RE = { 10, 0, 0 }, LS = { 18, 0, -82 }, LE = { 10, 0, 0 }, RH = { 156, 0, 0 }, RK = { 0, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
				spin = { axis = "x", degrees = 360 }, trail = "rightFoot", fx = { { "burst", color = STAR, size = 2.5, at = "front" } }, text = "LIVRÉ !", hitText = "GOOOAL !",
			},
			-- →K : il ouvre une porte imaginaire d'un grand coup de pied, pressé de livrer
			K_side = {
				label = "Porte ouverte au pied", startup = 0.12, active = 0.1, recovery = 0.26,
				damage = 9, hitbox = box(5.5, 3, 3.2, 0.2), kbBase = 26, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { 6, 30, 0, 0, -0.1, 0.15 }, Waist = { 6, 30, 0 }, Neck = { -6, -30, 0 }, RS = { 30, 0, 40 }, RE = { 90, 0, 0 }, LS = { 50, 0, -40 }, LE = { 90, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 } },
				strike = { Root = { 14, 60, 0, 0, -0.05, -0.15 }, Waist = { 10, 30, 0 }, Neck = { -6, -60, 0 }, RS = { 20, 0, 50 }, RE = { 90, 0, 0 }, LS = { 60, 0, -50 }, LE = { 90, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 30, 0, 0 } },
				follow = { Root = { 16, 62, 0, 0, -0.05, -0.18 }, Waist = { 12, 32, 0 }, Neck = { -6, -62, 0 }, RS = { 18, 0, 52 }, RE = { 90, 0, 0 }, LS = { 62, 0, -52 }, LE = { 90, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 34, 0, 0 } },
				trail = "rightFoot", fx = { { "burst", color = TEAL, size = 2, at = "front" } }, hitText = "BLAM !",
			},
			-- ↓K : balayage du carrefour, il tourne accroupi la jambe tendue comme une aiguille de montre
			K_down = {
				label = "Balayage du carrefour", startup = 0.1, active = 0.14, recovery = 0.26,
				damage = 7, hitbox = box(6.5, 1.8, 2, -1.8), kbBase = 24, kbGrowth = 40, kbAngle = 75,
				windup = { Root = { -10, 0, 0, 0, -0.9, 0 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 70, 0, -20 }, LE = { 30, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
				strike = { Root = { -10, 0, 0, 0, -1.0, 0 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -30 }, LE = { 30, 0, 0 }, RH = { 20, 0, 80 }, RK = { -4, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
				follow = { Root = { -10, 0, 0, 0, -1.0, 0 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 62 }, RE = { 30, 0, 0 }, LS = { 60, 0, -32 }, LE = { 30, 0, 0 }, RH = { 22, 0, 82 }, RK = { 0, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "rightFoot", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(200, 200, 205), dir = "all", at = "feet", time = 0.25, speed = 6 } }, hitText = "ZOUIP !",
			},
			-- ↑K : saut de haie, il enjambe un obstacle imaginaire et le talon monte au menton
			K_up = {
				label = "Saut de haie", startup = 0.12, active = 0.12, recovery = 0.28,
				damage = 8, hitbox = box(4, 5.5, 1.6, 3), kbBase = 26, kbGrowth = 50, kbAngle = 82,
				windup = { Root = { -6, 0, 0, 0, -0.35, 0.05 }, Waist = { -10, 0, 0 }, Neck = { -4, 0, 0 }, RS = { -30, 0, 20 }, RE = { 80, 0, 0 }, LS = { 70, 0, -20 }, LE = { 80, 0, 0 } },
				strike = { Root = { -12, 0, 0, 0, 0.5, -0.1 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 10 }, RE = { 10, 0, 0 }, LS = { -40, 0, -20 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -4, 0, 0 }, RA = { -10, 0, 0 }, LH = { -30, 0, 0 }, LK = { -90, 0, 0 } },
				follow = { Root = { -12, 0, 0, 0, 0.45, -0.12 }, Waist = { -16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 92, 0, 12 }, RE = { 10, 0, 0 }, LS = { -42, 0, -22 }, LE = { 30, 0, 0 }, RH = { 146, 0, 0 }, RK = { 0, 0, 0 }, RA = { -14, 0, 0 }, LH = { -34, 0, 0 }, LK = { -92, 0, 0 } },
				trail = "rightLeg", hitText = "ZOUP !",
			},
			-- K en l'air : coup de pied en étoile, bras et jambes écartés comme sur un logo de livraison
			K_air = {
				label = "Étoile filante", startup = 0.09, active = 0.16, recovery = 0.2,
				damage = 8, hitbox = box(5.5, 5, 1.6, 0), kbBase = 22, kbGrowth = 42, kbAngle = 45,
				windup = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 20 }, RE = { 110, 0, 0 }, LS = { 20, 0, -20 }, LE = { 110, 0, 0 }, RH = { 80, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
				strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 130 }, RE = { 0, 0, 0 }, LS = { 40, 0, -130 }, LE = { 0, 0, 0 }, RH = { 30, 0, 40 }, RK = { 0, 0, 0 }, LH = { 30, 0, -40 }, LK = { 0, 0, 0 } },
				follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 42, 0, 134 }, RE = { 0, 0, 0 }, LS = { 42, 0, -134 }, LE = { 0, 0, 0 }, RH = { 32, 0, 44 }, RK = { 0, 0, 0 }, LH = { 32, 0, -44 }, LK = { 0, 0, 0 } },
				trail = "body", fx = { { "symbols", symbols = { "⭐" }, color = STAR, count = 4, radius = 3 } }, hitText = "TCHAC !",
			},
			-- dash K : tacle glissé du coursier, une jambe devant, la main au sol
			K_dash = {
				label = "Tacle du coursier", startup = 0.08, active = 0.24, recovery = 0.3,
				damage = 9, hitbox = box(6, 2, 3, -1.4), kbBase = 26, kbGrowth = 52, kbAngle = 70, selfVelocity = Vector2.new(52, 0),
				windup = { Root = { -10, 0, 0, 0, -0.3, 0.05 }, Waist = { -12, 0, 0 }, Neck = { -4, 0, 0 }, RS = { -30, 0, 20 }, RE = { 80, 0, 0 }, LS = { 70, 0, -20 }, LE = { 80, 0, 0 } },
				strike = { Root = { 30, 20, 0, 0, -1.0, -0.2 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { -20, 0, -60 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -110, 0, 0 } },
				follow = { Root = { 32, 22, 0, 0, -1.0, -0.22 }, Waist = { 12, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 18, 0, 72 }, RE = { 10, 0, 0 }, LS = { -22, 0, -62 }, LE = { 10, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 }, LH = { 10, 0, 0 }, LK = { -114, 0, 0 } },
				trail = "rightFoot", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(200, 200, 205), dir = "front", at = "feet", time = 0.3, speed = 10 } }, hitText = "SKRRRT !",
			},
		},
		-- Combos à mains nues : J J J J (jab, jab, mitraillette, crochet du retard), K K (saute-portillon),
		-- K J K (course-poursuite puis retourné), →J J, ↓J ↑K. Un S pour finir envoie le spécial du perso.
		links = {
			P_neutral = { P = "P_combo2", K = "K_side", S = "S_neutral" },
			P_combo2 = { P = "P_combo3", K = "K_neutral", S = "S_side" },
			P_combo3 = { P = "P_combo4", K = "K_up", S = "S_side" },
			P_combo4 = { S = "S_neutral" },
			K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_side" },
			K_combo2 = { P = "P_up", K = "K_up", S = "S_up" },
			KP_combo = { K = "KPK_combo", P = "P_combo3", S = "S_side" },
			KPK_combo = { S = "S_up" },
			P_side = { P = "P_combo2", K = "K_down", S = "S_side" },
			P_down = { K = "K_up", P = "P_up", S = "S_down" },
			P_up = { P = "P_combo3", S = "S_up" },
			K_side = { P = "KP_combo", S = "S_side" },
			K_down = { P = "P_up", K = "K_up", S = "S_down" },
			K_up = { S = "S_up" },
			P_dash = { P = "P_combo3", K = "K_combo2", S = "S_side" },
			K_dash = { P = "P_up", K = "K_up", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la trottinette pliée (ses coups sont ceux de moves). n° 2 : le cône de chantier, lourd et lent, qui barre la
	-- route et éjecte loin. n° 3 : la pile de boîtes à pizza, jeu de projectiles qui grignote et saute plus haut.
	weapons = {
		{ id = "trottinette", name = "Trottinette électrique & sac cube", icon = "🛵",
			ability = { speed = 1.15, text = "Dylan file 15 % plus vite (il est en retard)" } },
		{ id = "cone", name = "Cône de chantier", icon = "🚧",
			prop = { name = "PropCone", hand = "Right", pieces = {
				{ "Socle", "", "block", Vector3.new(1.6, 0.14, 1.6), Vector3.new(0, -0.2, 0), Vector3.new(0, 0, 0), BLACK, "Rubber" },
				{ "ConeBas", "", "cyl", Vector3.new(1.0, 1.1, 1.0), Vector3.new(0, -0.8, 0), Vector3.new(0, 0, 0), CONE, "Plastic" },
				{ "BandeBlanche", "", "cyl", Vector3.new(0.9, 0.35, 0.9), Vector3.new(0, -1.5, 0), Vector3.new(0, 0, 0), WHITE, "Plastic" },
				{ "ConeMilieu", "", "cyl", Vector3.new(0.75, 0.9, 0.75), Vector3.new(0, -2.1, 0), Vector3.new(0, 0, 0), CONE, "Plastic" },
				{ "BandeBlanche2", "", "cyl", Vector3.new(0.55, 0.3, 0.55), Vector3.new(0, -2.7, 0), Vector3.new(0, 0, 0), WHITE, "Plastic" },
				{ "Pointe", "", "cyl", Vector3.new(0.35, 0.5, 0.35), Vector3.new(0, -3.1, 0), Vector3.new(0, 0, 0), CONE, "Plastic" },
			} },
			ability = { knockback = 1.25, text = "Éjecte 25 % plus loin (déviation obligatoire)" },
			moves = {
				-- J : coup de pointe de cône dans le sternum, bras tendu, l'autre main qui fait « stop »
				P_neutral = {
					label = "Pointe de cône", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 7, hitbox = box(5, 3, 3, 0.6), kbBase = 22, kbGrowth = 30, kbAngle = 25,
					windup = { Root = { 4, -18, 0, 0, -0.15, 0.15 }, Waist = { 6, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 50, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 40, 0, 0 }, LW = { -60, 0, 0 } },
					strike = { Root = { -10, 18, 0, 0, -0.28, -0.35 }, Waist = { -12, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 96, 0, 2 }, RE = { 4, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -10 }, LE = { 10, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 22, 0, 0, -0.3, -0.4 }, Waist = { -14, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 100, 0, 4 }, RE = { 8, 0, 0 }, RW = { -10, 0, 0 }, LS = { 92, 0, -8 }, LE = { 10, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", text = "STOP !", hitText = "POC !",
				},
				-- →J : le cône collé à la bouche en porte-voix, il hurle « PARDON » : le cri cogne à bout portant
				P_side = {
					label = "Porte-voix", startup = 0.12, active = 0.12, recovery = 0.22,
					damage = 8, hitbox = box(6, 3.5, 3.5, 1), kbBase = 26, kbGrowth = 42, kbAngle = 22,
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.15 }, Waist = { 8, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 120, 0, 10 }, RE = { 120, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.3, -0.35 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 0 }, RE = { 100, 0, 0 }, RW = { 70, 0, 0 }, LS = { 60, 0, -50 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 0, 0, 0, -0.32, -0.4 }, Waist = { -18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 112, 0, 0 }, RE = { 98, 0, 0 }, RW = { 72, 0, 0 }, LS = { 64, 0, -54 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, fx = { { "ring", color = CONE, radius = 3, at = "front" }, { "symbols", symbols = { "PARDON", "!!" }, count = 3, radius = 2.5, at = "front", color = CONE } }, text = "PARDOOON !", hitText = "ASSOURDI !",
				},
				-- ↓J : accroupi, il pose le socle du cône de tout son poids sur les orteils de l'adversaire
				P_down = {
					label = "Cône sur les orteils", startup = 0.12, active = 0.1, recovery = 0.24,
					damage = 7, hitbox = box(5, 2, 3, -1.8), kbBase = 24, kbGrowth = 30, kbAngle = 75,
					windup = { Root = { 8, 0, 0, 0, -0.6, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 150, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { 16, 0, 0, 0, -0.95, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 170, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 18, 0, 0, 0, -0.95, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { 175, 0, 0 }, LS = { 44, 0, -32 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { "dust" }, hitText = "ÉCRASÉ !",
				},
				-- ↑J : le cône posé sur le casque comme un chapeau de sorcier, il saute pointe en l'air
				P_up = {
					label = "Chapeau pointu", startup = 0.1, active = 0.12, recovery = 0.24,
					damage = 8, hitbox = box(4.5, 5.5, 1, 3.5), kbBase = 26, kbGrowth = 42, kbAngle = 86, selfVelocity = Vector2.new(0, 24),
					windup = { Root = { -8, 0, 0, 0, -0.6, 0 }, Waist = { -18, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -20 }, LE = { 30, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.3, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 190, 0, 4 }, RE = { 0, 0, 0 }, RW = { 170, 0, 0 }, LS = { -50, 0, -20 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 }, LH = { 60, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { 8, 0, 0, 0, 0.35, 0 }, Waist = { 10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 192, 0, 6 }, RE = { 0, 0, 0 }, RW = { 175, 0, 0 }, LS = { -55, 0, -22 }, LE = { 10, 0, 0 }, RH = { 65, 0, 0 }, RK = { -115, 0, 0 }, LH = { 65, 0, 0 }, LK = { -115, 0, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "🚧", "✨" }, count = 2, radius = 1.5, at = "head", color = CONE } }, hitText = "PIQUÉ !",
				},
				-- J en l'air : cône tenu à deux mains, pointe vers le bas, il le plante sous lui
				P_air = {
					label = "Cône plongeant", startup = 0.1, active = 0.12, recovery = 0.18,
					damage = 8, hitbox = box(4.5, 4, 1.5, -1.5), kbBase = 22, kbGrowth = 38, kbAngle = -45,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 180, 0, 15 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -15 }, LE = { 50, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -5 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -36, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 24, 0, 5 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 24, 0, -5 }, LE = { 6, 0, 0 }, RH = { 5, 0, 0 }, RK = { -25, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "PLANTÉ !",
				},
				-- dash J : il fonce cône en avant comme un bélier de chantier, tête baissée
				P_dash = {
					label = "Bélier de chantier", startup = 0.08, active = 0.16, recovery = 0.26,
					damage = 9, hitbox = box(5.5, 4, 3, 0.6), kbBase = 30, kbGrowth = 56, kbAngle = 24, selfVelocity = Vector2.new(44, 0),
					windup = { Root = { -8, 0, 0, 0, -0.3, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -24, 0, 0, 0, -0.42, -0.3 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 94, 0, 6 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 } },
					follow = { Root = { -26, 0, 0, 0, -0.44, -0.35 }, Waist = { -16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 96, 0, 8 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { -34, 0, -42 }, LE = { 30, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 6 } }, text = "TRAVAUX !", hitText = "BOUSCULÉ !",
				},
				-- K : il pose le cône au sol et shoote dedans de toutes ses forces, le cône part en toupie
				K_neutral = {
					label = "Shoot dans le cône", startup = 0.18, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(6, 3.5, 3.5, 0), kbBase = 32, kbGrowth = 72, kbAngle = 30,
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.1 }, Waist = { 8, -10, 0 }, RS = { 30, 0, 40 }, RE = { 40, 0, 0 }, RW = { 170, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { -35, 0, 0 }, RK = { -70, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.12, 0.05 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 55 }, RE = { 30, 0, 0 }, RW = { 170, 0, 0 }, LS = { 70, 0, -55 }, LE = { 30, 0, 0 }, RH = { 96, 0, 0 }, RK = { -4, 0, 0 }, RA = { 12, 0, 0 } },
					follow = { Root = { 16, 0, 0, 0, -0.12, 0.1 }, Waist = { 18, 0, 0 }, RS = { 64, 0, 60 }, RE = { 25, 0, 0 }, RW = { 170, 0, 0 }, LS = { 74, 0, -60 }, LE = { 25, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 16, 0, 0 } },
					trail = "rightFoot", fx = { { "toss", shape = "cyl", color = CONE, size = 0.9, count = 1, speed = 20 } }, hitText = "PÉNO !",
				},
				-- →K : grand balayage horizontal du cône tenu par la pointe, il pivote sur les talons
				K_side = {
					label = "Balayage de chantier", startup = 0.18, active = 0.14, recovery = 0.34,
					damage = 13, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 34, kbGrowth = 78, kbAngle = 30, selfVelocity = Vector2.new(18, 0),
					windup = { Root = { 6, 42, 0, 0, -0.2, 0.2 }, Waist = { 8, 48, 0 }, Neck = { 0, -30, 0 }, RS = { 70, 0, 70 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 70, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 92, 0, -30 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -42, 0, 0, -0.32, -0.4 }, Waist = { -12, -48, 0 }, Neck = { 0, 30, 0 }, RS = { 96, 0, -40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 84, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { "dust" }, hitText = "BLAM !",
				},
				-- ↓K : accroupi, il fait rouler le cône couché au ras du bitume dans les tibias
				K_down = {
					label = "Cône qui roule", startup = 0.16, active = 0.14, recovery = 0.3,
					damage = 11, hitbox = box(7, 2, 3.5, -1.6), kbBase = 30, kbGrowth = 60, kbAngle = 70,
					windup = { Root = { 10, 10, 0, 0, -0.85, 0.1 }, Waist = { 16, 14, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 } },
					strike = { Root = { 14, -20, 0, 0, -0.95, -0.15 }, Waist = { 20, -26, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 16, -28, 0, 0, -0.95, -0.2 }, Waist = { 22, -32, 0 }, Neck = { 10, 0, 0 }, RS = { 36, 0, 24 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { "dust" }, hitText = "ROULÉ !",
				},
				-- ↑K : coup de pied monté en tenant le cône comme un balancier, pointe vers le ciel
				K_up = {
					label = "Pied de chantier", startup = 0.17, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.1 }, Waist = { 14, 0, 0 }, RS = { 20, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, 0.05, -0.1 }, Waist = { -22, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 80 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 145, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -20, 0, 0, 0, 0.08, -0.12 }, Waist = { -24, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 24, 0, 84 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 152, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { { "particles", tex = "spark", color = ORANGE, dir = "up", at = "feet", time = 0.2, speed = 6 } }, hitText = "KLANG !",
				},
				-- K en l'air : marteau de cône à deux mains abattu vers le bas, jambes repliées
				K_air = {
					label = "Marteau de cône", startup = 0.15, active = 0.14, recovery = 0.24,
					damage = 12, hitbox = box(5, 4, 2, -1), kbBase = 30, kbGrowth = 66, kbAngle = -55,
					windup = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 190, 0, 12 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -12 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -20, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -6 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -24, 0, 0 }, Waist = { -36, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, 6 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 40, 0, -6 }, LE = { 6, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "BADABOUM !",
				},
				-- dash K : slalom entre des cônes imaginaires, pied tendu qui fauche au passage
				K_dash = {
					label = "Slalom", startup = 0.1, active = 0.26, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3, -0.6), kbBase = 30, kbGrowth = 64, kbAngle = 40, selfVelocity = Vector2.new(52, 10),
					windup = { Root = { -8, 20, 0, 0, -0.4, 0 }, Waist = { -10, 24, 0 }, RS = { 60, 0, 50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 } },
					strike = { Root = { 16, -20, 0, 0, -0.6, 0.15 }, Waist = { 10, -24, 0 }, RS = { -20, 0, 60 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 70, 0, 0 }, LK = { -20, 0, 0 } },
					follow = { Root = { 20, 20, 0, 0, -0.62, 0.2 }, Waist = { 12, 24, 0 }, RS = { -26, 0, 65 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 75, 0, 0 }, LK = { -20, 0, 0 } },
					wobble = true, trail = "rightFoot", fx = { "dust" }, hitText = "SKRRRT !",
				},
				-- L : barrage routier : il plante le cône devant lui, bras croisés, et pousse tout le couloir derrière la ligne (enracine)
				S_neutral = {
					label = "Barrage routier", startup = 0.24, active = 0.2, recovery = 0.5,
					damage = 13, hitbox = box(14, 5, 7, 0.8), kbBase = 30, kbGrowth = 52, kbAngle = 25, armor = true,
					status = { name = "rooted", duration = 1.2 },
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.15 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 150, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 40 }, LE = { 110, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.35, -0.4 }, Waist = { -16, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 60, 0, -20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 60 }, LE = { 120, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -14, 0, 0, 0, -0.38, -0.45 }, Waist = { -18, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 55, 0, -22 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 62, 0, 64 }, LE = { 120, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hold = 0.1, trail = "prop", fx = { { "beam", color = CONE, length = 14, width = 2.5, at = "feet" }, { "burst", color = CONE, size = 2.5, at = "front" }, { "symbols", symbols = { "🚧", "ROUTE BARRÉE" }, count = 3, radius = 3, at = "front", color = CONE } },
					text = "ROUTE BARRÉE !", hitText = "BLOQUÉ !",
				},
				-- →L : le haut-parleur de chantier : il rugit dans le cône, l'onde fait trembler tout le couloir (assourdit)
				S_side = {
					label = "Haut-parleur de chantier", startup = 0.26, active = 0.2, recovery = 0.5,
					damage = 15, hitbox = box(14, 5, 7, 1), kbBase = 32, kbGrowth = 60, kbAngle = 32,
					status = { name = "muted", duration = 2 },
					windup = { Root = { 10, 0, 0, 0, -0.15, 0.25 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 110, 0, 10 }, RE = { 120, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.3, -0.35 }, Waist = { -20, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 112, 0, 0 }, RE = { 100, 0, 0 }, RW = { 70, 0, 0 }, LS = { 70, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, 0, 0, 0, -0.32, -0.4 }, Waist = { -22, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 114, 0, 0 }, RE = { 98, 0, 0 }, RW = { 72, 0, 0 }, LS = { 74, 0, -64 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					shake = true, fx = { { "beam", color = CONE, length = 14, width = 3.5, at = "head" }, { "ring", color = CONE, radius = 5, at = "front" }, { "symbols", symbols = { "♪", "RECULEZ", "♫" }, count = 5, radius = 3.5, at = "front", color = CONE }, { "shake", amount = 0.3 } },
					text = "RECULEEEZ !", hitText = "SOURD !",
				},
				-- ↓L : il abat le socle du cône sur le bitume, l'onde de choc roule sur tout le couloir au ras du sol (ralentit)
				S_down = {
					label = "Plaque de chantier", startup = 0.24, active = 0.18, recovery = 0.5,
					damage = 13, hitbox = box(14, 4, 7, -0.5), kbBase = 30, kbGrowth = 55, kbAngle = 78,
					status = { name = "slowed", duration = 2 },
					windup = { Root = { 8, 0, 0, 0, -0.1, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 190, 0, 10 }, RE = { 50, 0, 0 }, RW = { 170, 0, 0 }, LS = { 180, 0, -10 }, LE = { 50, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.7, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 6 }, RE = { 0, 0, 0 }, RW = { 170, 0, 0 }, LS = { 50, 0, -6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -18, 0, 0, 0, -0.75, -0.4 }, Waist = { -34, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, 8 }, RE = { 0, 0, 0 }, RW = { 175, 0, 0 }, LS = { 40, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.1, trail = "prop", fx = { { "ring", color = CONE, radius = 6, at = "feet" }, { "beam", color = Color3.fromRGB(200, 200, 200), length = 14, width = 3, at = "feet" }, { "shake", amount = 0.4 }, { "particles", tex = "smoke", color = Color3.fromRGB(200, 200, 200), dir = "front", at = "feet", time = 0.4, speed = 12 } },
					text = "BOUM !", hitText = "APLATI !",
				},
				-- ↑L : catapulté par le cône : il saute dessus comme sur un tremplin et décolle en diagonale, cône brandi, jambes qui traînent
				S_up = {
					label = "Tremplin de cône", startup = 0.12, active = 0.3, recovery = 0.4,
					damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 52, kbAngle = 74, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 168, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -40 }, LE = { 20, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 172, 0, 12 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -45, 0, -44 }, LE = { 20, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					trail = "prop", fx = { { "ring", color = CONE, radius = 5, at = "feet" }, { "burst", color = CONE, size = 3, at = "feet" }, { "particles", tex = "spark", color = ORANGE, dir = "down", at = "feet", time = 0.35, speed = 14 } },
					text = "TREMPLIN !", hitText = "ENVOLÉ !",
				},
				-- L en l'air : il lâche le cône pointe en bas, qui fonce sur l'adversaire comme une fléchette de chantier
				S_air = {
					label = "Fléchette de chantier", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
					damage = 12, kbBase = 26, kbGrowth = 48, kbAngle = -40,
					projectile = { speed = 70, angle = -50, gravity = 20, lifetime = 0.8, size = 1.8, color = CONE,
						visual = { shape = "cyl", size = 1.6, color = CONE, spin = 6, parts = { { "cyl", Vector3.new(0.7, 0.3, 0.7), Vector3.new(0, 0.5, 0), WHITE }, { "block", Vector3.new(1.2, 0.12, 1.2), Vector3.new(0, 0.9, 0), BLACK } } } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 175, 0, 20 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -30 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 24, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 26, 0, -32 }, LE = { 20, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					hideProp = "cone", fx = { { "burst", color = CONE, size = 2, at = "hand" } }, text = "LÂCHER !", hitText = "PLANTÉ !",
				},
				-- Y : déviation obligatoire : il agite le cône comme un agent de circulation, le panneau tourne et tout le couloir est envoyé dans l'autre sens (commandes inversées)
				SUPER = {
					label = "Déviation obligatoire !", startup = 0.4, active = 0.25, recovery = 0.7,
					damage = 24, hitbox = box(16, 6, 8, 1), kbBase = 48, kbGrowth = 100, kbAngle = 35,
					status = { name = "inverted", duration = 3 },
					windup = { Root = { 0, 30, 0, 0, -0.2, 0.1 }, Waist = { 4, 36, 0 }, Neck = { 0, -26, 0 }, RS = { 100, 0, 80 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -80 }, LE = { 20, 0, 0 } },
					strike = { Root = { -12, -30, 0, 0, -0.3, -0.4 }, Waist = { -14, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 96, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, 10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -14, -36, 0, 0, -0.32, -0.45 }, Waist = { -16, -42, 0 }, Neck = { 0, 28, 0 }, RS = { 100, 0, -14 }, RE = { 4, 0, 0 }, RW = { -8, 0, 0 }, LS = { 100, 0, 14 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hold = 0.15, trail = "prop", windupFx = { "super", { "symbols", symbols = { "⬅️", "➡️", "🚧" }, count = 6, radius = 3.5, color = CONE } },
					fx = { { "beam", color = CONE, length = 16, width = 4, at = "feet" }, { "burst", color = CONE, size = 4, at = "front" }, { "text", text = "SENS INTERDIT", color = CONE, at = "above" }, { "shake", amount = 0.4 } },
					text = "DÉVIATION !", hitText = "DÉVIÉ !",
				},
				-- →Y : le cône-missile : il le charge comme un lance-roquettes sur l'épaule et le tire : il traverse tout le couloir en sifflant
				SUPER_side = {
					label = "Cône-missile !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.9, size = 3.2, color = CONE, pierce = true,
						visual = { shape = "cyl", size = 2.8, color = CONE, spin = 10, parts = { { "cyl", Vector3.new(1.2, 0.4, 1.2), Vector3.new(0, 0.6, 0), WHITE }, { "block", Vector3.new(2, 0.15, 2), Vector3.new(0, 1.3, 0), BLACK }, { "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0, 1.6, 0), STAR } } } },
					windup = { Root = { 8, 20, 0, 0, -0.3, 0.2 }, Waist = { 10, 24, 0 }, Neck = { -10, -20, 0 }, RS = { 150, 0, 40 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -10 }, LE = { 90, 0, 0 } },
					strike = { Root = { -14, 10, 0, 0, -0.34, -0.45 }, Waist = { -16, 14, 0 }, Neck = { -4, -8, 0 }, RS = { 150, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 0 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { 2, 14, 0, 0, -0.2, -0.2 }, Waist = { 6, 18, 0 }, Neck = { -2, -10, 0 }, RS = { 160, 0, 36 }, RE = { 90, 0, 0 }, RW = { -10, 0, 0 }, LS = { 88, 0, 4 }, LE = { 14, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					shake = true, hideProp = "cone", windupFx = { "super", { "symbols", symbols = { "🚧", "3", "2", "1" }, count = 4, radius = 3, color = CONE } },
					fx = { { "burst", color = FIRE_D, size = 3.5, at = "hand" }, { "particles", tex = "fire", color = ORANGE, dir = "front", at = "hand", time = 0.4, speed = 20 }, { "shake", amount = 0.4 } },
					text = "MISSILE !", hitText = "KA-BOUM !",
				},
				-- ↑Y : la grue de chantier : le cône s'allonge en flèche de grue et le soulève, lui et tout le couloir, jusqu'au ciel
				SUPER_up = {
					label = "Grue de chantier !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.9, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 188, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 188, 0, -6 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 190, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 190, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super", { "particles", tex = "spark", color = STAR, dir = "all", at = "feet", time = 0.25, speed = 8 } },
					fx = { { "pillar", color = CONE, height = 22, width = 3, at = "front" }, { "burst", color = STAR, size = 4, at = "above" }, { "ring", color = CONE, radius = 6, at = "feet" }, { "symbols", symbols = { "🏗️", "🚧" }, count = 4, radius = 4, at = "above", color = CONE } },
					text = "GRUE !", hitText = "HISSÉ !",
				},
				-- ↓Y : zone de travaux : il martèle le bitume avec le cône comme un marteau-piqueur, tout le couloir tremble et s'enlise
				SUPER_down = {
					label = "Zone de travaux !", startup = 0.35, active = 0.4, recovery = 0.7,
					damage = 6, hits = 4, hitbox = box(16, 4, 8, -0.5), kbBase = 40, kbGrowth = 85, kbAngle = 65,
					status = { name = "slowed", duration = 2.5 },
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 160, 0, 15 }, RE = { 70, 0, 0 }, RW = { 170, 0, 0 }, LS = { 150, 0, -15 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.6, -0.3 }, Waist = { -26, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 8 }, RE = { 10, 0, 0 }, RW = { 170, 0, 0 }, LS = { 60, 0, -8 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -16, 0, 0, 0, -0.7, -0.34 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 10 }, RE = { 10, 0, 0 }, RW = { 175, 0, 0 }, LS = { 50, 0, -10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, wobble = true, trail = "prop", windupFx = { "super" },
					fx = { { "beam", color = CONE, length = 16, width = 3, at = "feet" }, { "shake", amount = 0.6 }, { "particles", tex = "smoke", color = Color3.fromRGB(200, 200, 200), dir = "all", at = "front", time = 0.5, speed = 14 }, { "symbols", symbols = { "🚧", "TRAVAUX", "🚧" }, count = 5, radius = 4, at = "front", color = CONE } },
					text = "TRAVAUX EN COURS !", hitText = "ENLISÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { K = "K_side", P = "P_neutral", S = "S_side" },
				K_side = { K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "boites_a_pizza", name = "Pile de boîtes à pizza", icon = "🍕",
			prop = { name = "PropPizzas", hand = "Right", pieces = {
				{ "Boite1", "", "block", Vector3.new(1.7, 0.3, 1.7), Vector3.new(0, -0.45, -0.3), Vector3.new(0, 0, 0), CARDBOARD, "Cardboard" },
				{ "Boite2", "", "block", Vector3.new(1.7, 0.3, 1.7), Vector3.new(0.08, -0.8, -0.35), Vector3.new(0, 6, 0), CARDBOARD, "Cardboard" },
				{ "Boite3", "", "block", Vector3.new(1.7, 0.3, 1.7), Vector3.new(-0.06, -1.15, -0.3), Vector3.new(0, -5, 0), CARDBOARD, "Cardboard" },
				{ "Logo", "", "ball", Vector3.new(0.6, 0.06, 0.6), Vector3.new(0, -0.28, -0.3), Vector3.new(0, 0, 0), SAUCE_D, "SmoothPlastic" },
				{ "PartQuiDepasse", "", "wedge", Vector3.new(0.6, 0.12, 0.7), Vector3.new(0.6, -0.62, -0.9), Vector3.new(0, 90, 0), PIZZA, "SmoothPlastic" },
			} },
			ability = { heal = 0.25, jumps = 1, text = "Un saut de plus ; 25 % des dégâts le nourrissent (il grignote)" },
			moves = {
				-- J : il ouvre une boîte et la claque sur le nez de l'adversaire comme une mâchoire en carton
				P_neutral = {
					label = "Boîte claquée", startup = 0.07, active = 0.08, recovery = 0.15,
					damage = 6, hitbox = box(4.5, 3, 2.8, 0.7), kbBase = 20, kbGrowth = 26, kbAngle = 25,
					windup = { Root = { 2, -14, 0, 0, -0.12, 0.1 }, Waist = { 4, -18, 0 }, Neck = { 0, 12, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -8, 14, 0, 0, -0.22, -0.3 }, Waist = { -10, 20, 0 }, Neck = { 0, -12, 0 }, RS = { 94, 0, 0 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 } },
					follow = { Root = { -10, 18, 0, 0, -0.24, -0.34 }, Waist = { -12, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 96, 0, 2 }, RE = { 14, 0, 0 }, RW = { 20, 0, 0 }, LS = { 16, 0, -32 }, LE = { 100, 0, 0 } },
					trail = "prop", hitText = "CLAP !",
				},
				-- →J : une part de pizza jetée à bout portant, en flèche, qui se colle sur le front
				P_side = {
					label = "Part lancée", kind = "projectile", startup = 0.09, active = 0, recovery = 0.2,
					damage = 7, kbBase = 22, kbGrowth = 34, kbAngle = 28,
					projectile = { speed = 72, angle = 4, gravity = 30, lifetime = 0.3, size = 1.2, color = PIZZA, aim = false, visual = SLICE },
					windup = { Root = { 4, -24, 0, 0, -0.15, 0.2 }, Waist = { 6, -28, 0 }, Neck = { 0, 20, 0 }, RS = { 40, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 70, 0, 0 } },
					strike = { Root = { -10, 18, 0, 0, -0.28, -0.35 }, Waist = { -12, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, 0 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 22, 0, 0, -0.3, -0.4 }, Waist = { -14, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 60, 0, 22 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -4 }, LE = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					hitText = "SPLATCH !",
				},
				-- ↓J : accroupi, il fait glisser une pizza entière à plat sur le sol dans les chevilles
				P_down = {
					label = "Pizza glissée", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
					damage = 6, kbBase = 22, kbGrowth = 30, kbAngle = 70,
					projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 0.35, size = 1.4, from = "feet", color = PIZZA, aim = false,
						visual = { shape = "disc", size = 1.6, color = PIZZA, spin = 16, parts = { { "cyl", Vector3.new(0.26, 0.35, 0.35), Vector3.new(0.3, 0.2, 0), SAUCE_D } } } },
					windup = { Root = { 10, 0, 0, 0, -0.85, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -1.0, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 60, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 16, 0, 0, 0, -1.0, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 24, 0, -22 }, LE = { 0, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "leftHand", hitText = "GLISSÉE !",
				},
				-- ↑J : il ouvre la boîte sous le menton de l'adversaire : le nuage de vapeur de fromage le soulève
				P_up = {
					label = "Vapeur de fromage", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 7, hitbox = box(4.5, 5, 1.5, 3), kbBase = 24, kbGrowth = 40, kbAngle = 85,
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, 0.1, -0.1 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 160, 0, 10 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 150, 0, -20 }, LE = { 20, 0, 0 }, LW = { 60, 0, 0 } },
					follow = { Root = { -12, 0, 0, 0, 0.12, -0.12 }, Waist = { -16, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 168, 0, 12 }, RE = { 10, 0, 0 }, RW = { -70, 0, 0 }, LS = { 156, 0, -22 }, LE = { 20, 0, 0 }, LW = { 70, 0, 0 } },
					fx = { { "particles", tex = "smoke", color = Color3.fromRGB(255, 240, 210), dir = "up", at = "hand", time = 0.3, speed = 10, size = 0.6, rate = 60 }, { "symbols", symbols = { "🧀", "♨️" }, count = 2, radius = 1.5, at = "head", color = PIZZA } }, hitText = "FUMANT !",
				},
				-- J en l'air : il appuie la pile entière sous lui comme un plateau qui tombe
				P_air = {
					label = "Pile plongeante", startup = 0.1, active = 0.12, recovery = 0.16,
					damage = 8, hitbox = box(4.5, 4, 1.5, -1.4), kbBase = 20, kbGrowth = 36, kbAngle = -40,
					windup = { Root = { 8, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 180, 0, 15 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -28, 0, 0 }, RS = { 50, 0, 5 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -34, 0, 0 }, RS = { 26, 0, 5 }, RE = { 8, 0, 0 }, RW = { 90, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
					trail = "prop", hitText = "PLOF !",
				},
				-- dash J : « Pizza pour la 12 ! », il fonce la pile à l'horizontale devant lui comme un serveur pressé
				P_dash = {
					label = "Pizza pour la 12", startup = 0.06, active = 0.15, recovery = 0.22,
					damage = 8, hitbox = box(5.5, 3.5, 3, 0.6), kbBase = 26, kbGrowth = 50, kbAngle = 26, selfVelocity = Vector2.new(46, 0),
					windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 20 }, RE = { 100, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -22, 0, 0, 0, -0.4, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 94, 0, 4 }, RE = { 6, 0, 0 }, RW = { 90, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 } },
					follow = { Root = { -24, 0, 0, 0, -0.42, -0.35 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 96, 0, 6 }, RE = { 6, 0, 0 }, RW = { 90, 0, 0 }, LS = { -34, 0, -42 }, LE = { 30, 0, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "🍕", "12" }, count = 2, radius = 1.5, at = "front", color = PIZZA } }, text = "POUR LA 12 !", hitText = "SERVI !",
				},
				-- K : il shoote dans le bas de la pile, les boîtes partent en éventail dans l'adversaire
				K_neutral = {
					label = "Shoot dans la pile", startup = 0.16, active = 0.12, recovery = 0.3,
					damage = 11, hitbox = box(6, 3.5, 3.5, 0.3), kbBase = 30, kbGrowth = 66, kbAngle = 32,
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.1 }, Waist = { 8, -8, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, -0.1, 0.05 }, Waist = { 12, 0, 0 }, RS = { 20, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -55 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 14, 0, 0, 0, -0.1, 0.1 }, Waist = { 16, 0, 0 }, RS = { 24, 0, 64 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 74, 0, -60 }, LE = { 25, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
					trail = "rightFoot", fx = { { "toss", shape = "flat", color = CARDBOARD, size = 1, count = 3, speed = 18 } }, hitText = "CARTONNÉ !",
				},
				-- →K : il fait tourner une boîte fermée comme un frisbee carré et l'envoie en pleine poire
				K_side = {
					label = "Boîte-frisbee", kind = "projectile", startup = 0.16, active = 0, recovery = 0.3,
					damage = 11, kbBase = 30, kbGrowth = 64, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.45, size = 1.8, color = CARDBOARD, aim = false,
						visual = { shape = "block", size = 1.6, color = CARDBOARD, spin = 18, parts = { { "block", Vector3.new(1.7, 0.08, 1.7), Vector3.new(0, 0.2, 0), CARDBOARD }, { "ball", Vector3.new(0.6, 0.06, 0.6), Vector3.new(0, 0.26, 0), SAUCE_D } } } },
					windup = { Root = { 4, 40, 0, 0, -0.2, 0.15 }, Waist = { 6, 46, 0 }, Neck = { 0, -30, 0 }, RS = { 60, 0, 70 }, RE = { 60, 0, 0 }, RW = { 90, 0, 0 }, LS = { 50, 0, -20 }, LE = { 70, 0, 0 } },
					strike = { Root = { -10, -26, 0, 0, -0.3, -0.35 }, Waist = { -12, -32, 0 }, Neck = { 0, 22, 0 }, RS = { 92, 0, -20 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, -36, 0, 0, -0.32, -0.4 }, Waist = { -14, -42, 0 }, Neck = { 0, 28, 0 }, RS = { 94, 0, -40 }, RE = { 6, 0, 0 }, RW = { 90, 0, 0 }, LS = { 26, 0, -44 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hitText = "BOÎTÉ !",
				},
				-- ↓K : balayette basse, la pile posée au sol pour s'appuyer, la jambe gauche fauche
				K_down = {
					label = "Balayette à la pile", startup = 0.14, active = 0.14, recovery = 0.3,
					damage = 10, hitbox = box(7, 2, 3.5, -1.6), kbBase = 28, kbGrowth = 54, kbAngle = 75,
					windup = { Root = { 12, 10, 0, 0, -0.85, 0.1 }, Waist = { 16, 14, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 16, -20, 0, 0, -0.95, -0.1 }, Waist = { 20, -26, 0 }, RS = { 50, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 18, -26, 0, 0, -0.95, -0.14 }, Waist = { 22, -32, 0 }, RS = { 52, 0, 42 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : il lance la pile en l'air d'un coup de genou et la rattrape : les boîtes montent dans le menton
				K_up = {
					label = "Pile au plafond", startup = 0.16, active = 0.12, recovery = 0.3,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 64, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.05, -0.1 }, Waist = { -18, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 176, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.08, -0.12 }, Waist = { -20, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 182, 0, 12 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 116, 0, 0 }, RK = { -124, 0, 0 }, RA = { -20, 0, 0 } },
					trail = "prop", fx = { { "toss", shape = "flat", color = CARDBOARD, size = 1, count = 2, speed = 14, lift = 30 } }, hitText = "HOP !",
				},
				-- K en l'air : coup de talon vers le bas, une boîte coincée sous la semelle
				K_air = {
					label = "Talon à la boîte", startup = 0.14, active = 0.14, recovery = 0.22,
					damage = 11, hitbox = box(5, 4, 2, -1.2), kbBase = 28, kbGrowth = 64, kbAngle = -50,
					windup = { Root = { -10, 0, 0 }, Waist = { -12, 0, 0 }, RS = { 150, 0, 25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					strike = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 10, 0, 0 }, RK = { -6, 0, 0 }, RA = { -20, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					follow = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 154, 0, 26 }, RE = { 60, 0, 0 }, RW = { -10, 0, 0 }, LS = { 64, 0, -32 }, LE = { 60, 0, 0 }, RH = { 2, 0, 0 }, RK = { -4, 0, 0 }, RA = { -22, 0, 0 }, LH = { 55, 0, 0 }, LK = { -95, 0, 0 } },
					trail = "rightFoot", hitText = "TALONNÉ !",
				},
				-- dash K : il glisse assis sur une boîte comme sur une luge, pieds devant
				K_dash = {
					label = "Luge en carton", startup = 0.1, active = 0.26, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3, -0.8), kbBase = 30, kbGrowth = 62, kbAngle = 38, selfVelocity = Vector2.new(55, 12),
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 90, 0, 0 }, LS = { 50, 0, -40 } },
					strike = { Root = { 20, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, RW = { 90, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 24, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, RS = { -36, 0, 55 }, RE = { 20, 0, 0 }, RW = { 90, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "rightFoot", fx = { "dust" }, hitText = "SKRRRT !",
				},
				-- L : rafale de parts : trois parts lancées en éventail d'un seul geste, qui foncent sur l'adversaire
				S_neutral = {
					label = "Rafale de parts", kind = "projectile", startup = 0.2, active = 0, recovery = 0.45,
					damage = 5, kbBase = 24, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.6, size = 1.3, color = PIZZA, visual = SLICE, fan = { count = 3, from = -8, to = 8 } },
					windup = { Root = { 6, -22, 0, 0, -0.2, 0.2 }, Waist = { 8, -26, 0 }, Neck = { 4, 16, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 70, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, 0 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 6 }, LE = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					fx = { { "burst", color = PIZZA, size = 2, at = "lhand" } }, text = "TROIS PARTS !", hitText = "SPLATCH SPLATCH !",
				},
				-- →L : la pizza XXL : une pizza familiale lancée à plat qui traverse tout le couloir et rebondit sur les murs
				S_side = {
					label = "Pizza XXL", kind = "projectile", startup = 0.24, active = 0, recovery = 0.5,
					damage = 15, kbBase = 32, kbGrowth = 60, kbAngle = 32,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.8, size = 2.6, color = PIZZA, pierce = true, bounce = 1,
						visual = { shape = "disc", size = 2.6, color = PIZZA, spin = 20, parts = { { "cyl", Vector3.new(0.3, 0.5, 0.5), Vector3.new(0.6, 0.25, 0), SAUCE_D }, { "cyl", Vector3.new(0.3, 0.5, 0.5), Vector3.new(-0.5, -0.4, 0), SAUCE_D }, { "cyl", Vector3.new(0.3, 0.5, 0.5), Vector3.new(0.1, -0.1, 0.6), SAUCE_D } } } },
					status = { name = "slowed", duration = 1.5 },
					windup = { Root = { 6, 44, 0, 0, -0.25, 0.2 }, Waist = { 8, 50, 0 }, Neck = { 4, -34, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 70 }, LE = { 60, 0, 0 } },
					strike = { Root = { -12, -30, 0, 0, -0.32, -0.4 }, Waist = { -14, -36, 0 }, Neck = { -4, 26, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -30 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					follow = { Root = { -14, -40, 0, 0, -0.36, -0.46 }, Waist = { -18, -46, 0 }, Neck = { -6, 30, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -50 }, LE = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					spin = { axis = "y", degrees = 360 }, fx = { { "burst", color = PIZZA, size = 3, at = "lhand" }, { "ring", color = SAUCE_D, radius = 4, at = "front" } },
					text = "FAMILIALE !", hitText = "PIZZA EN PLEINE FACE !",
				},
				-- ↓L : il pose une boîte à pizza sur le sol : le premier qui marche dessus se fait pincer par le carton
				S_down = {
					label = "Boîte piégée", kind = "trap", startup = 0.2, active = 0.1, recovery = 0.45,
					damage = 13, kbBase = 30, kbGrowth = 55, kbAngle = 75,
					trap = { size = Vector3.new(3, 2, 6), offset = 3, lifetime = 10, max = 2, color = CARDBOARD,
						visual = { shape = "block", size = 1.8, color = CARDBOARD, parts = { { "block", Vector3.new(1.8, 0.3, 1.8), Vector3.new(0, 0, 0), CARDBOARD }, { "ball", Vector3.new(0.6, 0.06, 0.6), Vector3.new(0, 0.18, 0), SAUCE_D } } } },
					windup = { Root = { 8, 0, 0, 0, -0.6, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.95, -0.2 }, Waist = { 24, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 6, 0, 0, 0, -0.6, -0.1 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					fx = { { "symbols", symbols = { "🍕", "?" }, count = 2, radius = 1.5, at = "front", color = PIZZA } }, text = "C'EST POUR VOUS !", hitText = "PIÉGÉ !",
				},
				-- ↑L : la pile-ascenseur : il s'assied sur la pile qui s'empile toute seule sous lui et le propulse en diagonale, boîtes qui volent
				S_up = {
					label = "Pile-ascenseur", startup = 0.12, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 74, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 30 }, RE = { 110, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 110, 0, 0 } },
					strike = { Root = { -38, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, RW = { 90, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 }, RH = { 40, 0, 5 }, RK = { -70, 0, 0 }, LH = { 30, 0, -5 }, LK = { -60, 0, 0 } },
					follow = { Root = { -42, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 156, 0, 34 }, RE = { 20, 0, 0 }, RW = { 90, 0, 0 }, LS = { 156, 0, -34 }, LE = { 20, 0, 0 }, RH = { 44, 0, 6 }, RK = { -74, 0, 0 }, LH = { 34, 0, -6 }, LK = { -64, 0, 0 } },
					trail = "body", fx = { { "pillar", color = CARDBOARD, height = 10, width = 2.5 }, { "toss", shape = "flat", color = CARDBOARD, size = 1, count = 6, speed = 16 }, { "ring", color = PIZZA, radius = 5, at = "feet" } },
					text = "ASCENSEUR !", hitText = "EMPILÉ !",
				},
				-- L en l'air : pluie de parts lâchées sous lui, qui tombent sur l'adversaire
				S_air = {
					label = "Pluie de parts", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 24, kbGrowth = 45, kbAngle = -40,
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.2, color = PIZZA, visual = SLICE, rain = { count = 4, spread = 6 } },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 90, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -10 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 16, 0, 12 }, RE = { 4, 0, 0 }, RW = { 90, 0, 0 }, LS = { 16, 0, -12 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					fx = { { "burst", color = PIZZA, size = 2, at = "feet" } }, text = "ÇA TOMBE !", hitText = "PLOF !",
				},
				-- Y : pizza party : il ouvre toutes les boîtes d'un coup, huit parts partent en éventail et tout le monde rit (de bonheur) sans pouvoir bouger
				SUPER = {
					label = "Pizza party !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.6,
					damage = 4, kbBase = 25, kbGrowth = 40, kbAngle = 40,
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 1.0, size = 1.4, color = PIZZA, visual = SLICE, fan = { count = 8, from = -20, to = 40 } },
					status = { name = "laughing", duration = 2.5 },
					windup = { Root = { 0, 0, 0, 0, -0.5, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 90, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 4, 0, 0, 0, 0.2, 0 }, Waist = { 16, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 140, 0, 70 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -70 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					follow = { Root = { 6, 0, 0, 0, 0.15, 0 }, Waist = { 20, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 150, 0, 80 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -80 }, LE = { 5, 0, 0 } },
					windupFx = { "super", { "symbols", symbols = { "🍕", "🎉", "🍕" }, count = 6, radius = 3, color = PIZZA } }, fx = { { "burst", color = PIZZA, size = 3.5, at = "front" }, { "symbols", symbols = { "🎉", "😂" }, count = 6, radius = 5, at = "front", color = STAR } },
					text = "PIZZA PARTY !", hitText = "TROP BON !",
				},
				-- →Y : le calzone géant : il referme toutes les pizzas en un seul chausson énorme et le lance comme un boulet qui traverse le couloir
				SUPER_side = {
					label = "Calzone géant !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 88, angle = 0, gravity = 0, lifetime = 0.9, size = 3.2, color = CREPE_D, pierce = true,
						visual = { shape = "ball", size = 3, color = CREPE_D, spin = 8, parts = { { "ball", Vector3.new(1.2, 0.8, 2.4), Vector3.new(0, -1, 0), CREPE_D }, { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.8, 0.6, 0.6), SAUCE_D } } } },
					windup = { Root = { 8, -30, 0, 0, -0.4, 0.3 }, Waist = { 12, -34, 0 }, Neck = { 8, 22, 0 }, RS = { 40, 0, 30 }, RE = { 120, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 120, 0, 0 } },
					strike = { Root = { -18, 22, 0, 0, -0.3, -0.5 }, Waist = { -20, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 4 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 26, 0, 0, -0.34, -0.56 }, Waist = { -24, 32, 0 }, Neck = { -8, -18, 0 }, RS = { 100, 0, -4 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 96, 0, 6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					shake = true, hideProp = "pizzas", windupFx = { "super", { "symbols", symbols = { "🥟", "🍕" }, count = 6, radius = 3, color = CREPE_D } },
					fx = { { "burst", color = CREPE_D, size = 3.5, at = "hand" }, { "shake", amount = 0.4 } },
					text = "CALZONE !", hitText = "ÉCRABOUILLÉ !",
				},
				-- ↑Y : le four à pizza : la pile s'enflamme sous ses pieds comme un four à bois et le propulse au plafond avec tout le couloir
				SUPER_up = {
					label = "Four à pizza !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.95, 0 }, Waist = { -32, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, -20 }, RE = { 110, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, 20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 150, 0, 60 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 150, 0, -60 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 160, 0, 70 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 160, 0, -70 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 360 }, windupFx = { "super", { "particles", tex = "fire", color = ORANGE, dir = "up", at = "feet", time = 0.3, speed = 6 } },
					fx = { { "pillar", color = ORANGE, height = 22, width = 3, at = "front" }, { "particles", tex = "fire", color = STAR, dir = "up", at = "front", time = 0.6, speed = 24, size = 1.6, rate = 100 }, { "burst", color = PIZZA, size = 4, at = "above" }, { "ring", color = ORANGE, radius = 6, at = "feet" } },
					text = "AU FOUR !", hitText = "BIEN CUIT !",
				},
				-- ↓Y : le tapis de pizzas : il étale toutes les pizzas sur le sol du couloir, tout le monde glisse sur le fromage fondu
				SUPER_down = {
					label = "Tapis de pizzas !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 60,
					status = { name = "slippery", duration = 2.5 },
					windup = { Root = { 12, 0, 0, 0, -0.5, 0.2 }, Waist = { 20, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 150, 0, 30 }, RE = { 60, 0, 0 }, RW = { 90, 0, 0 }, LS = { 150, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -1.0, -0.3 }, Waist = { 28, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 40, 0, -60 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 20, 0, 0, 0, -1.0, -0.34 }, Waist = { 30, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 30, 0, 70 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -70 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.15, windupFx = { "super" }, fx = { { "puddle", color = PIZZA, width = 16 }, { "toss", shape = "flat", color = PIZZA, size = 1.4, count = 8, speed = 24 }, { "beam", color = PIZZA, length = 16, width = 4, at = "feet" }, { "shake", amount = 0.3 } },
					text = "TAPIS ROUGE… DE SAUCE !", hitText = "ÇA GLISSE !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

	-- Costume : casque de vélo avec support smartphone, blouson de livreur turquoise, énorme sac cube
	-- isotherme sur le dos, short, genouillères et baskets
	look = {
		body = {
			head = SKIN, upper = TEAL, lower = SHORTS, arms = TEAL, hands = SKIN, legs = SHORTS, feet = WHITE,
			forearms = SKIN, shins = SKIN,
		},
		cubeHead = 1.2,
		parts = {
			{ "Casque", "Head", "ball", Vector3.new(1.4, 0.75, 1.45), Vector3.new(0, 0.62, 0), Vector3.new(0, 0, 0), WHITE },
			{ "BandeCasque", "Head", "block", Vector3.new(0.3, 0.2, 1.45), Vector3.new(0, 0.95, 0), Vector3.new(0, 0, 0), TEAL },
			{ "Visiere", "Head", "block", Vector3.new(1.1, 0.12, 0.45), Vector3.new(0, 0.42, -0.72), Vector3.new(-10, 0, 0), TEAL_DARK },
			{ "Support", "Head", "block", Vector3.new(0.12, 0.12, 0.6), Vector3.new(0.35, 0.9, -0.6), Vector3.new(30, 0, 0), BLACK },
			{ "Telephone", "Head", "block", Vector3.new(0.55, 0.85, 0.08), Vector3.new(0.35, 1.25, -0.88), Vector3.new(-20, 0, 0), BLACK },
			{ "Ecran", "Head", "block", Vector3.new(0.45, 0.7, 0.02), Vector3.new(0.35, 1.25, -0.93), Vector3.new(-20, 0, 0), SCREEN, "Neon" },
			{ "Mentonniere", "Head", "block", Vector3.new(1.26, 0.08, 0.08), Vector3.new(0, -0.45, -0.3), Vector3.new(0, 0, 0), BLACK },
			{ "Nez", "Head", "block", Vector3.new(0.22, 0.3, 0.2), Vector3.new(0, -0.08, -0.68), Vector3.new(0, 0, 0), Color3.fromRGB(185, 135, 95) },
			{ "Fermeture", "UpperTorso", "block", Vector3.new(0.1, 1.5, 0.05), Vector3.new(0, 0, -0.52), Vector3.new(0, 0, 0), ORANGE },
			{ "Bandoulieres", "UpperTorso", "block", Vector3.new(1.4, 0.2, 1.06), Vector3.new(0, 0.55, 0), Vector3.new(0, 0, 0), BLACK },
			{ "SacCube", "UpperTorso", "block", Vector3.new(2.4, 2.4, 2), Vector3.new(0, 0.5, 1.5), Vector3.new(0, 0, 0), TEAL, "Fabric" },
			{ "Couvercle", "UpperTorso", "block", Vector3.new(2.45, 0.25, 2.05), Vector3.new(0, 1.65, 1.5), Vector3.new(0, 0, 0), TEAL_DARK, "Fabric" },
			{ "Logo", "UpperTorso", "ball", Vector3.new(1.1, 1.1, 0.1), Vector3.new(0, 0.5, 2.52), Vector3.new(0, 0, 0), WHITE },
			{ "LogoFleche", "UpperTorso", "wedge", Vector3.new(0.12, 0.5, 0.6), Vector3.new(0, 0.5, 2.56), Vector3.new(0, 90, 0), ORANGE },
			{ "Frites", "UpperTorso", "block", Vector3.new(0.5, 0.6, 0.4), Vector3.new(0.6, 1.95, 1.6), Vector3.new(0, 0, 10), Color3.fromRGB(240, 200, 60) },
			{ "Montre", "LeftLowerArm", "block", Vector3.new(0.6, 0.25, 0.6), Vector3.new(0, -0.35, 0), Vector3.new(0, 0, 0), BLACK },
			{ "GenouD", "RightLowerLeg", "block", Vector3.new(0.65, 0.45, 0.3), Vector3.new(0, 0.35, -0.35), Vector3.new(0, 0, 0), ORANGE },
			{ "GenouG", "LeftLowerLeg", "block", Vector3.new(0.65, 0.45, 0.3), Vector3.new(0, 0.35, -0.35), Vector3.new(0, 0, 0), ORANGE },
			{ "SemelleD", "RightFoot", "block", Vector3.new(0.95, 0.15, 1.25), Vector3.new(0, -0.25, -0.1), Vector3.new(0, 0, 0), ORANGE },
			{ "SemelleG", "LeftFoot", "block", Vector3.new(0.95, 0.15, 1.25), Vector3.new(0, -0.25, -0.1), Vector3.new(0, 0, 0), ORANGE },
		},
		props = {
			-- L'arme (Caisse Bizarre) : la trottinette électrique pliée, tenue par le guidon
			{ name = "PropTrottinette", hand = "Right", visible = true, pieces = {
				{ "Guidon", "", "cyl", Vector3.new(1.6, 0.14, 0.14), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic", { axis = "x" } },
				{ "Colonne", "", "cyl", Vector3.new(3, 0.18, 0.18), Vector3.new(0, -1.5, 0), Vector3.new(0, 0, 0), METAL, "Metal" },
				{ "Phare", "", "ball", Vector3.new(0.3, 0.3, 0.2), Vector3.new(0, -0.4, -0.15), Vector3.new(0, 0, 0), Color3.fromRGB(255, 250, 200), "Neon" },
				{ "Plateau", "", "block", Vector3.new(0.45, 0.15, 2.4), Vector3.new(0, -3.05, 1.1), Vector3.new(0, 0, 0), TEAL_DARK },
				{ "RoueAvant", "", "cyl", Vector3.new(0.25, 0.7, 0.7), Vector3.new(0, -3.1, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic", { axis = "x" } },
				{ "RoueArriere", "", "cyl", Vector3.new(0.25, 0.7, 0.7), Vector3.new(0, -3.1, 2.2), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic", { axis = "x" } },
				{ "Bequille", "", "block", Vector3.new(0.08, 0.6, 0.08), Vector3.new(0.2, -3.3, 1.2), Vector3.new(30, 0, 0), METAL, "Metal" },
			} },
			-- Objets ponctuels (prop = "…" dans les coups), main gauche
			{ name = "PropKlaxon", hand = "Left", visible = false, pieces = {
				{ "Poire", "", "ball", Vector3.new(0.6, 0.7, 0.6), Vector3.new(0, -0.2, 0), Vector3.new(0, 0, 0), Color3.fromRGB(220, 40, 40) },
				{ "Pavillon", "", "cyl", Vector3.new(0.9, 0.35, 0.35), Vector3.new(0, -0.8, 0), Vector3.new(0, 0, 0), Color3.fromRGB(230, 190, 70), "Metal" },
				{ "Cornet", "", "cyl", Vector3.new(0.12, 0.65, 0.65), Vector3.new(0, -1.25, 0), Vector3.new(0, 0, 0), Color3.fromRGB(230, 190, 70), "Metal" },
			} },
			{ name = "PropTicket", hand = "Left", visible = false, pieces = {
				{ "Ticket", "", "block", Vector3.new(0.6, 3.2, 0.04), Vector3.new(0, -1.6, 0), Vector3.new(0, 0, 0), WHITE },
				{ "Total", "", "block", Vector3.new(0.5, 0.2, 0.05), Vector3.new(0, -2.9, 0), Vector3.new(0, 0, 0), BLACK },
			} },
			{ name = "PropTelephone", hand = "Left", visible = false, pieces = {
				{ "Coque", "", "block", Vector3.new(0.6, 0.95, 0.12), Vector3.new(0, -0.4, -0.15), Vector3.new(0, 0, 0), BLACK },
				{ "EcranTel", "", "block", Vector3.new(0.5, 0.8, 0.02), Vector3.new(0, -0.4, -0.22), Vector3.new(0, 0, 0), SCREEN, "Neon" },
			} },
			{ name = "PropColis", hand = "Left", visible = false, pieces = {
				{ "Carton", "", "block", Vector3.new(1.6, 1.3, 1.3), Vector3.new(0, -0.6, -0.5), Vector3.new(0, 0, 0), CARDBOARD },
				{ "Scotch", "", "block", Vector3.new(1.65, 0.25, 1.35), Vector3.new(0, -0.6, -0.5), Vector3.new(0, 0, 0), TAPE },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Jab de klaxon : petit direct du gauche, la poire du klaxon couine sur le nez de l'adversaire
		P_neutral = {
			label = "Jab de klaxon", startup = 0.06, active = 0.07, recovery = 0.14,
			damage = 5, hitbox = box(4, 3, 2.6, 0.8), kbBase = 16, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { -2, 16, 0, 0, -0.15, 0.1 }, Waist = { -2, 12, 0 }, Neck = { 0, -10, 0 }, RS = { 30, 0, 20 }, RE = { 70, 0, 0 }, LS = { 50, 0, -10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -14, 0, 0, -0.2, -0.25 }, Waist = { -6, -18, 0 }, Neck = { 0, 12, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 95, 0, 5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -9, -16, 0, 0, -0.2, -0.28 }, Waist = { -7, -20, 0 }, Neck = { 0, 14, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 92, 0, 4 }, LE = { 8, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
			prop = "klaxon", trail = "leftHand", text = "POUET !", hitText = "POUET POUET !",
		},
		-- Kick de béquille : il pousse la trottinette à l'horizontale, plateau en avant, béquille dans les côtes
		P_side = {
			label = "Kick de béquille", startup = 0.09, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(6, 3, 3.5, 0.3), kbBase = 24, kbGrowth = 40, kbAngle = 20, selfVelocity = Vector2.new(22, 0),
			windup = { Root = { 4, -25, 0, 0, -0.25, 0.25 }, Waist = { 4, -28, 0 }, Neck = { 0, 20, 0 }, RS = { 40, 0, 35 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 18, 0, 0, -0.32, -0.45 }, Waist = { -10, 22, 0 }, Neck = { 0, -15, 0 }, RS = { 90, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -25 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 22, 0, 0, -0.34, -0.5 }, Waist = { -12, 26, 0 }, Neck = { 0, -18, 0 }, RS = { 94, 0, -8 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { 25, 0, -28 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "prop", hitText = "CLAC !",
		},
		-- Ticket de caisse coupant : accroupi, il déroule un ticket de caisse interminable au ras des chevilles
		P_down = {
			label = "Ticket de caisse coupant", startup = 0.08, active = 0.1, recovery = 0.18,
			damage = 5, hitbox = box(5, 1.6, 2.8, -2.1), kbBase = 22, kbGrowth = 22, kbAngle = 70,
			windup = { Root = { -8, 20, 0, 0, -0.75, 0.1 }, Waist = { -14, 20, 0 }, Neck = { 10, -15, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 30, 0, 60 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, -18, 0, 0, -0.85, -0.15 }, Waist = { -18, -20, 0 }, Neck = { 10, 15, 0 }, RS = { 25, 0, 35 }, RE = { 60, 0, 0 }, LS = { 50, 0, -60 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -12, -26, 0, 0, -0.85, -0.18 }, Waist = { -18, -28, 0 }, Neck = { 10, 20, 0 }, RS = { 25, 0, 35 }, RE = { 60, 0, 0 }, LS = { 45, 0, -85 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "ticket", trail = "leftHand", text = "VOTRE TICKET !", hitText = "TCHIC !",
		},
		-- Uppercut casque (anti-air) : il se ramasse puis bondit genoux serrés, bras ballants en arrière, casque le premier
		P_up = {
			label = "Uppercut casque", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 5, 2.5, 3), kbBase = 26, kbGrowth = 32, kbAngle = 85, selfVelocity = Vector2.new(0, 28),
			windup = { Root = { -8, 0, 0, 0, -0.8, 0 }, Waist = { -22, 0, 0 }, Neck = { -25, 0, 0 }, RS = { -30, 0, 25 }, RE = { 30, 0, 0 }, LS = { -30, 0, -25 }, LE = { 30, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.35, 0 }, Waist = { 12, 0, 0 }, Neck = { 42, 0, 0 }, RS = { -60, 0, 20 }, RE = { 10, 0, 0 }, LS = { -60, 0, -20 }, LE = { 10, 0, 0 }, RH = { 70, 0, 0 }, RK = { -120, 0, 0 }, LH = { 70, 0, 0 }, LK = { -120, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.45, 0 }, Waist = { 14, 0, 0 }, Neck = { 46, 0, 0 }, RS = { -65, 0, 22 }, RE = { 10, 0, 0 }, LS = { -65, 0, -22 }, LE = { 10, 0, 0 }, RH = { 75, 0, 0 }, RK = { -125, 0, 0 }, LH = { 75, 0, 0 }, LK = { -125, 0, 0 } },
			trail = "head", fx = { { "symbols", symbols = { "📱", "DING" }, count = 2, radius = 1.5, at = "head", color = SCREEN } }, hitText = "TOC CASQUE !",
		},
		-- Uppercut de casque (en l'air) : genoux remontés puis grand coup de casque vers l'avant et le haut
		P_air = {
			label = "Uppercut de casque", startup = 0.08, active = 0.1, recovery = 0.16,
			damage = 7, hitbox = box(4, 3.5, 1.8, 1.5), kbBase = 22, kbGrowth = 34, kbAngle = 60,
			windup = { Root = { -14, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 35, 0, 0 }, RS = { -40, 0, 40 }, RE = { 15, 0, 0 }, LS = { -40, 0, -40 }, LE = { 15, 0, 0 }, RH = { 10, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { -45, 0, 45 }, RE = { 15, 0, 0 }, LS = { -45, 0, -45 }, LE = { 15, 0, 0 }, RH = { 5, 0, 0 }, RK = { -45, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "head", hitText = "BONG !",
		},
		-- Livreur pressé (dash puis P) : « Pardon, j'ai une commande ! », trottinette tenue en travers à deux mains comme un bélier
		P_dash = {
			label = "Livreur pressé", startup = 0.06, active = 0.15, recovery = 0.22,
			damage = 8, hitbox = box(5.5, 4, 2.8, 0.6), kbBase = 28, kbGrowth = 52, kbAngle = 25, selfVelocity = Vector2.new(48, 0),
			windup = { Root = { -8, 0, 0, 0, -0.3, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 90 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, -0.4, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 92, 0, 8 }, RE = { 10, 0, 0 }, RW = { 0, 0, 90 }, LS = { 92, 0, -8 }, LE = { 10, 0, 0 } },
			follow = { Root = { -24, 0, 0, 0, -0.42, -0.35 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 94, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 90 }, LS = { 94, 0, -10 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 6 } }, text = "J'AI UNE COMMANDE !", hitText = "BOUSCULÉ !",
		},

		-- Suites d'enchaînement (voir LINKS) : P P, P P P…
		-- P P : Coup de sac isotherme, il pivote sur lui-même et le gros sac cube cogne au passage
		P_combo2 = {
			label = "Coup de sac isotherme", startup = 0.07, active = 0.12, recovery = 0.16,
			damage = 6, hitbox = box(5.5, 3.5, 2.5, 0.6), kbBase = 18, kbGrowth = 24, kbAngle = 30,
			windup = { Root = { -4, -30, 0, 0, -0.2, 0 }, Waist = { -6, -20, 0 }, Neck = { 0, 20, 0 }, RS = { 30, 0, 45 }, RE = { 50, 0, 0 }, LS = { 30, 0, -45 }, LE = { 50, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.25, -0.1 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.25, -0.12 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 38, 0, 55 }, RE = { 35, 0, 0 }, LS = { 38, 0, -55 }, LE = { 35, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", hitText = "BOUF !",
		},
		-- P P P : Trottinette pliée, il lève la trottinette et l'abat comme un marteau
		P_combo3 = {
			label = "Trottinette pliée", startup = 0.1, active = 0.1, recovery = 0.28,
			damage = 8, hitbox = box(5, 4, 2.8, 1), kbBase = 30, kbGrowth = 58, kbAngle = 45,
			windup = { Root = { 6, -10, 0, 0, -0.05, 0.2 }, Waist = { 10, -12, 0 }, Neck = { 15, 0, 0 }, RS = { 190, 0, 15 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -5 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 10, 0, 0, -0.4, -0.35 }, Waist = { -26, 12, 0 }, Neck = { -5, 0, 0 }, RS = { 75, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 15 }, LE = { 20, 0, 0 } },
			follow = { Root = { -16, 12, 0, 0, -0.45, -0.4 }, Waist = { -30, 14, 0 }, Neck = { -8, 0, 0 }, RS = { 50, 0, 5 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { 50, 0, 15 }, LE = { 25, 0, 0 } },
			trail = "prop", fx = { { "burst", color = TEAL, size = 2.5 } }, text = "LIVRÉ !", hitText = "BADABANG !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Coup de trottinette : grand balayage à deux mains, la trottinette tourne comme une batte
		K_neutral = {
			label = "Coup de trottinette", startup = 0.17, active = 0.1, recovery = 0.28,
			damage = 11, hitbox = box(6, 3, 3.5, 0.5), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { 4, -35, 0, 0, -0.3, 0.25 }, Waist = { 6, -40, 0 }, Neck = { 0, 30, 0 }, RS = { 70, 0, 80 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 45 }, LE = { 70, 0, 0 } },
			strike = { Root = { -10, 25, 0, 0, -0.35, -0.35 }, Waist = { -10, 32, 0 }, Neck = { 0, -20, 0 }, RS = { 95, 0, -10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 20 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -12, 38, 0, 0, -0.35, -0.4 }, Waist = { -12, 46, 0 }, Neck = { 0, -30, 0 }, RS = { 88, 0, -45 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 85, 0, -5 }, LE = { 45, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			trail = "prop", hitText = "BANG !",
		},
		-- Poussée de trottineur : pied sur le plateau, il pousse la trottinette d'un grand coup de jambe… droit dans le ventre de l'adversaire
		K_side = {
			label = "Poussée de trottineur", startup = 0.16, active = 0.12, recovery = 0.28,
			damage = 11, hitbox = box(6, 3.5, 3.5, 0), kbBase = 32, kbGrowth = 72, kbAngle = 28, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { 4, -10, 0, 0, -0.25, 0.15 }, Waist = { 2, -8, 0 }, Neck = { 4, 6, 0 }, RS = { 50, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 90 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.35, -0.35 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 96, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 90 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 }, RH = { 55, 0, 0 }, RK = { -10, 0, 0 }, RA = { 30, 0, 0 } },
			follow = { Root = { -22, 0, 0, 0, -0.38, -0.4 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 98, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 90 }, LS = { -45, 0, -42 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -5, 0, 0 }, RA = { 32, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = ORANGE, dir = "front", at = "feet", time = 0.25, speed = 8 } }, text = "POUSSE-TOI !", hitText = "PFOUM !",
		},
		-- Roue avant dans le tibia : accroupi, il pique la roue avant de la trottinette au ras du sol
		K_down = {
			label = "Roue avant dans le tibia", startup = 0.16, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(6, 1.8, 3.5, -1.8), kbBase = 28, kbGrowth = 60, kbAngle = 60,
			windup = { Root = { -6, -20, 0, 0, -0.7, 0.2 }, Waist = { -12, -20, 0 }, Neck = { 10, 15, 0 }, RS = { 20, 0, 45 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -14, 15, 0, 0, -0.85, -0.3 }, Waist = { -20, 18, 0 }, Neck = { 12, -12, 0 }, RS = { 60, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -15, 18, 0, 0, -0.85, -0.35 }, Waist = { -22, 22, 0 }, Neck = { 12, -15, 0 }, RS = { 55, 0, -5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 28, 0, -32 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = ORANGE, dir = "front", at = "feet", time = 0.2, speed = 8 } }, hitText = "CRIC !",
		},
		-- Freinage arrière : penché en avant, il donne un coup de talon vers le haut comme sur le frein arrière
		K_up = {
			label = "Freinage arrière", startup = 0.16, active = 0.14, recovery = 0.28,
			damage = 11, hitbox = box(4.5, 5, 0, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88,
			windup = { Root = { -10, 0, 0, 0, -0.35, 0 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -100, 0, 0 } },
			strike = { Root = { -40, 0, 0, 0, -0.3, -0.2 }, Waist = { -20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 80, 0, 40 }, RE = { 20, 0, 0 }, LS = { 80, 0, -40 }, LE = { 20, 0, 0 }, RH = { -70, 0, 0 }, RK = { -110, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -44, 0, 0, 0, -0.3, -0.22 }, Waist = { -22, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 85, 0, 45 }, RE = { 20, 0, 0 }, LS = { 85, 0, -45 }, LE = { 20, 0, 0 }, RH = { -78, 0, 0 }, RK = { -100, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightFoot", fx = { { "particles", tex = "spark", color = ORANGE, dir = "up", at = "feet", time = 0.2, speed = 6 } }, text = "SCRIIICH !", hitText = "FREINÉ !",
		},
		-- Wheelie aérien : en l'air, il ramène la trottinette devant lui et cabre la roue avant
		K_air = {
			label = "Wheelie aérien", startup = 0.15, active = 0.14, recovery = 0.24,
			damage = 11, hitbox = box(5, 4, 2.5, 1), kbBase = 30, kbGrowth = 68, kbAngle = 50,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 30 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 140, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, 10 }, LE = { 20, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 140, 0, 10 }, LE = { 20, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 5, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "prop", text = "WHEELIE !", hitText = "VROUM !",
		},
		-- Genou de coursier (dash puis K) : il saute la bordure du trottoir genou en avant, trottinette brandie au-dessus du casque
		K_dash = {
			label = "Genou de coursier", startup = 0.08, active = 0.25, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4, 3, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 40, selfVelocity = Vector2.new(50, 28),
			windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 185, 0, 15 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 }, RH = { 110, 0, 0 }, RK = { -125, 0, 0 }, RA = { -25, 0, 0 }, LH = { -20, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { -14, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 18 }, RE = { 30, 0, 0 }, RW = { -10, 0, 0 }, LS = { -45, 0, -42 }, LE = { 30, 0, 0 }, RH = { 118, 0, 0 }, RK = { -128, 0, 0 }, RA = { -25, 0, 0 }, LH = { -25, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "rightLeg", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 6 } }, text = "LA BORDURE !", hitText = "GENOU EXPRESS !",
		},

		-- Suites d'enchaînement : K K, K K K
		-- K K : Revers de trottinette, la trottinette revient de gauche à droite
		K_combo2 = {
			label = "Revers de trottinette", startup = 0.1, active = 0.1, recovery = 0.24,
			damage = 9, hitbox = box(5.5, 3.5, 3, 0.5), kbBase = 26, kbGrowth = 46, kbAngle = 30,
			windup = { Root = { -6, 35, 0, 0, -0.3, -0.3 }, Waist = { -8, 40, 0 }, Neck = { 0, -30, 0 }, RS = { 90, 0, -50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -8, -18, 0, 0, -0.3, -0.35 }, Waist = { -8, -26, 0 }, Neck = { 0, 18, 0 }, RS = { 92, 0, 45 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			follow = { Root = { -8, -26, 0, 0, -0.3, -0.38 }, Waist = { -8, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 85, 0, 75 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 28, 0, -32 }, LE = { 80, 0, 0 } },
			trail = "prop", hitText = "VLAN !",
		},
		-- K K K : Wheelie au sol, il cabre la trottinette de bas en haut (fait décoller)
		K_combo3 = {
			label = "Wheelie au sol", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(5, 5, 2.5, 1.5), kbBase = 34, kbGrowth = 78, kbAngle = 78,
			windup = { Root = { -10, -10, 0, 0, -0.65, 0.1 }, Waist = { -20, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 10, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { 10, 5, 0, 0, 0.15, -0.2 }, Waist = { 14, 8, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, 10 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 12, 8, 0, 0, 0.2, -0.25 }, Waist = { 16, 10, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 160, 0, 10 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			trail = "prop", text = "CABRÉ !", hitText = "VROOOM !",
		},
		-- P puis K : Genou pressé, petit genou sec sans même lever les yeux de son téléphone
		PK_combo = {
			label = "Genou pressé", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(5, 3.5, 2.5, 0.5), kbBase = 20, kbGrowth = 28, kbAngle = 40,
			windup = { Root = { 4, -6, 0, 0, -0.2, 0.1 }, Neck = { 20, 20, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, 0, -0.3 }, Waist = { -8, 4, 0 }, Neck = { 22, 20, 0 }, RS = { -10, 0, 40 }, RE = { 50, 0, 0 }, LS = { -10, 0, -40 }, LE = { 50, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -11, 6, 0, 0, 0.02, -0.32 }, Waist = { -9, 4, 0 }, Neck = { 22, 20, 0 }, RS = { -12, 0, 42 }, RE = { 50, 0, 0 }, LS = { -12, 0, -42 }, LE = { 50, 0, 0 }, RH = { 104, 0, 0 }, RK = { -122, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightLeg", hitText = "GNOC !",
		},
		-- K puis P : Klaxon de rappel, crochet du gauche avec la poire du klaxon
		KP_combo = {
			label = "Klaxon de rappel", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 20, kbGrowth = 32, kbAngle = 30,
			windup = { Root = { 2, 25, 0, 0, -0.2, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 0, -15, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 75, 0, -70 }, LE = { 95, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.25, -0.3 }, Waist = { -8, -32, 0 }, Neck = { 0, 15, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 92, 0, -10 }, LE = { 75, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -9, -26, 0, 0, -0.25, -0.33 }, Waist = { -9, -40, 0 }, Neck = { 0, 20, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 88, 0, 15 }, LE = { 80, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "klaxon", trail = "leftHand", hitText = "POUEEET !",
		},

		-- → P P : Coup de guidon, il pivote la trottinette et plante le guidon dans les côtes
		P_side2 = {
			label = "Coup de guidon", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(6, 3.5, 3, 0.6), kbBase = 20, kbGrowth = 30, kbAngle = 25, selfVelocity = Vector2.new(14, 0),
			windup = { Root = { -6, 30, 0, 0, -0.3, -0.2 }, Waist = { -8, 34, 0 }, Neck = { 0, -24, 0 }, RS = { 80, 0, -40 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -25 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, -16, 0, 0, -0.32, -0.45 }, Waist = { -12, -22, 0 }, Neck = { 0, 14, 0 }, RS = { 94, 0, 30 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, -24, 0, 0, -0.32, -0.5 }, Waist = { -12, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 88, 0, 50 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 18, 0, -32 }, LE = { 100, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", hitText = "CLONG !",
		},
		-- → P P P : Sonnette dans l'oreille, il colle la sonnette de la trottinette sur l'oreille et appuie comme un fou (finition)
		P_side3 = {
			label = "Sonnette dans l'oreille", startup = 0.1, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(6, 4, 3, 1), kbBase = 34, kbGrowth = 76, kbAngle = 36, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 4, -20, 0, 0, -0.2, 0.15 }, Waist = { 6, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 110, 0, 35 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 110, 0, 0 } },
			strike = { Root = { -12, 14, 0, 0, -0.3, -0.45 }, Waist = { -14, 18, 0 }, Neck = { 6, -12, 0 }, RS = { 100, 0, -10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 16, 0, 0, -0.3, -0.5 }, Waist = { -14, 20, 0 }, Neck = { 8, -14, 0 }, RS = { 102, 0, -14 }, RE = { 10, 0, 0 }, RW = { -8, 0, 0 }, LS = { 98, 0, 6 }, LE = { 115, 0, 0 }, LW = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			shake = true, trail = "prop", fx = { { "symbols", symbols = { "🔔", "DRING", "🔔" }, count = 6, radius = 3, at = "front", color = STAR }, { "ring", color = SCREEN, radius = 4, at = "front" }, { "shake", amount = 0.3 } },
			text = "DRIIIING !", hitText = "MES OREILLES !",
		},
		-- ↓ P P : Ticket qui n'en finit plus, le ticket de caisse continue de se dérouler et claque deux fois les chevilles
		P_down2 = {
			label = "Ticket qui n'en finit plus", startup = 0.07, active = 0.16, recovery = 0.2,
			damage = 3, hits = 2, hitbox = box(6.5, 3.5, 3.2, -0.6), kbBase = 20, kbGrowth = 24, kbAngle = 65,
			windup = { Root = { -12, 10, 0, 0, -0.8, 0 }, Waist = { -18, 10, 0 }, Neck = { 12, -8, 0 }, RS = { 25, 0, 35 }, RE = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, -25, 0, 0, -0.85, -0.2 }, Waist = { -20, -28, 0 }, Neck = { 12, 20, 0 }, RS = { 25, 0, 35 }, RE = { 60, 0, 0 }, LS = { 55, 0, -90 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -14, 25, 0, 0, -0.85, -0.25 }, Waist = { -20, 28, 0 }, Neck = { 12, -20, 0 }, RS = { 25, 0, 35 }, RE = { 60, 0, 0 }, LS = { 55, 0, -20 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 } },
			wobble = true, prop = "ticket", trail = "leftHand", fx = { { "symbols", symbols = { "🧾", "TOTAL : 847,50 €" }, count = 3, radius = 2.5, at = "front", color = WHITE } }, text = "ET ÇA CONTINUE…", hitText = "TCHIC TCHIC !",
		},
		-- ↓ P P P : Frite dans l'œil, il pioche une frite dans le sac isotherme et la plante dans l'œil (finition, aveugle)
		P_down3 = {
			label = "Frite dans l'œil", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(6, 4, 3, 0.8), kbBase = 34, kbGrowth = 70, kbAngle = 60, status = { name = "blinded", duration = 1.5 },
			windup = { Root = { 4, -30, 0, 0, -0.3, 0.1 }, Waist = { 6, -36, 0 }, Neck = { 0, 30, 0 }, RS = { 25, 0, 30 }, RE = { 60, 0, 0 }, LS = { 150, 0, -50 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 18, 0, 0, -0.32, -0.45 }, Waist = { -14, 22, 0 }, Neck = { 2, -14, 0 }, RS = { 25, 0, 30 }, RE = { 60, 0, 0 }, LS = { 100, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -12, 22, 0, 0, -0.32, -0.5 }, Waist = { -14, 26, 0 }, Neck = { 4, -16, 0 }, RS = { 25, 0, 30 }, RE = { 60, 0, 0 }, LS = { 102, 0, -4 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "leftHand", fx = { { "symbols", symbols = { "🍟", "👁️", "🍟" }, count = 4, radius = 2.5, at = "front", color = Color3.fromRGB(240, 200, 60) }, { "burst", color = Color3.fromRGB(240, 200, 60), size = 2.5, at = "front" } },
			text = "UNE FRITE ?", hitText = "DANS L'ŒIL !",
		},
		-- → K K : Sac cube en toupie, il tourne sur lui-même et le gros sac isotherme balaie tout au passage
		K_side2 = {
			label = "Sac cube en toupie", startup = 0.08, active = 0.14, recovery = 0.2,
			damage = 8, hitbox = box(6, 4, 2.5, 0.8), kbBase = 24, kbGrowth = 40, kbAngle = 30, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { -4, -35, 0, 0, -0.25, 0 }, Waist = { -6, -25, 0 }, Neck = { 0, 25, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 30, 0, -50 }, LE = { 50, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.3, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 45, 0, 70 }, RE = { 25, 0, 0 }, LS = { 45, 0, -70 }, LE = { 25, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -0.3, -0.22 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 42, 0, 65 }, RE = { 30, 0, 0 }, LS = { 42, 0, -65 }, LE = { 30, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", fx = { { "symbols", symbols = { "🍟", "🍕" }, count = 3, radius = 2.5, at = "root", color = PIZZA } }, text = "HOP !", hitText = "BOUF !",
		},
		-- → K K K : Trottinette javelot, il tend la trottinette à bout de bras et fonce comme un javelot sur roulettes (finition)
		K_side3 = {
			label = "Trottinette javelot", startup = 0.1, active = 0.16, recovery = 0.34,
			damage = 12, hitbox = box(7, 4, 4, 0.6), kbBase = 36, kbGrowth = 84, kbAngle = 30, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { 2, -25, 0, 0, -0.25, 0.2 }, Waist = { 4, -28, 0 }, Neck = { 0, 22, 0 }, RS = { 60, 0, 40 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -20, 15, 0, 0, -0.38, -0.5 }, Waist = { -16, 20, 0 }, Neck = { 6, -12, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -30 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -24, 18, 0, 0, -0.4, -0.55 }, Waist = { -18, 22, 0 }, Neck = { 8, -14, 0 }, RS = { 98, 0, -8 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -45, 0, -32 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = ORANGE, dir = "up", at = "feet", time = 0.3, speed = 8 }, { "burst", color = TEAL, size = 3, at = "front" } }, text = "LIVRAISON !", hitText = "EMBROCHÉ !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : Coup de sac aérien, il tourne sur lui-même et le sac cube balaie l'air
		P_air_side = {
			label = "Coup de sac aérien", startup = 0.08, active = 0.14, recovery = 0.18,
			damage = 7, hitbox = box(5, 3.5, 1.5, 0.3), kbBase = 22, kbGrowth = 38, kbAngle = 30,
			windup = { Root = { -6, -30, 0 }, Waist = { -8, -20, 0 }, Neck = { 0, 25, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 50, 0, 70 }, RE = { 20, 0, 0 }, LS = { 50, 0, -70 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 48, 0, 65 }, RE = { 25, 0, 0 }, LS = { 48, 0, -65 }, LE = { 25, 0, 0 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", hitText = "BOUF !",
		},
		-- ↑ P en l'air : Guidon au ciel, la trottinette tenue à deux mains par le guidon est hissée en travers au-dessus du casque
		P_air_up = {
			label = "Guidon au ciel", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 42, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 25 }, RE = { 90, 0, 0 }, RW = { 0, 0, 90 }, LS = { 20, 0, -25 }, LE = { 90, 0, 0 }, RH = { 85, 0, 0 }, RK = { -115, 0, 0 }, LH = { 80, 0, 0 }, LK = { -115, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 90 }, LS = { 160, 0, -10 }, LE = { 5, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 192, 0, 8 }, RE = { 5, 0, 0 }, RW = { 0, 0, 90 }, LS = { 188, 0, -8 }, LE = { 5, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			trail = "prop", hitText = "TCHING !",
		},
		-- ↓ P en l'air : Roue avant plongeante, trottinette brandie à deux mains puis roue plantée vers le bas
		P_air_down = {
			label = "Roue avant plongeante", startup = 0.15, active = 0.1, recovery = 0.28,
			damage = 9, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78,
			windup = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, -8 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, 8 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -18, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 6 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 20, 0, -6 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 20, 0, 6 }, LE = { 5, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "prop", text = "TERMINUS !", hitText = "KLONK !",
		},
		-- → K en l'air : Coup de pied du coursier, jambe droite détendue à l'horizontale, trottinette brandie à deux mains au-dessus du casque
		K_air_side = {
			label = "Coup de pied du coursier", startup = 0.13, active = 0.12, recovery = 0.24,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 68, kbAngle = 35,
			windup = { Root = { -14, 20, 0 }, Waist = { -14, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 50, 0, 45 }, RE = { 70, 0, 0 }, LS = { 70, 0, -30 }, LE = { 80, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 20, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, -10, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -20 }, LE = { 30, 0, 0 }, RH = { 68, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 30, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, -10, 0 }, RS = { 175, 0, 24 }, RE = { 30, 0, 0 }, RW = { -10, 0, 0 }, LS = { 165, 0, -24 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Salto du coursier, salto arrière debout sur la trottinette, guidon tenu devant, les deux baskets passent ensemble au-dessus du casque
		K_air_up = {
			label = "Salto du coursier", startup = 0.12, active = 0.2, recovery = 0.24,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 64, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 90 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 145, 0, 8 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 135, 0, -8 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 62, 0, 32 }, RE = { 60, 0, 0 }, RW = { 0, 0, 90 }, LS = { 62, 0, -32 }, LE = { 60, 0, 0 }, RH = { 120, 0, 8 }, RK = { -20, 0, 0 }, LH = { 110, 0, -8 }, LK = { -20, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "SALTO !", hitText = "POC !",
		},
		-- ↓ K en l'air : Atterrissage sur colis, les deux pieds joints sur le plateau et le guidon serré, il écrase ce qui est dessous
		K_air_down = {
			label = "Atterrissage sur colis", startup = 0.16, active = 0.15, recovery = 0.28,
			damage = 11, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, RW = { 0, 0, 90 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 90 }, LS = { 70, 0, -20 }, LE = { 20, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 65, 0, 22 }, RE = { 25, 0, 0 }, RW = { 0, 0, 90 }, LS = { 65, 0, -22 }, LE = { 25, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "COLIS ÉCRASÉ !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Pizza frisbee : il sort une pizza du sac cube et la lance comme un frisbee, elle fonce droit sur la tête de l'adversaire
		S_neutral = {
			label = "Pizza frisbee", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
			damage = 12, kbBase = 22, kbGrowth = 40, kbAngle = 20,
			projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.6, size = 2, color = PIZZA,
				visual = { shape = "disc", size = 2, color = PIZZA, spin = 20, parts = {
					{ "cyl", Vector3.new(0.28, 0.4, 0.4), Vector3.new(0.4, 0.2, 0), Color3.fromRGB(200, 40, 30) },
					{ "cyl", Vector3.new(0.28, 0.4, 0.4), Vector3.new(-0.3, -0.35, 0), Color3.fromRGB(200, 40, 30) },
				} } },
			windup = { Root = { 0, 30, 0, 0, -0.2, 0.15 }, Waist = { 0, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 70, 0, 60 }, LE = { 110, 0, 0 } },
			strike = { Root = { -6, -15, 0, 0, -0.25, -0.2 }, Waist = { -6, -20, 0 }, Neck = { 0, 10, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 90, 0, -40 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -6, -22, 0, 0, -0.25, -0.22 }, Waist = { -6, -28, 0 }, Neck = { 0, 15, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 85, 0, -65 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
			text = "PIZZA !", hitText = "SPLAF !",
		},
		-- Rush trottinette : il saute sur la trottinette et traverse tout le couloir à fond, guidon en avant
		S_side = {
			label = "Rush trottinette", startup = 0.15, active = 0.4, recovery = 0.4,
			damage = 14, hitbox = box(14, 5, 6, 0.5), kbBase = 32, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(85, 0),
			windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 0 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 50, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.2, -0.2 }, Waist = { -14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 18 }, LE = { 20, 0, 0 }, LH = { -40, 0, 0 }, LK = { -20, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.2, -0.22 }, Waist = { -16, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 72, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 72, 0, 18 }, LE = { 20, 0, 0 }, LH = { -45, 0, 0 }, LK = { -25, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "body", fx = { { "particles", tex = "spark", color = ORANGE, dir = "up", at = "feet", time = 0.4, speed = 8 } }, text = "EN RETAAAARD !", hitText = "PAF !",
		},
		-- Livraison glissée : il pose le colis piégé au sol et le pousse d'un coup de pied ; il file droit sur l'adversaire et explose en confettis
		S_down = {
			label = "Livraison glissée", kind = "projectile", startup = 0.18, active = 0, recovery = 0.4,
			damage = 13, kbBase = 30, kbGrowth = 55, kbAngle = 70,
			projectile = { speed = 62, angle = 0, gravity = 0, lifetime = 0.8, size = 1.8, from = "feet", color = CARDBOARD, visual = PARCEL },
			windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 80, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.4, -0.2 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 40, 0, -10 }, LE = { 10, 0, 0 }, RH = { 70, 0, 0 }, RK = { -10, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.4, -0.25 }, Waist = { -22, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 35, 0, -12 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", windupFx = { { "symbols", symbols = { "📦" }, count = 1, radius = 1, at = "front" } }, fx = { { "burst", color = CARDBOARD, size = 2, at = "feet" } }, text = "LIVRÉ !", hitText = "CONFETTIS !",
		},
		-- Dérapage (après une esquive) : il revient en glissade, la trottinette en travers rase tout le couloir
		S_dodge = {
			label = "Dérapage", startup = 0.15, active = 0.3, recovery = 0.4,
			damage = 12, hitbox = box(14, 4, 7, -1), kbBase = 28, kbGrowth = 55, kbAngle = 65, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { -6, 30, 0, 0, -0.5, 0 }, Waist = { -10, 20, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 30 }, RE = { 50, 0, 0 }, LS = { 40, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { -10, 60, 0, 0, -0.9, -0.2 }, Waist = { -14, 20, 0 }, Neck = { 0, -40, 0 }, RS = { 60, 0, -20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -60 }, LE = { 20, 0, 0 } },
			follow = { Root = { -10, 75, 0, 0, -0.9, -0.25 }, Waist = { -14, 24, 0 }, Neck = { 0, -50, 0 }, RS = { 55, 0, -25 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 18, 0, -65 }, LE = { 20, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(210, 210, 210), dir = "up", at = "feet", time = 0.35, speed = 7 } }, text = "SKRRRT !", hitText = "DÉRAPÉ !",
		},
		-- Saut de rampe (↑L) : il cabre la trottinette, roule sur une rampe imaginaire et décolle en diagonale vers l'avant,
		-- roue avant en premier, corps couché sur le guidon et jambes qui traînent derrière
		S_up = {
			label = "Saut de rampe", startup = 0.1, active = 0.3, recovery = 0.4,
			damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 72, selfVelocity = Vector2.new(42, 80),
			windup = { Root = { -6, 0, 0, 0, -0.7, 0 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -5, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 8 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -8 }, LE = { 5, 0, 0 }, RH = { -25, 0, 5 }, RK = { -35, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
			follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -7, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 170, 0, 10 }, RE = { 5, 0, 0 }, RW = { -8, 0, 0 }, LS = { 165, 0, -10 }, LE = { 5, 0, 0 }, RH = { -30, 0, 6 }, RK = { -40, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
			trail = "prop", fx = { { "ring", color = ORANGE, radius = 5, at = "feet" }, { "burst", color = STAR, size = 3, at = "feet" }, { "particles", tex = "spark", color = ORANGE, dir = "down", at = "feet", time = 0.35, speed = 14 } }, text = "RAMPE !", hitText = "VROUM !",
		},
		-- Charge batterie (S maintenu) : la trottinette crépite au bout du bras, puis il la tend comme un taser : l'arc électrique court sur tout le couloir (turbo et une étoile de plus)
		S_hold = {
			label = "Charge batterie", startup = 0.3, active = 0.15, recovery = 0.45,
			hitbox = box(14, 5, 7, 0.8), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 14, selfEffect = { buff = { "turbo", 3 }, meter = 1 },
			windup = { Root = { 0, -10, 0, 0, -0.3, 0.1 }, Waist = { -6, -12, 0 }, Neck = { 10, 10, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 16, 0, 0, -0.3, -0.45 }, Waist = { -14, 20, 0 }, Neck = { 0, -14, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -35 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 20, 0, 0, -0.32, -0.5 }, Waist = { -16, 24, 0 }, Neck = { 0, -16, 0 }, RS = { 98, 0, -10 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -25, 0, -38 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			hold = 0.1, shake = true, trail = "prop", windupFx = { { "particles", tex = "spark", color = STAR, dir = "all", at = "hand", time = 0.4, speed = 6 } },
			fx = { { "burst", color = STAR, size = 3, at = "front" }, { "beam", color = SCREEN, length = 14, width = 2, at = "hand" }, { "particles", tex = "spark", color = SCREEN, dir = "all", at = "front", time = 0.3, speed = 10 }, { "text", text = "BATTERIE 100 % !", color = STAR } }, text = "BZZZT !", hitText = "TASÉ !",
		},
		-- Raccourci GPS (→→S) : « Recalcul de l'itinéraire… », il disparaît, réapparaît plus loin et fait un grand tour sur lui-même, sac cube tendu : tout ce qui est autour de lui est balayé
		S_dash = {
			label = "Raccourci GPS", startup = 0.15, active = 0.2, recovery = 0.4,
			hitbox = box(24, 6, 0, 0.8), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 13, teleport = 12, invuln = 0.25,
			windup = { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 15, 0 }, RS = { 30, 0, 30 }, RE = { 50, 0, 0 }, LS = { 150, 0, 30 }, LE = { 120, 0, 0 } },
			strike = { Root = { -10, -40, 0, 0, -0.3, -0.3 }, Waist = { -10, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 40, 0, 70 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 } },
			follow = { Root = { -10, -60, 0, 0, -0.3, -0.35 }, Waist = { -10, -40, 0 }, Neck = { 0, 40, 0 }, RS = { 42, 0, 75 }, RE = { 20, 0, 0 }, LS = { 42, 0, -75 }, LE = { 20, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", windupFx = { { "ring", color = SCREEN, radius = 3, at = "root" } },
			fx = { { "burst", color = SCREEN, size = 3, at = "root" }, { "text", text = "ITINÉRAIRE RECALCULÉ", color = SCREEN, at = "head" } },
			text = "RECALCUL DE L'ITINÉRAIRE…", hitText = "RACCOURCI !",
		},
		-- Colis express (S en l'air) : il lâche un colis qui fonce droit sur l'adversaire
		S_air = {
			label = "Colis express", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
			damage = 12, kbBase = 24, kbGrowth = 45, kbAngle = 40,
			projectile = { speed = 65, angle = -30, gravity = 0, lifetime = 0.8, size = 1.8, color = CARDBOARD, visual = PARCEL },
			windup = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 150, 0, -10 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -14, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 40, 0, 45 }, RE = { 60, 0, 0 }, LS = { 50, 0, -10 }, LE = { 5, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -12, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 45 }, RE = { 60, 0, 0 }, LS = { 40, 0, -12 }, LE = { 5, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			text = "ATTENTION, FRAGILE !", hitText = "BOING !",
		},
		-- Livraison parachutée (↓S en l'air, plongeon) : bien droit, il tombe en piqué sur l'adversaire comme un colis largué
		S_air_down = {
			label = "Livraison parachutée", startup = 0.15, active = 0.35, recovery = 0.4,
			damage = 13, hitbox = box(5, 5, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -90),
			windup = { Root = { 0, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, LS = { 170, 0, -30 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 175, 0, 15 }, RE = { 10, 0, 0 }, LS = { 175, 0, -15 }, LE = { 10, 0, 0 }, RH = { 0, 0, 4 }, RK = { 0, 0, 0 }, RA = { -15, 0, 0 }, LH = { 0, 0, -4 }, LK = { 0, 0, 0 }, LA = { -15, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 178, 0, 18 }, RE = { 10, 0, 0 }, LS = { 178, 0, -18 }, LE = { 10, 0, 0 }, RH = { 0, 0, 5 }, RK = { -4, 0, 0 }, RA = { -15, 0, 0 }, LH = { 0, 0, -5 }, LK = { -4, 0, 0 }, LA = { -15, 0, 0 } },
			trail = "body", fx = { { "ring", color = TEAL, radius = 4, at = "feet" } }, text = "COLIS LARGUÉ !", hitText = "BOUM !",
		},
		-- Saut de trottoir (finition d'enchaînement, anti-air) : il saute comme sur un trottoir, genou et casque en avant
		S_finish_trottoir = {
			label = "Saut de trottoir", startup = 0.1, active = 0.15, recovery = 0.3,
			damage = 9, hitbox = box(5, 5, 2.5, 2.5), kbBase = 32, kbGrowth = 58, kbAngle = 82, selfVelocity = Vector2.new(8, 45),
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 30 }, RE = { 40, 0, 0 }, LS = { -20, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.3, -0.1 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 20 }, RE = { 20, 0, 0 }, LS = { -30, 0, -40 }, LE = { 20, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, LH = { -10, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.35, -0.1 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 165, 0, 20 }, RE = { 20, 0, 0 }, LS = { -35, 0, -42 }, LE = { 20, 0, 0 }, RH = { 115, 0, 0 }, RK = { -125, 0, 0 }, LH = { -15, 0, 0 }, LK = { -25, 0, 0 } },
			trail = "rightLeg", text = "HOP, LE TROTTOIR !", hitText = "BOING !",
		},

		------------------------------------------------------------------ Supers
		-- Commande groupée (Y) : il valide sur son téléphone… et une pluie de colis tombe du ciel droit sur l'adversaire
		SUPER = {
			label = "Commande groupée !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.6,
			damage = 3, kbBase = 20, kbGrowth = 30, kbAngle = 60,
			projectile = { speed = 60, gravity = 0, lifetime = 0.8, size = 2, color = CARDBOARD, visual = PARCEL,
				rain = { count = 12, spread = 6, ahead = 9, height = 22, gap = 0.06 } },
			windup = { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { -6, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 50, 0, 20 }, LE = { 110, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 172, 0, -15 }, LE = { 10, 0, 0 } },
			hold = 0.3, prop = "telephone", windupFx = { { "screen", color = TEAL, alpha = 0.25 }, { "text", text = "COMMANDE VALIDÉE ✔", color = SCREEN } },
			fx = { { "symbols", symbols = { "📦", "📦", "⭐" }, count = 8, radius = 5, at = "above" }, { "shake", amount = 0.4 } },
			text = "COMMANDE GROUPÉE !", hitText = "LIVRÉ !",
		},
		-- Trottinette-javelot (→Y) : il plie la trottinette, la fait tournoyer au-dessus du casque et la lance à plat comme un
		-- javelot à roulettes : elle traverse tout le couloir en fauchant tout le monde, puis revient se ranger dans sa main
		SUPER_side = {
			label = "Trottinette-javelot !", kind = "projectile", startup = 0.38, active = 0, recovery = 0.65,
			damage = 25, kbBase = 46, kbGrowth = 96, kbAngle = 32,
			projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = TEAL_DARK, returns = true, pierce = true,
				visual = { shape = "block", size = 2.4, color = TEAL_DARK, spin = 12, parts = {
					{ "cyl", Vector3.new(0.2, 3, 0.2), Vector3.new(0, 0, 0), METAL },
					{ "cyl", Vector3.new(1.6, 0.16, 0.16), Vector3.new(0, 1.5, 0), BLACK },
					{ "cyl", Vector3.new(0.25, 0.7, 0.7), Vector3.new(0, -1.5, 0), BLACK },
					{ "cyl", Vector3.new(0.25, 0.7, 0.7), Vector3.new(0, -1.5, 2), BLACK },
				} } },
			status = { name = "slowed", duration = 2 },
			windup = { Root = { 6, -38, 0, 0, -0.3, 0.3 }, Waist = { 10, -42, 0 }, Neck = { 8, 26, 0 }, RS = { 178, 0, 28 }, RE = { 40, 0, 0 }, RW = { 0, 0, 90 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -16, 26, 0, 0, -0.34, -0.5 }, Waist = { -18, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -18, 30, 0, 0, -0.36, -0.55 }, Waist = { -22, 34, 0 }, Neck = { -8, -20, 0 }, RS = { 98, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { -35, 0, -44 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
			spin = { axis = "y", degrees = 360 }, hideProp = "trottinette", windupFx = { "super", { "symbols", symbols = { "🛴", "⭐" }, count = 6, radius = 3, color = STAR } },
			fx = { { "burst", color = TEAL, size = 3, at = "hand" }, { "ring", color = ORANGE, radius = 4, at = "front" }, { "particles", tex = "spark", color = ORANGE, dir = "front", at = "hand", time = 0.3, speed = 16 }, { "shake", amount = 0.3 } },
			text = "JAVELOT À ROULETTES !", hitText = "FAUCHÉ !",
		},
		-- Livraison express en orbite (↑Y) : une rampe de lancement sort du sol, il cabre à la verticale et décolle en vrille,
		-- roue avant au ciel : tout le couloir part en orbite avec lui comme un colis-fusée
		SUPER_up = {
			label = "Livraison express en orbite !", startup = 0.3, active = 0.45, recovery = 0.7,
			damage = 24, hitbox = box(16, 12, 8, 4), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -14, 0, 0, 0, -0.75, 0 }, Waist = { -22, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 55, 0, 12 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 55, 0, -12 }, LE = { 70, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.5, 0 }, Waist = { 14, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 185, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 182, 0, -10 }, LE = { 0, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 14, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 180, 0, 35 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 178, 0, -40 }, LE = { 5, 0, 0 }, RH = { 20, 0, 25 }, RK = { -30, 0, 0 }, LH = { 20, 0, -25 }, LK = { -30, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, selfVelocity = Vector2.new(0, 70), shake = true,
			windupFx = { "super", { "particles", tex = "spark", color = STAR, dir = "all", at = "feet", time = 0.25, speed = 8 } }, trail = "prop",
			fx = { { "pillar", color = ORANGE, height = 18, width = 3, at = "root" }, { "ring", color = ORANGE, radius = 6, at = "feet" }, { "particles", tex = "fire", color = STAR, dir = "down", at = "feet", time = 0.6, speed = 14 }, { "symbols", symbols = { "📦", "⭐", "🚀" }, count = 6, radius = 4, at = "above", color = STAR } },
			text = "LIVRÉ EN 2 MIN !", hitText = "COLIS EN ORBITE !",
		},
		-- Mode Turbo (↓Y) : il tape « livraison express » sur son casque, ses baskets s'enflamment et son coup de pied fumant traverse tout le couloir : vitesse et note en hausse
		SUPER_down = {
			label = "Mode Turbo !", startup = 0.35, active = 0.2, recovery = 0.6,
			hitbox = box(16, 5, 8, 0.8), kbBase = 45, kbGrowth = 90, kbAngle = 45,
			damage = 22, selfEffect = { buff = { "turbo", 5 }, meter = 2 },
			windup = { Root = { 0, 0, 0, 0, -0.5, 0 }, Waist = { -16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 150, 0, 30 }, LE = { 130, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.1, -0.2 }, Waist = { 12, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, -0.1, -0.25 }, Waist = { 14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -38, 0, 55 }, RE = { 20, 0, 0 }, LS = { -38, 0, -55 }, LE = { 20, 0, 0 }, RH = { 108, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			hold = 0.15, trail = "rightFoot", windupFx = { { "screen", color = ORANGE, alpha = 0.3 }, { "text", text = "LIVRAISON EXPRESS ✔", color = SCREEN } },
			fx = { { "particles", tex = "fire", color = ORANGE, dir = "front", at = "feet", time = 0.6, speed = 14 }, { "beam", color = ORANGE, length = 16, width = 3, at = "feet" }, { "burst", color = ORANGE, size = 4, at = "front" }, { "pillar", color = ORANGE, height = 10, width = 3 } },
			text = "MODE TURBO !", hitText = "CRAMÉ !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise de colis : il attrape l'adversaire comme un carton fragile… et lui tend le téléphone : « Signez ici ! »
		GRAB = {
			label = "Prise de colis", kind = "grab", startup = 0.08, active = 0.12, recovery = 0.32,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 0, 0, 0, 0, -0.25, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 60, 0, 50 }, RE = { 20, 0, 0 }, LS = { 60, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.35, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 75, 0, -18 }, RE = { 70, 0, 0 }, LS = { 75, 0, 18 }, LE = { 70, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.3, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 80, 0, -20 }, RE = { 75, 0, 0 }, LS = { 95, 0, 10 }, LE = { 40, 0, 0 } },
			prop = "telephone", text = "SIGNEZ ICI !", hitText = "COLIS PRIS EN CHARGE",
		},
		-- ✋ puis → : Livraison express, il court trois pas et lance l'adversaire comme un colis
		THROW_fwd = {
			label = "Livraison express", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.28,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 15,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 2.0, 1.2 }, { 0.3, 4.5, 0.2 } },
			windup = { Root = { -12, 0, 0, 0, -0.3, 0.2 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 80, 0, -15 }, RE = { 60, 0, 0 }, LS = { 80, 0, 15 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, -0.3 } },
			strike = { Root = { -18, 0, 0, 0, -0.35, -0.5 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, -5 }, RE = { 5, 0, 0 }, LS = { 100, 0, 5 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -20, 0, 0, 0, -0.38, -0.55 }, Waist = { -16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 105, 0, -8 }, RE = { 5, 0, 0 }, LS = { 105, 0, 8 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 5 } }, text = "LIVRAISON EXPRESS !", hitText = "ZIOUUU !",
		},
		-- ✋ puis ← : Retour colis, il fait passer l'adversaire par-dessus sa tête, direction l'entrepôt
		THROW_back = {
			label = "Retour colis", kind = "throw", back = true, startup = 0.38, active = 0.1, recovery = 0.36,
			damage = 10, kbBase = 35, kbGrowth = 66, kbAngle = 45,
			carry = { { 0, 2.4, 0.6 }, { 0.12, 1.2, 2.2 }, { 0.26, -0.4, 3.4 }, { 0.38, -2.6, 0.8 } },
			windup = { Root = { -8, 0, 0, 0, -0.55, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 70, 0, -20 }, RE = { 70, 0, 0 }, LS = { 70, 0, 20 }, LE = { 70, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.5, 0.35 }, Waist = { 25, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 195, 0, -10 }, RE = { 20, 0, 0 }, LS = { 195, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 36, 0, 0, 0, -0.55, 0.4 }, Waist = { 28, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 200, 0, -10 }, RE = { 20, 0, 0 }, LS = { 200, 0, 10 }, LE = { 20, 0, 0 } },
			text = "RETOUR À L'ENTREPÔT !", hitText = "BADABOUM !",
		},
		-- ✋ puis ↑ : Livraison par drone, il lance l'adversaire tout droit vers le ciel, bras tendus
		THROW_up = {
			label = "Livraison par drone", kind = "throw", startup = 0.28, active = 0.08, recovery = 0.32,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.4, 0.6 }, { 0.14, 1.8, -0.6 }, { 0.28, 0.8, 4.0 } },
			windup = { Root = { -8, 0, 0, 0, -0.75, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 45, 0, -15 }, RE = { 40, 0, 0 }, LS = { 45, 0, 15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.35, -0.1 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 180, 0, 20 }, RE = { 5, 0, 0 }, LS = { 180, 0, -20 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			fx = { { "symbols", symbols = { "🚁" }, count = 2, radius = 2, at = "above" } }, text = "PAR DRONE !", hitText = "ZWIIING !",
		},
		-- ✋ puis ↓ : Colis écrasé, il plaque l'adversaire au sol et lui écrase un colis sur la tête : « ENDOMMAGÉ »
		THROW_down = {
			label = "Colis écrasé", kind = "throw", startup = 0.38, active = 0.1, hold = 0.2, recovery = 0.32,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.4, 0.6 }, { 0.14, 1.8, 1.6 }, { 0.26, 1.6, -2.0 }, { 0.38, 1.0, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.8, -0.4 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 20, 0, 0 }, LS = { 75, 0, -5 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -20, 0, 0, 0, -0.85, -0.45 }, Waist = { -34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 20 }, RE = { 20, 0, 0 }, LS = { 60, 0, -5 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "colis", fx = { { "burst", color = CARDBOARD, size = 3 }, { "text", text = "ENDOMMAGÉ", color = Color3.fromRGB(230, 40, 40) } }, text = "OUPS…", hitText = "CRAC !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "retour_expediteur", label = "Retour à l'expéditeur", sequence = { "forward", "forward", "down" },
			-- emballé, scotché, étiquette « FRAGILE », chargé dans un camion qui part en trombe
			scene = {
				{ "fxAttacker", { "text", text = "ADRESSE INCONNUE !", color = SCREEN } },
				{ "wait", 0.4 },
				{ "color", CARDBOARD },
				{ "material", "Fabric" },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 1.6, pieces = {
					{ "Carton", "", "block", Vector3.new(3.4, 5.2, 2.6), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), CARDBOARD, "Fabric", { transparency = 0.2 } },
					{ "Scotch", "", "block", Vector3.new(3.5, 0.5, 2.7), Vector3.new(0, 0.8, 0), Vector3.new(0, 0, 0), TAPE },
					{ "Scotch2", "", "block", Vector3.new(0.5, 5.3, 2.7), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), TAPE },
					{ "Fragile", "", "block", Vector3.new(2, 0.9, 0.1), Vector3.new(0, -1.2, -1.35), Vector3.new(0, 0, 0), Color3.fromRGB(230, 40, 40) },
				} },
				{ "text", "FRAGILE" },
				{ "wait", 0.8 },
				{ "spawn", at = "target", offset = Vector3.new(5, 0.5, 0), life = 2.4, name = "Camion", pieces = {
					{ "Caisse", "", "block", Vector3.new(7, 6, 4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), WHITE },
					{ "Cabine", "", "block", Vector3.new(3, 4, 4), Vector3.new(5, -1, 0), Vector3.new(0, 0, 0), TEAL },
					{ "Pare", "", "block", Vector3.new(0.2, 1.6, 3.4), Vector3.new(6.55, 0, 0), Vector3.new(0, 0, 0), SCREEN, "Glass" },
					{ "RoueAv", "", "cyl", Vector3.new(4.2, 1.6, 1.6), Vector3.new(5, -3, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic", { axis = "z" } },
					{ "RoueAr", "", "cyl", Vector3.new(4.2, 1.6, 1.6), Vector3.new(-2, -3, 0), Vector3.new(0, 0, 0), BLACK, "SmoothPlastic", { axis = "z" } },
				} },
				{ "move", to = "above", offset = Vector3.new(0, -4, 0), time = 0.3 },
				{ "launch", Vector3.new(70, 0, 0), time = 0.9 },
				{ "fxAttacker", { "text", text = "BON VOYAGE !", color = Color3.fromRGB(255, 230, 120) } },
				{ "wait", 0.6 },
			},
		},
		{
			id = "livre_en_30_minutes", label = "Livré en 30 minutes", sequence = { "down", "back", "forward" },
			-- transformé en pizza 4 fromages et livré au public
			scene = {
				{ "text", "UNE 4 FROMAGES !" },
				{ "squash", 0.2 },
				{ "color", PIZZA },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.6, 0), life = 3, pieces = {
					{ "Boite", "", "block", Vector3.new(5, 0.4, 5), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), WHITE },
					{ "Pate", "", "cyl", Vector3.new(0.3, 4.4, 4.4), Vector3.new(0, 0.35, 0), Vector3.new(0, 0, 0), PIZZA, "SmoothPlastic", { axis = "y" } },
					{ "Tomate", "", "cyl", Vector3.new(0.32, 0.8, 0.8), Vector3.new(1, 0.4, 0.6), Vector3.new(0, 0, 0), Color3.fromRGB(200, 40, 30), "SmoothPlastic", { axis = "y" } },
					{ "Tomate2", "", "cyl", Vector3.new(0.32, 0.8, 0.8), Vector3.new(-0.9, 0.4, -0.7), Vector3.new(0, 0, 0), Color3.fromRGB(200, 40, 30), "SmoothPlastic", { axis = "y" } },
				} },
				{ "fx", { "particles", tex = "smoke", color = WHITE, dir = "up", at = "root", time = 1.2, speed = 4 } },
				{ "wait", 0.8 },
				{ "fxAttacker", { "text", text = "LIVRÉ EN 29 MIN 59 !", color = STAR } },
				{ "lift", 5, time = 0.4 },
				{ "spin", 720, axis = "y", time = 0.5 },
				{ "launch", Vector3.new(20, 50, 0), time = 0.9 },
				{ "fx", { "symbols", symbols = { "🍕", "⭐" }, count = 6, radius = 3 } },
				{ "wait", 0.4 },
			},
		},
		{
			id = "une_etoile", label = "1 étoile", sequence = { "up", "forward", "up" },
			-- une pluie d'avis « ★☆☆☆☆ » géants l'aplatit comme une crêpe
			scene = {
				{ "fxAttacker", { "text", text = "MAUVAIS AVIS…", color = Color3.fromRGB(255, 120, 120) } },
				{ "spawn", at = "above", offset = Vector3.new(0, 4, 0), life = 2.5, pieces = {
					{ "Etoile1", "", "ball", Vector3.new(2.4, 2.4, 0.6), Vector3.new(-4.8, 0, 0), Vector3.new(0, 0, 0), STAR, "Neon" },
					{ "Etoile2", "", "ball", Vector3.new(2.4, 2.4, 0.6), Vector3.new(-2.4, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(120, 120, 130) },
					{ "Etoile3", "", "ball", Vector3.new(2.4, 2.4, 0.6), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(120, 120, 130) },
					{ "Etoile4", "", "ball", Vector3.new(2.4, 2.4, 0.6), Vector3.new(2.4, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(120, 120, 130) },
					{ "Etoile5", "", "ball", Vector3.new(2.4, 2.4, 0.6), Vector3.new(4.8, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(120, 120, 130) },
				} },
				{ "text", "★☆☆☆☆" },
				{ "wait", 0.7 },
				{ "fx", { "rain", shape = "flat", color = STAR, count = 14, radius = 5, size = 1.4 } },
				{ "squash", 0.15 },
				{ "fx", { "shake", amount = 0.6 } },
				{ "text", "1 ÉTOILE. AUCUN POURBOIRE." },
				{ "wait", 1.2 },
			},
		},
	},

	-- Mécanique : note client 1 à 5 ⭐ (enchaîner la monte et le rend plus rapide, se faire toucher la baisse)
	passive = { kind = "rating", name = "Note client", icon = "⭐", max = 5, start = 1 },

	-- Recharge ⚡ : il consulte le téléphone sur son casque, valide une livraison (« ding, +1 pourboire »)
	-- et pique une frite dans le sac isotherme
	charge = {
		label = "Pause pourboire",
		loop = 1.8,
		lockWrist = false,
		color = SCREEN,
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 28, 10, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 150, 0, -15 }, LE = { 120, 0, 0 } } },
			{ 0.2, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 30, 12, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 158, 0, -18 }, LE = { 128, 0, 0 } } },
			{ 0.4, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 28, 10, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 150, 0, -15 }, LE = { 120, 0, 0 } } },
			{ 0.6, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 60, 0, -50 }, LE = { 20, 0, 0 } } },
			{ 0.9, { Root = { 0, -15, 0, 0, -0.15, 0 }, Waist = { 0, -25, 0 }, Neck = { 0, 40, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { -60, 0, -50 }, LE = { 110, 0, 0 } } },
			{ 1.2, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 120, 0, 25 }, LE = { 135, 0, 0 } } },
			{ 1.4, { Root = { 0, 0, 0, 0, -0.12, 0 }, Waist = { 4, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 125, 0, 25 }, LE = { 140, 0, 0 } } },
			{ 1.8, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 28, 10, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 150, 0, -15 }, LE = { 120, 0, 0 } } },
		},
		beats = {
			{ 0.2, { "text", text = "DING ! +1 POURBOIRE", color = STAR } },
			{ 0.25, { "symbols", symbols = { "⭐", "💶" }, count = 3, radius = 2.5, color = STAR } },
			{ 1.3, { "symbols", symbols = { "🍟", "MIAM" }, count = 2, radius = 1.5, color = Color3.fromRGB(240, 200, 60) } },
		},
	},

	-- Manies au repos : il consulte son téléphone, regarde sa montre, trottine sur place
	fidgets = {
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { 30, 12, 0 }, LS = { 150, 0, -15 }, LE = { 120, 0, 0 } } },
			{ 0.55, { Neck = { 32, 14, 0 }, LS = { 158, 0, -18 }, LE = { 128, 0, 0 } } },
			{ 0.8, { Neck = { 30, 12, 0 }, LS = { 150, 0, -15 }, LE = { 120, 0, 0 } } },
			{ 1.0, { Neck = { 32, 14, 0 }, LS = { 158, 0, -18 }, LE = { 128, 0, 0 } } },
			{ 1.6, {} },
		} },
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.35, { Neck = { -25, 20, 0 }, LS = { 80, 0, 30 }, LE = { 100, 0, 0 } } },
			{ 0.9, { Neck = { -28, 22, 0 }, LS = { 82, 0, 30 }, LE = { 105, 0, 0 } } },
			{ 1.1, { Neck = { 10, -20, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 } } },
			{ 1.6, {} },
		} },
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.2, { Root = { 0, 0, 0, 0, -0.05, 0 }, RS = { 40, 0, 15 }, RE = { 90, 0, 0 }, LS = { -10, 0, -15 }, LE = { 90, 0, 0 }, FR = { 1, 0, 0, 0.62, -2.35, 0.38 } } },
			{ 0.45, { Root = { 0, 0, 0, 0, -0.05, 0 }, RS = { -10, 0, 15 }, RE = { 90, 0, 0 }, LS = { 40, 0, -15 }, LE = { 90, 0, 0 }, FL = { 1, 0, 0, -0.58, -2.35, -0.32 } } },
			{ 0.7, { Root = { 0, 0, 0, 0, -0.05, 0 }, RS = { 40, 0, 15 }, RE = { 90, 0, 0 }, LS = { -10, 0, -15 }, LE = { 90, 0, 0 }, FR = { 1, 0, 0, 0.62, -2.35, 0.38 } } },
			{ 0.95, { Root = { 0, 0, 0, 0, -0.05, 0 }, RS = { -10, 0, 15 }, RE = { 90, 0, 0 }, LS = { 40, 0, -15 }, LE = { 90, 0, 0 }, FL = { 1, 0, 0, -0.58, -2.35, -0.32 } } },
			{ 1.2, { Root = { 0, 0, 0, 0, -0.05, 0 }, RS = { 40, 0, 15 }, RE = { 90, 0, 0 }, LS = { -10, 0, -15 }, LE = { 90, 0, 0 }, FR = { 1, 0, 0, 0.62, -2.35, 0.38 } } },
			{ 1.8, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : il le porte devant lui comme un carton fragile, un peu cambré,
-- et jette un œil au téléphone sur son casque
data.grabHold = {
	Root = { 6, 0, 0, 0, -0.2, 0.1 },
	Waist = { 8, 0, 0 },
	Neck = { 20, 10, 0 },
	RS = { 75, 0, -20 },
	RE = { 60, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 75, 0, 20 },
	LE = { 60, 0, 0 },
}

-- Retour 🪂 : il descend debout sur sa trottinette, posée sur un gros colis en parachute, sonne
-- (« Livraison ! ») et fait signer le vide sur son téléphone
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Colis", "base", "block", Vector3.new(5.5, 1.8, 4), Vector3.new(0, -0.9, 0), Vector3.zero, CARDBOARD },
		{ "Scotch", "", "block", Vector3.new(5.6, 0.4, 4.1), Vector3.new(0, -0.9, 0), Vector3.zero, TAPE },
		{ "Etiquette", "", "block", Vector3.new(1.4, 0.9, 0.1), Vector3.new(1.4, -0.9, -2.05), Vector3.zero, WHITE },
		{ "Plateau", "", "block", Vector3.new(3, 0.15, 0.6), Vector3.new(0, 0.08, 0), Vector3.zero, TEAL_DARK },
		{ "Colonne", "", "cyl", Vector3.new(3.4, 0.18, 0.18), Vector3.new(-1.6, 1.7, 0), Vector3.new(0, 0, -8), METAL, "Metal" },
		{ "Guidon", "", "cyl", Vector3.new(1.6, 0.15, 0.15), Vector3.new(-1.85, 3.4, 0), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "Parachute", "", "ball", Vector3.new(9, 3, 6), Vector3.new(0, 9.5, 0), Vector3.zero, TEAL, "Fabric" },
		{ "Bande", "", "ball", Vector3.new(3, 3.1, 6.1), Vector3.new(0, 9.55, 0), Vector3.zero, ORANGE, "Fabric" },
		{ "CordeG", "", "cyl", Vector3.new(8, 0.08, 0.08), Vector3.new(-3.2, 4.8, 0), Vector3.new(0, 0, 14), WHITE },
		{ "CordeD", "", "cyl", Vector3.new(8, 0.08, 0.08), Vector3.new(3.2, 4.8, 0), Vector3.new(0, 0, -14), WHITE },
	} },
	keys = {
		{ 0.0, { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 40, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 } } },
		{ 0.6, { Root = { -10, 0, 0, 0, -0.6, 0 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 40, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 } } },
		{ 0.8, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 90, 0, -20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -15 }, LE = { 60, 0, 0 } } },
		{ 0.95, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 95, 0, -20 }, RE = { 60, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -15 }, LE = { 60, 0, 0 } } },
		{ 1.2, { Root = { -4, 0, 0, 0, -0.15, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 95, 0, 0 }, LE = { 20, 0, 0 } } },
		{ 1.5, { Root = { -4, 0, 0, 0, -0.15, -0.1 }, Waist = { -6, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 70, 0, -10 }, RE = { 90, 0, 0 }, LS = { 95, 0, 0 }, LE = { 20, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.6, { "ring", color = TEAL, radius = 4, at = "feet" } },
		{ 0.85, { "text", text = "DRING DRING ! LIVRAISON !", color = STAR } },
		{ 1.3, { "text", text = "SIGNEZ ICI… ?", color = SCREEN } },
	},
}

-- Arbre d'enchaînements : rafales rapides (P P P), → P P P (béquille, guidon, sonnette), ↓ P P P (ticket, ticket sans fin,
-- frite dans l'œil), trottinette (K K K), → K K K (poussée, sac en toupie, javelot) et finitions S (pizza, saut de
-- trottoir qui fait décoller, rush pour poursuivre)
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	P_neutral = { P = "P_combo2", K = "PK_combo", up_P = "P_up", S = "S_neutral" }, -- P
	P_combo2 = { P = "P_combo3", K = "K_combo3", S = "S_finish_trottoir" }, -- P P
	P_combo3 = { S = "S_side" }, -- P P P (le rush poursuit)
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_trottoir" }, -- P K
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_neutral" }, -- K
	K_combo2 = { K = "K_combo3", P = "P_combo2", S = "S_finish_trottoir" }, -- K K
	K_combo3 = { S = "S_finish_trottoir" }, -- K K K (fait décoller)
	KP_combo = { P = "P_combo3", K = "K_combo2", S = "S_neutral" }, -- K P
	P_side = { P = "P_side2", K = "K_side2", S = "S_side" }, -- → P
	P_side2 = { P = "P_side3", K = "K_combo3", S = "S_finish_trottoir" }, -- → P P
	P_down = { P = "P_down2", K = "K_combo3", up_P = "P_up", S = "S_finish_trottoir" }, -- ↓ P
	P_down2 = { P = "P_down3", K = "K_combo2", S = "S_dodge" }, -- ↓ P P
	P_up = { P = "P_combo3", S = "S_finish_trottoir" }, -- ↑ P
	K_down = { P = "P_combo2", K = "K_combo3", S = "S_dodge" }, -- ↓ K
	K_side = { K = "K_side2", P = "KP_combo", S = "S_side" }, -- → K
	K_side2 = { K = "K_side3", P = "P_combo2", S = "S_finish_trottoir" }, -- → K K
	K_up = { P = "P_up", S = "S_finish_trottoir" }, -- ↑ K
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_neutral" }, -- dash P
	K_dash = { P = "P_up", S = "S_finish_trottoir" }, -- dash K
	S_dash = { P = "P_combo2", K = "K_combo2", S = "S_neutral" }, -- après le raccourci GPS, on enchaîne
	-- en l'air
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

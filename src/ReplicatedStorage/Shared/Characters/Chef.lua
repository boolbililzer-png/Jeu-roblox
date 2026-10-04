-- Chef Flambé : grand chef étoilé (enfin, presque), toque d'un mètre et moustache en guidon, qui se bat comme il
-- cuisine : avec panache, beaucoup de beurre et un peu trop de flammes. Arme sortie de la Caisse Bizarre :
-- la poêle (main droite) et le rouleau à pâtisserie (main gauche).
--
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
-- Mécanique « Cuisson » : les coups de feu (burn = true) laissent une brûlure cartoon (dégâts dans la durée).
-- Les ustensiles ponctuels (louche, fouet, couvercle, couteau à oignon, plateau, salière) sont des accessoires
-- cachés qui n'apparaissent que le temps du coup (prop = "…") ; la poêle se cache quand un autre ustensile
-- prend la main droite (hideProp = "poele").

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(240, 196, 160)
local WHITE = Color3.fromRGB(246, 244, 238)
local CREAM = Color3.fromRGB(236, 228, 210)
local BLACK = Color3.fromRGB(30, 26, 24)
local IRON = Color3.fromRGB(45, 45, 50)
local WOOD = Color3.fromRGB(196, 150, 96)
local SAUCE = Color3.fromRGB(190, 40, 30)
local FIRE = Color3.fromRGB(255, 120, 30)
local FLAME = Color3.fromRGB(255, 210, 70)
local CREPE = Color3.fromRGB(235, 190, 110)
local PASTA = Color3.fromRGB(245, 215, 120)
local OIL = Color3.fromRGB(230, 200, 60)
local SILVER = Color3.fromRGB(200, 205, 215)

local CRUST = Color3.fromRGB(200, 140, 70) -- baguette géante (arme n° 2)
local CRUMB = Color3.fromRGB(240, 220, 170)
local POT = Color3.fromRGB(60, 60, 68) -- marmite de soupe (arme n° 3)
local SOUP = Color3.fromRGB(230, 150, 60)
local MEATBALL = Color3.fromRGB(150, 90, 60)
local LOBSTER = Color3.fromRGB(220, 50, 40) -- homard du →Y
-- Croûton (projectiles de l'arme n° 2)
local CROUTON = { shape = "block", size = 1.0, color = CRUST, spin = 10, parts = {
	{ "block", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0, 0, 0), CRUMB },
	{ "block", Vector3.new(0.75, 0.15, 0.75), Vector3.new(0, 0.3, 0), CRUST },
} }

local data = {
	id = "Chef",
	name = "Chef Flambé",
	costume = "Chef",
	style = "proud",

	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la poêle et le rouleau (ses coups sont ceux de moves). n° 2 : la baguette géante, fleuret croustillant rapide et
	-- long. n° 3 : la marmite de soupe, lourde et lente, qui encaisse et nourrit son homme.
	weapons = {
		{ id = "poele", name = "Poêle & rouleau à pâtisserie", icon = "🍳",
			ability = { damage = 1.15, text = "Dégâts +15 % (tout est meilleur avec du beurre)" } },
		{ id = "baguette_geante", name = "Baguette géante", icon = "🥖",
			prop = { name = "PropBaguette", hand = "Right", pieces = {
				{ "Talon", "", "ball", Vector3.new(0.5, 0.6, 0.5), Vector3.new(0, 0.2, 0), Vector3.zero, CRUST, "Sand" },
				{ "Mie", "", "cyl", Vector3.new(3.8, 0.5, 0.5), Vector3.new(0, -1.8, 0), Vector3.zero, CRUST, "Sand" },
				{ "Grigne1", "", "block", Vector3.new(0.2, 0.5, 0.12), Vector3.new(0, -1.0, -0.22), Vector3.new(0, 0, 25), CRUMB, "Sand" },
				{ "Grigne2", "", "block", Vector3.new(0.2, 0.5, 0.12), Vector3.new(0, -1.8, -0.22), Vector3.new(0, 0, 25), CRUMB, "Sand" },
				{ "Grigne3", "", "block", Vector3.new(0.2, 0.5, 0.12), Vector3.new(0, -2.6, -0.22), Vector3.new(0, 0, 25), CRUMB, "Sand" },
				{ "Pointe", "", "ball", Vector3.new(0.45, 0.7, 0.45), Vector3.new(0, -3.85, 0), Vector3.zero, CRUST, "Sand" },
			} },
			ability = { reach = 1.25, text = "Portée +25 % (une baguette d'un mètre vingt)" },
			moves = {
				-- J : touche de baguette : fente d'escrime éclair, la pointe pique le ventre, main gauche en l'air comme un fleurettiste
				P_neutral = {
					label = "Touche de baguette", startup = 0.06, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(5.5, 2.5, 3.2, 0.6), kbBase = 18, kbGrowth = 24, kbAngle = 20,
					windup = { Root = { 2, 30, 0, 0, -0.15, 0.1 }, Waist = { 2, 34, 0 }, Neck = { 0, -26, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -50 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, 24, 0, 0, -0.25, -0.35 }, Waist = { -8, 28, 0 }, Neck = { 0, -20, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -10, 24, 0, 0, -0.26, -0.4 }, Waist = { -10, 28, 0 }, Neck = { 0, -20, 0 }, RS = { 98, 0, -6 }, RE = { 4, 0, 0 }, RW = { -8, 0, 0 }, LS = { 134, 0, -62 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					trail = "prop", text = "TOUCHÉ !", hitText = "PIC !",
				},
				-- →J : fente croustillante : grande fente en avant, la baguette tendue à l'horizontale jusqu'à l'autre bout de la cuisine
				P_side = {
					label = "Fente croustillante", startup = 0.09, active = 0.1, recovery = 0.2,
					damage = 8, hitbox = box(7, 2.5, 4, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 18, selfVelocity = Vector2.new(26, 0),
					windup = { Root = { 4, 34, 0, 0, -0.2, 0.2 }, Waist = { 4, 38, 0 }, Neck = { 0, -28, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -40 }, LE = { 70, 0, 0 } },
					strike = { Root = { -16, 26, 0, 0, -0.5, -0.6 }, Waist = { -12, 30, 0 }, Neck = { 0, -22, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.8 } },
					follow = { Root = { -18, 28, 0, 0, -0.52, -0.65 }, Waist = { -14, 32, 0 }, Neck = { 0, -24, 0 }, RS = { 96, 0, -8 }, RE = { 0, 0, 0 }, RW = { -6, 0, 0 }, LS = { 154, 0, -42 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.85 } },
					trail = "prop", fx = { "dust" }, text = "EN GARDE !", hitText = "EMBROCHÉ !",
				},
				-- ↓J : baguette aux chevilles : accroupi, un revers rasant du bout de la baguette dans les chevilles
				P_down = {
					label = "Baguette aux chevilles", startup = 0.08, active = 0.1, recovery = 0.18,
					damage = 6, hitbox = box(6.5, 1.8, 3.5, -2), kbBase = 22, kbGrowth = 24, kbAngle = 70,
					windup = { Root = { -6, 30, 0, 0, -0.75, 0.1 }, Waist = { -12, 34, 0 }, Neck = { 8, -24, 0 }, RS = { 50, 0, 40 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
					strike = { Root = { -12, -20, 0, 0, -0.85, -0.2 }, Waist = { -18, -24, 0 }, Neck = { 10, 16, 0 }, RS = { 20, 0, -20 }, RE = { 0, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -12, -30, 0, 0, -0.85, -0.24 }, Waist = { -18, -34, 0 }, Neck = { 10, 22, 0 }, RS = { 16, 0, -30 }, RE = { 0, 0, 0 }, RW = { 60, 0, 0 }, LS = { 44, 0, -42 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", hitText = "TCHAC !",
				},
				-- ↑J : baguette au ciel : d'un coup de poignet, la baguette remonte à la verticale et soulève sous le menton
				P_up = {
					label = "Baguette au ciel", startup = 0.08, active = 0.12, recovery = 0.2,
					damage = 7, hitbox = box(4.5, 6, 2, 3.5), kbBase = 26, kbGrowth = 34, kbAngle = 86,
					windup = { Root = { 4, 10, 0, 0, -0.4, 0.1 }, Waist = { 8, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 20, 0, 20 }, RE = { 40, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.15, -0.1 }, Waist = { -12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.18, -0.12 }, Waist = { -14, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 182, 0, 8 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 64, 0, -52 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.18, 0 }, FL = { 0, 0, 0, 0, 0.18, 0 } },
					trail = "prop", hitText = "HOP !",
				},
				-- J en l'air : pique aérienne : en l'air, il pointe la baguette en diagonale vers le bas, jambes en ciseaux
				P_air = {
					label = "Pique aérienne", startup = 0.08, active = 0.1, recovery = 0.16,
					damage = 7, hitbox = box(5.5, 3.5, 3, -1), kbBase = 22, kbGrowth = 34, kbAngle = -30,
					windup = { Root = { 6, 20, 0 }, Waist = { 8, 24, 0 }, Neck = { 0, -16, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					strike = { Root = { -14, 16, 0 }, Waist = { -16, 20, 0 }, Neck = { 8, -12, 0 }, RS = { 70, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { -20, 0, 0 }, RK = { -20, 0, 0 }, LH = { 50, 0, 0 }, LK = { -40, 0, 0 } },
					follow = { Root = { -16, 18, 0 }, Waist = { -18, 22, 0 }, Neck = { 10, -14, 0 }, RS = { 66, 0, -6 }, RE = { 4, 0, 0 }, RW = { -8, 0, 0 }, LS = { 154, 0, -42 }, LE = { 20, 0, 0 }, RH = { -24, 0, 0 }, RK = { -16, 0, 0 }, LH = { 54, 0, 0 }, LK = { -36, 0, 0 } },
					trail = "prop", hitText = "PIQUÉ !",
				},
				-- dash J : charge du boulanger : baguette sous le bras comme une lance, il fonce tête baissée
				P_dash = {
					label = "Charge du boulanger", startup = 0.07, active = 0.15, recovery = 0.24,
					damage = 8, hitbox = box(6.5, 3.5, 3.5, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 24, selfVelocity = Vector2.new(46, 0),
					windup = { Root = { -6, 20, 0, 0, -0.25, 0.1 }, Waist = { -4, 24, 0 }, Neck = { 6, -18, 0 }, RS = { 20, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -22, 20, 0, 0, -0.38, -0.3 }, Waist = { -10, 24, 0 }, Neck = { 12, -16, 0 }, RS = { 60, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 } },
					follow = { Root = { -24, 22, 0, 0, -0.4, -0.35 }, Waist = { -12, 26, 0 }, Neck = { 14, -18, 0 }, RS = { 62, 0, -12 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -34, 0, -42 }, LE = { 30, 0, 0 } },
					trail = "prop", fx = { "dust" }, text = "CHAUD LE PAIN !", hitText = "EMBROCHÉ !",
				},
				-- K : moulinet de baguette : grand moulinet de la baguette autour de lui, il tourne sur un sabot
				K_neutral = {
					label = "Moulinet de baguette", startup = 0.16, active = 0.16, recovery = 0.3,
					damage = 11, hitbox = box(7, 3.5, 2.5, 0.8), kbBase = 30, kbGrowth = 66, kbAngle = 32,
					windup = { Root = { 4, -40, 0, 0, -0.3, 0.2 }, Waist = { 6, -40, 0 }, Neck = { 0, 30, 0 }, RS = { 120, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, 0, 0, 0, -0.3, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 95, 0, 60 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
					follow = { Root = { -6, 0, 0, 0, -0.3, -0.22 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 92, 0, 65 }, RE = { 5, 0, 0 }, RW = { -8, 0, 0 }, LS = { 42, 0, -62 }, LE = { 30, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "VLAN !",
				},
				-- →K : baguette à deux mains : il la prend comme une batte et frappe un grand coup en avançant d'un pas chassé
				K_side = {
					label = "Baguette-batte", startup = 0.18, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(7, 3.5, 3.8, 0.8), kbBase = 32, kbGrowth = 74, kbAngle = 28, selfVelocity = Vector2.new(24, 0),
					windup = { Root = { 6, 44, 0, 0, -0.25, 0.25 }, Waist = { 8, 50, 0 }, Neck = { 4, -34, 0 }, RS = { 80, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 20 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, -26, 0, 0, -0.38, -0.45 }, Waist = { -14, -30, 0 }, Neck = { -6, 20, 0 }, RS = { 92, 0, -20 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -14, -40, 0, 0, -0.4, -0.5 }, Waist = { -16, -44, 0 }, Neck = { -8, 26, 0 }, RS = { 88, 0, -40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 88, 0, -60 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					trail = "prop", fx = { "dust", { "toss", shape = "ball", color = CRUMB, size = 0.3, count = 4, speed = 14 } }, hitText = "BAOUM !",
				},
				-- ↓K : baguette rasante : accroupi, il fait tourner la baguette au ras du carrelage comme une hélice
				K_down = {
					label = "Hélice de baguette", startup = 0.16, active = 0.16, recovery = 0.3,
					damage = 11, hitbox = box(8, 2, 0.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 72,
					windup = { Root = { -8, 30, 0, 0, -0.95, 0 }, Waist = { -20, 24, 0 }, Neck = { 10, -20, 0 }, RS = { 40, 0, 60 }, RE = { 20, 0, 0 }, RW = { 80, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -1.2, 0 }, Waist = { -24, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 30, 0, 85 }, RE = { 5, 0, 0 }, RW = { 80, 0, 0 }, LS = { 20, 0, -65 }, LE = { 20, 0, 0 } },
					follow = { Root = { -12, 0, 0, 0, -1.15, 0 }, Waist = { -22, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 32, 0, 82 }, RE = { 5, 0, 0 }, RW = { 80, 0, 0 }, LS = { 25, 0, -62 }, LE = { 20, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : baguette montante : il saute et remonte la baguette à deux mains comme un uppercut de pain
				K_up = {
					label = "Uppercut de pain", startup = 0.16, active = 0.12, recovery = 0.3,
					damage = 12, hitbox = box(5, 6, 2, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88, selfVelocity = Vector2.new(0, 26),
					windup = { Root = { -8, -10, 0, 0, -0.6, 0 }, Waist = { -20, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 10, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { 10, 5, 0, 0, 0.3, -0.2 }, Waist = { 14, 8, 0 }, Neck = { 24, 0, 0 }, RS = { 160, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, 10 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 }, LH = { 50, 0, 0 }, LK = { -100, 0, 0 } },
					follow = { Root = { 12, 8, 0, 0, 0.35, -0.25 }, Waist = { 16, 10, 0 }, Neck = { 28, 0, 0 }, RS = { 176, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 166, 0, 10 }, LE = { 15, 0, 0 }, LW = { 0, 0, 0 }, RH = { 65, 0, 0 }, RK = { -115, 0, 0 }, LH = { 55, 0, 0 }, LK = { -105, 0, 0 } },
					trail = "prop", hitText = "LEVÉE DE PAIN !",
				},
				-- K en l'air : baguette plongeante : il abat la baguette à deux mains vers le bas comme une hache de pain
				K_air = {
					label = "Hache de pain", startup = 0.14, active = 0.14, recovery = 0.24,
					damage = 12, hitbox = box(5.5, 4, 2.5, -1), kbBase = 30, kbGrowth = 66, kbAngle = -55,
					windup = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 190, 0, 12 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -12 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -20, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -24, 0, 0 }, Waist = { -36, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 36, 0, 6 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 36, 0, -6 }, LE = { 6, 0, 0 }, LW = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "TRANCHÉ !",
				},
				-- dash K : glissade en garde : il glisse sur un sabot en position d'escrime, la baguette pointée devant
				K_dash = {
					label = "Glissade en garde", startup = 0.1, active = 0.25, recovery = 0.3,
					damage = 11, hitbox = box(7, 3.5, 4, -0.3), kbBase = 30, kbGrowth = 62, kbAngle = 40, selfVelocity = Vector2.new(52, 0),
					windup = { Root = { -8, 30, 0, 0, -0.4, 0 }, Waist = { -10, 34, 0 }, Neck = { 6, -26, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -40 }, LE = { 60, 0, 0 }, RH = { -15, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 6, 26, 6, 0, -0.5, -0.2 }, Waist = { 4, 30, -6 }, Neck = { 0, -22, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { 8, 28, 8, 0, -0.5, -0.25 }, Waist = { 6, 32, -8 }, Neck = { 0, -24, 0 }, RS = { 96, 0, -8 }, RE = { 0, 0, 0 }, RW = { -6, 0, 0 }, LS = { 154, 0, -42 }, LE = { 20, 0, 0 }, RH = { 86, 0, 0 }, RK = { 0, 0, 0 }, RA = { 22, 0, 0 } },
					wobble = true, trail = "prop", fx = { "dust" }, text = "ALLEZ !", hitText = "TOUCHÉ !",
				},
				-- L : croûtons : il casse le bout de la baguette, trois croûtons partent en éventail sur l'adversaire
				S_neutral = {
					label = "Croûtons !", kind = "projectile", startup = 0.2, active = 0, recovery = 0.45,
					damage = 5, kbBase = 24, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.6, size = 1.2, color = CRUST, visual = CROUTON, fan = { count = 3, from = -8, to = 8 } },
					windup = { Root = { 6, -20, 0, 0, -0.2, 0.2 }, Waist = { 8, -26, 0 }, Neck = { 4, 16, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 0 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, 0 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 6 }, LE = { 6, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					fx = { { "burst", color = CRUMB, size = 2, at = "lhand" }, { "toss", shape = "ball", color = CRUMB, size = 0.3, count = 4, speed = 12 } }, text = "CROÛTONS !", hitText = "CROC !",
				},
				-- →L : la flèche de baguette : grande fente qui traverse tout le couloir, la baguette tendue comme une lance
				S_side = {
					label = "Flèche de baguette", startup = 0.22, active = 0.25, recovery = 0.5,
					damage = 15, hitbox = box(14, 4, 7, 0.6), kbBase = 32, kbGrowth = 62, kbAngle = 24, selfVelocity = Vector2.new(40, 0),
					windup = { Root = { 4, 36, 0, 0, -0.3, 0.3 }, Waist = { 4, 40, 0 }, Neck = { 0, -30, 0 }, RS = { 30, 0, 20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 70, 0, 0 } },
					strike = { Root = { -22, 28, 0, 0, -0.6, -0.7 }, Waist = { -14, 32, 0 }, Neck = { 0, -24, 0 }, RS = { 96, 0, -8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.9 } },
					follow = { Root = { -24, 30, 0, 0, -0.62, -0.75 }, Waist = { -16, 34, 0 }, Neck = { 0, -26, 0 }, RS = { 98, 0, -10 }, RE = { 0, 0, 0 }, RW = { -6, 0, 0 }, LS = { 164, 0, -42 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.95 } },
					trail = "prop", fx = { { "beam", color = CRUST, length = 14, width = 2, at = "hand" }, { "burst", color = CRUMB, size = 2.5, at = "front" }, { "particles", tex = "spark", color = CRUMB, dir = "front", at = "hand", time = 0.3, speed = 16 } },
					text = "FLÈCHE !", hitText = "TRANSPERCÉ !",
				},
				-- ↓L : miettes partout : il frotte la baguette entre ses mains, le nuage de miettes envahit tout le couloir et fait éternuer
				S_down = {
					label = "Miettes partout", startup = 0.2, active = 0.22, recovery = 0.45,
					damage = 12, hitbox = box(14, 5, 7, 0.8), kbBase = 18, kbGrowth = 30, kbAngle = 40,
					status = { name = "sneezy", duration = 2 },
					windup = { Root = { 4, 0, 0, 0, -0.25, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 70, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, -0.3, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 10 }, RE = { 60, 0, 0 }, RW = { 40, 0, 0 }, LS = { 90, 0, -10 }, LE = { 60, 0, 0 }, LW = { -40, 0, 0 } },
					follow = { Root = { -8, 0, 0, 0, -0.3, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 10 }, RE = { 70, 0, 0 }, RW = { -40, 0, 0 }, LS = { 90, 0, -10 }, LE = { 70, 0, 0 }, LW = { 40, 0, 0 } },
					wobble = true, shake = true, trail = "prop", fx = { { "beam", color = CRUMB, length = 14, width = 4, at = "head" }, { "particles", tex = "smoke", color = CRUMB, dir = "front", at = "hand", time = 0.4, speed = 14, size = 0.6, rate = 90 }, { "symbols", symbols = { "ATCHOUM", "🥖" }, count = 4, radius = 3, at = "front", color = CRUST } },
					text = "ET DES MIETTES !", hitText = "ATCHOUM !",
				},
				-- ↑L : remontée en fente : il plante la baguette au sol comme une perche et saute par-dessus en diagonale, jambes qui traînent
				S_up = {
					label = "Saut à la perche", startup = 0.12, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 74, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.7, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -30 }, LE = { 30, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 170, 0, 12 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -30, 0, -40 }, LE = { 20, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					trail = "prop", fx = { { "ring", color = CRUST, radius = 5, at = "feet" }, { "burst", color = CRUMB, size = 3, at = "feet" }, { "particles", tex = "spark", color = CRUMB, dir = "down", at = "feet", time = 0.35, speed = 14 } },
					text = "PERCHE !", hitText = "ENVOLÉ !",
				},
				-- L en l'air : baguette lâchée : il lance la baguette comme un javelot vers le bas, elle fonce sur l'adversaire
				S_air = {
					label = "Javelot de pain", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
					damage = 12, kbBase = 26, kbGrowth = 48, kbAngle = -40,
					projectile = { speed = 75, angle = -45, gravity = 15, lifetime = 0.8, size = 2, color = CRUST,
						visual = { shape = "cyl", size = 2.4, color = CRUST, spin = 4, parts = { { "ball", Vector3.new(0.5, 0.6, 0.5), Vector3.new(0, 1.3, 0), CRUST }, { "ball", Vector3.new(0.5, 0.6, 0.5), Vector3.new(0, -1.3, 0), CRUST } } } },
					windup = { Root = { 8, -20, 0 }, Waist = { 12, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 175, 0, 20 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -14, 16, 0 }, Waist = { -28, 20, 0 }, Neck = { 28, -12, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -30 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 18, 0 }, Waist = { -32, 22, 0 }, Neck = { 32, -14, 0 }, RS = { 34, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 26, 0, -32 }, LE = { 20, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					hideProp = "baguette", fx = { { "burst", color = CRUMB, size = 2, at = "hand" } }, text = "JAVELOT !", hitText = "PLANTÉ !",
				},
				-- Y : mille-feuilles de touches : rafale de cinq touches d'escrime si rapides qu'on ne voit plus la baguette, sur tout le couloir
				SUPER = {
					label = "Mille-feuilles de touches !", startup = 0.35, active = 0.5, recovery = 0.6,
					damage = 5, hits = 5, hitbox = box(16, 5, 8, 0.8), kbBase = 20, kbGrowth = 36, kbAngle = 30,
					windup = { Root = { 2, 36, 0, 0, -0.2, 0.15 }, Waist = { 2, 40, 0 }, Neck = { 0, -30, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -50 }, LE = { 50, 0, 0 } },
					strike = { Root = { -12, 26, 0, 0, -0.35, -0.5 }, Waist = { -10, 30, 0 }, Neck = { 0, -22, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					follow = { Root = { -12, 26, 0, 0, -0.35, -0.5 }, Waist = { -10, 30, 0 }, Neck = { 0, -22, 0 }, RS = { 70, 0, -6 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					wobble = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🥖", "⚔️" }, count = 4, radius = 3, color = CRUST } },
					fx = { { "beam", color = CRUMB, length = 16, width = 3, at = "hand" }, { "symbols", symbols = { "TOUCHÉ", "TOUCHÉ", "TOUCHÉ" }, count = 6, radius = 5, at = "front", color = CRUST }, { "shake", amount = 0.3 } },
					text = "MILLE-FEUILLES !", hitText = "PIC PIC PIC PIC PIC !",
				},
				-- →Y : la baguette-javelot : il tourne sur lui-même comme un lanceur de javelot et envoie la baguette traverser tout le couloir, elle revient en boomerang
				SUPER_side = {
					label = "Baguette-javelot !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 92, angle = 0, gravity = 0, lifetime = 0.9, size = 3.2, color = CRUST, pierce = true, returns = true,
						visual = { shape = "cyl", size = 3.6, color = CRUST, spin = 10, parts = { { "ball", Vector3.new(0.7, 0.9, 0.7), Vector3.new(0, 1.9, 0), CRUST }, { "ball", Vector3.new(0.7, 0.9, 0.7), Vector3.new(0, -1.9, 0), CRUST }, { "block", Vector3.new(0.3, 0.7, 0.2), Vector3.new(0, 0, -0.35), CRUMB } } } },
					windup = { Root = { 8, -40, 0, 0, -0.3, 0.3 }, Waist = { 12, -44, 0 }, Neck = { 8, 28, 0 }, RS = { 170, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -16, 26, 0, 0, -0.34, -0.5 }, Waist = { -18, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -18, 30, 0, 0, -0.36, -0.55 }, Waist = { -22, 34, 0 }, Neck = { -8, -20, 0 }, RS = { 98, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { -35, 0, -44 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					spin = { axis = "y", degrees = 360 }, hideProp = "baguette", windupFx = { "super", { "symbols", symbols = { "🥖", "✨" }, count = 6, radius = 3, color = CRUST } },
					fx = { { "burst", color = CRUMB, size = 3.5, at = "hand" }, { "ring", color = CRUST, radius = 4, at = "front" }, { "shake", amount = 0.4 } },
					text = "JAVELOT !", hitText = "EMBROCHÉ !",
				},
				-- ↑Y : la tour de pain : la baguette gonfle au four sous ses pieds en une tour de brioche qui l'élève avec tout le couloir
				SUPER_up = {
					label = "Tour de brioche !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.9, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -70 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 126, 0, -76 }, LE = { 10, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super", { "particles", tex = "smoke", color = CRUMB, dir = "up", at = "feet", time = 0.3, speed = 6 } },
					fx = { { "pillar", color = CRUST, height = 22, width = 3.5, at = "front" }, { "burst", color = CRUMB, size = 4, at = "above" }, { "ring", color = CRUST, radius = 6, at = "feet" }, { "symbols", symbols = { "🥐", "🥖", "🍞" }, count = 6, radius = 4, at = "above", color = CRUST } },
					text = "ÇA LÈVE !", hitText = "BRIOCHÉ !",
				},
				-- ↓Y : le pétrissage : il abat la baguette comme un rouleau et pétrit tout le couloir, l'adversaire finit en boule de pâte étourdie
				SUPER_down = {
					label = "Pétrissage !", startup = 0.35, active = 0.4, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 62,
					status = { name = "stunned", duration = 1.5 },
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 190, 0, 15 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -15 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.7, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -18, 0, 0, 0, -0.75, -0.44 }, Waist = { -34, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 40, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 40, 0, -12 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hold = 0.15, wobble = true, trail = "prop", windupFx = { "super" },
					fx = { { "beam", color = CRUMB, length = 16, width = 4, at = "feet" }, { "particles", tex = "smoke", color = CRUMB, dir = "all", at = "front", time = 0.5, speed = 12, size = 0.8 }, { "shake", amount = 0.5 }, { "symbols", symbols = { "🍞", "💫" }, count = 5, radius = 4, at = "front", color = CRUST } },
					text = "ON PÉTRIT !", hitText = "EN BOULE !",
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
		{ id = "marmite", name = "Marmite de soupe", icon = "🍲",
			prop = { name = "PropMarmite", hand = "Right", pieces = {
				{ "Anse", "", "cyl", Vector3.new(1.0, 0.16, 0.16), Vector3.new(0, -0.1, 0), Vector3.zero, BLACK, "Metal", { axis = "x" } },
				{ "Cuve", "", "cyl", Vector3.new(1.6, 1.9, 1.9), Vector3.new(0, -1.3, 0), Vector3.zero, POT, "Metal" },
				{ "Soupe", "", "cyl", Vector3.new(0.1, 1.7, 1.7), Vector3.new(0, -0.5, 0), Vector3.zero, SOUP, "SmoothPlastic" },
				{ "Poignee1", "", "block", Vector3.new(0.4, 0.2, 0.2), Vector3.new(1.05, -1.0, 0), Vector3.zero, BLACK, "Metal" },
				{ "Poignee2", "", "block", Vector3.new(0.4, 0.2, 0.2), Vector3.new(-1.05, -1.0, 0), Vector3.zero, BLACK, "Metal" },
				{ "Louche", "", "cyl", Vector3.new(1.4, 0.1, 0.1), Vector3.new(0.5, -0.1, 0.5), Vector3.new(0, 0, -30), SILVER, "Metal" },
			} },
			ability = { heal = 0.3, armor = true, text = "Les L encaissent ; 30 % des dégâts le nourrissent (soupe du jour)" },
			moves = {
				-- J : coup de marmite : il balance la lourde marmite à deux mains devant lui, lentement, en soufflant
				P_neutral = {
					label = "Coup de marmite", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 3.5, 2.8, 0.5), kbBase = 24, kbGrowth = 30, kbAngle = 28,
					windup = { Root = { 4, -16, 0, 0, -0.15, 0.15 }, Waist = { 6, -20, 0 }, Neck = { 8, 12, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 14, 0, 0, -0.28, -0.3 }, Waist = { -12, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 96, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 18, 0, 0, -0.3, -0.36 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 100, 0, 6 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -8 }, LE = { 14, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", text = "OUMPF !", hitText = "BONG !",
				},
				-- →J : louchée de soupe : il puise une louche de soupe bouillante et la lance au visage
				P_side = {
					label = "Louchée de soupe", startup = 0.1, active = 0.12, recovery = 0.22,
					damage = 8, hitbox = box(6, 3, 3.5, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 22,
					windup = { Root = { 4, -10, 0, 0, -0.15, 0.1 }, Waist = { 6, -12, 0 }, Neck = { 10, 8, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 }, LW = { 40, 0, 0 } },
					strike = { Root = { -8, 10, 0, 0, -0.25, -0.3 }, Waist = { -10, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -6 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -10, 12, 0, 0, -0.28, -0.34 }, Waist = { -12, 14, 0 }, Neck = { 0, -10, 0 }, RS = { 60, 0, 22 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 98, 0, -8 }, LE = { 4, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "leftHand", fx = { { "toss", shape = "ball", color = SOUP, size = 0.5, count = 3, speed = 16 } }, text = "UNE LOUCHE ?", hitText = "SPLASH !",
				},
				-- ↓J : accroupi, il pose la marmite de tout son poids sur les orteils de l'adversaire
				P_down = {
					label = "Marmite sur les orteils", startup = 0.12, active = 0.1, recovery = 0.26,
					damage = 8, hitbox = box(5, 2, 3, -1.8), kbBase = 26, kbGrowth = 30, kbAngle = 75,
					windup = { Root = { 8, 0, 0, 0, -0.5, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 140, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -15 }, LE = { 40, 0, 0 } },
					strike = { Root = { 16, 0, 0, 0, -0.95, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 18, 0, 0, 0, -0.95, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 36, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { "dust", { "toss", shape = "ball", color = SOUP, size = 0.4, count = 3, speed = 10, lift = 20 } }, hitText = "ÉCRASÉ !",
				},
				-- ↑J : couvercle qui saute : la vapeur fait sauter le couvercle, il remonte la marmite sous le menton
				P_up = {
					label = "Couvercle qui saute", startup = 0.1, active = 0.12, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 5.5, 1.5, 3.2), kbBase = 26, kbGrowth = 40, kbAngle = 86,
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 120, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, 0.1, -0.1 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 } },
					follow = { Root = { -12, 0, 0, 0, 0.12, -0.12 }, Waist = { -16, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 178, 0, 12 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 178, 0, -12 }, LE = { 10, 0, 0 } },
					trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "up", at = "hand", time = 0.3, speed = 14, size = 0.7, rate = 70 }, { "toss", shape = "cyl", color = SILVER, size = 1, count = 1, speed = 10, lift = 40 } }, text = "PSSSHT !", hitText = "ÉBOUILLANTÉ !",
				},
				-- J en l'air : marmite plongeante : il la serre contre lui et la pousse d'un coup sous ses sabots
				P_air = {
					label = "Marmite plongeante", startup = 0.1, active = 0.12, recovery = 0.18,
					damage = 9, hitbox = box(4.5, 4, 1.5, -1.4), kbBase = 22, kbGrowth = 38, kbAngle = -45,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -5 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 24, 0, 5 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 24, 0, -5 }, LE = { 6, 0, 0 }, RH = { 5, 0, 0 }, RK = { -25, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash J : « Chaud devant, la soupe ! », il court marmite à bout de bras et éclabousse tout sur son passage
				P_dash = {
					label = "Chaud devant, la soupe !", startup = 0.1, active = 0.16, recovery = 0.28,
					damage = 9, hitbox = box(5.5, 4, 3, 0.6), kbBase = 30, kbGrowth = 54, kbAngle = 24, selfVelocity = Vector2.new(38, 0),
					windup = { Root = { -8, 0, 0, 0, -0.3, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 15 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -15 }, LE = { 100, 0, 0 } },
					strike = { Root = { -24, 0, 0, 0, -0.42, -0.3 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 94, 0, 6 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -6 }, LE = { 6, 0, 0 } },
					follow = { Root = { -26, 0, 0, 0, -0.44, -0.35 }, Waist = { -16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 96, 0, 8 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 96, 0, -8 }, LE = { 6, 0, 0 } },
					trail = "prop", fx = { { "toss", shape = "ball", color = SOUP, size = 0.5, count = 4, speed = 14 } }, text = "CHAUD DEVANT !", hitText = "ÉCLABOUSSÉ !",
				},
				-- K : coup de pied au cul de marmite : il la pose et shoote dedans, elle part en roulant dans les tibias
				K_neutral = {
					label = "Shoot de marmite", startup = 0.2, active = 0.12, recovery = 0.34,
					damage = 13, hitbox = box(6, 3.5, 3.5, 0.2), kbBase = 32, kbGrowth = 74, kbAngle = 30,
					windup = { Root = { 8, -8, 0, 0, -0.3, 0.15 }, Waist = { 8, -6, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 }, RH = { -30, 0, 0 }, RK = { -70, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.15, 0.05 }, Waist = { 12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 30, 0, 0 }, RH = { 94, 0, 0 }, RK = { -4, 0, 0 }, RA = { 14, 0, 0 } },
					follow = { Root = { 14, 0, 0, 0, -0.15, 0.1 }, Waist = { 14, 0, 0 }, Neck = { -2, 0, 0 }, RS = { 22, 0, 52 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -54 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 } },
					trail = "rightFoot", fx = { { "toss", shape = "ball", color = SOUP, size = 0.5, count = 3, speed = 16 } }, text = "OUSTE !", hitText = "BONG !",
				},
				-- →K : marmite balancée : grand revers de la marmite tenue par une poignée, tout le corps tourne avec
				K_side = {
					label = "Marmite balancée", startup = 0.2, active = 0.14, recovery = 0.36,
					damage = 14, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 34, kbGrowth = 80, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 6, 44, 0, 0, -0.25, 0.2 }, Waist = { 8, 50, 0 }, Neck = { 4, -32, 0 }, RS = { 70, 0, 70 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 50, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 92, 0, -30 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -60 }, LE = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -44, 0, 0, -0.32, -0.4 }, Waist = { -12, -50, 0 }, Neck = { 0, 30, 0 }, RS = { 96, 0, -40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", fx = { { "toss", shape = "ball", color = SOUP, size = 0.5, count = 5, speed = 14 } }, hitText = "BAOUM !",
				},
				-- ↓K : soupe renversée : accroupi, il penche la marmite et balaie le sol d'une vague de soupe brûlante
				K_down = {
					label = "Soupe renversée", startup = 0.17, active = 0.14, recovery = 0.32,
					damage = 12, hitbox = box(7, 2, 3.5, -1.6), kbBase = 30, kbGrowth = 62, kbAngle = 70,
					windup = { Root = { 8, 0, 0, 0, -0.6, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.9, -0.2 }, Waist = { 24, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 100 }, LS = { 60, 0, -10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 16, 0, 0, 0, -0.9, -0.24 }, Waist = { 26, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 56, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 110 }, LS = { 56, 0, -12 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "puddle", color = SOUP, width = 6 }, { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "front", at = "feet", time = 0.25, speed = 8, size = 0.5 } }, hitText = "SPLOTCH !",
				},
				-- ↑K : marmite au plafond : il cabre la marmite d'un coup de genou, la louche part au ciel et la cuve soulève
				K_up = {
					label = "Marmite au plafond", startup = 0.18, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(4.5, 5.5, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88,
					windup = { Root = { 8, 0, 0, 0, -0.35, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.05, -0.1 }, Waist = { -18, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -10 }, LE = { 10, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.08, -0.12 }, Waist = { -20, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 166, 0, -12 }, LE = { 10, 0, 0 }, RH = { 116, 0, 0 }, RK = { -124, 0, 0 }, RA = { -20, 0, 0 } },
					trail = "prop", fx = { { "toss", shape = "cyl", color = SILVER, size = 0.8, count = 1, speed = 8, lift = 40 } }, hitText = "HOP LÀ !",
				},
				-- K en l'air : marmite-enclume : il abat la marmite sous lui comme une enclume en fonte, jambes repliées
				K_air = {
					label = "Marmite-enclume", startup = 0.16, active = 0.14, recovery = 0.26,
					damage = 13, hitbox = box(5, 4, 2, -1.2), kbBase = 30, kbGrowth = 70, kbAngle = -55,
					windup = { Root = { 12, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 190, 0, 12 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -12 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -20, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -6 }, LE = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -24, 0, 0 }, Waist = { -36, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, 6 }, RE = { 6, 0, 0 }, RW = { -20, 0, 0 }, LS = { 40, 0, -6 }, LE = { 6, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 25, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "BADABOUM !",
				},
				-- dash K : glissade sur bouillon : il glisse sur un sabot dans une traînée de soupe, la marmite comme balancier
				K_dash = {
					label = "Glissade sur bouillon", startup = 0.1, active = 0.26, recovery = 0.32,
					damage = 12, hitbox = box(6, 3.5, 3.5, -0.3), kbBase = 30, kbGrowth = 64, kbAngle = 48, selfVelocity = Vector2.new(50, 0),
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, RH = { -15, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 8, 0, 6, 0, -0.5, -0.2 }, Waist = { 6, 0, -6 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { 10, 0, 8, 0, -0.5, -0.25 }, Waist = { 8, 0, -8 }, Neck = { 0, 0, 0 }, RS = { 92, 0, 88 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -88 }, LE = { 10, 0, 0 }, RH = { 86, 0, 0 }, RK = { 0, 0, 0 }, RA = { 22, 0, 0 } },
					wobble = true, trail = "rightFoot", fx = { { "puddle", color = SOUP, width = 6 } }, text = "OUH LÀ LÀ !", hitText = "PATINÉ !",
				},
				-- L : boulettes ! : trois boulettes de viande piochées dans la soupe partent en éventail sur l'adversaire
				S_neutral = {
					label = "Boulettes !", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 5, kbBase = 24, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.6, size = 1.3, color = MEATBALL, fan = { count = 3, from = -8, to = 8 },
						visual = { shape = "ball", size = 1.1, color = MEATBALL, spin = 8, parts = { { "ball", Vector3.new(0.4, 0.2, 0.4), Vector3.new(0, 0.5, 0), SAUCE } } } },
					windup = { Root = { 6, -20, 0, 0, -0.2, 0.2 }, Waist = { 8, -26, 0 }, Neck = { 4, 16, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 0 }, LE = { 120, 0, 0 }, LW = { 40, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, 0 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 60, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 6 }, LE = { 6, 0, 0 }, LW = { -70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					fx = { { "burst", color = SOUP, size = 2, at = "lhand" } }, text = "BOULETTES !", hitText = "SPLOTCH !",
				},
				-- →L : vague de soupe : il renverse la marmite entière devant lui, une vague brûlante roule sur tout le couloir (brûle, il encaisse)
				S_side = {
					label = "Vague de soupe", startup = 0.26, active = 0.22, recovery = 0.55,
					damage = 15, burn = true, hitbox = box(14, 5, 7, 0.8), kbBase = 32, kbGrowth = 62, kbAngle = 30, armor = true,
					windup = { Root = { 10, -20, 0, 0, -0.3, 0.3 }, Waist = { 14, -24, 0 }, Neck = { 10, 16, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -18, 14, 0, 0, -0.4, -0.5 }, Waist = { -22, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 110 }, LS = { 96, 0, -4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 16, 0, 0, -0.44, -0.55 }, Waist = { -26, 20, 0 }, Neck = { -8, -12, 0 }, RS = { 104, 0, 2 }, RE = { 4, 0, 0 }, RW = { 0, 0, 120 }, LS = { 100, 0, -6 }, LE = { 4, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hold = 0.1, shake = true, trail = "prop", fx = { { "beam", color = SOUP, length = 14, width = 4, at = "feet" }, { "burst", color = SOUP, size = 3.5, at = "front" }, { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "front", at = "feet", time = 0.4, speed = 14 }, { "shake", amount = 0.3 } },
					text = "LA SOUPE EST SERVIE !", hitText = "ÉBOUILLANTÉ !",
				},
				-- ↓L : bouillon au sol : il penche la marmite au ras du carrelage, la nappe de bouillon gras couvre tout le couloir et tout le monde glisse
				S_down = {
					label = "Bouillon gras", startup = 0.22, active = 0.2, recovery = 0.5,
					damage = 12, hitbox = box(14, 4, 7, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 60,
					status = { name = "slippery", duration = 2.5 },
					windup = { Root = { 6, -10, 0, 0, -0.3, 0.1 }, Waist = { 10, -10, 0 }, Neck = { 14, 0, 0 }, RS = { 110, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -20 }, LE = { 30, 0, 0 } },
					strike = { Root = { -10, 8, 0, 0, -0.7, -0.25 }, Waist = { -16, 8, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, 15 }, RE = { 10, 0, 0 }, RW = { 0, 0, 100 }, LS = { 70, 0, -15 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 10, 0, 0, -0.72, -0.3 }, Waist = { -18, 10, 0 }, Neck = { -12, 0, 0 }, RS = { 60, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 110 }, LS = { 60, 0, -20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					hold = 0.1, trail = "prop", fx = { { "puddle", color = SOUP, width = 14 }, { "beam", color = SOUP, length = 14, width = 2.5, at = "feet" } }, text = "UN PEU DE GRAS…", hitText = "ÇA GLISSE !",
				},
				-- ↑L : vapeur ascensionnelle : il s'assied sur la marmite, la vapeur le propulse en diagonale comme une montgolfière de soupe
				S_up = {
					label = "Montgolfière de soupe", startup = 0.14, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 74, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 30, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 110, 0, 0 } },
					strike = { Root = { -38, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 40, 0, 5 }, RK = { -70, 0, 0 }, LH = { 30, 0, -5 }, LK = { -60, 0, 0 } },
					follow = { Root = { -42, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 156, 0, 44 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -44 }, LE = { 20, 0, 0 }, RH = { 44, 0, 6 }, RK = { -74, 0, 0 }, LH = { 34, 0, -6 }, LK = { -64, 0, 0 } },
					trail = "body", fx = { { "burst", color = SOUP, size = 3, at = "feet" }, { "ring", color = SOUP, radius = 5, at = "feet" }, { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "down", at = "feet", time = 0.4, speed = 16, size = 1, rate = 90 } },
					text = "PSSSHHH !", hitText = "ENVOLÉ !",
				},
				-- L en l'air : marmite lâchée : il lâche la marmite entière, qui tombe comme une enclume sur l'adversaire
				S_air = {
					label = "Marmite lâchée", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
					damage = 13, kbBase = 26, kbGrowth = 50, kbAngle = -45,
					projectile = { speed = 65, angle = -60, gravity = 40, lifetime = 0.8, size = 2.2, color = POT,
						visual = { shape = "cyl", size = 1.9, color = POT, spin = 2, parts = { { "cyl", Vector3.new(0.1, 1.7, 1.7), Vector3.new(0, 0.9, 0), SOUP }, { "block", Vector3.new(0.4, 0.2, 0.2), Vector3.new(1.05, 0.3, 0), BLACK }, { "block", Vector3.new(0.4, 0.2, 0.2), Vector3.new(-1.05, 0.3, 0), BLACK } } } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 175, 0, 15 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -15 }, LE = { 50, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 34, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 34, 0, -12 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					hideProp = "marmite", fx = { { "burst", color = SOUP, size = 2, at = "hand" } }, text = "ATTENTION LA MARMITE !", hitText = "ENCLUMÉ !",
				},
				-- Y : soupe du jour : il sert trois louches bouillantes d'affilée à tout le couloir et en reprend une pour lui
				SUPER = {
					label = "Soupe du jour !", startup = 0.4, active = 0.5, recovery = 0.7,
					damage = 8, hits = 3, burn = true, hitbox = box(16, 6, 8, 1), kbBase = 24, kbGrowth = 45, kbAngle = 38, selfEffect = { heal = 8 },
					windup = { Root = { 6, 0, 0, 0, -0.15, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 }, LW = { 40, 0, 0 } },
					strike = { Root = { -10, 10, 0, 0, -0.3, -0.35 }, Waist = { -12, 12, 0 }, Neck = { -4, -8, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -6 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -10, 0, 0, -0.3, -0.35 }, Waist = { -12, -12, 0 }, Neck = { -4, 8, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, 20 }, LE = { 0, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					wobble = true, trail = "leftHand", windupFx = { "super", { "symbols", symbols = { "🍲", "♨️" }, count = 4, radius = 3, color = SOUP } },
					fx = { { "beam", color = SOUP, length = 16, width = 4, at = "lhand" }, { "toss", shape = "ball", color = SOUP, size = 0.8, count = 9, speed = 22 }, { "symbols", symbols = { "🍲", "MIAM", "🍲" }, count = 6, radius = 5, at = "front", color = SOUP } },
					text = "SOUPE DU JOUR !", hitText = "SERVI BRÛLANT !",
				},
				-- →Y : la marmite-boulet : il fait tournoyer la marmite au bout de son anse et la lance comme un boulet de canon à travers tout le couloir
				SUPER_side = {
					label = "Marmite-boulet !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3.4, color = POT, pierce = true,
						visual = { shape = "cyl", size = 3, color = POT, spin = 8, parts = { { "cyl", Vector3.new(0.1, 2.6, 2.6), Vector3.new(0, 1.5, 0), SOUP }, { "block", Vector3.new(0.5, 0.3, 0.3), Vector3.new(1.6, 0.5, 0), BLACK }, { "block", Vector3.new(0.5, 0.3, 0.3), Vector3.new(-1.6, 0.5, 0), BLACK } } } },
					status = { name = "burning", duration = 2 },
					windup = { Root = { 8, -40, 0, 0, -0.3, 0.3 }, Waist = { 12, -44, 0 }, Neck = { 8, 28, 0 }, RS = { 170, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -16, 26, 0, 0, -0.34, -0.5 }, Waist = { -18, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -18, 30, 0, 0, -0.36, -0.55 }, Waist = { -22, 34, 0 }, Neck = { -8, -20, 0 }, RS = { 98, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { -35, 0, -44 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					spin = { axis = "y", degrees = 720 }, hideProp = "marmite", windupFx = { "super", { "symbols", symbols = { "🍲", "💫" }, count = 6, radius = 3, color = SOUP } },
					fx = { { "burst", color = SOUP, size = 3.5, at = "hand" }, { "ring", color = POT, radius = 4, at = "front" }, { "shake", amount = 0.4 } },
					text = "BOULET DE SOUPE !", hitText = "KA-BLONG !",
				},
				-- ↑Y : le geyser de bouillon : la marmite déborde sous ses pieds, un geyser de soupe le propulse et emporte tout le couloir au plafond
				SUPER_up = {
					label = "Geyser de bouillon !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, burn = true, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.9, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -6 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 188, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, trail = "prop", windupFx = { "super", { "particles", tex = "smoke", color = Color3.fromRGB(240, 240, 240), dir = "all", at = "hand", time = 0.3, speed = 6 } },
					fx = { { "pillar", color = SOUP, height = 22, width = 3, at = "front" }, { "beam", color = SOUP, length = 16, width = 5, at = "feet" }, { "burst", color = MEATBALL, size = 4, at = "above" }, { "ring", color = SOUP, radius = 6, at = "feet" } },
					text = "ÇA DÉBORDE !", hitText = "GEYSER !",
				},
				-- ↓Y : la marmite retournée : il retourne la marmite sur le couloir entier comme une cloche, tout le monde est enfermé dessous et ligoté par les spaghettis
				SUPER_down = {
					label = "Marmite retournée !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 22, hitbox = box(16, 5, 8, 0.5), kbBase = 40, kbGrowth = 85, kbAngle = 50,
					status = { name = "rooted", duration = 2 },
					windup = { Root = { 10, 0, 0, 0, -0.2, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 190, 0, 15 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -15 }, LE = { 50, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.7, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 0, 0, 0 }, RW = { 170, 0, 0 }, LS = { 60, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -18, 0, 0, 0, -0.75, -0.44 }, Waist = { -34, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 50, 0, 12 }, RE = { 0, 0, 0 }, RW = { 175, 0, 0 }, LS = { 50, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hold = 0.2, trail = "prop", windupFx = { "super" },
					fx = { { "burst", color = POT, size = 4.5, at = "front" }, { "beam", color = SOUP, length = 16, width = 4, at = "feet" }, { "rain", shape = "cyl", color = PASTA, count = 12, radius = 6, size = 1.2 }, { "shake", amount = 0.5 } },
					text = "SOUS CLOCHE !", hitText = "LIGOTÉ !",
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

	look = {
		body = {
			head = SKIN, upper = WHITE, lower = Color3.fromRGB(55, 55, 65), arms = WHITE, forearms = WHITE,
			hands = SKIN, legs = Color3.fromRGB(60, 60, 72), feet = BLACK,
		},
		cubeHead = 1.25,
		parts = {
			-- toque d'un mètre : bandeau, cheminée et champignon de tissu
			{ "ToqueBandeau", "Head", "cyl", Vector3.new(0.6, 1.36, 1.36), Vector3.new(0, 0.9, 0), Vector3.zero, WHITE, "Fabric" },
			{ "ToqueCheminee", "Head", "cyl", Vector3.new(2.4, 1.5, 1.5), Vector3.new(0, 2.3, 0), Vector3.zero, WHITE, "Fabric" },
			{ "ToqueChampignon", "Head", "ball", Vector3.new(2.2, 1.1, 2.2), Vector3.new(0, 3.55, 0), Vector3.zero, WHITE, "Fabric" },
			-- visage : yeux, gros nez, moustache en guidon recourbée
			{ "OeilG", "Head", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(-0.28, 0.2, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.18, 0.2, 0.1), Vector3.new(0.28, 0.2, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "Nez", "Head", "ball", Vector3.new(0.36, 0.34, 0.42), Vector3.new(0, -0.02, -0.72), Vector3.zero, Color3.fromRGB(235, 150, 130), "SmoothPlastic" },
			{ "MoustacheG", "Head", "block", Vector3.new(0.62, 0.18, 0.14), Vector3.new(-0.32, -0.24, -0.68), Vector3.new(0, 0, -14), BLACK, "Fabric" },
			{ "MoustacheD", "Head", "block", Vector3.new(0.62, 0.18, 0.14), Vector3.new(0.32, -0.24, -0.68), Vector3.new(0, 0, 14), BLACK, "Fabric" },
			{ "GuidonG", "Head", "ball", Vector3.new(0.22, 0.24, 0.16), Vector3.new(-0.66, -0.1, -0.68), Vector3.zero, BLACK, "Fabric" },
			{ "GuidonD", "Head", "ball", Vector3.new(0.22, 0.24, 0.16), Vector3.new(0.66, -0.1, -0.68), Vector3.zero, BLACK, "Fabric" },
			-- veste croisée de chef et foulard rouge
			{ "Foulard", "UpperTorso", "block", Vector3.new(1.1, 0.32, 0.5), Vector3.new(0, 0.72, -0.35), Vector3.zero, SAUCE, "Fabric" },
			{ "NoeudFoulard", "UpperTorso", "ball", Vector3.new(0.4, 0.4, 0.3), Vector3.new(0.18, 0.5, -0.56), Vector3.zero, SAUCE, "Fabric" },
			{ "BoutonHG", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(-0.36, 0.25, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "BoutonHD", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(0.36, 0.25, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "BoutonBG", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(-0.36, -0.3, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "BoutonBD", "UpperTorso", "ball", Vector3.new(0.16, 0.16, 0.08), Vector3.new(0.36, -0.3, -0.52), Vector3.zero, BLACK, "SmoothPlastic" },
			-- tablier taché de sauce et torchon à la ceinture
			{ "Tablier", "LowerTorso", "block", Vector3.new(1.9, 1.9, 0.1), Vector3.new(0, -0.65, -0.52), Vector3.zero, CREAM, "Fabric" },
			{ "TacheSauce", "LowerTorso", "ball", Vector3.new(0.55, 0.38, 0.05), Vector3.new(0.4, -0.35, -0.58), Vector3.new(0, 0, 20), SAUCE, "SmoothPlastic" },
			{ "TacheChocolat", "LowerTorso", "ball", Vector3.new(0.35, 0.3, 0.05), Vector3.new(-0.35, -1.05, -0.58), Vector3.zero, Color3.fromRGB(110, 60, 30), "SmoothPlastic" },
			{ "Torchon", "LowerTorso", "block", Vector3.new(0.12, 1.1, 0.6), Vector3.new(1.02, -0.45, 0), Vector3.zero, Color3.fromRGB(110, 160, 225), "Fabric" },
		},
		props = {
			-- l'arme de la caisse : la poêle en fonte (main droite)…
			{ name = "PropPoele", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.5, 0.24, 0.24), Vector3.new(0, -0.75, 0), Vector3.zero, BLACK, "Metal" },
				{ "Corps", "", "cyl", Vector3.new(0.22, 1.9, 1.9), Vector3.new(0, -2.3, 0), Vector3.zero, IRON, "Metal", { axis = "z", reflect = 0.1 } },
				{ "Rebord", "", "cyl", Vector3.new(0.12, 2.05, 2.05), Vector3.new(0, -2.3, 0.1), Vector3.zero, BLACK, "Metal", { axis = "z" } },
			} },
			-- … et le rouleau à pâtisserie (main gauche)
			{ name = "PropRouleau", hand = "Left", visible = true, pieces = {
				{ "Poignee", "", "cyl", Vector3.new(0.6, 0.2, 0.2), Vector3.new(0, -0.3, 0), Vector3.zero, Color3.fromRGB(160, 110, 60), "Wood" },
				{ "Rouleau", "", "cyl", Vector3.new(2.2, 0.55, 0.55), Vector3.new(0, -1.7, 0), Vector3.zero, WOOD, "Wood" },
				{ "Poignee2", "", "cyl", Vector3.new(0.6, 0.2, 0.2), Vector3.new(0, -3.1, 0), Vector3.zero, Color3.fromRGB(160, 110, 60), "Wood" },
			} },
			-- ustensiles ponctuels
			{ name = "PropLouche", hand = "Right", visible = false, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.8, 0.14, 0.14), Vector3.new(0, -0.9, 0), Vector3.zero, SILVER, "Metal" },
				{ "Cuilleron", "", "ball", Vector3.new(0.8, 0.5, 0.8), Vector3.new(0, -1.9, -0.25), Vector3.zero, SILVER, "Metal", { reflect = 0.2 } },
			} },
			{ name = "PropFouet", hand = "Right", visible = false, pieces = {
				{ "Manche", "", "cyl", Vector3.new(0.8, 0.2, 0.2), Vector3.new(0, -0.4, 0), Vector3.zero, BLACK, "SmoothPlastic" },
				{ "Fils", "", "ball", Vector3.new(0.7, 1.5, 0.7), Vector3.new(0, -1.4, 0), Vector3.zero, SILVER, "Metal", { transparency = 0.35 } },
			} },
			{ name = "PropCouvercle", hand = "Right", visible = false, pieces = {
				{ "Couvercle", "", "cyl", Vector3.new(0.15, 1.9, 1.9), Vector3.new(0, -0.35, 0), Vector3.zero, SILVER, "Metal", { axis = "z", reflect = 0.2 } },
				{ "Bouton", "", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, -0.35, 0.12), Vector3.zero, BLACK, "SmoothPlastic" },
			} },
			{ name = "PropOignon", hand = "Right", visible = false, pieces = {
				{ "Lame", "", "block", Vector3.new(0.06, 1.4, 0.4), Vector3.new(0, -1.0, -0.1), Vector3.zero, SILVER, "Metal", { reflect = 0.3 } },
				{ "Oignon", "", "ball", Vector3.new(0.7, 0.75, 0.7), Vector3.new(0, -1.9, 0), Vector3.zero, Color3.fromRGB(230, 200, 220), "SmoothPlastic" },
				{ "Tige", "", "cyl", Vector3.new(0.4, 0.1, 0.1), Vector3.new(0, -2.35, 0), Vector3.zero, Color3.fromRGB(110, 170, 70), "SmoothPlastic" },
			} },
			{ name = "PropPlateau", hand = "Right", visible = false, pieces = {
				{ "Plateau", "", "cyl", Vector3.new(0.1, 2.2, 2.2), Vector3.new(0, -0.3, -0.6), Vector3.new(90, 0, 0), SILVER, "Metal", { reflect = 0.3 } },
				{ "Cloche", "", "ball", Vector3.new(1.5, 1.0, 1.5), Vector3.new(0, 0.15, -0.6), Vector3.zero, SILVER, "Metal", { reflect = 0.3 } },
			} },
			{ name = "PropSaliere", hand = "Left", visible = false, pieces = {
				{ "Saliere", "", "cyl", Vector3.new(0.6, 0.35, 0.35), Vector3.new(0, -0.35, 0), Vector3.zero, WHITE, "Glass" },
				{ "Bouchon", "", "ball", Vector3.new(0.36, 0.2, 0.36), Vector3.new(0, -0.7, 0), Vector3.zero, SILVER, "Metal" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de louche : la poêle se range, une louche sort et tape sèchement sur le crâne, petit doigt levé
		P_neutral = {
			label = "Coup de louche", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 6, hitbox = box(4, 3, 2.6, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { 6, -10, 0, 0, -0.12, 0.15 }, Waist = { 10, -16, 0 }, Neck = { 8, 10, 0 }, RS = { 150, 0, 25 }, RE = { 70, 0, 0 }, RW = { -20, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.2 }, Waist = { -10, 14, 0 }, Neck = { -4, -6, 0 }, RS = { 95, 0, 5 }, RE = { 10, 0, 0 }, RW = { 10, 0, 0 }, LS = { 5, 0, -42 }, LE = { 88, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.22, -0.25 }, Waist = { -12, 18, 0 }, Neck = { -4, -8, 0 }, RS = { 75, 0, 5 }, RE = { 18, 0, 0 }, RW = { 25, 0, 0 }, LS = { 5, 0, -42 }, LE = { 88, 0, 0 } },
			prop = "louche", hideProp = "poele", trail = "rightHand", hitText = "TOC !",
		},
		-- Poêle frontale : il arme la poêle derrière l'épaule et l'écrase à plat devant lui en avançant d'un pas
		P_side = {
			label = "Poêle frontale", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 9, hitbox = box(5, 3.5, 3, 0.8), kbBase = 24, kbGrowth = 40, kbAngle = 22, selfVelocity = Vector2.new(22, 0),
			windup = { Root = { 8, -30, 0, 0, -0.2, 0.3 }, Waist = { 12, -30, 0 }, Neck = { 6, 22, 0 }, RS = { 120, 0, 70 }, RE = { 80, 0, 0 }, RW = { -30, 0, 0 }, LS = { 60, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -10, 18, 0, 0, -0.35, -0.45 }, Waist = { -12, 22, 0 }, Neck = { -6, -12, 0 }, RS = { 95, 0, -5 }, RE = { 5, 0, 0 }, RW = { -70, 0, 0 }, LS = { -20, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -12, 24, 0, 0, -0.38, -0.5 }, Waist = { -14, 28, 0 }, Neck = { -8, -14, 0 }, RS = { 92, 0, -15 }, RE = { 8, 0, 0 }, RW = { -80, 0, 0 }, LS = { -25, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "prop", fx = { { "ring", color = SILVER, radius = 3, at = "front" } }, hitText = "BLONNNG !",
		},
		-- Coup de tablier : il attrape le bas du tablier et le claque au ras des chevilles comme un torchon
		P_down = {
			label = "Coup de tablier", startup = 0.09, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(5, 2, 2.6, -2), kbBase = 24, kbGrowth = 22, kbAngle = 75,
			windup = { Root = { -10, -25, 0, 0, -0.65, 0.15 }, Waist = { -18, -20, 0 }, Neck = { 10, 15, 0 }, RS = { 40, 0, 30 }, RE = { 50, 0, 0 }, LS = { 20, 0, -55 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, 25, 0, 0, -0.8, -0.15 }, Waist = { -26, 25, 0 }, Neck = { 14, -15, 0 }, RS = { 30, 0, 45 }, RE = { 40, 0, 0 }, LS = { 45, 0, 25 }, LE = { 10, 0, 0 }, LW = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -16, 34, 0, 0, -0.82, -0.2 }, Waist = { -26, 32, 0 }, Neck = { 14, -18, 0 }, RS = { 25, 0, 48 }, RE = { 40, 0, 0 }, LS = { 40, 0, 40 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			trail = "leftHand", fx = { { "particles", tex = "smoke", color = CREAM, dir = "front", at = "feet", time = 0.2, speed = 6, size = 0.5 } }, hitText = "FLAC !",
		},
		-- Couvercle anti-air : il brandit un couvercle au-dessus de la toque comme un bouclier et le relève d'un coup sec
		P_up = {
			label = "Couvercle", startup = 0.08, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5.5, 5, 2.5, 3), kbBase = 26, kbGrowth = 32, kbAngle = 86,
			windup = { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.25, 0 }, Waist = { 14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 170, 0, 10 }, RE = { 20, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -45 }, LE = { 70, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.3, 0 }, Waist = { 16, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 178, 0, 8 }, RE = { 15, 0, 0 }, RW = { 90, 0, 0 }, LS = { 15, 0, -48 }, LE = { 75, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			prop = "couvercle", hideProp = "poele", fx = { { "ring", color = SILVER, radius = 3, at = "above" } }, hitText = "DONG !",
		},
		-- Coup de couvercle : en l'air, il plaque le couvercle devant lui comme une cymbale
		P_air = {
			label = "Coup de couvercle", startup = 0.08, active = 0.1, recovery = 0.16,
			damage = 7, hitbox = box(4.5, 4, 2.2, 0), kbBase = 22, kbGrowth = 32, kbAngle = 35,
			windup = { Root = { 8, -15, 0 }, Waist = { 10, -15, 0 }, RS = { 60, 0, 70 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -8, 12, 0 }, Waist = { -10, 16, 0 }, RS = { 95, 0, -10 }, RE = { 10, 0, 0 }, RW = { 90, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -10, 16, 0 }, Waist = { -12, 20, 0 }, RS = { 92, 0, -18 }, RE = { 12, 0, 0 }, RW = { 90, 0, 0 }, LS = { 25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 25, 0, 0 }, RK = { -45, 0, 0 }, LH = { 65, 0, 0 }, LK = { -100, 0, 0 } },
			prop = "couvercle", hideProp = "poele", hitText = "CLANG !",
		},
		-- Coup de fouet : ventre en avant, il fouette l'air en petits moulinets (suite de la louche)
		P_combo2 = {
			label = "Coup de fouet", startup = 0.06, active = 0.12, recovery = 0.16,
			damage = 3, hitbox = box(5, 3.5, 2.5, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 35, hits = 2,
			windup = { Root = { 4, 14, 0, 0, -0.15, 0.05 }, Waist = { 6, 18, 0 }, RS = { 70, 0, -20 }, RE = { 100, 0, 0 }, RW = { -30, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -8, -14, 0 }, RS = { 90, 0, 20 }, RE = { 40, 0, 0 }, RW = { 40, 0, 0 }, LS = { 8, 0, -42 }, LE = { 88, 0, 0 } },
			follow = { Root = { -6, -14, 0, 0, -0.2, -0.22 }, Waist = { -8, -18, 0 }, RS = { 85, 0, 30 }, RE = { 60, 0, 0 }, RW = { -40, 0, 0 }, LS = { 8, 0, -42 }, LE = { 88, 0, 0 } },
			wobble = true, prop = "fouet", hideProp = "poele", trail = "rightHand", hitText = "TCHIK TCHIK !",
		},
		-- Poêle sur la tête : la poêle revient, levée à deux mains, et s'abat sur le crâne (fin de la série)
		P_combo3 = {
			label = "Poêle sur la tête", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 2.5, 1), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 10, -8, 0, 0, 0, 0.25 }, Waist = { 16, -10, 0 }, Neck = { 14, 0, 0 }, RS = { 195, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -15 }, LE = { 70, 0, 0 } },
			strike = { Root = { -14, 8, 0, 0, -0.45, -0.4 }, Waist = { -28, 10, 0 }, Neck = { -10, 0, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 70, 0, -10 }, LE = { 30, 0, 0 } },
			follow = { Root = { -18, 10, 0, 0, -0.55, -0.45 }, Waist = { -34, 12, 0 }, Neck = { -12, 0, 0 }, RS = { 55, 0, 0 }, RE = { 0, 0, 0 }, RW = { -75, 0, 0 }, LS = { 50, 0, -15 }, LE = { 35, 0, 0 } },
			trail = "prop", fx = { { "ring", color = SILVER, radius = 4, at = "front" }, { "shake", amount = 0.3 } }, text = "À TABLE !", hitText = "BOIIING !",
		},
		-- Service en salle (dash puis P) : il fonce poêle tendue devant comme s'il apportait un plat brûlant
		P_dash = {
			label = "Poêle en avant", startup = 0.08, active = 0.15, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 3.5, 2.6, 0.6), kbBase = 28, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -6, -15, 0, 0, -0.25, 0.1 }, Waist = { -4, -10, 0 }, RS = { 40, 0, 25 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			strike = { Root = { -20, 10, 0, 0, -0.38, -0.3 }, Waist = { -8, 10, 0 }, Neck = { 10, 0, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { -85, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } },
			follow = { Root = { -22, 12, 0, 0, -0.4, -0.35 }, Waist = { -10, 12, 0 }, Neck = { 12, 0, 0 }, RS = { 97, 0, -5 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { -35, 0, -42 }, LE = { 40, 0, 0 } },
			trail = "prop", fx = { "dust" }, text = "CHAUD DEVANT !", hitText = "BLANG !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Sabot de cuisine : torse bombé, poings sur les hanches, il monte le genou et détend le sabot en pleine face
		K_neutral = {
			label = "Sabot de cuisine", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, 0.2), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { 10, -10, 0, 0, -0.12, 0.2 }, Waist = { 14, -6, 0 }, Neck = { 10, 0, 0 }, RS = { 15, 0, 45 }, RE = { 95, 0, 0 }, LS = { 15, 0, -45 }, LE = { 95, 0, 0 }, RH = { 90, 0, 0 }, RK = { -115, 0, 0 }, RA = { -10, 0, 0 } },
			strike = { Root = { 18, -4, 0, 0, -0.1, 0.05 }, Waist = { 16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 20, 0, 50 }, RE = { 90, 0, 0 }, LS = { 20, 0, -50 }, LE = { 90, 0, 0 }, RH = { 98, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 20, -2, 0, 0, -0.1, 0.1 }, Waist = { 18, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 22, 0, 52 }, RE = { 88, 0, 0 }, LS = { 22, 0, -52 }, LE = { 88, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 } },
			trail = "rightFoot", text = "OUSTE !", hitText = "CLOC !",
		},
		-- Rouleau à pâtisserie : grand revers du rouleau tenu à gauche, il pivote et avance d'un pas chassé
		K_side = {
			label = "Rouleau à pâtisserie", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 13, hitbox = box(5.5, 3.5, 3.2, 0.8), kbBase = 32, kbGrowth = 82, kbAngle = 28, selfVelocity = Vector2.new(32, 0),
			windup = { Root = { 6, 35, 0, 0, -0.25, 0.25 }, Waist = { 8, 30, 0 }, Neck = { 4, -30, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, LS = { 90, 0, -100 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, -25, 0, 0, -0.38, -0.45 }, Waist = { -14, -30, 0 }, Neck = { -6, 20, 0 }, RS = { 10, 0, 45 }, RE = { 60, 0, 0 }, LS = { 92, 0, 15 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, -38, 0, 0, -0.4, -0.5 }, Waist = { -16, -42, 0 }, Neck = { -8, 26, 0 }, RS = { 5, 0, 50 }, RE = { 60, 0, 0 }, LS = { 85, 0, 40 }, LE = { 10, 0, 0 }, LW = { -15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "leftHand", fx = { "dust" }, hitText = "BAOUM !",
		},
		-- Balayage au rouleau : accroupi, il fait rouler le rouleau au ras du carrelage en tournant sur lui-même
		K_down = {
			label = "Balayage au rouleau", startup = 0.17, active = 0.16, recovery = 0.32,
			damage = 11, hitbox = box(8, 2, 0.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 72,
			windup = { Root = { -8, 25, 0, 0, -0.95, 0 }, Waist = { -20, 20, 0 }, Neck = { 10, -20, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -80 }, LE = { 20, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -1.2, 0 }, Waist = { -24, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 65 }, RE = { 20, 0, 0 }, LS = { 30, 0, -85 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -1.15, 0 }, Waist = { -22, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 25, 0, 62 }, RE = { 20, 0, 0 }, LS = { 35, 0, -82 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "leftHand", fx = { "dust" }, hitText = "ROULÉ !",
		},
		-- Retourné de crêpe : il glisse la poêle sous l'adversaire, ploie les genoux et le fait sauter comme une crêpe
		K_up = {
			label = "Retourné de crêpe", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 5, 2, 2.5), kbBase = 34, kbGrowth = 72, kbAngle = 88,
			windup = { Root = { -12, -10, 0, 0, -0.85, 0 }, Waist = { -26, -10, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 20 }, RE = { 20, 0, 0 }, RW = { -80, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 5, 0, 0, 0.35, -0.1 }, Waist = { 16, 5, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 15 }, RE = { 10, 0, 0 }, RW = { -90, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 8, 8, 0, 0, 0.4, -0.12 }, Waist = { 20, 8, 0 }, Neck = { 36, 0, 0 }, RS = { 172, 0, 10 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 25, 0, -65 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			trail = "prop", text = "HOP LA CRÊPE !", hitText = "FLIP !",
		},
		-- Petit retourné (dans un enchaînement) : version éclair du retourné de crêpe, poêle glissée sous l'adversaire et coup de poignet qui l'envoie au plafond
		K_flip = {
			label = "Petit retourné", startup = 0.09, active = 0.12, recovery = 0.26,
			damage = 9, hitbox = box(5.5, 5, 2.5, 2.5), kbBase = 30, kbGrowth = 55, kbAngle = 88,
			windup = { Root = { -10, -10, 0, 0, -0.6, 0 }, Waist = { -20, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 20, 0, 0 }, RW = { -80, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 5, 0, 0, 0.25, -0.1 }, Waist = { 16, 5, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 15 }, RE = { 10, 0, 0 }, RW = { -90, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, 8, 0, 0, 0.3, -0.12 }, Waist = { 20, 8, 0 }, Neck = { 36, 0, 0 }, RS = { 172, 0, 10 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 25, 0, -65 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			trail = "prop", fx = { { "toss", shape = "flat", color = CREPE, size = 1, count = 1, speed = 10, lift = 30 } }, text = "HOP !", hitText = "FLIP !",
		},
		-- Coup de toque : en l'air, il rentre le menton et fonce toque en avant comme un bélier
		K_air = {
			label = "Coup de toque", startup = 0.16, active = 0.14, recovery = 0.26,
			damage = 11, hitbox = box(4.5, 4, 2.5, 1.2), kbBase = 30, kbGrowth = 68, kbAngle = 38,
			windup = { Root = { 15, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -30, 0, 40 }, RE = { 40, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -30, 0, 0 }, Waist = { -25, 0, 0 }, Neck = { -30, 0, 0 }, RS = { -50, 0, 30 }, RE = { 10, 0, 0 }, LS = { -50, 0, -30 }, LE = { 10, 0, 0 }, RH = { -10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 0, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -34, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -34, 0, 0 }, RS = { -55, 0, 32 }, RE = { 10, 0, 0 }, LS = { -55, 0, -32 }, LE = { 10, 0, 0 }, RH = { -15, 0, 0 }, RK = { -35, 0, 0 }, LH = { -5, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "head", hitText = "TOQUÉ !",
		},
		-- Revers de rouleau : le rouleau revient dans l'autre sens, en coup droit (suite de K)
		K_combo2 = {
			label = "Revers de rouleau", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 3, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 4, -30, 0, 0, -0.2, 0.1 }, Waist = { 6, -30, 0 }, Neck = { 0, 25, 0 }, RS = { 20, 0, 40 }, RE = { 80, 0, 0 }, LS = { 95, 0, 30 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, 25, 0, 0, -0.3, -0.3 }, Waist = { -10, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 25, 0, 40 }, RE = { 80, 0, 0 }, LS = { 92, 0, -60 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -10, 32, 0, 0, -0.32, -0.35 }, Waist = { -12, 38, 0 }, Neck = { 0, -24, 0 }, RS = { 25, 0, 42 }, RE = { 80, 0, 0 }, LS = { 85, 0, -85 }, LE = { 10, 0, 0 }, LW = { -15, 0, 0 } },
			trail = "leftHand", hitText = "VLAM !",
		},
		-- K K K : Pirouette du chef étoilé, il tourne sur un sabot bras en « voilà » et le talon fouette en passant (il décolle un peu)
		K_combo3 = {
			label = "Pirouette du chef étoilé", startup = 0.1, active = 0.16, recovery = 0.3,
			damage = 12, hitbox = box(6, 4, 2.5, 1), kbBase = 32, kbGrowth = 80, kbAngle = 40, selfVelocity = Vector2.new(12, 36),
			windup = { Root = { -6, -40, 0, 0, -0.45, 0.1 }, Waist = { -10, -30, 0 }, Neck = { 6, 30, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 70 }, RE = { 10, 0, 0 }, LS = { 150, 0, -70 }, LE = { 10, 0, 0 }, RH = { 85, 0, 40 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 10, 0, -10 }, LK = { -60, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 160, 0, 75 }, RE = { 10, 0, 0 }, LS = { 160, 0, -75 }, LE = { 10, 0, 0 }, RH = { 90, 0, 45 }, RK = { -5, 0, 0 }, RA = { 18, 0, 0 }, LH = { 15, 0, -10 }, LK = { -65, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", fx = { { "symbols", symbols = { "⭐", "✨" }, count = 4, radius = 3, at = "head", color = FLAME } }, text = "VOILÀÀÀ !", hitText = "BAM !",
		},
		-- Patinage sur l'huile (dash puis K) : il glisse debout sur un sabot comme sur une flaque d'huile, l'autre sabot tendu devant, bras en balancier
		K_dash = {
			label = "Patinage sur l'huile", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 3.5, 3.5, -0.3), kbBase = 30, kbGrowth = 62, kbAngle = 50, selfVelocity = Vector2.new(52, 0),
			windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, RH = { -15, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { 8, 0, 6, 0, -0.5, -0.2 }, Waist = { 6, 0, -6 }, Neck = { 0, 0, 0 }, RS = { 90, 0, 85 }, RE = { 10, 0, 0 }, LS = { 90, 0, -85 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 10, 0, 8, 0, -0.5, -0.25 }, Waist = { 8, 0, -8 }, Neck = { 0, 0, 0 }, RS = { 92, 0, 88 }, RE = { 10, 0, 0 }, LS = { 92, 0, -88 }, LE = { 10, 0, 0 }, RH = { 86, 0, 0 }, RK = { 0, 0, 0 }, RA = { 22, 0, 0 } },
			wobble = true, trail = "rightFoot", fx = { { "puddle", color = OIL, width = 6 } }, text = "OUH LÀ LÀ !", hitText = "PATINÉ !",
		},
		-- P puis K : Coup de sabot dans le tibia, sec et vexant
		PK_combo = {
			label = "Sabot dans le tibia", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 3, -0.5), kbBase = 22, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { 6, -10, 0, 0, -0.18, 0.15 }, Waist = { 8, -10, 0 }, Neck = { 6, 10, 0 }, RS = { 20, 0, 40 }, RE = { 90, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 }, RH = { -20, 0, 6 }, RK = { -70, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.28, -0.2 }, Waist = { -6, 8, 0 }, Neck = { 0, -6, 0 }, RS = { 25, 0, 45 }, RE = { 85, 0, 0 }, LS = { 15, 0, -45 }, LE = { 85, 0, 0 }, RH = { 60, 0, 4 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.3, -0.25 }, Waist = { -8, 10, 0 }, Neck = { 0, -8, 0 }, RS = { 25, 0, 45 }, RE = { 85, 0, 0 }, LS = { 15, 0, -45 }, LE = { 85, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { -22, 0, 0 } },
			trail = "rightFoot", hitText = "TAC !",
		},
		-- K puis P : Coup de manche, il retourne la poêle et enfonce le manche dans l'estomac
		KP_combo = {
			label = "Coup de manche", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 2.5, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, -20, 0, 0, -0.18, 0.15 }, Waist = { 4, -24, 0 }, RS = { 30, 0, 50 }, RE = { 120, 0, 0 }, RW = { 80, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -8, 18, 0, 0, -0.28, -0.35 }, Waist = { -12, 24, 0 }, RS = { 85, 0, -5 }, RE = { 30, 0, 0 }, RW = { 100, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 } },
			follow = { Root = { -10, 22, 0, 0, -0.3, -0.4 }, Waist = { -14, 28, 0 }, RS = { 88, 0, -10 }, RE = { 25, 0, 0 }, RW = { 100, 0, 0 }, LS = { 18, 0, -42 }, LE = { 90, 0, 0 } },
			hitText = "OUF !",
		},

		-- → P P : Revers de poêle, la poêle revient à plat dans l'autre sens, comme pour retourner une omelette
		P_side2 = {
			label = "Revers de poêle", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 7, hitbox = box(5.5, 3.5, 3, 0.8), kbBase = 20, kbGrowth = 30, kbAngle = 22, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { -8, 30, 0, 0, -0.3, -0.25 }, Waist = { -10, 34, 0 }, Neck = { -4, -22, 0 }, RS = { 85, 0, -45 }, RE = { 60, 0, 0 }, RW = { -70, 0, 0 }, LS = { -20, 0, -40 }, LE = { 50, 0, 0 } },
			strike = { Root = { -12, -18, 0, 0, -0.34, -0.45 }, Waist = { -14, -26, 0 }, Neck = { -6, 14, 0 }, RS = { 95, 0, 35 }, RE = { 5, 0, 0 }, RW = { -80, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, -26, 0, 0, -0.34, -0.5 }, Waist = { -14, -34, 0 }, Neck = { -6, 18, 0 }, RS = { 88, 0, 55 }, RE = { 10, 0, 0 }, RW = { -85, 0, 0 }, LS = { 35, 0, -30 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", hitText = "BLANG !",
		},
		-- → P P P : Gong de cuisine, la poêle frappée à deux mains comme un gong, l'onde de choc fait trembler la toque (finition)
		P_side3 = {
			label = "Gong de cuisine", startup = 0.1, active = 0.12, recovery = 0.34,
			damage = 11, hitbox = box(6.5, 4, 3, 0.8), kbBase = 34, kbGrowth = 78, kbAngle = 36, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 8, -20, 0, 0, -0.15, 0.25 }, Waist = { 12, -24, 0 }, Neck = { 6, 16, 0 }, RS = { 130, 0, 60 }, RE = { 70, 0, 0 }, RW = { -40, 0, 0 }, LS = { 110, 0, -60 }, LE = { 70, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, -0.35, -0.45 }, Waist = { -16, 12, 0 }, Neck = { -6, -6, 0 }, RS = { 95, 0, -8 }, RE = { 0, 0, 0 }, RW = { -85, 0, 0 }, LS = { 95, 0, 10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 12, 0, 0, -0.38, -0.5 }, Waist = { -18, 14, 0 }, Neck = { -8, -8, 0 }, RS = { 92, 0, -14 }, RE = { 5, 0, 0 }, RW = { -90, 0, 0 }, LS = { 92, 0, 16 }, LE = { 5, 0, 0 }, LW = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			shake = true, trail = "prop", fx = { { "ring", color = SILVER, radius = 6, at = "front" }, { "ring", color = SILVER, radius = 3, at = "front" }, { "shake", amount = 0.4 }, { "symbols", symbols = { "♪", "GONNNG" }, count = 3, radius = 3, at = "front", color = SILVER } },
			text = "À TAAABLE !", hitText = "GONNNNG !",
		},
		-- ↓ P P : Croche-louche, la louche accroche la cheville et ramène l'adversaire vers le fourneau
		P_down2 = {
			label = "Croche-louche", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(6.5, 3.5, 3.4, -0.6), kbBase = 20, kbGrowth = 28, kbAngle = 20, pull = true,
			windup = { Root = { -12, -20, 0, 0, -0.7, 0.1 }, Waist = { -22, -20, 0 }, Neck = { 12, 14, 0 }, RS = { 40, 0, 30 }, RE = { 70, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -45 }, LE = { 40, 0, 0 } },
			strike = { Root = { -16, 15, 0, 0, -0.8, -0.3 }, Waist = { -28, 15, 0 }, Neck = { 16, -10, 0 }, RS = { 70, 0, 5 }, RE = { 0, 0, 0 }, RW = { 60, 0, 0 }, LS = { 25, 0, -45 }, LE = { 40, 0, 0 } },
			follow = { Root = { -8, -5, 0, 0, -0.65, 0.1 }, Waist = { -18, -5, 0 }, Neck = { 12, 4, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 25, 0, -45 }, LE = { 40, 0, 0 } },
			prop = "louche", hideProp = "poele", trail = "rightHand", text = "PAR ICI !", hitText = "ACCROCHÉ !",
		},
		-- ↓ P P P : Une pincée de sel, la salière vidée dans les yeux de l'adversaire, qui éternue à s'en décoller (finition)
		P_down3 = {
			label = "Une pincée de sel", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 9, hitbox = box(6.5, 4, 3.2, 0.8), kbBase = 34, kbGrowth = 70, kbAngle = 55, status = { name = "sneezy", duration = 2 },
			windup = { Root = { 2, 25, 0, 0, -0.25, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 6, -20, 0 }, RS = { 30, 0, 40 }, RE = { 70, 0, 0 }, LS = { 120, 0, -20 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, -15, 0, 0, -0.3, -0.4 }, Waist = { -12, -20, 0 }, Neck = { 0, 12, 0 }, RS = { 25, 0, 45 }, RE = { 70, 0, 0 }, LS = { 100, 0, 0 }, LE = { 10, 0, 0 }, LW = { -60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -10, -20, 0, 0, -0.3, -0.45 }, Waist = { -12, -26, 0 }, Neck = { 0, 16, 0 }, RS = { 25, 0, 45 }, RE = { 70, 0, 0 }, LS = { 102, 0, -6 }, LE = { 10, 0, 0 }, LW = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			wobble = true, prop = "saliere", trail = "leftHand", fx = { { "particles", tex = "spark", color = WHITE, dir = "front", at = "lhand", time = 0.3, speed = 10, size = 0.3, rate = 90 }, { "symbols", symbols = { "🧂", "ATCHOUM" }, count = 3, radius = 2.5, at = "front", color = WHITE } },
			text = "UNE PINCÉE DE SEL !", hitText = "ATCHOUM !",
		},
		-- → K K : Rouleau qui roule, il fait rouler le rouleau à pâtisserie sur l'adversaire comme sur une pâte (deux passages)
		K_side2 = {
			label = "Rouleau qui roule", startup = 0.08, active = 0.18, recovery = 0.22,
			damage = 4, hits = 2, hitbox = box(6, 4, 3, 0.8), kbBase = 20, kbGrowth = 32, kbAngle = 25, selfVelocity = Vector2.new(14, 0),
			windup = { Root = { -6, 0, 0, 0, -0.25, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, -20 }, RE = { 70, 0, 0 }, LS = { 70, 0, 20 }, LE = { 70, 0, 0 }, LW = { 0, 0, 90 } },
			strike = { Root = { -14, 0, 0, 0, -0.38, -0.4 }, Waist = { -18, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 96, 0, -14 }, RE = { 5, 0, 0 }, LS = { 96, 0, 14 }, LE = { 5, 0, 0 }, LW = { 0, 0, 90 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 0, 0, 0, -0.3, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, -16 }, RE = { 40, 0, 0 }, LS = { 80, 0, 16 }, LE = { 40, 0, 0 }, LW = { 0, 0, 90 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			wobble = true, trail = "leftHand", fx = { { "particles", tex = "smoke", color = CREAM, dir = "all", at = "front", time = 0.25, speed = 5, size = 0.5 } }, text = "ON ÉTALE !", hitText = "ROULÉ ROULÉ !",
		},
		-- → K K K : Pâte étalée, le rouleau levé à deux mains s'abat de tout son poids : l'adversaire part comme une pizza au four (finition)
		K_side3 = {
			label = "Pâte étalée", startup = 0.1, active = 0.12, recovery = 0.36,
			damage = 13, hitbox = box(6.5, 4.5, 3, 0.8), kbBase = 36, kbGrowth = 86, kbAngle = 34, selfVelocity = Vector2.new(14, 0),
			windup = { Root = { 10, 0, 0, 0, -0.05, 0.25 }, Waist = { 18, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 190, 0, 15 }, RE = { 50, 0, 0 }, LS = { 190, 0, -15 }, LE = { 50, 0, 0 }, LW = { 0, 0, 90 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.45 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 80, 0, 10 }, RE = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 90 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -20, 0, 0, 0, -0.6, -0.5 }, Waist = { -36, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 55, 0, 12 }, RE = { 0, 0, 0 }, LS = { 55, 0, -12 }, LE = { 0, 0, 0 }, LW = { 0, 0, 90 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "leftHand", fx = { { "burst", color = WOOD, size = 3.5, at = "front" }, { "particles", tex = "smoke", color = CREAM, dir = "all", at = "front", time = 0.3, speed = 8, size = 0.7 }, { "shake", amount = 0.4 }, { "symbols", symbols = { "🍕", "🥖" }, count = 3, radius = 2.5, at = "front", color = CREPE } },
			text = "AU FOUR !", hitText = "ÉTALÉ !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Crêpe retournée, la poêle part de sous la ceinture et remonte devant lui d'un coup de poignet
		P_air_side = {
			label = "Crêpe retournée", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(5, 3.5, 3, 0.5), kbBase = 22, kbGrowth = 40, kbAngle = 50,
			windup = { Root = { -8, 10, 0 }, Waist = { -10, 12, 0 }, RS = { -20, 0, 25 }, RE = { 20, 0, 0 }, RW = { -80, 0, 0 }, LS = { 40, 0, -50 }, LE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 8, -8, 0 }, Waist = { 10, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, 10 }, RE = { 10, 0, 0 }, RW = { -90, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 12, -12, 0 }, Waist = { 14, -14, 0 }, Neck = { 14, 0, 0 }, RS = { 135, 0, 10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 25, 0, -62 }, LE = { 40, 0, 0 }, RH = { 15, 0, 0 }, RK = { -45, 0, 0 }, LH = { 65, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", hitText = "FLOP !",
		},
		-- ↑ P en l'air : Poêle au plafond, recroquevillé, il balaie l'air au-dessus de sa toque
		P_air_up = {
			label = "Poêle au plafond", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.8), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -50 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 185, 0, -20 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { -20, 0, -55 }, LE = { 20, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", hitText = "DZING !",
		},
		-- ↓ P en l'air : Sabot plongeant, il pointe le talon vers le sol et tombe dessus de tout son poids (smash vers le sol)
		P_air_down = {
			label = "Sabot plongeant", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 0.8, -2.2), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(0, -45),
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 30, 0, 0 }, LS = { 120, 0, -50 }, LE = { 30, 0, 0 }, RH = { 110, 0, 0 }, RK = { -130, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 45 }, RE = { 10, 0, 0 }, LS = { 160, 0, -45 }, LE = { 10, 0, 0 }, RH = { -2, 0, 4 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 6, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 165, 0, 50 }, RE = { 10, 0, 0 }, LS = { 165, 0, -50 }, LE = { 10, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 45, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "rightFoot", text = "PLONGEON !", hitText = "CLOMP !",
		},
		-- → K en l'air : Rouleau volant, le rouleau balaie l'horizon de gauche à droite, jambes repliées
		K_air_side = {
			label = "Rouleau volant", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5.5, 3.5, 3.2, 0.5), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { -6, 30, 0 }, Waist = { -8, 30, 0 }, Neck = { 0, -25, 0 }, RS = { 40, 0, 40 }, RE = { 70, 0, 0 }, LS = { 90, 0, -100 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 6, -25, 0 }, Waist = { -6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 20, 0, 50 }, RE = { 60, 0, 0 }, LS = { 92, 0, 20 }, LE = { 5, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 70, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 8, -35, 0 }, Waist = { -6, -40, 0 }, Neck = { 0, 26, 0 }, RS = { 15, 0, 55 }, RE = { 60, 0, 0 }, LS = { 85, 0, 45 }, LE = { 10, 0, 0 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 75, 0, 0 }, LK = { -90, 0, 0 } },
			trail = "leftHand", hitText = "VLOUF !",
		},
		-- ↑ K en l'air : Ciseau de commis, salto arrière en grand écart, bras ouverts façon « voilà », les sabots se croisent au-dessus de la toque
		K_air_up = {
			label = "Ciseau de commis", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 55 }, RE = { 40, 0, 0 }, LS = { 40, 0, -55 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 100, 0, 80 }, RE = { 10, 0, 0 }, LS = { 100, 0, -80 }, LE = { 10, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { -35, 0, 0 }, LK = { -10, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 105, 0, 85 }, RE = { 10, 0, 0 }, LS = { 105, 0, -85 }, LE = { 10, 0, 0 }, RH = { -35, 0, 0 }, RK = { -10, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "CLAC-CLAC !",
		},
		-- ↓ K en l'air : Rouleau-pilon, rouleau levé à deux mains au-dessus de la toque puis abattu (smash vers le sol)
		K_air_down = {
			label = "Rouleau-pilon", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(4.5, 4, 1.2, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80,
			windup = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 10 }, RE = { 40, 0, 0 }, LS = { 190, 0, -10 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 10 }, RE = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -26, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 45, 0, 10 }, RE = { 0, 0, 0 }, LS = { 45, 0, -10 }, LE = { 5, 0, 0 }, LW = { -15, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "leftHand", text = "AU PILON !", hitText = "PAF-POUF !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Crêpe volante : une crêpe part de la poêle comme un frisbee et fonce droit sur la figure de l'adversaire
		S_neutral = {
			label = "Crêpe volante", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
			damage = 12, kbBase = 22, kbGrowth = 45, kbAngle = 35,
			projectile = { speed = 60, angle = 5, gravity = 0, lifetime = 1.0, size = 2, color = CREPE,
				visual = { shape = "disc", size = 2, color = CREPE, spin = 14, parts = { { "block", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0.2, 0, 0), Color3.fromRGB(255, 235, 120) } } } },
			windup = { Root = { 4, -15, 0, 0, -0.3, 0.1 }, Waist = { 6, -18, 0 }, Neck = { 12, 10, 0 }, RS = { 35, 0, 20 }, RE = { 60, 0, 0 }, RW = { -80, 0, 0 }, LS = { 5, 0, -40 }, LE = { 90, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.15, -0.15 }, Waist = { 8, 12, 0 }, Neck = { 22, -6, 0 }, RS = { 100, 0, 5 }, RE = { 10, 0, 0 }, RW = { -95, 0, 0 }, LS = { 5, 0, -42 }, LE = { 90, 0, 0 } },
			follow = { Root = { -4, 12, 0, 0, -0.12, -0.18 }, Waist = { 10, 14, 0 }, Neck = { 26, -8, 0 }, RS = { 115, 0, 5 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 5, 0, -42 }, LE = { 90, 0, 0 } },
			text = "HOP !", hitText = "SPLAF !",
		},
		-- Flambage : grande inspiration, torse bombé, et il crache un jet de flammes qui traverse tout le couloir (brûle)
		S_side = {
			label = "Flambage", startup = 0.2, active = 0.25, recovery = 0.45,
			damage = 14, burn = true, hitbox = box(15, 5, 7.5, 1), kbBase = 26, kbGrowth = 55, kbAngle = 30,
			windup = { Root = { 10, 0, 0, 0, -0.1, 0.25 }, Waist = { 18, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 30, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.2 }, Waist = { -14, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 60, 0, 85 }, RE = { 10, 0, 0 }, LS = { 60, 0, -85 }, LE = { 10, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.28, -0.25 }, Waist = { -16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 90 }, RE = { 10, 0, 0 }, LS = { 70, 0, -90 }, LE = { 10, 0, 0 } },
			shake = true, windupFx = { { "particles", tex = "smoke", color = Color3.fromRGB(90, 90, 90), dir = "up", at = "head", time = 0.2, speed = 4 } },
			fx = { "fire", { "beam", color = FIRE, length = 14, width = 3.4, at = "head" }, { "particles", tex = "fire", color = FLAME, dir = "front", at = "head", time = 0.3, speed = 26, size = 1.4, rate = 90 } },
			text = "FLAMBÉÉÉ !", hitText = "CRAMÉ !",
		},
		-- Oignon émincé : il émince un oignon à toute vitesse et le nuage de larmes envahit tout le couloir : l'adversaire fond en larmes, écran flou
		S_down = {
			label = "Oignon émincé", startup = 0.18, active = 0.25, recovery = 0.4,
			damage = 12, hitbox = box(14, 5, 7, 0.8), kbBase = 16, kbGrowth = 25, kbAngle = 40,
			status = { name = "blinded", duration = 1.5 },
			windup = { Root = { 4, -10, 0, 0, -0.3, 0 }, Waist = { -10, -10, 0 }, Neck = { -15, 0, 0 }, RS = { 120, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.35, -0.1 }, Waist = { -18, 10, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 5 }, RE = { 60, 0, 0 }, RW = { 20, 0, 0 }, LS = { 60, 0, 22 }, LE = { 85, 0, 0 } },
			follow = { Root = { -4, 10, 0, 0, -0.35, -0.1 }, Waist = { -18, 10, 0 }, Neck = { -20, 0, 0 }, RS = { 110, 0, 5 }, RE = { 90, 0, 0 }, RW = { -10, 0, 0 }, LS = { 60, 0, 22 }, LE = { 85, 0, 0 } },
			wobble = true, prop = "oignon", hideProp = "poele",
			fx = { { "symbols", symbols = { "💧", "😭", "💧" }, color = Color3.fromRGB(120, 180, 255), count = 7, radius = 3, at = "front" }, { "beam", color = Color3.fromRGB(235, 215, 230), length = 14, width = 4, at = "head" }, { "toss", shape = "flat", color = Color3.fromRGB(235, 215, 230), size = 0.4, count = 5, speed = 10 } },
			text = "TCHAC TCHAC TCHAC !", hitText = "SNIF !",
		},
		-- Flambée-fusée (↑L) : il allume la poêle, la flambée l'éjecte en diagonale vers l'avant comme une fusée, poêle brûlante
		-- tendue devant lui, toque au vent, jambes qui traînent derrière (brûle)
		S_up = {
			label = "Flambée-fusée", startup = 0.1, active = 0.3, recovery = 0.4,
			damage = 14, burn = true, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 75, selfVelocity = Vector2.new(42, 80),
			windup = { Root = { 0, 0, 0, 0, -0.7, 0 }, Waist = { -12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 20 }, RE = { 30, 0, 0 }, RW = { -60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -42, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 172, 0, 8 }, RE = { 0, 0, 0 }, RW = { -90, 0, 0 }, LS = { -30, 0, -30 }, LE = { 20, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
			follow = { Root = { -46, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 176, 0, 10 }, RE = { 0, 0, 0 }, RW = { -90, 0, 0 }, LS = { -35, 0, -35 }, LE = { 20, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
			trail = "prop", windupFx = { { "particles", tex = "fire", color = FIRE, dir = "up", at = "hand", time = 0.15, speed = 6, size = 0.9 } },
			fx = { { "burst", color = FLAME, size = 3.5, at = "feet" }, { "ring", color = FIRE, radius = 5, at = "feet" }, { "particles", tex = "fire", color = FLAME, dir = "down", at = "feet", time = 0.4, speed = 16, size = 1.2, rate = 90 } },
			text = "FLAMBÉE-FUSÉE !", hitText = "GRILLÉ EN VOL !",
		},
		-- Pluie de spaghettis (en l'air + ↓ + S) : poêle pleine au-dessus de la tête, il tombe comme une enclume sur l'adversaire
		-- et les spaghettis ligotent ceux qui sont dessous
		S_air_down = {
			label = "Pluie de spaghettis", startup = 0.15, active = 0.35, recovery = 0.4,
			damage = 13, hitbox = box(6, 5, 1, -2), kbBase = 18, kbGrowth = 35, kbAngle = -40, selfVelocity = Vector2.new(0, -80),
			status = { name = "rooted", duration = 1.2 },
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 175, 0, 10 }, RE = { 40, 0, 0 }, RW = { -90, 0, 0 }, LS = { 175, 0, -10 }, LE = { 40, 0, 0 }, RH = { 80, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 170, 0, 15 }, RE = { 30, 0, 0 }, RW = { -90, 0, 0 }, LS = { 170, 0, -15 }, LE = { 30, 0, 0 }, RH = { 0, 0, 5 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { 0, 0, -5 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 60 }, RE = { 20, 0, 0 }, RW = { -40, 0, 0 }, LS = { 120, 0, -60 }, LE = { 20, 0, 0 }, RH = { 2, 0, 8 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { 2, 0, -8 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "body", fx = { { "rain", shape = "cyl", color = PASTA, count = 16, radius = 4, size = 1.2 }, { "shake", amount = 0.4 } }, text = "AL DENTE !", hitText = "LIGOTÉ !",
		},
		-- Sol huilé (esquive puis S) : il penche la poêle et vide un torrent d'huile d'olive : la nappe couvre tout le couloir et tout le monde glisse
		S_dodge = {
			label = "Sol huilé", startup = 0.18, active = 0.2, recovery = 0.45,
			damage = 12, hitbox = box(14, 4, 7, 0.5), kbBase = 20, kbGrowth = 30, kbAngle = 60,
			status = { name = "slippery", duration = 2.5 },
			windup = { Root = { 6, -10, 0, 0, -0.15, 0.1 }, Waist = { 10, -10, 0 }, Neck = { 14, 0, 0 }, RS = { 110, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -10, 8, 0, 0, -0.3, -0.25 }, Waist = { -16, 8, 0 }, Neck = { -10, 0, 0 }, RS = { 100, 0, 15 }, RE = { 10, 0, 0 }, RW = { 0, 0, 90 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -12, 10, 0, 0, -0.32, -0.3 }, Waist = { -18, 10, 0 }, Neck = { -12, 0, 0 }, RS = { 70, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 100 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			hold = 0.1, trail = "prop", fx = { { "puddle", color = OIL, width = 14, time = 2 }, { "beam", color = OIL, length = 14, width = 2, at = "feet" } }, text = "UN FILET D'HUILE…", hitText = "ÇA GLISSE !",
		},
		-- Mijotage (S maintenu) : la poêle rougit sur un feu imaginaire, puis il l'abat : la vague de chaleur roule sur tout le couloir (brûle)
		S_hold = {
			label = "Mijotage", startup = 0.3, active = 0.15, recovery = 0.5,
			damage = 16, burn = true, hitbox = box(14, 5, 7, 0.8), kbBase = 32, kbGrowth = 82, kbAngle = 38,
			windup = { Root = { 8, -15, 0, 0, -0.3, 0.25 }, Waist = { 14, -18, 0 }, Neck = { 10, 15, 0 }, RS = { 185, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -50 }, LE = { 40, 0, 0 } },
			strike = { Root = { -16, 12, 0, 0, -0.5, -0.45 }, Waist = { -30, 14, 0 }, Neck = { -10, -6, 0 }, RS = { 75, 0, 0 }, RE = { 0, 0, 0 }, RW = { -70, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 } },
			follow = { Root = { -18, 14, 0, 0, -0.55, -0.5 }, Waist = { -34, 16, 0 }, Neck = { -12, -8, 0 }, RS = { 55, 0, 0 }, RE = { 0, 0, 0 }, RW = { -80, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 } },
			shake = true, trail = "prop",
			windupFx = { { "particles", tex = "fire", color = FIRE, dir = "up", at = "hand", time = 0.25, speed = 6, size = 0.9 } },
			fx = { { "burst", color = FIRE, size = 3.5, at = "front" }, { "beam", color = FIRE, length = 14, width = 3, at = "feet" }, { "particles", tex = "fire", color = FLAME, dir = "all", at = "front", time = 0.25, speed = 10, size = 1 } },
			text = "ÇA MIJOTE !", hitText = "TSSSS !",
		},
		-- Service rapide (→→S) : plateau d'argent levé comme un serveur pressé, il traverse tout le couloir et sert le plateau au visage
		S_dash = {
			label = "Service rapide", startup = 0.15, active = 0.3, recovery = 0.4,
			damage = 13, hitbox = box(14, 5, 6, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(60, 0), invuln = 0.15,
			windup = { Root = { -6, 0, 0, 0, -0.2, 0 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 25 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -30 }, LE = { 100, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, -0.3, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 100, 0, 5 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -35 }, LE = { 90, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.3, -0.25 }, Waist = { -6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 98, 0, 0 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { -35, 0, -38 }, LE = { 90, 0, 0 } },
			prop = "plateau", hideProp = "poele", fx = { "dust" }, text = "SERVICE !", hitText = "BON APPÉTIT !",
		},
		-- Assiette de spaghettis (S en l'air) : il lance l'assiette entière, qui fonce sur l'adversaire : les spaghettis le ligotent
		S_air = {
			label = "Assiette de spaghettis", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
			damage = 12, kbBase = 16, kbGrowth = 25, kbAngle = 60,
			status = { name = "rooted", duration = 1 },
			projectile = { speed = 58, angle = -20, gravity = 0, lifetime = 0.8, size = 1.8, color = PASTA,
				visual = { shape = "disc", size = 1.8, color = WHITE, spin = 6, parts = { { "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 0, -0.4), PASTA }, { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.25, 0.3, -0.9), SAUCE } } } },
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 40, 0, 20 }, RE = { 80, 0, 0 }, RW = { -80, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { -90, 0, 0 }, LS = { 20, 0, -60 }, LE = { 40, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 15, 0, -62 }, LE = { 40, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			text = "MAMMA MIA !", hitText = "SLURP !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Flambé minute : il balaie l'air de la poêle en feu en demi-cercle (brûle)
		S_finish_flambe = {
			label = "Flambé minute", startup = 0.14, active = 0.2, recovery = 0.32,
			damage = 10, burn = true, hitbox = box(7, 4, 3, 0.8), kbBase = 30, kbGrowth = 62, kbAngle = 35,
			windup = { Root = { 4, -35, 0, 0, -0.3, 0.2 }, Waist = { 6, -35, 0 }, Neck = { 0, 30, 0 }, RS = { 70, 0, 90 }, RE = { 30, 0, 0 }, RW = { -80, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -8, 20, 0, 0, -0.35, -0.3 }, Waist = { -10, 25, 0 }, Neck = { 0, -15, 0 }, RS = { 95, 0, 0 }, RE = { 5, 0, 0 }, RW = { -85, 0, 0 }, LS = { -10, 0, -45 }, LE = { 50, 0, 0 } },
			follow = { Root = { -10, 35, 0, 0, -0.35, -0.35 }, Waist = { -12, 40, 0 }, Neck = { 0, -25, 0 }, RS = { 90, 0, -40 }, RE = { 10, 0, 0 }, RW = { -85, 0, 0 }, LS = { -15, 0, -48 }, LE = { 50, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "fire", color = FIRE, dir = "up", at = "hand", time = 0.3, speed = 9, size = 1.1, rate = 90 } }, text = "FLAMBÉ MINUTE !", hitText = "GRILLÉ !",
		},
		-- Trois crêpes : trois crêpes empilées partent d'un seul coup de poêle, droit sur l'adversaire
		S_finish_crepes = {
			label = "Trois crêpes", kind = "projectile", startup = 0.12, active = 0, recovery = 0.3,
			damage = 12, kbBase = 22, kbGrowth = 45, kbAngle = 35,
			projectile = { speed = 55, angle = 5, gravity = 0, lifetime = 0.7, size = 1.8, color = CREPE,
				visual = { shape = "disc", size = 1.8, color = CREPE, spin = 16, parts = { { "block", Vector3.new(1.5, 1.5, 0.15), Vector3.new(0.15, -0.1, 0.3), CREPE }, { "block", Vector3.new(1.5, 1.5, 0.15), Vector3.new(-0.15, 0.1, 0.6), Color3.fromRGB(225, 175, 95) } } } },
			windup = { Root = { 4, -12, 0, 0, -0.3, 0.1 }, Waist = { 6, -14, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { -80, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.15 }, Waist = { -6, 12, 0 }, Neck = { 12, 0, 0 }, RS = { 105, 0, 0 }, RE = { 5, 0, 0 }, RW = { -95, 0, 0 }, LS = { 10, 0, -42 }, LE = { 85, 0, 0 } },
			follow = { Root = { -6, 12, 0, 0, -0.2, -0.18 }, Waist = { -6, 14, 0 }, Neck = { 14, 0, 0 }, RS = { 118, 0, 0 }, RE = { 5, 0, 0 }, RW = { -60, 0, 0 }, LS = { 10, 0, -42 }, LE = { 85, 0, 0 } },
			text = "ET TROIS CRÊPES !", hitText = "FLAP !",
		},

		------------------------------------------------------------------ Supers
		-- Flambée Impériale (Y) : il lève la poêle au ciel et une muraille de feu roule sur tout le couloir (brûle)
		SUPER = {
			label = "Flambée Impériale !", startup = 0.4, active = 0.45, recovery = 0.7,
			damage = 8, hits = 3, burn = true, hitbox = box(16, 22, 8, 9), kbBase = 30, kbGrowth = 60, kbAngle = 82,
			windup = { Root = { 6, 0, 0, 0, -0.6, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 90, 0, 0 }, LS = { 60, 0, -60 }, LE = { 90, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.2, 0 }, Waist = { 22, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -60 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.25, 0 }, Waist = { 25, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 180, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -70 }, LE = { 10, 0, 0 } },
			hold = 0.3, windupFx = { "super" },
			fx = { { "pillar", color = FIRE, height = 24, width = 5, at = "front" }, { "particles", tex = "fire", color = FLAME, dir = "up", at = "front", time = 0.7, speed = 30, size = 2.2, rate = 120 }, { "screen", color = FIRE, alpha = 0.3 }, { "shake", amount = 0.7 } },
			text = "FLAMBÉE IMPÉRIALE !", hitText = "BIEN CUIT !",
		},
		-- Homard en colère (→Y) : il sort un homard vivant du vivier, le brandit par la queue en s'excusant, et le lance : le homard
		-- traverse le couloir pinces en avant, poursuit l'adversaire et lui pince les orteils jusqu'à ce qu'il ne bouge plus
		SUPER_side = {
			label = "Homard en colère !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.65,
			damage = 24, kbBase = 44, kbGrowth = 92, kbAngle = 32,
			projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 1.0, size = 2.8, color = LOBSTER, homing = 0.5, pierce = true,
				visual = { shape = "ball", size = 2.2, color = LOBSTER, spin = 6, parts = {
					{ "ball", Vector3.new(1.0, 0.7, 2.0), Vector3.new(0, 0, 1.2), LOBSTER },
					{ "block", Vector3.new(0.5, 0.4, 1.2), Vector3.new(0.9, 0, -1.2), LOBSTER },
					{ "block", Vector3.new(0.5, 0.4, 1.2), Vector3.new(-0.9, 0, -1.2), LOBSTER },
					{ "ball", Vector3.new(0.25, 0.25, 0.25), Vector3.new(0.4, 0.5, -0.8), BLACK },
					{ "ball", Vector3.new(0.25, 0.25, 0.25), Vector3.new(-0.4, 0.5, -0.8), BLACK },
				} } },
			status = { name = "rooted", duration = 1.5 },
			windup = { Root = { 8, -36, 0, 0, -0.3, 0.3 }, Waist = { 12, -40, 0 }, Neck = { 6, 26, 0 }, RS = { 160, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } },
			strike = { Root = { -16, 26, 0, 0, -0.34, -0.5 }, Waist = { -18, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, 30, 0, 0, -0.3, -0.5 }, Waist = { -16, 34, 0 }, Neck = { 10, -20, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			hideProp = "poele", windupFx = { "super", { "symbols", symbols = { "🦞", "PARDON", "🦞" }, count = 5, radius = 3, color = LOBSTER } },
			fx = { { "burst", color = LOBSTER, size = 3, at = "hand" }, { "particles", tex = "spark", color = SAUCE, dir = "front", at = "hand", time = 0.3, speed = 16 }, { "shake", amount = 0.3 } },
			text = "DÉSOLÉ, MON HOMARD !", hitText = "PINCÉ !",
		},
		-- Crêpe suzette en orbite (↑Y) : poêle glissée sous le couloir entier, il la retourne d'un coup de reins : crêpe suzette flambée jusqu'au plafond, tout le monde avec
		SUPER_up = {
			label = "Crêpe suzette en orbite !", startup = 0.4, active = 0.3, recovery = 0.7,
			damage = 24, hitbox = box(16, 14, 8, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -14, -8, 0, 0, -0.9, 0.1 }, Waist = { -30, -8, 0 }, Neck = { 16, 6, 0 }, RS = { 25, 0, 15 }, RE = { 15, 0, 0 }, RW = { -85, 0, 0 }, LS = { 25, 0, -15 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 10, 6, 0, 0, 0.45, -0.1 }, Waist = { 22, 6, 0 }, Neck = { 42, 0, 0 }, RS = { 182, 0, 12 }, RE = { 8, 0, 0 }, RW = { -95, 0, 0 }, LS = { 176, 0, -18 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 12, 8, 0, 0, 0.5, -0.12 }, Waist = { 26, 8, 0 }, Neck = { 46, 0, 0 }, RS = { 170, 0, 45 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 165, 0, -50 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			hold = 0.35, shake = true, trail = "prop", burn = true, burnTime = 3,
			windupFx = { "super", { "particles", tex = "fire", color = FIRE, dir = "up", at = "hand", time = 0.3, speed = 6, size = 0.9 } },
			fx = { { "pillar", color = FIRE, height = 24, width = 4, at = "front" }, { "particles", tex = "fire", color = FLAME, dir = "up", at = "front", time = 0.7, speed = 20, size = 1.8, rate = 110 }, { "toss", shape = "flat", color = CREPE, size = 1.4, count = 5, speed = 14, lift = 40 }, { "burst", color = FLAME, size = 4, at = "above" } },
			text = "CRÊPE SUZETTE !", hitText = "FLAMBÉE AU PLAFOND !",
		},
		-- Menu Dégustation (↓Y) : plateau en main, il sert sept plats d'affilée au visage : tout le couloir est servi
		SUPER_down = {
			label = "Menu Dégustation !", startup = 0.35, active = 0.7, recovery = 0.6,
			damage = 4, hits = 7, hitbox = box(14, 5, 7, 0.8), kbBase = 12, kbGrowth = 25, kbAngle = 35,
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 150, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 95, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.25, -0.3 }, Waist = { -10, 14, 0 }, Neck = { 10, 0, 0 }, RS = { 95, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { -8, -10, 0, 0, -0.25, -0.3 }, Waist = { -10, -14, 0 }, Neck = { 10, 0, 0 }, RS = { 95, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -20 }, LE = { 20, 0, 0 } },
			wobble = true, prop = "plateau", hideProp = "poele", windupFx = { "super" },
			fx = { { "toss", shape = "flat", color = WHITE, size = 1.2, count = 7, speed = 18 }, { "symbols", symbols = { "🍝", "🥖", "🧀", "🍰", "🥩", "🍲", "🥐" }, count = 7, radius = 3, at = "front" } },
			text = "MENU DÉGUSTATION !", hitText = "MIAM !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise du chef : il attrape l'adversaire comme un poulet à farcir et le sale copieusement
		GRAB = {
			label = "Prise du chef", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 110, 0, 50 }, RE = { 20, 0, 0 }, LS = { 110, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -12, 0, 0 }, RS = { 85, 0, -15 }, RE = { 60, 0, 0 }, LS = { 85, 0, 15 }, LE = { 60, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.18, -0.3 }, Waist = { -10, 0, 0 }, RS = { 88, 0, -22 }, RE = { 70, 0, 0 }, LS = { 88, 0, 22 }, LE = { 70, 0, 0 } },
			prop = "saliere", fx = { { "particles", tex = "spark", color = WHITE, dir = "down", at = "lhand", time = 0.4, speed = 4, size = 0.25 } }, text = "UN PEU DE SEL ?", hitText = "ATCHOUM !",
		},
		-- ✋ puis → : Envoyé en salle, il fait tourner la victime comme une assiette et l'envoie au loin
		THROW_fwd = {
			label = "Envoyé en salle", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 12,
			carry = { { 0, 2.4, 0.4 }, { 0.14, -1.2, 0.6 }, { 0.32, 4.5, 0.2 } },
			windup = { Root = { 4, 45, 0, 0, -0.3, 0.2 }, Waist = { 6, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 85, 0, -30 }, RE = { 40, 0, 0 }, LS = { 85, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -12, -25, 0, 0, -0.4, -0.4 }, Waist = { -14, -30, 0 }, Neck = { 0, 15, 0 }, RS = { 90, 0, 40 }, RE = { 5, 0, 0 }, LS = { 90, 0, 0 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, -32, 0, 0, -0.42, -0.45 }, Waist = { -16, -36, 0 }, Neck = { 0, 18, 0 }, RS = { 85, 0, 60 }, RE = { 5, 0, 0 }, LS = { 80, 0, 20 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { "dust" }, text = "TABLE SIX !", hitText = "SERVI !",
		},
		-- ✋ puis ← : Retourné à la poêle, il glisse la poêle sous la victime et la fait sauter par-dessus sa tête
		THROW_back = {
			label = "Retourné à la poêle", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 50,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 2.4, -0.6 }, { 0.28, 0.5, 4.2 }, { 0.4, -2.6, 1.5 } },
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -20, 0, 0 }, RS = { 40, 0, 10 }, RE = { 30, 0, 0 }, RW = { -85, 0, 0 }, LS = { 40, 0, -20 }, LE = { 40, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.2, 0.3 }, Waist = { 28, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 195, 0, 5 }, RE = { 10, 0, 0 }, RW = { -85, 0, 0 }, LS = { 120, 0, -30 }, LE = { 20, 0, 0 } },
			follow = { Root = { 34, 0, 0, 0, -0.2, 0.35 }, Waist = { 32, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 205, 0, 5 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 130, 0, -35 }, LE = { 20, 0, 0 } },
			trail = "prop", text = "ET HOP, RETOURNÉ !", hitText = "FLOP !",
		},
		-- ✋ puis ↑ : Flambé, il lance la victime en l'air et souffle une flamme dessous (brûle)
		THROW_up = {
			label = "Flambé", kind = "throw", startup = 0.34, active = 0.1, recovery = 0.38,
			damage = 9, burn = true, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, -0.6 }, { 0.34, 1.0, 4.2 } },
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -18, 0, 0 }, RS = { 45, 0, -15 }, RE = { 40, 0, 0 }, LS = { 45, 0, 15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.1, 0 }, Waist = { 20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 170, 0, 15 }, RE = { 5, 0, 0 }, LS = { 170, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 14, 0, 0, 0, -0.1, 0.1 }, Waist = { 26, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 60, 0, 60 }, RE = { 10, 0, 0 }, LS = { 60, 0, -60 }, LE = { 10, 0, 0 } },
			fx = { { "particles", tex = "fire", color = FIRE, dir = "up", at = "head", time = 0.4, speed = 26, size = 1.6, rate = 90 } }, text = "FLAMBÉ !", hitText = "CARAMÉLISÉ !",
		},
		-- ✋ puis ↓ : Écrasé au rouleau, il plaque la victime au sol et l'aplatit au rouleau comme une pâte brisée
		THROW_down = {
			label = "Écrasé au rouleau", kind = "throw", startup = 0.42, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 2.0, 1.6 }, { 0.28, 2.4, -2.0 }, { 0.42, 2.4, -2.4 } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -25, 0, 0, 0, -0.9, -0.4 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 10, 0, 0 }, LS = { 70, 0, -20 }, LE = { 10, 0, 0 }, LW = { 80, 0, 0 } },
			follow = { Root = { -28, 0, 0, 0, -0.95, -0.6 }, Waist = { -32, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 60, 0, 25 }, RE = { 5, 0, 0 }, LS = { 60, 0, -25 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 } },
			fx = { "dust" }, text = "PÂTE BRISÉE !", hitText = "CRRRONCH !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "le_souffle", label = "Le Soufflé", sequence = { "forward", "down", "forward" },
			-- l'adversaire gonfle dans un ramequin comme un soufflé, puis s'envole par une cheminée
			scene = {
				{ "fxAttacker", { "text", text = "UN SOUFFLÉ, MONSIEUR ?", color = FLAME } },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.2, 0), life = 4, pieces = {
					{ "Ramequin", "", "cyl", Vector3.new(1.6, 4.2, 4.2), Vector3.zero, Vector3.zero, WHITE, "SmoothPlastic" },
					{ "Cannelures", "", "cyl", Vector3.new(1.4, 4.4, 4.4), Vector3.new(0, -0.1, 0), Vector3.zero, CREAM, "SmoothPlastic" },
				} },
				{ "fx", { "particles", tex = "smoke", color = WHITE, dir = "up", at = "root", time = 1.2, speed = 6, size = 1.2 } },
				{ "color", CREPE },
				{ "grow", 1.7, time = 0.9 },
				{ "text", "IL MONTE… IL MONTE…" },
				{ "wait", 0.4 },
				{ "spawn", at = "above", offset = Vector3.new(0, 8, 0), life = 3, pieces = {
					{ "Cheminee", "", "block", Vector3.new(3, 6, 3), Vector3.zero, Vector3.zero, Color3.fromRGB(170, 70, 50), "Slate" },
					{ "Fumee", "", "ball", Vector3.new(3, 2, 3), Vector3.new(0, 4, 0), Vector3.zero, Color3.fromRGB(220, 220, 220), "SmoothPlastic", { transparency = 0.4 } },
				} },
				{ "launch", Vector3.new(0, 90, 0), time = 1 },
				{ "fxAttacker", { "symbols", symbols = { "💋", "⭐" }, count = 5, color = FLAME } },
				{ "wait", 0.5 },
			},
		},
		{
			id = "croque_monsieur", label = "Croque-Monsieur", sequence = { "back", "forward", "down" },
			-- coincé entre deux tranches de pain géantes, passé au grill, il ressort en sandwich grognon
			scene = {
				{ "spawn", at = "target", offset = Vector3.zero, life = 4.5, name = "Croque", pieces = {
					{ "PainArriere", "", "block", Vector3.new(4.5, 5.5, 0.8), Vector3.new(0, 0, 1.2), Vector3.zero, Color3.fromRGB(230, 190, 120), "Sand" },
					{ "PainAvant", "", "block", Vector3.new(4.5, 5.5, 0.8), Vector3.new(0, 0, -1.2), Vector3.zero, Color3.fromRGB(230, 190, 120), "Sand" },
					{ "Fromage", "", "block", Vector3.new(4.8, 0.4, 2.8), Vector3.new(0, 2.9, 0), Vector3.zero, Color3.fromRGB(255, 210, 60), "SmoothPlastic" },
					{ "Jambon", "", "block", Vector3.new(4.6, 0.3, 2.6), Vector3.new(0, -2.9, 0), Vector3.zero, Color3.fromRGB(240, 150, 160), "SmoothPlastic" },
				} },
				{ "text", "CROQUE-MONSIEUR !" },
				{ "wait", 0.5 },
				{ "fx", { "particles", tex = "fire", color = FIRE, dir = "up", at = "feet", time = 1.2, speed = 10, size = 1.4 } },
				{ "fxAttacker", { "text", text = "AU GRILL !", color = FIRE } },
				{ "color", Color3.fromRGB(150, 95, 45) },
				{ "wait", 1 },
				{ "text", "GRRR…" },
				{ "fx", { "symbols", symbols = { "💢", "🔥" }, count = 5, color = FIRE } },
				{ "wait", 0.8 },
			},
		},
		{
			id = "zero_etoile", label = "Zéro étoile", sequence = { "down", "up", "down" },
			-- un critique gastronomique colle « 0 étoile » à l'adversaire, qu'on emporte sous une cloche d'argent
			scene = {
				{ "fxAttacker", { "text", text = "LA NOTE DU CRITIQUE…", color = SILVER } },
				{ "wait", 0.5 },
				{ "text", "0 ÉTOILE" },
				{ "fx", { "symbols", symbols = { "☆", "0", "☆" }, count = 5, color = Color3.fromRGB(255, 220, 80) } },
				{ "shrink", 0.5, time = 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, -1.6, 0), life = 4, pieces = {
					{ "Plateau", "", "cyl", Vector3.new(0.2, 5, 5), Vector3.zero, Vector3.zero, SILVER, "Metal", { reflect = 0.4 } },
				} },
				{ "wait", 0.4 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0.2, 0), life = 3.6, pieces = {
					{ "Cloche", "", "ball", Vector3.new(4.4, 4, 4.4), Vector3.zero, Vector3.zero, SILVER, "Metal", { reflect = 0.4 } },
					{ "Bouton", "", "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0, 2.1, 0), Vector3.zero, SILVER, "Metal" },
				} },
				{ "hide" },
				{ "fxAttacker", { "text", text = "DÉBARRASSEZ !", color = WHITE } },
				{ "wait", 0.5 },
				{ "launch", Vector3.new(30, 0, 0), time = 0.8 },
				{ "wait", 0.4 },
			},
		},
	},

	-- Mécanique « Cuisson » : les coups marqués burn = true brûlent (voir server/Mechanics.lua)
	passive = { kind = "burn", name = "Cuisson", icon = "🔥" },

	-- Recharge ⚡ : il goûte sa sauce à la cuillère, sale d'un geste théâtral du coude et embrasse ses doigts
	charge = {
		label = "Goûter la sauce",
		loop = 2.0,
		lockWrist = false,
		color = FLAME,
		keys = {
			{ 0.0, { Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 15 }, RE = { 70, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 0.3, { Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 118, 0, -25 }, RE = { 132, 0, 0 }, RW = { -40, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 0.6, { Waist = { 12, 0, 0 }, Neck = { 22, 18, 0 }, RS = { 115, 0, -25 }, RE = { 130, 0, 0 }, RW = { -45, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 0.85, { Root = { 0, 12, 0 }, Waist = { 10, 15, 0 }, Neck = { 14, -10, 0 }, RS = { 25, 0, 30 }, RE = { 70, 0, 0 }, LS = { 150, 0, -65 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 1.05, { Root = { 0, 14, 0 }, Waist = { 12, 18, 0 }, Neck = { 16, -12, 0 }, RS = { 25, 0, 30 }, RE = { 70, 0, 0 }, LS = { 160, 0, -50 }, LE = { 75, 0, 0 }, LW = { 25, 0, 0 } } },
			{ 1.3, { Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 122, 0, -30 }, RE = { 138, 0, 0 }, RW = { -60, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 1.55, { Waist = { 16, 0, 0 }, Neck = { 26, -15, 0 }, RS = { 120, 0, 70 }, RE = { 10, 0, 0 }, RW = { 20, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 1.8, { Waist = { 12, 0, 0 }, Neck = { 18, -8, 0 }, RS = { 70, 0, 50 }, RE = { 30, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
			{ 2.0, { Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 15 }, RE = { 70, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		},
		beats = {
			{ 0.4, { "symbols", symbols = { "😋" }, count = 1, radius = 1.5, color = FLAME } },
			{ 0.95, { "particles", tex = "spark", color = WHITE, dir = "down", at = "lhand", time = 0.3, speed = 4, size = 0.25 } },
			{ 1.5, { "symbols", symbols = { "💋" }, count = 2, radius = 2, color = SAUCE } },
			{ 1.55, { "text", text = "PARFAIT !", color = FLAME } },
		},
	},

	-- Manies au repos : il frise sa moustache, redresse sa toque, astique sa poêle avec le torchon
	fidgets = {
		{ duration = 2.0, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 14, -10, 0 }, RS = { 112, 0, -38 }, RE = { 142, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 0.8, { Neck = { 16, -14, 0 }, RS = { 115, 0, -32 }, RE = { 140, 0, 0 }, RW = { 10, 0, 0 } } },
			{ 1.2, { Neck = { 14, -10, 0 }, RS = { 112, 0, -38 }, RE = { 142, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 2.0, {} },
		} },
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.5, { Waist = { 10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 165, 0, 30 }, RE = { 70, 0, 0 }, LS = { 165, 0, -30 }, LE = { 70, 0, 0 } } },
			{ 1.0, { Waist = { 12, 0, 0 }, Neck = { -6, 0, 6 }, RS = { 168, 0, 28 }, RE = { 72, 0, 0 }, LS = { 162, 0, -32 }, LE = { 68, 0, 0 } } },
			{ 1.5, { Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 20, 0, 40 }, RE = { 90, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 2.4, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 60, 0, 25 }, LE = { 90, 0, 0 } } },
			{ 0.7, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 70, 0, 10 }, LE = { 80, 0, 0 } } },
			{ 1.0, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 60, 0, 25 }, LE = { 90, 0, 0 } } },
			{ 1.3, { Neck = { -15, 0, 0 }, RS = { 60, 0, -10 }, RE = { 70, 0, 0 }, RW = { -80, 0, 0 }, LS = { 70, 0, 10 }, LE = { 80, 0, 0 } } },
			{ 1.8, { Neck = { 10, 0, 0 }, RS = { 100, 0, 20 }, RE = { 30, 0, 0 }, RW = { -90, 0, 0 } } },
			{ 2.4, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : il le tient à bout de bras comme un poulet à farcir, torse bombé de fierté
data.grabHold = {
	Root = { 8, 0, 0, 0, -0.12, 0.1 },
	Waist = { 10, 0, 0 },
	Neck = { 14, 0, 0 },
	RS = { 95, 0, -15 },
	RE = { 50, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 90, 0, 12 },
	LE = { 55, 0, 0 },
}

-- Retour 🪂 : il atterrit dans une marmite géante qui fume, en sort d'un bond en faisant tourner sa poêle
-- et lance « Service ! »
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Fond", "base", "cyl", Vector3.new(1, 6.4, 6.4), Vector3.new(0, -0.5, 0), Vector3.zero, IRON, "Metal" },
		{ "Marmite", "", "cyl", Vector3.new(3.2, 6.8, 6.8), Vector3.new(0, -0.3, 0), Vector3.zero, Color3.fromRGB(150, 150, 160), "Metal", { transparency = 0.25, reflect = 0.2 } },
		{ "Bouillon", "", "cyl", Vector3.new(0.2, 6.4, 6.4), Vector3.new(0, 1.0, 0), Vector3.zero, Color3.fromRGB(220, 110, 50), "SmoothPlastic", { transparency = 0.3 } },
		{ "AnseG", "", "block", Vector3.new(0.8, 0.3, 1.6), Vector3.new(-3.7, 1.0, 0), Vector3.zero, BLACK, "Metal" },
		{ "AnseD", "", "block", Vector3.new(0.8, 0.3, 1.6), Vector3.new(3.7, 1.0, 0), Vector3.zero, BLACK, "Metal" },
		{ "Vapeur1", "", "ball", Vector3.new(2, 1.4, 2), Vector3.new(-2.2, 3.4, 0.5), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.5 } },
		{ "Vapeur2", "", "ball", Vector3.new(2.4, 1.6, 2), Vector3.new(2.4, 4.6, 0.8), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.6 } },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -1.0, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 70 }, RE = { 50, 0, 0 }, LS = { 50, 0, -70 }, LE = { 50, 0, 0 } } },
		{ 0.5, { Root = { 0, 0, 0, 0, -0.95, 0 }, Waist = { -4, 0, 0 }, Neck = { 16, 8, 0 }, RS = { 55, 0, 72 }, RE = { 45, 0, 0 }, LS = { 55, 0, -72 }, LE = { 45, 0, 0 } } },
		{ 0.75, { Root = { 0, 0, 0, 0, 0.6, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } } },
		{ 1.0, { Root = { 0, 20, 0, 0, 0, 0 }, Waist = { 10, 20, 0 }, Neck = { 16, -10, 0 }, RS = { 165, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		{ 1.2, { Root = { 0, -15, 0, 0, 0, 0 }, Waist = { 10, -20, 0 }, Neck = { 16, 10, 0 }, RS = { 165, 0, 5 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		{ 1.45, { Root = { -4, 0, 0, 0, -0.1, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 100, 0, 5 }, RE = { 5, 0, 0 }, RW = { -85, 0, 0 }, LS = { 10, 0, -40 }, LE = { 85, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.05, { "particles", tex = "smoke", color = WHITE, dir = "up", at = "root", time = 1.2, speed = 6, size = 1.5 } },
		{ 0.75, { "burst", color = Color3.fromRGB(220, 110, 50), size = 3, at = "feet" } },
		{ 1.0, { "ring", color = SILVER, radius = 3, at = "hand" } },
		{ 1.45, { "text", text = "SERVICE !", color = FLAME } },
	},
}

-- Arbre d'enchaînements : après le coup de gauche, le bouton (avec sa direction) lance le coup de droite.
-- Presque toutes les chaînes finissent sur S (Flambé minute brûle, Trois crêpes tient à distance).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- louche, fouet, poêle sur la tête
	P_neutral = { P = "P_combo2", K = "PK_combo", up_K = "K_flip", S = "S_finish_crepes" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", S = "S_finish_flambe" },
	P_combo3 = { K = "K_combo3", S = "S_finish_flambe" },
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_crepes" },
	-- sabot, revers de rouleau, sabot sauté
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_flambe" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", up_K = "K_flip", S = "S_finish_flambe" },
	K_combo3 = { K = "K_air_side", P = "P_air_side", S = "S_air" }, -- il décolle : la suite se joue en l'air
	KP_combo = { P = "P_combo3", K = "K_combo3", S = "S_finish_crepes" },
	-- avec une flèche : → P P P (poêle, revers, gong), ↓ P P P (tablier, croche-louche, sel), → K K K (rouleau, rouleau qui roule, pâte étalée)
	P_side = { P = "P_side2", K = "K_combo2", S = "S_finish_flambe" },
	P_side2 = { P = "P_side3", K = "K_side2", S = "S_finish_flambe" },
	P_down = { P = "P_down2", K = "K_flip", S = "S_finish_crepes" },
	P_down2 = { P = "P_down3", K = "K_combo2", S = "S_finish_crepes" },
	P_up = { K = "K_flip", P = "P_combo3", S = "S_finish_flambe" },
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_flambe" },
	K_side2 = { K = "K_side3", P = "P_combo3", S = "S_finish_flambe" },
	K_down = { P = "P_up", K = "K_flip", S = "S_finish_crepes" },
	K_up = { S = "S_finish_crepes" },
	K_flip = { S = "S_finish_crepes" }, -- petit retourné (suite) : la crêpe finit en l'air, trois crêpes pour l'accompagner
	P_dash = { P = "P_combo3", K = "K_side2", S = "S_finish_flambe" },
	K_dash = { P = "P_up", K = "K_flip", S = "S_finish_crepes" },
	-- en l'air ; les smashs ↓ sont des finitions sans suite
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

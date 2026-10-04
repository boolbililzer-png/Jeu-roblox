-- Bébé Colosse : un bébé de 2,50 m en couche, tétine au bec et bonnet à oreilles d'ours. Maladroit, capricieux
-- et terriblement costaud : il serre, il jette, il hurle. Arme sortie de la Caisse Bizarre : le hochet géant
-- (et sa couche, qui sert de bélier).
--
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
-- Mécanique « Caprice » : les coups reçus remplissent la jauge ; pleine, il pique une crise et encaisse sans
-- broncher pendant 5 s (bonus « caprice », voir server/Mechanics.lua).
-- Accessoires ponctuels : le biberon (main droite, le hochet se range) et le bol de purée (main gauche).

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(255, 214, 186)
local CHEEK = Color3.fromRGB(255, 150, 150)
local DIAPER = Color3.fromRGB(250, 250, 245)
local BONNET = Color3.fromRGB(150, 200, 240)
local EAR_IN = Color3.fromRGB(255, 190, 200)
local BLACK = Color3.fromRGB(25, 25, 30)
local PINK = Color3.fromRGB(250, 140, 180)
local YELLOW = Color3.fromRGB(255, 220, 70)
local BLUE = Color3.fromRGB(90, 160, 240)
local PUREE = Color3.fromRGB(240, 150, 50)
local MILK = Color3.fromRGB(255, 255, 250)
local TEARS = Color3.fromRGB(110, 180, 255)
local WOOD = Color3.fromRGB(205, 160, 110)

local LAPIN = Color3.fromRGB(235, 225, 215) -- doudou lapin (arme n° 2)
local METAL = Color3.fromRGB(200, 205, 215) -- cuilleron (arme n° 3)
local data = {
	id = "Bebe",
	name = "Bébé Colosse",
	costume = "Bebe",
	style = "baby",

	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : le hochet géant (ses coups sont ceux de moves). n° 2 : le doudou lapin, rapide et court, qui console (soigne).
	-- n° 3 : la cuillère à purée, jeu de projectiles collants (« l'avion ! ») qui ralentissent.
	weapons = {
		{ id = "hochet", name = "Hochet géant", icon = "🔔",
			ability = { knockback = 1.2, text = "Grelots sonnés : éjecte 20 % plus loin" } },
		{ id = "doudou", name = "Doudou lapin", icon = "🐰",
			prop = { name = "PropDoudou", hand = "Right", pieces = {
				{ "OreilleG", "", "ball", Vector3.new(0.36, 1.1, 0.24), Vector3.new(-0.26, -0.55, 0), Vector3.new(0, 0, 12), LAPIN, "Fabric" },
				{ "OreilleD", "", "ball", Vector3.new(0.36, 1.1, 0.24), Vector3.new(0.26, -0.55, 0), Vector3.new(0, 0, -12), LAPIN, "Fabric" },
				{ "Tete", "", "ball", Vector3.new(1.1, 1.0, 1.0), Vector3.new(0, -1.4, 0), Vector3.zero, LAPIN, "Fabric" },
				{ "Museau", "", "ball", Vector3.new(0.3, 0.22, 0.2), Vector3.new(0, -1.45, -0.5), Vector3.zero, PINK, "SmoothPlastic" },
				{ "Corps", "", "ball", Vector3.new(1.3, 1.5, 1.1), Vector3.new(0, -2.5, 0), Vector3.zero, LAPIN, "Fabric" },
				{ "Rustine", "", "block", Vector3.new(0.4, 0.4, 0.06), Vector3.new(0.3, -2.6, -0.55), Vector3.new(0, 0, 30), BLUE, "Fabric" },
			} },
			ability = { heal = 0.3, text = "Câlin du doudou : 30 % des dégâts infligés le consolent" },
			moves = {
				-- J : petite tape de doudou, vite fait, le lapin pris par le corps
				P_neutral = {
					label = "Tape de doudou", startup = 0.06, active = 0.07, recovery = 0.12,
					damage = 4, hitbox = box(4, 3, 2.4, 0.8), kbBase = 16, kbGrowth = 18, kbAngle = 28,
					windup = { Root = { 2, -12, 0, 0, -0.1, 0.1 }, Waist = { 4, -14, 0 }, Neck = { 6, 10, 0 }, RS = { 70, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 40, 0, 0 } },
					strike = { Root = { -4, 10, 0, 0, -0.18, -0.18 }, Waist = { -6, 12, 0 }, Neck = { 2, -8, 0 }, RS = { 90, 0, 0 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -40 }, LE = { 40, 0, 0 } },
					follow = { Root = { -6, 12, 0, 0, -0.2, -0.2 }, Waist = { -8, 14, 0 }, Neck = { 2, -10, 0 }, RS = { 86, 0, -6 }, RE = { 14, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -40 }, LE = { 40, 0, 0 } },
					trail = "prop", hitText = "PLOF !",
				},
				-- →J : il tient le lapin par les oreilles et le fouette en avant, le corps en pendule
				P_side = {
					label = "Doudou fouetté", startup = 0.07, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(5, 3, 3, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 25, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 6, -20, 0, 0, -0.12, 0.15 }, Waist = { 8, -24, 0 }, Neck = { 4, 16, 0 }, RS = { 150, 0, 30 }, RE = { 60, 0, 0 }, RW = { 40, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, 16, 0, 0, -0.25, -0.3 }, Waist = { -10, 20, 0 }, Neck = { -4, -10, 0 }, RS = { 86, 0, 0 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -10, 18, 0, 0, -0.26, -0.34 }, Waist = { -12, 22, 0 }, Neck = { -6, -12, 0 }, RS = { 70, 0, -4 }, RE = { 6, 0, 0 }, RW = { -60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.34 } },
					trail = "prop", hitText = "FLAP !",
				},
				-- ↓J : accroupi, il traîne le lapin par terre en cercle, les oreilles balaient les chevilles
				P_down = {
					label = "Doudou traîné", startup = 0.07, active = 0.1, recovery = 0.14,
					damage = 4, hitbox = box(5, 2, 2.8, -1.6), kbBase = 18, kbGrowth = 22, kbAngle = 70,
					windup = { Root = { 8, -20, 0, 0, -0.8, 0.1 }, Waist = { 12, -20, 0 }, Neck = { 10, 10, 0 }, RS = { 40, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { 12, 20, 0, 0, -0.95, -0.15 }, Waist = { 18, 24, 0 }, Neck = { 6, -14, 0 }, RS = { 20, 0, -10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 12, 26, 0, 0, -0.95, -0.18 }, Waist = { 18, 30, 0 }, Neck = { 6, -18, 0 }, RS = { 16, 0, -16 }, RE = { 0, 0, 0 }, RW = { -34, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { "dust" }, hitText = "FROTT !",
				},
				-- ↑J : il lance le lapin en l'air pour le rattraper… et le lapin cogne ce qui passe au-dessus
				P_up = {
					label = "Lapin lancé", startup = 0.07, active = 0.1, recovery = 0.14,
					damage = 5, hitbox = box(4, 5, 1, 3.5), kbBase = 22, kbGrowth = 28, kbAngle = 85,
					windup = { Root = { 6, 0, 0, 0, -0.3, 0 }, Waist = { 10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -4, 0, 0, 0, 0.1, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -20 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.12, 0 }, FL = { 0, 0, 0, 0, 0.12, 0 } },
					follow = { Root = { -4, 0, 0, 0, 0.12, 0 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 182, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 156, 0, -22 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.14, 0 }, FL = { 0, 0, 0, 0, 0.14, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "🐰", "♥" }, count = 2, radius = 2, at = "above", color = PINK } }, hitText = "HOP !",
				},
				-- J en l'air : il fait claquer les oreilles du lapin devant lui comme deux petits fouets
				P_air = {
					label = "Oreilles qui claquent", startup = 0.06, active = 0.1, recovery = 0.12,
					damage = 5, hitbox = box(4.5, 3.5, 2, 0), kbBase = 18, kbGrowth = 26, kbAngle = 32,
					windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 140, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 50, 0, 0 }, RK = { -70, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
					strike = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 88, 0, 0 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
					follow = { Root = { -10, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 80, 0, -4 }, RE = { 14, 0, 0 }, RW = { -70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 28, 0, 0 }, RK = { -48, 0, 0 }, LH = { 52, 0, 0 }, LK = { -82, 0, 0 } },
					trail = "prop", hitText = "CLAC-CLAC !",
				},
				-- dash J : il trottine en tendant le lapin devant lui pour faire un bisou… avec les dents du lapin
				P_dash = {
					label = "Trottinement doudou", startup = 0.06, active = 0.12, recovery = 0.18,
					damage = 6, hitbox = box(4.5, 3.5, 2.6, 0.6), kbBase = 22, kbGrowth = 40, kbAngle = 28, selfVelocity = Vector2.new(44, 0),
					windup = { Root = { -6, 0, 0, 0, -0.15, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -30 }, LE = { 40, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.25, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 96, 0, 6 }, RE = { 0, 0, 0 }, RW = { 20, 0, 0 }, LS = { -40, 0, -35 }, LE = { 20, 0, 0 } },
					follow = { Root = { -16, 0, 0, 0, -0.27, -0.34 }, Waist = { -12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 98, 0, 8 }, RE = { 0, 0, 0 }, RW = { 24, 0, 0 }, LS = { -44, 0, -38 }, LE = { 20, 0, 0 } },
					trail = "prop", fx = { "dust" }, text = "BISOU !", hitText = "MORDU !",
				},
				-- K : le lapin a traîné dans la bave : grande claque mouillée du doudou, ça trempe
				K_neutral = {
					label = "Doudou baveux", startup = 0.14, active = 0.1, recovery = 0.22,
					damage = 9, hitbox = box(5, 3.5, 2.8, 0.6), kbBase = 26, kbGrowth = 55, kbAngle = 35,
					status = { name = "wet", duration = 1 },
					windup = { Root = { 4, -24, 0, 0, -0.15, 0.2 }, Waist = { 6, -28, 0 }, Neck = { 10, 20, 0 }, RS = { 150, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -10, 20, 0, 0, -0.3, -0.35 }, Waist = { -12, 24, 0 }, Neck = { -6, -14, 0 }, RS = { 90, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 26, 0, 0, -0.32, -0.4 }, Waist = { -14, 30, 0 }, Neck = { -8, -18, 0 }, RS = { 76, 0, -24 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					trail = "prop", fx = { { "burst", color = MILK, size = 2.5, at = "front" }, { "symbols", symbols = { "💦" }, count = 2, radius = 2, at = "front", color = TEARS } }, hitText = "SPLATCH !",
				},
				-- →K : moulinet d'oreilles, le lapin tourne par les oreilles comme une fronde, trois coups
				K_side = {
					label = "Moulinet d'oreilles", startup = 0.12, active = 0.2, recovery = 0.24,
					damage = 3, hits = 3, hitbox = box(5.5, 4, 3, 0.8), kbBase = 18, kbGrowth = 28, kbAngle = 30,
					windup = { Root = { 2, -16, 0, 0, -0.12, 0.15 }, Waist = { 4, -18, 0 }, Neck = { 6, 12, 0 }, RS = { 120, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, 10, 0, 0, -0.25, -0.3 }, Waist = { -10, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 96, 0, 20 }, RE = { 10, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					follow = { Root = { -8, 10, 0, 0, -0.25, -0.3 }, Waist = { -10, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 96, 0, -20 }, RE = { 10, 0, 0 }, RW = { -60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					wobble = true, trail = "prop", fx = { { "symbols", symbols = { "🐰", "💫" }, count = 3, radius = 2.5, at = "front", color = PINK } }, text = "VROUM-VROUM !", hitText = "FLAP FLAP FLAP !",
				},
				-- ↓K : il glisse sur le ventre en poussant le lapin devant lui, un bélier tout doux dans les tibias
				K_down = {
					label = "Doudou sous le tapis", startup = 0.12, active = 0.14, recovery = 0.22,
					damage = 9, hitbox = box(5.5, 2.5, 3, -1.5), kbBase = 26, kbGrowth = 50, kbAngle = 72, selfVelocity = Vector2.new(26, 0),
					windup = { Root = { -20, 0, 0, 0, -0.6, 0 }, Waist = { -16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 100, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -70, 0, 0, 0, -1.5, -0.3 }, Waist = { -6, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 10, 0, 0 }, RH = { -10, 0, 10 }, RK = { -20, 0, 0 }, LH = { -10, 0, -10 }, LK = { -20, 0, 0 } },
					follow = { Root = { -72, 0, 0, 0, -1.52, -0.34 }, Waist = { -8, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 174, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 154, 0, -32 }, LE = { 10, 0, 0 }, RH = { -12, 0, 12 }, RK = { -24, 0, 0 }, LH = { -12, 0, -12 }, LK = { -24, 0, 0 } },
					trail = "prop", fx = { "dust" }, hitText = "POUF !",
				},
				-- ↑K : doudou-catapulte, il se cambre et balance le lapin à deux mains vers le ciel
				K_up = {
					label = "Doudou-catapulte", startup = 0.14, active = 0.12, recovery = 0.24,
					damage = 9, hitbox = box(4.5, 5.5, 1.2, 3.5), kbBase = 28, kbGrowth = 58, kbAngle = 86,
					windup = { Root = { 12, 0, 0, 0, -0.5, 0.15 }, Waist = { 20, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 20, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 30, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.1, -0.1 }, Waist = { -18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -8 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.14, 0 }, FL = { 0, 0, 0, 0, 0.14, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.12, -0.12 }, Waist = { -20, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 184, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 182, 0, -10 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.16, 0 }, FL = { 0, 0, 0, 0, 0.16, 0 } },
					trail = "prop", fx = { { "burst", color = PINK, size = 2.5, at = "above" } }, hitText = "ENVOLÉ !",
				},
				-- K en l'air : câlin tombant, il serre le lapin contre son bedon et tombe dessus en boule
				K_air = {
					label = "Câlin tombant", startup = 0.12, active = 0.14, recovery = 0.2,
					damage = 10, hitbox = box(5, 4, 1.5, -1), kbBase = 26, kbGrowth = 58, kbAngle = -40,
					windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 120, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -40, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 70, 0, -20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 130, 0, 0 }, RH = { 100, 0, 10 }, RK = { -130, 0, 0 }, LH = { 100, 0, -10 }, LK = { -130, 0, 0 } },
					follow = { Root = { -44, 0, 0 }, Waist = { -22, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 72, 0, -22 }, RE = { 132, 0, 0 }, RW = { 0, 0, 0 }, LS = { 72, 0, 22 }, LE = { 132, 0, 0 }, RH = { 104, 0, 12 }, RK = { -134, 0, 0 }, LH = { 104, 0, -12 }, LK = { -134, 0, 0 } },
					trail = "body", fx = { { "symbols", symbols = { "♥" }, count = 2, radius = 1.5, color = PINK } }, hitText = "GROS CÂLIN !",
				},
				-- dash K : doudou-bélier, il fonce le lapin devant lui, oreilles rabattues par la vitesse
				K_dash = {
					label = "Doudou-bélier", startup = 0.1, active = 0.2, recovery = 0.26,
					damage = 10, hitbox = box(5.5, 3.5, 3, 0.3), kbBase = 28, kbGrowth = 56, kbAngle = 36, selfVelocity = Vector2.new(52, 0),
					windup = { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -8, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -20, 0, 0, 0, -0.4, -0.3 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 96, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -8 }, LE = { 0, 0, 0 } },
					follow = { Root = { -22, 0, 0, 0, -0.42, -0.34 }, Waist = { -14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 98, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 98, 0, -10 }, LE = { 0, 0, 0 } },
					trail = "prop", fx = { "dust" }, text = "VROUUUM !", hitText = "BOUM-DOUDOU !",
				},
				-- L : gros câlin, bras grands ouverts, il attire tout le couloir contre son bedon et serre très fort (ça console)
				S_neutral = {
					label = "Gros câlin", startup = 0.2, active = 0.2, recovery = 0.42,
					damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 20, kbGrowth = 30, kbAngle = 30, pull = true,
					selfEffect = { heal = 4 },
					windup = { Root = { -6, 0, 0, 0, -0.2, 0 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -80 }, LE = { 10, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 16, 0, 10 }, RS = { 80, 0, -10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 10 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -8, 0, 0, 0, -0.26, -0.26 }, Waist = { -6, 0, 0 }, Neck = { 18, 0, 14 }, RS = { 76, 0, -14 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 76, 0, 14 }, LE = { 120, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					hold = 0.2, trail = "bothHands", fx = { { "ring", color = PINK, radius = 5, at = "front" }, { "symbols", symbols = { "♥", "🐰", "♥" }, count = 6, radius = 3, color = PINK } },
					text = "CÂLIN !", hitText = "TROP SERRÉ !",
				},
				-- →L : doudou-boomerang, il lance le lapin à plat qui fauche le couloir… et revient dans ses bras
				S_side = {
					label = "Doudou-boomerang", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 13, kbBase = 28, kbGrowth = 52, kbAngle = 30,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.8, size = 2, color = LAPIN, returns = true,
						visual = { shape = "ball", size = 1.4, color = LAPIN, spin = 10,
							parts = { { "ball", Vector3.new(0.4, 1.1, 0.3), Vector3.new(-0.3, 0.9, 0), LAPIN }, { "ball", Vector3.new(0.4, 1.1, 0.3), Vector3.new(0.3, 0.9, 0), LAPIN }, { "ball", Vector3.new(0.3, 0.2, 0.2), Vector3.new(0, 0, -0.7), PINK } } } },
					windup = { Root = { 6, -36, 0, 0, -0.2, 0.25 }, Waist = { 8, -40, 0 }, Neck = { 6, 24, 0 }, RS = { 170, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -14, 22, 0, 0, -0.32, -0.45 }, Waist = { -16, 26, 0 }, Neck = { -6, -16, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -6, 0, 0, 0, -0.25, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 80, 0, -10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 10 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					hideProp = "doudou", fx = { { "burst", color = LAPIN, size = 2.5, at = "hand" }, { "symbols", symbols = { "🐰", "↩" }, count = 3, radius = 2.5, at = "front", color = PINK } },
					text = "REVIENS !", hitText = "FLAP !",
				},
				-- ↓L : dodo avec doudou, il se couche sur tout le couloir en serrant le lapin et roule d'un côté à l'autre
				S_down = {
					label = "Dodo avec doudou", startup = 0.22, active = 0.2, recovery = 0.5,
					damage = 13, hitbox = box(14, 6, 7, 0.5), kbBase = 30, kbGrowth = 52, kbAngle = 78,
					status = { name = "asleep", duration = 0.6 },
					windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -80, 30, 0, 0, -1.6, -0.3 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, 20 }, RS = { 70, 0, -20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 130, 0, 0 }, RH = { 40, 0, 10 }, RK = { -80, 0, 0 }, LH = { 40, 0, -10 }, LK = { -80, 0, 0 } },
					follow = { Root = { -80, -30, 0, 0, -1.6, -0.3 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, -20 }, RS = { 70, 0, -20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 130, 0, 0 }, RH = { 40, 0, 10 }, RK = { -80, 0, 0 }, LH = { 40, 0, -10 }, LK = { -80, 0, 0 } },
					hold = 0.15, wobble = true, trail = "body", fx = { { "ring", color = TEARS, radius = 6, at = "feet" }, { "symbols", symbols = { "Z", "z", "💤" }, count = 4, radius = 2.5, color = Color3.fromRGB(170, 200, 255) }, { "shake", amount = 0.3 } },
					text = "DODO…", hitText = "ÉCRABOUILLÉ !",
				},
				-- ↑L : doudou-parachute, il tient le lapin à bout de bras au-dessus de sa tête et une bourrasque l'emporte en diagonale
				S_up = {
					label = "Doudou-parachute", startup = 0.15, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 72, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.7, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -36, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 182, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 }, RH = { -20, 0, 8 }, RK = { -40, 0, 0 }, RA = { -25, 0, 0 }, LH = { -30, 0, -8 }, LK = { -50, 0, 0 }, LA = { -25, 0, 0 } },
					follow = { Root = { -40, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 186, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 124, 0, -44 }, LE = { 30, 0, 0 }, RH = { -26, 0, 10 }, RK = { -48, 0, 0 }, RA = { -25, 0, 0 }, LH = { -36, 0, -10 }, LK = { -58, 0, 0 }, LA = { -25, 0, 0 } },
					trail = "prop", fx = { { "ring", color = BLUE, radius = 4, at = "feet" }, { "particles", tex = "smoke", color = Color3.new(1, 1, 1), dir = "up", at = "feet", time = 0.35, speed = 16, size = 0.7, rate = 60 }, { "symbols", symbols = { "🐰", "♥" }, count = 3, radius = 2, color = PINK } },
					text = "ENVOLE-TOI !", hitText = "PLOF !",
				},
				-- L en l'air : il lâche le lapin, qui tombe du ciel pile sur la tête de l'adversaire
				S_air = {
					label = "Doudou lâché", kind = "projectile", startup = 0.16, active = 0, recovery = 0.4,
					damage = 13, kbBase = 26, kbGrowth = 50, kbAngle = -60,
					projectile = { speed = 60, gravity = 60, lifetime = 0.8, size = 2.4, color = LAPIN, rain = { count = 1, spread = 0.5, ahead = 6, height = 18 },
						visual = { shape = "ball", size = 1.6, color = LAPIN, spin = 3, parts = { { "ball", Vector3.new(0.4, 1.1, 0.3), Vector3.new(-0.3, 0.9, 0), LAPIN }, { "ball", Vector3.new(0.4, 1.1, 0.3), Vector3.new(0.3, 0.9, 0), LAPIN } } } },
					windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 176, 0, 14 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					strike = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 140, 0, 40 }, RE = { 10, 0, 0 }, RW = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					follow = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 110, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -20 }, LE = { 120, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					hideProp = "doudou", fx = { { "symbols", symbols = { "🐰", "▼", "😱" }, count = 3, radius = 2, at = "above", color = PINK } }, text = "OUPS !", hitText = "PLOUF !",
				},
				-- Y : câlin colossal, il attire tout le couloir dans ses bras et serre, serre, serre… ça le console énormément
				SUPER = {
					label = "Câlin colossal !", startup = 0.35, active = 0.8, recovery = 0.6,
					damage = 5, hits = 5, pull = true, hitbox = box(14, 6, 7, 1), kbBase = 14, kbGrowth = 18, kbAngle = 70,
					selfEffect = { heal = 10 },
					windup = { Root = { -6, 0, 0, 0, -0.2, 0 }, Waist = { -8, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 100, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -85 }, LE = { 10, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, -0.3, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 12 }, RS = { 80, 0, -14 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 14 }, LE = { 120, 0, 0 } },
					follow = { Root = { -10, 0, 0, 0, -0.3, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, -12 }, RS = { 84, 0, -18 }, RE = { 126, 0, 0 }, RW = { 0, 0, 0 }, LS = { 84, 0, 18 }, LE = { 126, 0, 0 } },
					wobble = true, windupFx = { "super", { "symbols", symbols = { "♥", "🐰" }, count = 6, radius = 3, color = PINK } },
					fx = { { "ring", color = PINK, radius = 7, at = "front" }, { "symbols", symbols = { "♥", "♥", "CÂLIN" }, count = 8, radius = 5, color = PINK }, { "screen", color = PINK, alpha = 0.2 } },
					text = "CÂLIIIIN !", hitText = "J'ÉTOUFFE !",
				},
				-- →Y : doudou géant, il gonfle le lapin comme un matelas pneumatique et le lance : il traverse tout le couloir en endormant tout le monde
				SUPER_side = {
					label = "Doudou géant !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 46, kbGrowth = 94, kbAngle = 30,
					status = { name = "asleep", duration = 1 },
					projectile = { speed = 78, angle = 0, gravity = 0, lifetime = 0.9, size = 3.6, color = LAPIN, pierce = true,
						visual = { shape = "ball", size = 3, color = LAPIN, spin = 4,
							parts = { { "ball", Vector3.new(0.9, 2.4, 0.6), Vector3.new(-0.7, 1.8, 0), LAPIN }, { "ball", Vector3.new(0.9, 2.4, 0.6), Vector3.new(0.7, 1.8, 0), LAPIN }, { "ball", Vector3.new(0.6, 0.4, 0.4), Vector3.new(0, 0, -1.5), PINK } } } },
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 60, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.4, -0.5 }, Waist = { -16, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 96, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -14 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { -20, 0, 0, 0, -0.42, -0.55 }, Waist = { -18, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 16 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -16 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					shake = true, hideProp = "doudou", windupFx = { "super", { "symbols", symbols = { "😤", "💨" }, count = 3, radius = 2, color = CHEEK } },
					fx = { { "burst", color = LAPIN, size = 4, at = "front" }, { "symbols", symbols = { "🐰", "💤" }, count = 5, radius = 3, at = "front", color = PINK }, { "shake", amount = 0.3 } },
					text = "GROS LAPIN !", hitText = "ENDORMI !",
				},
				-- ↑Y : lancer de doudou au plafond, il se jette en l'air après son lapin et tout le couloir monte avec lui
				SUPER_up = {
					label = "Doudou au plafond !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(14, 8, 7, 2), kbBase = 46, kbGrowth = 95, kbAngle = 88, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { 10, 0, 0, 0, -0.85, 0.1 }, Waist = { 16, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 4, 0, 0, 0, 0.5, 0 }, Waist = { 8, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 184, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 184, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 10 }, RK = { -100, 0, 0 }, LH = { 60, 0, -10 }, LK = { -100, 0, 0 } },
					follow = { Root = { 6, 0, 0, 0, 0.55, 0 }, Waist = { 10, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 188, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 188, 0, -12 }, LE = { 0, 0, 0 }, RH = { 70, 0, 12 }, RK = { -110, 0, 0 }, LH = { 70, 0, -12 }, LK = { -110, 0, 0 } },
					hold = 0.2, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🐰", "▲" }, count = 4, radius = 2.5, color = PINK } },
					fx = { { "pillar", color = PINK, height = 22, width = 6, at = "front" }, { "ring", color = BLUE, radius = 7, at = "feet" }, { "burst", color = LAPIN, size = 4, at = "above" } },
					text = "ATTRAPE-LE !", hitText = "AU PLAFOND !",
				},
				-- ↓Y : guili-guili des oreilles, les oreilles du lapin chatouillent tout le couloir jusqu'au fou rire
				SUPER_down = {
					label = "Guili-guili des oreilles !", startup = 0.35, active = 0.8, recovery = 0.6,
					damage = 4, hits = 6, hitbox = box(14, 6, 7, 1), kbBase = 14, kbGrowth = 20, kbAngle = 60,
					status = { name = "laughing", duration = 2 },
					windup = { Root = { 4, 0, 0, 0, -0.2, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 110, 0, 0 } },
					strike = { Root = { -10, 10, 0, 0, -0.35, -0.35 }, Waist = { -12, 12, 0 }, Neck = { 6, -8, 0 }, RS = { 94, 0, 10 }, RE = { 10, 0, 0 }, RW = { 40, 0, 0 }, LS = { 90, 0, -10 }, LE = { 20, 0, 0 }, LW = { -40, 0, 0 } },
					follow = { Root = { -10, -10, 0, 0, -0.35, -0.35 }, Waist = { -12, -12, 0 }, Neck = { 6, 8, 0 }, RS = { 94, 0, -10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 90, 0, 10 }, LE = { 20, 0, 0 }, LW = { 40, 0, 0 } },
					shake = true, wobble = true, trail = "prop", windupFx = { "super" },
					fx = { { "ring", color = YELLOW, radius = 6, at = "front" }, { "symbols", symbols = { "😂", "HIHI", "🐰" }, count = 8, radius = 4, at = "front", color = YELLOW } },
					text = "GUILI-GUILI !", hitText = "HAHAHA, ARRÊTE !",
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
		{ id = "cuillere", name = "Cuillère à purée", icon = "🥄",
			prop = { name = "PropCuillere", hand = "Right", pieces = {
				{ "Manche", "", "cyl", Vector3.new(0.22, 2.4, 0.22), Vector3.new(0, -1.2, 0), Vector3.zero, BLUE, "SmoothPlastic", { axis = "y" } },
				{ "Ailes", "", "block", Vector3.new(1.0, 0.08, 0.3), Vector3.new(0, -0.45, 0), Vector3.zero, YELLOW, "SmoothPlastic" },
				{ "Cuilleron", "", "ball", Vector3.new(1.4, 0.35, 1.0), Vector3.new(0, -2.6, 0), Vector3.zero, METAL, "Metal" },
				{ "Puree", "", "ball", Vector3.new(1.0, 0.5, 0.7), Vector3.new(0, -2.5, 0), Vector3.zero, PUREE, "SmoothPlastic" },
			} },
			ability = { status = { name = "slowed", duration = 2 }, text = "Purée collante : les L ralentissent 2 s" },
			moves = {
				-- J : petite cuillère, un coup sec du cuilleron sur le nez, « une pour papa »
				P_neutral = {
					label = "Une pour papa", startup = 0.08, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(5, 3, 3, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
					windup = { Root = { 2, -14, 0, 0, -0.1, 0.1 }, Waist = { 4, -16, 0 }, Neck = { 4, 10, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 50, 0, 0 } },
					strike = { Root = { -6, 12, 0, 0, -0.2, -0.22 }, Waist = { -8, 14, 0 }, Neck = { 0, -8, 0 }, RS = { 92, 0, 0 }, RE = { 5, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -40 }, LE = { 50, 0, 0 } },
					follow = { Root = { -8, 14, 0, 0, -0.22, -0.26 }, Waist = { -10, 16, 0 }, Neck = { 0, -10, 0 }, RS = { 94, 0, -2 }, RE = { 8, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -40 }, LE = { 50, 0, 0 } },
					trail = "prop", text = "UNE POUR PAPA…", hitText = "TOC !",
				},
				-- →J : une cuillerée catapultée à bout portant, la purée part dans l'œil
				P_side = {
					label = "Cuillerée lancée", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 6, kbBase = 20, kbGrowth = 30, kbAngle = 30,
					projectile = { speed = 65, angle = 8, gravity = 45, lifetime = 0.35, size = 1.2, color = PUREE, aim = false,
						visual = { shape = "ball", size = 1.0, color = PUREE } },
					windup = { Root = { 4, -16, 0, 0, -0.12, 0.15 }, Waist = { 6, -18, 0 }, Neck = { 0, 12, 0 }, RS = { 40, 0, 30 }, RE = { 130, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, 14, 0, 0, -0.24, -0.28 }, Waist = { -8, 16, 0 }, Neck = { 0, -10, 0 }, RS = { 90, 0, 0 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -8, 16, 0, 0, -0.26, -0.32 }, Waist = { -10, 18, 0 }, Neck = { 0, -12, 0 }, RS = { 94, 0, 2 }, RE = { 10, 0, 0 }, RW = { -50, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					hitText = "SPLOTCH !",
				},
				-- ↓J : accroupi, il étale la purée par terre d'un revers de cuillère, ça colle aux semelles
				P_down = {
					label = "Purée par terre", startup = 0.09, active = 0.1, recovery = 0.18,
					damage = 6, hitbox = box(6, 2, 3, -1.5), kbBase = 22, kbGrowth = 28, kbAngle = 70,
					windup = { Root = { 8, -20, 0, 0, -0.8, 0.1 }, Waist = { 14, -20, 0 }, Neck = { 10, 14, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { 12, 20, 0, 0, -0.95, -0.15 }, Waist = { 20, 24, 0 }, Neck = { 6, -14, 0 }, RS = { 30, 0, -20 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 12, 26, 0, 0, -0.95, -0.18 }, Waist = { 20, 30, 0 }, Neck = { 6, -18, 0 }, RS = { 26, 0, -26 }, RE = { 0, 0, 0 }, RW = { -44, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "toss", shape = "ball", color = PUREE, size = 0.5, count = 3, speed = 14 } }, hitText = "SPLATCH !",
				},
				-- ↑J : « l'avion ! » : la cuillère décolle en vrombissant vers le menton d'en face
				P_up = {
					label = "L'avion !", startup = 0.09, active = 0.12, recovery = 0.2,
					damage = 7, hitbox = box(4.5, 5, 1, 3.5), kbBase = 26, kbGrowth = 36, kbAngle = 86,
					windup = { Root = { 6, 0, 0, 0, -0.4, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.1, -0.05 }, Waist = { -12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 176, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.12, 0 }, FL = { 0, 0, 0, 0, 0.12, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.12, -0.06 }, Waist = { -14, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 182, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.14, 0 }, FL = { 0, 0, 0, 0, 0.14, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "✈", "VROUM" }, count = 3, radius = 2, at = "above", color = YELLOW } }, text = "ET L'AVION…", hitText = "ATTERRIT !",
				},
				-- J en l'air : il plante la cuillère sous lui comme un piolet, cuilleron en avant
				P_air = {
					label = "Cuillère plongeante", startup = 0.08, active = 0.1, recovery = 0.16,
					damage = 7, hitbox = box(4.5, 4, 1.5, -1.2), kbBase = 22, kbGrowth = 36, kbAngle = -35,
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 176, 0, 12 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 4 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 24, 0, 6 }, RE = { 6, 0, 0 }, RW = { -30, 0, 0 }, LS = { -26, 0, -50 }, LE = { 20, 0, 0 }, RH = { 12, 0, 0 }, RK = { -34, 0, 0 }, LH = { 24, 0, 0 }, LK = { -54, 0, 0 } },
					trail = "prop", hitText = "PIC !",
				},
				-- dash J : zzzoum, il court en faisant l'avion avec la cuillère, bras tendu, et la plante dans le ventre d'en face
				P_dash = {
					label = "Zzzoum l'avion", startup = 0.08, active = 0.14, recovery = 0.24,
					damage = 8, hitbox = box(5.5, 3, 3, 0.8), kbBase = 26, kbGrowth = 48, kbAngle = 28, selfVelocity = Vector2.new(42, 0),
					windup = { Root = { -6, -10, 0, 0, -0.2, 0.1 }, Waist = { -4, -10, 0 }, Neck = { 6, 8, 0 }, RS = { 60, 0, 40 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 30, 0, 0 } },
					strike = { Root = { -16, 10, 0, 0, -0.3, -0.3 }, Waist = { -8, 8, 0 }, Neck = { 10, -6, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -35 }, LE = { 20, 0, 0 } },
					follow = { Root = { -18, 12, 0, 0, -0.32, -0.35 }, Waist = { -8, 10, 0 }, Neck = { 12, -8, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -44, 0, -38 }, LE = { 20, 0, 0 } },
					trail = "prop", fx = { "dust", { "symbols", symbols = { "✈" }, count = 2, radius = 2, color = YELLOW } }, text = "ZZZOUM !", hitText = "TCHAC !",
				},
				-- K : catapulte à purée, il plie la cuillère en arrière, la relâche et la purée vole en cloche
				K_neutral = {
					label = "Catapulte à purée", kind = "projectile", startup = 0.18, active = 0, recovery = 0.3,
					damage = 10, kbBase = 28, kbGrowth = 55, kbAngle = 35,
					projectile = { speed = 75, angle = 25, gravity = 70, lifetime = 0.5, size = 1.6, color = PUREE, aim = false,
						visual = { shape = "ball", size = 1.3, color = PUREE, parts = { { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.5, 0.3, 0), PUREE } } } },
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 40, 0, 20 }, RE = { 140, 0, 0 }, RW = { 70, 0, 0 }, LS = { 70, 0, -20 }, LE = { 100, 0, 0 }, LW = { 0, 0, 40 } },
					strike = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 10 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 0, 0, 0, -0.32, -0.34 }, Waist = { -16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 130, 0, 12 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					fx = { { "toss", shape = "ball", color = PUREE, size = 0.4, count = 3, speed = 18 } }, text = "BOING !", hitText = "SPLOTCH !",
				},
				-- →K : grand coup de louche, la cuillère tenue à deux mains fauche de côté
				K_side = {
					label = "Grand coup de louche", startup = 0.2, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 32, kbGrowth = 75, kbAngle = 30, selfVelocity = Vector2.new(20, 0),
					windup = { Root = { 4, -44, 0, 0, -0.15, 0.25 }, Waist = { 6, -40, 0 }, Neck = { 0, 30, 0 }, RS = { 70, 0, 70 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 40, 0, 0 } },
					strike = { Root = { -10, 24, 0, 0, -0.32, -0.4 }, Waist = { -12, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -12, 32, 0, 0, -0.34, -0.45 }, Waist = { -14, 38, 0 }, Neck = { -8, -22, 0 }, RS = { 84, 0, -30 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					trail = "prop", hitText = "VLAN !",
				},
				-- ↓K : purée renversée, un tour complet accroupi la cuillère au ras du sol, la purée gicle partout
				K_down = {
					label = "Purée renversée", startup = 0.16, active = 0.16, recovery = 0.3,
					damage = 10, hitbox = box(7, 2, 3.5, -1.5), kbBase = 28, kbGrowth = 58, kbAngle = 75,
					windup = { Root = { 0, -40, 0, 0, -0.9, 0.1 }, Waist = { 0, -30, 0 }, Neck = { 6, 26, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, -1.0, -0.1 }, Waist = { 8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } },
					follow = { Root = { 6, 0, 0, 0, -1.0, -0.1 }, Waist = { 8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", fx = { { "toss", shape = "ball", color = PUREE, size = 0.5, count = 5, speed = 20 }, "dust" }, hitText = "SPLATCH-SPLATCH !",
				},
				-- ↑K : cuillère-fronde, il envoie une boule de purée droit au plafond
				K_up = {
					label = "Cuillère-fronde", kind = "projectile", startup = 0.18, active = 0, recovery = 0.3,
					damage = 11, kbBase = 30, kbGrowth = 62, kbAngle = 86,
					projectile = { speed = 65, angle = 80, gravity = 55, lifetime = 0.5, size = 1.6, color = PUREE, aim = false,
						visual = { shape = "ball", size = 1.3, color = PUREE } },
					windup = { Root = { 8, 0, 0, 0, -0.4, 0.1 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 120, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.1, -0.1 }, Waist = { -12, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 10 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.12, 0 }, FL = { 0, 0, 0, 0, 0.12, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.12, -0.12 }, Waist = { -14, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 184, 0, 12 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 16, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.14, 0 }, FL = { 0, 0, 0, 0, 0.14, 0 } },
					trail = "prop", hitText = "SPLOTCH !",
				},
				-- K en l'air : grand arc de cuillère sous lui, à deux mains, comme une pelle
				K_air = {
					label = "Pelle à purée", startup = 0.14, active = 0.14, recovery = 0.24,
					damage = 11, hitbox = box(5.5, 4, 1.5, -1), kbBase = 28, kbGrowth = 62, kbAngle = -40,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -10 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 6 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -6 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 16, 0, 8 }, RE = { 6, 0, 0 }, RW = { -30, 0, 0 }, LS = { 16, 0, -8 }, LE = { 6, 0, 0 }, LW = { -30, 0, 0 }, RH = { 12, 0, 0 }, RK = { -34, 0, 0 }, LH = { 24, 0, 0 }, LK = { -54, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash K : cuillère-javelot, en courant il lance la cuillère comme un javelot, droit devant
				K_dash = {
					label = "Cuillère-javelot", kind = "projectile", startup = 0.1, active = 0, recovery = 0.3,
					damage = 11, kbBase = 30, kbGrowth = 58, kbAngle = 30, selfVelocity = Vector2.new(30, 0),
					projectile = { speed = 90, angle = 0, gravity = 10, lifetime = 0.4, size = 1.6, color = BLUE, aim = false, pierce = true,
						visual = { shape = "ball", size = 0.8, color = METAL, parts = { { "cyl", Vector3.new(2.2, 0.2, 0.2), Vector3.new(0, 0, 0), BLUE }, { "ball", Vector3.new(0.6, 0.5, 0.9), Vector3.new(1.3, 0, 0), PUREE } } } },
					windup = { Root = { 6, -30, 0, 0, -0.15, 0.2 }, Waist = { 8, -34, 0 }, Neck = { 4, 24, 0 }, RS = { 150, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 40, 0, 0 } },
					strike = { Root = { -12, 20, 0, 0, -0.3, -0.35 }, Waist = { -14, 26, 0 }, Neck = { -4, -14, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -14, 24, 0, 0, -0.32, -0.4 }, Waist = { -16, 30, 0 }, Neck = { -6, -16, 0 }, RS = { 98, 0, 4 }, RE = { 4, 0, 0 }, RW = { 10, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hideProp = "cuillere", fx = { "dust" }, text = "JAVELOT !", hitText = "PLANTÉ !",
				},
				-- L : rafale de purée, trois cuillerées d'affilée qui filent toutes sur l'adversaire
				S_neutral = {
					label = "Rafale de purée", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 5, kbBase = 22, kbGrowth = 38, kbAngle = 30,
					projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.7, size = 1.4, color = PUREE, fan = { count = 3, from = -8, to = 8 },
						visual = { shape = "ball", size = 1.1, color = PUREE } },
					windup = { Root = { 6, -20, 0, 0, -0.2, 0.2 }, Waist = { 8, -24, 0 }, Neck = { 6, 16, 0 }, RS = { 40, 0, 30 }, RE = { 130, 0, 0 }, RW = { 70, 0, 0 }, LS = { 70, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 100, 0, 6 }, RE = { 6, 0, 0 }, RW = { -50, 0, 0 }, LS = { 55, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, fx = { { "burst", color = PUREE, size = 2, at = "hand" } }, text = "ENCORE UNE !", hitText = "SPLOTCH-SPLOTCH !",
				},
				-- →L : « l'avion atterrit ! », la cuillère décolle en vrombissant et vise la bouche de l'adversaire, elle le suit en vol
				S_side = {
					label = "L'avion atterrit !", kind = "projectile", startup = 0.24, active = 0, recovery = 0.48,
					damage = 14, kbBase = 30, kbGrowth = 58, kbAngle = 32,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.9, size = 2, color = BLUE, homing = 0.5,
						visual = { shape = "ball", size = 0.9, color = METAL, spin = 0, parts = { { "cyl", Vector3.new(2.4, 0.22, 0.22), Vector3.new(0, 0, 0), BLUE }, { "block", Vector3.new(0.4, 0.08, 1.6), Vector3.new(-0.6, 0, 0), YELLOW }, { "ball", Vector3.new(0.7, 0.5, 1.0), Vector3.new(1.3, 0, 0), PUREE } } } },
					windup = { Root = { 6, -20, 0, 0, -0.2, 0.2 }, Waist = { 8, -24, 0 }, Neck = { 10, 16, 0 }, RS = { 150, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { -4, -12, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					follow = { Root = { -14, 22, 0, 0, -0.32, -0.4 }, Waist = { -16, 28, 0 }, Neck = { -6, -14, 0 }, RS = { 100, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					hideProp = "cuillere", windupFx = { { "symbols", symbols = { "✈", "VROUUUM" }, count = 3, radius = 2, color = YELLOW } }, fx = { { "beam", color = YELLOW, length = 10, width = 1.5, at = "hand" } },
					text = "OUVRE GRAND !", hitText = "MIAM !",
				},
				-- ↓L : flaque de purée, une grosse cuillerée balancée au sol qui reste collante un moment
				S_down = {
					label = "Flaque de purée", kind = "projectile", startup = 0.22, active = 0, recovery = 0.48,
					damage = 13, kbBase = 26, kbGrowth = 48, kbAngle = 45,
					projectile = { speed = 50, angle = 15, gravity = 50, lifetime = 0.7, size = 2.6, color = PUREE, linger = 2, from = "feet",
						visual = { shape = "ball", size = 2.2, color = PUREE, parts = { { "ball", Vector3.new(1.0, 0.6, 1.0), Vector3.new(0.9, -0.4, 0), PUREE }, { "ball", Vector3.new(0.8, 0.5, 0.8), Vector3.new(-0.8, -0.4, 0.3), PUREE } } } },
					windup = { Root = { 10, 0, 0, 0, -0.5, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.9, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 14, 0, 0, 0, -0.92, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 44, 0, 12 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 44, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "puddle", color = PUREE, width = 6 }, { "toss", shape = "ball", color = PUREE, size = 0.5, count = 4, speed = 16 } }, text = "PAS FAIM !", hitText = "COLLÉ !",
				},
				-- ↑L : assis sur le cuilleron, la cuillère se plie en catapulte et l'envoie en diagonale vers le ciel
				S_up = {
					label = "Catapulté par la cuillère", startup = 0.15, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 72, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 10, 0, 0, 0, -1.0, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { -38, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { 60, 0, 10 }, RK = { -100, 0, 0 }, LH = { 60, 0, -10 }, LK = { -100, 0, 0 } },
					follow = { Root = { -42, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 156, 0, 64 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -64 }, LE = { 10, 0, 0 }, RH = { 66, 0, 12 }, RK = { -106, 0, 0 }, LH = { 66, 0, -12 }, LK = { -106, 0, 0 } },
					trail = "body", fx = { { "ring", color = BLUE, radius = 5, at = "feet" }, { "burst", color = PUREE, size = 3, at = "feet" }, { "symbols", symbols = { "BOING", "🥄" }, count = 3, radius = 2, color = YELLOW } },
					text = "BOING !", hitText = "CATAPULTÉ !",
				},
				-- L en l'air : bombardement de purée, cinq cuillerées lâchées sous lui qui tombent sur l'adversaire
				S_air = {
					label = "Bombardement de purée", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 5, kbBase = 22, kbGrowth = 40, kbAngle = -40,
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.3, color = PUREE, rain = { count = 5, spread = 7 },
						visual = { shape = "ball", size = 1.0, color = PUREE } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 24, 0, 12 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 24, 0, -12 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 18, 0, 14 }, RE = { 4, 0, 0 }, RW = { -60, 0, 0 }, LS = { 18, 0, -14 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					fx = { { "burst", color = PUREE, size = 2, at = "feet" } }, text = "BOMBARDEMENT !", hitText = "SPLOTCH !",
				},
				-- Y : repas complet, entrée, plat, dessert : huit cuillerées en éventail qui filent toutes sur l'adversaire
				SUPER = {
					label = "Repas complet !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.6,
					damage = 4, kbBase = 24, kbGrowth = 40, kbAngle = 40,
					status = { name = "slowed", duration = 2.5 },
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 1.0, size = 1.5, color = PUREE, fan = { count = 8, from = -20, to = 40 },
						visual = { shape = "ball", size = 1.2, color = PUREE, parts = { { "ball", Vector3.new(0.4, 0.4, 0.4), Vector3.new(0.5, 0.3, 0), Color3.fromRGB(120, 200, 90) } } } },
					windup = { Root = { 0, 0, 0, 0, -0.5, 0.1 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -30 }, RE = { 130, 0, 0 }, RW = { 70, 0, 0 }, LS = { 60, 0, 30 }, LE = { 130, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 100, 0, 30 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 100, 0, -30 }, LE = { 0, 0, 0 }, LW = { 0, 0, -40 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 0, 0, 0, -0.32, -0.34 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 104, 0, 34 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 104, 0, -34 }, LE = { 0, 0, 0 }, LW = { 0, 0, -44 }, FL = { 0, 0, 0, 0, 0, -0.44 } },
					shake = true, windupFx = { "super", { "symbols", symbols = { "🥕", "🥦", "🍮" }, count = 6, radius = 3, color = PUREE } },
					fx = { { "burst", color = PUREE, size = 4, at = "hand" }, { "toss", shape = "ball", color = PUREE, size = 0.6, count = 6, speed = 24 }, { "shake", amount = 0.3 } },
					text = "ENTRÉE, PLAT, DESSERT !", hitText = "TROP MANGÉ !",
				},
				-- →Y : purée géante, toute la casserole sur la cuillère, une boule de purée grosse comme lui traverse le couloir
				SUPER_side = {
					label = "Purée géante !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 44, kbGrowth = 92, kbAngle = 28,
					status = { name = "slowed", duration = 3 },
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 0.9, size = 3.4, color = PUREE, pierce = true,
						visual = { shape = "ball", size = 3, color = PUREE, spin = 3, parts = { { "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(1.2, 0.8, 0), PUREE }, { "ball", Vector3.new(1.0, 1.0, 1.0), Vector3.new(-1.0, -0.6, 0.6), PUREE } } } },
					windup = { Root = { 12, 0, 0, 0, -0.5, 0.3 }, Waist = { 18, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 150, 0, 20 }, RE = { 60, 0, 0 }, RW = { 70, 0, 0 }, LS = { 150, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.4, -0.5 }, Waist = { -16, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 96, 0, 14 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 96, 0, -14 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					follow = { Root = { -20, 0, 0, 0, -0.42, -0.55 }, Waist = { -18, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 16 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 100, 0, -16 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					shake = true, hideProp = "cuillere", windupFx = { "super", { "symbols", symbols = { "🥄", "🍲" }, count = 5, radius = 3, color = PUREE } },
					fx = { { "burst", color = PUREE, size = 4.5, at = "front" }, { "shake", amount = 0.4 } },
					text = "TOUTE LA CASSEROLE !", hitText = "ENGLUÉ !",
				},
				-- ↑Y : geyser de purée, il plante la cuillère dans le sol et un geyser de purée emporte tout le couloir au plafond
				SUPER_up = {
					label = "Geyser de purée !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(14, 8, 7, 2), kbBase = 46, kbGrowth = 95, kbAngle = 88, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { 14, 0, 0, 0, -0.9, 0.1 }, Waist = { 24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 40, 0, -10 }, LE = { 10, 0, 0 } },
					strike = { Root = { 4, 0, 0, 0, 0.5, 0 }, Waist = { 8, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 150, 0, 70 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -70 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 6, 0, 0, 0, 0.55, 0 }, Waist = { 10, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 156, 0, 74 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -74 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, windupFx = { "super" },
					fx = { { "pillar", color = PUREE, height = 22, width = 4, at = "front" }, { "beam", color = PUREE, length = 16, width = 5, at = "feet" }, { "burst", color = PUREE, size = 4, at = "above" }, { "ring", color = BLUE, radius = 6, at = "feet" } },
					text = "GEYSER !", hitText = "PURÉE AU PLAFOND !",
				},
				-- ↓Y : la grande tartine, il étale la purée sur tout le couloir d'un seul coup de cuillère, c'est glissant
				SUPER_down = {
					label = "La Grande Tartine !", startup = 0.35, active = 0.35, recovery = 0.7,
					damage = 22, hitbox = box(14, 4, 7, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 60,
					status = { name = "slippery", duration = 2 },
					windup = { Root = { 10, -40, 0, 0, -0.8, 0.2 }, Waist = { 16, -36, 0 }, Neck = { 10, 30, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
					strike = { Root = { 16, 20, 0, 0, -1.0, -0.3 }, Waist = { 28, 24, 0 }, Neck = { 6, -14, 0 }, RS = { 30, 0, -20 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -30 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 18, 30, 0, 0, -1.0, -0.34 }, Waist = { 30, 34, 0 }, Neck = { 8, -20, 0 }, RS = { 24, 0, -30 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 30, 0, -30 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.15, trail = "prop", windupFx = { "super" },
					fx = { { "puddle", color = PUREE, width = 16, time = 2 }, { "beam", color = PUREE, length = 16, width = 3, at = "feet" }, { "toss", shape = "ball", color = PUREE, size = 0.8, count = 6, speed = 22 }, { "shake", amount = 0.4 } },
					text = "TARTINÉ !", hitText = "ÉTALÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_side = { P = "P_neutral", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

	look = {
		body = {
			head = SKIN, upper = SKIN, lower = DIAPER, arms = SKIN, forearms = SKIN,
			hands = SKIN, legs = SKIN, feet = SKIN,
		},
		cubeHead = 1.4,
		parts = {
			-- bonnet à oreilles d'ours
			{ "Bonnet", "Head", "ball", Vector3.new(1.6, 1.0, 1.6), Vector3.new(0, 0.55, 0.05), Vector3.zero, BONNET, "Fabric" },
			{ "OreilleG", "Head", "ball", Vector3.new(0.6, 0.6, 0.28), Vector3.new(-0.58, 1.05, 0), Vector3.zero, BONNET, "Fabric" },
			{ "OreilleD", "Head", "ball", Vector3.new(0.6, 0.6, 0.28), Vector3.new(0.58, 1.05, 0), Vector3.zero, BONNET, "Fabric" },
			{ "OreilleIntG", "Head", "ball", Vector3.new(0.35, 0.35, 0.1), Vector3.new(-0.58, 1.05, -0.12), Vector3.zero, EAR_IN, "Fabric" },
			{ "OreilleIntD", "Head", "ball", Vector3.new(0.35, 0.35, 0.1), Vector3.new(0.58, 1.05, -0.12), Vector3.zero, EAR_IN, "Fabric" },
			{ "Meche", "Head", "ball", Vector3.new(0.28, 0.22, 0.15), Vector3.new(0.05, 0.42, -0.68), Vector3.new(0, 0, 25), Color3.fromRGB(150, 100, 60), "SmoothPlastic" },
			-- grands yeux brillants, joues roses et tétine
			{ "OeilG", "Head", "ball", Vector3.new(0.26, 0.3, 0.1), Vector3.new(-0.3, 0.1, -0.71), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.26, 0.3, 0.1), Vector3.new(0.3, 0.1, -0.71), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "RefletG", "Head", "ball", Vector3.new(0.08, 0.08, 0.04), Vector3.new(-0.26, 0.17, -0.76), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
			{ "RefletD", "Head", "ball", Vector3.new(0.08, 0.08, 0.04), Vector3.new(0.34, 0.17, -0.76), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
			{ "JoueG", "Head", "ball", Vector3.new(0.32, 0.22, 0.06), Vector3.new(-0.5, -0.2, -0.7), Vector3.zero, CHEEK, "SmoothPlastic", { transparency = 0.25 } },
			{ "JoueD", "Head", "ball", Vector3.new(0.32, 0.22, 0.06), Vector3.new(0.5, -0.2, -0.7), Vector3.zero, CHEEK, "SmoothPlastic", { transparency = 0.25 } },
			{ "Tetine", "Head", "ball", Vector3.new(0.7, 0.42, 0.14), Vector3.new(0, -0.36, -0.76), Vector3.zero, PINK, "SmoothPlastic" },
			{ "AnneauTetine", "Head", "cyl", Vector3.new(0.08, 0.4, 0.4), Vector3.new(0, -0.36, -0.86), Vector3.zero, YELLOW, "SmoothPlastic", { axis = "z" } },
			-- gros ventre et nombril
			{ "Bedon", "UpperTorso", "ball", Vector3.new(1.9, 1.5, 1.2), Vector3.new(0, -0.25, -0.15), Vector3.zero, SKIN, "SmoothPlastic" },
			{ "Nombril", "UpperTorso", "ball", Vector3.new(0.14, 0.14, 0.05), Vector3.new(0, -0.35, -0.75), Vector3.zero, Color3.fromRGB(220, 160, 140), "SmoothPlastic" },
			-- couche bien rembourrée, épingle à nourrice et scratch
			{ "Couche", "LowerTorso", "ball", Vector3.new(2.5, 1.5, 1.7), Vector3.new(0, -0.25, 0), Vector3.zero, DIAPER, "Fabric" },
			{ "Epingle", "LowerTorso", "block", Vector3.new(0.4, 0.1, 0.06), Vector3.new(0.75, 0.05, -0.82), Vector3.new(0, 0, 15), BLUE, "SmoothPlastic" },
			{ "Scratch", "LowerTorso", "block", Vector3.new(0.35, 0.3, 0.05), Vector3.new(-0.75, 0.05, -0.82), Vector3.zero, YELLOW, "SmoothPlastic" },
			-- bourrelets de bébé aux poignets
			{ "BourreletG", "LeftLowerArm", "cyl", Vector3.new(0.25, 1.1, 1.1), Vector3.new(0, -0.35, 0), Vector3.zero, SKIN, "SmoothPlastic" },
			{ "BourreletD", "RightLowerArm", "cyl", Vector3.new(0.25, 1.1, 1.1), Vector3.new(0, -0.35, 0), Vector3.zero, SKIN, "SmoothPlastic" },
		},
		props = {
			-- l'arme de la caisse : le hochet géant
			{ name = "PropHochet", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.4, 0.3, 0.3), Vector3.new(0, -0.7, 0), Vector3.zero, PINK, "SmoothPlastic" },
				{ "Boule", "", "ball", Vector3.new(1.7, 1.7, 1.7), Vector3.new(0, -2.1, 0), Vector3.zero, YELLOW, "SmoothPlastic" },
				{ "Anneau", "", "cyl", Vector3.new(0.22, 2.1, 2.1), Vector3.new(0, -2.1, 0), Vector3.zero, BLUE, "SmoothPlastic", { axis = "z", transparency = 0.2 } },
				{ "Grelot1", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(0.85, -2.1, 0), Vector3.zero, PINK, "SmoothPlastic" },
				{ "Grelot2", "", "ball", Vector3.new(0.45, 0.45, 0.45), Vector3.new(-0.85, -2.1, 0), Vector3.zero, Color3.fromRGB(120, 210, 120), "SmoothPlastic" },
			} },
			-- accessoires ponctuels
			{ name = "PropBiberon", hand = "Right", visible = false, pieces = {
				{ "Flacon", "", "cyl", Vector3.new(1.5, 0.7, 0.7), Vector3.new(0, -0.6, 0), Vector3.zero, Color3.new(1, 1, 1), "Glass", { transparency = 0.35 } },
				{ "Lait", "", "cyl", Vector3.new(1.1, 0.6, 0.6), Vector3.new(0, -0.45, 0), Vector3.zero, MILK, "SmoothPlastic" },
				{ "Bague", "", "cyl", Vector3.new(0.2, 0.75, 0.75), Vector3.new(0, -1.4, 0), Vector3.zero, BLUE, "SmoothPlastic" },
				{ "TetineBib", "", "ball", Vector3.new(0.35, 0.5, 0.35), Vector3.new(0, -1.7, 0), Vector3.zero, Color3.fromRGB(240, 190, 120), "SmoothPlastic" },
			} },
			{ name = "PropPuree", hand = "Left", visible = false, pieces = {
				{ "Bol", "", "ball", Vector3.new(1.4, 0.6, 1.4), Vector3.new(0, -0.45, -0.2), Vector3.zero, BLUE, "SmoothPlastic" },
				{ "Puree", "", "ball", Vector3.new(1.2, 0.5, 1.2), Vector3.new(0, -0.25, -0.2), Vector3.zero, PUREE, "SmoothPlastic" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Hochet maladroit : il secoue le hochet au-dessus de sa tête et l'abat de travers, le corps suit tout seul
		P_neutral = {
			label = "Hochet maladroit", startup = 0.08, active = 0.08, recovery = 0.16,
			damage = 6, hitbox = box(4.5, 3.5, 2.6, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { 4, -10, -6, 0, -0.1, 0.1 }, Waist = { 6, -10, -6 }, Neck = { 10, 0, 8 }, RS = { 160, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, 12, 6, 0, -0.2, -0.2 }, Waist = { -10, 14, 6 }, Neck = { -6, 0, -6 }, RS = { 85, 0, -10 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { -8, 16, 8, 0, -0.22, -0.22 }, Waist = { -12, 18, 8 }, Neck = { -8, 0, -8 }, RS = { 60, 0, -20 }, RE = { 15, 0, 0 }, RW = { -40, 0, 0 }, LS = { 55, 0, -65 }, LE = { 30, 0, 0 } },
			trail = "prop", hitText = "GLING !",
		},
		-- Hochet retour : le hochet revient de l'autre côté, en revers, bébé manque de tomber (suite de P)
		P_combo2 = {
			label = "Hochet retour", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(5, 4, 3, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 32,
			windup = { Root = { -4, 25, 6, 0, -0.2, -0.1 }, Waist = { -6, 25, 6 }, Neck = { 0, -10, -6 }, RS = { 80, 0, -50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 20, 0, 0 } },
			strike = { Root = { -6, -15, -6, 0, -0.22, -0.2 }, Waist = { -8, -20, -6 }, Neck = { 0, 10, 6 }, RS = { 90, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 30, 0, 0 } },
			follow = { Root = { -8, -22, -8, 0, -0.25, -0.24 }, Waist = { -10, -26, -8 }, Neck = { 0, 14, 8 }, RS = { 85, 0, 65 }, RE = { 15, 0, 0 }, RW = { -20, 0, 0 }, LS = { 25, 0, -40 }, LE = { 30, 0, 0 } },
			trail = "prop", hitText = "GLANG !",
		},
		-- P P P P : Gros hochet, il lève le hochet à deux mains en tirant la langue et l'abat de tout son poids de bébé (finition)
		P_combo3 = {
			label = "Gros hochet", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 78, kbAngle = 50,
			windup = { Root = { 12, 0, 0, 0, 0.05, 0.25 }, Waist = { 16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 195, 0, 5 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -5 }, LE = { 50, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 75, 0, 0 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 75, 0, 10 }, LE = { 10, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.6, -0.45 }, Waist = { -34, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 0 }, RE = { 0, 0, 0 }, RW = { -45, 0, 0 }, LS = { 50, 0, 10 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { { "ring", color = YELLOW, radius = 4, at = "front" }, { "shake", amount = 0.3 } }, text = "AREUH !", hitText = "BADING !",
		},
		-- Coup de couche : il se retourne et donne un violent coup de fesses rembourrées vers l'avant
		P_side = {
			label = "Coup de couche", startup = 0.12, active = 0.1, recovery = 0.22,
			damage = 9, hitbox = box(4.5, 3, 2.4, -0.4), kbBase = 26, kbGrowth = 40, kbAngle = 25, selfVelocity = Vector2.new(24, 0),
			windup = { Root = { -6, 60, 0, 0, -0.25, 0.1 }, Waist = { -8, 20, 0 }, Neck = { 0, -40, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 40, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -22, 170, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 } },
			follow = { Root = { -26, 175, 0, 0, -0.5, 0 }, Waist = { -12, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 70, 0, 65 }, RE = { 20, 0, 0 }, LS = { 70, 0, -65 }, LE = { 20, 0, 0 } },
			trail = "body", fx = { { "burst", color = DIAPER, size = 3, at = "front" } }, text = "POUF !", hitText = "PROUT !",
		},
		-- Roulade à quatre pattes : il plonge en boule sous les coups et roule dans les jambes (esquive basse et frappe)
		P_down = {
			label = "Roulade à quatre pattes", startup = 0.08, active = 0.14, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 2.5, 2, -1.5), kbBase = 24, kbGrowth = 25, kbAngle = 68, selfVelocity = Vector2.new(30, 0), invuln = 0.12,
			windup = { Root = { -30, 0, 0, 0, -0.8, 0 }, Waist = { -30, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, LS = { 120, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -1.3, -0.3 }, Waist = { -40, 0, 0 }, Neck = { -35, 0, 0 }, RS = { 60, 0, 20 }, RE = { 120, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 }, RH = { 120, 0, 0 }, RK = { -140, 0, 0 }, LH = { 120, 0, 0 }, LK = { -140, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -1.2, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 70, 0, 20 }, RE = { 110, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			spin = { axis = "x", degrees = 360 }, trail = "body", fx = { "dust" }, hitText = "ROULI-ROULA !",
		},
		-- Tétine-ressort (anti-air) : accroupi, il se détend d'un coup tête en l'air, tétine pointée vers le ciel
		P_up = {
			label = "Tétine-ressort", startup = 0.09, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 5, 1, 3.6), kbBase = 26, kbGrowth = 32, kbAngle = 86,
			windup = { Root = { -6, 0, 0, 0, -0.75, 0 }, Waist = { -20, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.35, 0 }, Waist = { 14, 0, 0 }, Neck = { 45, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.4, 0 }, Waist = { 16, 0, 0 }, Neck = { 50, 0, 0 }, RS = { -35, 0, 55 }, RE = { 20, 0, 0 }, LS = { -35, 0, -55 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			trail = "head", hitText = "TCHOUP !",
		},
		-- Coup de tétine : en l'air, il fonce la tétine la première, bras et jambes ballants
		P_air = {
			label = "Coup de tétine", startup = 0.08, active = 0.1, recovery = 0.16,
			damage = 7, hitbox = box(4, 3.5, 2.2, 0.8), kbBase = 22, kbGrowth = 32, kbAngle = 35,
			windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 30, 0, -50 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -50, 0, 0 } },
			strike = { Root = { -25, 0, 0 }, Waist = { -15, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -20, 0, 60 }, RE = { 30, 0, 0 }, LS = { -20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 10, 0, 10 }, RK = { -40, 0, 0 }, LH = { 0, 0, -10 }, LK = { -50, 0, 0 } },
			follow = { Root = { -28, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { -25, 0, 62 }, RE = { 30, 0, 0 }, LS = { -25, 0, -62 }, LE = { 30, 0, 0 }, RH = { 5, 0, 12 }, RK = { -40, 0, 0 }, LH = { -5, 0, -12 }, LK = { -50, 0, 0 } },
			trail = "head", hitText = "SUÇOTE !",
		},
		-- Pincement (dash puis P) : il arrive en trottinant et pince les deux joues de l'adversaire en tirant fort
		P_dash = {
			label = "Pincement", startup = 0.08, active = 0.14, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 3.5, 2.4, 1), kbBase = 26, kbGrowth = 48, kbAngle = 30, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -8, 0, 0, 0, -0.2, 0 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 50 }, RE = { 60, 0, 0 }, LS = { 70, 0, -50 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 100, 0, -8 }, RE = { 20, 0, 0 }, LS = { 100, 0, 8 }, LE = { 20, 0, 0 }, LW = { 0, 0, 30 } },
			follow = { Root = { 10, 0, 0, 0, -0.3, -0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 95, 0, 20 }, RE = { 50, 0, 0 }, LS = { 95, 0, -20 }, LE = { 50, 0, 0 }, LW = { 0, 0, 30 } },
			fx = { "dust" }, text = "GUILI-GUILI !", hitText = "AÏE MES JOUES !",
		},

		-- Petit pied potelé : il lève la jambe tout droit devant, les bras en moulinet pour ne pas tomber, et la jambe
		-- claque à plat comme une palme ; il part en arrière sur la lancée, les bras qui pédalent
		K_neutral = {
			label = "Petit pied potelé", startup = 0.19, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3.5, 3, 0.2), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 6, 0, -6, 0, -0.2, 0.15 }, Waist = { 8, 0, -8 }, Neck = { 10, 0, 10 }, RS = { 120, 0, 80 }, RE = { 20, 0, 0 }, LS = { 120, 0, -80 }, LE = { 20, 0, 0 }, RH = { 40, 0, 10 }, RK = { -30, 0, 0 }, RA = { 20, 0, 0 } },
			strike = { Root = { 22, 0, 6, 0, -0.1, 0.1 }, Waist = { 14, 0, 6 }, Neck = { 18, 0, -8 }, RS = { -60, 0, 70 }, RE = { 30, 0, 0 }, LS = { -60, 0, -70 }, LE = { 30, 0, 0 }, RH = { 100, 0, 10 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
			follow = { Root = { 30, 0, 8, 0, -0.1, 0.25 }, Waist = { 18, 0, 8 }, Neck = { 22, 0, -10 }, RS = { -80, 0, 60 }, RE = { 60, 0, 0 }, LS = { -40, 0, -80 }, LE = { 20, 0, 0 }, RH = { 104, 0, 12 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 } },
			shake = true, trail = "rightFoot", fx = { { "symbols", symbols = { "!", "?" }, count = 2, radius = 1.5, at = "head", color = YELLOW } }, text = "HOU-LÀ !", hitText = "PATAPON !",
		},
		-- Gifle de bébé : la grosse main gauche s'ouvre et part en grand arc, tout le corps tourne avec
		K_side = {
			label = "Gifle de bébé", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 13, hitbox = box(5, 4, 3, 1), kbBase = 32, kbGrowth = 82, kbAngle = 30, selfVelocity = Vector2.new(25, 0),
			windup = { Root = { 6, 40, 0, 0, -0.2, 0.25 }, Waist = { 8, 35, 0 }, Neck = { 6, -25, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 100, 0, -110 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 } },
			strike = { Root = { -12, -25, 0, 0, -0.35, -0.4 }, Waist = { -14, -30, 0 }, Neck = { -6, 20, 0 }, RS = { 20, 0, 50 }, RE = { 40, 0, 0 }, LS = { 95, 0, 20 }, LE = { 5, 0, 0 }, LW = { 0, 0, 30 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, -40, 0, 0, -0.38, -0.45 }, Waist = { -16, -42, 0 }, Neck = { -8, 28, 0 }, RS = { 15, 0, 55 }, RE = { 40, 0, 0 }, LS = { 85, 0, 50 }, LE = { 10, 0, 0 }, LW = { 0, 0, 30 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "leftHand", text = "NA !", hitText = "PAF BÉBÉ !",
		},
		-- Assis par terre : il se laisse tomber sur les fesses de tout son poids, le sol tremble autour (encaisse sans broncher)
		K_down = {
			label = "Assis par terre", startup = 0.18, active = 0.12, recovery = 0.35,
			damage = 11, hitbox = box(8, 2.2, 0.5, -2), kbBase = 30, kbGrowth = 60, kbAngle = 75, armor = true,
			windup = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 120, 0, 40 }, RE = { 20, 0, 0 }, LS = { 120, 0, -40 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 10, 0, 0, 0, -1.5, 0.2 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 85, 0, 10 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { 85, 0, -10 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -1.5, 0.2 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 45, 0, 65 }, RE = { 20, 0, 0 }, LS = { 45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 80, 0, 15 }, RK = { -10, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, -15 }, LK = { -10, 0, 0 }, LA = { 10, 0, 0 } },
			fx = { { "ring", color = DIAPER, radius = 5, at = "feet" }, { "shake", amount = 0.4 }, "dust" }, text = "POUF !", hitText = "BOUM-BOUM !",
		},
		-- Porte-moi ! (anti-air) : il sautille sur place genoux repliés, les deux bras tendus au ciel pour qu'on le prenne,
		-- et c'est son bonnet à oreilles qui cogne tout ce qui passe au-dessus
		K_up = {
			label = "Porte-moi !", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 5, 0.8, 3.5), kbBase = 34, kbGrowth = 74, kbAngle = 88, selfVelocity = Vector2.new(0, 28),
			windup = { Root = { -4, 0, 0, 0, -0.55, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 30 }, RE = { 60, 0, 0 }, LS = { 120, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 178, 0, 12 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 5, 0, 0 }, RH = { 70, 0, 10 }, RK = { -110, 0, 0 }, LH = { 70, 0, -10 }, LK = { -110, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.55, 0 }, Waist = { 12, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 182, 0, 18 }, RE = { 8, 0, 0 }, RW = { 0, 0, 0 }, LS = { 182, 0, -18 }, LE = { 8, 0, 0 }, RH = { 80, 0, 12 }, RK = { -120, 0, 0 }, LH = { 80, 0, -12 }, LK = { -120, 0, 0 } },
			trail = "head", fx = { { "symbols", symbols = { "🧸", "♥" }, count = 3, radius = 2, at = "above", color = PINK } }, text = "PORTE-MOI !", hitText = "HOPLA !",
		},
		-- Plat ventre : en l'air, il s'étale à plat ventre bras et jambes en étoile sur l'adversaire
		K_air = {
			label = "Plat ventre", startup = 0.16, active = 0.14, recovery = 0.28,
			damage = 11, hitbox = box(5.5, 3.5, 1.8, -0.5), kbBase = 30, kbGrowth = 68, kbAngle = 30,
			windup = { Root = { 15, 0, 0 }, Waist = { 15, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -70, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 60 }, RE = { 10, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { -10, 0, 25 }, RK = { -10, 0, 0 }, LH = { -10, 0, -25 }, LK = { -10, 0, 0 } },
			follow = { Root = { -75, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 155, 0, 65 }, RE = { 10, 0, 0 }, LS = { 155, 0, -65 }, LE = { 10, 0, 0 }, RH = { -12, 0, 28 }, RK = { -12, 0, 0 }, LH = { -12, 0, -28 }, LK = { -12, 0, 0 } },
			trail = "body", hitText = "SPLATCH !",
		},
		-- Petit pied gauche : l'autre pied potelé tape à son tour en tapant du talon (suite de K)
		K_combo2 = {
			label = "Petit pied gauche", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 4, 3, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 32,
			windup = { Root = { 10, 0, 8, 0, -0.1, 0.15 }, Waist = { 12, 0, 6 }, Neck = { 10, 0, -8 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, LH = { 95, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 16, 0, -4, 0, -0.1, 0 }, Waist = { 16, 0, -4 }, Neck = { 14, 0, 4 }, RS = { 40, 0, 70 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, LH = { 95, 0, 0 }, LK = { -5, 0, 0 }, LA = { 25, 0, 0 } },
			follow = { Root = { 18, 0, -6, 0, -0.1, 0.05 }, Waist = { 18, 0, -6 }, Neck = { 16, 0, 6 }, RS = { 35, 0, 75 }, RE = { 20, 0, 0 }, LS = { 35, 0, -75 }, LE = { 20, 0, 0 }, LH = { 100, 0, 0 }, LK = { 0, 0, 0 }, LA = { 25, 0, 0 } },
			trail = "leftFoot", hitText = "PATAPAN !",
		},
		-- K K K K : Coup de pied colère, il saute en tapant des deux pieds en l'air comme un bébé en pleine crise (finition)
		K_combo3 = {
			label = "Coup de pied colère", startup = 0.1, active = 0.14, recovery = 0.3,
			damage = 12, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 36, kbGrowth = 82, kbAngle = 40, selfVelocity = Vector2.new(12, 38),
			windup = { Root = { -8, 0, 0, 0, -0.65, 0.1 }, Waist = { -14, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 140, 0, 40 }, RE = { 60, 0, 0 }, LS = { 140, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 25, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 60 }, RE = { 30, 0, 0 }, LS = { 160, 0, -60 }, LE = { 30, 0, 0 }, RH = { 90, 0, 8 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 80, 0, -8 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 165, 0, 65 }, RE = { 30, 0, 0 }, LS = { 165, 0, -65 }, LE = { 30, 0, 0 }, RH = { 100, 0, 10 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 90, 0, -10 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", text = "OUIIIN !", hitText = "BAM BAM !",
		},
		-- Bébé bulldozer (dash puis K) : il se jette à plat ventre et glisse sur le bedon comme sur une luge
		K_dash = {
			label = "Bébé bulldozer", startup = 0.1, active = 0.25, recovery = 0.32,
			damage = 11, hitbox = box(6, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 62, kbAngle = 45, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { -20, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 50, 0, 0 }, LS = { 40, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { -75, 0, 0, 0, -1.6, -0.3 }, Waist = { -5, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 165, 0, 20 }, RE = { 10, 0, 0 }, LS = { 165, 0, -20 }, LE = { 10, 0, 0 }, RH = { -10, 0, 10 }, RK = { -20, 0, 0 }, LH = { -10, 0, -10 }, LK = { -20, 0, 0 } },
			follow = { Root = { -78, 0, 0, 0, -1.65, -0.35 }, Waist = { -6, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 170, 0, 25 }, RE = { 10, 0, 0 }, LS = { 170, 0, -25 }, LE = { 10, 0, 0 }, RH = { -12, 0, 12 }, RK = { -25, 0, 0 }, LH = { -12, 0, -12 }, LK = { -25, 0, 0 } },
			trail = "body", fx = { "dust" }, text = "VROUM !", hitText = "BOULDOZÉ !",
		},
		-- P puis K : Coup de genou potelé, petit genou qui remonte dans le ventre
		PK_combo = {
			label = "Genou potelé", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.5), kbBase = 22, kbGrowth = 32, kbAngle = 45,
			windup = { Root = { 4, 0, 0, 0, -0.15, 0.1 }, Waist = { 6, 0, 0 }, RS = { 50, 0, 40 }, RE = { 40, 0, 0 }, LS = { 50, 0, -40 }, LE = { 40, 0, 0 }, RH = { -15, 0, 0 }, RK = { -50, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, 0.05, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 20, 0, 50 }, RE = { 50, 0, 0 }, LS = { 20, 0, -50 }, LE = { 50, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, 0.08, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 15, 0, 52 }, RE = { 50, 0, 0 }, LS = { 15, 0, -52 }, LE = { 50, 0, 0 }, RH = { 108, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 } },
			trail = "rightLeg", hitText = "POC !",
		},
		-- K puis P : Tape-tape, il tape deux fois à deux mains comme sur un tambour
		KP_combo = {
			label = "Tape-tape", startup = 0.08, active = 0.14, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5, 4, 3, 0.8), kbBase = 20, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 15 }, RE = { 60, 0, 0 }, LS = { 150, 0, -15 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 10 }, RE = { 20, 0, 0 }, LS = { 80, 0, -10 }, LE = { 20, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -0.25, -0.25 }, Waist = { -10, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 120, 0, 10 }, RE = { 50, 0, 0 }, LS = { 120, 0, -10 }, LE = { 50, 0, 0 } },
			wobble = true, trail = "bothHands", hitText = "TAPE TAPE !",
		},

		-- P P P : Secouage de hochet, il agite le hochet sous le nez d'en face, grelots en folie, deux coups
		P_grelot = {
			label = "Secouage de hochet", startup = 0.06, active = 0.14, recovery = 0.18,
			damage = 3, hits = 2, hitbox = box(5, 4, 3, 1), kbBase = 18, kbGrowth = 22, kbAngle = 40,
			windup = { Root = { 2, 0, 0, 0, -0.15, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, 20 }, RE = { 90, 0, 0 }, RW = { 20, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.25, -0.3 }, Waist = { -8, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 100, 0, 0 }, RE = { 30, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -0.25, -0.3 }, Waist = { -8, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 100, 0, 0 }, RE = { 50, 0, 0 }, RW = { 20, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 } },
			shake = true, wobble = true, trail = "prop", fx = { { "symbols", symbols = { "🔔", "♪" }, count = 4, radius = 2.5, at = "front", color = YELLOW } }, text = "AREUH-REUH !", hitText = "GLING-GLING !",
		},
		-- → P P : Couche rebond, il retombe sur les fesses et rebondit sur sa couche comme sur un ballon, couche en avant
		P_couche2 = {
			label = "Couche rebond", startup = 0.08, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.6), kbBase = 20, kbGrowth = 28, kbAngle = 45, selfVelocity = Vector2.new(20, 22),
			windup = { Root = { 8, 0, 0, 0, -0.9, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 50 }, RE = { 40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 80, 0, 15 }, RK = { -40, 0, 0 }, LH = { 80, 0, -15 }, LK = { -40, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.2, -0.3 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 140, 0, 50 }, RE = { 20, 0, 0 }, LS = { 140, 0, -50 }, LE = { 20, 0, 0 }, RH = { 90, 0, 20 }, RK = { -20, 0, 0 }, LH = { 90, 0, -20 }, LK = { -20, 0, 0 } },
			follow = { Root = { 34, 0, 0, 0, -0.15, -0.35 }, Waist = { 12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 150, 0, 55 }, RE = { 20, 0, 0 }, LS = { 150, 0, -55 }, LE = { 20, 0, 0 }, RH = { 95, 0, 22 }, RK = { -15, 0, 0 }, LH = { 95, 0, -22 }, LK = { -15, 0, 0 } },
			trail = "body", fx = { { "burst", color = DIAPER, size = 3, at = "feet" } }, text = "BOING !", hitText = "PLOF !",
		},
		-- → P P P : Prout propulseur, un pet de bébé le propulse couche en avant jusqu'au bout de l'arène (finition)
		P_couche3 = {
			label = "Prout propulseur", startup = 0.1, active = 0.16, recovery = 0.32,
			damage = 11, hitbox = box(5.5, 4.5, 3.2, 0.6), kbBase = 36, kbGrowth = 76, kbAngle = 22, selfVelocity = Vector2.new(48, 6),
			windup = { Root = { -10, 40, 0, 0, -0.4, 0.1 }, Waist = { -8, 10, 0 }, Neck = { 20, -30, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -24, 172, 0, 0, -0.5, -0.1 }, Waist = { -8, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 80, 0, 70 }, RE = { 20, 0, 0 }, LS = { 80, 0, -70 }, LE = { 20, 0, 0 } },
			follow = { Root = { -28, 176, 0, 0, -0.55, -0.15 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 90, 0, 75 }, RE = { 20, 0, 0 }, LS = { 90, 0, -75 }, LE = { 20, 0, 0 } },
			shake = true, trail = "body", windupFx = { { "symbols", symbols = { "😳" }, count = 1, radius = 1.5, color = CHEEK } }, fx = { { "burst", color = Color3.fromRGB(190, 220, 120), size = 4, at = "root" }, { "particles", tex = "smoke", color = Color3.fromRGB(190, 220, 120), dir = "front", at = "root", time = 0.35, speed = 20, size = 1 } }, text = "PROUUUUT !", hitText = "ASPHYXIÉ !",
		},
		-- ↓ P P : Galop à quatre pattes, il galope tête baissée et donne deux coups de tête dans les tibias
		P_galop = {
			label = "Galop à quatre pattes", startup = 0.07, active = 0.16, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5, 4, 3, 0.5), kbBase = 18, kbGrowth = 24, kbAngle = 45, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { -50, 0, 0, 0, -1.0, 0 }, Waist = { -20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 100, 0, 15 }, RE = { 10, 0, 0 }, LS = { 60, 0, -15 }, LE = { 20, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -62, 0, 0, 0, -1.1, -0.3 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 15 }, RE = { 10, 0, 0 }, LS = { 110, 0, -15 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { -62, 0, 0, 0, -1.1, -0.35 }, Waist = { -10, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 110, 0, 15 }, RE = { 10, 0, 0 }, LS = { 60, 0, -15 }, LE = { 10, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			wobble = true, trail = "head", fx = { "dust" }, text = "DADA !", hitText = "TONK-TONK !",
		},
		-- ↓ P P P : Gros bisou baveux, il se redresse d'un bond, attrape la tête d'en face et lui colle un bisou qui dégouline (finition, trempe)
		P_bisou = {
			label = "Gros bisou baveux", startup = 0.1, active = 0.12, recovery = 0.34,
			damage = 10, hitbox = box(5.5, 4.5, 3, 1), kbBase = 34, kbGrowth = 70, kbAngle = 55,
			status = { name = "wet", duration = 1.5 },
			windup = { Root = { -20, 0, 0, 0, -0.7, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 40 }, RE = { 60, 0, 0 }, LS = { 70, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.15, -0.4 }, Waist = { -10, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 95, 0, -10 }, RE = { 60, 0, 0 }, LS = { 95, 0, 10 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 6, 0, 0, 0, -0.2, 0 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 10 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
			trail = "head", fx = { { "symbols", symbols = { "💋", "💦", "♥" }, count = 5, radius = 3, at = "front", color = PINK }, { "burst", color = MILK, size = 3, at = "front" } }, text = "SMACK !", hitText = "BEURK, DE LA BAVE !",
		},
		-- K K K : Trépignement, il tape des deux pieds par terre de rage, trois coups de talon dans les tibias
		K_trepigne = {
			label = "Trépignement", startup = 0.06, active = 0.2, recovery = 0.2,
			damage = 3, hits = 3, hitbox = box(5, 4, 3, 0.5), kbBase = 18, kbGrowth = 24, kbAngle = 50,
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 20, 0, 20 }, RE = { 120, 0, 0 }, LS = { 20, 0, -20 }, LE = { 120, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 10, 0, 25 }, RE = { 125, 0, 0 }, LS = { 10, 0, -25 }, LE = { 125, 0, 0 }, RH = { 60, 0, 0 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.2, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 10, 0, 25 }, RE = { 125, 0, 0 }, LS = { 10, 0, -25 }, LE = { 125, 0, 0 }, LH = { 60, 0, 0 }, LK = { -5, 0, 0 }, LA = { -20, 0, 0 } },
			shake = true, wobble = true, trail = "bothFeet", fx = { { "shake", amount = 0.25 }, "dust" }, text = "NAN NAN NAN !", hitText = "TAP-TAP-TAP !",
		},
		-- → K K : Gifle retour, la grosse main revient de l'autre côté, en revers, l'autre joue y passe
		K_side2 = {
			label = "Gifle retour", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(5.5, 4, 3, 1), kbBase = 22, kbGrowth = 32, kbAngle = 30,
			windup = { Root = { -6, -40, 0, 0, -0.3, -0.2 }, Waist = { -8, -40, 0 }, Neck = { -4, 30, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 95, 0, 30 }, LE = { 10, 0, 0 }, LW = { 0, 0, -30 } },
			strike = { Root = { -10, 28, 0, 0, -0.35, -0.4 }, Waist = { -12, 34, 0 }, Neck = { -6, -22, 0 }, RS = { 20, 0, 50 }, RE = { 40, 0, 0 }, LS = { 92, 0, -40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 40 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -12, 38, 0, 0, -0.38, -0.45 }, Waist = { -14, 44, 0 }, Neck = { -8, -28, 0 }, RS = { 15, 0, 55 }, RE = { 40, 0, 0 }, LS = { 88, 0, -60 }, LE = { 10, 0, 0 }, LW = { 0, 0, 40 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "leftHand", text = "ET NA !", hitText = "PIF !",
		},
		-- → K K K : Claque-oreilles, les deux grosses mains claquent en même temps sur les oreilles d'en face (finition)
		K_side3 = {
			label = "Claque-oreilles", startup = 0.1, active = 0.1, recovery = 0.34,
			damage = 12, hitbox = box(6, 4.5, 3, 1.2), kbBase = 36, kbGrowth = 80, kbAngle = 28,
			status = { name = "stunned", duration = 0.4 },
			windup = { Root = { 4, 0, 0, 0, -0.15, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 90 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -90 }, LE = { 10, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.3, -0.4 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, 0, 0, 0, -0.32, -0.45 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 96, 0, 4 }, RE = { 12, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -4 }, LE = { 12, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "bothHands", fx = { { "ring", color = YELLOW, radius = 3.5, at = "front" }, { "symbols", symbols = { "💫", "★" }, count = 4, radius = 2, at = "front", color = YELLOW } }, text = "CLAP !", hitText = "BLAM-BLAM !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Jet de purée, il plonge la main dans le bol et envoie une poignée de purée qui ralentit
		P_air_side = {
			label = "Jet de purée", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
			damage = 6, kbBase = 16, kbGrowth = 25, kbAngle = 25,
			status = { name = "slowed", duration = 1.5 },
			projectile = { speed = 55, angle = 5, gravity = 40, lifetime = 0.7, size = 1.4, color = PUREE,
				visual = { shape = "ball", size = 1.1, color = PUREE, parts = { { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.5, 0.2, 0), PUREE } } } },
			windup = { Root = { 6, 20, 0 }, Waist = { 8, 20, 0 }, Neck = { 0, -15, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 80, 0, -90 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, -15, 0 }, Waist = { -8, -20, 0 }, Neck = { 0, 12, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 100, 0, 10 }, LE = { 5, 0, 0 }, LW = { 0, 0, 20 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -8, -20, 0 }, Waist = { -10, -24, 0 }, Neck = { 0, 15, 0 }, RS = { 30, 0, 52 }, RE = { 40, 0, 0 }, LS = { 95, 0, 30 }, LE = { 10, 0, 0 }, LW = { 0, 0, 30 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 55, 0, 0 }, LK = { -90, 0, 0 } },
			prop = "puree", text = "BEURK !", hitText = "SPLOTCH !",
		},
		-- ↑ P en l'air : Hochet hélice, il fait tourner le hochet au-dessus de sa tête comme une hélice
		P_air_up = {
			label = "Hochet hélice", startup = 0.09, active = 0.16, recovery = 0.18,
			damage = 4, hits = 2, hitbox = box(5, 4, 0.5, 3.6), kbBase = 24, kbGrowth = 40, kbAngle = 86,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 8, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -60 }, LE = { 30, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 5 }, RE = { 5, 0, 0 }, RW = { 90, 0, 0 }, LS = { 15, 0, -62 }, LE = { 30, 0, 0 }, RH = { 5, 0, 0 }, RK = { -35, 0, 0 }, LH = { 15, 0, 0 }, LK = { -45, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "GLING GLING !",
		},
		-- ↓ P en l'air : Atterrissage fesses, il tombe assis de tout son poids, couche en avant (smash vers le sol)
		P_air_down = {
			label = "Atterrissage fesses", startup = 0.15, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(4.5, 3.5, 0, -2.4), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(0, -55),
			windup = { Root = { -10, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 140, 0, 40 }, RE = { 30, 0, 0 }, LS = { 140, 0, -40 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 90, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 25, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, RH = { 90, 0, 15 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { 90, 0, -15 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 28, 0, 0 }, Waist = { 2, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 55, 0, 75 }, RE = { 20, 0, 0 }, LS = { 55, 0, -75 }, LE = { 20, 0, 0 }, RH = { 92, 0, 18 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { 92, 0, -18 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "body", fx = { { "ring", color = DIAPER, radius = 4, at = "feet" } }, text = "POUF !", hitText = "ÉCRABOUILLÉ !",
		},
		-- → K en l'air : Coup de couche volant, il pivote en l'air et présente la couche la première
		K_air_side = {
			label = "Coup de couche volant", startup = 0.15, active = 0.12, recovery = 0.26,
			damage = 11, hitbox = box(5, 3.5, 2.6, -0.3), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { -6, 60, 0 }, Waist = { -6, 20, 0 }, Neck = { 0, -40, 0 }, RS = { 60, 0, 50 }, RE = { 40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -20, 170, 0 }, Waist = { -10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 90, 0, 70 }, RE = { 20, 0, 0 }, LS = { 90, 0, -70 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -24, 175, 0 }, Waist = { -12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 95, 0, 72 }, RE = { 20, 0, 0 }, LS = { 95, 0, -72 }, LE = { 20, 0, 0 }, RH = { 55, 0, 0 }, RK = { -55, 0, 0 }, LH = { 55, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "body", hitText = "POUF-POUF !",
		},
		-- ↑ K en l'air : Pédalage de berceau, couché sur le dos dans le vide, il pédale des deux pieds vers le haut
		K_air_up = {
			label = "Pédalage de berceau", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 5, hits = 2, hitbox = box(4.5, 5, 0.5, 3.4), kbBase = 28, kbGrowth = 60, kbAngle = 86,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 45, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 100, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 45, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -110, 0, 0 }, LH = { 140, 0, 0 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			trail = "bothFeet", hitText = "GIGOTE !",
		},
		-- ↓ K en l'air : Talons de bébé, il pique vers le sol en tapant des deux talons (smash vers le sol)
		K_air_down = {
			label = "Talons de bébé", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 110, 0, 50 }, RE = { 50, 0, 0 }, LS = { 110, 0, -50 }, LE = { 50, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 60 }, RE = { 20, 0, 0 }, LS = { 150, 0, -60 }, LE = { 20, 0, 0 }, RH = { -4, 0, 6 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -4, 0, -6 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 160, 0, 65 }, RE = { 20, 0, 0 }, LS = { 160, 0, -65 }, LE = { 20, 0, 0 }, RH = { -4, 0, 8 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { -4, 0, -8 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "PATATRAS !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Signatures (L) : sûres de toucher (couloir / projectiles visés, voir docs/fiche-perso.md)
		-- Hurlement de bébé : il gonfle les joues, se cambre poings serrés et pousse un cri qui repousse tout, des deux côtés,
		-- sur toute la plateforme
		S_neutral = {
			label = "Hurlement de bébé", startup = 0.22, active = 0.22, recovery = 0.45,
			damage = 13, hitbox = box(34, 8, 0, 2), kbBase = 46, kbGrowth = 58, kbAngle = 30,
			windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 10, 0, 15 }, RE = { 110, 0, 0 }, LS = { 10, 0, -15 }, LE = { 110, 0, 0 } },
			strike = { Root = { -4, 0, 0, 0, -0.15, 0 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -25, 0, 35 }, RE = { 10, 0, 0 }, LS = { -25, 0, -35 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.1, 0 }, FL = { 0, 0, 0, 0, 0.1, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.15, 0 }, Waist = { -8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { -30, 0, 40 }, RE = { 10, 0, 0 }, LS = { -30, 0, -40 }, LE = { 10, 0, 0 } },
			hold = 0.15, shake = true,
			fx = { { "ring", color = TEARS, radius = 8, at = "head" }, { "ring", color = Color3.new(1, 1, 1), radius = 14, at = "head", time = 0.5 }, { "symbols", symbols = { "😭", "WAAAH" }, count = 6, radius = 5, color = TEARS }, { "shake", amount = 0.6 } },
			text = "OUIIIIIN !", hitText = "MES OREILLES !",
		},
		-- Charge à quatre pattes : il fonce à quatre pattes d'un bout à l'autre du couloir, attrape l'adversaire au passage
		-- et le jette par-dessus son épaule (l'adversaire part derrière lui)
		S_side = {
			label = "Charge à quatre pattes", startup = 0.18, active = 0.32, recovery = 0.45,
			damage = 14, hitbox = box(14, 6, 7, 0.5), kbBase = 36, kbGrowth = 62, kbAngle = 140, selfVelocity = Vector2.new(58, 0), armor = true,
			windup = { Root = { -40, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 90, 0, 20 }, RE = { 20, 0, 0 }, LS = { 90, 0, -20 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -60, 0, 0, 0, -1.1, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 120, 0, 15 }, RE = { 10, 0, 0 }, LS = { 50, 0, -15 }, LE = { 20, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.4, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 200, 0, 10 }, RE = { 20, 0, 0 }, LS = { 200, 0, -10 }, LE = { 20, 0, 0 } },
			wobble = true, fx = { "dust", { "burst", color = CHEEK, size = 3, at = "front" } }, text = "ATTRAPÉ !", hitText = "PAR-DESSUS !",
		},
		-- Colère sismique : il frappe le sol des deux poings en hurlant ; une fissure file sur toute la longueur du couloir et renverse tout
		S_down = {
			label = "Colère sismique", startup = 0.24, active = 0.16, recovery = 0.5,
			damage = 14, hitbox = box(14, 6, 7, 0.5), kbBase = 34, kbGrowth = 58, kbAngle = 82,
			windup = { Root = { 8, 0, 0, 0, 0, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 185, 0, 20 }, RE = { 50, 0, 0 }, LS = { 185, 0, -20 }, LE = { 50, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, -0.9, -0.25 }, Waist = { -42, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 72, 0, 15 }, RE = { 5, 0, 0 }, LS = { 72, 0, -15 }, LE = { 5, 0, 0 } },
			follow = { Root = { -24, 0, 0, 0, -0.95, -0.25 }, Waist = { -46, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 62, 0, 20 }, RE = { 5, 0, 0 }, LS = { 62, 0, -20 }, LE = { 5, 0, 0 } },
			shake = true, trail = "bothHands",
			fx = { { "ring", color = WOOD, radius = 6, at = "feet" }, { "pillar", color = WOOD, height = 3, width = 8, at = "front", time = 0.5 }, { "shake", amount = 0.7 }, { "particles", tex = "smoke", color = Color3.fromRGB(190, 170, 140), dir = "front", at = "feet", time = 0.35, speed = 24, size = 1.2, rate = 80 } },
			text = "NAAAN !", hitText = "BRRROUM !",
		},
		-- Bond du lit à barreaux (remontée) : un lit à barreaux élastique sort du sol sous lui, il rebondit dessus et file en
		-- diagonale vers l'avant, hochet brandi devant lui, petites jambes potelées qui pédalent derrière
		S_up = {
			label = "Bond du lit à barreaux", startup = 0.15, active = 0.32, recovery = 0.4,
			damage = 15, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 55, kbAngle = 72, selfVelocity = Vector2.new(44, 86),
			windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { -20, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -40, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 166, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -45 }, LE = { 25, 0, 0 }, RH = { -20, 0, 8 }, RK = { -35, 0, 0 }, RA = { -25, 0, 0 }, LH = { -34, 0, -8 }, LK = { -50, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -44, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 170, 0, 16 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 135, 0, -50 }, LE = { 25, 0, 0 }, RH = { -34, 0, 10 }, RK = { -55, 0, 0 }, RA = { -25, 0, 0 }, LH = { -22, 0, -10 }, LK = { -40, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "prop",
			fx = { { "pillar", color = WOOD, height = 2.5, width = 6, at = "root", time = 0.5 }, { "ring", color = BLUE, radius = 5, at = "feet" }, { "burst", color = YELLOW, size = 3, at = "feet" }, { "symbols", symbols = { "BOING", "🧸" }, count = 3, radius = 2, color = BLUE } },
			text = "BOING !", hitText = "DEBOUT !",
		},
		-- Plongeon Dodo (plongeon) : il tombe lourdement sur le ventre sur tout ce qu'il y a dessous et s'endort une fraction
		-- de seconde ; l'adversaire écrasé pique aussi du nez
		S_air_down = {
			label = "Plongeon Dodo", startup = 0.16, active = 0.35, recovery = 0.5,
			damage = 14, hitbox = box(8, 6, 1, -2), kbBase = 28, kbGrowth = 58, kbAngle = -70, selfVelocity = Vector2.new(10, -82),
			status = { name = "asleep", duration = 0.8 },
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 30 }, RE = { 20, 0, 0 }, LS = { 160, 0, -30 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -75, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 50 }, RE = { 10, 0, 0 }, LS = { 170, 0, -50 }, LE = { 10, 0, 0 }, RH = { -10, 0, 15 }, RK = { -10, 0, 0 }, LH = { -10, 0, -15 }, LK = { -10, 0, 0 } },
			follow = { Root = { -80, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 20 }, RS = { 120, 0, 70 }, RE = { 30, 0, 0 }, LS = { 120, 0, -70 }, LE = { 30, 0, 0 }, RH = { -12, 0, 18 }, RK = { -15, 0, 0 }, LH = { -12, 0, -18 }, LK = { -15, 0, 0 } },
			trail = "body", fx = { { "shake", amount = 0.5 }, { "ring", color = TEARS, radius = 6, at = "feet" }, { "symbols", symbols = { "Z", "z", "💤" }, count = 4, radius = 2, color = Color3.fromRGB(170, 200, 255) } }, text = "DODO !", hitText = "ZZZ-BAM !",
		},
		-- Biberon (esquive puis S) : il sort son biberon géant et le fauche d'un grand revers sur toute la longueur du couloir,
		-- lait qui gicle… puis s'assoit et le tète les yeux fermés pour se soigner (vulnérable pendant la tétée)
		S_dodge = {
			label = "Biberon", startup = 0.2, active = 0.14, recovery = 0.7,
			damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 32, kbGrowth = 58, kbAngle = 35,
			selfEffect = { heal = 6 },
			windup = { Root = { 6, -25, 0, 0, -0.1, 0.2 }, Waist = { 10, -28, 0 }, Neck = { 12, 10, 0 }, RS = { 60, 0, 85 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 24, 0, 0, -0.35, -0.45 }, Waist = { -18, 30, 0 }, Neck = { -8, -14, 0 }, RS = { 92, 0, -30 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -6, 0, 0, 0, -0.5, 0.15 }, Waist = { 12, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 145, 0, -15 }, RE = { 118, 0, 0 }, RW = { -115, 0, 0 }, LS = { 135, 0, 15 }, LE = { 118, 0, 0 } },
			hold = 0.4, prop = "biberon", hideProp = "hochet", trail = "prop",
			fx = { { "burst", color = MILK, size = 3, at = "front" }, { "particles", tex = "smoke", color = MILK, dir = "front", at = "hand", time = 0.3, speed = 20, size = 0.7, rate = 60 }, { "symbols", symbols = { "🍼", "♥" }, count = 3, radius = 2, color = MILK } },
			text = "GLOU GLOU", hitText = "BIBERONNÉ !",
		},
		-- Cri supersonique (S maintenu) : il retient sa respiration, devient tout rouge… et lâche une onde de cri qui fonce
		-- droit sur l'adversaire et traverse tout ce qu'elle croise
		S_hold = {
			label = "Cri supersonique", kind = "projectile", startup = 0.28, active = 0, recovery = 0.5,
			damage = 14, kbBase = 40, kbGrowth = 75, kbAngle = 25,
			projectile = { speed = 60, angle = 0, gravity = 0, lifetime = 0.7, size = 4, color = TEARS, pierce = true,
				visual = { shape = "disc", size = 4, color = TEARS, transparency = 0.45, neon = true, trail = false } },
			windup = { Root = { 8, 0, 0, 0, -0.35, 0.2 }, Waist = { 16, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 20, 0, 10 }, RE = { 120, 0, 0 }, LS = { 20, 0, -10 }, LE = { 120, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.3, -0.2 }, Waist = { -12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 40 }, RE = { 10, 0, 0 }, LS = { -30, 0, -40 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -35, 0, 45 }, RE = { 10, 0, 0 }, LS = { -35, 0, -45 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			shake = true, windupFx = { { "symbols", symbols = { "😤" }, count = 1, radius = 1.5, color = Color3.fromRGB(255, 90, 90) } },
			fx = { { "ring", color = TEARS, radius = 5, at = "front" }, { "shake", amount = 0.4 } }, text = "AAAAAAAH !", hitText = "TYMPANS !",
		},
		-- Rampe éclair (→→S) : il file à quatre pattes à une vitesse indécente, tête la première, d'un bout à l'autre du couloir
		S_dash = {
			label = "Rampe éclair", startup = 0.15, active = 0.32, recovery = 0.4,
			damage = 13, hitbox = box(12, 5, 5, -0.5), kbBase = 32, kbGrowth = 62, kbAngle = 40, selfVelocity = Vector2.new(68, 0), invuln = 0.15,
			windup = { Root = { -40, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 80, 0, 20 }, RE = { 10, 0, 0 }, LS = { 80, 0, -20 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -62, 0, 0, 0, -1.15, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 110, 0, 15 }, RE = { 10, 0, 0 }, LS = { 50, 0, -15 }, LE = { 10, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { -62, 0, 0, 0, -1.15, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 50, 0, 15 }, RE = { 10, 0, 0 }, LS = { 110, 0, -15 }, LE = { 10, 0, 0 }, RH = { 75, 0, 0 }, RK = { -110, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
			wobble = true, fx = { "dust" }, text = "GAGA-GOUGOU !", hitText = "BAM !",
		},
		-- Bol de purée (S en l'air) : il balance tout le bol, qui fonce droit sur la figure de l'adversaire ; la purée colle (ralenti)
		S_air = {
			label = "Bol de purée", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
			damage = 13, kbBase = 22, kbGrowth = 40, kbAngle = 45,
			status = { name = "slowed", duration = 1.5 },
			projectile = { speed = 58, angle = 0, gravity = 0, lifetime = 0.8, size = 2.2, color = PUREE,
				visual = { shape = "ball", size = 1.5, color = BLUE, spin = 8, parts = { { "ball", Vector3.new(1.3, 0.6, 1.3), Vector3.new(0, 0.5, 0), PUREE } } } },
			windup = { Root = { 8, 20, 0 }, Waist = { 10, 24, 0 }, Neck = { 0, -10, 0 }, RS = { 40, 0, 40 }, RE = { 40, 0, 0 }, LS = { 120, 0, -60 }, LE = { 90, 0, 0 }, LW = { 0, 0, 60 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -10, -16, 0 }, Waist = { -8, -20, 0 }, Neck = { 6, 10, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 96, 0, -4 }, LE = { 0, 0, 0 }, LW = { 0, 0, 90 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -12, -20, 0 }, Waist = { -10, -24, 0 }, Neck = { 8, 12, 0 }, RS = { 40, 0, 52 }, RE = { 40, 0, 0 }, LS = { 100, 0, -6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 120 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			prop = "puree", trail = "leftHand", fx = { { "toss", shape = "ball", color = PUREE, size = 0.5, count = 4, speed = 18 } }, text = "PAS MANGÉ !", hitText = "SPLOTCH !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Caprice tape-sol : il se jette par terre et tape des poings et des pieds en hurlant (fait décoller)
		S_finish_caprice = {
			label = "Caprice tape-sol", startup = 0.12, active = 0.3, recovery = 0.35,
			damage = 4, hits = 3, hitbox = box(6, 3, 1.5, -1.5), kbBase = 26, kbGrowth = 45, kbAngle = 72,
			windup = { Root = { 10, 0, 0, 0, -0.5, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 30 }, RE = { 40, 0, 0 }, LS = { 160, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -15, 0, 0, 0, -1.1, -0.1 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 25 }, RE = { 10, 0, 0 }, LS = { 120, 0, -25 }, LE = { 30, 0, 0 } },
			follow = { Root = { -15, 0, 0, 0, -1.1, -0.1 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 25 }, RE = { 30, 0, 0 }, LS = { 60, 0, -25 }, LE = { 10, 0, 0 } },
			wobble = true, fx = { { "shake", amount = 0.3 }, "dust" }, text = "NAN NAN NAN !", hitText = "PAF PAF PAF !",
		},
		-- Petit cri : un cri bref et perçant, bouche grande ouverte, qui éjecte à l'horizontale
		S_finish_cri = {
			label = "Petit cri", startup = 0.1, active = 0.15, recovery = 0.3,
			damage = 9, hitbox = box(7, 5, 3.5, 0.8), kbBase = 38, kbGrowth = 60, kbAngle = 25,
			windup = { Root = { 6, 0, 0, 0, -0.25, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 20 }, RE = { 100, 0, 0 }, LS = { 20, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.15 }, Waist = { -10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -20, 0, 40 }, RE = { 10, 0, 0 }, LS = { -20, 0, -40 }, LE = { 10, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.2, -0.15 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -25, 0, 45 }, RE = { 10, 0, 0 }, LS = { -25, 0, -45 }, LE = { 10, 0, 0 } },
			fx = { { "ring", color = TEARS, radius = 4, at = "front" } }, text = "IIIIH !", hitText = "AÏE !",
		},

		------------------------------------------------------------------ Supers (Y) : couloir 1,3 fois plus grand, plus farfelus
		-- Crise de larmes (Y) : il éclate en sanglots et un raz-de-marée de larmes fonce droit sur l'adversaire, le trempe et l'emporte
		SUPER = {
			label = "Crise de larmes !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 22, kbBase = 36, kbGrowth = 72, kbAngle = 25,
			status = { name = "wet", duration = 2.5 },
			projectile = { speed = 50, angle = 0, gravity = 0, lifetime = 1.4, size = 7, color = TEARS, pierce = true, from = "feet",
				visual = { shape = "block", size = 5, color = TEARS, transparency = 0.35, trail = false,
					parts = { { "ball", Vector3.new(6, 1.8, 3.5), Vector3.new(0, 2.9, 0), Color3.fromRGB(220, 240, 255) }, { "ball", Vector3.new(1.6, 1.6, 1.6), Vector3.new(1.8, 3.6, 0), Color3.fromRGB(220, 240, 255) }, { "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(-1.8, 3.4, 0), Color3.fromRGB(220, 240, 255) } } } },
			windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, -30 }, RE = { 140, 0, 0 }, LS = { 120, 0, 30 }, LE = { 140, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, -0.2, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -0.2, 0.1 }, Waist = { 18, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 50, 0, 70 }, RE = { 30, 0, 0 }, LS = { 50, 0, -70 }, LE = { 30, 0, 0 } },
			hold = 0.3, shake = true, windupFx = { "super", { "symbols", symbols = { "😭", "💧" }, count = 6, radius = 2.5, color = TEARS } },
			fx = { { "screen", color = TEARS, alpha = 0.35 }, { "puddle", color = TEARS, width = 12, time = 2 }, { "particles", tex = "smoke", color = TEARS, dir = "front", at = "head", time = 0.8, speed = 22, size = 1.2, rate = 100 }, { "shake", amount = 0.4 } },
			text = "BOUHOUHOUUU !", hitText = "PLOUF !",
		},
		-- Hochet-boulet (→Y) : il fait tourner le hochet géant par le manche comme un lanceur de marteau, de plus en plus vite,
		-- et le lâche : la grosse boule jaune roule sur tout le couloir, grelots en folie, et sonne tout ce qu'elle croise
		SUPER_side = {
			label = "Hochet-boulet !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 26, kbBase = 48, kbGrowth = 98, kbAngle = 32,
			status = { name = "stunned", duration = 0.6 },
			projectile = { speed = 72, angle = 0, gravity = 20, lifetime = 1.0, size = 3.2, color = YELLOW, pierce = true, bounce = 1, from = "feet",
				visual = { shape = "ball", size = 2.6, color = YELLOW, spin = 12,
					parts = { { "cyl", Vector3.new(2.0, 0.4, 0.4), Vector3.new(-1.6, 0, 0), PINK }, { "ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0, 0, 1.4), PINK }, { "ball", Vector3.new(0.7, 0.7, 0.7), Vector3.new(0, 0, -1.4), Color3.fromRGB(120, 210, 120) } } } },
			windup = { Root = { 4, -40, 0, 0, -0.3, 0.2 }, Waist = { 6, -44, 0 }, Neck = { 8, 30, 0 }, RS = { 100, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -16, 30, 0, 0, -0.45, -0.45 }, Waist = { -18, 34, 0 }, Neck = { -6, -20, 0 }, RS = { 60, 0, -10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			follow = { Root = { -18, 36, 0, 0, -0.48, -0.5 }, Waist = { -20, 40, 0 }, Neck = { -8, -24, 0 }, RS = { 50, 0, -16 }, RE = { 4, 0, 0 }, RW = { -40, 0, 0 }, LS = { 36, 0, -54 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.58 } },
			spin = { axis = "y", degrees = 720 }, shake = true, hideProp = "hochet", trail = "prop",
			windupFx = { "super", { "symbols", symbols = { "🔔", "♪", "🔔" }, count = 6, radius = 3, color = YELLOW } },
			fx = { { "burst", color = YELLOW, size = 3.5, at = "hand" }, { "beam", color = YELLOW, length = 14, width = 3, at = "feet" }, { "shake", amount = 0.4 }, "dust" },
			text = "BOULET !", hitText = "GLING-BLONG !",
		},
		-- Tétine-fusée (Y↑) : il aspire un grand coup, les joues gonflées à bloc… et crache sa tétine comme une fusée : elle fonce
		-- droit sur l'adversaire et l'emporte en orbite avec elle
		SUPER_up = {
			label = "Tétine-fusée !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.7,
			damage = 24, kbBase = 46, kbGrowth = 95, kbAngle = 88,
			projectile = { speed = 85, angle = 60, gravity = 0, lifetime = 1.0, size = 3.4, color = PINK, pierce = true, from = "above",
				visual = { shape = "ball", size = 2.6, color = PINK, neon = true, spin = 6,
					parts = { { "block", Vector3.new(2.8, 0.3, 2.8), Vector3.new(0, -1.2, 0), YELLOW }, { "ball", Vector3.new(1.3, 1.3, 1.3), Vector3.new(0, -2, 0), PINK } } } },
			windup = { Root = { 8, 0, 0, 0, -0.35, 0.1 }, Waist = { 14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, 20 }, RE = { 120, 0, 0 }, LS = { 30, 0, -20 }, LE = { 120, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, 0.2, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -40, 0, 50 }, RE = { 10, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.15, 0 }, Waist = { 14, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 120, 0, -30 }, RE = { 130, 0, 0 }, LS = { 120, 0, 30 }, LE = { 130, 0, 0 } },
			hold = 0.3, shake = true,
			windupFx = { "super", { "symbols", symbols = { "😤", "💨" }, count = 3, radius = 2, color = CHEEK } },
			fx = { { "beam", color = PINK, length = 14, width = 2.5, at = "head" }, { "burst", color = YELLOW, size = 4, at = "head" }, { "particles", tex = "fire", color = PINK, dir = "front", at = "head", time = 0.5, speed = 24, size = 1 }, { "shake", amount = 0.4 } },
			text = "PTHOUU !", hitText = "TÉTINE EN ORBITE !",
		},
		-- « Encore ! » (Y↓) : il aspire tout le couloir dans ses bras comme un jouet et fait tourner l'adversaire autour de lui à toute vitesse
		SUPER_down = {
			label = "Encore !", startup = 0.35, active = 0.9, recovery = 0.65,
			damage = 5, hits = 5, pull = true, hitbox = box(14, 6, 7, 1), kbBase = 16, kbGrowth = 20, kbAngle = 80,
			windup = { Root = { 4, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 110, 0, 70 }, RE = { 20, 0, 0 }, LS = { 110, 0, -70 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 10 }, RE = { 10, 0, 0 }, LS = { 120, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.2, 0 }, Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 130, 0, 10 }, RE = { 10, 0, 0 }, LS = { 130, 0, -10 }, LE = { 10, 0, 0 } },
			spin = { axis = "y", degrees = 1080 }, windupFx = { "super" }, fx = { { "ring", color = YELLOW, radius = 7, at = "front" }, { "symbols", symbols = { "ENCORE !", "😆" }, count = 6, radius = 5, color = YELLOW } },
			text = "ENCORE ! ENCORE !", hitText = "WIIIIZ !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Câlin de bébé : bras grands ouverts, il serre l'adversaire contre son bedon comme un doudou
		GRAB = {
			label = "Câlin de bébé", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4.5, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 120, 0, 70 }, RE = { 10, 0, 0 }, LS = { 120, 0, -70 }, LE = { 10, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.3 }, Waist = { -8, 0, 0 }, Neck = { -10, 0, 15 }, RS = { 85, 0, -35 }, RE = { 70, 0, 0 }, LS = { 85, 0, 35 }, LE = { 70, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.18, -0.3 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 18 }, RS = { 88, 0, -40 }, RE = { 75, 0, 0 }, LS = { 88, 0, 40 }, LE = { 75, 0, 0 } },
			fx = { { "symbols", symbols = { "♥" }, count = 3, radius = 2, color = PINK } }, text = "DOUDOU !", hitText = "CÂLIIIN !",
		},
		-- ✋ puis → : Jouet jeté, il secoue le « jouet » au-dessus de sa tête et le jette hors du parc
		THROW_fwd = {
			label = "Jouet jeté", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 20,
			carry = { { 0, 2.4, 0.4 }, { 0.16, 0.5, 3.6 }, { 0.32, 3.8, 1.6 } },
			windup = { Root = { 10, 0, 0, 0, -0.1, 0.25 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 185, 0, 10 }, RE = { 30, 0, 0 }, LS = { 185, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -20, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 90, 0, 10 }, RE = { 5, 0, 0 }, LS = { 90, 0, -10 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.4 }, Waist = { -24, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 15 }, RE = { 5, 0, 0 }, LS = { 75, 0, -15 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			text = "VEUX PLUS !", hitText = "HORS DU PARC !",
		},
		-- ✋ puis ← : Pas mangé !, il jette la victime par-dessus l'épaule comme une assiette de purée qu'il refuse
		THROW_back = {
			label = "Pas mangé !", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.6, 1.0 }, { 0.28, 0.2, 3.8 }, { 0.4, -2.6, 1.6 } },
			windup = { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 80, 0, -20 }, RE = { 60, 0, 0 }, LS = { 80, 0, 20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.2, 0.25 }, Waist = { 25, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 200, 0, 10 }, RE = { 30, 0, 0 }, LS = { 200, 0, -10 }, LE = { 30, 0, 0 } },
			follow = { Root = { 24, 0, 0, 0, -0.2, 0.3 }, Waist = { 28, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 210, 0, 15 }, RE = { 30, 0, 0 }, LS = { 210, 0, -15 }, LE = { 30, 0, 0 } },
			text = "PAS MANGÉ !", hitText = "BEURK !",
		},
		-- ✋ puis ↑ : Avion ! Vroum !, il fait voler la victime au-dessus de sa tête en courant sur place et la lâche vers le ciel
		THROW_up = {
			label = "Avion ! Vroum !", kind = "throw", startup = 0.36, active = 0.08, recovery = 0.38,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 0.5, 4.2 }, { 0.26, -0.5, 4.4 }, { 0.36, 0.5, 4.6 } },
			windup = { Root = { 0, 20, 0, 0, -0.1, 0 }, Waist = { 6, 15, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 10, 0, 0 }, LS = { 175, 0, -10 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 0, -20, 0, 0, 0.2, 0 }, Waist = { 10, -15, 0 }, Neck = { 40, 0, 0 }, RS = { 180, 0, 15 }, RE = { 5, 0, 0 }, LS = { 180, 0, -15 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 0, -10, 0, 0, 0.1, 0 }, Waist = { 12, -10, 0 }, Neck = { 45, 0, 0 }, RS = { 170, 0, 40 }, RE = { 10, 0, 0 }, LS = { 170, 0, -40 }, LE = { 10, 0, 0 } },
			text = "VROUUUM !", hitText = "AVION !",
		},
		-- ✋ puis ↓ : Assis sur le doudou, il pose la victime par terre et s'assoit dessus, ravi
		THROW_down = {
			label = "Assis sur le doudou", kind = "throw", startup = 0.42, active = 0.1, hold = 0.25, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, 1.2 }, { 0.3, 0.6, -2.0 }, { 0.42, 0, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 20 }, RE = { 30, 0, 0 }, LS = { 150, 0, -20 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 10, 0, 0, 0, -1.4, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 50 }, RE = { 20, 0, 0 }, LS = { 60, 0, -50 }, LE = { 20, 0, 0 }, RH = { 85, 0, 10 }, RK = { -10, 0, 0 }, LH = { 85, 0, -10 }, LK = { -10, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, -1.4, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 160, 0, 30 }, RE = { 20, 0, 0 }, LS = { 160, 0, -30 }, LE = { 20, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } },
			fx = { { "ring", color = DIAPER, radius = 4, at = "feet" }, { "shake", amount = 0.3 } }, text = "ASSIS !", hitText = "ÉCRASÉ !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "le_doudou", label = "Le Doudou", sequence = { "forward", "back", "down" },
			-- l'adversaire rétrécit en peluche toute douce, Bébé le câline et s'endort avec
			scene = {
				{ "fxAttacker", { "text", text = "DOUDOU ?", color = PINK } },
				{ "shrink", 0.4, time = 0.7 },
				{ "color", Color3.fromRGB(190, 140, 100) },
				{ "material", "Fabric" },
				{ "fx", { "symbols", symbols = { "🧸" }, count = 2, radius = 1.5, color = WOOD } },
				{ "text", "PELUCHE !" },
				{ "wait", 0.4 },
				{ "move", to = "attacker", offset = Vector3.new(0, 0.5, -1.2), time = 0.5 },
				{ "fxAttacker", { "symbols", symbols = { "♥", "♥" }, count = 4, color = PINK } },
				{ "wait", 0.6 },
				{ "fxAttacker", { "symbols", symbols = { "Z", "z", "💤" }, count = 6, color = Color3.fromRGB(170, 200, 255) } },
				{ "fxAttacker", { "text", text = "ZZZ…", color = Color3.fromRGB(170, 200, 255) } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "la_berceuse", label = "La Berceuse", sequence = { "down", "forward", "up" },
			-- un mobile géant descend du plafond, l'adversaire y est accroché et tourne en musique
			scene = {
				{ "spawn", at = "above", offset = Vector3.new(0, 4, 0), life = 4.5, pieces = {
					{ "Tige", "", "cyl", Vector3.new(6, 0.2, 0.2), Vector3.new(0, 3, 0), Vector3.zero, WOOD, "Wood" },
					{ "Croisillon", "", "block", Vector3.new(7, 0.25, 0.25), Vector3.zero, Vector3.zero, WOOD, "Wood" },
					{ "Lune", "", "ball", Vector3.new(1.2, 1.2, 0.4), Vector3.new(-3.2, -1.5, 0), Vector3.zero, YELLOW, "SmoothPlastic" },
					{ "Etoile", "", "ball", Vector3.new(1, 1, 0.4), Vector3.new(3.2, -1.5, 0), Vector3.zero, PINK, "SmoothPlastic" },
					{ "Fil", "", "cyl", Vector3.new(2.5, 0.06, 0.06), Vector3.new(0, -1.2, 0), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
				} },
				{ "fxAttacker", { "text", text = "DODO, L'ENFANT DO…", color = BLUE } },
				{ "lift", 5, time = 0.8 },
				{ "fx", { "symbols", symbols = { "♪", "♫" }, count = 6, radius = 4, color = BLUE } },
				{ "spin", 720, time = 1.4, axis = "y" },
				{ "fx", { "symbols", symbols = { "♪", "♫", "💤" }, count = 6, radius = 4, color = PINK } },
				{ "spin", 720, time = 1.4, axis = "y" },
				{ "text", "TOURNI-TOURNA…" },
				{ "wait", 0.5 },
			},
		},
		{
			id = "range", label = "Rangé !", sequence = { "back", "up", "forward" },
			-- jeté dans le coffre à jouets, le couvercle claque
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, -1.5, 0), life = 4, pieces = {
					{ "Coffre", "", "block", Vector3.new(5, 3, 3.5), Vector3.zero, Vector3.zero, BLUE, "Wood" },
					{ "Bande", "", "block", Vector3.new(5.1, 0.4, 3.6), Vector3.new(0, 0.6, 0), Vector3.zero, YELLOW, "Wood" },
					{ "Cube", "", "block", Vector3.new(0.9, 0.9, 0.9), Vector3.new(-1.6, 1.9, 0), Vector3.new(0, 30, 15), PINK, "SmoothPlastic" },
				} },
				{ "fxAttacker", { "text", text = "ON RANGE !", color = YELLOW } },
				{ "lift", 4, time = 0.4 },
				{ "shrink", 0.6, time = 0.3 },
				{ "lift", -4.5, time = 0.35 },
				{ "hide" },
				{ "spawn", at = "target", offset = Vector3.new(0, 0.3, 0), life = 2.5, pieces = {
					{ "Couvercle", "", "block", Vector3.new(5.2, 0.5, 3.7), Vector3.zero, Vector3.zero, BLUE, "Wood" },
				} },
				{ "fx", { "burst", color = YELLOW, size = 4, at = "root" } },
				{ "text", "CLAC !" },
				{ "fxAttacker", { "symbols", symbols = { "😊", "✨" }, count = 4, color = YELLOW } },
				{ "wait", 1.2 },
			},
		},
	},

	-- Mécanique « Caprice » : les coups reçus remplissent la jauge ; pleine, crise de 5 s sans broncher
	passive = { kind = "caprice", name = "Caprice", icon = "😭" },

	-- Recharge ⚡ : assis par terre, il tète un biberon géant à deux mains, puis lâche un rot qui fait trembler l'écran
	charge = {
		label = "Biberon géant",
		loop = 1.8,
		lockWrist = true,
		color = MILK,
		keys = {
			{ 0.0, { Root = { 10, 0, 0, 0, -1.4, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, -15 }, RE = { 115, 0, 0 }, RW = { -100, 0, 0 }, LS = { 135, 0, 15 }, LE = { 115, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 0.3, { Root = { 12, 0, 0, 0, -1.4, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 145, 0, -15 }, RE = { 112, 0, 0 }, RW = { -105, 0, 0 }, LS = { 140, 0, 15 }, LE = { 112, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 0.6, { Root = { 10, 0, 0, 0, -1.4, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, -15 }, RE = { 115, 0, 0 }, RW = { -100, 0, 0 }, LS = { 135, 0, 15 }, LE = { 115, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 0.9, { Root = { 12, 0, 0, 0, -1.4, 0.2 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 145, 0, -15 }, RE = { 112, 0, 0 }, RW = { -105, 0, 0 }, LS = { 140, 0, 15 }, LE = { 112, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 1.2, { Root = { 4, 0, 0, 0, -1.4, 0.2 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 1.35, { Root = { 16, 0, 0, 0, -1.35, 0.25 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
			{ 1.8, { Root = { 10, 0, 0, 0, -1.4, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, -15 }, RE = { 115, 0, 0 }, RW = { -100, 0, 0 }, LS = { 135, 0, 15 }, LE = { 115, 0, 0 }, RH = { 85, 0, 12 }, RK = { -10, 0, 0 }, LH = { 85, 0, -12 }, LK = { -10, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "symbols", symbols = { "🍼" }, count = 1, radius = 1.5, color = MILK } },
			{ 1.35, { "shake", amount = 0.5 } },
			{ 1.35, { "text", text = "BUUURP !", color = YELLOW } },
		},
	},

	-- Manies au repos : il suce son pouce, tape dans ses mains tout content, secoue son hochet près de l'oreille
	fidgets = {
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 6, 0, 8 }, LS = { 110, 0, 25 }, LE = { 140, 0, 0 }, LW = { -20, 0, 0 } } },
			{ 1.6, { Neck = { 10, 0, 12 }, LS = { 112, 0, 25 }, LE = { 142, 0, 0 }, LW = { -20, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 1.8, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { 15, 0, 0 }, RS = { 80, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 0.5, { Neck = { 18, 0, 0 }, RS = { 85, 0, -5 }, RE = { 50, 0, 0 }, LS = { 85, 0, 5 }, LE = { 50, 0, 0 } } },
			{ 0.7, { Neck = { 15, 0, 0 }, RS = { 80, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 0.9, { Neck = { 18, 0, 0 }, RS = { 85, 0, -5 }, RE = { 50, 0, 0 }, LS = { 85, 0, 5 }, LE = { 50, 0, 0 } } },
			{ 1.1, { Neck = { 15, 0, 0 }, RS = { 80, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.8, {} },
		} },
		{ duration = 2.0, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 0, 0, -15 }, RS = { 150, 0, 40 }, RE = { 110, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 0.6, { Neck = { 0, 0, -15 }, RS = { 150, 0, 45 }, RE = { 100, 0, 0 }, RW = { 20, 0, 0 } } },
			{ 0.8, { Neck = { 0, 0, -15 }, RS = { 150, 0, 40 }, RE = { 110, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 1.0, { Neck = { 0, 0, -15 }, RS = { 150, 0, 45 }, RE = { 100, 0, 0 }, RW = { 20, 0, 0 } } },
			{ 1.4, { Neck = { 20, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 } } },
			{ 2.0, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : gros câlin d'ours, bras serrés autour de la victime, joue collée contre elle
data.grabHold = {
	Root = { -6, 0, 0, 0, -0.15, 0 },
	Waist = { -8, 0, 0 },
	Neck = { -10, 0, 15 },
	RS = { 85, 0, -35 },
	RE = { 70, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 85, 0, 35 },
	LE = { 70, 0, 0 },
}

-- Retour 🪂 : il arrive dans un landau volant tiré par des cigognes, en sort à quatre pattes, se dresse et
-- tape sur son torse avec son hochet
data.respawn = {
	duration = 2.0,
	platform = { pieces = {
		{ "Nacelle", "base", "block", Vector3.new(5.5, 1, 3.6), Vector3.new(0, -0.5, 0), Vector3.zero, PINK, "Fabric" },
		{ "BordAvant", "", "block", Vector3.new(5.5, 1.2, 0.25), Vector3.new(0, 0.4, -1.75), Vector3.zero, PINK, "Fabric" },
		{ "BordArriere", "", "block", Vector3.new(5.5, 1.2, 0.25), Vector3.new(0, 0.4, 1.75), Vector3.zero, PINK, "Fabric" },
		{ "Capote", "", "ball", Vector3.new(2.6, 3.6, 3.8), Vector3.new(2.4, 1.2, 0), Vector3.zero, Color3.fromRGB(220, 110, 160), "Fabric" },
		{ "RoueAG", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(-1.9, -1.3, -1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "RoueAD", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(1.9, -1.3, -1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "RoueRG", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(-1.9, -1.3, 1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "RoueRD", "", "cyl", Vector3.new(0.3, 1.4, 1.4), Vector3.new(1.9, -1.3, 1.6), Vector3.zero, BLACK, "SmoothPlastic", { axis = "z" } },
		{ "Cigogne1", "", "ball", Vector3.new(1.6, 1, 1), Vector3.new(-3.5, 8, 0), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
		{ "Bec1", "", "wedge", Vector3.new(0.3, 0.3, 1), Vector3.new(-4.5, 8.1, 0), Vector3.new(0, 90, 0), Color3.fromRGB(250, 140, 50), "SmoothPlastic" },
		{ "Cigogne2", "", "ball", Vector3.new(1.6, 1, 1), Vector3.new(3.5, 8.6, 0), Vector3.zero, Color3.new(1, 1, 1), "SmoothPlastic" },
		{ "Bec2", "", "wedge", Vector3.new(0.3, 0.3, 1), Vector3.new(4.5, 8.7, 0), Vector3.new(0, -90, 0), Color3.fromRGB(250, 140, 50), "SmoothPlastic" },
		{ "Ruban1", "", "cyl", Vector3.new(7.5, 0.06, 0.06), Vector3.new(-2.2, 4.3, 0), Vector3.new(0, 0, 18), Color3.fromRGB(255, 240, 240), "SmoothPlastic" },
		{ "Ruban2", "", "cyl", Vector3.new(7.8, 0.06, 0.06), Vector3.new(2.2, 4.6, 0), Vector3.new(0, 0, -18), Color3.fromRGB(255, 240, 240), "SmoothPlastic" },
	} },
	keys = {
		{ 0.0, { Root = { -55, 0, 0, 0, -1.1, 0 }, Waist = { -10, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 60, 0, 15 }, RE = { 10, 0, 0 }, LS = { 60, 0, -15 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } } },
		{ 0.35, { Root = { -55, 0, 0, 0, -1.1, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 80, 0, 15 }, RE = { 10, 0, 0 }, LS = { 45, 0, -15 }, LE = { 10, 0, 0 }, RH = { 45, 0, 0 }, RK = { -80, 0, 0 }, LH = { 75, 0, 0 }, LK = { -100, 0, 0 } } },
		{ 0.7, { Root = { -55, 0, 0, 0, -1.1, -0.4 }, Waist = { -10, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 45, 0, 15 }, RE = { 10, 0, 0 }, LS = { 80, 0, -15 }, LE = { 10, 0, 0 }, RH = { 75, 0, 0 }, RK = { -100, 0, 0 }, LH = { 45, 0, 0 }, LK = { -80, 0, 0 } } },
		{ 1.05, { Root = { 0, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 20, 0, 0 }, LS = { 160, 0, -40 }, LE = { 20, 0, 0 } } },
		{ 1.25, { Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 70, 0, -30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 30 }, LE = { 120, 0, 0 } } },
		{ 1.4, { Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 90, 0, 0 } } },
		{ 1.55, { Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 70, 0, -30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 30 }, LE = { 120, 0, 0 } } },
		{ 1.7, { Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 90, 0, 0 } } },
		{ 2.0, {} },
	},
	beats = {
		{ 0.1, { "symbols", symbols = { "♪", "🍼" }, count = 3, radius = 3, at = "above", color = PINK } },
		{ 1.05, { "burst", color = YELLOW, size = 3, at = "head" } },
		{ 1.25, { "text", text = "BÉBÉ FORT !", color = YELLOW } },
		{ 1.4, { "shake", amount = 0.3 } },
	},
}

-- Arbre d'enchaînements : après le coup de gauche, le bouton (avec sa direction) lance le coup de droite.
-- P P P P : hochet, retour, secouage, gros hochet · → P P P : coup de couche, couche rebond, prout propulseur
-- ↓ P P P : roulade, galop, gros bisou baveux · K K K K : pied, pied gauche, trépignement, coup de pied colère
-- → K K K : gifle, gifle retour, claque-oreilles. Les S finissent : Caprice tape-sol (décolle) ou Petit cri (horizontal).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P P P P : hochet maladroit, hochet retour, secouage de hochet, gros hochet (finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_cri" },
	P_combo2 = { P = "P_grelot", K = "K_combo2", up_K = "K_up", S = "S_finish_caprice" },
	P_grelot = { P = "P_combo3", K = "K_trepigne", S = "S_finish_cri" },
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_caprice" },
	KP_combo = { P = "P_combo3", K = "K_trepigne", S = "S_finish_cri" },
	-- K K K K : petit pied potelé, petit pied gauche, trépignement, coup de pied colère (finition)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_cri" },
	K_combo2 = { K = "K_trepigne", P = "P_grelot", S = "S_finish_caprice" },
	K_trepigne = { K = "K_combo3", P = "P_bisou", S = "S_finish_cri" },
	-- → P P P : coup de couche, couche rebond, prout propulseur (finition à l'horizontale)
	P_side = { P = "P_couche2", K = "K_side", S = "S_finish_cri" },
	P_couche2 = { P = "P_couche3", K = "K_side2", S = "S_finish_caprice" },
	-- ↓ P P P : roulade à quatre pattes, galop, gros bisou baveux (finition)
	P_down = { P = "P_galop", K = "K_up", S = "S_finish_caprice" },
	P_galop = { P = "P_bisou", K = "K_trepigne", S = "S_finish_cri" },
	-- → K K K : gifle de bébé, gifle retour, claque-oreilles (finition)
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_cri" },
	K_side2 = { K = "K_side3", P = "P_grelot", S = "S_finish_caprice" },
	-- autres départs
	P_up = { K = "K_up", S = "S_finish_caprice" },
	K_down = { P = "P_up", K = "K_up", S = "S_finish_caprice" },
	K_up = { S = "S_finish_caprice" },
	P_dash = { P = "P_grelot", K = "K_side", S = "S_finish_cri" },
	K_dash = { P = "P_galop", K = "K_up", S = "S_finish_caprice" },
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

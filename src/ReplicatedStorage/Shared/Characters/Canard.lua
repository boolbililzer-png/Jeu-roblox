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

local data = {
	id = "Canard",
	name = "Capitaine Canard",
	costume = "Canard",
	style = "duck",
	flying = true, -- sait voler : un saut en l\'air de plus, plané, et un ↑L très puissant

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

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

local data = {
	id = "Dylan",
	name = "Dylan le Livreur",
	costume = "Dylan",
	style = "hurry",

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
		-- Uppercut casque (anti-air) : il se ramasse puis jaillit tête la première, casque vers le ciel
		P_up = {
			label = "Uppercut casque", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(4, 4.5, 1, 3.5), kbBase = 26, kbGrowth = 32, kbAngle = 85,
			windup = { Root = { -8, 0, 0, 0, -0.8, 0 }, Waist = { -22, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 20, 0, 25 }, RE = { 80, 0, 0 }, LS = { 20, 0, -25 }, LE = { 80, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.35, 0 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { -30, 0, 30 }, RE = { 20, 0, 0 }, LS = { -30, 0, -30 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.45, 0 }, Waist = { 14, 0, 0 }, Neck = { 45, 0, 0 }, RS = { -38, 0, 35 }, RE = { 20, 0, 0 }, LS = { -38, 0, -35 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			trail = "head", hitText = "TOC CASQUE !",
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
		-- Livreur pressé (dash puis P) : « Pardon, j'ai une commande ! », il fonce épaule en avant
		P_dash = {
			label = "Livreur pressé", startup = 0.06, active = 0.15, recovery = 0.22,
			damage = 8, hitbox = box(4, 4, 2, 0.5), kbBase = 28, kbGrowth = 52, kbAngle = 25, selfVelocity = Vector2.new(48, 0),
			windup = { Root = { -10, 20, 0, 0, -0.3, 0.1 }, Waist = { -6, 10, 0 }, Neck = { 0, -15, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { -20, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { -20, 45, 0, 0, -0.4, -0.25 }, Waist = { -10, 15, 0 }, Neck = { 0, -40, 0 }, RS = { 40, 0, 15 }, RE = { 70, 0, 0 }, LS = { -30, 0, -30 }, LE = { 40, 0, 0 } },
			follow = { Root = { -22, 50, 0, 0, -0.42, -0.3 }, Waist = { -12, 18, 0 }, Neck = { 0, -45, 0 }, RS = { 42, 0, 15 }, RE = { 70, 0, 0 }, LS = { -35, 0, -32 }, LE = { 40, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 6 } }, text = "J'AI UNE COMMANDE !", hitText = "BOUSCULÉ !",
		},

		-- Suites d'enchaînement (voir LINKS) : P P, P P P…
		-- P P : Coup de sac isotherme, il pivote sur lui-même et le gros sac cube cogne au passage
		P_combo2 = {
			label = "Coup de sac isotherme", startup = 0.07, active = 0.12, recovery = 0.16,
			damage = 6, hitbox = box(5, 3.5, 1.5, 0.6), kbBase = 18, kbGrowth = 24, kbAngle = 30,
			windup = { Root = { -4, -30, 0, 0, -0.2, 0 }, Waist = { -6, -20, 0 }, Neck = { 0, 20, 0 }, RS = { 30, 0, 45 }, RE = { 50, 0, 0 }, LS = { 30, 0, -45 }, LE = { 50, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.25, -0.1 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.25, -0.12 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 38, 0, 55 }, RE = { 35, 0, 0 }, LS = { 38, 0, -55 }, LE = { 35, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", hitText = "BOUF !",
		},
		-- P P P : Trottinette pliée, il lève la trottinette et l'abat comme un marteau
		P_combo3 = {
			label = "Trottinette pliée", startup = 0.13, active = 0.1, recovery = 0.28,
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
		-- Poussée de trottineur : le geste qui pousse la trottinette… mais droit dans le ventre de l'adversaire
		K_side = {
			label = "Poussée de trottineur", startup = 0.16, active = 0.12, recovery = 0.28,
			damage = 11, hitbox = box(5, 3, 3, 0), kbBase = 32, kbGrowth = 72, kbAngle = 28, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { 8, -10, 0, 0, -0.2, 0.15 }, Waist = { 6, -8, 0 }, Neck = { -4, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -120, 0, 0 }, RA = { -10, 0, 0 } },
			strike = { Root = { 16, 0, 0, 0, -0.15, -0.25 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 55 }, RE = { 30, 0, 0 }, LS = { 60, 0, -55 }, LE = { 30, 0, 0 }, RH = { 92, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, -0.15, -0.3 }, Waist = { 12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 62, 0, 60 }, RE = { 30, 0, 0 }, LS = { 62, 0, -60 }, LE = { 30, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", text = "POUSSE-TOI !", hitText = "PFOUM !",
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
		-- Tacle de trottoir (dash puis K) : il glisse sur une hanche, jambe droite tendue comme sur un trottoir mouillé
		K_dash = {
			label = "Tacle de trottoir", startup = 0.08, active = 0.25, recovery = 0.3,
			damage = 10, hitbox = box(6, 2.2, 3, -1.5), kbBase = 30, kbGrowth = 60, kbAngle = 40, selfVelocity = Vector2.new(58, 0),
			windup = { Root = { -10, 0, 0, 0, -0.5, 0 }, Waist = { -12, 0, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 } },
			strike = { Root = { 35, 0, 10, 0, -1.3, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 20, 0, 0 }, LS = { -30, 0, -60 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { 38, 0, 12, 0, -1.35, 0 }, Waist = { -20, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 125, 0, 55 }, RE = { 20, 0, 0 }, LS = { -35, 0, -62 }, LE = { 10, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 }, LH = { 55, 0, 0 }, LK = { -85, 0, 0 } },
			trail = "rightFoot", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 220, 220), dir = "up", at = "feet", time = 0.3, speed = 6 } }, hitText = "SBAM !",
		},

		-- Suites d'enchaînement : K K, K K K
		-- K K : Revers de trottinette, la trottinette revient de gauche à droite
		K_combo2 = {
			label = "Revers de trottinette", startup = 0.13, active = 0.1, recovery = 0.24,
			damage = 9, hitbox = box(5.5, 3, 3, 0.5), kbBase = 26, kbGrowth = 46, kbAngle = 30,
			windup = { Root = { -6, 35, 0, 0, -0.3, -0.3 }, Waist = { -8, 40, 0 }, Neck = { 0, -30, 0 }, RS = { 90, 0, -50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -8, -18, 0, 0, -0.3, -0.35 }, Waist = { -8, -26, 0 }, Neck = { 0, 18, 0 }, RS = { 92, 0, 45 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			follow = { Root = { -8, -26, 0, 0, -0.3, -0.38 }, Waist = { -8, -36, 0 }, Neck = { 0, 24, 0 }, RS = { 85, 0, 75 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 28, 0, -32 }, LE = { 80, 0, 0 } },
			trail = "prop", hitText = "VLAN !",
		},
		-- K K K : Wheelie au sol, il cabre la trottinette de bas en haut (fait décoller)
		K_combo3 = {
			label = "Wheelie au sol", startup = 0.16, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(5, 5, 2.5, 1.5), kbBase = 34, kbGrowth = 78, kbAngle = 78,
			windup = { Root = { -10, -10, 0, 0, -0.65, 0.1 }, Waist = { -20, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 10, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { 10, 5, 0, 0, 0.15, -0.2 }, Waist = { 14, 8, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, 10 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 12, 8, 0, 0, 0.2, -0.25 }, Waist = { 16, 10, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 160, 0, 10 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			trail = "prop", text = "CABRÉ !", hitText = "VROOOM !",
		},
		-- P puis K : Genou pressé, petit genou sec sans même lever les yeux de son téléphone
		PK_combo = {
			label = "Genou pressé", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(4, 3, 2.3, 0.3), kbBase = 20, kbGrowth = 28, kbAngle = 40,
			windup = { Root = { 4, -6, 0, 0, -0.2, 0.1 }, Neck = { 20, 20, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -10, 6, 0, 0, 0, -0.3 }, Waist = { -8, 4, 0 }, Neck = { 22, 20, 0 }, RS = { -10, 0, 40 }, RE = { 50, 0, 0 }, LS = { -10, 0, -40 }, LE = { 50, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -11, 6, 0, 0, 0.02, -0.32 }, Waist = { -9, 4, 0 }, Neck = { 22, 20, 0 }, RS = { -12, 0, 42 }, RE = { 50, 0, 0 }, LS = { -12, 0, -42 }, LE = { 50, 0, 0 }, RH = { 104, 0, 0 }, RK = { -122, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightLeg", hitText = "GNOC !",
		},
		-- K puis P : Klaxon de rappel, crochet du gauche avec la poire du klaxon
		KP_combo = {
			label = "Klaxon de rappel", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(4, 3, 2.5, 0.8), kbBase = 20, kbGrowth = 32, kbAngle = 30,
			windup = { Root = { 2, 25, 0, 0, -0.2, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 0, -15, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 75, 0, -70 }, LE = { 95, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.25, -0.3 }, Waist = { -8, -32, 0 }, Neck = { 0, 15, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 92, 0, -10 }, LE = { 75, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -9, -26, 0, 0, -0.25, -0.33 }, Waist = { -9, -40, 0 }, Neck = { 0, 20, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 88, 0, 15 }, LE = { 80, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "klaxon", trail = "leftHand", hitText = "POUEEET !",
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
		-- ↑ P en l'air : Guidon au ciel, la trottinette balaie l'air au-dessus de son casque
		P_air_up = {
			label = "Guidon au ciel", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 42, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -30, 0, 35 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 85, 0, 0 }, RK = { -115, 0, 0 }, LH = { 80, 0, 0 }, LK = { -115, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 195, 0, 5 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -28, 0, -50 }, LE = { 20, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
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
		-- → K en l'air : Coup de pied du coursier, jambe droite détendue à l'horizontale, buste en arrière
		K_air_side = {
			label = "Coup de pied du coursier", startup = 0.13, active = 0.12, recovery = 0.24,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 68, kbAngle = 35,
			windup = { Root = { -14, 20, 0 }, Waist = { -14, 10, 0 }, Neck = { 0, -10, 0 }, RS = { 50, 0, 45 }, RE = { 70, 0, 0 }, LS = { 70, 0, -30 }, LE = { 80, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 26, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, -10, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 68, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 30, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, -10, 0 }, RS = { -38, 0, 65 }, RE = { 20, 0, 0 }, LS = { 45, 0, -75 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Salto du coursier, salto arrière, les baskets passent au-dessus du casque
		K_air_up = {
			label = "Salto du coursier", startup = 0.12, active = 0.2, recovery = 0.24,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 64, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "SALTO !", hitText = "POC !",
		},
		-- ↓ K en l'air : Atterrissage sur colis, les deux pieds joints écrasent ce qui est dessous
		K_air_down = {
			label = "Atterrissage sur colis", startup = 0.16, active = 0.15, recovery = 0.28,
			damage = 11, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 170, 0, 50 }, RE = { 10, 0, 0 }, LS = { 170, 0, -50 }, LE = { 10, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "COLIS ÉCRASÉ !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Pizza frisbee : il sort une pizza du sac et la lance en revers comme un frisbee, très vite
		S_neutral = {
			label = "Pizza frisbee", kind = "projectile", energyCost = 20, startup = 0.12, active = 0, recovery = 0.26,
			damage = 7, kbBase = 18, kbGrowth = 30, kbAngle = 15,
			projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.5, size = 1.8, color = PIZZA,
				visual = { shape = "disc", size = 1.8, color = PIZZA, spin = 20, parts = {
					{ "cyl", Vector3.new(0.28, 0.4, 0.4), Vector3.new(0.4, 0.2, 0), Color3.fromRGB(200, 40, 30) },
					{ "cyl", Vector3.new(0.28, 0.4, 0.4), Vector3.new(-0.3, -0.35, 0), Color3.fromRGB(200, 40, 30) },
				} } },
			windup = { Root = { 0, 30, 0, 0, -0.2, 0.15 }, Waist = { 0, 35, 0 }, Neck = { 0, -25, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 70, 0, 60 }, LE = { 110, 0, 0 } },
			strike = { Root = { -6, -15, 0, 0, -0.25, -0.2 }, Waist = { -6, -20, 0 }, Neck = { 0, 10, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 90, 0, -40 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -6, -22, 0, 0, -0.25, -0.22 }, Waist = { -6, -28, 0 }, Neck = { 0, 15, 0 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 85, 0, -65 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
			text = "PIZZA !", hitText = "SPLAF !",
		},
		-- Rush trottinette : il saute sur la trottinette et traverse l'arène à fond
		S_side = {
			label = "Rush trottinette", energyCost = 25, startup = 0.1, active = 0.4, recovery = 0.3,
			damage = 10, hitbox = box(5, 3.5, 2.5, 0), kbBase = 32, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(85, 0),
			windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 0 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 50, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.2, -0.2 }, Waist = { -14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 18 }, LE = { 20, 0, 0 }, LH = { -40, 0, 0 }, LK = { -20, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.2, -0.22 }, Waist = { -16, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 72, 0, -10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 72, 0, 18 }, LE = { 20, 0, 0 }, LH = { -45, 0, 0 }, LK = { -25, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "body", fx = { { "particles", tex = "spark", color = ORANGE, dir = "up", at = "feet", time = 0.4, speed = 8 } }, text = "EN RETAAAARD !", hitText = "PAF !",
		},
		-- Colis « Livré ! » : il pose un colis piégé au sol ; il explose en confettis peu après qu'on y touche
		S_down = {
			label = "Colis « Livré ! »", kind = "trap", energyCost = 20, startup = 0.14, active = 0, recovery = 0.28,
			damage = 10, kbBase = 30, kbGrowth = 55, kbAngle = 70,
			trap = { size = Vector3.new(3, 2.5, 6), offset = 3, lifetime = 8, max = 2, armTime = 0.8, color = CARDBOARD, visual = PARCEL },
			windup = { Root = { -6, 0, 0, 0, -0.3, 0.1 }, Waist = { -16, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 80, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.75, -0.1 }, Waist = { -30, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 70, 0, 0 }, LE = { 10, 0, 0 } },
			follow = { Root = { -2, 0, 0, 0, -0.2, 0.1 }, Waist = { -4, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 150, 0, -20 }, LE = { 30, 0, 0 } },
			fx = { { "symbols", symbols = { "📦" }, count = 1, radius = 1, at = "front" } }, text = "LIVRÉ !", hitText = "CONFETTIS !",
		},
		-- Dérapage (après une esquive) : il revient en glissade, la trottinette en travers au ras du sol
		S_dodge = {
			label = "Dérapage", energyCost = 20, startup = 0.08, active = 0.3, recovery = 0.3,
			damage = 9, hitbox = box(7, 2, 3.5, -1.8), kbBase = 28, kbGrowth = 55, kbAngle = 65, selfVelocity = Vector2.new(50, 0),
			windup = { Root = { -6, 30, 0, 0, -0.5, 0 }, Waist = { -10, 20, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 30 }, RE = { 50, 0, 0 }, LS = { 40, 0, -30 }, LE = { 50, 0, 0 } },
			strike = { Root = { -10, 60, 0, 0, -0.9, -0.2 }, Waist = { -14, 20, 0 }, Neck = { 0, -40, 0 }, RS = { 60, 0, -20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -60 }, LE = { 20, 0, 0 } },
			follow = { Root = { -10, 75, 0, 0, -0.9, -0.25 }, Waist = { -14, 24, 0 }, Neck = { 0, -50, 0 }, RS = { 55, 0, -25 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 18, 0, -65 }, LE = { 20, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(210, 210, 210), dir = "up", at = "feet", time = 0.35, speed = 7 } }, text = "SKRRRT !", hitText = "DÉRAPÉ !",
		},
		-- Wheelie (remontée, gratuite) : il cabre la trottinette vers le haut et monte, roue avant devant lui
		S_up = {
			label = "Wheelie", energyCost = 0, startup = 0.05, active = 0.3, recovery = 0.3,
			damage = 7, hitbox = box(4, 6, 1, 2), kbBase = 30, kbGrowth = 40, kbAngle = 80, selfVelocity = Vector2.new(15, 88),
			windup = { Root = { -6, 0, 0, 0, -0.7, 0 }, Waist = { -14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 0 }, LE = { 40, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, 10 }, LE = { 10, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { -10, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.3, 0 }, Waist = { 12, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 175, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 170, 0, 10 }, LE = { 10, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { -15, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "prop", text = "WHEELIIIE !", hitText = "VROUM !",
		},
		-- Charge batterie (S maintenu) : il brandit la trottinette qui crépite ; turbo et une étoile de plus
		S_hold = {
			label = "Charge batterie", kind = "self", energyCost = 25, startup = 0.3, active = 0, recovery = 0.35,
			damage = 0, selfEffect = { buff = { "turbo", 3 }, meter = 1 },
			windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 30, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 172, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -45 }, LE = { 30, 0, 0 } },
			hold = 0.2, shake = true, windupFx = { { "particles", tex = "spark", color = STAR, dir = "all", at = "hand", time = 0.4, speed = 6 } },
			fx = { { "pillar", color = STAR, height = 8, width = 1.5 }, { "text", text = "BATTERIE 100 % !", color = STAR } }, text = "BZZZT !",
		},
		-- Raccourci GPS (→→S) : « Recalcul de l'itinéraire… », il disparaît et réapparaît plus loin
		S_dash = {
			label = "Raccourci GPS", kind = "self", energyCost = 25, startup = 0.1, active = 0, recovery = 0.22,
			damage = 0, teleport = 12, invuln = 0.25,
			windup = { Root = { -6, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 15, 0 }, RS = { 30, 0, 30 }, RE = { 50, 0, 0 }, LS = { 150, 0, 30 }, LE = { 120, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.2 }, Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 30, 0, 0 }, LS = { 60, 0, -10 }, LE = { 30, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.25, 0 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 25 }, RE = { 60, 0, 0 }, LS = { 40, 0, -25 }, LE = { 60, 0, 0 } },
			windupFx = { { "ring", color = SCREEN, radius = 3, at = "root" } }, fx = { { "burst", color = SCREEN, size = 3, at = "root" } },
			text = "RECALCUL DE L'ITINÉRAIRE…",
		},
		-- Colis express (S en l'air) : il lâche un colis qui rebondit une fois au sol
		S_air = {
			label = "Colis express", kind = "projectile", energyCost = 20, startup = 0.12, active = 0, recovery = 0.28,
			damage = 8, kbBase = 24, kbGrowth = 45, kbAngle = 40,
			projectile = { speed = 50, angle = -30, gravity = 60, lifetime = 0.9, size = 1.6, bounce = 1, color = CARDBOARD, visual = PARCEL },
			windup = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 150, 0, -10 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -14, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 40, 0, 45 }, RE = { 60, 0, 0 }, LS = { 50, 0, -10 }, LE = { 5, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -12, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 45 }, RE = { 60, 0, 0 }, LS = { 40, 0, -12 }, LE = { 5, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			text = "ATTENTION, FRAGILE !", hitText = "BOING !",
		},
		-- Livraison parachutée (↓S en l'air, plongeon) : bien droit, il tombe en piqué comme un colis largué
		S_air_down = {
			label = "Livraison parachutée", energyCost = 25, startup = 0.1, active = 0.35, recovery = 0.3,
			damage = 11, hitbox = box(4, 4, 0.5, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -90),
			windup = { Root = { 0, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, LS = { 170, 0, -30 }, LE = { 20, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 175, 0, 15 }, RE = { 10, 0, 0 }, LS = { 175, 0, -15 }, LE = { 10, 0, 0 }, RH = { 0, 0, 4 }, RK = { 0, 0, 0 }, RA = { -15, 0, 0 }, LH = { 0, 0, -4 }, LK = { 0, 0, 0 }, LA = { -15, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 178, 0, 18 }, RE = { 10, 0, 0 }, LS = { 178, 0, -18 }, LE = { 10, 0, 0 }, RH = { 0, 0, 5 }, RK = { -4, 0, 0 }, RA = { -15, 0, 0 }, LH = { 0, 0, -5 }, LK = { -4, 0, 0 }, LA = { -15, 0, 0 } },
			trail = "body", fx = { { "ring", color = TEAL, radius = 4, at = "feet" } }, text = "COLIS LARGUÉ !", hitText = "BOUM !",
		},
		-- Saut de trottoir (finition d'enchaînement, anti-air) : il saute comme sur un trottoir, genou et casque en avant
		S_finish_trottoir = {
			label = "Saut de trottoir", energyCost = 20, startup = 0.1, active = 0.15, recovery = 0.3,
			damage = 9, hitbox = box(4, 5, 1.5, 2.5), kbBase = 32, kbGrowth = 58, kbAngle = 82, selfVelocity = Vector2.new(8, 45),
			windup = { Root = { -10, 0, 0, 0, -0.75, 0.1 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 30 }, RE = { 40, 0, 0 }, LS = { -20, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.3, -0.1 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 20 }, RE = { 20, 0, 0 }, LS = { -30, 0, -40 }, LE = { 20, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, LH = { -10, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.35, -0.1 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 165, 0, 20 }, RE = { 20, 0, 0 }, LS = { -35, 0, -42 }, LE = { 20, 0, 0 }, RH = { 115, 0, 0 }, RK = { -125, 0, 0 }, LH = { -15, 0, 0 }, LK = { -25, 0, 0 } },
			trail = "rightLeg", text = "HOP, LE TROTTOIR !", hitText = "BOING !",
		},

		------------------------------------------------------------------ Supers
		-- Commande groupée : il tape sur son téléphone… et une vingtaine de colis tombent du ciel devant lui
		SUPER = {
			label = "Commande groupée !", kind = "projectile", superCost = 100, startup = 0.4, active = 0, recovery = 0.5,
			damage = 3, kbBase = 20, kbGrowth = 30, kbAngle = 60,
			projectile = { speed = 60, gravity = 0, lifetime = 0.7, size = 1.8, color = CARDBOARD, visual = PARCEL,
				rain = { count = 16, spread = 10, ahead = 9, height = 22, gap = 0.06 } },
			windup = { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { -6, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 50, 0, 20 }, LE = { 110, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 172, 0, -15 }, LE = { 10, 0, 0 } },
			hold = 0.3, prop = "telephone", windupFx = { { "screen", color = TEAL, alpha = 0.25 }, { "text", text = "COMMANDE VALIDÉE ✔", color = SCREEN } },
			fx = { { "symbols", symbols = { "📦", "📦", "⭐" }, count = 8, radius = 5, at = "above" }, { "shake", amount = 0.4 } },
			text = "COMMANDE GROUPÉE !", hitText = "LIVRÉ !",
		},
		-- Mode Turbo : il tape « livraison express » sur son casque, ses baskets fument : vitesse et note en hausse
		SUPER_down = {
			label = "Mode Turbo !", kind = "self", superCost = 100, startup = 0.35, active = 0, recovery = 0.3,
			damage = 0, selfEffect = { buff = { "turbo", 5 }, meter = 2, energy = 30 },
			windup = { Root = { 0, 0, 0, 0, -0.5, 0 }, Waist = { -16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 30 }, RE = { 60, 0, 0 }, LS = { 150, 0, 30 }, LE = { 130, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 30 }, RE = { 110, 0, 0 }, LS = { 20, 0, -30 }, LE = { 110, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 25 }, RE = { 90, 0, 0 }, LS = { -40, 0, -25 }, LE = { 90, 0, 0 } },
			hold = 0.2, windupFx = { { "screen", color = ORANGE, alpha = 0.3 } },
			fx = { { "particles", tex = "fire", color = ORANGE, dir = "up", at = "feet", time = 0.8, speed = 8 }, { "pillar", color = ORANGE, height = 10, width = 3 } },
			text = "MODE TURBO !",
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

-- Arbre d'enchaînements : rafales rapides (P P P), trottinette (K K K), et finitions S (pizza, saut de
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
	P_side = { P = "P_combo2", K = "K_neutral", S = "S_side" }, -- → P
	P_down = { P = "P_up", K = "K_combo3", S = "S_finish_trottoir" }, -- ↓ P
	P_up = { P = "P_combo3", S = "S_finish_trottoir" }, -- ↑ P
	K_down = { P = "P_combo2", K = "K_combo3", S = "S_dodge" }, -- ↓ K
	K_side = { P = "KP_combo", S = "S_side" }, -- → K
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

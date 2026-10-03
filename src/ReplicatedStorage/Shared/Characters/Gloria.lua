-- Gloria Zumba : prof de zumba survoltée, tout se fait en rythme. Arme sortie de la Caisse Bizarre :
-- l'enceinte fluo (et ses jambières de fitness, déjà au costume).
--
-- Même format que Gege.lua (voir son en-tête et docs/fiche-perso.md).
-- Mécanique « tempo » : un métronome bat toutes les 0,6 s ; un coup qui touche sur le temps fait +30 %.
-- Ses poses dansent : hanches qui chaloupent, bras en V, pointes de pied, grands battements de jambe.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local PEAU = Color3.fromRGB(150, 95, 65)
local ROSE = Color3.fromRGB(255, 45, 170)
local JAUNE = Color3.fromRGB(220, 255, 40)
local CYAN = Color3.fromRGB(40, 230, 255)
local VIOLET = Color3.fromRGB(120, 50, 210)
local CHEVEUX = Color3.fromRGB(45, 28, 20)
local BLANC = Color3.fromRGB(245, 245, 245)
local NOIR = Color3.fromRGB(25, 25, 30)
local OR = Color3.fromRGB(255, 200, 60)
local DISCO = Color3.fromRGB(210, 215, 230)

local data = {
	id = "Gloria",
	name = "Gloria Zumba",
	costume = "Gloria",
	style = "dance",

	look = {
		body = {
			head = PEAU, upper = ROSE, lower = ROSE, arms = PEAU, forearms = PEAU, hands = PEAU,
			legs = VIOLET, shins = JAUNE, feet = BLANC,
		},
		cubeHead = 1.25,
		parts = {
			-- grosse coiffure afro, queue haute et bandeau éponge
			{ "Afro", "Head", "ball", Vector3.new(1.85, 1.45, 1.75), Vector3.new(0, 0.62, 0.22), Vector3.zero, CHEVEUX, "Fabric" },
			{ "Queue", "Head", "ball", Vector3.new(1.0, 1.0, 1.0), Vector3.new(0, 1.35, 0.55), Vector3.zero, CHEVEUX, "Fabric" },
			{ "Chouchou", "Head", "cyl", Vector3.new(0.3, 0.55, 0.55), Vector3.new(0, 1.05, 0.45), Vector3.new(0, 0, 0), CYAN, "Fabric", { axis = "y" } },
			{ "Bandeau", "Head", "block", Vector3.new(1.32, 0.28, 1.32), Vector3.new(0, 0.32, 0), Vector3.zero, JAUNE, "Fabric" },
			-- visage : grands yeux, nez, sourire de prof motivée, créoles dorées
			{ "OeilG", "Head", "ball", Vector3.new(0.32, 0.36, 0.1), Vector3.new(-0.28, 0.05, -0.62), Vector3.zero, BLANC, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.32, 0.36, 0.1), Vector3.new(0.28, 0.05, -0.62), Vector3.zero, BLANC, "SmoothPlastic" },
			{ "PupilleG", "Head", "ball", Vector3.new(0.15, 0.17, 0.08), Vector3.new(-0.27, 0.03, -0.67), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "PupilleD", "Head", "ball", Vector3.new(0.15, 0.17, 0.08), Vector3.new(0.27, 0.03, -0.67), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "Nez", "Head", "block", Vector3.new(0.2, 0.28, 0.18), Vector3.new(0, -0.12, -0.7), Vector3.zero, Color3.fromRGB(130, 80, 55), "SmoothPlastic" },
			{ "Sourire", "Head", "block", Vector3.new(0.62, 0.14, 0.06), Vector3.new(0, -0.38, -0.63), Vector3.zero, Color3.fromRGB(230, 40, 90), "SmoothPlastic" },
			{ "CreoleG", "Head", "cyl", Vector3.new(0.06, 0.55, 0.55), Vector3.new(-0.68, -0.35, 0), Vector3.zero, OR, "Metal", { axis = "x" } },
			{ "CreoleD", "Head", "cyl", Vector3.new(0.06, 0.55, 0.55), Vector3.new(0.68, -0.35, 0), Vector3.zero, OR, "Metal", { axis = "x" } },
			-- justaucorps : bande cyan, sifflet de coach, banane fluo
			{ "Bande", "UpperTorso", "block", Vector3.new(2.04, 0.3, 1.04), Vector3.new(0, 0.15, 0), Vector3.zero, CYAN, "Fabric" },
			{ "Sifflet", "UpperTorso", "cyl", Vector3.new(0.4, 0.18, 0.18), Vector3.new(0.2, 0.25, -0.58), Vector3.new(0, 0, 0), BLANC, "SmoothPlastic", { axis = "x" } },
			{ "Cordon", "UpperTorso", "block", Vector3.new(0.08, 0.6, 0.06), Vector3.new(0.05, 0.55, -0.53), Vector3.new(0, 0, 20), JAUNE, "Fabric" },
			{ "Banane", "LowerTorso", "block", Vector3.new(1.1, 0.45, 0.4), Vector3.new(0, 0.05, -0.55), Vector3.zero, CYAN, "Fabric" },
			-- poignets éponge et revers des jambières
			{ "PoignetD", "RightLowerArm", "block", Vector3.new(0.6, 0.32, 0.6), Vector3.new(0, -0.35, 0), Vector3.zero, JAUNE, "Fabric" },
			{ "PoignetG", "LeftLowerArm", "block", Vector3.new(0.6, 0.32, 0.6), Vector3.new(0, -0.35, 0), Vector3.zero, ROSE, "Fabric" },
			{ "JambiereD", "RightLowerLeg", "block", Vector3.new(1.12, 0.3, 1.12), Vector3.new(0, 0.45, 0), Vector3.zero, ROSE, "Fabric" },
			{ "JambiereG", "LeftLowerLeg", "block", Vector3.new(1.12, 0.3, 1.12), Vector3.new(0, 0.45, 0), Vector3.zero, ROSE, "Fabric" },
		},
		props = {
			-- l'arme : l'enceinte portable fluo tenue par sa poignée
			{ name = "PropEnceinte", hand = "Right", visible = true, pieces = {
				{ "Poignee", "", "block", Vector3.new(0.2, 0.5, 0.9), Vector3.new(0, -0.3, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Caisson", "", "block", Vector3.new(0.85, 1.05, 2.0), Vector3.new(0, -1.05, 0), Vector3.zero, JAUNE, "SmoothPlastic" },
				{ "Neon", "", "block", Vector3.new(0.9, 0.14, 2.05), Vector3.new(0, -0.55, 0), Vector3.zero, ROSE, "Neon", { neon = true } },
				{ "HautParleurAv", "", "cyl", Vector3.new(0.1, 0.72, 0.72), Vector3.new(0.44, -1.1, -0.5), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
				{ "HautParleurAr", "", "cyl", Vector3.new(0.1, 0.72, 0.72), Vector3.new(0.44, -1.1, 0.5), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
				{ "TweeterG", "", "cyl", Vector3.new(0.1, 0.72, 0.72), Vector3.new(-0.44, -1.1, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
			} },
			-- boule à facettes (plongeon, Final disco)
			{ name = "PropBoule", hand = "Right", visible = false, pieces = {
				{ "Chaine", "", "cyl", Vector3.new(0.1, 0.8, 0.1), Vector3.new(0, -0.4, 0), Vector3.zero, DISCO, "Metal", { axis = "y" } },
				{ "Boule", "", "ball", Vector3.new(2.4, 2.4, 2.4), Vector3.new(0, -1.9, 0), Vector3.zero, DISCO, "Foil", { reflect = 0.5, light = { Color3.fromRGB(255, 150, 255), 12, 2 } } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Clap en rythme : bras grands ouverts sur le temps, puis l'enceinte claque contre la paume gauche
		P_neutral = {
			label = "Clap en rythme", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 5, hitbox = box(4, 3, 2.5, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { 2, 0, 0, 0, -0.08, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 70, 0, 62 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -62 }, LE = { 20, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.28, -0.2 }, Waist = { -6, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 92, 0, -12 }, RE = { 12, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 14 }, LE = { 12, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -0.3, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 96, 0, -16 }, RE = { 16, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, 18 }, LE = { 16, 0, 0 } },
			trail = "prop", fx = { { "symbols", symbols = { "♪" }, count = 2, radius = 2, color = ROSE } }, text = "CLAP !", hitText = "CLAP !",
		},
		-- Coude salsa : hanches qui tournent, pas en avant, le coude droit part en premier et l'enceinte suit
		P_side = {
			label = "Coude salsa", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 7, hitbox = box(4.5, 3, 2.8, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 22, selfVelocity = Vector2.new(22, 0),
			windup = { Root = { 4, -30, 0, 0, -0.22, 0.2 }, Waist = { 4, -26, -6 }, Neck = { 0, 20, 0 }, RS = { 60, 0, 72 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 45, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -8, 24, 0, 0, -0.32, -0.45 }, Waist = { -8, 30, 6 }, Neck = { 0, -14, 0 }, RS = { 88, 0, -8 }, RE = { 140, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -10, 32, 0, 0, -0.34, -0.5 }, Waist = { -10, 38, 8 }, Neck = { 0, -20, 0 }, RS = { 84, 0, -18 }, RE = { 138, 0, 0 }, RW = { -10, 0, 0 }, LS = { -28, 0, -45 }, LE = { 55, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "rightHand", text = "SALSA !", hitText = "AZÚCAR !",
		},
		-- Twist balayé : accroupie sur les talons, elle twiste un tour complet sur elle-même, la jambe droite tendue
		-- qui balaie le sol comme une aiguille de pendule
		P_down = {
			label = "Twist balayé", startup = 0.1, active = 0.14, recovery = 0.18,
			damage = 6, hitbox = box(6.5, 2.5, 2, -1.8), kbBase = 25, kbGrowth = 22, kbAngle = 75,
			windup = { Root = { -6, -30, 0, 0, -0.85, 0.1 }, Waist = { -10, -20, 8 }, Neck = { 0, 20, 0 }, RS = { 40, 0, 60 }, RE = { 110, 0, 0 }, LS = { 40, 0, -60 }, LE = { 110, 0, 0 }, RH = { 60, 0, 30 }, RK = { -120, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -1.0, -0.1 }, Waist = { -14, 0, -6 }, Neck = { 6, 0, 0 }, RS = { 20, 0, 70 }, RE = { 90, 0, 0 }, LS = { 20, 0, -70 }, LE = { 90, 0, 0 }, RH = { 76, 0, 12 }, RK = { -4, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -8, 0, 0, 0, -1.0, -0.12 }, Waist = { -14, 0, -8 }, Neck = { 6, 0, 0 }, RS = { 18, 0, 72 }, RE = { 90, 0, 0 }, LS = { 18, 0, -72 }, LE = { 90, 0, 0 }, RH = { 74, 0, 12 }, RK = { -6, 0, 0 }, RA = { -20, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", fx = { { "symbols", symbols = { "♪" }, count = 2, radius = 2, color = JAUNE, at = "feet" } }, text = "TWIST !", hitText = "ZOUIP !",
		},
		-- Boombox au ciel (anti-air) : petit plié, hanche sortie, puis elle se hisse sur les pointes et brandit
		-- l'enceinte à bout de bras au-dessus de sa tête comme un ghetto-blaster, l'autre main sur la hanche
		P_up = {
			label = "Boombox au ciel", startup = 0.09, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 5, 1, 3.5), kbBase = 28, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -4, 0, 8, 0.1, -0.5, 0 }, Waist = { -10, 0, 10 }, Neck = { -8, 0, -8 }, RS = { 30, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, -40 } },
			strike = { Root = { 4, 0, -10, -0.15, 0.3, 0 }, Waist = { 8, 0, -14 }, Neck = { 24, 0, 10 }, RS = { 180, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -35 }, LE = { 115, 0, 0 }, LW = { 0, 0, -40 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 6, 0, -12, -0.18, 0.35, 0 }, Waist = { 10, 0, -16 }, Neck = { 28, 0, 12 }, RS = { 186, 0, 14 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 10, 0, -36 }, LE = { 116, 0, 0 }, LW = { 0, 0, -40 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			trail = "prop", fx = { { "symbols", symbols = { "♪", "♫" }, count = 3, radius = 2, at = "above", color = CYAN } }, text = "ET LES BRAS EN L'AIR !", hitText = "WOOH !",
		},
		-- Saut étoile : en l'air, recroquevillée puis bras et jambes s'ouvrent en étoile (zone large)
		P_air = {
			label = "Saut étoile", startup = 0.08, active = 0.14, recovery = 0.16,
			damage = 7, hitbox = box(7, 6, 1, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 45,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, -20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 100, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 90, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 130, 0, 80 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -80 }, LE = { 0, 0, 0 }, RH = { 10, 0, 32 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 10, 0, -32 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 135, 0, 85 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 135, 0, -85 }, LE = { 0, 0, 0 }, RH = { 12, 0, 36 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 12, 0, -36 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			fx = { { "burst", color = JAUNE, size = 3, at = "root" } }, text = "ÉTOILE !", hitText = "TCHAC !",
		},
		-- Shimmy d'épaule (dash puis P) : elle file en avant poitrine bombée, les bras rejetés en arrière, et les épaules
		-- tremblent en shimmy jusqu'à l'impact : c'est le buste qui frappe
		P_dash = {
			label = "Shimmy d'épaule", startup = 0.08, active = 0.15, recovery = 0.24,
			damage = 8, hitbox = box(4.5, 4, 2.5, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { 4, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -30, 0, 40 }, RE = { 30, 0, 0 }, LS = { -30, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.3, -0.3 }, Waist = { 4, 0, 0 }, Neck = { 14, 0, 0 }, RS = { -50, 0, 55 }, RE = { 10, 0, 0 }, LS = { -50, 0, -55 }, LE = { 10, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.32, -0.35 }, Waist = { 6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { -55, 0, 60 }, RE = { 10, 0, 0 }, LS = { -55, 0, -60 }, LE = { 10, 0, 0 } },
			shake = true, wobble = true, trail = "body", fx = { "dust", { "symbols", symbols = { "✨" }, count = 3, radius = 2, color = ROSE } }, text = "SHIMMY !", hitText = "BOUM-TCHAK !",
		},

		-- P P : Clap au-dessus, elle claque l'enceinte contre sa paume au-dessus de la tête (fait décoller)
		P_combo2 = {
			label = "Clap au-dessus", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(5, 4.5, 2.5, 1.5), kbBase = 20, kbGrowth = 22, kbAngle = 65,
			windup = { Root = { -4, 0, 0, 0, -0.35, 0 }, Waist = { -6, 0, 0 }, RS = { 30, 0, 52 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -52 }, LE = { 30, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.05, -0.1 }, Waist = { 8, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 168, 0, -8 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 168, 0, 8 }, LE = { 6, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.0, -0.12 }, Waist = { 10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 172, 0, -10 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 172, 0, 10 }, LE = { 10, 0, 0 } },
			trail = "prop", text = "CLAP-CLAP !", hitText = "CLAP !",
		},
		-- P P P P : High kick du refrain, la jambe droite monte à la verticale sur le temps fort (finition, fait décoller)
		P_combo3 = {
			label = "High kick du refrain", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(5, 5.5, 3, 1.8), kbBase = 36, kbGrowth = 78, kbAngle = 72,
			windup = { Root = { -4, 0, 0, 0, -0.15, 0.1 }, Waist = { -6, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { -115, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 16, 0, 0, 0, -0.1, 0.15 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 100, 0, 82 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -82 }, LE = { 0, 0, 0 }, RH = { 152, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, -0.1, 0.18 }, Waist = { 14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 104, 0, 86 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 104, 0, -86 }, LE = { 0, 0, 0 }, RH = { 160, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", text = "ET HIGH KICK !", hitText = "WOOH !",
		},
		-- → P P : Tour de salsa, elle tourne sur elle-même, enceinte à bout de bras
		P_side2 = {
			label = "Tour de salsa", startup = 0.08, active = 0.14, recovery = 0.22,
			damage = 7, hitbox = box(6.5, 4, 2.5, 0.5), kbBase = 24, kbGrowth = 38, kbAngle = 30,
			windup = { Root = { 0, -30, 0, 0, -0.25, 0 }, Waist = { 0, -20, 0 }, RS = { 70, 0, 30 }, RE = { 60, 0, 0 }, LS = { 150, 0, -20 }, LE = { 40, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -0.05, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 30, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.05, 0 }, Neck = { 12, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, -8 }, LE = { 30, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", text = "VUELTA !", hitText = "OLÉ !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- High kick : genou monté, bras en V, puis la jambe droite se détend à hauteur de tête, buste en arrière
		K_neutral = {
			label = "High kick", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3.5, 3, 1.5), kbBase = 30, kbGrowth = 70, kbAngle = 45,
			windup = { Root = { 6, -8, 0, 0, -0.12, 0.15 }, Waist = { 6, -6, 0 }, Neck = { 6, 0, 0 }, RS = { 140, 0, 45 }, RE = { 15, 0, 0 }, LS = { 140, 0, -45 }, LE = { 15, 0, 0 }, RH = { 88, 0, 0 }, RK = { -118, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 16, -4, 0, 0, -0.1, 0.12 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 88 }, RE = { 0, 0, 0 }, LS = { 92, 0, -88 }, LE = { 0, 0, 0 }, RH = { 125, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 18, -2, 0, 0, -0.1, 0.15 }, Waist = { 14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 95, 0, 90 }, RE = { 0, 0, 0 }, LS = { 95, 0, -90 }, LE = { 0, 0, 0 }, RH = { 134, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", text = "HIGH KICK !", hitText = "PAF !",
		},
		-- Pas chassé frappé : petit pas glissé en avant, puis la jambe droite part tendue au niveau du ventre
		K_side = {
			label = "Pas chassé frappé", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 3, 3.2, 0.3), kbBase = 32, kbGrowth = 80, kbAngle = 28, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 2, -14, 0, 0, -0.05, 0.1 }, Waist = { 4, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 40, 0, 50 }, RE = { 70, 0, 0 }, LS = { 70, 0, -40 }, LE = { 60, 0, 0 }, RH = { 62, 0, 0 }, RK = { -105, 0, 0 }, RA = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0.1, -0.3 } },
			strike = { Root = { 14, 6, 0, 0, -0.15, -0.35 }, Waist = { 12, 4, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 45 }, RE = { 20, 0, 0 }, LS = { 85, 0, -40 }, LE = { 10, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { 16, 8, 0, 0, -0.15, -0.42 }, Waist = { 14, 4, 0 }, Neck = { -12, 0, 0 }, RS = { -36, 0, 48 }, RE = { 20, 0, 0 }, LS = { 88, 0, -44 }, LE = { 10, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "rightFoot", text = "CHASSÉ !", hitText = "VLAN !",
		},
		-- Grand écart frappé : petit saut, puis elle tombe en grand écart, le talon avant fauche au sol
		K_down = {
			label = "Grand écart frappé", startup = 0.18, active = 0.14, recovery = 0.38,
			damage = 11, hitbox = box(6.5, 2, 3, -2), kbBase = 30, kbGrowth = 60, kbAngle = 70,
			windup = { Root = { 0, 0, 0, 0, 0.15, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 30 }, RE = { 10, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { -20, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -1.55, 0 }, Waist = { 4, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 60 }, RE = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 0, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -82, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -1.6, 0 }, Waist = { 6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 155, 0, 70 }, RE = { 0, 0, 0 }, LS = { 155, 0, -70 }, LE = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -84, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			hold = 0.08, trail = "bothFeet", fx = { "dust" }, text = "GRAND ÉCART !", hitText = "CRAC !",
		},
		-- Grand battement (anti-air, ex-←K) : jambe tendue lancée droit vers le ciel, bras ouverts en T
		K_up = {
			label = "Grand battement", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(4, 5, 1.5, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 86,
			windup = { Root = { -4, 0, 0, 0, -0.3, 0.05 }, Waist = { -6, 0, 0 }, RS = { 20, 0, 20 }, RE = { 30, 0, 0 }, LS = { 20, 0, -20 }, LE = { 30, 0, 0 }, RH = { 35, 0, 0 }, RK = { -60, 0, 0 }, RA = { -25, 0, 0 } },
			strike = { Root = { 18, 0, 0, 0, -0.05, 0.15 }, Waist = { 12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 90, 0, 82 }, RE = { 0, 0, 0 }, LS = { 90, 0, -82 }, LE = { 0, 0, 0 }, RH = { 168, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 20, 0, 0, 0, -0.05, 0.18 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 92, 0, 86 }, RE = { 0, 0, 0 }, LS = { 92, 0, -86 }, LE = { 0, 0, 0 }, RH = { 176, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightLeg", text = "ET HAUT !", hitText = "TCHAK !",
		},
		-- Saut de biche : en l'air, jambe avant tendue et jambe arrière repliée, bras levés en couronne
		K_air = {
			label = "Saut de biche", startup = 0.16, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 3.5, 3, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 92, 0, 0 }, RK = { -125, 0, 0 }, LH = { 30, 0, 0 }, LK = { -95, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 40 }, RE = { 30, 0, 0 }, LS = { 160, 0, -40 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -50, 0, 0 }, LK = { -80, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 165, 0, 45 }, RE = { 30, 0, 0 }, LS = { 165, 0, -45 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -55, 0, 0 }, LK = { -85, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "rightFoot", hitText = "BAM !",
		},
		-- Jeté volant (dash puis K) : grand jeté de danseuse vers l'avant, jambe droite en lance
		K_dash = {
			label = "Jeté volant", startup = 0.1, active = 0.24, recovery = 0.3,
			damage = 11, hitbox = box(6, 3, 3, 0), kbBase = 30, kbGrowth = 65, kbAngle = 35, selfVelocity = Vector2.new(52, 30),
			windup = { Root = { -10, 0, 0, 0, -0.45, 0 }, Waist = { -12, 0, 0 }, RS = { 30, 0, 40 }, RE = { 40, 0, 0 }, LS = { 40, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 140, 0, 30 }, RE = { 10, 0, 0 }, LS = { 100, 0, -70 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -60, 0, 0 }, LK = { -10, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { -4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 145, 0, 32 }, RE = { 10, 0, 0 }, LS = { 105, 0, -74 }, LE = { 10, 0, 0 }, RH = { 94, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -64, 0, 0 }, LK = { -10, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "bothFeet", text = "JETÉ !", hitText = "SBAM !",
		},

		-- K K : Battement gauche, la jambe gauche répond à la droite, bras en V
		K_combo2 = {
			label = "Battement gauche", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 4, 3, 1), kbBase = 24, kbGrowth = 40, kbAngle = 40,
			windup = { Root = { 4, 20, 0, 0, -0.15, 0.1 }, Waist = { 4, 12, 0 }, Neck = { 0, -12, 0 }, RS = { 120, 0, 60 }, RE = { 20, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 }, LA = { -20, 0, 0 } },
			strike = { Root = { 14, 12, 0, 0, -0.1, 0 }, Waist = { 10, 8, 0 }, Neck = { -8, 0, 0 }, RS = { 95, 0, 85 }, RE = { 0, 0, 0 }, LS = { 95, 0, -85 }, LE = { 0, 0, 0 }, LH = { 118, 0, 0 }, LK = { -5, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 16, 14, 0, 0, -0.1, 0.02 }, Waist = { 12, 10, 0 }, Neck = { -10, 0, 0 }, RS = { 98, 0, 88 }, RE = { 0, 0, 0 }, LS = { 98, 0, -88 }, LE = { 0, 0, 0 }, LH = { 126, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "leftFoot", text = "ET DE L'AUTRE !", hitText = "TCHAK !",
		},
		-- K K K K : Grand jeté, elle s'envole en grand jeté de danseuse, jambe droite en lance (finition)
		K_combo3 = {
			label = "Grand jeté", startup = 0.1, active = 0.14, recovery = 0.32,
			damage = 12, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 82, kbAngle = 40, selfVelocity = Vector2.new(18, 42),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, RS = { -30, 0, 35 }, RE = { 30, 0, 0 }, LS = { -30, 0, -35 }, LE = { 30, 0, 0 } },
			strike = { Root = { 8, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 165, 0, 35 }, RE = { 10, 0, 0 }, LS = { 115, 0, -75 }, LE = { 10, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -55, 0, 0 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 10, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 170, 0, 38 }, RE = { 10, 0, 0 }, LS = { 118, 0, -78 }, LE = { 10, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -60, 0, 0 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "bothFeet", text = "GRAND JETÉ !", hitText = "BAM !",
		},
		-- P puis K : Kick-ball-change, petit coup de pied sec dans le tibia et changement d'appui
		PK_combo = {
			label = "Kick-ball-change", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { 2, -10, 0, 0, -0.1, 0.1 }, Waist = { 4, -10, 0 }, RS = { 40, 0, 40 }, RE = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { -20, 0, 6 }, RK = { -70, 0, 0 } },
			strike = { Root = { -4, 10, 0, 0, -0.2, -0.2 }, Waist = { -6, 10, 0 }, RS = { 20, 0, 55 }, RE = { 40, 0, 0 }, LS = { 70, 0, -45 }, LE = { 50, 0, 0 }, RH = { 60, 0, 4 }, RK = { -5, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -6, 14, 0, 0, -0.25, -0.25 }, Waist = { -6, 12, 0 }, RS = { 15, 0, 58 }, RE = { 40, 0, 0 }, LS = { 72, 0, -46 }, LE = { 50, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", text = "KICK-BALL-CHANGE !", hitText = "TOC !",
		},
		-- K puis P : Pointé disco, déhanché puis l'enceinte monte en diagonale vers le ciel (fait décoller)
		KP_combo = {
			label = "Pointé disco", startup = 0.08, active = 0.1, recovery = 0.24,
			damage = 8, hitbox = box(5, 4.5, 2.5, 1.5), kbBase = 26, kbGrowth = 40, kbAngle = 62,
			windup = { Root = { 2, -16, -6, 0, -0.3, 0.1 }, Waist = { 0, -14, -10 }, Neck = { 0, 10, 0 }, RS = { 35, 0, -30 }, RE = { 95, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { 4, 16, 8, 0, -0.1, -0.25 }, Waist = { 6, 16, 12 }, Neck = { 14, -10, 0 }, RS = { 160, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -15, 0, -40 }, LE = { 20, 0, 0 } },
			follow = { Root = { 4, 18, 10, 0, -0.1, -0.28 }, Waist = { 8, 18, 14 }, Neck = { 18, -12, 0 }, RS = { 166, 0, 44 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -18, 0, -42 }, LE = { 20, 0, 0 } },
			hold = 0.08, trail = "prop", text = "DISCO !", hitText = "STAYIN' ALIVE !",
		},

		-- P P P : Coup de hanche cha-cha, un-deux de hanches sur le temps et la hanche droite percute, bras en l'air
		P_hanche = {
			label = "Coup de hanche cha-cha", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(5, 4, 2.8, 0.6), kbBase = 20, kbGrowth = 26, kbAngle = 35, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { 0, -40, -8, 0.15, -0.15, 0.1 }, Waist = { 0, -20, -14 }, Neck = { 0, 30, 0 }, RS = { 30, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { -4, -80, 14, -0.35, -0.25, -0.3 }, Waist = { 0, 10, 18 }, Neck = { 4, 55, 0 }, RS = { 20, 0, 60 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -20 }, LE = { 10, 0, 0 } },
			follow = { Root = { -4, -84, 16, -0.38, -0.25, -0.34 }, Waist = { 0, 12, 20 }, Neck = { 4, 58, 0 }, RS = { 18, 0, 62 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 168, 0, -22 }, LE = { 10, 0, 0 } },
			wobble = true, trail = "body", fx = { { "symbols", symbols = { "♪" }, count = 2, radius = 2, color = ROSE, at = "root" } }, text = "CHA-CHA-CHA !", hitText = "BOUM-HANCHE !",
		},
		-- → P P P : Dip de tango, elle plonge en arrière en grand cambré… et abat l'enceinte sur le crâne d'en face (finition)
		P_dip = {
			label = "Dip de tango", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 76, kbAngle = 26,
			windup = { Root = { 22, 0, 0, 0, -0.3, 0.3 }, Waist = { 26, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 190, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -70 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.3 } },
			strike = { Root = { -16, 0, 0, 0, -0.45, -0.45 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -20, 0, 0, 0, -0.5, -0.5 }, Waist = { -28, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 60, 0, 0 }, RE = { 0, 0, 0 }, RW = { -45, 0, 0 }, LS = { 155, 0, -65 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "prop", fx = { { "symbols", symbols = { "🌹", "♪" }, count = 3, radius = 2.5, color = ROSE }, { "burst", color = CYAN, size = 3, at = "front" } }, text = "TANGO !", hitText = "OLÉ-BOUM !",
		},
		-- ↓ P P : Twist remontant, elle remonte en tordant le bassin dans l'autre sens, les deux coudes frappent au passage
		P_twist2 = {
			label = "Twist remontant", startup = 0.07, active = 0.14, recovery = 0.18,
			damage = 3, hits = 2, hitbox = box(5, 4.5, 2.8, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 50,
			windup = { Root = { -8, 40, 0, 0, -0.8, 0 }, Waist = { -12, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 50 }, RE = { 120, 0, 0 }, LS = { 40, 0, -50 }, LE = { 120, 0, 0 } },
			strike = { Root = { -4, -40, 0, 0, -0.3, -0.2 }, Waist = { -6, -34, 0 }, Neck = { 0, 24, 0 }, RS = { 90, 0, 60 }, RE = { 130, 0, 0 }, LS = { 90, 0, -60 }, LE = { 130, 0, 0 } },
			follow = { Root = { 0, 40, 0, 0, -0.1, -0.2 }, Waist = { 0, 34, 0 }, Neck = { 0, -24, 0 }, RS = { 90, 0, 60 }, RE = { 130, 0, 0 }, LS = { 90, 0, -60 }, LE = { 130, 0, 0 } },
			wobble = true, trail = "body", fx = { { "symbols", symbols = { "♫" }, count = 2, radius = 2, color = JAUNE } }, text = "TWIST !", hitText = "COUDE-COUDE !",
		},
		-- ↓ P P P : Mambo !, deux pas de mambo et l'enceinte part en uppercut vers le ciel (finition, fait décoller)
		P_mambo = {
			label = "Mambo !", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 5.5, 3, 1.8), kbBase = 34, kbGrowth = 74, kbAngle = 78,
			windup = { Root = { -6, -20, 6, 0, -0.5, 0.1 }, Waist = { -12, -16, 8 }, Neck = { 0, 14, 0 }, RS = { -30, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			strike = { Root = { 10, 14, -8, 0, 0.1, -0.25 }, Waist = { 14, 18, -10 }, Neck = { 24, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.2, -0.3 } },
			follow = { Root = { 12, 16, -10, 0, 0.15, -0.3 }, Waist = { 16, 20, -12 }, Neck = { 28, 0, 0 }, RS = { 182, 0, 6 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -25, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.25, -0.3 } },
			trail = "prop", fx = { { "pillar", color = ROSE, height = 8, width = 2, at = "front" }, { "symbols", symbols = { "♪", "♫", "!" }, count = 4, radius = 3, color = CYAN } }, text = "MAMBO !", hitText = "NUMBER FIVE !",
		},
		-- K K K : French cancan, trois coups de pied en l'air à la suite en tenant une jupe imaginaire
		K_cancan = {
			label = "French cancan", startup = 0.07, active = 0.22, recovery = 0.2,
			damage = 4, hits = 3, hitbox = box(5, 5, 3, 1.5), kbBase = 18, kbGrowth = 26, kbAngle = 55,
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 50 }, RE = { 110, 0, 0 }, LS = { 30, 0, -50 }, LE = { 110, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 60 }, RE = { 110, 0, 0 }, LS = { 30, 0, -60 }, LE = { 110, 0, 0 }, RH = { 140, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 14, 0, 0, 0, -0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 60 }, RE = { 110, 0, 0 }, LS = { 30, 0, -60 }, LE = { 110, 0, 0 }, LH = { 140, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			wobble = true, trail = "bothFeet", fx = { { "symbols", symbols = { "♪", "♫", "💃" }, count = 4, radius = 3, color = ROSE } }, text = "CAN-CAN !", hitText = "OUH-LÀ-LÀ !",
		},
		-- → K K : Chassé-croisé, elle croise les jambes en sautillant et la jambe gauche part en fouetté
		K_side2 = {
			label = "Chassé-croisé", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(5.5, 4, 3.2, 0.8), kbBase = 22, kbGrowth = 32, kbAngle = 32, selfVelocity = Vector2.new(16, 0),
			windup = { Root = { 4, 30, 0, 0, -0.2, 0.1 }, Waist = { 4, 20, 0 }, Neck = { 0, -20, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, LH = { 30, 0, -20 }, LK = { -90, 0, 0 } },
			strike = { Root = { 12, -20, 0, 0, -0.1, -0.2 }, Waist = { 10, -16, 0 }, Neck = { -8, 10, 0 }, RS = { 90, 0, 80 }, RE = { 0, 0, 0 }, LS = { 90, 0, -80 }, LE = { 0, 0, 0 }, LH = { 100, 0, 10 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 14, -24, 0, 0, -0.1, -0.24 }, Waist = { 12, -18, 0 }, Neck = { -10, 12, 0 }, RS = { 92, 0, 84 }, RE = { 0, 0, 0 }, LS = { 92, 0, -84 }, LE = { 0, 0, 0 }, LH = { 106, 0, 10 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "leftFoot", text = "ET CROISÉ !", hitText = "TCHAK !",
		},
		-- → K K K : Grand écart sauté, elle saute et retombe en grand écart, les deux talons fauchent de chaque côté (finition)
		K_side3 = {
			label = "Grand écart sauté", startup = 0.1, active = 0.14, recovery = 0.36,
			damage = 12, hitbox = box(7, 4, 2.5, 0.5), kbBase = 36, kbGrowth = 80, kbAngle = 35, selfVelocity = Vector2.new(14, 30),
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.1 }, Waist = { -10, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.2, -0.2 }, Waist = { 6, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 95, 0, 88 }, RE = { 0, 0, 0 }, LS = { 95, 0, -88 }, LE = { 0, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -86, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 2, 0, 0, 0, -1.5, -0.2 }, Waist = { 6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 150, 0, 60 }, RE = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -86, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "bothFeet", fx = { "dust", { "shake", amount = 0.3 }, { "burst", color = JAUNE, size = 3, at = "feet" } }, text = "GRAND ÉCART !", hitText = "CRAAAC !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Ciseaux aériens, les jambes se croisent deux fois devant elle
		P_air_side = {
			label = "Ciseaux aériens", startup = 0.09, active = 0.14, recovery = 0.18,
			damage = 4, hits = 2, hitbox = box(5, 3, 3, 0), kbBase = 22, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { -14, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 70, 0, 50 }, RE = { 50, 0, 0 }, LS = { 70, 0, -50 }, LE = { 50, 0, 0 }, RH = { -30, 0, 0 }, RK = { -40, 0, 0 }, LH = { 80, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 18, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -20, 0, 60 }, RE = { 20, 0, 0 }, LS = { -20, 0, -60 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -30, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -25, 0, 62 }, RE = { 20, 0, 0 }, LS = { -25, 0, -62 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -10, 0, 0 }, RA = { 15, 0, 0 }, LH = { 95, 0, 0 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "CISEAUX !", hitText = "CLIC-CLAC !",
		},
		-- ↑ P en l'air : Enceinte au plafond, l'enceinte décrit un grand arc au-dessus de sa tête
		P_air_up = {
			label = "Enceinte au plafond", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { -40, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 165, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -45 }, LE = { 20, 0, 0 }, RH = { 0, 0, 0 }, RK = { -20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 200, 0, 5 }, RE = { 10, 0, 0 }, RW = { -15, 0, 0 }, LS = { 155, 0, -50 }, LE = { 20, 0, 0 }, RH = { -5, 0, 0 }, RK = { -15, 0, 0 }, LH = { 5, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "prop", hitText = "BOOM-BOOM !",
		},
		-- ↓ P en l'air : Squat-punch descendant, genoux à la poitrine et l'enceinte cognée vers le sol
		P_air_down = {
			label = "Squat-punch descendant", startup = 0.15, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78,
			windup = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 185, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 40, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 90, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 45, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 25, 0, 5 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { 65, 0, -55 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -125, 0, 0 }, LH = { 95, 0, 0 }, LK = { -125, 0, 0 } },
			trail = "prop", text = "SQUAT !", hitText = "BOUM !",
		},
		-- → K en l'air : Coup de pied jazz, buste couché en arrière, jambe droite fouette à l'horizontale
		K_air_side = {
			label = "Coup de pied jazz", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 32,
			windup = { Root = { -12, 15, 0 }, Waist = { -14, 10, 0 }, RS = { 160, 0, 30 }, RE = { 50, 0, 0 }, LS = { 70, 0, -50 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, RA = { 10, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 26, 20, 0 }, Waist = { 10, 5, 0 }, Neck = { -14, 0, 0 }, RS = { 170, 0, 60 }, RE = { 10, 0, 0 }, LS = { 40, 0, -80 }, LE = { 20, 0, 0 }, RH = { 66, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			follow = { Root = { 30, 22, 0 }, Waist = { 12, 5, 0 }, Neck = { -16, 0, 0 }, RS = { 175, 0, 65 }, RE = { 10, 0, 0 }, LS = { 42, 0, -84 }, LE = { 20, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 12, 0, 0 }, LK = { -100, 0, 0 } },
			trail = "rightFoot", text = "JAZZ !", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Salto pom-pom, salto arrière, les pieds balaient l'air au-dessus de sa tête
		K_air_up = {
			label = "Salto pom-pom", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, LS = { 170, 0, -30 }, LE = { 20, 0, 0 }, RH = { 70, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 170, 0, 60 }, RE = { 10, 0, 0 }, LS = { 170, 0, -60 }, LE = { 10, 0, 0 }, RH = { 155, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 165, 0, 65 }, RE = { 10, 0, 0 }, LS = { 165, 0, -65 }, LE = { 10, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "POM-POM !", hitText = "POC !",
		},
		-- ↓ K en l'air : Talon métronome, jambes serrées et pointes vers le bas, elle tombe comme un métronome
		K_air_down = {
			label = "Talon métronome", startup = 0.17, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 110, 0, 50 }, RE = { 30, 0, 0 }, LS = { 110, 0, -50 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 2, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 175, 0, 20 }, RE = { 5, 0, 0 }, LS = { 175, 0, -20 }, LE = { 5, 0, 0 }, RH = { -3, 0, 2 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { -3, 0, -2 }, LK = { 0, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 2, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 178, 0, 25 }, RE = { 5, 0, 0 }, LS = { 178, 0, -25 }, LE = { 5, 0, 0 }, RH = { -3, 0, 4 }, RK = { -4, 0, 0 }, RA = { -30, 0, 0 }, LH = { -3, 0, -4 }, LK = { -4, 0, 0 }, LA = { -30, 0, 0 } },
			trail = "bothFeet", text = "TIC-TAC !", hitText = "TCHONK !",
		},

		------------------------------------------------------------------ Signatures (S)
		-- Onde de basse : elle pose un genou, braque l'enceinte devant elle et la basse part en ligne droite
		S_neutral = {
			label = "Onde de basse", energyCost = 20, kind = "projectile", startup = 0.16, active = 0, recovery = 0.3,
			damage = 9, kbBase = 22, kbGrowth = 45, kbAngle = 20,
			projectile = { speed = 62, angle = 0, gravity = 0, lifetime = 0.7, size = 2.4, color = CYAN, pierce = true,
				visual = { shape = "disc", size = 2.6, color = CYAN, neon = true, transparency = 0.25, text = "♪", spin = 0 } },
			windup = { Root = { -4, -10, 0, 0, -0.55, 0.15 }, Waist = { -6, -12, 0 }, Neck = { 0, 8, 0 }, RS = { 55, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 80, 0, 0 } },
			strike = { Root = { 6, 6, 0, 0, -0.6, 0.25 }, Waist = { 6, 8, 0 }, Neck = { 10, 0, 0 }, RS = { 88, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 20 }, LE = { 20, 0, 0 } },
			follow = { Root = { 10, 6, 0, 0, -0.55, 0.35 }, Waist = { 10, 8, 0 }, Neck = { 14, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 6, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 } },
			shake = true, windupFx = { { "symbols", symbols = { "♪", "♫" }, count = 4, radius = 3, color = ROSE, at = "hand" } },
			fx = { { "ring", color = CYAN, radius = 3, at = "front" }, { "shake", amount = 0.25 } }, text = "BOUM-BOUM !", hitText = "WOMP !",
		},
		-- Pas de conga : elle avance en dansant, enceinte en avant, et frappe trois fois sur les temps
		S_side = {
			label = "Pas de conga", energyCost = 25, startup = 0.1, active = 0.45, recovery = 0.3,
			damage = 4, hits = 3, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 20, kbGrowth = 50, kbAngle = 35, selfVelocity = Vector2.new(34, 0),
			windup = { Root = { 0, -10, 0, 0, -0.25, 0.1 }, Waist = { 0, -8, -8 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -10 }, LE = { 60, 0, 0 }, RH = { 10, 0, 20 }, RK = { -30, 0, 0 } },
			strike = { Root = { -6, 10, 6, 0, -0.3, -0.3 }, Waist = { -4, 10, 10 }, Neck = { 0, -8, 0 }, RS = { 88, 0, 6 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, -6 }, LE = { 25, 0, 0 }, LH = { 30, 0, -35 }, LK = { -10, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { -6, -10, -6, 0, -0.3, -0.4 }, Waist = { -4, -10, -10 }, Neck = { 0, 8, 0 }, RS = { 90, 0, 6 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -6 }, LE = { 25, 0, 0 }, RH = { 30, 0, 35 }, RK = { -10, 0, 0 }, RA = { 10, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "1", "2", "3" }, count = 3, radius = 3, color = JAUNE } },
			text = "CONGA !", hitText = "UN-DEUX-TROIS !",
		},
		-- Piétinement cardio : genou haut, bras au ciel, puis elle frappe le sol du pied et l'onde part autour d'elle
		S_down = {
			label = "Piétinement cardio", energyCost = 25, startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 10, hitbox = box(10, 2.5, 0, -1.5), kbBase = 30, kbGrowth = 50, kbAngle = 80,
			windup = { Root = { 6, 0, 0, 0, 0.05, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 165, 0, 25 }, RE = { 10, 0, 0 }, LS = { 165, 0, -25 }, LE = { 10, 0, 0 }, RH = { 100, 0, 0 }, RK = { -100, 0, 0 }, RA = { -10, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.55, -0.05 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 50 }, RE = { 90, 0, 0 }, LS = { 40, 0, -50 }, LE = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.2 } },
			follow = { Root = { -10, 0, 0, 0, -0.6, -0.05 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 35, 0, 55 }, RE = { 95, 0, 0 }, LS = { 35, 0, -55 }, LE = { 95, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.2 } },
			hold = 0.06, fx = { { "ring", color = JAUNE, radius = 6, at = "feet" }, { "puddle", color = ROSE, width = 9 }, { "shake", amount = 0.45 } },
			text = "ET ON PIÉTINE !", hitText = "BOUM !",
		},
		-- Saut pom-pom (remontée, gratuite) : accroupie, l'enceinte pointée vers le sol crache la basse et la propulse en vrille
		S_up = {
			label = "Saut pom-pom", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 7, hitbox = box(5, 6, 0.5, 2), kbBase = 30, kbGrowth = 40, kbAngle = 82, selfVelocity = Vector2.new(8, 88),
			windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 20, 0, 25 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.4, 0 }, Waist = { 6, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 10, 0, 22 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -8 }, LE = { 5, 0, 0 }, RH = { -4, 0, 2 }, RK = { 0, 0, 0 }, RA = { -30, 0, 0 }, LH = { -4, 0, -2 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.4, 0 }, Waist = { 8, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 8, 0, 25 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -6 }, LE = { 5, 0, 0 }, RH = { 20, 0, 6 }, RK = { -60, 0, 0 }, LH = { -4, 0, -2 }, LK = { -10, 0, 0 }, LA = { -30, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "body",
			fx = { { "particles", tex = "spark", color = CYAN, dir = "down", at = "hand", time = 0.35, speed = 14 }, { "symbols", symbols = { "♪", "♫" }, count = 4, radius = 2, color = ROSE, at = "feet" } },
			text = "POM-POM !", hitText = "HOP !",
		},
		-- Boule à facettes (plongeon, ↓S en l'air) : elle chevauche sa boule disco et tombe dessus ; l'éclat aveugle
		S_air_down = {
			label = "Boule à facettes", energyCost = 25, startup = 0.14, active = 0.35, recovery = 0.32,
			damage = 11, hitbox = box(5, 4, 0.5, -2.5), kbBase = 25, kbGrowth = 50, kbAngle = -60, selfVelocity = Vector2.new(0, -80),
			status = { name = "blinded", duration = 1 },
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 15, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -50 }, LE = { 20, 0, 0 }, RH = { 60, 0, 25 }, RK = { -90, 0, 0 }, LH = { 60, 0, -25 }, LK = { -90, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 10, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -55 }, LE = { 20, 0, 0 }, RH = { 62, 0, 28 }, RK = { -92, 0, 0 }, LH = { 62, 0, -28 }, LK = { -92, 0, 0 } },
			prop = "boule", hideProp = "enceinte", trail = "prop",
			fx = { { "particles", tex = "spark", color = Color3.fromRGB(255, 240, 255), dir = "all", at = "hand", time = 0.5, speed = 12, rate = 80 } },
			text = "DISCO !", hitText = "AVEUGLÉ !",
		},
		-- Pirouette (esquive puis S) : sur une pointe, bras en couronne, elle tourne sur elle-même et cogne au passage
		S_dodge = {
			label = "Pirouette", energyCost = 20, startup = 0.06, active = 0.2, recovery = 0.26,
			damage = 8, hitbox = box(6, 4, 1, 0.5), kbBase = 30, kbGrowth = 45, kbAngle = 35, invuln = 0.25,
			windup = { Root = { 0, -20, 0, 0, -0.35, 0 }, Waist = { 0, -10, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.12, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 45, 0, 0 }, LS = { 170, 0, -30 }, LE = { 45, 0, 0 }, RH = { 40, 0, 30 }, RK = { -95, 0, 0 }, RA = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0.12, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.12, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 172, 0, 32 }, RE = { 45, 0, 0 }, LS = { 172, 0, -32 }, LE = { 45, 0, 0 }, RH = { 42, 0, 32 }, RK = { -95, 0, 0 }, RA = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0.12, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "prop", text = "PIROUETTE !", hitText = "TOUPIE !",
		},
		-- Échauffement (S maintenu) : bras au ciel, puis une grande fente avant où l'enceinte part en coup de boutoir
		-- dans le ventre d'en face, et des petites foulées sur place : bonus de vitesse
		S_hold = {
			label = "Échauffement", energyCost = 30, startup = 0.22, active = 0.12, recovery = 0.4,
			damage = 9, hitbox = box(6, 4.5, 3.5, 0.6), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			selfEffect = { buff = { "turbo", 4 } },
			windup = { Root = { 0, 0, -8, 0, -0.1, 0.1 }, Waist = { 0, 0, -18 }, Neck = { 0, 0, -10 }, RS = { 178, 0, -10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -15 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.55, -0.6 }, Waist = { -14, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.7 } },
			follow = { Root = { 0, 0, 0, 0, -0.05, 0 }, Waist = { 6, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, LS = { 170, 0, -30 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			hold = 0.3, trail = "prop", fx = { { "burst", color = JAUNE, size = 3, at = "front" }, { "particles", tex = "spark", color = JAUNE, dir = "up", at = "root", time = 0.6, speed = 6 } },
			text = "ÉCHAUFFEMENT !", hitText = "FENTE !",
		},
		-- Glissé disco (→→S) : elle glisse sur un genou, doigt pointé au ciel, et ressort derrière l'adversaire
		S_dash = {
			label = "Glissé disco", energyCost = 25, startup = 0.06, active = 0.2, recovery = 0.3,
			damage = 9, hitbox = box(5, 3, 2, -0.5), kbBase = 28, kbGrowth = 55, kbAngle = 50, selfVelocity = Vector2.new(60, 0),
			invuln = 0.3, teleport = 7,
			windup = { Root = { -10, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, -1.2, -0.3 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 30 }, RE = { 20, 0, 0 }, LS = { 165, 0, -30 }, LE = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -30, 0, 0 }, LH = { -40, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -1.2, -0.35 }, Waist = { 12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 35, 0, 35 }, RE = { 20, 0, 0 }, LS = { 170, 0, -32 }, LE = { 0, 0, 0 }, RH = { 82, 0, 0 }, RK = { -28, 0, 0 }, LH = { -42, 0, 0 }, LK = { -112, 0, 0 } },
			trail = "body", fx = { "dust", { "symbols", symbols = { "✨" }, count = 3, radius = 2 } }, text = "GLISSÉ !", hitText = "DISCO !",
		},
		-- Boule à facettes qui aveugle (S en l'air) : elle lance une mini-boule disco vers le bas devant elle
		S_air = {
			label = "Mini-boule disco", energyCost = 22, kind = "projectile", startup = 0.14, active = 0, recovery = 0.3,
			damage = 7, kbBase = 18, kbGrowth = 35, kbAngle = 30,
			status = { name = "blinded", duration = 1.5 },
			projectile = { speed = 48, angle = -30, gravity = 40, lifetime = 0.9, size = 1.5, color = DISCO,
				visual = { shape = "ball", size = 1.3, color = DISCO, material = "Foil", spin = 12, parts = { { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, 0.6, 0), ROSE } } } },
			windup = { Root = { -6, -15, 0 }, Waist = { -8, -15, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -14, 12, 0 }, Waist = { -16, 12, 0 }, Neck = { -6, 0, 0 }, RS = { 50, 0, 45 }, RE = { 40, 0, 0 }, LS = { 50, 0, -10 }, LE = { 5, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -16, 14, 0 }, Waist = { -18, 14, 0 }, Neck = { -8, 0, 0 }, RS = { 52, 0, 48 }, RE = { 40, 0, 0 }, LS = { 35, 0, -12 }, LE = { 5, 0, 0 }, RH = { 48, 0, 0 }, RK = { -78, 0, 0 }, LH = { 18, 0, 0 }, LK = { -58, 0, 0 } },
			trail = "leftHand", text = "BLING !", hitText = "AVEUGLÉ !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Coup de basse : enceinte serrée contre elle à deux mains, puis poussée devant avec un gros WOMP
		S_finish_bass = {
			label = "Coup de basse", energyCost = 20, startup = 0.15, active = 0.15, recovery = 0.3,
			damage = 10, hitbox = box(7, 4, 4, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 30,
			windup = { Root = { 4, -10, 0, 0, -0.3, 0.2 }, Waist = { 6, -12, 0 }, RS = { 40, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 110, 0, 0 } },
			strike = { Root = { -10, 8, 0, 0, -0.35, -0.35 }, Waist = { -10, 10, 0 }, Neck = { -8, 0, 0 }, RS = { 90, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 86, 0, 14 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 10, 0, 0, -0.35, -0.42 }, Waist = { -12, 12, 0 }, Neck = { -10, 0, 0 }, RS = { 92, 0, -4 }, RE = { 0, 0, 0 }, RW = { 4, 0, 0 }, LS = { 88, 0, 14 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			shake = true, fx = { { "beam", color = CYAN, length = 8, width = 2.4, at = "root" }, { "shake", amount = 0.35 } }, text = "WOMP !", hitText = "BASS DROP !",
		},
		-- Pirouette finale : deux tours sur la pointe gauche, jambe droite tendue qui balaie tout autour
		S_finish_spin = {
			label = "Pirouette finale", energyCost = 25, startup = 0.1, active = 0.3, recovery = 0.3,
			damage = 11, hitbox = box(8, 3.5, 0, 0.3), kbBase = 32, kbGrowth = 65, kbAngle = 45,
			windup = { Root = { 0, -30, 0, 0, -0.3, 0 }, Waist = { 0, -20, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.0, 0 }, Neck = { -6, 0, 0 }, RS = { 160, 0, 30 }, RE = { 30, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0.1, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.0, 0 }, Neck = { -6, 0, 0 }, RS = { 162, 0, 32 }, RE = { 30, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0.1, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "rightFoot", text = "ET ON TOURNE !", hitText = "VLOUF !",
		},

		------------------------------------------------------------------ Supers
		-- Cours collectif : coup de sifflet, enceinte au ciel, toute la salle doit danser (l'adversaire danse 3 s)
		SUPER = {
			label = "Cours collectif !", superCost = 100, startup = 0.35, active = 0.2, recovery = 0.5,
			damage = 18, hitbox = box(16, 8, 4, 1), kbBase = 15, kbGrowth = 15, kbAngle = 60,
			status = { name = "dancing", duration = 3 },
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, LS = { 130, 0, 20 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, 10, 0, 0, 0.1, 0 }, Waist = { 12, 10, 0 }, Neck = { 22, 0, 0 }, RS = { 175, 0, 25 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 6, -10, 6, 0, 0.0, 0 }, Waist = { 12, -10, 8 }, Neck = { 22, 0, 6 }, RS = { 178, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -65 }, LE = { 0, 0, 0 } },
			hold = 0.4, windupFx = { "super", { "text", text = "PRIIIT !", color = JAUNE } },
			fx = { { "symbols", symbols = { "♪", "♫", "💃" }, count = 10, radius = 6, color = ROSE }, { "ring", color = JAUNE, radius = 9 }, { "pillar", color = ROSE, height = 14, width = 3 } },
			text = "COURS COLLECTIF !", hitText = "ET ON DANSE !",
		},
		-- Super ↑ : l'enceinte braquée vers le sol entre ses pieds, la basse la propulse en vrille vers le ciel, jambes
		-- écartées à l'horizontale : un hélicoptère disco qui fauche tout ce qui passe
		SUPER_up = {
			label = "Hélico grand écart !", superCost = 100, startup = 0.35, active = 0.4, recovery = 0.6,
			damage = 22, hitbox = box(9, 9, 0, 3.5), kbBase = 46, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -6, 0, 0, 0, -0.85, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.5, 0 }, Waist = { 4, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 160, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -40 }, LE = { 0, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -88, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.5, 0 }, Waist = { 4, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 165, 0, 45 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -45 }, LE = { 0, 0, 0 }, RH = { 94, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -90, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			spin = { axis = "y", degrees = 1080 }, selfVelocity = Vector2.new(0, 70), hold = 0.2, trail = "bothFeet",
			windupFx = { "super", { "particles", tex = "spark", color = CYAN, dir = "down", at = "hand", time = 0.4, speed = 16 } },
			fx = { { "pillar", color = CYAN, height = 22, width = 4, at = "root" }, { "ring", color = ROSE, radius = 7, at = "feet" }, { "symbols", symbols = { "♪", "♫", "💃" }, count = 10, radius = 5, color = JAUNE } },
			text = "ET ON DÉCOLLE !", hitText = "HÉLICO !",
		},
		-- Final disco : elle brandit une boule à facettes géante, la salle s'illumine et tout explose de lumière
		SUPER_down = {
			label = "Final disco !", superCost = 100, startup = 0.45, active = 0.2, recovery = 0.55,
			damage = 24, hitbox = box(14, 10, 0, 3), kbBase = 40, kbGrowth = 80, kbAngle = 70,
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 180, 0, 5 }, RE = { 0, 0, 0 }, RW = { 180, 0, 0 }, LS = { 160, 0, -50 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.3, 0 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 182, 0, 8 }, RE = { 0, 0, 0 }, RW = { 180, 0, 0 }, LS = { 165, 0, -55 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			hold = 0.45, prop = "boule", hideProp = "enceinte", windupFx = { "super" },
			fx = { { "pillar", color = Color3.fromRGB(255, 240, 255), height = 18, width = 4, at = "root" }, { "particles", tex = "spark", color = ROSE, dir = "all", at = "above", time = 0.8, speed = 20, rate = 120 }, { "screen", color = Color3.fromRGB(255, 220, 255), alpha = 0.35 }, { "shake", amount = 0.6 } },
			text = "FINAL DISCOOO !", hitText = "STAYIN' ALIVE !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise de danse : bras ouverts « on danse ? », puis elle saisit l'adversaire main dans la main
		GRAB = {
			label = "Prise de danse", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, 60 }, RE = { 10, 0, 0 }, LS = { 110, 0, -60 }, LE = { 10, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.3 }, Waist = { -8, 0, 0 }, RS = { 90, 0, -10 }, RE = { 30, 0, 0 }, LS = { 90, 0, 10 }, LE = { 30, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.18, -0.3 }, Waist = { -8, 0, 0 }, RS = { 92, 0, -14 }, RE = { 40, 0, 0 }, LS = { 92, 0, 14 }, LE = { 40, 0, 0 } },
			text = "ON DANSE ?", hitText = "SALSA !",
		},
		-- ✋ puis → : Passe et lâche, elle fait tourner la victime sous son bras puis la lâche au loin
		THROW_fwd = {
			label = "Passe et lâche", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 15,
			carry = { { 0, 2.4, 0.4 }, { 0.12, 0.5, 0.8 }, { 0.22, -1.5, 0.6 }, { 0.34, 4.5, 0.2 } },
			windup = { Root = { 0, 20, 0, 0, -0.2, 0.2 }, Waist = { 4, 20, 0 }, Neck = { 10, -10, 0 }, RS = { 170, 0, 10 }, RE = { 30, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, -20, 0, 0, -0.35, -0.45 }, Waist = { -10, -20, 0 }, Neck = { 0, 10, 0 }, RS = { 95, 0, 30 }, RE = { 0, 0, 0 }, LS = { 30, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, -26, 0, 0, -0.35, -0.5 }, Waist = { -12, -24, 0 }, Neck = { 0, 14, 0 }, RS = { 98, 0, 45 }, RE = { 0, 0, 0 }, LS = { 25, 0, -65 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			spin = { axis = "y", degrees = 360 }, text = "ET ON LÂCHE !", hitText = "ZIOUUU !",
		},
		-- ✋ puis ← : Renversé de tango, elle bascule la victime en arrière en un grand renversé, puis la jette derrière elle
		THROW_back = {
			label = "Renversé de tango", kind = "throw", back = true, startup = 0.42, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 40,
			carry = { { 0, 2.2, 0.3 }, { 0.16, 2.6, -0.8 }, { 0.3, 0.5, 0.5 }, { 0.42, -2.6, 0.8 } },
			windup = { Root = { -10, 0, 0, 0, -0.3, -0.2 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -20 }, RE = { 60, 0, 0 }, LS = { 120, 0, 10 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			strike = { Root = { 20, 150, 0, 0, -0.4, 0.2 }, Waist = { 20, 10, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 } },
			follow = { Root = { 22, 165, 0, 0, -0.4, 0.25 }, Waist = { 22, 10, 0 }, Neck = { 24, 0, 0 }, RS = { 160, 0, 45 }, RE = { 20, 0, 0 }, LS = { 160, 0, -45 }, LE = { 20, 0, 0 } },
			text = "TANGO !", hitText = "OLÉ !",
		},
		-- ✋ puis ↑ : Porté de lift, comme dans les films de danse : la victime au-dessus de sa tête, puis envoyée au ciel
		THROW_up = {
			label = "Porté de lift", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.2, -0.6 }, { 0.26, 0.4, 3.5 }, { 0.34, 0.3, 4.5 } },
			windup = { Root = { -10, 0, 0, 0, -0.8, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 60, 0, -15 }, RE = { 60, 0, 0 }, LS = { 60, 0, 15 }, LE = { 60, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 178, 0, 8 }, RE = { 5, 0, 0 }, LS = { 178, 0, -8 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.25, 0 }, Waist = { 14, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 180, 0, 25 }, RE = { 5, 0, 0 }, LS = { 180, 0, -25 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			hold = 0.1, text = "LE PORTÉ !", hitText = "DIRTY DANCING !",
		},
		-- ✋ puis ↓ : Grand écart, elle plaque la victime au sol et se laisse tomber dessus en grand écart
		THROW_down = {
			label = "Grand écart écrasant", kind = "throw", startup = 0.4, active = 0.1, hold = 0.25, recovery = 0.38,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.16, 2.0, 1.6 }, { 0.3, 1.2, -2.0 }, { 0.4, 0.4, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.15, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 165, 0, -10 }, RE = { 30, 0, 0 }, LS = { 165, 0, 10 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 0, 0, 0, 0, -1.55, -0.2 }, Waist = { 6, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 65 }, RE = { 0, 0, 0 }, LS = { 150, 0, -65 }, LE = { 0, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -82, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -1.6, -0.2 }, Waist = { 8, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 160, 0, 75 }, RE = { 0, 0, 0 }, LS = { 160, 0, -75 }, LE = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -84, 0, 0 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			fx = { "dust", { "shake", amount = 0.4 } }, text = "GRAND ÉCART !", hitText = "OUILLE !",
		},
	},

	-- Fatals (→ = forward, ← = back) : 1er offert, 2e au niveau de maîtrise 5, 3e au niveau 15
	fatals = {
		{
			id = "bout_de_la_nuit", label = "Jusqu'au bout de la nuit", sequence = { "forward", "forward", "back" },
			-- l'adversaire ne peut plus s'arrêter de danser et part en chenille avec le public
			scene = {
				{ "fxAttacker", { "text", text = "ET ON NE S'ARRÊTE PAS !", color = ROSE } },
				{ "fx", { "symbols", symbols = { "♪", "♫", "💃" }, count = 8, radius = 4, color = JAUNE } },
				{ "spin", 720, time = 1.0 },
				{ "spawn", at = "target", offset = Vector3.new(0, -1, 0), life = 4.5, pieces = {
					{ "Danseur1", "", "block", Vector3.new(1.4, 3.6, 1), Vector3.new(-2.5, 0, 0), Vector3.zero, CYAN, "SmoothPlastic" },
					{ "Tete1", "", "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(-2.5, 2.4, 0), Vector3.zero, PEAU, "SmoothPlastic" },
					{ "Danseur2", "", "block", Vector3.new(1.4, 3.6, 1), Vector3.new(-5, 0, 0), Vector3.zero, JAUNE, "SmoothPlastic" },
					{ "Tete2", "", "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(-5, 2.4, 0), Vector3.zero, Color3.fromRGB(240, 200, 170), "SmoothPlastic" },
					{ "Danseur3", "", "block", Vector3.new(1.4, 3.6, 1), Vector3.new(-7.5, 0, 0), Vector3.zero, VIOLET, "SmoothPlastic" },
					{ "Tete3", "", "ball", Vector3.new(1.2, 1.2, 1.2), Vector3.new(-7.5, 2.4, 0), Vector3.zero, Color3.fromRGB(110, 70, 50), "SmoothPlastic" },
				} },
				{ "text", "LA CHENILLE !" },
				{ "wait", 0.6 },
				{ "launch", Vector3.new(45, 2, 0), time = 2.2 },
				{ "fxAttacker", { "symbols", symbols = { "♪", "♫" }, count = 6, radius = 3, color = ROSE } },
				{ "wait", 0.5 },
			},
		},
		{
			id = "cent_burpees", label = "100 burpees", sequence = { "down", "up", "forward" },
			-- forcé à faire 100 burpees, il finit en flaque de sueur cartoon
			scene = {
				{ "fxAttacker", { "text", text = "ALLEZ, 100 BURPEES !", color = JAUNE } },
				{ "lift", 2, time = 0.2 },
				{ "lift", -2, time = 0.2 },
				{ "text", "1…" },
				{ "lift", 2, time = 0.15 },
				{ "lift", -2, time = 0.15 },
				{ "text", "2…" },
				{ "lift", 2, time = 0.1 },
				{ "lift", -2, time = 0.1 },
				{ "text", "… 100 !" },
				{ "fx", { "particles", tex = "smoke", color = Color3.fromRGB(150, 210, 255), dir = "up", at = "head", time = 0.8, speed = 8 } },
				{ "squash", time = 0.3 },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.8, 0), life = 3, pieces = {
					{ "Sueur", "", "cyl", Vector3.new(0.2, 6, 6), Vector3.zero, Vector3.zero, Color3.fromRGB(120, 200, 255), "Glass", { axis = "y", transparency = 0.3 } },
				} },
				{ "color", Color3.fromRGB(120, 200, 255) },
				{ "material", "Glass" },
				{ "fxAttacker", { "text", text = "BRAVO, ON S'HYDRATE !", color = CYAN } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "boule_a_facettes", label = "Boule à facettes", sequence = { "back", "down", "up" },
			-- transformé en boule à facettes, il est hissé au plafond et tourne au-dessus de la piste
			scene = {
				{ "fxAttacker", { "text", text = "QUE LA LUMIÈRE SOIT !", color = ROSE } },
				{ "shrink", 0.5, time = 0.5 },
				{ "color", DISCO },
				{ "material", "Foil" },
				{ "fx", { "particles", tex = "spark", color = Color3.fromRGB(255, 255, 255), dir = "all", at = "root", time = 1.0, speed = 12, rate = 80 } },
				{ "lift", 9, time = 0.8 },
				{ "spawn", at = "target", offset = Vector3.new(0, 4, 0), life = 4, pieces = {
					{ "Chaine", "", "cyl", Vector3.new(0.2, 8, 0.2), Vector3.zero, Vector3.zero, DISCO, "Metal", { axis = "y" } },
				} },
				{ "spin", 1080, time = 1.6 },
				{ "fx", { "symbols", symbols = { "✨", "💡" }, count = 8, radius = 5, color = JAUNE } },
				{ "text", "BLING BLING" },
				{ "wait", 1 },
			},
		},
	},

	-- Mécanique « tempo » : métronome de 0,6 s (100 battements par minute), +30 % sur le temps
	passive = { kind = "tempo", name = "Tempo", icon = "🎵", period = 0.6, bonus = 1.3, color = ROSE },

	-- Recharge ⚡ : pas de zumba sur place, bras en l'air, l'enceinte crache trois notes (« WOOH ! »).
	-- Deux temps de métronome (1,2 s) : pas à droite bras en V, pas à gauche bras croisés, puis « WOOH » bras au ciel.
	charge = {
		label = "Zumba sur place",
		loop = 1.2,
		lockWrist = false,
		color = ROSE,
		keys = {
			{ 0.0, { Root = { 0, 15, 6, 0, -0.3, 0 }, Waist = { 0, -12, 8 }, Neck = { 10, 10, 0 }, RS = { 150, 0, 45 }, RE = { 10, 0, 0 }, LS = { 150, 0, -45 }, LE = { 10, 0, 0 } } },
			{ 0.3, { Root = { 0, 0, 0, 0, -0.05, 0 }, Waist = { 4, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 100, 0, -30 }, RE = { 60, 0, 0 }, LS = { 100, 0, 30 }, LE = { 60, 0, 0 } } },
			{ 0.6, { Root = { 0, -15, -6, 0, -0.3, 0 }, Waist = { 0, 12, -8 }, Neck = { 10, -10, 0 }, RS = { 150, 0, 45 }, RE = { 10, 0, 0 }, LS = { 150, 0, -45 }, LE = { 10, 0, 0 } } },
			{ 0.85, { Root = { 4, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 30 }, RE = { 90, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 } } },
			{ 1.0, { Root = { 6, 0, 0, 0, 0.05, 0 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 178, 0, 15 }, RE = { 0, 0, 0 }, LS = { 178, 0, -15 }, LE = { 0, 0, 0 } } },
			{ 1.2, { Root = { 0, 15, 6, 0, -0.3, 0 }, Waist = { 0, -12, 8 }, Neck = { 10, 10, 0 }, RS = { 150, 0, 45 }, RE = { 10, 0, 0 }, LS = { 150, 0, -45 }, LE = { 10, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "symbols", symbols = { "♪" }, count = 1, radius = 2, color = ROSE, at = "hand" } },
			{ 0.35, { "symbols", symbols = { "♫" }, count = 1, radius = 2, color = CYAN, at = "hand" } },
			{ 0.65, { "symbols", symbols = { "♪" }, count = 1, radius = 2, color = JAUNE, at = "hand" } },
			{ 1.0, { "text", text = "WOOH !", color = ROSE } },
		},
	},

	-- Manies au repos : elle s'étire, vérifie son pouls, fait tourner ses hanches
	fidgets = {
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.5, { Root = { 0, 0, -6, 0, -0.2, 0 }, Waist = { 0, 0, -20 }, Neck = { 0, 0, -10 }, RS = { 175, 0, -15 }, RE = { 30, 0, 0 }, LS = { 15, 0, -10 }, LE = { 20, 0, 0 } } },
			{ 1.1, { Root = { 0, 0, -8, 0, -0.22, 0 }, Waist = { 0, 0, -24 }, Neck = { 0, 0, -12 }, RS = { 178, 0, -18 }, RE = { 35, 0, 0 }, LS = { 15, 0, -10 }, LE = { 20, 0, 0 } } },
			{ 1.6, { Root = { 0, 0, 0, 0, -0.18, 0 }, Waist = { 2, 0, 0 }, Neck = { 6, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 2.0, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { -20, 10, 0 }, Waist = { -6, 0, 0 }, LS = { 70, 0, 20 }, LE = { 110, 0, 0 }, LW = { -20, 0, 0 }, RS = { 60, 0, -10 }, RE = { 100, 0, 0 } } },
			{ 1.4, { Neck = { -22, 12, 0 }, Waist = { -6, 0, 0 }, LS = { 72, 0, 20 }, LE = { 112, 0, 0 }, LW = { -20, 0, 0 }, RS = { 62, 0, -10 }, RE = { 102, 0, 0 } } },
			{ 1.7, { Neck = { 10, 0, 0 }, RS = { 120, 0, 40 }, RE = { 30, 0, 0 } } },
			{ 2.0, {} },
		} },
		{ duration = 1.8, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.3, { Root = { 0, 20, 8, 0.2, -0.25, 0 }, Waist = { 0, -14, -6 }, RS = { 30, 0, 40 }, LS = { 30, 0, -40 } } },
			{ 0.6, { Root = { 0, 0, 0, 0, -0.3, 0.15 }, Waist = { 8, 0, 0 }, RS = { 30, 0, 40 }, LS = { 30, 0, -40 } } },
			{ 0.9, { Root = { 0, -20, -8, -0.2, -0.25, 0 }, Waist = { 0, 14, 6 }, RS = { 30, 0, 40 }, LS = { 30, 0, -40 } } },
			{ 1.2, { Root = { 0, 0, 0, 0, -0.3, -0.15 }, Waist = { -8, 0, 0 }, RS = { 30, 0, 40 }, LS = { 30, 0, -40 } } },
			{ 1.8, {} },
		} },
	},
}

-- Pendant qu'elle tient quelqu'un : position de salsa, main gauche sur l'épaule de l'adversaire, main droite
-- (avec l'enceinte) levée, petit déhanché
data.grabHold = {
	Root = { 0, 8, 4, 0, -0.2, 0.05 },
	Waist = { 2, -6, -4 },
	Neck = { 10, -6, 0 },
	RS = { 130, 0, 30 },
	RE = { 40, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 88, 0, 8 },
	LE = { 30, 0, 0 },
}

-- Retour 🪂 : elle descend sur une boule à facettes géante en tournant, saute au sol en écart et pointe
-- le doigt (« ON SE BOUGE ! »)
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Plateau", "base", "cyl", Vector3.new(0.6, 4, 4), Vector3.new(0, -0.3, 0), Vector3.zero, DISCO, "Foil", { axis = "y", reflect = 0.4 } },
		{ "BouleGeante", "", "ball", Vector3.new(5, 5, 5), Vector3.new(0, -3, 0), Vector3.zero, DISCO, "Foil", { reflect = 0.5, light = { Color3.fromRGB(255, 150, 255), 16, 2 } } },
		{ "Spot1", "", "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(2.3, -2, 0), Vector3.zero, ROSE, "Neon", { neon = true } },
		{ "Spot2", "", "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(-2.3, -3.5, 0), Vector3.zero, CYAN, "Neon", { neon = true } },
		{ "Spot3", "", "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0, -5.3, 0), Vector3.zero, JAUNE, "Neon", { neon = true } },
		{ "Chaine", "", "cyl", Vector3.new(0.2, 10, 0.2), Vector3.new(0, 5, 0), Vector3.zero, DISCO, "Metal", { axis = "y" } },
	} },
	keys = {
		{ 0.0, { Root = { 0, -60, 0, 0, -0.2, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 30, 0, 0 }, LS = { 170, 0, -30 }, LE = { 30, 0, 0 } } },
		{ 0.4, { Root = { 0, 60, 0, 0, -0.2, 0 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 30, 0, 0 }, LS = { 170, 0, -30 }, LE = { 30, 0, 0 } } },
		{ 0.75, { Root = { -6, 0, 0, 0, -0.6, 0 }, Waist = { -12, 0, 0 }, RS = { 20, 0, 30 }, RE = { 40, 0, 0 }, LS = { 20, 0, -30 }, LE = { 40, 0, 0 } } },
		{ 1.05, { Root = { 0, 0, 0, 0, -1.5, 0 }, Waist = { 6, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 140, 0, 70 }, RE = { 0, 0, 0 }, LS = { 140, 0, -70 }, LE = { 0, 0, 0 }, RH = { 86, 0, 0 }, RK = { 0, 0, 0 }, LH = { -80, 0, 0 }, LK = { 0, 0, 0 } } },
		{ 1.4, { Root = { 0, 10, 0, 0, -0.1, 0 }, Waist = { 4, 10, 0 }, Neck = { 6, -10, 0 }, RS = { 120, 0, -5 }, RE = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 } } },
		{ 1.6, { Root = { 0, 10, 0, 0, -0.12, 0 }, Waist = { 4, 10, 0 }, Neck = { 6, -10, 0 }, RS = { 122, 0, -5 }, RE = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.1, { "symbols", symbols = { "✨", "♪" }, count = 6, radius = 4, color = ROSE } },
		{ 1.05, { "burst", color = JAUNE, size = 3, at = "feet" } },
		{ 1.4, { "text", text = "ON SE BOUGE !", color = ROSE } },
	},
}

-- Arbre d'enchaînements : P P P P = clap, clap au-dessus, coup de hanche, high kick du refrain ; → P P P = coude,
-- tour de salsa, dip de tango ; ↓ P P P = twist, twist remontant, mambo ; K K K K = high kick, battement, cancan, grand
-- jeté ; → K K K = chassé, chassé-croisé, grand écart sauté. S finit presque toutes les chaînes (coup de basse de près,
-- pirouette finale tout autour).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P P P P : clap, clap au-dessus, coup de hanche cha-cha, high kick du refrain (finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_bass" },
	P_combo2 = { P = "P_hanche", K = "PK_combo", up_K = "K_up", S = "S_finish_bass" },
	P_hanche = { P = "P_combo3", K = "K_cancan", S = "S_finish_spin" },
	PK_combo = { K = "K_cancan", P = "KP_combo", S = "S_finish_spin" },
	KP_combo = { P = "P_combo3", S = "S_finish_bass" },
	-- K K K K : high kick, battement gauche, french cancan, grand jeté (finition)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_spin" },
	K_combo2 = { K = "K_cancan", P = "P_hanche", S = "S_finish_bass" },
	K_cancan = { K = "K_combo3", P = "P_mambo", S = "S_finish_spin" },
	-- → P P P : coude salsa, tour de salsa, dip de tango (finition à l'horizontale)
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_bass" },
	P_side2 = { P = "P_dip", K = "K_side2", S = "S_finish_spin" },
	-- ↓ P P P : twist balayé, twist remontant, mambo (finition vers le ciel)
	P_down = { P = "P_twist2", K = "K_down", up_K = "K_up", S = "S_finish_spin" },
	P_twist2 = { P = "P_mambo", K = "K_cancan", S = "S_finish_bass" },
	-- → K K K : pas chassé, chassé-croisé, grand écart sauté (finition)
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_spin" },
	K_side2 = { K = "K_side3", P = "P_dip", S = "S_finish_bass" },
	-- autres départs
	P_up = { K = "K_up", P = "P_combo2", S = "S_finish_bass" },
	P_dash = { P = "P_side2", K = "K_side2", S = "S_finish_bass" },
	K_down = { up_K = "K_up", P = "P_twist2", S = "S_finish_spin" },
	K_up = { S = "S_finish_bass" },
	K_dash = { P = "KP_combo", K = "K_side2", S = "S_finish_spin" },
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

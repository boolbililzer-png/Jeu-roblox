-- Jordan « RageQuit » : gamer nerveux qui tilte au moindre coup reçu. Arme sortie de la Caisse Bizarre :
-- la manette filaire (maniée comme un nunchaku) et le clavier mécanique RGB.
--
-- Même format que Gege.lua (voir son en-tête et docs/fiche-perso.md).
-- Mécanique « rage » : les dégâts reçus remplissent la jauge ; pleine, il « tilte » (+50 % de dégâts, plus
-- d'esquive) pendant 6 s.
-- Ses poses sont crispées : dos rond, épaules remontées, gestes brusques, coups en rafale façon « spam bouton ».

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local PEAU = Color3.fromRGB(235, 195, 165)
local SWEAT = Color3.fromRGB(45, 45, 55)
local SWEAT_FONCE = Color3.fromRGB(30, 30, 38)
local JOGGING = Color3.fromRGB(70, 75, 92)
local BASKETS = Color3.fromRGB(235, 235, 235)
local CHEVEUX = Color3.fromRGB(90, 60, 35)
local NOIR = Color3.fromRGB(22, 22, 26)
local BLANC = Color3.fromRGB(245, 245, 245)
local ROUGE = Color3.fromRGB(255, 45, 70)
local VERT = Color3.fromRGB(40, 255, 120)
local BLEU = Color3.fromRGB(60, 140, 255)
local VIOLET = Color3.fromRGB(180, 60, 255)
local CHIPS = Color3.fromRGB(255, 205, 40)
local BSOD = Color3.fromRGB(20, 80, 220)

local data = {
	id = "Jordan",
	name = "Jordan « RageQuit »",
	costume = "Jordan",
	style = "gamer",

	look = {
		body = {
			head = PEAU, upper = SWEAT, lower = JOGGING, arms = SWEAT, forearms = SWEAT, hands = PEAU,
			legs = JOGGING, feet = BASKETS,
		},
		cubeHead = 1.25,
		parts = {
			-- cheveux en bataille, mèche rebelle
			{ "Cheveux", "Head", "ball", Vector3.new(1.45, 0.75, 1.45), Vector3.new(0, 0.55, 0.08), Vector3.zero, CHEVEUX, "Fabric" },
			{ "Meche", "Head", "wedge", Vector3.new(0.35, 0.55, 0.6), Vector3.new(0.15, 0.95, -0.25), Vector3.new(-20, 0, -15), CHEVEUX, "Fabric" },
			-- casque gamer RGB avec micro
			{ "Arceau", "Head", "block", Vector3.new(1.55, 0.22, 0.32), Vector3.new(0, 0.88, 0), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "EcouteurG", "Head", "cyl", Vector3.new(0.36, 0.9, 0.9), Vector3.new(-0.74, 0, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
			{ "EcouteurD", "Head", "cyl", Vector3.new(0.36, 0.9, 0.9), Vector3.new(0.74, 0, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
			{ "LedG", "Head", "cyl", Vector3.new(0.06, 0.62, 0.62), Vector3.new(-0.94, 0, 0), Vector3.zero, VIOLET, "Neon", { axis = "x", neon = true } },
			{ "LedD", "Head", "cyl", Vector3.new(0.06, 0.62, 0.62), Vector3.new(0.94, 0, 0), Vector3.zero, VERT, "Neon", { axis = "x", neon = true, light = { VERT, 6, 1 } } },
			{ "Micro", "Head", "block", Vector3.new(0.1, 0.1, 0.75), Vector3.new(0.68, -0.4, -0.4), Vector3.new(0, -25, 0), NOIR, "SmoothPlastic" },
			{ "MicroBout", "Head", "ball", Vector3.new(0.2, 0.2, 0.2), Vector3.new(0.5, -0.4, -0.75), Vector3.zero, ROUGE, "Neon", { neon = true } },
			-- visage : yeux cernés, petite bouche crispée
			{ "OeilG", "Head", "ball", Vector3.new(0.3, 0.26, 0.1), Vector3.new(-0.27, 0.08, -0.62), Vector3.zero, BLANC, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.3, 0.26, 0.1), Vector3.new(0.27, 0.08, -0.62), Vector3.zero, BLANC, "SmoothPlastic" },
			{ "PupilleG", "Head", "ball", Vector3.new(0.12, 0.12, 0.08), Vector3.new(-0.27, 0.08, -0.67), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "PupilleD", "Head", "ball", Vector3.new(0.12, 0.12, 0.08), Vector3.new(0.27, 0.08, -0.67), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "Cernes", "Head", "block", Vector3.new(0.9, 0.1, 0.05), Vector3.new(0, -0.1, -0.63), Vector3.zero, Color3.fromRGB(150, 110, 150), "SmoothPlastic" },
			{ "Bouche", "Head", "block", Vector3.new(0.4, 0.08, 0.05), Vector3.new(0.05, -0.38, -0.63), Vector3.new(0, 0, -8), Color3.fromRGB(120, 50, 50), "SmoothPlastic" },
			-- sweat à capuche : capuche rabattue, poche kangourou, cordons, logo RGB
			{ "Capuche", "UpperTorso", "ball", Vector3.new(1.9, 0.85, 1.0), Vector3.new(0, 0.85, 0.45), Vector3.zero, SWEAT_FONCE, "Fabric" },
			{ "Poche", "UpperTorso", "block", Vector3.new(1.4, 0.6, 0.1), Vector3.new(0, -0.45, -0.52), Vector3.zero, SWEAT_FONCE, "Fabric" },
			{ "CordonG", "UpperTorso", "block", Vector3.new(0.08, 0.7, 0.06), Vector3.new(-0.3, 0.2, -0.53), Vector3.zero, BLANC, "Fabric" },
			{ "CordonD", "UpperTorso", "block", Vector3.new(0.08, 0.7, 0.06), Vector3.new(0.3, 0.2, -0.53), Vector3.zero, BLANC, "Fabric" },
			{ "Logo", "UpperTorso", "block", Vector3.new(0.45, 0.45, 0.05), Vector3.new(0.5, 0.35, -0.53), Vector3.new(0, 0, 45), BLEU, "Neon", { neon = true } },
		},
		props = {
			-- l'arme : la manette filaire, son câble pend comme un nunchaku
			{ name = "PropManette", hand = "Right", visible = true, pieces = {
				{ "Corps", "", "block", Vector3.new(0.35, 0.55, 1.2), Vector3.new(0, -0.3, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "PoigneeAv", "", "ball", Vector3.new(0.38, 0.6, 0.45), Vector3.new(0, -0.5, -0.45), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "PoigneeAr", "", "ball", Vector3.new(0.38, 0.6, 0.45), Vector3.new(0, -0.5, 0.45), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Boutons", "", "block", Vector3.new(0.38, 0.2, 0.5), Vector3.new(0, -0.2, 0.2), Vector3.zero, ROUGE, "Neon", { neon = true } },
				{ "Cable", "", "cyl", Vector3.new(0.08, 2.6, 0.08), Vector3.new(0, -1.85, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "y" } },
				{ "Prise", "", "block", Vector3.new(0.22, 0.35, 0.22), Vector3.new(0, -3.2, 0), Vector3.zero, Color3.fromRGB(160, 160, 170), "Metal" },
			} },
			-- clavier mécanique RGB (coup de clavier, clavier volant, combo clavier)
			{ name = "PropClavier", hand = "Right", visible = false, pieces = {
				{ "Base", "", "block", Vector3.new(0.25, 3.2, 1.0), Vector3.new(0, -1.5, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Touches", "", "block", Vector3.new(0.28, 3.0, 0.82), Vector3.new(0.04, -1.5, 0), Vector3.zero, BLEU, "Neon", { neon = true, transparency = 0.2 } },
			} },
			-- souris filaire (le yo-yo du ↓P)
			{ name = "PropSouris", hand = "Right", visible = false, pieces = {
				{ "Souris", "", "ball", Vector3.new(0.5, 0.35, 0.75), Vector3.new(0, -0.35, 0), Vector3.zero, BLANC, "SmoothPlastic" },
				{ "Molette", "", "block", Vector3.new(0.08, 0.1, 0.2), Vector3.new(0, -0.2, -0.15), Vector3.zero, VERT, "Neon", { neon = true } },
			} },
			-- paquet de chips (S, recharge)
			{ name = "PropChips", hand = "Right", visible = false, pieces = {
				{ "Paquet", "", "block", Vector3.new(0.4, 1.2, 0.9), Vector3.new(0, -0.65, 0), Vector3.zero, CHIPS, "Foil" },
				{ "Bande", "", "block", Vector3.new(0.42, 0.3, 0.92), Vector3.new(0, -0.65, 0), Vector3.zero, ROUGE, "SmoothPlastic" },
			} },
			-- vieil écran de PC (Écran bleu)
			{ name = "PropEcran", hand = "Right", visible = false, pieces = {
				{ "Coque", "", "block", Vector3.new(1.5, 1.6, 1.9), Vector3.new(0, -1.1, 0), Vector3.zero, Color3.fromRGB(210, 205, 190), "SmoothPlastic" },
				{ "DalleD", "", "block", Vector3.new(0.1, 1.2, 1.5), Vector3.new(0.78, -1.1, 0), Vector3.zero, BSOD, "Neon", { neon = true } },
				{ "DalleG", "", "block", Vector3.new(0.1, 1.2, 1.5), Vector3.new(-0.78, -1.1, 0), Vector3.zero, BSOD, "Neon", { neon = true } },
			} },
			-- chaise gaming (K neutre)
			{ name = "PropChaise", hand = "Right", visible = false, pieces = {
				{ "Dossier", "", "block", Vector3.new(0.35, 2.1, 1.4), Vector3.new(0, -1.1, 0), Vector3.zero, ROUGE, "Fabric" },
				{ "Assise", "", "block", Vector3.new(1.4, 0.35, 1.4), Vector3.new(0.6, -2.25, 0), Vector3.zero, NOIR, "Fabric" },
				{ "Pied", "", "cyl", Vector3.new(0.9, 0.2, 0.2), Vector3.new(1.3, -2.25, 0), Vector3.zero, NOIR, "Metal", { axis = "x" } },
				{ "Roulettes", "", "ball", Vector3.new(0.4, 1.3, 1.3), Vector3.new(1.8, -2.25, 0), Vector3.zero, NOIR, "SmoothPlastic" },
			} },
			-- ventilateur RGB de PC (S maintenu)
			{ name = "PropVentilo", hand = "Right", visible = false, pieces = {
				{ "Cadre", "", "block", Vector3.new(0.3, 1.6, 1.6), Vector3.new(0, -0.9, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Anneau", "", "cyl", Vector3.new(0.34, 1.4, 1.4), Vector3.new(0, -0.9, 0), Vector3.zero, VIOLET, "Neon", { axis = "x", neon = true, light = { VIOLET, 10, 2 } } },
				{ "Moyeu", "", "cyl", Vector3.new(0.38, 0.5, 0.5), Vector3.new(0, -0.9, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Spam bouton : manette tenue à deux mains, pouces qui martèlent, il la cogne trois fois devant lui
		P_neutral = {
			label = "Spam bouton", startup = 0.06, active = 0.2, recovery = 0.16,
			damage = 2, hits = 3, hitbox = box(4, 3, 2.5, 0.8), kbBase = 16, kbGrowth = 20, kbAngle = 25,
			windup = { Root = { -6, 0, 0, 0, -0.25, 0.1 }, Waist = { -12, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 55, 0, -15 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 85, 0, -12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 12 }, LE = { 30, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, -0.2 }, Waist = { -14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 70, 0, -12 }, RE = { 60, 0, 0 }, RW = { -10, 0, 0 }, LS = { 70, 0, 12 }, LE = { 60, 0, 0 } },
			wobble = true, trail = "bothHands", text = "SPAM !", hitText = "A-A-A !",
		},
		-- Coup de clavier : il sort le clavier et le balance à l'horizontale à bout de bras, de tout le buste
		P_side = {
			label = "Coup de clavier", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(6, 3, 3.5, 0.5), kbBase = 22, kbGrowth = 38, kbAngle = 20, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 4, -30, 0, 0, -0.25, 0.3 }, Waist = { 6, -36, 0 }, Neck = { 0, 20, 0 }, RS = { 80, 0, 85 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, 22, 0, 0, -0.35, -0.4 }, Waist = { -12, 34, 0 }, Neck = { 0, -16, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 32, 0, 0, -0.38, -0.45 }, Waist = { -14, 48, 0 }, Neck = { 0, -24, 0 }, RS = { 88, 0, -35 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -38, 0, -45 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "clavier", hideProp = "manette", trail = "prop", text = "CLAC-CLAC !", hitText = "QWERTY !",
		},
		-- Souris yo-yo : accroupi, il lance la souris par son fil au ras du sol puis la ramène (fait décoller)
		P_down = {
			label = "Souris yo-yo", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
			damage = 5, kbBase = 24, kbGrowth = 22, kbAngle = 72,
			projectile = { speed = 58, angle = 0, gravity = 0, lifetime = 0.5, size = 1.3, color = BLANC, returns = true, from = "feet",
				visual = { shape = "ball", size = 0.8, color = BLANC, spin = 0, parts = { { "block", Vector3.new(0.1, 0.12, 0.3), Vector3.new(0, 0.35, 0), VERT } } } },
			windup = { Root = { -8, -16, 0, 0, -0.7, 0.15 }, Waist = { -16, -12, 0 }, Neck = { 0, 12, 0 }, RS = { -20, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 14, 0, 0, -0.85, -0.15 }, Waist = { -20, 16, 0 }, Neck = { 4, -8, 0 }, RS = { 70, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			follow = { Root = { -12, 10, 0, 0, -0.82, -0.1 }, Waist = { -18, 12, 0 }, Neck = { 4, -6, 0 }, RS = { 60, 0, 10 }, RE = { 50, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			prop = "souris", hideProp = "manette", text = "CLIC !", hitText = "DOUBLE-CLIC !",
		},
		-- Manette hélico (anti-air, ex-←P) : il fait tournoyer la manette par son câble au-dessus de sa tête
		P_up = {
			label = "Manette hélico", startup = 0.09, active = 0.18, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5, 4.5, 0.5, 3.5), kbBase = 26, kbGrowth = 30, kbAngle = 86,
			windup = { Root = { -6, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 100, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 172, 0, -10 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 100, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", text = "HÉLICO !", hitText = "VRRR !",
		},
		-- Coup de casque RGB : en l'air, il fait les cornes des deux mains et headbangue deux fois, casque allumé,
		-- la visière RGB cogne en cadence
		P_air = {
			label = "Coup de casque RGB", startup = 0.09, active = 0.16, recovery = 0.16,
			damage = 4, hits = 2, hitbox = box(4.5, 3.5, 2.2, 1), kbBase = 22, kbGrowth = 38, kbAngle = 35,
			windup = { Root = { 14, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -40, 0, 0 }, RS = { 120, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 60, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 150, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			wobble = true, trail = "head", fx = { { "burst", color = VERT, size = 2, at = "head" }, { "symbols", symbols = { "🤘", "♪" }, count = 3, radius = 2, color = VIOLET } }, text = "METAL !", hitText = "BZZT-BZZT !",
		},
		-- Rush sprint (dash puis P) : il fonce tête baissée, la manette tenue à deux mains devant lui comme un volant,
		-- et la plante dans le ventre d'en face sans lever les yeux
		P_dash = {
			label = "Rush sprint", startup = 0.08, active = 0.15, recovery = 0.24,
			damage = 8, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(44, 0),
			windup = { Root = { -16, 0, 0, 0, -0.3, 0.1 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 50, 0, -10 }, RE = { 110, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, 10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -30, 0, 0, 0, -0.4, -0.35 }, Waist = { -12, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 92, 0, -8 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 92, 0, 8 }, LE = { 10, 0, 0 } },
			follow = { Root = { -32, 0, 0, 0, -0.42, -0.4 }, Waist = { -14, 0, 0 }, Neck = { -32, 0, 0 }, RS = { 94, 0, -10 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 94, 0, 10 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { "dust" }, text = "RUSH B !", hitText = "TCHAC !",
		},

		-- P P : Nunchaku de manette, la manette fouette au bout de son câble d'un côté à l'autre
		P_combo2 = {
			label = "Nunchaku de manette", startup = 0.07, active = 0.1, recovery = 0.16,
			damage = 5, hitbox = box(5.5, 4, 3, 0.5), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { -4, 26, 0, 0, -0.25, -0.2 }, Waist = { -6, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 80, 0, -40 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, -16, 0, 0, -0.3, -0.35 }, Waist = { -10, -26, 0 }, Neck = { 0, 12, 0 }, RS = { 95, 0, 45 }, RE = { 0, 0, 0 }, RW = { 80, 0, 0 }, LS = { 30, 0, -25 }, LE = { 100, 0, 0 } },
			follow = { Root = { -8, -24, 0, 0, -0.3, -0.38 }, Waist = { -10, -36, 0 }, Neck = { 0, 18, 0 }, RS = { 88, 0, 70 }, RE = { 5, 0, 0 }, RW = { 80, 0, 0 }, LS = { 32, 0, -25 }, LE = { 100, 0, 0 } },
			trail = "prop", text = "HOUWA !", hitText = "FOUIT !",
		},
		-- P P P P : Smash de rage, la manette levée à deux mains et fracassée sur le crâne d'en face (finition)
		P_combo3 = {
			label = "Smash de rage", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 36, kbGrowth = 78, kbAngle = 50,
			windup = { Root = { 8, 0, 0, 0, -0.05, 0.25 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 190, 0, 8 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -8 }, LE = { 60, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, -8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 8 }, LE = { 0, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.6, -0.4 }, Waist = { -36, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, -8 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 40, 0, 8 }, LE = { 5, 0, 0 } },
			shake = true, trail = "prop", fx = { { "shake", amount = 0.3 } }, text = "ARGH !", hitText = "KRAK !",
		},
		-- → P P : Revers de clavier, le clavier revient dans l'autre sens
		P_side2 = {
			label = "Revers de clavier", startup = 0.08, active = 0.1, recovery = 0.22,
			damage = 7, hitbox = box(6, 4, 3.5, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 25,
			windup = { Root = { -8, 30, 0, 0, -0.35, -0.4 }, Waist = { -10, 40, 0 }, Neck = { 0, -20, 0 }, RS = { 85, 0, -50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, -18, 0, 0, -0.3, -0.45 }, Waist = { -10, -28, 0 }, Neck = { 0, 14, 0 }, RS = { 95, 0, 50 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			follow = { Root = { -6, -26, 0, 0, -0.3, -0.5 }, Waist = { -10, -38, 0 }, Neck = { 0, 18, 0 }, RS = { 86, 0, 72 }, RE = { 15, 0, 0 }, RW = { -10, 0, 0 }, LS = { 45, 0, -30 }, LE = { 70, 0, 0 } },
			prop = "clavier", hideProp = "manette", trail = "prop", text = "ALT !", hitText = "TAB !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Coup de chaise gaming : il soulève sa chaise gaming au-dessus de la tête et l'abat devant lui
		K_neutral = {
			label = "Coup de chaise gaming", startup = 0.24, active = 0.12, recovery = 0.34,
			damage = 13, hitbox = box(5, 4.5, 3, 1), kbBase = 32, kbGrowth = 85, kbAngle = 40,
			windup = { Root = { 10, -6, 0, 0, -0.1, 0.25 }, Waist = { 16, -8, 0 }, Neck = { 14, 0, 0 }, RS = { 195, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -10 }, LE = { 50, 0, 0 } },
			strike = { Root = { -16, 6, 0, 0, -0.45, -0.4 }, Waist = { -26, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -5 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -20, 8, 0, 0, -0.55, -0.45 }, Waist = { -32, 10, 0 }, Neck = { -8, 0, 0 }, RS = { 55, 0, 5 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 50, 0, -5 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "chaise", hideProp = "manette", shake = true, fx = { { "shake", amount = 0.35 } }, text = "MA CHAISE !", hitText = "KLONK !",
		},
		-- Clavier volant : il fait tourner le clavier comme un frisbee et le lance devant lui
		K_side = {
			label = "Clavier volant", kind = "projectile", startup = 0.2, active = 0, recovery = 0.35,
			damage = 11, kbBase = 30, kbGrowth = 70, kbAngle = 30,
			projectile = { speed = 55, angle = 6, gravity = 25, lifetime = 0.8, size = 2.2, color = BLEU,
				visual = { shape = "block", size = 0.5, color = NOIR, spin = 16, parts = {
					{ "block", Vector3.new(3, 0.25, 1.0), Vector3.zero, NOIR },
					{ "block", Vector3.new(2.8, 0.1, 0.8), Vector3.new(0, 0.15, 0), BLEU, "Neon" },
				} } },
			windup = { Root = { 4, 30, 0, 0, -0.25, 0.25 }, Waist = { 4, 36, 0 }, Neck = { 0, -24, 0 }, RS = { 80, 0, -60 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, -20, 0, 0, -0.35, -0.35 }, Waist = { -12, -30, 0 }, Neck = { 0, 16, 0 }, RS = { 92, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, -28, 0, 0, -0.38, -0.4 }, Waist = { -14, -40, 0 }, Neck = { 0, 20, 0 }, RS = { 85, 0, 70 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -45 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "clavier", hideProp = "manette", text = "CLAVIER VOLANT !", hitText = "AZERTY !",
		},
		-- Glissade à roulettes : il s'assoit sur sa chaise gaming, bras sur les accoudoirs, et traverse l'arène en roulant,
		-- les deux pieds tendus devant comme des pare-chocs
		K_down = {
			label = "Glissade à roulettes", startup = 0.17, active = 0.25, recovery = 0.35,
			damage = 12, hitbox = box(6.5, 2.5, 3, -1.5), kbBase = 30, kbGrowth = 60, kbAngle = 62, selfVelocity = Vector2.new(46, 0),
			windup = { Root = { 8, 0, 0, 0, -1.1, 0.1 }, Waist = { -4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 90, 0, 10 }, RK = { -95, 0, 0 }, LH = { 90, 0, -10 }, LK = { -95, 0, 0 } },
			strike = { Root = { 18, 0, 0, 0, -1.2, -0.2 }, Waist = { -10, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 85, 0, 12 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 85, 0, -12 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 20, 0, 0, 0, -1.2, -0.25 }, Waist = { -12, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 88, 0, 12 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 88, 0, -12 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			prop = "chaise", hideProp = "manette", trail = "bothFeet", fx = { "dust" }, text = "ROULETTES !", hitText = "SKRRR !",
		},
		-- Retour d'AFK (anti-air, ex-←K) : figé et voûté comme un joueur AFK… puis il se détend d'un coup de genou
		K_up = {
			label = "Retour d'AFK", startup = 0.22, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(4, 5, 1.5, 3), kbBase = 32, kbGrowth = 72, kbAngle = 86, invuln = 0.15,
			windup = { Root = { -10, 0, 4, 0, -0.6, 0.05 }, Waist = { -24, 0, 6 }, Neck = { -20, 0, 10 }, RS = { 0, 0, 10 }, RE = { 10, 0, 0 }, LS = { 0, 0, -10 }, LE = { 10, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.3, 0 }, Waist = { 14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -40, 0, 40 }, RE = { 30, 0, 0 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 }, RH = { 130, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.35, 0 }, Waist = { 16, 0, 0 }, Neck = { 26, 0, 0 }, RS = { -45, 0, 42 }, RE = { 30, 0, 0 }, LS = { -45, 0, -42 }, LE = { 30, 0, 0 }, RH = { 138, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			shake = true, trail = "rightLeg", text = "AFK… RETOUR !", hitText = "BOUH !",
		},
		-- Double pied rageux : en l'air, recroquevillé de colère puis les deux pieds partent devant
		K_air = {
			label = "Double pied rageux", startup = 0.17, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 38,
			windup = { Root = { -12, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 110, 0, 0 }, LS = { 70, 0, 10 }, LE = { 110, 0, 0 }, RH = { 100, 0, 0 }, RK = { -135, 0, 0 }, LH = { 95, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 22, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 45 }, RE = { 30, 0, 0 }, LS = { -40, 0, -45 }, LE = { 30, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 80, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 26, 0, 0 }, Waist = { 22, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -48, 0, 50 }, RE = { 30, 0, 0 }, LS = { -48, 0, -50 }, LE = { 30, 0, 0 }, RH = { 94, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 86, 0, 0 }, LK = { -2, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "RAAH !", hitText = "POW !",
		},
		-- Genou rush (dash puis K) : il décolle genou en avant, manette brandie derrière lui
		K_dash = {
			label = "Genou rush", startup = 0.1, active = 0.24, recovery = 0.3,
			damage = 11, hitbox = box(5, 3.5, 2.5, 0.3), kbBase = 30, kbGrowth = 65, kbAngle = 38, selfVelocity = Vector2.new(50, 26),
			windup = { Root = { -12, 0, 0, 0, -0.45, 0 }, Waist = { -14, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -50, 0, 40 }, RE = { 20, 0, 0 }, LS = { 60, 0, -30 }, LE = { 100, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 }, LH = { -30, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -12, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 12, 0, 0 }, RS = { -55, 0, 42 }, RE = { 20, 0, 0 }, LS = { 62, 0, -30 }, LE = { 102, 0, 0 }, RH = { 115, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 }, LH = { -34, 0, 0 }, LK = { -64, 0, 0 } },
			trail = "rightLeg", text = "GO GO GO !", hitText = "SBAM !",
		},

		-- K K : Coup de pied rageur, la jambe gauche part dans les tibias en trépignant
		K_combo2 = {
			label = "Coup de pied rageur", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 4, 3, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 32,
			windup = { Root = { 4, 16, 0, 0, -0.15, 0.1 }, Waist = { 6, 12, 0 }, Neck = { 0, -12, 0 }, RS = { 70, 0, 40 }, RE = { 90, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, LH = { 80, 0, 0 }, LK = { -115, 0, 0 } },
			strike = { Root = { 16, 10, 0, 0, -0.1, 0.05 }, Waist = { 12, 6, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, LH = { 100, 0, 0 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 18, 12, 0, 0, -0.1, 0.08 }, Waist = { 14, 8, 0 }, Neck = { -12, 0, 0 }, RS = { 38, 0, 62 }, RE = { 40, 0, 0 }, LS = { 28, 0, -62 }, LE = { 40, 0, 0 }, LH = { 106, 0, 0 }, LK = { 0, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "leftFoot", text = "NUL !", hitText = "VLAN !",
		},
		-- K K K K : Ragekick sauté, il bondit et décoche un coup de pied de rage, « git gud ! » (finition)
		K_combo3 = {
			label = "Ragekick sauté", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 82, kbAngle = 42, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -10, 0, 0, 0, -0.7, 0.1 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 30 }, RE = { 40, 0, 0 }, LS = { -40, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 16, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 155, 0, 45 }, RE = { 20, 0, 0 }, LS = { 155, 0, -45 }, LE = { 20, 0, 0 }, RH = { 106, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 34, 0, 0 }, LK = { -114, 0, 0 } },
			trail = "rightFoot", text = "GIT GUD !", hitText = "BAM !",
		},
		-- P puis K : Coup de pied de tilt, petit coup sec dans le tibia en trépignant
		PK_combo = {
			label = "Coup de pied de tilt", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { -4, -10, 0, 0, -0.25, 0.15 }, Waist = { -10, -10, 0 }, RS = { 50, 0, -10 }, RE = { 100, 0, 0 }, LS = { 50, 0, 10 }, LE = { 100, 0, 0 }, RH = { -20, 0, 6 }, RK = { -75, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.3, -0.2 }, Waist = { -14, 8, 0 }, RS = { 55, 0, -10 }, RE = { 95, 0, 0 }, LS = { 55, 0, 10 }, LE = { 95, 0, 0 }, RH = { 60, 0, 4 }, RK = { -5, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -9, 12, 0, 0, -0.32, -0.24 }, Waist = { -15, 10, 0 }, RS = { 56, 0, -10 }, RE = { 95, 0, 0 }, LS = { 56, 0, 10 }, LE = { 95, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- K puis P : Uppercut manette, de l'accroupi jusqu'au ciel (fait décoller)
		KP_combo = {
			label = "Uppercut manette", startup = 0.08, active = 0.1, recovery = 0.24,
			damage = 8, hitbox = box(5, 5, 2.5, 1.5), kbBase = 28, kbGrowth = 45, kbAngle = 80,
			windup = { Root = { -8, -14, 0, 0, -0.7, 0.1 }, Waist = { -20, -14, 0 }, Neck = { -8, 0, 0 }, RS = { -30, 0, 25 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { 8, 14, 0, 0, 0.15, -0.2 }, Waist = { 14, 18, 0 }, Neck = { 20, 0, 0 }, RS = { 165, 0, 8 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -30 }, LE = { 50, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 10, 16, 0, 0, 0.2, -0.24 }, Waist = { 16, 20, 0 }, Neck = { 24, 0, 0 }, RS = { 176, 0, 4 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -15, 0, -32 }, LE = { 50, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			trail = "prop", text = "UPPERCUT !", hitText = "WOUSH !",
		},

		-- P P P : Quart de cercle avant, il mime la manip du hadoken et pousse les deux paumes : boule RGB à bout portant
		P_hadoken = {
			label = "Quart de cercle avant", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(5.5, 4.5, 3.2, 0.8), kbBase = 20, kbGrowth = 28, kbAngle = 35,
			windup = { Root = { -4, 40, 0, 0, -0.35, 0.15 }, Waist = { -6, 30, 0 }, Neck = { 0, -24, 0 }, RS = { 30, 0, -20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, 20 }, LE = { 110, 0, 0 }, LW = { 60, 0, 0 } },
			strike = { Root = { -12, -10, 0, 0, -0.3, -0.4 }, Waist = { -14, -10, 0 }, Neck = { -6, 8, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, 0 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, -12, 0, 0, -0.32, -0.45 }, Waist = { -16, -12, 0 }, Neck = { -8, 10, 0 }, RS = { 98, 0, 2 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 98, 0, -2 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "bothHands", windupFx = { { "symbols", symbols = { "↓", "↘", "→" }, count = 3, radius = 2, color = VERT, at = "front" } }, fx = { { "burst", color = BLEU, size = 3.5, at = "front" }, { "ring", color = VIOLET, radius = 2.5, at = "front" } }, text = "HA-DO-KEN !", hitText = "BZZOUM !",
		},
		-- → P P P : Ctrl+Alt+Suppr, trois touches tapées à toute vitesse… sur le front d'en face
		P_ctrlalt = {
			label = "Ctrl+Alt+Suppr", startup = 0.06, active = 0.2, recovery = 0.18,
			damage = 3, hits = 3, hitbox = box(5.5, 4, 3.2, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 40,
			windup = { Root = { -6, 0, 0, 0, -0.25, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 92, 0, 10 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 92, 0, -10 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 80, 0, 10 }, RE = { 40, 0, 0 }, RW = { 20, 0, 0 }, LS = { 80, 0, -10 }, LE = { 40, 0, 0 }, LW = { 20, 0, 0 } },
			wobble = true, prop = "clavier", hideProp = "manette", trail = "prop", fx = { { "symbols", symbols = { "CTRL", "ALT", "SUPPR" }, count = 3, radius = 2.5, at = "front", color = BLANC } }, text = "CTRL-ALT-SUPPR !", hitText = "GESTIONNAIRE DES TÂCHES !",
		},
		-- → P P P P : Barre espace, le clavier balaie à l'horizontale de tout son long, l'adversaire part au bout de l'arène (finition)
		P_espace = {
			label = "Barre espace", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(6.5, 4.5, 3.5, 0.8), kbBase = 38, kbGrowth = 78, kbAngle = 20,
			windup = { Root = { 4, -40, 0, 0, -0.3, 0.3 }, Waist = { 6, -44, 0 }, Neck = { 0, 26, 0 }, RS = { 70, 0, 90 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -90 }, LE = { 10, 0, 0 } },
			strike = { Root = { -12, 24, 0, 0, -0.4, -0.45 }, Waist = { -14, 36, 0 }, Neck = { 0, -18, 0 }, RS = { 92, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, 40, 0, 0, -0.42, -0.5 }, Waist = { -16, 52, 0 }, Neck = { 0, -26, 0 }, RS = { 86, 0, -40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 86, 0, -28 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "clavier", hideProp = "manette", trail = "prop", fx = { { "beam", color = BLEU, length = 7, width = 1.6, at = "front" }, { "shake", amount = 0.3 } }, text = "ESPAAACE !", hitText = "TAB-ULÉ !",
		},
		-- ↓ P P : Clic droit, la souris revient au bout de son fil et claque dans la figure
		P_souris2 = {
			label = "Clic droit", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(5.5, 4, 3.2, 0.8), kbBase = 20, kbGrowth = 26, kbAngle = 40,
			windup = { Root = { -8, -20, 0, 0, -0.5, 0.1 }, Waist = { -14, -16, 0 }, Neck = { 0, 14, 0 }, RS = { 120, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, 16, 0, 0, -0.3, -0.3 }, Waist = { -12, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			follow = { Root = { -12, 20, 0, 0, -0.32, -0.34 }, Waist = { -14, 22, 0 }, Neck = { -8, -12, 0 }, RS = { 90, 0, -15 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			prop = "souris", hideProp = "manette", trail = "prop", fx = { { "symbols", symbols = { "🖱️", "!" }, count = 2, radius = 2, at = "front", color = BLANC } }, text = "CLIC !", hitText = "CLIC DROIT !",
		},
		-- ↓ P P P : Glisser-déposer, il enroule le fil de la souris autour d'en face et le balance par-dessus sa tête (finition, fait décoller)
		P_deposer = {
			label = "Glisser-déposer", startup = 0.1, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(5.5, 5.5, 3, 1.5), kbBase = 34, kbGrowth = 74, kbAngle = 84,
			windup = { Root = { -14, 20, 0, 0, -0.45, 0.1 }, Waist = { -18, 20, 0 }, Neck = { -6, -14, 0 }, RS = { 40, 0, 40 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 } },
			strike = { Root = { 10, -10, 0, 0, 0.15, -0.1 }, Waist = { 14, -10, 0 }, Neck = { 28, 8, 0 }, RS = { 180, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 14, -14, 0, 0, 0.2, -0.1 }, Waist = { 18, -14, 0 }, Neck = { 34, 10, 0 }, RS = { 195, 0, 5 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 180, 0, -25 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "souris", hideProp = "manette", trail = "prop", fx = { { "text", text = "DÉPLACER VERS… LA CORBEILLE", color = VERT, at = "above" }, { "burst", color = VERT, size = 3, at = "above" } }, text = "GLISSER…", hitText = "DÉPOSÉ !",
		},
		-- K K K : Trash talk, il se penche en avant, doigt pointé, et hurle deux insultes de gamer à bout portant
		K_trashtalk = {
			label = "Trash talk", startup = 0.06, active = 0.16, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5.5, 4.5, 3.2, 1), kbBase = 18, kbGrowth = 26, kbAngle = 40,
			windup = { Root = { 6, 0, 0, 0, -0.15, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 110, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.35, -0.4 }, Waist = { -18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -18, 0, 0, 0, -0.38, -0.45 }, Waist = { -20, 0, 0 }, Neck = { -14, 0, 6 }, RS = { 100, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, wobble = true, trail = "rightHand", fx = { { "symbols", symbols = { "EZ", "NOOB", "💢" }, count = 4, radius = 3, at = "front", color = ROUGE } }, text = "EZ ! NOOB !", hitText = "POSTILLONS !",
		},
		-- ↓ K K : Tour de chaise, assis sur sa chaise à roulettes, il tourne sur lui-même les pieds en avant
		K_down2 = {
			label = "Tour de chaise", startup = 0.07, active = 0.18, recovery = 0.2,
			damage = 7, hitbox = box(6.5, 4, 2.5, 0.5), kbBase = 20, kbGrowth = 30, kbAngle = 45,
			windup = { Root = { 10, -30, 0, 0, -1.2, 0 }, Waist = { 0, -20, 0 }, Neck = { 0, 20, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 90, 0, 10 }, RK = { -95, 0, 0 }, LH = { 90, 0, -10 }, LK = { -95, 0, 0 } },
			strike = { Root = { 12, 0, 0, 0, -1.2, -0.1 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 88, 0, 15 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 88, 0, -15 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -1.2, -0.1 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 88, 0, 15 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 88, 0, -15 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, prop = "chaise", hideProp = "manette", trail = "bothFeet", fx = { "dust" }, text = "WIIII !", hitText = "ROULETTES !",
		},
		-- ↓ K K K : Chaise renversée, il bascule en arrière avec la chaise, les deux pieds partent vers le ciel (finition, fait décoller)
		K_down3 = {
			label = "Chaise renversée", startup = 0.1, active = 0.14, recovery = 0.36,
			damage = 11, hitbox = box(5.5, 5.5, 2.5, 1.5), kbBase = 34, kbGrowth = 76, kbAngle = 82,
			windup = { Root = { 10, 0, 0, 0, -1.2, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 90, 0, 10 }, RK = { -95, 0, 0 }, LH = { 90, 0, -10 }, LK = { -95, 0, 0 } },
			strike = { Root = { 70, 0, 0, 0, -1.4, 0.3 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 50 }, RE = { 40, 0, 0 }, LS = { 120, 0, -50 }, LE = { 40, 0, 0 }, RH = { 110, 0, 10 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 100, 0, -10 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 78, 0, 0, 0, -1.5, 0.4 }, Waist = { -12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 130, 0, 55 }, RE = { 40, 0, 0 }, LS = { 130, 0, -55 }, LE = { 40, 0, 0 }, RH = { 118, 0, 12 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 108, 0, -12 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			prop = "chaise", hideProp = "manette", trail = "bothFeet", fx = { { "shake", amount = 0.35 }, "dust", { "symbols", symbols = { "💢", "!!" }, count = 3, radius = 2.5, color = ROUGE } }, text = "MA CHAAAISE !", hitText = "PATATRAS !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Câble-fouet, il fouette l'air devant lui avec le câble de la manette (longue portée)
		P_air_side = {
			label = "Câble-fouet", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(6.5, 2.5, 4, 0.3), kbBase = 22, kbGrowth = 40, kbAngle = 28,
			windup = { Root = { -6, -20, 0 }, Waist = { -8, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 150, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -10, 16, 0 }, Waist = { -10, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -12, 20, 0 }, Waist = { -12, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 86, 0, -10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 38, 0, 0 }, RK = { -68, 0, 0 }, LH = { 52, 0, 0 }, LK = { -92, 0, 0 } },
			trail = "prop", text = "FOUET !", hitText = "TCHAK !",
		},
		-- ↑ P en l'air : Moulinet de câble, la manette tourne au-dessus de sa tête pendant qu'il pivote
		P_air_up = {
			label = "Moulinet de câble", startup = 0.09, active = 0.16, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 90, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 172, 0, 20 }, RE = { 5, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -50 }, LE = { 90, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 176, 0, -10 }, RE = { 5, 0, 0 }, RW = { 70, 0, 0 }, LS = { 42, 0, -52 }, LE = { 92, 0, 0 }, RH = { 8, 0, 0 }, RK = { -36, 0, 0 }, LH = { 18, 0, 0 }, LK = { -58, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "VRRRT !",
		},
		-- ↓ P en l'air : Smash de manette à deux mains, levée au-dessus de la tête puis abattue vers le sol
		P_air_down = {
			label = "Smash de manette", startup = 0.15, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80,
			windup = { Root = { 18, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 195, 0, -8 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 195, 0, 8 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 65, 0, -8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 65, 0, 8 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -26, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 42, 0, -8 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 42, 0, 8 }, LE = { 5, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "prop", text = "GAME OVER !", hitText = "KRAK !",
		},
		-- → K en l'air : Coup de pied tilté, buste en arrière, jambe droite qui part à l'horizontale
		K_air_side = {
			label = "Coup de pied tilté", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 34,
			windup = { Root = { -14, 20, 0 }, Waist = { -16, 10, 0 }, RS = { 50, 0, 45 }, RE = { 90, 0, 0 }, LS = { 70, 0, -30 }, LE = { 100, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 28, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 40, 0, -70 }, LE = { 40, 0, 0 }, RH = { 66, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 32, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, 0, 0 }, RS = { -38, 0, 65 }, RE = { 30, 0, 0 }, LS = { 45, 0, -75 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Salto ragequit, salto arrière rageur, les pieds balaient au-dessus de sa tête
		K_air_up = {
			label = "Salto ragequit", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "RAGEQUIT !", hitText = "POC !",
		},
		-- ↓ K en l'air : Piétinement clavier, il retombe à pieds joints comme pour écraser son clavier (smash vers le bas)
		K_air_down = {
			label = "Piétinement clavier", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 60, 0, 0 }, LS = { 120, 0, -45 }, LE = { 60, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 50 }, RE = { 90, 0, 0 }, LS = { 40, 0, -50 }, LE = { 90, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 35, 0, 55 }, RE = { 95, 0, 0 }, LS = { 35, 0, -55 }, LE = { 95, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "CTRL-ALT-SUPPR !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Signatures (L) : sûres de toucher (couloir / projectiles visés, voir docs/fiche-perso.md)
		-- Paquet de chips : il sort son paquet et le balance droit sur la figure de l'adversaire ; personne à portée : il retombe
		-- et éclate en un nuage de miettes grasses qui reste au sol
		S_neutral = {
			label = "Paquet de chips", kind = "projectile", startup = 0.2, active = 0, recovery = 0.42,
			damage = 13, kbBase = 22, kbGrowth = 38, kbAngle = 35,
			projectile = { speed = 55, angle = 12, gravity = 40, lifetime = 0.8, size = 2.6, color = CHIPS, linger = 1.2,
				visual = { shape = "block", size = 1.2, color = CHIPS, material = "Foil", spin = 10, parts = { { "block", Vector3.new(1.25, 0.3, 0.75), Vector3.zero, ROUGE } } } },
			windup = { Root = { 6, -24, 0, 0, -0.15, 0.25 }, Waist = { 10, -30, 0 }, Neck = { 0, 16, 0 }, RS = { 185, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -12, 20, 0, 0, -0.3, -0.35 }, Waist = { -22, 30, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -30 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 26, 0, 0, -0.35, -0.4 }, Waist = { -26, 38, 0 }, Neck = { 0, -14, 0 }, RS = { 60, 0, -15 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -30, 0, -35 }, LE = { 75, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			prop = "chips", hideProp = "manette", trail = "prop", fx = { { "toss", shape = "flat", color = CHIPS, size = 0.4, count = 5, speed = 20 } }, text = "CRUNCH !", hitText = "MIETTES !",
		},
		-- Speedrun : il glisse à genoux à toute vitesse d'un bout à l'autre du couloir, traverse l'adversaire et ressort derrière lui
		S_side = {
			label = "Speedrun", startup = 0.15, active = 0.24, recovery = 0.42,
			damage = 13, hitbox = box(12, 5, 5, -0.5), kbBase = 30, kbGrowth = 58, kbAngle = 50, selfVelocity = Vector2.new(85, 0),
			invuln = 0.3, teleport = 7,
			windup = { Root = { -14, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -30, 0, 30 }, RE = { 40, 0, 0 }, LS = { -30, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 16, 0, 0, 0, -1.2, -0.3 }, Waist = { 10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -120, 0, 0 }, LH = { 10, 0, 0 }, LK = { -120, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, -1.22, -0.35 }, Waist = { 12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 155, 0, 32 }, RE = { 20, 0, 0 }, LS = { 155, 0, -32 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -122, 0, 0 }, LH = { 10, 0, 0 }, LK = { -122, 0, 0 } },
			trail = "body", fx = { "dust", { "text", text = "WORLD RECORD", color = VERT, at = "above" } }, text = "SPEEDRUN !", hitText = "SKIP !",
		},
		-- Câble tendu : il arrache le câble de la manette, le claque au ras du sol sur toute la longueur du couloir, et tout le monde trébuche
		S_down = {
			label = "Câble tendu", startup = 0.22, active = 0.16, recovery = 0.48,
			damage = 13, hitbox = box(14, 6, 7, 0.5), kbBase = 26, kbGrowth = 50, kbAngle = 75,
			status = { name = "stunned", duration = 0.7 },
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.8, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 60, 0, 8 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 55, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -20, 0, 0, 0, -0.85, -0.35 }, Waist = { -32, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 45, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			trail = "prop", fx = { { "beam", color = NOIR, length = 16, width = 0.4, at = "feet" }, { "ring", color = VERT, radius = 4, at = "front" }, "dust" },
			text = "CÂBLE TENDU !", hitText = "PATATRAS !",
		},
		-- Rage Jump (remontée) : il hurle de rage et le cri le propulse en diagonale vers l'avant, manette tendue devant lui
		-- comme un bélier, jambes qui gigotent derrière ; tout ce qui est sur le passage prend la rage
		S_up = {
			label = "Rage Jump", startup = 0.15, active = 0.32, recovery = 0.4,
			damage = 15, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 55, kbAngle = 72, selfVelocity = Vector2.new(44, 86),
			windup = { Root = { -6, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 20, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 110, 0, 0 } },
			strike = { Root = { -42, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 168, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -45 }, LE = { 110, 0, 0 }, RH = { -24, 0, 8 }, RK = { -40, 0, 0 }, RA = { -25, 0, 0 }, LH = { -36, 0, -8 }, LK = { -55, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -46, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 172, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 45, 0, -50 }, LE = { 110, 0, 0 }, RH = { -36, 0, 10 }, RK = { -55, 0, 0 }, RA = { -25, 0, 0 }, LH = { -24, 0, -10 }, LK = { -40, 0, 0 }, LA = { -25, 0, 0 } },
			shake = true, trail = "prop",
			fx = { { "pillar", color = VIOLET, height = 10, width = 3, at = "feet" }, { "particles", tex = "spark", color = VERT, dir = "down", at = "feet", time = 0.4, speed = 14 }, { "ring", color = ROUGE, radius = 4, at = "feet" }, { "symbols", symbols = { "💢", "RAAH" }, count = 3, radius = 2, color = ROUGE } },
			text = "RAAAAAH !", hitText = "RAGE !",
		},
		-- Écran bleu (plongeon) : il tombe en tenant un vieil écran à bout de bras sur tout ce qu'il y a dessous ; l'impact fige l'adversaire
		S_air_down = {
			label = "Écran bleu", startup = 0.18, active = 0.35, recovery = 0.45,
			damage = 14, hitbox = box(8, 6, 1, -2), kbBase = 28, kbGrowth = 55, kbAngle = -60, selfVelocity = Vector2.new(0, -85),
			status = { name = "frozen", duration = 0.5 },
			windup = { Root = { 14, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -10 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -22, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 25, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 20 }, LE = { 20, 0, 0 }, RH = { 38, 0, 0 }, RK = { -78, 0, 0 }, LH = { 38, 0, 0 }, LK = { -78, 0, 0 } },
			prop = "ecran", hideProp = "manette", trail = "prop",
			fx = { { "screen", color = BSOD, alpha = 0.25 }, { "ring", color = BSOD, radius = 6, at = "feet" }, { "shake", amount = 0.4 } }, text = ":(", hitText = "ÉCRAN BLEU !",
		},
		-- Freeze (esquive puis S) : il pointe la manette comme une télécommande et met en pause tout le couloir devant lui (0,8 s)
		S_dodge = {
			label = "Freeze", startup = 0.15, active = 0.14, recovery = 0.42,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 8, kbGrowth = 8, kbAngle = 0,
			status = { name = "stunned", duration = 0.8 },
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 4, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, -0.3, -0.4 }, Waist = { -10, 8, 0 }, Neck = { -6, -6, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 30, 0, -25 }, LE = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -12, 8, 0, 0, -0.3, -0.4 }, Waist = { -10, 8, 0 }, Neck = { -6, -6, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { -62, 0, 0 }, LS = { 30, 0, -25 }, LE = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.15, trail = "prop", fx = { { "beam", color = BLEU, length = 16, width = 2, at = "hand" }, { "symbols", symbols = { "⏸", "▓", "░" }, count = 6, radius = 4, color = BLEU, at = "front" } },
			text = "PAUSE !", hitText = "*LAG*",
		},
		-- Ventilo RGB (S maintenu) : il brandit un ventilateur de PC allumé à fond ; le souffle balaie tout le couloir et repousse très loin
		S_hold = {
			label = "Ventilo RGB", startup = 0.26, active = 0.3, recovery = 0.5,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 52, kbGrowth = 55, kbAngle = 10,
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.2 }, Waist = { 6, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -12, 4, 0, 0, -0.35, -0.3 }, Waist = { -10, 4, 0 }, Neck = { 6, 0, 0 }, RS = { 94, 0, 0 }, RE = { 5, 0, 0 }, RW = { -80, 0, 0 }, LS = { 88, 0, 12 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 4, 0, 0, -0.35, -0.35 }, Waist = { -12, 4, 0 }, Neck = { 8, 0, 0 }, RS = { 96, 0, 0 }, RE = { 5, 0, 0 }, RW = { -82, 0, 0 }, LS = { 90, 0, 12 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
			hold = 0.1, prop = "ventilo", hideProp = "manette",
			fx = { { "beam", color = VIOLET, length = 16, width = 4, at = "hand" }, { "particles", tex = "smoke", color = BLEU, dir = "front", at = "hand", time = 0.45, speed = 32, size = 1.2, rate = 90 } },
			text = "VROOOOM !", hitText = "WHOOSH !",
		},
		-- Moulinet nunchaku (→→S) : il avance en faisant tournoyer la manette au bout de son câble, un grand moulinet qui balaie tout le couloir
		S_dash = {
			label = "Moulinet nunchaku", startup = 0.15, active = 0.3, recovery = 0.42,
			damage = 14, hitbox = box(14, 6, 7, 0.5), kbBase = 32, kbGrowth = 60, kbAngle = 35, selfVelocity = Vector2.new(36, 0),
			windup = { Root = { -8, -20, 0, 0, -0.25, 0.1 }, Waist = { -6, -20, 0 }, RS = { 80, 0, 70 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.3, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 92, 0, 88 }, RE = { 0, 0, 0 }, RW = { 80, 0, 0 }, LS = { 60, 0, -50 }, LE = { 90, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.3, -0.3 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 94, 0, 88 }, RE = { 0, 0, 0 }, RW = { 80, 0, 0 }, LS = { 62, 0, -50 }, LE = { 90, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "prop", fx = { { "ring", color = ROUGE, radius = 5, at = "root" }, "dust" }, text = "MOULINET !", hitText = "WATAAA !",
		},
		-- Pic de lag (S en l'air) : il frappe dans un sursaut saccadé tout autour de lui… puis se « téléporte » en arrière comme un lag
		S_air = {
			label = "Pic de lag", startup = 0.15, active = 0.16, recovery = 0.42,
			damage = 13, hitbox = box(8, 6, 2, 0), kbBase = 28, kbGrowth = 52, kbAngle = 35, teleport = -5,
			windup = { Root = { -8, 10, 6 }, Waist = { -10, 10, 0 }, Neck = { 0, -10, 10 }, RS = { 140, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -20, -10, -6 }, Waist = { -14, -10, 0 }, Neck = { -10, 10, -10 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -22, -12, -8 }, Waist = { -16, -12, 0 }, Neck = { -12, 12, -12 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 38, 0, 0 }, RK = { -58, 0, 0 }, LH = { 62, 0, 0 }, LK = { -102, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "▓", "░", "▒" }, count = 8, radius = 3, color = VERT }, { "ring", color = VERT, radius = 4, at = "root" } }, text = "LAG !", hitText = "*GLITCH*",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Explosion de rage : poings vers le sol, il hurle et tout vole autour de lui
		S_finish_rage = {
			label = "Explosion de rage", startup = 0.12, active = 0.2, recovery = 0.32,
			damage = 11, hitbox = box(8, 4.5, 0, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 45,
			windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, -20 }, RE = { 120, 0, 0 }, LS = { 30, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, -0.2, 0 }, Waist = { 14, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 20, 0, 50 }, RE = { 20, 0, 0 }, LS = { 20, 0, -50 }, LE = { 20, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.2, 0 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 15, 0, 55 }, RE = { 20, 0, 0 }, LS = { 15, 0, -55 }, LE = { 20, 0, 0 } },
			shake = true, fx = { { "burst", color = ROUGE, size = 5, at = "root" }, { "ring", color = ROUGE, radius = 6 }, { "shake", amount = 0.4 } },
			text = "J'EN AI MARRE !", hitText = "BOUM !",
		},
		-- Combo clavier : clavier levé à deux mains, abattu devant lui avec un « ENTRÉE » rageur
		S_finish_key = {
			label = "Touche Entrée", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(6, 4, 3.5, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 35,
			windup = { Root = { 10, 0, 0, 0, -0.05, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 5 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -5 }, LE = { 40, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.4, -0.35 }, Waist = { -24, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 85, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 0 }, LE = { 10, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.45, -0.4 }, Waist = { -28, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 66, 0, 0 }, LE = { 10, 0, 0 } },
			prop = "clavier", hideProp = "manette", trail = "prop", text = "ENTRÉE !", hitText = "CLAC !",
		},

		------------------------------------------------------------------ Supers (Y) : couloir 1,3 fois plus grand, plus farfelus
		-- Rage Quit ! (Y) : il fracasse son clavier et une pluie de touches tombe du ciel pile sur l'adversaire
		SUPER = {
			label = "Rage Quit !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 3, kbBase = 20, kbGrowth = 25, kbAngle = 50,
			projectile = { speed = 60, gravity = 40, lifetime = 1.2, size = 1.6, color = BLANC, rain = { count = 8, spread = 6, ahead = 9, height = 22 },
				visual = { shape = "block", size = 1.0, color = BLANC, text = "ESC", textColor = NOIR, spin = 8 } },
			windup = { Root = { 8, 0, 0, 0, -0.05, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 190, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.6, -0.2 }, Waist = { -30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 30, 0, 0 } },
			follow = { Root = { -14, 0, 0, 0, -0.6, -0.2 }, Waist = { -32, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 30, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 30, 0, 0 } },
			hold = 0.3, prop = "clavier", hideProp = "manette", windupFx = { "super" },
			fx = { { "burst", color = BLEU, size = 4, at = "front" }, { "toss", shape = "block", color = BLANC, size = 0.5, count = 10, speed = 28 }, { "shake", amount = 0.5 } },
			text = "RAGE QUIT !", hitText = "TAC-TAC-TAC !",
		},
		-- Chaise en orbite (Y↑) : il empoigne sa chaise gaming à deux mains et la balance de toutes ses forces : elle fonce droit
		-- sur l'adversaire et l'emporte en orbite… et il reste planté à la regarder s'éloigner
		SUPER_up = {
			label = "Chaise en orbite !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.75,
			damage = 24, kbBase = 46, kbGrowth = 95, kbAngle = 86,
			projectile = { speed = 78, angle = 45, gravity = 0, lifetime = 1.3, size = 4.2, color = NOIR, pierce = true, from = "above",
				visual = { shape = "block", size = 2.2, color = SWEAT_FONCE, spin = 5, parts = {
					{ "block", Vector3.new(2.2, 0.5, 2.2), Vector3.new(0, -0.6, 0), SWEAT_FONCE },
					{ "block", Vector3.new(2.2, 2.6, 0.5), Vector3.new(0, 0.9, 1.0), SWEAT_FONCE },
					{ "block", Vector3.new(0.4, 2.6, 0.2), Vector3.new(0, 0.9, 0.75), ROUGE },
					{ "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.9, -1.4, 0.9), VERT },
					{ "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.9, -1.4, -0.9), VIOLET },
				} } },
			windup = { Root = { -12, 0, 0, 0, -0.75, 0.1 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, 0.2, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -14 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.2, 0 }, Waist = { 16, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 150, 0, 60 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 0, 0, 0 } },
			hold = 0.3, shake = true, prop = "chaise", hideProp = "manette",
			windupFx = { "super", { "symbols", symbols = { "💢", "!!" }, count = 4, radius = 2.5, color = ROUGE } },
			fx = { { "beam", color = VIOLET, length = 14, width = 3.5, at = "hand" }, { "burst", color = VERT, size = 4, at = "above" }, { "shake", amount = 0.5 }, { "text", text = "ELLE REVIENT PAS ?", color = BLANC, at = "above" } },
			text = "MA CHAIIISE !", hitText = "EN ORBITE !",
		},
		-- Code de triche (Y↓) : il tape le code sur la manette, aura « GOD MODE » : invincible 2,5 s et une onde de choc
		-- dorée des deux côtés sur toute la plateforme
		SUPER_down = {
			label = "Code de triche !", startup = 0.4, active = 0.2, recovery = 0.65,
			damage = 22, hitbox = box(34, 8, 0, 2), kbBase = 36, kbGrowth = 62, kbAngle = 60,
			invuln = 2.5, selfEffect = { armor = 3 },
			windup = { Root = { -4, 0, 0, 0, -0.25, 0 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 60, 0, -15 }, RE = { 110, 0, 0 }, RW = { -20, 0, 0 }, LS = { 60, 0, 15 }, LE = { 110, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.2, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -40 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.25, 0 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 175, 0, 45 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -45 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			hold = 0.4, windupFx = { "super", { "text", text = "↑↑↓↓←→←→ B A", color = VERT, at = "above" } },
			fx = { { "pillar", color = Color3.fromRGB(255, 215, 60), height = 16, width = 4, at = "root" }, { "ring", color = Color3.fromRGB(255, 215, 60), radius = 10 }, { "ring", color = Color3.fromRGB(255, 215, 60), radius = 17, time = 0.5 }, { "text", text = "GOD MODE", color = Color3.fromRGB(255, 215, 60), at = "above" } },
			text = "GOD MODE !", hitText = "TRICHEUR !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise de rage : il agrippe l'adversaire par la capuche d'une main, l'autre poing déjà armé
		GRAB = {
			label = "Prise de rage", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { -6, 10, 0, 0, -0.2, 0.15 }, Waist = { -10, 10, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 90, 0, 0 }, LS = { 120, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, -6, 0, 0, -0.25, -0.3 }, Waist = { -14, -6, 0 }, Neck = { -14, 0, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, LS = { 105, 0, 5 }, LE = { 30, 0, 0 } },
			follow = { Root = { -10, -8, 0, 0, -0.25, -0.3 }, Waist = { -14, -8, 0 }, Neck = { -14, 0, 0 }, RS = { 62, 0, 32 }, RE = { 122, 0, 0 }, LS = { 108, 0, 5 }, LE = { 35, 0, 0 } },
			text = "VIENS LÀ !", hitText = "GRR !",
		},
		-- ✋ puis → : Alt+F4, il lance l'adversaire droit devant comme on ferme une fenêtre
		THROW_fwd = {
			label = "Alt+F4", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 42, kbGrowth = 55, kbAngle = 10,
			carry = { { 0, 2.4, 0.4 }, { 0.14, 1.4, 0.4 }, { 0.3, 4.5, 0.6 } },
			windup = { Root = { 6, 30, 0, 0, -0.3, 0.3 }, Waist = { 8, 26, 0 }, Neck = { 0, -16, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, LS = { 80, 0, -10 }, LE = { 60, 0, 0 } },
			strike = { Root = { -20, -12, 0, 0, -0.45, -0.5 }, Waist = { -18, -12, 0 }, Neck = { 10, 6, 0 }, RS = { 90, 0, 0 }, RE = { 5, 0, 0 }, LS = { 90, 0, 0 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -24, -16, 0, 0, -0.5, -0.55 }, Waist = { -20, -14, 0 }, Neck = { 14, 8, 0 }, RS = { 92, 0, -5 }, RE = { 5, 0, 0 }, LS = { 92, 0, 5 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { "dust", { "text", text = "[X]", color = ROUGE, at = "front" } }, text = "ALT+F4 !", hitText = "FERMÉ !",
		},
		-- ✋ puis ← : Câble arraché, il fait passer l'adversaire par-dessus son épaule comme une manette qu'on débranche
		THROW_back = {
			label = "Câble arraché", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.12, 1.6, 1.0 }, { 0.26, 0.2, 3.2 }, { 0.4, -2.6, 0.2 } },
			windup = { Root = { -10, 0, 0, 0, -0.5, 0.1 }, Waist = { -16, 0, 0 }, RS = { 80, 0, -10 }, RE = { 60, 0, 0 }, LS = { 80, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.35, 0.3 }, Waist = { 26, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 195, 0, -10 }, RE = { 20, 0, 0 }, LS = { 195, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 34, 0, 0, 0, -0.38, 0.35 }, Waist = { 30, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 205, 0, -10 }, RE = { 20, 0, 0 }, LS = { 205, 0, 10 }, LE = { 20, 0, 0 } },
			fx = { "dust" }, text = "DÉBRANCHÉ !", hitText = "BADABOUM !",
		},
		-- ✋ puis ↑ : Lancer de manette, il lance l'adversaire au ciel comme une manette jetée de rage
		THROW_up = {
			label = "Lancer de manette", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, -0.8 }, { 0.3, 0.8, 4.0 } },
			windup = { Root = { -10, 0, 0, 0, -0.8, 0.1 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 45, 0, -15 }, RE = { 40, 0, 0 }, LS = { 45, 0, 15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, -0.1 }, Waist = { 15, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.35, -0.1 }, Waist = { 18, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 180, 0, 20 }, RE = { 5, 0, 0 }, LS = { 180, 0, -20 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			text = "VOLE !", hitText = "ZWIIING !",
		},
		-- ✋ puis ↓ : Clavier cassé, il plaque l'adversaire au sol et tape dessus à deux poings comme sur un clavier
		THROW_down = {
			label = "Clavier cassé", kind = "throw", startup = 0.4, active = 0.1, hold = 0.3, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 2.0, 1.4 }, { 0.28, 1.8, -2.0 }, { 0.4, 1.6, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.9, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 40, 0, 0 }, LS = { 30, 0, 10 }, LE = { 90, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.9, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, -10 }, RE = { 90, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 } },
			wobble = true, fx = { "dust", { "symbols", symbols = { "Q", "W", "E", "R" }, count = 6, radius = 2, color = BLANC, at = "front" } },
			text = "TAPE-TAPE-TAPE !", hitText = "CLAC-CLAC !",
		},
	},

	-- Fatals (→ = forward, ← = back) : 1er offert, 2e au niveau de maîtrise 5, 3e au niveau 15
	fatals = {
		{
			id = "game_over", label = "Game Over", sequence = { "down", "forward", "forward" },
			-- l'adversaire devient du pixel art 8-bit et se désagrège en pixels
			scene = {
				{ "fxAttacker", { "text", text = "GG EZ.", color = VERT } },
				{ "material", "Slate" },
				{ "color", Color3.fromRGB(90, 200, 90) },
				{ "fx", { "symbols", symbols = { "▓", "░", "▒", "█" }, count = 10, radius = 3, color = VERT } },
				{ "wait", 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 3, pieces = {
					{ "Pixel1", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(-1.2, 1.5, 0), Vector3.zero, VERT, "Neon", { neon = true } },
					{ "Pixel2", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(1.0, 0.5, 0), Vector3.zero, BLEU, "Neon", { neon = true } },
					{ "Pixel3", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(-0.6, -1.0, 0), Vector3.zero, VIOLET, "Neon", { neon = true } },
					{ "Pixel4", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(1.4, -1.8, 0), Vector3.zero, ROUGE, "Neon", { neon = true } },
				} },
				{ "shrink", 0.4, time = 0.5 },
				{ "shrink", 0.15, time = 0.4 },
				{ "fx", { "burst", color = VERT, size = 3, at = "root" } },
				{ "hide" },
				{ "text", "GAME OVER" },
				{ "fxAttacker", { "text", text = "INSERT COIN ?", color = CHIPS } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "ctrl_z", label = "Ctrl+Z", sequence = { "back", "back", "down" },
			-- l'adversaire est rembobiné à toute vitesse jusqu'à disparaître dans l'écran titre
			scene = {
				{ "fxAttacker", { "text", text = "CTRL+Z !", color = BLEU } },
				{ "text", "◀◀" },
				{ "spin", -720, time = 0.6 },
				{ "launch", Vector3.new(6, 1, 0), time = 0.5 },
				{ "text", "◀◀ ◀◀" },
				{ "spin", -720, time = 0.4 },
				{ "spawn", at = "target", offset = Vector3.new(2, 1, 1), life = 3.5, pieces = {
					{ "EcranTitre", "", "block", Vector3.new(7, 5, 0.4), Vector3.zero, Vector3.zero, NOIR, "SmoothPlastic" },
					{ "Titre", "", "block", Vector3.new(5, 1, 0.5), Vector3.new(0, 1.2, 0), Vector3.zero, VIOLET, "Neon", { neon = true } },
					{ "Start", "", "block", Vector3.new(3, 0.5, 0.5), Vector3.new(0, -1.2, 0), Vector3.zero, BLANC, "Neon", { neon = true } },
				} },
				{ "shrink", 0.2, time = 0.6 },
				{ "move", to = "target", offset = Vector3.new(0, 1, 1), time = 0.3 },
				{ "hide" },
				{ "text", "PRESS START" },
				{ "fxAttacker", { "text", text = "ANNULÉ.", color = VERT } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "desinstalle", label = "Désinstallé", sequence = { "up", "forward", "down" },
			-- une barre « Désinstallation… » se remplit au-dessus de l'adversaire, qui s'efface à 100 %
			scene = {
				{ "fxAttacker", { "text", text = "DÉSINSTALLER ? OUI.", color = ROUGE } },
				{ "spawn", at = "above", offset = Vector3.new(0, 1, 0), life = 3.5, pieces = {
					{ "Cadre", "", "block", Vector3.new(6, 0.9, 0.3), Vector3.zero, Vector3.zero, BLANC, "SmoothPlastic" },
					{ "Remplissage", "", "block", Vector3.new(5.6, 0.6, 0.4), Vector3.zero, Vector3.zero, VERT, "Neon", { neon = true } },
				} },
				{ "text", "Désinstallation… 12 %" },
				{ "wait", 0.5 },
				{ "material", "Glass" },
				{ "text", "… 64 %" },
				{ "wait", 0.5 },
				{ "shrink", 0.6, time = 0.4 },
				{ "text", "… 99 %" },
				{ "wait", 0.7 },
				{ "text", "100 %" },
				{ "fx", { "particles", tex = "spark", color = VERT, dir = "up", at = "root", time = 0.6, speed = 10 } },
				{ "hide" },
				{ "fxAttacker", { "text", text = "ESPACE LIBÉRÉ !", color = VERT } },
				{ "wait", 1 },
			},
		},
	},

	-- Mécanique « rage » : les dégâts reçus remplissent la jauge ; pleine, il tilte (+50 % de dégâts, plus d'esquive)
	passive = { kind = "rage", name = "Rage", icon = "😡", max = 100, gain = 1.2, duration = 6, color = ROUGE },

	-- Recharge ⚡ : il s'enfile une poignée de chips et martèle sa manette, le casque RGB clignote de plus en plus vite
	charge = {
		label = "Chips et spam",
		loop = 1.4,
		lockWrist = true,
		color = VERT,
		keys = {
			{ 0.0, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 0.12, { Root = { -8, 0, 0, 0, -0.32, 0 }, Waist = { -17, 2, 0 }, Neck = { -15, 0, 0 }, RS = { 58, 0, -15 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 58, 0, 15 }, LE = { 100, 0, 0 } } },
			{ 0.24, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, -2, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 0.36, { Root = { -8, 0, 0, 0, -0.32, 0 }, Waist = { -17, 2, 0 }, Neck = { -15, 0, 0 }, RS = { 58, 0, -15 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 58, 0, 15 }, LE = { 100, 0, 0 } } },
			{ 0.48, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, -2, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 0.75, { Root = { -2, 0, 0, 0, -0.2, 0 }, Waist = { -4, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 50, 0, -10 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 120, 0, 20 }, LE = { 150, 0, 0 } } },
			{ 0.95, { Root = { -2, 0, 0, 0, -0.22, 0 }, Waist = { -4, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 50, 0, -10 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 115, 0, 20 }, LE = { 155, 0, 0 } } },
			{ 1.15, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 1.4, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "particles", tex = "spark", color = VIOLET, dir = "up", at = "head", time = 0.2, speed = 4 } },
			{ 0.3, { "particles", tex = "spark", color = VERT, dir = "up", at = "head", time = 0.15, speed = 4 } },
			{ 0.5, { "particles", tex = "spark", color = BLEU, dir = "up", at = "head", time = 0.1, speed = 4 } },
			{ 0.85, { "text", text = "CRUNCH", color = CHIPS, at = "head" } },
			{ 0.9, { "toss", shape = "flat", color = CHIPS, size = 0.4, count = 3, speed = 8 } },
		},
	},

	-- Manies au repos : il fait craquer sa nuque, secoue sa manette (« elle lague ! »), tapote du pied nerveusement
	fidgets = {
		{ duration = 1.8, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.35, { Neck = { 0, 0, 25 }, Waist = { -10, 0, 0 } } },
			{ 0.6, { Neck = { 0, 0, -25 }, Waist = { -10, 0, 0 } } },
			{ 0.9, { Neck = { 20, 0, 0 }, Waist = { -6, 0, 0 }, RS = { 60, 0, -20 }, RE = { 120, 0, 0 }, LS = { 60, 0, 20 }, LE = { 120, 0, 0 } } },
			{ 1.3, { Neck = { -10, 0, 0 } } },
			{ 1.8, {} },
		} },
		{ duration = 2.2, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { -20, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 110, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 0.6, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { -10, 0, 0 } } },
			{ 0.75, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 120, 0, 0 }, RW = { -40, 0, 0 } } },
			{ 0.9, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { -10, 0, 0 } } },
			{ 1.05, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 120, 0, 0 }, RW = { -40, 0, 0 } } },
			{ 1.6, { Neck = { 10, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 1.6, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.2, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { -6, 10, 0 } } },
			{ 0.4, { Root = { 0, 0, 0, 0, -0.22, 0 }, Neck = { -6, -10, 0 } } },
			{ 0.6, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { -6, 10, 0 } } },
			{ 0.8, { Root = { 0, 0, 0, 0, -0.22, 0 }, Neck = { -6, -10, 0 } } },
			{ 1.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { -6, 10, 0 } } },
			{ 1.6, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : il le tient par la capuche à bout de bras gauche, poing droit (manette) armé,
-- penché en avant, les épaules remontées de rage
data.grabHold = {
	Root = { -8, -6, 0, 0, -0.25, 0.05 },
	Waist = { -12, -6, 0 },
	Neck = { -12, 6, 0 },
	RS = { 50, 0, 35 },
	RE = { 120, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 100, 0, 8 },
	LE = { 30, 0, 0 },
}

-- Retour 🪂 : il réapparaît en pixels qui se recomposent comme un jeu qui recharge (« RESPAWN »), crie « LAG ! »
-- et remet son casque
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Dalle", "base", "block", Vector3.new(4.5, 0.5, 3.5), Vector3.new(0, -0.25, 0), Vector3.zero, NOIR, "SmoothPlastic", { reflect = 0.2 } },
		{ "BordAv", "", "block", Vector3.new(4.6, 0.12, 0.12), Vector3.new(0, 0, -1.75), Vector3.zero, VERT, "Neon", { neon = true } },
		{ "BordAr", "", "block", Vector3.new(4.6, 0.12, 0.12), Vector3.new(0, 0, 1.75), Vector3.zero, VIOLET, "Neon", { neon = true } },
		{ "Pixel1", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-1.8, 2.5, 0), Vector3.zero, VERT, "Neon", { neon = true } },
		{ "Pixel2", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(1.9, 4, 0.4), Vector3.zero, BLEU, "Neon", { neon = true } },
		{ "Pixel3", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-1.4, 5.2, -0.3), Vector3.zero, VIOLET, "Neon", { neon = true } },
		{ "Pixel4", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(1.6, 1.2, -0.2), Vector3.zero, ROUGE, "Neon", { neon = true } },
	} },
	keys = {
		{ 0.0, { Root = { -10, 0, 12, 0, -0.6, 0 }, Waist = { -16, 0, -8 }, Neck = { -20, 0, 14 }, RS = { 10, 0, 10 }, RE = { 20, 0, 0 }, LS = { 10, 0, -10 }, LE = { 20, 0, 0 } } },
		{ 0.25, { Root = { -10, 0, 12, 0, -0.6, 0 }, Waist = { -16, 0, -8 }, Neck = { -20, 0, 14 }, RS = { 10, 0, 10 }, RE = { 20, 0, 0 }, LS = { 10, 0, -10 }, LE = { 20, 0, 0 } } },
		{ 0.3, { Root = { 4, 0, -10, 0, -0.3, 0 }, Waist = { 0, 0, 10 }, Neck = { 10, 0, -12 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -10 }, LE = { 90, 0, 0 } } },
		{ 0.55, { Root = { 4, 0, -10, 0, -0.3, 0 }, Waist = { 0, 0, 10 }, Neck = { 10, 0, -12 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -10 }, LE = { 90, 0, 0 } } },
		{ 0.6, { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 } } },
		{ 0.85, { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 100, 0, 70 }, RE = { 30, 0, 0 }, LS = { 100, 0, -70 }, LE = { 30, 0, 0 } } },
		{ 1.2, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 0, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 150, 0, 35 }, RE = { 130, 0, 0 }, LS = { 150, 0, -35 }, LE = { 130, 0, 0 } } },
		{ 1.45, { Root = { -4, 0, 0, 0, -0.18, 0 }, Waist = { -8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 145, 0, 38 }, RE = { 135, 0, 0 }, LS = { 145, 0, -38 }, LE = { 135, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.05, { "symbols", symbols = { "▓", "░", "▒", "█" }, count = 10, radius = 3, color = VERT } },
		{ 0.3, { "text", text = "RESPAWN", color = VERT, at = "above" } },
		{ 0.85, { "text", text = "LAG !", color = ROUGE } },
		{ 1.25, { "particles", tex = "spark", color = VIOLET, dir = "all", at = "head", time = 0.3, speed = 6 } },
	},
}

-- Arbre d'enchaînements : P P P P = spam, nunchaku, hadoken, smash de rage ; → P P P P = clavier, revers, Ctrl+Alt+Suppr,
-- barre espace ; ↓ P P P = souris yo-yo, clic droit, glisser-déposer ; K K K K = chaise, pied rageur, trash talk,
-- ragekick ; ↓ K K K = roulettes, tour de chaise, chaise renversée. S finit presque toutes les chaînes (explosion de
-- rage tout autour, touche Entrée devant lui).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P P P P : spam bouton, nunchaku, quart de cercle avant, smash de rage (finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_key" },
	P_combo2 = { P = "P_hadoken", K = "PK_combo", up_P = "KP_combo", S = "S_finish_rage" },
	P_hadoken = { P = "P_combo3", K = "K_trashtalk", S = "S_finish_rage" },
	PK_combo = { K = "K_trashtalk", P = "KP_combo", S = "S_finish_key" },
	KP_combo = { P = "P_combo3", S = "S_finish_rage" },
	-- K K K K : chaise gaming, coup de pied rageur, trash talk, ragekick sauté (finition)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_rage" },
	K_combo2 = { K = "K_trashtalk", P = "P_hadoken", S = "S_finish_key" },
	K_trashtalk = { K = "K_combo3", P = "P_espace", S = "S_finish_rage" },
	-- → P P P P : coup de clavier, revers, Ctrl+Alt+Suppr, barre espace (finition à l'horizontale)
	P_side = { P = "P_side2", K = "PK_combo", S = "S_finish_key" },
	P_side2 = { P = "P_ctrlalt", K = "K_combo2", S = "S_finish_rage" },
	P_ctrlalt = { P = "P_espace", K = "K_trashtalk", S = "S_finish_key" },
	-- ↓ P P P : souris yo-yo (fait décoller), clic droit, glisser-déposer (finition vers le ciel)
	P_down = { P = "P_souris2", K = "K_down", up_K = "K_up", S = "S_finish_rage" },
	P_souris2 = { P = "P_deposer", K = "K_down2", S = "S_finish_key" },
	-- ↓ K K K : glissade à roulettes, tour de chaise, chaise renversée (finition vers le ciel)
	K_down = { K = "K_down2", up_K = "K_up", P = "P_souris2", S = "S_finish_rage" },
	K_down2 = { K = "K_down3", P = "P_hadoken", S = "S_finish_key" },
	-- autres départs
	P_up = { K = "K_up", P = "P_combo2", S = "S_finish_key" },
	P_dash = { P = "P_ctrlalt", K = "PK_combo", S = "S_finish_key" },
	K_side = { S = "S_finish_rage" }, -- clavier volant
	K_up = { S = "S_finish_key" },
	K_dash = { P = "KP_combo", K = "K_trashtalk", S = "S_finish_rage" },
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

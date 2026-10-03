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

local data = {
	id = "Lola",
	name = "Lola Filtre",
	costume = "Lola",
	style = "diva",

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

		------------------------------------------------------------------ Signatures (S)
		-- Le Flash : téléphone braqué sur l'adversaire, gros flash blanc qui l'étourdit 0,5 s (de quoi placer un combo)
		S_neutral = {
			label = "Le Flash", energyCost = 25, startup = 0.14, active = 0.1, recovery = 0.28,
			damage = 6, hitbox = box(7, 5, 3.5, 1), kbBase = 10, kbGrowth = 10, kbAngle = 20,
			status = { name = "stunned", duration = 0.5 },
			windup = { Root = { 4, -10, 0, 0, -0.15, 0.15 }, Waist = { 4, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 70, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, 30 }, LE = { 140, 0, 0 } },
			strike = { Root = { -4, 8, 0, 0, -0.2, -0.15 }, Waist = { -4, 8, 0 }, Neck = { -6, -8, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 15, 0, 0 }, LS = { 150, 0, 40 }, LE = { 140, 0, 0 } },
			follow = { Root = { -4, 10, 0, 0, -0.2, -0.18 }, Waist = { -4, 10, 0 }, Neck = { -6, -10, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 18, 0, 0 }, LS = { 152, 0, 40 }, LE = { 142, 0, 0 } },
			hold = 0.1, fx = { { "burst", color = FLASH, size = 5, at = "front" }, { "ring", color = FLASH, radius = 4, at = "front" } },
			text = "FLASH !", hitText = "ÉBLOUI !",
		},
		-- Hashtag : elle tape le hashtag sur son téléphone et un gros # bleu part à l'horizontale
		S_side = {
			label = "Hashtag", energyCost = 25, kind = "projectile", startup = 0.18, active = 0, recovery = 0.32,
			damage = 10, kbBase = 25, kbGrowth = 50, kbAngle = 30,
			projectile = { speed = 42, angle = 0, gravity = 0, lifetime = 1.1, size = 2.2, color = BLEU,
				visual = { shape = "block", size = 1.8, color = BLEU, neon = true, transparency = 0.15, text = "#", spin = 3 } },
			windup = { Root = { 2, -14, 0, 0, -0.15, 0.15 }, Waist = { 0, -12, 0 }, Neck = { -12, 0, 0 }, RS = { 80, 0, -20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 20 }, LE = { 110, 0, 0 } },
			strike = { Root = { -8, 16, 0, 0, -0.25, -0.3 }, Waist = { -8, 18, 0 }, Neck = { 6, -10, 0 }, RS = { 50, 0, 40 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -10, 18, 0, 0, -0.25, -0.35 }, Waist = { -10, 20, 0 }, Neck = { 8, -12, 0 }, RS = { 48, 0, 42 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
			trail = "leftHand", text = "#BAGARRE !", hitText = "#OUILLE !",
		},
		-- Filtre chien (piège) : elle pose un filtre au sol ; qui marche dessus a des oreilles de chien (portée réduite 3 s)
		S_down = {
			label = "Filtre chien", energyCost = 25, kind = "trap", startup = 0.18, active = 0, recovery = 0.3,
			damage = 4, kbBase = 10, kbGrowth = 10, kbAngle = 60,
			status = { name = "dog", duration = 3 },
			trap = { size = Vector3.new(3, 2, 6), offset = 3, lifetime = 10, max = 2, color = ROSE,
				visual = { shape = "disc", size = 2.4, color = ROSE, neon = true, transparency = 0.2, text = "🐶", trail = false } },
			windup = { Root = { -4, -10, 0, 0, -0.5, 0.1 }, Waist = { -14, -8, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 6, 0, 0, -0.8, -0.1 }, Waist = { -24, 6, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 10, 0, 0 } },
			follow = { Root = { -12, 8, 0, 0, -0.8, -0.12 }, Waist = { -24, 8, 0 }, Neck = { 6, -10, 0 }, RS = { 28, 0, 32 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -10 }, LE = { 130, 0, 0 } },
			fx = { { "symbols", symbols = { "🐶", "✨" }, count = 4, radius = 2, at = "front" } }, text = "FILTRE CHIEN !", hitText = "OUAF !",
		},
		-- Drone caméra (remontée, gratuite) : elle attrape son drone de vlog qui la tire en diagonale vers le haut
		S_up = {
			label = "Drone caméra", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 6, hitbox = box(5, 5, 1.5, 2.5), kbBase = 28, kbGrowth = 40, kbAngle = 70, selfVelocity = Vector2.new(38, 84),
			windup = { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, 15 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -60, 0, 0 }, LH = { -10, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 168, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -70 }, LE = { 20, 0, 0 }, RH = { 30, 0, 0 }, RK = { -90, 0, 0 }, LH = { 5, 0, 0 }, LK = { -40, 0, 0 } },
			prop = "drone", hideProp = "perche", trail = "body", text = "DRONE !", hitText = "VZZZ !",
		},
		-- Pluie de cœurs (plongeon, ↓S en l'air) : elle pique vers le sol perche en avant dans une cascade de cœurs (+likes)
		S_air_down = {
			label = "Pluie de cœurs", energyCost = 25, startup = 0.14, active = 0.35, recovery = 0.3,
			damage = 10, hitbox = box(5, 4, 0.5, -2.5), kbBase = 25, kbGrowth = 50, kbAngle = -60, selfVelocity = Vector2.new(8, -80),
			selfEffect = { meter = 100 },
			windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -30, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -40 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -34, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 25, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 165, 0, -45 }, LE = { 20, 0, 0 }, RH = { -12, 0, 0 }, RK = { -40, 0, 0 }, LH = { 8, 0, 0 }, LK = { -58, 0, 0 } },
			trail = "prop", fx = { { "rain", shape = "ball", color = ROSE_VIF, count = 10, radius = 5, size = 0.6 }, { "symbols", symbols = { "❤️", "💖" }, count = 6, radius = 4 } },
			text = "LOVE !", hitText = "+100 ❤️",
		},
		-- Bloquer l'utilisateur (esquive puis S) : ring light brandie en bouclier et poussée d'un coup sec dans la figure ;
		-- le prochain coup reçu est bloqué et elle riposte
		S_dodge = {
			label = "Bloquer l'utilisateur", energyCost = 20, kind = "counter", startup = 0.04, active = 0.45, recovery = 0.3,
			damage = 7, hitbox = box(5.5, 4.5, 3, 0.8),
			counter = { window = 0.45, text = "BLOQUÉ !", riposte = { damage = 11, kbBase = 38, kbGrowth = 70, kbAngle = 35, hitText = "UTILISATEUR BLOQUÉ !" } },
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.15 }, Waist = { 6, 0, 0 }, Neck = { 6, 20, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { -70, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.35 }, Waist = { -8, 0, 0 }, Neck = { 6, 30, 0 }, RS = { 96, 0, -6 }, RE = { 0, 0, 0 }, RW = { -75, 0, 0 }, LS = { 10, 0, -45 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, -0.35 }, Waist = { -8, 0, 0 }, Neck = { 8, 32, 0 }, RS = { 97, 0, -6 }, RE = { 0, 0, 0 }, RW = { -76, 0, 0 }, LS = { 10, 0, -46 }, LE = { 112, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			prop = "ringlight", hideProp = "perche", trail = "prop", fx = { { "ring", color = FLASH, radius = 3, at = "front" } }, text = "BLOQUÉE !", hitText = "UTILISATEUR BLOQUÉ !",
		},
		-- Live (S maintenu) : elle lance le direct en plantant la perche dans le nez d'en face (« dis bonjour aux abonnés ! »),
		-- puis salue ses abonnés, perche levée ; les likes pleuvent (+300 likes)
		S_hold = {
			label = "Live", energyCost = 30, startup = 0.22, active = 0.12, recovery = 0.45,
			damage = 9, hitbox = box(6, 4.5, 3.5, 1), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			selfEffect = { meter = 300 },
			windup = { Root = { 4, -14, 4, 0, -0.15, 0.1 }, Waist = { 4, -14, 6 }, Neck = { 10, 10, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, -0.3, -0.4 }, Waist = { -10, 12, 0 }, Neck = { 0, -8, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -35 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { 4, 10, 6, 0, -0.1, 0 }, Waist = { 6, 8, 8 }, Neck = { 20, -6, 6 }, RS = { 145, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -10 }, LE = { 40, 0, 0 } },
			hold = 0.45, trail = "prop", fx = { { "symbols", symbols = { "❤️", "👍", "💬" }, count = 8, radius = 4 }, { "text", text = "🔴 LIVE", color = Color3.fromRGB(255, 60, 60), at = "above" } },
			text = "COUCOU LES LOLAS !", hitText = "DIS BONJOUR !",
		},
		-- Swipe (→→S) : grand geste de swipe de la main gauche et elle file de côté en un éclair
		S_dash = {
			label = "Swipe", energyCost = 25, startup = 0.05, active = 0.22, recovery = 0.3,
			damage = 9, hitbox = box(4.5, 3.5, 2, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 25, selfVelocity = Vector2.new(80, 0), invuln = 0.2,
			windup = { Root = { -6, -20, 0, 0, -0.25, 0.1 }, Waist = { -4, -20, 0 }, RS = { 40, 0, 30 }, RE = { 80, 0, 0 }, LS = { 80, 0, 60 }, LE = { 30, 0, 0 } },
			strike = { Root = { -18, 10, 0, 0, -0.35, -0.2 }, Waist = { -8, 16, 0 }, Neck = { 10, -10, 0 }, RS = { -20, 0, 40 }, RE = { 40, 0, 0 }, LS = { 90, 0, -80 }, LE = { 5, 0, 0 } },
			follow = { Root = { -20, 12, 0, 0, -0.35, -0.25 }, Waist = { -8, 18, 0 }, Neck = { 12, -12, 0 }, RS = { -25, 0, 42 }, RE = { 40, 0, 0 }, LS = { 85, 0, -95 }, LE = { 5, 0, 0 } },
			trail = "body", fx = { "dust" }, text = "SWIPE !", hitText = "SKIP !",
		},
		-- Cœurs en rafale (S en l'air) : elle envoie trois cœurs à tête chercheuse vers le bas, devant elle
		S_air = {
			label = "Cœurs en rafale", energyCost = 22, kind = "projectile", startup = 0.14, active = 0, recovery = 0.3,
			damage = 4, kbBase = 16, kbGrowth = 30, kbAngle = 35,
			projectile = { speed = 50, gravity = 0, lifetime = 0.65, size = 1.3, color = ROSE_VIF, homing = 0.25, fan = { count = 3, from = -40, to = -10 },
				visual = { shape = "ball", size = 1.0, color = ROSE_VIF, neon = true, text = "❤" } },
			windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, 20 }, LE = { 130, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -14, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 5, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -16, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 72, 0, 42 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -12 }, LE = { 5, 0, 0 }, RH = { 48, 0, 0 }, RK = { -78, 0, 0 }, LH = { 18, 0, 0 }, LK = { -58, 0, 0 } },
			trail = "leftHand", text = "BISOUS !", hitText = "❤️",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Pose finale : grand balayage de perche, puis flash de la photo de fin
		S_finish_pose = {
			label = "Pose finale", energyCost = 20, startup = 0.15, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(7, 4, 3.5, 0.8), kbBase = 32, kbGrowth = 65, kbAngle = 35,
			windup = { Root = { 6, -30, 0, 0, -0.2, 0.25 }, Waist = { 6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 115, 0, 0 } },
			strike = { Root = { -8, 22, 0, 0, -0.3, -0.35 }, Waist = { -10, 28, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, -20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 118, 0, 0 } },
			follow = { Root = { 6, 26, 6, 0, -0.25, -0.38 }, Waist = { 6, 30, 8 }, Neck = { 10, -16, 6 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -45 }, LE = { 118, 0, 0 } },
			hold = 0.12, trail = "prop", fx = { { "burst", color = FLASH, size = 4, at = "front" } }, text = "ET… CLIC !", hitText = "PHOTO FINALE !",
		},
		-- Ring light tournante : elle sort la ring light et tourne deux fois sur elle-même, cercle de lumière à bout de bras
		S_finish_ring = {
			label = "Ring light tournante", energyCost = 25, startup = 0.1, active = 0.3, recovery = 0.3,
			damage = 11, hitbox = box(8, 4, 0, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 45,
			windup = { Root = { 0, -30, 0, 0, -0.3, 0 }, Waist = { 0, -20, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -0.1, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.1, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, prop = "ringlight", hideProp = "perche", trail = "prop", text = "LUMIÈRE !", hitText = "BZZZT !",
		},

		------------------------------------------------------------------ Supers
		-- Virale ! : elle publie la vidéo, une avalanche de notifications tombe du ciel et elle devient virale
		SUPER = {
			label = "Virale !", kind = "projectile", superCost = 100, startup = 0.35, active = 0, recovery = 0.5,
			damage = 3, kbBase = 18, kbGrowth = 20, kbAngle = 50,
			selfEffect = { buff = { "viral", 4 } },
			projectile = { speed = 55, gravity = 30, lifetime = 1.2, size = 1.8, color = ROSE_VIF, rain = { count = 6, spread = 7, ahead = 9, height = 22 },
				visual = { shape = "block", size = 1.5, color = BLANC, text = "🔔", parts = { { "ball", Vector3.new(0.6, 0.6, 0.6), Vector3.new(0.8, 0.8, 0), ROSE_VIF } } } },
			windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 90, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 6, 10, 4, 0, 0.1, 0 }, Waist = { 12, 10, 6 }, Neck = { 26, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 20, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 6, 14, 6, 0, 0.1, 0 }, Waist = { 14, 12, 8 }, Neck = { 30, 0, 6 }, RS = { 172, 0, 32 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -55 }, LE = { 20, 0, 0 } },
			hold = 0.3, windupFx = { "super", { "text", text = "PUBLIER…", color = BLEU } },
			fx = { { "symbols", symbols = { "🔔", "❤️", "💬", "📈" }, count = 10, radius = 6 }, { "screen", color = ROSE, alpha = 0.25 } },
			text = "JE SUIS VIRALE !", hitText = "DING DING DING !",
		},
		-- Super ↑ : accroupie, elle sort la ring light, se dresse sur les pointes et la brandit au-dessus de sa tête en
		-- tournant sur elle-même : une auréole de lumière qui aspire tout vers le ciel (et aveugle)
		SUPER_up = {
			label = "Auréole de ring light !", superCost = 100, startup = 0.32, active = 0.3, recovery = 0.55,
			damage = 22, hitbox = box(7, 12, 1.5, 5), kbBase = 46, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			status = { name = "blinded", duration = 1.5 },
			windup = { Root = { -8, 0, 0, 0, -0.7, 0.05 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 40, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.35, 0 }, Waist = { 8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 182, 0, 6 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 182, 0, -6 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.4, 0 }, Waist = { 10, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 185, 0, 8 }, RE = { 0, 0, 0 }, RW = { 90, 0, 0 }, LS = { 185, 0, -8 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			hold = 0.35, spin = { axis = "y", degrees = 360 }, selfVelocity = Vector2.new(0, 40), prop = "ringlight", hideProp = "perche", trail = "prop",
			windupFx = { "super", { "text", text = "LUMIÈRE…", color = FLASH, at = "above" } },
			fx = { { "pillar", color = FLASH, height = 24, width = 5, at = "root" }, { "screen", color = FLASH, alpha = 0.45 }, { "burst", color = ROSE_VIF, size = 5, at = "above" }, { "symbols", symbols = { "✨", "📸", "😇" }, count = 8, radius = 4 } },
			text = "AURÉOLE !", hitText = "SAINTE LOLA !",
		},
		-- Collab ! : elle lance un appel en live et un perso du roster débarque pour un coup (3 invités possibles)
		SUPER_down = {
			label = "Collab !", superCost = 100, startup = 0.45, active = 0.2, recovery = 0.55,
			damage = 20, hitbox = box(12, 8, 6, 1), kbBase = 35, kbGrowth = 70, kbAngle = 45,
			variants = {
				{ label = "Collab avec Gégé !", status = { name = "inverted", duration = 3 }, hitText = "SODA DOUTEUX !" },
				{ label = "Collab avec Mamie !", status = { name = "rooted", duration = 2 }, hitText = "LIGOTÉ PAR MAMIE !" },
				{ label = "Collab avec Chef Flambé !", burn = true, hitText = "FLAMBÉ !" },
			},
			windup = { Root = { 2, 10, 0, 0, -0.15, 0 }, Waist = { 4, 10, 0 }, Neck = { 10, -10, 0 }, RS = { 140, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 40 }, LE = { 130, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -6, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 150, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -10 }, LE = { 0, 0, 0 } },
			follow = { Root = { -6, -12, 0, 0, -0.2, -0.22 }, Waist = { -6, -12, 0 }, Neck = { 0, 12, 0 }, RS = { 152, 0, 22 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -12 }, LE = { 0, 0, 0 } },
			hold = 0.4, windupFx = { "super", { "text", text = "📞 APPEL EN LIVE…", color = BLEU, at = "above" } },
			fx = { { "pillar", color = BLEU, height = 14, width = 3, at = "front" }, { "burst", color = FLASH, size = 5, at = "front" }, { "symbols", symbols = { "🤝", "✨", "📸" }, count = 8, radius = 5 } },
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
